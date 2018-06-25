defmodule Randomizer do
  def randomize_string(length, type \\ :all) do
    alphabets = "ABCDEFGHIJKLMNOPQRSTUVWXYZ!@#$%&*_-~"
    numbers = "0123456789"

    lists =
      cond do
        type == :alpha -> alphabets <> String.downcase(alphabets)
        type == :numeric -> numbers
        type == :upcase -> alphabets
        type == :downcase -> String.downcase(alphabets)
        true -> alphabets <> String.downcase(alphabets) <> numbers
      end
      |> String.split("", trim: true)

    do_randomizer(length, lists)
  end

  @doc false
  defp get_range(length) when length > 1, do: 1..length
  defp get_range(length), do: 1

  @doc false
  defp do_randomizer(length, lists) do
    get_range(length)
    |> Enum.reduce([], fn _, acc -> [Enum.random(lists) | acc] end)
    |> Enum.join("")
  end
end

defmodule CodeGenerator do
  def generate(%{:count => count, :group_id => group_id}) when count > 0 and group_id > 0 do
    pc_map = gen_code(group_id, count)
  end

  def generate(%{:custom => name, :group_id => group_id})
      when is_binary(name) and group_id > 0 do
    combine_code_in_map(name, group_id)
  end

  defp gen_code(group_id, n) when is_map(accumulator) and n >= 1 and group_id >= 1 do
    Enum.reduce(1..n, accumulator, fn _, acc ->
      Randomizer.randomize_string(34)
      |> combine_code_in_map(group_id)
      |> Map.merge(acc)
    end)
  end

  defp combine_code_in_map(code, group_id) when is_binary(code) when group_id > 0 do
    %{"#{code}" => %{:group_id => group_id}}
  end
end

defmodule Promo do
  def generate(%{:count => count, :group_id => group_id}) when count > 0 and group_id > 0 do
    CodeGenerator.generate(%{:count => count, :group_id => group_id}) |> store_cp_map
  end

  def generate(%{:custom => name, :group_id => group_id})
      when is_binary(name) and group_id > 0 do
    CodeGenerator.generate(%{:custom => name, :group_id => group_id}) |> store_cp_map
  end

  defp get_file do
    "./data/auto.json"
  end

  defp store_cp_map(map) when is_map(map) do
    filename = get_file()

    data = get_cp_map(filename) |> Map.merge(map) |> Poison.encode!()
    File.write(filename, data, [:write])
  end

  def get_cp_map(filename) do
    {:ok, json} = File.read(filename)
    Poison.decode!(check_json(json))
  end

  defp check_json(json) when json === "", do: "{}"
  defp check_json(json), do: json

  def check_code(code) when is_binary(code) do
    cp_map = get_file() |> get_cp_map()

    if cp_map[code] != nil do
      group_id = cp_map[code]["group_id"]
      IO.puts("Code exist. Game group: #{group_id}")
    else
      IO.puts("Code not exist!")
    end
  end
end
