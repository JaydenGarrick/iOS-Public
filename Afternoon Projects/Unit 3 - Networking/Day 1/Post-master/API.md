# Post API Documentation

## Retrieving Data 

[Firebase REST API Reference](https://www.firebase.com/docs/rest/guide/retrieving-data.html)

* Query all posts: `https://devmtn-post.firebaseio.com/posts.json`
* Query a specific post: `https://devmtn-post.firebaseio.com/posts/{{ uuid }}.json`

## Saving Data

[Firebase REST API Reference](https://www.firebase.com/docs/rest/guide/saving-data.html)

* Adding a post: PUT to `https://devmtn-post.firebaseio.com/posts/{{ uuid }}`

## Filtering Data with URL Parameters

[Firebase REST API Reference](https://www.firebase.com/docs/rest/guide/retrieving-data.html#section-rest-filtering)