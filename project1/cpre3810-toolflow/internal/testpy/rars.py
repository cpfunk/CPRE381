"""Rars Interface.

Date:
    2022.08.24
    2025.02.12 Converto to RARS Aiden Peterson
"""

import subprocess
from pathlib import Path

import logging
logger = logging.getLogger(__name__)

class Rars:
    """Interface into rars execution.
    """

    def __init__(self, rars_path):
        """Creates new Rars object.

        Args:
            rars_path (str): String or pathlike to rars jar
        """
        logger.debug(f'New Rars runner, using jar {rars_path}')
        self.rars_path = Path(rars_path)  #:Rars Path

        if not self.rars_path.is_file():
            raise FileNotFoundError

    def check_asm_file(self, asm_file_path):
        """Set the asm file to use.

        Checks if the given file exists.

        Args:
            asm_file_path (str) : String or path like to asm file

        Returns:
            True if file exists, else false
        """
        asm_file_path = Path(asm_file_path)

        if not asm_file_path.is_file():
            logger.warning('ASM file "{self.asm_file_path}" does not exist')
            return False

        return True

    def check_assemble(self, asm_file_path):
        """Assembles RISCV file.

        Args:
            asm_file_path (str) : String or Pathlike to RISCV file

        Returns:
            list of errors (empty if no errors)

        """
        if not self.check_asm_file(asm_file_path):
            return [f'Error: file "{asm_file_path}" does not exists', ]

        errors = subprocess.check_output(
            ['java','-jar', self.rars_path, 'nc', 'a', asm_file_path],
            stderr=subprocess.STDOUT,
            encoding='utf8'
            )

        error_list = errors.split('\n')[:-3] # Throw away the last 3 lines, as they are general messages

        logger.info(f'Assembled file {asm_file_path}. Found {len(error_list)} errors.')

        return error_list

    def generate_hex(self, asm_file_path, output_path):
        """Generates hex files for IMEM and DMEM sections.

        This generates both IMEM and DMEM hex files. The method assumes that the assembly file
        correctly compiles

        Args:
            output_path (str) : String or path like to output files.
                Output files will be {output_path}.imem and {output_path}.dmem

            asm_file_path (str): String or path like to assembly file

        Returns:
            True if succesfull, else false

        """

        if not self.check_asm_file(asm_file_path):
            return False

        imem_path = Path(output_path) / 'imem.hex'
        dmem_path = Path(output_path) / 'dmem.hex'
    
        subprocess.check_output(
            ['java', '-jar', self.rars_path, 'a', 'dump', '.text', 'HexText', imem_path, asm_file_path],
            )
    
        # create the dump file in case no data mem dump is generated
        dmem_path.touch()
    
        subprocess.check_output(
            ['java', '-jar', self.rars_path, 'a', 'dump', '.data', 'HexText', dmem_path, asm_file_path],
            )

        logger.info(f'Generated hex files {imem_path} and {dmem_path}')
        return True


    def run_sim(self, asm_file_path, output_trace, timeout=30):
        '''Simulates given RISCV file.

        Args:
            asm_file (str) : String or pathlike of asm_file
    
        Returns:
            list of errors (empty if no errors)
        '''
        logger.info(f'Simulating file {asm_file_path}')

        if not self.check_asm_file(asm_file_path):
            return [f'Error: file "{asm_file_path}" does not exists', ]

        rars_out = subprocess.run(
            ['timeout', str(timeout), 'java', '-jar', self.rars_path, 'nc', asm_file_path],
            encoding='utf8',
            stdout=subprocess.PIPE,
            stderr=subprocess.STDOUT
            )
    
        if rars_out.returncode == 124:
            logger.warning('Rars hit infinite loop.')
            rars_errs.append('Rars hit infinite loop. Check assembly file for infinte recursion or loops.')
        
        rars_errs = self.check_rars_dump(rars_out.stdout)

        with open(output_trace, 'w') as f:
            f.write(rars_out.stdout)

        return rars_errs


    def check_rars_dump(self, output):
        '''Checks rars dump for errors.

        Args:
            output (str) : Rars output trace

        Returns:
            None if no error, else next error

        '''
    
        # Rars does not seem provide non-zero error codes, so we need to look at the dump to check for errors
        # We defensively check for the assembly file not existing, so an invalid argument should not be possible
        # This method scans the dump and checks for lines starting with 'Error '

        errors = []
    
        for line in output.split('\n'):
            if line.startswith('Error '):
                logger.warning(f'Found RARS sim error - {line.rstrip()}')
                errors.append(line.rstrip())

        return errors
    
