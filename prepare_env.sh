#!/usr/bin/env bash
set -eu


readonly WORK_DIR="$(pwd)"

# Some pandoc specific variables
PANDOC_VER='2.9.2.1'
PANDOC_TGZ="pandoc-${PANDOC_VER}-linux-amd64.tar.gz"
PANDOC_URL="https://github.com/jgm/pandoc/releases/download/${PANDOC_VER}/${PANDOC_TGZ}"
PANDOC_BIN="${WORK_DIR}/pandoc/bin/pandoc"

# Python virtual environment variables
VENV_BIN='python3'
VENV_BIN_PARAMS='-m venv'
VENV_DIR="${WORK_DIR}/.venv"
VENV_REQ_FILE="${WORK_DIR}/venv_requirements/pip.txt"

# OK, Let's play...

echo -e "\n[INFO]: Creating python virtual environment '${VENV_DIR}' please wait..."
${VENV_BIN} ${VENV_BIN_PARAMS} "${VENV_DIR}"
ls -ald "${VENV_DIR}"

echo -e "\n[INFO]: Activating '${VENV_DIR}' virtual environment..."
set +u
. "${VENV_DIR}/bin/activate"
set -u

echo -e "\n[INFO]: Installing packages provided in '${VENV_REQ_FILE}' file for '${VENV_DIR}' virtual environment..."
pip3 --no-cache-dir install -q -r "${VENV_REQ_FILE}"

echo -e '\n[INFO]: Checking pip3 version...'
pip3 -V

echo -e '\n[INFO]: Checking easy_install/setuptools version...'
easy_install --version

echo -e '\n[INFO]: Checking weasyprint version...'
weasyprint --version

echo -e "\n[INFO]: Downloading '${PANDOC_URL}' please wait..."
curl -L -s "${PANDOC_URL}" > "${PANDOC_TGZ}"
ls -al "${PANDOC_TGZ}"

echo -e "\n[INFO]: Unpacking '${PANDOC_TGZ}' please wait..."
tar -xzvf "${PANDOC_TGZ}"

echo -e '\n[INFO]: Checking/removing old pandoc symbolic link...'
if [[ -L pandoc && -d pandoc ]]; then
    ls -al pandoc
    rm -fv pandoc
fi

echo -e '\n[INFO]: Creating pandoc symbolic link...'
ln -sv pandoc-${PANDOC_VER} pandoc
ls -al pandoc

echo -e '\n[INFO]: Checking pandoc version...'
${PANDOC_BIN} --version

echo -e "\n[INFO]: Removing '${PANDOC_TGZ}' package..."
rm -fv "${PANDOC_TGZ}"

echo -e '\n[INFO]: Environment prepared successfully.\n'

echo "[INFO]: Script ${0} completed."


# The End
