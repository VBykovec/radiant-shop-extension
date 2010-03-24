class Admin::Shop::CategoriesController < Admin::ResourceController
  model_class ShopCategory
  helper :shop
  only_allow_access_to :index, :show, :new, :create, :edit, :update, :remove, :destroy,
      :when => [:admin, :designer],
      :denied_url => :back,
      :denied_message => "You don't have permission to access this page."

  # GET /shop/products/categories
  # GET /shop/products/categories.js
  # GET /shop/products/categories.xml
  # GET /shop/products/categories.json                            AJAX and HTML
  #----------------------------------------------------------------------------
  def index
    @shop_categories = ShopCategory.search(params[:search])
    attr_hash =  {
      :include => :products,
      :only => [:id, :handle, :created_at, :updated_at, :description, :price, :title, :tags] 
    }
    respond_to do |format|
      format.html { redirect_to admin_shop_products_path }
      format.js { render :partial => '/admin/shop/categories/category', :collection => @shop_categories }
      format.json { render :json => @shop_categories.to_json(attr_hash) }
      format.xml { render :xml => @shop_categories.to_xml(attr_hash) }
    end
  end
  
  # GET /shop/products/categories/1/products
  # GET /shop/products/categories/1/products.js
  # GET /shop/products/categories/1/products.xml
  # GET /shop/products/categories/1/products.json                 AJAX and HTML
  #----------------------------------------------------------------------------
  def products
    @shop_category = ShopCategory.find(params[:id])
    attr_hash = {
      :only => [:id, :handle, :created_at, :updated_at, :description, :title]
    }
    respond_to do |format|
      format.html { render }
      format.js { render :partial => '/admin/shop/products/product', :collection => @shop_category.products }
      format.xml { render :xml => @shop_category.products.to_xml(attr_hash) }
      format.json { render :json => @shop_category.products.to_json(attr_hash) }
    end
  end

  # GET /shop/products/categories/1
  # GET /shop/products/categories/1.js
  # GET /shop/products/categories/1.xml
  # GET /shop/products/categories/1.json                          AJAX and HTML
  #----------------------------------------------------------------------------
  def show
    @shop_category = ShopCategory.find(params[:id])
    attr_hash =  { 
      :include => :products,
      :only => [:id, :handle, :created_at, :updated_at, :description, :tags, :title] 
    }
    respond_to do |format|
      format.html { render }
      format.js { render :partial => '/admin/shop/categories/category', :locals => { :category => @shop_category } }
      format.xml { render :xml => @shop_category.to_xml(attr_hash) }
      format.json { render :json => @shop_category.to_json(attr_hash) }
    end
  end

  # POST /shop/products/categories
  # POST /shop/products/categories.js
  # POST /shop/products/categories.xml
  # POST /shop/products/categories.json                           AJAX and HTML
  #----------------------------------------------------------------------------
  def create
    @shop_category = ShopCategory.new(params[:shop_category])

    if @shop_category.save
      respond_to do |format|
        format.html { 
          flash[:notice] = "Category created successfully."
          redirect_to admin_shop_categories_path 
        }
        format.js { render :partial => '/admin/shop/categories/category', :locals => { :category => @shop_category } }
        format.xml { redirect_to "/admin/shop/products/categories/#{@shop_category.id}.xml" }
        format.json { redirect_to "/admin/shop/products/categories/#{@shop_category.id}.json" }
      end
    else
      respond_to do |format|
        format.html { 
          flash[:error] = "Unable to create new product."
          render
        }
        format.js { render :text => @shop_category.errors.to_json, :status => :unprocessable_entity }
        format.xml { render :xml => @shop_category.errors.to_xml, :status => :unprocessable_entity }
        format.json { render :json => @shop_category.errors.to_json, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /shop/products/categories/1
  # PUT /shop/products/categories/1.js
  # PUT /shop/products/categories/1.xml
  # PUT /shop/products/categories/1.json                          AJAX and HTML
  #----------------------------------------------------------------------------
  def update
    @shop_category = ShopCategory.find(params[:id])
    
    if @shop_category.update_attributes!(params[:shop_category])
      respond_to do |format|
        format.html { 
          flash[:notice] = "Category updated successfully."
          redirect_to admin_shop_products_path 
        }
        format.js { render :partial => '/admin/shop/categories/category', :locals => { :category => @shop_category } }
        format.xml { redirect_to "/admin/shop/products/categories/#{@shop_category.id}.xml" }
        format.json { redirect_to "/admin/shop/products/categories/#{@shop_category.id}.json" }
      end
    else
      respond_to do |format|
        format.html { 
          flash[:error] = "Unable to update new category."
          render
        }
        format.js { render :text => @shop_category.errors.to_s, :status => 422 }
        format.xml { render :xml => @shop_category.errors.to_xml, :status => 422 }
        format.json { render :json => @shop_category.errors.to_json, :status => 422 }
      end
    end
  end

  # DELETE /shop/products/categories/1
  # DELETE /shop/products/categories/1.js
  # DELETE /shop/products/categories/1.xml
  # DELETE /shop/products/categories/1.json                       AJAX and HTML
  #----------------------------------------------------------------------------
  def destroy
    # Need to rewrite this method to check for errors and return xml or json.
    # For some reason the answer isn't obvious to me.
    @shop_category = ShopCategory.find(params[:id])
    @shop_category.destroy if @shop_category
    respond_to do |format|
      format.html {
        flash[:notice] = "Category deleted successfully."
        redirect_to admin_shop_products_path
      }
      format.js  { render :html => {:message => "Category deleted successfully."}, :status => 200 }
      format.xml  { render :xml => {:message => "Category deleted successfully."}, :status => 200 }
      format.json  { render :json => {:message => "Category deleted successfully."}, :status => 200 }
    end
  end 
  
end
