Feature: Source and target should be validated

  Scenario: Source should be valid
    Given I run the application with options "--source es --target whatever"
    Then the application should fail with "Unknown language code"

