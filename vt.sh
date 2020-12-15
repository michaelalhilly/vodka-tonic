#!/bin/bash

# Exits if no arguments are passed.

if [ "$1" = "" ]; then

	echo "Specify a command.";
	exit 0
fi

# Displays commands.

if [[ "$1" = "--help" || "$1" = "-h" ]]; then

	printf "\n\n"
	printf "Vodka Tonic Commands";
	printf "\n\n\n"

	printf "vt build";
	printf "\n\n"
	printf "Builds project image.";
	printf "\n\n\n"

	printf "vt cli";
	printf "\n\n"
	printf "Starts project container command line.";
	printf "\n\n\n"

	printf "vt containers";
	printf "\n\n"
	printf "List Docker containers.";
	printf "\n\n\n"

	printf "vt exec";
	printf "\n\n"
	printf "Executes command on project container.";
	printf "\n\n\n"

	printf "vt images";
	printf "\n\n"
	printf "List Docker images.";
	printf "\n\n\n"

	printf "vt rebuild";
	printf "\n\n"
	printf "Removes and rebuilds project image.";
	printf "\n\n\n"

	printf "vt restart";
	printf "\n\n"
	printf "Stops and restarts project container.";
	printf "\n\n\n"

	printf "vt rm";
	printf "\n\n"
	printf "Removes project container.";
	printf "\n\n\n"

	printf "vt rmi";
	printf "\n\n"
	printf "Removes project image.";
	printf "\n\n\n"

	printf "vt run";
	printf "\n\n"
	printf "Runs project container.";
	printf "\n\n\n"

	printf "vt start";
	printf "\n\n"
	printf "Restarts project container.";
	printf "\n\n\n"

	printf "vt stop";
	printf "\n\n"
	printf "Stops project container.";
	printf "\n\n\n"

	printf "vt <npm script>"
	printf "\n\n"
	printf "Runs npm script defined in project's package.json."
	printf "\n\n\n"
	exit 0
fi

# Displays version.

if [[ "$1" = "--version" || "$1" = "-v" ]]; then

	echo "1.0.0"
	exit 0
fi

# Extracts project info if package.json exists.

HAS_PACK=FALSE
NAME=""
OPTIONS=""

if [[ $(find . -maxdepth 1 -name 'package.json') != "" ]]; then

	HAS_PACK=TRUE

	# Extracts project name.

	NAME=$(grep -Eo '"name": ".*",' package.json | awk '{print $2}' | sed 's/"//g' | sed 's/,//g');

	# Extract project options.

	OPTIONS=$(grep -Eo '"vt": ".*"' package.json | awk '{for (i=2; i<NF; i++) printf $i " "; print $NF}' | sed 's/"//g' | sed 's/,//g');
fi

# Exits if project name is missing from package.json.

if [[ $HAS_PACK = TRUE && $NAME = "" ]]; then

	echo "Add your project name to package.json."
	exit 10
fi

# Uses specified container name if one is passed.

if [ "$#" -gt 1 ]; then

	NAME="$2"
fi

# Shortcuts

if [ "$1" = "build" ]; then

	docker build -t $NAME .
	exit 0
fi

if [[ "$1" = "run" && "$#" = 1 ]]; then

	eval docker run -itd $OPTIONS --name $NAME $NAME
	exit 0
fi

if [[ "$1" = "run" && "$#" -gt 1 ]]; then
	
	eval docker run -itd "${@:3}" --name $NAME $NAME
	exit 0
fi

if [ "$1" = "start" ]; then

	docker restart $NAME
	exit 0
fi

if [ "$1" = "stop" ]; then

	docker stop $NAME
	exit 0
fi

if [ "$1" = "exec" ]; then

	docker exec $NAME "${@:2}"
	exit 0
fi

if [ "$1" = "cli" ]; then

	docker exec -it $NAME /bin/bash
	exit 0
fi

if [ "$1" = "rm" ]; then

	if [ "$2" = "all" ]; then

		docker stop $(docker ps -aq)
		docker rm $(docker ps -aq)
		exit 0

	fi

	docker stop $NAME
	docker rm $NAME
	exit 0
fi

if [ "$1" = "rmi" ]; then

	if [ "$2" = "none" ]; then

		docker rmi $(docker images -f "dangling=true" -q)
		exit 0
	fi

	docker rmi $NAME
	exit 0
fi

if [ "$1" = "restart" ]; then

	docker stop $NAME
	docker restart $NAME
	exit 0
fi

if [ "$1" = "rebuild" ]; then

	docker rmi $NAME
	docker build -t $NAME .
	exit 0
fi

if [ "$1" = "containers" ]; then

	docker ps -a
	exit 0
fi

if [ "$1" = "images" ]; then

	docker images
	exit 0
fi

# Executes NPM script since first argument did not match
# a VT command..

npm run $@
exit 0