class AddRepsToTrainings < ActiveRecord::Migration[7.0]
  def change
    add_column :trainings, :reps, :integer
  end
end
