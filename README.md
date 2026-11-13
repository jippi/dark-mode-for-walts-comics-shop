# Dark mode for Walt's Comic Shop (unofficial)

A dark theme for [waltscomicshop.com](https://waltscomicshop.com). CSS only: no scripts, no network requests, no data collected.

Not affiliated with or endorsed by Walt's Comic Shop.

![Home page in dark mode](screenshots/01-home.png)

## Install

- **Chrome, Edge, Brave, Vivaldi, Arc:** [Chrome Web Store](https://chromewebstore.google.com/detail/dkblkanljfclibldicedkpgneogjnfhb)
- **Firefox:** [Firefox Add-ons](https://addons.mozilla.org/firefox/addon/dark-mode-for-walts-comic-shop/)

### Stylus (any browser)

1. Install [Stylus](https://add0n.com/stylus.html).
2. Open [walts-dark.user.css](https://raw.githubusercontent.com/jippi/dark-mode-for-walts-comics-shop/main/walts-dark.user.css) and click "Install style".

Stylus picks up new versions by itself.

### From source

1. Download this repo (Code > Download ZIP) and unzip it.
2. Open `chrome://extensions` and turn on "Developer mode".
3. Click "Load unpacked" and pick the unzipped folder.

## Turn it off

Disable the style in Stylus, or the extension in your browser's extension page, and reload.

## Develop

Edit `dark.css`, then run `./build.sh` (needs `python3` and `zip`). It writes:

- `dist/chrome.zip` and `dist/firefox.zip` for the browser stores
- `walts-dark.user.css` for Stylus, which is committed

Bump `version` in `manifest.json` before a release, or Stylus won't see an update.

Something looks wrong on a page? Open an issue with the URL and a screenshot.
