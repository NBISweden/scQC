setopt shwordsplit 

conda activate cellbender

indir="/Users/asabjor/projects/sc-devop/scQC/data/mouse/GSE261852/"

samples="GSE261852_CI82_spl1_raw_feature_bc_matrix.h5 GSE261852_CI82_spl2_raw_feature_bc_matrix.h5"

resdir="/Users/asabjor/projects/sc-devop/scQC/data/mouse/output"
mkdir -p $resdir

tmp="tmp_GSE261852"
mkdir -p $tmp
cd $tmp


for s in $samples; do
    echo $s
    substr=$(echo $s| cut -d'_' -f 3)
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



