Feature: Load settings from configuration file
  As a user
  I want to be able to configure the behavior of the program using a configuration file
  So that I don't have to specify all the options every time.

  Options passed directly to the program will OVERRIDE the options in the configuration file.

  #Scenario: Use source and target from configuration file
  #  Given this configuration file:
  #  """
  #  {
  #      "settings": {
  #          "source": "es", 
  #          "target": "en",
  #          "service": "yandex"
  #      }
  #  }
  #  """
  #  When I run the translator with text "fe"
  #  Then I should see "faith" in the output

  #Scenario: Use play option from configuration file
  #  Given this configuration file:
  #  """
  #  {
  #      "settings": {
  #          "source": "en", 
  #          "target": "es",
  #          "service": "yandex",
  #          "play": true
  #      }
  #  }
  #  """
  #  When I run the translator with text "admonition"
  #  Then I should see "amonestación" in the output
  #  And I should see "♬" in the output


  #Scenario: Command line options override config file settings
  #  Given this configuration file:
  #  """
  #  {
  #      "settings": {
  #          "source": "en", 
  #          "target": "es",
  #          "service": "yandex"
  #      }
  #  }
  #  """
  #  When I run the translator with target "fr" and text "song"
  #  Then I should see "chanson" in the output
