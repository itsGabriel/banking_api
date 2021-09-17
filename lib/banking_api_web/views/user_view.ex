
defmodule BankingApiWeb.UserView do
  use BankingApiWeb, :view
  alias BankingApiWeb.UserView

  def render("show.json", %{user: user}) do
    %{data: render_one(user, UserView, "user.json")}
  end

  def render("user.json", %{user: user}) do
    %{
      id: user.id,
      email: user.email,
      username: user.username,
    }
  end
end
