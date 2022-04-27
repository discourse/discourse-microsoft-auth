# frozen_string_literal: true

# name: discourse-plugin-office365-auth
# about: Enable Login via Office365
# version: 0.0.1
# authors: Matthew Wilkin
# url: https://github.com/discourse/discourse-plugin-office365-auth

require 'auth/oauth2_authenticator'
require File.expand_path('../omniauth-microsoft365.rb', __FILE__)

enabled_site_setting :office365_enabled

class Office365Authenticator < ::Auth::OAuth2Authenticator
  PLUGIN_NAME = 'oauth-office365'

  def name
    'microsoft_office365'
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
    omniauth.provider :microsoft_office365,
                      setup: lambda { |env|
                        strategy = env['omniauth.strategy']
                        strategy.options[:client_id] = SiteSetting.office365_client_id
                        strategy.options[:client_secret] = SiteSetting.office365_secret

                        unless SiteSetting.office365_tenant_id.empty?
                          strategy.options[:client_options] = {
                            site: 'https://login.microsoftonline.com',
                            token_url: "/#{SiteSetting.office365_tenant_id}/oauth2/v2.0/token",
                            authorize_url: "/#{SiteSetting.office365_tenant_id}/oauth2/v2.0/authorize"
                          }
                        end
                      }
  end

  def enabled?
    SiteSetting.office365_enabled
  end
end

auth_provider enabled_setting: "office365_enabled",
              frame_width: 920,
              frame_height: 800,
              authenticator: Office365Authenticator.new(
                'microsoft_office365',
                trusted: true,
                auto_create_account: true
              )

register_css <<CSS

.btn-social.microsoft_office365 {
  background: #EB3D01;
}

CSS
