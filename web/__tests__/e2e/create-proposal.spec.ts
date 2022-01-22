/* eslint-disable node/no-unpublished-import */
import { test, expect } from "@playwright/test";

test("create proposal", async ({ page }) => {
  await page.goto("http://localhost:3001/");
  await page.locator("text=Connect").first().click();
  await expect(page).toHaveTitle(/Create Proposals/);
});
