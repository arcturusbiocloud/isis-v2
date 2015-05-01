# Isis-v2

Component responsible for managing customers and their projects on Arcturus BioCloud. It communicates with the clusters of robots through the project [horus-v2](https://github.com/arcturusbiocloud/horus-v2).

## Environment variables

You should set this variables to run the project:

```shell
# petri dish slot available on the robot endpoint
heroku config:set SLOTS=[5,6]

# number of pictures to take before automatically finishing the project
heroku config:set NUMBER_OF_PICTURES_TO_TAKE=3

# stripe payment keys
heroku config:set STRIPE_PUBLISHABLE_KEY=pk_test_dkH6SuhSyjqPu0kZnjDwQuFz
heroku config:set STRIPE_SECRET_KEY=sk_test_lcGjI6jHE2NrO3pdod3DYoJo
```

## Clockwork

Every 30 seconds Isis-v2 try to run a pending experiment. Every 60 seconds Isis-v2 try to take a picture on the robot endpoint. You can check the jobs at `lib/clock.rb`. To run the job enable clockwork on Heroku with <https://devcenter.heroku.com/articles/clock-processes-ruby> or in development mode use the following shell command:

```shell
clockwork lib/clock.rb
```

## API

It's possible to feed the timeline through the public API, which also reflects on the project status.

The initial status of a project is **pending**. This status is automatically changed when the activity with `key = 1` is created:

### Users endpoint

Setting the user status:

```shell
# status=1
# Update the user status (pending: 0, active: 1, suspended: 2)
curl -X PUT "https://www.arcturus.io/api/users/luisbebop@gmail.com?access_token=55d28fc5783172b90fea425a2312b95a&status=1"
```

### Projects endpoint

Setting the recording file:

```shell
# get the list of the recordings
curl -X GET "https://www.cine.io/api/1/-/stream/recordings?publicKey=55f827239e6c0badfc95795943396155&id=551913c4b936640b005750da"
# the record file bellow contains 5 minutes of an assembly protocol
# recording_file_name=XJRl3Bsq.20150411T022627.mp4
# Update the project with its recording file
curl -X PUT "https://www.arcturus.io/api/projects/1?access_token=55d28fc5783172b90fea425a2312b95a&recording_file_name=XJRl3Bsq.20150411T022627.mp4"
```

Promoting a project to the **featured projects**:

```shell
# is_featured=true
# Update the project featured status (true / false)
curl -X PUT "https://www.arcturus.io/api/projects/1?access_token=55d28fc5783172b90fea425a2312b95a&is_featured=true"
```

_Note: In case you don't know the project ID, you can simply inspec the project title (on action Project#show), and the project ID will be inside the `h1` tag, as a comment._

### Activities endpoint

```shell
# key=1
# Add timeline item indicating that the project is assembling
curl -X POST "https://www.arcturus.io/api/projects/1/activities?access_token=55d28fc5783172b90fea425a2312b95a&key=1&detail=streaming_url"
```

```shell
# key=2
# Add timeline item indicating that the project is transforming
curl -X POST "https://www.arcturus.io/api/projects/1/activities?access_token=55d28fc5783172b90fea425a2312b95a&key=2"
```

```shell
# key=3
# Add timeline item indicating that the project is plating
curl -X POST "https://www.arcturus.io/api/projects/1/activities?access_token=55d28fc5783172b90fea425a2312b95a&key=3"
```

```shell
# key=4
# Add timeline item indicating that the project is incubating
curl -X POST "https://www.arcturus.io/api/projects/1/activities?access_token=55d28fc5783172b90fea425a2312b95a&key=4"
```

```shell
# key=5
# Add timeline item indicating that a picture was taken
# Note that @sample.png is the picture being sent (there is a file called sample.png in the current directory)
curl -X POST "https://www.arcturus.io/api/projects/1/activities?access_token=55d28fc5783172b90fea425a2312b95a&key=5" -F "content=@sample.png"
```

```shell
# key=6
# Add timeline item indicating that the project has been completed
curl -X POST "https://www.arcturus.io/api/projects/1/activities?access_token=55d28fc5783172b90fea425a2312b95a&key=6"
```

From `key = 1` to `key = 3` the status of the project is **running**. After creating a new activity with `key = 4`, the project status is changed to **incubating**, and after creating a new activity with `key = 6`, the project is automatically finished.

### To update an activity

```shell
# Get the list of activities of a given project
curl -X GET "https://www.arcturus.io/api/projects/1/activities?access_token=55d28fc5783172b90fea425a2312b95a"
```

```shell
# Update the attribute created_at of the first activity
curl -X PUT "https://www.arcturus.io/api/projects/1/activities/1?access_token=55d28fc5783172b90fea425a2312b95a&created_at=2015-04-13T02:12:21.405Z"
```

## Featured projects

There's a way to do this through the Project's endpoint, but it's also possible to go straight through Heroku's console:

```shell
$ heroku run console
> # updating the project by it's ID
> Project.find(1).update_attribyte(:is_featured, true)
> # updating the project by it's friendly name
> Project.friendly.find('my-project').update_attribyte(:is_featured, true)
```

## Image handling

The service [Cloudnary](cloudinary.com) is used to handle images. Check out Heroku's dashboard for the credentials.

### How it works

Once the original image is upload, a set o transformations is performed, generating other images.

List of transaformations: [https://cloudinary.com/console/transformations?filter=named](https://cloudinary.com/console/transformations?filter=named)

### Transformation details

The following transformations are available:

#### twitter-card

Transformation used on Twitter.

Ref: https://dev.twitter.com/cards/types/summary-large-image

```
Scale to 643 x 643
Mpad to 1200 x 643 (Center gravity)
Background: #130b18
```

#### facebook

Transformation used on Facebook.

Ref: https://developers.facebook.com/docs/sharing/best-practices#images

This might also be useful (Fetch new scrape): [debug](https://developers.facebook.com/tools/debug/og/object/)

```
Scale to 630
Mpad to 1200 x 630 (Center gravity)
Background: #130b18
```

#### thumbnail

Transformation used to generate the thumbnails.

```
Crop to 1077 x 1077 (Center gravity)
Fit to 150 x 150 (Center gravity)
```
