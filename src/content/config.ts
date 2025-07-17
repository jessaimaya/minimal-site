import { defineCollection, z } from 'astro:content';

const blog = defineCollection({
	type: 'content',
	// Type-check frontmatter using a schema
	schema: z.object({
		title: z.string(),
		description: z.string(),
		// Transform string to Date object
		pubDate: z.coerce.date(),
		updatedDate: z.coerce.date().optional(),
		heroImage: z.string().optional(),
	}),
});

const projects = defineCollection({
	type: 'content',
	schema: z.object({
		title: z.string(),
		description: z.string(),
		date: z.coerce.date(),
		tags: z.array(z.string()),
		difficulty: z.enum(['beginner', 'intermediate', 'advanced']),
		framework: z.enum(['macroquad', 'raylib']),
		projectName: z.string(),
		originalSource: z.string().optional(),
		controls: z.array(z.object({
			name: z.string(),
			type: z.enum(['range', 'number', 'color', 'checkbox']),
			min: z.number().optional(),
			max: z.number().optional(),
			step: z.number().optional(),
			default: z.union([z.string(), z.number(), z.boolean()]).optional()
		})).optional()
	})
});

export const collections = { blog, projects };
