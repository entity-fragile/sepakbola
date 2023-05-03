from django.shortcuts import render

# Create your views here.
def panitiaDashboard(request):
    return render(request, 'panitiaDashboard.html')