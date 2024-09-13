from saxonche import *

"""
echo "Publishing PV"
saxon collections/popol-wuj/xom-all-flat-mod-pnums.xml transformers/add-lb-ids.xsl > tmp/xom-all-flat-mod-pnums-lbids.xml
saxon tmp/xom-all-flat-mod-pnums-lbids.xml transformers/tei-to-html.xsl > docs/xom-all-flat-mod-pnums-lbids.html

echo "Publishing Escolios"
saxon collections/popol-wuj-escolios/xom-escolios-v1.xml transformers/add-lb-ids.xsl > tmp/xom-escolios-v1-lbids.xml
saxon tmp/xom-escolios-v1-lbids.xml transformers/tei-to-html.xsl > docs/xom-escolios-v1-lbids.html

echo "Publishing Aj Tzibab K'iche"
saxon collections/popolwuj-ajtzibab-kiche/source.v1.tei.xml transformers/add-lb-ids.xsl > tmp/popolwuj-ajtzibab-kiche-source.v1.tei-lbids.xml
saxon tmp/popolwuj-ajtzibab-kiche-source.v1.tei-lbids.xml transformers/tei-to-html.xsl > docs/popolwuj-ajtzibab-kiche-source.v1.tei-lbids.html
"""

transforms = {
    "PV": [
        ("collections/popol-wuj/xom-all-flat-mod-pnums.xml", 
         "transformers/add-lb-ids.xsl", 
         "tmp/xom-all-flat-mod-pnums-lbids.xml"),
        ("tmp/xom-escolios-v1-lbids.xml", 
         "transformers/tei-to-html.xsl",
         "docs/xom-escolios-v1-lbids.html")
    ],
    "Escolios": [
        ("collections/popolwuj-ajtzibab-kiche/source.v1.tei.xml", 
         "transformers/add-lb-ids.xsl",
         "tmp/popolwuj-ajtzibab-kiche-source.v1.tei-lbids.xml"),
        ("tmp/xom-escolios-v1-lbids.xml", 
         "transformers/tei-to-html.xsl", 
         "docs/xom-escolios-v1-lbids.html")
    ],
    "Aj Tzibab K'iche": [    
        ("collections/popolwuj-ajtzibab-kiche/source.v1.tei.xml", 
         "transformers/add-lb-ids.xsl", 
         "tmp/popolwuj-ajtzibab-kiche-source.v1.tei-lbids.xml"),
        ("tmp/popolwuj-ajtzibab-kiche-source.v1.tei-lbids.xml", 
         "transformers/tei-to-html.xsl", 
         "docs/popolwuj-ajtzibab-kiche-source.v1.tei-lbids.html")
    ]
}


with PySaxonProcessor(license=False) as proc:
    xsltproc = proc.new_xslt30_processor()
    for pub in transforms:
        print("Publishing", pub)
        for i, transform in enumerate(transforms[pub]):
            src = transform[0]
            xsl = transform[1]
            dst = transform[2]
            print(f"\t{i} src:", src)
            print(f"\t{i} xsl:", xsl)
            print(f"\t{i} dst:", dst)
            
            document = proc.parse_xml(xml_text=open(src, 'r').read())
            executable = xsltproc.compile_stylesheet(stylesheet_file=xsl)
            # output = executable.transform_to_string(xdm_node=dst)
            
            # print(output)
            
