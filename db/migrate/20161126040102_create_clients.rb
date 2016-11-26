class CreateClients < ActiveRecord::Migration[5.0]
  def change
    create_table :clients do |t|
      t.string :name
      t.string :last_name
      t.string :picture
      t.string :sender_id

      t.timestamps
    end
  end
end
