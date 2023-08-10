defmodule KazipWeb.ArticleLive.FormComponent do
  use KazipWeb, :live_component

  alias Kazip.Articles
  alias Kazip.Articles.Article

  @impl true
  def render(assigns) do
    ~H"""
    <div>
      <.header>
        <%= @title %>
        <:subtitle>Use this form to manage article records in your database.</:subtitle>
      </.header>

      <.simple_form
        for={@form}
        id="article-form"
        phx-target={@myself}
        phx-change="validate"
        phx-submit="save"
      >
        <.input field={@form[:title]} type="text" label="Title" />
        <.input field={@form[:body]} type="textarea" label="Body" />
        <.input
          field={@form[:status]}
          type="select"
          label="Public Type"
          options={[draft: 0, public: 1, limited: 2]}
        />
        <:actions>
          <.button phx-disable-with="Saving...">Save Article</.button>
        </:actions>
      </.simple_form>
    </div>
    """
  end

  @impl true
  def update(%{article: article} = assigns, socket) do
    changeset = Articles.change_article(article)

    {:ok,
     socket
     |> assign(assigns)
     |> assign_form(changeset)}
  end

  @impl true
  def handle_event("validate", %{"article" => article_params}, socket) do
    changeset =
      socket.assigns.article
      |> Articles.change_article(article_params)
      |> Map.put(:action, :validate)

    {:noreply, assign_form(socket, changeset)}
  end

  def handle_event("save", %{"article" => article_params}, socket) do
    {:noreply, save_article(socket, socket.assigns.action, article_params)}
  end

  defp save_article(socket, :edit, article_params) do
    case Articles.update_article(socket.assigns.article, article_params) do
      {:ok, %Article{status: 0}} ->
        socket
        |> put_flash(:info, "Article saved successfully")
        |> redirect(to: ~p"/drafts")

      {:ok, %Article{status: 1} = article} ->
        notify_parent({:saved, article})

        socket
        |> put_flash(:info, "Article updated successfully")
        |> push_patch(to: socket.assigns.patch)

      {:ok, %Article{status: 2}} ->
        socket
        |> put_flash(:info, "Article updated successfully")
        |> redirect(to: ~p"/limited")

      {:error, %Ecto.Changeset{} = changeset} ->
        assign_form(socket, changeset)
    end
  end

  defp save_article(socket, :new, article_params) do
    current_account_id = socket.assigns.current_account.id
    article_params = Map.merge(article_params, %{"account_id" => current_account_id})

    case Articles.create_article(article_params) do
      {:ok, %Article{status: 0}} ->
        socket
        |> put_flash(:info, "Article saved successfully")
        |> redirect(to: ~p"/drafts")

      {:ok, %Article{status: 1} = article} ->
        # notify_parent({:saved, article})

        socket
        |> put_flash(:info, "Article created successfully")
        |> push_patch(to: socket.assigns.patch)

      {:ok, %Article{status: 2}} ->
        socket
        |> put_flash(:info, "Article created successfully")
        |> redirect(to: ~p"/limited")

      {:error, %Ecto.Changeset{} = changeset} ->
        assign_form(socket, changeset)
    end
  end

  defp assign_form(socket, %Ecto.Changeset{} = changeset) do
    assign(socket, :form, to_form(changeset))
  end

  defp notify_parent(msg), do: send(self(), {__MODULE__, msg})
end
