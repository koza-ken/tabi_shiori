class AddForeignKeyToGroups < ActiveRecord::Migration[7.2]
  def change
    add_foreign_key :groups, :users, column: :created_by_user_id
  end
end
