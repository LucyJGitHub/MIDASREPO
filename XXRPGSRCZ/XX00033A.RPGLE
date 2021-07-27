     H DEBUG DATEDIT(*YMD)
      *****************************************************************
/*S*D****RPGBASE*******************************************************                       LUC109
/*STD *  RPGBASEBND                                                   *                       LUC109
/*EXI *  TEXT('GL Bills Documents Extract')                           *                       LUC109
      *****************************************************************
      *                                                               *
      *  Midas - Interface to Head Office Reporting                   *
      *                                                               *
      ***GLM033A*-*GL*Bills*Documents*Extract**************************                       LUC109
      *  XX00033A - GL Bills Documents Extract                        *                       LUC109
      *                                                               *                       LUC109
  ?   *****************************************************************
  ?   * *** THIS PROGRAM MUST BE COMPILED WITH XXINTFLIB AT THE TOP   *
  ?   * OF LIBL ***                                                   *
  ?   *****************************************************************
      *                                                               *
      *  Function: GL Bills Document Extract                          *
      *                                                               *
      *                                                               *
      ***CALLED BY**GLCM033*-*GL*Bills*Extract*************************                       LUC109
      *  CALLED BY  XXC00033 - GL Bills Extract                       *                       LUC109
      *             Frequency: Automatically in Close of Business     *
      *                                                               *
      ***(C)*COPYRIGHT*MKI*LIMITED*1998********************************                       LUC109
      *  (c) Finastra International Limited 2016                      *                       LUC109
      *                                                               *
      *  Last Amend No. LUC109             Date 20Sep16               *
      *  Prev Amend No. 245336             Date 29Jan07               *
      *                 238352             Date 06Feb06               *
      *                 MUI011             Date 24May04               *
      *                 224663             Date 23Feb04               *
      *                 222255             Date 17Oct03               *
      *                 206329             Date 05Jun02               *
      *                 LUC010             Date 22Aug01               *
      *                 182400             Date 15AUG00               *
      *                 MUI002             Date 22Dec99               *
      *                 159964             Date 22Aug99               *
      *                 MMI043             Date 18Dec98               *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  LUC109 - HO Reporting (Upgrade to FB Midas 2.1)              *
      *  245336 - Field C5064 (Expired Indicator) set to 0 before     *
      *           Maturity Date.                                      *
      *  238352 - Fields C9151 and C9152 empty before Value Date.     *
      *  MUI011 - ALMS - Add field C9830.                             *
      *  224663 - Field C9116 to contain total discount for discount  *
      *           loans.                                              *
      *  222255 - Field C9115 to contain interest posted to date.     *
      *  206329 - Matured loans reported as live.                     *
      *  LUC010 - Changes to Head Office Extracts                     *
      *  182400 - Facilities file should be accessed using Facility   *
      *           Customer, as not always = customer of loan.         *
      *  MUI002 - HOR Extract of Rediscount of Discounted Financial   *
      *           Bills.                                              *
      *  159964 - PGM/GLM032A cannot allocate object LF/SDCUSTL0 due  *
      *           to SCC0406.                                         *
      *         - Seton job switches U7/U8 for error processing       *
      *  MMI043 - Bills Document Extract                              *
      *                                                               *
      *****************************************************************
      *
     FSDBANKPD  IF   E             DISK    INFSR(*PSSR)
     FSDGELRPP  IF   E             DISK    INFSR(*PSSR)
     FSDGELRPD  IF   E             DISK    INFSR(*PSSR)
     FSDBRCHL1  IF   E           K DISK    INFSR(*PSSR)
     FCLOANBR   IF   E           K DISK    INFSR(*PSSR)
     FCLOANCY0  IF   E           K DISK    INFSR(*PSSR)
     FCLOANCV3  IF   E           K DISK    INFSR(*PSSR)                         MUI002
     F                                     RENAME(CLOANCLF:CLOANCL0)            MUI002
     F                                     RENAME(MCLONCLF:MCLONCL0)            MUI002
     FMLOAN     IF   E           K DISK    INFSR(*PSSR)                         MUI002
     F                                     IGNORE(CLOANHHF)                     MUI002
     F                                     IGNORE(CLOANCLF)                     MUI002
     F                                     RENAME(CLOANCKF:MLOANK)              MUI002
     F                                     IGNORE(CLOANZ1F)                     MUI002
     FSDCUSTY0  IF   E           K DISK    INFSR(*PSSR)                         MUI002
     FFCLTYL8   IF   E           K DISK    INFSR(*PSSR)
     FSDACRCL9  IF   E           K DISK    INFSR(*PSSR)
     FSDINTFPD  IF   E           K DISK    INFSR(*PSSR)
     FACKEY     IF   E           K DISK    INFSR(*PSSR)
     FWKFEPTF   O    E             DISK    INFSR(*PSSR)
     F***GLM033AU  O    E             PRINTER INFDS(SPOOL)                                    LUC109
     FXX000033AUO    E             PRINTER INFDS(SPOOL)                                       LUC109
     F                                     INFSR(*PSSR)
      *
      *****************************************************************
      *                                                               *
      *  F U N C T I O N   O F   I N D I C A T O R S                  *
      *                                                               *
      *   20 - LF/SDBRCHL1   File I/O                                 *
      *   21 - LF/DEALBR     File I/O                                 *
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
      *  #BSPL  - Determine BSPL Details                              *
      *  #ACKEY - Determine Account Codes                             *
      *  #TERM  - Program termination                                 *
      *  *PSSR  - Abnormal termination                                *
      *                                                               *
      *****************************************************************
      * COMPILE TIME ARRAYS                                           *
     D CPY@            S             80    DIM(1) CTDATA PERRCD(1)              Copyright
     D @ERR            S             35    DIM(5) CTDATA PERRCD(1)
      *
      ***File*information*for*printer*file*GLM033AU********************                       LUC109
      ** File information for printer file XX000033AU                                         LUC109
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
     D  F1DCFL                 4      4
     D  F1BKCD                 5      7
     D  F1BRCD                 8     10
     D  F1RCUS                11     16
     D  F1DCUS                17     22
     D  F1CCUS                23     28
     D  F1SCUS                29     34
     D  F1BASC                35     35
     D  F1FACT                36     38  0
     D  F1FCNO                39     40  0
     D  F1FCSD                41     48
     D  F1FCED                49     56
     D  F1DTYP                57     58
     D  F1DSBT                59     60
     D  F1CCYC                61     63
     D  F1MDCD                64     66
     D**********                             67  78 F1FILL                LUC010
     D  C9811                 67     70                                         LUC010
     D  C9802                 71     76                                         LUC010
     D  F1FILL                77     78                                         LUC010
     D**********                             77  78 F1FILL          LUC010MUI011
     D  F1BOKC                77     78                                         MUI011
      *
      ** Detail Record 2
      *
     D DET002          DS
     D  F2PROG                 1      3
     D  F2DNUM                 4     18
     D  F2ACNM                19     36
     D  F2ACCD                37     40  0
     D  F2RLAC                41     44  0
     D  F2COAC                45     48  0
     D  F29153                49     52  0
     D  F29154                53     56  0
     D  C9160                 49     56                                         LUC010
     D  F2IDIM                57     75
     D  F2FILL                76     78
      *
      ** Detail Record 3
      *
     D DET003          DS
     D  F3PROG                 1      3
     D  F3IDAM                 4     22
     D  F3IRIM                23     41
     D  F3IRAM                42     60
     D  F3DSCR                61     68  5
     D  F3MATD                69     76
     D  F3FILL                77     78
      *
      ** Detail Record 4
      *
     D DET004          DS
     D  F4PROG                 1      3
     D  F4FVAL                 4     22
     D  F4DSWR                23     23
     D  F4LCBL                24     24
     D  F4TBRC                25     25
     D  F4SDAT                26     33
     D  F4ACBL                34     52
     D  F4CRTP                53     53
     D  F4TSEX                54     54
     D  F4BSP1                55     58  0
     D  F4BSP2                59     62  0
     D  F4BSP3                63     66  0
     D  F4FIL1                67     68
     D  F4KOBP                69     69
     D  C9812                 70     78                                         LUC010
     D************************************** 70  78 F4FIL2                LUC010
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
     D* Account Key
     D @@ACK           DS
     D  @ACFL1                 1      2
     D  @ACFL2                 3      3
     D  @ACFL3                 4      5
     D  @ACFIL                 6      8
     D  @ACFL4                 9     10
     D* Deal Number
     D                 DS
     D  @@DLNA                 1     15
     D  @@DLNN                 1     15  0
      *
      ** Account Number
      *
     D ACNUM           DS
     D  ABRCH                  1      3
     D  ACUST                  4      9  0
     D  ACCYC                 10     12
     D  AACOD                 13     16  0
     D  AACSQ                 17     18  0
     D* ERROR DATA STRUCTURE
     D REPAMT          DS
     D  REPCCY                 1      3
     D  REPVAL                 4     18  0
     D ERRFAC          DS
     D  ERRCUS                 1      6
     D  ERRFCT                 8     10
     D  ERRFCS                11     12
     I***/C*PY*ZSRSRC,ZDATE2Z1                                                                LUC109
     I/COPY ZSRSRC,ZDATE2Z1LE                                                                 LUC109
      *
      *
      ** CLOANCL0 Record                                                  MUI002
      *                                                                   MUI002
     ICLOANCL0      01                                                          MUI002
     I              RECI                        RRRECI                          MUI002
     I              LNRF                        RRLNRF                          MUI002
     I              PTYP                        RRPTYP                          LUC010
     I              CNUM                        RRCNUM                          MUI002
     I              BRCA                        RRBRCA                          MUI002
     I              LTYP                        RRLTYP                          MUI002
     I              SUTP                        RRSUTP                          MUI002
     I              VDAT                        RRVDAT                          MUI002
     I              MDAT                        RRMDAT                          MUI002
     I              LASQ                        RRLASQ                          MUI002
     I              FCUS                        RRFCUS                          182400
     I              FTYP                        RRFTYP                          MUI002
     I              FSEQ                        RRFSEQ                          MUI002
     I              CCY                         RRCCY                           MUI002
     I              CPAM                        RRCPAM                          MUI002
     I              INTR                        RRINTR                          MUI002
     I              MARG                        RRMARG                          LUC010
     I              PSAM                        RRPSAM                          MUI002
     I              ICBS                        RRICBS                          MUI002
     I              AITC                        RRAITC                          MUI002
     I              AIAP                        RRAIAP                          MUI002
     I              IPRD                        RRIPRD                          MUI002
     I              IPRM                        RRIPRM                          MUI002
      *                                                                   EF0018
      ** MCLONCL0 Record                                                  EF0018
      *                                                                   EF0018
     IMCLONCL0      02                                                          EF0018
     I              RECI                        PPRECI                          EF0018
     I              LNRF                        PPLNRF                          EF0018
     I              PTYP                        PPPTYP                          LUC010
     I              CNUM                        PPCNUM                          EF0018
     I              BRCA                        PPBRCA                          EF0018
     I              LTYP                        PPLTYP                          EF0018
     I              SUTP                        PPSUTP                          EF0018
     I              VDAT                        PPVDAT                          EF0018
     I              MDAT                        PPMDAT                          EF0018
     I              LASQ                        PPLASQ                          EF0018
     I              FCUS                        PPFCUS                          EF0018
     I              FTYP                        PPFTYP                          EF0018
     I              FSEQ                        PPFSEQ                          EF0018
     I              CCY                         PPCCY                           EF0018
     I              CPAM                        PPCPAM                          EF0018
     I              INTR                        PPINTR                          EF0018
     I              MARG                        PPMARG                          LUC010
     I              PSAM                        PPPSAM                          EF0018
     I              ICBS                        PPICBS                          EF0018
     I              AITC                        PPAITC                          EF0018
     I              AIAP                        PPAIAP                          EF0018
     I              IPRD                        PPIPRD                          EF0018
     I              IPRM                        PRIPRM                          EF0018
      *                                                                   MUI002
      ** MLOAN Record                                                     MUI002
      *                                                                   MUI002
     IMLOANK                                                                    MUI002
     I              OPAM                        QQOPAM                          MUI002
      *                                                                   MUI002
      ** FCLTYFM Record (Field amended to avoid conflict)                 MUI002
      *                                                                   MUI002
     IFCLTYFMF                                                                  MUI002
     I              CNUM                        FFCNUM                          MUI002
      *                                                                   206329
      ** Account keys                                                     206329
      *                                                                   206329
     IACKEYAKF                                                                  206329
     I              RECI                        AKRECI                          206329
      *                                                                   206329
     IACKEYALF                                                                  206329
     I              RECI                        ALRECI                          206329
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
      ** Key list/parameter list definition for SDACRCL9
      *
     C     @@KEY         KLIST
     C                   KFLD                    XXRSNO            1
     C                   KFLD                    XXACCD            4
     C                   KFLD                    XXDRCR            1
      ** Key list/parameter list definition for FCLTYL8
      *
     C     @@KEY1        KLIST
     C**********           KFLD           CNUM                            182400
     C                   KFLD                    FCUS                                          18240
     C                   KFLD                    FTYP
     C                   KFLD                    FSEQ
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
      *                                                                   CEU011
     C                   MOVE      *BLANKS       FILL01
     C                   MOVE      *BLANKS       FILL02
     C                   MOVE      *BLANKS       F1FILL
     C                   MOVE      *BLANKS       F2FILL
     C                   MOVE      *BLANKS       F3FILL
     C*                    MOVE *BLANKS   F4FIL1
     C******************** MOVE *BLANKS   F4FIL2                          LUC010
     C                   MOVE      *BLANKS       FILL04
     C                   MOVE      '001'         F1PROG
     C                   MOVE      '002'         F2PROG
     C                   MOVE      '003'         F3PROG
     C                   MOVE      '004'         F4PROG
     C*
     C* SET UP HEADER FIELDS
     C*
     C                   MOVE      A8CMCD        FBKCD
     C                   MOVE      BJSLCD        FGPCD
     C                   MOVEL     'FEPTF'       FEXFL
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
     C                   MOVE      A8CMCD        F1BKCD
     C                   MOVE      FBRCD         F1BRCD
      *
      *   Generate Detail Records
     C                   EXSR      #S200
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
      *  Calls:     #S201 #S202 #S203 #S204                           *
      *                                                               *
      *****************************************************************
      *
     C     #S200         BEGSR
      *
      * Read all Loans for the branch
      *
     C     FBRCD         SETLL     CLOANBR
     C     FBRCD         READE     CLOANBR                                21
      *
      *
     C     *IN21         DOWEQ     *OFF                                         Until eof
      *
      * Process only outstanding loans or loans that have matured
      *  since the end of the previous month
     C     RECI          IFEQ      'M'
     C     MDAT          ANDGT     MPEMB
     C     RECI          OREQ      'D'
      *                                                                   MUI002
      * Initialize the @@KEY1 KLIST for the customer number               MUI002
     C*                    Z-ADDCNUM      XXPCUS  60                      MUI002
      *                                                                   MUI002
      * Check the corresponding details in file CLOANCV0 for              MUI002
      * 'HD' Loan Type transactions.                                      MUI002
     C     LTYP          IFEQ      'HD'                                                        MUI00
     C                   EXSR      CHKHP                                                       MUI00
     C                   ENDIF                                                                 MUI00
      *
      * Access loan extension details
     C     LNRF          CHAIN     CLOANCY0                           23
      *
      * Access Facility details
     C     @@KEY1        CHAIN     FCLTYL8                            24
      *
     C                   MOVEL     '05'          WKFLD1
     C                   MOVEL     '05'          WKFLD2
     C                   MOVEL     '05'          WKFLD3
     C                   MOVEL     '05'          WKFLD4
      *
     C                   EXSR      #S201
      *
      *  Write Detail Record 1
     C                   MOVE      DET001        WKFLD1
      *
      *
     C                   EXSR      #S202
      *
      *  Write Detail Record 2
     C                   MOVE      DET002        WKFLD2
      *
     C     *IN23         IFEQ      *ON
     C                   MOVE      *BLANKS       REPPRG
     C                   MOVE      *BLANKS       REPMSG
     C                   MOVE      *BLANKS       REPKEY
     C                   MOVE      *BLANKS       REPDTA
     C                   MOVE      *BLANKS       REPACN
     C                   MOVEL     F2DNUM        REPACN
     C                   MOVEL     '#S200'       REPPRG
     C                   MOVEL     @ERR(1)       REPMSG
     C                   MOVEL     LNRF          REPKEY
     C                   EXSR      #ERR
     C                   ENDIF
      *
     C     *IN24         IFEQ      *ON
     C                   MOVE      *BLANKS       REPPRG
     C                   MOVE      *BLANKS       REPMSG
     C                   MOVE      *BLANKS       REPKEY
     C                   MOVE      *BLANKS       REPDTA
     C                   MOVE      *BLANKS       REPACN
     C                   MOVEL     F2DNUM        REPACN
     C                   MOVEL     '#S200'       REPPRG
     C                   MOVEL     @ERR(2)       REPMSG
     C**********           MOVE CNUM      ERRCUS                          182400
     C                   MOVE      FCUS          ERRCUS                                        18240
     C                   MOVE      FTYP          ERRFCT
     C                   MOVE      FSEQ          ERRFCS
     C                   MOVEL     ERRFAC        REPKEY
     C                   EXSR      #ERR
     C                   ENDIF
      *
     C                   EXSR      #S203
      *
      *  Write Detail Record 3
     C                   MOVE      DET003        WKFLD3
      *
      *
     C                   EXSR      #S204
      *
      *  Write Detail Record 4
     C                   MOVE      DET004        WKFLD4
      *
     C                   WRITE     WKFEPTFF
     C*
     C                   ENDIF
      *
      *  Read Next record
     C     FBRCD         READE     CLOANBR                                21
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
      *  Calls:                                                       *
      *                                                               *
      *****************************************************************
      *
     C     #S201         BEGSR
      *
      * Discount Collection Flag
     C                   MOVE      'D'           F1DCFL
      * Releaser's Customer Number
     C                   MOVE      CNUM          F1RCUS
      * Drawee's Customer Number
     C     *IN23         IFEQ      *OFF
     C                   MOVE      MDCUS         F1DCUS
     C                   ELSE
     C                   MOVE      *BLANKS       F1DCUS
     C                   ENDIF
      * Consignee's Customer Number
     C                   MOVE      *BLANKS       F1CCUS
      * Rediscounter's Customer Number
     C                   MOVE      *BLANKS       F1SCUS
     C     LTYP          IFEQ      'HD'                                                        MUI00
     C     WHP           ANDEQ     'Y'                                                         MUI00
     C                   MOVE      PCUST         F1SCUS                                        MUI00
     C                   ENDIF                                                                 MUI00
      * Basis Code
     C                   MOVE      ICBS          F1BASC
      * Facility Type
     C                   Z-ADD     FTYP          F1FACT
      * Facility Number
     C                   Z-ADD     FSEQ          F1FCNO
      * Facility Starting Date
     C     *IN24         IFEQ      *OFF
     C**********         CALL      'GLM053'                                                   LUC109
     C                   CALL      'XX000053'                                                 LUC109
     C                   PARM                    DTAP
     C*                    PARM           F1FCSD
     C                   PARM      *ZERO         W1FCSD            8 0
     C                   MOVE      W1FCSD        F1FCSD
     C                   ELSE
     C                   MOVE      *BLANKS       F1FCSD
     C                   ENDIF
      * Facility Expiry Date
     C     *IN24         IFEQ      *OFF
     C**********         CALL      'GLM053'                                                   LUC109
     C                   CALL      'XX000053'                                                 LUC109
     C                   PARM                    DTEX
     C*                    PARM           F1FCED
     C                   PARM      *ZERO         W1FCED            8 0
     C                   MOVE      W1FCED        F1FCED
     C                   ELSE
     C                   MOVE      *BLANKS       F1FCED
     C                   ENDIF
      * Deal Type
     C                   MOVE      LTYP          F1DTYP
      * Deal Sub-Type
     C                   MOVE      SUTP          F1DSBT
      * Currency Code
     C                   MOVE      CCY           F1CCYC
      * Module Code
     C                   MOVE      'LE '         F1MDCD
      * Profit Centre Code                                                LUC010
     C                   MOVE      PRFC          C9811                                         LUC01
      *                                                                   LUC010
      * Facility Customer Number (For Discounted items only)              LUC010
     C                   MOVE      *BLANKS       C9802                                         LUC01
     C     PTYP          IFEQ      63                                                          LUC01
     C                   MOVE      FCUS          C9802                                         LUC01
     C                   ENDIF                                                                 LUC01
      * Book Code                                                         MUI011
     C                   MOVE      BOKC          F1BOKC                                        MUI01
      *
     C                   ENDSR
      *****************************************************************
      *                                                               *
      *  #S202  -  Set up Detail records 2                            *
      *                                                               *
      *  Called By: #S200                                             *
      *  Calls:                                                       *
      *                                                               *
      *****************************************************************
      *
     C     #S202         BEGSR
      *
      * Deal Number
     C                   Z-ADD     0             @@DLNN
     C                   MOVEL     LNRF          @@DLNN
     C                   MOVE      @@DLNA        F2DNUM
      *
      * Account Number and account Code
     C********** VDAT      IFLE BJRDNB                                    238352
      *
      * Set up Standard part of account Key
     C                   MOVE      LTYP          @ACFL1
     C                   MOVE      SUTP          @ACFL3
      *                                                                   MUI002
      * Use 'HP' for 'HD' transactions with corresponding 'HP'            MUI002
     C     LTYP          IFEQ      'HD'                                                        MUI00
     C     WHP           ANDEQ     'Y'                                                         MUI00
     C                   MOVE      XXLTYP        @ACFL1                                        MUI00
     C                   MOVE      XXSUTP        @ACFL3                                        MUI00
     C                   ENDIF                                                                 MUI00
     C                   MOVE      'R'           @ACFL2
     C                   MOVE      ' A'          @ACFL4
     C                   EXSR      #ACKEY
      *
      * Account Code
     C                   Z-ADD     @@ACC2        F2ACCD
      *                                                                   238352
      * Before Value Date, use Deal Date Account Key for C9151            238352
     C     VDAT          IFGT      BJRDNB                                                      23835
     C                   MOVE      'D'           @ACFL2                                        23835
     C     @@ACK         CHAIN     ACKEY                              40                       23835
      *                                                                   238352
     C     ACD6          IFNE      *ZERO                                                       23835
     C                   Z-ADD     ACD6          @@ACC2                                        23835
     C                   ENDIF                                                                 23835
      *                                                                   238352
     C     ACD5          IFNE      *ZERO                                                       23835
     C                   Z-ADD     ACD5          @@ACC2                                        23835
     C                   ENDIF                                                                 23835
      *                                                                   238352
     C     ACD4          IFNE      *ZERO                                                       23835
     C                   Z-ADD     ACD4          @@ACC2                                        23835
     C                   ENDIF                                                                 23835
     C                   ENDIF                                                                 23835
      *
      * Account Number
     C                   MOVE      BRCA          ABRCH
     C                   Z-ADD     CNUM          ACUST
     C                   MOVE      CCY           ACCYC
     C                   Z-ADD     @@ACC2        AACOD
     C                   Z-ADD     LASQ          AACSQ
      *                                                                   MUI002
      * Use the saved details if an 'HD' transaction                      MUI002
     C     LTYP          IFEQ      'HD'                                                        MUI00
     C     WHP           ANDEQ     'Y'                                                         MUI00
      **Check*for*the*value*date***************************         MUI002238352
     C********** PVDAT     ANDLEBJRDNB                              MUI002238352
     C                   MOVE      PBRCH         ABRCH                                         MUI00
     C                   Z-ADD     PCUST         ACUST                                         MUI00
     C                   MOVE      PCCY          ACCYC                                         MUI00
     C                   Z-ADD     PLASQ         AACSQ                                         MUI00
     C                   ENDIF                                                                 MUI00
      *                                                                   MUI002
     C                   MOVEL     ACNUM         F2ACNM
     C**********                                                          238352
     C**********           ELSE                                           238352
     C**********           Z-ADD*ZERO     F2ACCD                          238352
     C**********           MOVE *BLANKS   F2ACNM                          238352
     C**********           ENDIF                                          238352
      *
      * Releaser's Memo Account Code
     C                   Z-ADD     *ZERO         F2RLAC
      *
      * Consignee's Memo Account Code
     C                   Z-ADD     *ZERO         F2COAC
      *                                                                   MUI002
      * Use the searched account code if an 'HD' transaction              MUI002
     C     LTYP          IFEQ      'HD'                                                        MUI00
     C     WHP           ANDEQ     'Y'                                                         MUI00
     C     VDAT          ANDLE     BJRDNB                                                      23835
     C                   Z-ADD     @@ACC1        F2COAC                                        MUI00
     C                   ENDIF                                                                 MUI00
      *
      * C9153
     C                   Z-ADD     *ZERO         F29153
      *
      * C9154
     C                   Z-ADD     *ZERO         F29154
      *                                                                   LUC010
      * Value Date (For Discounted items only)                            LUC010
     C                   MOVE      *BLANKS       C9160                                         LUC01
     C     PTYP          IFEQ      63                                                          LUC01
     C**********         CALL      'GLM053'                                                   LUC109
     C                   CALL      'XX000053'                                                 LUC109
     C                   PARM                    VDAT                                          LUC01
     C                   PARM      *ZERO         WFNWKD            8 0                         LUC01
      *                                                                   LUC010
     C                   MOVE      WFNWKD        C9160                                         LUC01
     C                   ENDIF                                                                 LUC01
      *
      * Interest on debit balances accrued in the month
     C     CCY           IFNE      *BLANKS
     C                   Z-ADD     MDACM         @@AMT
     C                   Z-SUB     @@AMT         @@AMT                          reverse sign
     C                   MOVE      'N'           IERROR            1
     C**********         CALL      'GLM041'                                                   LUC109
     C                   CALL      'XX000041'                                                 LUC109
     C                   PARM                    CCY
     C                   PARM                    @@AMT            15 0
     C                   PARM                    F2IDIM
     C                   PARM                    IERROR
      *
     C     IERROR        IFEQ      'Y'                                          Ended in error
     C                   MOVE      *BLANKS       REPPRG
     C                   MOVE      *BLANKS       REPMSG
     C                   MOVE      *BLANKS       REPKEY
     C                   MOVE      *BLANKS       REPDTA
     C                   MOVEL     F2DNUM        REPACN
     C                   MOVEL     '#S202'       REPPRG
     C                   MOVEL     @ERR(3)       REPMSG
     C                   MOVEL     '*NONE'       REPKEY
     C                   MOVE      CCY           REPCCY
     C                   Z-ADD     MDACM         REPVAL
     C                   MOVEL     REPAMT        REPDTA
     C                   EXSR      #ERR
     C                   MOVE      *BLANKS       F2IDIM
     C                   ENDIF
      *
     C                   ELSE
     C                   MOVE      *BLANKS       F2IDIM
     C                   ENDIF
      *
     C                   ENDSR
      *****************************************************************
      *                                                               *
      *  #S203  -  Set up Detail records 3                            *
      *                                                               *
      *  Called By: #S200                                             *
      *  Calls:     #ACKEY                                            *
      *                                                               *
      *****************************************************************
      *
     C     #S203         BEGSR
      *
      * Interest on debit balances accrued at the month
     C     CCY           IFNE      *BLANKS
     C**********           Z-ADDAITC      @@AMT                           222255
     C**********           ADD  AIAP      @@AMT                           222255
     C**********           Z-SUB@@AMT     @@AMT            reverse sign   222255
     C                   Z-SUB     AIPD          @@AMT                          reverse sign   22225
     C                   MOVE      'N'           IERROR            1
     C**********         CALL      'GLM041'                                                   LUC109
     C                   CALL      'XX000041'                                                 LUC109
     C                   PARM                    CCY
     C                   PARM                    @@AMT            15 0
     C                   PARM                    F3IDAM
     C                   PARM                    IERROR
      *
     C     IERROR        IFEQ      'Y'                                          Ended in error
     C                   MOVE      *BLANKS       REPPRG
     C                   MOVE      *BLANKS       REPMSG
     C                   MOVE      *BLANKS       REPKEY
     C                   MOVE      *BLANKS       REPDTA
     C                   MOVEL     F2DNUM        REPACN
     C                   MOVEL     '#S203'       REPPRG
     C                   MOVEL     @ERR(3)       REPMSG
     C                   MOVEL     '*NONE'       REPKEY
     C                   MOVE      CCY           REPCCY
     C                   Z-ADD     @@AMT         REPVAL
     C                   MOVEL     REPAMT        REPDTA
     C                   EXSR      #ERR
     C                   MOVE      *BLANKS       F3IDAM
     C                   ENDIF
      *
     C                   ELSE
     C                   MOVE      *BLANKS       F3IDAM
     C                   ENDIF
      *
      * Interest on debit balances received this month
     C     CCY           IFNE      *BLANKS
     C                   Z-ADD     IPRM          @@AMT
     C                   Z-SUB     @@AMT         @@AMT                          reverse sign
     C                   MOVE      'N'           IERROR            1
     C**********         CALL      'GLM041'                                                   LUC109
     C                   CALL      'XX000041'                                                 LUC109
     C                   PARM                    CCY
     C                   PARM                    @@AMT            15 0
     C                   PARM                    F3IRIM
     C                   PARM                    IERROR
      *
     C     IERROR        IFEQ      'Y'                                          Ended in error
     C                   MOVE      *BLANKS       REPPRG
     C                   MOVE      *BLANKS       REPMSG
     C                   MOVE      *BLANKS       REPKEY
     C                   MOVE      *BLANKS       REPDTA
     C                   MOVEL     F2DNUM        REPACN
     C                   MOVEL     '#S203'       REPPRG
     C                   MOVEL     @ERR(3)       REPMSG
     C                   MOVEL     '*NONE'       REPKEY
     C                   MOVE      CCY           REPCCY
     C                   Z-ADD     IPRM          REPVAL
     C                   MOVEL     REPAMT        REPDTA
     C                   EXSR      #ERR
     C                   MOVE      *BLANKS       F3IRIM
     C                   ENDIF
      *
     C                   ELSE
     C                   MOVE      *BLANKS       F3IRIM
     C                   ENDIF
      *
      * Interest on debit balances received at the month
     C     CCY           IFNE      *BLANKS
     C                   Z-ADD     IPRD          @@AMT
     C     PTYP          IFEQ      63                                                          22466
     C                   Z-ADD     TOTI          @@AMT                                         22466
     C                   ENDIF                                                                 22466
     C                   Z-SUB     @@AMT         @@AMT                          reverse sign
     C                   MOVE      'N'           IERROR            1
     C**********         CALL      'GLM041'                                                   LUC109
     C                   CALL      'XX000041'                                                 LUC109
     C                   PARM                    CCY
     C                   PARM                    @@AMT            15 0
     C                   PARM                    F3IRAM
     C                   PARM                    IERROR
      *
     C     IERROR        IFEQ      'Y'                                          Ended in error
     C                   MOVE      *BLANKS       REPPRG
     C                   MOVE      *BLANKS       REPMSG
     C                   MOVE      *BLANKS       REPKEY
     C                   MOVE      *BLANKS       REPDTA
     C                   MOVEL     F2DNUM        REPACN
     C                   MOVEL     '#S203'       REPPRG
     C                   MOVEL     @ERR(3)       REPMSG
     C                   MOVEL     '*NONE'       REPKEY
     C                   MOVE      CCY           REPCCY
     C                   Z-ADD     IPRD          REPVAL
     C                   MOVEL     REPAMT        REPDTA
     C                   EXSR      #ERR
     C                   MOVE      *BLANKS       F3IRAM
     C                   ENDIF
      *
     C                   ELSE
     C                   MOVE      *BLANKS       F3IRAM
     C                   ENDIF
      *
      * Discount Rate
     C                   Z-ADD     INTR          F3DSCR
      *
      * Maturity Date
     C**********         CALL      'GLM053'                                                   LUC109
     C                   CALL      'XX000053'                                                 LUC109
     C                   PARM                    MDAT
     C*                    PARM           F3MATD
     C                   PARM      *ZERO         W3MATD            8 0
     C                   MOVE      W3MATD        F3MATD
      *
     C                   ENDSR
      *****************************************************************
      *                                                               *
      *  #S204  -  Set up Detail records 4                            *
      *                                                               *
      *  Called By: #S200                                             *
      *  Calls:     #ACKEY #BSPL                                      *
      *                                                               *
      *****************************************************************
      *
     C     #S204         BEGSR
      *
      * Face Value of Draft in Original Currency
     C     CCY           IFNE      *BLANKS
     C                   Z-ADD     CPAM          @@AMT
      *                                                                   MUI002
      * Use the calculated amounts for 'HD' transactions                  MUI002
     C     LTYP          IFEQ      'HD'                                                        MUI00
     C     WHP           ANDEQ     'Y'                                                         MUI00
     C                   Z-ADD     PFVAL         @@AMT                                         MUI00
     C                   ENDIF                                                                 MUI00
      *                                                                   MUI002
     C                   Z-SUB     @@AMT         @@AMT                          reverse sign
     C                   MOVE      'N'           IERROR            1
     C**********         CALL      'GLM041'                                                   LUC109
     C                   CALL      'XX000041'                                                 LUC109
     C                   PARM                    CCY
     C                   PARM                    @@AMT            15 0
     C                   PARM                    F4FVAL
     C                   PARM                    IERROR
      *
     C     IERROR        IFEQ      'Y'                                          Ended in error
     C                   MOVE      *BLANKS       REPPRG
     C                   MOVE      *BLANKS       REPMSG
     C                   MOVE      *BLANKS       REPKEY
     C                   MOVE      *BLANKS       REPDTA
     C                   MOVEL     F2DNUM        REPACN
     C                   MOVEL     '#S204'       REPPRG
     C                   MOVEL     @ERR(3)       REPMSG
     C                   MOVEL     '*NONE'       REPKEY
     C                   MOVE      CCY           REPCCY
     C                   Z-ADD     CPAM          REPVAL
     C                   MOVEL     REPAMT        REPDTA
     C                   EXSR      #ERR
     C                   MOVE      *BLANKS       F4FVAL
     C                   ENDIF
      *
     C                   ELSE
     C                   MOVE      *BLANKS       F4FVAL
     C                   ENDIF
      *
      * Discount with/without recourse
     C                   MOVE      MDISC         F4DSWR
      *
      * Location of the bills
     C                   MOVE      '0'           F4LCBL
      *
      * Bills rediscounted with Central Bank
     C                   MOVE      '0'           F4TBRC
      *                                                                   MUI002
      * For 'HD' records with 'HP' and a central bank.                    MUI002
     C     LTYP          IFEQ      'HD'                                                        MUI00
     C     WHP           ANDEQ     'Y'                                                         MUI00
     C                   MOVE      XXTBRC        F4TBRC                                        MUI00
     C                   ENDIF                                                                 MUI00
      *
      * Starting Date
     C**********         CALL      'GLM053'                                                   LUC109
     C                   CALL      'XX000053'                                                 LUC109
     C                   PARM                    VDAT
     C*                    PARM           F4SDAT
     C                   PARM      *ZERO         W4SDAT            8 0
     C                   MOVE      W4SDAT        F4SDAT
      *
      * Accounting Balance in Original Currency
     C     CCY           IFNE      *BLANKS
     C     RECI          IFEQ      'M'
     C                   Z-ADD     *ZERO         @@AMT
     C                   ELSE
     C                   Z-ADD     CPAM          @@AMT
      *                                                                   MUI002
      * Use the calculated amounts which is the same with that of         MUI002
      *  Face Value of Draft in Original Currency for 'HD'                MUI002
      *  transactions                                                     MUI002
     C     LTYP          IFEQ      'HD'                                                        MUI00
     C     WHP           ANDEQ     'Y'                                                         MUI00
     C                   Z-ADD     PFVAL         @@AMT                                         MUI00
     C                   ENDIF                                                                 MUI00
      *                                                                   MUI002
     C                   ENDIF
     C                   Z-SUB     @@AMT         @@AMT                          reverse sign
     C                   MOVE      'N'           IERROR            1
     C**********         CALL      'GLM041'                                                   LUC109
     C                   CALL      'XX000041'                                                 LUC109
     C                   PARM                    CCY
     C                   PARM                    @@AMT            15 0
     C                   PARM                    F4ACBL
     C                   PARM                    IERROR
      *
     C     IERROR        IFEQ      'Y'                                          Ended in error
     C                   MOVE      *BLANKS       REPPRG
     C                   MOVE      *BLANKS       REPMSG
     C                   MOVE      *BLANKS       REPKEY
     C                   MOVE      *BLANKS       REPDTA
     C                   MOVEL     F2DNUM        REPACN
     C                   MOVEL     '#S204'       REPPRG
     C                   MOVEL     @ERR(3)       REPMSG
     C                   MOVEL     '*NONE'       REPKEY
     C                   MOVE      CCY           REPCCY
     C                   Z-ADD     @@AMT         REPVAL
     C                   MOVEL     REPAMT        REPDTA
     C                   EXSR      #ERR
     C                   MOVE      *BLANKS       F4ACBL
     C                   ELSE
     C                   MOVEL     '-'           F4ACBL
     C                   ENDIF
      *
     C                   ELSE
     C                   MOVE      *BLANKS       F4ACBL
     C                   ENDIF
      *
      * Credit Type
     C                   MOVE      MCRTP         F4CRTP
      *
      * Test Expired
     C********** MDAT      IFLE MMDNB                                     245336
     C     MDAT          IFLE      BJRDNB                                                      24533
     C     MDAT          ANDGT     MPEMB
     C                   MOVE      '0'           F4TSEX
     C                   ELSE
     C                   MOVE      '1'           F4TSEX
     C                   ENDIF
      *
      * BSPL Code 1
     C                   Z-SUB     1             @@BAL            15 0
     C                   MOVE      F2ACCD        XXACCD
     C                   EXSR      #BSPL
     C                   Z-ADD     FBSPL         F4BSP1
      *
      * BSPL Code 2
     C                   Z-ADD     *ZERO         F4BSP2
      *
      * BSPL Code 3
     C                   Z-ADD     *ZERO         F4BSP3
      *
      * Kind of Bills Portfolio
     C                   MOVE      MBILL         F4KOBP
      *
      * Drawee's Customer Number
     C     *IN23         IFEQ      *OFF
     C                   MOVE      MDCTY         F4FIL1
     C                   ELSE
     C                   MOVE      *BLANKS       F4FIL1
     C                   ENDIF
      *                                                                   LUC010
      * Margin (For Discounted items only)                                LUC010
     C                   MOVE      *BLANKS       C9812                                         LUC01
     C     PTYP          IFEQ      63                                                          LUC01
      *                                                                   LUC010
     C     MARG          IFEQ      *ZERO                                                       LUC01
     C                   MOVEL     *ZEROS        C9812                                         LUC01
     C                   ELSE                                                                  LUC01
     C     MARG          IFLT      *ZERO                                                       LUC01
     C                   MOVEL     '-0'          C9812                                         LUC01
     C                   Z-SUB     MARG          WMARG             7 5                         LUC01
     C                   MOVE      WMARG         C9812                                         LUC01
     C                   ELSE                                                                  LUC01
     C                   MOVEL     '+0'          C9812                                         LUC01
     C                   MOVE      MARG          C9812                                         LUC01
     C                   ENDIF                                                                 LUC01
     C                   ENDIF                                                                 LUC01
      *                                                                   LUC010
     C                   ENDIF                                                                 LUC01
      *
     C                   ENDSR
      *****************************************************************
      *                                                               *
      *  #BSPL  -  Determine BSPL Details                             *
      *                                                               *
      *  Called By: #S200                                             *
      *  Calls:                                                       *
      *                                                               *
      *****************************************************************
      *
     C     #BSPL         BEGSR
      *
      *
      * Balance < 0
      *
     C     @@BAL         IFLT      *ZERO
      *
     C                   MOVE      '0'           XXDRCR
     C     @@KEY         CHAIN     SDACRCL9                           22        Account Reports
      *
     C     *IN22         IFEQ      *ON                                          Not Found
      *
     C                   MOVE      ' '           XXDRCR
     C     @@KEY         CHAIN     SDACRCL9                           22        Account Reports
     C*
     C                   ENDIF
      * Account Reporting Details Not Found
     C     *IN22         IFEQ      *ON                                          Not Found
     C                   Z-ADD     *ZERO         FBSPL             4 0
     C                   ELSE
     C                   MOVE      G6RSCD        FBSPL
     C                   ENDIF
      *
     C                   ENDIF
      *
      * Balance > 0
      *
     C     @@BAL         IFGT      *ZERO
      *
     C                   MOVE      '1'           XXDRCR
     C     @@KEY         CHAIN     SDACRCL9                           22        Account Reports
      *
     C     *IN22         IFEQ      *ON                                          Not Found
      *
     C                   MOVE      ' '           XXDRCR
     C     @@KEY         CHAIN     SDACRCL9                           22        Account Reports
     C*
     C                   ENDIF
      * Account Reporting Details Not Found
     C     *IN22         IFEQ      *ON                                          Not Found
     C                   Z-ADD     *ZERO         FBSPL
     C                   ELSE
     C                   MOVE      G6RSCD        FBSPL
     C                   ENDIF
      *
     C                   ENDIF
      *
      * Balance = 0
      *
     C     @@BAL         IFEQ      *ZERO
      *
     C                   MOVE      '0'           XXDRCR
     C     @@KEY         CHAIN     SDACRCL9                           22        Account Reports
      *
     C     *IN22         IFEQ      *ON                                          Not Found
      *
     C                   MOVE      '1'           XXDRCR
     C     @@KEY         CHAIN     SDACRCL9                           22        Account Reports
     C*
     C                   ENDIF
      *
     C     *IN22         IFEQ      *ON                                          Not Found
      *
     C                   MOVE      ' '           XXDRCR
     C     @@KEY         CHAIN     SDACRCL9                           22        Account Reports
     C*
     C                   ENDIF
      * Account Reporting Details Not Found
     C     *IN22         IFEQ      *ON                                          Not Found
     C                   Z-ADD     *ZERO         FBSPL
     C                   ELSE
     C                   MOVE      G6RSCD        FBSPL
     C                   ENDIF
      *
     C                   ENDIF
      *
      *
      * Error Reporting
     C     *IN22         IFEQ      *ON
     C                   MOVE      *BLANKS       REPPRG
     C                   MOVE      *BLANKS       REPMSG
     C                   MOVE      *BLANKS       REPKEY
     C                   MOVE      *BLANKS       REPDTA
     C                   MOVEL     F2DNUM        REPACN
     C                   MOVEL     '#BSPL'       REPPRG
     C                   MOVEL     @ERR(4)       REPMSG
     C                   MOVEL     XXRSNO        REPKEY
     C                   MOVE      XXACCD        REPKEY
     C                   EXSR      #ERR
     C                   ENDIF
      *
     C                   ENDSR
      *****************************************************************
      *                                                               *
      *  #ACKEY -  Determine Account Codes                            *
      *                                                               *
      *  Called By: #203 #204                                         *
      *  Calls:                                                       *
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
     C     PRF3          IFEQ      3
     C                   Z-ADD     ACD3          @@ACC1
     C                   ENDIF
      *
     C     PRF2          IFEQ      3
     C                   Z-ADD     ACD2          @@ACC1
     C                   ENDIF
      *
     C     PRF1          IFEQ      3
     C                   Z-ADD     ACD1          @@ACC1
     C                   ENDIF
      *
      *
     C     PRF6          IFEQ      3
     C                   Z-ADD     ACD6          @@ACC2
     C                   ENDIF
      *
     C     PRF5          IFEQ      3
     C                   Z-ADD     ACD5          @@ACC2
     C                   ENDIF
      *
     C     PRF4          IFEQ      3
     C                   Z-ADD     ACD4          @@ACC2
     C                   ENDIF
      *
      * Error Reporting
     C                   ELSE
     C                   MOVE      *BLANKS       REPPRG
     C                   MOVE      *BLANKS       REPMSG
     C                   MOVE      *BLANKS       REPKEY
     C                   MOVE      *BLANKS       REPDTA
     C                   MOVEL     F2DNUM        REPACN
     C                   MOVEL     '#ACKEY'      REPPRG
     C                   MOVEL     @ERR(5)       REPMSG
     C                   MOVEL     @@ACK         REPKEY
     C                   EXSR      #ERR
      *
     C                   ENDIF
      *
     C                   ENDSR
      *****************************************************************   MUI002
      *                                                               *   MUI002
      *  CHKHP  -  Get details of corresponding 'HP' transactions     *   MUI002
      *                                                               *   MUI002
      *  Called By: #S200                                             *   MUI002
      *  Calls:                                                       *   MUI002
      *                                                               *   MUI002
      *****************************************************************   MUI002
      *                                                                   MUI002
     C     CHKHP         BEGSR                                                                 MUI00
      *                                                                   MUI002
      * Initialize field if 'HD' has a corresponding 'HP'                 MUI002
      *                                                                   MUI002
     C                   MOVE      'N'           WHP               1                           MUI00
     C                   MOVE      '0'           XXTBRC            1                           MUI00
      *                                                                   MUI002
      * Access corresponding 'HP' transaction to get the                  MUI002
      *  Account number (C9151)                                           MUI002
     C     LNRF          CHAIN     CLOANCV3                           25                       MUI00
     C     *IN25         IFEQ      *OFF                                                        MUI00
     C                   MOVE      'Y'           WHP                                           MUI00
      *                                                                   MUI002
      * Check in what file the record was found (CLOANCL0 or MCLONCL0)    MUI002
     C     *IN01         IFEQ      *ON                                                         MUI00
      *                                                                   MUI002
      *   Record was found in CLOANCL0                                    MUI002
     C                   Z-ADD     RRCNUM        PCUST             6 0                         EF001
     C                   Z-ADD     RRVDAT        PVDAT             5 0                         MUI00
     C                   MOVE      RRBRCA        PBRCH             3                           MUI00
     C                   MOVE      RRCCY         PCCY              3                           MUI00
     C                   Z-ADD     RRLASQ        PLASQ             2 0                         MUI00
     C                   MOVE      RRLTYP        XXLTYP            2                           MUI00
     C                   MOVE      RRSUTP        XXSUTP            2                           MUI00
      *                                                                   MUI002
      * For the Face value of the draft in original currency              MUI002
     C                   Z-ADD     RRCPAM        PFVAL            15 0                         MUI00
      *                                                                   MUI002
      * Loan could be matured already.                                    MUI002
     C     RRCPAM        IFEQ      0                                                           MUI00
     C     OLNO          CHAIN     MLOAN                              25                       MUI00
     C                   Z-ADD     QQOPAM        PFVAL                                         MUI00
     C                   ENDIF                                                                 MUI00
      *                                                                   EF0018
      *   Record was found in MCLONCL0                                    EF0018
     C                   ELSE                                                                  EF001
     C                   Z-ADD     PPCNUM        PCUST                                         EF001
     C                   Z-ADD     PPVDAT        PVDAT                                         EF001
     C                   MOVE      PPBRCA        PBRCH                                         EF001
     C                   MOVE      PPCCY         PCCY                                          EF001
     C                   Z-ADD     PPLASQ        PLASQ                                         EF001
     C                   MOVE      PPLTYP        XXLTYP                                        MUI00
     C                   MOVE      PPSUTP        XXSUTP                                        MUI00
      *                                                                   EF0018
      * For the Face value of the draft in original currency              EF0018
     C                   Z-ADD     PPCPAM        PFVAL                                         EF001
      *                                                                   EF0018
      * Loan could be matured already.                                    EF0018
     C     PPCPAM        IFEQ      0                                                           EF001
     C     OLNO          CHAIN     MLOAN                              25                       EF001
     C                   Z-ADD     QQOPAM        PFVAL                                         EF001
     C                   ENDIF                                                                 EF001
     C                   ENDIF                                                                 EF001
      *                                                                   EF0018
      * Check if rediscounter is a central bank or not                    EF0018
     C                   MOVE      PCUST         YYCUST            6                           MUI00
     C     YYCUST        CHAIN     SDCUSTY0                           25                       MUI00
     C     *IN25         IFEQ      *OFF                                                        MUI00
     C     MBCAT         IFEQ      '1'                                                         MUI00
     C                   MOVE      MBCAT         XXTBRC                                        MUI00
     C                   ENDIF                                                                 MUI00
     C                   ENDIF                                                                 MUI00
      *                                                                   EF0018
     C                   ENDIF                                                                 MUI00
     C                   ENDSR                                                                 MUI00
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
     C     ERRCNT        IFGT      *ZERO
     C                   WRITE     EOR
     C                   ELSE
     C                   WRITE     NODET
     C                   ENDIF
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
     C**********         MOVEL     'GLM033A'     DBPGM                          Set program idLUC109
     C                   MOVEL     'XX00033A'    DBPGM                          Set program idLUC109
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
     C***/C*PY*ZSRSRC,ZDATE2Z2                                                                LUC109
     C/COPY ZSRSRC,ZDATE2Z2LE                                                                 LUC109
      ***
**  CPY@
(c) Finastra International Limited 2016
**  @ERR
CLOANCY0 RECORD NOT FOUND
FCLTYL8  RECORD NOT FOUND
XX000041 UNABLE TO CONVERT AMOUNT
SDACRCL9 RECORD NOT FOUND
ACKEY RECORD NOT FOUND
**   ZYDY - YEARS IN DAYS CUMULATIVE, FOUR YEAR SPAN
0366073110961461
**   ZMDY - MONTHS IN DAYS CUMULATIVE THROUGH YEAR
000031059090120151181212243273304334365
**   ZMNM - MONTHS SHORT NAMES
JANFEBMARAPRMAYJUNJULAUGSEPOCTNOVDEC
