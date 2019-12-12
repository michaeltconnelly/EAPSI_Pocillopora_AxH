for file in ${1}/outputs/phylotrans_Pdam/*
do
gunzip $file
sed -i '' 's/SczhEnG_//g' ${1}/outputs/phylotrans_Pdam/*
