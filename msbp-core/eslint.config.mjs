/* eslint-disable @typescript-eslint/naming-convention */
import eslint from "@eslint/js";
import tseslint from "typescript-eslint";

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
      "new-cap": "off",
    },
  },
);
