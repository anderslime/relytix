defmodule Relytix.VisitView do
  use Relytix.Web, :view

  def render("index.json", %{visits: visits}) do
    %{data: render_many(visits, Relytix.VisitView, "visit.json")}
  end

  def render("show.json", %{visit: visit}) do
    %{data: render_one(visit, Relytix.VisitView, "visit.json")}
  end

  def render("visit.json", %{visit: visit}) do
    %{id: visit.id,
      visitor_id: visit.visitor_id,
      ip: visit.ip,
      started_at: visit.started_at}
  end
end
