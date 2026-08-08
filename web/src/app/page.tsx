export default function Home() {
  return (
    <main className="min-h-screen flex flex-col items-center justify-center p-6 text-center">
      <div className="inline-block px-4 py-1.5 mb-6 text-sm font-semibold text-teal-700 bg-teal-50 border border-teal-100 rounded-full">
        Free Test · No Sign-up
      </div>
      
      <h1 className="text-5xl md:text-6xl font-serif text-[#0a4a52] mb-6 leading-tight">
        Find Your <em className="italic text-teal-600">Real</em> English Level
        <br /> in 15 Minutes
      </h1>
      
      <p className="max-w-2xl text-lg text-gray-600 mb-10">
        Our free placement test gives you an accurate CEFR level (A1–C2), a breakdown of your strengths, and a personalised course recommendation — instantly.
      </p>

      <button className="px-8 py-4 text-lg font-bold text-white bg-teal-600 rounded-xl shadow-lg hover:bg-teal-700 hover:-translate-y-1 transition-all duration-200">
        Start Free Test →
      </button>
    </main>
  );
}