import xml.etree.ElementTree as ET
from colorsys import hls_to_rgb, rgb_to_hls

# https://raw.githubusercontent.com/KDE/partitionmanager/refs/heads/master/src/partitionmanager.kcfg
input_filepath = "partitionmanager.kcfg"


def parse_filesystem_colors(filepath: str) -> dict:
    """
    Parse the partitionmanager.kcfg file to extract filesystem types and their
    RGB color codes.

    Args:
        filepath (str): Path to the partitionmanager.kcfg file.

    Returns:
        dict: A dictionary where keys are filesystem types and values are RGB
        tuples.
    """
    filesystem_colors = {}

    tree = ET.parse(filepath)
    root = tree.getroot()

    # Find <entry> node containing default color codes
    namespace = {"kcfg": "http://www.kde.org/standards/kcfg/1.0"}
    path = ".//kcfg:entry[@key='fileSystemColorCode$(FileSystem)']"
    entry = root.find(path, namespace)

    if entry is None:
        return {}

    # Extract default color codes
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
        filesystem_colors (dict): Dictionary of filesystem types and their RGB
        color codes.

    Returns:
        dict: A dictionary where keys are filesystem types and values are
        transformed RGB tuples.
    """
    transformed_colors = {}

    for fs_type, rgb in filesystem_colors.items():
        # Normalize RGB to [0, 1] then convert to HLS
        r, g, b = [x / 255.0 for x in rgb]
        h, l, s = rgb_to_hls(r, g, b)

        # Set lightness to 0.4
        l = 0.4

        # Convert HLS back to RGB then rescale to [0, 255]
        r, g, b = hls_to_rgb(h, l, s)
        transformed_rgb = tuple(int(x * 255) for x in (r, g, b))

        transformed_colors[fs_type] = transformed_rgb

    return transformed_colors


def output_colors(filesystem_colors: dict):
    """
    Output filesystem color code config entries to stdout.

    Args:
        filesystem_colors (dict): Dictionary of filesystem types and their RGB
        tuples.
    """
    for fs_type, rgb in filesystem_colors.items():
        r, g, b = rgb
        print(f"fileSystemColorCode{fs_type}={r},{g},{b}")


if __name__ == "__main__":
    filesystem_colors = parse_filesystem_colors(input_filepath)
    transformed_colors = transform_colors(filesystem_colors)
    output_colors(transformed_colors)
