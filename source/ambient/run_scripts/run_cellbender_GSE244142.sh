setopt shwordsplit 

conda activate cellbender

indir="/Users/asabjor/projects/sc-devop/scQC/data/mouse/GSE244142"

samples="GSM7807801_SITTA8 GSM7807804_SITTD9 GSM7807807_SITTH4 GSM7807802_SITTA9 GSM7807805_SITTE9 GSM7807808_SITTH9 GSM7807803_SITTB9 GSM7807806_SITTF9"

resdir="/Users/asabjor/projects/sc-devop/scQC/data/mouse/output"
mkdir -p $resdir

tmp="tmp_GSE244142"
mkdir -p $tmp
cd $tmp

for s in $samples; do
    echo $s
    # create folder with symlinks to the files
    tmpfolder="$indir/$s"
    echo $tmpfolder
    mkdir -p $tmpfolder
    ln -s "$indir/${s}_matrix.mtx" "$tmpfolder/matrix.mtx"
    ln -s "$indir/${s}_features.tsv" "$tmpfolder/genes.tsv"
    ln -s "$indir/${s}_barcodes.tsv" "$tmpfolder/barcodes.tsv"


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



