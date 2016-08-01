#!/usr/bin/env python

####################################################################
# Imports.
####################################################################

# import sys, inspect
import os
import argparse
import subprocess
# import sh


####################################################################
# Arguments Parser
####################################################################

# ARGUMENTS CONFIG
__author__ = 'jgentle'
parser = argparse.ArgumentParser(description='This is the MODFLOW 96 case data extraction script.')

# note: set required to false in order to use set_defaults on an option.
# parser.add_argument('-msd', '--modelsourcedir', help='Input directory path for the model source data. Defaults to model_src if no argument is provided.', required=False)
# parser.add_argument('-rd', '--rechargedir', help='Input directory path for the recharge interpretation source files. Defaults to recharge_interpretations if no argument is provided.', required=False)
# parser.add_argument('-wd', '--welldir', help='Input directory path for the well scalar source files. Defaults to well_scalars if no argument is provided.', required=False)
# parser.add_argument('-mf', '--manifestfile', help='Filename for the manifest to track generated cases. Defaults to scenario_manifest.dat if no argument is provided.', required=False)
# parser.add_argument('-od', '--outputdir', help='Output directory for the generated cases. Defaults to generated_cases if no argument is provided.', required=False)
# parser.add_argument('-cp', '--caseprefix', help='Naming prefix for the generated case directories. Defaults to case if no argument is provided.', required=False)
# parser.add_argument('-dr', '--dryrun', help='Dry run the script without generating cases to test configs. Defaults to false if no argument is provided.', required=False)

parser.add_argument('-cdd', '--casedatadir', help='Input directory path for the case data source files. Defaults to . if no argument is provided.', required=False)

# Set some defaults for simplicity.
# parser.set_defaults(modelsourcedir="model_src")
# parser.set_defaults(rechargedir="recharge_interpretations")
# parser.set_defaults(welldir="well_scalars")
# parser.set_defaults(manifestfile="scenario_manifest.dat")
# parser.set_defaults(outputdir="generated_cases")
# parser.set_defaults(caseprefix="case")
# parser.set_defaults(dryrun='false')

parser.set_defaults(casedatadir=".")

# Parse the cli args (which will supercede the defaults).
args = parser.parse_args()

####################################################################
# Variables.
####################################################################

# # current_dir = os.path.abspath('')
# current_dir = os.getcwd()

# # model_src_dir = './base_model_src'
# model_src_dir = args.modelsourcedir
# model_src_path = os.path.abspath(model_src_dir)

# # recharge_dir = './recharge_interpretations'
# recharge_dir = args.rechargedir
# recharge_path = os.path.abspath(recharge_dir)

# # well_dir = './well_scalars'
# well_dir = args.welldir
# well_path = os.path.abspath(well_dir)

# # manifest_file = 'scenario_manifest.dat'
# manifest_file = args.manifestfile
# manifest_file_target = current_dir + '/' + manifest_file

# # generated_cases_dir = 'generated_cases'
# generated_cases_dir = args.outputdir
# generated_cases_path = os.path.abspath(generated_cases_dir)

# # generated_cases_prefix = '/bsgam_mf96_'
# generated_cases_prefix = '/' + args.caseprefix + '_'

# dry_run = args.dryrun

case_data_dir = args.casedatadir
case_data_path = os.path.abspath(case_data_dir)

####################################################################
# Methods.
####################################################################


####################################################################
# Generation Logic.
####################################################################

