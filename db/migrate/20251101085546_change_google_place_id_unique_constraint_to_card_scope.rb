class ChangeGooglePlaceIdUniqueConstraintToCardScope < ActiveRecord::Migration[7.2]
  def change
    # 既存の全体ユニークインデックスを削除
    remove_index :spots, name: "index_spots_on_google_place_id"

    # card_idスコープの複合ユニークインデックスを追加
    add_index :spots, [:card_id, :google_place_id], unique: true, where: "(google_place_id IS NOT NULL)"
  end
end
