import { defineCollection, z } from 'astro:content';
import { glob } from 'astro/loaders';

const blog = defineCollection({
	loader: glob({ pattern: '**/*.{md,mdx}', base: './src/content/blog' }),
	schema: z.object({
		title: z.string(),
		description: z.string(),
		pubDate: z.coerce.date(),
		updatedDate: z.coerce.date().optional(),
		heroImage: z.string().optional(),
	}),
});

const studies = defineCollection({
	loader: glob({ pattern: '**/*.{md,mdx}', base: './src/content/studies' }),
	schema: z.object({
		title: z.string(),
		position: z.string(),
		description: z.string(),
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

export const collections = { blog, studies };
