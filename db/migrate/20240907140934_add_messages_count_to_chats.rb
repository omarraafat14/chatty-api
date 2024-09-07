class AddMessagesCountToChats < ActiveRecord::Migration[7.2]
  def change
    add_column :chats, :messages_count, :integer, default: 0, null: false
  end
end
