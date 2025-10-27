export concurrently_colors := "blue,green,yellow,magenta,cyan,white"

help:
    just --list

setup:
    npm clean-install

dev:
    npm run dev

run:

test:

all:
    concurrently \
    --names "test,lint" \
    --prefix-colors ${concurrently_colors} \
        "just test" \
        "just lint"
