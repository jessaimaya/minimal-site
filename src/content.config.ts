import { defineCollection, z } from 'astro:content';
import { glob } from 'astro/loaders';
import { rampNames } from './data/palette';

const studies = defineCollection({
	loader: glob({ pattern: '**/*.{md,mdx}', base: './src/content/studies' }),
	schema: z.object({
		title: z.string(),
		position: z.string(),
		description: z.string(),
		metaDescription: z.string(),
		task: z.array(z.string()),
		clients: z.array(z.object({
			title: z.string(),
			link: z.string(),
			logo: z.string(),
			logoi: z.string(),
		})),
		gallery: z.array(z.object({
			title: z.string(),
			source: z.string(),
		})).optional(),
		stack: z.array(z.string()),
		challenges: z.array(z.string()),
	}),
});

// Blog posts, each with something running in it: either a live experiment
// (builds in public/dist/wasm/<experiment>/, sources in src/native/) or an
// embedded project hosted elsewhere.
const blog = defineCollection({
	loader: glob({ pattern: '**/*.{md,mdx}', base: './src/content/blog' }),
	schema: z.object({
		title: z.string(),
		description: z.string(),
		date: z.coerce.date(),
		experiment: z.string().optional(),
		// Colour ramp from src/data/palette.ts, handed to the experiment
		ramp: z.enum(rampNames).default('bloom'),
		runtimes: z.array(z.object({
			type: z.enum(['wasm', 'script']),
			label: z.string(),
			// Path under public/ to the module (wasm) or script exposing a global (script)
			src: z.string(),
			global: z.string().optional(),
			// Path under src/native/ shown in the source panel
			source: z.string(),
		})).default([]),
		controls: z.array(z.object({
			name: z.string(),
			label: z.string(),
			min: z.number(),
			max: z.number(),
			step: z.number(),
			value: z.number(),
		})).default([]),
		credit: z.object({ label: z.string(), url: z.string() }).optional(),
		// A project hosted elsewhere, loaded in an iframe when the reader presses play
		embed: z.object({
			src: z.string().url(),
			title: z.string(),
			// Path under public/ shown before the project loads
			poster: z.string(),
			// CSS aspect ratio of the frame, e.g. "9 / 16"
			aspect: z.string().default('16 / 9'),
		}).optional(),
		// Path under public/ used for link previews
		cover: z.string().optional(),
		stack: z.array(z.string()).default([]),
		links: z.array(z.object({ label: z.string(), url: z.string().url() })).default([]),
	}).refine((post) => post.embed || (post.experiment && post.runtimes.length > 0), {
		message: 'A post needs either an experiment with runtimes, or an embed',
	}),
});

export const collections = { studies, blog };
