fa="~/genome-cattle/ARS-UCD1.2/GCF_002263795.1_ARS-UCD1.2_genomic.fna"
gtf="~/genome-cattle/ARS-UCD1.2/GCF_002263795.1_ARS-UCD1.2_genomic.gtf"
################################################
#### 
################################################
sawriter="~/software/blasr/alignment/bin/sawritermc"
blasr="~/miniconda3/bin/blasr"
python3="~/miniconda3/bin/python3.9"
###
# 1 Split genome into short kmer sequences
$python3 /home/sll/miniconda3/CNVcaller/bin/0.1.Kmer_Generate.py /home/sll/genome-cattle/ARS-UCD1.2/GCF_002263795.1_ARS-UCD1.2_genomic.fna 1000 kmer.fa
# 2 Align the kmer FASTA (from step 1) to reference genome using blasr.
# 1) creat .sa file use sawriter
$sawriter genomic.fa.sa ~/genome-cattle/ARS-UCD1.2/GCF_002263795.1_ARS-UCD1.2_genomic.fna
# 2) blasr 
$blasr kmer.fa $fa --sa genomic.fa.sa --out kmer.aln -m 5 --noSplitSubreads --minMatch 15 --maxMatch 20 --advanceHalf --advanceExactMatches 10 --fastMaxInterval --fastSDP --aggressiveIntervalCut --bestn 10
# 3 Generate duplicated window record file
$python3 /home/sll/miniconda3/CNVcaller/bin/0.2.Kmer_Link.py kmer.aln 1000 ARS_UCD1.2_1000
################################################
### 
# 1) Create a window file for the genome (you can use it directly later)
CNVReferenceDB="/home/sll/miniconda3/CNVcaller/bin/CNVReferenceDB.pl"
perl $CNVReferenceDB $fa -w 1000

# 2) Calculate the absolute copy number  of each window
IndividualProcess="/home/sll/miniconda3/CNVcaller/Individual.Process.sh"
Winlink="/home/sll/genome-cattle/CNVCaller-Duplink/ARS_UCD1.2_1000_link"
sample_list="sample_list.txt"  #per row per ID
cat $sample_list | while read -r sample;
do
    echo $sample
    bash $IndividualProcess -b `pwd`/${sample}.sorted.addhead.markdup.bam -h $sample -d $Winlink -s none;
done
################################################
CNVDis="/home/sll/miniconda3/CNVcaller/CNV.Discovery.sh"
### 
touch exclude_list
bash $CNVDis -l `pwd`/wagyu_angus_hostein.txt -e `pwd`/exclude_list -f 0.1 -h 3 -r 0.5 -p 03.wagyu_angus_hostein.primaryCNVR -m 03.wagyu_angus_hostein.mergeCNVR
################################################
### 
python /home/sll/miniconda3/CNVcaller/Genotype.py --cnvfile 03.wagyu_angus_hostein.mergeCNVR --outprefix 04.wagyu_angus_hostein.genotypeCNVR --nproc 24
################################################
GetSVtype="~/script/CNVCaller/GetSVtypeForIntersect.py"
# 
python $GetSVtype --vcffile 04.wagyu_angus_hostein.genotypeCNVR.vcf --out 05.wagyu_angus_hostein.genotypeCNVR_getsv.vcf
################################################
#### 
################################################
### 
samtools index input.bam
### 
smoove="~/software/smoove"
sample_list="sample_list.txt"
fa=~/genome-cattle/ARS-UCD1.2/GCF_002263795.1_ARS-UCD1.2_genomic.fna
cat $sample_list | while read -r sample;
do
    echo $sample
    $smoove call --outdir results-smoove/ --name $sample --fasta $fa -p 1 --genotype ${sample}.sorted.addhead.markdup.bam;
