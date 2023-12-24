class CreateAuthors < ActiveRecord::Migration[7.1]
  def change
    create_table :authors, comment: 'authors' do |t|
      t.string :name, null: false, comment: "author's name"
      t.string :tel, null: true, comment: "author's telephone number"
      t.string :email, null: true, comment: "author's email address"
      t.timestamps
    end
  end
end
