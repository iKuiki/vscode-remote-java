#-----------------------------------------------------------------------------------------
# Copyright (c) Microsoft Corporation. All rights reserved.
# Licensed under the MIT License. See LICENSE in the project root for license information.
#-----------------------------------------------------------------------------------------

FROM maven:3.6-jdk-8

# Configure apt
ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get update \
    && apt-get -y install --no-install-recommends apt-utils 2>&1 \
    #
    # Install git, process tools, lsb-release (common in install instructions for CLIs), zsh, less, locales, git-flow vim
    && apt-get -y install git procps lsb-release zsh less locales git-flow vim \
    #
    # Allow for a consistant java home location for settings - image is changing over time
    && if [ ! -d "/docker-java-home" ]; then ln -s "${JAVA_HOME}" /docker-java-home; fi \
    #
    # Clean up
    && apt-get autoremove -y \
    && apt-get clean -y \
    && rm -rf /var/lib/apt/lists/* \
    # Add zh_CN locale support
    && echo 'zh_CN.UTF-8 UTF-8' >> /etc/locale.gen \
    && locale-gen

# Install Oh-My-Zsh
RUN sh -c "$(curl -fsSL https://raw.github.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"

# Replace aliyun maven mirror
RUN sed -Ee "s/(<mirrors>)/\1\n    <mirror>\n      <id>alimaven<\/id>\n      <mirrorOf>central<\/mirrorOf>\n      <name>aliyun maven<\/name>\n      <url>http:\/\/maven.aliyun.com\/nexus\/content\/groups\/public\/<\/url>\n    <\/mirror>/" -i /usr/share/maven/conf/settings.xml

ENV DEBIAN_FRONTEND=dialog

# Set time zone
ENV TZ=Asia/Shanghai

# Allow for a consistant java home location for settings - image is changing over time
RUN if [ ! -d "/docker-java-home" ]; then ln -s "${JAVA_HOME}" /docker-java-home; fi

# Set the default shell to zsh rather than sh
ENV SHELL /bin/zsh
