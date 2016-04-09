     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2006')
 **** *****************************************************************
/*STD *  RPGSQLBND                                                    *
/*EXI *  TEXT('Midas SM Update GPCURRPD based on zone SDCURRPD')
 **** *****************************************************************
      *                                                               *
      *  Midas - Implementation module                                *
      *                                                               *
      *  SM000002 - Update GPCURRPD                                   *
      *                                                               *
      *  Function:  This program will update GPCURRPD with records    *
      *             from SDCURRPD                                     *
      *                                                               *
      *  Called By:                                                   *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2006            *
      *  Last Amend No. CFB001             Date 12Nov14               *
      *  Prev Amend No. CTP011             Date 10Jun10               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CPK025  *CREATE    Date 04sep06               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CFB001 - FuisonBanking Midas Rebranding                      *
      *  CTP011 - Bank Fusion Midas Rebranding                        *
      *  CPK025 - Packaging changes for MidasPlus 1.3.                *
      *                                                               *
      *****************************************************************
      *
      * Update GPCURRPD
      *
     C/Exec SQL
     C+ INSERT INTO GPCURRPD SELECT A6CYCD, CYDESC, A6NBDP,1,'M',0,'I',
     C********** + 'MIDASPLUS', A6CDFN, A6ECDN, A6SWCY, A6TXND, A6PRRT, A6SRC1, A6SRC2,      CTP011
     C**********+ 'BANKFUSION', A6CDFN, A6ECDN, A6SWCY, A6TXND, A6PRRT, A6SRC1, A6SRC2,CTP011 CFB001
     C+ '          ', A6CDFN, A6ECDN, A6SWCY, A6TXND, A6PRRT, A6SRC1, A6SRC2,                 CFB001
     C+ A6DLCI, A6SSNB, A6ERLC, A6MDPR, A6MDHB, A6MDEX, A6NOSN, A6SPDY,
     C+ A6HSRT, A6LSPR, A6FXSD, A6MMSD, A6NQDP, A6DICB, A6SCEX, A6EBDA,
     C+ A6HBRT, A6ENC1, A6ENC2, A6CACD, A6CNMC, A6WEDH, A6MONH, A6TUEH,
     C+ A6THUH, A6FRIH, A6SATH, A6SUNH, A6DPBF, A6BYSR, A6BYSS, A6SLSR,
     C+ A6SLSS, A6RMCM, A6RECI, A6DPRU, A6DNOR, A6NDWR, A6GMPY, A6DLCD,
     C+ A6RDFC, A6PMRT, A6RKSQ, A6DFPC, A6DDPC, A6TKCC, A6CQCD, A6SMLD,
     C+ A6ISON, A6ISFC, A6MACD, A6FRAC, A6NUWD, A6MICD, A6INCY, A6EUER,
     C+ A6EUMD, A6TPSD, A6TPED, A6INER, A6INMD, A6DLOC, A6CYPI, A6EXWC,
     C+ A6POWC, A6CYD1, A6CYD2, A6CYD3, A6CYLD, A6CYGR, A6RENO, A6SWDP,
     C+ A6SWDT, A6CLSC, A6EFDT, A6SRDS, A6DFTS, A6SRID, A6SRRP, A6SRTM,
     C+ A6FRDS, A6FRNT, A6BODS, A6BOID, A6LEDS, A6LEID, A6DTFR, A6TLEX,
     C+ A6SETD, A6IRDP, A6FXDY, A6ZONE, A6SPAE, A6FTAE, A6SWAE, A6TAC4,
     C+ A6TAC5, A6CSCD, A6IUSR, A6XUSR, A6AACC, A6EACC, A6GPDT
     C+ FROM (SELECT DISTINCT A6CYCD, A6NBDP, A6CDFN, A6ECDN,
     C+ A6SWCY, A6TXND, A6PRRT, A6SRC1, A6SRC2,
     C+ A6DLCI, A6SSNB, A6ERLC, A6MDPR, A6MDHB, A6MDEX, A6NOSN, A6SPDY,
     C+ A6HSRT, A6LSPR, A6FXSD, A6MMSD, A6NQDP, A6DICB, A6SCEX, A6EBDA,
     C+ A6HBRT, A6ENC1, A6ENC2, A6CACD, A6CNMC, A6WEDH, A6MONH, A6TUEH,
     C+ A6THUH, A6FRIH, A6SATH, A6SUNH, A6DPBF, A6BYSR, A6BYSS, A6SLSR,
     C+ A6SLSS, A6RMCM, A6RECI, A6DPRU, A6DNOR, A6NDWR, A6GMPY, A6DLCD,
     C+ A6RDFC, A6PMRT, A6RKSQ, A6DFPC, A6DDPC, A6TKCC, A6CQCD, A6SMLD,
     C+ A6ISON, A6ISFC, A6MACD, A6FRAC, A6NUWD, A6MICD, A6INCY, A6EUER,
     C+ A6EUMD, A6TPSD, A6TPED, A6INER, A6INMD, A6DLOC, A6CYPI, A6EXWC,
     C+ A6POWC, A6CYD1, A6CYD2, A6CYD3, A6CYLD, A6CYGR, A6RENO, A6SWDP,
     C+ A6SWDT, A6CLSC, A6EFDT, A6SRDS, A6DFTS, A6SRID, A6SRRP, A6SRTM,
     C+ A6FRDS, A6FRNT, A6BODS, A6BOID, A6LEDS, A6LEID, A6DTFR, A6TLEX,
     C+ A6SETD, A6IRDP, A6FXDY, A6ZONE, A6SPAE, A6FTAE, A6SWAE, A6TAC4,
     C+ A6TAC5, A6CSCD, A6IUSR, A6XUSR, A6AACC, A6EACC, A6GPDT  FROM SDCURRPD)
     C+ T INNER JOIN GPICURRPD ON T.A6CYCD = CYCYCD WHERE NOT EXISTS
     C+ (SELECT GCCYCD FROM GPCURRPD WHERE A6CYCD = GCCYCD)
     C/End-Exec
 
      *
      * If there's an SQL error, set on U7 and U8.
     C                   IF        SQLCOD < 0
     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   ENDIF
      *
     C                   EVAL      *INLR = *ON
      *
     C                   RETURN
