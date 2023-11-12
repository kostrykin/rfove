# rfove

Build image:
```bash
docker build --no-cache --tag kostrykin/rfove .
```

Run RFOVE:
```bash
docker run --rm -ti -v /tmp/io:/io kostrykin/rfove /rfove 250 0.1 0.2 201 /io/input.png /io/seg.tiff
```
