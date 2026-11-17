Feature: Metric
  As a developer
  I want to see if metric is getting

  Scenario Outline: Verify that I can see metric
    Given Meeting has been created <option>
    And I switch tab 'Metrics'
    Then I should be able to see metric
    @metric @common
    Examples:
      | option                |
      | without CallKit       |

    @callkit-metric @callkit
    Examples:
      | option                |
      | with CallKit outgoing |
      | with CallKit incoming |
