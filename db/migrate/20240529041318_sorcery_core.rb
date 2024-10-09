class SorceryCore < ActiveRecord::Migration[7.0]
  def change
    unless table_exists?(:users)
      create_table :users do |t|
        t.string :email, null: false, index: { unique: true }
        t.string :crypted_password
        t.string :salt
        t.string :first_name, null: false
        t.string :last_name, null: false

        t.timestamps null: false
      end

      add_index :users, :email, unique: true
      add_index :users, :reset_password_token, unique: true
    end
  end
end
