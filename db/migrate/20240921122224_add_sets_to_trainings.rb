class AddSetsToTrainings < ActiveRecord::Migration[7.0]
  def change
    add_column :trainings, :sets, :integer
  end
end
