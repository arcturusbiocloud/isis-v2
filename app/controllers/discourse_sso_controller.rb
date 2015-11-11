require 'single_sign_on'

class DiscourseSsoController < ApplicationController
  before_action :authenticate_user!

  def sso
    sso = SingleSignOn.parse(request.query_string, secret)
    sso.email = current_user.email
    sso.name = current_user.username
    sso.username = current_user.email
    sso.external_id = current_user.id
    sso.avatar_url = current_user.gravatar_url(default: 'identicon')
    sso.avatar_force_update = true
    sso.sso_secret = secret

    redirect_to sso.to_url('https://forum.arcturus.io/session/sso_login')
  end

  private

  def secret
    'QHXSWKWmTfF5p5uus4eTTycH'
  end
end
