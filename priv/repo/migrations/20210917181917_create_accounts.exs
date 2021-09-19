defmodule BankingApi.Repo.Migrations.CreateAccounts do
  use Ecto.Migration

  def change do
    create table(:accounts) do
      add :code, :string
      add :balance, :integer

      add :user_id, references(:users)

      timestamps()
    end

    create unique_index(:accounts, [:code])
  end
end
