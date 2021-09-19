defmodule BankingApiWeb.TransactionController do
  use BankingApiWeb, :controller

  alias BankingApi.{
    UserAccount,
    UserAccount.Withdraw,
    UserAccount.Transfer
  }

  action_fallback BankingApiWeb.FallbackController

  def withdraw(conn, params) do
    with {:ok, user} <- Guardian.Plug.current_resource(conn),
         %{valid?: true} = changeset <- Withdraw.changeset(%Withdraw{}, params),
         {:ok, account} <- UserAccount.withdraw(user.id, changeset) do
      conn
      |> put_status(:ok)
      |> json(%{data: %{total: account.balance}})
    end
  end

  def transfer(conn, params) do
    with {:ok, user} <- Guardian.Plug.current_resource(conn),
         %{valid?: true} = changeset <- Transfer.changeset(%Transfer{}, params),
         {:ok, account} <- UserAccount.transfer(user.id, changeset) do
      conn
      |> put_status(:ok)
      |> json(%{data: %{total: account.balance}})
    end
  end
end
