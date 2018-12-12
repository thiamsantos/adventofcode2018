defmodule Day4 do
  def part1 do
    {id, guard_shifts} =
      read_shifts()
      |> Enum.group_by(fn {id, _range} -> id end)
      |> Enum.sort_by(
        fn {_id, shifts} ->
          shifts
          |> Enum.map(fn {_id, range} -> range.last - range.first end)
          |> Enum.sum()
        end,
        &>=/2
      )
      |> List.first()

    {minute, _times} =
      guard_shifts
      |> Enum.flat_map(fn {_id, range} -> Enum.to_list(range) end)
      |> Enum.reduce(%{}, fn x, acc ->
        Map.update(acc, x, 1, &(&1 + 1))
      end)
      |> Enum.sort_by(fn {_minute, times} -> times end, &>=/2)
      |> List.first()

    id * minute
  end

  def part2 do
    {minute, id, _times} = read_shifts()
    |> Enum.group_by(fn {id, _range} -> id end)
    |> Enum.flat_map(fn {id, shifts} ->
      shifts
      |> Enum.flat_map(fn {_id, range} -> Enum.to_list(range) end)
      |> Enum.reduce(%{}, fn x, acc ->
        Map.update(acc, x, 1, &(&1 + 1))
      end)
      |> Enum.map(fn {minute, times} -> {minute, id, times} end)
    end)
    |> Enum.sort_by(fn {_minute, _id, times} -> times end, &>=/2)
    |> List.first()

    id * minute
  end

  defp read_shifts do
    {_, shifts} =
      "priv/day-4-input.txt"
      |> File.stream!()
      |> Stream.map(&String.trim/1)
      |> Stream.map(&Day4.Parser.parse/1)
      |> Stream.map(fn
        {:ok, [year, month, day, hour, minute | rest], _, _, _, _} ->
          {:ok, date} = NaiveDateTime.new(year, month, day, hour, minute, 0)

          {date, rest}
      end)
      |> Enum.sort(fn {date1, _}, {date2, _} -> NaiveDateTime.compare(date1, date2) == :lt end)
      |> Enum.reduce({{nil, nil}, []}, fn
        {_date, [:guard, id, :begins_shift]}, {_current_shift, shifts} ->
          {{id, nil}, shifts}

        {sleep_at, [:falls_asleep]}, {{id, _sleep_at}, shifts} ->
          {{id, sleep_at}, shifts}

        {wakes_at, [:wakes_up]}, {{id, sleep_at}, shifts} ->
          # sleep_time = trunc(NaiveDateTime.diff(wakes_at, sleep_at) / 60)

          {{id, nil}, [{id, sleep_at.minute..wakes_at.minute} | shifts]}
      end)

    shifts
  end

  defmodule Parser do
    import NimbleParsec

    # [1518-11-05 00:55] wakes up
    # [1518-11-01 00:00] Guard #10 begins shift
    # [1518-11-02 00:40] falls asleep

    guard =
      replace(string("Guard #"), :guard)
      |> integer(min: 1)
      |> replace(string(" begins shift"), :begins_shift)

    falls_sleep = replace(string("falls asleep"), :falls_asleep)
    wakes_up = replace(string("wakes up"), :wakes_up)

    defparsec(
      :parse,
      ignore(string("["))
      |> integer(4)
      |> ignore(string("-"))
      |> integer(2)
      |> ignore(string("-"))
      |> integer(2)
      |> ignore(string(" "))
      |> integer(2)
      |> ignore(string(":"))
      |> integer(2)
      |> ignore(string("] "))
      |> concat(choice([guard, falls_sleep, wakes_up]))
    )
  end
end

Day4.part1()
|> IO.inspect(label: :part1)

Day4.part2()
|> IO.inspect(label: :part2)
