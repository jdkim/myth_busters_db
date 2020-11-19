class AddRootToUser < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :root, :boolean, default:false
  end
end
