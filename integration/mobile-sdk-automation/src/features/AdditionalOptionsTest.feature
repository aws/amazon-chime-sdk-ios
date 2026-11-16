Feature: AdditionalOptions
  As a developer
  I want to be able to test additional options

  Scenario Outline: Verify that I can toggle VoiceFocus
    Given Meeting has been created <option>
    And I click AdditionalOptions button
    Then I can see AdditionalOptions dialog
    When I click TurnOffVoiceFocus button
    Then I cannot see AdditionalOptions dialog
    When I click AdditionalOptions button
    Then I can see TurnOnVoiceFocus button
    @audio @common @voice-focus
    Examples:
      | option                |
      | without CallKit       |

    @callkit-audio @callkit @callkit-stable
    Examples:
      | option                |
      | with CallKit outgoing |
      | with CallKit incoming |
