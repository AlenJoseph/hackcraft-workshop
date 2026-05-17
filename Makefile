.PHONY: start stop reset status shell logs help

# Default target
help: ## Show this help message
	@echo ""
	@echo "  ╔═══════════════════════════════════════╗"
	@echo "  ║       HackCraft Workshop Lab          ║"
	@echo "  ╚═══════════════════════════════════════╝"
	@echo ""
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | \
		awk 'BEGIN {FS = ":.*?## "}; {printf "  \033[36m%-15s\033[0m %s\n", $$1, $$2}'
	@echo ""

start: ## Start the lab environment
	@echo "🚀 Starting HackCraft lab environment..."
	docker compose up -d
	@echo ""
	@echo "✅ Lab is running! Connect with: make shell"
	@echo ""
	@docker compose ps

stop: ## Stop the lab environment
	@echo "🛑 Stopping lab environment..."
	docker compose down
	@echo "✅ Lab stopped."

reset: ## Stop, remove volumes, and restart fresh
	@echo "🔄 Resetting lab environment (this removes all data)..."
	docker compose down -v
	docker compose up -d --build
	@echo ""
	@echo "✅ Lab reset complete!"
	@docker compose ps

status: ## Show container status
	@docker compose ps

shell: ## Open a shell in the Kali container
	@echo "🐧 Connecting to Kali attacker machine..."
	@docker exec -it kali bash

logs: ## Show logs for all containers
	@docker compose logs --tail=50

logs-ctf: ## Show CTF server logs
	@docker compose logs --tail=50 ctf-server

build: ## Rebuild all containers from scratch
	@echo "🔨 Rebuilding all containers..."
	docker compose build --no-cache
	@echo "✅ Build complete. Run 'make start' to launch."

lightweight: ## Start without Metasploitable (saves ~1GB RAM)
	@echo "🚀 Starting lightweight lab (no Metasploitable)..."
	docker compose up -d kali dvwa ctf-server
	@echo ""
	@echo "✅ Lightweight lab running! (Metasploitable skipped)"
	@docker compose ps
