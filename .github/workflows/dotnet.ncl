let runners = ["ubuntu-latest"] in
let dotnet_image = "bitnami/dotnet-sdk:8.0.204" in
let runner_env = {
  runs-on = runners,
  container = dotnet_image
}
in
let build-steps = [
  { name = "Checkout", uses = "actions/checkout@v4" },
  { name = "Restore", run = "dotnet restore" },
  { name = "Build", run = "dotnet build --no-restore" }
]
in
let fold_multiline = std.string.replace "\n" " " in
let after_build = fun steps =>
  std.array.flatten
    [
      build-steps,
      steps
    ]
in
let postgres-test-db = {
  test-db = {
    image = "postgres:16-alpine",
    env = {
      POSTGRES_PASSWORD = "postgres"
    },
    options =
      fold_multiline
        m%"
      --health-cmd pg_isready
      --health-interval 10s
      --health-timeout 5s
      --health-retries 5
    "%
  }
}
in
{
  name = "InForm CI",
  on = {
    push = { branches = ["main"] },
    pull_request = { branches = ["main"] }
  },
  env = {
    DOTNET_ENVIRONMENT = "CI"
  },
  jobs = {
    build-check =
      { steps = build-steps }
      & runner_env,
    tests =
      {
        needs = ["build-check"],
        steps = after_build [{ name = "Tests", run = "dotnet test --no-build --verbosity normal" }]
      }
      & runner_env,
    load-tests =
      {
        needs = ["build-check"],
        services = postgres-test-db,
        steps =
          after_build
            [
              {
                name = "Install lsb-release system package",
                uses = "awalsh128/cache-apt-pkgs-action@latest",
                with = {
                    packages = "lsb-release",
                    version = "1.0"
                }
              },
              {
                name = "Setup python3.11",
                uses = "actions/setup-python@v5",
                with = {
                  python-version = "3.11",
                  cache = "pip"
                }
              },
              {
                name = "Install locust",
                run = "pip install -r requirements.txt"
              },
              {
                name = "Start server",
                run = "dotnet run -c Release -v m --project InForm.Server &"
              },
              {
                name = "Load tests",
                run =
                  fold_multiline
                    m%"
                  locust --headless
                  -f ci-utils/locustfile.py
                  -H http://localhost:5218
                  -t 2m
                  -u 3000
                  -r 100
                  --logfile obj/locust.log
                  --csv api
                "%
              },
              {
                name = "Stop server",
                run = "pkill -INT dotnet"
              },
              {
                name = "Parse load test results",
                run =
                  fold_multiline
                    m%"
                  python3 ci-utils/parse-locust.py
                  api_stats.csv > load-stats.md
                "%
              },
              {
                name = "Comment statistics to PR",
                uses = "thollander/actions-comment-pull-request@v2",
                "if" =
                  fold_multiline
                    m%"
                  always()
                  && github.ref == 'refs/heads/main'
                  && github.event_name == 'pull_request'
                "%,
                with = {
                  filePath = "load-stats.md",
                  comment_tag = "load-statistics-table"
                }
              },
              {
                name = "Upload locust logs to artifacts",
                uses = "actions/upload-artifact@v4",
                "if" = "failure()",
                with = {
                  name = "locust.log",
                  path = "obj/locust.log",
                  compression-level = 9,
                  overwrite = true,
                }
              }
            ]
      }
      & runner_env
  }
}
