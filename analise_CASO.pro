function cpCNA,rio_c,rio_f
gz=where(rio_c gt 0 and rio_f gt 0, c)
abspt=fltarr(c)*!VALUES.F_NAN
if c ne 0 then abspt[gz]=10*(alog10(rio_c[gz])-alog10(rio_f[gz]))


return, abspt
end
;=====================

pro analise_CASO
;;%% 
;data_path='D:\2017data\work\GRAU\data\quickview\2013'
;goes_data='D:\2017data\work\GRAU\goes_xray\result'


;;;;;;;;;;;;;;;;;;;;;;;;;;;; C A L M O ;;;;;;;;;;;;;;;;;;;;;;;;;;;; 
dir='D:\2017data\work\GRAU\'
;f = findfile(dir+'ATB201310*'+'t'+'*.save')
;f = findfile(dir+'ATB2014*'+'t.save')

;f = findfile(dir+'SJC20111112'+'t.save')
;f = findfile(dir+'SJC20111113'+'t.save')
;f = findfile(dir+'SJC20111116'+'t.save')
;f = findfile(dir+'SJC20111117'+'t.save')

;f = findfile(dir+'CON20111113'+'t.save')
;f = findfile(dir+'CON20111111'+'t.save')

;f = findfile(dir+'EACF20111107*.save')
;f = findfile(dir+'EACF20111108*.save') ; um

;f = findfile(dir+'SMR20111*'+'t.save')

;f = findfile(dir+'TRW20111129*'+'t.save')
;f = findfile(dir+'TRW20111109*'+'t.save')

;f = findfile(dir+'BAH20111122*'+'t.save')
f = findfile(dir+'PLR20111103'+'t.save')


;;;;;;;;;;;;;;;;;;;;;;;;;;;; F L A R E ;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;stname=['ATB','SMR','TRW','PAC','KAK','CON','SJC','PAL','BAH','ACF','EAC','EACF','PLR']
dirf='D:\2017data\work\GRAU\'
st_name='PLR'
flr='20111103t.save'
restore, dirf+st_name+flr
Tut_f=Tvec
Tsd_f=timeMin
rio38_f=rio38
;rio38_f=rio30
;select_Flares,'2011', date,classe,'X'

;;;;;;;;;;;;;;;;;;;;;;;;;;;; TEMPESTADE G E O M A G ;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;stname=['ATB','SMR','TRW','PAC','KAK','CON','SJC','PAL','BAH','ACF','EAC','EACF']
;dirf='D:\2017data\work\GRAU\qdc_nova\explosao\'
;st_name='ATB'
;DP='20140925t.save'
;restore, dirf+st_name+DP
;Tut_f=Tvec
;Tsd_f=timeMin
;rio38_f=rio38
;rio38_f=rio30

;;;;;;;;;;;;;;;;;;;;;;;;;;;; ;;;;;;;;;;;;;;;;;;;;;;;;;;;; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

cstr=['Hot Pink','Indian Red', 'Blue', 'Brown', 'Charcoal', 'Coral', 'Cyan', 'Dark Green', 'Green', 'Magenta','Orange Red','Yellow', $
  'Hot Pink','Indian Red', 'Blue', 'Brown', 'Charcoal', 'Coral', 'Cyan', 'Dark Green', 'Green', 'Magenta','Orange Red','Yellow', $
  'Hot Pink','Indian Red', 'Blue', 'Brown', 'Charcoal', 'Coral', 'Cyan', 'Dark Green', 'Green', 'Magenta','Orange Red','Yellow']
;;; CRIA MATRIS DIAS CALMOS OU DIA CALMO
;mtx_c=fltarr(N_ELEMENTS(f),(86400/4))
;tsidall=fltarr(N_ELEMENTS(f),(86400/4))
;;;restaura dias calmos e completa matriz
;for ul=0,N_ELEMENTS(f)-1 do begin  
;;  if ul eq 3 then goto ,j1
;restore, f[ul]
;tsidall[ul,*]=timeMin[0:n_elements(timeMin)-1:4]
;r38c=rio38[0:n_elements(rio38)-1:4]
;irpow=cpFil_sinal(r38c,3,0.15,'AVG')
;mtx_c[ul,*]=irpow
;endfor


