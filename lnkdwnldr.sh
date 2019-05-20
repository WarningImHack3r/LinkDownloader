BOLD=$(tput bold)
NORMAL=$(tput sgr0)
NC='\033[0m'
RED='\033[0;31m'
ORANGE='\033[0;33m'
YELLOW='\033[1;33m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
LIGHTBLUE='\033[1;34m'

if [ $# -ne 1 ]
then
	echo -e "Veuillez entrer 1 argument."
else
	regex='(https?|ftp|file)://[-A-Za-z0-9\+&@#/%?=~_|!:,.;]*[-A-Za-z0-9\+&@#/%=~_|]'
	lien=$1
	path=/mnt/library/Films
	filmPath="$path"
	if [[ $lien =~ $regex ]]
	then
		clear
		echo -e "${YELLOW}${BOLD}============================================================"
		echo -e "                  ${RED}LINK DOWNLOADER V2.0"
		echo -e "${YELLOW}============================================================${NORMAL}"
		echo -e "${YELLOW}>> Lien reçu : ${BOLD}${lien}${NORMAL}${NC}"
		echo -e "${YELLOW}============================================================${NC}"
		Davail=$(df --output=avail -kh "$path" | tail -n +2)
		Dtotal=$(df --output=size -kh "$path" | tail -n +2)
		Lavail=$(df --output=avail -kh / | tail -n +2)
		Ltotal=$(df --output=size -kh / | tail -n +2)
		echo -e "${YELLOW}Mémoire : ${BOLD}${Lavail//[[:blank:]]/}${NORMAL}${YELLOW} libres sur ${BOLD}${Ltotal//[[:blank:]]/}${NORMAL}"
		echo -e "${YELLOW}Disque dur : ${BOLD}${Davail//[[:blank:]]/}${NORMAL}${YELLOW} libres sur ${BOLD}${Dtotal//[[:blank:]]/}${NORMAL}${NC}"
		echo -e "${YELLOW}============================================================${NC}"
		echo -e -n ">> Entrez le nom pour renommer le fichier : "
		read -r titre
		if [ $titre == *"."* ]
		then
			$titre=${titre%.*}
		fi
		echo -e -n ">> Précisez l'extension de fichier : "
		read -r ext
		$ext=${$ext/"."/""}
		if [ $ext != "mkv" ] && [ $ext != "avi" ] && [ $ext != "mp4" ] && [ $ext != "torrent" ]
		then
			path=~
			nom="${titre}"
		else
			echo -e -n ">> Quelle est la hauteur de trame du film ? "
			read -r qua
			$qua=${qua%p}
			nom="[${qua}p] ${titre}"
		fi
		if [ $ext == "torrent" ]
		then
			transmission-cli $lien -w "$path"/"$nom".$ext -ep -D
		else
			if [ ! -e "$path"/"$nom".$ext ]
			then
				wget -O "$path"/"$nom".$ext $lien
			else
				echo -e "${LIGHTBLUE}${BOLD}==> Reprise du téléchargement${NC}${NORMAL}"
				wget -c -O "$path"/"$nom".$ext $lien
			fi
		fi
		echo -e "${BOLD}${LIGHTBLUE}==> Téléchargement terminé${NC}${NORMAL}"
		if [ $ext = "rar" ] || [ $ext = "zip" ]
		then
			echo -e "${BOLD}${LIGHTBLUE}==> Dézippage du fichier...${NC}${NORMAL}"
			if [ $ext = "rar" ]
			then
				unrar t "$path"/"$nom".$ext
				unrar l "$path"/"$nom".$ext
				unrar e "$path"/"$nom".$ext "$path"/
			else
				if [ $ext = "zip" ]
				then
					unzip -t "$path"/"$nom".$ext
					unzip -l "$path"/"$nom".$ext
					unzip "$path"/"$nom".$ext -d "$path"/
				fi
			fi
			echo -e "${BOLD}${LIGHTBLUE}==> Extraction terminée${NC}${NORMAL}"
			rm "$path"/"$nom".$ext
			ls -l "$path" | grep "$nom.$ext"
			if [ $? -eq 0 ]
			then
				echo -e "${BOLD}${LIGHTBLUE}==> Vous pouvez supprimer "$nom.$ext" manuellement${NC}${NORMAL}"
			else
				echo -e "${BOLD}${LIGHTBLUE}==> "$nom.$ext" a été correctement extrait puis supprimé${NC}${NORMAL}"
			fi
			ls -l "$path" | grep ".mkv"
			if [ $? -eq 0 ]
			then
				ext="mkv"
				echo -e -n ">> Quelle est la hauteur de trame du film ? "
				read -r qua
				$qua=${qua%p}
				nom="[${qua}p] ${titre}"
				mv "$path"/*.$ext "$filmPath"/"$nom".$ext
				echo -e "${BOLD}${LIGHTBLUE}==> Le film .$ext extrait a bien été déplacé dans le dossier Films${NC}${NORMAL}"
			fi
			ls -l "$path" | grep ".avi"
			if [ $? -eq 0 ]
			then
				ext="avi"
				echo -e -n ">> Quelle est la hauteur de trame du film ? "
				read -r qua
				$qua=${qua%p}
				nom="[${qua}p] ${titre}"
				mv "$path"/*.$ext "$filmPath"/"$nom".$ext
				echo -e "${BOLD}${LIGHTBLUE}==> Le film .$ext extrait a bien été déplacé dans le dossier Films${NC}${NORMAL}"
			fi
			ls -l "$path" | grep ".mp4"
			if [ $? -eq 0 ]
			then
				ext="mp4"
				echo -e -n ">> Quelle est la hauteur de trame du film ? "
				read -r qua
				$qua=${qua%p}
				nom="[${qua}p] ${titre}"
				mv "$path"/*.$ext "$filmPath"/"$nom".$ext
				echo -e "${BOLD}${LIGHTBLUE}==> Le film .$ext extrait a bien été déplacé dans le dossier Films${NC}${NORMAL}"
			fi
		fi
		echo -e "${BOLD}${LIGHTBLUE}==> Fichier téléchargé dans \"${path}\" :${NC}${NORMAL}"
		ls "$path" | grep "$titre.$ext"
		if [ "$path" != ~ ]
		then
			echo -e "${BOLD}${LIGHTBLUE}==> Le fichier apparaîtra dans Plex dans quelques secondes${NC}${NORMAL}"
		fi
	else
    	    echo -e "Veuillez entrer un lien en argument"
    fi
fi
