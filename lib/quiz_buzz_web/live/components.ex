defmodule QuizBuzzWeb.Components do
  @moduledoc """
  Stateless function components.
  """

  use Phoenix.Component

  @spec setup(assigns :: Phoenix.LiveView.Socket.assigns()) :: Phoenix.LiveView.Rendered.t()
  def setup assigns do
    ~H"""
    <h2>Individual players</h2>
    <ul class="qb-players">
    <%= for %{team: team} = player when is_nil(team) <- @quiz.players do %>
    <li class={"qb-player #{if player.name == assigns[:player_name], do: "qb-me"}"}><%= player.name %></li>
    <% end %>
    </ul>

    <h2>Teams</h2>
    <%= for team <- @quiz.teams do %>
    <div>
      <h3 class="qb-team"><%= team.name %>:</h3>
      <ul class="qb-team-players">
      <%= for player <- Enum.filter(@quiz.players, & &1.team == team) do %>
        <li class={"qb-team-player #{if player.name == assigns[:player_name], do: "qb-me"}"}><%= player.name %></li>
      <% end %>
    </ul>
    <%= if assigns[:player_name] do %>
      <p><button phx-click="join-team" phx-value-team={team.name}>Join <%= team.name %></button></p>
    <% end %>
    </div>
    <% end %>
    """
  end

  @spec scoreboard(assigns :: Phoenix.LiveView.Socket.assigns()) :: Phoenix.LiveView.Rendered.t()
  def scoreboard(assigns) do
    ~H"""
    <div class={"qb-scoreboard #{if @quiz.state == :buzzed, do: "qb-buzzed"}"}>
      <%= for %{team: team} = player when is_nil(team) <- @quiz.players do %>
        <div class={"qb-team #{if player.buzzed?, do: "qb-buzzed" }"}>
          <h2><%= player.name %></h2>
        </div>
      <% end %>

      <%= for team <- @quiz.teams do %>
        <div class={"qb-team #{if Enum.any?(@quiz.players, & &1.team == team and &1.buzzed?), do: "qb-buzzed"}"}>
      <h2><%= team.name %> <span class="qb-points"><%= team.points %></span></h2>
          <ul class="qb-team-players">
            <%= for player <- Enum.filter(@quiz.players, & &1.team == team) do %>
              <li class={"qb-team-player #{if player.name == assigns[:player_name], do: "qb-me"} #{if player.buzzed?, do: "qb-buzzed"}"}><%= player.name %></li>
            <% end %>
          </ul>
        </div>
      <% end %>
    </div>
    """
  end
end
