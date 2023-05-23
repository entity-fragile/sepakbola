from django.shortcuts import render, redirect
from utils.query import query

# Create your views here.
def panitiaDashboard(request):
    if (request.session.get('username') == None):
        return redirect('/authentication/login/')
    if(request.session.get('user_role') != 'panitia'):
        if (request.session.get('user_role') == None):
            return redirect('/authentication/login/')
        return redirect(f'/{request.session.get("user_role")}/')
    non_pemain = query(f''' 
        SELECT nama_depan, nama_belakang, nomor_hp, email, alamat, string_agg(status, ', ') as status, jabatan
        FROM NON_PEMAIN np join status_non_pemain snp 
        on np.id = snp.id_non_pemain 
        join panitia p on p.id_panitia = np.id
        WHERE username = '{request.session.get("username")}'
        GROUP BY nama_depan, nama_belakang, nomor_hp, email, alamat, jabatan;
        ''')
    list_rapat = query(f'''
        SELECT t.nama_tim as tim_a, t2.nama_tim as tim_b,  r.datetime, np1.nama_depan AS p_fname,
        np1.nama_belakang AS p_lname,
        np2.nama_depan AS ma_fname, np2.nama_belakang AS ma_lname,
        np3.nama_depan AS mb_fname, np3.nama_belakang AS mb_lname, r.isi_rapat
        FROM rapat r
        INNER JOIN non_pemain np1 ON np1.id = r.perwakilan_panitia
        INNER JOIN non_pemain np2 ON np2.id = r.manajer_tim_a
        INNER JOIN non_pemain np3 ON np3.id = r.manajer_tim_b
		INNER JOIN tim_manajer t on np2.id = t.id_manajer
		INNER JOIN tim_manajer t2 on np3.id = t2.id_manajer
        WHERE r.datetime > current_timestamp;
        ''')
    context = {
        "non_pemain": non_pemain,
        "list_rapat": list_rapat
        } 
    # handle for belom ada rapat
    if (len(list_rapat) == 0):
        context['message'] = 'Anda belum memiliki rapat'
    return render(request, 'panitiaDashboard.html',  context)

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