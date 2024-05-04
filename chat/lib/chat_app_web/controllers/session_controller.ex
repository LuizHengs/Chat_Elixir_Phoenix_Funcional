defmodule ChatAppWeb.SessionController do
  use ChatAppWeb, :controller
  def new(conn, _params) do
    render(conn, "new.html")
  end
  def create(conn, %{"session" => session_params}) do
    user = Repo.get_by(ChatApp.User, email: session_params["email"])
    case Guardian.authenticate(user, session_params["password"]) do
      {:ok, user, _claims} ->
        conn
        |> Guardian.Plug.sign_in(user)
        |> redirect(to: "/")
      {:error, _reason} ->
        conn
        |> put_flash(:error, "Invalid email or password")
        |> redirect(to: "/login")
    end
  end
  def delete(conn, _params) do
    conn
    |> Guardian.Plug.sign_out()
    |> redirect(to: "/")
  end
end
