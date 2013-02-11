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

  this should respond with someting like this:

  ```
   Rails 3.2.11
  ```


  if you see something like an error, you may need to [setup your system first](http://railsinstaller.org/).

let's start:

* $ rails new pony_app
* $ cd pony_app
* $ git init
* $ git add .
* $ git commit -am "init"

Add to Gemfile (open in your editor):

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

![screenshot](https://raw.github.com/DonSchado/pony_app/master/guide/rails.png)

great! :)

now delete **public/index.html**

reload your browser and read the first error message:

![screenshot](https://raw.github.com/DonSchado/pony_app/master/guide/1_routing.png)

Ah, there is no route defined for the root url of the app.

So let's start the **E.D.D.**-Process ;)


## (index/home page) routing, controller, view
to build our own "index page" add before the last ```end``` in **config/routes.rb**

```
 root :to => 'pages#index'
```

(reload and read the error message)

![screenshot](https://raw.github.com/DonSchado/pony_app/master/guide/2_pagescontroller.png)

Ok, we have no Controller for Pages... so we need to create one.

As Rails will search for a file named ```pages_controller.rb```, we create the file **pages_controller.rb** under app/controllers

(reload and read the error message)

![screenshot](https://raw.github.com/DonSchado/pony_app/master/guide/3_pagescontroller.png)

Sure, just the file isn't enough, to add in pages_controller.rb

```
 class PagesController < ApplicationController
 end
```

(reload and read the error message)

![screenshot](https://raw.github.com/DonSchado/pony_app/master/guide/4_index.png)

add to the class in pages_controller.rb the method

```
 def index
 end
```

(reload and read the error message)

![screenshot](https://raw.github.com/DonSchado/pony_app/master/guide/5_missing_view.png)

make a folder named **pages** under app/views/
and create a file **index.html.erb** with:

```
 <h1> I can haz pony? </h1>
```

reload and be happy! :)

![screenshot](https://raw.github.com/DonSchado/pony_app/master/guide/6_pony.png)

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

in **layouts/application.html.erb** add this _between_ the ```<body> </body>``` tags

```
 <div class="container">
   <%= yield %>
 </div>
```

(reload)

![screenshot](https://raw.github.com/DonSchado/pony_app/master/guide/7_home_page.png)

ok, we changed a bunch of files... but the only real method we're calling is ```link_to```

we need to change our routes.rb so that Rails knows how to link to the ```home_page_path```.


```
 root :to => 'pages#index', as: :home_page
```

(reload) you should see the link now :)

That's a bit of Rails' magic... checkout the [railsguides](http://guides.rubyonrails.org/routing.html) for more on routing.

But for now, save your work! :)

* $ git status
* $ git add .
* $ git commit -am "bootstrap"



## form for new ponies
ok, to link to the same page you're looking at is kinda boring.

We want to save new ponies!

So change the ```:home_page``` in index.html.erb to ```new_pony_path```

```
 <%= link_to new_pony_path, :class => "btn btn-primary btn-large" do %>
```

(reload)

![screenshot](https://raw.github.com/DonSchado/pony_app/master/guide/8_new_pony_path.png)

We could add this path like we did with the home_page_path,
but in this case we don't want to link to a single page,
we want to deal with ponies! So in Rails such an entity is represented by a model.
A model represents the information and data.
We can address a model with a resource.
(A Resource provides a framework for managing the connection between model and database.)

Ok, so we want a pony resource and add it to our routes.rb file:

```
 resources :ponies
 root :to => 'pages#index', as: :home_page
```

(reload) and click the new pony link:

![screenshot](https://raw.github.com/DonSchado/pony_app/master/guide/9_ponies_controller.png)

Ah, we had a similar error... now we need to add the file **controllers/ponies_controller.rb**

```
 class PoniesController < ApplicationController
 end
```

(reload)

![screenshot](https://raw.github.com/DonSchado/pony_app/master/guide/10_new_action.png)

ok, so we add it

```
 def new
 end
```

(reload)

![screenshot](https://raw.github.com/DonSchado/pony_app/master/guide/11_missing_pony_new.png)

Now we know what to do:

add folder **app/views/ponies**

add there the file **new.html.erb**

and paste a form snippet, inspired from the railsguides ;) (we can pretty this up later)
we need fields for name, color and maybe the type (or say kind_of).
the form should ```create``` simple ponies.

```
 <h1>New Pony</h1>
 <%= form_for @pony, :url => { :action => "create" } do |f| %>
   <%= f.text_field :name %>
   <%= f.text_field :color %>
   <%= f.text_field :kind_of %>
   <%= f.submit %>
 <% end %>
```

(reload)

![screenshot](https://raw.github.com/DonSchado/pony_app/master/guide/12_pony_model.png)

Ok, what's the error here? We have ```nil``` somewhere.

better_errors has a live shell:

![screenshot](https://raw.github.com/DonSchado/pony_app/master/guide/13_shell.png)

since we try to build the form for a pony, just type:

```
 @pony
```

you will see the value of ```@pony``` is **nil**... or nothing.
So we have to fill this variable with something.

go to ponies_controller.rb and add

```
 def new
   @pony = Pony.new
 end
```

and since we need a model for representing our ponies switch to your terminal and type:

* $ rails g model pony

you will the somethin like this:

![screenshot](https://raw.github.com/DonSchado/pony_app/master/guide/14_g_model.png)

we now have a model class, and a migration. Cool!

edit the **migration** to add the additionl fields we want to save

```
 class CreatePonies < ActiveRecord::Migration
   def change
     create_table :ponies do |t|

       t.string :name
       t.string :color
       t.string :kind_of

       t.timestamps
     end
   end
 end
```

(reload)

![screenshot](https://raw.github.com/DonSchado/pony_app/master/guide/15_table_ponies.png)

sorry... of course we have to run this migration. Fire up your terminal:

 ```rake db:migrate```

it should return something like this (if not check for typos!):

```
 ==  CreatePonies: migrating ============
 -- create_table(:ponies)
   -> 0.0021s
 ==  CreatePonies: migrated (0.0023s) ===
```

(reload)

You should see the form now! :)

fill in the form with pony junk (i.e. Pinke Pie, pink, earth) and click the submit button.

![screenshot](https://raw.github.com/DonSchado/pony_app/master/guide/16_action_create.png)

hm, check in the live shell the params send (or posted) by the form:

```
 params
```

which returns the params hash

```
 {"pony" => {"name" => "Pinkie Pie", ...}
```

So everything is fine! :) We only need the create action.

create the create action in the ponies_controller.rb

for now we just want to see if we wired everything up corectly:

```
 def create
   render :text => params[:pony]
 end
```

(reload, click yes/next to re-submit the form if you like)

### YAY! we can submit ponies!

![screenshot](https://raw.github.com/DonSchado/pony_app/master/guide/17_pony_params.png)


* $ git status
* $ git add .
* $ git ci -am "post the form to ponies_controller"



## new ponies all around

change the create method in the ponies_controller.rb to:

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

![screenshot](https://raw.github.com/DonSchado/pony_app/master/guide/17_mass_assign.png)

oh, the form is not allowed to set these attributes...

so we add them in the model under **app/models/pony.rb**:

```
 class Pony < ActiveRecord::Base
   attr_accessible :name, :color, :kind_of
 end

```

(reload again)

![screenshot](https://raw.github.com/DonSchado/pony_app/master/guide/18_show_pony.png)

Ah, to show the created pony, we need a show action and view:

add in the ponies_controller.rb:

```
 def show
 end
```

and create the file **ponies/show.html.erb**:

```
 <h1>Pony Profile for <%= @pony.name %> </h1>
```

![screenshot](https://raw.github.com/DonSchado/pony_app/master/guide/19_nil_pony.png)

Oh, ```nil``` again... check the "Request info" of better_errors, you should see something like this:

```
 Request parameters {"action"=>"show", "controller"=>"ponies", "id"=>"1"}
```

So we wanted to show pony number 1, but... the show action does nothing to find the pony.

to change that add in the **ponies_controller.rb**:

```
 def show
   @pony = Pony.find(params[:id])
 end
```

(reload)

##YAY! Pony Profile for Pinkie Pie! ;)

ok, we can add more info to this page.

add to **ponies/show.html.erb**:

```
 <div class="well">
   <p><strong>Name:</strong> <%= @pony.name %></p>
   <p><strong>Color:</strong> <%= @pony.color %></p>
   <p><strong>Kind of:</strong> <%= @pony.kind_of %></p>
 </div>

 <%= link_to "Home", :home_page, :class => "btn" %>
```

(reload)

=> cool :)


Now we want in **ponies/new.html.erb** a selectbox for kind_of.
So change:

```
 <%= f.text_field :kind_of %>
```

to this:

```
 <%= f.select :kind_of, ["earth", "pegasus", "unicorn"], :prompt => "-" %>
```

Visit the form and test this out. Submit i.e. Rainbow Dash, blue, pegasus

cool! :)

hm, we can **validate** that we want at least a name for a pony...

go to **pony.rb** and add ```validates :name, :presence => true```:

```
 class Pony < ActiveRecord::Base
   attr_accessible :name, :color, :kind_of
   validates :name, :presence => true
 end

```

(reload, and submit an empty form)

what happens? Nothing? ;)

inspect at bottom of ponies/new.html.erb

```
 <%= @pony.errors.inspect %>
```

(reload)

you should see something like:

```
 #<ActiveModel::Errors:0x007fc2cf21c9f8
  @base=#<Pony id: nil, name: "", color: "", kind_of: "", created_at: nil, updated_at: nil>,
  @messages={:name=>["can't be blank"], :color=>[], :kind_of=>[]}>
```

ah there are errors, because of the validation, obvious.

and rails adds an errors array to @pony

remove inspect and add error block **in** the form:

```
 <% @pony.errors.full_messages.each do |msg| %>
   <div class ="alert alert-error"><%= msg %></div>
 <% end %>
```

try again to submit an empty form!
it should say:

```
 Name can't be blank
```

Cool, good job! :)

We have to save this.

* $ git status
* $ git add .
* $ git ci -am "save ponies"



## show me the ponies

from now on, you are aware of the errors I guess ;)

so we will speed up the final part.

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

and add the file **ponies/index.html.erb**:

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

(reload)


we need to add the custom path in the routes:

```
 get "kill_all_ponies" => "ponies#delete_all", :as => "kill_all_ponies"
```

(reload)


add in the ponies_controller:

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

## You're done! Commit your work! :)

hope you found this useful.
