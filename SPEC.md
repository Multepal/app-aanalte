# Spec for Migrating Topics and Annotations to XML

## Objective

**Replace current Drupal system with a pure XML system.**

## Requirements

- Create schema for defining **Topics**.
- Create schema for capturing **Annotations**.
- Create schema for **Relations** (among topics).
- Create XSLT files for merging topics, relations, annotations, and target texts.
- Adapt current Aanalte to work with the output.

## Assumptions

- Topics, relations, and annotations will live in a repo separate from the documents they annotate.
- Individual topics and annotations will be stored in separate files. Relations may be included in the source file.
- Topics will be linked to texts from the text.
- Annotations will be linked to texts from the annotation file.
- Annotations will use XPath to specify target elements in a text. (This may be challenged by using CTE.)
- Contributors will add annotation and add or update topics with an XML editor.
- Contributors will issue pull requests to submit their works.

## Resources

- Current examples of annotations topics in `collections/topics`. These are automatically output from Drupal using its REST exporter.