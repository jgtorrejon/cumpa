class CreateCreditStatuses < ActiveRecord::Migration[5.0]
  def change
    create_table :credit_statuses do |t|
      t.string :description
      t.string :sender_id
      t.references :clients, foreign_key: true
      t.timestamps
    end
  end
end
