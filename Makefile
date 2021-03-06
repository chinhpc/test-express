Myapp := my-express-nodejs-app

all: run

install:
	docker build -t $(Myapp) .

server:
	docker run -d \
	  --network bridge \
	  --name mongo-server mongo
	docker run -d \
	  --name mongo-express \
	  -e ME_CONFIG_MONGODB_SERVER=mongo-server \
	  -p 8081:8081 \
	  --network bridge \
	  mongo-express

run: install
	docker run -it \
	  --rm \
	  -p 80:3000 \
	  -e "NODE_ENV=production" \
	  -u "node" \
	  --name "$(Myapp)" \
	  --network bridge \
	  $(Myapp) bash -c "DEBUG=myapp:* npm start"

clean:
	docker image rm $(shell docker images -a -q --filter=reference="$(Myapp)" --format "{{.ID}}")
	docker rm $(shell docker stop $(shell docker ps -a -q --filter name=mongo-express --format="{{.ID}}"))
	docker rm $(shell docker stop $(shell docker ps -a -q --filter name=mongo-server --format="{{.ID}}"))
# 	docker rm $(docker stop $(docker ps -a -q --filter ancestor=mongo-express --format="{{.ID}}"))
