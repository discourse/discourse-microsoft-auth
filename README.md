# Office365 OAuth Login Plugin
This plugin adds support logging in via Office365.

Admin Settings  
![](https://raw.githubusercontent.com/cpradio/discourse-plugin-office365-auth/master/screenshot-admin-settings.png)

Login Screen  
![](https://raw.githubusercontent.com/cpradio/discourse-plugin-office365-auth/master/screenshot-login-screen.png)

## How to Help

- Create a PR with a new translation!
- Log Issues
- Submit PRs to help resolve issues

## Installation

1. Follow the directions at [Install a Plugin](https://meta.discourse.org/t/install-a-plugin/19157) using https://github.com/cpradio/discourse-plugin-office365-auth.git as the repository URL.
2. Rebuild the app using `./launcher rebuild app`
3. Visit https://dev.outlook.com/appregistration and follow the directions for [creating an application](https://www.linkedin.com/secure/developer?newapp=), or look up the details of your [existing application](https://apps.dev.microsoft.com/).
  a. Generate a New Password under Application Secrets (copy the password, you will need it for your admin settings in Discourse)
  b. Add a Web Platform
  c. Add your website as a redirect uri using  
     `https://example.com/auth/microsoft_office365/callback`  
     (Office 365 requires HTTPS, this will not work without it)
  d. Add a Delegated Permission of `User.Read`
  e. Make sure `Live SDK support` is checked.
4. Update the plugin settings in the Admin > Settings area.

## Authors

Matthew Wilkin

## License

GNU GPL v2