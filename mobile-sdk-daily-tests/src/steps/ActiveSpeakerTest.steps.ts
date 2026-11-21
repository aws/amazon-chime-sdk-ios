import { Then } from 'cucumber';
import { waitForExist, waitForDisplayedThenClick } from '../utils/WaitForUtils';
import MeetingScreen from '../screens/MeetingScreen';
import MeetingPage from '../pages/MeetingPage';
import { expect } from 'chai';
import { helperParticipant, ONE_SECOND, SECONDS } from '../constants';

Then(/^I can see helper as active speaker$/, function() {
  // waitForDisplayedThenClick(MeetingScreen.toggleMuteBtn);
  MeetingPage.play440HzTone();
  if (global.targetDevice.isAndroid) {
    global.targetDevice.pause(1_500);
    expect(waitForExist(MeetingScreen.activeSpeaker(helperParticipant))).to.be.true;
  } else {
    global.targetDevice.pause(500);
    // Due to Default Active Speaker Policy, which makes it inactive if volume is constant, make some workaround
    try {
      expect(waitForExist(MeetingScreen.activeSpeaker(helperParticipant), 10 * SECONDS)).to.be.true;
    } catch (err) {
      waitForDisplayedThenClick(MeetingPage.toggleMuteBtn);
      global.targetDevice.pause(ONE_SECOND);
      waitForDisplayedThenClick(MeetingPage.toggleMuteBtn);
      expect(waitForExist(MeetingScreen.activeSpeaker(helperParticipant), 20 * SECONDS)).to.be.true;
    }
  }
});
