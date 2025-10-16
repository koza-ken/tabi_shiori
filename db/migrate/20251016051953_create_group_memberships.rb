class CreateGroupMemberships < ActiveRecord::Migration[7.2]
  def change
    create_table :group_memberships do |t|
      t.references :user, foreign_key: true
      t.references :group, null: false, foreign_key: true
      t.string :group_nickname, limit: 20
      t.integer :role, default: 0, null: false
      t.string :guest_token, limit: 64
      t.timestamps
    end
    # 登録ユーザーの重複参加防止
    add_index :group_memberships, [:user_id, :group_id], unique: true
    # 同じグループ内でのニックネーム重複防止
    add_index :group_memberships, [:group_id, :group_nickname], unique: true
    add_index :group_memberships, :guest_token
  end
end
