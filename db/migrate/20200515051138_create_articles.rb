class CreateArticles < ActiveRecord::Migration[5.2]
  def change
    create_table :articles do |t|
      t.string :aid
      t.string :title
      t.text :body
      t.string :lcode
      t.string :scode
      t.string :author

      t.timestamps
    end
  end
end