;RESTAURA OS DIAS CALMOS DE F
cdata=fltarr(4,n_elements(f))
for ul=0,N_ELEMENTS(f)-1 do begin  
restore, f[ul]
tUT_C=Tvec
tsd_c=timeMin
rio38_c=rio38
;rio38_c=rio30
;stop

; CRIA OS OBSERVACIONAIS CADA 4 SEGUNDOS
rqdc=rio38_c(0:n_elements(rio38_c)-1:4)

; TEMPO SIDERAL DO DIA CALMO
tqdc=tsd_c(0:n_elements(tsd_c)-1:4) 
; FILTRA O OBS CALMO PARA QDC
irpow=cpFil_sinal(rqdc,150,0.05,'AVG')
;irpow=cpFil_sinal(rqdc,3,0.15,'AVG')
rbruto=rqdc[0:n_elements(irpow)-1:15]


;stop
; CRIA A QDC TIME E QDC DATA
; qdctime=indgen(1440)*(60/3600.)
;bin,rio38_c,tqdc, qdctime,qdc1col,qdcmean1col
;binh,rqdc,tqdc, qdctime,qdc1col,qdcmean1col,ir
bin,irpow,tqdc, qdctime,qdc1col,qdcmean1col,ir
;bin,mtx_c,tsidall, qdctime,qdc1col,qdcmean1col
stop

;y=cpFil_sinal(qdc1col,3,0.05,'AVG')
;x=qdctime
;yfit = GAUSSFIT(x, y, coeff, NTERMS=4)
;cdata[*,ul]=coeff

; COLOca NA MESMA HORA SIDERAL DO DIA DO FLARE
qdcdata=smooth(qdc1col,30,/EDGE_WRAP,/NAN)
sqdc=interpol(qdc1col,qdctime,Tsd_f)
;c_ndat=interpol(rbruto,qdctime,Tsd_f)


;FILTRA O FLARE
ipowf=cpFil_sinal(rio38_f,150,0.05,'AVG')
; CRIA A QDCCURVE DE MINUTOS
;qdcfit=smqdc[0:N_ELEMENTS(smqdc)-1:60]
qdccurve=sqdc[0:N_ELEMENTS(sqdc)-1:60]


rio38ff=ipowf[0:N_ELEMENTS(ipowf)-1:60]
;ndat=c_ndat[0:N_ELEMENTS(c_ndat)-1:60]

;smthm=smooth(qdcmean,30,/EDGE_WRAP,/NAN)
smth=smooth(qdccurve,150,/EDGE_MIRROR,/NAN)
;sh=gauss_smooth(qdccurve,50,/EDGE_MIRROR,/NAN)

;TEMPO DO FLARE EM UT EM MUNUTOS em MS
ti=Tut_f(0:N_ELEMENTS(Tut_f)-1:60)
tt=ti*3.6d6
window,0, ysize=630,xsize=900
;t_plot,tt,rio38ff,yst=1,yr=[0,6.],xrange=['20.','21.'],title='ZOOM :: Dia calmo: GREEN '+'Dia perturbado: BRANCO'
t_plot,tt,rio38ff,yst=1,yr=[0,2.],title='Dia calmo: GREEN '+'Dia perturbado: BRANCO'
t_plot,tt,smth,color=cgcolor('blue'),thick=1.5,/ov
t_plot,tt,qdccurve,color=cgcolor('green'),/ov
;t_plot,tt,ndat,color=cgcolor('green'),thick=1.,/ov
CNAD=cpCNA(smth,rio38ff)
t_plot, tt, CNAD,/ov
print ,f[ul]
;WRITE_PNG,f[ul]+'_bruto_.png',TVRD(/True)
;stop

