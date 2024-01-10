defmodule SocialOauth.Platforms.Twitter.Service do
  alias SocialOauth.HTTPClient

  def client_id(config) do
    config
    |> Keyword.get(:client_id)
  end

  def client_secret(config) do
    config
    |> Keyword.get(:client_id)
  end

  def base_url(config) do
    config
    |> Keyword.get(:base_url)
  end

  def consumer_key(config) do
    config
    |> Keyword.get(:consumer_key)
  end

  def consumer_secret(config) do
    config
    |> Keyword.get(:consumer_secret)
  end

  def api_url(config) do
    config
    |> Keyword.get(:api_url)
  end

  def access_token_url(code, redirect_uri, code_verifier) do
    config = config()

    api_url(config)
    |> URI.merge("/2/oauth2/token")
    |> Map.put(
      :query,
      URI.encode_query(%{
        code: code,
        grant_type: "authorization_code",
        client_id: client_id(config),
        redirect_uri: redirect_uri,
        code_verifier: code_verifier
      })
    )
    |> to_string()
  end

  def authorization_url(redirect_uri, code_verifier, state) do
    code_challenge = :crypto.hash(:sha512, code_verifier) |> Base.url_encode64()
    config = config()

    base_url(config)
    |> URI.merge("/i/oauth2/authorize")
    |> Map.put(
      :query,
      URI.encode_query(%{
        response_type: "code",
        client_id: client_id(config),
        redirect_uri: redirect_uri,
        state: state,
        scope: "follows.read",
        code_challenge: code_challenge,
        code_challenge_method: "S256"
      })
    )
    |> to_string()
  end

  def access_token(code, redirect_uri, code_verifier) do
    access_token_url = access_token_url(code, redirect_uri, code_verifier)
    config = config()

    username = consumer_key(config)
    password = consumer_secret(config)

    IO.inspect(Plug.BasicAuth.encode_basic_auth(username, password))

    HTTPClient.request(
      :post,
      access_token_url,
      [
        {"content-type", "application/x-www-form-urlencoded"},
        {"authorization", Plug.BasicAuth.encode_basic_auth(username, password)}
      ],
      Jason.encode!(%{
        code: code,
        grant_type: "authorization_code",
        client_id: client_id(config),
        redirect_uri: redirect_uri,
        code_verifier: code_verifier
      })
    )
  end

  def config() do
    Application.get_env(:social_oauth, __MODULE__)
  end
end
