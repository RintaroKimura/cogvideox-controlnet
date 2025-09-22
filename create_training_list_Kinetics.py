import os
from pathlib import Path

# データセットのルートディレクトリを指定
dataset_root = Path("/export/data/dataset/Kinetics/Kinetics-600/full/train")
output_file = "train_kinetics_10s.txt"

training_files = []

# .aviファイルを再帰的に検索
video_files = list(dataset_root.rglob("*.mp4"))

if not video_files:
    print(f"error: No .mp4 files were found in {dataset_root}")
else:
    print(f"Found {len(video_files)} videos. Saving paths to {output_file}...")
    for video_path in video_files:
        full_path = str(video_path.resolve())
        training_files.append(full_path)

    if training_files:
        with open(output_file, "w") as f:
            for line in training_files:
                f.write(line + "\n")
        print(f"\nCompleted! {len(training_files)} paths were saved in {output_file}.")
    else:
        print("\nNo video paths were found to save.")