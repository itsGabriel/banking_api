defmodule BankingApiWeb.UserView do
  use BankingApiWeb, :view
  alias BankingApiWeb.UserView

  def render("accounts.json", %{accounts: accounts}) do
    %{data: render_many(accounts, UserView, "account.json")}
  end

  def render("account.json", %{user: account}) do
    %{
      id: account.id,
      code: account.code,
      balance: account.balance
    }
  end
end
