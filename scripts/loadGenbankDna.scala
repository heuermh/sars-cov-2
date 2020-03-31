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
val logger = LoggerFactory.getLogger("loadGenbankDna")

import org.apache.log4j.{ Level, Logger }
Logger.getLogger("loadGenbankDna").setLevel(Level.INFO)
Logger.getLogger("org.biojava").setLevel(Level.INFO)

import org.biojava.nbio.adam.BiojavaAdamContext
val bac = BiojavaAdamContext(sc)

val inputPath = Option(System.getenv("INPUT"))
val outputPath = Option(System.getenv("OUTPUT"))

if (!inputPath.isDefined || !outputPath.isDefined) {
  logger.error("INPUT and OUTPUT environment variables are required")
  System.exit(1)
}

val sequences = bac.loadGenbankDna(inputPath.get)

logger.info("Saving DNA sequences to output path %s ...".format(outputPath.get))
sequences.save(outputPath.get, asSingleFile = true, disableFastConcat = false)

logger.info("Done")
System.exit(0)
