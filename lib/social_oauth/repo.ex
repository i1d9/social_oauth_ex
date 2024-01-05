defmodule SocialOauth.Repo do
  use Ecto.Repo,
    otp_app: :social_oauth,
    adapter: Ecto.Adapters.Postgres
end
