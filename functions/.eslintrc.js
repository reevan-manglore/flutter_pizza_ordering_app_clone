module.exports = {
  root: true,
  env: {
    es6: true,
    node: true,
  },
  extends: [
    "eslint:recommended",
    "google",
  ],
  rules: {
    "quotes": ["error", "double"],
    "max-len": [
      "error",
      {
        "code": 150,
        "tabWidth": 2,
        "ignoreComments": true, // "comments": 80
        "ignoreUrls": true,
        "ignoreStrings": true,
        "ignoreTemplateLiterals": true,
      },
    ],
  },

  // Newly added property
  parserOptions: {
    "ecmaVersion": 2020,
  },

};


// module.exports = {
//   root: true,
//   env: {
//     es6: true,
//     node: true,

//   },
//   parserOptions: {
//     ecmaVersion: 8,
//   },
//   extends: [
//     "eslint:recommended",
//     "google",
//   ],
//   rules: {
//     quotes: ["error", "double"],
//   },
// };


