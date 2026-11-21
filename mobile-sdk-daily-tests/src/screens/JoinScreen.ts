import {
  waitForDisplayedThenClick,
  waitForDisplayedThenSetValue,
  waitForDisplayed,
} from '../utils/WaitForUtils';
import { Screen } from './Screen';
import MeetingScreen from './MeetingScreen';
import { JOIN_OPTION, SECONDS } from '../constants';
import DebugSettingsScreen from './DebugSettingsScreen';

class JoinScreen extends Screen {
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

  get continueBtn() {
    if (this.browser.isAndroid && this.browser.isLocked()) {
      this.browser.unlock();
    }
    if (this.browser.isIOS) return this.browser.$('~Join Without CallKit');
    return this.browser.$('~Continue');
  }

  // On Device selection screen
  get joinBtn() {
    if (this.browser.isAndroid && this.browser.isLocked()) {
      this.browser.unlock();
    }
    if (this.browser.isIOS) return this.browser.$('~Join Meeting');
    // Scroll down for small screen
    return this.browser.$(
      'android=new UiScrollable(new UiSelector())' +
        '.scrollIntoView(new UiSelector().resourceId("com.amazonaws.services.chime.sdkdemo:id/buttonJoin"))'
    );
  }

  get meetingIdInput() {
    if (this.browser.isIOS) {
      return this.browser.$(`~Meeting Id Input`);
    } else {
      if (this.browser.isLocked()) {
        this.browser.unlock();
      }
      return this.browser.$(
        'android=new UiSelector().text("Meeting ID").className("android.widget.EditText")'
      );
    }
  }

  get debugSettingsBtn() {
    if (this.browser.isAndroid && this.browser.isLocked()) {
      this.browser.unlock();
    }
    if (this.browser.isIOS) return this.browser.$('~Debug Settings Button');
    return this.browser.$(
      'android=new UiSelector().text("DEBUG SETTINGS").className("android.widget.Button")'
    );
  }

  get joinCallKitIncomingBtn() {
    if (this.browser.isIOS) return this.browser.$('~Join with CallKit as Incoming in 10s');
    throw new Error('CallKit is only available on iOS');
  }

  get joinCallKitOutgoingBtn() {
    if (this.browser.isIOS) return this.browser.$('~Join with CallKit as Outgoing');
    throw new Error('CallKit is only available on iOS');
  }

  get callKitAcceptBtn() {
    if (this.browser.isIOS) return this.browser.$('~Accept');
    throw new Error('CallKit is only available on iOS');
  }

  acceptPermissionDialog() {
    this.browser.pause(2 * SECONDS);
    try {
      waitForDisplayedThenClick(this.browser.$('~OK'), 15 * SECONDS);
    } catch (error) {}
  }

  setMeetingEndpointUrl(meetingEndpointUrl: string) {
    waitForDisplayedThenClick(this.debugSettingsBtn);
    DebugSettingsScreen.setMeetingEndpointUrl(meetingEndpointUrl);
  }

  joinMeeting(
    meetingId: string,
    name: string,
    option: JOIN_OPTION = JOIN_OPTION.noCallKit
  ): boolean {
    this.browser.pause(2 * SECONDS);
    if (this.browser.isAndroid) {
      if (this.browser.isLocked()) {
        this.browser.unlock();
      }
      this.browser.pause(2 * SECONDS);
      if (this.browser.isLocked()) {
        this.browser.unlock();
      }
      waitForDisplayedThenSetValue(this.meetingIdInput, meetingId);

      waitForDisplayedThenSetValue(
        this.browser.$(
          'android=new UiSelector().text("Your Name").className("android.widget.EditText")'
        ),
        name
      );
      waitForDisplayedThenClick(this.continueBtn);
      // Device selection screen
      waitForDisplayedThenClick(this.joinBtn);
    } else if (this.browser.isIOS) {
      try {
        waitForDisplayed(this.meetingIdInput, 5 * SECONDS);
      } catch (err) {}
      waitForDisplayedThenSetValue(this.meetingIdInput, meetingId);
      waitForDisplayedThenSetValue(this.browser.$(`~Name Input`), name);
      try {
        // To hind keyboard if it's diaplaying
        waitForDisplayedThenClick(this.browser.$('~Done'));
      } catch {}
      if (option === JOIN_OPTION.callKitIncoming) {
        waitForDisplayedThenClick(this.joinCallKitIncomingBtn);
        // Microphone permission
        this.acceptPermissionDialog();
        global.targetDevice.pause(10 * SECONDS);
        waitForDisplayedThenClick(this.callKitAcceptBtn);
      } else if (option === JOIN_OPTION.callKitOutgoing) {
        waitForDisplayedThenClick(this.joinCallKitOutgoingBtn);
        // Microphone permission
        this.acceptPermissionDialog();
      } else {
        waitForDisplayedThenClick(this.continueBtn);
        // Microphone permission
        this.acceptPermissionDialog();
        // Device selection screen
        // Camera permission
        this.acceptPermissionDialog();
        waitForDisplayedThenClick(this.joinBtn);
      }
      this.acceptPermissionDialog();
    }
    return MeetingScreen.isLoaded();
  }
}
export default new JoinScreen(global.targetDevice);
