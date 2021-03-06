# MT-ComparEval
MT-ComparEval is a tool for comparison and evaluation of machine translations.
It allows users to compare translations according to several criteria, such as:
 - automatic metrics of machine translation quality computed either on whole documents or single sentences
 - quality comparison of single sentence translation by highlighting conﬁrmed, improving and worsening n-grams
 - summaries of the most improving and worsening n-grams for the whole document.

MT-ComparEval also plots a chart with absolute differences of metrics computed on single sentences
  and a chart with values obtained from paired bootstrap resampling.


MT-ComparEval is distributed under Apache 2.0 license with an exception of [Highcharts.js](http://www.highcharts.com/) library
  which is distributed under [Creative Commons Attribution-NonCommercial 3.0 License](http://creativecommons.org/licenses/by-nc/3.0/).


# Installation
In order to be able to run MT-ComparEval several dependencies have to be installed.
Namely, PHP version 5.4 and Sqlite 3.
On Ubuntu 14.04 these dependencies can be installed with the following commands.
```
sudo apt-get install sqlite3 php5-cli php5-sqlite
```

Then the application can be installed with the following command:
```
bash bin/install.sh
```

# Running MT-ComparEval
To start MT-ComparEval two processes have to be run:
 - `bin/server.sh` which starts the application server on the address [localhost:8080](http://localhost:8080)
  (you can can check/adapt `app/config/config.neon` first to set the main title, set of metrics etc. See the [default config](app/config/config.neon).)
 - `bin/watcher.sh` which monitors folder `data` for new experiments and tasks (the `data` folder must exist before you run `bin/watcher.sh`.)

## Structure of the `data` folder
Folder `data` contains folders with *experiments* (e.g. `EN-CS-WMT15`), which contains subfolders with *tasks* for each experiment (e.g. `MOSES`). For example:
```
data/
├─ EN-CS-WMT15/
│  ├─ source.txt
│  ├─ reference.txt
│  ├─ CHIMERA/
│  │  └─ translation.txt
│  └─ NEURAL-MT/
│     └─ translation.txt
└─ EN-DE-WMT15/
   ├─ source.txt
   ├─ reference.txt
   ├─ MOSES/
   │  └─ translation.txt
   └─ NEURAL-MT/
      └─ translation.txt
```

Each folder corresponds to one experiment and it should contain the following files:
 - `source.txt` - a plain text file with sentences in source language (one sentence per line).
 - `reference.txt` - a plain text file with reference translations (in target language).
 - `config.neon` - (optionally) a configuration file with the following structure:
```
name: Name of the experiment
description: "Description of the experiment\n can be multiline"
source: source.txt
reference: reference.txt
```
See http://ne-on.org/ for the syntax of neon files.
The `source` and `reference` needs to be defined only if you you choose non-default file names (not `source.txt` and `reference.txt`).

Individual machine translations called *tasks* are then stored in subfolders with the following files:
- `translation.txt` - a plain text file with translated sentences
- `config.neon` - (optionally) a configuration file with the following structure:
```
name: Name of the task
description: Description of the task
translation: translation.txt
precompute_ngrams: true
```

## API to create experiments and tasks
A curl command to create an experiment:
```bash
curl -X POST -F "name=experiment name" -F "description=description" -F "source=@source.txt" -F "reference=@reference.txt" http://localhost:8080/api/experiments/upload
```

A curl command to create a task:
```bash
curl -X POST -F "name=task name" -F "description=description" -F "experiment_id=1" -F "translation=@translation.txt" http://localhost:8080/api/tasks/upload
```
