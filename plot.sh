rm temp.txt
for file in ./tTL500mv60s*.out
do
echo $file 
python coincplot.py << EOF
$file
EOF

echo
#display $file.png &
done 
