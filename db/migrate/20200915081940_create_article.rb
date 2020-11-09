class CreateArticle < ActiveRecord::Migration[5.2]
	def change
		create_table :articles do |t|
			t.references :collection
			t.integer :number
			t.string :native_number
			t.string :title
			t.text :body

			t.timestamps
		end
	end
end
