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

samples = Channel.of('sars-cov-2')
(sequences,features) = samples.into(2)

process unionSequences {
  publishDir "${params.resultsDir}", mode: 'copy'
  container 'quay.io/biocontainers/adam:0.32.0--0'

  input:
  val sample from sequences

  """
  adam-submit \
    ${params.sparkOpts} \
    -- \
    transformSequences \
    \"${params.resultsDir}/**.sequences.adam/*\" \
    ${params.resultsDir}/${sample}.sequences.adam
  """
}

process unionFeatures {
  publishDir "${params.resultsDir}", mode: 'copy'
  container 'quay.io/biocontainers/adam:0.32.0--0'

  input:
  val sample from features

  """
  adam-submit \
    ${params.sparkOpts} \
    -- \
    transformFeatures \
    \"${params.resultsDir}/**.features.adam/*\" \
    ${params.resultsDir}/${sample}.features.adam
  """
}
