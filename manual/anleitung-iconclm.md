* Szenarien für die Lehre - Downscaling I.Kirchner (Maerz/2023)

Anleitung zur Vorbereitung und Durchführung eines Regionalen Downscaling Experiments
mit ICON-CLM (Im Rahmen des Moduls - Modelle fuer Wetter und Umwelt - Sommersemester)

Im Folgenden wird beschrieben, wie man eine regionale Simulation mit dem ICON
vorbereitet und durchführt. Dazu sind mehrere Schritte zu durchlaufen, die mit
Werkzeugen aus dem VAST-Toolpool unterstützt werden. Ein Teil der Arbeitsschritte
erfordert Zugriff auf spezielle Ressourcen (ICON-Webseiten). Für die Nutzung des
ICON über die Lehre hinaus, muss das im Rahmen der ICON-Lizenz erfolgen. Folgende
Arbeitsschritte bzw. Kernabschnitte des Workflows sind prinziell notwendig ...

+ Einrichten des ICON Binaries, Zugriff auf ICON-Quellen, Compilation auf dem
  Produktionssystem
  -> nur bei Autorisierung, VAST-System stellt ein lauffähiges Binary bereit

+ Vorbereitung der Zielauflösung, Zielgebiet, Zeitraum
  -> eine Reihe von Auflösungen und Randdatensets steht im VAST-System bereit

+ Durchführung und Auswertung einer Simulation
  -> mit Hilfe der VAST-Tools indiduell zu gestalten

VAST_BASE ... bezeichnet den Ordner, in dem das VAST-System eingerichtet wurde
              /daten/vast/arch/vast-git/  @ifm
              

==========================================================================================
* A - Vorbereitungen der Simulation
===================================

1. Auswahl des Zielgebietes und der Zielregion
2. Erstellung des passenden Gitters und der externen Daten
3. Zusammenstellen des Randdatenarchives

** Ausgangsdaten ERA5

- Zeitraum : Jan/1990 - Jul/2021
- Auflösung : global 0.33°

Auswahl einer Wettersituation [Zeitraum und Region] (kann mit Unterstützung erfolgen)
Beachte: es stehen nur bestimmte Regionen zur Verfügung (Gitter und External Data)

Bei Verwendung der ERA5 Daten stellt man im ersten Schritt ein Archiv zusammen,
in dem alle notwendigen Variablen in der passenden Filestruktur abgelegt werden.
Dabei sollte das Gebiet so klein wie nötig aber auch so groß wie für das
Zielgebiet. Optimal wählt man das Gebiet entsprechend des Zielgebietes mit
einem Halo von wenigen Grad. Damit werden die Dateien nicht zu groß und an den
Rändern kann noch interpoliert werden.

------------------------------------------------------------------------------------------
*** Aufgabe 1 : erstelle die CAS Daten für Deine Episode (ein Monate, großes Gebiet)

- stelle die Konfiguration zusammen
- kleinste Zeiteinheit ist ein Monat, d.h. es werden Daten für mindestens einen Monat berechnet
Konfiguration : Zeitraum, Region
Ergebnis      : CAS Datenordner
- Abschätzung des benötigten Plattenplatzes (Vorgabe machen, wieviel jede Gruppe benötigt)
------------------------------------------------------------------------------------------


[BASIS_ORDNER]/[REGIONS_KEY]/[YYYY][MM]/cas*.nc
Es gibt bereits eine Reihe von CAF-Archiven, in die man seine Zielepisode einbetten kann.

BASIS_ORDNER = ~ingokir/work/devel-cclm/daten/CAS-ERA5/

REGIONS_KEY   : Gebiet (ca.)                           : Zeitraum
europe1       : -10 (W) ... 30 (E) 40 (N) ... 70 (N)   : 201806
europe2       : -20 (W) ... 40 (E) 35 (N) ... 70 (N)   : 201806
europe3       : -30 (W) ... 50 (E) 20 (N) ... 80 (N)   : 2018[06-08]
europe4       : -70 (W) ... 80 (E) 20 (N) ... 80 (N)   : 2014[08,09]
india1        : 30 (E) ... 125 (E) -20 (S) ... 45 (N)  : 2018[01-08]
northatlantic : -150 (W) ... 30 (E) -40 (S) ... 90 (N) : 2015/01-2020/06

Die Datei CASGRID... beschreibt i.d.R. das Gitter dieser Daten.

** Definition der Zielregion

In Kombination mit dem Zielgitter kann man die notwendigen Randdaten
für die gewünschte Episode erzeugen. Es gibt eine Reihe von vorbereiteten
Zielregionen ....

ICON_GRID : ...

--- EUROPA ---

europa044    : 0.44° 44km  17.228 Boxen
             lon : -47.75591 to 68.91826 degrees_east
             lat : 20.50585 to 73.73994 degrees_north
             -> macht Sinn mit eraint/era40 oder anderen gröberen Daten
             
