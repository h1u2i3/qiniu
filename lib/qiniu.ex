defmodule Qiniu do
  @moduledoc """
  Top module of this package. For configuration at this moment.
  """

  @doc """
  Get config data.

  ## Examples

  Config in your config.exs

      config :qiniu, Qiniu,
        access_key: "key",
        secret_key: "secret"

  You can fetch the config if you want as

      Qiniu.config[:access_key]

  """
  use Qiniu.Config, Application.get_env(:qiniu, Qiniu, [])
end
