defmodule SocialOauth.HTTPClient do
  @type method() :: :get | :post | :head | :patch | :delete | :options | :put | String.t()

  @callback request(method(), String.t(), Keyword.t(), String.t() | nil) ::
              {:ok, any()} | {:error, any()}

  def request(method, url, headers \\ [], body \\ nil) do
    config = Application.get_env(:social_oauth, __MODULE__, [])
    mod = Keyword.get(config, :mod, SocialOauth.HTTPClient.Finch)
    mod.request(method, url, headers, body)
  end
end
