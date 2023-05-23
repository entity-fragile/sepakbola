from django.shortcuts import render

# Create your views here.
def panitiaDashboard(request):
    return render(request, 'panitiaDashboard.html')

def rapatPanitia(request):
    return render(request, 'rapatPanitia.html')

def mulaiRapat(request):
    return render(request, 'rapat.html')

def mulaiPertandingan(request):
    return render(request, 'mulaiPertandingan.html')

def peristiwa(request):
    return render(request, 'peristiwa.html')

def managePertandingan(request):
    return render(request, 'managePertandingan.html')

def pembuatanPertandingan(request):
    return render(request, 'pembuatanPertandingan.html')

def warningPertandingan(request):
    return render(request, 'warningPertandingan.html')

def daftarPeristiwa(request):
    return render(request, 'daftarPeristiwa.html')

def updatePertandingan(request):
    return render(request, 'updatePertandingan.html')

def akhirMusim(request):
    return render(request, 'akhirMusim.html')

def editList(request):
    return render(request, 'editList.html')

def waktuStadium(request):
    return render(request, 'waktuStadium.html')

def pertandinganDuatim(request):
    return render(request, 'pertandinganDuatim.html')