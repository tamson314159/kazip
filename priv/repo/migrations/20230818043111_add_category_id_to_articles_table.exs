defmodule Kazip.Repo.Migrations.AddCategoryIdToArticlesTable do
  use Ecto.Migration

  def change do
    alter table(:articles) do
      add :category_id, references(:categories)
    end
  end
end
