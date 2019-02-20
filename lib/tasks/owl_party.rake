namespace :owl_party do
  desc "crawls a site"

# rake owl_party:work[https://tim.blog/]
task :work, [:target] => [:environment] do |task, args|
  target = args[:target]
    Spidr.site(target) do |spider|
      spider.every_url do |url| 
        SiteUrl.create(url: url)
        puts url 
      end
    end
  end

# rake owl_party:parse
  task :parse => :environment do
    remove_comments()
  end

# rake owl_party:rip
  task :rip => :environment do
    while SiteUrl.where(ripped: false).count > 0
      remove_comments()
      url = SiteUrl.where(ripped: false).first 
        filename = url.url.split('//')[1]
        puts url.url
        puts filename
        filename.gsub!("\/", "-")
        puts filename
        Gastly.capture(url.url, Rails.root.join('public', "#{filename}.png" ))
        url.ripped = true
        url.save
    end
end

def remove_comments
    SiteUrl.all.each do |url|
      remove = url.url.include?('comment') || url.url.include?('reply') || url.url.include?('share')
      if remove
        puts "destroying #{url.url}"
        url.destroy
      end
    end
end

end
