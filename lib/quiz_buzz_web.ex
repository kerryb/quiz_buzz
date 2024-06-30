# credo:disable-for-this-file Credo.Check.Consistency.MultiAliasImportRequireUse
# credo:disable-for-this-file Credo.Check.Readability.AliasAs
# credo:disable-for-this-file Credo.Check.Readability.Specs
# credo:disable-for-this-file Credo.Check.Refactor.ModuleDependencies

defmodule QuizBuzzWeb do
  @moduledoc """
  The entrypoint for defining your web interface, such
  as controllers, views, channels and so on.

  This can be used in your application as:

      use QuizBuzzWeb, :controller
      use QuizBuzzWeb, :view

  The definitions below will be executed for every view,
  controller, etc, so keep them short and clean, focused
  on imports, uses and aliases.

  Do NOT define functions inside the quoted expressions
  below. Instead, define any helper function in modules
  and import those modules here.
  """

  def controller do
    quote do
      use Phoenix.Controller, namespace: QuizBuzzWeb

      import Phoenix.LiveView.Controller
      import Plug.Conn
      import QuizBuzzWeb.Gettext

      alias QuizBuzzWeb.Router.Helpers, as: Routes
    end
  end

  def view do
    quote do
      use Phoenix.View,
        root: "lib/quiz_buzz_web/templates",
        namespace: QuizBuzzWeb

      use PhoenixHTMLHelpers

      import Phoenix.Component
      import Phoenix.HTML
      import Phoenix.HTML.Form

      # Import convenience functions from controllers

      # Use all HTML functionality (forms, tags, etc)
      import QuizBuzzWeb.ErrorHelpers
      import QuizBuzzWeb.Gettext

      alias QuizBuzzWeb.Router.Helpers, as: Routes
    end
  end

  def router do
    quote do
      use Phoenix.Router

      import Phoenix.Controller
      import Phoenix.LiveView.Router
      import Plug.Conn
    end
  end

  def channel do
    quote do
      use Phoenix.Channel

      import QuizBuzzWeb.Gettext
    end
  end

  @doc """
  When used, dispatch to the appropriate controller/view/etc.
  """
  defmacro __using__(which) when is_atom(which) do
    apply(__MODULE__, which, [])
  end
end
