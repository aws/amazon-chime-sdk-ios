/// <reference types="jest" />
import { MeetingPage } from './MeetingPage';

type FakeElement = {
  waitForDisplayed: jest.Mock;
  waitForEnabled: jest.Mock;
  click: jest.Mock;
  setValue: jest.Mock;
  getAttribute: jest.Mock;
  getText: jest.Mock;
  $: jest.Mock;
};

const fakeElement = (attribute = ''): FakeElement => ({
  waitForDisplayed: jest.fn(() => true),
  waitForEnabled: jest.fn(() => true),
  click: jest.fn(),
  setValue: jest.fn(),
  getAttribute: jest.fn(() => attribute),
  getText: jest.fn(() => ''),
  $: jest.fn(),
});

const createPage = (elements: Record<string, FakeElement>) => {
  const browser = {
    $: jest.fn((selector: string) => elements[selector]),
    url: jest.fn(),
    pause: jest.fn(),
    keys: jest.fn(),
    waitUntil: jest.fn((condition: () => boolean) => {
      for (let attempt = 0; attempt < 10; attempt++) {
        if (condition()) return true;
      }
      throw new Error('condition did not become true');
    }),
  };
  return { browser, page: new MeetingPage((browser as unknown) as WebdriverIO.BrowserObject) };
};

