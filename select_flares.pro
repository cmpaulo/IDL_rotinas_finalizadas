pro select_Flares,ano,tipo,dates,times
;rotina que retorna os dias do tipo do flare.
;flare que acontecem entre a 08:00 e 20:00 UT periodo iluminado para america latina e norte americano
; utiliza os arquivos GOES-XRS-REPOT_aaaa do NOAA.
; dependencia da rotina readcol (SSW)
; by Paulo, C.M. >> 29/07/2018 

;INICO PARA COMILAR NO WINDOWS
;ano='2014'
;tipo='EM'
;f = findfile('D:\2017data\Classifica_dias_pertu\goes-xrs-report_'+ano+'.txt')
;for i=0,N_ELEMENTS(f)-1 do begin
;  print, f[i]
; readcol,f[i],dita, b_time, e_time, pk_time,format='a,a,a,a,x,x,x,x'
; readcol,f[i],co,cln,format='x,x,x,x,a,a,x,x'

;INICIO PARA CHAMAR COMO PRO
readcol,ano,dita, b_time, e_time, pk_time,format='a,a,a,a,x,x,x,x'
readcol,ano,co,cln,format='x,x,x,x,a,a,x,x'
data=strmid(dita,5,6)
if N_ELEMENTS(pk_time) eq N_ELEMENTS(co) then print, 'O. K.' else stop 

if tipo eq 'A' or tipo eq 'B' or tipo eq 'C' or tipo eq 'M' or tipo eq 'X' then begin
um =where(pk_time eq tipo, lu)
doi=where(cln eq tipo, ld)
tre=where(co eq tipo , ll)
if lu gt 0 and ld gt 0 and ll gt 0 then  t=[um,doi,tre]
if lu eq 0 and ld eq 0 and ll eq 0 then stop 
if lu eq 0 and ld gt 0 and ll gt 0 then  t=[doi,tre]
if lu gt 0 and ld eq 0 and ll gt 0 then  t=[um,tre]
if lu gt 0 and ld gt 0 and ll eq 0 then  t=[um,doi]
if lu gt 0 and ld eq 0 and ll eq 0 then  t=[um]
if lu eq 0 and ld gt 0 and ll eq 0 then  t=[doi]
if lu eq 0 and ld eq 0 and ll gt 0 then  t=[tre]
ts=t[sort(t)]
endif
;;;;;;;;//////////////;;;;;;;;;;;;;;;;
if  tipo eq 'XM' or tipo eq 'MX' or tipo eq 'EX' or tipo eq 'EM' then begin 
cvec=['M','X']
for ev=0,1 do begin
um =where(pk_time eq cvec[ev], lu)
doi=where(cln eq cvec[ev], ld)
tre=where(co eq cvec[ev] , ll)
;ler e criar a lista de posições da classe do flare
if lu gt 0 and ld gt 0 and ll gt 0 then  t=[um,doi,tre]
if lu eq 0 and ld eq 0 and ll eq 0 then stop 
if lu eq 0 and ld gt 0 and ll gt 0 then  t=[doi,tre]
if lu gt 0 and ld eq 0 and ll gt 0 then  t=[um,tre]
if lu gt 0 and ld gt 0 and ll eq 0 then  t=[um,doi]
if lu gt 0 and ld eq 0 and ll eq 0 then  t=[um]
if lu eq 0 and ld gt 0 and ll eq 0 then  t=[doi]
if lu eq 0 and ld eq 0 and ll gt 0 then  t=[tre]
if cvec[ev] eq 'M' then tsM=t[sort(t)] else tsX=t[sort(t)] 
endfor
endif
;;;;;;;;;;;;;; seleciona o periodo dirno 

if tipo eq 'm' or tipo eq 'M' or tipo eq 'XM' or tipo eq 'MX' then begin
if tipo eq 'm' or tipo eq 'M' then tsm=ts
print, '%%%%%%%%%%%%%%%%%%%%%%%      Flare M         %%%%%%%%%%%%%%%%%%%%%%'
cl_iM=where((b_time[tsM] gt 800 and pk_time[tsM] lt 2100) or (b_time[tsM] gt 800 and e_time[tsM] lt 2100), cnt)   
if (cnt gt 1) then print, data[tsM[cl_iM]]
times=strarr(3,cnt)
dates=strarr(cnt)
dates[*]=data[tsM[cl_iM]]
times[0,*]=b_time[tsM[cl_iM]] & times[1,*]=pk_time[tsM[cl_iM]] & times[2,*]=e_time[tsM[cl_iM]]
        

