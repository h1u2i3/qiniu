defmodule Qiniu.Resource do
  @moduledoc """
  Module to managing resource

  See http://developer.qiniu.com/docs/v6/api/reference/rs/
  """

  @doc """
  Get the metadata of the resource

  ## Fields

    * `entry_uri` - uri of your resource entry, "bucket:key"
  """
  def stat(module, entry_uri) do
    auth_post(module, op_url(module, :stat, entry_uri))
  end

  @doc """
  Copy one entry to another dest key

  ## Fields

    * `source_uri` - uri of your source entry, "bucket:key"
    * `dest_uri` - uri of your dest entry, "bucket:key"
  """
  def copy(module, source_uri, dest_uri) do
    auth_post(module, op_url(module, :copy, source_uri, dest_uri))
  end

  @doc """
  Move an entry to another dest

  ## Fields

    * `source_uri` - uri of your source entry, "bucket:key"
    * `dest_uri` - uri of your dest entry, "bucket:key"
  """
  def move(module, source_uri, dest_uri) do
    auth_post(module, op_url(module, :move, source_uri, dest_uri))
  end

  @doc """
  Delete an entry

  ## Fields

    * `uri` - uri of your entry to delete, "bucket:key"
  """
  def delete(module \\ Qiniu, uri) do
    auth_post(module, op_url(module, :delete, uri))
  end

  @doc """
  Batch operations for mix of `stat`, `copy`, `move` and `delete`

  ## Fields

    * `ops` - Array of all operations like `[[:stat, "b:k"], [:copy, "b:k", "b1:k1"]]`
  """
  def batch(module \\ Qiniu, ops) do
    params = Enum.map_join(ops, "&", &("op=" <> apply(__MODULE__, :op_path, &1)))
    url = module.config()[:rs_host] <> "?" <> params
    auth_post(module, url)
  end

  @doc """
  List resources in one bucket

  ## Fields

    * `bucket` - the bucket to list

  ## Options

    * `:limit` - Number to list(1~1000), default is 1000
    * `:prefix` - Prefix of resources to list, default is `""`
    * `:delimiter` - Directory separator to list common prefix, default is `""`
    * `:marker` - Marker of last request, which can act as starting point of
      this request, default is `""`
  """
  def list(module \\ Qiniu, bucket, opts \\ []) do
    opts = Keyword.put(opts, :bucket, bucket)
    params = Enum.map_join(opts, "&", fn {k, v} -> "#{k}=#{v}" end)

    url = Path.join([module.config()[:rsf_host], "list?#{params}"])
    auth_post(module, url)
  end

  @doc """
  Fetch resource from a url, and store it in your own bucket

  ## Fields

    * `url` - URL of the external resource
    * `entry_uri` - URI of your entry, "bucket:key"
  """
  def fetch(module \\ Qiniu, url, entry_uri) do
    encoded_url = Base.url_encode64(url)
    encoded_dest = Base.url_encode64(entry_uri)
    url = Path.join([module.config()[:io_host], "fetch", encoded_url, "to", encoded_dest])
    auth_post(module, url)
  end

  @doc """
  For the bucket which sets image storing, fetch resource from image source
  and store to this bucket. If the entry exists in this bucket, override
  the entry with the resource of image storing.

  ## Fields

    * `uri` - URI of destiny entry, "bucket:key"
  """
  def prefetch(module \\ Qiniu, uri) do
    url = Path.join([module.config()[:io_host], "prefetch", Base.url_encode64(uri)])
    auth_post(module, url)
  end

  @doc """
  Change type(MIME type) of the entry

  ## Fields

    * `uri` - URI of the entry, "bucket:key"
    * `mime` - MIME type to change
  """
  def chgm(module \\ Qiniu, entry_uri, mime) do
    encoded_uri = Base.url_encode64(entry_uri)
    encoded_mime = Base.url_encode64(mime)
    url = Path.join([module.config()[:rs_host], "chgm", encoded_uri, "mime", encoded_mime])
    auth_post(module, url)
  end

  @doc false
  defp auth_post(module, url, body \\ "") do
    Qiniu.HTTP.auth_post(module, url, body)
  end

  defp op_url(module, op, source_uri, dest_uri \\ nil) do
    module.config()[:rs_host] <> op_path(op, source_uri, dest_uri)
  end

  @doc false
  def op_path(op, source_uri, dest_uri \\ nil) do
    encoded_source = Base.url_encode64(source_uri)
    encoded_dest = if dest_uri, do: Base.url_encode64(dest_uri)

    parts =
      case op do
        :stat -> ["stat", encoded_source]
        :delete -> ["delete", encoded_source]
        :move -> ["move", encoded_source, encoded_dest]
        :copy -> ["copy", encoded_source, encoded_dest]
      end

    "/" <> Path.join(parts)
  end
end
