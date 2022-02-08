# frozen_string_literal: true

class CreateAds < ActiveRecord::Migration[6.1]
  def change
    create_table :ads do |t|
      t.string :title, null: false
      t.string :description, null: false
      t.string :city, null: false
      t.decimal :lat, precision: 10, scale: 2
      t.decimal :lon, precision: 10, scale: 2
      t.integer :user_id, null: false

      t.timestamps
    end
  end
end
