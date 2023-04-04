This test was done on `erlang 19` and as a result `cowboy 1.1.2` due to using this version of erlang in projects of 
a company where I'm working now.

### Installing and start

	$ git clone git@github.com:GovindaGopal/crafting_software_test.git
	$ cd crafting_software_test
	$ make
	
Use the script `start.sh` from the repo to start app

    $ ./start.sh
    
### Requests
Make REST request to `/api/sort` to get sorted tasks with a proper execution order

    $ curl --request GET 'http://localhost:8080/api/sort' \
    --header 'Content-Type: application/json' \
    --data '{
          "tasks": [
              {
                  "name": "task-1",
                  "command": "touch /tmp/file1"
              },
              {
                  "name": "task-2",
                  "command": "cat /tmp/file1",
                  "requires": [
                      "task-3"
                  ]
              },
              {
                  "name": "task-3",
                  "command": "echo '\''Hello World!'\'' > /tmp/file1",
                  "requires": [
                      "task-1"
                  ]
              },
              {
                  "name": "task-4",
                  "command": "rm /tmp/file1",
                  "requires": [
                      "task-2",
                      "task-3"
                  ]
              }
          ]
      }'
      
Make REST request to `/api/script` to get sorted commands as a bash script representation

    $ curl --request GET 'http://localhost:8080/api/script' \ 
    --header 'Content-Type: application/json' \
    --data '{
          "tasks": [
              {
                  "name": "task-1",
                  "command": "touch /tmp/file1"
              },
              {
                  "name": "task-2",
                  "command": "cat /tmp/file1",
                  "requires": [
                      "task-3"
                  ]
              },
              {
                  "name": "task-3",
                  "command": "echo '\''Hello World!'\'' > /tmp/file1",
                  "requires": [
                      "task-1"
                  ]
              },
              {
                  "name": "task-4",
                  "command": "rm /tmp/file1",
                  "requires": [
                      "task-2",
                      "task-3"
                  ]
              }
          ]
      }'

Also was added the simplest validation rules for other path and body structure
For example

    $ curl --request GET 'http://localhost:8080/api/any' \
      --header 'Content-Type: application/json' \
      --data '{
          "tasks": [
              {
                  "name": "task-4",
                  "command": "rm /tmp/file1",
                  "requires": [
                      "task-2",
                      "task-3"
                  ]
              },
              {
                  "name": "task-1",
                  "command": "touch /tmp/file1"
              },
              {
                  "name": "task-2",
                  "command": "cat /tmp/file1",
                  "requires": [
                      "task-3"
                  ]
              },
              {
                  "name": "task-3",
                  "command": "echo '\''Hello World!'\'' > /tmp/file1",
                  "requires": [
                      "task-1"
                  ]
              }
          ]
      }'
or

    $ curl --request GET 'http://localhost:8080/api/sort' \
      --header 'Content-Type: application/json' \
      --data '{
          "list": [
              {
                  "name": "task-4",
                  "command": "rm /tmp/file1",
                  "requires": [
                      "task-2",
                      "task-3"
                  ]
              },
              {
                  "name": "task-1",
                  "command": "touch /tmp/file1"
              },
              {
                  "name": "task-2",
                  "command": "cat /tmp/file1",
                  "requires": [
                      "task-3"
                  ]
              },
              {
                  "name": "task-3",
                  "command": "echo '\''Hello World!'\'' > /tmp/file1",
                  "requires": [
                      "task-1"
                  ]
              }
          ]
      }'
      
### Unit tests

For running unit tests call the command in console

    $ make tests
    
or 

    $ ./start.sh
    $ eunit:test(crafting_software_test_logic).