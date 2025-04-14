import sys
import xml.etree.ElementTree as ET
from colorsys import hls_to_rgb
from colorsys import rgb_to_hls


def parse_filesystem_colors(filepath: str) -> dict:
    """
    Parse the partitionmanager.kcfg file to extract filesystem types and their RGB color codes.

    Args:
        filepath (str): Path to the partitionmanager.kcfg file.

    Returns:
        dict: A dictionary where keys are filesystem types and values are RGB tuples.
    """
    filesystem_colors = {}

    # Parse the XML file
    tree = ET.parse(filepath)
    root = tree.getroot()

    # Define the namespace used in the XML
    namespace = {"kcfg": "http://www.kde.org/standards/kcfg/1.0"}

    # Find all <default> elements within the <entry> with key="fileSystemColorCode$(FileSystem)"
    entry = root.find(".//kcfg:entry[@key='fileSystemColorCode$(FileSystem)']", namespace)

    if entry is None:
        return {}

    for default in entry.findall("kcfg:default", namespace):
        param = default.attrib.get("param")
        rgb_string = default.text.strip()

        if not (param and rgb_string):
            continue

        rgb_tuple = tuple(map(int, rgb_string.split(",")))
        filesystem_colors[param] = rgb_tuple

    return filesystem_colors

def transform_colors(filesystem_colors: dict) -> None:
    """
    Transform RGB colors to HLS, adjust lightness, and convert back to RGB.

    Args:
        filesystem_colors (dict): Dictionary of filesystem types and their RGB color codes.

    Returns:
        dict: A dictionary where keys are filesystem types and values are transformed RGB tuples.
    """
    transformed_colors = {}

    for fs_type, rgb in filesystem_colors.items():
        # Normalize RGB to [0, 1]
        r, g, b = [x / 255.0 for x in rgb]

        # Convert RGB to HLS
        h, l, s = rgb_to_hls(r, g, b)

        # Set lightness to 0.4
        l = 0.4

        # Convert HLS back to RGB
        r, g, b = hls_to_rgb(h, l, s)

        # Rescale RGB to [0, 255]
        transformed_rgb = tuple(int(x * 255) for x in (r, g, b))

        # Store the transformed color
        transformed_colors[fs_type] = transformed_rgb

    return transformed_colors

def output_colors(filesystem_colors: dict):
    """
    Output filesystem color code config entries to stdout.

    Args:
        filesystem_colors (dict): Dictionary of filesystem types and their RGB tuples.
    """
    for fs_type, rgb in filesystem_colors.items():
        r, g, b = rgb
        print(f"fileSystemColorCode{fs_type}={r},{g},{b}")


# https://raw.githubusercontent.com/KDE/partitionmanager/refs/heads/master/src/partitionmanager.kcfg
input_filepath = "partitionmanager.kcfg"

filesystem_colors = parse_filesystem_colors(input_filepath)
transformed_colors = transform_colors(filesystem_colors)
output_colors(transformed_colors)
