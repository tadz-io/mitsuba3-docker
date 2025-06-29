# Mitsuba 3 ARM64 Docker Build

This repository provides a Dockerfile to build [Mitsuba 3](https://github.com/mitsuba-renderer/mitsuba3) from source on **Linux ARM64** platforms.

## ⚠️ Why This Exists

As of now, **there are no official precompiled Mitsuba 3 builds** for ARM64 Linux systems.  
However, compiling it from source out of the box **fails** due to a hardcoded architecture flag in cmake files used by `Dr.Jit` and `Mitsuba3`:

```
-march=ivybridge
```

The Dockerfile first builds a wheel for `Dr.Jit` (`v.1.0.5`) for Linux ARM64 that is then used to build and install `Mitsuba`.

## ✅ Tested for

- Mitsuba v.3.6.4
- Dr.Jit v.1.0.5
- Python 3.12

## 🐳 Building the Docker Image

Clone this repository and run:

```bash
docker build -t mitsuba3-linux-arm64 .
```
## ▶️ Run the Container

```bash
docker run -it --name mitsuba3-linux-arm64 mitsuba3-linux-arm64:latest
```
`Mitsuba` can be used from the command line or within python. 
