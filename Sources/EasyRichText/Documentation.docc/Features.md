# Features

Distinct style component for a segment of text.

## Overview

In EasyRichText, rich texts are expressed as an array of text segments (*runs*) with different styles (*features*) attached to each of the segments.

Features are the smallest unit of style in EasyRichText. They are used to represent a single style property, such as font, color, or underline. Each feature is represented by a `struct` conforming to `ERTFeature` protocol.

## Topics

### Basic Protocols

- ``ERTFeature``
- ``ERTSingleKeyFeature``
- ``ERTSymbolicTraitFeature-fpvl``

### Font Features

- ``ERTBoldFeature``
- ``ERTItalicFeature``
- ``ERTUnderlineFeature``

### Color Features

- ``ERTForegroundColorFeature``
- ``ERTBackgroundColorFeature``
