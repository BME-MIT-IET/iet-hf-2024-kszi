import { test, expect } from '@playwright/test';
//tries to create a new form, however, no element has been added, publish button stays on the same page
test('test', async ({ page }) => {
  await page.goto('https://localhost:7211/');
  await page.getByRole('link', { name: 'Create' }).click();
  await page.getByLabel('Form Title').click();
  await page.getByLabel('Form Title').fill('form');
  await page.getByLabel('Form Subtitle').click();
  await page.getByLabel('Form Subtitle').fill('subtitle');
  await page.getByLabel('Results password').click();
  await page.getByLabel('Results password').fill('pass');
  await page.getByRole('button', { name: 'Publish' }).click();
  await page.locator('div').filter({ hasText: 'Results password' }).nth(2).click();
});