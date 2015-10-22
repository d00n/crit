class ShortenIndexName < ActiveRecord::Migration
  def change



    rename_index :messages, "index_messages_on_recipient_deleted_and_recipient_id_and_read_at", "index_messages_XAPP"

  end
end
