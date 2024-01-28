class CreateTags < ActiveRecord::Migration[7.1]
  def change
    create_table :tags, comment: 'tags' do |t|
      t.string :name, null: false
      t.string :slug, null: false
      t.timestamps
    end
  end
end
