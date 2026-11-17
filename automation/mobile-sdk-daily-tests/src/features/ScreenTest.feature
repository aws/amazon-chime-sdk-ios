Feature: Screen
  As a developer
  I want to see if screen is shown and shared properly

  Scenario Outline: Verify that I can start screen share for certain OS version, and can see if screen is shared from remote
    Given Meeting has been created <option>
    When I share the screen
    Then I should be able to see the local content attendee
    When I switch tab 'Metrics'
    Then I should be able to see content share metrics
    Given I switch tab 'Screen'
    When Helper shares the screen
    Then I should be able to see screen
    Given I switch tab 'Attendee'
    Then I should not be able to see the local content attendee
    @screen @common
    Examples:
      | option                |
      | without CallKit       |

    @callkit-screen @callkit
    Examples:
      | option                |
      | with CallKit outgoing |
      | with CallKit incoming |