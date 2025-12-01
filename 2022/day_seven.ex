defmodule Playground.AdventOfCode.TwentyTwentyTwo.DaySeven do
  def part_one(input_filename) do
    File.read!(input_filename)
    |> String.split("\n")
    |> process_command(%{})
  end

  def process_command([], current_structure) do
    current_structure
  end

  def process_command(["$", "cd", ".." | tail], current_structure) do
    current_path =
      current_structure["current_path"]
      |> IO.inspect(label: "CURRENT_PATH DOTDOT BEFORE")

    current_path =
      String.split(current_path, "/")
      |> Enum.reverse()

    current_path =
      Enum.slice(current_path, 1..length(current_path))
      |> Enum.reverse()
      |> Enum.join("/")
      |> IO.inspect(label: "CURRENT_PATH DOTDOT")

    current_structure =
      Map.merge(current_structure, %{"current_path" => current_path})

    process_command(tail, current_structure)
  end

  def process_command(["$", "cd", path | tail], current_structure) do
    current_path =
      if is_nil(current_structure["current_path"]) do
        path
      else
        current_structure["current_path"] ++ [path] |> Enum.join("/")
      end
      |> IO.inspect(label: "CURRENT_PATH")

    current_structure =
      Map.merge(current_structure, %{"current_path" => current_path})

    current_structure =
      if Map.has_key?(current_structure, path) do
        current_structure
      else
        Map.merge(current_structure, %{"#{path}" => %{}})
      end

    process_command(tail, current_structure)
  end

  def process_command(["$", "ls" | tail], current_structure) do
    process_command(tail, current_structure)
  end

  def process_command(["dir", pathname | tail], current_structure) do
    current_struct =
      current_structure["current_path"]
      |> String.split("/")
      |> find_current_struct(current_structure)

    current_struct =
      if Map.has_key?(current_struct, pathname) do
        current_struct
      else
        Map.merge(
          current_struct,
          %{
            "#{pathname}" => %{},
            "sub_folders" => [pathname | current_structure["sub_folders"]]
          }
        )
      end

    current_structure = update_structure(current_structure["current_path"], current_struct, current_structure)

    process_command(tail, current_structure)
  end

  def process_command([size, filename | tail], current_structure) do
    IO.inspect(size)
    case Integer.parse(size) do
      {size, _} ->
        current_struct =
          current_structure["current_path"]
          |> String.split("/")
          |> find_current_struct(current_structure)

        new_files = [%{"name" => filename, "size" => size} | current_struct["files"]]
        current_struct = Map.merge(current_struct, %{"files" => new_files})

        current_structure = update_structure(current_structure["current_path"], current_struct, current_structure)

        process_command(tail, current_structure)
      :error ->
        process_command(String.split(size, " ") ++ tail, current_structure)
    end
  end

  def process_command([head | tail], current_structure) do
    process_command([String.split(head, " ") | tail], current_structure)
  end

  def find_current_struct([], current_struct), do: current_struct

  def find_current_struct([head | tail], current_struct) do
    current_struct =
      if Map.has_key?(current_struct, head) do
        current_struct["#{head}"]
      else
        %{}
      end

    find_current_struct(tail, current_struct)
  end

  def update_structure(path, current_struct, current_structure) do
    [root_path | _] = String.split(path, "/")

    Map.merge(current_structure, %{"#{root_path}" => current_struct})
  end
end
