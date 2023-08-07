defmodule KazipWeb.ArticleLive.Show do
  use KazipWeb, :live_view

  alias Kazip.Articles

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl true
  def handle_params(%{"id" => id}, _, socket) do
    {:noreply,
     socket
     |> assign(:page_title, page_title(socket.assigns.live_action))
     |> assign(:article, Articles.get_article!(id))}
  end

  defp page_title(:show), do: "Show Article"
  defp page_title(:edit), do: "Edit Article"

  def parse_markdown(markdown) do
    Earmark.as_html!(markdown)
  end
end
