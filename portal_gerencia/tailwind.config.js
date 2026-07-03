/** @type {import('tailwindcss').Config} */
export default {
  content: ['./index.html', './src/**/*.{js,ts,jsx,tsx}'],
  theme: {
    extend: {
      colors: {
        incasur: {
          azul: '#0E6481',
          azuloscuro: '#0A4D63',
          amarillo: '#EAEA00',
          verde: '#2E7D32',
          dorado: '#D4A843',
        },
      },
    },
  },
  plugins: [],
}
