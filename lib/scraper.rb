require 'open-uri'
require 'pry'

class Scraper

  def self.scrape_index_page(index_url)
    html = File.read(index_url)
    index = Nokogiri::HTML(html)

    students = []

    index.css(".student-card").each do |student|
      students << {
        :name => student.css("h4.student-name").text,
        :location => student.css("p.student-location").text,
        :profile_url => student.css("a").attribute("href").value
      }
    end

    # return the projects hash
    students
  end

  def self.scrape_profile_page(profile_url)
    html = File.read(profile_url)
    index = Nokogiri::HTML(html)
    # binding.pry
    student = index.css("div.main-wrapper.profile")
    # binding.pry
    student_info = {
      :profile_quote=>student.css("div.profile-quote").text,
      :bio=> student.css(".description-holder p").text
     }

     student.css("div.social-icon-container a").each do |social|
       link = social.attribute("href").value
         if link.include?("linkedin")
          student_info[:linkedin] = link
        elsif link.include?("github")
          student_info[:github] = link
        elsif link.include?("twitter")
          student_info[:twitter] = link
        else
          student_info[:blog] = link
        end
     end

     student_info
  end

end
