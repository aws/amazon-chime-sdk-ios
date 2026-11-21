import { waitForDisplayedThenClick, waitForDisplayedThenSetValue } from '../utils/WaitForUtils';
import { Screen } from './Screen';

class DebugSesstingsScreen extends Screen {
  isLoaded(): boolean {
    if (this.browser.isAndroid && this.browser.isLocked()) {
      this.browser.unlock();
    }
    if (this.browser.isIOS) {
      // Remove some system popups
      try {
        waitForDisplayedThenClick(this.browser.$('~Not Now'), 5_000);
      } catch (error) {}
      try {
        waitForDisplayedThenClick(this.browser.$('~Cancel'), 5_000);
      } catch (error) {}
    }
    return true;
  }

  get saveBtn() {
    if (this.browser.isAndroid && this.browser.isLocked()) {
      this.browser.unlock();
    }
    if (this.browser.isIOS) return this.browser.$('~Debug Settings Save');
    return this.browser.$(
      'android=new UiSelector().text("SAVE").className("android.widget.Button")'
    );
  }

  get meetingEndpointUrlInput() {
    if (this.browser.isAndroid && this.browser.isLocked()) {
      this.browser.unlock();
    }
    if (this.browser.isIOS) return this.browser.$('~Meeting Endpoint Url Input');
    return this.browser.$(
      'android=new UiSelector().text("Meeting Endpoint URL").className("android.widget.EditText")'
    );
  }

  setMeetingEndpointUrl(meetingEndpointUrl: string) {
    waitForDisplayedThenSetValue(this.meetingEndpointUrlInput, meetingEndpointUrl);
    if (this.browser.isIOS) {
      try {
        // To hind keyboard if it's diaplaying
        waitForDisplayedThenClick(this.browser.$('~Return'));
      } catch {}
    }
    waitForDisplayedThenClick(this.saveBtn);
  }
}
export default new DebugSesstingsScreen(global.targetDevice);
