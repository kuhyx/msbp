/* eslint-disable @typescript-eslint/naming-convention */
import eslint from "@eslint/js";
import tseslint from "typescript-eslint";

const MAX_FUNCTION_LENGTH = 20, MAX_LINES = 200;

export default tseslint.config(
  eslint.configs.all,
  ...tseslint.configs.all,
  {
    languageOptions: {
      parserOptions: {
        projectService: true,
        tsconfigRootDir: import.meta.dirname,
      },
    },
  },
  {
    ignores: [".angular", "**/*.spec.ts", "dist"],
  },
  {
    rules: {
      "@typescript-eslint/consistent-type-imports": "off",
      "max-lines": ["error", MAX_LINES],
      "max-lines-per-function": ["error", MAX_FUNCTION_LENGTH],
      "new-cap": "off",
    },
  },
);
