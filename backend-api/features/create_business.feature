Feature: Create Business

  Background:
    Given initial setup is complete
    And I am logged in

  Scenario: Should not create a business with empty data
    Given I send POST request to http://localhost:8000/counter/business
        """
        """
    Then I should receive JSON response
        """
        {
          "errors": {
            "name": [
              "This field is required."
            ],
            "business_type_name": [
              "This field is required."
            ],
            "resource_type_name": [
              "This field is required."
            ],
            "address": [
              "This field is required."
            ]
          }
        }
        """

  Scenario: Should not create a business with invalid business type
    Given I send POST request to http://localhost:8000/counter/business
        """
        {
          "name": "My Business",
          "business_type_name": "retail",
          "resource_type_name": "shorts",
          "address": "Hetauda, Nepal"
        }
        """
    Then I should receive JSON response
        """
        {
          "errors": {
            "business_type_name": [
              "Invalid business type name"
            ],
            "resource_type_name": [
              "Invalid resource type name"
            ]
          }
        }
        """

  Scenario: Create a vehicle booking business
    Given I send POST request to http://localhost:8000/counter/business
        """
        {
          "name": "My Business",
          "business_type_name": "transport",
          "resource_type_name": "sumo",
          "address": "Hetauda, Nepal"
        }
        """
    Then I should receive JSON response
      """
      {
        "data": {
          "id": 1,
          "name": "My Business",
          "address": "Hetauda, Nepal",
          "business_type": {
            "id": 1,
            "name": "transport",
            "label_singular": "Transport",
            "label_plural": "Transports",
            "description": ""
          },
          "resource_type": {
            "id": 1,
            "name": "sumo",
            "description": "Sumo with 9 seat capacity",
            "group_type": "Individual",
            "capacity_type": "SeatTemplate",
            "default_capacity": null,
            "duration_type": "TimeTabled",
            "label_singular": "Sumo",
            "label_plural": "Sumo(s)"
          }
        }
      }
      """
