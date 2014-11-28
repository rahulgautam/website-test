Feature: Gift voucher redemption

  As an existing user
  I want to redeem a voucher
  In order to get a gift credit to my account

  Background:
    Given I am signed in
    And I am on the Voucher Redemption page

  @smoke @production
  Scenario: Voucher Redemption page
    When I am on the Voucher Redemption page
    Then Voucher Redemption form should be displayed

  #Please input a valid voucher code below before running the scenario
  #TODO: to make this scenario fully automated, we can make an API call to voucher generator service to generate a new voucher code on a test environment
  @smoke @pending
  Scenario: User redeems a valid voucher code
    When I submit a valid voucher code "<a_valid_voucher_code>"
    And I confirm the voucher redemption
    Then the redemption confirmation message is displayed

  @negative @smoke
  Scenario Outline: Invalid or expired voucher code is rejected by the server
    When I submit an invalid voucher code "<invalid_code>"
    Then "<error_message>" error message is displayed

  Examples:
    | invalid_code     | error_message                                           |
    | CPBGFWUSDSFPG7HP | is past its use by date. Sorry, it's no longer valid.   |
    | 1234567890abcdef | doesn't exist! Keep an eye out for typos and try again. |

  @negative @production
  Scenario Outline: Voucher code validation on the client side
    When I submit an invalid voucher code "<invalid_code>"
    Then "<error_message>" error message is displayed

  Examples:
    | invalid_code      | error_message                                                                |
    | 123D!@£           | That code isn't quite right - it should be a combo of 16 letters and numbers |
    | 12D4567890        | That code's a bit short – it should be a combo of 16 letters and numbers     |
    | 11DB1111111111111 | That code's a bit long – it should be a combo of 16 letters and numbers      |

  @negative @production
  Scenario: Non-allowed characters in the voucher code are highlighted by the client side validation straight away
    When I start to enter a voucher code with special characters
    Then "Just letters and numbers please, e.g. A9K2" error message is displayed

  @pending
  Scenario: User makes a mistake in the voucher code and corrects it
    When I submit an invalid voucher code
    Then voucher validation error is displayed
    When I submit a valid voucher code
    Then the redemption confirmation message is displayed

  @manual
  Scenario Outline: Voucher code has been used before user confirms the redemption
    When I submit a valid voucher code
    But my wife redeems the voucher on <account> account at the same time
    When I confirm the voucher redemption
    Then Already used error message id displayed

  Examples:
    | account     |
    | the same    |
    | a different |

