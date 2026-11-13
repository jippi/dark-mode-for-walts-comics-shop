#!/usr/bin/env bash
# Builds dist/chrome.zip, dist/firefox.zip, walts-dark.user.css and walts-dark.user.js.
set -euo pipefail
cd "$(dirname "$0")"

files=(manifest.json dark.css logo-dark.svg icons)
rm -rf dist
mkdir -p dist/chrome dist/firefox

cp -R "${files[@]}" dist/chrome/
cp -R "${files[@]}" dist/firefox/

# Chrome warns on the Firefox-only key.
python3 - <<'PY'
import json
p = "dist/chrome/manifest.json"
m = json.load(open(p))
m.pop("browser_specific_settings")
json.dump(m, open(p, "w"), indent=2)
PY

# Firefox serves extension files from moz-extension://.
sed -i '' 's|chrome-extension://|moz-extension://|g' dist/firefox/dark.css

# Userstyle for Stylus: logo inlined, CSS scoped to the site. Both user files are committed, since managers install from the raw URL.
python3 - <<'PY'
import base64, json, textwrap
repo = "jippi/dark-mode-for-walts-comics-shop"
m = json.load(open("manifest.json"))
version = ".".join((m["version"].split(".") + ["0", "0"])[:3])
logo = base64.b64encode(open("logo-dark.svg", "rb").read()).decode()
css = open("dark.css").read().replace(
    "chrome-extension://__MSG_@@extension_id__/logo-dark.svg",
    "data:image/svg+xml;base64," + logo,
)
header = f"""/* ==UserStyle==
@name         {m["name"]}
@namespace    github.com/{repo}
@version      {version}
@description  {m["description"]}
@homepageURL  https://github.com/{repo}
@updateURL    https://raw.githubusercontent.com/{repo}/main/walts-dark.user.css
==/UserStyle== */
"""
body = '@-moz-document domain("waltscomicshop.com") {\n' + textwrap.indent(css, "  ") + "}\n"
open("walts-dark.user.css", "w").write(header + "\n" + body)

# Userscript for Tampermonkey and friends. GM_addStyle where it exists, a plain <style> otherwise (Greasemonkey 4).
raw = f"https://raw.githubusercontent.com/{repo}/main/walts-dark.user.js"
js = f"""// ==UserScript==
// @name         {m["name"]}
// @namespace    github.com/{repo}
// @version      {version}
// @description  {m["description"]}
// @match        *://*.waltscomicshop.com/*
// @run-at       document-start
// @grant        GM_addStyle
// @homepageURL  https://github.com/{repo}
// @updateURL    {raw}
// @downloadURL  {raw}
// ==/UserScript==

(function () {{
  const css = {json.dumps(css)};
  if (typeof GM_addStyle === "function") {{
    GM_addStyle(css);
    return;
  }}
  const style = document.createElement("style");
  style.textContent = css;
  (document.head || document.documentElement).appendChild(style);
}})();
"""
open("walts-dark.user.js", "w").write(js)
PY

for b in chrome firefox; do
  (cd "dist/$b" && zip -qr "../$b.zip" . -x '.*')
done
ls -l dist/*.zip
