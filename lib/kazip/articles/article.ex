defmodule Kazip.Articles.Article do
  use Ecto.Schema
  import Ecto.Changeset

  alias Kazip.Accounts.Account

  schema "articles" do
    field :body, :string
    field :submit_date, :date
    field :title, :string
    field :status, :integer, default: 0
    belongs_to :account, Account

    timestamps()
  end

  @doc false
  def changeset(article, attrs) do
    article
    |> cast(attrs, [:title, :body, :submit_date, :status, :account_id])
    |> validate_articles()
  end

  def validate_articles(cs) do
    cs =
      validate_required(cs, :title, message: "Please fill in the title.")

    unless get_field(cs, :status, 0) == 0 do
      cs
      |> change(%{submit_date: Date.utc_today()})
      |> validate_required(:body, message: "Please fill the body.")
      |> validate_required(:submit_date)
    else
      cs
    end
  end
end
