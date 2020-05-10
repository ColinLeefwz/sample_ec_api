class CreateOrders < ActiveRecord::Migration[6.0]
  def change
    create_table :orders do |t|
      t.datetime :ready_at
      t.integer :user_id
      t.integer :product_id

      t.timestamps
    end
    add_index :orders, :user_id
    add_index :orders, :product_id
  end
end
