class AddTeammateReferenceToTasks < ActiveRecord::Migration
  def change
    add_reference :tasks, :teammate, index: true
  end
end
