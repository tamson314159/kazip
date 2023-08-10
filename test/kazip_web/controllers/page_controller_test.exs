defmodule KazipWeb.PageControllerTest do
  use KazipWeb.ConnCase

  test "GET /", %{conn: conn} do
    conn = get(conn, ~p"/")
    IO.inspect(html_response(conn, 200))
    assert html_response(conn, 200) =~ "Listing Articles"
  end
end
