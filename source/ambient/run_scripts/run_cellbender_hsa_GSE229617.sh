setopt shwordsplit 

indir="/Users/asabjor/projects/sc-devop/scQC/data/human/GSE229617"
conda activate cellbender


samples="multiseq parse1 parse2 fixed1_5-Azacytidine fixed1_Dexamethasone fixed1_XRP44X fixed2_Control fixed2_Fludarabine fixed2_Imatinib"
resdir="/Users/asabjor/projects/sc-devop/scQC/data/human/output"
mkdir -p $resdir

for s in $samples; do
    echo $s
    sdir="$resdir/$s"
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



