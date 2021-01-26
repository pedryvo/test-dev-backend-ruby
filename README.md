Delivery Center - Backend Dev Test
==================

### General

This is a simple Sinatra API using DataMapper as ORM and Ministest for tests.

### Uso da API
Here are the url's supported by the API:

- :base =>  https://orders-api-delivery-center.herokuapp.com/

- :orders => https://orders-api-delivery-center.herokuapp.com/api/v1/orders

  Supported Actions: GET, POST, DELETE

Note: This API only supports JSON.

## Example Requests ##
Below is an example request that will create an **Order**.
<pre><code>
    curl -X POST -H "Content-Type: application/json" -d @test.json https://orders-api-delivery-center.herokuapp.com/api/v1/order
</pre></code>


Here is an example request that will show an **Order**.
<pre><code>
    curl -X GET https://orders-api-delivery-center.herokuapp.com/api/v1/orders/1
</pre></code>


Here is an example request that will delete an **Order**.
<pre><code>
  curl -X DELETE https://orders-api-delivery-center.herokuapp.com/api/v1/orders/1
</pre></code>


#### Notes

* Tests can be run using Rake `bundle exec rake`.

* To run the Sinatra app simply install the dependencies via bundler and run the server from the root using `bundle exec shotgun`.

* To run project locally you must have a PostgreSQL database named 'test' with an user 'postgres' and password 'postgres' on your machine.

* To run project on Heroku you need to add an add-on after deploy using `heroku addons:create heroku-postgresql:hobby-dev`.
