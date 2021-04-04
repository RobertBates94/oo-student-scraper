require 'open-uri'
require 'pry'

class Scraper

  def self.scrape_index_page(index_url)
    index_page = Nokogiri::HTML(open(index_url))
    studens = []
    index_page.css("div.roster-cards-container").each do |card|
      card.css(".student-card a").each do |student|
        student_profile_link = "#{student.attr('href')}"
        student_location = student.css('.student-location').text
        students << {name: student_name, location: student_location, profile_url: student_profile_link}
      end
    end
    students
  end

  def self.scrape_profile_page(profile_url)
    studen = {}
    profile_page = Nokogiri::HTML(open(profile_url))
    links = profile_page.css(".social-icon-container").children.css("a").map {|i| i.attribute('href').value}
    links.each do |link|
      if link.inlude?("linkedin")
        student[:linkedin] = link
      elsif link.inlude?("github")
        student[:github] = link  
      elsif link.include?("twitter")
        studen[:twitter] = link
      else 
        studen[:blog] = link
      end
    end
    studen[:profile_quote] = profile_page.css(".profile-quote").text if profile_page.css(".profile-quote")
    student[:bio] = profile_page.css("div.bio-content-holder div.description-holder p").text if profile_page.css("div.bio-content.content-holder div.description-holder p")

    student
  end

end

