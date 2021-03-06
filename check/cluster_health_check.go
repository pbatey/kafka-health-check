package check

import "log"

const (
	green  = "green"
	yellow = "yellow"
	red    = "red"
)

// periodically checks health of the Kafka cluster
func (check *HealthCheck) checkClusterHealth() string {
	metadata, err := check.broker.Metadata()

	if err != nil {
		log.Println("Error while retrieving metadata:", err)
		return red
	}

	for _, topic := range metadata.Topics {
		for _, partition := range topic.Partitions {
			if len(partition.Isrs) == 0 {
				return red // offline partitions exist.
			}
			if len(partition.Isrs) < len(partition.Replicas) {
				return yellow // under-replicated partitions exist.
			}
		}
	}

	return green // all replicas up to date.
}
