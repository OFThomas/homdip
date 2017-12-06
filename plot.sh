for file in ./tT1L2_1s*.out
do
echo $file 
python coincplot.py << EOF
$file
EOF

echo
#display $file.png &
done 
