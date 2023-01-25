Feature: Showing off behave

  Background:
    Given I am logged in

  @with-no-data
  Scenario: Run a simple test
    Given I create some questions
      | question_text | pub_date |
      | What is your first pet's name? | 2021-01-08 05:43:32.222983+00:00 |
      | What is the name of the town you were born | 2021-03-18 03:22:02.222977+00:00 |
     Then I should have 2 questions


  Scenario: Run another test
    Given I create some questions
      | question_text | pub_date |
      | What is your first pet's name? | 2021-01-08 05:43:32.222983+00:00 |
      | What is the name of the town you were born | 2021-03-18 03:22:02.222977+00:00 |
     Then I should have 4 questions
     When I send GET request to http://localhost:8000/counter/questions/
      Then I should receive JSON response
          """
          [
            "admin"
          ]
          """
