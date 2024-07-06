class CreateComments < ActiveRecord::Migration[7.0]
  def change
    create_table :comments do |t|
      t.bigint :user_id, null: false
      t.bigint :board_id, null: false
      t.text :body, null: false

      t.timestamps
    end

    add_foreign_key :comments, :users
    add_foreign_key :comments, :boards
  end
end
