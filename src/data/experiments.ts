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

// Everything listed here links to a real, public, non-fork repository.
// Add new work at the top of its group as it ships.
export const experimentGroups: ExperimentGroup[] = [
  {
    id: "ai-systems",
    title: "AI & systems",
    lede: "LLM agents with tool definitions, MCP servers, prompt evaluation, and locally hosted open-weight models.",
    items: [
      {
        title: "code-recall",
        repo: "https://github.com/jessaimaya/code-recall",
        year: "2026",
        stack: "FSRS · local-first",
        blurb:
          "Spaced repetition for developers — practice coding interviews the way you actually work. Built on the FSRS scheduling algorithm.",
      },
      {
        title: "the-coop",
        repo: "https://github.com/jessaimaya/the-coop",
        demo: "https://the-coop.vercel.app",
        year: "2025",
        stack: "TypeScript",
        blurb:
          "A flexible structure that assembles itself around each project — connecting the right talents to build what no one could build alone.",
      },
    ],
  },
  {
    id: "games-wasm",
    title: "Games & WebAssembly",
    lede: "Rust compiled to WebAssembly, and a Godot project — where the art and animation training meets the systems work.",
    items: [
      {
        title: "wasm_snake",
        repo: "https://github.com/jessaimaya/wasm_snake",
        year: "2024",
        stack: "Rust → WASM",
        blurb: "Snake, written in Rust and compiled to WebAssembly.",
      },
      {
        title: "connect_four",
        repo: "https://github.com/jessaimaya/connect_four",
        year: "2024",
        stack: "Rust → WASM",
        blurb: "Connect Four with move evaluation, in Rust and WebAssembly.",
      },
      {
        title: "godot_demo",
        repo: "https://github.com/jessaimaya/godot_demo",
        year: "2024",
        stack: "Godot · GDScript",
        blurb: "A Godot project exploring scene composition and GDScript.",
      },
      {
        title: "2048",
        repo: "https://github.com/jessaimaya/2048",
        year: "2021",
        stack: "Rust · Mogwai",
        blurb: "2048 implemented in Rust on the Mogwai reactive framework.",
      },
    ],
  },
  {
    id: "generative",
    title: "Generative graphics",
    lede: "Drawing with code — canvas, WebGL, and Rust/WASM frontend frameworks (Yew, Sycamore, Leptos).",
    items: [
      {
        title: "wassily_poster",
        repo: "https://github.com/jessaimaya/wassily_poster",
        year: "2022",
        stack: "Rust → WASM · web-sys",
        blurb:
          "A poster generator inspired by Wassily Kandinsky's paintings — every render is a new composition.",
      },
      {
        title: "leptos_tic-tac-toe",
        repo: "https://github.com/jessaimaya/leptos_tic-tac-toe",
        year: "2024",
        stack: "Rust · Leptos",
        blurb:
          "Exploring fine-grained reactivity in Leptos, a Rust frontend framework.",
      },
    ],
  },
];
