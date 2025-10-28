class CreateSpots < ActiveRecord::Migration[7.2]
  def change
    create_table :spots do |t|
      t.references :card, null: false, foreign_key: true
      t.string :name, null: false, limit: 50
      t.text :address
      t.string :phone_number, limit: 20
      t.text :website_url
      t.string :google_place_id
      t.timestamps
    end
    add_index :spots, :google_place_id, unique: true, where: "google_place_id IS NOT NULL"
  end
end
