#!/bin/sh

export GEA_HOME=/lustre7/singularity/images/gene_expression_analysis

module load singularity/3.5.2

while read SRS cell SRR ; do
        ../sratoolkit.2.11.0-ubuntu64/bin/fastq-dump --split-files $SRR
        fq1="${SRR}_1.fastq"
        fq2="${SRR}_2.fastq"
        echo $fq1
        echo $fq2
        if [ -f $fq1 ]; then
                singularity exec \
                -B ${GEA_HOME}/refs:${GEA_HOME}/refs \
                ${GEA_HOME}/gene_expression_analysis.sif \
                GeneExpressionAnalysisSingle.sh \
                $SRR \
                hg38 \
                $fq1 \
                $fq2
        else
                echo "Not downloaded ${SRR}"
        fi
done < test_list.txt
