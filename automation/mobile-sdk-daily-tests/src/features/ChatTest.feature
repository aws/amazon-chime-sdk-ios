Feature: Chat
  As a developer
  I want to see if messages can be sent and received

  Background:
    Given Meeting has been created with old messages
    And I switch tab 'Chat'

  @chat @common
  Scenario: Verify that I can see the old messages upon join
    Then I should be able to see old messages

  @chat @common
  Scenario: Verify that I can receive and send message
    Given I send a message 'How are you?'
    Then Helper should be able to see the message 'How are you?'
    Given Helper sends a message 'I'm good, thanks!'
    Then I should be able to see the message 'I'm good, thanks!'
