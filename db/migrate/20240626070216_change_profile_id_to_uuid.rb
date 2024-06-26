class ChangeProfileIdToUuid < ActiveRecord::Migration[7.1]
  def up
    transaction do
      add_column :profiles, :uuid, :uuid, default: "gen_random_uuid()", null: false

      add_column :active_storage_attachments, :record_uuid, :uuid
      add_column :chats, :profile_uuid, :uuid
      add_column :memberships, :profile_uuid, :uuid
      add_column :posts, :profile_uuid, :uuid
      

      execute <<-SQL
        UPDATE active_storage_attachments SET record_uuid = profiles.uuid FROM profiles WHERE active_storage_attachments.record_type = 'Profile' AND active_storage_attachments.record_id::integer = profiles.id;
        UPDATE chats SET profile_uuid = profiles.uuid FROM profiles WHERE chats.profile_id = profiles.id;
        UPDATE memberships SET profile_uuid = profiles.uuid FROM profiles WHERE memberships.profile_id = profiles.id;
        UPDATE posts SET profile_uuid = profiles.uuid FROM profiles WHERE posts.profile_id = profiles.id;
      SQL

      remove_foreign_key :chats, :profiles
      remove_foreign_key :memberships, :profiles
      remove_foreign_key :posts, :profiles

      remove_column :profiles, :id
      rename_column :profiles, :uuid, :id
      execute "ALTER TABLE profiles ADD PRIMARY KEY (id);"

      
      remove_column :active_storage_attachments, :record_id
      remove_column :chats, :profile_id
      remove_column :memberships, :profile_id
      remove_column :posts, :profile_id

      rename_column :active_storage_attachments, :record_uuid, :record_id
      rename_column :chats, :profile_uuid, :profile_id
      rename_column :memberships, :profile_uuid, :profile_id
      rename_column :posts, :profile_uuid, :profile_id

      add_foreign_key :chats, :profiles, on_delete: :cascade
      add_foreign_key :memberships, :profiles, on_delete: :cascade
      add_foreign_key :posts, :profiles, on_delete: :cascade
    end
  end

  def down
    transaction do
      remove_foreign_key :chats, :profiles
      remove_foreign_key :memberships, :profiles
      remove_foreign_key :posts, :profiles
    
      add_column :profiles, :integer_id, :integer
    
      add_column :active_storage_attachments, :record_integer_id, :bigint
      add_column :chats, :profile_integer_id, :integer
      add_column :memberships, :profile_integer_id, :integer
      add_column :posts, :profile_integer_id, :integer
    
      execute <<-SQL
        CREATE SEQUENCE IF NOT EXISTS profiles_id_seq;
        UPDATE profiles SET integer_id = nextval('profiles_id_seq');
        UPDATE active_storage_attachments SET record_integer_id = profiles.integer_id FROM profiles WHERE active_storage_attachments.record_type = 'Profile' AND active_storage_attachments.record_id = profiles.id;
        UPDATE chats SET profile_integer_id = profiles.integer_id FROM profiles WHERE chats.profile_id = profiles.id;
        UPDATE memberships SET profile_integer_id = profiles.integer_id FROM profiles WHERE memberships.profile_id = profiles.id;
        UPDATE posts SET profile_integer_id = profiles.integer_id FROM profiles WHERE posts.profile_id = profiles.id;
      SQL
    
      remove_column :profiles, :id
      rename_column :profiles, :integer_id, :id
      execute "ALTER TABLE profiles ADD PRIMARY KEY (id);"

      remove_column :active_storage_attachments, :record_id
      remove_column :chats, :profile_id
      remove_column :memberships, :profile_id
      remove_column :posts, :profile_id
      
      rename_column :active_storage_attachments, :record_integer_id, :record_id
      rename_column :chats, :profile_integer_id, :profile_id
      rename_column :memberships, :profile_integer_id, :profile_id
      rename_column :posts, :profile_integer_id, :profile_id
    
      add_foreign_key :chats, :profiles, on_delete: :cascade
      add_foreign_key :memberships, :profiles, on_delete: :cascade
      add_foreign_key :posts, :profiles, on_delete: :cascade
    end
  end

end
