/// <reference types="jest" />

const putMetricData = jest.fn(() => ({ promise: () => Promise.resolve() }));

jest.mock('aws-sdk', () => ({
  config: { update: jest.fn() },
  CloudWatch: jest.fn(() => ({ putMetricData })),
}));

const capabilities = {
  testobject_device_name: 'iPhone 13',
  platformVersion: '16.4',
  platformName: 'iOS',
};

const originalEnv = { ...process.env };

const loadEmitMetrics = (env: Record<string, string | undefined>) => {
  jest.resetModules();
  process.env = { ...originalEnv, ...env };
  return require('./CloudWatchUtils').emitMetrics;
};

describe('emitMetrics', () => {
  beforeEach(() => {
    putMetricData.mockClear();
  });

  afterAll(() => {
    process.env = originalEnv;
  });

  it('does not publish when CLOUD_WATCH_METRIC is unset', async () => {
    const emitMetrics = loadEmitMetrics({ CLOUD_WATCH_METRIC: undefined, TEST_TYPE: 'Daily' });

    await emitMetrics('AudioTest', capabilities, 'E2E', 1);

    expect(putMetricData).not.toHaveBeenCalled();
  });

  it('publishes each dimension combination under the TEST_TYPE namespace when enabled', async () => {
    const emitMetrics = loadEmitMetrics({ CLOUD_WATCH_METRIC: 'true', TEST_TYPE: 'Daily' });

    await emitMetrics(' AudioTest ', capabilities, ' E2E ', 0);

    expect(putMetricData).toHaveBeenCalledTimes(5);
    const calls = putMetricData.mock.calls as unknown as any[][];
    const dimensionNames = calls.map(([params]) => {
      expect(params.Namespace).toBe('Daily/AudioTest');
      expect(params.MetricData[0]).toMatchObject({ MetricName: 'E2E', Value: 0, Unit: 'None' });
      return (params.MetricData[0].Dimensions || []).map((d: any) => `${d.Name}=${d.Value}`);
    });
    expect(dimensionNames).toEqual([
      ['DeviceName=iPhone 13', 'PlatformVersion=16.4', 'PlatformName=iOS'],
      ['PlatformVersion=16', 'PlatformName=iOS'],
      ['PlatformName=iOS'],
      ['DeviceName=iPhone 13'],
      [],
    ]);
  });
});
