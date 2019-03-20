# 12th Sept 2018
#
# RUN ligA bound state wt-metadynamics
#    CV1 : distance
#    CV2 : orientation
#    DT  : 1000K
#    A   : 0.1 kcal
#    d   : 0.08 (colvars units**2)
#    t   : 50 ns
#    dt  : 1 fs
#    T   : 298K
#    P   : 1atm
#
#
# PROTOCOL
# 1. Optimize 5000 steps
# 2. Equilibrate 50000 steps
# 3. Run WT-Metadynamics simulation 50000000 steps
# ---------------------------------------------------------------------------- #
# VARIABLES
PROC=32
# input
OPTINPUT="run_optimize.namd"
EQINPUT="run_equilibrate.namd"
RUNINPUT="run_metadynamics_01.namd"
# output
OPTOUTPUT="./opt/optimization.log"
EQOUTPUT="./eq/equilibrate.log"
RUNOUTPUT="./run/run.log"
# err
OPTERROR="./opt/optimization.err"
EQERROR="./eq/equilibrate.err"
RUNERROR="./run/run.err"
# CHECKING NAMD PATH
echo "[$(date +'%r')] STARTING RUN LIGA-BB-WTMETADYN" >> logfile
if [ -z "${NAMD_PATH}" ] ; then
	echo "missing NAMD_PATH env variable"
	exit 1
else
	echo "NAMD PATH is ${NAMD_PATH}" >> logfile
fi
# COPYING FILES
cp "./input/ligA_bb_w.psf" .
cp "./input/ligA_bb_w.pdb" .
# OPTIMIZATION
mkdir -p opt
cp "./scripts/run_optimize.namd" .
echo "[$(date +'%r')] Starting optimization protocol" >> logfile
${NAMD_PATH}/namd2 "+p${PROC}" "${OPTINPUT}" 1>"${OPTOUTPUT}" 2>"${OPTERROR}"
echo "[$(date +'%r')] Optimization protocol finished" >> logfile
rm "./run_optimize.namd"
# EQUILIBRATION
mkdir -p eq
cp "./scripts/run_equilibrate.namd" .
cp "./input/ligA_bb_w_protein_fixed.pdb" .
echo "[$(date +'%r')] Starting equilibration protocol" >> logfile
${NAMD_PATH}/namd2 "+p${PROC}" "${EQINPUT}" 1>"${EQOUTPUT}" 2>"${EQERROR}"
echo "[$(date +'%r')] Equilibration protocol finished" >> logfile
rm "./run_equilibrate.namd"
# METADYNAMICS
mkdir -p run
cp "./scripts/run_metadynamics.namd" .
echo "[$(date +'%r')] Starting metadynamics protocol" >> logfile
${NAMD_PATH}/namd2 "+p${PROC}" "${RUNINPUT}" 1>"${RUNOUTPUT}" 2>"${RUNERROR}"
echo "[$(date +'%r')] Metadynamics protocol finished" >> logfile
rm "./run_metadynamics.namd"
# CLEANING
rm "./input/ligA_bb_w.psf" .
rm "./input/ligA_bb_w.pdb" .
echo "[$(date +'%r')] FINISHED" >> logfile
