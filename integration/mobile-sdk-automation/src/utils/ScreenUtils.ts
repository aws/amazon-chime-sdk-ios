export const saveBaselineScreen = (
  driver: WebdriverIO.DriverObject,
  tag: string
): any => {
  return driver.call(() => {
    return driver.saveScreen(tag, driver, true);
  });
};

export const compareScreen = (
  driver: WebdriverIO.DriverObject,
  tag: string
): any => {
  return driver.call(() => {
    return driver.compareScreen(tag, {}, driver);
  });
};

export const saveBaselineElement = (
  element: WebdriverIO.Element,
  driver: WebdriverIO.DriverObject,
  tag: string
): any => {
  return driver.call(() => {
    return driver.saveElement(element, tag, driver, {}, true);
  });
};

export const compareElement = (
  element: WebdriverIO.Element,
  driver: WebdriverIO.DriverObject,
  tag: string
): any => {
  return driver.call(() => {
    return driver.compareElement(element, tag, {}, driver);
  });
};
