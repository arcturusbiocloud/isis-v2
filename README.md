# Isis

Component responsible for managing customers and their projects on Arcturus BioCloud. It communicates with the clusters of robots through the project [horus-v2](https://github.com/arcturusbiocloud/horus-v2).

## API

It's possible to feed the timeline through the public API, which also reflects on the project status.

The initial status of a project is **pending**. This status is automatically changed when the activity with `key = 1` is created:

```shell
# key=1
# Add timeline item indicating that the project is assembling
curl -X POST "https://dashboard.arcturus.io/api/projects/1/activities?access_token=TOKEN&key=1&detail=streaming_url"
```

```shell
# key=2
# Add timeline item indicating that the project is transforming
curl -X POST "https://dashboard.arcturus.io/api/projects/1/activities?access_token=TOKEN&key=2"
```

```shell
# key=3
# Add timeline item indicating that the project is plating
curl -X POST "https://dashboard.arcturus.io/api/projects/1/activities?access_token=TOKEN&key=3"
```

```shell
# key=4
# Add timeline item indicating that the project is incubating
curl -X POST "https://dashboard.arcturus.io/api/projects/1/activities?access_token=TOKEN&key=4"
```

```shell
# key=5
# Add timeline item indicating that a picture was taken
# Note that @sample.png is the picture being sent (there is a file called sample.png in the current directory)
curl -X POST "https://dashboard.arcturus.io/api/projects/1/activities?access_token=TOKEN&key=5" -F "content=@sample.png"
```

```shell
# key=6
# Add timeline item indicating that the project has been completed
curl -X POST "https://dashboard.arcturus.io/api/projects/1/activities?access_token=TOKEN&key=6"
```

From `key = 1` to `key = 3` the status of the project is **running**. After creating a new activity with `key = 4`, the project status is changed to **incubating**, and after creating a new activity with `key = 6`, the project is automatically finished.

## Featured projects

At this moment there's no interface to set/unset featured projects, so it's necessary to use Heroku's console:

```shell
$ heroku run console
> # updating the project by it's ID
> Project.find(1).update_attribyte(:is_featured, true)
> # updating the project by it's friendly name
> Project.friendly.find('my-project').update_attribyte(:is_featured, true)

```

## Image handling

The service [Cloudnary](cloudinary.com) is used to handle images. Check out Heroku's dashboard for the credentials.

Sample upload:

```ruby
Cloudinary::Uploader.upload(params["content"],
                            public_id: public_id, tags: tags,
                            eager: [
                              {
                                transformation: [
                                  { width: 1077, height: 1077, crop: :crop, gravity: :center },
                                  { width: 150, height: 150, crop: :fit, gravity: :center }
                                ]
                              },
                              { width: 1077, height: 1077, crop: :crop, gravity: :center }
                            ])
```

Same upload, but now using named transformations (they can seen on Cloudnary's dashboard):

```ruby
Cloudinary::Uploader.upload(params["content"],
                            public_id: public_id, tags: tags,
                            eager: [
                              { transformation: 'thumbnail' },
                              { transformation: 'original' }
                            ])
```
