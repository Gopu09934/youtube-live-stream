const { chromium } = require('playwright');

(async () => {
    const url = process.argv[2];

    const browser = await chromium.launch({ headless: true });
    const page = await browser.newPage();

    let streamUrl = null;

    page.on('response', async (response) => {
        const rurl = response.url();
        if (rurl.includes("m3u8") || rurl.includes("manifest")) {
            streamUrl = rurl;
        }
    });

    await page.goto(url, { waitUntil: "networkidle" });

    await page.waitForTimeout(10000);

    console.log(streamUrl || "");

    await browser.close();
})();
