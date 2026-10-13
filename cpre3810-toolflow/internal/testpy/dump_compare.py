# dump_compare.py compares the output of the Test Framework provided Testbench and RARS. 
# Usase is as follows (works in both python 2 and 3, but tested with python 2.7):
# 	python dump_compare.py <testbench_file> <rars_file> <max_mismatches>
# Example Usage:
# 	python dump_compare.py dump.txt student_RARSdump.txt 10
#
# NOTE: max_mismatches need not be provided, it will default to 2.

import sys
import re
import time

rars_firstline_re = re.compile(r'[0-9]*\[inst #(?P<num>[0-9]+)\] (?P<instr>[0-9$a-z ,\-\(\)]+)') # statrts with [0-9]* to ignore known rars issue
student_firstline_re = re.compile(r'In clock cycle: (?P<cycle>[0-9]+)')
register_write_re = re.compile(r'Register Write to Reg: (?P<reg>[0-9A-Fa-fxX]+) Val: (?P<val>[0-9A-Fa-fxX]+)')
# RARS omits byte enables; student memory writes must include the actual mask.
memory_write_re = re.compile(r'Memory Write to Addr: (?P<addr>[0-9A-Fa-fxX]+) Val: (?P<val>[0-9A-Fa-fxXzZ]+)(?: BE: (?P<be>[0-9A-Za-z-]+))?')
ovf_re = re.compile(r'Arithmetic Overflow Detected')
nop_re = re.compile(r'Register Write to Reg: 0x00.*')
partial_store_re = re.compile(r'^(?P<op>sb|sh)\s+x(?P<rs2>\d+)\s*,\s*(?P<imm>-?(?:0x[0-9a-f]+|\d+))\(x(?P<rs1>\d+)\)')

student_done_re = re.compile(r'Execution is stopping! Clock Cycle: (?P<cycle>[0-9]+)')
rars_done_re = re.compile(r'\[inst #(?P<inst>\d+)\] halt')

def main():
    max_mismatches = 2

    if not 3 <= len(sys.argv) <= 4:
        print('Improper usage, expecting python dump_compare.py <testbench_file> <rars_file> <max_mismatches>')
        print('Note: max_mismatches will default to 2 if not set')
        return 1

    student_file_path = sys.argv[1]
    rars_file_path = sys.argv[2]
    if len(sys.argv) == 4:
        try:
            max_mismatches = int(sys.argv[3])
        except (ValueError, TypeError):
            print('Invalid Argument in position 4, only numbers are accepted')
            return 1
        
    print('Maximum Number of Mismatches Accepted: ' + str(max_mismatches))
    print('')

    dc = DumpCompare(student_file_path, rars_file_path, max_mismatches)
    dc.compare()

    dc.print_cpi()


class StudentReader:
    '''
    Wraps a rars dump file object so that we can separate the skipping logic from the comparison logic
    '''

    def __init__(self,path):
        self.path = path
        self.f = open(path, "r")
        self.buff = []
        self.cyc_num = 0

    def read_next(self): 
        """
        Reads the next instruction from the student file.

        This will return either an instruction and a memory access, an
        intruction and a register access, or an instruction, reg access, and
        an overflow. Each return type will be a match object.

        """
        not_done = True
        while not_done:

            # Fill the buffer
            while (len(self.buff) < 3):
                self.buff.append(self.f.readline())

            if not self.buff[0]:
                # File is over
                return None, None, None

            cycle = student_firstline_re.search(self.buff[0])

            if not cycle:
                # We didn't read a valid cycle, skip and move on
                student_done = student_done_re.search(self.buff.pop(0))
                if student_done:
                    self.cyc_num = int(student_done.group("cycle")) + 1 # Add 1 because cycle count starts at zero
                    return None, None, None

                return self.read_next()
            else:
                self.buff.pop(0)

            self.cyc_num = int(cycle.group("cycle")) + 1

            # Do we have a register or memory write next?
            acc = memory_write_re.search(self.buff[0])
            if acc:
                self.buff.pop(0)
            else:
                acc = register_write_re.search(self.buff[0]) # this will be None if this also fails
                if acc:
                    self.buff.pop(0)

            # Lastly, do we have overflow?
            ovf = ovf_re.search(self.buff[0])
            if ovf:
                self.buff.pop(0)

            # Final checks -- is it a NOP? 
            if (not ovf and nop_re.search(acc.group())):
                not_done = True
            else:
                not_done = False

        return cycle, acc, ovf
        
    def close(self):
        self.f.close()

