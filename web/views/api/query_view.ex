defmodule Relytix.Api.QueryView do
  use Relytix.Web, :view

  def render("index.json", %{params: params}) do
    %{series: %{
        "Landing page": [1, 2, 5, 3, 8, 6, 10, 9, 7, 5, 8],
        "Sign up": [3, 2, 1, 2, 4, 2, 1, 0, 2, 1, 0],
        "About": [5, 4, 5, 6, 5, 4, 4, 3, 4, 3, 5]
      },
      columns: ["2015-11-01", "2015-11-02", "2015-11-03", "2015-11-04", "2015-11-05", "2015-11-06", "2015-11-07", "2015-11-08", "2015-11-09", "2015-11-10", "2015-11-11"]
    }
  end
end
