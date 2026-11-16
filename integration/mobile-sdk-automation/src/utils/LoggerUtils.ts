import * as winston from "winston";

const { combine, timestamp, label, printf } = winston.format;

/**
 * Create logger that logs to the console
 * @param labelTexts Label added to each log entry
 *
 * @example
 * const log = createLogger('Label');
 *
 * // Prints
 * // [2019-09-19T23:29:09.055Z] [Label] INFO: Hello Chime
 * log.info('Hello Chime');
 *
 * @example
 * const log = createLogger('Label1', 'Label2');
 *
 * // Prints
 * // [2019-09-19T23:29:09.055Z] [Label1][Label2] INFO: Hello Chime
 * log.info('Hello Chime');
 */
export const createLogger = (...labelTexts: string[]): winston.Logger => {
  const transports = new winston.transports.Console();
  const loggerFormat = printf(
    info =>
      `[${info.timestamp}] ${info.label} ${info.level.toUpperCase()}: ${
        info.message
      }`
  );
  const labels = labelTexts.map(labelText => `[${labelText}]`);

  return winston.createLogger({
    format: combine(
      timestamp(),
      label({ label: labels.join("") }),
      loggerFormat
    ),
    transports
  });
};
