import fs from 'fs';
import path from 'path';

/**
 * Reads source code from a file path relative to the native projects directory
 */
export function loadSourceCode(sourceFile: string): string {
  try {
    const fullPath = path.join(process.cwd(), 'src/native', sourceFile);
    return fs.readFileSync(fullPath, 'utf-8');
  } catch (error) {
    console.warn(`Could not load source file: ${sourceFile}`, error);
    return `// Could not load source file: ${sourceFile}`;
  }
}

/**
 * Gets the appropriate source code for a framework, either from embedded code or file
 */
export function getFrameworkSourceCode(
  framework: {
    name: string;
    displayName: string;
    sourceCode?: string | undefined;
    sourceFile?: string | undefined;
  },
  projectName: string = 'fractal-trees'
): string {
  // If sourceCode is provided, use it (legacy support)
  if (framework.sourceCode) {
    return framework.sourceCode;
  }
  
  // If sourceFile is provided, load from file
  if (framework.sourceFile) {
    return loadSourceCode(framework.sourceFile);
  }
  
  // Fallback: try to infer the file path based on naming conventions
  switch (framework.name) {
    case 'macroquad':
      return loadSourceCode(`macroquad/${projectName}/src/lib.rs`);
    case 'raylib':
      return loadSourceCode(`raylib/${projectName}/main.cpp`);
    case 'threejs':
      return loadSourceCode(`macroquad/${projectName}/threejs/src/main.ts`);
    default:
      return `// Unknown framework: ${framework.name}`;
  }
}