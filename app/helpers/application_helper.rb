module ApplicationHelper
  def current_user
    # Memoization
    # User.find get called only once during the same request
    # even though we refer to current_user three times in our _header file.
    # For this to work, we need to set an instance variable with the 'or-equals' operator
    @current_user ||= User.find(session[:user_id]) if session[:user_id]
  end
end
