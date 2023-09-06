defmodule KazipWeb.ArticleLive.Show do
  use KazipWeb, :live_view

  alias Kazip.Articles

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl true
  def handle_params(params, _, socket) do
    id = params["id"]
    article = Articles.get_article!(id)

    socket =
      unless article.status == 0 do
        socket
        |> assign(:page_title, article.title)
        |> assign(:article, article)
      else
        redirect(socket, to: ~p"/")
      end

    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :show, _params), do: socket

  defp apply_action(socket, :edit, %{"id" => id}) do
    article = Articles.get_article!(id)
    current_account_id = socket.assigns.current_account.id
    if (current_account_id == article.account_id) do
      socket
        |> assign(:page_title, "編集")
        |> assign(:article, Articles.get_article!(id))
    else
      redirect(socket, to: ~p"/")
    end
  end

  def parse_markdown(markdown) do
    Earmark.as_html!(markdown)
  end
end
