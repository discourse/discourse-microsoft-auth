# frozen_string_literal: true

# name: discourse-microsoft-auth
# about: Enable Login via Microsoft Identity Platform
# version: 1.0
# authors: Matthew Wilkin
# url: https://github.com/discourse/discourse-microsoft-auth

require_relative "lib/omniauth-microsoft365"

enabled_site_setting :microsoft_auth_enabled

register_svg_icon "fab-microsoft"

class ::MicrosoftAuthenticator < ::Auth::ManagedAuthenticator
  def name
    'microsoft_office365'
  end

  def register_middleware(omniauth)
    omniauth.provider :microsoft_office365,
                      setup: lambda { |env|
                        strategy = env['omniauth.strategy']
                        strategy.options[:client_id] = SiteSetting.microsoft_auth_client_id
                        strategy.options[:client_secret] = SiteSetting.microsoft_auth_client_secret

                        unless SiteSetting.microsoft_auth_tenant_id.empty?
                          strategy.options[:client_options] = {
                            site: 'https://login.microsoftonline.com',
                            token_url: "/#{SiteSetting.microsoft_auth_tenant_id}/oauth2/v2.0/token",
                            authorize_url: "/#{SiteSetting.microsoft_auth_tenant_id}/oauth2/v2.0/authorize"
                          }
                        end
                      }
  end

  def enabled?
    SiteSetting.microsoft_auth_enabled
  end
end

auth_provider authenticator: MicrosoftAuthenticator.new,
              icon: "fab-microsoft"