done
################################################
### 
$smoove merge --name 02.wagyu_angus_hostein.merged -f $fa --outdir ./ /home/sll/2023-CNV/02_Smoove_result/01.wagyu_results-smoove/*.genotyped.vcf.gz /home/sll/2023-CNV/02_Smoove_result/01.angus_results-smoove/*.genotyped.vcf.gz /home/sll/2023-CNV/02_Smoove_result/01.hostein_results-smoove/*.genotyped.vcf.gz
################################################
###
smoove="/home/sll/software/smoove"
sample_list="/home/sll/20230629-cattle-bam/hn/wagyu.txt"
reference="/home/sll/genome-cattle/ARS-UCD1.2/GCF_002263795.1_ARS-UCD1.2_genomic.fna"
cat $sample_list | while read -r sample;
do
    echo "$sample"
    $smoove genotype -d -x -p 1 --name ${sample}-joint --outdir 03.wagyu_angus_hostein-results-genotped/ --fasta $reference --vcf 02.wagyu_angus_hostein.merged.sites.vcf.gz /home/sll/20230629-cattle-bam/hn/${sample}.sorted.addhead.markdup.bam;
done
################################################
### 
$smoove paste --name 04.wagyu_angus_hostein-cohort /home/sll/2023-CNV/02_Smoove_result/03.wagyu_angus_hostein-results-genotped/*.vcf.gz
################################################
### 
GetSVtype="~/script/smoove/05.GetCnvrFromSmooveResult.py"
python $GetSVtype --vcffile 04.wagyu_angus_hostein-cohort.smoove.square.vcf.gz --outfile 05.wagyu_angus_hostein-smoove_svpos.txt
################################################
###
replacechr="~/script/replace_chr/ReplaceChr.py"
python $replacechr -i 05.wagyu_angus_hostein-smoove_svpos.txt -c ~/script/replace_chr/chr2-NC.txt -o 05.wagyu_angus_hostein-smoove_svpos_30chr.txt
################################################
### 
grep "<DEL>" 05.wagyu_angus_hostein.genotypeCNVR_getsv_30chr.vcf > 06.wagyu_angus_hostein-CNVcaller_30chr_DEL.txt
grep "<DUP>" 05.wagyu_angus_hostein.genotypeCNVR_getsv_30chr.vcf > 06.wagyu_angus_hostein-CNVcaller_30chr_DUP.txt
grep "<DEL>" 05.wagyu_angus_hostein-smoove_svpos_30chr.txt > 06.wagyu_angus_hostein-smoove_30chr_DEL.txt
################################################

bedtools intersect -f 0.30 -F 0.3 -e -a 06.wagyu_angus_hostein-CNVcaller_30chr_DEL.txt -b 06.wagyu_angus_hostein-smoove_30chr_DEL.txt -wa > wagyu_angus_hostein-CNVcaller_smoove-DEL


Deloverlap="~/script/Del-overlap_interval.py"
python $Deloverlap -i wagyu_angus_hostein-CNVcaller_smoove-DEL -o wagyu_angus_hostein-CNVcaller_smoove-nonoverlap_DEL
################################################
### 
cat wagyu_angus_hostein-CNVcaller_smoove-nonoverlap_DEL 06.wagyu_angus_hostein-CNVcaller_30chr_DUP.txt > 07.wagyu_angus_hostein-CNVcaller_smoove_30chr_CNV
### 
awk '{print $1"\t"$2"\t"$3}' 07.wagyu_angus_hostein-CNVcaller_smoove_30chr_CNV > 07.wagyu_angus_hostein-CNVcaller_smoove_30chr_CNV.pos
################################################
mkdir 08.correct_CNV
python $GetCNV --cnvr ./01_CNVcaller_RD_normalized/04.wagyu_angus_hostein_30chr.genotypeCNVR.tsv --clean 07.wagyu_angus_hostein-CNVcaller_smoove_30chr_CNV.pos --out 08.correct_CNV/08.wagyu_angus_hostein-CNVcaller_smoove_30chr_CNV2filter
################################################
CNVfilter="~/script/CNVCaller/New_cnvFilterAfterCNVcaller.py"
python $CNVfilter -f 08.wagyu_angus_hostein-CNVcaller_smoove_30chr_CNV2filter.txt -o 09.wagyu_angus_hostein-CNVcaller_smoove_30chr
################################################
cd RectChr
~/software/RectChr/bin/RectChr -InConfi in.cofi -OutPut OUT

python ~/script/replace_chr/ReplaceChr.py -i 08.wagyu_angus_hostein-CNVcaller_smoove_30chr_CNV2filter.txt -c /home/sll/script/replace_chr/chr2-NC.txt -o 08.wagyu_angus_hostein-CNVcaller_smoove_30chr_CNV2filter.NC.txt

python ~/miniconda3/CNVcaller/CNVcaller_tools/cnvcallertools/main.py annannovar --cnvfile 08.wagyu_angus_hostein-CNVcaller_smoove_30chr_CNV2filter.NC.txt --outprefix anno.genotypeCNVR.vcf --annovar /home/sll/software/annovar/annotate_variation.pl --buildver cattle1.2 --buildpath /home/sll/software/annovar/Bos
#### PCA

vcftools --vcf ~/2023-CNV/01_CNVcaller_RD_normalized/04.wagyu_angus_hostein.genotypeCNVR.vcf --positions dup.NC.pos --recode --out dup

python ~/script/replace_chr/ReplaceChr.py -i dup.recode.vcf -c ~/script/replace_chr/chr2-NC.txt -o dup.recode.30chr.vcf
vcftools --vcf dup.recode.30chr.vcf --plink --out dup
plink --allow-extra-chr --chr-set 30 --file dup --make-bed --out dup

/home/software/gcta_1.92.3beta3/gcta64 --bfile dup --make-grm --autosome-num 29 --out dup.gcta
/home/software/gcta_1.92.3beta3/gcta64 --grm dup.gcta --pca 10 --out dup.gcta.out


## vst
python ~/script/replace_chr/ReplaceChr.py -i 03.wagyu_angus_hostein.mergeCNVR -c ~/script/replace_chr/chr2-NC.txt -o 03.wagyu_angus_hostein-30chr.mergeCNVR


python ~/script/CNVCaller/GetCleanCNV.py --cnvr ~/2023-CNV/01_CNVcaller_RD_normalized/03.wagyu_angus_hostein-30chr.mergeCNVR --clean 09.wagyu_angus_hostein-CNVcaller_smoove_30chr.Get_Region.txt --out 10.wagyu_angus_hostein-CNVcaller_smoove_30chr.CNVR

##
python ~/script/CNVCaller/calVstAfterCNVcaller.py --file 10.wagyu_angus_hostein-CNVcaller_smoove_30chr.CNVR --p1 angus_hostein.txt --p2 wagyu.txt --out wagyu-angus_hostein.vst


python ~/script/replace_chr/ReplaceChr.py -i wagyu-angus_hostein.vst_0.5.txt -c /home/sll/script/replace_chr/chr2-NC.txt -o wagyu-angus_hostein.vst_0.5.NC.txt



