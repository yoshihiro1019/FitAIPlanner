class AddPartToTrainings < ActiveRecord::Migration[7.0]
  def change
    add_column :trainings, :part, :string
  end
end
