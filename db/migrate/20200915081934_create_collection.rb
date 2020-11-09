class CreateCollection < ActiveRecord::Migration[5.2]
	def change
		create_table :collections do |t|
			t.string :label
			t.string :authors, array: true
			t.string :source
			t.references :language
			t.references :script

			t.timestamps
		end
	end
end
