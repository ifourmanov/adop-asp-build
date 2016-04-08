FROM centos:centos7.2.1511
MAINTAINER "Ilya Fourmanov" <ilya.fourmanov@gmail.com>

#Pre-requisites
RUN yum install -y wget tar epel-release openldap-clients openssl yum-utils unzip automake libtool
RUN rpm -ivh http://pkgs.repoforge.org/rpmforge-release/rpmforge-release-0.5.3-1.el6.rf.x86_64.rpm && yum --enablerepo=rpmforge-extras install -y git
RUN yum install -y which python-pip
RUN pip install awscli
RUN rpm --import "http://keyserver.ubuntu.com/pks/lookup?op=get&search=0x3FA7E0328081BFF6A14DA29AA6A19B38D3D831EF" && \
    yum-config-manager --add-repo http://download.mono-project.com/repo/centos/ && \
    yum install -y mono-complete ca-certificates-mono
RUN curl -fsSL https://get.docker.com/ | sh
RUN curl -L https://github.com/docker/compose/releases/download/1.6.0/docker-compose-`uname -s`-`uname -m` > /usr/local/bin/docker-compose && \
    chmod +x /usr/local/bin/docker-compose
RUN curl -L https://github.com/docker/machine/releases/download/v0.6.0/docker-machine-`uname -s`-`uname -m` >/usr/local/bin/docker-machine && \
    chmod +x /usr/local/bin/docker-machine

# Install node
RUN curl --silent --location https://rpm.nodesource.com/setup_4.x | bash 
RUN yum install -y nodejs
RUN npm install bower -g &&\
    npm install grunt-cli -g

# Install mono version and libuv for dotnet support
RUN curl -sSL https://raw.githubusercontent.com/aspnet/Home/dev/dnvminstall.sh | DNX_BRANCH=dev sh 
RUN bash -c "source /root/.dnx/dnvm/dnvm.sh && \
        dnvm upgrade -r mono"

RUN wget http://dist.libuv.org/dist/v1.8.0/libuv-v1.8.0.tar.gz && \
    tar -zxf libuv-v1.8.0.tar.gz && \
    cd libuv-v1.8.0 && \
    sh autogen.sh && \
    ./configure && \
     make && \
     make check && \
     make install && \
     ln -s /usr/lib64/libdl.so.2 /usr/lib64/libdl && \
     ln -s /usr/local/lib/libuv.so.1.0.0 /usr/lib64/libuv.so

VOLUME /build
