defmodule Kazip.Articles.Article do
  use Ecto.Schema
  import Ecto.Changeset

  alias Kazip.Accounts.Account
  alias Kazip.Articles.Category

  schema "articles" do
    field :body, :string
    field :submit_date, :date
    field :title, :string
    field :status, :integer, default: 0
    belongs_to :account, Account
    belongs_to :category, Category

    timestamps()
  end

  @doc false
  def changeset(article, attrs) do
    article
    |> cast(attrs, [:title, :body, :submit_date, :status, :account_id, :category_id])
    |> validate_articles()
  end

  def validate_articles(cs) do
    cs =
      validate_required(cs, :title, message: "タイトルを記入してください。")

    unless get_field(cs, :status, 0) == 0 do
      cs
      |> change(%{submit_date: Date.utc_today()})
      |> validate_required(:body, message: "内容を記入してください。")
      |> validate_required(:submit_date)
    else
      cs
    end
  end
end
