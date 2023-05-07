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