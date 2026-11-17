export abstract class Screen {
  abstract isLoaded(): boolean;
  constructor(protected readonly browser: WebdriverIO.BrowserObject) {}
}
