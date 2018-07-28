# H&E color normalization - MATLAB

MATLAB functions for color normalization of H&E stained histology slides.

## Usage

```matlab
>> sampleImage = imread('/path/to/histology/sample_image.tif')
>> fullImage = imread('/path/to/histology/full_image.tif')
>> [structureMap, lumen, nuclei, stroma, cytoplasm] = colorassign_manual(loadedImage)
>> classifier = train_classifier(loadedImage, structureMap, lumen, nuclei, stroma, cytoplasm)
>> classified_image = color_classify(fullImage, classifier)
>> load('target.mat')
>> normalizedImage = color_normalize(fullImage, target, classified)
>> imwrite(normalizedImage, '/path/to/output/normalized.tif')
```