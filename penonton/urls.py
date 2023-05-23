from django.urls import path
from . import views
from .views import *

app_name = 'penonton'

urlpatterns = [
    path('', views.penontonDashboard, name='penontonDashboard'),
    path('listPertandingan', listPertandingan, name='listPertandingan'),
    path('pilihstadium/',views.pilihStadium,name='pilihStadium'),
    path('listwaktu/<str:nama>/<str:tgl>/',views.listWaktu,name='listWaktu'),
    path('belitiket/',views.beliTiket,name='beliTiket'),
    path('tiketListPertandingan/<str:id>/',views.tiketListPertandingan,name='tiketListPertandingan/'),
]