# Ab0ut

Welcome to **`cv-gen`** project - the simple CV generator and **`md`** -> **`pdf`** converter.  
Have fun.


# INstallati0n

## ReQU!remenTs

- `linux`
- `git`
- `bash`
- `python3`
- `make`

## Clonn!N9

```
$ cd /tmp
$ clone https://github.com/skaluzka/cv-gen.git
```

Note: **`/tmp`** is just an example directory (see the paths below).

## PreparIN9 buiLd enV!R0nment

```
$ cd cv-gen
$ time ./prepare_env.sh

[INFO]: Creating python virtual environment '/tmp/cv-gen/.venv' please wait...
drwxr-xr-x 5 user user 140 Apr  4 20:14 /tmp/cv-gen/.venv

[INFO]: Activating '/tmp/cv-gen/.venv' virtual environment...

[INFO]: Installing packages provided in '/tmp/cv-gen/venv_requirements/pip.txt' file for '/tmp/cv-gen/.venv' virtual environment...

[INFO]: Checking pip3 version...
pip 20.0.2 from /tmp/cv-gen/.venv/lib/python3.8/site-packages/pip (python 3.8)

[INFO]: Checking easy_install/setuptools version...
setuptools 46.1.3 from /tmp/cv-gen/.venv/lib/python3.8/site-packages (Python 3.8)

[INFO]: Checking weasyprint version...
WeasyPrint version 51

[INFO]: Downloading 'https://github.com/jgm/pandoc/releases/download/2.9.2.1/pandoc-2.9.2.1-linux-amd64.tar.gz' please wait...
-rw-r--r-- 1 user user 23777856 Apr  4 20:14 pandoc-2.9.2.1-linux-amd64.tar.gz

[INFO]: Unpacking 'pandoc-2.9.2.1-linux-amd64.tar.gz' please wait...
pandoc-2.9.2.1/
pandoc-2.9.2.1/share/
pandoc-2.9.2.1/share/man/
pandoc-2.9.2.1/share/man/man1/
pandoc-2.9.2.1/share/man/man1/pandoc.1.gz
pandoc-2.9.2.1/share/man/man1/pandoc-citeproc.1.gz
pandoc-2.9.2.1/bin/
pandoc-2.9.2.1/bin/pandoc
pandoc-2.9.2.1/bin/pandoc-citeproc

[INFO]: Checking/removing old pandoc symbolic link...

[INFO]: Creating pandoc symbolic link...
'pandoc' -> 'pandoc-2.9.2.1'
lrwxrwxrwx 1 user user 14 Apr  4 20:14 pandoc -> pandoc-2.9.2.1

[INFO]: Checking pandoc version...
pandoc 2.9.2.1
Compiled with pandoc-types 1.20, texmath 0.12.0.1, skylighting 0.8.3.2
Default user data directory: /home/user/.local/share/pandoc or /home/user/.pandoc
Copyright (C) 2006-2020 John MacFarlane
Web:  https://pandoc.org
This is free software; see the source for copying conditions.
There is no warranty, not even for merchantability or fitness
for a particular purpose.

[INFO]: Removing 'pandoc-2.9.2.1-linux-amd64.tar.gz' package...
removed 'pandoc-2.9.2.1-linux-amd64.tar.gz'

[INFO]: Environment prepared successfully.

[INFO]: Script ./prepare_env.sh completed.

real	0m42.570s
user	0m11.470s
sys	0m1.508s
$ 
```


# USA9e

```
$ cd cv-gen
$ make

This is the top-level Makefile of cv-gen tool.

Usage:

    make               - The default target (see below) 

    make all           - Build all                      

    make clean         - Remove all output dirs         

    make help          - Print this help message        

$
```


# eX4mPLes

**Agent Smith:**

```
$ cd cv-gen
$ cp -vr examples/Agent_Smith/ in/
'examples/Agent_Smith/' -> 'in/Agent_Smith'
'examples/Agent_Smith/agentsmith1.png' -> 'in/Agent_Smith/agentsmith1.png'
'examples/Agent_Smith/agentsmith2.png' -> 'in/Agent_Smith/agentsmith2.png'
'examples/Agent_Smith/agentsmith3.png' -> 'in/Agent_Smith/agentsmith3.png'
'examples/Agent_Smith/cv.md' -> 'in/Agent_Smith/cv.md'
'examples/Agent_Smith/style.css' -> 'in/Agent_Smith/style.css'
$ 
$ tree in/
in/
└── Agent_Smith
    ├── agentsmith1.png
    ├── agentsmith2.png
    ├── agentsmith3.png
    ├── cv.md
    └── style.css

1 directory, 5 files
$
$ time make Agent_Smith.pdf
Generating /tmp/cv-gen/build/pdf/Agent_Smith.pdf file...
File /tmp/cv-gen/build/pdf/Agent_Smith.pdf generated succesfully.

real	0m1.039s
user	0m0.891s
sys	0m0.163s
$
$ tree -apugsF build/
build/
└── [drwxr-xr-x user user          60]  pdf/
    └── [-rw-r--r-- user user       64212]  Agent_Smith.pdf

1 directory, 1 file
$ 
```

