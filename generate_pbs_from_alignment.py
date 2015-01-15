# Call this python script with a directory as the argument. It will generate .pbs files for submission to lion-xg cluster

from subprocess import Popen, PIPE
from shlex import split
from re import sub
import sys

def create_files(directory):
    #the beginning of the .pbs file
    front = """
    #PBS -l nodes=8
    #PBS -l walltime=10:00:00
    #PBS -l pmem=1gb
    #PBS -j oe
    # set nodes to CPU number, allowing for use of cores on any nodes
    cd $PBS_O_WORKDIR
    date
    
    module load openmpi/gnu
    mpirun ~/work/bin/raxmlHPC-MPI -s """
    
    #the rest of the pbs file, i.e. the stuff after the parameter we are going to alter
    back = """ -m GTRGAMMA -p 12345 -x 12345 -f a -N 500 
    # calling raxml mpi version (multiple nodes) -x random seed -f a is a rapid bootstrap analysis with an optimal tree search in the same run
    # -N number of bs replicates -m model of sequence evolution
    
    date
    """
    
    #create a subprocess to get the files in the current directory
    proc = Popen(split("ls " + directory), stdout=PIPE, stderr=PIPE)
    
    #run the subprocess
    stdout, stderr = proc.communicate()
    
    #parse the output of ls to get the list of files
    files = stdout.split("\n")[:-1]
    
    #loop over the files
    for filename in files:
        #create a new file
        writefile = open(filename[:-4] +".pbs", "w")
        
        #remove "alignment EDIT" and ".phy"
        #these can be altered to clean up output files
        honk = sub("_translation_alignment_EDIT.phy", "", filename)
        mid = sub("Arabidopsis", "", honk)
        
        #write the whole thing to a file,
        #concatenating the beginning of the pbs file, the parameter, and the stuff after
        writefile.write(front + filename + " -n " + mid + back)
        
        #close the file
        writefile.close()
    
if __name__ == "__main__":
    create_files(sys.argv[1])    
