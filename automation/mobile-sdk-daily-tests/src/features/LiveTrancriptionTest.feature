Feature: Live transcription
  As a developer
  I want to see if transcripts are received

  Scenario Outline: Verify and Validate Transcripts being received
    Given Meeting has been created <option>
    When I mute button
    And I click AdditionalOptions button
    Then I can see AdditionalOptions dialog
    When I click TurnOnLiveTranscription button
    Then I click StartTranscriptionButton button
    And I switch tab 'Captions'
    When I play prerecorded speech
    Then I should be able to get precorded text as transcription message
    @transcription @common
    Examples:
      | option                |
      | without CallKit       |

    @callkit-transcription @callkit @callkit-stable
    Examples:
      | option                |
      | with CallKit outgoing |
      | with CallKit incoming |
