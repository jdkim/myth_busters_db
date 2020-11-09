class CreateLanguage < ActiveRecord::Migration[5.2]
	def change
		create_table :languages do |t|
			t.string :iso639_3
			t.string :label
			t.string :autonyms, array: true
			t.string :glossonyms, array: true
			t.string :reference

			t.timestamps
		end
	end
end
