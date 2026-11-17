export const PLATFORM = {
  WEB: 'web',
  MOBILE: 'mobile',
  DESKTOP: 'desktop',
};

export const SUITE = {
  CLIENT: 'client',
};

export const STAGE = {
  DEV: 'dev',
  ALPHA: 'alpha',
  BETA: 'beta',
  GAMMA: 'gamma',
  PILOT: 'pilot',
  PROD: 'prod',
};

export const RING = {
  CURRENT: 'current',
  BETA: 'beta',
  STABLE: 'stable',
};

export const DEFAULT_TIMEOUT = 30_000;

export const MOBILE_PLATFORM = {
  ANDROID: 'android',
  IOS: 'ios',
};

export enum JOIN_OPTION {
  noCallKit = 0,
  callKitIncoming = 1,
  callKitOutgoing = 2,
}

// More supported devices can be found https://www.browserstack.com/list-of-browsers-and-platforms/js_testing

/*
  Android devices: Samsung Galaxy S9 Plus, Samsung Galaxy S8 Plus, Samsung Galaxy S10, Samsung Galaxy Note 10 Plus, Samsung Galaxy Note 10, Samsung Galaxy Note 9, Samsung Galaxy S9, Samsung Galaxy Note 8, Samsung Galaxy A8, Samsung Galaxy S8, Samsung Galaxy S7, Samsung Galaxy Note 4, Samsung Galaxy S6, Samsung Galaxy S5, Google Pixel 3a XL, Google Pixel 3a, Google Pixel 3 XL, Google Pixel 3, Google Pixel 2, Google Pixel, Google Nexus 6, Google Nexus 5, OnePlus 7, OnePlus 6T, Motorola Moto X 2nd Gen, LG G5, Samsung Galaxy Tab S4, Samsung Galaxy Tab S3, Samsung Galaxy Tab 4, Google Nexus 9
  iOS devices: iPhone XS, iPhone 11 Pro Max, iPhone 11 Pro, iPhone 11, iPhone XS Max, iPhone XR, iPhone X, iPhone 8, iPhone 8 Plus, iPhone 7, iPhone 7 Plus, iPhone 6S, iPhone 6S Plus, iPhone 6, iPhone SE, iPad Pro 12.9 2018, iPad Pro 11 2018, iPad Mini 2019, iPad Air 2019, iPad Pro 9.7 2016, iPad Pro 12.9 2017, iPad Mini 4, iPad 6th, iPad 5th
*/

// Alias
export const SUPPORTED_DEVICES_MAP: { [key: string]: string } = {
  s5: 'Samsung Galaxy S5',
  s6: 'Samsung Galaxy S6',
  s7: 'Samsung Galaxy S7',
  s8: 'Samsung Galaxy S8',
  s9: 'Samsung Galaxy S9',
  s10: 'Samsung Galaxy S10',
  'note 10': 'Samsung Galaxy Note 10',
  'note 10 plus': 'Samsung Galaxy Note 10 Plus',
  'note 9': 'Samsung Galaxy Note 9',
  'note 8': 'Samsung Galaxy Note 8',
  a8: 'Samsung Galaxy A8',
};

export const SUPPORTED_ANDROID_DEVICES = new Set<string>([
  'Samsung Galaxy S8',
  'Samsung Galaxy S9',
  'Samsung Galaxy S10',
  'Samsung Galaxy S9 Plus',
  'Samsung Galaxy S8 Plus',
  'Samsung Galaxy Note 10 Plus',
  'Samsung Galaxy Note 10',
  'Samsung Galaxy Note 9',
  'Samsung Galaxy Note 8',
  'Samsung Galaxy A8',
  'Samsung Galaxy S8',
  'Samsung Galaxy S7',
  'Google Pixel 3a XL',
  'Google Pixel 3a',
  'Google Pixel 3 XL',
  'Google Pixel 3',
  'Google Pixel 2',
  'OnePlus 6T',
  'Samsung Galaxy Note 4',
  'Samsung Galaxy S5',
  'Samsung Galaxy S6',
  'Google Pixel',
  'Google Nexus 6',
  // Google Nexus 5,
  // OnePlus 7,
  // Motorola Moto X 2nd Gen,
  // LG G5,
  // Samsung Galaxy Tab S4,
  // Samsung Galaxy Tab S3,
  // Samsung Galaxy Tab 4,
  // Google Nexus 9
]);

export const SUPPORTED_IOS_DEVICES = new Set<string>([
  'iPhone X',
  'iPhone 11',
  'iPhone XS',
  'iPhone XS Max',
  'iPhone 11 Pro Max',
  'iPhone 11 Pro',
  'iPhone XR',
  'iPhone 8',
  'iPhone 8 Plus',
  'iPhone 7',
  'iPhone 7 Plus',
  'iPhone 6S',
  'iPhone 6S Plus',
  'iPhone 6',
  'iPhone SE',
  // iPad Pro 12.9 2018,
  // iPad Pro 11 2018,
  // iPad Mini 2019,
  // iPad Air 2019,
  // iPad Pro 9.7 2016,
  // iPad Pro 12.9 2017,
  // iPad Mini 4,
  // iPad 6th,
  // iPad 5th
]);

SUPPORTED_ANDROID_DEVICES.forEach((androidDevice: string) => {
  SUPPORTED_DEVICES_MAP[androidDevice.toLocaleLowerCase()] = androidDevice;
});
SUPPORTED_IOS_DEVICES.forEach((iosDevice: string) => {
  SUPPORTED_DEVICES_MAP[iosDevice.toLocaleLowerCase()] = iosDevice;
});

export const helperParticipant = 'participate1';
export const targetParticipant = 'participate2';

export const oldMessageText1 = 'old message 1';
export const oldMessageText2 = 'old message 2';

export const SECONDS = 1_000;
export const ONE_SECOND = SECONDS;

export const expectedTranscribedMessage =
  'My fellow Americans, tonight, I’d like to talk with you about immigration. For more than 200 years, our tradition of welcoming immigrants from around the world has given us a tremendous advantage over other nations. It’s kept us youthful, dynamic, and entrepreneurial.';
