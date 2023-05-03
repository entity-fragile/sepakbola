from django.shortcuts import render

# Create your views here.

def showDashboard(request):
    return render(request, 'dashboard.html')

def pelangganDashboard(request):
    return render(request, 'pelanggan.html')