The result **`pdf`** file will be saved to **`build/pdf/Agent_Smith.pdf`**
path.  
For comparison purposes it has been added also to
**`examples/results/build/pdf/`** directory:
[examples/results/build/pdf/Agent_Smith.pdf](examples/results/build/pdf/Agent_Smith.pdf)


# Cust0M inpUT dA7A

New input data has to follow below structure pattern:
```
FirstName_LastName/
├── photo.png
├── cv.md
└── style.css
```
Where:
- **`FirstName_LastName/`** - The top-level directory containing input custom
data.
- **`photo.png`** - Optional graphics file. Thanks to **`style.css`** file
any image can be easily embedded into final pdf file.
- **`cv.md`** - Mandatory markdown file containig resume data. Its content
can be fully customized.It has to be named **`cv.md`** (for more details
please examine the content of **`Makefile`** file). Any other names are not
supported currently. 
- **`style.css`** - Mandatory CSS style file. It will be used by **`pandoc`**
tool during **`md -> pdf`** conversion. Its content can be freely changed
and customized, but it has to be strictly named **`style.css`** (see the
content of **`Makefile`** file). Any other names are not supported currently.

Such prepared custom input data directory has to be copied into **`in/`**
directory before building.

Below command will generate **`build/pdf/FirstName_LastName.pdf `** result file
for structure described above:

```
$ cd cv-gen
$ make FirstName_LastName.pdf
Generating /tmp/cv-gen/build/pdf/FirstName_LastName.pdf file...
File /tmp/cv-gen/build/pdf/FirstName_LastName.pdf generated succesfully.
$
```

# Track!N9 depENDencies

The **`Makefile`** file contains properly defined dependencies between
all input **`md`**, **`css`** files and corresponding result **`pdf`**
files. There is no unnecessary building. Please try few examples below.

## Track!N9 depENDencies - prepariN9 inpu7 dA7A...

```
$ cd cv-gen
$ cp -r examples/Agent_Smith/ in/
$
```

## Track!N9 depENDencies - test scenaRio 1

```
$ make clean
[INFO]: Removing /tmp/cv-gen/build/pdf directory...
[INFO]: Done
$
$ make Agent_Smith.pdf
Generating /tmp/cv-gen/build/pdf/Agent_Smith.pdf file...
File /tmp/cv-gen/build/pdf/Agent_Smith.pdf generated succesfully.
$
$ make Agent_Smith.pdf
make: Nothing to be done for 'Agent_Smith.pdf'.
$
```

## Track!N9 depENDencies - test scenaRio 2

```
$ touch in/Agent_Smith/cv.md
$
$ make Agent_Smith.pdf
Generating /tmp/cv-gen/build/pdf/Agent_Smith.pdf file...
File /tmp/cv-gen/build/pdf/Agent_Smith.pdf generated succesfully.
$
```

## Track!N9 depENDencies - test scenaRio 3

```
$ touch in/Agent_Smith/style.css
$
$ make Agent_Smith.pdf
Generating /tmp/cv-gen/build/pdf/Agent_Smith.pdf file...
File /tmp/cv-gen/build/pdf/Agent_Smith.pdf generated succesfully.
$
```

## Track!N9 depENDencies - test scenaRio 4
```
$ make clean
[INFO]: Removing /tmp/cv-gen/build/pdf directory...
[INFO]: Done
$
$ make Agent_Smith.pdf
Generating /tmp/cv-gen/build/pdf/Agent_Smith.pdf file...
File /tmp/cv-gen/build/pdf/Agent_Smith.pdf generated succesfully.
$
$ make Agent_Smith.pdf
make: Nothing to be done for 'Agent_Smith.pdf'.
$
$ make $(pwd)/build/pdf/Agent_Smith.pdf
make: '/tmp/cv-gen/build/pdf/Agent_Smith.pdf' is up to date.
$ 
```

# ParaLLeL execut!0N

Yes, that's right! The **`Makefile`** file can properly handle parallel
execution as well.

