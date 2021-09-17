defmodule BankingApiWeb.SessionView do
  use BankingApiWeb, :view
  alias BankingApiWeb.SessionView

  def render("login.json", %{token: token}) do
    %{data: render_one(token, SessionView, "token.json")}
  end

  def render("token.json", %{session: token}) do
    %{token: token}
  end
end
