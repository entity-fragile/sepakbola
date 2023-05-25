from django.urls import path
from . import views
from .views import *

app_name = 'panitia'

urlpatterns = [
    path('', views.panitiaDashboard, name='panitiaDashboard'),
    path('mulaiRapat/',views.mulaiRapat,name='mulaiRapat'),
    path('rapat/',views.startMeeting,name='startMeeting'),
    path('pertandingan/',views.mulaiPertandingan,name='mulaiPertandingan'),
    path('peristiwa/',views.peristiwa, name='peristiwa'),
    path('mulaiRapat/startMeeting/', views.startMeeting, name='startMeeting'),
    path('mulaiRapat/submitRapat/', views.submitRapat, name='submitRapat'),
]