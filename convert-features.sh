#!/bin/bash

 # The authors of this file license it to you under the
 # Apache License, Version 2.0 (the "License"); you may not
 # use this file except in compliance with the License.  You
 # may obtain a copy of the License at
 #
 #  http://www.apache.org/licenses/LICENSE-2.0
 #
 # Unless required by applicable law or agreed to in writing,
 # software distributed under the License is distributed on an
 # "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
 # KIND, either express or implied.  See the License for the
 # specific language governing permissions and limitations
 # under the License.

adam-submit \
  --master yarn \
  --driver-memory 18g \
  --executor-memory 18g \
  -- \
  transformFeatures \
  's3://sra-pub-sars-cov2/genbank/nucleotide/annotation/*.gff3' \
  $DEST
