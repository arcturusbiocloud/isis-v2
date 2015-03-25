# Isis

Component responsible for managing customers and their projects on Arcturus BioCloud. It communicates with the clusters of robots through the project [horus](https://github.com/arcturusbiocloud/horus).

## API

It's possible to feed the timeline through the public API, which also reflects on the project status.

The initial status of a project is **pending**. This status is automatically changed when the activity with `key = 1` is created:

```shell
# key=1
# Add timeline item indicating that the project is running
curl -X POST "https://dashboard.arcturus.io/api/projects/1/activities?access_token=TOKEN&key=1&detail=streaming_url"
```

```shell
# key=2
# Add timeline item indicating that the project is incubating
curl -X POST "https://dashboard.arcturus.io/api/projects/1/activities?access_token=TOKEN&key=2"
```

```shell
# key=3
# Add timeline item indicating that a picture was taken
# Note that @sample.png is the picture being sent (there is a file called sample.png in the current directory)
curl -X POST "https://dashboard.arcturus.io/api/projects/1/activities?access_token=TOKEN&key=3" -F "content=@sample.png"
```

From `key = 1` to `key = 3` the status of the project is **running**. After creating a new activity with `key = 4`, the project is automatically finished.

```shell
# key=4
# Add timeline item indicating that the project has been completed
curl -X POST "https://dashboard.arcturus.io/api/projects/1/activities?access_token=TOKEN&key=2"
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
