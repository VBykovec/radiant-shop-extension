module ShopProducts
  module ProductExtensions
    def self.included(base)
      base.class_eval do
        def slug
          "/shop/#{self.category.handle}/#{self.handle}"
        end
      
        def layout
          self.category.product_layout
        end
      
        def assets_available
          Asset.search('', {:image => 1}) - self.assets
        end
      end
    end
  end
end