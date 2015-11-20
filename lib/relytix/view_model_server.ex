defmodule Relytix.ViewModelServer do
  use GenServer

  # Public API
  def start_link(opts \\ []) do
    GenServer.start_link(__MODULE__, :ok, opts)
  end

  def init(:ok) do
    {:ok, {0, %{}}}
  end

  def get(server) do
    GenServer.call(server, :get)
  end

  def version(server) do
    GenServer.call(server, :version)
  end

  def process_event(server, event) do
    GenServer.cast(server, {:process_event, event})
  end

  def process_events(server, events) do
    GenServer.cast(server, {:process_events, events})
  end

  # GenServer Behaviour
  def handle_call(:get, _from, {_, view_model} = state) do
    {:reply, view_model, state}
  end

  def handle_call(:version, _from, {version, _} = state) do
    {:reply, version, state}
  end

  def handle_cast({:process_events, events}, state) do
    new_state = Enum.reduce(events, state, fn(event, {old_version, old_view_model}) ->
      do_process_event(old_view_model, old_version, event)
    end)
    {:noreply, new_state}
  end

  def handle_cast({:process_event, event}, {highest_version, view_model}) do
    new_state = do_process_event(view_model, highest_version, event)
    {:noreply, new_state}
  end

  # Private API
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
    {{date.year, date.month, date.day}, {date.hour, date.min, 0}}
  end
end
