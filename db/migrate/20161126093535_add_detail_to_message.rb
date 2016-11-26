class AddDetailToMessage < ActiveRecord::Migration[5.0]
  def change
    add_column :messages, :bot, :boolean
  end
end