describe('MeetingPage rebuilt demo compatibility', () => {
  it('joins through the prejoin flow and disables a remembered camera', () => {
    const elements = {
      '#inputMeeting': fakeElement(),
      '#inputName': fakeElement(),
      '#authenticate': fakeElement(),
      '#joinButton': fakeElement(),
      '#prejoin-camera-toggle': fakeElement('true'),
      '#flow-meeting': fakeElement(),
    };
    const { browser, page } = createPage(elements);

    page.joinMeeting('meeting-id', 'helper');

    expect(browser.url).toHaveBeenCalledWith('');
    expect(elements['#inputMeeting'].setValue).toHaveBeenCalledWith('meeting-id');
    expect(elements['#inputName'].setValue).toHaveBeenCalledWith('helper');
    expect(elements['#authenticate'].click).toHaveBeenCalledTimes(1);
    expect(elements['#prejoin-camera-toggle'].getAttribute).toHaveBeenCalledWith('aria-pressed');
    expect(elements['#prejoin-camera-toggle'].click).toHaveBeenCalledTimes(1);
    expect(elements['#joinButton'].waitForEnabled).toHaveBeenCalledTimes(1);
    expect(elements['#joinButton'].click).toHaveBeenCalledTimes(1);
    expect(elements['#flow-meeting'].waitForDisplayed).toHaveBeenCalledTimes(1);
  });

  it('keeps the prejoin camera off when it is already disabled', () => {
    const elements = {
      '#inputMeeting': fakeElement(),
      '#inputName': fakeElement(),
      '#authenticate': fakeElement(),
      '#joinButton': fakeElement(),
      '#prejoin-camera-toggle': fakeElement('false'),
      '#flow-meeting': fakeElement(),
    };
    const { page } = createPage(elements);

    page.joinMeeting('meeting-id', 'helper');

    expect(elements['#prejoin-camera-toggle'].getAttribute).toHaveBeenCalledWith('aria-pressed');
    expect(elements['#prejoin-camera-toggle'].click).not.toHaveBeenCalled();
  });

  it('opens the content-share popover from the main Share button', () => {
    const elements = {
      '#button-content-share': fakeElement(),
      '#dropdown-item-content-share-screen-capture': fakeElement(),
    };
    const { browser, page } = createPage(elements);

    page.playScreenShare();

    expect(browser.$).not.toHaveBeenCalledWith('#button-content-share-drop');
    expect(elements['#button-content-share'].click).toHaveBeenCalledTimes(1);
    expect(elements['#dropdown-item-content-share-screen-capture'].click).toHaveBeenCalledTimes(1);
  });

  it('opens Chat before sending a message', () => {
    const elements = {
      '#button-chat': fakeElement('false'),
      '#panel-chat': fakeElement(),
      '#send-message': fakeElement(),
    };
    const { browser, page } = createPage(elements);

    page.sendMessage('hello');

    expect(elements['#button-chat'].getAttribute).toHaveBeenCalledWith('aria-pressed');
    expect(elements['#button-chat'].click).toHaveBeenCalledTimes(1);
    expect(elements['#panel-chat'].waitForDisplayed).toHaveBeenCalledTimes(1);
    expect(elements['#send-message'].setValue).toHaveBeenCalledWith('hello');
    expect(browser.keys).toHaveBeenCalledWith('\uE007');
  });

  it('does not click an already-open Chat panel', () => {
    const message = fakeElement();
    const messages = fakeElement();
    messages.$.mockReturnValue(message);
    const elements = {
      '#button-chat': fakeElement('true'),
      '#panel-chat': fakeElement(),
      '#receive-message': messages,
    };
    const { page } = createPage(elements);

    page.findMessage('hello');

    expect(elements['#button-chat'].getAttribute).toHaveBeenCalledWith('aria-pressed');
    expect(elements['#button-chat'].click).not.toHaveBeenCalled();
    expect(elements['#panel-chat'].waitForDisplayed).toHaveBeenCalledTimes(1);
  });

  it('finds messages in the rebuilt Chat panel markup', () => {
    const message = fakeElement();
    const messages = fakeElement();
    messages.$.mockReturnValue(message);
    const elements = {
      '#button-chat': fakeElement('false'),
      '#panel-chat': fakeElement(),
      '#receive-message': messages,
    };
    const { page } = createPage(elements);

    expect(page.findMessage('hello')).toBe(message);
    expect(elements['#button-chat'].click).toHaveBeenCalledTimes(1);
    expect(messages.$).toHaveBeenCalledWith('div*=hello');
  });

  it('waits for mute state through transient roster status', () => {
    const status = fakeElement();
    status.getAttribute.mockReturnValueOnce('weak').mockReturnValue('muted');
    const participant = fakeElement();
    participant.$.mockReturnValue(status);
    const roster = fakeElement();
    roster.$.mockReturnValue(participant);
    const elements = {
      '#button-participants': fakeElement('false'),
      '#panel-participants': fakeElement(),
      '#roster': roster,
    };
    const { browser, page } = createPage(elements);

    expect(page.isPersonMuted('target')).toBe(true);
    expect(browser.waitUntil).toHaveBeenCalledTimes(1);
    expect(elements['#button-participants'].click).toHaveBeenCalledTimes(1);
    expect(roster.$).toHaveBeenCalledWith('li*=target');
    expect(participant.$).toHaveBeenCalledWith('.roster-status');
    expect(status.getAttribute).toHaveBeenCalledWith('data-status');
  });

  it('waits until a participant is no longer muted', () => {
    const status = fakeElement();
    status.getAttribute.mockReturnValueOnce('muted').mockReturnValue('');
    const participant = fakeElement();
    participant.$.mockReturnValue(status);
    const roster = fakeElement();
    roster.$.mockReturnValue(participant);
    const elements = {
      '#button-participants': fakeElement('false'),
      '#panel-participants': fakeElement(),
      '#roster': roster,
    };
    const { browser, page } = createPage(elements);

    expect(page.personVolumeStatus('target')).toBe('');
    expect(browser.waitUntil).toHaveBeenCalledTimes(1);
    expect(status.getAttribute).toHaveBeenCalledWith('data-status');
  });

  it('leaves and rejoins through the demo controls', () => {
    const elements = {
      '#button-meeting-leave': fakeElement(),
      '#button-confirm-leave': fakeElement(),
      '#flow-left': fakeElement(),
      '#left-rejoin': fakeElement(),
      '#flow-meeting': fakeElement(),
    };
    const { page } = createPage(elements);

    page.leaveMeeting();
    page.rejoinMeeting();

    expect(elements['#button-meeting-leave'].click).toHaveBeenCalledTimes(1);
    expect(elements['#button-confirm-leave'].click).toHaveBeenCalledTimes(1);
    expect(elements['#flow-left'].waitForDisplayed).toHaveBeenCalledTimes(1);
    expect(elements['#left-rejoin'].click).toHaveBeenCalledTimes(1);
    expect(elements['#flow-meeting'].waitForDisplayed).toHaveBeenCalledTimes(1);
  });
});
