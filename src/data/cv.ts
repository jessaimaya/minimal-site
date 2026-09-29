// Single source for the CV page and the homepage skill cards.
// Keep in sync with CV/cv.html, which is what the downloadable PDF is printed from.

export type Job = {
  role: string;
  org: string;
  when: string;
  where?: string;
  stack: string;
  study?: string;
  points: string[];
};

export type SkillGroup = {
  id: string;
  title: string;
  feature?: boolean;
  items: string[];
};

export const summary =
  "Frontend engineer with 14+ years building enterprise-scale UI systems for regulated industries, most recently fintech. I work at the level of architecture, performance, and the shared UI infrastructure product teams build on, such as component systems, build tooling and accessibility standards that hold up as codebases grow. Trained in art and animation. Currently building with LLM APIs, agents and MCP, alongside games and generative graphics.";

export const jobs: Job[] = [
  {
    role: "Senior UI Engineer",
    org: "Globant",
    when: "2019-Present",
    where: "México",
    stack: "React, AngularJS, Component Systems, Fintech",
    study: "/studies/globant",
    points: [
      "Build and maintain enterprise interfaces for fintech clients, where accessibility, auditability and browser support are contractual rather than optional.",
      "Design and maintain shared component systems consumed across product teams, keeping UI coherent as feature work scales out.",
      "Work across modern React and legacy AngularJS codebases through long-running platform transitions, owning front-end performance and WCAG conformance as ongoing responsibilities instead of one-off audits.",
      "Build with LLM APIs in product work, including structured output, tool and function definitions and MCP, and use agentic coding tools day to day.",
    ],
  },
  {
    role: "Fullstack Developer & Designer",
    org: "EatIn App",
    when: "Jan-Aug 2019",
    stack: "React, Feathers.js, Figma",
    study: "/studies/eatin",
    points: [
      "Sole engineer and designer on the product, from interface design in Figma to the React front end and Feathers.js services.",
    ],
  },
  {
    role: "Tech Lead & Architect",
    org: "Kamikaze Lab",
    when: "2012-2019",
    where: "7 years",
    stack: "React, GraphQL, AWS, Node",
    study: "/studies/kamikaze",
    points: [
      "Led technical direction across client engagements at a digital product studio, covering architecture, delivery and engineering standards.",
      "Architected React and GraphQL applications on AWS including CI/CD, and ran code review and mentoring for the development team.",
    ],
  },
];

export const skills: SkillGroup[] = [
  {
    id: "frontend",
    title: "Front-end",
    feature: true,
    items: ["TypeScript", "ES6", "React", "Next.js", "HTML", "CSS", "Micro-frontends", "Storybook", "PWA", "Web Workers", "a11y", "WCAG"],
  },
  {
    id: "ai",
    title: "AI",
    feature: true,
    items: ["LLM APIs", "agents & tool use", "MCP", "prompt engineering & evals", "local models", "Claude Code", "Cursor"],
  },
  {
    id: "graphics",
    title: "Games & Graphics",
    items: ["Godot", "GDScript", "Rust to WebAssembly", "ThreeJS", "WebGL", "Canvas", "generative art"],
  },
  {
    id: "styling",
    title: "Styling",
    items: ["SCSS", "Sass", "PostCSS", "Styled Components", "Ant Design", "Material", "Bulma", "Bootstrap"],
  },
  {
    id: "tooling",
    title: "Tooling & QA",
    items: ["Webpack", "Vite", "Jest", "React Testing Library", "Cypress", "Figma"],
  },
  {
    id: "backend",
    title: "Back-end",
    items: ["Node", "NestJS", "Express", "GraphQL", "REST", "WebSockets", "Prisma", "MySQL", "MongoDB"],
  },
  {
    id: "infra",
    title: "Infrastructure",
    items: ["AWS", "GCP", "Docker", "Jenkins", "Nginx", "CI/CD"],
  },
];

export const sideWork = [
  "Games and generative graphics in Rust compiled to WebAssembly, including a complete 2048 game and wassily_poster, a Kandinsky-inspired poster generator. Also unfinished Snake and Connect Four prototypes and a first Godot experiment.",
  "More recently, AI and systems work with LLM agents and tool definitions, MCP servers, prompt evaluation and locally hosted open-weight models, alongside Rust and WebAssembly frontend work (Yew, Sycamore, Leptos).",
];
