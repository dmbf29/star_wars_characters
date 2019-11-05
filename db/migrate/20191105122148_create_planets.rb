class CreatePlanets < ActiveRecord::Migration[5.2]
  def change
    create_table :planets do |t|
      t.string :name
      t.integer :rotation_period
      t.integer :orbital_period
      t.integer :diameter
      t.string :climate
      t.string :gravity
      t.string :terrain
      t.integer :surface_water
      t.integer :population
      t.string :url
      t.string :photo

      t.timestamps
    end
  end
end
