class CreateOrders < ActiveRecord::Migration[6.0]
  def change
    create_table :orders do |t|
      t.datetime :ready_at
      t.integer :item_id
      t.integer :wrapper_id

      t.timestamps
    end
    add_index :item_wrappers, :item_id
    add_index :item_wrappers, :wrapper_id
  end
end
