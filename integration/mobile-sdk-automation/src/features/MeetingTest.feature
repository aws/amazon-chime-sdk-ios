Feature: Meeting
  As a developer
  I want to be able to see attendee change real time

  Scenario Outline: Verify that I can see helper attendee change
    Given Meeting has been created <option>
    And I switch tab 'Attendee'
    Given Other participant joined
    When Helper leaves the meeting
    Then I am able to see other participant disappeared
    When Helper joins back the meeting
    Then I am able to see other participant appeared
    @meeting @common
    Examples:
      | option                |
      | without CallKit       |

    @callkit-meeting @callkit @callkit-stable
    Examples:
      | option                |
      | with CallKit outgoing |
      | with CallKit incoming |

  Scenario Outline: Verify that I can see self attendee change
    Given Meeting has been created <option>
    And I switch tab 'Attendee'
    Given Helper is able to see other participant
    When I leave the meeting
    Then Helper is not able to see me
    @meeting @common
    Examples:
      | option                |
      | without CallKit       |

    @callkit-meeting @callkit @callkit-stable
    Examples:
      | option                |
      | with CallKit outgoing |
      | with CallKit incoming |
