class AddBalanceToClient < ActiveRecord::Migration[5.0]
  def change
    add_column :clients, :balance, :float
  end
end
