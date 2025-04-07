# Vonage Video API Demo

This is a demo application built in Ruby using [Ruby on Rails](https://rubyonrails.org/) and the [Vonage Ruby SDK](https://github.com/Vonage/vonage-ruby-sdk) to demonstrate the basic functionality of the [Vonage Verify API](https://developer.vonage.com/en/verify/overview).

## Pre-requisites

To run this demo locally you will need:

- A [Vonage Developer account](https://developer.vonage.com/sign-up)
- [Ruby](https://www.ruby-lang.org/en/) installed

## Setting up your Vonage Application

You'll need to set up a Vonage application to manage the capabilities and obtain the API credentials for this app.

1. Log onto the [Vonage Developer Dashboard](https://dashboard.nexmo.com/)

2. Go to the [Applications](https://dashboard.nexmo.com/applications) page and click on the  'Create a new application' button

3. Generate a private key for the application by clicking on the 'Generate public and private key' button. Download the `private.key` file and keep it somewhere safe.

4. Under 'Capabilities', enable the application for **Verify V2** by toggling the switch to 'on'.

5. Click on the 'Generate new application' button at the bottom. This will generate and Application ID for the Vonage application; make a note of this or copy it to your clipboard for later.

## Running the Demo Locally

1. Open Terminal and navigate to wherever you want to clone the repository.

2. Clone the repository
    ```
    git clone https://github.com/Vonage-Community/demo-verify-ruby_on_rails-swag_order.git
    ```

3. Change directory (`cd`) into the root directory of the cloned repository and install the dependencies
    ```
    bundle install
    ```

4. Run the database migrations:
    ```
    rails db:migrate
    ```

5. Copy or move the `private.key` file you downloaded earlier the root directory of this demo application

6. Copy or rename the `.env-example` file to `.env` and update the file with your Vonage credentials:
    - `VONAGE_APPLICATION_ID`. This is the Application ID you generated earlier when creating the Vonage Application

7. Start the Rails application
    ```
    rails s
    ```

8. In your browser, navigate to `localhost:3000`. The demo should now be running in the browser.

9. The log-in functionality of the demo requires a `User` record to exist in the database. You can create a user locally by using the Rails Console. In a separate Terminal tab, open the Rails console:
    ```
    rails c
    ```

10. Create a user record in the Rails console:
    ```
    User.create!(username: 'YOUR-USERNAME', password: 'YOUR-PASSWORD', phone_number: 'YOUR-PHONE_NUMBER')
    ```
    > Note: the phone number should be the number for the mobile device being used at the booth