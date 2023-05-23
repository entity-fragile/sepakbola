from django.shortcuts import render
from utils.query import query

# Create your views here.
def penontonDashboard(request):
    return render(request, 'penontonDashboard.html')

def listPertandingan(request):
    return render(request, 'listPertandingan.html')

def pilihStadium(request):
    list_stadium = query(f'''
        SELECT * FROM STADIUM
    ''')
    print(list_stadium)
    context = {
        'list_stadium': list_stadium
    }

    return render(request,'pilihStadium.html', context)

def listWaktu(request, nama, tgl):
    list_waktu = query(f''' 
        SELECT *
        FROM PERTANDINGAN
        WHERE Start_Datetime >= '{tgl} 00:00:00' AND Start_Datetime <= '{tgl} 23:59:59'
    ''')

    print(list_waktu)
    context = {
        'stadium': nama,
        'list_waktu': list_waktu
    }

    return render(request,'listWaktu.html', context)

def tiketListPertandingan(request, id):
    list_tim = query(f'''
        SELECT TP.nama_tim
        FROM TIM_PERTANDINGAN TP
        WHERE TP.ID_Pertandingan = '{id}'
    ''')

    context = {
        'list_tim': list_tim
    }

    return render(request,'ticketListPertandingan.html', context)

def beliTiket(request):
    return render(request,'beliTiket.html')