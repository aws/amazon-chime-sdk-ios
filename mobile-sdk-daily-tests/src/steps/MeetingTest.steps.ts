import { expect } from 'chai';
import { Given, When, Then } from 'cucumber';

import MeetingScreen from '../screens/MeetingScreen';
import { helperParticipant, targetParticipant } from '../constants';
import {
  waitForDisplayed,
  waitForDisplayedThenClick,
  waitForDisappeared,
} from '../utils/WaitForUtils';
import MeetingPage from '../pages/MeetingPage';
import { isSelf } from '../utils/MediaUtils';

Given(/^Other participant joined$/, function() {
  global.targetDevice.pause(2_500);
  expect(waitForDisplayed(MeetingScreen.participant(helperParticipant))).to.be.true;
});

Then(/^I am able to see other participant (appeared|disappeared)$/, function(appear: string) {
  // Appium is little unstable for real time change so giving little time to update
  global.targetDevice.pause(2_500);
  const appeared = appear === 'appeared';
  const displayFn = appeared ? waitForDisplayed : waitForDisappeared;
  expect(displayFn(MeetingScreen.participant(helperParticipant))).to.be.true;
});

// TODO: This might be fragile since it assumes that browser will save state
When(/^(I|Helper) leaves? the meeting$/, function(subject: string) {
  if (isSelf(subject)) {
    waitForDisplayedThenClick(MeetingScreen.leaveBtn);
  } else {
    MeetingPage.leaveMeeting();
  }
});

When(/^Helper joins back the meeting$/, function() {
  MeetingPage.rejoinMeeting();
});

Given(/^(I am|Helper is) able to see other participant$/, function(subject: string) {
  if (isSelf(subject)) {
    expect(waitForDisplayed(MeetingScreen.participant(helperParticipant))).to.be.true;
  } else {
    expect(waitForDisplayed(MeetingPage.findParticipant(targetParticipant))).to.be.true;
  }
});

Then(/^Helper is not able to see me$/, function() {
  expect(waitForDisappeared(MeetingPage.findParticipant(targetParticipant))).to.be.true;
});
