Feature: ActiveSpeaker
  As a developer
  I want to be able to test active speaker

  Scenario Outline: Verify that I can see active speaker
    Given Meeting has been created <option>
    And I switch tab 'Attendee'
    Then I can see helper as active speaker
    @active @common
    Examples:
      | option                |
      | without CallKit       |

    @callkit-active @callkit @@callkit-stable
    Examples:
      | option                |
      | with CallKit outgoing |
      | with CallKit incoming |