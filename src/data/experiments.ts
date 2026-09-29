export type Experiment = {
  title: string;
  repo: string;
  year: string;
  stack: string;
  blurb: string;
  demo?: string;
};

export type ExperimentGroup = {
  id: string;
  title: string;
  lede: string;
  items: Experiment[];
};

// Everything listed here links to a real, public, non-fork repository,
// and each blurb matches what the code actually does today.
// Add new work at the top of its group as it ships.
export const experimentGroups: ExperimentGroup[] = [
  {
    id: "products",
    title: "Products",
    lede: "Sites and apps built for real use.",
    items: [
      {
        title: "the-coop",
        repo: "https://github.com/jessaimaya/the-coop",
        demo: "https://the-coop.vercel.app",
        year: "2025",
        stack: "Next.js, TypeScript, Vitest, Playwright",
        blurb:
          "Website for coop, a collective that builds small teams around each project.",
      },
    ],
  },
  {
    id: "games-wasm",
    title: "Games & WebAssembly",
    lede: "Rust compiled to WebAssembly, where the art and animation training meets the systems work.",
    items: [
      {
        title: "2048",
        repo: "https://github.com/jessaimaya/2048",
        year: "2021",
        stack: "Rust, Mogwai",
        blurb: "2048 in Rust on the Mogwai framework, with score, undo and restart.",
      },
      {
        title: "connect_four",
        repo: "https://github.com/jessaimaya/connect_four",
        year: "2024",
        stack: "Rust, Leptos",
        blurb: "Unfinished. Screens and board are built; game logic isn't yet.",
      },
      {
        title: "wasm_snake",
        repo: "https://github.com/jessaimaya/wasm_snake",
        year: "2024",
        stack: "Rust to WebAssembly, TypeScript",
        blurb: "Unfinished. The snake moves and turns; no food or scoring yet.",
      },
    ],
  },
  {
    id: "generative",
    title: "Generative graphics",
    lede: "Drawing with code in the browser.",
    items: [
      {
        title: "wassily_poster",
        repo: "https://github.com/jessaimaya/wassily_poster",
        year: "2022",
        stack: "Rust to WebAssembly, web-sys",
        blurb:
          "A poster generator inspired by Wassily Kandinsky's paintings. Every render is a new composition.",
      },
    ],
  },
];
