defmodule QuizBuzzWeb.QuizLive do
  use QuizBuzzWeb, :live_view

  def mount(_params, _session, socket) do
    {:ok, assign(socket, name: nil, edit_name?: false)}
  end

  def handle_event("load-name", %{"name" => name}, socket) do
    {:noreply, assign(socket, name: name)}
  end

  def handle_event("edit-name", _params, socket) do
    {:noreply, assign(socket, edit_name?: true)}
  end

  def handle_event("cancel-edit-name", _params, socket) do
    {:noreply, assign(socket, edit_name?: false)}
  end

  def handle_event("save-name", %{"name" => name}, socket) do
    {:noreply,
     socket |> assign(name: name, edit_name?: false) |> push_event("save-name", %{name: name})}
  end
end
