import os
import random
from pathlib import Path

dataset_root = Path("/export/data/dataset/UCF-101")
sample_rate = 0.2
output_file = "train.txt"

training_files = []

class_dirs = [d for d in dataset_root.iterdir() if d.is_dir()]

if not class_dirs:
    print(f"error: Sub-directory was not found in {dataset_root} ")
else:
    for class_dir in class_dirs:
        print(f"\nProcessing: {class_dir.name}")
        
        video_files = list(class_dir.glob("*.avi"))
        
        if not video_files:
            continue
        
        num_videos = len(video_files)
        num_to_sample = max(1, int(num_videos * sample_rate))
        
        print(f"  -> Find {num_videos} videos. Sampling {num_to_sample} videos...")
        
        sampled_videos = random.sample(video_files, num_to_sample)
        
        for video_path in sampled_videos:
            full_path = str(video_path)
            training_files.append(full_path)

    if training_files:
        with open(output_file, "w") as f:
            for line in training_files:
                f.write(line + "\n")
        print(f"\nCompleted! {len(training_files)} paths were saved in {output_file}.")
    else:
        print("\n The videos were not found.")