module.exports = {
  presets: [
    '@babel/flow',
    [
      '@babel/preset-env',
      {
        targets: {
          node: 'current'
        }
      }
    ]
  ],
  plugins: ['@babel/plugin-proposal-nullish-coalescing-operator', ['module-resolver', {
    alias: {
      'bs-platform/lib/es6': 'bs-platform/lib/js'
    }
  }]]
};
