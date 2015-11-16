defmodule Relytix.ViewModelServer do
  use GenServer

  def start_link(opts \\ []) do
    GenServer.start_link(__MODULE__, :ok, [name: Dict.fetch!(opts, :name)])
  end

  def init(:ok) do
    {:ok, {0, %{}}}
  end

  def get(server) do
    GenServer.call(server, :get)
  end

  def process_event(server, event) do
    GenServer.cast(server, {:process_event, event})
  end

  def handle_call(:get, _from, {_, view_model} = state) do
    {:reply, view_model, state}
  end

  def handle_cast({:process_event, event}, {highest_version, view_model}) do
    new_state = do_process_event(view_model, highest_version, event)
    {:noreply, new_state}
  end

  def do_process_event(view_model, highest_version, %{version: version} = _) when highest_version >= version do
    {highest_version, view_model}
  end
  def do_process_event(view_model, highest_version, event) do
    {_, new_view_model} = increment_minute(view_model, event)
    {highest_version + 1, new_view_model}
  end

  defp increment_minute(state, event) do
    Map.get_and_update(state, minute_key(event.date), &increment(&1))
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
