import numpy as np

# File paths
float_path = 'output_test_float/Result_0/199.raw'
quant_path = 'output_test_quant/Result_0/199.raw'

# Load .raw files as float32 arrays
float_out = np.fromfile(float_path, dtype=np.float32)
quant_out = np.fromfile(quant_path, dtype=np.float32)

# Shape check
if float_out.shape != quant_out.shape:
    raise ValueError(f"Shape mismatch: float={float_out.shape}, quant={quant_out.shape}")

# Cosine similarity
cos_sim = np.dot(float_out, quant_out) / (np.linalg.norm(float_out) * np.linalg.norm(quant_out))

# L2 distance
l2_dist = np.linalg.norm(float_out - quant_out)

# Print results
print(f"Output shape: {float_out.shape}")
print(f"Cosine similarity: {cos_sim:.6f}")
print(f"L2 distance: {l2_dist:.6f}")
print(f"Float output range: min={float_out.min():.6f}, max={float_out.max():.6f}")
print(f"Quant output range: min={quant_out.min():.6f}, max={quant_out.max():.6f}")