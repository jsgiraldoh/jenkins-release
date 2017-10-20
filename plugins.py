import xml.etree.ElementTree as ET

def main():
    tree = ET.parse('installedPlugins.xml')
    root = tree.getroot()

    plugins = []
    for entry in root.getchildren()[0]:
        plugin, version = entry.getchildren()
        if "Hudson core" in plugin.text:
            continue
        plugins.append('%s:%s\n' % (plugin.text, version.text))

    with open('plugins.txt', 'w') as ofile:
        ofile.writelines(plugins)

if __name__ == '__main__':
    main()
