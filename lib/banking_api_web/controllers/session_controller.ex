defmodule BankingApiWeb.SessionController do
  use BankingApiWeb, :controller

  alias BankingApi.{Accounts, Accounts.User, Guardian}

  action_fallback BankingApiWeb.FallbackController

  def create(conn, params) do
    with {:ok, user, account} <- Accounts.create_user(params),
         {:ok, token, _} <- Guardian.encode_and_sign(user) do
      conn
      |> put_status(:ok)
      |> render("sign_up.json", %{session: %{token: token, user: user, account: account}})
    end
  end

  def login(conn, params) do
    with {:ok, %User{} = user} <- Accounts.auth_user(params),
         {:ok, token, _} <- Guardian.encode_and_sign(user) do
      conn
      |> put_status(:ok)
      |> render("login.json", token: token)
    else
      {:error, :invalid_credentials} ->
        conn
        |> put_status(:bad_request)
        |> json(%{data: %{message: "invalid credentials"}})
    end
  end
end
