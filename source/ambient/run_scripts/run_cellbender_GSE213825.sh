setopt shwordsplit 

indir="/Users/asabjor/projects/sc-devop/scQC/data/mouse/GSE213825/"

samples="GSM6594872_SAM24349928_raw_feature_bc_matrix.h5 GSM6594880_SAM24353299_raw_feature_bc_matrix.h5
GSM6594873_SAM24349929_raw_feature_bc_matrix.h5 GSM6594881_SAM24353300_raw_feature_bc_matrix.h5
GSM6594874_SAM24352442_raw_feature_bc_matrix.h5 GSM6594882_SAM24374036_raw_feature_bc_matrix.h5
GSM6594875_SAM24352443_raw_feature_bc_matrix.h5 GSM6594883_SAM24374037_raw_feature_bc_matrix.h5
GSM6594876_SAM24352444_raw_feature_bc_matrix.h5 GSM6594884_SAM24374038_raw_feature_bc_matrix.h5
GSM6594877_SAM24352445_raw_feature_bc_matrix.h5 GSM6594885_SAM24374039_raw_feature_bc_matrix.h5
GSM6594878_SAM24353297_raw_feature_bc_matrix.h5 GSM6594886_SAM24374040_raw_feature_bc_matrix.h5
GSM6594879_SAM24353298_raw_feature_bc_matrix.h5 GSM6594887_SAM24374041_raw_feature_bc_matrix.h5"

resdir="/Users/asabjor/projects/sc-devop/scQC/data/mouse/output"
mkdir -p $resdir

tmp="tmp_GSE213825"
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



