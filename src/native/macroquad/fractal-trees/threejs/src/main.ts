import * as THREE from 'three';

// Global state
let scene: THREE.Scene;
let camera: THREE.PerspectiveCamera;
let renderer: THREE.WebGLRenderer;
let animationId: number | null = null;
let treeGroup: THREE.Group;

// Parameters
let params = {
    iterations: 5,
    angle: 25,
    length: 100
};

export function init_fractal_trees_threejs(canvasId: string): void {
    const canvas = document.getElementById(canvasId) as HTMLCanvasElement;
    if (!canvas) {
        console.error('Canvas not found:', canvasId);
        return;
    }

    // Setup scene
    scene = new THREE.Scene();
    scene.background = new THREE.Color(0x000000);

    // Setup camera
    const aspect = canvas.width / canvas.height;
    camera = new THREE.PerspectiveCamera(75, aspect, 0.1, 1000);
    camera.position.set(0, 0, 300);
    camera.lookAt(0, 0, 0);

    // Setup renderer
    renderer = new THREE.WebGLRenderer({ canvas, antialias: true });
    renderer.setSize(canvas.width, canvas.height);

    // Create group for tree
    treeGroup = new THREE.Group();
    scene.add(treeGroup);

    // Initial tree generation
    generateTree();
}

export function start_fractal_trees_threejs(): void {
    if (animationId !== null) return;
    
    const animate = () => {
        animationId = requestAnimationFrame(animate);
        
        // Gentle rotation animation
        if (treeGroup) {
            treeGroup.rotation.z += 0.002;
        }
        
        render();
    };
    
    animate();
}

export function stop_fractal_trees_threejs(): void {
    if (animationId !== null) {
        cancelAnimationFrame(animationId);
        animationId = null;
    }
}

export function update_fractal_trees_threejs_params(iterations: number, angle: number, length: number): void {
    params.iterations = Math.max(1, Math.min(10, Math.round(iterations)));
    params.angle = Math.max(10, Math.min(45, angle));
    params.length = Math.max(50, Math.min(150, length));
    
    generateTree();
}

function generateTree(): void {
    // Clear existing tree
    treeGroup.clear();

    // Create material for branches
    const material = new THREE.LineBasicMaterial({ 
        color: 0xffffff,
        linewidth: 2
    });

    // Start drawing from bottom center
    const startX = 0;
    const startY = -150;
    const initialAngle = Math.PI / 2; // Point upward

    drawBranch(startX, startY, params.length, initialAngle, params.iterations, material);
}

function drawBranch(
    x: number, 
    y: number, 
    length: number, 
    angle: number, 
    depth: number, 
    material: THREE.LineBasicMaterial
): void {
    if (depth === 0) return;

    // Calculate end point
    const endX = x + length * Math.cos(angle);
    const endY = y + length * Math.sin(angle);

    // Create line geometry
    const geometry = new THREE.BufferGeometry().setFromPoints([
        new THREE.Vector3(x, y, 0),
        new THREE.Vector3(endX, endY, 0)
    ]);

    // Create line mesh
    const line = new THREE.Line(geometry, material);
    treeGroup.add(line);

    // Recursive calls for branches
    const newLength = length * 0.67; // Reduce length by ~33%
    const angleRadians = (params.angle * Math.PI) / 180;
    
    // Left branch
    drawBranch(
        endX, 
        endY, 
        newLength, 
        angle + angleRadians, 
        depth - 1, 
        material
    );
    
    // Right branch
    drawBranch(
        endX, 
        endY, 
        newLength, 
        angle - angleRadians, 
        depth - 1, 
        material
    );
}

function render(): void {
    if (renderer && scene && camera) {
        renderer.render(scene, camera);
    }
}