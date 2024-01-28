class CreateTableOnes < ActiveRecord::Migration[7.1]
  def change
    create_table :table_ones, comment: 'table_ones' do |t|
      t.string :string_non_null, null: false
      t.string :string_nullable, null: true
      t.integer :integer_non_null, null: false
      t.integer :integer_nullable, null: true
      t.timestamps
    end
  end
end
