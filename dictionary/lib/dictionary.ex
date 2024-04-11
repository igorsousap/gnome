defmodule Dictionary do
  alias Dictionary.Runtime.Server
  @opaque t :: WordList.t()

  defdelegate random_word(), to: Server
end
