require 'spec/spec_helper'

describe ShopDiscount do
  
  dataset :shop_discounts, :shop_products

  describe 'validations' do
    before :each do
      @discount = shop_discounts(:ten_percent)
    end
    
    context 'name' do
      it 'should require' do
        @discount.name = nil
        @discount.valid?.should === false
      end
      it 'should be unique' do
        @other = shop_discounts(:five_percent)
        @other.name = @discount.name
        @other.valid?.should === false
      end
    end
    
    context 'code' do
      it 'should require' do
        @discount.code = nil
        @discount.valid?.should === false
      end
      it 'should be unique' do
        @other = shop_discounts(:five_percent)
        @other.code = @discount.code
        @other.valid?.should === false
      end
    end
    
    context 'amount' do
      it 'should require' do
        @discount.amount = nil
        @discount.valid?.should === false
      end
      it 'should be numerical' do
        @discount.amount = 'failure'
        @discount.valid?.should === false
      end
    end
  end
  
  describe 'relationships' do
    before :each do
      @discount = shop_discounts(:five_percent)
    end
    context 'categories' do
      before :each do
        @bread = shop_categories(:bread)
      end
      it 'should have many' do
        @discount.discountables.create(:discounted => @bread)
        @discount.categories.include?(@bread).should === true
      end
    end
  end
  
  describe '#available_categories' do
    before :each do
      @discount = shop_discounts(:ten_percent)
    end
    it 'should return all categories minus its own' do
      @discount.available_categories.should === ShopCategory.all - @discount.categories
    end
  end
  
  describe '#available_products' do
    before :each do
      @discount = shop_discounts(:ten_percent)
    end
    it 'should return all products minus its own' do
      @discount.available_products.should === ShopProduct.all - @discount.products
    end
  end
  
  describe '#add_category' do
    before :each do
      @discount = shop_discounts(:one_percent)
      @category = shop_categories(:milk)
    end
    it 'should assign the category to the discount' do
      @discount.add_category(@category)
      @discount.categories.include?(@category).should === true
    end
    it 'should assign the products to that category' do
      @discount.add_category(@category)
      @discount.products.should === @category.products
    end
  end
  
  describe '#remove_category' do
    before :each do
      @discount = shop_discounts(:one_percent)
      @category = shop_categories(:milk)
    end
    it 'should remove the category to the discount' do
      @discount.add_category(@category)
      @discount.remove_category(@category)
      @discount.categories.include?(@category).should === false
    end
    it 'should remove the products of that category' do
      @discount.add_category(@category)
      @discount.remove_category(@category)
      @discount.products.should be_empty
    end
  end
  
end