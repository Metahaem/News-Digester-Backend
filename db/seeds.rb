# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

Website.destroy_all
Category.destroy_all
User.destroy_all

websites = [{name: "BBC"}, {name: "Independent"}, {name: "Guardian"}, {name: "Reuters"}]
websites.each {|website| Website.create(website)}

categories = [{name: "UK"}, {name: "World"}, {name: "Art"}, {name: "Politics"}, {name: "Business"}, {name: "Technology"}, {name: "Environment"}]
categories.each {|category| Category.create(category)}

User.create(name: "Tom", password_digest: "foo")
