FROM fedora


#===========================Systems Configuration=============================#

# installing tools
RUN dnf install -y gcc gcc-c++ make cmake automake clang rust golang bat lsd \
                neofetch git subversion fish ksh java-11-openjdk-devel \
                java-17-openjdk-devel java-jd-decompiler openssh python3 python\
                python3-pip python-pip perl util-linux neovim openssh-server wget\
                net-tools

#set up the users with sudoers and remote access
RUN useradd -ms /usr/bin/fish camoore
RUN echo "camoore ALL=(root) NOPASSWD:ALL" >> /etc/sudoers
RUN echo "Port 3000" >> /etc/ssh/sshd_config
RUN echo "camoore_base" > /etc/hostname
RUN ssh-keygen -f /etc/ssh/ssh_host_rsa_key -N '' -t rsa
RUN ssh-keygen -f /etc/ssh/ssh_host_ecdsa_key -N '' -t ecdsa -b 521
RUN ssh-keygen -f /etc/ssh/ssh_host_ed25519_key -N '' -t ed25519

EXPOSE 3000

#set up the system configuration files
COPY etc /etc

#============================User Configuration===============================#
USER camoore

# Set up the users configuration files
ADD --chown=camoore:camoore home /home

# Configure working dir
RUN mkdir -p /home/camoore/workspace

WORKDIR /home/camoore/workspace

RUN cd && wget https://raw.githubusercontent.com/DOCGroup/ACE_TAO/master/.clang-format
RUN cd && wget https://raw.githubusercontent.com/llvm-mirror/clang/master/tools/clang-format/clang-format-diff.py
# set up fish plugins
RUN fish -c "curl https://raw.githubusercontent.com/oh-my-fish/oh-my-fish/master/bin/install > install"
RUN fish install --noninteractive
RUN rm install
RUN fish -c "omf install bass"
RUN fish -c "omf install agnoster"
RUN fish -c "omf theme agnoster"
ENV theme_svn_prompt_enabled yes

# set up the aliases and functions you want to use
RUN fish -c "alias --save l=lsd"
RUN fish -c "alias --save p=bat"
RUN fish -c "alias --save vim=nvim"
RUN fish -c "alias --save fish_greeting=neofetch"
RUN fish -c "function svn_format; svn diff --diff-cmd=diff -x-U0 | python3 ~/clang-format-diff.py -i; end; funcsave svn_format"
RUN fish -c "function git_format; git diff -U0 --no-color HEAD^ | python3 ~/clang-format-diff.py -p1 -i; end; funcsave git_format"

ENTRYPOINT [ "sudo", "/usr/sbin/sshd", "-D", "-e" ]