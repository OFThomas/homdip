for file in *.out
do python coincplot.py << EOF
$file
EOF

display $file.png &
done
