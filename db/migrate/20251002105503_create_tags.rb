class CreateTags < ActiveRecord::Migration[8.0]
  def change
    enable_extension(:citext)
    create_table :tags do |t|
      t.citext :name, null: false, index: { unique: true }
      t.timestamps
    end
  end
end
