# Microsoft 365 OAuth Login Plugin
This plugin adds support logging in via Microsoft 365.

Admin Settings  
![](https://raw.githubusercontent.com/discourse/discourse-plugin-microsoft365-auth/master/screenshot-admin-settings.png)

Login Screen  
![](https://raw.githubusercontent.com/discourse/discourse-plugin-microsoft365-auth/master/screenshot-login-screen.png)

## How to Help

- Create a PR with a new translation!
- Log Issues
- Submit PRs to help resolve issues

## Prerequisites

First, you need access to an account in an Microsoft 365 Subscription. This can be an existing subscription you have for your work or business, an [Microsoft 365 Developer Subscription](http://dev.office.com/devprogram), or you can start with a [free 30-day trial](https://portal.office.com/Signup/Signup.aspx). 

The name on the subscription you use to register your app will show as the publisher for that app when users are prompted to give consent.

## Installation

1. Follow the directions at [Install a Plugin](https://meta.discourse.org/t/install-a-plugin/19157) using `https://github.com/discourse/discourse-plugin-microsoft365-auth.git` as the repository URL.

2. Rebuild the app using `./launcher rebuild app`

3. Visit https://dev.outlook.com/appregistration and follow the directions for [creating an application](https://apps.dev.microsoft.com/#/appList), or look up the details of your [existing application](https://apps.dev.microsoft.com/).
  * Generate a New Password under Application Secrets (copy the password, you will need it for your admin settings in Discourse). It is not necessary to create a Key Pair.
  * Click Add Platform and choose "Web"
  * Add your website as a Redirect URI in this format:  
     `https://`[YOUR_FORUM_FQDN]`/auth/microsoft_office365/callback`  
     (Note that Microsoft 365 requires HTTPS, this will not work without it)
  * Ensure that there is a Delegated Permission of `User.Read`
  * Leave the `Live SDK support` option checked.
  * Click Save, the Client ID will be visible in the My Applications list 
   
4. Update the plugin settings in the Admin > Settings > Plugins area.

## Authors

Matthew Wilkin

## License

GNU GPL v2
