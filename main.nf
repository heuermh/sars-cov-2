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

genbankFiles = "${params.dir}/**.gb.gz"
genbanks = Channel.fromPath(genbankFiles).map { path -> tuple(path.simpleName, path) }

process transformSequences {
  tag { sample }
  publishDir "$sample", mode: 'copy'
  container "quay.io/biocontainers/adam:0.31.0--0"

  input:
  set sample, file (genbank) from genbanks

  output:
  set sample, file (genbank), file ("${sample}.sequences.adam") into sequences

  """
  INPUT=$genbank \
  OUTPUT=${sample}.sequences.adam \
  spark-shell \
    $params.sparkOpts \
    --conf spark.serializer=org.apache.spark.serializer.KryoSerializer \
    --conf spark.kryo.registrator=org.biojava.nbio.adam.BiojavaKryoRegistrator \
    --packages org.bdgenomics.adam:adam-assembly-spark2_2.11:0.31.0,org.biojava:biojava-adam:0.3.0-SNAPSHOT \
    -i $baseDir/scripts/loadGenbankDna.scala
  """
}

process transformFeatures {
  tag { sample }
  publishDir "$sample", mode: 'copy'
  container "quay.io/biocontainers/adam:0.31.0--0"

  input:
  set sample, file (genbank), file (sequences) from sequences

  output:
  set sample, file ("${sample}.features.adam") into features

  """
  GENBANK=$genbank \
  SEQUENCES=$sequences \
  OUTPUT=${sample}.features.adam \
  spark-shell \
    $params.sparkOpts \
    --conf spark.serializer=org.apache.spark.serializer.KryoSerializer \
    --conf spark.kryo.registrator=org.biojava.nbio.adam.BiojavaKryoRegistrator \
    --packages org.bdgenomics.adam:adam-assembly-spark2_2.11:0.31.0,org.biojava:biojava-adam:0.3.0-SNAPSHOT \
    -i $baseDir/scripts/loadGenbankDnaFeatures.scala
  """
}
