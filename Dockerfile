# Copyright (c) 2018 SAP SE or an SAP affiliate company. All rights reserved. This file is licensed under the Apache Software License, v. 2 except as noted otherwise in the LICENSE file
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

FROM alpine:3.17.2
MAINTAINER Gardener Project

RUN apk add --update nodejs npm sed curl pwgen runit && \
    mkdir -p /usr/src/ingress-default-backend
WORKDIR /usr/src/ingress-default-backend

COPY . /usr/src/ingress-default-backend
RUN npm install

# Nobody user. For K8S is better to use numeric values.
USER 65534:65534
EXPOSE 8080
CMD ["npm", "start"]
