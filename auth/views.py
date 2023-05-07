from django.shortcuts import render

# Create your views here.
def show_home(request):
    return render(request, "home.html")

def show_login(request):
    return render(request, "login.html")

def show_register(request):
    return render(request, "register.html")