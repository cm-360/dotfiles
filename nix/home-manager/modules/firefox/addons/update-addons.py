import hashlib
import json
import urllib.request
from functools import reduce
from typing import Any

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
            "homepage": safe_get(details, "homepage.url.en-US"),
            "description": safe_get(details, "summary.en-US"),
        },
    }

    return result


def safe_get(dictionary: dict, dot_key: str) -> Any | None:
    keys = dot_key.split(".")

    return reduce(lambda v, k: v.get(k) if v else None, keys, dictionary)


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
