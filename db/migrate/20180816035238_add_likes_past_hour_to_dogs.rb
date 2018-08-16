class AddLikesPastHourToDogs < ActiveRecord::Migration[5.2]
  def change
    add_column :dogs, :likes_past_hour, :integer
  end
end
