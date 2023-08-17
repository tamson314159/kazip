defmodule Kazip.ArticlesFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Kazip.Articles` context.
  """

  @doc """
  Generate a article.
  """
  def draft_article_fixture(attrs \\ %{}) do
    {:ok, article} =
      attrs
      |> Enum.into(%{
        body: "draft body",
        title: "draft title",
        status: 0
      })
      |> Kazip.Articles.create_article()

    article
  end

  def public_article_fixture(attrs \\ %{}) do
    {:ok, article} =
      attrs
      |> Enum.into(%{
        body: "public body",
        title: "public title",
        status: 1
      })
      |> Kazip.Articles.create_article()

    article
  end

  def limited_article_fixture(attrs \\ %{}) do
    {:ok, article} =
      attrs
      |> Enum.into(%{
        body: "limited body",
        title: "limited title",
        status: 2
      })
      |> Kazip.Articles.create_article()

    article
  end
end
