export const requireDemoUrl = (url?: string): string => {
  const trimmed = url?.trim();
  if (!trimmed) {
    throw new Error(
      'A helper demo URL is required. Pass --demo-url or set CAT_DEMO_URL to the deployed Amazon Chime SDK JS meeting demo.'
    );
  }
  return trimmed;
};

export const buildHelperDemoUrl = (url: string, region?: string): string => {
  const helperDemoUrl = new URL(url);
  helperDemoUrl.searchParams.set('dev', '1');
  helperDemoUrl.searchParams.set('fatal', '1');
  if (region) {
    helperDemoUrl.searchParams.set('region', region);
  }
  return helperDemoUrl.toString();
};
