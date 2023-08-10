defmodule Kazip.Repo.Migrations.CreateArticles do
  use Ecto.Migration

  def change do
    create table(:articles) do
      add :title, :string, null: false
      add :body, :text
      add :submit_date, :date
      add :status, :integer, null: false
      add :account_id, references(:accounts, on_delete: :nothing)

      timestamps()
    end

    create index(:articles, [:account_id])
  end
end
