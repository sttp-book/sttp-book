#!/usr/bin/python
from pandocfilters import toJSONFilter, RawBlock
import re

"""
Pandoc filter that converts html tables into latex tables, supporting colspan and rowspan
"""

row_amount, pos = dict(), 0
col_to_add, col_tag = 0, ""



def html(l):
    return [RawBlock('html', x) for x in l]

def pre_string(content):
    global row_amount, pos
    if pos in row_amount and re.search(r"<(td|th).*>", content):
        row_amount[pos] -= 1
        if row_amount[pos] <= 0:
            del row_amount[pos]
        return ["<td>","</td>"]
    return []


def tables(key, value, format, meta):
    if key == 'RawBlock':
        global rows_amount, pos, col_to_add, col_tag
        block_format, content = value


        if content == "</tr>":
            pos = 0

        if re.search(r"</(th|td)>", content):
            pos += 1
            if col_to_add > 0:
                res =  html([content] + [f"<{col_tag}>", f"</{col_tag}>"] * col_to_add)
                col_to_add = 0
                col_tag = ""
                return res
            return html([content])

        if match := re.match(r"<(td|th) (col|row)span=\"(\d+)\">", content):
            tag, kind, num = match.groups()
            num = int(num)
            if kind == "row":
                row_amount[pos] = num - 1
                return html([f"<{tag}>"])
            else:
                col_tag = tag
                col_to_add = num - 1
                pos += num - 1
                return html(pre_string(content) + [f"<{tag}>"])
        
        if re.search(r"<td|th>", content):
            return html(pre_string(content) + [content])


if __name__ == "__main__":
    toJSONFilter(tables)

                
            
