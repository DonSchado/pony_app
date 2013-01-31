class CreatePonies < ActiveRecord::Migration
  def change
    create_table :ponies do |t|
      t.string :name
      t.string :color
      t.string :kind_of

      t.timestamps
    end
  end
end
