class CreateAbsences < ActiveRecord::Migration[5.0]
  def change
    create_table :absences do |t|
      t.datetime :time
      t.string :reason
      t.references :course, foreign_key: true

      t.timestamps
    end
  end
end
