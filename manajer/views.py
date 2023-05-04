from django.shortcuts import render

# Create your views here.
def manajerDashboard(request):
    return render(request, 'manajerDashboard.html')

def listStadium(request):
    return render(request, 'listStadium.html')

def pinjamStadium(request):
    return render(request, 'pinjamStadium.html')

def pesanStadium(request):
    return render(request, 'pesanStadium.html')

def listPertandingan(request):
    return render(request, 'listPertandingan.html')

def historyRapat(request):
    return render(request, 'historyRapat.html')

def kelolaTim(request):
    return render(request, 'kelolaTim.html')

def daftarTim(request):
    return render(request, 'registerTim.html')

def daftarPemain(request):
    return render(request, 'registerPemain.html')

def daftarPelatih(request):
    return render(request, 'registerPelatih.html')
