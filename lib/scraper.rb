require 'nokogiri'
require 'open-uri'
require 'pry'

class Scraper

  def self.scrape_index_page(index_url)
    doc = Nokogiri::HTML(File.read(index_url))
    doc.css('div .student-card').map do |x|
      hash = {
        name: x.css('h4.student-name').text,
        location: x.css('p.student-location').text,
        profile_url: x.css('a')[0].values[0]
      }
    end
  end

  def self.scrape_profile_page(profile_url)
    doc = Nokogiri::HTML(File.read(profile_url))
    hash = {}

    #Get social media links
    doc.css('div.social-icon-container').css('a').each do |social_link|
      if social_link.values[0].include?('twitter')
        hash[:twitter] = social_link.values[0]
      elsif social_link.values[0].include?('linkedin')
        hash[:linkedin] = social_link.values[0]
      elsif social_link.values[0].include?('github')
        hash[:github] = social_link.values[0] if social_link.values[0].include?('github')
      else
        hash[:blog] = social_link.values[0]
      end
    end

    #Get bio and quote
    hash[:profile_quote] = doc.css("div.profile-quote").text
    hash[:bio] = doc.css('div.bio-content.content-holder').text.split()[1..-1].join(' ')

    hash
  end
end
