# SNPE Docker Workflow

This repository provides a reproducible Docker-based workflow for converting ONNX models to quantized `.dlc` models using Qualcomm's SNPE SDK.

---

## Requirements

- Docker
- SNPE SDK (`snpe-1.68.0.3932`) — must be downloaded manually
- Android NDK (`android-ndk-r21e`) — must be downloaded manually
- ONNX model on host machine

> These files are **not included** in the repo.

---

## How to Use

### 1. Clone the repository
git clone https://github.com/galshalice/snpe-docker.git
cd snpe-docker

### 2. Manually Download Required Files

### 3. Build the Docker Image
docker build -t snpe-dev:1.68 .

### 4. Start the Container
docker run -it --name snpe-container \
  -v $(pwd)/mnt:/mnt \
  snpe-dev:1.68

If the container exists and only need re-starting:
docker start -ai snpe-container

### 5. Copy Files into the Container
docker cp /full/path/to/model.onnx snpe-container:/mnt/model.onnx


### 6. Convert ONNX to DLC
Inside the container (x.1 is the name of the input layer):
/opt/snpe/bin/x86_64-linux-clang/snpe-onnx-to-dlc \
  --input_network /mnt/model.onnx \
  --input_type "x.1" default \
  --input_layout "x.1" NCHW \
  --input_dtype "x.1" float32 \
  --output_path /opt/snpe/model.dlc

(HOW TO GET THE x.1)

### 7. Convert Images to .raw Format
Run:
python scripts/convert_to_raw.py /mnt/images /opt/snpe/raw_output

### 8. Create Input List File
Create a file like /opt/snpe/input_list.txt with paths to .raw files:
ls /opt/snpe/raw_output/*.raw > /opt/snpe/input_list.txt


### 9. Quantize the DLC Model

snpe-dlc-quantize \
  --input_dlc /opt/snpe/model.dlc \
  --input_list /opt/snpe/input_list.txt \
  --output_dlc /opt/snpe/model_quantized.dlc


### 10. Validate Quantized Output
(Optional) Run inference for a a single image listed in: input_list_single.txt, and compare outputs:
# For float model
snpe-net-run \
  --container /opt/snpe/model.dlc \
  --input_list /opt/snpe/input_list_single.txt \
  --output_dir /opt/snpe/output_float

# For quantized model
snpe-net-run \
  --container /opt/snpe/blazeface_quantized.dlc \
  --input_list /opt/snpe/input_list_single.txt \
  --output_dir /opt/snpe/output_quant

Run:
Scripts/compare_outputs.py

### 11. Copy Files Back to Host
docker cp snpe-container:/opt/snpe/model_quantized.dlc ./mnt/






