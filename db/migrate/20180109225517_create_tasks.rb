class CreateTasks < ActiveRecord::Migration[5.0]
  def change
    create_table :tasks do |t|
      t.string :name
      t.string :description
      t.datetime :start
      t.datetime :close
      t.references :course, foreign_key: true

      t.timestamps
    end
  end
end
