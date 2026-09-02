#!/usr/bin/env bash

set -e

tlmgr update --self


tlmgr install amsfonts booktabs titling textpos

# pandoc 3.10.2 pdf_document template (R_test_markdown.Rmd): hard \usepackage{caption,bookmark}
tlmgr install caption bookmark