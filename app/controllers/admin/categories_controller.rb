class Admin::CategoriesController < ApplicationController
    def index
        @categories = Category.all
      end
    
      def new
        @category = Category.new
      end
    
      def create
        @category = Category.new(product_params)
    
        if @category.save
          redirect_to [:admin, :products], notice: 'Product created!'
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
