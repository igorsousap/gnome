defmodule Runtime.RemoteHangman do
  @remote_server :hangman@igor
  def connect() do
    :rpc.call(@remote_server, Hangman, :new_game)
  end
end
