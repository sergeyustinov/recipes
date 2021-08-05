class CreateRecipes < ActiveRecord::Migration[6.1]
  def change
    create_table :recipes do |t|
      t.string :title
      t.string :status, index: true, null: false

      t.timestamps
    end
  end
end
