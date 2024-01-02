.PHONY: tsc build publish

FLAGS = --bundle --minify --target=es2021

tsc:
	./node_modules/.bin/tsc --noEmit

build:
	./node_modules/.bin/esbuild src/main.ts $(FLAGS) --format=iife --global-name=Runno --outfile=dist/runno.js
	./node_modules/.bin/esbuild src/main.ts $(FLAGS) --format=esm --outfile=dist/runno.mjs

publish:
	make tsc build
	npm publish --access=public
