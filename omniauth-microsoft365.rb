# frozen_string_literal: true

require "omniauth/strategies/oauth2"

module OmniAuth
  module Strategies
    class MicrosoftOffice365 < OmniAuth::Strategies::OAuth2
      option :name, :microsoft_365

      DEFAULT_SCOPE = "openid email profile https://graph.microsoft.com/User.Read"

      option :client_options,
        site: 'https://login.microsoftonline.com',
        authorize_url: '/common/oauth2/v2.0/authorize',
        token_url: '/common/oauth2/v2.0/token'

      option :authorize_options, [:scope]

      uid { raw_info["id"] }

      info do
        {
          name: raw_info['displayName'] || raw_info['userPrincipalName'],
          email: raw_info['mail'] || raw_info['userPrincipalName']
        }
      end

      extra do
        {
          "raw_info" => raw_info
        }
      end

      def raw_info
        @raw_info ||= access_token.get('https://graph.microsoft.com/v1.0/me').parsed
      end

      def authorize_params
        super.tap do |params|
          %w[display score auth_type].each do |v|
            if request.params[v]
              params[v.to_sym] = request.params[v]
            end
          end

          params[:scope] ||= DEFAULT_SCOPE
        end
      end

      def callback_url
        full_host + script_name + callback_path
      end

      # alias :oauth2_access_token :access_token
      #
      # def access_token
      #   ::OAuth2::AccessToken.new(client, oauth2_access_token.token, {
      #     :mode => :query,
      #     :param_name => 'oauth2_access_token',
      #     :expires_in => oauth2_access_token.expires_in,
      #     :expires_at => oauth2_access_token.expires_at
      #   })
      # end

    end
  end
end
