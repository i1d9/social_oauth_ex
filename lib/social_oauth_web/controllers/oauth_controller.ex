defmodule SocialOauthWeb.OauthController do
  use SocialOauthWeb, :controller

  alias SocialOauth.Platforms.Twitter.Service

  def twitter_login(conn, _params) do
    redirect_uri = SocialOauthWeb.Endpoint.url() <> "/x/redirect"

    code_verifier = :crypto.strong_rand_bytes(8) |> Base.url_encode64()

    state = :crypto.strong_rand_bytes(6) |> Base.url_encode64()
    url = Service.authorization_url(redirect_uri, code_verifier, state)

    conn
    |> put_session(:x_auth, %{code_verifier: code_verifier, state: state})
    |> redirect(external: url)
  end

  def twitter_redirect(conn, params) do
    redirect_uri = SocialOauthWeb.Endpoint.url() <> "/x/redirect"

    with %{"state" => state, "code" => code} <- params,
         %{state: session_state, code_verifier: code_verifier} <-
           get_session(conn, :x_auth) |> IO.inspect(),
         true <- state === session_state,
         results <- Service.access_token(code, redirect_uri, code_verifier) do
      IO.inspect(results)
      text(conn, "haha")
    end
  end
end
