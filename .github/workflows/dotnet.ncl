let runners = ["ubuntu-latest"] in

let dotnet_image = "bitnami/dotnet-sdk:8.0.204" in

let runner_env = {
  runs-on = runners
}
in

let fold_multiline : String -> String = std.string.replace "\n" " " in

let run_step : String -> String -> { _: String } = fun step_name cmd =>
  {
    name = step_name,
    run = fold_multiline cmd
  }
in

let build-steps = [
  { name = "Checkout", uses = "actions/checkout@v4" },
  {
    name = "Setup dotnet",
    uses = "actions/setup-dotnet@v3",
    with = {
      dotnet-version = "8.0.204"
    }
  },
  run_step "Restore" "dotnet restore",
  run_step "Build" "dotnet build --no-restore",
]
in

let db-setup-steps = [
  {
    name = "Download migrations bundle",
    uses = "actions/download-artifact@v4",
    with = {
      name = "InForm.Migrations.tgz"
    }
  },
  run_step "Install system packages" "apt update && apt install -y dnsutils",
  run_step "dig test-db" "dig test-db",
  run_step "Apply migrations bundle" m%"
    tar xzf InForm.Migrations.tgz
    && ./InForm.Migrations
  "%
]
in

let after_build = fun steps =>
  std.array.flatten
    [
      build-steps,
      steps
    ]
in

let test_steps = fun steps =>
  std.array.flatten
    [
      build-steps,
      db-setup-steps,
      steps
    ]
in

let postgres-test-db = {
  test-db = {
    image = "postgres:16",
    env = {
      POSTGRES_PASSWORD = "postgres"
    },
    ports = [ "5432:5432" ],
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

let test_job  = fun tsteps =>
  {
    needs = [build-name],
    steps = test_steps tsteps
  }
  & runner_env
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
    "%{build-name}" =
      {
        steps =
          after_build
            [
              run_step "Restore dotnet tools" "dotnet tool restore",
              run_step
                "Generate migration bundle"
                m%"
                cd InForm.Server
                && dotnet ef migrations bundle -o InForm.Migrations
                && tar czf ../InForm.Migrations.tgz InForm.Migrations appsettings.*.json
              "%,
              {
                name = "Upload bundle artifact",
                uses = "actions/upload-artifact@v4",
                with = {
                  name = "InForm.Migrations.tgz",
                  path = "InForm.Migrations.tgz",
                  compression-level = 0, # already compressed
                  overwrite = true,
                }
              }
            ]
      }
      & runner_env,
    tests = test_job 
      [
        run_step "Tests" "dotnet test --no-build --verbosity normal"
      ],
    load-tests = test_job
      [
        run_step "Install system packages" "apt update && apt install -y python3.11 python3-pip",
        run_step "Setup python packages" "python3.11 -m pip install -r requirements.txt --break-system-packages",
        run_step "Start InForm.Server" "dotnet run -c Release -v m --project InForm.Server &",
        run_step "Do load tests" m%"
          locust --headless
          -f ci-utils/locustfile.py
          -H http://localhost:5218
          -t 2m
          -u 3000
          -r 100
          --logfile obj/locust.log
          --csv api
        "%,
        run_step "Stop server" "pkill -INT dotnet",
        run_step "Parse load test results" m%"
          python3.11 ci-utils/parse-locust.py
          api_stats.csv > load-stats.md
        "%,
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
}
