# Yet another Rails Beginner Walkthrough
**(E.D.D.) Error Driven Development**

=> understand the error messages

=> avoiding scaffolds to understand the interplay of the components

we will build something like this:

![screenshot](https://raw.github.com/DonSchado/pony_app/master/public/screen1.png)

![screenshot](https://raw.github.com/DonSchado/pony_app/master/public/screen2.png)

![screenshot](https://raw.github.com/DonSchado/pony_app/master/public/screen3.png)



## setup
* $ rails -v
* $ rails new pony_app
* $ cd pony_app
* $ git init
* $ git add .
* $ git commit -am "init"

Add to Gemfile:

```
 group :development do
   gem "thin"
   gem "better_errors"
   gem "binding_of_caller"
   gem "quiet_assets"
 end
```

* $ bundle
* $ rails server

visit localhost:3000

delete public/index.html

reload your browser and read the error message


## (index/home page) routing, controller, view
in routes.rb

```
 root :to => 'pages#index'
```
(reload and read the error message)

create the file **pages_controller.rb** under app/controllers

(reload and read the error message)

in pages_controller.rb

```
 class PagesController < ApplicationController
 end
```

(reload and read the error message)

add in pages_controller.rb

```
 def index
 end
```

(reload and read the error message)

make a folder named **pages** under app/views/
and create a file **index.html.erb**

```
 <h1> I can haz pony? </h1>
```

reload and be happy! :)

time to save the work:

* $ git status (which files have changed?)
* $ git add .
* $ git commit -am "index view"


## make it a little bit more pretty!
visit [http://twitter.github.com/bootstrap/](http://twitter.github.com/bootstrap/), download bootstrap.zip and unzip the bootstrap folder.

move the bootstrap/img folder to your apps **public/img**

js/bootstrap.js file => **vendor/assets/javascripts** (not the *.min file)

css/bootstrap-responsive.css and css/bootstrap.css files => **vendor/assets/stylesheets** (w/o *.min)


change **app/assets/stylsesheets/application.css** to

```
 /*
  *= require bootstrap
  *= require bootstrap-responsive
  */
```

and **app/assets/javascripts/application.js** to

```
 //= require jquery
 //= require jquery_ujs
 //= require bootstrap
```

change **views/pages/index.html.erb** to

```
 <div class="hero-unit">
   <h1>I can haz pony?</h1>
   <br>
   <p>
     <%= link_to :home_page, :class => "btn btn-primary btn-large" do %>
       <i class="icon-heart icon-white"></i>
       Yes you can!
     <% end -%>
   </p>
 </div>
```

in **layouts/application.html.erb** add this between the body tags

```
 <div class="container">
   <%= yield %>
 </div>
```

(reload)

change routes.rb

```
 root :to => 'pages#index', as: :home_page
```

(reload) 

and save your work!

* $ git status
* $ git add .
* $ git commit -am "bootstrap"



## form for new ponies
change the home_page in index.html.erb to

```
 <%= link_to new_pony_path, … %>
```

(reload)

in routes.rb

```
 resources :ponies
```
(reload)

add file **controllers/ponies_controller.rb**

```
 class PoniesController < ApplicationController
 end
```

(reload)

add then

```
 def new; end
```

(reload)

add folder app/views/**ponies**
add there the file **new.html.erb** (we can pretty this up later)

```
 <h1>New Pony</h1>
 <%= form_for @pony, :url => { :action => "create" } do |f| %>
   <%= f.input :name %>
   <%= f.text_field :color %>
   <%= f.text_field :kind_of %>
   <%= f.submit %>
 <% end -%>
```

(reload)

better_errors has a live shell, type:

```
 @pony
```
you will see it's **nil**

go to ponies_controller.rb and add

```
 def new
   @pony = Pony.new
 end
```

Now we need a model for representing our ponies:

* $ rails g model pony name color kind_of

(reload)


rake db:migrate

(reload)


fill in the form with pony junk and submit

check in the live shell:

```
 params
```

which returns the params hash

```
 {"pony" => {"name" => "Pinkie Pie", ...}
```

create the create action in the ponies_controller.rb:

```
 def create
   render :text => params[:pony]
 end
```

(reload)

**YAY! we can submit ponies! **

* $ git status
* $ git add .
* $ git ci -am "post the form to ponies_controller"



## new ponies all around

ponies_controller

```
 def create
   @pony = Pony.create(params[:pony])
   if @pony.save
     redirect_to pony_path(@pony)
   else
     render "new"
   end
 end
```

(reload)

add also:

```
 def show
 end
```

create file **ponies/show.html.erb** and add:

```
 <h1>Pony Profile for <%= @pony.name %>:</h1>
```

(reload)

check the "Request info", you should see something like this:

```
 Request parameters {"action"=>"show", "controller"=>"ponies", "id"=>"2"}
```

add in the **ponies_controller.rb**:

```
 def show
   @pony = Pony.find(params[:id])
 end
```

(reload)


add to **ponies/show.html.erb**:

```
 <div class="well">
   <p><strong>Name:</strong> <%= @pony.name %></p>
   <p><strong>Color:</strong> <%= @pony.color %></p>
   <p><strong>Kind of:</strong> <%= @pony.kind_of %></p>
 </div>

 <%= link_to "Home", :home_page, :class => "btn" %>
```


we want in **ponies/new.html.erb** a selectbox for kind_of:

```
 <%= f.select :kind_of, ["earth", "pegasus", "unicorn"], :prompt => "-" %>
```

submit i.e. Rainbow Dash, blue, pegasus


go to **pony.rb** and add:

```
 validates :name, :presence => true
```

(reload, and submit empty form)

what happens? Nothing? ;)

inspect at bottom of ponies/new.html.erb

```
 <%= @pony.errors.inspect %>
```

(reload)

ah there are errors, because of the validation, obvious.

and rails adds an errors array to @pony

remove inspect and add error block **in** the form:

```
 <% @pony.errors.full_messages.each do |msg| %>
   <div class ="alert alert-error"><%= msg %></div>
 <% end %>
```

good job!

* $ git status
* $ git add .
* $ git ci -am "save ponies"



## show me the ponies

add after the other link_to call in **pages/index.html.erb**:

```
  <%= link_to "Show me the ponies!", ponies_path, :class => "btn btn-info btn-large" %>
```

(reload and try the link/button)


```
 'index' could not be found for PoniesController
```

we know this kind of error now:

**ponies_controller.rb:**

```
 def index
   @ponies = Pony.all
 end
```

and add file the **ponies/index.html.erb**:

```
 <h1>All my fellow ponies:</h1>
 <%= @ponies %>
```

(reload)

great, but we like to list the ponies in a table


## building a table of ponies

**ponies/index.html.erb**:

```
 <h1>All my fellow ponies:</h1>

 <table class="table table-bordered table-striped table-hover">
   <%- @ponies.each do |pony| %>
     <tr>
       <td><%= link_to pony.name, pony_path(pony) %></td>
       <td><%= pony.color %></td>
       <td><%= pony.kind_of %></td>
     </tr>
   <% end -%>
 </table>

 <%= link_to "Home", :home_page, :class => "btn" %>
```

(reload)


## delete ponies:

add another link to **ponies/index.html.erb**:

```
 <%= link_to kill_all_ponies_path, :class => "btn btn-danger pull-right btn-mini" do %>
   <i class="icon-remove icon-white"></i>
   Kill all the ponies
 <% end -%>
```

in the ponies controller:

```
 def delete_all
   Pony.delete_all
   redirect_to :home_page, notice: "Killed all the ponies..."
 end
```


## display messages in application layout
change in app/views/layout/application.html.erb:

```
 <div class="container">
  <%- flash.each do |type, msg| %>
   <div class="alert alert-info fade in">
     <a class="close", href= "#", data-dismiss='alert'>&times;</a>
     <%= msg %>
   </div>
  <% end %>

  <%= yield %>
 </div>
```


Nicer looking form for new ponies **views/ponies/new.html.erb**:

```
 <h1>New Pony</h1>
 <br>
 <div class="row">
   <div class="span12">
     <div class="well">
       <%= form_for @pony, :url => { :action => "create" }, :html => { :class => "form-horizontal" } do |f| %>
         <% @pony.errors.full_messages.each do |msg| %>
          <div class ="alert alert-error"><%= msg %></div>
         <% end %>
         <div class="control-group">
           <div class="control-label">
             <%= f.label :name %>
           </div>
           <div class="controls">
             <%= f.text_field :name %>
           </div>
         </div>
         <div class="control-group">
           <div class="control-label">
             <%= f.label :color %>
           </div>
           <div class="controls">
             <%= f.text_field :color %>
           </div>
         </div>
         <div class="control-group">
           <div class="control-label">
             <%= f.label :kind_of %>
           </div>
           <div class="controls">
             <%= f.select :kind_of, ["earth", "pegasus", "unicorn"], :prompt => "-" %>
           </div>
         </div>
         <div class="control-group">
           <div class="controls">
             <%= f.submit "New", :class => "btn" %>
           </div>
         </div>
       <% end %>
     </div>
   </div>
 </div>
```

## Commit your work! :)

hope you found this useful.
