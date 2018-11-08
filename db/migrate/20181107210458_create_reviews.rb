class CreateReviews < ActiveRecord::Migration[5.1]
  def change
    create_table :reviews do |t|
      t.text :title
      t.text :description
      t.integer :rating
      t.references :order_item, foreign_key: true

      t.timestamps
    end
  end
end
