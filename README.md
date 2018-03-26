# vend
Well that was fun!

## Quick start

Clone repo, change into the repo directory, build image and start CLI.

```
cd /path/to/where/you/cloned/vend
docker build -t vend .
docker run -it vend bundle exec rake start
```

To run the tests:

```
docker run -it vend bundle exec rake
```
