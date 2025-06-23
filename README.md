# Kretz

This repo serves as a program to convert raw `.vol` files to nifti or dicom files.

If you would like to run this program on a Linux machine, feel free to download a release from [releases](https://github.com/MasterOfCubesAU/kretz/releases). Alternatively, if you would like to build from source, follow the instructions below.

**Kretz** refers to a `.vol` file in this context.

# Requirements

- Docker Desktop/Engine

# Setup

```bash
git submodule update --init --recursive
docker build -t kretz .
```

# Usage

1. Copy all the `.vol` files you wish to convert into the `inputs` folder
2. Run the below command

```bash
docker compose run app

# if <CLI_ARGS> is omitted, program will run with defaults: -r 0.2 0.2 0.2 and -d. You will get both a bmode and power doppler output

# If you wanted to run the kretz converter with only -m and image dimensions 100x200x300 for example, you would execute
docker compose run app -- -m -s 100 200 300

# See Programs below for CLI args.
```

1. When prompted, enter the output type you would like. Supported types are `.dcm` and `.nii.gz`.

2. All your converted files can then be found in the`outputs` folder

# Programs

The below program help is taken from [here](https://github.com/plooney/kretz)

## KretzFileWriter

This program either takes a KRETZ file and outputs the voxels in the geometry of the 3D ultrasound probe. One dimension corresponds to radial distance and the others correspond to the angles. The spacing is not isotropic and can be found in the KRETZ file. KretzFileWriter can take a cartesian geometry and a KRETZ file and convert the cartesian geometry back into the geometry specified in the KRETZ file.

arguments:

- i - input KRETZ file
- c - optional cartesian file to convert back into geometry specified in the KRETZ file
- o - path for the output file

## KretzConverter

This program takes a KRETZ file and converts it to cartesian coordinates.

arguments:

- i - input KRETZ file
- o - path for the output file
- r - three floating point values corresponding to the voxel spacing in each direction, if not specified s must be
- s - three integers to define the number of voxels in each direction, if not specifed r must be
- m - create a mask image 1 where the voxel is in the geometry of the ultrasound beam and 0 otherwise
- n - normalise voxel values to have zero mean and unit variance
- d - write out power doppler instead of grayscale voxel values to geometry of the grayscale acquisition
