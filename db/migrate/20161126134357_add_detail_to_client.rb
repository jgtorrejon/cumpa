class AddDetailToClient < ActiveRecord::Migration[5.0]
  def change
    add_column :clients, :logged, :boolean, :default => false
    add_column :clients, :bot_service, :boolean, :default => true
  end
end
