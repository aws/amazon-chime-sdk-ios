import * as AWS from 'aws-sdk';

const { CLOUD_WATCH_METRIC, TEST_TYPE } = process.env;

AWS.config.update({ region: 'us-east-1' });
const cloudWatch = new AWS.CloudWatch({
  apiVersion: '2010-08-01',
});

export const emitMetricsSync = (
  driver: any,
  namespace: string,
  capabilities: any,
  metric_name: string,
  value: any
) => {
  return driver.call(() => {
    return emitMetrics(namespace, capabilities, metric_name, value);
  });
};

export const emitMetrics = async (
  namespace: string,
  capabilities: any,
  metric_name: string,
  value: any
) => {
  if (!CLOUD_WATCH_METRIC) {
    return;
  }
  namespace = `${process.env.TEST_TYPE}/${namespace.trim()}`;
  metric_name = metric_name.trim();
  console.log(`Emitting metric: ${namespace}/${metric_name} : ${value}`);
  let params = createParams(capabilities, metric_name, namespace, value);
  await publishToCloudWatch(params);
  // platformVersion and name
  params = createParams(capabilities, metric_name, namespace, value, false, true, true, true);
  await publishToCloudWatch(params);
  // just name
  params = createParams(capabilities, metric_name, namespace, value, false, false, false, true);
  await publishToCloudWatch(params);
  // just device type
  params = createParams(capabilities, metric_name, namespace, value, true, false, false, false);
  await publishToCloudWatch(params);
  // no dimension
  params = createParams(capabilities, metric_name, namespace, value, false, false, false, false);
  await publishToCloudWatch(params);
};

const publishToCloudWatch = async (params: any) => {
  try {
    await cloudWatch.putMetricData(params).promise();
  } catch (error) {
    console.error(`Unable to emit metric: ${error}`);
  }
};

const createParams = (
  capabilities: any,
  metric_name: string,
  namespace: string,
  value: any,
  addDeviceModel: boolean = true,
  addPlatformVersion: boolean = true,
  roundPlatformVersion: boolean = false,
  addPlatformName: boolean = true
) => {
  const dimensions: any[] = [];
  if (addDeviceModel) {
    dimensions.push({
      Name: 'DeviceName',
      Value: capabilities.testobject_device_name,
    });
  }
  if (addPlatformVersion) {
    if (roundPlatformVersion) {
      dimensions.push({
        Name: 'PlatformVersion',
        Value: capabilities.platformVersion.split('.')[0],
      });
    } else {
      dimensions.push({
        Name: 'PlatformVersion',
        Value: capabilities.platformVersion,
      });
    }
  }
  if (addPlatformName) {
    dimensions.push({
      Name: 'PlatformName',
      Value: capabilities.platformName,
    });
  }

  return {
    MetricData: [
      {
        MetricName: metric_name,
        ...(dimensions.length > 0 && { Dimensions: dimensions }),
        Unit: 'None',
        Value: value,
      },
    ],
    Namespace: namespace,
  };
};
