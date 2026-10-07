/* tslint:disable */
/* eslint-disable */
/**
 * Draws the tree at `time` seconds: branches sway and the palette drifts
 */
export function frame(time: number): void;
/**
 * Binds the canvas. Call again after resizing it so the new size is picked up.
 */
export function setup(canvas_id: string): void;
export function main(): void;
/**
 * Sets one control by name (`iterations`, `angle` or `length`) and redraws
 */
export function set_param(name: string, value: number): void;
/**
 * Sets the colours to blend through, as comma separated hex (`#5EA8E6,#C387C2`)
 */
export function set_palette(colors: string): void;

export type InitInput = RequestInfo | URL | Response | BufferSource | WebAssembly.Module;

export interface InitOutput {
  readonly memory: WebAssembly.Memory;
  readonly frame: (a: number) => void;
  readonly main: () => void;
  readonly set_palette: (a: number, b: number) => void;
  readonly set_param: (a: number, b: number, c: number) => void;
  readonly setup: (a: number, b: number) => [number, number];
  readonly __wbindgen_exn_store: (a: number) => void;
  readonly __externref_table_alloc: () => number;
  readonly __wbindgen_export_2: WebAssembly.Table;
  readonly __wbindgen_free: (a: number, b: number, c: number) => void;
  readonly __wbindgen_malloc: (a: number, b: number) => number;
  readonly __wbindgen_realloc: (a: number, b: number, c: number, d: number) => number;
  readonly __externref_table_dealloc: (a: number) => void;
  readonly __wbindgen_start: () => void;
}

export type SyncInitInput = BufferSource | WebAssembly.Module;
/**
* Instantiates the given `module`, which can either be bytes or
* a precompiled `WebAssembly.Module`.
*
* @param {{ module: SyncInitInput }} module - Passing `SyncInitInput` directly is deprecated.
*
* @returns {InitOutput}
*/
export function initSync(module: { module: SyncInitInput } | SyncInitInput): InitOutput;

/**
* If `module_or_path` is {RequestInfo} or {URL}, makes a request and
* for everything else, calls `WebAssembly.instantiate` directly.
*
* @param {{ module_or_path: InitInput | Promise<InitInput> }} module_or_path - Passing `InitInput` directly is deprecated.
*
* @returns {Promise<InitOutput>}
*/
export default function __wbg_init (module_or_path?: { module_or_path: InitInput | Promise<InitInput> } | InitInput | Promise<InitInput>): Promise<InitOutput>;
