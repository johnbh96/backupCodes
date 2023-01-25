Feature: Load Configurations

  Background:
    Given initial setup is complete
    And I am logged in

  Scenario: List available business types
    Given I send GET request to http://localhost:8000/counter/business/types
    Then I should receive JSON response
      """
      {
        "data": [
          {
            "id": 1,
            "name": "transport",
            "label_singular": "Transport",
            "label_plural": "Transports",
            "description": ""
          },
          {
            "id": 2,
            "name": "salon",
            "label_singular": "Salon",
            "label_plural": "Salons",
            "description": "Haircut, Beauty"
          }
        ]
      }
      """

  Scenario: List resource option for Transport
    Given I send GET request to http://localhost:8000/counter/business/type/transport/options
    Then I should receive JSON response
      """
      {
        "data": [
          {
            "id": 2,
            "name": "sumo",
            "description": "Sumo with 9 seat capacity",
            "group_type": "Individual",
            "capacity_type": "SeatTemplate",
            "default_capacity": null,
            "duration_type": "TimeTabled",
            "label_singular": "Sumo",
            "label_plural": "Sumo(s)"
          }
        ]
      }
      """

  Scenario: List Sumo seat template
    Given I send GET request to http://localhost:8000/counter/resource/type/sumo/template
    Then I should receive JSON response
      """
      {
        "data": {
          "id": 3,
          "name": "1x4x4",
          "row_count": 3,
          "column_count": 4,
          "seats": [
            {
              "id": 25,
              "row_index": 0,
              "column_index": 0,
              "is_hidden": false,
              "is_disabled": false
            },
            {
              "id": 26,
              "row_index": 0,
              "column_index": 1,
              "is_hidden": false,
              "is_disabled": false
            },
            {
              "id": 27,
              "row_index": 0,
              "column_index": 2,
              "is_hidden": true,
              "is_disabled": true
            },
            {
              "id": 28,
              "row_index": 0,
              "column_index": 3,
              "is_hidden": true,
              "is_disabled": true
            },
            {
              "id": 29,
              "row_index": 1,
              "column_index": 0,
              "is_hidden": false,
              "is_disabled": false
            },
            {
              "id": 30,
              "row_index": 1,
              "column_index": 1,
              "is_hidden": false,
              "is_disabled": false
            },
            {
              "id": 31,
              "row_index": 1,
              "column_index": 2,
              "is_hidden": false,
              "is_disabled": false
            },
            {
              "id": 32,
              "row_index": 1,
              "column_index": 3,
              "is_hidden": false,
              "is_disabled": false
            },
            {
              "id": 33,
              "row_index": 2,
              "column_index": 0,
              "is_hidden": false,
              "is_disabled": false
            },
            {
              "id": 34,
              "row_index": 2,
              "column_index": 1,
              "is_hidden": false,
              "is_disabled": false
            },
            {
              "id": 35,
              "row_index": 2,
              "column_index": 2,
              "is_hidden": false,
              "is_disabled": false
            },
            {
              "id": 36,
              "row_index": 2,
              "column_index": 3,
              "is_hidden": false,
              "is_disabled": false
            }
          ]
        }
      }
      """
