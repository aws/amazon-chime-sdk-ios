/* eslint-disable no-console */
import { readFileSync } from 'fs-extra';
import { resolve } from 'path';
import { saveBase64Image } from './saveBase64Image';
import { addBlockOuts } from './addBlockOuts';
import pixelMatch from 'pixelmatch';
import { Dimension } from './rectangles';
import { PNG } from 'pngjs';
import JPEG from 'jpeg-js';

export interface ScreeCompareFolder {
  actual: string;
  diff: string;
  baseline: string;
}
/**
 * Compare 2 images with each other
 *
 * @param {object}  folders
 * @param {string}  fileName
 * @param {object}  options
 *
 * @return {Promise<{
 *      fileName: {string},
 *      folders: {object},
 *      misMatchPercentage: number
 * }>}
 */
export async function executeCompare(folders: any, fileName: string, options: any): Promise<any> {
  //   if (options.ignoreAlpha) {
  //     options.ignore.push('alpha');
  //   }
  //   if (options.ignoreAntialiasing) {
  //     options.ignore.push('antialiasing');
  //   }
  //   if (options.ignoreColors) {
  //     options.ignore.push('colors');
  //   }
  //   if (options.ignoreLess) {
  //     options.ignore.push('less');
  //   }
  //   if (options.ignoreNothing) {
  //     options.ignore.push('nothing');
  //   }

  //   // Create the ignored boxes variable
  const ignoredBoxes =
    options.output && options.output.ignoredBoxes ? [...options.output.ignoredBoxes] : [];
  // Now adjust the ignored boxes array for the ResembleJS API (which is a total mess :( )
  if (ignoredBoxes.length > 0) {
    options.output.ignoredBoxes = options.output.ignoredBoxes.map((ignoredBox: Dimension) => {
      return {
        bottom: ignoredBox.top + ignoredBox.bottom,
        right: ignoredBox.left + ignoredBox.right,
        left: ignoredBox.left,
        top: ignoredBox.top,
      };
    });
  }

  // Execute the compare and retrieve the data
  let actualFile;
  let baseFile;
  try {
    actualFile = PNG.sync.read(readFileSync(resolve(folders.actual, fileName)));
  } catch (err) {
    // Sometimes it gets jpg format instead of png (could be saucelab issue)
    actualFile = JPEG.decode(readFileSync(resolve(folders.actual, fileName)));
  }
  try {
    baseFile = PNG.sync.read(readFileSync(resolve(folders.baseline, fileName)));
  } catch (err) {
    baseFile = JPEG.decode(readFileSync(resolve(folders.baseline, fileName)));
  }

  const { width, height } = baseFile;
  const output = new PNG({ width, height });
  const pixelDiff = pixelMatch(actualFile.data, baseFile.data, output.data, width, height, options);
  const diff = pixelDiff / (width * height);

  const misMatchPercentage = options.rawMisMatchPercentage ? diff : Number(diff.toFixed(2));
  // Save the diff when there is a diff or when debug mode is on
  if (misMatchPercentage > options.saveAboveTolerance || options.debug) {
    // Save the diff with the blockouts
    await saveBase64Image(
      resolve(folders.diff, fileName),
      await addBlockOuts(Buffer.from(PNG.sync.write(output)).toString('base64'), ignoredBoxes)
    );
  }

  // Return the comparison data
  return {
    fileName,
    folders,
    misMatchPercentage,
  };
}
