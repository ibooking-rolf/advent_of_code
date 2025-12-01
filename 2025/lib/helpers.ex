defmodule AdventOfCode.Helpers do
  def read_input(file_path) do
    File.read!(file_path)
    |> String.split("\n", trim: true)
  end
end
