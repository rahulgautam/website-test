@register @ie @safari
Feature: Register a new Blinkbox books user
  As a guest user of Blinkbox books
  I want to sign up
  So that I can buy and read books

  Background:
    Given I am a guest user

  @smoke
  Scenario: Happy path-register user
    Given I am on Register page
    When I enter valid personal details
    And I choose a valid password
    And I accept terms and conditions
    And I submit registration details
    Then Registration success page is displayed
    And welcome message is shown

  Scenario: Happy path register user with a valid club card number
    Given I am on Register page
    When I enter personal details with valid clubcard number
    And I choose a valid password
    And I submit registration details by accepting terms and conditions
    Then Registration success page is displayed
    And welcome message is shown

  @negative
  Scenario: Submit registration details with already existing email address
    Given I am on Register page
    When I enter registration details with already registered email address
    And I submit registration details by accepting terms and conditions
    Then registration is not successful
    And "This email address is already registered with blinkbox books" message is displayed
    And link to sign in with already registered email address is displayed

  @negative
  Scenario: Submit registration details without accepting blinkbox books terms and conditions
    Given I am on Register page
    When I enter valid registration details
    And I submit registration details by not accepting terms and conditions
    Then registration is not successful
    And "Please accept the blinkbox books terms & conditions" message is displayed

  @negative
  Scenario: Submit registration details when passwords not matching
    Given I am on Register page
    When I enter valid personal details
    And type passwords that are not matching
    And I submit registration details by accepting terms and conditions
    Then registration is not successful
    And  "Your passwords don't match, please check and try again" message is displayed

  @negative
  Scenario: Submit registration details with password less than 6 characters
    Given I am on Register page
    When I enter valid personal details
    And type passwords that are less than 6 characters
    And I submit registration details by accepting terms and conditions
    Then registration is not successful
    And "Your password is too short" message is displayed

  @negative
  Scenario: Submit registration details with empty password
    Given I am on Register page
    When I enter valid personal details
    But I leave the password field empty
    And I submit registration details by accepting terms and conditions
    Then registration is not successful
    And "Please enter your password" message is displayed
    And "Your passwords don't match, please check and try again" message is displayed

  @negative
  Scenario: Submit registration details with invalid clubcard number
    Given I am on Register page
    When I enter personal details with invalid clubcard number
    And I choose a valid password
    And I submit registration details by accepting terms and conditions
    Then registration is not successful
    And "This Tesco Clubcard number doesn't seem to be correct. Please check and try again" message is displayed

  Scenario: Click sign in with already registered email link
    Given I am on Register page
    And I have attempted to register with already registered email address
    And link to sign in with already registered email address is displayed
    When I click on link to sign in with already registered email
    Then Sign in page is displayed

  Scenario: Verify promotion check box is ticked by default
    Given I am on Register page
    And promotion checkbox is ticked by default

  Scenario: Tick to show password after entering passwords
    Given I am on Register page
    When I enter password on register screen
    And I tick show password while typing checkbox
    Then check passwords shows in text on register screen

  Scenario: Check password is hidden as you type
    Given I am on Register page
    When I enter password on register screen
    Then check passwords are hidden on register screen


