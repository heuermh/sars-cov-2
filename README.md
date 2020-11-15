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
