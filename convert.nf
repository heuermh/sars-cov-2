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

fastaFiles = "s3://sra-pub-sars-cov2/genbank/nucleotide/sequence/*.fasta"
gff3Files = "s3://sra-pub-sars-cov2/genbank/nucleotide/annotation/*.gff3"

fastas = Channel.fromPath(fastaFiles).map { path -> tuple(path.simpleName, path) }
gff3s = Channel.fromPath(gff3Files).map { path -> tuple(path.simpleName, path) }

process transformSequences {
  tag { sample }
  publishDir "results/$sample", mode: 'copy'
  container "quay.io/biocontainers/adam:0.34.0--0"

  input:
  set sample, file (fasta) from fastas

  output:
  set sample, file (fasta), file ("${sample}.sequences.adam") into sequences

  """
  adam-submit \
    $params.sparkOpts \
    -- \
    transformSequences \
    $fasta \
    ${sample}.sequences.adam
  """
}

process transformFeatures {
  tag { sample }
  publishDir "results/$sample", mode: 'copy'
  container "quay.io/biocontainers/adam:0.34.0--0"

  input:
  set sample, file (gff3) from gff3s

  output:
  set sample, file (gff3), file ("${sample}.features.adam") into features

  """
  adam-submit \
    $params.sparkOpts \
    -- \
    transformFeatures \
    $gff3 \
    ${sample}.features.adam
  """
}
