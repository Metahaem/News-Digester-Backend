require 'nokogiri'
require 'open-uri'
class Independent < ApplicationRecord

    def self.get_page
        Nokogiri::HTML(open("https://www.independent.co.uk/life-style/gadgets-and-tech"))
       end
     
     
       def self.get_stories
         self.get_page.css(".article")
       end
     
     
     
       def self.get_array_of_stories
         data = self.get_stories[0..6]
         data.map do |post|
                 {
                 title: post.at_css(".headline").text.gsub(/\n/, "").strip,
                 subtext: ``,
                 image: post.at_css(".amp-img")["src"],
                 link: "https://www.independent.co.uk#{post.at_css(".content").children[3]["href"]}",
                 category_id: Category.all.find{|category| category.name == "Tech"}.id,
                 website_id: Website.all.find{|website| website.name == "Independent"}.id
         }
         end
       end
     
       def self.scrape_all_categories
         self.get_array_of_stories.each do |story|
           Story.create!(story)
         end
       end
     
     
end


