class SorceryResetPassword < ActiveRecord::Migration[7.0]
  def change
    unless column_exists?(:users, :reset_password_token)
      add_column :users, :reset_password_token, :string, default: nil
    end
    unless column_exists?(:users, :reset_password_token_expires_at)
      add_column :users, :reset_password_token_expires_at, :datetime, default: nil
    end
    unless column_exists?(:users, :reset_password_email_sent_at)
      add_column :users, :reset_password_email_sent_at, :datetime, default: nil
    end
    unless column_exists?(:users, :access_count_to_reset_password_page)
      add_column :users, :access_count_to_reset_password_page, :integer, default: 0
    end

    unless index_exists?(:users, :reset_password_token, unique: true)
      add_index :users, :reset_password_token, unique: true
    end
  end
end
