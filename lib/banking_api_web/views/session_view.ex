defmodule BankingApiWeb.SessionView do
  use BankingApiWeb, :view
  alias BankingApiWeb.SessionView
  alias BankingApiWeb.UserView

  def render("login.json", %{token: token}) do
    %{data: render_one(token, SessionView, "token.json")}
  end

  def render("sign_up.json", %{session: data}) do
    %{data: render_one(data, SessionView, "session.json")}
  end

  def render("token.json", %{session: token}) do
    %{token: token}
  end

  def render("session.json", %{session: session}) do
    %{
      id: session.user.id,
      name: session.user.username,
      account: render_one(session.account, UserView, "account.json"),
      token: session.token
    }
  end
end
