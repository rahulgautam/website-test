@navigation
Feature: Navigation around the website
  As a user
  I want to be able to navigate around the website
  So that I can find the page I'm looking for

  Background:
    Given I am on the home page

  @smoke @production
  Scenario: Clicking on the website logo
    When I click on the website logo
    Then Home page is displayed

  @smoke @production
  Scenario: Clicking on the About Blinkbox Books
    When I click on the About Blinkbox Books link
    Then About Blinkbox Books page is displayed

  @smoke @wip @production
  Scenario: Clicking on the Sitemap link
    When I click on the Sitemap link
    Then Sitemap page is displayed

  @smoke @production
  Scenario: Navigating to the help site from the footer
    Given the blinkbox books help link is present in the footer
    Then the link should point to the blinkbox books help home page

  @smoke @production
  Scenario: Navigating to the blinkbox movies site from the footer
    Given the blinkbox movies link is present in the footer
    Then the link should point to the blinkbox movies home page

  @smoke @production
  Scenario: Navigating to the blinkbox music site from the footer
    Given the blinkbox music link is present in the footer
    Then the link should point to the blinkbox music home page

  @smoke @production
  Scenario: Navigate to Terms and Conditions page
    When I click on the Terms & conditions link
    Then Terms and conditions page is displayed

  @smoke @production
  Scenario: Navigate to categories page
    When I click on the Categories header tab
    Then Categories page is displayed
    And main footer is displayed

  @CWA-71 @smoke @production
  Scenario: Navigate to Bestsellers page
    When I click on the Bestsellers header tab
    Then Bestsellers page is displayed
    And Bestsellers section header is Bestsellers Top 100 this month
    And I should see 'Fiction' and 'Non-Fiction' tabs
    And Grid view and List view buttons displayed
    And main footer is displayed

  @smoke @production
  Scenario: Navigate to New releases page
    When I click on the New releases header tab
    Then New releases page is displayed
    And New releases section header is New releases in the last 30 days
    And Grid view and List view buttons displayed
    And main footer is displayed

  @smoke @production
  Scenario: Navigate to Free books page
    When I click on the Free books header tab
    Then Free books page is displayed
    And Free books section header is Free books
    And Grid view and List view buttons displayed
    And main footer is displayed

  @smoke @production
  Scenario: Navigate to Authors page
    When I click on the Authors header tab
    Then I should be on the Authors page
    And Bestselling authors section header is Top 100 bestselling authors this month
    And main footer is displayed

  @smoke @production
  Scenario: Navigate to book details page
    When I select a book to view book details
    Then details page of the corresponding book is displayed
    And details of above book are displayed

  @smoke @production
  Scenario: Navigate to a Category page
    Given I am on Categories page
    When I click on a category
    Then Category page is displayed for the selected category

  @smoke @production
  Scenario: Read a sample
    When I select a book to view book details
    Then details page of the corresponding book is displayed
    And  the book reader is displayed
    And I am able to read the sample of corresponding book

  @CWA-87
  Scenario: Clicking browser back should load previous search results pages if any
    When I search for following words
      | words     |
      | da vinci  |
      | dan brown |
    And I press browser back
    And I should see search results page for "da vinci"

  @CWA-70
  Scenario: Main header tabs are not selected in search results page and footer is displayed
    When I search for "summer"
    Then search results should be displayed
    And main header tabs should not be selected
    And footer is displayed

  @CWA-105
  Scenario Outline: Search word should not visible upon user navigating to another page
    When I search for "dan brown"
    Then "dan brown" should be visible in search bar
    And I click on the <page> link
    Then search term should not be visible in search bar
  Examples:
    | page         |
    | Featured     |
    | Categories   |
    | Bestsellers |
    | New releases |
    | Free books   |
    | Authors      |

  @CWA-71 @wip
  Scenario: Promotable category-All time best selling books
    When I click on the Bestsellers link
    Then Bestsellers page is displayed
    And I should see Promotions section header as All time best selling books
    And I should see 5 books being displayed

  @CWA-71
  Scenario: Bestsellers page - Switching views
    When I click on the Bestsellers link
    Then Bestsellers page is displayed
    And I select grid view
    Then I should see Fiction books in gird view
    And I select list view
    Then I should see Fiction books in list view

  @CWA-71
  Scenario: Bestsellers page - Grid view not changing between tabs
    When I click on the Bestsellers link
    Then Bestsellers page is displayed
    And I select grid view
    Then I should see Fiction books in gird view
    And I click on Non-Fiction tab
    Then I should see Non-Fiction books in gird view

  @CWA-71
  Scenario: Bestsellers page - List view not changing between tabs
    When I click on the Bestsellers link
    Then Bestsellers page is displayed
    And I select list view
    Then I should see Fiction books in list view
    And I click on Non-Fiction tab
    Then I should see Non-Fiction books in list view

  @CWA-34 @manual
  Scenario:Book Component-List view Title display
    When I click on the Bestsellers link
    Then Bestsellers page is displayed
    And  I select list view
    Then long titles should be displayed in two lines

  @CWA-34  @manual
  Scenario:Book Component-Grid view Title display
    When I click on the Bestsellers link
    Then Bestsellers page is displayed
    And  I select grid view
    Then long titles should be truncated to fit within image
