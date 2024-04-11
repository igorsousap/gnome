defmodule Type do
  @type state :: :initializing | :won | :bad_guess | :good_guess | :lost | :alredy_used

  @type tally :: %{
          turns_left: integer,
          game_state: state,
          letters: list(String.t()),
          used: list(String.t())
        }
end
