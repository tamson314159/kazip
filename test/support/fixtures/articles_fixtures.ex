defmodule Kazip.ArticlesFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Kazip.Articles` context.
  """

  @doc """
  Generate a article.
  """
  def article_fixture(attrs \\ %{}) do
    {:ok, article} =
      attrs
      |> Enum.into(%{
        body: "some body",
        submit_date: ~D[2023-08-06],
        title: "some title",
        status: 1
      })
      |> Kazip.Articles.create_article()

    article
  end
end
