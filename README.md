# Pixela output plugin for Embulk

Embulk Output plugin for [Pixela](https://pixe.la/) to store your historical records

## Overview

* **Plugin type**: output
* **Load all or nothing**: no
* **Resume supported**: no
* **Cleanup supported**: yes

## Limitations

This plugin supports only recoring your historical data to an existing graph.
Create user and Create graph are not supported.
Rerun the following commands in order to do them.

## Configuration

- **name**: Your Username (string, required)
- **token**: Your Token (string, required)
- **graph_id**: Your Graph ID (String, required)
- **quantity_float_column**: Column name to indicate a quantity as float type (quantity_float_column or quantity_int_column are required) (string)
- **quantity_int_column**: Column name to indicate a quantity as int type (quantity_float_column or quantity_int_column are required) (string)
- **date_column**: Column name to indicate date of a quantity (string, required)

## Before you use this plugin

```
$ gem install pixela

$ irb
require "pixela"
client = Pixela::Client.new(username: "xxxx", token: "yyyy")
client.create_user(agree_terms_of_service: true, not_minor: true)
client.create_graph(graph_id: "zzzz", name: "hhhh", unit: "commit", type: "int", color: "shibafu")
```

More example is [here](https://pixe.la/)

## Example

You already have the following graph.

![](https://t.gyazo.com/teams/treasure-data/ab4a4c6ee2d56d4cbe2b34b997c15e24.png)

Th example CSV file is below.

```csv
point,date
0,2018/10/01
1,2018/10/02
2,2018/10/03
3,2018/10/04
4,2018/10/05
5,2018/10/06
6,2018/10/07
7,2018/10/08
8,2018/10/09
9,2018/10/10
10,2018/10/11
11,2018/10/12
12,2018/10/13
13,2018/10/14
14,2018/10/15
```

You can submit this csv file to Pixela by th following command with this yml file

```yaml
in:
  type: file
  path_prefix: test.csv
  parser:
    charset: UTF-8
    newline: CRLF
    type: csv
    delimiter: ','
    quote: '"'
    escape: '"'
    trim_if_not_quoted: false
    skip_header_lines: 1
    allow_extra_columns: false
    allow_optional_columns: false
    columns:
    - {name: point, type: long}
    - {name: date, type: timestamp, format: '%Y/%m/%d'}
out:
  type: pixela
  name: torut
  token: xxxx
  graph_id: embulk-test
  quantity_int_column: point
  date_column: date
```

```
$ embulk run example.yml
```

After this steps are completed, you'll see the following.

![](https://t.gyazo.com/teams/treasure-data/1d3032ad08e5b7d62ae612d84dd4cf4b.png)

## Build

```
$ rake
```
