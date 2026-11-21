import { expect } from 'chai';
import { Given, After } from 'cucumber';
import { v4 as uuidv4 } from 'uuid';

import MeetingScreen from '../screens/MeetingScreen';
import JoinScreen from '../screens/JoinScreen';
import MeetingPage from '../pages/MeetingPage';
import {
  helperParticipant,
  JOIN_OPTION,
  targetParticipant,
  oldMessageText1,
  oldMessageText2,
  SECONDS,
} from '../constants';
import { waitForDisplayedThenClick } from '../utils/WaitForUtils';

const { CAT_DEMO_URL } = process.env;

Given(/^Meeting has been created without CallKit$/, function() {
  joinMeeting(JOIN_OPTION.noCallKit);
});

Given(/^Meeting has been created with CallKit incoming$/, function() {
  joinMeeting(JOIN_OPTION.callKitIncoming);
});

Given(/^Meeting has been created with CallKit outgoing$/, function() {
  joinMeeting(JOIN_OPTION.callKitOutgoing);
});

Given(/^Meeting has been created with old messages$/, function() {
  const meetingId = `${uuidv4().substring(0, 14)}${new Date().getTime()}`;
  joinFromWeb(meetingId);
  MeetingPage.sendMessage(oldMessageText1);
  MeetingPage.sendMessage(oldMessageText2);
  joinFromMobile(meetingId, JOIN_OPTION.noCallKit);
});

const joinMeeting = (option: JOIN_OPTION) => {
  global.targetDevice.pause(2 * SECONDS);
  const meetingId = `${uuidv4().substring(0, 14)}${new Date().getTime()}`;
  joinFromWeb(meetingId);
  joinFromMobile(meetingId, JOIN_OPTION.noCallKit);
};

Given(/^I switch tab '(.*)'$/, function(tabName: string) {
  MeetingScreen.switchTab(tabName);
});

const joinFromWeb = (meetingId: string) => {
  MeetingPage.joinMeeting(meetingId, helperParticipant);
};

const joinFromMobile = (meetingId: string, option: JOIN_OPTION) => {
  expect(JoinScreen.isLoaded()).to.be.true;
  if (CAT_DEMO_URL) {
    JoinScreen.setMeetingEndpointUrl(CAT_DEMO_URL);
  }
  const joined = JoinScreen.joinMeeting(meetingId, targetParticipant, option);
  expect(joined).to.be.true;
};

Given(/^I am on (.*) screen$/, function(screenName: string) {
  if (screenName === 'meeting') {
    expect(MeetingScreen.isLoaded()).to.be.true;
  }
});

After(function() {
  if (MeetingScreen.leaveBtn.isDisplayed()) {
    waitForDisplayedThenClick(MeetingScreen.leaveBtn);
  }
});
