import sys

with open('c:/CSW430/final2/EXAM_CHEATSHEET.js', 'r', encoding='utf-8') as f:
    lines = f.readlines()

out = []
in_code = False
for line in lines:
    if line.startswith('// ████'):
        in_code = False
        out.append(line)
        continue
    
    if line.startswith('import '):
        in_code = True

    if in_code:
        if not line.startswith('//'):
            out.append('// ' + line)
        else:
            out.append(line)
    else:
        out.append(line)

with open('c:/CSW430/final2/EXAM_CHEATSHEET.js', 'w', encoding='utf-8') as f:
    f.writelines(out)
