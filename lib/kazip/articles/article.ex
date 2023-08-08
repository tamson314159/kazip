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
    |> cast(attrs, [:title, :body, :submit_date, :status])
    |> validate_required([:title, :body, :submit_date, :status])
  end
end
