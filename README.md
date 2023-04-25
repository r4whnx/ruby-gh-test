# ruby-gh-test

Test application that makes use of simple web server and interacts with GitHub public API

## How it works
- Server listens to requests on port 2000
- Converts relative URL to GitHub username
- Generates a request to GitHub API and parses the answer
- Shows whether user exists or not and outputs it's ID and link to the profile

## Running the app
### Locally:
```sh
ruby server.rb
```

### With Docker:
```sh
docker build . -t andreychenkom/ruby-gh-test:latest --no-cache
docker run --rm -ti -p 2000:2000 andreychenkom/ruby-gh-test:latest
```
> However `docker build` command is optional since app is already present on [Docker Hub](https://hub.docker.com/r/andreychenkom/ruby-gh-test)

### With K8s:
```sh
kubectl apply -f manifests/namespace.yaml
kubectl apply -f manifests/service.yaml
kubectl apply -f manifests/deployment.yaml
```
In order to get actual app's URL from minikube you can run:
```sh
minikube service ruby-gh-test --url -n ruby-gh-test
```

## Example usage
```sh
$ curl localhost:2000
No username passed. Consider using host:port/username
Falling back to default account (r4whnx)
User r4whnx is found.
User id is 46276538.
Profile can be found at https://github.com/r4whnx
```
```sh
$ curl localhost:2000/davidyuk
User davidyuk is found.
User id is 9007851.
Profile can be found at https://github.com/davidyuk
```
```sh
$ curl localhost:2000/g87634xgfgb78
Not found. Try another user
```
```sh
$ curl localhost:2000/health_check
Ready
```
