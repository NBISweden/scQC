setopt shwordsplit 

conda activate cellbender

hdir="/Users/asabjor/projects/sc-devop/scQC/data/human/GSE229617"
parserun="parse1"
indir="$hdir/$parserun"

samples="5-Azacytidine Fludarabine XRP44X Control Dexamethasone Imatinib all"
resdir="/Users/asabjor/projects/sc-devop/scQC/data/human/output"
mkdir -p $resdir

for s in $samples; do
    sname="${parserun}_${s}"
    echo $sname
    sdir="$resdir/$sname"
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



