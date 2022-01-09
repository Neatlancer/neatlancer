const { teal } = require("tailwindcss/colors");

module.exports = {
  content: [
    "./index.html",
    "./src/**/*.{vue,js,ts,jsx,tsx}",
    "./node_modules/atmosphere-ui/**/*.vue",
    "./node_modules/vue-ethers/**/*.js",
  ],
  theme: {
    extend: {
      colors: {
        primary: {
          DEFAULT: teal[500],
          ...teal,
        },
      },
    },
  },
  plugins: [],
};
