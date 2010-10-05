module Shop
  module Tags
    module Product
      include Radiant::Taggable
      include ActionView::Helpers::NumberHelper
      
      desc %{ expands if there are products within the context }
      tag 'shop:if_products' do |tag|
        tag.expand unless Helpers.current_products(tag).empty?
      end
      
      desc %{ expands if there are no products within the context }
      tag 'shop:unless_products' do |tag|
        tag.expand if Helpers.current_products(tag).empty?
      end
      
      tag 'shop:products' do |tag|
        tag.locals.shop_products = Helpers.current_products(tag)
        
        tag.expand
      end
      
      desc %{ iterates through each product within the scope }
      tag 'shop:products:each' do |tag|
        content = ''
        
        tag.locals.shop_products.each do |product|
          tag.locals.shop_product = product
          content << tag.expand
        end
        
        content
      end
      
      tag 'shop:product' do |tag|
        tag.locals.shop_product = Helpers.current_product(tag)
        
        tag.expand if tag.locals.shop_product.present?
      end
      
      [:id, :name, :sku, :slug].each do |symbol|
        desc %{ outputs the #{symbol} of the current shop product }
        tag "shop:product:#{symbol}" do |tag|
          tag.locals.shop_product.send(symbol)
        end
      end
      
      desc %{ outputs the description of the current shop product}
      tag "shop:product:description" do |tag|
        parse(TextileFilter.filter(tag.locals.shop_product.description))
      end
      
      desc %{ generates a link to the products generated page }
      tag 'shop:product:link' do |tag|
        options = tag.attr.dup
        attributes = options.inject('') { |s, (k, v)| s << %{#{k.downcase}="#{v}" } }.strip
        attributes = " #{attributes}" if attributes.present?
        
        text = tag.double? ? tag.expand : tag.locals.shop_product.name
        
        %{<a href="#{tag.locals.shop_product.slug}"#{attributes}>#{text}</a>}
      end
      
      desc %{ outputs the slug to the products generated page }
      tag 'shop:product:slug' do |tag|
        tag.locals.shop_product.slug
      end
      
      desc %{ output price of product }
      tag 'shop:product:price' do |tag|
        attr = tag.attr.symbolize_keys
        
        number_to_currency(tag.locals.shop_product.price, 
          :precision  =>(attr[:precision] || Radiant::Config['shop.price_precision']).to_i,
          :unit       => attr[:unit]      || Radiant::Config['shop.price_unit'],
          :separator  => attr[:separator] || Radiant::Config['shop.price_separator'],
          :delimiter  => attr[:delimiter] || Radiant::Config['shop.price_delimiter'])
      end
      
      tag 'shop:product:images' do |tag|
        tag.locals.images = tag.locals.shop_product.attachments
        
        tag.expand
      end
      
      desc %{ expands if the product has a valid image }
      tag 'shop:product:images:if_images' do |tag|
        tag.expand if tag.locals.images.present?
      end
      
      desc %{ expands if the product does not have a valid image }
      tag 'shop:product:images:unless_images' do |tag|
        tag.expand unless tag.locals.images.present?
      end
      
      desc %{ iterates through each of the products images }
      tag 'shop:product:images:each' do |tag|
        content = ''
        
        tag.locals.images.each do |image|
          tag.locals.image = image
          content << tag.expand
        end
        
        content
      end
      
    end
  end
end