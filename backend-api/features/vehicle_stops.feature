Feature: Manage Vehicle Stops

  Background:
    Given initial setup is complete
    And I am logged in

    @wip
    Scenario: Should not be able to add duplicate stop
      Given I have a sumo business with id 1
      And I have a stop with name Kathmandu
      When I create a sumo stop by sending POST request to http://localhost:8000/counter/stop
        """
        {
          "business_id": {business_id},
          "stop_name": "Kathmandu"
        }
        """
      Then I should receive 400 response
      And response should contain JSON
        """

        """

    @wip
    Scenario: Should be able to add vehicle stop
      Given I have a sumo business with id 1
      When I create a sumo stop by sending POST request to http://localhost:8000/counter/vehicle/stop
        """
        {
          "business_id": {business_id},
          "resource_type": "sumo",
          "number": "Ba 4 Pa 2345"
        }
        """
      Then I should receive JSON response
        """

        """

    @wip
    Scenario: Should not be able to delete Vehicle Stop if route exists
      Given I have a sumo business with id 1
      And I have a route from Kathmandu to Hetauda
      When I delete a sumo stop by sending DELETE request to http://localhost:8000/counter/stop/{hetauda_stop_id}
      Then I should receive 400 response
      And response should contain JSON
        """

        """

    @wip
    Scenario: Should not be able to delete Vehicle Stop if booking is available
      Given I have a sumo business with id 1
      And I have a booking available from Hetauda to Kathmandu
      When I delete a sumo stop by sending DELETE request to http://localhost:8000/counter/stop/{hetauda_stop_id}
      Then I should receive 400 response
      And response should contain JSON
        """
        """

    @wip
    Scenario: Should not be able to delete Vehicle Stop if booking was available
      Given I have a sumo business with id 1
      And I had a booking from Hetauda to Kathmandu
      When I delete a sumo stop by sending DELETE request to http://localhost:8000/counter/stop/{hetauda_stop_id}
      Then I should receive 400 response
      And response should contain JSON
        """
        """

    @wip
    Scenario: Should not be able to archive Vehicle Stop if booking is available
      Given I have a sumo business with id 1
      And I had a booking from Hetauda to Kathmandu
      When I delete a sumo stop by sending DELETE request to http://localhost:8000/counter/stop/{hetauda_stop_id}
      Then I should receive 400 response
      And response should contain JSON
        """
        """

    @wip
    Scenario: Should be able to archive Vehicle Stop if no booking is available
      Given I have a sumo business with id 1
      And I had a booking from Hetauda to Kathmandu
      When I delete a sumo stop by sending DELETE request to http://localhost:8000/counter/stop/{hetauda_stop_id}
      Then I should receive 400 response
      And response should contain JSON
        """
        """