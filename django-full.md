 {{{
        # Golden Rule: Dont trust data from untrusted sources

        # Change admin templates for customization index|base|base_site.html
        # Unicode functionality replaced by str in python 3
        from django.utils.encoding import python_2_unicode_compatible
        # convenient file refrencing
        # Build paths inside the project like this: os.path.join(BASE_DIR, ...)
        >>> import os
        >>> BASE_DIR = os.path.dirname(os.path.dirname(__file__))
        >>> LOCALE_PATHS = (
                os.path.join(BASE_DIR, 'locale'),
                )
        >>> MEDIA_ROOT = os.path.join(BASE_DIR, 'public/media/')
        >>> MEDIA_URL = '/media/'
        >>> STATIC_ROOT = os.path.join(BASE_DIR, 'public/static/')
        >>> STATIC_URL = '/static/'
        >>> STATICFILES_DIRS = (
                os.path.join(BASE_DIR, 'demo/static/'),
                )
        >>> TEMPLATE_DIRS = (
                os.path.join(BASE_DIR, 'demo/templates/'),
                )
        # and for the database path
        # ...
        >>> os.path.join(BASE_DIR, 'private/development.db')

        # during request phase the items in MIDDLEWARE run in order
        # during the response phase the items are run in reverse order

        # If code deals with the request object, it should almost definitely be
        # in the view. Outside of that, ask yourself where the code should live
        # in the following in order:
        1. Should it be a model method?
        2. Should it be model manager method?
        3. Should it be a form method?
        4. Should it be a method of a view class?
        # If the answer to those four is no, then consider a util function.
        # TL;DR
        # Using model methods makes Django apps better

    part 3
    views are a type of Webpage in your Django application that generally
        serves a specific function and has a specific template
    meta classes
        abstract proxy multi table inheritance
        Make sure to rename related name, Multi table inheritance
## }}}

## gen {{{
## }}}

## toolchain {{{
    virtualenv virtualenvwrapper
    django
    south
    celery
    stripe
        pip install --index-url https://code.stripe.com --upgrade stripe
    macaw

## }}}

## commands {{{
    django-admin.py startproject ProjectName
    cd ProjectName
    mkdir templates
    mkdir media

    # settings.py
    # edit your database settings
    # set path to media dir ( e.g. /home/joe/ProjectName/media )
    # media contains public files such as css and js files
    # set path to template dir ( e.g. /home/joe/ProjectName/templates )
    # templates contains django html templates
    # your applications will likely have their own template dirs.
    # Remember to add those as you create them ( e.g. /home/joe/ProjectName/templates/polls )

    ./manage.py                     # list available commands
    ./manage.py syncdb              # create tables for models that don't have tables
    ./manage.py startapp polls      # create application
    ./manage.py sql polls           # view sql create table for app polls
    ./manage.py validate            # check for errors in the construction of your models
    ./manage.py sqlindexex polls    # create index for polls app
    ./manage.py diffsettings        # settings that deviate from the default settings
    ./manage.py collectstatic       # This will copy all files from your static
                                        # folders to STATIC_ROOT directory

    ./manage.py createsuperuser --username=joe --email=joe@example.com
    ./manage.py changepassword *username*

    ./manage.py makemigrations [<app_label>] # make a migration file
        # with --dry-run and --verbosity 3 for debugging
        # --database argument, tell migrate to synchronize a different
        # database.
    ./manage.py migrate [<app_label> [<migrationname>]] # make a migration

    # south migration commands
    ./manage.py schemamigration polls --initial # create index for polls app
    ./manage.py schemamigration polls --auto    # create index for polls app

    ./django-admin.py makemessages  # make message files for translating
## }}}
## database {{{
    # If no suggestion can be found, it tries the current _state.db of the hint
    # instance.

    # Master slave configuration need routers
    import random

    class MasterSlaveRouter(object):
        # Returns None if there is no suggestion.
        def db_for_read(self, model, **hints):
            """
            Reads go to randomly chosen db
            """
            return random.choice(['slave1', 'slave2'])

        # Returns None if there is no suggestion.
        def db_for_wrie(self, model, **hints):
            """
            Writes always to master
            """
            return 'master'

        def allow_relation(self, obj1, obj2, **hints):
            """
            relationships are allowed if both are in master slave pool
            """
            db_list=('master', 'slave1', 'slave2')
            if obj1.state.db in db_list and obj2.state.db in db_list
                return true
            return None

        def allow_syncdb(self, db, **hints):
            """
            if other routers havent captured other models they end up here
            """
            return True

    # In settings.py
    DATABASE_ROUTERS=['path.to.routers', 'path.to.MasterSlaveRouter']
    # Routers will be queried in the order the are listed in the
    # DATABASE_ROUTERS setting

    # Manually selecting a database for a QuerySet
    # using() takes a single argument: the alias of the database on which you
    # want to run the query.
    >>> Author.objects.using('other').all()

    # Selecting a database for save()
    >>> my_object.save(using='legacy_users')

    # Selecting a database to delete from
    >>> user_obj.delete(using='legacy_users')

    # Using managers with multiple databases
    >>> User.objects.db_manager('new_users').create_user(...)

    # Exposing multiple databases in Django’s admin interface
    # ModelAdmin objects have five methods that require customization for
    # multiple-database support:
    >>> class MultiDBModelAdmin(admin.ModelAdmin):
            # A handy constant for the name of the alternate database.
            using = 'other'

            def save_model(self, request, obj, form, change):
                # Tell Django to save objects to the 'other' database.
                obj.save(using=self.using)
             def delete_model(self, request, obj):
                # Tell Django to delete objects from the 'other' database
                obj.delete(using=self.using)
             def get_queryset(self, request):
                # Tell Django to look for objects on the 'other' database.
                return super(MultiDBModelAdmin,
                    self).get_queryset(request).using(self.using)
             def formfield_for_foreignkey(self, db_field, request=None, **kwargs):
                # Tell Django to populate ForeignKey widgets using a query
                # on the 'other' database.
                return super(MultiDBModelAdmin, self).formfield_for_foreignkey(
                    db_field, request=request, using=self.using, **kwargs)
             def formfield_for_manytomany(self, db_field, request=None, **kwargs):
                # Tell Django to populate ManyToMany widgets using a query
                # on the 'other' database.
                return super(MultiDBModelAdmin, self).formfield_for_manytomany(
                    db_field, request=request, using=self.using, **kwargs)

    # Inlines can be handled in a similar fashion. They require three
    # customized methods:

    >>> class MultiDBTabularInline(admin.TabularInline):
            using = 'other'
            def get_queryset(self, request):
                # Tell Django to look for inline objects on the 'other' database.
                return super(MultiDBTabularInline,
                    self).get_queryset(request).using(self.using)
             def formfield_for_foreignkey(self, db_field, request=None, **kwargs):
                # Tell Django to populate ForeignKey widgets using a query
                # on the 'other' database.
                return super(MultiDBTabularInline,self).formfield_for_foreignkey(
                    db_field, request=request, using=self.using, **kwargs
             def formfield_for_manytomany(self, db_field, request=None, **kwargs):
                # Tell Django to populate ManyToMany widgets using a query
                # on the 'other' database.
                return super(MultiDBTabularInline, self).formfield_for_manytomany(
                    db_field, request=request, using=self.using, **kwargs

    # Using raw cursors with multiple databases
    >>> from django.db import connections
    >>> cursor = connections['my_db_alias'].cursor()

    # some restrictions
    * each one of contenttypes.ContentType, sessions.Session and sites.Site can
        be stored in any database, given a suitable
      router.
    * auth models — User, Group and Permission — are linked together and linked
        to ContentType, so they must be stored in
      the same database as ContentType.
    * admin depends on auth, so their models must be in the same database as
        auth.
    * flatpages and redirects depend on sites, so their models must be in the
        same database as sites.

    # some objects are automatically created just after migrate creates a
    # their table
    * a default Site,
    * a ContentType for each model (including those not stored in that database),
    * three Permission for each model (including those not stored in that database).

    # it isn’t useful to have these objects in more than one database.
    # Therefore, it’s recommended:
    * either to run migrate only for the default database;
    * or to write database router that allows synchronizing these three models
        only to one database.

    # Warning
    # when synchronizing content types to more than one database, primary keys
    # may not match across databases ergo possible data corruption or data loss.



## }}}
## urlpatterns {{{
    # Your `mysite/urls.py`` file should look like this::

    from django.conf.urls import patterns, include, url
    from django.contrib import admin
    admin.autodiscover()

    urlpatterns = patterns('',
        url(r'^polls/', include('polls.urls')),
        url(r'^admin/', include('admin.site.urls')),

    # namespace and name resolution
    url(r'^polls/', include('polls.urls', namespace="polls"))
    url(r'^specifics/(?<poll_id>\d+)/$', vies.detail, name='detail'),

    # userfull shortcut

    urlpatterns = patterns('polls.views',
        url(r'^$', 'index'),
        url(r'^(?P<poll_id>\d+)/$', 'detail'),
        url(r'^(?P<poll_id>\d+)/results/$', 'results'),
        url(r'^(?P<poll_id>\d+)/vote/$', 'vote'),
    )
## }}}
## views {{{
    # how to use render context and order_by
    from django.shortcuts import render
    from polls.models import Poll

    def index(request):
        latest_poll_list = Poll.objects.all().order_by('-pub_date')[:5]
        context = {'latest_poll_list':latest_poll_list}
        return render(request , 'polls/index.html' , context)

    ###############################################################
    # How to raise error 404
    # Make sure to create a 404.html in the template root dir
    # While your at it create 500.html server error
    from django.shortcuts import render # , get_object_or_404
    from django.http import Http404
    # ...
    def detail(request, poll_id):
        try:
            poll = Poll.objects.get(pk=poll_id)
        except Poll.DoesNotExist:
            raise Http404
        # does not need a try, except promotes decoupling
        # poll =  get_object_or_404( Poll, pk=poll_id)
        return render(request, 'polls/detail.html',{'poll':poll})
    ###############################################################
    # reversing Urls
    reverse(viewname[, urlconf=None, args=None, kwargs=None, current_app=None])
    # The reverse() function can reverse a large variety of regular expression
    # patterns for URLs, but not every possible one. The main restriction at the
    # moment is that the pattern cannot contain alternative choices using the
    # vertical bar ("|") character.
    # Note: args and kwargs cannot be passed to reverse() at the same time.
    # If there are any errors whilst importing any of your view functions, it
    # will cause reverse() to raise an error, even if that view function is not
    # the one you are trying to reverse.
    # Note: The string returned by reverse() is already urlquoted.
    reverse_lazy()
    # cases where this function is necessary are:
    * providing a reversed URL as the url attribute of a generic class-based view
    * providing a reversed URL to a decorator (such as the login_url argument
        for the django.contrib.auth.decorators.permission_required() decorator)
    * providing a reversed URL as a default value for a parameter in a
        function’s signature.
    resolve()
    # The resolve() function can be used for resolving URL paths to the
    # corresponding view functions.
    get_script_prefix()
    # you may occasionally need to generate URLs. In that case, you need to be
    # able to find the base URL of the Django project within its Web server. In
    # that case, you can call get_script_prefix(), which will return the script
    # prefix portion of the URL for your Django project. If your Django project
    # is at the root of its web server, this is always "/".
    ###############################################################
    # Class based view
    # At its core, a class-bassed view allows you to respond to different HTTP
    # request method with diffrent class instance methods, instead of
    # conditional branching code inside a singe view function
    # NameOfView.as_view(), a callable entry point to your view, in urlconf
    # returns ae identical to that of function based views, namely some form of
    # HttpResponse, that meant that http shortcuts or TemplateResponse objects
    # are valid to use inside a class-based view
    # when class based views are called, various helpful things are stored in
    # self; the request (self.request), positional arguments (self.args) and
    # named-based arguments (self.kwargs) captured according to the urlconf

    # configure class attributes as keyword arguments to the as_view() call in
    # Urlconf

    # Mixins are a form of multiple inheritance where attributes and behavior
    # of multiple parent classes can be combined
    # Note: you can only inherit from one generic view - that is, only one
    # parent class may inherit from View and rest (if any) should be mixins

    >>> from django.views.generic import TemplateView

    # view as API, when the most recent book was published
    # in Urlconf
    >>> from django.conf.urls import patterns
    >>> from Book.views import BookListView
    >>> urlpatterns = patterns('',
            # ...
            (r'^books/$', BookListView.as_view()),
        )
    # in view
    >>> from django.http import HttpResponse
    >>> from django.views.generic import ListView
    >>> from Book.models import Book
    >>> class BookListView(ListView):
            model = Book
            def head(self, *args, **kargs):
                last_book = self.get_queryset().latest('publication_date')
                response = HttpResponse('')
                # RFC 1123 date format
                response['Last_Modified']=
                    last_book.publication_date.strftime('%a, %d %b %Y %H:%M:%S GMT')
                return response
    # If the view is accessed thru a Get request, a plain-and-simple object
    # list is returned

    # Decorating class based views per instance in urlconf
    >>> from django.contrib.auth.decorators import login_required, permission_required
    >>> from django.views.generic import TemplateView
    >>> from .views import VoteView
    >>> urlpatterns = patterns('',
            # ...
            (r'^about/', login_required(TemplateView.as_view(template_name="secret.html"))),
            (r'^vote/', permission_required('polls.can_vote')(VoteView.as_view())),
        )

    >>> from django.utils.decorators import method_decorator
    >>> from django.views.generic import ListView
    # Useful parameter
    >>> model = Publisher # Shorthand for
    >>> queryset = Publisher.object.all()
    >>> context_object_name = 'Publisher' # Default is lowercase model parameter
            # for example publisher_list in addition to the default
            # object_list
    >>> template_name = 'Publisher/Pub_list.html'
    # decorating methods inside class based views
    >>> @method_decorator(login_required)
    # Note: method_decorator passes *args and **kargs as parameters to the
    # decorated method on the class. If your method does not accept a
    # compatible set of parameters it will raise a TypeError exception

    # get_context_data
    # Generally merges the context data of all parent classes with those of the
    # current class, to preserve this behavior make sure to call
    # get_context_data on the super class, works as expected unless keys are
    # overriden
    >>> from django.views.generic import DetailView
    >>> from books.models import Publisher, Book
    >>> class PublisherDetail(DetailView):
            model = Publisher
            def get_context_data(self, **kwargs):
                # Call super to preserve default context behavior
                context = super(PublisherDetail, self).get_context_data(**kargs)
                context['book_list'] = Book.objects.all()
                return context

    # the model argument is not the only way to specify the objects that the
    # view will operate upun - you can also specify the list of objects using
    # the queryset argument
    # simple example, ordering a list of books by publication_date, with the
    # most recent first
    >>> from django.view.generic import ListView
    >>> from books.models import Book
    >>> class BookList(ListView):
            queryset = Book.objects.order_by('-publication_date')
            context_object_name = 'book_list'
    # Adds object_list to the context
    # If allow_empty is True then display an empty list. If allow_empty is
    # False then raise a 404 error

    # ListView has a get_queryset method we can override, normally it just
    # returns the value of the queryset attribute
    # urls.py
    >>> from django.conf.urls import patterns
    >>> from book.views import PublisherBookList
    >>> urlpatterns = patterns('',
            # ...
            (r'^books/([\w-]+)/$', PublisherBookList.as_view()),
        )
    # view.py
    >>> from django.shortcuts import get_object_or_404
    >>> from django.views.generic import ListView
    >>> from books.models import Book, Publisher
    >>> class PublisherBookList(ListView):
            template_name = 'books/books_by_publisher.html'
            def get_queryset(self):
                self.publisher = get_object_or_404(Publisher, name=self.args[0])
                return Book.objects.filter(publisher=self.publisher)
    # If we wanted we could filter based on the current user self.request.user
    # we could also add the Publisher into the context, so we can use it in the
    # template
            def get_context_data(self, **kwargs):
                # get context from parent
                context = super(PublisherBookList, self).get_context_data(**kwargs)
                # add in the publisher
                context['publisher'] = self.publisher
                return context

    # If we wanted to update a field everytime an object is accessed, or
    # perform some other actction we would override get_object, the method that
    # retrieves the object, and wrap the call
    # urls.py
    >>> from django.conf.urls import patterns
    >>> from book.views import AuthorDetailView
    >>> urlpatterns = patterns('',
            # ...
            (r'^authors/(?P<pk>\d+)/$', AuthorDetailView.as_view(), name='author-detail'),
        )
    # views.py
    >>> from django.views.generic import DetailView
    >>> from django.utils import timezone
    >>> from books.models import Author
    >>> class AuthorDetailView(DetailView):
            queryset = Author.objects.all()

            def get_object(self):
                # call the super class
                object = super(AuthorDetailView, self).get_object()
                # record the last accessed date
                object.last_accessed = timezone.now()
                object.save()
                # return the object
                return object
    # Note: urlconf uses the named group pk, default name DetailView uses to
    # get the value of the primary key used to filter the queryset, to change
    # the name set pk_url_kwarg on the view

    # Form processing with class based view
    # forms.py
    >>> from django import forms
    >>> class ContactForm(forms.Form):
            name = forms.CharField()
            message = forms.CharField(widget=forms.Textarea)

            def send_email(self):
                # send email using self.cleaned_data dictionary
                pass
    # views.py
    >>> from myapp.forms import ContactForm
    >>> from django.views.generic.edit import FormView
    >>> class ContactView(FormView):
            template_name = 'contact.html'
            form_class = ContactForm
            success_url = '/thanks/'

            def form_valid(self, form):
                # This method is called when valid form data has been POSTed
                # It should return an HttpResponse
                form.send_email()
                return super(ContactView, self).form_valid(form)

    # Notes:
    * FormView inherits TemplateResponseMixin so template_name can be used here
    * The default implementation for form_valid() simply redirects to the
        success_url
    # Neat dependencie detachment
    from django.core.urlresolvers import reverse_lazy
    # ...
    success_url = reverse_lazy('named_url')

    # ModelForm
    # generic views will automatically create a ModelForm, as long as which
    # model class to use can be worked out
    * If the model Attribute is given, that model class will be used.
    * If get_object() returns an object, the class of the object will be used
    * If a queryset is given, the model for that queryset will be used
    # Model form views provide a is_valid() implementation that saves the model
    # automatically, can be overriden

    # You don't need to provide a success_url for CreateView or UpdateView,
    # they will use get_absolute_url() on the model object if available

    # If you want to use a custom form class, set form_class on your view
    # Note: When specifying a custom form class, you must still specify the
    # model, even though the form_class may be a ModelForm

    # First we need to implemnt the get_absolute_url() to our Arthur class:
    # models.py
    >>> from django.core.urlresolvers import revers
    >>> from django.db import models
    >>> class Author(models.Model):
            name = models.CharField(max_length=200)

            def get_absolute_url(self):
                return reverse('author-detail', kwargs={'pk': self.pk})
    # views.py
    >>> from django.views.generic import CreateView, UpdateView, DeleteView
    >>> from django.core.urlresolvers import reverse_lazy
    >>> from myapp.models import Author
    >>> class AuthorCreate(CreateView):
            model = Author
            fields = ['name']
    >>> class AuthorUpdate(UpdateView):
            model = Author
            fields = ['name']
    >>> class AuthorDelete(DeleteView):
            model = Author
            success_url = reverse_lazy('author-list')
    # Note: we have to use reverse_lazy() here, not just reverse as the urls
    # are not loaded when the file is imported
    # The fields attribute works the same way as the fields attribute on the
    # inner Meta class on ModelForm, required by 1.8, unless the form is
    # defined in some other way
    # urls.py
    >>> from django.conf.urls import patterns, urls
    >>> from myapp.views import AuthorCreate, AuthorUpdate, AuthorDelete
    >>> urlpatterns = patterns('',
            # ...
            urls(r'author/add/$', AuthorCreate.as_view(), name='author_add')
            urls(r'author/(?<pk>\d+/$', AuthorUpdate.as_view(), name='author_update')
            urls(r'author/(?<pk>\d+/delete$', AuthorDelete.as_view(), name='author_delete')
    # Note: These views inherit SingleObjectTemplateResponseMixin which uses
    # template_name_suffix to construct the template_name based on the model

    # To track the user that created an object using a CreateView, You can use
    # a custom ModelForm to do this, first add a foreign key relation to the
    # model. In the view, ensure that you don't include the foreignkey field,
    # and override form_valid() to add the user
    # in form_valid
    >>> form.instance.created_by = self.request.user
    # Note: handle unathorized users via decorators or in form_valid


#BOOKMARK#

    # Implementing a form that works with ajax request as well as `normal` form
    # POSTs:
    # views.py
    >>> import json
    >>> from django.http import HttpResponse
    >>> from django.views.generic.edit import CreateView
    >>> class AjaxableResponseMixin(object):
            """
            Mixin to add AJAX support to a form.
            Must be used with an object-based FormView (e.g. CreateView)
            """
            def render_to_json_response(self, context, **response_kwargs):
                data = json.dumps(context)
                response_kwargs['content_type'] = 'application/json'
                return HttpResponse(data, **response_kwargs)

            def form_invalid(self, form):
                response = super(AjaxableResponseMixin, self).form_invalid(form)
                if self.request.is_ajax():
                    return self.render_to_json_response(form.errors , status=400)
                else:
                    return response

            def form_valid(self, form):
                # We make sure to call the parent's form_valid() method because
                # it might do some processing (in the case of CreateView, it
                # will call form.save() for example)
                response = super(AjaxableResponseMixin, self). form_valid(form)
                if self.request.is_ajax():
                    data = {
                        'pk': self.object.pk,
                    }
                    return self.render_to_json_response(data)
                else:
                    return response

    >>> class AuthorCreate(AjaxableResponseMixin, CreateView):
            model = Author
            fields = ['name']

    # Using mixins with class based views
    # mixins provide discrete functionality

    # Context and template mixin
    # TemplateResponseMixin provides render_to_response(), this will be called
    # for you in get() method implemented by both TemplateView and DetailView,
    # it is unlikely that you'll need to override it. If you want to return
    # something not rendered by django you'll want to, example see
    # AjaxableResponseMixin

    # render_to_response() itself calls get_template_names(), which by default
    # will just look up template_name on the class-based view; two other mixins
    # (SingleObjectTemplateResponseMixin and MultipleObjectTemplateResponseMixin)
    # override this to provide more flexible defaults when dealing with actual
    # objects

    # ContextMixin
    # Every built in view which needs context data should call
    # get_context_data() passing any data they want to ensure is in there as
    # keyword arguments. get_context_data() returns a dictionary; in
    # ContextMixin it simply returns its keyword arguments, it is common to
    # override this to add more members to the dictionary

    # Building up Django's generic class-based views

    # DetailView depends on SingleObjectMixin, which provides get_object(), it
    # figures out the object ased on the URL of the request (it looks for pk
    # and slug keyword arguments as declared in the urlconf, and looks the
    # object up either based from the model attribute on the view, or the
    # queryset attribute if that's provided). SingleObjectMixin also overrides
    # get_context_data()
    # To make the TemplateResponse, DetailView uses
    # SingleObjectTemplateResponseMixin, which extends TemplateResponseMixin,
    # overriding get_template_names() as discussed above. setting
    # template_name_suffix for template suffix

    # ListView: working with many Django objects
    # To get the objects ListView uses MultipleObjectMixin, which provides both
    # get_queryset() and paginate_queryset()
    # A common reason to override get_queryset() here would be to dynamically
    # vary objects, such as depending on the current user or to exclude posts
    # in the future for a blog
    # MultipleObjectMixin also overrides get_context_data() to include
    # appropriate context variables for pagination (providing dummies if
    # pagination is disabled). It relies on object_list being passed in as a
    # keyword argument, which ListView arranges for it
    # To make the TeplateResponse, ListView then uses
    # MultipleObjectTemplateResponseMixin also overrides get_template_names()
    # to provide a range of options, with the most commonly-used being the
    # template_name_suffix attribute

    # Using Django's class-based view mixins
    # Warning: Not all mixins can be used together, and not all generic class
    # based views can be used with all other mixins
    # you'll have to consider interactions between attributes and methods that
    # overlap between the diffrent classes you're using and how method
    # resolution order will affect which versions of the methods will be called in
    # what order

    # Combining SingleObjectMixin with ListView
    # Paginating a list of objects that are all related (by foreignkey) to
    # another object, One way to do this is by combining SingleObjectMixin with
    # ListView, so that the queryset for the paginated list of books can hang
    # off the publisher object found as the single object. In order to do this,
    # we need two diffrent querysets. We need to explicitly call pass a
    # queryset argument because otherwise the default implementation of
    # get_object() would call get_queryset() which we will override to return
    # Book objects instead of Publisher ones.
    >>> from django.views.generic import ListView
    >>> from django.views.generic.detail import SingleObjectMixin
    >>> from books.models import Publisher
    >>> class PublisherDetail(SingleObjectMixin, ListView):
            paginate_by = 2
            template_name = "books/publisher_details.html"

            def get(self, request, *args, **kwargs):
                self.object = self.get_object(queryset=Publisher.objects.all())
                return super(PublisherDetail, self).get(request, *args, **kwargs)

            def get_context_data(self, **kwargs):
                context = super(PublisherDetail, self).get_context_data(**kwargs)
                context['publisher'] = self.object
                return context

            def get_queryset(self):
                return self.object.book_set.all()
    # Notice how we set self.object within get() so we can use it again later
    # in get_context_data() ang get_queryset(). If you don't set tempate_name,
    # the template will default to the normal ListView choice, which in this
    # case would be "book/book_list.html" because it's a list of books;
    # ListView knows nothing about SingleObjectMixin, so it doesn't have any
    # clue this view is anything to do with a Publisher.

    # Here's the template you'll want to use:
    {% extends "base.html" %}
    {% block content %}
        <h2>Publisher {{ publisher.name }}</h2>

        <ol>
            {% for book in page_obj %}
                <li>{{ book.title }}</li>
            {% endfor %}
        </ol>

        <div class="pagination">
            <span class="step-links">
                {% if page_obj.has_previous %}
                    <a href="?page={{ page_obj.previous_page_number }}">previous</a>
                {% endif %}

                <span class="current">
                    Page {{ page_obj.number }} of {{ page_obj.num_pages }}.
                </span>

                {% if page_obj.has_next %}
                    <a href="?page={{ page_obj.next_page_number }}">next</a>
                {% endif %}
            </span>
        </div>
    {% endblock %}

    # Rule of thumb: Each of your views should only use mixins from one of the
    # groups of generic class-based: detail, list, editing, and date.

    # Using two diffrent class based view from the same url
    >>> from django.view.generic import DetailView
    >>> from django import forms
    >>> from books.models import Author
    >>> class AuthorInterestForm(forms.Form):
            message = forms.CharField()

    >>> class AuthorDisplay(DetailView):
            model = Author

            def get_context_data(self, **kwargs):
                context = super(AuthorDisplay, self).get_context_data(**kwargs)
                context['form'] = AuthorInterestForm()

    # Then the AuthorInterest is a simple FormView, but we have to bring in
    # SingleObjectMixin so we can find the author we're talking about, and we
    # have to remember to set templat_name to ensure that form errors will
    # render the same templates as AuthorDisplay is using on GET
    >>> from django.core.urlresolvers import reverse
    >>> from django.http import HttpResponseForbidden
    >>> from django.views.generic import FormView
    >>> from django.views.generic.detail import SingleObjectMixin
    >>> class AuthorInterest(SingleObjectMixin, FormView):
            templat_name = "book/author_detail.html"
            form_class = AuthorInterestForm
            model = Author

            def post(self, request, *args, **kwargs):
                if not request.user.is_authenticated():
                    return HttpResponseForbidden()
                self.object = self.get_object()
                return super(AuthorInterest, self).post(request, *args, **kwargs)

            def get_success_url(self):
                return reverse('author-detail', kwargs={'pk': self.object.pk})

    # Bringing it together
    >>> from django.views.generic View
    >>> class AuthorDetail(View):
            def get(self, request, *args, **kwargs):
                view = AuthorDisplay.as_view()
                return view(request, *args, **kwargs):

            def post(self, request, *args, **kwargs):
                view = AuthorInterest.as_view()
                return view(request, *args, **kwargs):
    # This approach can also be used with any other generic class-based views
    # or your own class-based views inheriting directly from View or
    # TemplateView, as it keeps the different views as seperate as possible.

    # API where every view should return a JSON instead of rendered html
    >>> import json
    >>> from django.http import HttpResponse
    >>> class JSONResponseMixin(object):
            """
            A mixin that can be used to render a JSON response
            """
            def render_to_json_response(self, context, **response_kwargs):
                """
                Returs a JSON response, transforming 'context' to make the payload
                """
                return HttpResponse(
                    self.convert_context_to_json(context),
                    content_type='application/json',
                    **response_kwargs
                )

            def convert_context_to_json(self, context):
                "Convert the context Dictionary into a JSON object"
                # Note: This is extremely naive; in reality, you'll need to do
                # much more complex handling to ensure that arbitary objects --
                # such as Django model instances or querysets -- can be
                # serialized as JSON
                return json.dumps(context)

    # django.views.generic.detail.BaseDetailView - DetailView before template
    # rendering behavior has been mixed in

    # Class based views behave exactly like views with as_view
    from django.views.generic import View
    # ...
    Class AuthorDetails(View):
        def get(self, request, *args, **kwargs):
            view = AuthorDisplay.as_view()
            return view(request, *args, **kwargs)
    # ...

    # Conditional View Processing
    # etag last_modified condition decorators
    django.views.decorators.http.etag
    django.views.decorators.http.last_modified
    # Use condition when testing for both conditions
    django.views.decorators.http.condition
    # condition decorator signature
    condition(etag_func=None, last_modified_func=None)
    # etag_func should return a string representing the etag for the resource
    # or None if it doesn't exist, last_modified_func should return a standard
    # datetime value representing the last time the resource was modified or
    # None if the resource doesn't exist
## }}}
## models {{{
    # model methods provide row level fuctionalty
    # while manager methods do table wide
    # __str__, __unicode__, get_absolute_url, save, delete
    # full model validation save, full_clean() for manual validation

    # meta class's variables that are useful
        # proxy = true
            # If you want to modify the Python-level behavior of a model,
            # without changing the models fields in any way
            # used for adding managers, model methods and changing sorting order
            # must inherit from one none-abstract model
        # abstract = true
            # through abstract models managers are added
            # when using an abstract class (only) which uses related_name attribute,
            # wich should be unique, on a Foreignkey or ManyToManyField use
            # related_name="%(app_label)s_%(class)s_related"
    # Multiple table inheritance
    class Place(Model):
        # ...
    # Implicid OneToOneField link
    # All the fields of Place will also be available in Restaurant
    class Restaurant(Place):
        # ...
    # There after must specify related_name on all rations.
    class Supplier(Place)
        # Must specifie related_name or error will be raised
        customers = models.ManytoManyField(Restaurant, related_name="supplier")
    ###############################################################
    # The models are going to require an admin page
    # simple admin register aka no foreignkeys or manytomany
    from django.contrib import admin
    from polls.models import Poll

    admin.site.register(Poll)

    # foreignkeys
    from django.contrib import admin
    from polls.models import Choice, Poll

    # StackedInline vs TabularInline (is smaller and better)
    class ChoiceInline(admin.TabularInline):
        model = Choice
        extra = 3

    class PollAdmin(admin.ModelAdmin):
        # characterize and choose which fields to show
        fieldsets = [
            (None, {'fields':['questions']}),
            ('Date information', {'fields':['pub_date'],'classes':['collapse']}),
            ]
        # columns to show in a list view
        list_display = ('question','pub_date','was_published_recently')
        # filter by
        list_filter = ['pub_date']
        # search by field, keep your database happy kiss
        search_fields = ['question']
        inlines = [ChoiceInline]

    admin.site.register(Poll, PollAdmin)

    ###############################################################
    # Sometimes you should collect metadata for manytomany relationships
    # this can be done through an intermediate model
    class Person(models.Model):
        name = models.CharField(max_length=128)
        def __unicode__(self):
            return self.name

    class Group(models.Model):
        name = models.CharField(max_length=128)
        members = models.ManyToManyField(Person, through=’Membership’)
        def __unicode__(self):
            return self.name

    class Membership(models.Model):
        person = models.ForeignKey(Person)
        group = models.ForeignKey(Group)
        date_joined = models.DateField()
        invite_reason = models.CharField(max_length=64)

    # How it is accessed, relationships have to be made 'through'the
    # intermediate model
    >>> ringo = Person.objects.create(name="Ringo Starr")
    >>> paul = Person.objects.create(name="Paul McCartney")
    >>> beatles = Group.objects.create(name="The Beatles")
    >>> m1 = Membership(person=ringo, group=beatles,
            date_joined=date(1962, 8, 16),
            invite_reason= "Needed a new drummer.")
    >>> m1.save()
    >>> # Beatles broken up
    >>> beatles.members.clear()
    # To remove a single relationship, delete the through record
    ###############################################################
    # Reverse urlresolvers
    >>> from django.core.urlresolvers import reverse
    >>> from django.db import models
    >>> class Author(models.Model):
            name = models.CharField(max_length=200)
            def get_absolute_url(self):
                    return reverse('author-detail', kwargs={'pk': self.pk})

## }}}
## Managers {{{
    # manager methods provide table wide functionality
    # A custom Manager method can return anything you want. It doesn’t have to
    # return a QuerySet.

    # Default manager in object
    >>> from django.db import models
    >>> models.Manager()

    # overriding a Manager's base QuerySet, Manager.get_queryset method,
    # should return a QuerySet
    >>> class AuthorManager(models.Manager):
            def get_queryset(self):
                return super(AuthorManager, self).get_queryset().filter(role='A')
    # because get_queryset() returns a QuerySet object, you can use filter(),
    # exclude() and all the other QuerySet methods on it.

    # interesting technique: using multiple managers on the same model. You can
    # attach as many Manager() instances to a model as you’d like.

    # Creating managers with QuerySet methods
    # old way
    >>> class PersonQuerySet(models.QuerySet):
            def authors(self):
                return self.filter(role='A')

            def editors(self):
                return self.filter(role='E')

        class PersonManager(models.Manager):
            def get_queryset(self):
                return PersonQuerySet(self.model, using=self._db)

            def authors(self):
                return self.get_queryset().authors()

            def editors(self):
                return self.get_queryset().editors()

        class Person(models.Model):
            first_name = models.CharField(max_length=50)
            last_name = models.CharField(max_length=50)
            role = models.CharField(max_length=1, choices=(('A', _('Author')),
                ('E', _('Editor'))))
            people = PersonManager()
    # new way
    >>> class Person(models.Model):
            ...
            people = PersonQuerySet.as_manager()

    # Not every QuerySet method makes sense at the Manager level; for instance
    # we intentionally prevent the QuerySet.delete() method from being copied
    # onto the Manager class.

    # Methods are copied according to the following rules:
    1. Public methods are copied by default.
    2. Private methods (starting with an underscore) are not copied by default.
    3. Methods with a queryset_only attribute set to False are always copied.
    4. Methods with a queryset_only attribute set to True are never copied.
    # For example:
    >>> class CustomQuerySet(models.QuerySet):
            # Available on both Manager and QuerySet.
            def public_method(self):
                return
            # Available only on QuerySet.
            def _private_method(self):
                return

            # Available only on QuerySet.
            def opted_out_public_method(self):
                return
            opted_out_public_method.queryset_only = True

            # Available on both Manager and QuerySet.
            def _opted_in_private_method(self):
                return
            _opted_in_private_method.queryset_only = False

    # Whatever features you add to your custom Manager, it must be possible to
    # make a shallow copy of a Manager instance; i.e.,
    # the following code must work:
    >>> import copy
    >>> manager = MyManager()
    >>> my_copy = copy.copy(manager)
    # if you’re overriding __getattr__ or some other private method of your
    # Manager object that controls object state, ensure the above copy still
    # works

    # Django provides a way for custom manager developers to say that their
    # manager class should be used for automatic managers whenever it is the
    # default manager on a model. This is done by setting the
    # use_for_related_fields attribute on the manager class:
    >>> class MyManager(models.Manager):
            use_for_related_fields = True
            # ...
    # A manager that filters results in get_queryset() is not appropriate for
    # use as an automatic manager.


## }}}
## Files {{{
    # Managing Files
    # By default, django store files locally using the MEDIA_ROOT and MEDIA_URL
    # settings.

    # Static files
    # Django provides django.contrib.staticfiles to help manage them
    # to configure staticfiles
    1. Make sure that django.contrib.staticfiles s included in your INSTALLED_APPS
    2. Define setting, STATIC_URL
    3. In your templates, either hardcode the url, or preferably, use the static
        template tag to build the URL for the given relative path by using the
        configured STATICFILES_STORAGE storage, this makes it easier when
        working with CDN
        {% load staticfiles %}
        <img src="{% static "my_app/myexample.jpg" %}" alt="My image"/>
    4. Store your static files in a folder called static in your app. For exmple
        my_app/static/my_app/myexample.jpg

    # STATICFILES_DIRS, a list of directories, in your settings file, where
    # Django will also look for static files

    # namespacing static files; putting static files inside another directory
    # named for the application itself, in the apps static folder
    # my_app/static/my_app/myexample.jpg
    #
    # During Developement one can serve static files and media files, using
    # django.contrib.staticfiles.view.serve(), NOT
    # SUITABLE FOR DEPLOYMENT, example
    # for static
    >>> from django.conf import settings
    >>> from django.conf.urls.static import static
    >>> urlpatterns = patterns('',
            # ... the rest of your URLconf goes here ...
        ) + static(settings.STATIC_URL, document_root=settings.STATIC_ROOT)
    # for media
        ) + static(settings.MEDIA_URL, document_root=settings.MEDIA_ROOT)
    # This helper function only works in debug mode and only if the given
    # prefix is local (e.g. /media/) and not a URL, and it only serves the
    # folder it doesn't perform static file discovery like
    # django.contrib.staticfiles


    # The File Object
    # any time django needs to represent a file it uses
    django.core.files.File

    # Constructing a file, using pythons built in file object
    >>> from django.core.files import File
    # Create a Python fiel object using open()
    >>> f = open('/tmp/hello_world', 'w')
    >>> myfile = File(f)
    # files open like this are not automatically closed
    # The following can be used to close files automatically
    >>> from django.core.files import File
    >>> with open('/tmp/hello_world.txt', 'w') as f:
            myfile = File(f)
            myfile.write('Hello World')
    >>> myfile.closed
    True
    >>> f.closed
    True

    # Django default file storage is given by DEFAULT_FILE_STORAGE setting

    # you can use file storage directly, using the default global storage system
    >>> from django.core.files.storage import default_storage
    >>> from django.core.files.base import ContentFile
    >>> path = default_storage.save('/path/to/file', ContentFile('new content'))
    >>> path
    u'/path/to/file'
    >>> default_storage.size(path)
    11
    >>> default_storage.open(path).read()
    'new content'
    >>> default_storage.delete(path)
    >>> default_storage.exists(path)

    # django's built in FileSystemStorage class (defined in
    # django.core.files.storage) its initializer takes two arguments
    * location: Optional. Absolute path to the directory that will hold the files.
        If omitted, it will be set to the value of your MEDIA_ROOT setting.
    * base_url: Optional. URL that serves the files stored at this location. If
        omitted, it will default to the value your MEDIA_URL

    # The following  will store uploaded files to /media/photos regardless of
    # what your MEDIA_ROOT setting is
    >>> from django.db import models
    >>> from django.core.files.storage import FileSystemStorage
    >>> fs = FileSystemStorage(location='/media/photos')
    >>> class Car(models.Model):
            # ...
            photo = models.ImageField(storag=fs)
    # Custom storage systems work the same way: you can pass them in as the
    # storage argument to a FileField

## }}}
## ContentType {{{
    # Each instance of ContentType has three fields which, taken together,
    # uniquely describe an installed model
    * app_label - Only the last part of the application's Python import path
    * model - The name of the model class
    * name - The verbose_name of the model class
    # Each instance of ContentType has a method that allows you to get from a
    # ContentType instance to the model it represents, or to retrieve objects
    # from that model
    >>> ContentType.get_object_for_this_type(**kwargs)
    # Takes a list of valid lookup arguments for the model ContentType
    # represents, and does a get() lookup on that model, returning the
    # corresponding object
    >>> ContentType.model_class()
    # Returns the model the class represented by this ContentType instance

    # For example, we could look up the ContentType for the User model
    >>> from django.contrib.contenttypes.models import ContentType
    >>> user_type = ContentType.objects.get(app_label="auth", model="User")
    >>> user_type
    <ContentType: user>

    # And then use it to query for a particular User, or to get access to the
    # User model class
    >>> user_type.model_class()
    <class 'django.contrib.auth.models.User'>
    >>> user_type.get_object_for_this_type(username='Guido')

    # Use cases
    * write high-level generic code that performs queries on any installed model
    * You can relate another model to ContentType as a way of tying instances
        of it to particular model classes, and use these methods to get access
        to those model classes

    # ContentType also has a custom manager
    class ContentTypeManager

    clear_cache()
        clears an internal cache used by ContentType to keep track of models for
        for which it has created ContentType instances. You probably won't ever
        need to call this method yourself; Django will call it automatically when
        it's needed

    get_for_id(id)
        Lookup a ContentType by ID. Since this method uses the same shared cache
        as get_for_model(), it's preferred to use this method over the usual
        ContentType.objects.get(pk=id)

    get_for_model(model[, for_concrete_model=True])
        Takes either a model class or an instance of a model, and returns the
        ContentType instance representing that model

    get_for_models(*models[, for_concrete_models=True])
        Takes a variadic number of model classes, and returns a dictionary
        mapping the model classes to the ContentType instances representing them

    get_by_natural_key(app_label, model)
        Returns the ContentType instance uniquely identified by the given
        application label and model name. The primary purpose of this method is
        to allow ContentType objects to be referenced via a natural key during
        deserialization

    # get_for_model example
    >>> from django.contrib.auth.models import User
    >>> user_type = ContentType.objects.get_for_model(User)
    >>> user_type
    <ContentType: user>

    # Generic relations
    # Adding a foreignkey from one of your own models to ContentType allows
    # your model to effectively tie itself to another model class, as in the
    # example of the Permission model above. But it's possible to go one step
    # further and use ContentType  to enable truly generic, "polymorphic",
    # relationships between models

    # Tag system example:
    >>> from django.db import models
    >>> from django.contrib.contenttypes.models import ContentType
    >>> from django.contrib.contenttypes import generic
    >>> class TaggedItem(models.Model):
            tag = models.SlugField()
            content_type = models.ForeignKey(ContentType)
            object_id = models.PositiveIntegerField()
            content_object = generic.GenericForeignKey('content_type', 'object_id')
            # in python 3 def __str__(self):
            def __unicode__(self):
                return self.tag

    class GenericForeignKey
    # There are three parts to setting up a GenericForeignKey:
    * Give your model a ForeignKey to ContentType. The  usual name for this
        field is "content_type"
    * Give your model a field that can store primary key values from the models
        you'll be relating to. For most models, this means a PositiveIntegerField.
        The usual name for this field is "object_id"
    * Give your model a GenericForeignKey, and pass it the names of the two
        fields described above. If these field are named "content_type" and
        "object_id", you can omit this - those are the default field names
        GenericForeignKey will look for

    # for_concrete_model
        # If false, the field will be able to refrence proxy models. Default is
        # True. This mirrors the for_concrete_model argument get_for_model()
    # Note: for models whos primary key is not a integer, you can use CharField
        # but values must be coercibel by get_db_prep_value()

    # Note: when serializing data, such as when creating fixtures for a model
    # that implements generic relations, you should probably be using natural
    # key to uniquely identify related ContentType objects.

    # Each TaggedItem will have a content_object field that returns the object
    # it's related to, and you can also assign to that field or use it when
    # creating TaggedItem
    >>> from django.contrib.auth.models import User
    >>> guido = User.objects.get(username='Guido')
    >>> t = TaggedItem(content_object=guido, tag='bdf1')
    >>> t.save()
    >>> t.content_object
    <User: Guido>

    # You canot use GenericForeignKey fields with filters directly
    # This will fail
    >>> TaggedItem.objects.get(content_object=guido)
    # This will also fail
    >>> TaggedItem.objects.filter(content_object=guido)
    # Also GenericForeignKey does not appear in modelforms

    # Reverse generic relations
    class GenericRelation
    # If you know which models you'll be using most often you can add a
    # "reverse" generic relationship to enable an additional API. For Example:
    >>> class Bookmark(models.Model):
            url = models.URLField()
            tags = generic.GenericRelation(TaggedItem)

    >>> b = Bookmark(url='https://www.djangoproject.com/')
    >>> b.save()
    >>> t1 = TaggedItem(content_object=b, tag='django')
    >>> t1.save()
    >>> t2 = TaggedItem(content_object=b, tag='python')
    >>> t2.save()
    >>> b.tags.all()
    [<TaggedItem: django>, <TaggedItem: python>]
    # If the model which has the GenericForeignKey is using none default names
    # for those fields, you must pass the names of the fields when setting up
    # a GenericRelation to it. For example, if the TaggedItem model referred to
    # above used fields named content_type_fk and object_primary_key to create
    # its generic foreign keys then a generic relationship back to it would need
    # to be defined like so
    >>> tags = generic.GenericRelation(TaggedItem,
            content_type_field='content_type_fk',
            object_id_field='object_primary_key')
    # manual lookup
    >>> b = Bookmark.objects.get(url='https://www.djangoproject.com/')
    >>> bookmark_type = ContentType.objects.get_for_model(b)
    >>> TaggedItem.objects.filter(content_type__pk=bookmark_type.id, object_id=b.id)
    [<TaggedItem: django>, <TaggedItem: python>]

    # Note: if you delete an object that has a GenericRelation, any object
    # which have a GenericForeignKey pointing at it will also be deleted as
    # well
    # Also Note: for now aggregates on generic relations, you'll need to
    # calculate them without using the aggregation API
    #
    # django.contrib.contenttypes.generic module provides
    * BaseGenericInlineFormSet
    * GenericTabularInline GenericStackedInline (subclasses of
        GenericInlineModelAdmin)
    * A formset factory, generic_inlineformset_factory(), for use with
        GenericForeignKey
    class GenericInlineModelAdmin
    # inherits all properties from InlineModelAdmin, adds a couple of its own
    ct_field
    # The name of the ContentType foreign key field on the model. Defaults to
    # content_type
    ct_fk_field
    # The name of the integer field that represents the ID of the related
    # objects. Defaults to object_id

    class GenericTabularInline
    class GenericStackedInline
    # Subclasses of GenericInlineModelAdmin

    generic_inlineformset_factory(model, form=ModelForm, formset=BaseGenericInlineFormSet,
        ct_field="content_type", fk_field="object_id", fields=None, extra=3,
        can_order=False, can_delete=True, max_num=None, formfield_callback=None,
        validate_max=False, for_concrete_model=True)

## }}}
## Authenthication {{{
    # Create superuser, prompts for password
    ./manage.py createsuperuser --username=joe --email=joe@example.com
    # Clear all session data
    >>> Session.objects.all().delete()

    # Profiles, and admin registration for user and profile
    >>> from django.contrib.auth.models import User
    >>> class Employee(model.Models):
            user = models.OneToOneField(User)
            department = models.CharField(max_length=100)

    >>> u = User.objects.get(username='fsmith')
    >>> freds_department = u.employee.department

    >>> from django.contrib import admin
    >>> from django.contrib.auth.admin import UserAdmin
    >>> from django.contrib.auth.models import User
    >>> from my_user_profile_app.models import Employee

    >>> class EmployeeInline(admin.StackedInline):
            model = Employee
            can_delete = False
            verbose_name_plural = 'employee'

    >>> class UserAdmin(UserAdmin):
            inlines = (EmployeeInline, )

    >>> admin.unregister(User)
    >>> admin.register(User, UserAdmin)

    # Authenthication views are interesting

    # Settings.AUTHENTHICATE_BACKENDS list backends to use in authenthication
    # Deprecated setting, prefer using profile model throug ORM OneToOneField
    # Settings.AUTH_PROFILE_MODULE  Profile Model to use, set before first syncdb,
    # AUTH_PROFILE_MODULE = 'accounts.UserProfile'
    # Settings.AUTH_USER_MODEL User Model to use, set before first syncdb
    # Settings.AUTH_USER_MODEL = 'myapp.MyUser'
    # After which, use get_user_model()
    >>> from django.contrib.auth import get_user_model
    # For foreignkey or manytomany fields use AUTH_USER_MODEL
    >>> from django.conf import settings
    >>> from django.db import models
    >>> class Article(models.Model):
            author = models.ForeignKey(settings.AUTH_USER_MODEL)

    # AbstractBaseUser, custom user
    # USERNAME_FIELD, name of field to use as the indentafying field
    # Must have unique = True
    # REQUIRED_FIELD, List of field names prompted when createsuperuser
    # affects no other part of django, Must include blank = False or undefined
    # and all required fields except USERNAME_FIELD, does not work with
    # ForeignKey fields

    # Custom User and Auth forms
    # UserCreationForm, Must be re-written for any custom User model
    # UserChangeForm, Must be re-written for any custom User model
    # AuthenticationForm, Works with any subclass of AbstractBaseUser
    # PasswordResetForm, Assumes Interger primary key, field named email and
    # Boolean field named is_active
    # SetPasswordForm, Works with any subclass of AbstractBaseUser
    # PasswordChangeForm, Works with any subclass of AbstractBaseUser
    # AdminPasswordChangeForm, Works with any subclass of AbstractBaseUser
    #
    # If your custom user extends from
    # django.contrib.auth.models.AbstractUser you can use
    # django.contrib.auth.admin.UserAdmin however if it extends
    # django.contrib.auth.admin.AbstractBaseUser you'll need a custom ModelAdmin
    # class or might be able to use UserAdmin however you'll need to override
    # any defenitions that refer to fields defined in AbstractUser that aren't
    # defined in your custom User Class
    #
    # Custom manager for your User model. If your User model defines username,
    # email, is_staff, is_active, is_superuser, last_login, and date_joined
    # fields, the same as Django's default User, you can just use Django's
    # UserManager, however if this is not the case you'll need to define a
    # custom manager that extends BaseUserManager
    #
    # signals work different in custom user classes
    # When connecting to signals send by the custom User specify the sender
    # with AUTH_USER_MODEL setting
    >>> from django.conf import settings
    >>> from django.db.models.sigals import post_save
    >>> def post_save_receiver(signal, sender, instance, **kwargs):
            pass
    >>> post_save.connect(post_save_receiver, sender=settings.AUTH_USER_MODEL)

    # Django lets you plug in authentication sources, when
    # django.contrib.auth.authenthicate is called django tries to authenticate
    # across all of its authenthication backends specified in
    # AUTHENTHICATION_BACKENDS, authentication backend is a class that
    # implements two required methods: get_user(user_id) and
    # authenticate(**credentials), as well as optional permission related
    # authorization methods
    # {get_group_permissions,get_all_permissions,has_perm,has_module_perms}
    # authenticate should check credentials and return User object that matches
    # those credentials, None if they are invalid
    #
    # Django provides PermissionsMixin, an abstract model giving you all the
    # methods and database fields necessary to support Django's permissions
    # model. It provides {is_superuser,get_group_permissions(obj=None),
    # get_all_permissions(obj=None),has_perm(perm, obj=None),
    # has_perms(perms_list, obj=None),has_module_perms(package_name)}

    # Authenthicate, login
    # Returns a user if authenthication was successfull else None
    >>> from django.contrib.auth import authenthicate, login
    >>>def myview(request):
           username = request.POST['username']
           password = request.POST['password']
           user = authenthicate(username=username, password=password)
           if user is not None:
               if user.is_active:
                   #print("user valid, active and authenthicated")
                   login(request, user)
                   # Redirect to success_url
               else:
                   # print("The password was valid but the account has been disabled")
           else:
               # print("The username and password did not match")

    # RequestContext
    {% if user.is_authenticated %}
        {{ user.username }}
        ...
    {% else %}
        ...
    {% endif %}

    # The currently logged in user's permissions are stored in {{ perms }}
    # Permissions in RequestContext
    {{ perms.foo.can_vote }}
    {% if perms.foo %} # {% if foo in perms %}
        {% if perms.foo.can_vote %} # {% if foo.can_vote in perms %}
        ...
        {% endif %}
    {% else %}
        ...
    {% endif %}

    # Logout
    >>> from django.contrib.auth import logout
    >>> def logout_view(request)
            logout(request)

    # login required decorator note: does not check is active
    # parameter login_url, redirect_field_name default is 'next'
    # settings.LOGIN_URL
    >>> from django.contrib.auth.decorators import login_required
    >>> @login_required
        def myview(request):

    # Meta Permissions for models
    # all it does is create the extra permissions doesn't check
    >>> class myTask(model.Models):
            class Meta:
                Permissions = (
                    ("view_task", "Can see available tasks"),
                    ("change_task_status", "Can change task status"),
                    ("close_task", "Can remove a tasks"),
                )

    # Limiting view access decorators:
    # user_passes_test decorator required arguments, callable
    # that returns true if user is allowed does not check if user is anonymous
    >>> from django.contrib.auth.decorators import user_passes_test
    >>> def email_check(user):
            return '@example.com' in user.email
    >>> @user_passes_test(email_check)
        def myview(request):
        ...
    # Limiting view access on permissions
    # parameter: raise_exception raises 403, login_url
    >>> from django.contrib.auth.decorators import permission_required
    >>> @permission_required('polls.can_vote')
        def myview(request):


    # Changing passwords
    ./manage.py changepassword *username*
    >>> from django.contrib.auth.model import User
    >>> u = User.objects.get(username__exact='john')
    >>> u.set_password('new password')
    >>> u.save()

    # Password hashing and storage
    # The password attribute is a string in this format
    <algorithm>$<iterations>$<salt>$<hash>
    # Algorithms are consulted in the settings.PASSWORD_HASHERS
    # The first listed is default the rest are available
    # Note: consider bcrypt
    # Manually managing user passwords
    >>> check_password(password, encoded)
    >>> make_password(password[, salt, hasher])
    >>> is_password_usable(encoded_password)

    # Permissions
    >>> myuser.groups = [group_list]
    >>> myuser.groups.add(group, group, ...)
    >>> myuser.groups.remove(group, group, ...)
    >>> myuser.groups.clear()
    >>> myuser.user_permissions = [permissions_list]
    >>> myuser.user_permissions.add(permission, permission, ...)
    >>> myuser.user_permissions.remove(permission, permission, ...)
    >>> myuser.user_permissions.clear()

    # Filtering by permissions, where permissions is the permission
    >>> User.objects.filter(user_permissions__in=permissions)
    # thorough filtering by permission
    >>> from django.contrib.auth.models import User, Permission
    >>> from django.db.models import Q
    >>> perm = Permission.objects.get(codename='blogger')
    >>> users = User.objects.filter(
            Q(is_superuser=True)|
            Q(groups__permissions=perm)|
            Q(user_permissions=perm)
            ).distinct()

    # Groups
    class models.Group
    >>> group.permissions = [permission_list]
    >>> group.permissions.add(permission, permission, ...)
    >>> group.permissions.remove(permission, permission, ...)
    >>> group.permissions.clear()

    # Checking permission, for app foo model bar
    # Permissions take the form "<app label>.<permission codename>"
    >>> user.has_perm('foo.add_bar')
    >>> user.has_perm('foo.change_bar')
    >>> user.has_perm('foo.delete_bar')

    # Creating permissions directly
    # The permissions can then be assigned to a User via its user_permissions
    # attribute or to a Group via its permissions attribute
    from myapp.models import BlogPost
    from django.contrib.auth.models import Group, Permission
    from django.contrib.contenttypes.models import ContentType

    content_type = ContentType.objects.get_for_model(BlogPost)
    permission = Permission.objects.create(codename='can_publish',
                                            name='Can Publish Posts'
                                            content_type=content_type)


## }}}
## Signals {{{
    # to receiver a signal, you need to register a receiver
    Signal.connect(reciever[, sender=None, weak=True, dispatch_uid=None])
    * reciever - The callback function which will be connected to this signal
    * sender - specifies a particular sender to receive signals from.
    * weak - Django stores signal handlers as weak references by default. Thus,
        if you reciever is a local function, it may be garbage collected. To
        prevent this, pass weak=False when you call the signals connect() method
    * dispatch_uid - A unique identifier for a signal receiver in case where
        duplicate signals may be sent. A string or any hashable object
        dispatch_uid="My_unique_identifier"

    # Note: callbacks a.k.a. receivers must accept sender and **kwargs

    # Two ways to connect callbacks to signals
    >>> from django.core.signal import request_finished
    >>> from django.dispatch import receiver
    >>> request_finished.connect(my_callback)
    # As a decorator
    >>> from django.core.signal import request_finished
    >>> from django.dispatch import receiver
    >>> @receiver(request_finished)
    >>> def my_callback(sender, **kwargs):
            print("request finished!")

    # use setup() in apps.py for registration of signal handlers,
    # because they get registered before signals need to be sent

    >>> from django.db.models.signals import pre_save
    >>> from django.dispatch import receiver
    >>> from myapp.models import MyModel
    >>> @receiver(pre_save, sender=MyModel)
    >>> def my_handler(sender, **kwargs):
            ...

    # Defining our own signals
    # All signals are django.dispatch.Signal instances
    class Signal([providing_args=list])
    # porviding_args is a list of the names of arguments the signal provide to
    # listeners, however, this is purely documentational

    # for example:
    >>> import django.dispatch
    >>> pizza_done = django.dispatch.Signal(providing_args=["toppings", "size"])

    # there are two ways to send signals in django
    # you must provide the sender argument and may provide as many other
    # keyword arguments as you like
    >>> Signal.send(sender, **kwargs) # Does not catch exceptions
    >>> Signal.send_robust(sender, **kwargs) # Catches excetions

    # Disconnecting signals
    >>> Signal.disconnect([receiver=None, sender=None, weak=True,
            dispatch_uid=None])
    # receiver argument indicates the registered receiver to disconnect. It may
    # be None if the dispatch_uid is used to identify the receiver.
## }}}
## Forms {{{
    # django.forms is Django's form handling library
    # with it you can
    * Display an HTML form with automatically generated form widgets
    * Check submitted data against a set of validation rules
    * Redisplay a form in the case of validation errors
    * Convert submitted form data to the relevant Python data types
    >>> from django import forms
    >>> class ContactForm(forms.Form)
            subject = forms.CharField(max_length=100)
            message = forms.CharField()
            sender = forms.CharField()
            cc_myself = forms.BooleanField(required=False)
    # If your form is going to be used to directly add or edit a Django model,
    # you can use a ModelForm to avoid duplicating your model description

    # standard pattern for processing forms in views
    >>> from django.shortcuts import render
    >>> from django.http import HttpResponseRedirect
    >>> def contact(request)
            if request.method == 'POST' # If the form has been submitted
                form = ContactForm(request.POST) # A form bound to the post data
                if form.is_valid() # All validation rules pass
                    # Process the data in form.cleaned_data dictionary
                    subject = form.cleaned_data['subject']
                    # ...
                    return HttpResponseRedirect('/thanks/') # Redirect after POST
            else:
                form = ContactForm() # An unbound form

            return render(request, 'contact.html', {'form': form,})
    # distnction between bound and unbound forms is important:
    * An unbound form has no data associated with it. When rendered to the user,
        it will be empty or will contain default values
    * A bound form has submitted data, and hence can be used to tell if the data
        is valid. If an invalid bound form is rendered, it can include Inline
        error messages telling the user what data to correct.

    # Once is_valid() returns True, the successfully validated form data will
    # be in the form.cleaned_data dictionary. Already converted into Python types

    # Displaying a form using a template
    # The form only outputs its own fields; it is up to you to provide it's
    # surrounding <form> tags and submit button
    <form action="/contact/" method="post">{% csrf_token %}
    {{ form.as_p }}
    <input type="submit" value="Submit" />
    </form>
    # form.as_p form.as_ul form.as_table

    # If your form includes uploaded files, be sure to include
    # enctype="multipart/form-data"
    # Heres generic code that adds the enctype based on the is_multipart
    # attribute
    <form action="/contact/" method="post"
        {% if form.is_multipart %} enctype="multipart/form-data"{% endif %}>

    # To customize the layout of a rendered form, example
    <form action="/contact/" method="post">
        {{ form.non_field_errors }}
        <div class="fieldWrapper">
            {{ form.subject.errors }}
            <label for="id_subject">Email subject</label>
            {{ form.subject }}
        </div>
        ...
        <p><input type="submit" value="Send message" /></p>
    </form>
    # {{ form.name_of_field }} will produce the HTML needed to display the form
    # widget
    # {{ form.name_of_field.errors }} displays a list of form errors, rendered
    # as an unordered list, might look like
    <ul class="errorlist">
        <li>Sender is required.</li>
    </ul>

    # looping over errors
    {{ if form.subject.errors }}
        <ol>
        {{ for error in form.subject.errors }}
        <li><strong>{{ error|escape }}</li></strong>
        {{ endfor }}
        </ol>
    {{ endif }}

    # looping over form field
    <form action="/contact/" method="post">
        {{ for field in form }}
            <div class="fieldWrapper">
                {{ field.errors }}
                {{ field.label_tag }} {{ field }}
            </div>
        <p><input type="submit" value="Send message" /></p>
    </form>

    # Within this loop the {{ field }} is an instance of BoundField
    # attributes of BoundField

    {{ field.label }}
        # The labe of the field, e.g. Email address
    {{ field.label_tag }}
        # The field's label wrapped in the appropriate HTML <label> tag
        # This includes the form's label_suffix, the default label_suffix is a
        # colon :
        <label for="id_email">Email address:</label>
    {{ field.id_for_label }}
        # The ID that will be used for this field (id_email in the example
        # above). You may want to us this in lieu of label_tag if you are
        # constructing the label manually. also useful in avoiding hardcoding
        # the field's ID in javascript.
    {{ field.value }}
        # The value of the field. e.g. someone@example.com
    {{ field.html_name }}
        # The name of the field that will be used in the input element's name
        # field. This takes the form prefix into account, if it has been set.
    {{ field.help_text }}
        # Any help text that has been associated with the field.
    {{ field.errors }}
        # Outputs a <ul class="errorlist"> containing any validation errors
        # corresponding to this field. You can customize the presentation of the
        # errors with a {% for error in field.errors %} loop. In this case, each
        # object in the loop is a simple string containing the error message.
    {{ field.is_hidden }}
        # This attribute is True if the form field is a hidden field and False
        # otherwise. It's not particularly useful as a template variable, but
        # could be useful in conditional tests such as:
        {% if field.is_hidden %}
            {# Do something special #}
        {% endif %}
    {{ field.field }}
        # The field instance from form class that this BoundField wraps.
        # You can use it to access field attributes, e.g.
        {{ char_field.field.max_length }}

    # It may confused users if you display errors for hidden fields, errors for
    # those fields should be handled diffrently, usually an error in a hidden
    # field is a sign of form tampering.
    #
    # If your site uses the same rendering logic for forms in multiple places,
    # you can reduce duplication by saving the form's loop in a standalone
    # template and using the include tag to reuse it in other template:
    <form action="/contact/" method="post">
        {% include "form_snippet.html" %}
        <p><input type="submit" value="Send message" /></p>
    </form>
    # In form_snippet.html
    {% for field in form %}
        <div clas="fieldWrapper">
            {{ field.errors }}
            {{ field.label_tag}} {{ field }}
        </div>
    {% endfor %}
    # If the form object passed to a template has a different name within the
    # context, you can alias it using the with argument of the include tag
    <form action="/contact/" method="post">
        {% include "form_snippet.html" with form=comment_form %}
        <p><input type="submit" value="Send message" /></p>
    </form>

    # Form and Field validation
    # Validation method order
    1. to_python(): on a Field, checks value to correct datatype and raises
        ValidationError if that is not possible, returns converted value

    2. validate(): on a Field, field-specific Validation that is not suitable
        for a validator, It takes a value that has been coerced to correct
        datatype and raises ValidationError on any error

    3. The run_validators() method on a Field runs all of the field’s
        validators and aggregates all the errors into a single ValidationError.
        You shouldn’t need to override this method.

    4. Field's subclass clean(): responsible for running to_python, validate
        and run_validators in the correct order and propagating their errors.
        Validation will stop if any method raises a ValidationError at any
        time and that error is raised. This method returns the cleaned data
        which is then inserted into the forms cleaned_data dictionary

    5. clean_<fieldname>(): does any cleaning that is specific to that
        particular attribute, this method is not passed any parameters, look up
        the value of the field in self.cleaned_data, at this point it will be a
        python object

        This method should return the cleaned value obtained from cleaned_data,
        regardless of whether it changed anything or not.

    6. Form's subclass clean(): performs any validation that requires access to
        multiple fields from the form at once. The data that this method returns
        is the final cleaned_data attribute for the form, so remember to return
        the full list of cleaned data if you override this method, by default
        Form.clean() just returns self.cleaned_data

        you also have access to the form’s errors attribute which contains all
        the errors raised by cleaning of individual fields. and any error raised
        goes into a special field called '__all__', which can be acessed via
        the non_field_errors()

    # Raising a flexible ValidationError
    >>> raise ValidationError( _('Invalid value: %(value)s'),
            code='invalid',
            params={'value': '42'},
            )
    # Raising multiple errors
    >>> raise ValidationError([
            ValidationError(_('Error 1'), code='error1'),
            ValidationError(_('Error 2'), code='error2'),
            ])
    # typical situation is to raise a ValidationError from, which is turned
    # into a form-wide error that is available through the
    # Form.non_field_errors() method. To add an error message to a particular
    # field from the form’s clean() method, use add_error('field', 'error_msg')
    # The second argument of add_error() can be a simple string, or preferably
    # an instance of ValidationError. See Raising ValidationError for more
    # details. Note that add_error() automatically removes the field from
    # cleaned_data.

    # Django’s form (and model) fields support use of simple utility functions
    # and classes known as validators. These can be passed to a field’s
    # constructor, via the field’s validators argument, or defined on the
    # Field class itself with the default_validators attribute.
    >>> from django.forms import CharField
    >>> from django.core import validators
    >>> class SlugField(CharField):
            default_validators = [validators.validate_slug]
    # or
    >>> slug = forms.CharField(validators=[validators.validate_slug])

    class django.forms.formsets.BaseFormSet
    # A formset is a layer of abstraction to work with multiple forms on the
    # same page. It can be best compared to a data grid.
    >>> from django import form
    >>> class ArticleForm(forms.Form):
            title = forms.CharField()
            pub_date = forms.DateField()

    # To allow the user to create several articles at once
    >>> from django.forms.formsets import formset_factory
    >>> ArticleFormSet = formset_factory(ArticleForm)
    >>> formset = ArticleFormSet()
    # Iterate over the forms in the formset and display them
    >>> for form in formset:
            print(form.as_table)
    # Iterating over the formset will render the forms in the order they where
    # created to change this behavior provide an alternative implementation for
    # __iter__, the form can also be indexed, if you override __iter__ you also
    # need to override __getitem__ to provide matching behavior
    # The number of empty forms that is displayed is controlled by the extra
    # parameter, how many additional forms to show in addition to the number of
    # forms it generated from the initial data
    >>> from django.forms.formsets import formset_factory
    >>> from myapp.forms import ArticleForm
    >>> ArticleFormSet = formset_factory(ArticleForm, extra=2)
    # with initial data
    >>> formset = ArticleFormSet(initial=[
            {'title':u'Django is ow open source',
            'pub_date':datetime.date.today(),}
            ])
    # max_num gives you the ability to limit the maximum number of empty forms
    # the formset will display. Initial data is displayed regardless of
    # max_num. By default max_num only affects how many forms
    # are displayed and does not affect validation. If validate_max=True is
    # passed to the formset_factory(), then max_num will affect validation

    # There is an is_valid() on the formset to provide a convenient way to
    # vaidate all forms in the formset. The formset will ignore extra forms
    # that where not changed
    >>> data = {
            'form-Total_forms':u'1',
            'form-Initial_forms':u'0',
            'form-max_num_forms':u'',
            }
    >>> formset = ArticleFormSet(data)
    >>> formset.is_valid
    True

    >>> formset.errors
    # formset.errors is a list  whose entries correspond to the forms in the
    # formset. for example if two article forms where in the initial data but
    # the second didn't provide the pub_date which is required the error would
    # look like
    [{}, {'pub_date': [u'This field is required .']}]
    # to see how many errors where in the formset, use the total_error_count()
    >>> formset.total_error_count()

    # to check if form data differs from the initial data
    >>> formset.has_changed() # returns Bool

    # management form is used by the formset to manage the collection of forms
    # contained in the formset, an exception will be raised if the
    # management form data is missing
    >>> data = {
            'form-Total_forms':u'1',
            'form-Initial_forms':u'0',
            'form-max_num_forms':u'',
            }
    # If you are adding new forms via javascript make sure to increment the
    # count field in the management_form, also forms marked for deletion are
    # marked via the form-#-DELETE in the POST data. It is expected that all
    # forms are present in the POST data regardless
    # rendering a management form in a template, substituting the name of your
    # formset as appropriate
    {{ my_formset.management_form }}

    # BaseFormSet has a couple of methods that are closely related to the
    # management form
    * total_form_count returns the total number of forms in the formset
    * initial_form_count returns the number of forms  in the formset that where
        pre-filled, and is also used to determine how many forms are required
    # BaseFormSet provides empty_form attribute which returns a form instance
    # with a prefix of __prefix__ for easier use in dynamic forms with
    # JavaScript

    # A formset has a clean method similar to that of a Form class. This  is
    # where you define your own validation that works at the formset level:
    >>> from django.forms.formset import BaseFormSet
    >>> from django.forms.formset import formset_factory
    >>> from myapp.forms import ArticleForm
    >>> class BaseArticleFormSet(BaseFormSet):
            def clean(self):
                """Checks that no two articles have the same title."""
                if any(self.errors):
                    # Don't bother validating the formset unless each form is
                    # valid on its own
                    return
                titles = []
                for form in self.forms:
                    title = form.cleaned_data['title']
                    if title in titles:
                        raise forms.ValidationError("Article in a set must have
                            distinct titles.")
                    titles.append(title)

    >>> ArticleFormSet = formset_factory(ArticleForm, formset=BaseArticleFormSet)
    >>> data = {
            'form-Total_forms':u'1',
            'form-Initial_forms':u'0',
            'form-max_num_forms':u'',
            'form-0-title':u'Test',
            'form-0-pub_date':u'1904-06-16',
            'form-1-title':u'Test',
            'form-1-pub_date':u'1912-06-23',
            }
    >>> formset = ArticleFormSet(data)
    >>> formset.is_valid()
    False
    >>> formset.errors
    [{}, {}]
    # The formset clean method is called after the all the Forms.clean methods
    # have been called. errors can be found non_form_errors
    >>> formset.non_form_errors()
    [u'Articles in a set must have distinct titles.']

    # Validating the number of forms in a formset
    # If validate_max=True is passed to formset_factory(), validation will also
    # check that the number of forms in the data set, minus those marked for
    # deletion, is less than or equal to max_num
    >>> from django.forms.formset import formset_factory
    >>> from myapp.forms import ArticleForm
    >>> ArticleFormSet = formset_factory(ArticleForm, max_num=1, validate_max=True)
    >>> data = {
            'form-Total_forms':u'1',
            'form-Initial_forms':u'0',
            'form-max_num_forms':u'',
            'form-0-title':u'Test',
            'form-0-pub_date':u'1904-06-16',
            'form-1-title':u'Test 2',
            'form-1-pub_date':u'1912-06-23',
            }
    >>> formset = ArticleFormSet(data)
    >>> formset.is_valid()
    False
    >>> formset.errors
    [{}, {}]
    >>> formset.non_form_errors()
    [u'Please submit 1 or fewer forms.']
    # validate_max=True validates against max_num strictly even if max_num was
    # exceeded because the amount of initial data supplied was excessive

    # formset provides two optional parameters can_order and can_delete
    * can_order
        Default: False
        This adds an additional field to each form. This fileld is named ORDER
        and is a forms.IntegerField. form-X-ORDER:u'1'
        acces the ordered formset
        >>> for forms in formset.ordered_forms:
    * can_delete
        Default: False
        Lets you create a formset with the aability to select forms for deletion
        adds a new field to each form named DELETE and is a forms.BooleanField
        form-X-DELETE:u'' acces the deleted forms with
        >>> for form in formset.deleted_forms
        There is no general notion of what it means to deleted a form, its up to
        you to handele the formset.deleted_forms, in ModelFormSet model
        instances for deleted forms will be deleted when
        you call formset.save()

    # Adding additional fields to a formset
    # The formsets base class provides an add_fields method. override this
    # method to add fields or alter the default field/attributes of the order
    # and deletion fields
    >>> from django.forms.formset import BaseFormSet
    >>> from django.forms.formset import formset_factory
    >>> from myapp.forms import ArticleForm
    >>> class BaseArticleFormSet(BaseFormSet):
            def add_fields(self, form, index):
                super(BaseArticleFormSet, self).add_fields(form, index)
                form.fields["my_field"] = forms.CharField()

    >>> ArticleFormSet = formset_factory(ArticleForm, formset=BaseArticleFormSet)

    # Using formsets in views and templates
    >>> from django.forms.formset import formset_factory
    >>> from django.shortcuts import render_to_response
    >>> from myapp.forms import ArticleForm
    >>> def manage_article(request):
            ArticleFormSet = formset_factory(ArticleForm)
            if request.method == 'POST':
                formset = ArticleFormSet(request.POST, request.FILES)
                if formset.is_valid():
                    # Do something with the formset.cleaned_data
                    pass
            else:
                formset = ArticleFormSet()
            return render_to_response("manage_article.html", {'formset': formset})

    # In the template
    <form action="/contact/" method="post">
        {{ formset.management_form }}
        <table>
            {% for form in formset %}
                {{ form }}
            {% endfor %}

        </table>
    </form>

    # calls the as_table method on the form set class
    {{ formset }}

    # If manually rendering form you can render can_delete and can_order
    # parameter with
    {% for form in formset %}
        {% if formset.can_delete %}
            {{ form.DELETE }}
        {% endif %}
        {% if formset.can_order %}
            {{ form.ORDER }}
        {% endif %}
    {% endfor %}

    # Using more than one formset in a view
    >>> from django.forms.formset import formset_factory
    >>> from django.shortcuts import render_to_response
    >>> from myapp.forms import ArticleForm, BookForm
    >>> def manage_articles(request):
            ArticleFormSet = formset_factory(ArticleForm)
            BookFormSet = formset_factory(BookForm)
            if request.method == 'POST':
                article_formset = ArticleFormSet(request.POST, request.FILES,
                    prefix='articles')
                book_formset = BookFormSet(request.POST, request.FILES,
                    prefix='books')
                if article_formset.is_valid() and book_formset.is_valid():
                    # Do something with the formset.cleaned_data
                    pass
            else:
                article_formset = ArticleFormSet(prefix='articles')
                book_formset = ArticleFormSet(prefix='books')
            return render_to_response("manage_article.html", {
                'article_formset': article_formset,
                'book_formset': book_formset,
                })
    # You need to pass corresponding prefixes on both the POST and non-POST
    # cases so that it is rendered and processed correctlty

    # Creating forms from models
    class ModelForm
    # for example
    >>> from django.forms import ModelForm
    >>> from myapp.models import Article
    >>> class ArticleForm(ModelForm)
            class Meta:
                model = Article
                fields = [ 'pub_date', 'headline', 'content', 'reporter' ]
    # It is strongly recommended that you explicitly set all fields that should
    # be edited in the forms using the fields attribute, for security reasons
    # Alternatives like exclude and setting the fields attribute to '__all__'
    # are known to be much less secure and have led to serious exploids on
    # major websites

    # If you set editable=False on the model field, any form created from the
    # model via ModelForm will not include that field

    # Creating a form to add an Article
    >>> form = ArticleForm()
    # Creating a form to eddit an existing Article
    >>> article = Article.objects.get(pk=1)
    >>> form = ArticleForm(instance=article)

    * ForeignKey is represented by django.forms.ModelChoiceField, which is a
        ChoiceField whose choices are a model QuerySet
    * ManyToManyField is represented by django.forms.ModelMultipleChoiceField,
        which is a MultipleChoiceField whose choices are a model QuerySet
    # In addition each genereated form field has attributes set as follows
    * If the model field has blank=True, then required is set to False on the
        form field
    * The form field's label is set to the verbose_name of the model field, with
        the first character capatalized
    * The fields help_text is set to the help_text of the models field
    * If the models field has choices set, then the form field's widget will be
        set to Select, with choices coming from the models field's choices. The
        choices will be normally include the blank choice which is selected by
        default. If the field is required, this forces the user to make a
        selection. The blank choice will not be included if the model field has
        blank=False and an explicit default value (the default value will be
        initially slected instead)

    # Validation on a ModelForm
    # There are two main steps in validating ModelForm:
    1. validating the form
    2. validating the model instance
    # ModelForm validation is triggered implicidly when calling is_valid() or
    # accessing the errors attribute an explicitly when calling full_clean()
    # Model validation (Model.full_clean()) is triggered from within the form
    # validation step, right after the form's clean() method is called

    # You can override the clean() method on a model form to provide additional
    # validation in the same way you can on a normal form.
    # to retain clean vaidation of uniqueness of a model field call the
    # parent's class clean()

    # A subclass of ModelForm can accept an existing model instance as the
    # keyword argument instance; if this is supplied, save will update that
    # instance. if not save() will create a new instance of the specified model
    >>> from myapp.models import Article
    >>> from myapp.forms import ArticleForm
    # Create a form instance from POST data
    >>> f = ArticleForm(request.POST)
    # Save a new Article object from the form's data
    >>> new_article = f.save()
    # Create a form to edit an existing Article, but use
    # POST data to populate the form
    >>> a = Article.objects.get(pk=1)
    >>> f = ArticleForm(request.POST, instance=a)
    >>> f.save()
    # If you call save() with commit=False, then it will return an object that
    # hasn't yet been saved to the database
    >>> f = AuthorForm(request.POST)
    # Save a new Author object from the form's data
    >>> new_author = f.save(commit=False)
    >>> new_author.some_field = 'some_value'
    >>> new_author.save()
    # you'll need to save the m2m relations also if you passed commit=False
    >>> f.save_m2m()

    # Any attemp to save a ModelForm with missing required fields will fail, if
    # the model does not provide default values. To avoid this failure you must
    # instantiate your model with initial values for the missing, but required
    # fields
    >>> class PartialAuthorForm(ModelForm)
            class Meta:
                model = Author
                exclude = ['title']
    >>> author = Author(title='Mr')
    >>> form = PartialAuthorForm(request.POST, instance=author)
    >>> forms.save()
    # Alternatively, you can use save(commit=False) and manually set any extra
    # required fields:
    >>> form = PartialAuthorForm(request.POST)
    >>> author = form.save(commit=False)
    >>> author.title = 'Mr'
    >>> author.save()

    # validating unique together
    >>> from django.core.exceptions import ValidationError
    [...]
    >>> class ExistingListItemForm(ItemForm):
            def __init__(self, for_list, *args, **kwargs):
                super().__init__(*args, **kwargs)
                self.instance.list = for_list
            def validate_unique(self):
                try:
                    self.instance.validate_unique()
                except ValidationError as e:
                    e.error_dict = {'text': [DUPLICATE_ITEM_ERROR]}
                    self._update_errors(e)

    # Override the field's widget
    # Here the widget for the name field is represented by <textarea> instead of
    # its default <input type="text">
    >>> from django.forms import ModelForm, Textarea
    >>> from myapp.models import Author
    >>> class AuthorForm(ModelForm)
            model = Author
            fields = ['name', 'title', 'birth_date']
            widgets = {
                'name': Textarea(attrs={'cols': 80, 'rows': 20}),
            }
    # The widgets dictionary accepts either widget instances (e.g.,
    # Textarea(...)) or classes (e.g., Textarea)
    # It is also possible to specify labels, help_text, error_messages
    # attributes of the inner Meta class if you want to further customize a
    # field
    >>> class AuthorForm(ModelForm):
            model = Author
            fields = ['name', 'title', 'birth_date']
            labels = {
                'name': _('Writer'),
            }
            help_texts = {
                'name': _('Some useful help text.'),
            }
            error_messages = {
                'name': {
                    'max_length': _("This writer's name is too long."),
                },
            }

    # If you want complete control over a field, by declaratively specifying
    # fields like you would in a regular Form
    >>> from django.forms import ModelForm
    >>> from myapp.models import Article
    >>> class ArticleForm(ModelForm):
            slug = MySlugFormField()
            class Meta:
                model = Article
                fields = ['pub_date', 'headline', 'content', 'reporter', 'slug']
    # declaratively setting a fields validators
    >>> from django.forms import ModelForm, CharField
    >>> from myapp.models import Article
    >>> class ArticleForm(ModelForm):
            slug = CharField(validators=[validate_slug])
            class Meta:
                model = Article
                fields = ['pub_date', 'headline', 'content', 'reporter', 'slug']
    # Fields define declaratively do not draw their attributes from the
    # corresponding model, if you want matching behavior, you must set the
    # corresponding arguments explicitly when declaring the form field

    # Localize data for a field
    # use localized_fields attribute on the Meta class, if localized_fields is
    # set to '__all__' all fields will be localized

    # Form inheritance
    # As with basic forms, you can extend and reuse ModelForms by inheriting
    # them

    >>> class EnhancedArticleForm(ArticleForm):
            def clean_pub_date(self):
            ...
    # This creates a form that behaves identically to ArticleForm, except there
    # is some extra validation and cleaning for the pub_date field

    # You can also subclass the parent's Meta inner class if you want to change
    # the Meta.fields or Meta.exclude list
    >>> class RestrictedArticleForm(EnhancedArticleForm):
            class Meta(ArticleForm.Meta)
                exclude = ['body',]
    # Normal python name resolution rules apply

    # ModelForm factory function
    # instead of using class defenitions, if you don't have many customizations
    >>> from django.forms.models import modelform_factory
    >>> from myapp.models import Book
    >>> BookForm = modelform_factory(Book, fields=("author", "title"))
    # Making modifications on exiting forms
    >>> from django.forms import Textarea
    >>> Form = modelform_factory(Book, form=BookForm,
            wdgets={"title":textarea()})
    # Enabling localization for specific fields
    >>> Form = modelform_factory(Author, form=AuthorForm,
            localized_fields=("birth_date",))

    # Model formsets
    class models.BaseModelFormSet
    # example
    >>> from django.forms.models import modelformset_factory
    >>> from myapp.models import Author
    >>> AuthorFormSet = modelformset_factory(Author)
    # This works just like a regular formset
    >>> formset = AuthorFormSet()
    >>> print(formset)
    # modelformset_factory uses formset_factory to generate formsets
    # By default, when you create a formset from a model,the formset will use a
    # queryset that includes all objects in the model( e.g.
    # Author.objects.all()). You can override this behavior by using the
    # queryset argument
    >>> formset = AuthorFormSet(queryset=Author.objects.filter(name__startswith='0'))
    # Alternative you can create a subclass that sets self.queryset in __init__
    >>> from django.forms.models import BaseModelFormSet
    >>> from myapp.models import Author
    >>> class BaseAuthorFormSet(BaseModelFormSet):
            def __init__(self, *args, **kargs):
                super(BaseAuthorFormSet, self).__init__(*args, **kargs)
                self.queryset = Author.objects.filter(name__startswith='0')
    # Then, pass your BaseAuthorFormSet class to the factory function
    >>> AuthorFormSet = modelformset_factory(Author, formset=BaseAuthorFormSet)
    # If you want to return a formset that doesn't include any pre-existing
    # instances of the model, you can specify an empty queryset
    >>> AuthorFormSet(queryset=Author.objects.none())

    # Specify a custom model form
    >>> class AuthorForm(forms.ModelForm):
            class Meta:
                model = Author
                fields = ('name', 'title')

            def clean_name(self):
                # custom validation for the name field
                ...
    # Then, pass your model form to the factory function
    AuthorFormSet = modelformset_factory(Author, form=AuthorForm)

    # By default, a model formset uses all fields in the model that are not
    # marked with editable=False, to override this
    >>> AuthorFormSet = modelformset_factory(Author, fields=('name', 'title'))
    >>> AuthorFormSet = modelformset_factory(Author, exclude=('birth_date',))
    >>> AuthorFormSet = modelformset_factory(Author,
            widgets={'name': Textarea(attrs={'cols': 80, 'rows': 20})})
    >>> AuthorFormSet = modelformset_factory(Author, localized_fields=('value',))

    # Initial values
    # specify initial data for forms in the formset by specifying an initial
    # parameter when instantiating the model formset class returned by
    # modelformset_factory

    # Create a formset instance with Post data
    >>> formset = Authorformset(request.POST)
    # Assuming all is valid, save the data
    >>> instances = formset.save()
    # something needs to be done with each form in the formset before saving
    >>> instances = formset.save(commit=False)
    # Note: while calling formset.save(commit=Fals) does not save new or
    # changed objects to the database, it does delete objects that have been
    # marked for deletion. This behavior will be corrected in django 1.7
    >>> for instance in instances
            # Do something
            instance.save()
    # If your formset contains a ManyToManyField, you'll also need to call
    >>> formset.save_m2m()

    # Limiting the number of editable objects
    # you can use the max_num and extra parameters to modelformset_factory() to
    # limit the number of extra forms displayed, max_num does not prevent
    # existing objects from being displayed
    # If the value of max_num is greater than the number of existing related
    # objects, up to extra additional blank forms will all be added to the
    # formset, so long as the total number of forms does not exceed max_num

    # Using a model formset in a view
    >>> from django.forms.models import modelformset_factory
    >>> from django.shortcuts import render_to_response
    >>> from myapp.models import Author
    >>> def manage_authors(request):
            AuthorFormSet = modelformset_factory(Author)
            if request.method == 'POST':
                formset = AuthorFormSet(request.POSTS, request.FILES)
                if formset.is_valid():
                    formset.save()
                    # Do something
            else:
                formset = AuthorFormSet()
            return render_to_response("manage_authors.html",{
                    "formset": formset,
                })
    # The only diffrence from a normal formset is that we call formset.save()
    # to save the data to the database

    # ModelFormSet() clean method
    # Default will validate that none of the unique constrains are violated,
    # If ou want to override the clean method on a ModelFormSet want to
    # maintain this validation, you must call the parent class's clean method
    >>> from django.forms.models import BaseModelFormSet
    >>> class MyModelFormSet(BaseModelFormSet):
            def clean(self):
                super(MyModelFormSet, self).clean()
                # example custom validation across forms in the formset
                for form in self.forms:
                    # your custom form validation
                    # ...
    # Note by this time you reach this step, individual model instances have
    # already been created for ieach Form.Modifying a value in
    # form.cleaned_data is not sufficient to affect the saved value. If you
    # wish to  modify a value in ModelFormSet.clean() you must modify
    # form.instance:
    >>> from django.forms.models import BaseModelFormSet
    >>> class MyModelFormSet(BaseModelFormSet):
            def clean(self):
                super(MyModelFormSet, self).clean()
                for form in self.forms:
                    name = form.cleaned_data['name'].upper()
                    form.cleaned_data['name'] = name
                    form.instance.name = name

    # If you override the queryset argument do it in both the POST and GET cases

    # There are three ways to render a formset
    # First, you can let the formset do most of the work
    <form action="/contact/" method="post">
        # calls the as_table method on the form set class
        {{ formset }}
    </form>

    # Second, you can manually render the formset, but let the form deal with
    # itself
    <form action="/contact/" method="post">
        {{ formset.management_form }}
        <table>
            {% for form in formset %}
                {{ form }}
            {% endfor %}
        </table>
    </form>

    # Third, you can manually render each field
    <form action="/contact/" method="post">
        {{ formset.management_form }}
        <table>
            {% for form in formset %}
                {% for field in for %}
                    {{ field.label_tag }} {{ field }}
                {% endfor %}
            {% endfor %}
        </table>
    </form>
    # If you don't iterate over the fields with a {% for %} loop, you'' need to
    # render the primary key field

    # Inline formsets
    class models.BaseInlineFormSet
    # Inline formset is a small abstraction layer on top of model formsets.
    # These simplify the case of working with related objects via foreignkey
    >>> from django.db import models
    >>> class Author(models.Model):
            name = models.CharField(max_length=100)
    >>> class Book(models.Model):
            author = models.ForeignKey(Author)
            title = models.CharField(max_length=100)
    # If you want to create a formset that allows you to edit books belonging
    # to a particular author, you could do this:
    >>> import django.forms.models import inlineformset_factory
    # think of as a's relation to b
    >>> BookFormSet = inlineformset_factory(Author, Book)
    >>> author = Author.objects.get(name=u'Mike Royko')
    >>> formset = BookFormSet(instance=author)
    # Note: inlineformset_factory() uses modelformset_factory and marks
    # can_delete=True

    # To override methods on InlineFormSet, subclass BaseInlineFormSet rather
    # than BaseModelFormSet
    >>> from django.forms.models import BaseInlineFormSet
    >>> class CustomInlineFormSet(BaseInlineFormSet):
            def clean(self):
                super(CustomInlineFormSet,self).clean()
                # example custom Validation across forms in the formset
                for form in self.forms:
                    # your custom form validation
    # Then when you create your inline formset, pass in the optional argument
    # formset
    >>> from django.forms.models import inlineformset_factory
    >>> BookFormSet = inlineformset_factory(Author, Book,
            formset=CustomInlineFormSet)
    >>> author = Author.objects.get(name=u'Mike Royko')
    >>> formset = BookFormSet(instance=author)

    # ore than one foreign key to the samme model, you;ll need to resolve the
    # ambiguity by setting fk_name attribute in inlineformset_factory
    >>> class Friendship(models.Model):
            from_field = models.ForeignKey(Friend)
            to_field = models.ForeignKey(Friend)
            length_in_months = models.IntegerField()
    >>> FriendshipFormSet = inlineformset_factory(Friend, Friendship,
            fk_name="from_field")

    # Inline formset in a view
    >>> def manage_book(request, author_id):
            author = Author.objects.get(pk=author_id)
            BookInlineFormSet = inlineformset_factory(Author, Book)
            if request == "POST":
                formset = BookInlineFormSet(request.POST, request.FILES,
                    instance=author)
                if formset.is_valid():
                    formset.save()
                    # Do something. Should generally end with a redirect.
                    return HttpResponseRedirect(author.get_absolute_url())
            else:
                formset = BookInlineFormSet(instance=author)
            return render_to_response("manage_books.html", {
                    "formset": formset,
                })

    # Form Assets (the Media class)
    # static defenition inner Media class, properties define requirements
    >>> from django import forms
    >>> class CalendarWidget(forms.TextInput):
            class Media:
                css = {
                    'all': ('pretty.css',)
                }
                js = ('animations.js', 'actions.js')
    # Static defenition is converted to a widget property named media
    >>> w = CalendarWidget()
    >>> print(w.media)
    ...
    # inner Media class, parameters
    * css: a dictionary, the key is output media types: 'all', 'aural', 'braille',
        'embossed', 'handheld', 'print', 'projection', 'screen', 'tty' and 'tv'.
        If a group of CSS files are appropriate for multiple output media types,
        the dictionary key can be a comma seperated list of output media types.
    * js: A tuple describing the JavaScript files
    * extend: A Boolean defining the inheritance behavior for Media declaration
        default is True, meaning it inherits all assets associated with the
        parent class, False disables this behavior

    # dyanamic properties, give more controll to what is inherited
    # static definition in dyanamic fashion. define the media property, that
    # returns an instance of forms.Media; css and js arguments are in the same
    # format as that used in a static media
    # defenition
    >>> class CalendarWidget(forms.TextInput):
            def _media(self):
                return forms.Media(css={'all': ('pretty.css',)},
                    js=( 'animation.js', 'actions.js'))
            media = property(_media)
    # paths can be relative or absolute, to define assets. If a path starts
    # with /, http:// or https:// it will be interpreted as an absolute path
    # STATIC_URL and STATIC_ROOT refer to static files (images, CSS, javascript,
    # etc.) if STATIC_URL is NONE django falls back to MEDIA_URL

    # subscript operator to filter out a medium of interest
    >>> print(w.media['css'])
    # object returned is a new Media object

    # Media objects can be added, union operation
    >>> print(w1.media + w2.media)

    # Forms can also have media definition, same rules apply

## }}}
## Template {{{
    # A template is simply a text file. It can generate any text-based format
    # (HTML, XML, CSV, etc.)
    # Dont trust user fed variables by default html tags are escaped
    # the safe filter disables this behavior
    {% extends "base_generic.html" %}

    # variables look like this, variable names cannot have spaces or punctuation
    {{ variable }}

    # a (.) acesses variable attributes, lookups behind the scenes
    * Dictionary lookup
    * Attribute lookup
    * Method call
    * List-index lookup

    # an objects url
    <a href="{{ object.get_absolute_url }}">{{ object.name }}</a>

    # filters
    # modifies variables for display
    {{ name|lower }}
    # filters can be chained
    {{ text|escape|linebreaks }}
    # Some filters take arguments
    {{ bio|truncatewords:30 }}

    # default: If a variable is False or empty use given default
    {{ value|default:"nothing" }}
    # length: returns the length of the value. works with strings and lists
    {{ value|length }}
    # striptags: strips all [X]HTML tags
    {{ value|striptags }}

    # Tags
    # they look like this
    {% tag %}
    # loop over items in an array
    <ul>
    {% for athlete in athlete_list %}
    # forloop.counter indicates how many times the for tag has gone through
    # its loop
        <li> {{ athlete.name }} </li>
    {% empty %}
        <li> No athletes </li>
    {% endfor %}
    </ul>
    # if, elif, else
    # filters and other operators in if tags
    {% if athlete_list|length > 1 %}

    # Retrieving an instance from a ModelChoiceField
    {{ form.instance.field_name }}

    # block and extend, reduce boilerplate
    # common way of using inheritance, is the following three level inheritance
    * Create a Base.html template that holds the main look-and-feel of your site
    * Create a Base_SECTIONNAME.html template for each "section" of your site.
        for ex. base_news.html. These templates all extend base.html and include
        section-specific styles/design.
    * Create individual templates for each type of page, such as a news article
        or blog entry. These templates extend the appropriate section template.
    # The extend tag must be the first template tag, otherwise inheritance wont
    # work
    # The more blocks the better
    # To get the contents of the parent block use, data inserted this way will
    # not be automatically escaped because it was already escaped, if necessary
    # in the parent
    {{ block.super }}
    # endblocks can be named, helps discern which block is ending
    {% block content %}
    {% endblock content %}

    # comments have the syntax, comments can contain any template code
    {# comment goes here #}

    # by default in Django, every template automatically escapes the output of
    # every variable tag.

    # To disable auto escaping for an individual variable, use the safe filter
    {{ value|safe }}
    # To disable auto escaping for a section
    {% autoescape off %}
    {% endautoescape %}
    # autoescape can be nested
    {% autoescape off %}
        {% autoescape on %}
        {% endautoescape %}
    {% endautoescape %}
    # The autoescape tag passses its effects onto Templates that extend the
    # current one as well as templates included via the include tag, just like
    # all block tags
    {% autoescape off %}
        {% block content %}
            {{ value|escape }}
        {% endblock content %}
    {% endautoescape %}

    # load tags from apps with the load tag
    {% load comments %}
    # tags loaded in this way are not available to child or parent templates,
    # only to the current template

    # Templates for programmers




    # If a vatiable has side effects that would be undesirable if accessed via
    # the template system, set its alters_data attribute to True
    >>> def sensitive_function(self):
            self.database_record.delete()
    >>> sensitive_function.alters_data = True
    # To completely disable template calls set do_not_call_in_templates
    # attribute on the cllable to True, the template system would than act as
    # if your variable is not callable (allowing you to access attributes of
    # the callable)
    >>> sensitive_function.do_not_call_in_templates = True

    class RequestContext

    # Django comes with a special Context class, django.template.RequestContext,
    # that acts slightly differently than the normal django.template.Context.
    # The first difference is that it takes an HttpRequest as its first argument.
    # The second difference is that it automatically populates the context with
    # a few variables, according to your TEMPLATE_CONTEXT_PROCESSORS setting.

    # The TEMPLATE_CONTEXT_PROCESSORS setting is a tuple of callables
    # – called context processors – that take a request object as their argument
    # and return a dictionary of items to be merged into the context.

    # Also, you can give RequestContext a list of additional processors, using
    # the optional, third positional argument, processors.
    >>> from django.http import HttpResponse
    >>> from django.templates import RequestContext
    >>> def ip_address_processor(request):
            return {'ip_address': request.META['REMOTE_ADDR']}
    >>> def some_view(request):
            # ...
            c = RequestContext(request, {
                'foo': 'bar',
                }, [ip_address_processor])
            return HttpResponse(t.render(c))


## }}}
## Tests {{{
    # Selenium, for web rendering and javascript testing
    # Consider using LiveServerTestCase with it

    # Any test that instantiates an instance of User will fail if the User
    # model has been swaped out, this inludes fixtures

    # Django has a test client for debuging from the interactive shell
    >>> from django.test.utils import setup_test_environment
    >>> setup_test_environment()
    # Create the database
    >>> from django.test.runner.DiscoverRunner import setup_databases
    >>> setup_databases()
    >>> # ...
    >>> from django.test.client import Client
    >>> # for test.py 'from django.test import TestCase' has a test client
    >>> # self.client.get('/url/') from a test class function
    >>> client = Client()
    >>> response = client.post('/login/', {'username': 'john',
            'password': 'smith'}) #, HTTP_USER_AGENT='Mozilla/5.0')
    >>> response.status_code
    # If you set follow to True the client will follow any redirects and a
    # redirect_chain attribute will be set in the response object containing
    # tuples of the intermediate urls and status codes.
    >>> response = client.get('/redirect_me/', follow=True)
    >>> response.redirect_chain
    [('http://testserver/next/', 302), ('http://testserver/final/', 302)]
    # The client login, cookies and session data to access login views
    # Provided as kwargs, returns true if accepted
    >>> client.login(**credentials)
    >>> response = client.get('/url/')
    >>> response.status_code
    >>> response.content
    >>> response.context['latest_poll_list']
    >>> response.context_data['latest_poll_list']
    # This bit goes in a class where self.client is set to the test client in
    # its setUp method and SESSION_KEY is from
    >>> from django.contrib.auth import SESSION_KEY
    >>> self.assertEqual(self.client.session[SESSION_KEY], user.pk)

    # Place test in test.py
    # python manage.py test polls
    # testing published recently future bug

    import datetime
    from django.test import TestCase
    from django.utils import timezone
    from polls.models import Poll
    # Used for namespace base url resolution
    from django.core.urlresolvers import reverse

    def create_poll(question, days):
        """
        creates polls
        """
        return Poll.objects.create(question=question,
            pub_date=timezone.now() + datetime.timedelta(days=days))

    class PollMethodTests(TestCase)
        def test_was_published_recently_with_future_poll(self):
            """
            was_published_recently() should return False for polls whose
            pub_date is in the future
            """
            future_poll = Poll(pub_date=timezone.now() + datetime.timedelta(days=30))
            self.assertEqual(future_poll.was_published_recently(),False)

        def test_index_viw_with_a_future_poll(self)
            create_poll(question="Future poll.", days=30)
            response = self.client.get(reverse('polls:index'))
            self.assertContains(response, "No polls are available", status_code=200)
            self.assertQuerysetEqual(response.context['latest_poll_list'],[])
            # If we where expecting to see the poll in the context it would look like this
            # self.assertQuerysetEqual(response.context['latest_poll_list'],['<Poll:Future poll.>'])
            # self.assertTemplateUsed(response, 'expected.html')
            # ...

            # asserting an error is raised
            with self.assertRaises(ValidationError):
                item.full_clean()
                item.save()

            # asserting a template was used, context style
            with self.assertTemplateUsed(template_name='index.html'):
                 render_to_string('index.html')

        # Here more tests would go

    # Some Django test assertions
    SimpleTestCase.assertTemplateUsed(response, template_name, msg_prefix='',
        count=None)
    SimpleTestCase.assertTemplateNotUsed(response, template_name, msg_prefix='')
    SimpleTestCase.assertRedirects(response, expected_url, status_code=302,
        target_status_code=200, msg_prefix='', fetch_redirect_response=True)
    SimpleTestCase.assertInHTML(needle, haystack, count=None, msg_prefix='')
    # query asserts
    TransactionTestCase.assertQuerysetEqual(qs, values, transform=repr,
        ordered=True, msg=None)
    TransactionTestCase.assertNumQueries(num, func, *args, **kwargs)
    # can also use this as a context manager:
    >>> with self.assertNumQueries(2):
             Person.objects.create(name="Aaron")
             Person.objects.create(name="Daniel")
    # If a "using" key is present in kwargs it is used as the database alias
    # for which to check the number of queries. If you wish to call a function
    # with a using parameter you can do it by wrapping the call with a lambda to
    # add an extra parameter:
    >>> self.assertNumQueries(7, lambda: my_function(using=7))

    # Calling a test granuarly
    >>> python manage.py test  polls.PollMethodTests.test_was_published_recently_with_future_poll
    # Test with python warnings enabled
    >>> python -Wall manage.py test  polls

    # Dump and Load
    # place in app fixtures directory and use in fixtures class attribute
    >>> ./manage.py dumpdata
    >>> ./manage.py loaddata

    # useful attributes
    # urls = 'Myapp.testurls' # sets a urlconf to use in test case
    # multi_db = True # flushes all databases, fixtures loaaded into all databases

    # Django settings can be change for test
    >>> with self.settings(LOGIN_URL='/other/login/'):
    # overriding settings
    # the override_settings decorator can be used in test functions and classes
    >>> from django.test import override_settings
    # django.contrib.auth.test.custome_user.CustomeUser, email field as
    # username and has a basic admin-compliant permissions setup
    >>> @override_settings(AUTH_USER_MODEL='auth.CustomeUser')
    # django.contrib.auth.test.custome_user.ExtensionUser, extends AbstractUser
    # adding a date_of_birth field
    >>> @override_settings(AUTH_USER_MODEL='auth.ExtensionUser')
    # You can also simulate the absence of a setting by deleting it after
    # settings have been overridden, like this:
    >>> @override_settings()
    >>> def test_something(self):
            del settings.LOGIN_URL
            ...
    # modifying settings
    # the modify_settings decorator can be used in test functions and classes
    >>> from django.test import modify_settings
    >>> @modify_settings(INSTALLED_APPS={'remove': 'django.contrib.sites'})
    # or
    >>> with self.modify_settings(MIDDLEWARE_CLASSES={
            'append': 'django.middleware.cache.FetchFromCacheMiddleware',
            'prepend': 'django.middleware.cache.UpdateCacheMiddleware',
            'remove': [
                'django.contrib.sessions.middleware.SessionMiddleware',
                'django.contrib.auth.middleware.AuthenticationMiddleware',
                'django.contrib.messages.middleware.MessageMiddleware',
                ],
        }):
    # Django provides the django.test.signals.setting_changed signal that lets
    # you register callbacks to clean up and otherwise reset state when
    # settings are changed.

    # Skipping tests decorators
    >>> from django.contrib.auth.test.utils import skipIfCustomUser
    # Test will not be executed if the database supports feature
    skipIfDBFeature(feature_name_string)
    # Test will be executed if the database feature is supported
    skipUnlessDBFeature(feature_name_string)
    # full list of database strings, django.db.backends.BaseDatabaseFeatures

    # Testing email, important attribute
    >>> from django.core import mail
    >>> ...
    >>> self.assertEqual(len(mail.outbox), 0)
    >>> self.assertEqual(mail.outbox[0].subject, 'something')
    # Testing the SMTP server with python, dump email headers and body to
    # terminal, set EMAIL_HOST and EMAIL_PORT accordingly
    python -m smtpd -n -c DebuggingServer localhost:1025


    # Testing Master Slave DB
    # Under testing, treated as a mirror of default.
    # because they are actually the same database, not because there is data
    # replication between the two databases.
    ...
    'TEST_MIRROR': 'default',
    # Control database creation order by declaring dependencies
    'TEST_DEPENDENCIES': ['default'],
    ...

    # Test Code coverage, coverage.py
    coverage run --source='.' manage.py test myapp
    coverage report

    # list of dictionaries in order of query execution.
    # Each dictionary has the following
    # ''sql''  -- raw sql statement
    # ''time'' -- time of execution
    >>> from django.db import connection
    >>> connection.queries
## }}}
## Cache {{{
    # Memcached, python bindings are python-memcached and pylibmc
    # settings.CACHE
    >>> CACHE = {
            'default': {
                'BACKEND': 'django.core.cache.backends.memcached.MemcachedCache',
                'LOCATION': '127.0.0.1:11211',
                # 'LOCATION' can also be a unix socket file
                # Cache can be shared over multiple Memcached instances
                # 'LOCATION': ['172.19.26.240:11211',
                #              '172.19.26.241:11212',
                #              '172.19.26.242:11213',
                # ]
            }
        }

    # Cache arguments
    >>> TIMEOUT # Timeout to use with the cache bacend defaults to 300 sec
    >>> OPTIONS # An option dict that should be passed directly to the backend
    >>> KEY_PREFIX # A Key prefix, string
    >>> VERSION # Default version key to be generated ny django
    >>> KEY_FUNCTION # Dotted path, function that defines how to compose a prefix

    # Memcached limits key length to 250 chars error will be raised
    # django.core.cache.backends.base.CacheKeyWarning is raised if key that
    # would cause an error in memcached is used
    # Custom key func follows this prototype
    >>> def make_key(key, key_prefix, version)
            return ":".join(key_prefix, str(version), key)

    # Another possible backend is the db
    # 'django.core.cache.backends.db.DatabaseCache'
    # Routing required if working with multiple db and using this backend if
    # you dont default will be used for caching
    # Another possible backend is the filesystem
    # 'django.core.cache.backends.filebased.FileBasedCache'
    # Another possible backend is the locmem, not a good choice for production
    # 'django.core.cache.backends.locmem.LocMemCache'
    # Another possible backend is the Dummy
    # 'django.core.cache.backends.dummy.DummyCache'

    # CSCHE_MIDDLEWARE_SECONDS # number of seconds a page should be cached
    # CSCHE_MIDDLEWARE_ANONYMOUS_ONLY = True # requires Auth middleware
    >>> from django.views.decorators.cache import cache_control, never_cache,
            cache_page
    >>> @cache_page(60*15[, cache='special_cache', key_prefix='site1'])
        def myview(request):
        ...
    # Samething with myview wrapped in cache_page
    >>> urlpatterns = ('',
            (r'^foo/(\d{ 1,2 })', cache_page(60*15)(my_view))
        )

    # Template fragment caching
    {% load i18n %}
    {% load cache %}
    {% get_curent_language as LANGUAGE_CODE %}
    {% cache 300 sidebar %}
        .. sidebar ..
    {% endcache %}
    # {% cache 300 sidebar request.user.username %} # cache based on unique data
    # {% cache my_timeout sidebar %} # cache based on timeout variable
    {% cache 300 welcome LANGUAGE_CODE %}
        {% trans "Welcome" %}
    {% endcache %}

    # django.core.cache, cache module has a cache object ceated automatically
    # from the 'default' entry int CACHE
    >>> from django.core.cache import get_cache
    # if key doesen't exist InvalidCacheBackendError will be raised
    >>> cache = get_cache('alternative')
    # Timeout is optional defaults to the appropriate backends setting in CACHE
    >>> cache.set('my_key', 'hello, world!', 30)
    # add is like set except it wont try to update the cache if the key
    # already exist
    >>> cache.add('my_key', 'hello, world!', 30)
    >>> cache.get('my_key'[, 'has expired'])
    >>> cache.set('a', '1')
    >>> cache.set('b', '2')
    >>> cache.set('c', '3')
    >>> cache.get_many(['a', 'b', 'c'])
    >>> cache.set_many({ 'a': 1, 'b': 2, 'c':3 })
    >>> cache.delete('a')
    >>> cache.delete_many(['a', 'b', 'c'])
    # Clear EVERYTHING in the cache
    >>> cache.clear()

    # Note incr() or decr() might not be atomic
    >>> cache.set('num', 1)
    >>> cache.incr('num')
    2
    >>> cache.incr('num', 10)
    12
    >>> cache.decr('num')
    11
    >>> cache.decr('num', 5)
    6

    >>> cache.set('my_key', 'hello, world!', version=2)
    >>> cache.incr_version('my_key')
    >>> cache.get('my_key', version=3)

    # Upstream Cache
    >>> from django.view.decorators.vary import vary_on_headers
    # headers are not case sensitive
    # @vary_on_cookie is equall to @vary_on_headers('Cookie')
    >>> @vary_on_headers('User-Agent', 'Cookie')
        def my_view(request):
        # ...
    >>> from django.utils.cache import patch_vary_headers
    >>> def my_view(request):
            # ...
            response = render_to_response('template_name', context)
            patch_vary_headers(response, ['Cookie'])
            return response

    # For private info you don't want to be cached Upstream
    # Use this for dashboards and other views that expose the user
    >>> from django.view.decorators.cache import cache_control
    >>> @cache_control(private=True)
        def my_view(request):
            # ...
    # cache_control
    # Public=True
    # Private=True
    # no_cache=True
    # no_transform=True
    # must_revalidate=True
    # proxy_revalidate=True
    # max_age=num_seconds
    # s_maxage=num_seconds

    # You can also patch the headers like so
    >>> patch_vary_headers(response, private=True)
    # Never cache a view
    >>> from django.view.decorators.cache import never_cache


## }}}
## Crypt. Signing {{{
    # cryptographic signing allows for transmission of data through untrusted
    # channels, any tampering is detectable
    # Common uses incudes Signed cookies
    # By default signer uses SECRET_KEY to generate signatures
    # SECRET_KEY is the key to secure signed data, keep secure

    class Signer(key=None, sep=':', salt=None)
    # Usage example
    >>> from django.core.signing import Signer
    >>> signer = Signer()
    >>> value = signer.sign('My string')
    # if the value is modified, unsign will raise signing.BadSignature exception
    >>> from django.core.signing import signing
    >>> value += 'm'
    >>> try:
            original = signer.unsign(value)
        except signing.BadSignature:
            print('tampering detected')

    # Usign a diffrent secret key than the value SECRET_KEY
    # pass the secret key to the signer constructor
    >>> signer = Signer('my-other-secet')
    # Salts put different signatures into different namespaces
    # Unlike your SECRET_KEY salts don't need to stay secret
    >>> signer = Signer(key='my-other-secet', salt='lk2y3')

    # TimeStampSigner adds a timestamp to allow you to confirm that a signature
    # was created within a specified period of time
    class TimestampSigner(key=None, sep=':', salt=None)
    >>> from django.core.signing import TimestampSigner
    >>> signer = TimestampSigner()
    >>> value = signer.sign('My string')
    >>> signer.unsign(value, max_age=60)
        # max_age is in seconds

    # Protecting list, tuple or dictionary
    # use JSON, ensures that even if your SECRET_KEY is compromised attackers
    # can't execute arbitary code
    >>> from django.core.signing import signing
    >>> value = signing.dump({"foo":"bar"})
    >>> signing.loads(value)
    # dumps(obj, key=None, salt='django.core.signing', compres #  
