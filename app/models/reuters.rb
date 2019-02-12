require 'nokogiri'
require 'open-uri'

class Reuters < ApplicationRecord

    @categories = {
      'UK': "news/uk", 
      "World": "news/world", 
      "Art": "news/entertainment/arts", 
      "Business": "business", 
      "Politics": "politics",
      "Technology": "news/technology",  
      "Environment": "news/environment"}
    
    def self.get_category_id(category)
        Category.all.find{|cat| cat.name.downcase == category.to_s.downcase}.id
    end

    def self.get_website_id
        Website.all.find{|website| website.name.downcase == "reuters"}.id
    end
    
    def self.get_page(category)
        Nokogiri::HTML(open("https://uk.reuters.com/#{@categories[category]}"))
    end

    # Returns story's subtext if it had one, otherwise returns empty string
    def self.get_subtext(story)
        if story.at_css(".story-content").at_css("p") == nil 
            return ""
        else 
            return story.at_css(".story-content").at_css("p").text
        end
    end

    def self.filter_stories_with_no_image(stories)
        stories = stories.reject {|story| story.at_css(".story-photo") == nil}
        stories = stories.reject {|story| story.at_css(".story-photo").children[1].children[1]["org-src"] == nil}
    end

    def self.refine_story_data(category)
        stories = self.get_page(category).css(".story")
        stories = self.filter_stories_with_no_image(stories)
        
        stories.map do |story| {
            title: story.at_css(".story-title").children.text.gsub(/\n/, "").strip,
            subtext: self.get_subtext(story),
            image: story.at_css(".story-photo").children[1].children[1]["org-src"],
            link: "https://uk.reuters.com#{story.at_css(".story-photo").children[1].attributes["href"].value}",
            category_id: self.get_category_id(category),
            website_id: self.get_website_id
            }
        end
    end
        
    def self.scrape_one_category(category)
        stories = self.refine_story_data(category)
        stories.each do |story|
            Story.create!(story)
        end
    end
        
    def self.scrape_all_categories
        category_names = @categories.map {|k, v| k}
        category_names.each {|cat| self.scrape_one_category(cat)}
    end
      
end