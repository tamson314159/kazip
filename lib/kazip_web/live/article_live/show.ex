defmodule KazipWeb.ArticleLive.Show do
  use KazipWeb, :live_view

  alias Kazip.Articles

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl true
  def handle_params(%{"id" => id}, _, socket) do
    article = Articles.get_article!(id)

    socket =
      unless article.status == 0 do
        socket
        |> assign(:page_title, article.title)
        |> assign(:article, article)
      else
        redirect(socket, to: ~p"/")
      end

    {:noreply, socket}
  end

  def parse_markdown(markdown) do
    Earmark.as_html!(markdown)
  end
end
