import { Then, Given } from 'cucumber';
import MeetingPage from '../pages/MeetingPage';
import MeetingScreen from '../screens/MeetingScreen';
import { expect } from 'chai';
import { oldMessageText1, oldMessageText2 } from '../constants';
import { isSelf } from '../utils/MediaUtils';
import { waitForDisplayed } from '../utils/WaitForUtils';

Then(/^I should be able to see old messages$/, function() {
  expect(waitForDisplayed(MeetingScreen.findMessage(oldMessageText1))).to.be.true;
  expect(waitForDisplayed(MeetingScreen.findMessage(oldMessageText2))).to.be.true;
});

Given(/^(I|Helper) sends? a message '(.*)'$/, function(subject: string, message: string) {
  const target = isSelf(subject) ? MeetingScreen : MeetingPage;
  target.sendMessage(message);
});

Then(/^(I|Helper) should be able to see the message '(.*)'$/, function(
  subject: string,
  message: string
) {
  const target = isSelf(subject) ? MeetingScreen : MeetingPage;
  expect(waitForDisplayed(target.findMessage(message))).to.be.true;
});
