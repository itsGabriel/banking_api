defmodule BankingApiWeb.UserController do
  use BankingApiWeb, :controller
  alias BankingApi.UserAccount

  def get_my_accounts(conn, _params) do
    with {:ok, user} <- Guardian.Plug.current_resource(conn),
    {:ok, accounts} <- UserAccount.get_accounts_by_user(user.id) do
      conn
      |> put_status(:ok)
      |> render("accounts.json", %{accounts: accounts})
    end
  end
end
