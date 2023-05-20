from django.urls import path
from .views import *

app_name = 'authentication'

urlpatterns = [
    path('login/', login, name='login'),
    path('register/', register, name='register'),
    path('registerManajer/', registerManajer, name='registerManajer'),
    path('registerPanitia/', registerPanitia, name='registerPanitia'),
    path('registerPenonton/', registerPenonton, name='registerPenonton'),
    path('registerManajer/post/', post_register_manajer, name='post_register_manajer'),
    path('registerPanitia/post/', post_register_panitia, name='post_register_panitia'),
    path('registerPenonton/post/', post_register_penonton, name='post_register_penonton'),
    path('login/post/', post_login, name='post_login'),
    path('logout/', logout, name='logout'),

]