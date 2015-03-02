Feature: Allow the user pass options to the program.
  As a user
  I want to be able to pass options to the program
  So that I can change the behaviour or the result.

  Scenario Outline: Wrong options
    Given I execute the program with "<option>"
    Then it should fail with "<error_message>"

    Scenarios:
      | option            | error_message     |
      | --info *#!_?-     | Unknown service   |

  Scenario Outline: Good options
    Given I execute the program with "<option>"
    Then I should see "<output>" in the output

    Scenarios:
      | option            | output            |
      | --info google     | Google Translate  |
      | --version         | tli version       |
