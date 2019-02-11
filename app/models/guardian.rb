require 'nokogiri'
require 'open-uri'

class Guardian < ApplicationRecord
        @categories = {
          'UK': "UK", 
          "World": "World", 
          "Art": "artanddesign", 
          "Politics": "Politics", 
          "Business": "Business", 
          "Technology": "Technology",  
          "Environment": "Environment"}
      
      
        def self.get_page(category)
          Nokogiri::HTML(open("https://www.theguardian.com/#{@categories[category].downcase}"))
        end

        def self.has_kicker(story)
            if story.at_css(".fc-item__kicker") == nil
                return false
            else
                return true
            end
        end
      
        def self.has_img(story)
            if story.at_css(".responsive-img") == nil
                return false
            else
                return true
            end
        end



        def self.refine_story_data(category)
            refined_stories = []
            stories = self.get_page(category).css(".fc-item__container")
           
            stories = stories.reject{|story| story.at_css(".responsive-img") == nil}[0..6]
            
            stories.each do |story|
                if self.has_kicker(story)
                    title = story.at_css(".fc-item__kicker").children.text
                    subtext = story.at_css(".js-headline-text").children.text
                else
                    title = story.at_css(".js-headline-text").children.text
                    subtext = ""
                end
            
                hash = {
                 title: title,
                 subtext: subtext,
                image: story.at_css(".responsive-img")["src"],
                link: story.at_css(".u-faux-block-link__overlay").attributes["href"].value,
                category_id: Category.all.find{|cat| cat.name.downcase == category.to_s.downcase}.id,
                website_id: Website.all.find{|website| website.name.downcase == "guardian"}.id
                }
                refined_stories << hash
            end
            refined_stories
        end
      
      
      
    def self.scrape_one_category(category)
        stories = self.refine_story_data(category)
          
        #create stories in database
        stories.compact.each do |story|
            Story.create!(story)
        end
    end
      
    def self.scrape_all_categories
        category_names = @categories.map {|k, v| k}
        category_names.each {|cat| self.scrape_one_category(cat)}
    end
      
end