require 'nokogiri'
require 'open-uri'
class Bbc < ApplicationRecord

  def self.get_page
   Nokogiri::HTML(open("https://www.bbc.co.uk/news/technology"))
  end

  

  def self.get_stories
    self.get_page.css(".pigeon-item")
  end



  def self.get_array_of_stories
    data = self.get_stories[0..1]
    data.map do |post|
            {
            title: post.at_css(".title-link__title-text").text,
            subtext: post.at_css(".pigeon-item__summary").children.text,
            image: post.at_css(".js-delayed-image-load")["data-src"],
            link: "https://www.bbc.co.uk#{post.at_css(".pigeon-item__body").children[1].attributes['href'].value}",
            category_id: Category.all.find{|category| category.name == "Tech"}.id,
            website_id: Website.all.find{|website| website.name == "BBC"}.id
        }
    end
  end

  def self.scrape_all_categories
    self.get_array_of_stories.each do |story|
      Story.create!(story)
    end
  end

end

