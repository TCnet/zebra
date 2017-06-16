class ProductsController < ApplicationController
  before_action :logged_in_user, only: [:index,:edit,:show, :create, :destroy]

  def index
    @products = current_user.products.paginate(page: params[:page])
  end

  def new
    @product = Product.new
    
  end

  def update
    @product = Product.find(params[:id])
    if @product.update_attributes(product_params)
      flash[:success]= "Product updated"
      redirect_to products_path
    else
      render 'edit'
    end
  end

  def edit
    @product = Product.find(params[:id])
  end

  def create
    @product = current_user.products.build(product_params)
    if @product.save
      flash[:success] = "Product created"
      redirect_to products_path
    else
      render 'new'
    end
    
  end

  def destroy
    Product.find(params[:id]).destroy
    flash[:success] = "Product deleted"
    redirect_to products_path
  end

  private
    def product_params
      params.require(:product).permit(:name, :sku,:description)
    end
  
end
