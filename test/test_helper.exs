ExUnit.start(capture_log: true)

{:ok, _} = Application.ensure_all_started(:wallaby)
Application.put_env(:wallaby, :base_url, QuizBuzzWeb.Endpoint.url())
Application.put_env(:wallaby, :screenshot_on_failure, true)

File.mkdir_p!("log")
{:ok, file} = File.open("log/js.log", [:write])
Application.put_env(:wallaby, :js_logger, file)