pineti007    : 0.07°  7km  252.228 Boxen
             lon : -10.0 (W) ... 33.0 (E)
             lat :  32.0 (N) ... 63.0 (N)

europe00625  : 0.0625° 6km  407.528 Boxen
             lon : -50.0 (W) ... 60.0 (E)
             lat : 30.0 (N) ... 70.0 (N)

--- ATLANTIK ---

barbados010  : 0.1°  10km  49.476 Boxen
             lon : -70.0 (W) ... -50.0 (W)
             lat : 3.0 (N) ... 23.0 (N)

--- INDIEN ---

india013     : 0.13° 13km  195.568 Boxen
             lon : 49.0 (E) ... 109.0 (E)
             lat : -9.0 (S) ... 46.0 (N)

kolkata010   : 0.1°  10km  53.116 Boxen
             lon : 81.338 (E) ... 95.338 (E)
             lat : 15.541 (N) ... 29.541 (N)

Die offiziellen ICON_GRIDs werden zentral eingerichtet, das betrifft die
Gitter (DOM01, DOM01.parent) und die ExternalParameters. Diese Dateien findet
man hier ....

/daten/vast/arch/special-icon/icon-ini/
/daten/vast/arch/vast-git/models/icon-clm/ini/ (symlinks)
Gitter siehe .../sc-icon/gitter/[ICON_GRID]/[ICON_GRID]_DOM01.[nc|parent.nc]
Extpar siehe .../sc-clmsk/external_parameter_icon_[ICON_GRID]_DOM01_tiles.nc

In der Experimentumgebung wird dann ICON_GRID über die TARGET_REGION angesprochen
TARGET_REGION    : ICON_GRID 
europe           : europe044
europa6km        : europe00625
pineti7km        : pineti007
kolkata          : kolkata010
kolkata2         : kolkata010
kolkata3         : india013
barbados10km     : barbados010

Konfiguration einer neuer Region
- Gitter DOM0 und DOM1 erzeugen
- external parameter erstellen

Auslieferung der Daten dann via ...
https://download.dwd.de/pub/Pamore/


------------------------------------------------------------------------------------------
*** Aufgabe 2 : Erzeuge die Boundary Files für Dein Experiment

- suche die geeignete Gitterdatei
- kombiniere mit dem CAF/CAS Archiv
- lege den Zielordner fest
------------------------------------------------------------------------------------------


Es gibt bereits eine Reihe von LABF Archiven, die genutzt werden können.
Dann erspart man sich das Aufbereiten der Randdaten.

/daten/medusa/arch/ICON/
/daten/model/arch/ICON/
/home/ingokir/work/devel-icon/build/icon-work/spice_scratch/

Der Unterordner setzt sich aus zweu Keys zusammen ...

BASESET  : ... ZIELREGION
era5na  ... ERA5-Northatlantic
         : barbados10km  : 2019/12-2020/06
         : europe        : 2019/12-2020/04
         : pineti7km     : 2015/01-2020/01
eraint  ... Eraint-Global
         : europa        : 1979/01-04, 2019/01-04
india   ... ERA5-Indien
         : kolkata       : 2018[06-08]
         : kolkata2      : 2018/05
         : kolkata3      : 2018/05

Nach Abschluss den Blocks A sollten eine Zielregion und der dazu gehörende
Zeitraum festliegen. Der Ordner mit den Start- und Randdaten ist vorbereitet
und kann im Experiment benutzt werden.

==========================================================================================
* B - Simulationen durchführen
==============================

1. Einrichten einer Simulation
2. antesten und Anpassung des Setups
3. Auswerten der Ergebnisse

** Ausführen der Standardexperimente

Mit dem folgenden Installationscript ...

[VAST_BASE]models/scripts/install-exp.sh

... lassen sich verschiedene Setups einrichten und können dann Testweise ausgeführt
werden. Wenn man dieses Script ohne Argument startet, werden alle möglichen
Szenarien angezeigt.


** Durchführung einer Simulation mit den neuen Boundary Files

- benutze das Initialisierungsscript

Ausgangsscripten
.../icon-ifm/config-exp/compose-exp.sh

------------------------------------------------------------------------------------------
*** Aufgabe 3 : Referenzsimulation durchführen

Beispiele vorbereitet
a) Europa lt. Projekt PINETI
b) Indien gesamt 13 km
c) Kolkata 10 km
------------------------------------------------------------------------------------------

------------------------------------------------------------------------------------------
*** Aufgabe 4 : Sensitivitätsexperiment

Ausgangspunkt ist ein Referenzexperiment
gleiches Experiment als Sensitivitätsexperiment anlegen
im [runscript-clmsk.sh] werden die Namelisten zusammengestellt, dort
können Anpassungen vorgenommen werden

Szenarien ...

------------------------------------------------------------------------------------------


** Auswertung der Experimente

** offene Problemstellungen

siehe Planung.md

** Specifikation des Werkzeuges

siehe ../scripts/README.md



