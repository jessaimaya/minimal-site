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
		// Legacy single framework support (optional for backward compatibility)
		framework: z.enum(['macroquad', 'raylib', 'threejs']).optional(),
		// New multi-framework support
		frameworks: z.array(z.object({
			name: z.enum(['macroquad', 'raylib', 'threejs']),
			displayName: z.string(),
			sourceCode: z.string().optional(),
			sourceFile: z.string().optional() // Path to source file
		})).optional(),
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
