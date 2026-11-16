import { expect } from 'chai';
import { When, Then } from 'cucumber';

import MeetingPage from '../pages/MeetingPage';
import {
  waitForDisplayedThenClick,
  waitForDisplayed,
  waitForDisappeared,
} from '../utils/WaitForUtils';
import {
  saveBaselineScreen,
  compareScreen,
  saveBaselineElement,
  compareElement,
} from '../utils/ScreenUtils';
import MeetingScreen from '../screens/MeetingScreen';
import { v4 as uuidv4 } from 'uuid';
import { helperParticipant, targetParticipant, SECONDS } from '../constants';
import { isSelf } from '../utils/MediaUtils';

const currentTag = `${uuidv4()}_${new Date().toISOString()}`;

const localTag = `${uuidv4()}_${new Date().toISOString()}_local`;

When(/^(I|Helper) turns? the video on$/, function(from: string) {
  const btn = isSelf(from) ? MeetingScreen.toggleCameraBtn : MeetingPage.toggleCameraBtn;
  const tag = isSelf(from) ? localTag : currentTag;
  waitForDisplayed(MeetingScreen.videoCollectionView);
  if (global.targetDevice.isIOS && isSelf(from)) {
    saveBaselineElement(MeetingScreen.videoCollectionView, global.targetDevice, tag);
  } else {
    saveBaselineScreen(global.targetDevice, tag);
  }
  waitForDisplayedThenClick(btn);
});

When(/^I turn the video off$/, function() {
  waitForDisplayedThenClick(MeetingScreen.toggleCameraBtn);
});

Then(/^I should not be able to see local video tile$/, function() {
  let participate = targetParticipant;
  if (global.targetDevice.isAndroid) {
    participate = '';
  }
  expect(waitForDisappeared(MeetingScreen.findVideoParticipantVideo(participate))).to.be.true;
});

Then(/^I should be able to see (remote|local) video$/, function(remote: string) {
  const isLocal = remote === 'local';
  // TODO: check with iOS and dark theme
  let participate = isLocal ? targetParticipant : helperParticipant;
  const tag = isLocal ? localTag : currentTag;
  if (isLocal && global.targetDevice.isIOS) {
    participate = targetParticipant;
    global.targetDevice.pause(2 * SECONDS);
    try {
      waitForDisplayedThenClick(global.targetDevice.$('~OK'), 15 * SECONDS);
    } catch (error) {}
  }
  waitForDisplayed(MeetingScreen.findVideoParticipantVideo(participate));
  let res = {
    misMatchPercentage: 0,
  };
  if (isLocal && global.targetDevice.isIOS) {
    res = compareElement(MeetingScreen.videoCollectionView, global.targetDevice, tag);
  } else {
    res = compareScreen(global.targetDevice, tag);
  }
  if (isLocal && global.targetDevice.isIOS) {
    // due to aspect fit the diff is super small for local
    expect(res.misMatchPercentage).to.be.gte(0.01);
  } else {
    expect(res.misMatchPercentage).to.be.greaterThan(0.16);
  }
});

// TODO: Uncomment this once we figure why pause doesn't work for fake input.
// const pauseTag = `${uuidv4()}_${new Date().toISOString()}_pause`;

// When(/^I click on switch camera$/, function() {
//   waitForDisplayed(MeetingScreen.videoCollectionView);
//   waitForDisplayed(MeetingScreen.findVideoParticipantVideo(helperParticipant));
//   waitForDisplayedThenClick(MeetingScreen.toggleCameraSwitch);
// });

// Then(/^I should be able to see helper video (paused|resumed)$/, function(pauseState: string) {
//   saveBaselineScreen(global.targetDevice, pauseTag);
//   global.targetDevice.pause(12_500);
//   const res = compareScreen(global.targetDevice, pauseTag);
//   expect(res.misMatchPercentage).to.be.lessThan(0.02);
// });
