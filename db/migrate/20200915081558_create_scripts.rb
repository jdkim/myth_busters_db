class CreateScripts < ActiveRecord::Migration[5.2]
  def change
    create_table :scripts do |t|
			t.string :iso15924
			t.string :label

			t.timestamps
    end
  end
end