;        ;;;;;; limpo 1 evento M no dia
gi=uniq(dates)
zo=dates[gi]
for i=0,N_ELEMENTS(zo)-1 do begin        
;    print,zo[i]
su_pk=where(pk_time eq tipo,luu)
su_sl=where(cln eq tipo,lSu)
su_co=where(co eq tipo,lLu)
po=where( data eq zo[i] ,pl)
;if pl gt 1 then print, data[po], pk_time[po],co[po],cln[po]
ru=where( pk_time[po] eq 'M' or pk_time[po] eq 'X' ,en)
rub=where( cln[po] eq 'A' or cln[po] eq 'B' or cln[po] eq 'C' or cln[po] eq 'M' or cln[po] eq 'X' ,ent)
ruc=where( co[po] eq 'A' or co[po] eq 'B' or co[po] eq 'C' or co[po] eq 'M' or co[po] eq 'X' ,ento)
if en eq 0 then begin 
unico=where(cln[po] eq tipo and cln[po] ne 'X' , c)
un_ico=where(co[po] eq tipo and cln[po] ne 'X' , ci)
if c+ci eq 1 and tipo eq 'M' then  print, '::::::::: 1ev: condição somente classe M ->'+'::::::::: '+zo[i] 
endif else begin 
uni=where(pk_time[po] eq tipo and pk_time[po] ne 'X'  , cn)

un_ico=where(co[po] eq tipo and co[po] ne 'X'  , ci)
if cn+c+ci eq 1 and tipo eq 'M' then  print, '::::::::: 1ev: condição somente classe M ->'+'::::::::: '+zo[i]
endelse
endfor
endif       
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; 
        
if tipo eq 'x' or tipo eq 'X' or tipo eq 'XM' or tipo eq 'MX' then begin        
print, '%%%%%%%%%%%%%%%%%%%%%%%      Flare X         %%%%%%%%%%%%%%%%%%%%%%'
if tipo eq 'x' or tipo eq 'X' then  tsX=ts
;ss=ss & sr=sr
cl_iX=where((b_time[tsX] gt 800 and pk_time[tsX] lt 2100) or (b_time[tsX] gt 800 and e_time[tsX] lt 2100), cnt)   
if (cnt gt 1) then print, data[tsX[cl_iX]]
times=strarr(3,cnt)
dates=strarr(cnt)
dates[*]=data[tsX[cl_iX]]
times[0,*]=b_time[tsX[cl_iX]] & times[1,*]=pk_time[tsX[cl_iX]] & times[2,*]=e_time[tsX[cl_iX]]
      ;;;;;; limpo 1 evento no dia
gi=uniq(dates)
zo=dates[gi]
for i=0,N_ELEMENTS(zo)-1 do begin        
;print,zo[i]
su_pk=where(pk_time eq tipo,luu)
su_sl=where(cln eq tipo,lSu)
su_co=where(co eq tipo,lLu)
po=where( data eq zo[i] ,pl)
;          if pl gt 1 then print, 'data/dia -> '+data[po],'hr pike flx -> '+pk_time[po],'position-> '+co[po],'classe flare -> '+cln[po]
Ru=where( pk_time[po] eq 'M' or pk_time[po] eq 'X' ,en)
rub=where( cln[po] eq 'A' or cln[po] eq 'B' or cln[po] eq 'C' or cln[po] eq 'M' or cln[po] eq 'X' ,ent)
ruc=where( co[po] eq 'A' or co[po] eq 'B' or co[po] eq 'C' or co[po] eq 'M' or co[po] eq 'X' ,ento)
if en eq 0 then begin 
unico=where(cln[po] eq tipo and cln[po] ne 'M'  , c)
un_ico=where(co[po] eq tipo and co[po] ne 'M'  , ci)
if c+ci eq 1 and tipo eq 'X' then  print, '::::::::: 1ev: condição somente classe X ->'+'::::::::: '+zo[i]
endif else begin 
uni=where(pk_time[po] eq tipo and pk_time[po] ne 'M'  , cn)
unico=where(cln[po] eq tipo and cln[po] ne 'M'  , c)
un_ico=where(co[po] eq tipo and co[po] ne 'M'  , ci)
if cn+c+ci eq 1 and tipo eq 'X' then  print, '::::::::: 1ev: condição somente classe X ->'+'::::::::: '+zo[i]
endelse
              

endfor      
endif
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; 
if tipo eq 'EX' or tipo eq 'EM' then begin
if tipo eq 'EM' then begin
times=strarr(3,N_ELEMENTS(tsM))
dates=strarr(N_ELEMENTS(tsM))
dates[*]=data[tsM]
times[0,*]=b_time[tsM] & times[1,*]=pk_time[tsM] & times[2,*]=e_time[tsM]
endif
if tipo eq 'EX' then begin
times=strarr(3,N_ELEMENTS(tsX))
dates=strarr(N_ELEMENTS(tsX))
dates[*]=data[tsX]
times[0,*]=b_time[tsX] & times[1,*]=pk_time[tsX] & times[2,*]=e_time[tsX]
endif
endif
;endfor ; varios arquivos
end