class UserMailer < ApplicationMailer
    default from: 'notifications@example.com'

    def welcome_email(user,order)
        @user = user
        @order = order 
        puts 'Hello'
        puts @order.id
        puts @order
        puts @user.email 
        @url  = 'http://example.com/login'
        mail(to: @user.email, 
            subject: @order.id) do |format|
            format.html {render 'welcome_email'}
            format.text { render plain: 'Render text'}
            puts "Sending e-mail was successfull"
      end
    end 
end
