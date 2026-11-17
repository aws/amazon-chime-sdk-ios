module.exports = {
  collectCoverageFrom: ["src/**/*.ts"],
  coverageDirectory: "coverage",
  coverageReporters: ["text", "html", "cobertura"],
  testRegex: ["^.*\\.test\\.ts$"],
  testEnvironment: "node",
  transform: {
    "^.+\\.ts?$": "ts-jest"
  },
  verbose: true
};
