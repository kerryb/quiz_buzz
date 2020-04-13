# QuizBuzz

A web-based quiz buzzer app, for remote quizzes on Zoom etc. Consists of four
main layers (working outwards):

* A set of structs, in the `QuizBuzz.Schema` namespace
* A functional core, with a set of functions all operating on a common
  `QuizBuzz.Schema.Quiz` token
* A `QuizBuzz.Registry`, handling persistence of quizzes and the external API
* A Phoenix Live View app, providing the UI

There is no database: quizzes are only persisted as long as the application is
running.

## Phoenix boilerplate

To start your Phoenix server:

  * Install dependencies with `mix deps.get`
  * Install Node.js dependencies with `cd assets && npm install`
  * Start Phoenix endpoint with `mix phx.server`

Now you can visit [`localhost:4000`](http://localhost:4000) from your browser.

Ready to run in production? Please [check our deployment
guides](https://hexdocs.pm/phoenix/deployment.html).

## Learn more

  * Official website: https://www.phoenixframework.org/
  * Guides: https://hexdocs.pm/phoenix/overview.html
  * Docs: https://hexdocs.pm/phoenix
  * Forum: https://elixirforum.com/c/phoenix-forum
  * Source: https://github.com/phoenixframework/phoenix
