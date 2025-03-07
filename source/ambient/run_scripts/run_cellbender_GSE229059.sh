setopt shwordsplit 

conda activate cellbender

indir="/Users/asabjor/projects/sc-devop/scQC/data/mouse/GSE229059/"

samples="GSM7150714_C57_MA_raw_feature_bc_matrix.h5          GSM7150728_CD4creMYD88_MA_raw_feature_bc_matrix.h5
GSM7150718_C57_PBS_raw_feature_bc_matrix.h5         GSM7150730_CD4creMYD88_PBS_raw_feature_bc_matrix.h5
GSM7150720_Rag1KO_PBS_raw_feature_bc_matrix.h5      GSM7150732_MYD88_MA_raw_feature_bc_matrix.h5
GSM7150721_Rag1KO_MA_raw_feature_bc_matrix.h5       GSM7150735_MYD88_PBS_raw_feature_bc_matrix.h5
GSM7150723_C57_MA_Jan6_raw_feature_bc_matrix.h5     GSM7150737_OTII_MA_raw_feature_bc_matrix.h5
GSM7150726_C57_PBS_Jan6_raw_feature_bc_matrix.h5    GSM7150739_OTII_PBS_raw_feature_bc_matrix.h5"


resdir="/Users/asabjor/projects/sc-devop/scQC/data/mouse/output"
mkdir -p $resdir

tmp="tmp_GSE229059"
mkdir $tmp
cd $tmp

for s in $samples; do
    echo $s
    substr=$(echo $s| cut -d'_' -f 1)
    echo $substr
    sdir="$resdir/$substr"
    mkdir -p $sdir
    cellbender_dir="$sdir/cellbender"
    mkdir -p $cellbender_dir
    echo $cellbender_dir
    outfile="$cellbender_dir/cellbender_out.h5"
    chkfile="$cellbender_dir/ckpt.tar.gz"
    if ! [ -f $outfile ]; then
        if ! [ -f $chkfile ]; then
            cellbender remove-background --cpu-threads  4 --input "$indir/$s" --output $outfile
            cp ckpt.tar.gz $chkfile
        else
            cp $chkfile ckpt.tar.gz
            cellbender remove-background --cpu-threads  4 --input "$indir/$s" --output $outfile
            cp ckpt.tar.gz $chkfile
        fi
    fi
done



