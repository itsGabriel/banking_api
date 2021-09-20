defmodule BankingApiWeb.TransactionView do
  use BankingApiWeb, :view
  alias BankingApiWeb.TransactionView

  def render("transfer.json", %{account: account}) do
    %{data: render_one(account, TransactionView, "account.json")}
  end

  def render("withdraw.json", %{account: account}) do
    %{data: render_one(account, TransactionView, "account.json")}
  end

  def render("account.json", %{transaction: data}) do
    %{
      id: data.id,
      code: data.code,
      balance: data.balance
    }
  end
end
