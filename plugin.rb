# frozen_string_literal: true

# name: discourse-plugin-microsoft365-auth
# about: Enable Login via Microsoft 365
# version: 0.0.1
# authors: Matthew Wilkin
# url: https://github.com/discourse/discourse-plugin-microsoft365-auth

require 'auth/oauth2_authenticator'
require File.expand_path('../omniauth-microsoft365.rb', __FILE__)

enabled_site_setting :microsoft_365_enabled

class Office365Authenticator < ::Auth::OAuth2Authenticator
  PLUGIN_NAME = 'oauth-microsoft365'

  def name
    'microsoft_365'
  end

  def after_authenticate(auth_token)
    result = super

    if result.user && result.email && (result.user.email != result.email)
      begin
        result.user.primary_email.update!(email: result.email)
      rescue
        used_by = User.find_by_email(result.email)&.username
        Rails.loger.warn("FAILED to update email for #{user.username} to #{result.email} cause it is in use by #{used_by}")
      end
    end

    result
  end

  def register_middleware(omniauth)
    omniauth.provider :microsoft_365,
                      setup: lambda { |env|
                        strategy = env['omniauth.strategy']
                        strategy.options[:client_id] = SiteSetting.microsoft_365_client_id
                        strategy.options[:client_secret] = SiteSetting.microsoft_365_secret
                      }
  end

  def enabled?
    SiteSetting.microsoft_365_enabled
  end
end

auth_provider title: 'with Microsoft 365',
              enabled_setting: "microsoft_365_enabled",
              message: 'Log in via Microsoft 365',
              frame_width: 920,
              frame_height: 800,
              authenticator: Office365Authenticator.new(
                'microsoft_365',
                trusted: true,
                auto_create_account: true
              )

register_css <<CSS

.btn-social.microsoft_365 {
  background: #EB3D01;
}

CSS
