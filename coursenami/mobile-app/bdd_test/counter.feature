// ignore_for_file: unused_import, directives_ordering, always_specify_types

Feature: Counter App Running
    Scenario: Initially the counter value is not greater than 0 when the app starts for the first time
        Given the app is running
        Then I See {'0'} text
        Then I See {Icons.arrow_forward} icon
        Then I See {Icons.arrow_back} icon

     Scenario: Arrow Forward button increases the counter value
        Given the app is running
        When I Tap {Icons.arrow_forward} icon
        Then I See {'1'} text
