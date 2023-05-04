from django.urls import path
from . import views
from .views import *

app_name = 'manajer'

urlpatterns = [
    path('', views.manajerDashboard, name='manajerDashboard'),
    path('kelolatim/', views.kelolaTim, name='kelolaTim'),
]