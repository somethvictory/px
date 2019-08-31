class CreateTransactions < ActiveRecord::Migration[5.0]
  def change
    create_table :transactions do |t|
      t.belongs_to :user
      t.belongs_to :country
      t.decimal :amount_spent

      t.timestamps
    end
  end
end
