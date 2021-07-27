     H DEBUG DATEDIT(*YMD)
      *****************************************************************
/*S*D****RPGBASE*******************************************************                       LUC109
/*STD *  RPGBASEBND                                                   *                       LUC109
/*EXI *  TEXT('GL Limit Extract')                                     *                       LUC109
      *****************************************************************
      *                                                               *
      *  Midas - Interface to Head Office Reporting                   *
      *                                                               *
      ***GLM036**-*GL*Limit*Extract************************************                       LUC109
      *  XX000036 - GL Limit Extract                                  *                       LUC109
      *                                                               *
  ?   *****************************************************************
  ?   * *** THIS PROGRAM MUST BE COMPILED WITH XXINTFLIB AT THE TOP   *
  ?   * OF LIBL ***                                                   *
  ?   *****************************************************************
      *                                                               *
      *  Function: Limit Extract                                      *
      *                                                               *
      *                                                               *
      *  CALLED BY  XXXXXXXX- XXXXXXXXXXXXXXXXXXXXXXXX                *
      *             Frequency: Automatically in Close of Business     *
      *                                                               *
      ***(C)*COPYRIGHT*MKI*LIMITED*1993,*1994**************************                       LUC109
      *  (c) Finastra International Limited 2016                      *                       LUC109
      *                                                               *
      *  Last Amend No. LUC109             Date 20Sep16               *
      *  Prev Amend No. MUI009             Date 24May04               *
      *                 159964             Date 22Aug99               *
      *                 MMI043             Date 15Dec98               *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  LUC109 - HO Reporting (Upgrade to FB Midas 2.1)              *
      *  MUI009 - R4.1 Upgrade. Apply fix from UCI NY to extract      *
      *           Company-level limits.                               *
      *  159964 - PGM/GLM032A cannot allocate object LF/SDCUSTL0 due  *
      *           to SCC0406.                                         *
      *         - Seton job switches U7/U8 for error processing       *
      *  MMI043 - Limit Extract                                       *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  C R E A T I O N     P A R A M E T E R S                      *
      *                                                               *
      *****************************************************************
      *
     FSDBANKPD  IF   E             DISK    INFSR(*PSSR)
     FSDGELRPP  IF   E             DISK    INFSR(*PSSR)
     FSDGELRPD  IF   E             DISK    INFSR(*PSSR)
     FSDDEALPD  IF   E             DISK    INFSR(*PSSR)
     FSDFAISPD  IF   E             DISK    INFSR(*PSSR)
     FSDBRCHL1  IF   E           K DISK    INFSR(*PSSR)
     FSDCOMPL1  IF   E           K DISK    INFSR(*PSSR)                         MUI009
     FSDINTFPD  IF   E           K DISK    INFSR(*PSSR)
     FSDCTRYY0  IF   E           K DISK    INFSR(*PSSR)
     FSDLIMTY0  IF   E           K DISK    INFSR(*PSSR)
     FSDCUSTY0  IF   E           K DISK    INFSR(*PSSR)
     FSDCUSTL1  IF   E           K DISK    INFSR(*PSSR)
     FSDCLLMV0  IF   E           K DISK    INFSR(*PSSR)
     FFELIM     O    E             DISK    INFSR(*PSSR)
     F***GLM036AU  O    E             PRINTER INFDS(SPOOL)                                    LUC109
     FXX000036AUO    E             PRINTER INFDS(SPOOL)                                       LUC109
     F                                     INFSR(*PSSR)
      *
      *****************************************************************
      *                                                               *
      *  F U N C T I O N   O F   I N D I C A T O R S                  *
      *                                                               *
      *   20 - LF/SDBRCHL1   File I/O                                 *
      *   21 - LF/SDCLLMV0   File I/O                                 *
      *                                                               *
      *  90-99    Used by Standard Subroutines                        *
      *                                                               *
      *  88       Database Error                                      *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  S U B R O U T I N E   I N D E X                              *
      *                                                               *
      *  #INIT  - Initial Processing                                  *
      *  #PROC  - Main Processing                                     *
      *  #S200  - Detail Processing                                   *
      *  #TERM  - Program termination                                 *
      *  *PSSR  - Abnormal termination                                *
      *                                                               *
      *****************************************************************
      * COMPILE TIME ARRAYS                                           *
     D CPY@            S             80    DIM(1) CTDATA PERRCD(1)              Copyright
     D @ERR            S             35    DIM(3) CTDATA PERRCD(1)
      *
      *
      ** Rename duplicate fields
      *
      *
      ***File*information*for*printer*file*GLM036AU********************                       LUC109
      ** File information for printer file XX000036AU                                         LUC109
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
     D  F1RPNM                16     35
     D  F1RPTN                36     45
     D  F1CTCZ                46     47
     D  F1HOGA                48     48  0
     D  F1BKCT                49     49
     D  F1PARI                50     50
     D  F1PCUS                51     56  0
     D  F1LBCY                57     59
     D  F1FILL                60     78
      *
      ** Detail Record 2
      *
     D DET002          DS
     D  F2PROG                 1      3
     D  F2MMLT                 4      6  0
     D  F2M1PD                 7      9
     D  F2M1PC                10     12  0
     D  F2M2PD                13     15
     D  F2M2PC                16     18  0
     D  F2M3PD                19     21
     D  F2M3PC                22     24  0
     D  F2M4PD                25     27
     D  F2M4PC                28     30  0
     D  F2M5PD                31     33
     D  F2M5PC                34     36  0
     D  F2M6PD                37     39
     D  F2M6PC                40     42  0
     D  F2MLAM                43     51  0
     D  F2MCDL                52     60  0
     D  F2MEXD                61     68
     D  F2FILL                69     78
      *
      ** Detail Record 3
      *
     D DET003          DS
     D  F3PROG                 1      3
     D  F3XMLT                 4      6  0
     D  F3X1PD                 7      9
     D  F3X1PC                10     12  0
     D  F3X2PD                13     15
     D  F3X2PC                16     18  0
     D  F3X3PD                19     21
     D  F3X3PC                22     24  0
     D  F3X4PD                25     27
     D  F3X4PC                28     30  0
     D  F3X5PD                31     33
     D  F3X5PC                34     36  0
     D  F3X6PD                37     39
     D  F3X6PC                40     42  0
     D  F3XSLA                43     51  0
     D  F3XFLA                52     60  0
     D  F3XMDR                61     69  0
     D  F3XEXD                70     77
     D  F3FILL                78     78
      *
      ** Detail Record 4
      *
     D DET004          DS
     D  F4PROG                 1      3
     D  F4FLAM                 4     12  0
     D  F4FEXD                13     20
     D  F4FLPC                21     28  5
     D  F4FLPP                29     32  0
     D  F4FUPC                33     40  5
     D  F4FUPP                41     44  0
     D  F4FILL                45     78
      *
      ** Detail Record 5
      *
     D DET005          DS
     D  F5PROG                 1      3
     D  F5ILAM                 4     12  0
     D  F5IEXD                13     20
     D  F5ILPC                21     28  5
     D  F5ILPP                29     32  0
     D  F5IUPC                33     40  5
     D  F5IUPP                41     44  0
     D  F5FILL                45     78
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
     D* ERROR DATA STRUCTURE
     D REPAMT          DS
     D  REPCCY                 1      3
     D  REPVAL                 4     18  0
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
      ** Data definition
      *
      *
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
     C     @@KEY         KLIST
     C                   KFLD                    XXRSNO            1
     C                   KFLD                    XXACCD            4
     C                   KFLD                    XXDRCR            1
      *
      ** Initial housekeeping
      *
     C                   MOVEA     CPY@          BIS@             80            Copyright
     C                   MOVE      'N'           @@PSSR            1            *PSSR Control
     C                   MOVE      *OFF          *IN98
     C                   MOVE      '9'           XXRSNO
      *
     C                   READ      SDBANKPD                               98    Bank details
      *
     C     *IN98         IFEQ      *ON                                          Ended in error
     C                   MOVEL     '001'         DBASE                          ***************
     C                   MOVEL     'SDBANKPD'    DBFILE                         * DB ERR  001 *
     C                   MOVE      *BLANKS       DBKEY                          ***************
     C                   EXSR      *PSSR
     C                   ENDIF
      *
     C                   READ      SDGELRPP                               98    Bank Extension
      *
     C     *IN98         IFEQ      *ON                                          Ended in error
     C                   MOVEL     '002'         DBASE                          ***************
     C                   MOVEL     'SDGELRPP'    DBFILE                         * DB ERR  002 *
     C                   MOVE      *BLANKS       DBKEY                          ***************
     C                   EXSR      *PSSR
     C                   ENDIF
      * Determine which Branch is used for bank/company code
     C     BJSLCD        CHAIN     SDINTFPD                           98        Bank Extension
      *
     C     *IN98         IFEQ      *ON                                          Ended in error
     C                   MOVEL     '003'         DBASE                          ***************
     C                   MOVEL     'SDINTFPD'    DBFILE                         * DB ERR  003 *
     C                   MOVE      *BLANKS       DBKEY                          ***************
     C                   EXSR      *PSSR
     C                   ENDIF
      * Determine Bank/company code for header
     C     S9BRCH        CHAIN     SDBRCHL1                           98        Branch
      *
     C     *IN98         IFEQ      *ON                                          Ended in error
     C                   MOVEL     '004'         DBASE                          ***************
     C                   MOVEL     'SDBRCHL1'    DBFILE                         * DB ERR  004 *
     C                   MOVE      *BLANKS       DBKEY                          ***************
     C                   EXSR      *PSSR
     C                   ENDIF
      *
     C                   READ      SDGELRPD                               98    Gl ICD
      *
     C     *IN98         IFEQ      *ON                                          Ended in error
     C                   MOVEL     '006'         DBASE                          ***************
     C                   MOVEL     'SDGELRPD'    DBFILE                         * DB ERR  006 *
     C                   MOVE      *BLANKS       DBKEY                          ***************
     C                   EXSR      *PSSR
     C                   ENDIF
      *
     C                   READ      SDDEALPD                               98    Gl ICD
      *
     C     *IN98         IFEQ      *ON                                          Ended in error
     C                   MOVEL     '008'         DBASE                          ***************
     C                   MOVEL     'SDDEALPD'    DBFILE                         * DB ERR  008 *
     C                   MOVE      *BLANKS       DBKEY                          ***************
     C                   EXSR      *PSSR
     C                   ENDIF
      *
     C                   READ      SDFAISPD                               98    Gl ICD
      *
     C     *IN98         IFEQ      *ON                                          Ended in error
     C                   MOVEL     '009'         DBASE                          ***************
     C                   MOVEL     'SDFAISPD'    DBFILE                         * DB ERR  009 *
     C                   MOVE      *BLANKS       DBKEY                          ***************
     C                   EXSR      *PSSR
     C                   ENDIF
     C*
      *
      *
     C                   MOVE      *BLANKS       FILL01
     C                   MOVE      *BLANKS       FILL02
     C                   MOVE      *BLANKS       F1FILL
     C                   MOVE      *BLANKS       F2FILL
     C                   MOVE      *BLANKS       F3FILL
     C                   MOVE      *BLANKS       F4FILL
     C                   MOVE      *BLANKS       F5FILL
     C                   MOVE      *BLANKS       FILL04
     C                   MOVE      '001'         F1PROG
     C                   MOVE      '002'         F2PROG
     C                   MOVE      '003'         F3PROG
     C                   MOVE      '004'         F4PROG
     C                   MOVE      '005'         F5PROG
     C*
     C* SET UP HEADER FIELDS
     C*
     C                   MOVE      A8CMCD        FBKCD
     C                   MOVE      BJSLCD        FGPCD
     C                   MOVEL     'FELIM'       FEXFL
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
     C*                    CALL 'GLM053'
     C*                    PARM           BKAPDT
     C*                    PARM           FLACD
     C*                    PARM *ZERO     WFLACD  80
     C*                    MOVE WFLACD    FLACD
      * Last Working Day of Month
     C                   MOVE      MMDAT         FLWDM
      * Next Working Day
     C**********         CALL      'GLM053'                                                   LUC109
     C                   CALL      'XX000053'                                                 LUC109
     C                   PARM                    BJDNWD
     C*                    PARM           FNWKD
     C                   PARM      *ZERO         WFNWKD            8 0
     C                   MOVE      WFNWKD        FNWKD
      *
      *
      *  Write Header Record
     C                   MOVE      '00'          RECC
     C                   MOVE      HEADER        DATA
     C                   WRITE     FELIMF
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
      *                                                                   MUI009
      *  Generate Detail Records For COMPANY records if reporting branch  MUI009
     C                   EXSR      COMP                                                        MUI00
      *                                                                   MUI009
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
     C                   WRITE     FELIMF
     C                   ADD       1             COUNT
      *
     C                   MOVE      A8CMCD        F1BKCD
     C                   MOVE      FBRCD         F1BRCD
     C                   MOVE      '05'          RECC
      *
      *   Generate Detail Records
     C                   EXSR      #S200
      *
      *  Generate Detail Records For SYSTEM records if reporting branch
     C     FBRCD         IFEQ      S9BRCH
     C                   MOVE      'SYS'         FBRCD
     C                   EXSR      #S200
     C                   ENDIF
      *  Write Branch Trailer Record
     C                   MOVE      '09'          RECC
     C                   MOVE      *BLANKS       DATA
     C                   WRITE     FELIMF
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
      *  Calls:     #S201 #S202 #S203 #S204 #205                      *
      *                                                               *
      *****************************************************************
      *
     C     #S200         BEGSR
      *
      * Read all Deals for the branch
      *
     C     FBRCD         SETLL     SDCLLMV0
     C     FBRCD         READE     SDCLLMV0                               21
      *
      *
     C     *IN21         DOWEQ     *OFF                                         Until eof
      *
     C     DZCUST        CHAIN     SDCUSTL1                           98        CUSTOMER
      *
     C     *IN98         IFEQ      *ON                                          Ended in error
     C                   MOVEL     '021'         DBASE                          ***************
     C                   MOVEL     'SDCUSTPD'    DBFILE                         * DB ERR  021 *
     C                   MOVEL     DZCUST        DBKEY                          ***************
     C                   EXSR      *PSSR
     C                   ENDIF
      *
     C                   EXSR      #S201
      *
      *  Write Detail Record 1
     C                   MOVE      DET001        DATA
     C                   WRITE     FELIMF
     C                   ADD       1             COUNT
      *
      *
     C                   EXSR      #S202
      *
      *  Write Detail Record 2
     C                   MOVE      DET002        DATA
     C                   WRITE     FELIMF
     C                   ADD       1             COUNT
      *
     C                   EXSR      #S203
      *
      *  Write Detail Record 3
     C                   MOVE      DET003        DATA
     C                   WRITE     FELIMF
     C                   ADD       1             COUNT
      *
      *
     C                   EXSR      #S204
      *
      *  Write Detail Record 4
     C                   MOVE      DET004        DATA
     C                   WRITE     FELIMF
     C                   ADD       1             COUNT
      *
      *
     C                   EXSR      #S205
      *
      *  Write Detail Record 5
     C                   MOVE      DET005        DATA
     C                   WRITE     FELIMF
     C                   ADD       1             COUNT
      *
      *
      *  Read Next record
     C     FBRCD         READE     SDCLLMV0                               21
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
      * Customer Number
     C                   MOVE      DZCUST        F1CUST
      * Report Name
     C                   MOVE      BBCRNM        F1RPNM
      * Report Town
     C                   MOVE      BBCRTN        F1RPTN
      * Country of Citizenship
     C                   MOVE      BBCNCZ        F1CTCZ
      * H.O. Geographical Area
     C     F1CTCZ        CHAIN     SDCTRYY0                           41
     C     *IN41         IFEQ      *OFF
     C                   MOVE      MGEOA         F1HOGA
     C                   ELSE
     C                   MOVE      *BLANKS       REPPRG
     C                   MOVE      *BLANKS       REPMSG
     C                   MOVE      *BLANKS       REPKEY
     C                   MOVE      *BLANKS       REPDTA
     C                   MOVE      *BLANKS       REPACN
     C                   MOVEL     F1CUST        REPACN
     C                   MOVEL     '#S201'       REPPRG
     C                   MOVEL     @ERR(1)       REPMSG
     C                   MOVEL     F1CTCZ        REPKEY
     C                   EXSR      #ERR
     C                   Z-ADD     *ZERO         F1HOGA
     C                   ENDIF
      * Bank Category Code
     C     DZCUST        CHAIN     SDCUSTY0                           42
     C     *IN42         IFEQ      *OFF
     C                   MOVE      MBCAT         F1BKCT
     C                   ELSE
     C                   MOVE      *BLANKS       REPPRG
     C                   MOVE      *BLANKS       REPMSG
     C                   MOVE      *BLANKS       REPKEY
     C                   MOVE      *BLANKS       REPDTA
     C                   MOVE      *BLANKS       REPACN
     C                   MOVEL     F1CUST        REPACN
     C                   MOVEL     '#S201'       REPPRG
     C                   MOVEL     @ERR(2)       REPMSG
     C                   MOVEL     F1CUST        REPKEY
     C                   EXSR      #ERR
     C                   MOVE      *BLANK        F1BKCT
     C                   ENDIF
      * Parent Indicator
     C     BBPAIN        IFEQ      *BLANKS
     C     BBPCNB        IFNE      *BLANKS
     C                   MOVE      'N'           F1PARI
     C                   ELSE
     C                   MOVE      'Y'           F1PARI
     C                   ENDIF
     C                   ELSE
     C                   MOVE      'Y'           F1PARI
     C                   ENDIF
      * Parent Customer
     C     BBPCNB        IFNE      *BLANKS
     C                   MOVE      BBPCNB        F1PCUS
     C                   ELSE
     C                   Z-ADD     *ZERO         F1PCUS
     C                   ENDIF
      * Limit Base Currency Code
     C                   MOVE      BNCYCD        F1LBCY
      *
     C                   ENDSR
      *****************************************************************
      *                                                               *
      *  #S202  -  Set up Detail records 2                            *
      *                                                               *
      *  Called By: #S200                                             *
      *  Calls:     #ERR                                              *
      *                                                               *
      *****************************************************************
      *
     C     #S202         BEGSR
      *
      * MM Limit Type
     C     DZMMTY        IFNE      *BLANKS
     C                   MOVE      DZMMTY        F2MMLT
     C                   ELSE
     C                   Z-ADD     *ZERO         F2MMLT
     C                   ENDIF
      *
      * Initialise Limit details
     C                   MOVE      *BLANKS       F2M1PD
     C                   Z-ADD     *ZERO         F2M1PC
     C                   MOVE      *BLANKS       F2M2PD
     C                   Z-ADD     *ZERO         F2M2PC
     C                   MOVE      *BLANKS       F2M3PD
     C                   Z-ADD     *ZERO         F2M3PC
     C                   MOVE      *BLANKS       F2M4PD
     C                   Z-ADD     *ZERO         F2M4PC
     C                   MOVE      *BLANKS       F2M5PD
     C                   Z-ADD     *ZERO         F2M5PC
     C                   MOVE      *BLANKS       F2M6PD
     C                   Z-ADD     *ZERO         F2M6PC
      *
      * Access limit type Details
     C     DZMMTY        CHAIN     SDLIMTY0                           43
     C     *IN43         IFEQ      *OFF
      *
      * MM 1st Period Days
     C     A2E1LP        IFEQ      'SP '
     C                   MOVE      '002'         F2M1PD
     C                   ELSE
     C                   MOVE      A2E1LP        F2M1PD
     C                   ENDIF
      *
      * MM 1st Period Percentage
     C                   Z-ADD     A2PL1P        F2M1PC
      *
      * MM 2nd Period Days
     C                   Z-ADD     A2E2LP        @@DMN
     C                   MOVE      @@DMA         F2M2PD
      *
      * MM 2nd Period Percentage
     C                   Z-ADD     A2PL2P        F2M2PC
      *
      * MM 3rd Period Days
     C                   Z-ADD     A2E3LP        @@DMN
     C                   MOVE      @@DMA         F2M3PD
      *
      * MM 3rd Period Percentage
     C                   Z-ADD     A2PL3P        F2M3PC
      *
      * MM 4th Period Days
     C                   Z-ADD     A2E4LP        @@DMN
     C                   MOVE      @@DMA         F2M4PD
      *
      * MM 4th Period Percentage
     C                   Z-ADD     A2PL4P        F2M4PC
      *
      * MM 5th Period Days
     C                   Z-ADD     A2E5LP        @@DMN
     C                   MOVE      @@DMA         F2M5PD
      *
      * MM 5th Period Percentage
     C                   Z-ADD     A2PL5P        F2M5PC
      *
      * MM 6th Period Days
     C                   Z-ADD     A2E6LP        @@DMN
     C                   MOVE      @@DMA         F2M6PD
      *
      * MM 6th Period Percentage
     C                   Z-ADD     A2PL6P        F2M6PC
      *
     C                   ELSE
     C                   MOVE      *BLANKS       REPPRG
     C                   MOVE      *BLANKS       REPMSG
     C                   MOVE      *BLANKS       REPKEY
     C                   MOVE      *BLANKS       REPDTA
     C                   MOVE      *BLANKS       REPACN
     C                   MOVEL     F1CUST        REPACN
     C                   MOVEL     '#S202'       REPPRG
     C                   MOVEL     @ERR(3)       REPMSG
     C                   MOVEL     DZMMTY        REPKEY
     C                   EXSR      #ERR
     C                   ENDIF
      *
      * MM Limit Amount
     C                   Z-ADD     DZMMAM        F2MLAM
      *
      * MM Comp. Deposit Limit Amount
     C                   Z-ADD     DZMLAM        F2MCDL
      *
      * MM - Expiry Date
     C     DZMMED        IFEQ      0
     C                   MOVE      *BLANKS       F2MEXD
     C                   ELSE
     C**********         CALL      'GLM053'                                                   LUC109
     C                   CALL      'XX000053'                                                 LUC109
     C                   PARM                    DZMMED
     C*                    PARM           F2MEXD
     C                   PARM      *ZERO         W2MEXD            8 0
     C                   MOVE      W2MEXD        F2MEXD
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
      * FX Limit Type
     C     DZFXLT        IFNE      *BLANKS
     C                   MOVE      DZFXLT        F3XMLT
     C                   ELSE
     C                   Z-ADD     *ZERO         F3XMLT
     C                   ENDIF
      *
      * Initialise Limit details
     C                   MOVE      *BLANKS       F3X1PD
     C                   Z-ADD     *ZERO         F3X1PC
     C                   MOVE      *BLANKS       F3X2PD
     C                   Z-ADD     *ZERO         F3X2PC
     C                   MOVE      *BLANKS       F3X3PD
     C                   Z-ADD     *ZERO         F3X3PC
     C                   MOVE      *BLANKS       F3X4PD
     C                   Z-ADD     *ZERO         F3X4PC
     C                   MOVE      *BLANKS       F3X5PD
     C                   Z-ADD     *ZERO         F3X5PC
     C                   MOVE      *BLANKS       F3X6PD
     C                   Z-ADD     *ZERO         F3X6PC
      *
      * Access limit type Details
     C     DZFXLT        CHAIN     SDLIMTY0                           43
     C     *IN43         IFEQ      *OFF
      *
      * FX 1st Period Days
     C     A2E1LP        IFEQ      'SP '
     C                   MOVE      '002'         F3X1PD
     C                   ELSE
     C                   MOVE      A2E1LP        F3X1PD
     C                   ENDIF
      *
      * FX 1st Period Percentage
     C                   Z-ADD     A2PL1P        F3X1PC
      *
      * FX 2nd Period Days
     C                   Z-ADD     A2E2LP        @@DMN
     C                   MOVE      @@DMA         F3X2PD
      *
      * FX 2nd Period Percentage
     C                   Z-ADD     A2PL2P        F3X2PC
      *
      * FX 3rd Period Days
     C                   Z-ADD     A2E3LP        @@DMN
     C                   MOVE      @@DMA         F3X3PD
      *
      * FX 3rd Period Percentage
     C                   Z-ADD     A2PL3P        F3X3PC
      *
      * FX 4th Period Days
     C                   Z-ADD     A2E4LP        @@DMN
     C                   MOVE      @@DMA         F3X4PD
      *
      * FX 4th Period Percentage
     C                   Z-ADD     A2PL4P        F3X4PC
      *
      * FX 5th Period Days
     C                   Z-ADD     A2E5LP        @@DMN
     C                   MOVE      @@DMA         F3X5PD
      *
      * FX 5th Period Percentage
     C                   Z-ADD     A2PL5P        F3X5PC
      *
      * FX 6th Period Days
     C                   Z-ADD     A2E6LP        @@DMN
     C                   MOVE      @@DMA         F3X6PD
      *
      * FX 6th Period Percentage
     C                   Z-ADD     A2PL6P        F3X6PC
      *
     C                   ELSE
     C                   MOVE      *BLANKS       REPPRG
     C                   MOVE      *BLANKS       REPMSG
     C                   MOVE      *BLANKS       REPKEY
     C                   MOVE      *BLANKS       REPDTA
     C                   MOVE      *BLANKS       REPACN
     C                   MOVEL     F1CUST        REPACN
     C                   MOVEL     '#S203'       REPPRG
     C                   MOVEL     @ERR(3)       REPMSG
     C                   MOVEL     DZFXLT        REPKEY
     C                   EXSR      #ERR
     C                   ENDIF
      *
      * FX Spot Limit Amount
     C                   Z-ADD     DZFLAM        F3XSLA
      *
      * FX Forward Limit Amount
     C                   Z-ADD     DZFXFA        F3XFLA
      *
      * FX MDDR Amount
     C                   Z-ADD     DZMDDR        F3XMDR
      *
      * FX - Expiry Date
     C     DZFLED        IFEQ      0
     C                   MOVE      *BLANKS       F3XEXD
     C                   ELSE
     C**********         CALL      'GLM053'                                                   LUC109
     C                   CALL      'XX000053'                                                 LUC109
     C                   PARM                    DZFLED
     C*                    PARM           F3XEXD
     C                   PARM      *ZERO         W3XEXD            8 0
     C                   MOVE      W3XEXD        F3XEXD
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
      * FRA limit Amount
     C                   Z-ADD     DZFRLA        F4FLAM
      *
      * FRA  Expiry Date
     C     DZFRED        IFEQ      0
     C                   MOVE      *BLANKS       F4FEXD
     C                   ELSE
     C**********         CALL      'GLM053'                                                   LUC109
     C                   CALL      'XX000053'                                                 LUC109
     C                   PARM                    DZFRED
     C*                    PARM           F4FEXD
     C                   PARM      *ZERO         W4FEXD            8 0
     C                   MOVE      W4FEXD        F4FEXD
     C                   ENDIF
      *
      * FRA Lower End Percentage                                       ?
     C                   Z-ADD     BQFLPC        F4FLPC
      *
      * FRA Lower End Period                                           ?
     C                   Z-ADD     BQFLPD        F4FLPP
      *
      * FRA Upper End Percentage                                       ?
     C                   Z-ADD     BQFUPC        F4FUPC
      *
      * FRA Upper End Period                                           ?
     C                   Z-ADD     BQFUPD        F4FUPP
      *
     C                   ENDSR
      *****************************************************************
      *                                                               *
      *  #S205  -  Set up Detail records 5                            *
      *                                                               *
      *  Called By: #S200                                             *
      *  Calls:                                                       *
      *                                                               *
      *****************************************************************
      *
     C     #S205         BEGSR
      *
      * IRS limit Amount
     C                   Z-ADD     DZIRLM        F5ILAM
      *
      * IRS  Expiry Date
     C*          DZFRED    IFEQ 0
     C     DZIRED        IFEQ      0
     C                   MOVE      *BLANKS       F5IEXD
     C                   ELSE
     C**********         CALL      'GLM053'                                                   LUC109
     C                   CALL      'XX000053'                                                 LUC109
     C                   PARM                    DZIRED
     C*                    PARM           F5IEXD
     C                   PARM      *ZERO         W5IEXD            8 0
     C                   MOVE      W5IEXD        F5IEXD
     C                   ENDIF
      *
      * IRS Lower End Percentage                                       ?
     C                   Z-ADD     BQILPC        F5ILPC
      *
      * IRS Lower End Period                                           ?
     C                   Z-ADD     BQILEP        F5ILPP
      *
      * IRS Upper End Percentage                                       ?
     C                   Z-ADD     BQIUPC        F5IUPC
      *
      * IRS Upper End Period                                           ?
     C                   Z-ADD     BQIUEP        F5IUPP
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
     C     *IN88         IFEQ      *ON                                          Database error
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
     C                   WRITE     FELIMF
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
     C**********         MOVEL     'GLM036'      DBPGM                          Set program idLUC109
     C                   MOVEL     'XX000036'    DBPGM                          Set program idLUC109
     C                   ENDIF
      *
     C     *LOCK         IN        WLDA
     C                   MOVEL     DBERR         WLDA
     C                   OUT       WLDA
      *
     C                   MOVE      *ON           *IN88                          Database error
     C                   MOVE      *ON           *INU7                                         15996
     C                   MOVE      *ON           *INU8                                         15996
     C                   DUMP                                                   Dump system var
      *
     C                   EXSR      #TERM                                        Stop run
      *
     C                   ENDIF
      *
     C                   ENDSR
      /EJECT                                                              MUI009
      *****************************************************************   MUI009
      *                                                               *   MUI009
      *    COMP      - COMPANY SR                                     *   MUI009
      *                                                               *   MUI009
      *    CALLED BY - MAIN                                           *   MUI009
      *    CALLS     - LOTS                                           *   MUI009
      *                                                               *   MUI009
      *****************************************************************   MUI009
      *                                                                   MUI009
     C     COMP          BEGSR                                                                 MUI00
      *                                                                   MUI009
      * Read all COMPANYS                                                 MUI009
      *                                                                   MUI009
     C     *LOVAL        SETLL     SDCOMPL1                                                    MUI00
     C                   READ      SDCOMPL1                               20                   MUI00
      *                                                                   MUI009
      *                                                                   MUI009
     C     *IN20         DOWEQ     *OFF                                         Until eof      MUI00
      * COMPANY Code                                                      MUI009
     C                   MOVE      APCMCD        FBRCD                                         MUI00
      *                                                                   MUI009
      *  Write Branch Header Record                                       MUI009
     C                   MOVE      '02'          RECC                                          MUI00
     C                   MOVE      BRCHHD        DATA                                          MUI00
     C                   WRITE     FELIMF                                                      MUI00
     C                   ADD       1             COUNT                                         MUI00
      *                                                                   MUI009
     C                   MOVE      APCMCD        F1BKCD                                        MUI00
     C                   MOVE      APCMCD        F1BRCD                                        MUI00
     C                   MOVE      '05'          RECC                                          MUI00
      *                                                                   MUI009
      *   Generate Detail Records                                         MUI009
     C                   EXSR      #S200                                                       MUI00
      *                                                                   MUI009
      *  Write Branch Trailer Record                                      MUI009
     C                   MOVE      '09'          RECC                                          MUI00
     C                   MOVE      *BLANKS       DATA                                          MUI00
     C                   WRITE     FELIMF                                                      MUI00
     C                   ADD       1             COUNT                                         MUI00
      *                                                                   MUI009
      *                                                                   MUI009
      *  Read Next record                                                 MUI009
     C                   READ      SDCOMPL1                               20                   MUI00
      *                                                                   MUI009
      *                                                                   MUI009
     C                   ENDDO                                                                 MUI00
      *                                                                   MUI009
     C                   ENDSR                                                                 MUI00
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
      ***
**  CPY@
(c) Finastra International Limited 2016
**  @ERR
SDCTRYY0 RECORD NOT FOUND
SDCUSTY0 RECORD NOT FOUND
SDLIMTY0 RECORD NOT FOUND
