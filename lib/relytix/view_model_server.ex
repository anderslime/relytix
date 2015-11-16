defmodule Relytix.ViewModelServer do
  use GenServer

  def start_link(opts \\ []) do
    GenServer.start_link(__MODULE__, %{}, [name: Dict.fetch!(opts, :name)])
  end

  def init(view_model) do
    {:ok, view_model}
  end

  def get(server) do
    GenServer.call(server, :get)
  end

  def process_event(server, event) do
    GenServer.cast(server, {:process_event, event})
  end

  def handle_call(:get, _from, state) do
    {:reply, state, state}
  end

  def handle_cast({:process_event, event}, state) do
    {_, new_state} = state |> Map.get_and_update(minute_key(event.date), &increment(&1))
    {:noreply, new_state}
  end

  defp increment(nil), do: {nil, 1}
  defp increment(old_value) do
    {old_value, old_value + 1}
  end

  defp minute_key(date) do
    [
      date.year,
      date.month,
      date.day,
      date.hour,
      date.min
    ] |> Enum.join("-")
  end
end
