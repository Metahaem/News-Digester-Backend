class CreateStories < ActiveRecord::Migration[5.2]
  def change
    create_table :stories do |t|
      t.string :title
      t.string :subtext
      t.string :image
      t.string :link
      t.integer :category_id
      t.integer :website_id

      t.timestamps
    end
  end
end
