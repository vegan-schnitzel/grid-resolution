# Wie starte ich eine Simulation mit COSMO-CLM?

### CURTA
Hier liegt das runscript für CCLM:
`/home/ingokir/work/devel-vast/vast-git/models/c50clm6/scripts/runscript.py (-bs)`

Auf diesen Arbeitsordner kann von poincare/cip zugegriffen werden:
`/remote/trove/geo/ifm/model/work/SS2023/rw0064fu/`

### MODEL OUTPUT FILES
`namelists_H00000` = Namelists (werden vom runscript erzeugt und dann 
vom Modell eingelesen)
`cclm_listing_001_out` = Output des Modells
`run_listing_all` = Nützliche Informationen (Output) über den gesamten
Berechnungszeitraum des Modells

### WO LIEGEN DIE DATEN?
entweder in ANALYSIS/MERGED/ oder RESULT/
es gibt ein postprocessing script in week #7

### BOUNDARY FILES
zu finden unter /daten/model/arch/CLM?
LMGRID.TXT beschreibt die Gitterstruktur (CCLM benutzt rotiertes Gitter!)
Außerdem zu finden: Gitterauflösung, Bodenauflösung, ...

### OBSERVATIONS
Global Precipitation Climatology Project
E-OBS gridded dataset
Meteorological data of Berlin - MEVIS
