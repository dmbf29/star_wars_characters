class CreateCharacters < ActiveRecord::Migration[5.2]
  def change
    create_table :characters do |t|
      t.string :name
      t.integer :height
      t.integer :mass
      t.string :hair_color
      t.string :skin_color
      t.string :eye_color
      t.string :birth_year
      t.string :gender
      t.string :url
      t.string :photo
      t.references :planet, foreign_key: true

      t.timestamps
    end
  end
end
