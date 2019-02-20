class AddDownload < ActiveRecord::Migration[5.1]
  def change
    add_column :site_urls, :ripped, :boolean, :default => false
  end
end
