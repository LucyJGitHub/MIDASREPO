     H DEBUG DATEDIT(*YMD)
      *****************************************************************
/*S*D****RPGBASE*******************************************************                       LUC109
/*STD *  RPGBASEBND                                                   *                       LUC109
/*EXI *  TEXT('FRA/IRS/CCS EXTRACT')                                  *                       LUC109
      *****************************************************************
      *                                                               *
      *  Midas - Interface to Head Office Reporting                   *
      *                                                               *
      ***GLM042**-*FRA/IRS/CCS*EXTRACT*********************************                       LUC109
      *  XX000042 - FRA/IRS/CCS EXTRACT                               *                       LUC109
      *                                                               *
  ?   *****************************************************************
  ?   * *** THIS PROGRAM MUST BE COMPILED WITH XXINTFLIB AT THE TOP   *
  ?   * OF LIBL ***                                                   *
  ?   *****************************************************************
      *                                                               *
      *  Function: Derivatives Extract                                *
      *                                                               *
      *                                                               *
      ***CALLED*BY**GLCM042*-*GL*FRA/IRS/CCS*Extract*******************                       LUC109
      *  CALLED BY  XXC000042 - GL FRA/IRS/CCS Extract                *                       LUC109
      *             Frequency: Automatically in Close of Business     *
      *                                                               *
      ***(C)*COPYRIGHT*MKI*LIMITED*1998********************************                       LUC109
      *  (c) Finastra International Limited 2016                      *                       LUC109
      *                                                               *
      *  Last Amend No. LUC109             Date 21Sep16               *
      *  Prev Amend No. CM000xxxxx - ND    Date 23Sep14               *
      *                 CM00036425 - ND    Date 10Feb14               *
      *                 MUI011             Date 24May04               *
      *                 MUI009             Date 16Feb04               *
      *                 159964             Date 22Aug99               *
      *                 MMI043             Date 29Dec98               *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  LUC109 - HO Reporting (Upgrade to FB Midas 2.1)              *
      *  CM000xxxxx - Add R306 Netting Agreement Flag to output rec 7 *
      *  CM00036425 - Add Murex Transaction Id to output record       *
      *  MUI011 - ALMS - Add records 5, 6 and 7.                      *
      *  MUI009 - R4.1 Upgrade:                                       *
      *           Added I specs requireds by ZCBDYS                   *
      *           Core subroutine ZINTPL replaced by pgm ZAINTPL      *
      *           Added ZDATE9 which is now required by ZCBDYS        *
      *           Renamed timestamp field on FDINTRPP.                *
      *  159964 - PGM/GLM032A cannot allocate object LF/SDCUSTL0 due  *
      *           to SCC0406.                                         *
      *         - Seton job switches U7/U8 for error processing       *
      *  MMI043 - FRA/IRS/CCS EXTRACT                                 *
      *                                                               *
      *****************************************************************
      *
     FSDBANKPD  IF   E             DISK    INFSR(*PSSR)
     F                                     RECNO(WRECNO)
     FSDGELRPP  IF   E             DISK    INFSR(*PSSR)
     F                                     RECNO(WRECNO)
     FSDGELRPD  IF   E             DISK    INFSR(*PSSR)
     F                                     RECNO(WRECNO)
     FSDBRCHL1  IF   E           K DISK    INFSR(*PSSR)
     FSDINTFPD  IF   E           K DISK    INFSR(*PSSR)
     FDEALGBR   IF   E           K DISK    INFSR(*PSSR)
     FDEALSGY0  IF   E           K DISK    INFSR(*PSSR)                                       LUC109
     FACKEY     IF   E           K DISK    INFSR(*PSSR)
     FSDCURRL0  IF   E           K DISK    INFSR(*PSSR)
     FDLFRARL4  IF   E           K DISK                                         E28216
     FDLINTRL2  IF   E           K DISK                                         E28216
     FDLMMDFL1  IF   E           K DISK                                         E28216
     FDLMPEVV0  IF   E           K DISK    INFSR(*PSSR)                         MUI011
     F***GZSIRSL1  IF   E           K DISK    INFSR(*PSSR)                         CM00036425 LUC109
     FFEDER     O    E             DISK    INFSR(*PSSR)
     F***GLM042AU  O    E             PRINTER INFDS(SPOOL)                                    LUC109
     FXX000042AUO    E             PRINTER INFDS(SPOOL)                                       LUC109
     F                                     INFSR(*PSSR)
      *
      *****************************************************************
      *                                                               *
      *  F U N C T I O N   O F   I N D I C A T O R S                  *
      *                                                               *
      *   20 - LF/SDBRCHL1   File I/O                                 *
      *   21 - LF/DEALGBR    File I/O                                 *
      *                                                               *
      *  90-99    Used by Standard Subroutines                        *
      *                                                               *
      *  89       Database Error                                      *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  S U B R O U T I N E   I N D E X                              *
      *                                                               *
      *  #INIT  - Initial Processing                                  *
      *  #PROC  - Main Processing                                     *
      *  #S200  - Detail Processing                                   *
      *  #ACKEY - Determine Account Codes                             *
      *  #TERM  - Program termination                                 *
      *  *PSSR  - Abnormal termination                                *
      *                                                               *
      *****************************************************************
      * COMPILE TIME ARRAYS                                           *
     D CPY@            S             80    DIM(1) CTDATA PERRCD(1)              Copyright
     D @ERR            S             35    DIM(2) CTDATA PERRCD(1)
      *
      *
      ***File*information*for*printer*file*GLM042AU********************                       LUC109
      ** File information for printer file XX000042AU                                         LUC109
      *
     D SPOOL           DS
     D  WWOFL1               188    189B 0
     D  WWPTL1               367    368B 0
      *
      *
      ** Data structure for data-base error processing
      *
     D DBERR           DS           256
     D  DBFILE               134    141
     D  DBKEY                142    170
     D  DBPGM                171    180
     D  DBASE                181    183  0
      *
      ** Header Record
      *
     D HEADER          DS
     D  FBKCD                  1      3
     D  FGPCD                  4      6
     D  FEXFL                  7     11
     D  FSYSD                 12     19
     D  FLACD                 20     27
     D  FLWDM                 28     35
     D  FNWKD                 36     43
     D  FILL01                44     78
      *
      ** Branch Header Record
      *
     D BRCHHD          DS
     D  FBRCD                  1      3
     D  FILL02                 4     78
      *
      ** Detail Record 1
      *
     D DET001          DS
     D  F1PROG                 1      3
     D  F1BKCD                 4      6
     D  F1BRCD                 7      9
     D  F1CUST                10     15  0
     D  F1MODL                16     18
     D  F1DEAL                19     33
     D  F1DDAT                34     41
     D  F1DTYP                42     43
     D  F1DSTY                44     45
     D  F1INAM                46     64
     D  F1FILL                65     78
      *
      ** Detail Record 2
      *
     D DET002          DS
     D  F2PROG                 1      3
     D  F2CTNA                 4     22
     D  F2CONA                23     41
     D  F2LKRF                42     47  0
     D  F2IFCY                48     50
     D  F2CTCY                51     53
     D  F2COCY                54     56
     D  F2ATDT                57     60  0
     D  F2ATDP                61     64  0
     D  F2FCRT                65     77  8
     D  F2FILL                78     78
      *
      ** Detail Record 3
      *
     D DET003          DS
     D  F3PROG                 1      3
     D  F3ITDR                 4     16  8
     D  F3ITRT                17     17
     D  F3IODR                18     30  8
     D  F3IORT                31     31
     D  F3VDAT                32     39  0
     D  F3MDAT                40     47
     D  F3FBSC                48     48
     D  F3ITBC                49     49
     D  F3IOBC                50     50
     D  F3TIAN                51     69
     D  F3FILL                70     78
      *
      ** Detail Record 4
      *
     D DET004          DS
     D  F4PROG                 1      3
     D  F4OIAN                 4     22
     D  F4ITRD                23     30
     D  F4IORD                31     38
     D  F4NPVL                39     57
     D  F4FRBS                58     58
     D  F4FILL                59     78
      *                                                                   MUI011
      ** Detail Record 5                                                  MUI011
      *                                                                   MUI011
     D DET005          DS                                                       MUI011
     D  F5PROG                 1      3                                         MUI011
     D  C9830                  4      5                                         MUI011
     D  C9852                  6      7                                         MUI011
     D  C9853                  8     15  0                                      MUI011
     D  C9854                 16     24                                         MUI011
     D  C9855                 25     37  8                                      MUI011
     D  C9856                 38     56                                         MUI011
     D  C9857                 57     75                                         MUI011
     D  F5FILL                76     78                                         MUI011
      *                                                                   MUI011
      ** Detail Record 6                                                  MUI011
      *                                                                   MUI011
     D DET006          DS                                                       MUI011
     D  F6PROG                 1      3                                         MUI011
     D  C9858                  4     22                                         MUI011
     D  C9859                 23     41                                         MUI011
     D  C9860                 42     42                                         MUI011
     D  C9861                 43     43                                         MUI011
     D  C9862                 44     44                                         MUI011
     D  C9863                 45     45                                         MUI011
     D  C9864                 46     47                                         MUI011
     D  C9865                 48     49                                         MUI011
     D  C9866                 50     58                                         MUI011
     D  C9867                 59     67                                         MUI011
     D  F6FILL                68     78                                         MUI011
      *                                                                   MUI011
      ** Detail Record 7                                                  MUI011
      *                                                                   MUI011
     D DET007          DS                                                       MUI011
     D  F7PROG                 1      3                                         MUI011
     D  C9884                  4     11  0                                      MUI011
     D  C9885                 12     30                                         MUI011
     D  C9886                 31     31                                         MUI011
     D  C9887                 32     50                                         MUI011
     D******                                 51  78 F7FILL                CM00036425
     D  CMXTN                 51     75                                         CM00036425
     D******                                 76  78 F7FILL                CM00062206
     D  R306FL                76     76                                         CM00062206
     D  F7FILL                77     78                                         CM00062206
      *
      ** Trailer Record
      *
     D TRAILR          DS
     D  FCONT                  1      6  0
     D  FILL04                 7     78
     D* DATESTAMP
     D DATST           DS
     D  @@YY                   1      2
     D  @@YYT                  3      4  0
     D  @SYDT                  3      8
     D* Convert Numeric to Char
     D                 DS
     D  @@DMN                  1      3  0
     D  @@DMA                  1      3
     D* Account Key
     D @@ACK           DS
     D  @ACFL1                 1      2
     D  @ACFL2                 3      3
     D  @ACFL3                 4      5
     D  @ACFIL                 6      8
     D  @ACFL4                 9     10
     D* ERROR DATA STRUCTURE
     D REPAMT          DS
     D  REPCCY                 1      3
     D  REPVAL                 4     18  0
     D/COPY ZSRSRC,ZDATE2Z1LE                                                                 LUC109
     D/COPY ZSRSRC,ZDATE9Z1LE                                                                 LUC109
     D/COPY ZSRSRC,ZPOWERZ1IL                                                                 LUC109
     D/COPY ZSRSRC,ZDAYSZ1LE                                                                  LUC109
     D/COPY ZSRSRC,ZDATE9Z2LE                                                                 LUC109
     D/COPY ZSRSRC,ZDAT10Z1LE                                                                 LUC109
      *                                                                                       LUC109
      ** Data structure for subroutine ZCBDYS                                                 LUC109
     D                 DS                                                                     LUC109
     D  ZZDAT1                 1      8  0                                                    LUC109
     D  ZZYYA                  1      4  0                                                    LUC109
     D  ZZMMA                  5      6  0                                                    LUC109
     D  ZZDDA                  7      8  0                                                    LUC109
      *                                                                                       LUC109
     D                 DS                                                                     LUC109
     D  ZZDAT2                 1      8  0                                                    LUC109
     D  ZZYYB                  1      4  0                                                    LUC109
     D  ZZMMB                  5      6  0                                                    LUC109
     D  ZZDDB                  7      8  0                                                    LUC109
     I***/C*PY*ZSRSRC,ZDATE2Z1                                                                LUC109
     I***/C*PY*ZSRSRC,ZDATE9Z1                                                                LUC109
     I***/C*PY*ZSRSRC,ZPOWERZ1                                                                LUC109
     I***/C*PY*ZSRSRC,ZDAYSZ1                                                                 LUC109
      *
      *
      ** Rename duplicate fields
     IACKEYALF
     I              RECI                        RECIAL
     IACKEYAKF
     I              RECI                        RECIAK
      *                                                                   MUI009
      ** Rename fields                                                    MUI009
     IFDINTRP0                                                                  MUI009
     I              HWTMESTMP                   HWTMES                          MUI009
      *
     I***/C*PY*ZSRSRC,ZCBDYSZ2                                                         MUI009 LUC109
     I***/C*PY*ZSRSRC,ZDATE9Z2                                                         MUI009 LUC109
     I***/C*PY*ZSRSRC,ZDAT10Z1                                                                LUC109
      *****************************************************************
      *
     C                   EXSR      #INIT                                        Housekeeping
      *
     C                   EXSR      #PROC                                        Main process
      *
     C                   EXSR      #TERM                                        Termination
      *
      *****************************************************************
      *                                                               *
      *  INIT   - Subroutine to do Program Initialisation.            *
      *                                                               *
      *  Called By: Main Processing                                   *
      *  Calls    : None                                              *
      *                                                               *
      *****************************************************************
      *
     C     #INIT         BEGSR                                                  Initialisation
      *
      ** Initialise Database Error data structure
      *
     C     *DTAARA       DEFINE    LDA           WLDA            256
     C     *LOCK         IN        WLDA
     C                   MOVEL     WLDA          DBERR
     C                   OUT       WLDA
     C                   MOVE      *BLANKS       DBFILE
     C                   MOVE      *BLANKS       DBKEY
     C                   MOVE      *BLANKS       DBPGM
     C                   Z-ADD     0             DBASE
      ** Key list/parameter list definition
      *
     C     KHV0          KLIST                                                                 MUI01
     C                   KFLD                    HDLNO                                         MUI01
     C                   KFLD                    HRCDT                                         MUI01
     C                   KFLD                    HOUTF                                         MUI01
      *
      ***Set*Up*key*to*chain*to*GZSIRSL1*******************************            CM00036425 LUC109
     C*****MXKEY         KLIST                                                          CM000 LUC109
     C**********         KFLD                    WZONE                                  CM000 LUC109
     C**********         KFLD                    CHDLNO                                 CM000 LUC109
      *                                                                   CM00036425
     C                   MOVEL     'LONDON'      WZONE            10                           CM000
      *
      ** Initial housekeeping
      *
     C                   MOVEA     CPY@          BIS@             80            Copyright
     C                   MOVE      'N'           @@PSSR            1            *PSSR Control
     C                   MOVE      *OFF          *IN98
      *
     C                   Z-ADD     1             WRECNO            5 0
     C     WRECNO        CHAIN     SDBANKPD                           88        Bank details
      *
     C     *IN88         IFEQ      *ON                                          Ended in error
     C                   MOVEL     '001'         DBASE                          ***************
     C                   MOVEL     'SDBANKPD'    DBFILE                         * DB ERR  001 *
     C                   MOVE      *BLANKS       DBKEY                          ***************
     C                   EXSR      *PSSR
     C                   ENDIF
      *
     C                   Z-ADD     1             WRECNO            5 0
     C     WRECNO        CHAIN     SDGELRPP                           88        Bank Extension
      *
     C     *IN88         IFEQ      *ON                                          Ended in error
     C                   MOVEL     '002'         DBASE                          ***************
     C                   MOVEL     'SDGELRPP'    DBFILE                         * DB ERR  002 *
     C                   MOVE      *BLANKS       DBKEY                          ***************
     C                   EXSR      *PSSR
     C                   ENDIF
      * Determine which Branch is used for bank/company code
     C     BJSLCD        CHAIN     SDINTFPD                           88        Bank Extension
      *
     C     *IN88         IFEQ      *ON                                          Ended in error
     C                   MOVEL     '003'         DBASE                          ***************
     C                   MOVEL     'SDINTFPD'    DBFILE                         * DB ERR  003 *
     C                   MOVE      *BLANKS       DBKEY                          ***************
     C                   EXSR      *PSSR
     C                   ENDIF
      * Determine Bank/company code for header
     C     S9BRCH        CHAIN     SDBRCHL1                           88        Branch
      *
     C     *IN88         IFEQ      *ON                                          Ended in error
     C                   MOVEL     '004'         DBASE                          ***************
     C                   MOVEL     'SDBRCHL1'    DBFILE                         * DB ERR  004 *
     C                   MOVE      *BLANKS       DBKEY                          ***************
     C                   EXSR      *PSSR
     C                   ENDIF
      *
     C                   Z-ADD     1             WRECNO
     C     WRECNO        CHAIN     SDGELRPD                           88        Gl ICD
      *
     C     *IN88         IFEQ      *ON                                          Ended in error
     C                   MOVEL     '006'         DBASE                          ***************
     C                   MOVEL     'SDGELRPD'    DBFILE                         * DB ERR  006 *
     C                   MOVE      *BLANKS       DBKEY                          ***************
     C                   EXSR      *PSSR
     C                   ENDIF
      *
      *
     C                   MOVE      *BLANKS       FILL01
     C                   MOVE      *BLANKS       FILL02
     C                   MOVE      *BLANKS       F1FILL
     C                   MOVE      *BLANKS       F2FILL
     C                   MOVE      *BLANKS       F3FILL
     C                   MOVE      *BLANKS       F4FILL
     C                   MOVE      *BLANKS       FILL04
     C                   MOVE      '001'         F1PROG
     C                   MOVE      '002'         F2PROG
     C                   MOVE      '003'         F3PROG
     C                   MOVE      '004'         F4PROG
     C                   MOVE      *BLANKS       @ACFIL
      *
      * SET UP HEADER FIELDS
      *
     C                   MOVE      A8CMCD        FBKCD
     C                   MOVE      BJSLCD        FGPCD
     C                   MOVEL     'FEDER'       FEXFL
      * System Date
     C                   MOVE      UDATE         @SYDT
     C     @@YYT         IFGT      50
     C                   MOVE      '19'          @@YY
     C                   ELSE
     C                   MOVE      '20'          @@YY
     C                   ENDIF
     C                   MOVE      DATST         FSYSD
      *
      * Last Accounting Date
     C                   MOVE      MLACT         FLACD
      * Last Working Day of Month
     C                   MOVE      MMDAT         FLWDM
      * Next Working Day
     C**********         CALL      'GLM053'                                                   LUC109
     C                   CALL      'XX000053'                                                 LUC109
     C                   PARM                    BJDNWD
     C                   PARM      *ZERO         WFNWKD            8 0
      *
     C                   MOVE      WFNWKD        FNWKD
      *
      *  Write Header Record
     C                   MOVE      '00'          RECC
     C                   MOVE      HEADER        DATA
     C                   WRITE     FEDERF
     C                   Z-ADD     1             COUNT             6 0
      *
     C                   Z-ADD     *ZERO         ERRCNT            6 0
      * Write Error Report Header
     C                   WRITE     ERRHDR
      *
     C                   ENDSR
      *
      *****************************************************************
      *                                                               *
      *  #PROC  -  Main process                                       *
      *                                                               *
      *  Called By: Main line                                         *
      *  Calls: S200                                                  *
      *                                                               *
      *****************************************************************
      *
     C     #PROC         BEGSR
      *
      * Read all Branches
      *
     C     *LOVAL        SETLL     SDBRCHL1
     C                   READ      SDBRCHL1                               20
      *
      *
     C     *IN20         DOWEQ     *OFF                                         Until eof
      * Branch Code
     C                   MOVE      A8BRCD        FBRCD
      *
      *  Write Branch Header Record
     C                   MOVE      '02'          RECC
     C                   MOVE      BRCHHD        DATA
     C                   WRITE     FEDERF
     C                   ADD       1             COUNT
      *
     C                   MOVE      A8CMCD        F1BKCD
     C                   MOVE      FBRCD         F1BRCD
     C                   MOVE      '05'          RECC
      *
      *   Generate Detail Records
     C                   EXSR      #S200
      *
      *
      *  Write Branch Trailer Record
     C                   MOVE      '09'          RECC
     C                   MOVE      *BLANKS       DATA
     C                   WRITE     FEDERF
     C                   ADD       1             COUNT
      *
      *
      *
      *  Read Next record
     C                   READ      SDBRCHL1                               20
      *
      *
     C                   ENDDO
      *
     C                   ENDSR
      *****************************************************************
      *                                                               *
      *  #S200  -  Generate Detail Records                            *
      *                                                               *
      *  Called By: #PROC                                             *
      *  Calls:     #S201 #S202 #S203 #S204 #S205 #S206 #S207         *
      *                                                               *
      *****************************************************************
      *
     C     #S200         BEGSR
      *
      * Read all Deals for the branch
      *
     C     FBRCD         SETLL     DEALGBR
     C     FBRCD         READE     DEALGBR                                21
      *
      *
     C     *IN21         DOWEQ     *OFF                                         Until eof
      *
      *
     C                   EXSR      #S201
      *
      *  Write Detail Record 1
     C                   MOVE      DET001        DATA
     C                   WRITE     FEDERF
     C                   ADD       1             COUNT
      *
      *
     C                   EXSR      #S202
      *
      *  Write Detail Record 2
     C                   MOVE      DET002        DATA
     C                   WRITE     FEDERF
     C                   ADD       1             COUNT
      *
     C                   EXSR      #S203
      *
      *  Write Detail Record 3
     C                   MOVE      DET003        DATA
     C                   WRITE     FEDERF
     C                   ADD       1             COUNT
      *
      *
     C                   EXSR      #S204
      *
      *  Write Detail Record 4
     C                   MOVE      DET004        DATA
     C                   WRITE     FEDERF
     C                   ADD       1             COUNT
      *                                                                   MUI011
      *                                                                   MUI011
     C                   EXSR      #S205                                                       MUI01
      *                                                                   MUI011
      *  Write Detail Record 5                                            MUI011
     C                   MOVE      DET005        DATA                                          MUI01
     C                   WRITE     FEDERF                                                      MUI01
     C                   ADD       1             COUNT                                         MUI01
      *                                                                   MUI011
      *                                                                   MUI011
     C                   EXSR      #S206                                                       MUI01
      *                                                                   MUI011
      *  Write Detail Record 6                                            MUI011
     C                   MOVE      DET006        DATA                                          MUI01
     C                   WRITE     FEDERF                                                      MUI01
     C                   ADD       1             COUNT                                         MUI01
      *                                                                   MUI011
      *                                                                   MUI011
     C                   EXSR      #S207                                                       MUI01
      *                                                                   MUI011
      *  Write Detail Record 7                                            MUI011
     C                   MOVE      DET007        DATA                                          MUI01
     C                   WRITE     FEDERF                                                      MUI01
     C                   ADD       1             COUNT                                         MUI01
      *
      *  Read Next record
     C     FBRCD         READE     DEALGBR                                21
      *
      *
     C                   ENDDO
      *
      *
     C                   ENDSR
      *****************************************************************
      *                                                               *
      *  #S201  -  Set up Detail records 1                            *
      *                                                               *
      *  Called By: #S200                                             *
      *  Calls:     #ERR                                              *
      *                                                               *
      *****************************************************************
      *
     C     #S201         BEGSR
      *
      * Counterparty Customer Number
     C                   MOVE      CNUM          F1CUST
      * Module Code
     C                   MOVE      'DL '         F1MODL
      * Deal Number
     C                   MOVE      *BLANKS       F1DEAL
     C                   MOVEL     DLNO          F1DEAL
      * Deal Date
     C**********         CALL      'GLM053'                                                   LUC109
     C                   CALL      'XX000053'                                                 LUC109
     C                   PARM                    DDAT
     C                   PARM      *ZERO         W1DDAT            8 0
     C                   MOVE      W1DDAT        F1DDAT
      * Deal Type
     C                   MOVE      DTYP          F1DTYP
      * Deal Sub-Type
     C                   MOVE      DLST          F1DSTY
      * IRS and FRA Notional Amount
     C     UCUCY         IFNE      *BLANKS
      *
     C     DTYP          IFNE      'RX'
     C                   Z-ADD     UPAMT         @@AMT
     C                   ELSE
     C                   Z-ADD     *ZERO         @@AMT
     C                   ENDIF
      *
     C                   MOVE      'N'           IERROR            1
     C**********         CALL      'GLM041'                                                   LUC109
     C                   CALL      'XX000041'                                                 LUC109
     C                   PARM                    UCUCY
     C                   PARM                    @@AMT
     C                   PARM                    F1INAM
     C                   PARM                    IERROR
      *
     C     IERROR        IFEQ      'Y'                                          Ended in error
     C                   MOVE      *BLANKS       REPPRG
     C                   MOVE      *BLANKS       REPMSG
     C                   MOVE      *BLANKS       REPKEY
     C                   MOVE      *BLANKS       REPDTA
     C                   MOVEL     F1DEAL        REPACN
     C                   MOVEL     '#S201'       REPPRG
     C                   MOVEL     @ERR(1)       REPMSG
     C                   MOVEL     '*NONE'       REPKEY
     C                   MOVE      UCUCY         REPCCY
     C                   Z-ADD     @@AMT         REPVAL
     C                   MOVEL     REPAMT        REPDTA
     C                   EXSR      #ERR
     C                   MOVE      *BLANKS       F1INAM
     C                   ENDIF
      *
     C                   ELSE
     C                   MOVE      *BLANKS       F1INAM
     C                   ENDIF
      *
     C                   ENDSR
      *****************************************************************
      *                                                               *
      *  #S202  -  Set up Detail records 2                            *
      *                                                               *
      *  Called By: #S200                                             *
      *  Calls:     #ERR #ACKEY
      *                                                               *
      *****************************************************************
      *
     C     #S202         BEGSR
      *
      * CCS their details Notional Amount
     C     TCUCY         IFNE      *BLANKS
      *
     C     DTYP          IFEQ      'RX'
     C                   Z-ADD     TPAMT         @@AMT
     C                   ELSE
     C                   Z-ADD     *ZERO         @@AMT
     C                   ENDIF
      *
     C                   MOVE      'N'           IERROR            1
     C**********         CALL      'GLM041'                                                   LUC109
     C                   CALL      'XX000041'                                                 LUC109
     C                   PARM                    TCUCY
     C                   PARM                    @@AMT            15 0
     C                   PARM                    F2CTNA
     C                   PARM                    IERROR
      *
     C     IERROR        IFEQ      'Y'                                          Ended in error
     C                   MOVE      *BLANKS       REPPRG
     C                   MOVE      *BLANKS       REPMSG
     C                   MOVE      *BLANKS       REPKEY
     C                   MOVE      *BLANKS       REPDTA
     C                   MOVEL     F1DEAL        REPACN
     C                   MOVEL     '#S202'       REPPRG
     C                   MOVEL     @ERR(1)       REPMSG
     C                   MOVEL     '*NONE'       REPKEY
     C                   MOVE      TCUCY         REPCCY
     C                   Z-ADD     @@AMT         REPVAL
     C                   MOVEL     REPAMT        REPDTA
     C                   EXSR      #ERR
     C                   MOVE      *BLANKS       F2CTNA
     C                   ENDIF
      *
     C                   ELSE
     C                   MOVE      *BLANKS       F2CTNA
     C                   ENDIF
      *
      * CCS our details Notional Amount
     C     UCUCY         IFNE      *BLANKS
      *
     C     DTYP          IFEQ      'RX'
     C                   Z-ADD     UPAMT         @@AMT
     C                   ELSE
     C                   Z-ADD     *ZERO         @@AMT
     C                   ENDIF
      *
     C                   MOVE      'N'           IERROR            1
     C**********         CALL      'GLM041'                                                   LUC109
     C                   CALL      'XX000041'                                                 LUC109
     C                   PARM                    UCUCY
     C                   PARM                    @@AMT
     C                   PARM                    F2CONA
     C                   PARM                    IERROR
      *
     C     IERROR        IFEQ      'Y'                                          Ended in error
     C                   MOVE      *BLANKS       REPPRG
     C                   MOVE      *BLANKS       REPMSG
     C                   MOVE      *BLANKS       REPKEY
     C                   MOVE      *BLANKS       REPDTA
     C                   MOVEL     F1DEAL        REPACN
     C                   MOVEL     '#S202'       REPPRG
     C                   MOVEL     @ERR(1)       REPMSG
     C                   MOVEL     '*NONE'       REPKEY
     C                   MOVE      UCUCY         REPCCY
     C                   Z-ADD     @@AMT         REPVAL
     C                   MOVEL     REPAMT        REPDTA
     C                   EXSR      #ERR
     C                   MOVE      *BLANKS       F2CONA
     C                   ENDIF
      *
     C                   ELSE
     C                   MOVE      *BLANKS       F2CONA
     C                   ENDIF
      *
      * Linked Reference Number
     C     DTYP          IFEQ      'RX'
     C                   Z-ADD     LNKDN         F2LKRF
     C                   ELSE
     C                   Z-ADD     0             F2LKRF
     C                   ENDIF
      *
      * IRS and FRA Currency Code
     C     DTYP          IFNE      'RX'
     C                   MOVE      UCUCY         F2IFCY
     C                   ELSE
     C                   MOVE      *BLANKS       F2IFCY
     C                   ENDIF
      *
      * CCS their details currency Code
     C     DTYP          IFEQ      'RX'
     C                   MOVE      TCUCY         F2CTCY
     C                   ELSE
     C                   MOVE      *BLANKS       F2CTCY
     C                   ENDIF
      *
      * CCS our details currency Code
     C     DTYP          IFEQ      'RX'
     C                   MOVE      UCUCY         F2COCY
     C                   ELSE
     C                   MOVE      *BLANKS       F2COCY
     C                   ENDIF
      *
      *
      *
      * Set up Standard part of account Key
     C                   MOVE      DTYP          @ACFL1
     C                   MOVE      'D'           @ACFL2
     C                   MOVE      DLST          @ACFL3
     C     DTYP          IFEQ      'RX'
     C                   MOVE      'TA'          @ACFL4
     C                   ELSE
     C                   MOVE      ' A'          @ACFL4
     C                   ENDIF
     C                   EXSR      #ACKEY
      *
      * Account Type Code: contingent accounts - their details
     C                   Z-ADD     @@ACC1        F2ATDT
      *
      * Account Type Code: contingent accounts - their deposit
     C                   Z-ADD     @@ACC2        F2ATDP
      *
      * FRA Contact Rate
     C                   Z-ADD     *ZERO         F2FCRT
     C     DTYP          IFEQ      'FR'
     C     BYSL          IFEQ      'S'
     C                   Z-ADD     TEINR         F2FCRT
     C                   ELSE
     C                   Z-ADD     UEINR         F2FCRT
     C                   ENDIF
     C                   ENDIF
      *
     C                   ENDSR
      *****************************************************************
      *                                                               *
      *  #S203  -  Set up Detail records 3                            *
      *                                                               *
      *  Called By: #S200                                             *
      *  Calls:     #ERR                                              *
      *                                                               *
      *****************************************************************
      *
     C     #S203         BEGSR
      *
     C     DTYP          IFNE      'FR'
      *
      * IRS and CCS: their details rate
     C                   Z-ADD     TEINR         F3ITDR
      *
      * IRS and CCS: their details rate type
     C     TBRTT         IFEQ      *ZERO
     C                   MOVE      '0'           F3ITRT
     C                   ELSE
     C                   MOVE      '1'           F3ITRT
     C                   ENDIF
      *
      * IRS and CCS: our details rate
     C***        BYSL      IFEQ 'B'
     C***                  Z-ADDUEINR     F3IODR
     C***                  ELSE
     C***                  Z-ADDTEINR     F3IODR
     C***                  ENDIF
     C     BYSL          IFEQ      'S'
     C                   Z-ADD     TEINR         F3IODR
     C                   ELSE
     C                   Z-ADD     UEINR         F3IODR
     C                   ENDIF
      *
      * IRS and CCS: our details rate type
     C     UBRTT         IFEQ      *ZERO
     C                   MOVE      '0'           F3IORT
     C                   ELSE
     C                   MOVE      '1'           F3IORT
     C                   ENDIF
      *
      * Null Values
     C                   ELSE
      *
     C                   Z-ADD     *ZERO         F3ITDR
      *
     C                   MOVE      *BLANK        F3ITRT
      *
     C                   Z-ADD     *ZERO         F3IODR
      *
     C                   MOVE      *BLANK        F3IORT
      *
     C                   ENDIF
      * Value Date
     C**********         CALL      'GLM053'                                                   LUC109
     C                   CALL      'XX000053'                                                 LUC109
     C                   PARM                    VDAT
     C                   PARM      *ZERO         W3VDAT            8 0
     C                   MOVE      W3VDAT        F3VDAT
      * Maturity Date
     C**********         CALL      'GLM053'                                                   LUC109
     C                   CALL      'XX000053'                                                 LUC109
     C                   PARM                    MDAT
     C                   PARM      *ZERO         W3MDAT            8 0
     C                   MOVE      W3MDAT        F3MDAT
      *
      *
     C     DTYP          IFEQ      'FR'
      *
      * FRA Basis Code
     C                   MOVE      UICBS         F3FBSC
      *
      * IRS and CCS their detail Basis Code
     C                   MOVE      '0'           F3ITBC
      *
      * IRS and CCS our detail Basis Code
     C                   MOVE      '0'           F3IOBC
      *
     C                   ELSE
      * FRA Basis Code
     C                   MOVE      '0'           F3FBSC
      *
      * IRS and CCS their detail Basis Code
     C                   MOVE      TICBS         F3ITBC
      *
      * IRS and CCS our detail Basis Code
     C                   MOVE      UICBS         F3IOBC
      *
     C                   ENDIF
      *
      * Their details: Interest accrued at the month and not yet paid??
     C     DTYP          IFNE      'FR'
     C     TCUCY         ANDNE     *BLANKS
     C     TAIAN         ADD       TAIPD         @@AMT
     C                   SUB       TIPRD         @@AMT
     C                   ELSE
     C                   Z-ADD     0             @@AMT
     C                   ENDIF
      *
     C                   MOVE      'N'           IERROR            1
     C**********         CALL      'GLM041'                                                   LUC109
     C                   CALL      'XX000041'                                                 LUC109
     C                   PARM                    TCUCY
     C                   PARM                    @@AMT
     C                   PARM                    F3TIAN
     C                   PARM                    IERROR
      *
     C     IERROR        IFEQ      'Y'                                          Ended in error
     C                   MOVE      *BLANKS       REPPRG
     C                   MOVE      *BLANKS       REPMSG
     C                   MOVE      *BLANKS       REPKEY
     C                   MOVE      *BLANKS       REPDTA
     C                   MOVEL     F1DEAL        REPACN
     C                   MOVEL     '#S203'       REPPRG
     C                   MOVEL     @ERR(1)       REPMSG
     C                   MOVEL     '*NONE'       REPKEY
     C                   MOVE      TCUCY         REPCCY
     C                   Z-ADD     @@AMT         REPVAL
     C                   MOVEL     REPAMT        REPDTA
     C                   EXSR      #ERR
     C                   MOVE      *BLANKS       F3TIAN
     C                   ENDIF
      *
     C                   ENDSR
      *****************************************************************
      *                                                               *
      *  #S204  -  Set up Detail records 4                            *
      *                                                               *
      *  Called By: #S200                                             *
      *  Calls:                                                       *
      *                                                               *
      *****************************************************************
      *
     C     #S204         BEGSR
      *
      * Our details: Interest accrued at the month and not yet paid
     C     DTYP          IFNE      'FR'
     C     UCUCY         ANDNE     *BLANKS
     C     UAIAN         ADD       UAIPD         @@AMT
     C                   SUB       UIPRD         @@AMT
     C                   ELSE
     C                   Z-ADD     0             @@AMT
     C                   ENDIF
      *
     C                   MOVE      'N'           IERROR
     C**********         CALL      'GLM041'                                                   LUC109
     C                   CALL      'XX000041'                                                 LUC109
     C                   PARM                    UCUCY
     C                   PARM                    @@AMT
     C                   PARM                    F4OIAN
     C                   PARM                    IERROR
      *
     C     IERROR        IFEQ      'Y'                                          Ended in error
     C                   MOVE      *BLANKS       REPPRG
     C                   MOVE      *BLANKS       REPMSG
     C                   MOVE      *BLANKS       REPKEY
     C                   MOVE      *BLANKS       REPDTA
     C                   MOVEL     F1DEAL        REPACN
     C                   MOVEL     '#S204'       REPPRG
     C                   MOVEL     @ERR(1)       REPMSG
     C                   MOVEL     '*NONE'       REPKEY
     C                   MOVE      UCUCY         REPCCY
     C                   Z-ADD     @@AMT         REPVAL
     C                   MOVEL     REPAMT        REPDTA
     C                   EXSR      #ERR
     C                   MOVE      *BLANKS       F4OIAN
     C                   ENDIF
      *
      * IRS and CCS their details: floating rate change date
     C     DTYP          IFNE      'FR'
     C**********         CALL      'GLM053'                                                   LUC109
     C                   CALL      'XX000053'                                                 LUC109
     C                   PARM                    TNICD
     C                   PARM      *ZERO         W4ITRD            8 0
     C                   MOVE      W4ITRD        F4ITRD
     C                   ELSE
     C                   MOVE      *BLANKS       F4ITRD
     C                   ENDIF
      *
      * IRS and CCS our details: floating rate change date
     C     DTYP          IFNE      'FR'
     C**********         CALL      'GLM053'                                                   LUC109
     C                   CALL      'XX000053'                                                 LUC109
     C                   PARM                    UNICD
     C                   PARM      *ZERO         W4IORD            8 0
     C                   MOVE      W4IORD        F4IORD
     C                   ELSE
     C                   MOVE      *BLANKS       F4IORD
     C                   ENDIF
      *
      * Net Present Value FRA
     C                   MOVE      *BLANKS       F4NPVL
      *
     C     DTYP          IFEQ      'FR'
     C     RECI          ANDEQ     'D'
     C     BJRDNB        ANDLE     VDAT
      *
     C                   EXSR      #CALC
      *
     C     *IN20         IFEQ      '1'
     C     SETF          ANDEQ     'G'                                                         AUS02
     C     *IN21         OREQ      '1'
     C                   Z-ADD     0             @@AMT
     C                   ELSE
     C                   Z-ADD     WPLNPV        @@AMT
     C                   ENDIF
      *
     C     UCUCY         IFNE      *BLANKS
     C                   MOVE      'N'           IERROR
     C**********         CALL      'GLM041'                                                   LUC109
     C                   CALL      'XX000041'                                                 LUC109
     C                   PARM                    UCUCY
     C                   PARM                    @@AMT
     C                   PARM                    F4NPVL
     C                   PARM                    IERROR
      *
     C     IERROR        IFEQ      'Y'                                          Ended in error
     C                   MOVE      *BLANKS       REPPRG
     C                   MOVE      *BLANKS       REPMSG
     C                   MOVE      *BLANKS       REPKEY
     C                   MOVE      *BLANKS       REPDTA
     C                   MOVEL     F1DEAL        REPACN
     C                   MOVEL     '#S204'       REPPRG
     C                   MOVEL     @ERR(1)       REPMSG
     C                   MOVEL     '*NONE'       REPKEY
     C                   MOVE      UCUCY         REPCCY
     C                   Z-ADD     @@AMT         REPVAL
     C                   MOVEL     REPAMT        REPDTA
     C                   EXSR      #ERR
     C                   MOVE      *BLANKS       F4NPVL
     C                   ENDIF
      *
     C                   ENDIF
     C                   ENDIF
      *
      * Net Present Value IRS
     C     DTYP          IFNE      'FR'
     C     RECI          ANDEQ     'D'
     C     BJRDNB        ANDLE     MDAT
      *
     C**********         CALL      'GLM050'                                                   LUC109
     C                   CALL      'XX000050'                                                 LUC109
     C                   PARM                    DLNO
     C                   PARM      *ZEROS        @@AMT
     C                   PARM      *BLANKS       PRTCD             1
      *
     C                   MOVE      'N'           IERROR
      *
     C     DTYP          IFEQ      'RX'
     C**********         CALL      'GLM041'                                                   LUC109
     C                   CALL      'XX000041'                                                 LUC109
     C                   PARM                    BJCYCD
     C                   PARM                    @@AMT
     C                   PARM                    F4NPVL
     C                   PARM                    IERROR
     C                   ELSE
     C     UCUCY         IFNE      *BLANKS
     C**********         CALL      'GLM041'                                                   LUC109
     C                   CALL      'XX000041'                                                 LUC109
     C                   PARM                    UCUCY
     C                   PARM                    @@AMT
     C                   PARM                    F4NPVL
     C                   PARM                    IERROR
     C                   ENDIF
     C                   ENDIF
      *
     C     IERROR        IFEQ      'Y'                                          Ended in error
     C                   MOVE      *BLANKS       REPPRG
     C                   MOVE      *BLANKS       REPMSG
     C                   MOVE      *BLANKS       REPKEY
     C                   MOVE      *BLANKS       REPDTA
     C                   MOVEL     F1DEAL        REPACN
     C                   MOVEL     '#S204'       REPPRG
     C                   MOVEL     @ERR(1)       REPMSG
     C                   MOVEL     '*NONE'       REPKEY
     C     DTYP          IFEQ      'RX'
     C                   MOVE      BJCYCD        REPCCY
     C                   ELSE
     C                   MOVE      UCUCY         REPCCY
     C                   ENDIF
     C                   Z-ADD     @@AMT         REPVAL
     C                   MOVEL     REPAMT        REPDTA
     C                   EXSR      #ERR
     C                   MOVE      *BLANKS       F4NPVL
     C                   ENDIF
      *
     C                   ENDIF
      *
      * FRA Buy or Sell
     C     DTYP          IFEQ      'FR'
     C     BYSL          IFEQ      'S'
     C                   MOVE      '1'           F4FRBS
     C                   ELSE
     C                   MOVE      '0'           F4FRBS
     C                   ENDIF
     C                   ELSE
     C                   MOVE      *BLANK        F4FRBS
     C                   ENDIF
      *
     C                   ENDSR
      /EJECT                                                              MUI011
      *****************************************************************   MUI011
      *                                                               *   MUI011
      *  #S205  -  Set up Detail records 5                            *   MUI011
      *                                                               *   MUI011
      *  Called By: #S200                                             *   MUI011
      *  Calls:                                                       *   MUI011
      *                                                               *   MUI011
      *****************************************************************   MUI011
      *                                                                   MUI011
     C     #S205         BEGSR                                                                 MUI01
      *                                                                   MUI011
      * Reset work fields                                                 MUI011
      *                                                                   MUI011
     C                   CLEAR                   DET005                                        MUI01
     C                   MOVE      '005'         F5PROG                                        MUI01
      *                                                                   MUI011
      * C9830 - Book Code                                                 MUI011
      *                                                                   MUI011
     C                   MOVE      BOKC          C9830                                         MUI01
      *                                                                   MUI011
      * C9852 - FRA Base Rate Code                                        MUI011
      *                                                                   MUI011
     C     DTYP          IFEQ      'FR'                                                        MUI01
      *                                                                   MUI011
     C     BYSL          IFEQ      'B'                                                         MUI01
     C                   MOVE      TBRTT         C9852                                         MUI01
     C                   ELSE                                                                  MUI01
     C                   MOVE      UBRTT         C9852                                         MUI01
     C                   ENDIF                                                                 MUI01
      *                                                                   MUI011
      * C9853 - FRA Fixing Date                                           MUI011
      *                                                                   MUI011
     C     BYSL          IFEQ      'B'                                                         MUI01
     C                   MOVE      TINFD         P@DAY                                         MUI01
     C                   ELSE                                                                  MUI01
     C                   MOVE      UINFD         P@DAY                                         MUI01
     C                   ENDIF                                                                 MUI01
     C**********         CALL      'GLM053'                                                   LUC109
     C                   CALL      'XX000053'                                                 LUC109
     C                   PARM                    P@DAY             5 0                         MUI01
     C                   PARM                    P@DATE            8 0                         MUI01
     C                   Z-ADD     P@DATE        C9853                                         MUI01
      *                                                                   MUI011
      * C9854 - Field suppressed                                          MUI011
      *                                                                   MUI011
      * C9855 - Floating Rate already fixed                               MUI011
      *                                                                   MUI011
     C     BJRDNB        IFGE      UINFD                                                       MUI01
     C     BJRDNB        ANDGE     TINFD                                                       MUI01
     C     BYSL          IFEQ      'B'                                                         MUI01
     C                   Z-ADD(H)  TEINR         WK9855           13 8                         MUI01
     C                   ELSE                                                                  MUI01
     C                   Z-ADD(H)  UEINR         WK9855                                        MUI01
     C                   ENDIF                                                                 MUI01
     C                   MOVE      WK9855        C9855                                         MUI01
     C                   ENDIF                                                                 MUI01
      *                                                                   MUI011
      * C9856 - FRA - Settled Amount                                      MUI011
      *                                                                   MUI011
     C     TIPRD         SUB       UIPRD         @@AMT                                         MUI01
     C**********         CALL      'GLM041'                                                   LUC109
     C                   CALL      'XX000041'                                                 LUC109
     C                   PARM                    UCUCY                                         MUI01
     C                   PARM                    @@AMT                                         MUI01
     C                   PARM                    C9856                                         MUI01
     C                   PARM                    IERROR                                        MUI01
      *                                                                   MUI011
      * C9857 - Field suppressed                                          MUI011
      *                                                                   MUI011
     C                   ENDIF                                                                 MUI01
      *                                                                   MUI011
     C                   ENDSR                                                                 MUI01
      /EJECT                                                              MUI011
      *****************************************************************   MUI011
      *                                                               *   MUI011
      *  #S206  -  Set up Detail records 6                            *   MUI011
      *                                                               *   MUI011
      *  Called By: #S200                                             *   MUI011
      *  Calls:                                                       *   MUI011
      *                                                               *   MUI011
      *****************************************************************   MUI011
      *                                                                   MUI011
     C     #S206         BEGSR                                                                 MUI01
      *                                                                   MUI011
      * Reset work fields                                                 MUI011
      *                                                                   MUI011
     C                   CLEAR                   DET006                                        MUI01
     C                   MOVE      '006'         F6PROG                                        MUI01
      *                                                                   MUI011
      * C9858 - IRS and CIRS: Their Accrued Interest month to date        MUI011
      *                                                                   MUI011
     C     DTYP          IFNE      'FR'                                                        MUI01
      *                                                                   MUI011
      * Access history record with interest accrued until previous eom    MUI011
      *                                                                   MUI011
     C                   Z-ADD     DLNO          HDLNO                                         MUI01
     C                   MOVE      'T'           HRCDT                                         MUI01
     C                   MOVE      'EOM'         HOUTF                                         MUI01
     C                   Z-ADD     *ZERO         HEAMT                                         MUI01
      *                                                                   MUI011
     C     KHV0          CHAIN     DLMPEVP0                           04                       MUI01
      *                                                                   MUI011
     C     TAIPD         SUB       HEAMT         @@AMT                                         MUI01
     C**********         CALL      'GLM041'                                                   LUC109
     C                   CALL      'XX000041'                                                 LUC109
     C                   PARM                    TCUCY                                         MUI01
     C                   PARM                    @@AMT                                         MUI01
     C                   PARM                    C9858                                         MUI01
     C                   PARM                    IERROR                                        MUI01
      *                                                                   MUI011
      * C9859 - IRS and CIRS: Our Accrued Interest month to date          MUI011
      *                                                                   MUI011
      * Access history record with interest accrued until previous eom    MUI011
      *                                                                   MUI011
     C                   MOVE      'U'           HRCDT                                         MUI01
     C                   Z-ADD     *ZERO         HEAMT                                         MUI01
      *                                                                   MUI011
     C     KHV0          CHAIN     DLMPEVP0                           04                       MUI01
      *                                                                   MUI011
     C     UAIPD         SUB       HEAMT         @@AMT                                         MUI01
     C**********         CALL      'GLM041'                                                   LUC109
     C                   CALL      'XX000041'                                                 LUC109
     C                   PARM                    UCUCY                                         MUI01
     C                   PARM                    @@AMT                                         MUI01
     C                   PARM                    C9859                                         MUI01
     C                   PARM                    IERROR                                        MUI01
      *                                                                   MUI011
      * C9860 - IRS and CIRS: Their Rate Change Frequency                 MUI011
      *                                                                   MUI011
     C                   MOVE      TICFR         C9860                                         MUI01
      *                                                                   MUI011
      * C9861 - IRS and CIRS: Our Rate Change Frequency                   MUI011
      *                                                                   MUI011
     C                   MOVE      UICFR         C9861                                         MUI01
      *                                                                   MUI011
      * C9862 - IRS and CIRS: Their Interest Pay Frequency                MUI011
      *                                                                   MUI011
     C                   MOVE      TIPFR         C9862                                         MUI01
      *                                                                   MUI011
      * C9863 - IRS and CIRS: Our Interest Pay Frequency                  MUI011
      *                                                                   MUI011
     C                   MOVE      UIPFR         C9863                                         MUI01
      *                                                                   MUI011
      * C9864 - IRS and CIRS: Their Base Rate Code                        MUI011
      *                                                                   MUI011
     C     TBRTT         IFNE      *ZERO                                                       MUI01
     C                   MOVE      TBRTT         C9864                                         MUI01
     C                   ENDIF                                                                 MUI01
      *                                                                   MUI011
      * C9865 - IRS and CIRS: Our Base Rate Code                          MUI011
      *                                                                   MUI011
     C     UBRTT         IFNE      *ZERO                                                       MUI01
     C                   MOVE      UBRTT         C9865                                         MUI01
     C                   ENDIF                                                                 MUI01
      *                                                                   MUI011
      * C9866 - IRS and CIRS: Their Spread                                MUI011
      *                                                                   MUI011
     C     TBRTT         IFNE      *ZERO                                                       MUI01
     C                   Z-ADD(H)  TRTSP         WK9866            8 5                         MUI01
     C                   MOVE      WK9866        C9866                                         MUI01
     C     TSPIN         IFEQ      'S'                                                         MUI01
     C                   MOVEL     '-'           C9866                                         MUI01
     C                   ELSE                                                                  MUI01
     C                   MOVEL     '+'           C9866                                         MUI01
     C                   ENDIF                                                                 MUI01
     C                   ENDIF                                                                 MUI01
      *                                                                   MUI011
      * C9867 - IRS and CIRS: Our Spread                                  MUI011
      *                                                                   MUI011
     C     UBRTT         IFNE      *ZERO                                                       MUI01
     C                   Z-ADD(H)  URTSP         WK9867            8 5                         MUI01
     C                   MOVE      WK9867        C9867                                         MUI01
     C     USPIN         IFEQ      'S'                                                         MUI01
     C                   MOVEL     '-'           C9867                                         MUI01
     C                   ELSE                                                                  MUI01
     C                   MOVEL     '+'           C9867                                         MUI01
     C                   ENDIF                                                                 MUI01
     C                   ENDIF                                                                 MUI01
      *                                                                   MUI011
     C                   ENDIF                                                                 MUI01
      *                                                                   MUI011
     C                   ENDSR                                                                 MUI01
      /EJECT                                                              MUI011
      *****************************************************************   MUI011
      *                                                               *   MUI011
      *  #S207  -  Set up Detail records 7                            *   MUI011
      *                                                               *   MUI011
      *  Called By: #S200                                             *   MUI011
      *  Calls:                                                       *   MUI011
      *                                                               *   MUI011
      *****************************************************************   MUI011
      *                                                                   MUI011
     C     #S207         BEGSR                                                                 MUI01
      *                                                                   MUI011
      * Reset work fields                                                 MUI011
      *                                                                   MUI011
     C                   CLEAR                   DET007                                        MUI01
     C                   MOVE      '007'         F7PROG                                        MUI01
      *                                                                   MUI011
      * Condition following fields on Upfront Fee being there             MUI011
      *                                                                   MUI011
     C     UPFE          IFNE      *ZERO                                                       MUI01
      *                                                                   MUI011
      * C9884 - Upfront Fee Value Date                                    MUI011
      *                                                                   MUI011
     C**********         CALL      'GLM053'                                                   LUC109
     C                   CALL      'XX000053'                                                 LUC109
     C                   PARM      UPVD          P@DAY             5 0                         MUI01
     C                   PARM      *ZERO         P@DATE            8 0                         MUI01
     C                   Z-ADD     P@DATE        C9884                                         MUI01
      *                                                                   MUI011
      * C9885 - Upfront Fee Amount                                        MUI011
      *                                                                   MUI011
     C     UPPR          IFEQ      'P'                                                         MUI01
     C                   MOVE      UCUCY         P@CCY                                         MUI01
     C                   ELSE                                                                  MUI01
     C                   MOVE      TCUCY         P@CCY                                         MUI01
     C                   ENDIF                                                                 MUI01
     C**********         CALL      'GLM041'                                                   LUC109
     C                   CALL      'XX000041'                                                 LUC109
     C                   PARM                    P@CCY             3                           MUI01
     C                   PARM                    UPFE                                          MUI01
     C                   PARM                    C9885                                         MUI01
     C                   PARM                    IERROR                                        MUI01
      *                                                                   MUI011
      * C9886 - Upfront Fee Sign                                          MUI011
      *                                                                   MUI011
     C                   MOVE      UPPR          C9886                                         MUI01
      *                                                                   MUI011
      * C9887 - Upfront Fee Accrued to date                               MUI011
      *                                                                   MUI011
     C**********         CALL      'GLM041'                                                   LUC109
     C                   CALL      'XX000041'                                                 LUC109
     C                   PARM                    P@CCY                                         MUI01
     C                   PARM                    UPAD                                          MUI01
     C                   PARM                    C9887                                         MUI01
     C                   PARM                    IERROR                                        MUI01
      *                                                                   MUI011
     C                   ENDIF                                                                 MUI01
      *                                                                   CM00036425
      * CMXTN = Murex transaction ID and R306 Flag                        CM00036425/62206
      *                                                                   CM00036425
     C**********         MOVE      DLNO          CHDLNO            6                    CM000 LUC109
     C*****MXKEY         CHAIN     GZSIRSL1                           91                CM000 LUC109
     C**N91*****         MOVE      MXTRNO        CMXTN                                  CM000 LUC109
     C**N91*****         MOVE      R306          R306FL                                 CM000 LUC109
     C                   Z-ADD     DLNO          CHDLNO            6 0                        LUC109
     C     CHDLNO        CHAIN     DEALSGY0                           91                      LUC109
     C     *IN91         IFEQ      '0'                                                        LUC109
     C                   MOVE      MXTRNO        CMXTN                                        LUC109
     C                   MOVE      MXNTAF        R306FL                                       LUC109
     C                   ENDIF                                                                LUC109
      *                                                                   CM00036425
     C                   ENDSR                                                                 CM000
      *****************************************************************
      *                                                               *
      *  #ACKEY -  Determine Account Codes                            *
      *                                                               *
      *  Called By: #201                                              *
      *  Calls:     #ERR                                              *
      *                                                               *
      *****************************************************************
      *
     C     #ACKEY        BEGSR
      *
     C                   Z-ADD     *ZERO         @@ACC1            4 0
     C                   Z-ADD     *ZERO         @@ACC2            4 0
      *
      * Access Account Key File
     C     @@ACK         CHAIN     ACKEY                              40
      *
     C     *IN40         IFEQ      *OFF
      *
     C     ACD3          IFNE      *ZERO
     C                   Z-ADD     ACD3          @@ACC1
     C                   ENDIF
      *
     C     ACD2          IFNE      *ZERO
     C                   Z-ADD     ACD2          @@ACC1
     C                   ENDIF
      *
     C     ACD1          IFNE      *ZERO
     C                   Z-ADD     ACD1          @@ACC1
     C                   ENDIF
      *
      *
     C     ACD6          IFNE      *ZERO
     C                   Z-ADD     ACD6          @@ACC2
     C                   ENDIF
      *
     C     ACD5          IFNE      *ZERO
     C                   Z-ADD     ACD5          @@ACC2
     C                   ENDIF
      *
     C     ACD4          IFNE      *ZERO
     C                   Z-ADD     ACD4          @@ACC2
     C                   ENDIF
      *
     C                   ELSE
      *
     C                   MOVE      *BLANKS       REPPRG
     C                   MOVE      *BLANKS       REPMSG
     C                   MOVE      *BLANKS       REPKEY
     C                   MOVE      *BLANKS       REPDTA
     C                   MOVE      *BLANKS       REPACN
     C                   MOVEL     F1DEAL        REPACN
     C                   MOVEL     '#ACKEY'      REPPRG
     C                   MOVEL     @ERR(2)       REPMSG
     C                   MOVEL     @@ACK         REPKEY
     C                   EXSR      #ERR
      *
     C                   ENDIF
      *
     C                   ENDSR
      *****************************************************************
      *                                                               *
      *    #TERM     - Program termination                            *
      *                                                               *
      *    CALLED BY - #PROC, *PSSR                                   *
      *    CALLS     - NONE                                           *
      *                                                               *
      *****************************************************************
      *
     C     #TERM         BEGSR
      *
      *
     C     *IN89         IFEQ      *ON                                          Database error
      *
      ** Print audit report & stop run
      *
     C                   WRITE     HEADAU                                       Report header
      *
     C                   WRITE     DBERROR                                      Report error
      *
     C                   ELSE
      *
      *
      *  Write Trailer Record
     C                   ADD       1             COUNT
     C                   Z-ADD     COUNT         FCONT
     C                   MOVE      '99'          RECC
     C                   MOVE      TRAILR        DATA
     C                   WRITE     FEDERF
      *
     C     ERRCNT        IFGT      *ZERO
     C                   WRITE     EOR
     C                   ELSE
     C                   WRITE     NODET
     C                   ENDIF
      *
     C                   ENDIF
      *
     C                   MOVE      *ON           *INLR                          Last record
     C                   RETURN                                                 Return control
      *
     C                   ENDSR
      *
      *****************************************************************
      *                                                               *
      *  *PSSR  - Program Error Processing Subroutine.                *
      *                                                               *
      *  Called By: Various                                           *
      *  #AUDIT - Produce #AUDIT Report and End Program               *
      *                                                               *
      *****************************************************************
      *
     C     *PSSR         BEGSR                                                  *** *PSSR  ***
      *
      ** Prevent recursive call
      *
     C     @@PSSR        IFEQ      'N'                                          Recursive call
      *
     C                   MOVE      'Y'           @@PSSR                         *PSSR Executed
      *
      ** Update local data area
      *
     C     DBPGM         IFEQ      *BLANKS
     C**********         MOVEL     'GLM042'      DBPGM                          Set program idLUC109
     C                   MOVEL     'XX000042'    DBPGM                          Set program idLUC109
     C                   ENDIF
      *
     C     *LOCK         IN        WLDA
     C                   MOVEL     DBERR         WLDA
     C                   OUT       WLDA
      *
     C                   MOVE      *ON           *IN89                          Database error
     C                   MOVE      *ON           *INU7                                         15996
     C                   MOVE      *ON           *INU8                                         15996
     C                   DUMP                                                   Dump system var
      *
     C                   EXSR      #TERM                                        Stop run
      *
     C                   ENDIF
      *
     C                   ENDSR
      /EJECT
      *****************************************************************
      *                                                               *
      *    #ERR      - Error Reporting                                *
      *                                                               *
      *    CALLED BY - #S201                                          *
      *    CALLS     - NONE                                           *
      *                                                               *
      *****************************************************************
      *
     C     #ERR          BEGSR
      *
      *
      *
      ** Print audit report & stop run
      *
      *
     C     WWOFL1        SUB       WWPTL1        WWLINE            2 0
      *
     C     WWLINE        IFLT      5
     C                   WRITE     ERRHDR
     C                   ENDIF
      *
     C                   ADD       1             ERRCNT
     C                   WRITE     ERRDET                                       Report error
      *
      *
     C                   ENDSR
      *
      *****************************************************************
      *                                                               *
      *  #CALC  - calculate Profit and Loss                           *
      *                                                               *
      *****************************************************************
      *
     C     #CALC         BEGSR                                                  *** CALCPL ***
      ***  Define Keylists.
      *
      ***  FRA Rates File: Key1 - Full Key.
      *
     C     KFRAR1        KLIST
     C                   KFLD                    UCUCY
     C                   KFLD                    WBRTT
     C                   KFLD                    VDAT
      *
      ***  FRA Rates File: Key2 - Partial Key.
      *
     C     KFRAR2        KLIST
     C                   KFLD                    UCUCY
     C                   KFLD                    WBRTT
      *
      *
      ***  Set up Interest Fields, (dependent on Buy/Sell).
      *
     C     BYSL          IFEQ      'S'
     C                   Z-ADD     TEINR         WEINR
     C                   Z-ADD     UBRTT         WBRTT
     C                   Z-ADD     UICBS         WICBS
     C                   Z-ADD     UINFD         WINFD                                         05984
     C                   Z-ADD     UEINR         WFXRT                                         05984
     C                   ELSE
     C                   Z-ADD     UEINR         WEINR            11 7
     C                   Z-ADD     TBRTT         WBRTT             2 0
     C                   Z-ADD     TICBS         WICBS             1 0
     C                   Z-ADD     TINFD         WINFD             5 0                         05984
     C                   Z-ADD     TEINR         WFXRT            11 7                         05984
     C                   END
      *
      * Chain to Currency File.
     C                   CLEAR                   @A6REA4
     C     UCUCY         CHAIN     SDCURRL0                           90
     C     *IN90         IFEQ      *OFF
     C                   Z-ADD     A6SPRT        WEXRT            13 8
     C                   Z-ADD     A6NBDP        WCDP              1 0
     C                   MOVE      A6MDIN        WMDIN             1
     C                   MOVE      A6DICB        WDICB             1
     C                   Z-ADD     A6MMSD        ZZDTIN
     C                   EXSR      ZDAT10
     C                   Z-ADD     ZZMDNO        WSPOT             5 0
     C                   ENDIF
      *
      * Calculate Profit and Loss
     C                   EXSR      CALCPL
      *
     C                   ENDSR                                                                 05984
      /TITLE SR/CALCPL
      *****************************************************************
      *                                                               *
      *  CALCPL - Subroutine to Calculate the Profit or Loss.         *
      *                                                               *
      *  Called By: PROCES                                            *
      *  Calls:                                                       *
      *  GETRAT - Get the FRA Market Rate.                            *
      *  ZDLINT - DL Calculate Interest between Two Dates             *
      *  ZNPV   - Net Present Value a Future Amount                   *
      *  ZCONV  - Convert Amount to Another Currency                  *
      *  CALCAU - Subroutine to Calculate the P/L for Australia/USA   *   AUS021
      *                                                               *
      *  Returns  : WPL    (Profit/Loss)                              *
      *             WPLNPV (Net Present Value of Profit/Loss)         *
      *             *IN20  (No MM Rates for Currency)                 *
      *             *IN21  (No IRS Rate for Currency)                 *
      *                                                               *
      *****************************************************************
      *
     C     CALCPL        BEGSR                                                  *** CALCPL ***
      *
      ***  Initialise Fields.
     C                   Z-ADD     0             WPL              15 0
     C                   Z-ADD     0             WPLNPV           15 0
     C                   SETOFF                                       2021
      *                                                                   059841
      ***  Obtain the revaluation rate from the Current Market Rate if    059841
      ***  the fix date has not passed the rundate, otherwise, use the    059841
      ***  fixed rate.                                                    059841
     C     WINFD         IFGT      BJRDNB                                                      05984
     C     WFXRT         OREQ      *ZERO                                                       06718
      *
      ***  The Rate used in the calculation of Profit is the difference
      ***  of the Current Market Rate and the FRA Contract Rate.
      *
      ***  Get the FRA Market Rate.
      *
     C                   EXSR      GETRAT
     C                   ELSE                                                                  05984
     C                   Z-ADD     WFXRT         WFRART                                        05984
     C                   END                                                                   05984
      *
      ***  If no FRA Rate for Currency, set on *IN21 and exit SR.
      *
     C     *IN73         IFEQ      '1'
     C                   SETON                                        21
     C                   GOTO      CALEND
     C                   END
      *                                                                   AUS021
      ***  If the Settlement Formula for the deal is 'A' (Australian)     AUS021
      ***  or 'U' (USA) then call CALCAU; else process for Settlement     AUS021
      ***  Formula 'G' (GBP).                                             AUS021
     C     SETF          IFEQ      'A'                                                         AUS02
     C     SETF          OREQ      'U'                                                         AUS02
     C                   Z-ADD     UPAMT         SZPPL                                         AUS02
     C                   Z-ADD     VDAT          SZVDAT                                        AUS02
     C                   Z-ADD     MDAT          SZMDAT                                        AUS02
     C                   Z-ADD     WFRART        SZFLT                                         AUS02
     C                   Z-ADD     WEINR         SZFIX                                         AUS02
     C                   EXSR      CALCAU                                                      AUS02
     C                   Z-ADD     SZRDS         WPLNPV                                        AUS02
      *                                                                   AUS021
      **  Adjust WPLNPV by making negative if loss. A loss is             AUS021
      **  calculated by                                                   AUS021
      **                (A) If the BANK is Buying and the contract        AUS021
      **  rate is greater than the FRA rate.                              AUS021
      **                (B) If the BANK is Selling and the contract       AUS021
      **  rate is less than the FRA rate.                                 AUS021
      *                                                                   AUS021
     C     BYSL          IFEQ      'B'                                                         AUS02
     C     WEINR         ANDGT     WFRART                                                      AUS02
      *                                                                   AUS021
     C     BYSL          OREQ      ' '                                                         AUS02
     C     WEINR         ANDGT     WFRART                                                      AUS02
      *                                                                   AUS021
     C     BYSL          OREQ      'S'                                                         AUS02
     C     WEINR         ANDLT     WFRART                                                      AUS02
      *                                                                   AUS021
     C                   Z-SUB     WPLNPV        WPLNPV                                        AUS02
     C                   END                                                                   AUS02
      *                                                                   AUS021
     C                   ELSE                                                                  AUS02
      *                                                                   AUS021
      ***  Calculate the differential Rate for SR/ZDLINT.
      *
     C     WFRART        SUB       WEINR         ZDLRAT
      *
      ***  Calculate the Interest.
      *
     C                   Z-ADD     UPAMT         ZDLAMT
     C                   Z-ADD     VDAT          ZCBSDT
     C                   Z-ADD     MDAT          ZCBEDT
     C                   MOVE      WICBS         ZCBCBS
     C                   EXSR      ZDLINT
     C                   Z-ADD     ZDLOUT        WPL
      *
      ***  If FRA Sold, correct the sign.
      *
     C     BYSL          IFEQ      'S'
     C                   Z-SUB     WPL           WPL
     C                   END
      *
      ***  Net Present Value the Profit/Loss to Spot Date.
      ***  Note: The MM Rates assume the use of the Calculation Basis
      ***  on the Currency, therefore this must be used for Net Present
      ***  Valuing, and not the Calculation Basis of the Deal.
      *
     C                   Z-ADD     WSPOT         ZNPSDT
     C                   Z-ADD     MDAT          ZNPFDT
     C                   Z-ADD     WPL           ZNPAMT
     C                   MOVE      UCUCY         ZNPCCY
      *
      ***  Loss means paying out, therefore use Bid/Borrow Rate.
      ***  Profit means receiving, therefore use Offer/Lend Rate.
      *
     C     WPL           IFLT      0
     C                   MOVE      'B'           ZNPBOF
     C                   ELSE
     C                   MOVE      'O'           ZNPBOF
     C                   END
      *
     C                   MOVE      WDICB         ZCBCBS
     C                   EXSR      ZNPV
      *
      ***  Check for no Rates for Currency.
      *
     C     *IN93         IFEQ      '1'
     C                   SETON                                        20
     C                   GOTO      CALEND
     C                   END
      *
     C                   Z-ADD     ZNPOUT        WPLNPV
      *                                                                   AUS021
     C                   END                                                                   AUS02
      *
     C     CALEND        TAG                                                    *** CALEND ***
      *
     C                   ENDSR
      *                                                                   AUS021
      *****************************************************************   AUS021
      /TITLE SR/CALCAU                                                    AUS021
      *****************************************************************   AUS021
      *                                                               *   AUS021
      *  CALCAU - Subroutine to Calculate the P/L for Australia/USA   *   AUS021
      *                                                               *   AUS021
      *           This subroutine calculates the revalued profit or   *   AUS021
      *           loss using the Australian or American Settlement    *   AUS021
      *           Formula.  The code has been lifted from the         *   AUS021
      *           subroutine DLRADS in DL1601A, DL1922, DL0280 etc..  *   AUS021
      *                                                               *   AUS021
      *  Called By: CALCPL                                            *   AUS021
      *  Calls    : None                                              *   AUS021
      *                                                               *   AUS021
      *****************************************************************   AUS021
      *                                                                   AUS021
     C     CALCAU        BEGSR                                                  *** CALCAU *** AUS02
      *                                                                   AUS021
     C                   Z-ADD     SZVDAT        SZVDAT            5 0                         AUS02
     C                   Z-ADD     SZMDAT        SZMDAT            5 0                         AUS02
     C                   Z-ADD     SZPPL         SZPPL            13 0                         AUS02
     C                   Z-ADD     SZFIX         SZFIX            11 7                         AUS02
     C                   Z-ADD     SZFLT         SZFLT            11 7                         AUS02
     C                   Z-ADD     0             SZWRK1           11 7                         AUS02
     C                   Z-ADD     0             SZWRK2           20 7                   AUS02104330
     C                   Z-ADD     0             SZWRK3            5 0                         AUS02
     C                   Z-ADD     0             SZWRK8           15 0                         AUS02
     C                   Z-ADD     0             SZWRK9           15 7                         AUS02
     C                   Z-ADD     0             SZSETL           18 0                         05137
     C                   Z-ADD     0             SZRSA            15 0                         AUS02
     C                   Z-ADD     0             SZRDS            13 0                         AUS02
     C*                                                                   AUS021
     C**  CHECK IF AUSTRALIA FORMULA REQUIRED                             AUS021
     C*                                                                   AUS021
     C     SETF          IFEQ      'A'                                                         AUS02
     C*                                                                   AUS021
     C**  CALCULATE DISCOUNTED SETTLEMENT AMOUNT USING AUSTRALIAN         AUS021
     C*   FORMULA                                                         AUS021
     C*                                                                   AUS021
     C**  CALCULATE DAYS TO MATURITY                                      AUS021
     C*                                                                   AUS021
     C     SZMDAT        SUB       SZVDAT        SZWRK3                                        AUS02
     C*                                                                   AUS021
     C**  MULTIPLY FACE VALUE BY (DAYS IN YEAR x 100)                     AUS021
     C*                                                                   AUS021
     C     SZPPL         MULT      36500         SZSETL                                        AUS02
     C*                                                                   AUS021
     C**  CALCULATE PROCEEDS FROM FLOATING RATE                           AUS021
     C*                                                                   AUS021
     C     SZWRK3        MULT      SZFLT         SZWRK2                                        AUS02
     C                   ADD       36500         SZWRK2                                        AUS02
     C     SZWRK2        IFNE      *ZEROS                                                      AUS02
     C     SZSETL        DIV(H)    SZWRK2        SZRSA                                         AUS02
     C                   ELSE                                                                  AUS02
     C                   Z-ADD     *ZEROS        SZRSA                                         AUS02
     C                   END                                                                   AUS02
     C*                                                                   AUS021
     C**  CALCULATE PROCEEDS FROM FIXED AMOUNT                            AUS021
     C*                                                                   AUS021
     C     SZWRK3        MULT      SZFIX         SZWRK2                                        AUS02
     C                   ADD       36500         SZWRK2                                        AUS02
     C     SZWRK2        IFNE      *ZEROS                                                      AUS02
     C     SZSETL        DIV(H)    SZWRK2        SZWRK8                                        AUS02
     C                   ELSE                                                                  AUS02
     C                   Z-ADD     *ZEROS        SZWRK8                                        AUS02
     C                   END                                                                   AUS02
     C*                                                                   AUS021
     C**  CALCULATE DISCOUNTED SETTLEMENT AMOUNT                          AUS021
     C*                                                                   AUS021
     C     SZRSA         IFGT      SZWRK8                                                      04031
     C     SZRSA         SUB       SZWRK8        SZRDS                                         AUS02
     C                   ELSE                                                                  04031
     C     SZWRK8        SUB       SZRSA         SZRDS                                         04031
     C                   END                                                                   04031
     C*                                                                   AUS021
     C                   ELSE                                                                  AUS02
     C*                                                                   AUS021
     C**  CHECK IF U.S.A FORMULA REQUIRED                                 AUS021
     C*                                                                   AUS021
     C     SETF          IFEQ      'U'                                                         AUS02
     C*                                                                   AUS021
     C**  CALCULATE DISCOUNTED SETTLEMENT AMOUNT USING U.S.A FORMULA      AUS021
     C*                                                                   AUS021
     C**  CALCULATE DAYS TO MATURITY                                      AUS021
     C*                                                                   AUS021
     C     SZMDAT        SUB       SZVDAT        SZWRK3                                        AUS02
     C*                                                                   AUS021
     C**  MULTIPLY INTEREST SETTLEMENT RATE BY DAYS TO MATURITY           AUS021
     C**  AND ADD (DAYS IN YEAR x 100)                                    AUS021
     C*                                                                   AUS021
     C     SZFLT         MULT      SZWRK3        SZWRK9                                        AUS02
     C                   ADD       36000         SZWRK9                                        AUS02
     C*                                                                   AUS021
     C**  CALCULATE DIFFERENCE in RATES                                   AUS021
     C*                                                                   AUS021
     C     SZFLT         IFGT      SZFIX                                                       AUS02
     C     SZFLT         SUB       SZFIX         SZWRK1                                        AUS02
     C                   ELSE                                                                  AUS02
     C     SZFIX         SUB       SZFLT         SZWRK1                                        AUS02
     C                   END                                                                   AUS02
     C*                                                                   AUS021
     C**  MULTIPLY DIFFERENCE IN RATES BY DAYS TO MATURITY AND            AUS021
     C**  CONTRACT AMOUNT                                                 AUS021
     C*                                                                   AUS021
     C     SZWRK1        MULT      SZWRK3        SZWRK2                                        AUS02
     C     SZWRK2        MULT      SZPPL         SZWRK2                                        AUS02
     C*                                                                   AUS021
     C**  CALCULATE DISCOUNTED SETTLEMENT AMOUNT                          AUS021
     C*                                                                   AUS021
     C     SZWRK9        IFNE      *ZEROS                                                      AUS02
     C     SZWRK2        DIV(H)    SZWRK9        SZRDS                                         AUS02
     C                   ELSE                                                                  AUS02
     C                   Z-ADD     *ZEROS        SZRDS                                         AUS02
     C                   END                                                                   AUS02
     C*                                                                   AUS021
     C                   END                                                                   AUS02
     C*                                                                   AUS021
     C                   END                                                                   AUS02
     C*                                                                   AUS021
     C                   ENDSR                                                                 AUS02
      *
      *****************************************************************
      /TITLE SR/GETRAT
      *****************************************************************
      *                                                               *
      *  GETRAT - Subroutine to Obtain the FRA Market Rate.           *
      *                                                               *
      *  Called By: CALCPL                                            *
      *  Calls:                                                       *
      *  ZINTPL - Straight Line Interpolation                         *
      *                                                               *
      *  Returns  : WFRART (FRA Market Rate)                          *
      *             *IN73  (Set on if Currency/Base Rate not on File) *
      *                                                               *
      *****************************************************************
      *
     C     GETRAT        BEGSR                                                  *** GETRAT ***
      *
      ***  Initialise Fields.
     C                   Z-ADD     0             WFRART           11 7
     C                   SETOFF                                       717273
      *
      ***  First set Lower Limits using Currency/Base Rate/Value Date.
      *
     C     KFRAR1        SETLL     DLFRARL4                           71                       E2821
      *
      ***  If not EOF, Read Equal the next record of the Currency/Base
      ***  Rate.
      *
     C     *IN71         IFEQ      '0'
     C     KFRAR2        READE     DLFRARL4                               72                   E2821
      *
      ***  If a record was read and is the correct date, set up the FRA
      ***  Rate and exit.
      *
     C     *IN72         IFEQ      '0'
     C     FRVMDN        ANDEQ     VDAT
     C                   Z-ADD     FRRATE        WFRART
     C                   GOTO      RATEND
     C                   END
      *
     C                   END
      *
      ***  If a record has not yet been retrieved, reposition the file
      ***  and read the last record of the Currency/Base Rate.
      *
     C     *IN71         IFEQ      '1'
     C     *IN72         OREQ      '1'
     C     KFRAR1        SETGT     DLFRARL4                                                    E2821
      *
      ***  If Record found then set up the FRA Rate, else the Currency/
      ***  Base Rate is not on File (*IN73 returned).
      *
     C     KFRAR2        READPE    DLFRARL4                               73                   E2821
     C     *IN73         IFEQ      '0'
     C                   Z-ADD     FRRATE        WFRART
     C                   END
     C                   GOTO      RATEND
      *
     C                   END
      *
      ***  If this point has been reached, a record has been found with
      ***  a date greater than the one we want and it will probably be
      ***  necessary to use interpolation, so set up Far Date and Far
      ***  Rate fields (for SR/ZINTPL).
      *
     C                   Z-ADD     FRVMDN        ZIFDAT
     C                   Z-ADD     FRRATE        ZIFRAT
      *
      ***  Read the Previous record to get the Near Rate. If not found,
      ***  (*IN71), then the record already retrieved is the first for
      ***  this Currency/Base Rate and that FRA Rate should be used.
      *
     C     KFRAR2        READPE    DLFRARL4                               71                   E2821
      *
     C     *IN71         IFEQ      '1'
     C                   Z-ADD     ZIFRAT        WFRART
     C                   ELSE
      *
      ***  Else set up Near Date, Near Rate and Broken Date and then
      ***  interpolate the Rate.
      *
     C                   Z-ADD     FRVMDN        ZINDAT
     C                   Z-ADD     FRRATE        ZINRAT
     C                   Z-ADD     VDAT          ZIBDAT
     C***********          EXSR ZINTPL
     C***********          Z-ADDZIBRAT    WFRART                          MUI009
     C                   Z-ADD     0             ZIBRAT                                        MUI00
     C                   CALL      'ZAINTPL'                                                   MUI00
     C                   PARM                    ZINDAT            5 0                         MUI00
     C                   PARM                    ZIBDAT            5 0                         MUI00
     C                   PARM                    ZIFDAT            5 0                         MUI00
     C                   PARM                    ZINRAT           13 9                         MUI00
     C                   PARM                    ZIFRAT           13 9                         MUI00
     C                   PARM                    ZIBRAT           13 9                         MUI00
     C                   Z-ADD     ZIBRAT        WFRART                                        MUI00
     C                   END
      *
     C     RATEND        TAG                                                    *** RATEND ***
      *
     C                   ENDSR
      *
      *****************************************************************
      /TITLE SR/ZCONV
     C***/C*PY*ZSRSRC,ZCONVZ1                                                                 LUC109
     C/COPY ZSRSRC,ZCONVZ1ILE                                                                 LUC109
      /TITLE SR/ZNPV
     C***/C*PY*ZSRSRC,ZNPVZ1                                                                  LUC109
     C/COPY ZSRSRC,ZNPVZ1LE                                                                   LUC109
      /TITLE SR/ZDLINT
     C***/C*PY*ZSRSRC,ZDLINTZ1                                                                LUC109
     C/COPY ZSRSRC,ZDLINTZ1LE                                                                 LUC109
      ***********TITLE SR/ZINTPL                                          MUI009
     C***********COPY ZSRSRC,ZINTPLZ1                                     MUI009
      /TITLE SR/ZDATE9                                                    MUI009
     C***/C*PY*ZSRSRC,ZDATE9Z3                                                         MUI009 LUC109
      /TITLE SR/ZDAT10
     C***/C*PY*ZSRSRC,ZDAT10Z2                                                                LUC109
     C/COPY ZSRSRC,ZDAT10Z2LE                                                                 LUC109
      /TITLE SR/ZCBDYS
     C***/C*PY*ZSRSRC,ZCBDYSZ1                                                                LUC109
     C/COPY ZSRSRC,XCBDYSZ1LE                                                                 LUC109
      /TITLE SR/ZDATE2
     C***/C*PY*ZSRSRC,ZDATE2Z2                                                                LUC109
     C/COPY ZSRSRC,ZDATE2Z2LE                                                                 LUC109
      ***
**  CPY@
(c) Finastra International Limited 2016
**  @ERR
XX000041 UNABLE TO CONVERT AMOUNT
ACKEY RECORD NOT FOUND
**   ZYDY - YEARS IN DAYS CUMULATIVE, FOUR YEAR SPAN
0366073110961461
**   ZMDY - MONTHS IN DAYS CUMULATIVE THROUGH YEAR
000031059090120151181212243273304334365
**   ZMNM - MONTHS SHORT NAMES
JANFEBMARAPRMAYJUNJULAUGSEPOCTNOVDEC
**   @YD  - YEARS IN DAYS CUMULATIVE, FOUR YEAR SPAN
00366007310109601461
**   @MD  - MONTHS IN DAYS CUMULATIVE THROUGH YEAR
00000000310005900090001200015100181002120024300273003040033400365
**  POWER - ARRAY OF POWERS FOR CURRENCY CONVERSION
0000001
0000010
0000100
0001000
0010000
0100000
1000000
**   ZF29 DAY NOS OF FEB 29 TO 2096 (INCLUDING 2000)
0006001521029820444305904073650882610287117481320914670161311759219053
2051421975234362489726358278192928030741322023366335124365853804639507
40968424294389045351
