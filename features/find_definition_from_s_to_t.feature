Feature: Find definition of word from language S to T
  As a user
  I want to find the definition of a word or idiom from language S to T
  So that I can increase my vocabulary.

  S  can be  the same  as T,  in  which case  we want  the meaning  in the  same
  language, kind of like an encyclopedia.

  Scenario Outline: Define in non-interactive version
    Given I have the text "<text>"
    When I run the translator with S being "<source>" and T being "<target>"
    Then I should see "<translation>" in the output

    Scenarios: valid words
      | text          | source  | target  | translation   |
      | translate     | en      | es      | traducir      |
      | traducir      | es      | en      | translate     |
      | alibi         | en      | es      | coartada      |
      | fácil         | es      | en      | easy          |
      | gracias       | es      | ja      | どうも        | 
      | literally     | en      | fr      | littéralement |
      | montaña       | es      | pt      | montanha      |
      | mujer         | es      | ru      | женщина       |
      | play          | en      | es      | jugar         |


  Scenario Outline: Define in interactive mode
    Given I started the translator with source "<source>", target "<target>", and no text
    When I enter "<text>"
    Then the program should output "<translation>"

    Scenarios: valid words
      | text          | source  | target  | translation   |
      | translate     | en      | es      | traducir      |
      | traducir      | es      | en      | translate     |
      | alibi         | en      | es      | coartada      |
      | fácil         | es      | en      | easy          |
      | gracias       | es      | ja      | どうも        | 
      | literally     | en      | fr      | littéralement |
      | montaña       | es      | pt      | montanha      |
      | mujer         | es      | ru      | женщина       |
      | play          | en      | es      | jugar         |
