# Amazon Linux をベースイメージに設定
FROM amazonlinux:latest

# 必要なツールのインストール
RUN yum update -y
RUN yum install -y shadow-utils bash sudo git zip \
                  python python3-pip

# aws-cli のインストール
RUN curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
RUN unzip awscliv2.zip
RUN ./aws/install

# 特権ユーザーのパスワード設定
RUN echo "root:yourpassword" | chpasswd

# 非特権ユーザーを作成
ARG USERNAME=myuser
ARG USER_UID=1000
ARG USER_GID=1000
RUN groupadd -g $USER_GID $USERNAME \
  && useradd -m -u $USER_UID -g $USER_GID -s /bin/bash $USERNAME

# 永続化のための設定
VOLUME /home/$USERNAME
RUN chown -R $USER_UID:$USER_GID /home/$USERNAME

# デフォルトのユーザーを非特権ユーザーに変更
USER $USERNAME
WORKDIR /home/$USERNAME

CMD ["/bin/bash"]
