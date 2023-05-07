from django.shortcuts import render

# Create your views here.
def penontonDashboard(request):
    return render(request, 'penontonDashboard.html')

def listPertandingan(request):
    return render(request, 'listPertandingan.html')

def pilihStadium(request):
    return render(request,'pilihStadium.html')

def listWaktu(request):
    return render(request,'listWaktu.html')

def tiketListPertandingan(request):
    return render(request,'ticketListPertandingan.html')

def beliTiket(request):
    return render(request,'beliTiket.html')