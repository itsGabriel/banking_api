defmodule BankingApi.UserAccount.Account do
  use Ecto.Schema
  import Ecto.Changeset
  alias BankingApi.Accounts.User

  schema "accounts" do
    field :code, :string
    field :balance, :integer
    belongs_to :user, User

    timestamps()
  end

  @doc false
  def changeset(account, attrs) do
    account
    |> cast(attrs, [:code, :balance, :user_id])
    |> validate_required([:code, :balance])
    |> validate_number(:balance, greater_than_or_equal_to: 1, message: "Insufficient funds")
  end
end
