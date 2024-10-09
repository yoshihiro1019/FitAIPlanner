class AddAvatarToUsers < ActiveRecord::Migration[7.0]
  def change
    unless column_exists?(:users, :avatar)
      add_column :users, :avatar, :string
    end
  end
end
