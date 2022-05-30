class Product < ApplicationRecord
  # Validations
  validates :url, presence: true
  validates :title, presence: true
  validates :scrapped_at, presence: true
  validates :price, numericality: true

  # Class methods
  # 
  # Scrapes the data from the web
  def self.scrape_from_web(url)
    scrapper_obj = WebScrapper.new url
    scrapper_obj.parse_contents.merge(url: url, scrapped_at: Time.now)
  end

  # Tries to find and update or creates the product 
  def self.create_or_update(url)
    product = Product.find_by_url(url)

    product = product.scrape_and_update if product.present? && product.expired?

    if product.blank?
      product = self.scrape_and_create(url)
      status = :created
    end
    
    product
  end

  # 
  def self.scrape_and_create(url)
    scrapped_data = Product.scrape_from_web(url)
    product = Product.new(scrapped_data)

    product.save! if product.valid?

    product
  end

  # Instance methods
  #  
  # Checks if the product is scrapped one week back
  def expired?
    self.scrapped_at + 7.days < Time.now
  end

  # Scrapes the data from web and updates the product attrs
  def scrape_and_update
    scrapped_data = Product.scrape_from_web(self.url)
    self.update(
      title: scrapped_data[:title],
      scrapped_at: scrapped_data[:scrapped_at],
      description: scrapped_data[:description],
      price: scrapped_data[:price].to_f
    )

    self
  end

  # Simple custom serializer used in the controller response 
  def serialize!
    product = self.as_json
    product["expired"] = self.expired?

    product
  end
end
