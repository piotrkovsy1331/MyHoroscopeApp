#!/usr/bin/env python3
"""Builds assets/data/cities.tsv from GeoNames dumps (CC BY 4.0).

Usage:
  1. Download into an empty directory from https://download.geonames.org/export/dump/:
     cities15000.zip (unzip it), admin1CodesASCII.txt, countryInfo.txt
  2. python3 -I tool/build_cities.py <that-directory> assets/data/cities.tsv

Output format (UTF-8, tab separated):
  #tz   <IANA zone 0> <IANA zone 1> ...
  #cc   <ISO2>=<country name> ...
  then one row per city, most populous first:
  name, ascii name (empty if equal), ISO2, admin1 name, lat, lon, tz index, population
"""
import os
import sys


def main(src: str, out: str) -> None:
    countries = {}
    with open(os.path.join(src, 'countryInfo.txt'), encoding='utf-8') as f:
        for line in f:
            if line.startswith('#'):
                continue
            cols = line.rstrip('\n').split('\t')
            countries[cols[0]] = cols[4]

    admin1 = {}
    with open(os.path.join(src, 'admin1CodesASCII.txt'), encoding='utf-8') as f:
        for line in f:
            code, name, *_ = line.rstrip('\n').split('\t')
            admin1[code] = name

    rows = []
    with open(os.path.join(src, 'cities15000.txt'), encoding='utf-8') as f:
        for line in f:
            c = line.rstrip('\n').split('\t')
            name, ascii_name = c[1], c[2]
            cc, a1, pop, tz = c[8], c[10], int(c[14] or 0), c[17]
            if not tz:
                continue
            rows.append((pop, name, '' if ascii_name == name else ascii_name,
                         cc, admin1.get(f'{cc}.{a1}', ''),
                         float(c[4]), float(c[5]), tz))

    rows.sort(key=lambda r: -r[0])
    zones = sorted({r[7] for r in rows})
    zone_index = {z: i for i, z in enumerate(zones)}
    used_cc = sorted({r[3] for r in rows})

    with open(out, 'w', encoding='utf-8', newline='\n') as f:
        f.write('#tz\t' + '\t'.join(zones) + '\n')
        f.write('#cc\t' + '\t'.join(f'{cc}={countries.get(cc, cc)}' for cc in used_cc) + '\n')
        for pop, name, ascii_name, cc, region, lat, lon, tz in rows:
            f.write(f'{name}\t{ascii_name}\t{cc}\t{region}\t{lat:.4f}\t{lon:.4f}\t{zone_index[tz]}\t{pop}\n')
    print(f'{len(rows)} cities, {len(zones)} time zones -> {out}')


if __name__ == '__main__':
    main(sys.argv[1], sys.argv[2])
