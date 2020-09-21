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

params.dir = "${baseDir}"
params.acc = "${params.dir}/sars-cov-2.acc"
params.efetchBatchSize = 200

accessions = Channel
  .fromPath(params.acc)
  .splitText(by: params.efetchBatchSize)
  .map { it.split("\n") }
  .map { [ it[0], it[it.length - 1], it.join(",") ] }

process efetch {
  container "quay.io/biocontainers/entrez-direct:13.8--pl526h375a9b1_0"

  input:
  val acc from accessions

  output:
  file "${acc.get(0)}-${acc.get(1)}.gb" into sequences

  """
  sleep 1
  efetch -db nucleotide -format gb -mode text -id ${acc.get(2)} > ${acc.get(0)}-${acc.get(1)}.gb
  """
}
