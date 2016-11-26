class AddDetailsToMessage < ActiveRecord::Migration[5.0]
  def change
    add_reference :messages, :client, foreign_key: true
  end
end
