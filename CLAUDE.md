# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

This is an R project using `renv` for dependency management with R version 4.4.3.

## Environment Setup

The project uses `renv` for reproducible environments. The `.Rprofile` automatically activates the `renv` environment when R starts.

### Installing Dependencies

```bash
# In R console
renv::restore()
```

This installs all packages specified in `renv.lock`.

### Adding New Packages

When adding new R packages to the project:

```r
# Install the package
install.packages("package_name")

# Update the lockfile to record the dependency
renv::snapshot()
```

## Running R Code

### Interactive R Session

```bash
R
```

### Running R Scripts

```bash
Rscript path/to/script.R
```

## Project Configuration

- **Code Style**: 2 spaces for indentation (configured in .Rproj file)
- **Encoding**: UTF-8
- **CRAN Mirror**: https://cloud.r-project.org

## Dependency Management

The `renv.lock` file contains the complete dependency specification. Always commit changes to `renv.lock` after adding or updating packages to ensure reproducibility.
