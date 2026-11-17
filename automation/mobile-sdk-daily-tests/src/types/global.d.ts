declare type Nullable<T> = T | null | undefined;

declare namespace NodeJS {
  interface Global {
    targetDevice: WebdriverIO.DriverObject;
    helperBrowser: WebdriverIO.DriverObject;
    driver: any;
  }
}

declare namespace WebdriverIO {
  interface Element {
    targetBrowser: WebdriverIO.BrowserObject & WebdriverIO.Element;
    targetDevice: WebdriverIO.BrowserObject & WebdriverIO.Element;
    helperBrowser: WebdriverIO.BrowserObject & WebdriverIO.Element;
  }
  type DriverObject = WebdriverIO.BrowserObject & ImageComparisonService;
}

declare class ImageComparisonService {
  saveElement(
    element: WebdriverIO.Element,
    tag: string,
    driver?: any,
    options?: any,
    isBase?: boolean
  ): Promise<any>;

  saveScreen(tag: string, driver?: any, isBase?: boolean): Promise<any>;

  compareScreen(
    tag: string,
    checkScreenOptions?: any,
    driver?: any
  ): Promise<any>;

  compareElement(
    element: WebdriverIO.Element,
    tag: string,
    checkElementOptions?: any,
    driver?: any
  ): Promise<any>;
}
