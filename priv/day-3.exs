defmodule FabricClaims do
  def part1 do
    read_file()
    |> Enum.reduce(%{}, fn [claim_id, left, top, width, height], acc ->
      Enum.reduce((left + 1)..(left + width), acc, fn x, acc ->
        Enum.reduce((top + 1)..(top + height), acc, fn y, acc ->
          Map.update(acc, {x, y}, [claim_id], fn claims -> [claim_id | claims] end)
        end)
      end)
    end)
    |> Enum.filter(&match?({{_x, _y}, [_, _ | _]}, &1))
    |> length()
  end

  def part2 do
    {multiple_claims, one_claim} =
      read_file()
      |> Enum.reduce(%{}, fn [claim_id, left, top, width, height], acc ->
        Enum.reduce((left + 1)..(left + width), acc, fn x, acc ->
          Enum.reduce((top + 1)..(top + height), acc, fn y, acc ->
            Map.update(acc, {x, y}, [claim_id], fn claims -> [claim_id | claims] end)
          end)
        end)
      end)
      |> Map.values()
      |> Enum.split_with(&match?([_, _ | _], &1))

    multiple_claims =
      multiple_claims
      |> List.flatten()
      |> MapSet.new()

    one_claim =
      one_claim
      |> List.flatten()
      |> MapSet.new()

    one_claim
    |> MapSet.difference(multiple_claims)
    |> MapSet.to_list()
    |> List.first()
  end

  defp read_file do
    "priv/day-3-input.txt"
    |> File.stream!()
    |> Stream.map(fn claim ->
      claim
      |> String.trim()
      |> String.split(["#", " @ ", ": ", ",", "x"], trim: true)
      |> Enum.map(&String.to_integer/1)
    end)
    |> Enum.to_list()
  end
end

FabricClaims.part1()
|> IO.inspect(label: :part1)

FabricClaims.part2()
|> IO.inspect(label: :part2)