```
$ cd cv-gen
$ mkdir -pv backup/{build,in}
mkdir: created directory 'backup'
mkdir: created directory 'backup/build'
mkdir: created directory 'backup/in'
$
$ mv build/* backup/build/
$ mv in/* backup/in/
$
$ for i in {00..15} ; do cp -r examples/Agent_Smith/ in/Agent_Smith_clone${i} ; done
$
$ ls -1d in/* | wc -l
16
$
$ time make -j4 all
Generating /tmp/cv-gen/build/pdf/Agent_Smith_clone00.pdf file...
Generating /tmp/cv-gen/build/pdf/Agent_Smith_clone01.pdf file...
Generating /tmp/cv-gen/build/pdf/Agent_Smith_clone02.pdf file...
Generating /tmp/cv-gen/build/pdf/Agent_Smith_clone03.pdf file...
File /tmp/cv-gen/build/pdf/Agent_Smith_clone00.pdf generated succesfully.
Generating /tmp/cv-gen/build/pdf/Agent_Smith_clone04.pdf file...
File /tmp/cv-gen/build/pdf/Agent_Smith_clone01.pdf generated succesfully.
Generating /tmp/cv-gen/build/pdf/Agent_Smith_clone05.pdf file...
File /tmp/cv-gen/build/pdf/Agent_Smith_clone03.pdf generated succesfully.
Generating /tmp/cv-gen/build/pdf/Agent_Smith_clone06.pdf file...
File /tmp/cv-gen/build/pdf/Agent_Smith_clone02.pdf generated succesfully.
Generating /tmp/cv-gen/build/pdf/Agent_Smith_clone07.pdf file...
File /tmp/cv-gen/build/pdf/Agent_Smith_clone05.pdf generated succesfully.
Generating /tmp/cv-gen/build/pdf/Agent_Smith_clone08.pdf file...
File /tmp/cv-gen/build/pdf/Agent_Smith_clone04.pdf generated succesfully.
Generating /tmp/cv-gen/build/pdf/Agent_Smith_clone09.pdf file...
File /tmp/cv-gen/build/pdf/Agent_Smith_clone07.pdf generated succesfully.
Generating /tmp/cv-gen/build/pdf/Agent_Smith_clone10.pdf file...
File /tmp/cv-gen/build/pdf/Agent_Smith_clone06.pdf generated succesfully.
Generating /tmp/cv-gen/build/pdf/Agent_Smith_clone11.pdf file...
File /tmp/cv-gen/build/pdf/Agent_Smith_clone08.pdf generated succesfully.
Generating /tmp/cv-gen/build/pdf/Agent_Smith_clone12.pdf file...
File /tmp/cv-gen/build/pdf/Agent_Smith_clone09.pdf generated succesfully.
Generating /tmp/cv-gen/build/pdf/Agent_Smith_clone13.pdf file...
File /tmp/cv-gen/build/pdf/Agent_Smith_clone10.pdf generated succesfully.
Generating /tmp/cv-gen/build/pdf/Agent_Smith_clone14.pdf file...
File /tmp/cv-gen/build/pdf/Agent_Smith_clone11.pdf generated succesfully.
Generating /tmp/cv-gen/build/pdf/Agent_Smith_clone15.pdf file...
File /tmp/cv-gen/build/pdf/Agent_Smith_clone12.pdf generated succesfully.
File /tmp/cv-gen/build/pdf/Agent_Smith_clone13.pdf generated succesfully.
File /tmp/cv-gen/build/pdf/Agent_Smith_clone14.pdf generated succesfully.
File /tmp/cv-gen/build/pdf/Agent_Smith_clone15.pdf generated succesfully.

real	0m4.064s
user	0m14.024s
sys	0m1.666s
$
$ time make -j4 all
make: Nothing to be done for 'all'.

real	0m0.044s
user	0m0.044s
sys	0m0.000s
$
$ ls -1 build/pdf/* | wc -l
16
$
```

# C0ntrib

All pull requests are welcome! ;)


# C0py!N9

Please see the LICENSE file for details.


# reS0URces

Few images were downloaded from the web and used in this project for test
purposes. Those images were slightly preprocessed (mostly cropped and resized).
All sources are published below:

**Agent Smith:**
- agentsmith1.png -> https://screencrush.com/files/2012/10/Agent-Smith1.jpg
- agentsmith2.png -> http://3.bp.blogspot.com/-wqlx--azZGg/UrW4fSDO73I/AAAAAAAAA0E/o5DlLg8IFNI/s1600/AgentSmith.jpeg
- agentsmith3.png -> https://mymistakesweremade4u.files.wordpress.com/2014/04/agent_smith.jpg

**Terminator:**
- terminator.png -> https://cdn2.highdefdigest.com/media/2017/06/26/660/terminator_genisys_5.png
