Feature: Home Screen Drawer Navigation
    Scenario: when email and password are in specified format and login is clicked
        Given I have "drawerLogOff" and "LoginButton"
        When I open the drawer
        Then I tap the widget that contains the text "Log In"
        Then I wait until the "LoginPage" is present