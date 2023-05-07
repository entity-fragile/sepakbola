from django.urls import path
from .views import *

app_name = 'manajer'

urlpatterns = [
    path('login/', login, name='login'),
    path('register/', register, name='register'),
    path('registerManajer/', registerManajer, name='registerManajer'),
    path('registerPanitia/', registerPanitia, name='registerPanitia'),
    path('registerPenonton/', registerPenonton, name='registerPenonton'),

]