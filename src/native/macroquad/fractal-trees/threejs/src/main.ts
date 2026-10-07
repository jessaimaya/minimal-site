import * as THREE from 'three';

// Every experiment exposes the same functions to the page: `setup`, `frame`,
// `set_param` and, when it uses colour, `set_palette`. The page owns the loop.

let scene: THREE.Scene;
let camera: THREE.PerspectiveCamera;
let renderer: THREE.WebGLRenderer | null = null;
let treeGroup: THREE.Group;

// Parameters, same units as the Rust version (lengths against a 600px tall view)
const params = {
    iterations: 10,
    angle: 25,
    length: 140
};

// Colours to blend through from trunk to tips. Slate from src/data/palette.ts
// until the page sends the site palette.
let palette: THREE.Color[] = [new THREE.Color('#ADB5BB')];

/** Binds the canvas. Call again after resizing it so the new size is picked up. */
export function setup(canvasId: string): void {
    const canvas = document.getElementById(canvasId) as HTMLCanvasElement | null;
    if (!canvas) {
        console.error('Canvas not found:', canvasId);
        return;
    }

    if (!renderer || renderer.domElement !== canvas) {
        scene = new THREE.Scene();
        camera = new THREE.PerspectiveCamera(50, 1, 1, 4000);

        // Transparent background, so the page shows through in both themes
        renderer = new THREE.WebGLRenderer({ canvas, antialias: true, alpha: true });
        renderer.setClearColor(0x000000, 0);

        treeGroup = new THREE.Group();
        treeGroup.position.y = -300;
        scene.add(treeGroup);
        generateTree();
    }

    // Fit the 720x600 unit tree whatever the canvas shape
    camera.aspect = canvas.clientWidth / canvas.clientHeight;
    const halfFov = Math.tan(THREE.MathUtils.degToRad(25));
    camera.position.set(0, 0, Math.max(320 / halfFov, 380 / (halfFov * camera.aspect)));
    camera.updateProjectionMatrix();
    renderer.setPixelRatio(Math.min(window.devicePixelRatio, 2));
    renderer.setSize(canvas.clientWidth, canvas.clientHeight, false);
    render();
}

/** Draws the tree at `time` seconds, slowly turning around its trunk */
export function frame(time: number): void {
    if (!renderer) return;
    treeGroup.rotation.y = time * 0.25;
    render();
}

/** Sets one control by name (`iterations`, `angle` or `length`) and redraws */
export function set_param(name: string, value: number): void {
    if (name === 'iterations') params.iterations = Math.max(1, Math.min(13, Math.round(value)));
    else if (name === 'angle') params.angle = Math.max(5, Math.min(60, value));
    else if (name === 'length') params.length = Math.max(20, Math.min(200, value));
    else return;

    if (!renderer) return;
    generateTree();
    render();
}

/** Sets the colours to blend through, as comma separated hex (`#5EA8E6,#C387C2`) */
export function set_palette(colors: string): void {
    const parsed = colors
        .split(',')
        .map((hex) => hex.trim())
        .filter((hex) => /^#[0-9a-f]{6}$/i.test(hex))
        .map((hex) => new THREE.Color(hex));
    if (parsed.length === 0) return;
    palette = parsed;

    if (!renderer) return;
    generateTree();
    render();
}

/** Colour at `t` (0 to 1) along the palette, blending neighbours linearly */
function sample(t: number): THREE.Color {
    const last = palette.length - 1;
    const position = Math.min(Math.max(t, 0), 1) * last;
    const index = Math.min(Math.floor(position), last);
    const next = Math.min(index + 1, last);
    return new THREE.Color().lerpColors(palette[index]!, palette[next]!, position - index);
}

function generateTree(): void {
    treeGroup.children.forEach((child) => {
        if (child instanceof THREE.LineSegments) {
            child.geometry.dispose();
            (child.material as THREE.Material).dispose();
        }
    });
    treeGroup.clear();

    // One geometry for every branch, coloured per vertex
    const positions: number[] = [];
    const colors: number[] = [];
    drawBranch(0, 0, params.length, Math.PI / 2, params.iterations, positions, colors);

    const geometry = new THREE.BufferGeometry();
    geometry.setAttribute('position', new THREE.Float32BufferAttribute(positions, 3));
    geometry.setAttribute('color', new THREE.Float32BufferAttribute(colors, 3));
    const material = new THREE.LineBasicMaterial({ vertexColors: true });
    treeGroup.add(new THREE.LineSegments(geometry, material));
}

function drawBranch(
    x: number,
    y: number,
    length: number,
    angle: number,
    depth: number,
    positions: number[],
    colors: number[]
): void {
    if (depth === 0) return;

    const endX = x + length * Math.cos(angle);
    const endY = y + length * Math.sin(angle);
    positions.push(x, y, 0, endX, endY, 0);

    const level = (params.iterations - depth) / Math.max(1, params.iterations - 1);
    const color = sample(level);
    colors.push(color.r, color.g, color.b, color.r, color.g, color.b);

    const newLength = length * 0.75;
    const angleRadians = THREE.MathUtils.degToRad(params.angle);
    drawBranch(endX, endY, newLength, angle + angleRadians, depth - 1, positions, colors);
    drawBranch(endX, endY, newLength, angle - angleRadians, depth - 1, positions, colors);
}

function render(): void {
    if (renderer && scene && camera) {
        renderer.render(scene, camera);
    }
}
