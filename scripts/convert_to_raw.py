import cv2
import numpy as np
import os
import sys

input_dir = sys.argv[1]
output_dir = sys.argv[2]
os.makedirs(output_dir, exist_ok=True)

for filename in os.listdir(input_dir):
    if not filename.lower().endswith((".jpg", ".jpeg", ".png")):
        continue
    path = os.path.join(input_dir, filename)
    img = cv2.imread(path)
    img = cv2.resize(img, (128, 128))
    img = img.astype(np.float32)
    img = img * (1.0 / 127.5) - 1.0  # Normalize to [-1, 1]
    img = img.transpose(2, 0, 1)  # Convert to CHW for NCHW layout
    out_path = os.path.join(output_dir, os.path.splitext(filename)[0] + ".raw")
    img.tofile(out_path)