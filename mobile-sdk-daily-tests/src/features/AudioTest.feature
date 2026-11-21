Feature: Audio
  As a developer
  I want to be able to test audio playing

  Scenario Outline: Verify that I can hear audio
    Given Meeting has been created <option>
    And I switch tab 'Attendee'
    Then I can hear sound from helper
    @audio @common
    Examples:
      | option                |
      | without CallKit       |

    @callkit-audio @callkit
    Examples:
      | option                |
      | with CallKit outgoing |
      | with CallKit incoming |

  Scenario Outline: Verify that I can mute self audio
    Given Meeting has been created <option>
    And I switch tab 'Attendee'
    When I click mute button
    And Helper clicks mute button
    Then Helper expects to see me muted
    And Helper expects to see helper muted
    And I expect to see me muted
    And I expect to see helper muted
    @audio @common
    Examples:
      | option                |
      | without CallKit       |

    @callkit-audio @callkit @callkit-stable
    Examples:
      | option                |
      | with CallKit outgoing |
      | with CallKit incoming |

  Scenario Outline: Verify that I can unmute self audio
    Given Meeting has been created <option>
    And I switch tab 'Attendee'
    When I click mute button
    Then Helper expects to see me muted
    And I expect to see me muted
    When I click mute button
    Then I expect to see me not muted
    And Helper expects to see me not muted
    @audio @common
    Examples:
      | option                |
      | without CallKit       |

    @callkit-audio @callkit @callkit-stable
    Examples:
      | option                |
      | with CallKit outgoing |
      | with CallKit incoming |