class RarsReader:
    '''
    Wraps a rars dump file object so that we can separate the skipping logic from the comparison logic
    '''

    def __init__(self,path):
        self.path = path
        self.f = open(path, "r")
        self.buff = []
        self.inst_num = 1

        self.regs = [0] * 32
        self.regs[2] = 0x7FFFEFFC # sp
        self.regs[3] = 0x10008000 # default RARs value

    def partial_store_access(self, instr):
        '''
        Returns a memory write match object for an untraced sb/sh, or None if
        instr is not a partial store. Address is the byte address and the value
        is the zero-extended byte/halfword being stored.
        '''
        st = partial_store_re.search(instr.strip())
        if not st:
            return None
        addr = (self.regs[int(st.group('rs1'))] + int(st.group('imm'), 0)) & 0xFFFFFFFF
        mask = 0xFF if st.group('op') == 'sb' else 0xFFFF
        val = self.regs[int(st.group('rs2'))] & mask
        return memory_write_re.search(f'Memory Write to Addr: 0x{addr:08X} Val: 0x{val:08X}')

    def read_next(self):
        """
        Reads the next instruction from the student file.

        This will return either an instruction and a memory access, an
        intruction and a register access, or an instruction, reg access, and
        an overflow. Each return type will be a match object.

        """
        not_done = True
        while not_done:

            # Fill the buffer
            while (len(self.buff) < 3):
                self.buff.append(self.f.readline())

            if not self.buff[0]:
                # File is over
                return None, None, None

            inst = rars_firstline_re.search(self.buff[0])



            if not inst:
                # We didn't read a valid cycle, skip and move on
                rars_done = rars_done_re.search(self.buff.pop(0))
                if rars_done:
                    self.inst_num = int(rars_done.group("inst"))
                    return None, None, None
                return self.read_next()
            else:
                self.buff.pop(0)

            self.inst_num = inst.group("num")

            if "halt" in inst.group("instr"):
                # Same effect as EOF
                return None, None, None


            # Do we have a register or memory write next?
            acc = memory_write_re.search(self.buff[0])
            if acc:
                self.buff.pop(0)
            else:
                acc = register_write_re.search(self.buff[0]) # this will be None if this also fails
                if acc:
                    self.buff.pop(0)
                    reg = int(acc.group('reg'), 16)
                    if reg != 0:
                        self.regs[reg] = int(acc.group('val'), 16)
                else:
                    acc = self.partial_store_access(inst.group('instr'))
                    if not acc:
                        # Doesn't do anything to reg or mem (control flow)
                        return self.read_next()

            # Lastly, do we have overflow?
            ovf = ovf_re.search(self.buff[0])
            if ovf:
                self.buff.pop(0)

            # Final checks -- is it a NOP? 
            if (not ovf and nop_re.search(acc.group())):
                not_done = True
            else:
                not_done = False
            
        return inst, acc, ovf
       
    def close(self):
        self.f.close()

