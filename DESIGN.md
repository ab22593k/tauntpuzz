# Design System Specification: High-End Editorial

## 1. Overview & Creative North Star

**Creative North Star: The Digital Curator**

This design system is not a template; it is a gallery. It rejects the cluttered "e-commerce" look in favor of a high-end fashion magazine aesthetic. We achieve this through **Intentional Asymmetry**, where whitespace is treated as a physical element rather than "empty" space. By leveraging extreme contrasts—deep blacks against expansive, breathable whites—we create a rhythm that guides the eye through a curated narrative. The goal is to make every scroll feel like turning the page of a heavy, matte-finish editorial.

## 2. Colors & Tonal Depth

The palette is strictly monochromatic, but it is never flat. We utilize Material Design tonal tiers to create a sense of physical layering.

### The "No-Line" Rule

**Explicit Instruction:** 1px solid borders are strictly prohibited for sectioning or containment. Structural boundaries must be defined solely through:

- **Background Shifts:** A `surface-container-low` (#f3f3f3) section sitting on a `surface` (#f9f9f9) background.
- **Negative Space:** Using the Spacing Scale (specifically levels 16 to 24) to create a visual "void" between content blocks.

### Surface Hierarchy & Nesting

Treat the UI as a series of stacked sheets of fine vellum.

- **Base Layer:** `surface` (#f9f9f9) for the primary page background.
- **Nested Content:** Use `surface-container-lowest` (#ffffff) for product cards or featured modules to create a "lifted" feel against the slightly warmer base.
- **Depth:** Reserve `primary` (#000000) for high-impact focus areas, ensuring the `on-primary` (#e2e2e2) text maintains sophisticated legibility.

### The "Glass & Texture" Rule

To add a "signature" feel, use **Glassmorphism** for navigation bars and floating action menus.

- **Implementation:** Apply a `surface-container` (#eeeeee) color at 70% opacity with a `backdrop-blur` of 20px.
- **Gradients:** Use subtle tonal gradients (e.g., `primary` #000000 to `primary-container` #3b3b3b) for primary CTAs to avoid a "flat vector" look and provide a satin-like finish.

## 3. Typography

Typography is the voice of this brand. The interplay between the Noto Serif and Inter creates a dialogue between tradition and modernity.

- **Display & Headlines (Noto Serif):** Use `display-lg` (3.5rem) and `headline-lg` (2rem) for editorial titles. These should often be center-aligned or intentionally offset to the left to break the grid.
- **Titles & Body (Inter):** Use `title-md` (1.125rem) for product names and `body-md` (0.875rem) for descriptions. The sans-serif provides a "crisp" utilitarian contrast to the romanticism of the serif.
- **Labels (Inter):** `label-sm` (0.6875rem) should be used for metadata like "SKU" or "Composition," often in all-caps with increased letter spacing (+0.1rem) to mimic architectural notation.

## 4. Elevation & Depth

We eschew traditional drop shadows for **Tonal Layering**.

- **The Layering Principle:** Place a `surface-container-lowest` (#ffffff) card on a `surface-container-low` (#f3f3f3) section. The slight shift in hex value creates a "soft lift" that feels premium and organic.
- **Ambient Shadows:** If a floating element (like a quick-cart) is required, use a shadow with a 40px blur, 0% spread, and 4% opacity of the `on-surface` (#1b1b1b) color.
- **The "Ghost Border" Fallback:** If a boundary is required for accessibility, use the `outline-variant` (#c6c6c6) at **15% opacity**. Never use 100% opaque lines.

## 5. Components

### Buttons

- **Primary:** Solid `primary` (#000000) with `on-primary` (#e2e2e2) text. 0px corner radius. Padding: `spacing-4` (1.4rem) horizontal.
- **Secondary:** Transparent background with a "Ghost Border." Text in `primary`.
- **Tertiary:** Underlined text using `primary` color, no background. The underline should be 1px and offset by 4px.

### Input Fields

- **Styling:** No bounding box. Use a 1px `outline-variant` bottom-border only.
- **States:** On focus, the bottom border transitions to `primary` (#000000). Labels use `label-md` and sit above the input.

### Cards & Lists

- **Forbid Dividers:** Use `spacing-12` (4rem) to separate list items rather than lines.
- **Imagery:** Product images should occupy 100% of the card width. Use `surface-dim` (#dadada) as a placeholder color to maintain the monochromatic aesthetic during loading.

### Boutique-Specific Components

- **The Editorial Carousel:** A full-bleed slider using `display-lg` typography overlaid on high-contrast photography.
- **Lookbook Spacing:** Use the `24` spacing token (8.5rem) between major sections to enforce the "Ultra-Minimalist" feel.

## 6. Do's and Don'ts

### Do

- **Embrace Asymmetry:** Offset text blocks from images to create an editorial flow.
- **Use White as a Color:** Treat `surface` (#f9f9f9) as a luxury material. Give elements room to breathe.
- **High Contrast:** Ensure `primary` (#000000) is used sparingly for maximum impact (CTAs and Headings).

### Don't

- **No Rounded Corners:** `roundedness-scale` is strictly 0px. Circles/radii break the "chic/sharp" aesthetic.
- **No Heavy Shadows:** Traditional Material Design shadows are too "tech." Stay flat or use tonal shifts.
- **No Standard Grids:** Avoid the "3-column product grid" where possible. Try a 2-column staggered layout to feel more bespoke.
- **No Icons for Icons' sake:** Only use icons (thin-stroke) if they are strictly necessary for navigation. Prefer text labels in `label-md`.

---

name: High-End Editorial Noir
colors:
surface: "#131313"
surface-dim: "#131313"
surface-bright: "#393939"
surface-container-lowest: "#0e0e0e"
surface-container-low: "#1b1b1b"
surface-container: "#1f1f1f"
surface-container-high: "#2a2a2a"
surface-container-highest: "#353535"
on-surface: "#e2e2e2"
on-surface-variant: "#c6c6c6"
inverse-surface: "#e2e2e2"
inverse-on-surface: "#303030"
outline: "#919191"
outline-variant: "#474747"
surface-tint: "#c6c6c6"
primary: "#ffffff"
on-primary: "#1b1b1b"
primary-container: "#d4d4d4"
on-primary-container: "#000000"
inverse-primary: "#5e5e5e"
secondary: "#c8c6c5"
on-secondary: "#1c1b1b"
secondary-container: "#474746"
on-secondary-container: "#e5e2e1"
tertiary: "#e4e2e2"
on-tertiary: "#1b1c1c"
tertiary-container: "#919090"
on-tertiary-container: "#000000"
error: "#ffb4ab"
on-error: "#690005"
error-container: "#93000a"
on-error-container: "#ffdad6"
primary-fixed: "#5e5e5e"
primary-fixed-dim: "#474747"
on-primary-fixed: "#ffffff"
on-primary-fixed-variant: "#e2e2e2"
secondary-fixed: "#c8c6c5"
secondary-fixed-dim: "#adabaa"
on-secondary-fixed: "#1c1b1b"
on-secondary-fixed-variant: "#3c3b3b"
tertiary-fixed: "#5e5e5e"
tertiary-fixed-dim: "#474747"
on-tertiary-fixed: "#ffffff"
on-tertiary-fixed-variant: "#e4e2e2"
background: "#131313"
on-background: "#e2e2e2"
surface-variant: "#353535"
typography:
display-lg:
fontFamily: Noto Serif
fontSize: 3.5rem
fontWeight: "400"
lineHeight: "1.1"
headline-lg:
fontFamily: Noto Serif
fontSize: 2rem
fontWeight: "400"
lineHeight: "1.2"
title-md:
fontFamily: Inter
fontSize: 1.125rem
fontWeight: "500"
lineHeight: "1.5"
body-md:
fontFamily: Inter
fontSize: 0.875rem
fontWeight: "400"
lineHeight: "1.6"
label-sm:
fontFamily: Inter
fontSize: 0.6875rem
fontWeight: "600"
lineHeight: "1.4"
letterSpacing: 0.1rem

---

# Design System Specification: High-End Editorial Noir

## 1. Overview & Creative North Star

**Creative North Star: The Midnight Curator**

This design system is not a template; it is a gallery. It rejects the cluttered "e-commerce" look in favor of a high-end fashion magazine aesthetic, now translated into a deep, cinematic dark mode. We achieve this through **Intentional Asymmetry**, where dark space is treated as a physical element rather than "empty" space. By leveraging extreme contrasts—stark whites against expansive, breathable blacks—we create a rhythm that guides the eye through a curated narrative. The goal is to make every scroll feel like turning the page of a heavy, matte-finish editorial.

## 2. Colors & Tonal Depth

The palette is strictly monochromatic and optimized for dark mode. We utilize Material Design tonal tiers to create a sense of physical layering within a dark space.

### The "No-Line" Rule

**Explicit Instruction:** 1px solid borders are strictly prohibited for sectioning or containment. Structural boundaries must be defined solely through:

- **Background Shifts:** A `surface-container-high` (#2a2a2a) section sitting on a `surface` (#000000) background.
- **Negative Space:** Using the Spacing Scale (specifically levels 16 to 24 based on the spacing-2 unit) to create a visual "void" between content blocks.

### Surface Hierarchy & Nesting

Treat the UI as a series of stacked sheets of fine vellum.

- **Base Layer:** `surface` (#000000) for the primary page background.
- **Nested Content:** Use `surface-container-low` (#1a1a1a) for product cards or featured modules to create a "defined" feel against the pure black base.
- **Contrast:** Reserve white (`on-surface`) for high-impact focus areas, ensuring the text maintains sophisticated legibility against the dark background.

### The "Glass & Texture" Rule

To add a "signature" feel, use **Glassmorphism** for navigation bars and floating action menus.

- **Implementation:** Apply a `surface-container` (#1a1a1a) color at 70% opacity with a `backdrop-blur` of 20px.
- **Gradients:** Use subtle tonal gradients (e.g., `surface` #000000 to `surface-container` #1a1a1a) for primary backgrounds to avoid a "flat vector" look.

## 3. Typography

Typography is the voice of this brand. The interplay between Noto Serif and Inter creates a dialogue between tradition and modernity.

- **Display & Headlines (Noto Serif):** Use `display-lg` (3.5rem) and `headline-lg` (2rem) for editorial titles. These should often be center-aligned or intentionally offset to the left to break the grid.
- **Titles & Body (Inter):** Use `title-md` (1.125rem) for product names and `body-md` (0.875rem) for descriptions. The white text provides a "crisp" contrast to the dark void.
- **Labels (Inter):** `label-sm` (0.6875rem) should be used for metadata like "SKU" or "Composition," often in all-caps with increased letter spacing (+0.1rem).

## 4. Elevation & Depth

We eschew traditional drop shadows for **Tonal Layering**.

- **The Layering Principle:** Place a `surface-container-low` (#1a1a1a) card on a `surface` (#000000) section. The slight shift in hex value creates a "soft lift" that feels premium and organic in a dark environment.
- **Ambient Glow:** If a floating element is required, use a shadow with a 40px blur and very low opacity (4%) white color to simulate a soft glow rather than a heavy shadow.
- **The "Ghost Border" Fallback:** If a boundary is required for accessibility, use the `outline-variant` (#4d4d4d) at **15% opacity**. Never use 100% opaque lines.

## 5. Components

### Buttons

- **Primary:** Solid white (`on-surface`) with black (`surface`) text. 0px corner radius. Padding: `spacing-4` (approx 0.8rem based on spacing unit 2) horizontal.
- **Secondary:** Transparent background with a "Ghost Border." Text in white.
- **Tertiary:** Underlined text using white color, no background. The underline should be 1px and offset by 4px.

### Input Fields

- **Styling:** No bounding box. Use a 1px `outline-variant` bottom-border only.
- **States:** On focus, the bottom border transitions to white. Labels use `label-md` and sit above the input.

### Cards & Lists

- **Forbid Dividers:** Use high spacing tokens to separate list items rather than lines.
- **Imagery:** Product images should occupy 100% of the card width. Use `surface-container-high` (#2a2a2a) as a placeholder color.

### Boutique-Specific Components

- **The Editorial Carousel:** A full-bleed slider using `display-lg` typography overlaid on high-contrast photography.
- **Lookbook Spacing:** Use the largest spacing tokens between major sections to enforce the "Ultra-Minimalist" feel.

## 6. Do's and Don'ts

### Do

- **Embrace Asymmetry:** Offset text blocks from images to create an editorial flow.
- **Use Black as a Color:** Treat the `surface` (#000000) as a luxury material. Give elements room to breathe in the dark.
- **High Contrast:** Ensure white text is used sparingly for maximum impact.

### Don't

- **No Rounded Corners:** `roundedness` is strictly 0px. Sharp edges are mandatory.
- **No Heavy Shadows:** Traditional shadows are too "tech." Stay flat or use tonal shifts/faint glows.
- **No Standard Grids:** Avoid the "3-column product grid" where possible. Try a 2-column staggered layout to feel more bespoke.
- **No Icons for Icons' sake:** Only use icons (thin-stroke) if they are strictly necessary. Prefer text labels in `label-md`.
