class SessionsController < ApplicationController
  def new
  end
	
	def create
		user = User.find_by(email: params[:session][:email].downcase)
		if user && user.authenticate(params[:session][:password])
      if user.activated?
			# Method created in SessionsHelper
			# Also written log_in(user)
        log_in user
        # This was defined in the user model
        params[:session][:remember_me] == "1" ? remember(user) : forget(user)
        # Added for friendly forwarding
        redirect_back_or user
        # Redirects to the user's profile page
        # Also could be written redirect_to user_page(user)
      else
        message = "Account not activated"
        message += "Check your email for the activation link"
        flash[:warning] = message
        redirect_to root_url
      end
		else
      flash.now[:danger] = "Invalid email/password combination"
			render 'new'
		end
	end
	
	def destroy
		# log_out method defined in the sessions helper
		# Checking logged in because you could be logged in in 2 browsers then logout of one causing an error
		log_out if logged_in?
			redirect_to root_url
	end
	
end
