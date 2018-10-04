# Includes authentication behavior for all subclasses. 
# So just recovery the sessions user only by calling current_user. 
class Api::V1::BaseController < ApplicationController
  include Authenticable
end
