Feature: Cache results
  As a user
  I want to get save results of previous queries in my computer
  So that I can get results as quickly as possible.

  Scenario Outline: Cache text
    Given I translated the text "<text>" from "<source>" to "<target>" and cached the result
    When I run the translator with S being "<source>" and T being "<target>"
    Then I should see "<translation>" in the output
    And the translation should come from the local database

    Scenarios:
      | text                    | source  | target  | translation         |
      | What is your name?      | en      | es      | Cuál es tu nombre?  |
      | Take it easy!           | en      | es      | Tómalo con calma!   |
