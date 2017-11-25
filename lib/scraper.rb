require 'open-uri'
require 'pry'

class Scraper

  def self.scrape_index_page(index_url)
    doc = Nokogiri::HTML(open(index_url))

    students = []

    doc.css(".student-card").each do |student_card|
      card = {}
      card[:name] = student_card.css("h4").text
      card[:location] = student_card.css("p").text
      card[:profile_url] = student_card.css("a").first.attribute("href").value

      students << card
    end

    students
  end

  def self.scrape_profile_page(profile_url)
    profile = Nokogiri::HTML(open(profile_url))

    profile_info = {}

    links = profile.css(".social-icon-container").css("a")

    links.each do |link|
      url = link.attribute("href").value
      if url.include?("twitter")
        profile_info[:twitter] = url
      elsif url.include?("github")
        profile_info[:github] = url
      elsif url.include?("linkedin")
        profile_info[:linkedin] = url
      else
        profile_info[:blog] = url
      end
    end
    
    profile_info[:profile_quote] = profile.css(".profile-quote").text
    profile_info[:bio] = profile.css(".description-holder p").text

    profile_info
  end

end
