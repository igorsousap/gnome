defmodule Impl.Player do
  @type game :: Hangman.game()
  @type tally :: Hangman.tally()
  @typep state :: {game, tally}

  def start(game) do
    tally = Hangman.tally(game)
    interact({game, tally})
  end

  def interact({_game, _tally = %{game_state: :won}}), do: IO.puts("Congratulations. You won")

  def interact({_game, tally = %{game_state: :lost}}),
    do: IO.puts("You lost the word was #{tally.letters |> Enum.join()}")

  def interact({game, tally}) do
    IO.puts(feedback_for(tally))
    IO.puts(current_word(tally))

    tally = Hangman.make_move(game, get_guess())

    interact({game, tally})
  end

  defp feedback_for(%{game_state: :initializing} = tally) do
    "Welcome! I`m thinking of a #{tally.letters |> length} letters words"
  end

  defp feedback_for(%{game_state: :good_guess}), do: "Good Guess"
  defp feedback_for(%{game_state: :bad_guess}), do: "Bad Guess"
  defp feedback_for(%{game_state: :alredy_used}), do: "Alredy Used"

  defp current_word(tally) do
    [
      "Word so far:",
      tally.letters |> Enum.join(" "),
      "    turns left: ",
      tally.turns_left |> Integer.to_string(),
      "    used so far: ",
      tally.used |> Enum.join(",")
    ]
  end

  def get_guess() do
    IO.gets("Next letter: ")
    |> String.trim()
    |> String.downcase()
  end
end
