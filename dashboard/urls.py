from django.urls import path
from . import views
from .views import *

app_name = 'dashboard'

urlpatterns = [
    path('', views.showDashboard, name='showDashboard'),
    path('pelanggan/', views.pelangganDashboard, name='pelangganDashboard'),
]