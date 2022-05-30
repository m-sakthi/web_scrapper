require 'rails_helper'

module Api::V1
  RSpec.describe ProductsController, type: :controller do
    describe "GET /index" do
      before do
        @product = Product.create(title: 'Whatever', url: 'http://abc.xyz/path', price: 11, scrapped_at: Time.now)
      end

      it "renders the result" do
        get :index
  
        expect(response.status).to eq(200)
        
        resp = JSON.parse(response.body)[0]

        expect(resp).to include('id')
        expect(resp['id']).to eq(@product.id)
      end
    end

    describe "PUT /update" do
      before do
        @url = 'http://abc.xyz/path'
        @product = Product.create(title: 'Whatever', url: @url, price: 11, scrapped_at: Time.now - 7.days)
      end

      it "updated the record if the record is found" do
        title = "New Title"
        price = 100.00
        description = "New Description"
        result = {
          title: title,
          price: price,
          description: description
        }

        allow_any_instance_of(WebScrapper).to receive(:parse_contents).and_return(result)

        put :update, params: { products: { url: @url } }
  
        expect(response.status).to eq(200)
        
        resp = JSON.parse(response.body)

        expect(resp).to include('id')
        expect(resp['id']).to eq(@product.id)
        expect(resp['title']).to eq(title)
        expect(resp['price']).to eq(price)
        expect(resp['description']).to eq(description)
      end

      it "created the record when the record is not found" do
        url = 'http://new-abc.xyz/path'
        title = "New Title"
        price = 100.00
        description = "New Description"
        result = {
          title: title,
          price: price,
          description: description
        }

        allow_any_instance_of(WebScrapper).to receive(:parse_contents).and_return(result)

        expect { 
          put :update, params: { products: { url: url } }
        }.to change { Product.count }
  
        expect(response.status).to eq(200)
        
        resp = JSON.parse(response.body)

        expect(resp).to include('id')
        expect(resp['url']).to eq(url)
        expect(resp['title']).to eq(title)
        expect(resp['price']).to eq(price)
        expect(resp['description']).to eq(description)
      end
    end
  end
end
