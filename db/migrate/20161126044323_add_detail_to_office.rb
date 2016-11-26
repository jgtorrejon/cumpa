class AddDetailToOffice < ActiveRecord::Migration[5.0]
  def change
    add_column :offices, :name, :string
  end
end
