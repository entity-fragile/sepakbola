from django.shortcuts import render

# Create your views here.
def manajerDashboard(request):
    return render(request, 'manajerDashboard.html')

def kelolaTim(request):
    return render(request, 'kelolaTim.html')

def daftarTim(request):
    return render(request, 'registerTim.html')

def daftarPemain(request):
    return render(request, 'registerPemain.html')

def daftarPelatih(request):
    return render(request, 'registerPelatih.html')
