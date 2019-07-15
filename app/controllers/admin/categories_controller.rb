class Admin::CategoriesController < ApplicationController

  http_basic_authenticate_with name: ENV["HTTP_BASIC_USER"],
  password: ENV["HTTP_BASIC_PASSWORD"],
  if: -> { ENV["HTTP_BASIC_PASSWORD"].present? }
  
    def index
        @categories = Category.all
      end
    
      def new
        @category = Category.new
      end
    
      def create
        @category = Category.new(product_params)
    
        if @category.save
          redirect_to [:admin, :categories], notice: 'Category created!'
        else
          render :new
        end
      end
    
          
      private
    
      def product_params
        params.require(:category).permit(
          :name
        )
      end

end
