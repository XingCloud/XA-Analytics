class CreateTranslations < ActiveRecord::Migration
  def change
    create_table :translations do |t|
      t.integer :rid
      t.string :rtype
      t.string :rfield
      t.string :locale
      t.text :content
      t.timestamps
    end
  end
end
