defmodule Kazip.Articles do
  @moduledoc """
  The Articles context.
  """

  import Ecto.Query, warn: false
  alias Kazip.Repo

  alias Kazip.Articles.Article
  alias Kazip.Articles.Category

  @doc """
  Returns the list of articles.

  ## Examples

      iex> list_articles()
      [%Article{}, ...]

  """
  def list_articles do
    Repo.all(Article)
    |> Repo.preload(:category)
  end

  def list_categories do
    Repo.all(Category)
  end

  def list_articles(:public) do
    query =
      from(a in Article,
        where: a.status == 1,
        preload: [:category],
        order_by: [desc: a.updated_at]
      )

    Repo.all(query)
  end

  def list_articles_by_category(category) do
    query =
      from(a in Article,
        where: a.status == 1,
        where: a.category_id == ^category.id,
        preload: [:category],
        order_by: [desc: a.updated_at]
      )

    Repo.all(query)
  end

  def list_articles(account_id, :draft) do
    query =
      from(a in Article,
        where: a.status == 0,
        where: a.account_id == ^account_id,
        preload: [:category],
        order_by: [desc: a.updated_at]
      )

    Repo.all(query)
  end

  def list_articles(account_id, :limited) do
    query =
      from(a in Article,
        where: a.status == 2,
        where: a.account_id == ^account_id,
        preload: [:category],
        order_by: [desc: a.updated_at]
      )

    Repo.all(query)
  end

  @doc """
  Gets a single article.

  Raises `Ecto.NoResultsError` if the Article does not exist.

  ## Examples

      iex> get_article!(123)
      %Article{}

      iex> get_article!(456)
      ** (Ecto.NoResultsError)

  """
  def get_article!(id), do: Repo.get!(Article, id) |> Repo.preload([:category, :account])

  def get_category!(id), do: Repo.get!(Category, id)

  @doc """
  Creates a article.

  ## Examples

      iex> create_article(%{field: value})
      {:ok, %Article{}}

      iex> create_article(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_article(attrs \\ %{}) do
    %Article{}
    |> Article.changeset(attrs)
    |> Repo.insert()
  end

  def create_category(attrs \\ %{}) do
    %Category{}
    |> Category.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a article.

  ## Examples

      iex> update_article(article, %{field: new_value})
      {:ok, %Article{}}

      iex> update_article(article, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_article(%Article{} = article, attrs) do
    article
    |> Article.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a article.

  ## Examples

      iex> delete_article(article)
      {:ok, %Article{}}

      iex> delete_article(article)
      {:error, %Ecto.Changeset{}}

  """
  def delete_article(%Article{} = article) do
    Repo.delete(article)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking article changes.

  ## Examples

      iex> change_article(article)
      %Ecto.Changeset{data: %Article{}}

  """
  def change_article(%Article{} = article, attrs \\ %{}) do
    Article.changeset(article, attrs)
  end
end
