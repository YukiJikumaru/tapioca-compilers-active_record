class CreatePosts < ActiveRecord::Migration[7.1]
  def change
    create_table :posts, comment: 'posts' do |t|
      t.references :author, null: true, foreign_key: { on_delete: :nullify }
      t.string :title, null: false
      t.text :content, null: false
      t.timestamps
    end
  end
end
