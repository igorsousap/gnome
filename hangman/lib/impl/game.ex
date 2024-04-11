defmodule Impl.Game do
  alias Type

  @type t :: %__MODULE__{
          turns_left: integer,
          game_state: Typen.state(),
          letters: list(String.t()),
          used: list(String.t())
        }
  defstruct(
    turns_left: 7,
    game_state: :initializing,
    letters: [],
    used: MapSet.new()
  )

  def new_game do
    new_game(Dictionary.random_word())
  end

  def new_game(word) do
    %__MODULE__{
      letters: word |> String.codepoints()
    }
  end

  def make_move(%{game_state: state} = game, _guess) when state in [:won, :lost] do
    game
    |> return_with_tally()
  end

  def make_move(game, guess) do
    accept_guess(game, guess, MapSet.member?(game.used, guess))
    |> return_with_tally()
  end

  defp accept_guess(game, _guess, true) do
    %{game | game_state: :alredy_used}
  end

  defp accept_guess(game, guess, false) do
    %{game | used: MapSet.put(game.used, guess)}
    |> score_guess(Enum.member?(game.letters, guess))
  end

  def score_guess(game, _good_guess = true) do
    new_state = maybe_won(MapSet.subset?(MapSet.new(game.letters), game.used))
    %{game | game_state: new_state}
  end

  def score_guess(%{turns_left: 1} = game, _bad_guess) do
    %{game | game_state: :lost, turns_left: 0}
  end

  def score_guess(game, _bad_guess) do
    %{game | game_state: :bad_guess, turns_left: game.turns_left - 1}
  end

  def tally(game) do
    %{
      turns_left: game.turns_left,
      game_state: game.game_state,
      letters: revel_guessed_letters(game),
      used: game.used |> MapSet.to_list() |> Enum.sort()
    }
  end

  defp return_with_tally(game) do
    {game, tally(game)}
  end

  defp revel_guessed_letters(%{game_state: :lost} = game) do
    game.letters
  end

  defp revel_guessed_letters(game) do
    game.letters
    |> Enum.map(fn letter -> MapSet.member?(game.used, letter) |> maybe_reveal(letter) end)
  end

  defp maybe_won(true), do: :won
  defp maybe_won(_), do: :good_guess

  defp maybe_reveal(true, letter), do: letter
  defp maybe_reveal(false, _letter), do: "_"
end
