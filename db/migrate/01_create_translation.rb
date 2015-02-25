class CreateTranslation < ActiveRecord::Migration
  def change
    create_table :translations do |t|
      t.string :text
      t.string :source
      t.string :target
      t.string :service
      t.string :response

      t.timestamps null: true
    end

    add_index :translations, [:text, :source, :target, :service], unique: true
  end
end
