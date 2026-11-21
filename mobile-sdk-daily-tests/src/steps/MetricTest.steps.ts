import { Then } from 'cucumber';
import { waitForExist } from '../utils/WaitForUtils';
import MeetingScreen from '../screens/MeetingScreen';
import { expect } from 'chai';

const audioRPLMetric = 'audioReceivePacketLossPercent';
const audioSPLMetric = 'audioSendPacketLossPercent';
// TODO: Enable this for video
const videoARBMetric = 'videoAvailableReceiveBandwidth';
const videoRBMetric = 'videoReceiveBitrate';
const videoRPLPMetric = 'videoReceivePacketLossPercent';

Then(/^I should be able to see metric/, function() {
  global.targetDevice.pause(1_000);
  expect(waitForExist(MeetingScreen.metricName(audioRPLMetric))).to.be.true;
  expect(waitForExist(MeetingScreen.metricValue(audioRPLMetric))).to.be.true;

  expect(waitForExist(MeetingScreen.metricName(audioSPLMetric))).to.be.true;
  expect(waitForExist(MeetingScreen.metricValue(audioSPLMetric))).to.be.true;

  expect(waitForExist(MeetingScreen.metricName(videoARBMetric))).to.be.true;
  expect(waitForExist(MeetingScreen.metricValue(videoARBMetric))).to.be.true;

  expect(waitForExist(MeetingScreen.metricName(videoRBMetric))).to.be.true;
  expect(waitForExist(MeetingScreen.metricValue(videoRBMetric))).to.be.true;

  expect(waitForExist(MeetingScreen.metricName(videoRPLPMetric))).to.be.true;
  expect(waitForExist(MeetingScreen.metricValue(videoRPLPMetric))).to.be.true;
});
