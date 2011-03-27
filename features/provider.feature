@provider
Feature: OAI Providers
  As an administrator
  In order to configure OAI providers
  I want a page that allows me to manipulate OAI providers

    Scenario: Index page
        When I am on the providers page
        Then I should see "Listing providers"

