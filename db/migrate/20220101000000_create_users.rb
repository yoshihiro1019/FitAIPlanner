class CreateUsers < ActiveRecord::Migration[7.0]
  def change
    create_table :users do |t|
      t.string :email, null: false
      t.string :crypted_password
      t.string :salt
      t.string :first_name, null: false
      t.string :last_name, null: false
      t.integer :role, default: 0, null: false
      t.string :reset_password_token
      t.datetime :reset_password_token_expires_at
      t.datetime :reset_password_email_sent_at
      t.integer :access_count_to_reset_password_page, default: 0
      t.string :avatar

      t.timestamps
    end

    add_index :users, :email, unique: true
    add_index :users, :reset_password_token, unique: true
  end
end
