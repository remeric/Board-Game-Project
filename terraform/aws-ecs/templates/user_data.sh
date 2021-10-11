#!/bin/bash

# ECS config
{
  echo "ECS_CLUSTER=BGapp_ECS_cluster"
} >> /etc/ecs/ecs.config

sudo yum update -y

start ecs

echo "Done"