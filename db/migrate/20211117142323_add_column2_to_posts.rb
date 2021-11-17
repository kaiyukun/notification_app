class AddColumn2ToPosts < ActiveRecord::Migration[6.1]
  def change
    add_column :posts, :user_uid, :string
  end
end
