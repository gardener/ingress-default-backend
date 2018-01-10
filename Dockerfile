# Copyright 2018 The Gardener Authors.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

FROM alpine:3.6
MAINTAINER Gardener Project

RUN echo "@community http://dl-4.alpinelinux.org/alpine/edge/community" >> /etc/apk/repositories && \
    apk add --update nodejs nodejs-npm sed curl pwgen runit@community && \
    mkdir -p /usr/src/ingress-default-backend
WORKDIR /usr/src/ingress-default-backend

COPY . /usr/src/ingress-default-backend
RUN npm install

EXPOSE 8080
CMD ["npm", "start"]