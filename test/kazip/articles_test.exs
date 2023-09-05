defmodule Kazip.ArticlesTest do
  use Kazip.DataCase

  alias Kazip.Articles

  import Kazip.ArticlesFixtures
  import Kazip.AccountsFixtures

  setup do
    account = account_fixture()
    %{
      account: account,
      draft_article: draft_article_fixture(%{account_id: account.id, category_id: 1}),
      public_article: public_article_fixture(%{account_id: account.id, category_id: 1}),
      limited_article: limited_article_fixture(%{account_id: account.id, category_id: 1})
    }
  end

  describe "articles" do
    alias Kazip.Articles.Article

    @invalid_attrs %{body: nil, submit_date: nil, title: nil, account_id: nil}

    test "list_articles/0 returns all articles", %{draft_article: draft_article, public_article: public_article, limited_article: limited_article} do
      articles = [draft_article, public_article, limited_article]
      assert Articles.list_articles() == articles
    end

    test "list_articles/1 returns draft articles", %{account: account, draft_article: article} do
      assert Articles.list_articles(account.id, :draft) == [article]
    end

    test "list_articles/1 returns public articles", %{public_article: article} do
      assert Articles.list_articles(:public) == [article]
    end

    test "list_articles/1 returns limited articles", %{account: account, limited_article: article} do
      article = article |> Repo.preload(:category)
      assert Articles.list_articles(account.id, :limited) == [article]
    end

    test "get_article!/1 returns the article with given id", %{public_article: article} do
      assert Articles.get_article!(article.id) == article
    end

    test "create_article/1 with valid data creates a article", %{account: account} do
      valid_attrs = %{body: "some body", title: "some title", status: 1, account_id: account.id}

      assert {:ok, %Article{} = article} = Articles.create_article(valid_attrs)
      assert article.body == "some body"
      assert article.submit_date == Date.utc_today()
      assert article.title == "some title"
      assert article.status == 1
      assert article.account_id == account.id
    end

    test "create_article/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Articles.create_article(@invalid_attrs)
    end

    test "update_article/2 with valid data updates the article", %{draft_article: article} do
      update_attrs = %{body: "some updated body", title: "some updated title", status: 1}

      assert {:ok, %Article{} = article} = Articles.update_article(article, update_attrs)
      assert article.body == "some updated body"
      assert article.submit_date == Date.utc_today()
      assert article.title == "some updated title"
      assert article.status == 1
    end

    test "update_article/2 with invalid data returns error changeset", %{public_article: article} do
      assert {:error, %Ecto.Changeset{}} = Articles.update_article(article, @invalid_attrs)
      assert article == Articles.get_article!(article.id)
    end

    test "delete_article/1 deletes the article", %{public_article: article} do
      assert {:ok, %Article{}} = Articles.delete_article(article)
      assert_raise Ecto.NoResultsError, fn -> Articles.get_article!(article.id) end
    end

    test "change_article/1 returns a article changeset", %{public_article: article} do
      assert %Ecto.Changeset{} = Articles.change_article(article)
    end
  end
end
