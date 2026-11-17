Feature: Video
  As a developer
  I want to see if video is playing

  Scenario Outline: Verify that I and helper can see video
    Given Meeting has been created <option>
    And I switch tab 'Video'
    When Helper turns the video on
    Then I should be able to see remote video
    @video @common
    Examples:
      | option                |
      | without CallKit       |

    @callkit-video @callkit
    Examples:
      | option                |
      | with CallKit outgoing |
      | with CallKit incoming |

  Scenario Outline: Verify that I can see local video on and off
    Given Meeting has been created <option>
    And I switch tab 'Video'
    When I turn the video on
    Then I should be able to see local video
    When I turn the video off
    Then I should not be able to see local video tile
    @video @common
    Examples:
      | option                |
      | without CallKit       |

    @callkit-video @callkit
    Examples:
      | option                |
      | with CallKit outgoing |
      | with CallKit incoming |
