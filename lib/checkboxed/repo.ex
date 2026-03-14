defmodule Checkboxed.Repo do
  use Ecto.Repo,
    otp_app: :checkboxed,
    adapter: Ecto.Adapters.Postgres
end
