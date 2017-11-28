for file in ./t300s*.out
do
echo $file 
python coincplot.py << EOF
$file
EOF

echo
#display $file.png &
done 
