#!/bin/bash

# ECS config
{
  echo "ECS_CLUSTER=BGapp_ECS_cluster"
} >> /etc/ecs/ecs.config

start ecs

echo "Done"