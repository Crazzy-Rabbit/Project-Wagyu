# -*- coding: utf-8 -*-
#! /usr/bin/env python
"""
Created on  07 07 10:52:08  2023
@Author: Lulu Shi
@Mails: crazzy_rabbit@163.com
"""
import click
# 换染色体号的脚本
def load_vcf(vcf, chrlist, out):
    Chrfiles = []
    for line in vcf:
        line = line.strip()
        if line.startswith('#') and not line.startswith('##contig'):
            out.write(line + '\n')
        elif line.startswith('##contig'):
            contig = line.strip().split('=')
            contigchr = contig[2].strip().split(',')
            chrlist.seek(0)
            for chrchange in chrlist:
                chrchange = chrchange.strip().split()
                if contigchr[0] == chrchange[0]:
                    contigchr[0] = chrchange[1]
                    out.write('='.join(contig[:2]) + '=' + ','.join(contigchr) + '=' + contig[3] + '\n')
                elif contigchr[0] == chrchange[1]:
                    contigchr[0] = chrchange[0]
                    out.write('='.join(contig[:2]) + '=' + ','.join(contigchr) + '=' + contig[3] + '\n')
                else:
                    continue
        elif not line.startswith('#'):
            Chrfiles.append(line.split())

    return Chrfiles

@click.command()
@click.option('-i', '--infile', type=click.File('r'), help='input file for change chr', required=True)
@click.option('-c', '--chrlist', type=click.File('r'), help='chrlist to change chr, such NC123 1', required=True)
@click.option('-o', '--out', type=click.File('w'), help='output file', required=True)
def main(infile, chrlist, out):
    """
    changechr for file, chrlist has 2 col NC and number-chr
    
    Automatic recognition of vcf file chromosome form and conversion to another
    """
    Chrfiles = load_vcf(infile, chrlist,  out)
    chrlist.seek(0)
    for chrchange in chrlist:
        chrchange = chrchange.strip().split()
        for Chr in Chrfiles:
            if Chr[0] == chrchange[0]:
                Chr[0] = chrchange[1]
                out.write('\t'.join(Chr) + '\n')
            elif Chr[0] == chrchange[1]:
                Chr[0] = chrchange[0]
                out.write('\t'.join(Chr) + '\n')
            else:
                continue


if __name__ == '__main__':
    main()
