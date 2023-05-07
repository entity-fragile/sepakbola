from django.shortcuts import render

# Create your views here.
def penontonDashboard(request):
    return render(request, 'penontonDashboard.html')

def listPertandingan(request):
    return render(request, 'listPertandingan.html')