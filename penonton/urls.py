from django.urls import path
from . import views
from .views import *

app_name = 'penonton'

urlpatterns = [
    path('', views.penontonDashboard, name='penontonDashboard'),
    path('listPertandingan', listPertandingan, name='listPertandingan'),
    path('pilihstadium/',views.pilihStadium,name='pilihStadium'),
    path('listwaktu/',views.listWaktu,name='listWaktu'),
    path('belitiket/',views.beliTiket,name='beliTiket'),
    path('tiketListPertandingan/',views.tiketListPertandingan,name='tiketListPertandingan/'),
]