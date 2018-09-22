
head=`grep -nH 'LEXICON Root' apertium-uzb.uzb.lexc  | cut -f2 -d':'`

for tag in `cat apertium-uzb.uzb.lexc | grep -o '%<[^>]\+%>' | sort -u`;  do
	found=`head -n $head apertium-uzb.uzb.lexc | grep "$tag" | wc -l`
	if [[ $found -eq 0 ]]; then
		echo "$tag                         !";
	fi
done

for tag in `cat apertium-uzb.uzb.lexc | grep -o '%{[^}]\+%}' | sort -u`;  do
	found=`head -n $head apertium-uzb.uzb.lexc | grep "$tag" | wc -l`
	if [[ $found -eq 0 ]]; then
		echo "$tag                         !";
	fi
done
