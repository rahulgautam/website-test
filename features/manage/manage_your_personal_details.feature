Feature: Update the Personal details of the user under 'your account'
  As a singed in Blinkbox books user
  I need the ability to view my account page
  So I can view and update my personal details details
  #- Manage - Your personal details (8.3.0.0-L 1)

  Background:
    Given I am on the home page

  @CWA-213 @smoke
  Scenario: Successfully update Your personal information
    Given I have signed in
    And I am on the Your personal details tab
    When I edit the first name and last name
    And I submit my personal details
    Then "Your personal details have been successfully updated." message is displayed
    And the first name and last name are as submitted

  @smoke
  Scenario: Successfully update Your marketing preferences
    Given I have signed in
    And I am on the Your personal details tab
    When I edit marketing preferences
    And I submit my personal details
    Then "Your personal details have been successfully updated." message is displayed
    And marketing preferences are as submitted

  @smoke
  Scenario: Successfully update Email address
    Given I have registered as new user
    And I am on the Your personal details tab
    When I edit email address
    And I submit my personal details
    Then "Your personal details have been successfully updated." message is displayed
    And email address is as submitted


  @smoke
  Scenario: Successfully change password
    Given I have registered as new user
    And I am on the Change your password section
    When I change password
    And I click Confirm button
    Then password is updated