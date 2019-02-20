class CreateSiteUrls < ActiveRecord::Migration[5.1]
  def change
    create_table :site_urls do |t|
      t.string :url
      t.timestamps
    end
  end
end
