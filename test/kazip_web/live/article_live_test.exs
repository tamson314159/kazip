defmodule KazipWeb.ArticleLiveTest do
  use KazipWeb.ConnCase

  import Phoenix.LiveViewTest
  import Kazip.ArticlesFixtures
  import Kazip.AccountsFixtures

  alias Kazip.Repo

  @create_attrs %{body: "some body", title: "some title", status: 1}
  @update_attrs %{body: "some updated body", title: "some updated title", status: 1, category_id: 1}
  @invalid_attrs %{body: nil, title: nil, status: 0}

  defp create_article(%{account: account}) do
    #category = category_fixture()
    other_account = account_fixture()
    %{
      draft_article: draft_article_fixture(%{account_id: account.id, category_id: 1}),
      public_article: public_article_fixture(%{account_id: account.id, category_id: 1}),
      limited_article: limited_article_fixture(%{account_id: account.id, category_id: 1}),
      other_draft_article: draft_article_fixture(%{account_id: other_account.id, category_id: 1}),
      other_public_article: public_article_fixture(%{account_id: other_account.id, category_id: 1})
    }
  end

  describe "Index" do
    setup [:register_and_log_in_account, :create_article]

    test "lists public articles", %{conn: conn, public_article: article} do
      {:ok, _index_live, html} = live(conn, ~p"/")

      assert html =~ "記事一覧"
      assert html =~ article.body
    end

    test "lists draft articles", %{conn: conn, draft_article: article} do
      {:ok, _index_live, html} = live(conn, ~p"/drafts")

      assert html =~ "下書き一覧"
      assert html =~ article.body
    end

    test "lists limited articles", %{conn: conn, limited_article: article} do
      {:ok, _index_live, html} = live(conn, ~p"/limited")

      assert html =~ "限定記事一覧"
      assert html =~ article.body
    end

    test "saves new article", %{conn: conn} do
      {:ok, index_live, _html} = live(conn, ~p"/")

      assert index_live |> element("a", "新規作成") |> render_click() =~
               "新規作成"

      assert_patch(index_live, ~p"/articles/new")

      assert index_live
             |> form("#article-form", article: @invalid_attrs)
             |> render_change() =~ "タイトルを記入してください。"

      index_live
      |> form("#article-form", article: %{body: "## section", title: "some title", status: 1, category_id: 1})
      |> render_change()

      assert index_live
             |> element("#preview", "プレビュー")
             |> render_click() =~ "<h2>section</h2>"

      assert index_live
             |> form("#article-form", article: @create_attrs)
             |> render_submit()

      assert_patch(index_live, ~p"/")

      html = render(index_live)
      assert html =~ "記事は正常に作成されました。"
      assert html =~ "some body"
    end

    test "updates article in listing", %{conn: conn, public_article: article} do
      {:ok, index_live, _html} = live(conn, ~p"/")

      assert index_live |> element("#articles-#{article.id} a", "編集") |> render_click() =~
               "編集"

      assert_patch(index_live, ~p"/articles/#{article}/edit")

      assert index_live
             |> form("#article-form", article: @invalid_attrs)
             |> render_change() =~ "を記入してください"

      index_live
      |> form("#article-form", article: %{body: "## section", title: "some title", status: 1, category_id: 1})
      |> render_change()

      assert index_live
             |> element("#preview", "プレビュー")
             |> render_click() =~ "<h2>section</h2>"

      assert index_live
             |> form("#article-form", article: @update_attrs)
             |> render_submit()

      assert_patch(index_live, ~p"/")

      html = render(index_live)
      assert html =~ "記事は正常に更新されました。"
      assert html =~ "some updated body"
    end

    test "updates other article in listing", %{conn: conn, other_public_article: article} do
      {:ok, index_live, _html} = live(conn, ~p"/")
      refute has_element?(index_live, "#articles-#{article.id}", "Edit")

      assert {:error, {:redirect, %{to: "/"}}} = live(conn, ~p"/articles/#{article.id}/edit")
    end

    test "deletes article in listing", %{conn: conn, public_article: article} do
      {:ok, index_live, _html} = live(conn, ~p"/")

      assert index_live |> element("#articles-#{article.id} a", "削除") |> render_click()
      refute has_element?(index_live, "#articles-#{article.id}")
    end

    test "delete other article in listing", %{conn: conn, other_public_article: article} do
      {:ok, index_live, _html} = live(conn, ~p"/")
      refute has_element?(index_live, "#articles-#{article.id}", "Edit")
    end
  end

  describe "Show" do
    setup [:register_and_log_in_account, :create_article]

    test "displays article", %{conn: conn, public_article: article} do
      {:ok, _show_live, html} = live(conn, ~p"/articles/#{article}")

      article = Repo.preload(article, :account)

      assert html =~ article.title
      assert html =~ "投稿者: #{article.account.email}"
      assert html =~ article.body
    end

    test "displays other drafts", %{conn: conn, other_draft_article: article} do
      assert {:error, {:redirect, %{to: "/"}}} = live(conn, ~p"/articles/#{article}")
    end

    test "updates article within modal", %{conn: conn, public_article: article} do
      {:ok, show_live, _html} = live(conn, ~p"/articles/#{article}")

      assert show_live |> element("a", "編集") |> render_click() =~
               article.title

      assert_patch(show_live, ~p"/articles/#{article}/show/edit")

      assert show_live
             |> form("#article-form", article: @invalid_attrs)
             |> render_change() =~ "タイトルを記入してください。"

      assert show_live
             |> form("#article-form", article: @update_attrs)
             |> render_submit()

      assert_patch(show_live, ~p"/articles/#{article}")

      html = render(show_live)
      assert html =~ "記事は正常に更新されました。"
      assert html =~ "some updated body"
    end

    test "updates other article within modal", %{conn: conn, other_public_article: article} do
      {:ok, show_live, _html} = live(conn, ~p"/articles/#{article}")
      refute has_element?(show_live, "a", "Edit")
      assert {:error, {:redirect, %{to: "/"}}} = live(conn, ~p"/articles/#{article.id}/show/edit")
    end
  end

  @markdown """
  ## 目標を明確にする

  * 短期的な目標と長期的な目標を設定しましょう。
  * 目標は、自分の価値観や興味に合ったものである必要があります。
  * 目標は具体的で、測定可能で、達成可能で、関連性があり、期限を定めてください。
  * 目標は、自分にとって重要なものである必要があります。
  * 目標は、自分にとってチャレンジングなものである必要があります。

  ## タスクを分解する

  大きなタスクを分解することで、より管理しやすくなります。また、タスクを分解することで、達成感を得ることができ、モチベーションの維持にもつながります。

  ## 優先順位をつける

  すべてのタスクに同じように時間をかけるのは、効率的ではありません。重要なタスクに優先順位をつけることで、時間の無駄を防ぐことができます。

  ## 休憩をとる

  長時間、集中していると、ミスや疲労が蓄積されます。適度に休憩をとることで、集中力を維持し、効率的に作業を行うことができます。

  ## ツールを活用する

  時間管理を効率的に行うために、ツールを活用することも有効です。タスク管理ツールや時間管理アプリなど、さまざまなツールが無料で提供されています。

  時間管理は、一朝一夕に身につくものではありません。しかし、今回ご紹介したライフハックを参考にすることで、時間管理スキルを向上させることができます。ぜひ、参考にしてみてください。
  """

  describe "first_character/1" do
    test "returns string of length 30" do
      assert KazipWeb.ArticleLive.Index.first_character(@markdown, 30) ==
               "目標を明確にする 短期的な目標と長期的な目標を設定しましょう"
    end
  end
end
