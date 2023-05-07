from django.urls import path
from . import views
from .views import *

app_name = 'penonton'

urlpatterns = [
    path('', views.penontonDashboard, name='penontonDashboard'),
    path('listPertandingan', listPertandingan, name='listPertandingan'),
]