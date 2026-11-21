import { Then, When } from 'cucumber';
import { waitForExist, waitForDisplayedThenClick, waitForNotExist } from '../utils/WaitForUtils';
import MeetingScreen from '../screens/MeetingScreen';
import { expect } from 'chai';

Then(/^I cannot see AdditionalOptions dialog$/, function() {
  expect(waitForNotExist(MeetingScreen.additionalOptionsDialog)).to.be.true;
});

When(/^I click AdditionalOptions button$/, function() {
  waitForDisplayedThenClick(MeetingScreen.toggleAdditionalOptionsBtn);
});

Then(/^I can see AdditionalOptions dialog$/, function() {
  expect(waitForExist(MeetingScreen.additionalOptionsDialog)).to.be.true;
});

When(/^I click TurnOffVoiceFocus button$/, function() {
  waitForDisplayedThenClick(MeetingScreen.turnOffVoiceFocusButton);
});

Then(/^I can see TurnOnVoiceFocus button$/, function() {
  expect(waitForExist(MeetingScreen.turnOnVoiceFocusButton)).to.be.true;
});
