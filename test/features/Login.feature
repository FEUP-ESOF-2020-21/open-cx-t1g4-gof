Feature: Home Screen Drawer Navigation
    Scenario: when I am logged out and open the drawer and click the login button, I should go to the login page
        Given I have "drawerLogOff" and "LoginButton"
        When I open the drawer
        Then I tap the widget that contains the text "Log In"
        Then I wait until the "LoginPage" is present