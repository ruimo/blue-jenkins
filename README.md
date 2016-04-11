# blue-jenkins

Run Jenkins on IBM Containers.

# Prerequisite

You need to have Bluemix account registered with your IBM ID.
You should install cf tools and cf plugin for Bluemix. Please consult the following documentation:

https://console.ng.bluemix.net/docs/containers/container_cli_cfic.html

You need to create volume to backup Jenkins configuration:

```
$ cf ic volume create jenkins
```

Please consult the following documentation for cf ic tools usage:

https://console.ng.bluemix.net/docs/containers/container_cli_reference_cfic.html#container_cli_reference_cfic__volume_create

# Usage

Rename the run.sh.sample to run.sh and reflect your account information.

```
$ cf ic group create --name YOUR_HOST_NAME -p 8080 -m 2048 -v jenkins:/var/jenkins_home --min 1 --max 1 --desired 1 -n YOUR_CONTAINER_NAME -d mybluemix.net registry.ng.bluemix.net/YOUR_DOCKER_NAMESPACE/blue-jenkins
```

Where YOUR_HOST_NAME should be unique in Bluemix url name space, YOUR_CONTAINER_NAME is arbitrary name to spot your Jenkins container, and YOUR_DOCKER_NAMESPACE is your own docker private registry name space in Bluemix. This example use 2048(2GB) as container memory size. You can shrink this parameter to avoid being charged ;-)

Once you add execute bit to your run.sh (chmod +x run.sh), you can start your Jenkins by running this script. For the first time, it begins to run relatively quickly because there are no data in volume to copy. You can inspect your container status by:

```
$ cf ic ps -a

CONTAINER ID        IMAGE                                               COMMAND             CREATED             STATUS                PORTS                          NAMES
efd502f8-1bf        registry.ng.bluemix.net/ruimo/blue-jenkins:latest   ""                  3 hours ago         Running 3 hours ago   10.142.187.57:8080->8080/tcp   ru-pbpl-iqpv5ivzc4fq-sysmt5rpefcw-server-kzgunlpyk3hq
```

If the STATUS column becomes 'Running', your Jenkins is ready to serve you!

Once your Jenkins becomes ready, create simple backup job that execute the following command(I know you are good at Jenkins, I don't guide you how to create the job...):

```
rsync -auv --delete --include jobs/*/config.xml --exclude war --exclude jobs/*/* /var/_jenkins /var/jenkins_home/backup
```

# Caveat

You should wait relatively long time (10 minutes or so: it depends how many plugins you installed) to start Jenkins once the volume has its own backup data because it restores Jenkins configuration from volume before Jenkins starts. Do not use --auto option (auto recovery). Since restoring from volume is terribly slow, auto recovery agent will wrongly determine the application goes hung and fall into end-less loop to stop/start the application.
