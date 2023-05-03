from django.urls import path
from . import views
from .views import *

app_name = 'panitia'

urlpatterns = [
    path('', views.panitiaDashboard, name='panitiaDashboard'),

]