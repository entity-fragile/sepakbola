from django.urls import path
from . import views
from .views import *

app_name = 'panitia'

urlpatterns = [
    path('', views.panitiaDashboard, name='panitiaDashboard'),
    path('mulaiRapat/',views.rapatPanitia,name='rapatPanitia'),
    path('rapat/',views.mulaiRapat,name='mulaiRapat'),
    path('pertandingan/',views.mulaiPertandingan,name='mulaiPertandingan'),
    path('peristiwa/',views.peristiwa, name='peristiwa'),
]