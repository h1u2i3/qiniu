defmodule Qiniu.Config do
  defmacro __using__(options) do
    quote do
      def config do
        Keyword.merge(unquote(default_config()), unquote(options))
      end
    end
  end

  defp default_config do
    [
      user_agent: "QiniuElixir/#{System.version()}",
      content_type: "application/x-www-form-urlencoded",
      up_host: "http://up.qiniu.com",
      rs_host: "http://rs.qiniu.com",
      rsf_host: "http://rsf.qbox.me",
      io_host: "http://iovip.qbox.me",
      api_host: "http://api.qiniu.com"
    ]
  end
end
