defmodule Day5 do
  def part1 do
    read_file()
    |> react_polymer()
    |> String.length()
  end

  defp react_polymer(polymer) when is_binary(polymer) do
    react_polymer(polymer, [])
  end

  defp react_polymer(<<letter, rest::binary>>, [head | acc]) when abs(letter - head) == 32 do
    react_polymer(rest, acc)
  end

  defp react_polymer(<<letter, rest::binary>>, acc) do
    react_polymer(rest, [letter | acc])
  end

  defp react_polymer(<<>>, acc) do
    acc |> Enum.reverse() |> List.to_string()
  end

  def part2 do
    polymer = read_file()

    ?A..?Z
    |> Task.async_stream(fn letter ->
      react_and_ignore(polymer, letter, [])
    end)
    |> Stream.map(fn {:ok, result} -> String.length(result) end)
    |> Enum.min()
  end

  defp react_and_ignore(<<letter, rest::binary>>, ignored_letter, acc)
       when letter == ignored_letter or letter == ignored_letter + 32 do
    react_and_ignore(rest, ignored_letter, acc)
  end

  defp react_and_ignore(<<letter, rest::binary>>, ignored_letter, [head | acc])
       when abs(letter - head) == 32 do
    react_and_ignore(rest, ignored_letter, acc)
  end

  defp react_and_ignore(<<letter, rest::binary>>, ignored_letter, acc) do
    react_and_ignore(rest, ignored_letter, [letter | acc])
  end

  defp react_and_ignore(<<>>, _ignored_letter, acc) do
    acc |> Enum.reverse() |> List.to_string()
  end

  defp read_file do
    "priv/day-5-input.txt"
    |> File.read!()
    |> String.trim()
  end
end

Day5.part1()
|> IO.inspect(label: :part1)

Day5.part2()
|> IO.inspect(label: :part2)
