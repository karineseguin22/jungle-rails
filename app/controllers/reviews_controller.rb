class ReviewsController < ApplicationController
    def create
        @product = Product.find(params[:product_id])

        @review = @product.reviews.new(review_params)
        @review.user_id = current_user.id
        if @review.save
            #redirecting to the same product show page
            redirect_to product_path(@product)
        else
            #provide the path to the show html.erb from the movies folder
            #otherwise looking by default in reviews folder
            render 'products/show'
      end
    end 
    private 
    def review_params
        params.require(:review).permit(:rating, :description)
    end 
end
