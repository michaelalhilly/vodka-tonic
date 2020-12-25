# Vodka Tonic

Docker companion so the only software you need to install directly on your device is Docker and libraries not supported by Docker (i.e. XCode).

## Setup

- Clone or download this project into your directory of choice
- Add an alias to the vt.sh script from the command line like so:

```
alias vt="~/Dev/vodka-tonic/vt.sh"
```

## Use with Package.json

VT makes it easy to interact with your project's container. My project's development environment is always contained within Docker.

Your project's root folder needs a package.json file. Here's an example:
```
{
  "name": "your-app",
  ...
  "vt": "-v $(PWD):/var/www -v ~/.ssh:/root/.ssh -w /var/www --env-file=./.env",
  "scripts": {
    "vt:watch": "npm run watch -- ./src/lambda/$3.js ./dist/$3.js"
  }
}
```

## Basic Commands

The vt commands are designed to use the name of your app specified in package.json as the image and container name so you don't have to type them every time. Now you can build, run, and start your development's cli like this:

```
vt build
vt run
vt cli
```

If you exit your container you can jump back in:
```
vt cli
```

## Container Options

You can add container run options to your package.json file using the vt property:

```
...
"vt": "-v $(PWD):/var/www -v ~/.ssh:/root/.ssh -w /var/www --env-file=./.env"
```

## NPM Scripts

If you download vt in your container you can also call npm scripts in your package.json file like so:
```
vt YOUR_SCRIPT_NAME
```
Additionally you can pass arguments to your npm script:
```
vt YOUR_SCRIPT FILENAME
```
You reference arguments in your scripts starting with $2.

```
...
"scripts": {
  "watch": "npm run watch -- ./src/lambda/$2.js ./dist/$2.js"
}
```

## Commands

```
vt build
```
Builds image.


```
vt containers
```
Lists Docker containers in case you get in the habit of using vt.


```
vt cli
```
Starts container's shell session.


```
vt exec
```
Accesses the container's command line.


```
vt images
```
Lists Docker images in case you get in the habit of using vt.


```
vt install
```
Installs npm package.


```
vt push
```
Adds, commits, and pushes all changes to project's git repo.


```
vt rebuild
```
Removes and builds image.


```
vt restart
```
Stops and restarts image.


```
vt rm
```
Removes container.


```
vt rmi
```
Removes image.


```
vt run
```
Creates container from image.


```
vt runcli
```
Runs container and starts its command line.


```
vt start
```
Runs npm start script.


```
vt stop
```
Stops container.


```
vt update
```
Updates npm package.


```
vt {NPM_SCRIPT}
```
Runs script defined in package.json.