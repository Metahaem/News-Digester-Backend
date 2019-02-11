require 'nokogiri'
require 'open-uri'

# BBC News webpages have irregular class names for various types of headline. 
# The "pigeon items" are the smaller news stories on a particular page.
# The "buzzard" or "albatross" news items are the larger headlines, with one on each page. 

class Bbc < ApplicationRecord
  @categories = {
    'UK': "UK", 
    "World": "World", 
    "Art": "entertainment_and_arts", 
    "Politics": "Politics", 
    "Business": "Business", 
    "Technology": "Technology",  
    "Environment": "Science_and_environment"}


  def self.get_page(category)
    
    Nokogiri::HTML(open("https://www.bbc.co.uk/news/#{@categories[category].downcase}"))
  end

  def self.refine_pigeon_data(category)
    # Only the first 2 pigeon items follow the desired data format e.g. with an image and usually a subtext.
    # This method only selects the first 2

    pigeons = self.get_page(category).css(".pigeon-item")[0..1]
    
    refined_pigeons = []
    pigeons.each do |story| 
      
      subtext = ""
      # adding summary text if it is present
      if story.at_css(".pigeon-item__summary") && story.at_css(".pigeon-item__summary").children.any?
        subtext = story.at_css(".pigeon-item__summary").children.text
      end

      #putting the data into standardised format  
      hash = {
        title: story.at_css(".title-link__title-text").text,
        subtext: subtext,
        image: story.at_css(".js-delayed-image-load")["data-src"],
        link: "https://www.bbc.co.uk#{story.at_css(".pigeon-item__body").children[1].attributes['href'].value}",
        category_id: Category.all.find{|cat| cat.name.downcase == category.to_s.downcase}.id,
        website_id: Website.all.find{|website| website.name.downcase == "bbc"}.id
      }
      refined_pigeons << hash
    end

    refined_pigeons
  end

  def self.refine_buzzard_data(category)
  @buzzard = self.get_page(category).css(".buzzard-item")
  if @buzzard.any?
    @buzzard = {
      title: @buzzard.children.at_css(".title-link__title-text").children.first.text,
      subtext: @buzzard.children.at_css(".buzzard__summary").children.first.text,
      image: @buzzard.at_css(".responsive-image").children[1]["src"],
      link: "https://www.bbc.co.uk#{@buzzard.children[1].attributes['href'].value}",
      category_id: Category.all.find{|cat| cat.name.downcase == category.to_s.downcase}.id,
      website_id: Website.all.find{|website| website.name.downcase == "bbc"}.id
      }
    end
  end

  def self.refine_albatross_data(category)
    @albatross = self.get_page(category).css(".albatross-item")
    if @albatross.any?
      @albatross = {
        title: @albatross.children.at_css(".title-link__title-text").children.first.text,
        subtext: @albatross.children.at_css(".albatross__summary").children.first.text,
        image: @albatross.at_css(".responsive-image").children[1]["src"],
        link: "https://www.bbc.co.uk#{@albatross.children[1].attributes['href'].value}",
        category_id: Category.all.find{|cat| cat.name.downcase == category.to_s.downcase}.id,
        website_id: Website.all.find{|website| website.name.downcase == "bbc"}.id
      }     
    end
  end

  def self.scrape_one_category(category)
    #group all different stories into single array
    @stories = []
    @stories << self.refine_albatross_data(category)
    @stories << self.refine_buzzard_data(category)
    @stories << self.refine_pigeon_data(category)
    
    #create stories in database
    @stories.compact.each do |story|
      Story.create!(story)
      end
  end

  def self.scrape_all_categories
    category_names = @categories.map {|k, v| k}
    category_names.each {|cat| self.scrape_one_category(cat)}
  end

end








