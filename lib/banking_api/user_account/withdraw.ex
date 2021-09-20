defmodule BankingApi.UserAccount.Withdraw do
  use Ecto.Schema
  import Ecto.Changeset

  embedded_schema do
    field :account, :string
    field :amount, :integer
  end

  def changeset(account, attrs) do
    account
    |> cast(attrs, [:account, :amount])
    |> validate_required([:account, :amount])
    |> validate_number(:amount, greater_than_or_equal_to: 1)
  end
end
