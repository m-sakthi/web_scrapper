require 'watir'
require 'webdrivers'
require 'nokogiri'

class WebScrapper
  def initialize(url)
    @url = url
  end

  def scrape
    @browser = Watir::Browser.new :chrome, headless: true
    @browser.goto @url
    scrapped_content = @browser.html
    @browser.close

    scrapped_content
  end

  def parse_contents
    parsed_page = Nokogiri::HTML(self.scrape)

    return ({
      title: parsed_page.title,
      price: parsed_page.css("div._16Jk6d").text[1..-1],
      description: parsed_page.css("span.B_NuCI").text
    })
  end
end