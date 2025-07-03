# Mitsuba 3 Docker Build

This repository provides a Dockerfile to build [Mitsuba 3](https://github.com/mitsuba-renderer/mitsuba3) from source. For builds on **Linux ARM64** checkout the `linux-arm64` branch.

## ✅ Tested for

- Mitsuba v.3.6.4
- Dr.Jit v.1.0.5
- Python 3.12

## 🐳 Building the Docker Image

Clone this repository and run:

```bash
docker build -t mitsuba3-docker .
```
## ▶️ Run the Container

```bash
docker run -it --name mitsuba3-docker mitsuba3-docker:latest
```
`Mitsuba` can be used from the command line or within python. 
