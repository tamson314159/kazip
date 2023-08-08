defmodule KazipWeb.ArticleLiveTest do
  use KazipWeb.ConnCase

  import Phoenix.LiveViewTest
  import Kazip.ArticlesFixtures

  # @create_attrs %{body: "some body", submit_date: "2023-08-06", title: "some title"}
  @create_attrs %{body: "some body", title: "some title"}
  # @update_attrs %{body: "some updated body", submit_date: "2023-08-07", title: "some updated title"}
  @update_attrs %{body: "some updated body", title: "some updated title"}
  # @invalid_attrs %{body: nil, submit_date: nil, title: nil}
  @invalid_attrs %{body: nil, title: nil}

  defp create_article(_) do
    article = article_fixture()
    %{article: article}
  end

  describe "Index" do
    setup [:create_article]

    test "lists all articles", %{conn: conn, article: article} do
      {:ok, _index_live, html} = live(conn, ~p"/")

      assert html =~ "Listing Articles"
      assert html =~ article.body
    end

    test "saves new article", %{conn: conn} do
      {:ok, index_live, _html} = live(conn, ~p"/")

      assert index_live |> element("a", "New Article") |> render_click() =~
               "New Article"

      assert_patch(index_live, ~p"/articles/new")

      assert index_live
             |> form("#article-form", article: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert index_live
             |> form("#article-form", article: @create_attrs)
             |> render_submit()

      assert_patch(index_live, ~p"/")

      html = render(index_live)
      assert html =~ "Article created successfully"
      assert html =~ "some body"
    end

    @tag :skip
    test "updates article in listing", %{conn: conn, article: article} do
      {:ok, index_live, _html} = live(conn, ~p"/")

      assert index_live |> element("#articles-#{article.id} a", "Edit") |> render_click() =~
               "Edit Article"

      assert_patch(index_live, ~p"/articles/#{article}/edit")

      assert index_live
             |> form("#article-form", article: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert index_live
             |> form("#article-form", article: @update_attrs)
             |> render_submit()

      assert_patch(index_live, ~p"/")

      html = render(index_live)
      assert html =~ "Article updated successfully"
      assert html =~ "some updated body"
    end

    test "deletes article in listing", %{conn: conn, article: article} do
      {:ok, index_live, _html} = live(conn, ~p"/")

      assert index_live |> element("#articles-#{article.id} a", "Delete") |> render_click()
      refute has_element?(index_live, "#articles-#{article.id}")
    end
  end

  describe "Show" do
    setup [:create_article]

    test "displays article", %{conn: conn, article: article} do
      {:ok, _show_live, html} = live(conn, ~p"/articles/#{article}")

      assert html =~ "Show Article"
      assert html =~ article.body
    end

    @tag :skip
    test "updates article within modal", %{conn: conn, article: article} do
      {:ok, show_live, _html} = live(conn, ~p"/articles/#{article}")

      assert show_live |> element("a", "Edit") |> render_click() =~
               "Edit Article"

      assert_patch(show_live, ~p"/articles/#{article}/show/edit")

      assert show_live
             |> form("#article-form", article: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert show_live
             |> form("#article-form", article: @update_attrs)
             |> render_submit()

      assert_patch(show_live, ~p"/articles/#{article}")

      html = render(show_live)
      assert html =~ "Article updated successfully"
      assert html =~ "some updated body"
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
      assert KazipWeb.ArticleLive.Index.first_character(@markdown, 30)
        == "目標を明確にする 短期的な目標と長期的な目標を設定しましょう"
    end
  end
end
