# frozen_string_literal: true

class MicrosoftAuthenticator < ::Auth::ManagedAuthenticator
  def name
    "microsoft_office365"
  end

  def register_middleware(omniauth)
    omniauth.provider :microsoft_office365,
                      setup:
                        lambda { |env|
                          strategy = env["omniauth.strategy"]
                          strategy.options[:client_id] = SiteSetting.microsoft_auth_client_id
                          strategy.options[
                            :client_secret
                          ] = SiteSetting.microsoft_auth_client_secret
                        }
  end

  def enabled?
    SiteSetting.microsoft_auth_enabled
  end

  def primary_email_verified?(auth_token)
    SiteSetting.microsoft_auth_email_verified
  end
end
