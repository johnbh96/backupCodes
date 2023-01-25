Feature: Update Business

  Background:
    Given I am logged in

  @wip
  Scenario: Do not update business with invalid types
    Given I have a business with id 1
    And I have no resource in business with id 1
    When I send PUT request to http://localhost:8000/api/business/1
      """
      {
        "name": "My Business",
        "businessType": 1,
        "resourceType": 2
      }
      """
    Then I should receive Bad Request response
      """
      {
        "error": {
          "resourceType": {
            "message": {
              "en-us": "Invalid Resource Type"
            },
            "debug": {
              "en-us": "Selected Resource Type 2 is not allowed to Business Type 1"
            }
          }
        }
      }
      """

  @wip
  Scenario: Do not update business if resource exists
    Given I have a business with id 1
    And I have some resources in business with id 1
    When I send PUT request to http://localhost:8000/api/business/1
      """
      {
        "name": "My Business",
        "businessType": 1,
        "resourceType": 2
      }
      """
    Then I should receive Bad Request response
      """
      {
        "error": {
          "all": {
            "message": {
              "en-us": "Not Allowed"
            },
            "debug": {
              "en-us": "Changing resource type for business with some resource already created is not allowed"
            }
          }
        }
      }
      """
