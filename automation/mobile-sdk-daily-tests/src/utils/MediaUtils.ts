import { createLogger } from "./LoggerUtils";

const log = createLogger("MediaUtils");

// Note: This method is executed in browser context
// It uses AnalyserNode here to capture audio stream
// from source, for example, an <audio> element.
// For each run (every 50 ms), it takes a snapshot of current
// frequency data into a Float32Array, i.e., frequencyData, and
// scan the array to find the hot frequency. If the hot frequency
// is within the expected range (2 of bin size) of the targetFrequency,
// then we know it receives something that we expect. Since the mock
// audio stream we are receiving is not continuously at or around
// the target frequency, and the snapshot may be taken at bad time,
// we need to do multiple runs (recommended for at least 20 runs, span of 1 second)
// in order to capture enough snapshots.
const runAudioToneCheck = async (
  runCount: number,
  targetFrequency: number,
  sourceElementId: string,
  callback: Function
): Promise<void> => {
  let pass = 0;

  const delay = (timeout: number): Promise<void> =>
    new Promise(resolve => setTimeout(resolve, timeout));
  const audioContext = new (AudioContext ||
    (window as any).webkitAudioContext)();
  const analyser = audioContext.createAnalyser();
  const frequencyData = new Float32Array(analyser.frequencyBinCount);
  const binSize = audioContext.sampleRate / analyser.fftSize;
  const stream = (document.getElementById(sourceElementId) as HTMLAudioElement)
    .srcObject;
  const source = audioContext.createMediaStreamSource(stream as MediaStream);
  source.connect(analyser);

  // Wait for 1 second to avoid the empty beginning state
  await delay(1_000);

  for (let i = 0; i < runCount; i++) {
    let maxDb = -Infinity;
    let hotFrequency = 0;

    analyser.getFloatFrequencyData(frequencyData);

    frequencyData.forEach((value, index) => {
      if (value > maxDb) {
        maxDb = value;
        hotFrequency = index * binSize;
      }
    });

    const error = Math.abs(hotFrequency - targetFrequency);

    if (error <= 2 * binSize) {
      pass += 1;
    }

    await delay(50);
  }
  callback(pass / runCount);
};

// Note: This method is executed in browser context
// This method take a snapshot of specified video stream
// by drawing an image on canvas, and return the sum of all pixels.
// The sum will be used to determine if there are any diffs of each
// snapshot, so that we can know if we can receive new frame.
const getPixelSumByIndex = function(index: number): number {
  const getSum = (total: number, num: number): number => total + num;
  const canvas = document.createElement("canvas");
  const ctx = canvas.getContext("2d") as CanvasRenderingContext2D;
  const videos = document.getElementsByTagName("video");
  const video = videos[index];
  if (!video) {
    return 0;
  }

  ctx.drawImage(video, 0, 0, video.videoHeight, video.videoWidth);
  const imageData = ctx.getImageData(0, 0, video.videoHeight, video.videoWidth)
    .data;
  return imageData.reduce(getSum);
};

export const canReceiveAudioTone = (
  browser: WebdriverIO.BrowserObject,
  targetFrequency: number
): boolean => {
  const PASS_THRESHOLD = 0.05;
  const RUN_COUNT = 50;
  const RETRY_LIMIT = 2;

  let passRate = 0;
  let retries = 0;
  while (passRate === 0 && retries < RETRY_LIMIT) {
    passRate = browser.executeAsync(
      runAudioToneCheck,
      RUN_COUNT,
      targetFrequency,
      "chime-audio"
    );
    retries += 1;
  }

  log.info(`Received pass rate: ${passRate}`);

  return passRate >= PASS_THRESHOLD;
};

export const canReceiveVideoFrame = (
  browser: WebdriverIO.BrowserObject,
  index: number
): boolean => {
  const RETRY_LIMIT = 2;

  let sum1 = 0;
  let sum2 = 0;
  let retries = 0;
  while (sum1 === sum2 && retries < RETRY_LIMIT) {
    browser.pause(1_000);
    sum1 = browser.execute(getPixelSumByIndex, index);
    browser.pause(1_000);
    sum2 = browser.execute(getPixelSumByIndex, index);
    retries += 1;
  }

  log.info(
    `Received video pixel sum for index [${index}]: ${sum1} and ${sum2}`
  );

  return sum1 !== sum2;
};

export const isSelf = (subject: string): boolean => {
  return subject.startsWith("I");
};
