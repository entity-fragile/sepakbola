from django.shortcuts import render

# Create your views here.
def manajerDashboard(request):
    return render(request, 'manajerDashboard.html')

