#!/usr/bin/env nextflow

/*
 * The authors of this file license it to you under the
 * Apache License, Version 2.0 (the "License"); you may not
 * use this file except in compliance with the License.  You
 * may obtain a copy of the License at
 *
 *  http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing,
 * software distributed under the License is distributed on an
 * "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
 * KIND, either express or implied.  See the License for the
 * specific language governing permissions and limitations
 * under the License.
 */

params.resultsDir = "${baseDir}/results"

samples = Channel.fromPath("${params.resultsDir}").map{ p -> tuple('sars-cov-2', p) }
(sequences,features) = samples.into(2)

process unionSequences {
  publishDir "$results", mode: 'copy'
  container 'quay.io/biocontainers/adam:0.33.0--0'

  input:
  set sample, path(results) from sequences

  """
  adam-submit \
    ${params.sparkOpts} \
    -- \
    transformSequences \
    \"${results}/**/*.sequences.adam/*\" \
    ${results}/${sample}.sequences.adam
  """
}

process unionFeatures {
  publishDir "$results", mode: 'copy'
  container 'quay.io/biocontainers/adam:0.33.0--0'

  input:
  set sample, path(results) from features

  """
  adam-submit \
    ${params.sparkOpts} \
    -- \
    transformFeatures \
    \"${results}/**/*.features.adam/*\" \
    ${results}/${sample}.features.adam
  """
}
