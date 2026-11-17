import { Screen } from './Screen';
import {
  waitForDisplayed,
  waitForDisplayedThenClick,
  waitForDisplayedThenGetText,
  waitForDisplayedThenSetValue,
} from '../utils/WaitForUtils';
import { targetParticipant, SECONDS, ONE_SECOND } from '../constants';

class MeetingScreen extends Screen {
  isLoaded(): boolean {
    if (this.browser.isAndroid) {
      if (this.browser.isLocked()) {
        this.browser.unlock();
      }
    }
    try {
      return waitForDisplayed(this.leaveBtn, 4 * SECONDS);
    } catch (error) {
      this.browser.pause(ONE_SECOND);
      return waitForDisplayed(this.leaveBtn);
    }
  }

  activeSpeaker(name: string) {
    this.unlock();
    return this.browser.$(`~${name} Active`);
  }

  // Pause Resume button
  get toggleCameraSwitch() {
    this.unlock();
    return this.browser.$('~Switch Camera');
  }

  // Turn on or off video for local
  get toggleCameraBtn() {
    this.unlock();
    return this.browser.$('~Toggle Camera');
  }

  get leaveBtn() {
    this.unlock();
    return this.browser.$('~Leave Meeting');
  }

  get toggleMuteBtn() {
    this.unlock();
    return this.browser.$('~Toggle Mute');
  }

  get toggleAdditionalOptionsBtn() {
    this.unlock();
    if (this.browser.isIOS) return this.browser.$('~More');
    return this.browser.$('~Additional Options');
  }

  get additionalOptionsDialog() {
    const target = 'Additional Options';
    if (this.browser.isIOS) {
      return this.selectByIosClassChain(
        `**/XCUIElementTypeStaticText[\`name MATCHES "${target}"\`]`
      );
    } else {
      return this.selectByAndroidUISelector(
        `new UiSelector().className("android.widget.TextView").text("${target}")`
      );
    }
  }

  get turnOnVoiceFocusButton() {
    return this.toggleVoiceFocuseButton(true);
  }

  get turnOffVoiceFocusButton() {
    return this.toggleVoiceFocuseButton(false);
  }

  private toggleVoiceFocuseButton(isOn: boolean) {
    const targetIOS = isOn ? 'Turn on Voice Focus' : 'Turn off Voice Focus';
    const targetAndroid = isOn
      ? 'Turn on Voice Focus (noise suppression)'
      : 'Turn off Voice Focus (noise suppression)';
    if (this.browser.isIOS) {
      return this.selectByIosClassChain(
        `**/XCUIElementTypeButton[\`name MATCHES "${targetIOS}"\`]`
      );
    } else {
      return this.selectByAndroidUISelector(
        `new UiSelector().className("android.widget.TextView").text("${targetAndroid}")`
      );
    }
  }

  get turnOnLiveTranscriptionButton() {
    return this.toggleLiveTranscriptionButton(true);
  }

  get turnOffLiveTranscriptionButton() {
    return this.toggleLiveTranscriptionButton(false);
  }

  private toggleLiveTranscriptionButton(isOn: boolean) {
    const targetText = isOn ? 'Turn on Live Transcription' : 'Turn off Live Transcription';
    if (this.browser.isIOS) {
      return this.selectByIosClassChain(
        `**/XCUIElementTypeButton[\`name MATCHES "${targetText}"\`]`
      );
    } else {
      return this.selectByAndroidUISelector(
        `new UiSelector().className("android.widget.TextView").text("${targetText}")`
      );
    }
  }

  get videoCollectionView() {
    this.unlock();
    return this.browser.$('~Video Collection');
  }

  get screenShareView() {
    this.unlock();
    return this.browser.$('~Screen Share');
  }

  get screenShareTile() {
    this.unlock();
    return this.browser.$('~ScreenTile');
  }

  get toggleMetricsBtn() {
    this.unlock();
    return this.browser.$('~Toggle Metrics');
  }

  get localContentAttendee() {
    this.unlock();
    return this.browser.$(`~${targetParticipant} <<Content>>`);
  }

  metricValue(metric: string) {
    this.unlock();
    return this.browser.$(`~${metric} value`);
  }

  metricValueText(metric: string): string {
    return waitForDisplayedThenGetText(this.metricValue(metric));
  }

  metricName(metric: string) {
    this.unlock();
    return this.browser.$(`~${metric} metric`);
  }

  private unlock() {
    if (this.browser.isAndroid && this.browser.isLocked()) {
      this.browser.unlock();
    }
  }

  participant(name: string) {
    this.unlock();
    return this.browser.$(`~${name}`);
  }

  switchTab(name: string) {
    if (name === 'Attendee') return;
    if (this.browser.isIOS) {
      // due to toast add wait for stability
      this.browser.pause(3 * SECONDS);
      waitForDisplayedThenClick(this.browser.$(`~${name}`));
      return;
    }
    const tabLayout = 'Tab Layout';
    waitForDisplayed(this.browser.$(`~${tabLayout}`));
    // Use UIAutomator query for scrollable tab. Tried mobile:scroll, but get unable to find command
    // Bound Android 12+ UiScrollable's end-detection loop.
    waitForDisplayedThenClick(
      this.browser.$(
        `android=new UiScrollable(new UiSelector().description("${tabLayout}")).setAsHorizontalList().setMaxSearchSwipes(6).scrollDescriptionIntoView("${name} Tab");`
      )
    );
    // Some android devices don't handle scroll properly, clicking on wrong tab,
    // so we'll click metric tab again to handle this issue
    this.browser.pause(3 * SECONDS);
    if (name === 'Metrics' || name === 'Captions')
      waitForDisplayedThenClick(this.browser.$(`~${name} Tab`));
  }

  findVideoParticipantVideo(name: string) {
    this.unlock();
    return this.browser.$(`~${name} VideoTile`);
  }

  volumeLevel(level: string, name: string): WebdriverIO.Element {
    this.unlock();
    let query = 'Speaking';
    if (level === 'muted') {
      query = 'Muted';
    } else if (level === 'notSpeaking') {
      query = 'Not Speaking';
    }
    return this.browser.$(`~${name} ${query}`);
  }

  findMessage(message: string) {
    this.unlock();
    return this.browser.$(`~${message}`);
  }

  sendMessage(message: string) {
    this.unlock();
    waitForDisplayedThenSetValue(this.browser.$(`~Enter message`), message);
    waitForDisplayedThenClick(this.browser.$(`~Send Message`));
  }

  playSreenShare() {
    this.unlock();
    if (this.browser.isAndroid) {
      waitForDisplayedThenClick(this.toggleAdditionalOptionsBtn);
      waitForDisplayedThenClick(
        this.selectByAndroidUISelector(
          `new UiSelector().className("android.widget.TextView").text("Share screen")`
        )
      );
      // Accept the capture request
      waitForDisplayedThenClick(
        this.selectByAndroidUISelector(`new UiSelector().resourceId("android:id/button1")`)
      );
    } else {
      waitForDisplayedThenClick(this.browser.$('~More'));
      waitForDisplayedThenClick(this.browser.$('~Share in app content'));
      // Subsequent content share does not need to click record screen share
      // This seems to happen because we don't fully stop screen share
      try {
        waitForDisplayedThenClick(this.browser.$('~Record Screen'), 10 * SECONDS);
      } catch (err) {}
    }
  }

  private selectByIosClassChain(selector: string) {
    return this.browser.$(`-ios class chain:${selector}`);
  }

  private selectByAndroidUISelector(selector: string) {
    return this.browser.$(`android=${selector}`);
  }
}
export default new MeetingScreen(global.targetDevice);
