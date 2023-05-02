from django.shortcuts import render

# Create your views here.

def pelangganDashboard(request):
    return render(request, 'pelanggan.html')