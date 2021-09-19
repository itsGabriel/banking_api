defmodule BankingApi.Repo.Migrations.CreateTransactions do
  use Ecto.Migration
  alias BankingApi.UserAccount.Account

  def change do
    create table(:transactions) do
      add :amount, :integer
      add :type, :string
      add :account_origin_id, references(:accounts)
      add :account_destination_id, references(:accounts)

      timestamps()
    end

  end
end
