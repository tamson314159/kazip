defmodule Kazip.Repo.Migrations.CreateArticles do
  use Ecto.Migration

  def change do
    create table(:articles) do
      add :title, :string, null: false
      add :body, :text
      add :submit_date, :date

      timestamps()
    end
  end
end
