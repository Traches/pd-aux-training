class CreateTrainingRecords < ActiveRecord::Migration[5.1]
  def change
    create_table :training_records do |t|

      t.timestamps
    end
  end
end
