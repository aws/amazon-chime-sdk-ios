import { expect } from 'chai';
import { Then, When } from 'cucumber';

import MeetingPage from '../pages/MeetingPage';
import {
  waitForDisplayedThenClick,
  waitForExist,
  waitForDisplayedThenGetText,
} from '../utils/WaitForUtils';
import { parseString, compareTranscripts } from '../utils/TranscriptionUtils';
import MeetingScreen from '../screens/MeetingScreen';
import { expectedTranscribedMessage, SECONDS } from '../constants';
import LiveTranscriptionScreen from '../screens/LiveTranscriptionScreen';

const NUMBER_OF_TRANSCRIPT_ROWS = 6;

When(/^I mute button$/, function() {
  waitForDisplayedThenClick(MeetingScreen.toggleMuteBtn);
});

When(/^I click TurnOnLiveTranscription button$/, function() {
  waitForDisplayedThenClick(MeetingScreen.turnOnLiveTranscriptionButton);
});

Then(/^I can see TurnOffLiveTranscription button$/, function() {
  expect(waitForExist(MeetingScreen.turnOffLiveTranscriptionButton)).to.be.true;
});

When(/^I click TurnOffLiveTranscription button$/, function() {
  waitForDisplayedThenClick(MeetingScreen.turnOffLiveTranscriptionButton);
});

Then(/^I can see TurnOnLiveTranscription button$/, function() {
  expect(waitForExist(MeetingScreen.turnOnLiveTranscriptionButton)).to.be.true;
});

Then(/^I click StartTranscriptionButton button$/, function() {
  waitForDisplayedThenClick(LiveTranscriptionScreen.liveTranscriptionBtn);
});

When(/^I play prerecorded speech$/, function() {
  MeetingPage.playPrerecordedSpeech();
  global.targetDevice.pause(25 * SECONDS);
});

Then(/^I should be able to get precorded text as transcription message$/, function() {
  let transcribedMessage = '';

  for (let i = 1; i < NUMBER_OF_TRANSCRIPT_ROWS; i++) {
    try {
      const message = waitForDisplayedThenGetText(MeetingScreen.findMessage('caption-' + i), 3_000);
      transcribedMessage += message + ' ';
    } catch {
      break;
    }
  }

  const convertedTranscribedMessage = parseString(transcribedMessage);
  const expectedConvertedTranscribedMessage = parseString(expectedTranscribedMessage);

  const isTrue = compareTranscripts(
    convertedTranscribedMessage,
    expectedConvertedTranscribedMessage
  );

  expect(isTrue).to.be.true;
});
