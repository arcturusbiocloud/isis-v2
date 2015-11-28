# Isis-v2

Component responsible for managing customers and their projects on Arcturus BioCloud.

## Environments

The following distinct environments are available:

- Staging: [https://www-staging.arcturus.io](https://www-staging.arcturus.io) (branch `staging`)
- Production: [https://www.arcturus.io](https://www.arcturus.io) (branch `master`)

## Deployment

```shell
#to production on branch master
git push heroku-production

#to staging on branch staging
git push heroku-staging staging:master
```

## Environment variables

You should set this variables to run the project:

```shell
# stripe payment keys
heroku config:set STRIPE_PUBLISHABLE_KEY=pk_test_dkH6SuhSyjqPu0kZnjDwQuFz
heroku config:set STRIPE_SECRET_KEY=sk_test_lcGjI6jHE2NrO3pdod3DYoJo
```

## Featured projects

Through Heroku's console:

```shell
$ heroku run console
> # updating the project by it's ID
> Project.find(1).update_attribute(:is_featured, true)
> # updating the project by it's friendly name
> Project.friendly.find('my-project').update_attribyte(:is_featured, true)
```
