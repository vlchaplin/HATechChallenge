import os
import pandas as pd

new_base = '/home/ubuntu/notebooks/swab_seqs'
base = '/home/ubuntu/all/challenge_4/'
paths = [base+folder+'/' for folder in os.listdir(base) if 'SRS' in folder]

#'../all/challenge_4/SRS016503/SRS016503.denovo_duplicates_marked.trimmed.singleton.fastq'
files = [path+file for path in paths for file in os.listdir(path) if 'singleton' in file]


for file in files:
    swab_seqs = pd.DataFrame()
    print(file)
    df = pd.read_csv(file, header=None, delimiter='\t')  
    for i,row in df.iterrows():
        txt = row[0].strip()
        if txt.startswith('@'):
            swab_seqs = swab_seqs.append(pd.DataFrame({'unique_id':[txt],
                                                       'class':['unknown'],
                                                       'gen_seq':[df.loc[i+1,0]]}))
    swab_seqs.to_csv(new_base + file[file.rfind('/'):file.index('.d')]+'seq.csv', index=False)