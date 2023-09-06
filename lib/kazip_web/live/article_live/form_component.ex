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
      </.header>

      <.simple_form
        for={@form}
        id="article-form"
        phx-target={@myself}
        phx-change="validate"
        phx-submit="save"
      >
        <.input field={@form[:title]} type="text" label="タイトル" />
        <.input field={@form[:body]} type="textarea" label="内容" />
        <.input
          field={@form[:status]}
          type="select"
          label="公開・限定"
          options={[下書き: 0, 公開: 1, 限定: 2]}
        />
        <.input
          field={@form[:category_id]}
          type="select"
          label="カテゴリ"
          options={[家事全般: 1, 掃除: 2, 洗濯: 3, 料理: 4, 片付け: 5, 育児: 6, 園芸: 7, 買い物: 8, その他: 9]}
        />
        <:actions>
          <.button phx-disable-with="保存中...">記事を保存</.button>
        </:actions>
      </.simple_form>
      <label class="relative inline-flex items-center cursor-pointer mt-2" phx-target={@myself} phx-click="preview" id="preview">
        <input type="checkbox" value="" class="sr-only peer" checked={@preview}>
        <div class="w-11 h-6 bg-gray-200 peer-focus:outline-none peer-focus:ring-4 peer-focus:ring-blue-300 dark:peer-focus:ring-blue-800 rounded-full peer dark:bg-gray-700 peer-checked:after:translate-x-full peer-checked:after:border-white after:content-[''] after:absolute after:top-[2px] after:left-[2px] after:bg-white after:border-gray-300 after:border after:rounded-full after:h-5 after:w-5 after:transition-all dark:border-gray-600 peer-checked:bg-blue-600"></div>
        <span class="ml-3 text-sm font-medium text-gray-900 dark:text-gray-300">プレビュー</span>
      </label>
      <div :if={@preview} class="article_body">
        <div class="mb-3">
          <h1><%= @form.params["title"] || @article.title || "" %></h1>
        </div>
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
    {:noreply, save_article(socket, socket.assigns.action, article_params)}
  end

  def handle_event("preview", _params, %{assigns: %{preview: preview}} = socket) do
    {:noreply, assign(socket, :preview, !preview)}
  end

  defp save_article(socket, :edit, article_params) do
    case Articles.update_article(socket.assigns.article, article_params) do
      {:ok, %Article{status: 0}} ->
        socket
        |> put_flash(:info, "記事は正常に保存されました。")
        |> redirect(to: ~p"/drafts")

      {:ok, %Article{status: 1} = article} ->
        notify_parent({:saved, article})

        socket
        |> put_flash(:info, "記事は正常に更新されました。")
        |> push_patch(to: socket.assigns.patch)

      {:ok, %Article{status: 2}} ->
        socket
        |> put_flash(:info, "記事は正常に更新されました。")
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
        |> put_flash(:info, "記事は正常に保存されました。")
        |> redirect(to: ~p"/drafts")

      {:ok, %Article{status: 1} = _article} ->
        # notify_parent({:saved, article})

        socket
        |> put_flash(:info, "記事は正常に作成されました。")
        |> push_patch(to: socket.assigns.patch)

      {:ok, %Article{status: 2}} ->
        socket
        |> put_flash(:info, "記事は正常に作成されました。")
        |> redirect(to: ~p"/limited")

      {:error, %Ecto.Changeset{} = changeset} ->
        assign_form(socket, changeset)
    end
  end

  defp assign_form(socket, %Ecto.Changeset{} = changeset) do
    assign(socket, :form, to_form(changeset))
  end

  defp notify_parent(msg), do: send(self(), {__MODULE__, msg})

  def parse_markdown(markdown) do
    Earmark.as_html!(markdown, compact_output: true)
  end
end
