class CreateProducts < ActiveRecord::Migration[7.0]
  def change
    create_table :products do |t|
      t.string :url, null: false
      t.string :title, null: false
      t.text :description
      t.float :price
      t.datetime :scrapped_at, null: false

      t.timestamps
    end
  end
end
