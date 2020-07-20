#! /bin/bash -x

aws s3 cp webinar-viz-covid19.html s3://castagnetto.site/talks/upch/
aws s3 cp my-reveal-style.css s3://castagnetto.site/talks/upch/
aws s3 cp assets s3://castagnetto.site/talks/upch/assets/ --recursive
aws s3 cp webinar-viz-covid19_files/ s3://castagnetto.site/talks/upch/webinar-viz-covid19_files/ --recursive
