var tailwindcss = require('tailwindcss');

module.exports = {
    plugins: [
        require('postcss-import')(),
        tailwindcss('./src/tailwind.config.js'),
        require('autoprefixer'),
    ],
};
