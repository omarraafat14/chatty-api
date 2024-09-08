class AddNameToChat < ActiveRecord::Migration[7.2]
  def change
    add_column :chats, :name, :text, null: false
  end
end
