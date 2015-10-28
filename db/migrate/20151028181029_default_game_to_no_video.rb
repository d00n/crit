class DefaultGameToNoVideo < ActiveRecord::Migration
  def change
    change_column :games, :use_video, :boolean, :default => false
  end
end
