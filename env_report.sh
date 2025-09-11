#!/usr/bin/env bash
set -euo pipefail

TS=$(date +"%Y%m%d-%H%M%S")
OUT="conda-env-report-${TS}.txt"
echo "Writing report to $OUT"

# Ensure conda command is available in non-interactive shells (adjust path if needed)
if ! command -v conda >/dev/null 2>&1; then
  # try typical miniconda path — adjust if conda is elsewhere
  if [ -f "$HOME/miniconda3/etc/profile.d/conda.sh" ]; then
    source "$HOME/miniconda3/etc/profile.d/conda.sh"
  elif [ -f "$HOME/anaconda3/etc/profile.d/conda.sh" ]; then
    source "$HOME/anaconda3/etc/profile.d/conda.sh"
  else
    echo "warning: 'conda' not found in PATH and no typical install detected." >> "$OUT"
  fi
fi

{
echo "===== Timestamp ====="
date
echo

echo "===== Conda (basic) ====="
conda --version 2>&1 || true
echo
echo "===== Conda info (human) ====="
conda info --all 2>&1 || true
echo
echo "===== Conda info (JSON summary) ====="
conda info --json 2>&1 || true
echo

echo "===== Active environment name/path ====="
# python -c is reliable for current executable
python -c 'import sys,os; print("executable:", sys.executable); print("prefix:", sys.prefix); print("sys.path:"); print("\\n".join(sys.path))' 2>&1 || true
echo

echo "===== Python version and build ====="
python --version 2>&1 || true
python -c 'import platform,sys; print(platform.platform()); print(platform.python_build()); print("implementation:", platform.python_implementation())' 2>&1 || true
echo

echo "===== pip info ====="
pip --version 2>&1 || true
python -m pip list --format=columns 2>&1 || true
echo
echo "pip list (JSON):"
python -m pip list --format=json 2>&1 || true
echo

echo "===== conda packages ====="
conda list 2>&1 || true
echo
echo "conda list (JSON):"
conda list --json 2>&1 || true
echo

echo "===== conda env export (YAML, --no-builds) ====="
conda env export --no-builds 2>&1 || true
echo

echo "===== conda list --explicit (exact spec) ====="
conda list --explicit 2>&1 || true
echo

echo "===== pip freeze (requirements format) ====="
pip freeze 2>&1 || true
echo

echo "===== Dependency checks ====="
echo "pip check:"
python -m pip check 2>&1 || true
echo
echo "conda list --revisions:"
conda list --revisions 2>&1 || true
echo

echo "===== Useful checks for common libs (if installed) ====="
# examples for pytorch/tensorflow/numpy
python - <<'PY'
import importlib,sys
def show(mod):
    try:
        m=importlib.import_module(mod)
        v=getattr(m,'__version__',None)
        info=f"{mod}: version={v}"
        # extra for torch
        if mod=='torch':
            info += f", cuda_available={m.cuda.is_available() if hasattr(m,'cuda') else 'N/A'}"
            info += f", cuda_version={getattr(m,'version',None).cuda if hasattr(getattr(m,'version',None),'cuda') else getattr(m,'version',None)}"
        print(info)
    except Exception as e:
        print(f"{mod}: not installed ({e})")
for m in ['numpy','scipy','pandas','torch','tensorflow','opencv','skimage','matplotlib']:
    show(m)
PY
echo

echo "===== System / OS ====="
uname -a 2>&1 || true
echo "lsb_release (if available):"
lsb_release -a 2>&1 || true

} > "$OUT" 2>&1

echo "Report saved to $OUT"
echo "You can open it with: less $OUT"
