defmodule SocialOauth.HTTPClient.Finch do
  @behaviour SocialOauth.HTTPClient

  @impl SocialOauth.HTTPClient
  def request(method, url, headers \\ [], body \\ nil) do
    method
    |> Finch.build(url, headers, body)
    |> Finch.request(SocialOauth.Finch)
  end
end
