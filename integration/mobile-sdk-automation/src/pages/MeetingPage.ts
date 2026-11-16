import {
  waitForDisplayedThenClick,
  waitForDisplayedThenSetValue,
  waitForDisplayed,
} from '../utils/WaitForUtils';
import { DEFAULT_TIMEOUT, ONE_SECOND } from '../constants';

export class MeetingPage {
  constructor(private readonly browser: WebdriverIO.BrowserObject) {}

  get toggleCameraBtn() {
    return this.browser.$('#button-camera');
  }

  get toggleMuteBtn() {
    return this.browser.$('#button-microphone');
  }

  get joinButton() {
    return this.browser.$('#joinButton');
  }

  get authenticateButton() {
    return this.browser.$('#authenticate');
  }

  get prejoinCameraToggle() {
    return this.browser.$('#prejoin-camera-toggle');
  }

  get meetingFlow() {
    return this.browser.$('#flow-meeting');
  }

  get participantsButton() {
    return this.browser.$('#button-participants');
  }

  get participantsPanel() {
    return this.browser.$('#panel-participants');
  }

  get chatButton() {
    return this.browser.$('#button-chat');
  }

  get chatPanel() {
    return this.browser.$('#panel-chat');
  }

  get leaveButton() {
    return this.browser.$('#button-meeting-leave');
  }

  get confirmLeaveButton() {
    return this.browser.$('#button-confirm-leave');
  }

  get leftFlow() {
    return this.browser.$('#flow-left');
  }

  get rejoinButton() {
    return this.browser.$('#left-rejoin');
  }

  get soundButton() {
    return this.browser.$('#dropdown-menu-microphone-440-Hz');
  }

  get prerecordedSpeechButton() {
    return this.browser.$('#dropdown-menu-microphone-Prerecorded-Speech');
  }

  get microphoneDropdown() {
    return this.browser.$('#button-microphone-drop');
  }

  get screenShareButton() {
    return this.browser.$('#button-content-share');
  }

  get screenShareCapture() {
    return this.browser.$('#dropdown-item-content-share-screen-capture');
  }

  get mutedPerson() {
    this.openParticipants();
    const mutedStatus = this.browser.$('#roster').$('.roster-status[data-status="muted"]');
    waitForDisplayed(mutedStatus);
    return mutedStatus
      .$('..')
      .$('.roster-name')
      .getText();
  }

  isPersonMuted(name: string): boolean {
    const participant = this.findParticipant(name);
    waitForDisplayed(participant);
    const status = participant.$('.roster-status');
    this.browser.waitUntil(() => status.getAttribute('data-status') === 'muted', DEFAULT_TIMEOUT);
    return true;
  }

  personVolumeStatus(name: string): string {
    const participant = this.findParticipant(name);
    waitForDisplayed(participant);
    const status = participant.$('.roster-status');
    this.browser.waitUntil(() => status.getAttribute('data-status') !== 'muted', DEFAULT_TIMEOUT);
    return status.getAttribute('data-status');
  }

  findParticipant(name: string) {
    this.openParticipants();
    return this.browser.$('#roster').$(`li*=${name}`);
  }

  joinMeeting(meetingId: string, name: string): void {
    this.browser.url('');
    waitForDisplayedThenSetValue(this.browser.$('#inputMeeting'), meetingId);
    waitForDisplayedThenSetValue(this.browser.$('#inputName'), name);
    waitForDisplayedThenClick(this.authenticateButton);
    this.joinButton.waitForDisplayed(DEFAULT_TIMEOUT);
    this.joinButton.waitForEnabled(DEFAULT_TIMEOUT);
    this.prejoinCameraToggle.waitForDisplayed(DEFAULT_TIMEOUT);
    if (this.prejoinCameraToggle.getAttribute('aria-pressed') === 'true') {
      this.prejoinCameraToggle.click();
    }
    this.joinButton.click();
    this.meetingFlow.waitForDisplayed(DEFAULT_TIMEOUT);
  }

  leaveMeeting(): void {
    waitForDisplayedThenClick(this.leaveButton);
    waitForDisplayedThenClick(this.confirmLeaveButton);
    this.leftFlow.waitForDisplayed(DEFAULT_TIMEOUT);
  }

  rejoinMeeting(): void {
    waitForDisplayedThenClick(this.rejoinButton);
    this.meetingFlow.waitForDisplayed(DEFAULT_TIMEOUT);
  }

  play440HzTone(): void {
    waitForDisplayedThenClick(this.microphoneDropdown);
    waitForDisplayedThenClick(this.soundButton);
  }

  playPrerecordedSpeech(): void {
    waitForDisplayedThenClick(this.microphoneDropdown);
    waitForDisplayedThenClick(this.prerecordedSpeechButton);
  }

  playScreenShare(): void {
    waitForDisplayedThenClick(this.screenShareButton);
    waitForDisplayedThenClick(this.screenShareCapture);
  }

  sendMessage(message: string): void {
    this.openChat();
    this.browser.pause(ONE_SECOND);
    waitForDisplayedThenSetValue(this.browser.$('#send-message'), message);
    // Press enter key to send out the message
    this.browser.keys('\uE007');
  }

  findMessage(message: string) {
    this.openChat();
    return this.browser.$('#receive-message').$(`div*=${message}`);
  }

  private openParticipants(): void {
    this.openPanel(this.participantsButton, this.participantsPanel);
  }

  private openChat(): void {
    this.openPanel(this.chatButton, this.chatPanel);
  }

  private openPanel(button: WebdriverIO.Element, panel: WebdriverIO.Element): void {
    button.waitForDisplayed(DEFAULT_TIMEOUT);
    if (button.getAttribute('aria-pressed') !== 'true') {
      button.click();
    }
    panel.waitForDisplayed(DEFAULT_TIMEOUT);
  }
}

export default new MeetingPage(global.helperBrowser);
