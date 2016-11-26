class CreateOffices < ActiveRecord::Migration[5.0]
  def change
    create_table :offices do |t|
      t.string :localization
      t.integer :quantity_of_people

      t.timestamps
    end
  end
end
