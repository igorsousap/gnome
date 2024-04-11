defmodule Hangman do
  alias Dictionary.Runtime.Server
  alias Type

  @opaque game :: Game.t()

  def new_game do
    {:ok, pid} = Hangman.Runtime.Application.start_game()
    pid
  end

  def make_move(game, guess) do
    GenServer.call(game, {:make_move, guess})
  end

  def tally(game) do
    GenServer.call(game, {:tally})
  end
end
