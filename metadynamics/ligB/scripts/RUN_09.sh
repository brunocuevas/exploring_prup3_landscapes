# 09.namd# 12th Sept 2018
#
# IMPORTANT - This will be run in Magerit so the syntax is quite different
# to others run files
#
# RUN ligB bound state wt-metadynamics
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
# 1. Run WT-Metadynamics simulation 50000000 steps
# ---------------------------------------------------------------------------- #
# VARIABLES
PROC=32
# MODULES
OPTIMIZATION="false"
EQUILIBRATION="false"
METADYNAMICS="true"
# input
OPTINPUT="run_optimize.namd"
EQINPUT="run_equilibrate.namd"
RUNINPUT="run_metadynamics_09.namd"
# output
OPTOUTPUT="./opt/optimization.log"
EQOUTPUT="./eq/equilibrate.log"
RUNOUTPUT="./run_09/run.log"
# err
OPTERROR="./opt/optimization.err"
EQERROR="./eq/equilibrate.err"
RUNERROR="./run_09/run.err"
# COPYING FILES
cp "./input/ligB_bb_w.psf" .
cp "./input/ligB_bb_w.pdb" .
# OPTIMIZATION
if [ "${OPTIMIZATION}" == true ] ; then
	mkdir -p opt
	cp "./scripts/run_optimize.namd" .
	echo "[$(date +'%r')] Starting optimization protocol" >> logfile
	srun ${NAMD_PATH}/namd2  "${OPTINPUT}" 1>"${OPTOUTPUT}" 2>"${OPTERROR}"
	echo "[$(date +'%r')] Optimization protocol finished" >> logfile
	rm "./run_optimize.namd"
fi
# EQUILIBRATION
if [ "${EQUILIBRATION}" == true ] ; then
	mkdir -p eq
	cp "./scripts/run_equilibrate.namd" .
	cp "./input/ligB_bb_w_protein_fixed.pdb" .
	echo "[$(date +'%r')] Starting equilibration protocol" >> logfile
	srun ${NAMD_PATH}/namd2  "${EQINPUT}" 1>"${EQOUTPUT}" 2>"${EQERROR}"
	echo "[$(date +'%r')] Equilibration protocol finished" >> logfile
	rm "./run_equilibrate.namd"
fi
# METADYNAMICS
if [ "${METADYNAMICS}" == true ] ; then
	mkdir -p run_09
	cp "./scripts/${RUNINPUT}" .
	echo "[$(date +'%r')] Starting metadynamics protocol" >> logfile
	srun ${NAMD_PATH}/namd2  "${RUNINPUT}" 1>"${RUNOUTPUT}" 2>"${RUNERROR}"
	echo "[$(date +'%r')] Metadynamics protocol finished" >> logfile
	rm "./${RUNINPUT}.namd"
fi
# CLEANING
#rm "./input/ligB_bb_w.psf" .
#rm "./input/ligB_bb_w.pdb" .
echo "[$(date +'%r')] FINISHED" >> logfile
