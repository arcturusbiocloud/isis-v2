require 'single_sign_on'

class DiscourseSsoController < ApplicationController
  before_action :authenticate_user! # ensures user must login

  def sso
    secret = "QHXSWKWmTfF5p5uus4eTTycH"
    sso = SingleSignOn.parse(request.query_string, secret)
    sso.email = current_user.email # from devise
    sso.name = current_user.username 
    sso.username = current_user.email # from devise
    sso.external_id = current_user.id # from devise
    sso.avatar_url = current_user.gravatar_url(default: 'identicon')
    sso.avatar_force_update=true
    sso.sso_secret = secret

    redirect_to sso.to_url("https://forum.arcturus.io/session/sso_login")
  end
end