class CreateCards < ActiveRecord::Migration[7.2]
  def change
    create_table :cards do |t|
      t.string :name, null: false, limit: 50
      t.text :memo
      t.timestamps
      t.references :user, foreign_key: true
      t.references :group, foreign_key: true
    end

    add_check_constraint :cards,
      "(user_id IS NOT NULL AND group_id IS NULL) OR (user_id IS NULL AND group_id IS NOT NULL)",
      name: "cards_must_belong_to_user_or_group"
  end
end
