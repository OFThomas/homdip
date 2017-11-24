rm temp.txt
for file in tfibreCov*.out
do
echo $file 
python coincplot.py << EOF
$file
EOF

#display $file.png &
done 
