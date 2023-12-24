defmodule Mix.Tasks.Day2 do
  use Mix.Task

  @impl Mix.Task
  def run(_args) do
    AOC23.Day2.run()
  end
end
