namespace :owl_party do
  require 'open-uri'
  desc "crawls a site"

# rake owl_party:crawl[https://tim.blog/]
task :crawl, [:target] => [:environment] do |task, args|
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

# rake owl_party:text_only
  task :text_only => :environment do
    while SiteUrl.where(ripped: false).count > 0
    target = SiteUrl.where(ripped: false).first 
    puts target.url
    puts target.filename
    html = Nokogiri::HTML.parse(open(target.url))
    paragraphs = html.search("p")
    paragraphs = paragraphs.map { |p| p.text }
    paragraphs = paragraphs.join("\n")
    File.write(Rails.root.join('public', "#{target.filename}.txt"), paragraphs)
      target.ripped = true
      target.save
    end
  end

# rake owl_party:rip
  task :rip => :environment do
    while SiteUrl.where(ripped: false).count > 0
      remove_comments()
      target = SiteUrl.where(ripped: false).first 
        puts target.url
        puts target.filename
        Gastly.capture(url.url, Rails.root.join('public', "#{target.filename}.png" ))
        target.ripped = true
        target.save
        remove_empty()
    end
end

task :remove_files => :environment do
  remove_empty()
end

def remove_empty
  files = Dir["public/*"]
  files.each do |file|
    compressed_file_size = File.size(file).to_f / 2**20
    puts file
    puts compressed_file_size
    File.delete(file) if compressed_file_size == 0
  end

end

def remove_comments
    SiteUrl.all.each do |target|
      url = target.url
      remove = url.include?('comment') ||
               url.include?('reply') ||
               url.include?('share') ||
               url.include?('.php') ||
               url.include?('/feed') ||

      if remove
        puts "destroying #{url.url}"
        target.destroy
      end
    end
end
end
