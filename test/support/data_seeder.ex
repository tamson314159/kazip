defmodule Kazip.DataSeeder do
  alias Kazip.ArticlesFixtures

  @data_inserted? false
  def setup(:insert_data) when not @data_inserted? do
    ArticlesFixtures.category_fixture()
    @data_inserted? = true
  end

  def setup(_), do: :ok
end
