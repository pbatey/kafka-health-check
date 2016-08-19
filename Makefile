build:
	go build .

install:
	go install .

deps:
	go get github.com/kardianos/govendor
	govendor sync
	cd compatibility; govendor sync
	go get github.com/golang/mock/gomock
	go get github.com/optiopay/kafka
	go get github.com/optiopay/kafka/kafkatest
	go get github.com/optiopay/kafka/proto
	go get github.com/samuel/go-zookeeper/zk
	go get github.com/go-kit/kit/log

test: build
	go fmt . ./check
	go vet . ./check
	go test -v -race ./check

docker: build
	GO_ENABLED=0 GOOS=linux go build -a -installsuffix cgo -o main .
	docker build -t kafka-health-check .

compatibility: build
	go run compatibility/test.go -base-dir "./compatibility" -health-check "./kafka-health-check"
