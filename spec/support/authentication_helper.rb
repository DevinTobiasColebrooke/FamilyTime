module AuthenticationHelper
  def login_as(user)
    post sign_in_path, params: { email: user.email, password: user.password }
  end
end
