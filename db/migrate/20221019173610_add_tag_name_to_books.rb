class AddTagNameToBooks < ActiveRecord::Migration[6.1]
  def change
    add_column :books, :tag_name, :string
  end
end
