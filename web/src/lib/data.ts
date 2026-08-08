cat << 'EOF' > src/lib/data.ts
export type Question = {
  section: number;
  text: string;
  options: string[];
  correct: number;
  level: string;
};

export type Section = {
  name: string;
  icon: string;
  start: number;
  end: number;
};

export type CefrLevel = {
  level: string;
  name: string;
  color: string;
  min: number;
  max: number;
  tagline: string;
  course: string;
  courseDesc: string;
  emoji: string;
};

export const SECTIONS: Section[] = [
  { name: 'Vocabulary', icon: '📚', start: 0, end: 9 },
  { name: 'Grammar', icon: '✏️', start: 10, end: 19 },
  { name: 'Reading Comprehension', icon: '📖', start: 20, end: 29 }
];

export const CEFR_LEVELS: CefrLevel[] = [
  {
    level: 'A1', name: 'Beginner', color: '#9e9e9e',
    min: 0, max: 6,
    tagline: 'You\'re at the start of your English journey — a great place to begin building strong foundations.',
    course: 'Foundation English — Beginner',
    courseDesc: 'Build core vocabulary, basic grammar, and everyday phrases in a supportive, structured environment.',
    emoji: '🌱'
  },
  {
    level: 'A2', name: 'Elementary', color: '#66bb6a',
    min: 7, max: 12,
    tagline: 'You can handle simple conversations and understand everyday English in familiar situations.',
    course: 'General English — Elementary',
    courseDesc: 'Expand your vocabulary and grammar to communicate confidently in daily situations.',
    emoji: '🌿'
  }
];

export const QUESTIONS: Question[] = [
  {
    section: 0,
    text: 'Choose the word that means "very happy".',
    options: ['Furious', 'Elated', 'Anxious', 'Weary'],
    correct: 1, level: 'B1'
  },
  {
    section: 0,
    text: 'The scientist made a remarkable _____ that changed medicine forever.',
    options: ['disaster', 'discovery', 'distraction', 'decoration'],
    correct: 1, level: 'B1'
  }
];
EOF

echo "✅ data.ts successfully created in the correct folder!"