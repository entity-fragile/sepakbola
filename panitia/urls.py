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
     path('managePertandingan', managePertandingan, name='managePertandingan'),
    path('pembuatanPertandingan', pembuatanPertandingan, name='pembuatanPertandingan'),
    path('warningPertandingan', warningPertandingan, name='warningPertandingan'),
    path('daftarPeristiwa', daftarPeristiwa, name='daftarPeristiwa'),
    path('updatePertandingan', updatePertandingan, name='updatePertandingan'),
    path('akhirMusim', akhirMusim, name='akhirMusim'),
    path('editList', editList, name='editList'),
    path('waktuStadium', waktuStadium, name='waktuStadium'),
    path('pertandinganDuatim', pertandinganDuatim, name='pertandinganDuatim'),
    path('mulaiPertandingan', mulaiPertandingan, name='mulaiPertandingan'),
    path('mulaiRapat/startMeeting/', views.startMeeting, name='startMeeting'),
    path('mulaiRapat/submitRapat/', views.submitRapat, name='submitRapat'),
]