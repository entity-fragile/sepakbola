from django.urls import path
from auth.views import show_login, show_register, show_home

app_name = 'auth'

urlpatterns = [
    path('', show_home, name='show_home'),
    path('register/', show_register, name='show_register' ),
    path('login/', show_login, name='show_login' ),
]