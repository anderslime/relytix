defmodule Relytix.ViewModelServer do
  use GenServer

  # Public API
  def start_link(key) do
    IO.puts "START SERVER"
    GenServer.start_link(__MODULE__, key, name: via_tuple(key))
  end

  defp via_tuple(key) do
    {:via, :gproc, gproc_name(key)}
  end

  def whereis(key) do
    :gproc.where(gproc_name(key))
  end

  def gproc_name(key) do
    {:n, :l, {:view_model, key}}
  end

  def init(key) do
    initial_state =
      Relytix.EventQueries.by_name(key)
      |> do_process_events({0, %{}})
    {:ok, initial_state}
  end

  def get(key) do
    GenServer.call(via_tuple(key), :get)
  end

  def version(key) do
    GenServer.call(via_tuple(key), :version)
  end

  def process_event(key, event) do
    GenServer.cast(via_tuple(key), {:process_event, event})
  end

  def process_events(key, events) do
    GenServer.cast(via_tuple(key), {:process_events, events})
  end

  # GenServer Behaviour
  def handle_call(:get, _from, {_, view_model} = state) do
    {:reply, Relytix.TimeSeries.from_view_model(view_model), state}
  end

  def handle_call(:version, _from, {version, _} = state) do
    {:reply, version, state}
  end

  def handle_cast({:process_events, events}, state) do
    new_state = do_process_events(events, state)
    {:noreply, new_state}
  end

  def handle_cast({:process_event, event}, {highest_version, view_model}) do
    new_state = do_process_event(view_model, highest_version, event)
    {:noreply, new_state}
  end

  # Private API

  def do_process_events(events, state) do
    Enum.reduce(events, state, fn(event, {old_version, old_view_model}) ->
      do_process_event(old_view_model, old_version, event)
    end)
  end
  def do_process_event(view_model, highest_version, %{version: version} = _) when highest_version >= version do
    {highest_version, view_model}
  end
  def do_process_event(view_model, highest_version, event) do
    {_, new_view_model} = increment_minute(view_model, event)
    {highest_version + 1, new_view_model}
  end

  defp increment_minute(state, event) do
    Map.get_and_update(state, minute_key(event.inserted_at), &increment(&1))
  end

  defp increment(nil), do: {nil, 1}
  defp increment(old_value) do
    {old_value, old_value + 1}
  end

  defp minute_key(date) do
    {{date.year, date.month, date.day}, {0, 0, 0}}
  end
end
