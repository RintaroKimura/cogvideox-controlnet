#!/bin/bash

export NCCL_P2P_DISABLE=1
export MODEL_PATH="THUDM/CogVideoX-2b"
# export PYTORCH_CUDA_ALLOC_CONF=expandable_segments:True
export CUDA_VISIBLE_DEVICES=0,1,2,3,4,5,6,7

accelerate launch --config_file accelerate_config_machine_single.yaml --multi_gpu \
  train_controlnet.py \
  --tracker_name "cogvideox-colorization-ucf101" \
  --gradient_checkpointing \
  --pretrained_model_name_or_path $MODEL_PATH \
  --seed 42 \
  --mixed_precision bf16 \
  --output_dir "../models/finetuned-colorization-ucf101" \
  --height 240 \
  --width 320 \
  --fps 24 \
  --max_num_frames 49 \
  --video_root_dir "" \
  --csv_path "/home/yanai-lab/kimura-r/space/jupyter/notebook/model_test/CogVideoX/cogvideox-controlnet/train.txt" \
  --stride_min 1 \
  --stride_max 3 \
  --hflip_p 0.5 \
  --controlnet_type "grayscale" \
  --controlnet_transformer_num_layers 8 \
  --controlnet_input_channels 3 \
  --downscale_coef 8 \
  --controlnet_weights 0.25 \
  --init_from_transformer \
  --train_batch_size 1 \
  --dataloader_num_workers 0 \
  --num_train_epochs 5 \
  --checkpointing_steps 400 \
  --gradient_accumulation_steps 2 \
  --learning_rate 5e-7 \
  --lr_scheduler cosine_with_restarts \
  --lr_warmup_steps 250 \
  --lr_num_cycles 1 \
  --optimizer AdamW \
  --adam_beta1 0.9 \
  --adam_beta2 0.95 \
  --max_grad_norm 1.0 \
  --allow_tf32

#  --validation_prompt "car is going in the ocean, beautiful waves:::ship in the vulcano" \
#  --validation_video "../resources/car.mp4:::../resources/ship.mp4" \
#  --validation_prompt_separator ::: \
#  --num_inference_steps 28 \
#  --num_validation_videos 1 \
#  --validation_steps 500 \