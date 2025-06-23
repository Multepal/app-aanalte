#! /bin/bash

# This script publishes the Popol Wuj collection files to the docs directory.
# It processes the XML files with XSLT transformations to generate HTML files.
# It also adds line break IDs to the XML files before conversion.  

# Converts  XML files to HTML using Saxon XSLT processor.
echo "Publishing PV"
saxon collections/popol-wuj/xom-all-flat-mod-pnums.xml transformers/add-lb-ids.xsl > tmp/xom-all-flat-mod-pnums-lbids.xml
saxon tmp/xom-all-flat-mod-pnums-lbids.xml transformers/tei-to-html.xsl > docs/xom-all-flat-mod-pnums-lbids.html

# Converts the Popol Wuj XOM file to HTML with line break IDs.
echo "Publishing Escolios"
saxon collections/popol-wuj-escolios/xom-escolios-v1.xml transformers/add-lb-ids.xsl > tmp/xom-escolios-v1-lbids.xml
saxon tmp/xom-escolios-v1-lbids.xml transformers/tei-to-html.xsl > docs/xom-escolios-v1-lbids.html

# Converts the Popol Wuj Aj Tzibab K'iche source file to HTML with line break IDs.
echo "Publishing Aj Tzibab K'iche"
saxon collections/popolwuj-ajtzibab-kiche/source.v1.tei.xml transformers/add-lb-ids.xsl > tmp/popolwuj-ajtzibab-kiche-source.v1.tei-lbids.xml
saxon tmp/popolwuj-ajtzibab-kiche-source.v1.tei-lbids.xml transformers/tei-to-html.xsl > docs/popolwuj-ajtzibab-kiche-source.v1.tei-lbids.html