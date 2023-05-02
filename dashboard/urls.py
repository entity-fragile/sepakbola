from django.urls import path
from . import views
from .views import *

app_name = 'dashboard'

urlpatterns = [
    path('', views.pelangganDashboard, name='pelangganDashboard'),
    
]