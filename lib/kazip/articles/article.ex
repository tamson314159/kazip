defmodule Kazip.Articles.Article do
  use Ecto.Schema
  import Ecto.Changeset

  schema "articles" do
    field :body, :string
    field :submit_date, :date
    field :title, :string

    timestamps()
  end

  @doc false
  def changeset(article, attrs) do
    article
    |> cast(attrs, [:title, :body, :submit_date])
    |> validate_required([:title, :body, :submit_date])
  end
end
