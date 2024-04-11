defmodule TextClient do
  def start do
    Runtime.RemoteHangman.connect()
    |> Impl.Player.start()
  end
end
