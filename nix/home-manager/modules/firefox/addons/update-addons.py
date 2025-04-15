import hashlib
import json
import urllib.request


addons = {
    "bitwarden": "bitwarden-password-manager",
    "clearurls": "clearurls",
    "darkreader": "darkreader",
    "localcdn": "localcdn-fork-of-decentraleyes",
    "plasma-integration": "plasma-integration",
    "privacy-badger": "privacy-badger17",
    "simple-tab-groups": "simple-tab-groups",
    "stylus": "styl-us",
    "terms-of-service-didnt-read": "terms-of-service-didnt-read",
    "ublock-origin": "ublock-origin",
}


# https://mozilla.github.io/addons-server/topics/api/addons.html
def get_addon_details(pname, slug):
    url = f"https://addons.mozilla.org/api/v5/addons/addon/{slug}/"

    with urllib.request.urlopen(url) as response:
        details = json.loads(response.read().decode())

    result = {
        "pname": pname,
        "version": details["current_version"]["version"],
        "addonId": details["guid"],
        "url": details["current_version"]["file"]["url"],
        "sha256": details["current_version"]["file"]["hash"].replace("sha256:", ""),
        "meta": {
            "homepage": details.get("homepage", {}).get("url", {}).get("en-US", ""),
            "description": details.get("summary", {}).get("en-US", ""),
        },
    }

    return result


def get_sha256(url):
    sha256_hash = hashlib.sha256()

    with urllib.request.urlopen(url) as response:
        while chunk := response.read(8192):
            sha256_hash.update(chunk)

    return sha256_hash.hexdigest()


addons_details = {}
for pname, slug in addons.items():
    print(pname)
    addon_details = get_addon_details(pname, slug)
    addons_details[pname] = addon_details


with open("addons.json", "w") as f:
    json.dump(addons_details, f, indent=2)
