#!/bin/bash

fundDeployer() {
  source .env
  cast send --legacy $DEPLOYER_ADDRESS --value 0.001ether --private-key $PRIVATE_KEY
}