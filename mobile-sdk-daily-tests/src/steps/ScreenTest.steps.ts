import { expect } from 'chai';
import { When, Then } from 'cucumber';

import MeetingPage from '../pages/MeetingPage';
import {
  waitForDisplayedThenClick,
  waitForDisplayed,
  waitForExist,
  waitForDisappeared,
} from '../utils/WaitForUtils';
import { saveBaselineScreen, compareScreen } from '../utils/ScreenUtils';
import MeetingScreen from '../screens/MeetingScreen';
import { v4 as uuidv4 } from 'uuid';
import { isSelf } from '../utils/MediaUtils';
import { ONE_SECOND } from '../constants';

const currentTag = `${uuidv4()}_${new Date().toISOString()}_screen`;
const contentShareMetric = 'contentShareVideoSendBitrate';

When(/^(I|Helper) shares? the screen$/, function(subject: string) {
  if (isSelf(subject) && isScreenShareAvailable()) {
    MeetingScreen.playSreenShare();
  } else {
    waitForDisplayed(MeetingScreen.screenShareView);
    saveBaselineScreen(global.targetDevice, currentTag);
    waitForDisplayedThenClick(MeetingPage.toggleMuteBtn);
    MeetingPage.playScreenShare();
  }
});

Then(/^I should be able to see the local content attendee/, function() {
  if (isScreenShareAvailable()) {
    expect(waitForDisplayed(MeetingScreen.localContentAttendee)).to.be.true;
  }
});

Then(/^I should not be able to see the local content attendee/, function() {
  expect(waitForDisappeared(MeetingScreen.localContentAttendee)).to.be.true;
});

Then(/^I should be able to see content share metrics/, function() {
  if (isScreenShareAvailable()) {
    expect(waitForExist(MeetingScreen.metricName(contentShareMetric))).to.be.true;
    expect(waitForExist(MeetingScreen.metricValue(contentShareMetric))).to.be.true;
  }
});

Then(/^I should be able to see screen/, function() {
  if (global.targetDevice.isIOS) {
    waitForExist(MeetingScreen.screenShareTile);
    global.targetDevice.pause(ONE_SECOND);
  } else {
    waitForDisplayed(MeetingScreen.screenShareTile);
  }
  const res = compareScreen(global.targetDevice, currentTag);
  expect(res.misMatchPercentage).to.be.greaterThan(0.18);
});

function isScreenShareAvailable() {
  if (
    global.targetDevice.isAndroid ||
    !(
      global.targetDevice.capabilities.platformVersion &&
      global.targetDevice.capabilities.platformVersion.startsWith('10.')
    )
  ) {
    return true;
  } else {
    console.info('OS does not support screen share, skipping...');
    return false;
  }
}
