.PHONY: server
server:
	@echo "Starting Hugo docs server..."
	cd docs && hugo server && cd ..
