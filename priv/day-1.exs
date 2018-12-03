"priv/day-1-input.txt"
|> File.stream!()
|> Stream.map(&String.trim/1)
|> Stream.map(&String.to_integer/1)
|> Enum.to_list()
|> Stream.cycle()
|> Enum.reduce_while({MapSet.new([0]), 0}, fn value, {seen_frequencies, current_frequency} ->
  new_frequency = current_frequency + value

  if new_frequency in seen_frequencies do
    {:halt, new_frequency}
  else
    {:cont, {MapSet.put(seen_frequencies, new_frequency), new_frequency}}
  end
end)
|> IO.inspect()
