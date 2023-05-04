from django.urls import path
from .views import *

app_name = 'manajer'

urlpatterns = [
    path('', manajerDashboard, name='manajerDashboard'),
    path('listStadium', listStadium, name='listStadium'),
    path('pinjamStadium', pinjamStadium, name='pinjamStadium'),
    path('pesanStadium', pesanStadium, name='pesanStadium'),
    path('listPertandingan', listPertandingan, name='listPertandingan'),
    path('historyRapat', historyRapat, name='historyRapat')

]