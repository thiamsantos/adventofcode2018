defmodule Checksum do
  def run do
    "priv/day-2-input.txt"
    |> File.stream!()
    |> Stream.map(&String.trim/1)
    |> Stream.map(&String.graphemes/1)
    |> Stream.map(&count_ocurrences/1)
    |> Stream.map(&Map.values/1)
    |> Stream.map(&Enum.uniq/1)
    |> Stream.map(&Enum.reject(&1, fn arg -> arg < 2 end))
    |> Enum.to_list()
    |> List.flatten()
    |> count_ocurrences()
    |> Enum.reject(fn {key, _value} -> key != 2 and key != 3 end)
    |> Map.new()
    |> Map.values()
    |> Enum.reduce(1, &(&1 * &2))
  end

  def count_ocurrences(list) do
    list
    |> Enum.group_by(& &1)
    |> Enum.map(fn {key, items} -> {key, length(items)} end)
    |> Map.new()
  end
end

defmodule CommonLetters do
  def run do
    "priv/day-2-input.txt"
    |> File.stream!()
    |> Stream.map(&String.trim/1)
    |> Stream.map(&String.graphemes/1)
    |> Enum.to_list()
    |> find_common_letters()
  end

  defp find_common_letters([head | tail]) do
    common_letters = Enum.find_value(tail, &check_common(head, &1))

    if not is_nil(common_letters) do
      Enum.join(common_letters)
    else
      find_common_letters(tail)
    end
  end

  defp check_common(left_box_id, right_box_id) do
    letters =
      left_box_id
      |> Enum.zip(right_box_id)
      |> Enum.reduce({[], []}, fn {left_letter, right_letter},
                                  {equal_letters, different_letters} ->
        if left_letter == right_letter do
          {[left_letter | equal_letters], different_letters}
        else
          {equal_letters, [left_letter | different_letters]}
        end
      end)

    case letters do
      {equal, [_]} -> Enum.reverse(equal)
      _ -> nil
    end
  end
end

Checksum.run()
|> IO.inspect()

CommonLetters.run()
|> IO.inspect()
