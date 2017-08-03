Feature: Email friends

  @rp_test
  Scenario Outline: As a Zoopla user I should be able to email my friends about a property that I like and send it to more than one friends
    Given I navigate to listing details page
    When I click on the link Email a friend
    And I fill in the email friend form details
      | name    | value                   |
      | name    | Sarah Harlequin         |
      | email   | sharlequin@zoopla.co.uk |
      | message | test message            |
    And I click on Tell another friends link to add my friends email address <number_of_friends>
    And I fill my friends email addresses <number_of_friends>
    When I click on button Send Email
    Then I should see the succesful message <message>
    And the browser's URL should contain the <path>
    Examples:
      | message   | path             | number_of_friends |
      | Thank you | /friend/success/ | 0                 |
      | Thank you | /friend/success/ | 3                 |
      | Thank you | /friend/success/ | 5                 |
