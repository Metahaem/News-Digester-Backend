require 'nokogiri'
require 'open-uri'
class Independent < ApplicationRecord
  @categories = {
    'UK': "news/uk", 
    "World": "news/world", 
    "Art": "arts-entertainment", 
    "Politics": "news/uk/politics", 
    "Business": "news/business", 
    "Technology": "life-style/gadgets-and-tech",  
    "Environment": "environment"}
  

    def self.get_page(category)
        Nokogiri::HTML(open("https://www.independent.co.uk/#{@categories[category]}"))
       end
     
     
       def self.get_stories(category)
         self.get_page(category).css(".article")
       end
     
     
     
       def self.get_array_of_stories(category)
         data = self.get_stories(category)[0..6]
         data.map do |post|
                 {
                 title: post.at_css(".headline").text.gsub(/\n/, "").strip,
                 subtext: ``,
                 image: post.at_css(".amp-img")["src"],
                 link: "https://www.independent.co.uk#{post.at_css(".content").children[3]["href"]}",
                 category_id: Category.all.find{|cat| cat.name.downcase == category.to_s.downcase}.id,
                 website_id: Website.all.find{|website| website.name.downcase == "independent"}.id
         }
         end
       end

       def self.scrape_one_category(category)
        stories = self.get_array_of_stories(category)
        stories.each do |story| 
          Story.create!(story)
        end
      end

       def self.scrape_all_categories
        category_names = @categories.map {|k, v| k}
        category_names.each {|cat| self.scrape_one_category(cat)}
      end
     
     
end


