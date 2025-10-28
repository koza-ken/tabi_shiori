class CreateCategories < ActiveRecord::Migration[7.2]
  def change
    create_table :categories do |t|
      t.string :name, null: false, limit: 20
      t.integer :display_order, null:false
      t.timestamps
    end
    add_index :categories, :display_order, unique: true
  end
end
