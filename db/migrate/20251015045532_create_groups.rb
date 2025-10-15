class CreateGroups < ActiveRecord::Migration[7.2]
  def change
    create_table :groups do |t|
      t.integer :created_by_user_id, null: false
      t.string :name, null: false, limit: 30
      t.string :invite_token, null: false, limit: 64
      t.string :trip_name, limit: 50
      t.date :start_date
      t.date :end_date
      t.text :trip_memo

      t.timestamps null: false
    end
    add_index :groups, :created_by_user_id
    add_index :groups, :invite_token, unique: true
    add_index :groups, :start_date
  end
end
