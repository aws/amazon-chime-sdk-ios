import { Screen } from './Screen';
import { waitForDisplayed } from '../utils/WaitForUtils';
import { SECONDS, ONE_SECOND } from '../constants';

class LiveTranscriptionScreen extends Screen {
  isLoaded(): boolean {
    if (this.browser.isAndroid) {
      if (this.browser.isLocked()) {
        this.browser.unlock();
      }
    }
    try {
      return waitForDisplayed(this.liveTranscriptionBtn, 4 * SECONDS);
    } catch (error) {
      this.browser.pause(ONE_SECOND);
      return waitForDisplayed(this.liveTranscriptionBtn);
    }
  }

  // On Live Transcripiton screen
  get liveTranscriptionBtn() {
    if (this.browser.isAndroid && this.browser.isLocked()) {
      this.browser.unlock();
    }
    if (this.browser.isIOS) {
      this.browser.execute('mobile: scroll', { direction: 'down' });
      return this.browser.$('~Start Transcription');
    }
    // Scroll down for small screen
    return this.browser.$(
      'android=new UiScrollable(new UiSelector())' +
        '.scrollIntoView(new UiSelector().resourceId("com.amazonaws.services.chime.sdkdemo:id/buttonStartTranscription"))'
    );
  }
}
export default new LiveTranscriptionScreen(global.targetDevice);
