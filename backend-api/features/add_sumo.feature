Feature: Add Sumo

  Background:
    Given initial setup is complete
    And I am logged in

  Scenario: Should add a sumo
    Given I have a sumo business with id 1
    When I create business by sending POST request to http://localhost:8000/counter/resource
      """
      {
        "business_id": {business_id},
        "resource_type": "sumo",
        "number": "Ba 4 Pa 2345"
      }
      """
    Then I should receive JSON response
      """
      {
        "data": {
          "id": 1,
          "group_letter": null,
          "name": "Ba 4 Pa 2345",
          "capacity": null,
          "business": {
            "id": 1,
            "name": "some business",
            "address": "Some street 1",
            "owner": 1,
            "creator": 1,
            "business_type": 1,
            "resource_type": 1
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
