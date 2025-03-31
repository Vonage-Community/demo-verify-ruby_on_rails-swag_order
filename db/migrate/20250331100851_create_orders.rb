class CreateOrders < ActiveRecord::Migration[8.0]
  def change
    create_table :orders do |t|
      t.string :uuid
      t.string :product_name

      t.timestamps
    end
  end
end
