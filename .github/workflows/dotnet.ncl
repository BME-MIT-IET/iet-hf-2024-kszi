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
let db-setup-steps = [
  {
    name = "Download migrations bundle",
    uses = "actions/download-artifact@v4",
    with = {
      name = "InForm.Migrations.tgz"
    }
  },
  {
    name = "Apply migrations bundle",
    run = fold_multiline
      m%"
      tar xzf InForm.Migrations.tgz
      && ./InForm.Migrations
    "%
  }
]
in
let after_build = fun steps =>
  std.array.flatten
    [
      build-steps,
      db-setup-steps,
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
let build-name = "build" in
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
    "%{build-name}" =
      {
        steps =
          after_build
            [
              {
                name = "Restore dotnet tools",
                run = "dotnet tool restore"
              },
              {
                name = "Generate migration bundle",
                run =
                  fold_multiline
                    m%"
                  cd InForm.Server
                  dotnet ef migrations bundle -o InForm.Migrations
                  && tar czf ../mig.tar.gz InForm.Migrations appsettings.*.json
                "%
              },
              {
                name = "Upload bundle artifact",
                uses = "actions/upload-artifact@v4",
                with = {
                  name = "InForm.Migrations.tgz",
                  path = "mig.tar.gz",
                  compression-level = 0, # already compressed
                  overwrite = true,
                }
              }
            ]
      }
      & runner_env,
    tests =
      {
        needs = [build-name],
        steps = after_build [{ name = "Tests", run = "dotnet test --no-build --verbosity normal" }]
      }
      & runner_env,
    load-tests =
      {
        needs = [build-name],
        services = postgres-test-db,
        steps =
          after_build
            [
              {
                name = "Install system packages",
                run = "apt update && apt install -y python3.11 python3-pip"
              },
              {
                name = "Setup python packages",
                run = "python3.11 -m pip install -r requirements.txt --break-system-packages"
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
                  python3.11 ci-utils/parse-locust.py
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
