class SiteUrl < ApplicationRecord

  def filename
    url.split('//')[1].gsub!("\/", "-")
  end

end
