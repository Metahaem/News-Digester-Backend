require 'nokogiri'
require 'open-uri'

class Al_jazeera < ApplicationRecord

    @categories = {
      'UK': "topics/country/united-kingdom.html", 
      "World": "news/", 
      "Art": "topics/subjects/art.html", 
      "Business": "topics/categories/business.html", 
      "Technology": "topics/categories/science-and-technology.html",  
      "Environment": "topics/categories/environment.html"}
    
    def self.get_category_id(category)
        Category.all.find{|cat| cat.name.downcase == category.to_s.downcase}.id
    end

    def self.get_website_id
        Website.all.find{|website| website.name.downcase == "al jazeera"}.id
    end
    
    def self.get_page(category)
        Nokogiri::HTML(open("https://www.aljazeera.com/#{@categories[category]}"))
    end

    # Returns story's subtext if it had one, otherwise returns empty string
    def self.get_subtext(story)
        if story.at_css(".top-sec-desc") == nil 
            return ""
        else 
            return story.at_css(".top-sec-desc").children.text
        end
    end

    def self.refine_headline_data(category)
        
        story = self.get_page(category).at_css(".top-section-lt")
        
        return {
            title: story.at_css(".top-sec-title").children.text,
            subtext: self.get_subtext(story),
            image: "https://www.aljazeera.com#{story.at_css(".img-responsive")["src"]}",
            link: "https://www.aljazeera.com#{story.at_css(".frame-container").children.first["href"]}",
            category_id: self.get_category_id(category),
            website_id: self.get_website_id
            }
    end


    
    def self.refine_middle_story_data(category)
        stories = self.get_page(category).css(".top-section-rt-s1")
        #filter out stories with no image
        stories = stories.reject {|story| story.at_css(".img-responsive") == nil}
        
        stories.map do |story| {
            title: story.at_css(".top-sec-smalltitle").text,
            subtext: self.get_subtext(story),
            image: "https://www.aljazeera.com#{story.at_css(".img-responsive")["src"]}",
            link: "https://www.aljazeera.com#{story.at_css(".frame-container").children.first["href"]}",
            category_id: self.get_category_id(category),
            website_id: self.get_website_id
            }   
        end
    end

    def self.refine_lower_story_data(category)

        stories = self.get_page(category).css(".topics-sec-item")
        #filter out stories with no image
        stories = stories.reject {|story| story.at_css(".img-responsive") == nil}

        stories.map do |story| {
            title: story.at_css(".topics-sec-item-head").text,
            subtext: self.get_subtext(story),
            image: "https://www.aljazeera.com#{story.at_css(".img-responsive")["src"]}",
            link: "https://www.aljazeera.com#{story.at_css(".topics-sec-item-label").children.first["href"]}",
            category_id: self.get_category_id(category),
            website_id: self.get_website_id
            } 
             
        end
    end

    def self.combine_stories_from_single_category(category)
        stories = []
        stories << self.refine_lower_story_data(category)
        stories << self.refine_middle_story_data(category) 
        stories << self.refine_headline_data(category)
        stories.compact.flatten
    end
        
    def self.scrape_one_category(category)
        stories = self.combine_stories_from_single_category(category)
        stories.compact.each do |story|
            Story.create!(story)
            puts story
        end
    end
        
    def self.scrape_all_categories
        category_names = @categories.map {|k, v| k}
        category_names.each {|cat| self.scrape_one_category(cat)}
    end
      
end