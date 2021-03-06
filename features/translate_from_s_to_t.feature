Feature: Translate from language S to T
  As a user
  I want to translate text from language S to language T
  So that I can know the the equivalent version of my text in other language.

  This program works either in interactive and non-interactive mode, languages
  S and T will be passed as  parameters or read from a configuration file. The
  text  will be  passed as  one or  more parameters  or typed  by the  user in
  interactive mode.

  Scenario Outline: Translate in non-interactive mode
    Given I have the text "<text>"
    When I run the translator with S being "<source>" and T being "<target>"
    Then I should see "<translation>" in the output

    Scenarios:
      | text                    | source  | target  | translation         |
      | What is your name?      | en      | es      | Cuál es tu nombre?  |
      | Que tengas un buen día. | es      | en      | Have a good day.    |
      | Que tengas un buen día. | es      | ru      | Хорошего дня.       |
      | See you soon.           | en      | es      | pronto              |
      | Mon ami.                | fr      | es      | amigo               |


  Scenario Outline: Translate in interactive mode
    Given I started the translator with source "<source>", target "<target>", and no text
    When I enter "<text>"
    Then the program should output "<translation>"

    Scenarios:
      | text                    | source  | target  | translation         |
      | What is your name?      | en      | es      | Cuál es tu nombre?  |
      | Take it easy!           | en      | es      | Tómalo con calma!   |
      | Que tengas un buen día. | es      | en      | Have a good day.    |
      | Que tengas un buen día. | es      | ru      | Хорошего дня.       |
      | See you soon.           | en      | es      | Hasta pronto.       |
      | Mon ami.                | fr      | es      | Mi amigo.           |


#  Scenario Outline: Play translation in non-interactive mode
#    Given I have the text "<text>"
#    When I run the translator with the --play option, S being "<source>" and T being "<target>"
#    Then I should see "<translation>" in the output
#    And I should see "♬" in the output
#
#    Scenarios:
#      | text      | source  | target  | translation   | 
#      | book      | en      | es      | libro         |

  Scenario Outline: Play translation in interactive mode
    Given I started the translator with the --play option, source "<source>", target "<target>", and no text
    When I enter "<text>"
    Then the program should output "<translation>"
    Then the program should output "♬"

    Scenarios:
      | text      | source  | target  | translation   | 
      | book      | en      | es      | libro         |