def extractCaseData():
    print ' '
    print '--------------------------------------'
    print 'Starting Modflow 96 Case Generation...'
    print '--------------------------------------'
    print ' '

    iterator = 1

    # Iterate over cases.
    for case in os.listdir(case_data_path):

        # Get refs to paths.
        case_path = os.path.abspath(case);
        output_file_path = os.path.join(case_path, 'output.dat')

        # Read contents of file.
        output_file = open(output_file_path)
        output_file_data = output_file.read()

        ## Verify paths.
        print '============================================'
        print 'Extracting data from case:'
        print 'case_data_path: ', case_data_path
        print 'case_path: ', case_path
        print 'output_file_path: ', output_file_path
        print 'output_file: ', output_file
        # print 'output_file_data: ', output_file_data


        # ============================================
        # Extracting data from case:
        # casedata path:  /data/03325/jgentle/encompass/modflow/modflow96/data_src/generated_cases/bsgam/gen_2
        # case path:  /data/03325/jgentle/encompass/modflow/modflow96/data_src/generated_cases/bsgam/gen_2/bsgam_mf96_rchTROLD_wells_c9949b18178fee559f552f142bc63a7e
        # output_file_path:  /data/03325/jgentle/encompass/modflow/modflow96/data_src/generated_cases/bsgam/gen_2/bsgam_mf96_rchTROLD_wells_c9949b18178fee559f552f142bc63a7e/output.dat
        # output_file:  <open file '/data/03325/jgentle/encompass/modflow/modflow96/data_src/generated_cases/bsgam/gen_2/bsgam_mf96_rchTROLD_wells_c9949b18178fee559f552f142bc63a7e/output.dat', mode 'r' at 0x2b735d6b69c0>
        # output_file_data:   LISTING FILE: output.dat
        # ...


        ### Grep out last 40 lines of output_file_data into output_file_data_cum
        #
        # subprocess.call(['echo $HOME'], shell=True)

        # TEST 1
        # cmd = ["/bin/grep -a -A 40 -e 'VOLUMETRIC.*12.*120' %s" %output_file_data]
        # subprocess.call(cmd)
        # 
        # ERROR: 
        # Traceback (most recent call last):
        #   File "./case_data_output_cumulative_extraction.py", line 165, in <module>
        #     extractCaseData()
        #   File "./case_data_output_cumulative_extraction.py", line 135, in extractCaseData
        #     subprocess.call("/bin/grep -a -A 40 -e 'VOLUMETRIC.*12.*120' %s" %output_file_data)
        #   File "/opt/apps/intel15/python/2.7.9/lib/python2.7/subprocess.py", line 522, in call
        #     return Popen(*popenargs, **kwargs).wait()
        #   File "/opt/apps/intel15/python/2.7.9/lib/python2.7/subprocess.py", line 710, in __init__
        #     errread, errwrite)
        #   File "/opt/apps/intel15/python/2.7.9/lib/python2.7/subprocess.py", line 1335, in _execute_child
        #     raise child_exception
        # TypeError: must be encoded string without NULL bytes, not str
        
        # TEST 2
        # cmd = ["""/bin/grep -a -A 40 -e 'VOLUMETRIC.*12.*120' output_file_data"""]
        # print subprocess.Popen(cmd,shell=True)

        # TEST 3
        # cmd = ["""/bin/grep -a -A 40 -e 'VOLUMETRIC.*12.*120' output_file_data"""]
        # print subprocess.Popen(cmd,shell=True)
        
        # TEST 4
        # results=subprocess.Popen(['grep','"host:"',output_file], stdout= subprocess.PIPE)
        # results=subprocess.Popen(['grep','-a -A 40 -e "VOLUMETRIC.*12.*120"',output_file], stdout= subprocess.PIPE)
        # results=subprocess.Popen(['grep -a -A 40 -e "VOLUMETRIC.*12.*120"',output_file], stdout= subprocess.PIPE)
        # results=subprocess.Popen(['grep','-a -A 40 -e "VOLUMETRIC.*12.*120"',output_file_data], stdout= subprocess.PIPE)
        # results = subprocess.Popen(('grep -a -A 40 -e "VOLUMETRIC.*12.*120"', output_file),shell=True, stdin=subprocess.PIPE, stdout=subprocess.PIPE)
        # results = subprocess.Popen(('grep -a -A 40 -e "VOLUMETRIC.*12.*120"' %output_file), shell=True, stdin=subprocess.PIPE, stdout=subprocess.PIPE)
        # print results.stdout.read()
        
        # TEST 5
        # cmd = ["/bin/grep -a -A 40 -e 'VOLUMETRIC.*12.*120' %s" %output_file_data]
        cmd = ["/bin/grep -a -A 40 -e 'VOLUMETRIC.*12.*120' " + output_file_data]
        print 'cmd: ', cmd
        results=subprocess.Popen(cmd, stdout= subprocess.PIPE)  
        # print 'results: ', results.stdout.read()  #YES????
        # 
        # results.stdout.read() > outputCUM.dat  #outputVOL.dat in Daniel's scripts.
        # results.stdout > outputCUM.dat

        # Run perl script on output_file_data_cum to populate cumulative_data

    print ' '
    print '--------------------------------------'
    print 'Modflow 96 Case Generation Complete.'
    print '--------------------------------------'
    print ' '


####################################################################
# Start Module.
####################################################################

extractCaseData()

####################################################################
# End Module.
####################################################################