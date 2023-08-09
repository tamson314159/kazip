defmodule KazipWeb.ArticleLive.Drafts do
  use KazipWeb, :live_view

  alias Kazip.Articles
  alias KazipWeb.ArticleLive.Index
  alias Kazip.Articles.Article

  def render(assigns) do
    ~H"""
    <.header>
      Listing Drafts
      <:actions>
        <.link patch={~p"/articles/new"}>
          <.button>New Article</.button>
        </.link>

        <.link patch={~p"/"}>
          <.button>Articles</.button>
        </.link>
      </:actions>
    </.header>

    <.table
      id="articles"
      rows={@streams.articles}
      row_click={fn {_id, article} -> JS.navigate(~p"/articles/#{article}") end}
    >
      <:col :let={{_id, article}} label="Title"><%= article.title %></:col>

      <:col :let={{_id, article}} label="Body"><%= Index.first_character(article.body, 30) %></:col>

      <:action :let={{_id, article}}>
        <div class="sr-only">
          <.link navigate={~p"/articles/#{article}"}>Show</.link>
        </div>
         <.link patch={~p"/articles/#{article}/edit"}>Edit</.link>
      </:action>

      <:action :let={{id, article}}>
        <.link
          phx-click={JS.push("delete", value: %{id: article.id}) |> hide("##{id}")}
          data-confirm="Are you sure?"
        >
          Delete
        </.link>
      </:action>
    </.table>

    <.modal :if={@live_action in [:new, :edit]} id="article-modal" show on_cancel={JS.patch(~p"/drafts")}>
      <.live_component
        module={KazipWeb.ArticleLive.FormComponent}
        id={@article.id || :new}
        title={@page_title}
        action={@live_action}
        article={@article}
        patch={~p"/drafts"}
        current_account={@current_account}
      />
    </.modal>
    """
  end

  def mount(_params, _session, socket) do
    {:ok, stream(socket, :articles, Articles.list_articles(:draft))}
  end

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

  # ページのタイトルをアサインする関数
  defp apply_action(socket, :drafts, _params) do
    socket
    |> assign(:page_title, "Listing Drafts")
    |> assign(:article, nil)
  end

  def handle_info({KazipWeb.ArticleLive.FormComponent, {:saved, article}}, socket) do
    {:noreply, stream_insert(socket, :articles, article)}
  end

  # 下書きを削除できるようにする関数
  def handle_event("delete", %{"id" => id}, socket) do
    article = Articles.get_article!(id)
    {:ok, _} = Articles.delete_article(article)

    {:noreply, stream_delete(socket, :articles, article)}
  end
end
