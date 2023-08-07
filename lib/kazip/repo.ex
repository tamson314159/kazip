defmodule Kazip.Repo do
  use Ecto.Repo,
    otp_app: :kazip,
    adapter: Ecto.Adapters.Postgres
end
