     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2008')
      *****************************************************************
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('Midas ME BIC Plus Database Updater')                   *
      *****************************************************************
      *                                                               *
      *  Midas - Message Management Module                            *
      *                                                               *
      *  ME1461 - BIC Database Plus Update (Delta Update)             *
      *                                                               *
      *  Function:  This program reads the BIC Plus IBAN file and     *
      *             updates the BIC Plus directory file               *
      *                                                               *
      *  Called By: MEC1420 - Midas ME BIC Plus loader                *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2008            *
      *                                                               *
      *  Last Amend No. 262490             Date 07Nov09               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      *  Prev Amend No. CFT040  *CREATE    Date 15Sep08               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  262490 - BIC branch is not being written to MEBICPPD         *
      *  CFT040 - BIC Plus IBAN Utility                               *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  Use of indicators.                                           *
      *                                                               *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  S U B R O U T I N E   I N D E X                              *
      *                                                               *
      *  Main routine                                                 *
      *  SRMAP   -  Mapping of fields from MEBICBPD to MEBICPPD       *
      *  *PSSR   -  Error handling subroutine                         *
      *                                                               *
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
      *
     FMEBICBPD  IF   E             DISK
     FMEBICPL0  UF A E           K DISK
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ D-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
      *
     D BICPLUS       E DS                  EXTNAME(MEBICPPD)
      ** BIC Plus master file records
      *
     D DSFDY         E DS                  EXTNAME(DSFDY)
      ** Short data structure for access objects
      *
      ** The Following /COPY Line Includes All The Defined Fields In
      ** The PSDS.  They Have Meaningful Names, Prefixed By 'PS'.
      *
     D/COPY ZACPYSRC,PSDS
 
      ** +--------------------------------------+
      ** ¦ Arrays AND Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
 
     D BICPMAS         DS
     DMAS_BITAG                1      2
     DMAS_BIFLAG               3      3
     DMAS_BIBIC                4     14
     DMAS_BIINST              15    119
     DMAS_BIBNCH             120    189
     DMAS_BICITY             190    224
     DMAS_BISTYP             225    228
     DMAS_BISERV             229    288
     DMAS_BIXINF             289    323
     DMAS_BIADDR             324    463
     DMAS_BIZIP              464    478
     DMAS_BILOCN             479    568
     DMAS_BICNTY             569    638
     DMAS_BIPOBN             639    673
     DMAS_BIPOBZ             674    688
     DMAS_BIPOBL             689    778
     DMAS_BIPOBC             779    848
     DMAS_BISRCI             849    850
     DMAS_BISPEC             851    856
     DMAS_BIUPDT             857    862
     DMAS_BIORIG             863    866
     DMAS_BIKEY              867    874
     DMAS_BICHCK             875    876
     DMAS_BICHIP             877    882
     DMAS_BINATI             883    897
     DMAS_BIACTD             898    903
     DMAS_BIDCTD             904    909
     DMAS_BIUNDC             910    917
     DMAS_BIUNDN             918    925
     DMAS_BINKEY             926    933
     DMAS_BICFLG             934    934
     DMAS_BICINS             935    935
     DMAS_BIUSER             936   1063
     DMAS_BICBI1            1064   1080
     DMAS_BICBI2            1081   1097
     DMAS_BICBI3            1098   1114
     DMAS_BICBI4            1115   1131
     DMAS_BICBD1            1132   1160
     DMAS_BICBD2            1161   1189
     DMAS_BIMFLG            1190   1190
     DMAS_BIMMTH            1191   1191
     DMAS_BIMRLT            1192   1192
     DMAS_BIFILL            1193   1248
      ** BIC Plus master file records
      *
     D LDA             DS           256
      ** Local data area for database error details
      *
     D  DBFILE               134    141
     D  DBKEY                142    170
     D  DBPGM                171    180
     D  DBASE                181    183  0
     D  DBTXT                184    256
 
      *
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
      *
     D WRun            S              1
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *  MAIN - Processing                                            *
      *****************************************************************
      *
      ** Define LDA
      *
     C     *DTAARA       DEFINE                  LDA
      *
     C     *LOCK         IN        LDA
     C                   MOVEL     'ME1461'      DBPGM
     C                   MOVE      *BLANKS       DBFILE
     C                   MOVE      *BLANKS       DBKEY
     C                   MOVE      *BLANKS       DBTXT
     C                   Z-ADD     0             DBASE
     C                   OUT       LDA
      *
      ** Update BIC Plus database from BIC Plus IBAN
      *
     C                   READ      MEBICBPD
     C                   IF        (%EOF)
     C     *LOCK         IN        LDA
     C                   EVAL      DBASE = 001
     C                   EVAL      DBFILE = 'MEBICBPD'
     C                   EVAL      DBKEY =  '*FIRST'
     C                   OUT       LDA
     C                   EXSR      *PSSR
      *
     C                   ELSE
     C                   DOW       NOT (%EOF(MEBICBPD))
     C                   EXSR      SRMAP
     C     BIKEY         CHAIN     MEBICPL0
     C                   IF        %FOUND(MEBICPL0)
     C                   IF        MAS_BIFLAG = 'M'
     C                   EVAL      BICPLUS = BICPMAS
     C                   UPDATE    @BICPPD
     C                   ENDIF
     C                   IF        MAS_BIFLAG = 'D'
     C                   DELETE    @BICPPD
     C                   ENDIF
      *
     C                   ELSE
     C                   EVAL      BICPLUS = BICPMAS
     C                   WRITE     @BICPPD
     C                   ENDIF
      *
     C                   READ      MEBICBPD
     C                   ENDDO
     C                   ENDIF
      *
      ** Terminate program
      *
     C                   EVAL      *INLR = *ON
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRMAP  -  Mapping of fields from MEBICBPD to MEBICPPD        *
      *  Called by: Main routine                                      *
      *  Calls    : None                                              *
      *                                                               *
      *****************************************************************
      *
     C     SRMAP         BEGSR
     C                   EVAL      MAS_BITAG = BITAG
     C                   EVAL      MAS_BIFLAG = BIFLAG
     C**********         EVAL      MAS_BIBIC = BIUBIC                                         262490
     C                   MOVEL     BIBICC        MAS_BIBIC                                    262490
     C                   MOVE      BIBRCD        MAS_BIBIC                                    262490
     C                   EVAL      MAS_BIINST = BIINST
     C                   EVAL      MAS_BIBNCH = BIBINF
     C                   EVAL      MAS_BICITY = BICITY
     C                   EVAL      MAS_BISTYP = BISTYP
     C                   EVAL      MAS_BISERV = BISERV
     C                   EVAL      MAS_BIXINF = BIBRQA
     C                   EVAL      MAS_BIADDR = BIADDR
     C                   EVAL      MAS_BIZIP = BIZIP
     C                   EVAL      MAS_BILOCN = BILOCN
     C                   EVAL      MAS_BICNTY = BICNTY
     C                   EVAL      MAS_BIPOBN = BIPOBN
     C                   EVAL      MAS_BIPOBZ = BIPOBZ
     C                   EVAL      MAS_BIPOBL = BIPLOC
     C                   EVAL      MAS_BIPOBC = BIPCNT
     C                   EVAL      MAS_BISRCI = *BLANKS
     C                   EVAL      MAS_BISPEC = *BLANKS
     C                   MOVE      BIUDAT        MAS_BIUPDT
     C                   EVAL      MAS_BIORIG = *BLANKS
     C                   EVAL      MAS_BIKEY = BIKEY
     C                   EVAL      MAS_BICHCK = *BLANKS
     C                   EVAL      MAS_BICHIP = BICHIP
     C                   EVAL      MAS_BINATI = BINATI
     C                   EVAL      MAS_BIACTD = *BLANKS
     C                   EVAL      MAS_BIDCTD = *BLANKS
     C                   EVAL      MAS_BIUNDC = *BLANKS
     C                   EVAL      MAS_BIUNDN = *BLANKS
     C                   EVAL      MAS_BINKEY = *BLANKS
     C                   EVAL      MAS_BICFLG = *BLANKS
     C                   EVAL      MAS_BICINS = *BLANKS
     C                   EVAL      MAS_BIUSER = *BLANKS
     C                   EVAL      MAS_BICBI1 = BIOND1
     C                   EVAL      MAS_BICBI2 = BIOND2
     C                   EVAL      MAS_BICBI3 = *BLANKS
     C                   EVAL      MAS_BICBI4 = *BLANKS
     C                   EVAL      MAS_BICBD1 = *BLANKS
     C                   EVAL      MAS_BICBD2 = *BLANKS
     C                   EVAL      MAS_BIMFLG = *BLANKS
     C                   EVAL      MAS_BIMMTH = *BLANKS
     C                   EVAL      MAS_BIMRLT = *BLANKS
     C                   EVAL      MAS_BIFILL = *BLANKS
      *
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  *PSSR   -  File Exception/Error Handling Subroutine          *
      *  Called by: Various                                           *
      *  Calls    : DBERRCTL - DB Error Control                       *
      *                                                               *
      *****************************************************************
      *
     C     *PSSR         BEGSR
      *
     C                   IF        WRun = *BLANKS
     C                   EVAL      WRun = 'Y'
     C                   DUMP
     C                   CALL      'DBERRCTL'
     C                   ENDIF
      *
     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   EVAL      *INLR = *ON
     C                   RETURN
      *
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
