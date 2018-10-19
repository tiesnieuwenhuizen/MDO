# -*- coding: utf-8 -*-
"""
Created on Wed Oct 10 10:22:59 2018

@author: xx
"""

from pyxdsm.XDSM import XDSM

#
opt = 'Optimization'
comp = 'Analysis'
group = 'Metamodel'
func = 'Function'

x = XDSM()



x.add_system('opt', opt, r'\text{Optimizer}')
x.add_system('A', comp, r'\text{Aerodynamics}')
x.add_system('L', comp, r'\text{Loads}')
x.add_system('S', comp, r'\text{Structures}')
x.add_system('P', comp, r'\text{Performance}')
x.add_system('O', func, r'\text{Objective}')
x.add_system('I', func, r'\text{Inequality Constraints}')
x.add_system('C', func, r'\text{Consistency Constraints}')


x.connect('opt', 'A', r'S_{e},b_{e},\lambda_{e},\Lambda_{LE},\\CST_{root},CST_{tip},\phi_{e},\hat{MTOW},\hat{W_{f}}')
x.connect('opt', 'L', r'S_{e},b_{e},\lambda_{e},\Lambda_{LE},\\CST_{root},CST_{tip},\phi_{e},\hat{MTOW},\hat{W_{f}}')
x.connect('opt', 'S', r'S_{e},b_{e},\lambda_{e},\Lambda_{LE},\\CST_{root},CST_{tip},\hat{MTOW},\hat{W_{f}},\hat{loading},loc_{engines}')
x.connect('opt', 'P', r'\hat{MTOW},\hat{L/D}')
#x.connect('A', 'I', r' z')
x.connect('A', 'C', r' \hat{L/D}')
#x.connect('L', 'I', r' z')
x.connect('L', 'C', r' \hat{loading}')
x.connect('S', 'I', r' \hat{MTOW}')
x.connect('S', 'C', r' \hat{MTOW}')
x.connect('P', 'O', r' \hat{W_{f}}')
x.connect('P', 'I', r' \hat{W_{f}}')
x.connect('P', 'C', r' \hat{W_{f}}')
x.connect('opt', 'I', r' S_{e},b_{e},CST_{root},CST_{tip},\lambda_{e},\Lambda_{LE},loc_{engines}')
x.connect('opt','C',r'\hat{MTOW},\hat{W_{f}},\hat{loading},\hat{L/D}')
#x.connect('A', 'opt', r'')
#x.connect('L', 'opt', r'\mathcal{R}(L)')
#x.connect('S', 'opt', r'\mathcal{R}(S)')
#x.connect('P', 'opt', r'\mathcal{R}(P)')


x.connect('O', 'opt', r'f_{0}')
x.connect('I', 'opt', r'c_{0}')
x.connect('C', 'opt', r'c_{c}')

x.add_input('opt',r'S_{e}^{0},b_{e}^{0},\lambda_{e}^{0},\Lambda_{LE}^{0},CST_{root}^{0},CST_{tip}^{0},\phi_{t}^{0},loc_{engines}^{0},\hat{MTOW}^{0},\hat{W_{f}}^{0},\hat{loading}^{0},\hat{L/D}{^0}')

x.add_output('opt', r'S_{e}^{*},b_{e}^{*},\lambda_{e}^{*},\Lambda_{LE}^{*},CST_{root}^{*},CST_{tip}^{*},\phi_{t}^{*},loc_{engines}^{*},\hat{MTOW}^{*},\hat{W_{f}}^{*},\hat{loading}^{*},\hat{L/D}^{*}', side='left')
x.add_output('A', r'L/D^{*}', side='left')
x.add_output('L', r'loading^{*}', side='left')
x.add_output('S', r'MTOW^{*}', side='left')
x.add_output('P', r'W_{f}^{*}', side='left')
#x.add_output('F', r'f^*', side='left')
#x.add_output('G', r'g^*', side='left')
x.write('mdf4')