import { string } from 'yargs';

export const parseString = (message: string): string[] => {
  return message
    .replace(/[^a-zA-Z0-9 ]/g, '')
    .toLowerCase()
    .trim()
    .split(/\s+/g);
};

export const compareTranscripts = (actualContent: string[], expectedContent: string[]): any => {
  if (actualContent.length === 0 || expectedContent.length === 0) {
    return actualContent.length === expectedContent.length;
  }

  // Otherwise, compute a naive recall: are expected tokens present in transcripts?
  const total = expectedContent.length; // > 0
  let hits = 0;
  for (var i = 0; i < expectedContent.length; i++) {
    if (actualContent.includes(expectedContent[i])) {
      hits++;
      actualContent.splice(actualContent.indexOf(expectedContent[i]), 1);
    }
  }

  const hitPct = (100 * hits) / total;
  if (hitPct < 80) {
    return false;
  }

  return true;
};
