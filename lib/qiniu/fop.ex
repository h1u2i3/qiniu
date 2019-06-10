defmodule Qiniu.Fop do
  alias Qiniu.HTTP

  @doc """
  Generate QR code for a image

  ## Fields

    * url - URL of the image
    * level - level of the error correction("L", "M", "Q", "H"), "L" is the default
  """
  def qrcode(module \\ Qiniu, url, level \\ "L") do
    HTTP.get(module, url <> "?qrcode/0/level/#{level}")
  end
end
