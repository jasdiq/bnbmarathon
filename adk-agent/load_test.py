# Copyright 2025 Google LLC
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

# TODO: Import required modules
# You'll need:
# - random, uuid
# - HttpUser, task, between from locust

# TODO: Create ProductionAgentUser class
# Create a class that inherits from HttpUser

# TODO: Set wait time between requests
# Use between(1, 3) for faster requests to trigger scaling

# TODO: Implement on_start method
# Set up user_id and session_id
# Create session for the gemma_agent

# TODO: Create conversation test task
# @task(4) method with high frequency to trigger scaling
# Use various conversation topics

# TODO: Create health check test task  
# @task(1) method to test the /health endpoint
