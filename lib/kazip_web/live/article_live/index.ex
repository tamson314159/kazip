defmodule KazipWeb.ArticleLive.Index do
  use KazipWeb, :live_view

  alias Kazip.Articles
  alias Kazip.Articles.Article

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  # def handle_event("filter_drafts", _params, socket) do
  #   {:noreply, stream(socket, :articles, Articles.list_articles(:draft))}
  # end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, "Edit Article")
    |> assign(:article, Articles.get_article!(id))
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New Article")
    |> assign(:article, %Article{})
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Listing Articles")
    |> assign(:article, nil)
    |> stream(:articles, Articles.list_articles(:public), reset: true)
    |> assign_form()
  end

  defp apply_action(socket, :drafts, _params) do
    articles = Articles.list_articles(socket.assigns.current_account.id, :draft)

    socket
    |> assign(:page_title, "Listing Drafts")
    |> assign(:article, nil)
    |> stream(:articles, articles)
  end

  defp apply_action(socket, :limited, _params) do
    articles = Articles.list_articles(socket.assigns.current_account.id, :limited)

    socket
    |> assign(:page_title, "Listing Limited Articles")
    |> assign(:article, nil)
    |> stream(:articles, articles)
  end

  defp assign_form(socket) do
    assign(socket, :form, to_form(%{}, as: "search_by_category"))
  end

  @impl true
  def handle_info({KazipWeb.ArticleLive.FormComponent, {:saved, article}}, socket) do
    {:noreply, stream_insert(socket, :articles, article)}
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    article = Articles.get_article!(id)
    {:ok, _} = Articles.delete_article(article)

    {:noreply, stream_delete(socket, :articles, article)}
  end

  def handle_event("search_by_category", %{"search_by_category" => %{"category_id" => category_id}}, socket) do
    category = Articles.get_category!(category_id)
    IO.puts("\n\n\nxxxxxxxx\n\n\n")
    articles = Articles.list_articles_by_category(category)

    socket =
      socket
      |> assign(:article, nil)
      |> stream(:articles, articles)
      |> assign_form()

    {:noreply, socket}
  end

  def first_character(markdown, number) do
    markdown
    |> Earmark.as_html!()
    |> Floki.parse_document!()
    |> Floki.text()
    |> String.replace("\n", " ")
    |> String.slice(1..number)
  end
end
