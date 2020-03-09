class CreateStates < ActiveRecord::Migration[6.0]
  def change
    create_table :states do |t|
      t.string :name
      t.integer :tested
      t.integer :positive
      t.integer :deaths
      t.string :tested_crawl_date
      t.string :positive_crawl_date
      t.string :deaths_crawl_date
      t.string :tested_source
      t.string :positive_source
      t.string :deaths_source

      t.timestamps
    end
  end
end
