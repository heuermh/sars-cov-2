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
