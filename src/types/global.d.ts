declare global {
  interface Window {
    Module?: {
      ccall: (name: string, returnType: string | null, argTypes: string[], args: any[]) => any;
    };
    fractal_trees_threejs?: {
      init_fractal_trees_threejs: (canvasId: string) => void;
      start_fractal_trees_threejs: () => void;
      stop_fractal_trees_threejs: () => void;
      update_fractal_trees_threejs_params: (iterations: number, angle: number, length: number) => void;
    };
    [key: string]: any;
  }
}

export {};