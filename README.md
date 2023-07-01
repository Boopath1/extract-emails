# Email Extractor

This script extracts email addresses from a list of URLs.

## Features

- Extracts email addresses from a list of URLs
- Supports custom file inputs and outputs
- Removes duplicate email addresses
- Provides a progress bar to track the processing status

## Usage

``` shell
./mail.sh [filename] [outputfile]
```
`filename`: Name of the file containing URLs.
`outputfile`: Name of the output file to store the extracted email addresses.

## Getting Started

### Prerequisites
> Make sure you have the following dependencies installed:
* `bash`
* `curl`

## Installation

Clone the repository:

``` shell
https://github.com/Boopath1/extract-emails
```

Make the script executable:
```shell
chmod +x mail.sh
```

## Usage Example

To extract email addresses from a file called urls.txt and store the results in output.txt, run the following command:

```shell
./mail.sh urls.txt output.txt
```
