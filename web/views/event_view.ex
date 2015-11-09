defmodule Relytix.EventView do
  use Relytix.Web, :view

  def render("index.json", %{events: events}) do
    %{data: render_many(events, Relytix.EventView, "event.json")}
  end

  def render("show.json", %{event: event}) do
    %{data: render_one(event, Relytix.EventView, "event.json")}
  end

  def render("event.json", %{event: event}) do
    %{id: event.id,
      visit_id: event.visit_id,
      name: event.name,
      properties: event.properties,
      time: event.time}
  end
end
