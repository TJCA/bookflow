class CreateRecords < ActiveRecord::Migration
  def change
    create_table :records do |t|
      t.integer :subject
      t.integer :verb
      t.integer :object
      t.text :adverb

      t.timestamps null: false
    end
  end
end
