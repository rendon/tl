Feature: Display supported translation services
  As a user
  I want to know  list available of translation services the translator supports
  So that I can issue a query to a specific translation service.

  Scenario: Display available services for translation
    Given I execute the program with "--lts"
    Then I should see "Available translation services" in the output
    And I should see "Google Translate" in the output
    And I should see "google" in the output
