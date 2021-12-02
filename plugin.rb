# frozen_string_literal: true

# name: discourse-plugin-office365-auth
# about: Enable Login via Office365
# version: 1.0
# authors: Matthew Wilkin
# url: https://github.com/discourse/discourse-plugin-office365-auth

require_relative "lib/omniauth-microsoft365"

enabled_site_setting :office365_enabled

class ::Office365Authenticator < ::Auth::ManagedAuthenticator
  def name
    'microsoft_office365'
  end

  def register_middleware(omniauth)
    omniauth.provider :microsoft_office365,
                      setup: lambda { |env|
                        strategy = env['omniauth.strategy']
                        strategy.options[:client_id] = SiteSetting.office365_client_id
                        strategy.options[:client_secret] = SiteSetting.office365_secret
                      }
  end

  def enabled?
    SiteSetting.office365_enabled
  end
end

auth_provider authenticator: Office365Authenticator.new
