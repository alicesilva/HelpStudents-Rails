class CreateCourses < ActiveRecord::Migration[5.0]
  def change
    create_table :courses do |t|
      t.string :name
      t.string :description
      t.text :grades, array: true, default: []
      t.integer :absences_allowed
      t.integer :absences_committed
      t.references :semester, foreign_key: true

      t.timestamps
    end
  end
end
