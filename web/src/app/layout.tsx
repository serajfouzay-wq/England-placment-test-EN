import type { Metadata } from "next";
import { Inter, DM_Serif_Display } from "next/font/google";
import "./globals.css";

const inter = Inter({ 
  subsets: ["latin"], 
  variable: "--font-inter" 
});

const dmSerif = DM_Serif_Display({ 
  weight: "400", 
  subsets: ["latin"], 
  variable: "--font-dm-serif" 
});

export const metadata: Metadata = {
  title: "Excel English | Free CEFR Placement Test",
  description: "Find your real English level in 15 minutes with our accurate CEFR placement test.",
};

export default function RootLayout({
  children,
}: Readonly<{
  children: React.ReactNode;
}>) {
  return (
    <html lang="en">
      <body className={`${inter.variable} ${dmSerif.variable} font-sans antialiased bg-[#fdfcfb] text-[#1a202c]`}>
        {children}
      </body>
    </html>
  );
}