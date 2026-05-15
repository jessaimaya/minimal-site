---
title: 'EatIn App'
position: 'Full-Stack Engineer & UI Designer'
description: "A two-sided marketplace connecting home cooks with nearby eaters — supporting dine-in, pickup, and delivery. I owned the full stack end-to-end: product architecture, design system, mobile and web frontends, backend services, and CI/CD pipeline, under a 4-month delivery target."
task:
    - Owned full-stack architecture decisions from day one — selecting the technology stack, infrastructure providers, and deployment strategy for a two-sided marketplace under a tight delivery constraint.
    - Designed and implemented a cross-platform component library in React Native and React, driven by a Figma design system — establishing a single source of truth for UI across mobile and web surfaces.
    - Built real-time order tracking and cook availability systems using WebSockets, managing concurrent state updates across user and cook dashboards without race conditions.
    - Implemented JWT authentication and role-based access control across all surfaces, ensuring secure session handling and data isolation between user types.
    - Set up end-to-end CI/CD pipelines using GitHub Actions, Heroku, TestFlight, and AWS Device Farm — automating builds, integration tests, and device deployments to enable continuous delivery on mobile.
    - Integrated Google Maps geolocation API for proximity-based cook discovery and real-time delivery tracking.
    - Defined user journeys for both cooks and eaters through Figma prototypes before implementation, validating interaction flows early to reduce scope creep mid-sprint.
clients:
    -
        title: EatIn App
        link: https://www.linkedin.com/company/eatin-app/
        logo: /img/eatin-app-bw.png
        logoi: /img/eatin-app-bwi.png

stack:
    - React Native
    - React
    - TypeScript
    - FeatherJS
    - Socket.io
    - JWT Auth
    - Redux
    - Styled Components
    - MongoDB
    - Google Cloud Platform
    - GitHub Actions
    - Figma
challenges:
    - "Delivered a functional two-sided marketplace prototype in 3–4 months by making pragmatic technology choices early and deferring non-essential complexity until after the core flow was stable."
    - "Managed WebSocket state consistency across concurrent user and cook sessions — ensuring real-time updates (order status, availability, notifications) remained in sync without race conditions."
    - "Bootstrapped a full design-to-code pipeline as a two-person team: Figma design system → shared component library → production UI, eliminating the handoff bottleneck that typically costs weeks in larger teams."
    - "Designed secure authentication and payment flows without a dedicated security engineer, applying JWT best practices and researching payment gateway compliance requirements independently."

---
EatIn was the most concentrated exercise in **end-to-end ownership** I've had. When you're the only engineer making architecture decisions, there is nowhere to defer: every technology choice, infrastructure trade-off, and UX decision lands on you.

The constraint — a **functional prototype in under four months** — forced a discipline that large-team projects often lack: ruthless prioritization. I mapped the critical path on day one and worked backward from it. Features that didn't serve the core user flow were deferred without negotiation. Tools were chosen for what they could deliver today, not for what they might scale to hypothetically.

The most technically demanding piece was the **real-time layer**. A two-sided marketplace means two independent sessions — cook and eater — need to see the same state without latency. I implemented WebSocket event handling with explicit acknowledgement patterns to prevent silent failures, and tested concurrent update scenarios before considering the feature complete.

The **design system** was a forcing function for the frontend architecture. Building it in Figma first — with tokens for color, spacing, and type — meant the component library had a contract to implement against, not just a mockup to approximate. That discipline is one I've carried into every project since: the interface between design and engineering should be a specification, not an interpretation.
