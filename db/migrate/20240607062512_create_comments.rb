class CreateComments < ActiveRecord::Migration[7.0]
    def change
      unless table_exists?(:comments)
        create_table :comments do |t|
          t.integer :user_id, null: false
          t.integer :board_id, null: false
          t.text :body, null: false, limit: 65535
  
          t.timestamps
        end
  
        add_foreign_key :comments, :users
        add_foreign_key :comments, :boards
        add_index :comments, :user_id
        add_index :comments, :board_id
      end
    end
  end