Feature: Translate from language S to T
  As a user
  I want to translate text from language S to language T
  So that I can know the the equivalent version of my text in other language.

  This program works either in interactive and non-interactive mode, languages
  S and T will be passed as  parameters or read from a configuration file. The
  text  will be  passed as  one or  more parameters  or typed  by the  user in
  interactive mode.

  Scenario: Translate in non-interactive mode
    Given I have the text "What is your name?"
    When I run the translator with S being "en" and T being "es"
    Then I should see "Cuál es tu nombre?"
