/* eslint-disable no-console */
import { access, copySync } from "fs-extra";
import chalk from "chalk";
import { resolve } from "path";
import { nativeAppCompareLog } from "../helpers/logger";
import { ScreeCompareFolder } from "./executeCompare";

/**
 * Check if the given image already exists
 *
 * @param {object}  folders
 * @param {string}  fileName
 * @param {boolean} autoSaveBaseline
 *
 * @return {Promise<*>}
 */
export async function checkBaselineImageExists(
  folders: ScreeCompareFolder,
  fileName: string,
  autoSaveBaseline: boolean
): Promise<any> {
  return new Promise((resolvePromise, rejectPromise) => {
    access(resolve(folders.baseline, fileName), error => {
      if (error) {
        if (autoSaveBaseline) {
          try {
            copySync(
              resolve(folders.actual, fileName),
              resolve(folders.baseline, fileName)
            );
            nativeAppCompareLog.info(
              `\nINFO: Autosaved the image to ${resolve(
                folders.baseline,
                fileName
              )}\n`
            );
          } catch (err) {
            rejectPromise(
              chalk.red(
                `Image could not be copied. The following error was thrown: ${err}`
              )
            );
          }
        } else {
          rejectPromise(
            chalk.yellow(`Image not found, copy your actual image:
'${resolve(folders.actual, fileName)}'
manually to your baseline or enable the option
'autoSaveBaseline: true'
and this module will do that automatically for you.`)
          );
        }
      }
      resolvePromise();
    });
  });
}
