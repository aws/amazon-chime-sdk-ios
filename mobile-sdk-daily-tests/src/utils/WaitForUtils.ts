import { DEFAULT_TIMEOUT } from '../constants';

export const waitForDisplayedThenClick = (
  element: WebdriverIO.Element,
  timeout = DEFAULT_TIMEOUT
): void => {
  const displayed = element.waitForDisplayed(timeout);
  displayed && element.click();
};

export const waitForDisplayed = (
  element: WebdriverIO.Element,
  timeout = DEFAULT_TIMEOUT
): boolean => {
  return element.waitForDisplayed(timeout);
};

export const waitForExist = (element: WebdriverIO.Element, timeout = DEFAULT_TIMEOUT): boolean => {
  return element.waitForExist(timeout);
};

export const waitForNotExist = (
  element: WebdriverIO.Element,
  timeout = DEFAULT_TIMEOUT
): boolean => {
  return element.waitForExist(timeout, true);
};

export const waitForDisplayedAndCheckEnabled = (
  element: WebdriverIO.Element,
  enabled: boolean,
  timeout = DEFAULT_TIMEOUT
): boolean => {
  element.waitForDisplayed(timeout);
  return element.isEnabled() === enabled;
};

export const waitForDisplayedThenGetText = (
  element: WebdriverIO.Element,
  timeout = DEFAULT_TIMEOUT
): string => {
  element.waitForDisplayed(timeout);
  return element.getText();
};

export const waitForDisplayedThenGetAttribute = (
  element: WebdriverIO.Element,
  attribute: string,
  timeout = DEFAULT_TIMEOUT
): string => {
  element.waitForDisplayed(timeout);
  return element.getAttribute(attribute);
};

export const waitForDisplayedThenSetValue = (
  element: WebdriverIO.Element,
  value: any,
  timeout = DEFAULT_TIMEOUT
): void => {
  element.waitForDisplayed(timeout);
  element.setValue(value);
};

export const waitForDisplayedThenAddValue = (
  element: WebdriverIO.Element,
  value: any,
  timeout = DEFAULT_TIMEOUT
): void => {
  element.waitForDisplayed(timeout);
  element.addValue(value);
};

export const waitForDisappeared = (
  element: WebdriverIO.Element,
  timeout = DEFAULT_TIMEOUT
): boolean => {
  return element.waitForDisplayed(timeout, true);
};

export const waitForDisplayedTextThenClick = (
  element: WebdriverIO.Element,
  displayedText: string,
  timeout = DEFAULT_TIMEOUT
): boolean => {
  element.waitForDisplayed(timeout);
  if (element.getText() === displayedText) {
    element.click();
    return true;
  }
  return false;
};

export const waitForDisplayedText = (
  element: WebdriverIO.Element,
  expectedText: string,
  timeout = DEFAULT_TIMEOUT
): boolean => {
  browser.waitUntil(() => {
    return element.getText() === expectedText;
  }, timeout);
  return element.getText() === expectedText;
};
