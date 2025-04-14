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
def get_addon_data(pname, slug):
    url = f"https://addons.mozilla.org/api/v5/addons/addon/{slug}/"

    with urllib.request.urlopen(url) as response:
        data = json.loads(response.read().decode())

    result = {
        "pname": pname,
        "version": data["current_version"]["version"],
        "addonId": data["guid"],
        "url": data["current_version"]["file"]["url"],
        "sha256": data["current_version"]["file"]["hash"].replace("sha256:", ""),
        "meta": {
            "homepage": data.get("homepage", {}).get("url", {}).get("en-US", ""),
            "description": data.get("summary", {}).get("en-US", ""),
        },
    }

    return result


def get_sha256(url):
    sha256_hash = hashlib.sha256()

    with urllib.request.urlopen(url) as response:
        while chunk := response.read(8192):
            sha256_hash.update(chunk)
    
    return sha256_hash.hexdigest()


addons_data = {}
for pname, slug in addons.items():
    print(pname)
    addon_data = get_addon_data(pname, slug)
    addons_data[pname] = addon_data


with open("addons.json", "w") as f:
    json.dump(addons_data, f, indent=2)
