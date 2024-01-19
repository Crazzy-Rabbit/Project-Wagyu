# -*- coding: utf-8 -*-
#! /usr/bin/env python
"""
Created on  05 19 10:00:31  2023
@Author: Lulu Shi
@Mails: crazzy_rabbit@163.com
"""

import click
import pandas as pd

def load_data(file):
    df = pd.read_csv(file, usecols=['chr', 'start', 'end',
                                              'silhouette_score','average', 'sd',
                                              'dd', 'Ad', 'AA', 'AB', 'BB', 'BC', 'M'],
                sep='\t',
                dtype={'chr': str, 'start': int, 'end': int,
                       'silhouette_score': float, 'average': float, 'sd': float,
                       'dd': int, 'Ad': int, 'AA': int,
                       'AB': int, 'BB': int, 'BC': int, 'M': int
                })
    return df

def cal_freq(df):
    dup_freq = (df['AB'] + 2*df['BB'] + 2*df['BC'] + 2*df['M'])/(2*(df['dd'] + df['Ad'] + df['AA'] + df['AB'] + df['BB'] + df['BC'] + df['M']))
    del_freq = (2*df['dd'] + df['Ad'])/(2*(df['dd'] + df['Ad'] + df['AA'] + df['AB'] + df['BB'] + df['BC'] + df['M']))
    df['dup_freq'], df['del_freq']  = dup_freq, del_freq
    df['lenth'] = df['end'] - df['start']

    return df

def Del_filter(df, out):
    Del = df.query('silhouette_score > 0.25 and 0.05 < del_freq < 0.95 and dup_freq <= 0.01 and lenth <= 50000')
    Del.loc[:, 'Type'] = 'Del'
    if not Del.empty:
        Del.to_csv(f'{out}.Del_genotypeCNVR.txt',
                   sep='\t', index=False)
    else:
        print("No rows meet the criteria.")

    return Del

def Dup_filter(df, out):
    Dup = df.query('silhouette_score > 0.25 and 0.05 < dup_freq < 0.95 and del_freq <= 0.01 and lenth <= 500000')
    Dup.loc[:, 'Type'] = 'Dup'
    if not Dup.empty:
        Dup.to_csv(f'{out}.Dup_genotypeCNVR.txt',
                   sep='\t', index=False)
    else:
        print("No rows meet the criteria.")

    return Dup

def Both_filter(df, out):
    Both = df.query('silhouette_score < 0.75 and 0.05 < dup_freq < 0.95 and 0.05 < del_freq < 0.95 and lenth <= 50000')
    Both.loc[:, 'Type'] = 'Both'
    if not Both.empty:
        Both.to_csv(f'{out}.Both_genotypeCNVR.txt',
                    sep='\t', index=False)
    else:
        print("No rows meet the criteria.")

    return Both

@click.command()
@click.option('-f','--file', type=str, help='CNVcaller结果文件中的genotypeCNVR.tsv文件', required=True)
@click.option('-o','--out', type=str, help='输出文件前缀', required=True)
def main(file, out):
    """
    对CNVcaller结果进行过滤，条件为：
    1、所有类型： 轮廓系数（silhouette_score） > 0.6
    2、缺失型：0.05<del<0.95且dup<=0.01 且 lenth <= 50000
    3、重复型： 0.05<dup<0.95且del<=0.01 且lenth <= 500000
    4、Both型： 0.05<dup<0.95 且 0.05<del<0.95 且 lenth < =50000
    """
    df = load_data(file)
    df_freq = cal_freq(df)
    
    Del = Del_filter(df_freq, out)
    Dup = Dup_filter(df_freq, out)
    Both = Both_filter(df_freq, out)

    rectchr = pd.concat([Del, Dup, Both], axis=0)
    rectchr[['chr', 'start', 'end',
             'lenth', 'Type']].to_csv(f'{out}.chat.rectchr',
                                      sep='\t', index=False)

    rectchr[['chr', 'start', 'end']].to_csv(f'{out}.Get_Region.txt',
                                            sep='\t', index=False)

if __name__ == '__main__':
    main()
