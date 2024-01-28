class CreatePostTagRelations < ActiveRecord::Migration[7.1]
  def change
    create_table :post_tag_relations, primary_key: [:post_id, :tag_id], comment: 'post_tag_relations' do |t|
      t.references :post, null: false, foreign_key: { on_delete: :cascade }
      t.references :tag, null: false, foreign_key: { on_delete: :cascade }
      t.timestamps
    end

    add_index :post_tag_relations, %i[post_id tag_id], unique: true
  end
end
