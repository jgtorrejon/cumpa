class CreateMessages < ActiveRecord::Migration[5.0]
  def change
    create_table :messages do |t|
      t.text :message
      t.string :fb_message_id
      t.references :user, foreign_key: true

      t.timestamps
    end
  end
end
