import { outputFileSync } from 'fs-extra';
import { PNG } from 'pngjs';

/**
 * Save the base64 image to a file
 *
 * @param   {string}  filePath
 * @param   {string}  base64Image
 *
 * @returns {Promise<void>}
 */
export function saveBase64Image(filePath: string, base64Image: string): void {
  return outputFileSync(filePath, base64Image, 'base64');
}
