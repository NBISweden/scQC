setopt shwordsplit 

indir="/Users/asabjor/projects/sc-devop/scQC/data/mouse/GSE218853/"

samples="GSM6757771_rep1_raw_feature_bc_matrix.h5 GSM6757773_rep3_raw_feature_bc_matrix.h5 GSM6757775_nuc3_raw_feature_bc_matrix.h5
GSM6757772_rep2_raw_feature_bc_matrix.h5 GSM6757774_nuc2_raw_feature_bc_matrix.h5"

resdir="/Users/asabjor/projects/sc-devop/scQC/data/mouse/output"
mkdir -p $resdir

tmp="tmp_GSE218853"
mkdir -p $tmp
cd $tmp

for s in $samples; do
    echo $s
    substr=$(echo $s| cut -d'_' -f 2)
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



