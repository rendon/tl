Feature: Display information of a given translation service
  As a user
  I want to get detailed information of given translation service
  So that I can know better where my results come from and what languages does that service support.

  Scenario Outline: Display service info
    Given I execute the program with "<option>"
    Then I should see "<service_name>" in the output
    And I should see "Supported languages:" in the output

    Scenarios:
      | option            | service_name      |
      | --info google     | Google Translate  |
