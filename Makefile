all: run
	@echo === Finished Running Dockerfile ===

run: build
	@echo == Running Dockerfile ==
	docker run -p 1522:22 -it camoore_base /usr/bin/fish

build: init
	@echo == Building Dockerfile ==
	docker build -t camoore_base .
	if [ -d "etc" ]; then sudo rm -rf etc; fi
	if [ -d "home" ]; then sudo rm -rf home; fi

init:
	@echo == Initing Enviroment ==
	if [ -d "etc" ]; then sudo rm -rf etc; fi
	mkdir -p etc
	if [ -d "home" ]; then sudo rm -rf home; fi
	mkdir -p home/camoore
	sudo cp -r /etc/subversion etc/subversion
	cp -r ~/.ssh home/camoore/.ssh
	cp -r ~/.gitconfig home/camoore/.gitconfig
	cp -r ~/.gnupg home/camoore/.gnupg	
	cp -r ~/.subversion home/camoore/.subversion

clean:
	@echo == Cleaning Dockerfile ==
	docker image prune
	if [ -d "home" ]; then sudo rm -rf home; fi
	if [ -d "etc" ]; then sudo rm -rf etc; fi