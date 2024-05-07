import { test, expect } from '@playwright/test';

test('test', async ({ page }) => {
  // Recording...await page.goto('https://localhost:7211/');
  await page.getByRole('link', { name: 'Create' }).click();
  await page.getByText('Add element').click();
  await page.getByRole('button', { name: 'Text element' }).click();
});