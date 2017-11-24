rm temp.txt
for file in tfibreCov*.out
do
echo $file 
python coincplot.py << EOF
$file
EOF
<<<<<<< HEAD

#display $file.png &
done
=======
 
#display $file.png &
done 
>>>>>>> c463c709825b4a819e47759f1f0927582770d725
