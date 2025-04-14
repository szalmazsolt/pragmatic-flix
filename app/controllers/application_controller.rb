class ApplicationController < ActionController::Base
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern

  add_flash_types(:danger, :success, :info)

  private

    def current_user
      # Memoization
      # User.find gets called only once during the same request
      # even though we refer to current_user three times in our _header file.
      # For this to work, we need to set an instance variable with the 'or-equals' operator
      @current_user ||= User.find(session[:user_id]) if session[:user_id]
    end

    helper_method :current_user

    def require_signin
      session[:intended_url] = request.url
      redirect_to new_session_path, alert: "You need to sign in first!" unless current_user
    end

    def require_correct_user
      @user = User.find(params[:id])
      redirect_to root_url, status: :see_other unless current_user_same_as?(@user) || current_user_admin?
    end

    def current_user_same_as?(user)
      current_user == user
    end

    helper_method :current_user_same_as?

    def current_user_admin?
      current_user && current_user.admin?
    end

    helper_method :current_user_admin?

    def require_admin
      redirect_to root_url unless current_user_admin?
    end
end
