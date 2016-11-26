class CreateExchangeRates < ActiveRecord::Migration[5.0]
  def change
    create_table :exchange_rates do |t|
      t.date :date
      t.float :sell
      t.float :buy
      t.float :ufv

      t.timestamps
    end
  end
end
