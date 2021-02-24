# sars-cov-2
SARS-CoV-2 (Severe acute respiratory syndrome coronavirus 2) sequences and features

### Hacking sars-cov-2

Install

 * Nextflow, https://nextflow.io
 * Docker, https://www.docker.com


### Running sars-cov-2

Download full Genbank records from NCBI given a list of accession numbers
```bash
$ nextflow run prepare.nf
```

Convert full Genbank records to `Sequence`s and `Feature`s in Apache Parquet format
```bash
$ nextflow run main.nf
```

Union all `Sequence` and `Feature` records into single data sets
```bash
$ nextflow run union.nf
```


### Running with Docker containers

Use the `docker` profile to run with Docker containers, e.g.
```bash
$ nextflow run prepare.nf -profile docker
```


### Apache Spark configuration

Configuration for Apache Spark can be provided via `--sparkOpts`
```bash
$ nextflow run main.nf --sparkOpts="--master local[*] --driver-memory 16g"
```

or by defining a profile in [`nextflow.config`](https://github.com/heuermh/sars-cov-2/blob/master/nextflow.config), e.g.
```bash
$ nextflow run main.nf -profile yarn
```


### Interactive analysis with Spark SQL


Sequences and features can be loaded into `adam-shell` for interactive analysis via Spark SQL.

Join the two data frames on `sequences.name` to `features.referenceName`.

```
$ adam-shell

...

scala> import org.bdgenomics.adam.rdd.ADAMContext._
import org.bdgenomics.adam.rdd.ADAMContext._

scala> val sequences = sc.loadParquetSequences("results/sars-cov-2.sequences.adam")

scala> val features = sc.loadParquetFeatures("results/sars-cov-2.features.adam")

scala> features.toDF().createOrReplaceTempView("features")

scala> sequences.toDF().createOrReplaceTempView("sequences")

scala> spark.sql("select referenceName, start, end, strand, name from features").show()
+-------------+-----+-----+-------+-----------+
|referenceName|start|  end| strand|       name|
+-------------+-----+-----+-------+-----------+
|     MW309449|    0|29806|FORWARD|     source|
|     MW309449|  227|21508|FORWARD|        CDS|
|     MW309449|  227|21508|FORWARD|       gene|
|     MW309449|  227|13436|FORWARD|        CDS|
|     MW309449|  227|  758|FORWARD|mat_peptide|
|     MW309449|  227|  758|FORWARD|mat_peptide|
|     MW309449|  758| 2672|FORWARD|mat_peptide|
|     MW309449|  758| 2672|FORWARD|mat_peptide|
|     MW309449| 2672| 8507|FORWARD|mat_peptide|
|     MW309449| 2672| 8507|FORWARD|mat_peptide|
|     MW309449| 8507|10007|FORWARD|mat_peptide|
|     MW309449| 8507|10007|FORWARD|mat_peptide|
|     MW309449|10007|10925|FORWARD|mat_peptide|
|     MW309449|10007|10925|FORWARD|mat_peptide|
|     MW309449|10925|11795|FORWARD|mat_peptide|
|     MW309449|10925|11795|FORWARD|mat_peptide|
|     MW309449|11795|12044|FORWARD|mat_peptide|
|     MW309449|11795|12044|FORWARD|mat_peptide|
|     MW309449|12044|12638|FORWARD|mat_peptide|
|     MW309449|12044|12638|FORWARD|mat_peptide|
+-------------+-----+-----+-------+-----------+
only showing top 20 rows

scala> spark.sql("select name, length, description, sequence from sequences").show()
+--------+------+--------------------+--------------------+
|    name|length|         description|            sequence|
+--------+------+--------------------+--------------------+
|MT419817| 29570|Severe acute resp...|ATGCTTAGTGCACTCAC...|
|MT419818| 29743|Severe acute resp...|ATGCTTAGTGCACTCAC...|
|MT419819| 29743|Severe acute resp...|ATGCTTAGTGCACTCAC...|
|MT419820| 29706|Severe acute resp...|ATGCTTAGTGCACTCAC...|
|MT419821| 29743|Severe acute resp...|ATGCTTAGTGCACTCAC...|
|MT419822| 29743|Severe acute resp...|ATGCTTAGTGCACTCAC...|
|MT419827| 29675|Severe acute resp...|CTAATTACTGTCGTTGA...|
|MT419828| 29462|Severe acute resp...|GGCTTTGGAGACTCCGT...|
|MT419829| 29823|Severe acute resp...|ATTAAAGGTTTATACCT...|
|MT419830| 29851|Severe acute resp...|ATTAAAGGTTTATACCT...|
|MT419831| 29834|Severe acute resp...|ATTAAAGGTTTATACCT...|
|MT419832| 29868|Severe acute resp...|CCAACTTTCGATCTCTT...|
|MT419833| 29835|Severe acute resp...|ATTAAAGGTTTATACCT...|
|MT419834| 29704|Severe acute resp...|CTAATTACTGTCGTTGA...|
|MT419835| 29818|Severe acute resp...|GTTAAAGGTTTATACCT...|
|MT419836| 29648|Severe acute resp...|TAATTAATAACTAATTA...|
|MT419837| 29885|Severe acute resp...|ATTAAAGGTTTATACCT...|
|MT419838| 29731|Severe acute resp...|TGCTTAGTGCACTCACG...|
|MT419839| 29851|Severe acute resp...|ATTAAAGGTTTATACCT...|
|MT419840| 29004|Severe acute resp...|CTCGTACGTGGCTTTGG...|
+--------+------+--------------------+--------------------+
only showing top 20 rows

scala> spark.sql("select s.name, s.length, f.name, f.start, f.end, f.strand from sequences s, features f where s.name == f.referenceName").show()
+--------+------+------------+-----+-----+-------+
|    name|length|        name|start|  end| strand|
+--------+------+------------+-----+-----+-------+
|LR814215| 29903|      source|    0|29903|FORWARD|
|LR814215| 29903|assembly_gap|    0|   54|FORWARD|
|LR814215| 29903|assembly_gap|22324|22342|FORWARD|
|LR814215| 29903|assembly_gap|22527|22542|FORWARD|
|LR814215| 29903|assembly_gap|29836|29903|FORWARD|
|LR821850| 29903|      source|    0|29903|FORWARD|
|LR821850| 29903|assembly_gap|    0|   54|FORWARD|
|LR821850| 29903|assembly_gap|29836|29903|FORWARD|
|LR821942| 29878|      source|    0|29878|FORWARD|
|LR821942| 29878|assembly_gap|    0|   13|FORWARD|
|LR821942| 29878|assembly_gap|29811|29845|FORWARD|
|LR824074| 29903|      source|    0|29903|FORWARD|
|LR824074| 29903|assembly_gap|    0|   30|FORWARD|
|LR824074| 29903|assembly_gap|29866|29903|FORWARD|
|LR824130| 29903|      source|    0|29903|FORWARD|
|LR824130| 29903|assembly_gap|    0|   30|FORWARD|
|LR824130| 29903|assembly_gap|29866|29903|FORWARD|
|LR824224| 29903|      source|    0|29903|FORWARD|
|LR824224| 29903|assembly_gap|    0|   30|FORWARD|
|LR824224| 29903|assembly_gap|22346|22516|FORWARD|
+--------+------+------------+-----+-----+-------+
only showing top 20 rows
```
