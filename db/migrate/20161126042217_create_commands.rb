class CreateCommands < ActiveRecord::Migration[5.0]
  def change
    create_table :commands do |t|
      t.string :answer
      t.string :command
      t.string :intent

      t.timestamps
    end
  end
end
