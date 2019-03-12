Feature: Creating and fetching a customer

  Scenario: Is service there
    When I GET /ping
    Then response code should be 200