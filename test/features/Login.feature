Feature: Login screen Validates and then Logs In
    Scenario: when email and password are in the specified format and login is clicked
        Given I have "emailfield" and "passfield" and "loginButton"
        When I fill "emailfield" field with "testemail@test.com"
        And I fill "passfield" field with "testingPassword1"
        Then I tap the "loginButton" button
        Then I wait until the "HomePage" is present