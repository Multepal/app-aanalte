#!/usr/bin/env python

import configparser
import requests
import os
from lxml import etree as ET

class Importer():

    def __init__(self, ini_file):
        """Import configuratation and set up data structures"""

        self.config = configparser.ConfigParser()
        self.config.read(ini_file)
        self.base_path = self.config['DEFAULT']['base_path']
        self.multepal = self.config['multepal']['multepal_url']
        
        # Should use YAML instead if you want nested configs
        self.exports = {
            'topics': {}, 
            'annotations': {}, 
            'snippets': {}
        }
        for export in self.exports.keys():
            self.exports[export] = {
                'url': self.multepal + self.config['multepal'][f'{export}_url'],
                'file': self.base_path + self.config['multepal'][f'{export}_src']
            }

    def download(self):
        """Download content from Drupal site"""

        for export in self.exports.keys():
            print(f"Getting {export} from Multepal site")
            url = self.exports[export]['url']
            r = requests.get(url)
            out_file = self.exports[export]['file']
            print('out_file', out_file)
            if os.path.exists(out_file):
                os.system(f'mv {out_file} {out_file}.tmp')
            with open(out_file, 'w') as out:
                print(out_file)
                out.write(r.text)

    def annotation_mapper(self):
        """Maps line IDs to annotation IDs and adds an annotation map element to the annotations file."""

        # Get annotation XML file path
        file = self.exports['annotations']['file']

        # Create XML parser
        parser = ET.XMLParser(remove_blank_text=True)
        tree = ET.parse(file, parser=parser)
        root = tree.getroot()

        # Create a new element to store the annotation map
        amap = ET.SubElement(root, 'annotation-map')

        # Define translations of how lines are represented in Drupal vs in the XML.
        # Todo: Replace this whole system so that Drupal is pulling from the IDs 
        # as they exist in the source documents.
        trans = {
            'Folio': 'f',
            'Escolio': 'f',
            'recto': 's1',
            'verso': 's2',
            'A': 'quc',
            'B': 'spa',
        }

        # Grab all the annotation elements
        for note in root.xpath("//annotation"):

            # Grab the node_id and mapped lines
            node_id = note.xpath("nid/text()")[0]
            lines = [el.xpath('li/text()') for el in note.xpath("lineas/ul")]

            # Translate names using `trans` dict
            for line in lines:
                line_id = []
                for el in line:
                    parts = el.split()
                    if el == 'MS 1515: Popol Wuj':
                        line_id.append('xom')
                    if el == 'MS 1515: Escolios':
                        # line_id.append('xom-esc')
                        pass
                    elif parts[0] == 'Folio' or parts[0] == 'Escolio':
                        line_id.append(f'{trans[parts[0]]}{parts[1]}')
                        line_id.append(f'{trans[parts[2]]}')
                    elif parts[0] == 'Column':
                        line_id.append(f'{trans[parts[1]]}')
                    elif parts[0] == 'Line':
                        line_id.append(parts[1])
                line_id_str = '-'.join(line_id)
                
                # Add new element to XML doc in the followin pattern:
                # <item nid="995" line_id="xom-f56-s1-quc-27" />
                new_el = ET.SubElement(amap, 'item')
                new_el.set('nid', node_id)
                new_el.set('line_id', line_id_str)

        tree.write(file, method='xml', encoding='utf-8', pretty_print=True)

if __name__ == '__main__': 

    import os
    cwd = os.getcwd()
    print('CWD=', cwd)
    config_file = f"{cwd}/config.ini"
    imp = Importer(config_file)
    imp.download()
    imp.annotation_mapper()