class DumpCompare:
    helpinfo = '''
Helpful resources for Debugging:
ms.trace : output from the VHDL testbench during program execution on your processor
rars.trace : output from RARS containing expected output
vsim.wlf: waveform file generated by processor simulation, you can display this simulation in ModelSim without resimulating your processor by hand

'''


    def __init__(self, student_file, rars_file, max_mismatches=3, outfunc=print, help=False):
        self.student_reader = StudentReader(student_file)
        self.rars_reader = RarsReader(rars_file)
        self.student_path = student_file
        self.rars_path = rars_file
        self.max_mismatches = max_mismatches
        self.outfunc = outfunc
        self.mismatches = 0

        self.inst_num = 1 # Prevents a division by zero if no instructions issue
        self.clk_cyc = 0
        self.help = help

    def acc_match(self, m_inst, m_acc, s_acc):
        '''
        Returns True if RARS and student accesses are equivalent.

        Register writes require an exact string match. Memory writes require
        the byte enables dictated by the RARS instruction and address, and
        matching data in those lanes. Inactive data lanes may be unknown.
        '''
        if m_acc.re != memory_write_re or s_acc.re != memory_write_re:
            return m_acc.group() == s_acc.group()

        if m_inst is None:
            return False

        op = m_inst.group('instr').split()[0].lower()
        size = {'sb': 1, 'sh': 2, 'sw': 4}.get(op)
        if size is None:
            return False

        try:
            addr = int(m_acc.group('addr'), 16)
            if addr != int(s_acc.group('addr'), 16) or addr % size != 0:
                return False

            byte_offset = addr & 0x3
            expected_be = ((1 << size) - 1) << byte_offset
            if s_acc.group('be') != format(expected_be, '04b'):
                return False

            # Trace data is a 32-bit bus word, with lane 0 at the right.
            data = s_acc.group('val')
            if data.lower().startswith('0x'):
                data = data[2:]
            if len(data) != 8:
                return False
            start = 8 - 2 * (byte_offset + size)
            end = 8 - 2 * byte_offset
            actual = int(data[start:end], 16)
            expected = int(m_acc.group('val'), 16) & ((1 << (8 * size)) - 1)
            return actual == expected
        except ValueError:
            # Unknown enabled data or addresses are mismatches, not crashes.
            return False

    def print_error(self, cycle, inst, expected, actual, description):
        self.mismatches += 1

        if cycle:
            cycle_num = cycle.group('cycle')
        else:
            cycle_num = 'na'

        if inst:
            inst_num = inst.group('num')
            inst = inst.group('instr')
        else:
            inst_num = 'na'
            inst = 'na'

        if self.mismatches == 1:
            self.outfunc('Oh no...\n')
        self.outfunc(f'Cycle: {cycle_num}')
        self.outfunc(f'RARS instruction number: {inst_num}\tInstruction: {inst}')
        self.outfunc(f'Expected:\t{expected}')
        self.outfunc(f'Got     :\t{actual}')
        if description:
            self.outfunc(description)
        self.outfunc("")

    def compare(self):
        '''
        Compares the modelsim and rars dump files for a program
        Returns True if sim succeeded, false otherwise
        '''
    
        while self.mismatches < self.max_mismatches:
   
            #get rars instruction
            m_inst, m_acc, m_ovf = self.rars_reader.read_next() 

            s_cycle, s_acc, s_ovf = self.student_reader.read_next() 
            
            # Both end
            if (not s_cycle) and (not m_inst):
                break

            if (not s_cycle) and m_inst:
                self.print_error(s_cycle, m_inst, m_acc.group(), "Execution stopped",
                    "Student execution ended prematurely")
                break
                
            if s_cycle and not m_inst: 
                self.print_error(s_cycle, m_inst, "Execution stopped", s_acc.group(),
                    "Student execution improperly continued")
                break
                

            if self.acc_match(m_inst, m_acc, s_acc) and (type(m_ovf) == type(s_ovf)):
                # instruction is correct
                continue

            # Something is wrong... Loop as we may need to remove NOPs
            #
            # The way this looping works is that we first try to determine if
            # either RARs or the student is apparantly writing to register 0
            # eg is it a NOP. Note... there is a case where a reg write to 
            # zero may be triggering overflow. This should be caught by the 
            # student as it is valid.
            #
            # If overflow has been possibly detected... then refresh either
            # the rars stream or the student stream and try again, until
            # eventually we either match or error out.
            while True:
                # Both end
                if (not s_cycle) and (not m_inst):
                    break

                if not s_cycle: # Only happens at EOF
                    self.print_error(s_cycle, m_inst, m_acc, "Execution stopped",
                        "Student execution ended prematurely")
                    break
                if not m_inst: # Only happens at EOF
                    self.print_error(s_cycle, m_inst, "Execution stopped", "Execution stopped",
                        "Student execution ended prematurely")
                if self.acc_match(m_inst, m_acc, s_acc) and (type(m_ovf) == type(s_ovf)):
                    # instruction is correct
                    break
                if self.acc_match(m_inst, m_acc, s_acc):
                    # Overflow is wrong, is the student a NOP?
                    if nop_re.search(s_acc.group()):
                        s_cycle, s_acc, s_ovf = self.student_reader.read_next()
                        continue
                    else:
                        exp = "Overflow" if m_ovf else "No Overflow"
                        got = "Overflow" if s_ovf else "No Overflow"
                        self.print_error(s_cycle, m_inst, exp, got, "Overflow is incorrect")
                        break
                # Is the student a NOP
                if nop_re.search(s_acc.group()):
                    s_cycle, s_acc, s_ovf = self.student_reader.read_next() 
                    continue # Try again

                # Is the rars a NOP
                if nop_re.search(m_acc.group()):
                    m_inst, m_acc, m_ovf = self.rars_reader.read_next() 
                    continue # Try again
                    
                # Is the write to the wrong structure?
                if (m_acc.re == memory_write_re) and (s_acc.re == register_write_re):
                    # Nop?
                    if nop_re.search(s_acc.group()):
                        s_cycle, s_acc, s_ovf = self.student_reader.read_next()
                        continue
                    self.print_error(s_cycle, m_inst, m_acc.group(), s_acc.group(), "Wrote to incorrect structure")
                    break
                if (s_acc.re == memory_write_re) and (m_acc.re == register_write_re):
                    # Nop?
                    if nop_re.search(m_acc.group()):
                        m_inst, m_acc, m_ovf = self.rars_reader.read_next() 
                        continue
                    self.print_error(s_cycle, m_inst, m_acc.group(), s_acc.group(), "Wrote to incorrect structure")
                    break

                # all thats left is incorrect writes
                self.print_error(s_cycle, m_inst, m_acc.group(), s_acc.group(), "Incorrect write")
                break

        self.inst_num = self.rars_reader.inst_num
        self.clk_cyc = self.student_reader.cyc_num
   
        self.rars_reader.close()
        self.student_reader.close()

        #Print final message
        if self.mismatches == 0:
            if self.help:
                self.outfunc('Victory!! Your processes matches RARS expected output with no mismatches!!')
            return True
        elif self.mismatches < self.max_mismatches:
            if self.help:
                self.outfunc(f'Almost! your processor completed the program with  {self.mismatches}/{self.max_mismatches} allowed mismatches')
                self.outfunc(self.helpinfo)
            return False
        else:
            if self.help:
                self.outfunc(f'You have reached the maximum mismatches ({self.mismatches})')
                self.outfunc(self.helpinfo)
            return False

    def get_cpi(self):
        return int(self.clk_cyc) / int(self.inst_num)

    def print_cpi(self):
        self.outfunc(f"Instructions: {self.inst_num:4}\tCycles: {self.clk_cyc:4}\tCPI: {int(self.clk_cyc)/int(self.inst_num):.4}")

    def write_cpi(self, f):
        f.write(f"Instructions issued: {self.inst_num}\n")
        f.write(f"Student Processor Cycles: {self.clk_cyc}\n")
        f.write(f"CPI: {int(self.clk_cyc)/int(self.inst_num):.4}\n")

if __name__ == '__main__':
    main()
