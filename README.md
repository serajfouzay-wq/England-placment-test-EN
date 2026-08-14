# Horizon English Academy template

A responsive multi-page demo website for an English language centre. It includes a free placement test, natural editorial photography, subtle motion, and a browser-based content editor.

## Run it

Open `index.html` in a browser. No build step is required. The public pages are `courses.html`, `about.html`, `library.html`, `consultation.html`, and `level-test.html`.

## Demo site manager

Use **Site manager** in the navigation and enter `excel-admin`.

The editor changes the centre name, copy, WhatsApp number, colours, image URLs, courses, testimonials, and contact information. Changes are stored only in the current browser using local storage; use **Export settings** to save a JSON backup.

## Important before production

- The password is deliberately a demo-only UI gate and is public in the browser source. Replace it with Supabase Auth and server-side authorization before deployment.
- The photos use remote Unsplash image URLs. Replace them with licensed photography of the actual centre and students.
- The placement-test and consultation forms are currently client-side only. The assessment includes an honesty declaration, timer, one-way questions, and tab-focus notices, but browser code cannot truly prevent cheating. Add Supabase tables, RLS policies, CAPTCHA/rate limiting, privacy consent, server-side timestamps, and error handling before collecting real data.
- Replace the sample testimonials with real feedback used with student permission.
