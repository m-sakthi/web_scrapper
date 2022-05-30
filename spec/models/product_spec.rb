require 'rails_helper'

RSpec.describe Product, type: :model do
  context 'before creation' do
    it 'should have required data' do
      expect { Product.create! }.to raise_error(ActiveRecord::RecordInvalid)
    end

    it 'should create the record when all attributes are passed' do
      expect {
        Product.create(title: 'Whatever', url: 'http://abc.xyz/path', price: 11, scrapped_at: Time.now)
      }.to change { Product.count }
    end
  end

  context 'scrape_from_web' do
    it 'should call WebScrapper methods' do
      url = 'http://abc.xyz/path'
      result = {
        title: 'New Title',
        price: 100.00,
        description: 'New Description'
      }
      
      allow_any_instance_of(WebScrapper).to receive(:parse_contents).and_return(result)

      expect(Product.scrape_from_web(url)).to include(
        title: 'New Title',
        price: 100.00,
        description: 'New Description',
        url: url
      )
    end
  end

  context 'create_or_update' do
    it 'should create product when not found' do
      url = 'http://new-abc.xyz/path'
      title = "New Title"
      price = 100.00
      description = "New Description"
      result = {
        title: title,
        price: price,
        description: description,
        # scrapped_at: Time.now
      }

      allow_any_instance_of(WebScrapper).to receive(:parse_contents).and_return(result)

      expect{ Product.create_or_update(url) }.to change { Product.count }
    end

    it 'should update product when found' do
      url = 'http://new-abc.xyz/path'
      product = Product.create(title: 'Whatever', url: url, price: 11, scrapped_at: Time.now - 7.days)
      title = "New Title"
      price = 100.00
      description = "New Description"
      result = {
        title: title,
        price: price,
        description: description
      }

      allow_any_instance_of(WebScrapper).to receive(:parse_contents).and_return(result)

      expect{ Product.create_or_update(url) }.not_to change { Product.count }
      updated_product = Product.find(product.id)

      expect(updated_product.title).to eq(title)
      expect(updated_product.description).to eq(description)
      expect(updated_product.price).to eq(price)
    end

    it 'should not update product when found and not expired' do
      url = 'http://new-abc.xyz/path'
      product = Product.create(title: 'Whatever', url: url, price: 11, scrapped_at: Time.now - 6.days)
      result = Product.create_or_update(url)

      expect(result.title).to eq(product.title)
      expect(result.description).to eq(product.description)
      expect(result.price).to eq(product.price)
    end
  end

  context 'expired?' do
    it 'should return true when scrapped_at is older that a week' do
      url = 'http://new-abc.xyz/path'
      product = Product.create(title: 'Whatever', url: url, price: 11, scrapped_at: Time.now - 8.days)

      expect(product.expired?).to eq(true)
    end

    it 'should return false when scrapped_at is not older that a week' do
      url = 'http://new-abc.xyz/path'
      product = Product.create(title: 'Whatever', url: url, price: 11, scrapped_at: Time.now - 6.days)

      expect(product.expired?).to eq(false)
    end
  end

  context 'serialize!' do
    it 'should convert the product to json format and add expired key' do
      url = 'http://new-abc.xyz/path'
      product = Product.create(title: 'Whatever', url: url, price: 11, scrapped_at: Time.now - 6.days)

      result = product.serialize!
      expect(result.is_a?(Hash))
      expect(result.has_key?(:expired))
    end
  end
end
