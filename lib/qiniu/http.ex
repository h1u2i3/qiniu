defmodule Qiniu.HTTP do
  @moduledoc false

  def post(module, url, body, opts \\ []) do
    request(:post, module, url, body, opts)
  end

  def get(module, url, opts \\ []) do
    request(:get, module, url, opts)
  end

  defp request(method, module, url, opts) do
    request(method, module, url, "", opts)
  end

  defp request(method, module, url, body, opts) do
    headers =
      Keyword.merge(opts[:headers] || [],
        accept: "application/json",
        connection: "close",
        user_agent: module.config()[:user_agent]
      )

    response =
      case method do
        :get -> HTTPoison.get!(url, headers)
        :post -> HTTPoison.post!(url, body, headers)
      end

    if opts[:raw] do
      response
    else
      case Jason.decode(response.body) do
        {:ok, body} -> %{response | body: body}
        _ -> response
      end
    end
  end

  @doc false
  def auth_post(module \\ Qiniu, url, body, headers \\ []) do
    post(module, url, body,
      headers:
        Keyword.merge(
          [
            Authorization: "QBox " <> Qiniu.Auth.access_token(module, url, body),
            "Content-Type": module.config()[:content_type]
          ],
          headers
        )
    )
  end
end
