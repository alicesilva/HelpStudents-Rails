# User microservices for login and logout with simple token authentication. 
# For more faster authentication, see: 
# https://auth0.com/learn/json-web-tokens/
# https://www.pluralsight.com/guides/ruby-ruby-on-rails/token-based-authentication-with-ruby-on-rails-5-api
class Api::V1::SessionsController < Api::V1::BaseController
  def create
    user = User.find_by(email: session_params[:email])
    if user && user.valid_password?(session_params[:password])
      sign_in user, store: false
      user.generate_authentication_token!
      user.save
      render json: user, status: :ok
    else
      render json: { errors: 'Email ou senha inválido!' }, status: :unauthorized
    end
  end

  def destroy
    user = User.find_by(auth_token: session_params[:auth_token])
    user.generate_authentication_token!
    user.save
    head :no_content
  rescue
    head :not_found
  end

  private

  def session_params
    params.require(:session).permit(:email, :password, :auth_token)
  end
end
