// The site's colour palette. Accents and experiments use only these colours.
// Each one is also a CSS variable, `--palette-<name>`, set in BaseHead.
export const palette = {
  peach: "#FFDBBA",
  salmon: "#FFACA8",
  coral: "#FF8894",
  seafoam: "#A1E0DD",
  teal: "#5CC2C6",
  steel: "#88AED2",
  mint: "#D4F1D8",
  blush: "#F7DFF6",
  pink: "#FA85B9",
  orchid: "#C387C2",
  sky: "#A4E9FF",
  blue: "#5EA8E6",
  mist: "#D2D8D9",
  slate: "#ADB5BB",
} as const;

export type PaletteColor = keyof typeof palette;

// Ordered colours an experiment blends through, from start to end.
// The pale ones (peach, mint, blush, sky, mist) barely show on the light
// theme, so ramps keep them for the ends if at all.
export const ramps = {
  // Cool to warm: blue trunk, orchid and pink through to coral tips
  bloom: ["blue", "orchid", "pink", "coral", "salmon"],
  // Blues to greens: blue trunk, steel and teal through to seafoam tips
  tide: ["blue", "steel", "teal", "seafoam"],
} as const satisfies Record<string, readonly PaletteColor[]>;

export type Ramp = keyof typeof ramps;

export const rampNames = Object.keys(ramps) as [Ramp, ...Ramp[]];

export const rampColors = (ramp: Ramp): string[] =>
  ramps[ramp].map((name) => palette[name]);

export const paletteCss = `:root {\n${Object.entries(palette)
  .map(([name, hex]) => `  --palette-${name}: ${hex};`)
  .join("\n")}\n}`;
