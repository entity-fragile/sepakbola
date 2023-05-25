from django.shortcuts import render
from django.db import connection
# from .models import Stadium
from datetime import datetime

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

from datetime import datetime

def pembuatanPertandingan(request):
    if request.method == 'POST':
        tanggal = request.POST.get('tanggal')
        request.session["tanggal"]=tanggal
        # print(request.session["tanggal"])

        with connection.cursor() as cursor:
            query = """
                SELECT S.Nama
                FROM Stadium AS S
                WHERE S.ID_Stadium NOT IN (
                    SELECT P.Stadium
                    FROM Pertandingan AS P
                    WHERE DATE %s BETWEEN P.Start_Datetime::date AND P.End_Datetime::date
                )
            """
            cursor.execute(query, [tanggal])
            stadiums = [row[0] for row in cursor.fetchall()]

        context = {'stadiums': stadiums}
        return render(request, 'pembuatanPertandingan.html', context)
    else:
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
    with connection.cursor() as cursor:
        cursor.execute("SELECT ID_Pertandingan, string_agg(Nama_Tim, ' vs. ') AS Teams FROM Tim_Pertandingan GROUP BY ID_Pertandingan;")
        pertandingan_data = cursor.fetchall()

    pertandingan = [{'Teams': row[1]} for row in pertandingan_data]

    return render(request, 'editList.html', {'pertandingan': pertandingan})

def waktuStadium(request):
    return render(request, 'waktuStadium.html') 

from django.shortcuts import render
from django.db import connection

# def pilihWasit(request):
#     return render(request, 'pilihWasit.html')

def pertandinganDuatim(request):
    # tanggal = request.POST.get('tanggal')
    tanggal = request.session["tanggal"]
    # print(request.session["tanggal"])
    # if request.method == 'POST':
    wasit_utama = request.POST.get('wasit_utama')
    wasit_pembantu = request.POST.get('wasit_pembantu')
    wasit_cadangan = request.POST.get('wasit_cadangan')
        
        # Handle form submission and other logic
        
    # else:
        # Execute the query to retrieve referee data
    query = '''
    SELECT w.id_wasit, np.nama_depan, np.nama_belakang
    FROM WASIT w
    LEFT JOIN WASIT_BERTUGAS wb ON w.id_wasit = wb.id_wasit
    LEFT JOIN PERTANDINGAN p ON wb.id_pertandingan = p.id_pertandingan
    LEFT JOIN NON_PEMAIN np ON w.id_wasit = np.id
    WHERE DATE(p.start_datetime) <> %s OR p.start_datetime IS NULL;
    '''

    with connection.cursor() as cursor:
        cursor.execute(query, [tanggal])
        # cursor.execute(query)
        rows = cursor.fetchall()

        # Prepare referee data for rendering in HTML
        referees = [{'id': row[0], 'nama_depan': row[1], 'nama_belakang': row[2]} for row in rows]
        
    query = '''
    SELECT T.nama_tim
    FROM TIM AS T
    WHERE T.nama_tim NOT IN (
        SELECT TP.nama_tim
        FROM TIM_PERTANDINGAN AS TP
        INNER JOIN PERTANDINGAN AS P ON TP.id_pertandingan = P.id_pertandingan
        WHERE DATE(%s) BETWEEN P.start_datetime::date AND P.end_datetime::date);
        '''
    
    with connection.cursor() as cursor:
        cursor.execute(query, [tanggal])
        # cursor.execute(query)
        rows = cursor.fetchall()
    
        nama_tim = []

        # Eksekusi query SQL
        with connection.cursor() as cursor:
            cursor.execute(query, [tanggal])
            rows = cursor.fetchall()

        # Menyimpan nama tim ke dalam list
        for row in rows:
            nama_tim.append({'nama_tim': row[0]})

        # Menampilkan hasil
        print(nama_tim)
        
        
    context = {
    'referees': referees,
    'nama_tim': nama_tim,  # Tambahkan ini
}
        
    return render(request, 'pertandinganDuatim.html', context)