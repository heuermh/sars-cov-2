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

import org.slf4j.LoggerFactory
val logger = LoggerFactory.getLogger("loadGenbankDnaFeatures")

import org.apache.log4j.{ Level, Logger }
Logger.getLogger("loadGenbankDnaFeatures").setLevel(Level.INFO)
Logger.getLogger("org.biojava").setLevel(Level.INFO)

import org.biojava.nbio.adam.BiojavaAdamContext
val bac = BiojavaAdamContext(sc)

val genbankPath = Option(System.getenv("GENBANK"))
val sequencesPath = Option(System.getenv("SEQUENCES"))
val outputPath = Option(System.getenv("OUTPUT"))

if (!genbankPath.isDefined || !sequencesPath.isDefined || !outputPath.isDefined) {
  logger.error("GENBANK, SEQUENCES, and OUTPUT environment variables are required")
  System.exit(1)
}

import org.bdgenomics.adam.rdd.ADAMContext._
val sequences = sc.loadParquetSequences(sequencesPath.get)
val features = bac.loadGenbankDnaFeatures(genbankPath.get).replaceSequences(sequences.sequences)

logger.info("Saving DNA sequence features to output path %s ...".format(outputPath.get))
features.save(outputPath.get, asSingleFile = true, disableFastConcat = false)

logger.info("Done")
System.exit(0)
