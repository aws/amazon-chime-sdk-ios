/// <reference types="jest" />
import { buildHelperDemoUrl, requireDemoUrl } from './DemoUrlUtils';

describe('requireDemoUrl', () => {
  it('returns the trimmed demo URL', () => {
    expect(requireDemoUrl('  https://example.com/Prod/ ')).toBe('https://example.com/Prod/');
  });

  it.each([undefined, '', '   '])('rejects a missing demo URL (%p)', (value) => {
    expect(() => requireDemoUrl(value)).toThrow(/helper demo URL is required/);
  });
});

describe('buildHelperDemoUrl', () => {
  it('enables developer options and fatal errors', () => {
    const result = new URL(buildHelperDemoUrl('https://example.com/Prod/'));

    expect(result.origin + result.pathname).toBe('https://example.com/Prod/');
    expect(result.searchParams.get('dev')).toBe('1');
    expect(result.searchParams.get('fatal')).toBe('1');
  });

  it('preserves custom query parameters and replaces stale test options', () => {
    const result = new URL(
      buildHelperDemoUrl('https://example.com/Prod/?custom=value&dev=0&fatal=0')
    );

    expect(result.searchParams.get('custom')).toBe('value');
    expect(result.searchParams.get('dev')).toBe('1');
    expect(result.searchParams.get('fatal')).toBe('1');
  });

  it('adds the canary region without dropping test options', () => {
    const result = new URL(buildHelperDemoUrl('https://example.com/Prod/', 'us-east-1'));

    expect(result.searchParams.get('dev')).toBe('1');
    expect(result.searchParams.get('fatal')).toBe('1');
    expect(result.searchParams.get('region')).toBe('us-east-1');
  });
});
