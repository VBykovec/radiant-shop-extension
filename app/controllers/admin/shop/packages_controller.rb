class Admin::Shop::PackagesController < Admin::ResourceController
  model_class ShopPackage
  
  before_filter :config_global
  before_filter :config_new,    :only => [ :new, :create ]
  before_filter :config_edit,   :only => [ :edit, :update ]
  before_filter :assets_global
  before_filter :assets_index,  :only => :index
  before_filter :assets_edit,   :only => [ :edit, :update ]
  
private
  
  def config_global
    @meta     ||= []
    @buttons  ||= []
    @parts    ||= []
    @popups   ||= []
  end
  
  def config_new
    @meta  << 'sku'
    
    @parts << 'description'
  end
  
  def config_edit
    @meta  << 'sku'
    
    @parts << 'description'
    @parts << 'products'
    
    @buttons << 'browse_products'
    
    @popups << 'browse_products'
  end
  
  def assets_global
    include_stylesheet 'admin/extensions/shop/edit'
  end
  
  def assets_index
    include_stylesheet 'admin/extensions/shop/packages/index'
  end
  
  def assets_edit
    include_javascript 'admin/dragdrop'
    include_stylesheet 'admin/extensions/shop/packages/edit'
    include_javascript 'admin/extensions/shop/packages/edit'
  end

end