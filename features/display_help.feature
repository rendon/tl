Feature: Display help
  As a user
  I want to get help from program
  So that I can better understand how the program works.

  Scenario: Ask for help
    When I run the translator with the option "--help"
    Then it should pass with:
    """
    Usage: tli [options]
    """
