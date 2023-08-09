defmodule KazipWeb.ArticleLive.FormComponent do
  use KazipWeb, :live_component

  alias Kazip.Articles

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

      <%!-- ダークモードに対応する前の一時的なコード --%>
      <label class="relative inline-flex items-center cursor-pointer mt-2" phx-target={@myself} phx-click="preview">
        <input type="checkbox" value="" class="sr-only peer" checked={@preview}>
        <div class="w-11 h-6 bg-gray-200 peer-focus:outline-none peer-focus:ring-4 peer-focus:ring-blue-300 rounded-full peer peer-checked:after:translate-x-full peer-checked:after:border-white after:content-[''] after:absolute after:top-[2px] after:left-[2px] after:bg-white after:border-gray-300 after:border after:rounded-full after:h-5 after:w-5 after:transition-all peer-checked:bg-blue-600"></div>
        <span class="ml-3 text-sm font-medium text-gray-900">Preview</span>
      </label>

      <%!-- ダークモード対応版 --%>
      <%!-- <label class="relative inline-flex items-center cursor-pointer mt-2" phx-target={@myself} phx-click="preview">
        <input type="checkbox" value="" class="sr-only peer" checked={@preview}>
        <div class="w-11 h-6 bg-gray-200 peer-focus:outline-none peer-focus:ring-4 peer-focus:ring-blue-300 dark:peer-focus:ring-blue-800 rounded-full peer dark:bg-gray-700 peer-checked:after:translate-x-full peer-checked:after:border-white after:content-[''] after:absolute after:top-[2px] after:left-[2px] after:bg-white after:border-gray-300 after:border after:rounded-full after:h-5 after:w-5 after:transition-all dark:border-gray-600 peer-checked:bg-blue-600"></div>
        <span class="ml-3 text-sm font-medium text-gray-900 dark:text-gray-300">Preview</span>
      </label> --%>

      <div class="article_body" :if={@preview}>
        <%= (@form.params["body"] || @article.body || "") |> parse_markdown() |> raw() %>
      </div>
    </div>
    """
  end

  @impl true
  def update(%{article: article} = assigns, socket) do
    changeset = Articles.change_article(article)

    {:ok,
     socket
     |> assign(assigns)
     |> assign(:preview, false)
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
    IO.puts("\n\n\nxxxxxxxxxx")
    IO.inspect(article_params)
    IO.puts("xxxxxxxxxxxxx\n\n\n")
    save_article(socket, socket.assigns.action, article_params)
  end

  def handle_event("preview", _params, %{assigns: %{preview: preview}} = socket) do
    {:noreply, assign(socket, :preview, !preview)}
  end

  defp save_article(socket, :edit, article_params) do
    case Articles.update_article(socket.assigns.article, article_params) do
      {:ok, article} ->
        notify_parent({:saved, article})

        {:noreply,
         socket
         |> put_flash(:info, "Article updated successfully")
         |> assign(:patch, ~p"/drafts")
         |> push_patch(to: socket.assigns.patch)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign_form(socket, changeset)}
    end
  end

  defp save_article(socket, :new, article_params) do
    current_account_id = socket.assigns.current_account.id
    article_params = Map.merge(article_params, %{"account_id" => current_account_id})

    case Articles.create_article(article_params) do
      {:ok, article} ->
        notify_parent({:saved, article})

        if article_params["status"] == 0 do
          assign(socket, :patch, ~p"/drafts")
        end

        {:noreply,
         socket
         |> put_flash(:info, "Article created successfully")
         |> push_patch(to: socket.assigns.patch)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign_form(socket, changeset)}
    end
  end

  defp assign_form(socket, %Ecto.Changeset{} = changeset) do
    assign(socket, :form, to_form(changeset))
  end

  defp notify_parent(msg), do: send(self(), {__MODULE__, msg})

  def parse_markdown(markdown) do
    Earmark.as_html!(markdown)
  end
end