;goesdir='D:\2017data\work\GRAU\goes_xray\'
;fx=findfile('wibk*'+'.sav')
;restore, 

endfor


;;;salva um .SAV com todos os dados do dia
;DESCRIPTION='CASO PARA ESTUDO  2014 10 25 - RIO - ATB Variaveis : cal = diretorido do caminho, flr = diretorio do flare, st_name = name da estação , tempUT = tempo UT, rio38F = dado bruto do riometro evento flare, rio38_c = dado bruto riometro calmo, rioc_sh = riometro calmo mesma hora sideral, rio38fil_c = calmo filtardado, rio38fil_f = flareday filtardado, CNAd = CNA'
;save, filename='20141025_flareRIOcase.sav',cal,flr,st_name,tempUT,rio38F,rio38_c,rio38c_sh,rio38fil_C,rio38fil_f,CNAd, DESCRIPTION=DESCRIPTION


end







;print ,f[ul]
;stop
;if ul eq 0 then begin
;  window,2
;t_plot,tt,qdccurve,color=255,yr=[0,6]
;
;endif else begin 
;  wset,2
;  t_plot,tt,qdccurve,color=cgcolor(cstr[ul]),/ov
;  endelse
;wdelete,0
;stop
;;if n_elements(filrioc) gt n_elements(filriof) then goto,j1
;;mxtmd[ul,*]=filrioc
;;j1:mxtmd[ul,*]=!VALUES.F_NAN
;
;
;
;CNAD=cpCNA(smth,rio38ff)
;nz=where(cnad gt 0)
;window,4
;t_plot, tt, CNAD,yrange=[0,max(cnad,/NAN)+0.5],xrange=['19.','21.']
;
;;descr='st_name : nome das estacao, flr: dia do flare, f : lista dos dias calmos , timeut : tempo UT, mxtmd: matrz dos dias calmos,m_qdc: media dias calmos, std_qdc: desvio padrao,rio38f: dia perturbado ,filriof : dia perturabado filtrado'
;;save,filename='qdcmtxcal26.sav',st_name,flr,f,timeut, mxtmd,m_qdc,std_qdc,rio38f,filriof, DESCRIPTION=descr
;;;;;;;;;;;;;;;;;;;
;;compara com o fluxo xray 1-8A
;
;stop
;
;;;;; usa o observavel
;;(Shigeru MIYAZAKI,1975)
;; variacao da densidade 
;;Nel=exp(4.67+(0.205*cnad))
;;variacao da altura de pico
;;hpk=100+(2*cnad)*(-1)
;;;;;;;;000 plot 
;;window,10
;;cgplot,temput(990:1072), nel(990:1072),xs=1,ys=1
;;window,11
;;cgplot,temput(990:1072), hpk(990:1072),xs=1,ys=1
;;window,12
;;cgplot,nel(990:1072), hpk(990:1072),xs=1,ys=1
;
;;;salva um .SAV com todos os dados do dia
;;DESCRIPTION='CASO PARA ESTUDO  2014 10 25 - RIO - ATB Variaveis : cal = diretorido do caminho, flr = diretorio do flare, st_name = name da estação , tempUT = tempo UT, rio38F = dado bruto do riometro evento flare, rio38_c = dado bruto riometro calmo, rioc_sh = riometro calmo mesma hora sideral, rio38fil_c = calmo filtardado, rio38fil_f = flareday filtardado, CNAd = CNA'
;;save, filename='20141025_flareRIOcase.sav',cal,flr,st_name,tempUT,rio38F,rio38_c,rio38c_sh,rio38fil_C,rio38fil_f,CNAd, DESCRIPTION=DESCRIPTION
;
;
;; - - - - - - - - - - - - - - - - - - -
;; - - - - - - - - plot area - - - - - -
;; - - - - - - - - - - - - - - - - - - -
;stop
;;endfor
