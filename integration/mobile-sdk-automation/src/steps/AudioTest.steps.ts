import { expect } from 'chai';
import { Then, When } from 'cucumber';

import MeetingPage from '../pages/MeetingPage';
import { waitForDisplayedThenClick, waitForExist, waitForDisappeared } from '../utils/WaitForUtils';
import MeetingScreen from '../screens/MeetingScreen';
import { isSelf } from '../utils/MediaUtils';
import { helperParticipant, targetParticipant, ONE_SECOND } from '../constants';

Then(/^I can hear sound from helper$/, function() {
  MeetingPage.play440HzTone();
  // It keeps changing elements, which make the tests fail
  // for now mute self.
  waitForDisplayedThenClick(MeetingScreen.toggleMuteBtn);
  global.targetDevice.pause(ONE_SECOND);
  expect(waitForExist(MeetingScreen.volumeLevel('speaking', helperParticipant))).to.be.true;
});

When(/^(I|Helper) clicks? mute button$/, function(subject: string) {
  const target = isSelf(subject) ? MeetingScreen : MeetingPage;
  waitForDisplayedThenClick(target.toggleMuteBtn);
});

Then(/^(I|Helper) expects? to see (me|helper) muted$/, function(from: string, to: string) {
  const mutedTarget = to === 'me' ? targetParticipant : helperParticipant;

  if (!isSelf(from)) {
    expect(MeetingPage.isPersonMuted(mutedTarget)).to.be.true;
  } else {
    global.targetDevice.pause(ONE_SECOND);
    expect(waitForExist(MeetingScreen.volumeLevel('muted', mutedTarget))).to.be.true;
  }
});

Then(/^(I|Helper) expects? to see me not muted$/, function(from: string) {
  if (!isSelf(from)) {
    expect(MeetingPage.personVolumeStatus(targetParticipant)).to.not.equal('muted');
  } else {
    global.targetDevice.pause(ONE_SECOND);
    expect(waitForDisappeared(MeetingScreen.volumeLevel('muted', targetParticipant))).to.be.true;
  }
});
