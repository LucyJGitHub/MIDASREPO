     H DEBUG DATEDIT(*YMD)
      *****************************************************************
/*S*D****RPGBASE*******************************************************                       LUC109
/*STD *  RPGBASEBND                                                   *                       LUC109
/*EXI *  TEXT('Engagement Transaction Extract from Midas')            *                       LUC109
      *****************************************************************
      *                                                               *
      *  Midas - Interface to Head Office Reporting                   *
      *                                                               *
      ***GLM032A*-*Engagement*Transaction*Extract*from*Midas***********                       LUC109
      *  XX00032A - Engagement Transaction Extract from Midas         *                       LUC109
      *                                                               *
  ?   *****************************************************************
  ?   * *** THIS PROGRAM MUST BE COMPILED WITH XXINTFLIB AT THE TOP   *
  ?   * OF LIBL ***                                                   *
  ?   *****************************************************************
      *                                                               *
      *  Function: Engagement Transaction Extract from Midas          *
      *                                                               *
      ***CALLED*BY**GLCM032*-*ENGAGEMENTS*EXTRACT**********************                       LUC109
      *  CALLED BY  XXC000032 - ENGAGEMENTS EXTRACT                   *                       LUC109
      *             Frequency: Automatically in Close of Business     *
      *                                                               *
      ***(C)*COPYRIGHT*MKI*LIMITED*1998********************************                       LUC109
      *  (c) Finastra International Limited 2016                      *                       LUC109
      *                                                               *
      *  Last Amend No. LUC109             Date 20Sep16               *
      *  Prev Amend No. MUI010             Date 10Mar04               *
      *                 159964             Date 22Aug99               *
      *                 MMI043             Date 07Dec98               *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  LUC109 - HO Reporting (Upgrade to FB Midas 2.1)              *
      *  MUI010 - HOR Changes: add field C9802 (Facility Customer).   *
      *  159964 - PGM/GLM032A cannot allocate object LF/SDCUSTL0 due  *
      *           to SCC0406.                                         *
      *         - Seton job switches U7/U8 for error processing       *
      *  MMI043 - Customer Detail Changes Extract                     *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  C R E A T I O N     P A R A M E T E R S                      *
      *                                                               *
      *****************************************************************
      *
      ** Loan Details
     FCLOANV4   IF   E           K DISK    INFSR(*PSSR)
      *
      ** Loan extension details
     FCLOANCY0  IF   E           K DISK    INFSR(*PSSR)
      *
      ** General Ledger ICD
     FSDGELRPP  IF   E           K DISK    INFSR(*PSSR)
      *
      ** Loan Facility Details
     F*FACIL   IF  E           K        DISK         KINFSR *PSSR
     FFCLTYMV0  IF   E           K DISK    INFSR(*PSSR)
      *
      ** Midas Report Codes
     FSDACRCL9  IF   E           K DISK    INFSR(*PSSR)
      *
      ** Account Keys
     FACKEY     IF   E           K DISK    INFSR(*PSSR)
     F                                     IGNORE(ACKEYAKF)
      *
      ** Branch codes
     FSDBRCHL1  IF   E           K DISK    INFSR(*PSSR)
      *
      ** Customer details
     F***SDCUSTL0IF  E           K        DISK         KINFSR *PSSR       159964
     FSDCUSTV0  IF   E           K DISK    INFSR(*PSSR)                         159964
      *
      ** Engagement Transaction Extract work File
     FWKFECRF   O    E             DISK    INFSR(*PSSR)
      *
      ** Engagement Transaction Extract Audit Report
     F***GLM032AU  O    E             PRINTER INFDS(SPOOL)                                    LUC109
     FXX000032AUO    E             PRINTER INFDS(SPOOL)                                       LUC109
     F                                     INFSR(*PSSR)
      *
      *****************************************************************
      *                                                               *
      *  F U N C T I O N   O F   I N D I C A T O R S                  *
      *                                                               *
      *  20       Controls the Loop for CLOAN                         *
      *  21       Used on Customer extension details retreival        *
      *  22       Used on facility Details Retreival (FCLTYMV0)       *
      *  23       Used for Account Key retreival (ACKEYAL)            *
      *  24       Used for Midas report accounts file (SDACRCL9)      *
      ***25*******Used*on*Customer*Details*retreival*(SDCUSTL0)********
      *  25       Used on Customer Details retreival (SDCUSTV0)       *
      *                                                               *
      *  90-99    Used by Standard Subroutines                        *
      *                                                               *
      *  88       Database Error                                      *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  S U B R O U T I N E   I N D E X                              *
      *                                                               *
      *  *INZSR - Initial Processing                                  *
      *  #S200  - Main Processing                                     *
      *  #S210  - Detail Processing                                   *
      *  #S250  - Report any Errors during processing                 *
      *  #S300  - Program termination                                 *
      *  *PSSR  - Abnormal termination                                *
      *                                                               *
      *****************************************************************
      * Compile Time Arrays                                           *
     D CPY@            S             80    DIM(1) CTDATA PERRCD(1)              Copyright
     D ERR@            S             50    DIM(6) CTDATA PERRCD(1)              Error description
      *
      ***File*information*for*printer*file*GLM032AU********************                       LUC109
      ** File information for printer file XX000032AU                                         LUC109
     D SPOOL           DS
     D  WWOFL1               188    189B 0
     D  WWPTL1               367    368B 0
      *
      ** Data structure for data-base error processing
     D DBERR           DS           256    INZ
     D  DBFILE               134    141
     D  DBKEY                142    170
     D  DBPGM                171    180
     D  DBASE                181    183  0
      *
      ** DateStamp
     D DATST           DS
     D  @@YY                   1      2
     D  @@YYT                  3      4  0
     D  @SYDT                  3      8
      *
      ** Data structure for Access via account Keys
     D                 DS
     D  ACCKY                  1     10
     D  LTYP                   1      2
     D  FILL01                 3      3    INZ('R')
     D  SUTP                   4      5
     D  RECIND                 7      7
     D  FILL02                 8     10
      *
      ** Data structure for Account Code
     D                 DS
     D  ACCKEY                 1     18
     D  BRCA                   1      3
     D  CNUM                   4      9  0
     D  CCY                   10     12
     D  UACDX                 13     16  0
     D  LASQ                  17     18  0
      *
      ** Rename duplicate fields
     IFCLTYFMF
     I              BRCA                        FBRCA
     I              ORED                        FORED
      *****************************************************************
      *
     C                   EXSR      #S200                                        Main process
      *
     C                   EXSR      #S300                                        Termination
      *
      *****************************************************************
      *                                                               *
      *  *INZSR - Subroutine to do Program Initialisation.            *
      *                                                               *
      *  Called By: Main Processing                                   *
      *  Calls    : None                                              *
      *                                                               *
      *****************************************************************
      *
     C     *INZSR        BEGSR                                                  Initialisation
      *
      ** Key List for access to Facility Details
     C     FACKL1        KLIST
     C                   KFLD                    CNUM
     C                   KFLD                    FTYP
     C                   KFLD                    FSEQ
      *
      ** Key List for access to Access Key
     C     ACKYL1        KLIST
     C                   KFLD                    LTYP
     C                   KFLD                    SUTP
      *
      ** Key List for access
     C     ACCKY1        KLIST
     C                   KFLD                    G6RSNO
     C                   KFLD                    G6ACCD
     C                   KFLD                    G6DRCR
      *
      ** Key List for access to Midas accounts by report code
     C     SDACK1        KLIST
     C                   KFLD                    G6RSNO
     C                   KFLD                    G6ACCD
     C                   KFLD                    G6DRCR
      *
      ** Initialise Database Error data structure
     C     *DTAARA       DEFINE    LDA           WLDA            256
      *
     C     *LOCK         IN        WLDA
     C                   MOVEL     WLDA          DBERR
     C                   OUT       WLDA
      *
      ** Initial housekeeping
     C                   MOVEA     CPY@          BIS@             80            Copyright
     C                   MOVE      'N'           @@PSSR            1            *PSSR Control
     C                   Z-ADD     *ZERO         ERRCNT            6 0
      *
      ** General Ledger - ICD
     C                   READ      SDGELRPP                               98    Gl ICD
      *
     C     *IN98         IFEQ      *ON                                          Ended in error
     C                   Z-ADD     1             DBASE                          ***************
     C                   MOVEL(P)  'SDGELRPP'    DBFILE                         * DB ERR  001 *
     C                   MOVE(P)   *BLANKS       DBKEY                          ***************
     C                   EXSR      *PSSR
     C                   ENDIF
      *
     C                   ENDSR
      *
      *****************************************************************
      *                                                               *
      *  #S200  -  Main process                                       *
      *                                                               *
      *            Controls the reading of the Customer Lending file  *
      *            Retreives information from the Facility details    *
      *            and the Lending Extension data file.               *
      *                                                               *
      *  Called By: Main line                                         *
      *                                                               *
      *  Calls:     #S210    -   Retreive Corresponding Loan details  *
      *             #S250    -   Error Reporting                      *
      **********    GLM053   -   Return transmission date format      *                       LUC109
      *             XX000053 -   Return transmission date format      *                       LUC109
      **********    GLM041   -   GL Conversion amount utility         *                       LUC109
      *             XX000041 -   GL Conversion amount utility         *                       LUC109
      *                                                               *
      *****************************************************************
      *
     C     #S200         BEGSR
      *
      ** Read all Records from Customer lending
     C     *LOVAL        SETLL     CLOANV4
     C                   READ      CLOANV4                                20
      *
      ** Continue Reading Customer Lending until end-of-file
     C     *IN20         DOWEQ     *OFF
      *
      ** Only process Loans with a Processing Type of 70 or 71
     C     PTYP          IFEQ      70
     C     PTYP          OREQ      71
      *
      ** Only process outstanding Loans or Matured loans within the
      **  Last Month
      *
     C     RECI          IFEQ      'D'
      *
     C     RECI          OREQ      'M'
     C     MDAT          ANDGT     MPEMB
      *
      ** Retreive all coresponding Loan Details Required
     C                   EXSR      #S210
      *
      ** Company Code
     C                   MOVEL     A8CMCD        WKCMCD
      *
      ** Branch Code
     C                   MOVEL(P)  BRCA          WKBRCD
      *
      ** Module Code
     C                   MOVEL(P)  'LE'          WKMDCD
      *
      ** Deal Number
     C                   MOVEL(P)  LNRF          WKDLNO
      *
      ** Account Number
     C                   MOVEL(P)  ACCKEY        WKCACC
      *
      ** Customer Number
     C                   Z-ADD     CNUM          WKCUST
      *
      ** Currency Code
     C                   MOVEL(P)  CCY           WKCCYC
      *
      ** Charges Debited
     C                   Z-SUB     MDCGM         @@AMT
     C**********         CALL      'GLM041'                                                   LUC109
     C                   CALL      'XX000041'                                                 LUC109
     C                   PARM                    CCY
     C*                    PARM           MDCGM
     C                   PARM                    @@AMT
     C                   PARM                    WKCRDB
     C                   PARM                    UERRID            1
      *
      ** Set up data for the error report - If error code returned
     C     UERRID        IFEQ      'Y'                                                      or
      *
     C                   MOVEL(P)  LNRF          REPCNO
     C                   MOVEL(P)  '#S200'       REPPRG
     C                   MOVEL(P)  ERR@(4)       REPMSG
     C                   MOVEL(P)  '*NONE'       REPKEY
     C                   MOVEL     MDCGM         UMDCGM           15
     C     CCY           CAT(P)    UMDCGM:1      REPDTA
      *
     C                   EXSR      #S250
     C                   ENDIF
      *
      ** Commission Debited
     C                   Z-SUB     MDCMM         @@AMT
     C**********         CALL      'GLM041'                                                   LUC109
     C                   CALL      'XX000041'                                                 LUC109
     C                   PARM                    CCY
     C*                    PARM           MDCMM
     C                   PARM                    @@AMT
     C                   PARM                    WKCMDB
     C                   PARM                    UERRID            1
      *
      ** Set up data for the error report - If error code returned
     C     UERRID        IFEQ      'Y'                                                      or
      *
     C                   MOVEL(P)  LNRF          REPCNO
     C                   MOVEL(P)  '#S200'       REPPRG
     C                   MOVEL(P)  ERR@(4)       REPMSG
     C                   MOVEL(P)  '*NONE'       REPKEY
     C                   MOVEL     MDCGM         UMDCGM           15
     C     CCY           CAT(P)    UMDCGM:1      REPDTA
      *
     C                   EXSR      #S250
     C                   ENDIF
      *
      ** Issue Date
     C     VDAT          IFNE      *ZERO
     C**********         CALL      'GLM053'                                                   LUC109
     C                   CALL      'XX000053'                                                 LUC109
     C                   PARM                    VDAT
     C*                    PARM           WKISSD
     C                   PARM      *ZERO         WWKISS            8 0
     C                   MOVE      WWKISS        WKISSD
      *
     C                   ENDIF
      *
      ** Expiry Date
     C     MDAT          IFNE      *ZERO
     C**********         CALL      'GLM053'                                                   LUC109
     C                   CALL      'XX000053'                                                 LUC109
     C                   PARM                    MDAT
     C*                    PARM           WKEXPD
     C                   PARM      *ZERO         WWEXPD            8 0
     C                   MOVE      WWEXPD        WKEXPD
      *
     C                   ENDIF
      *                                                                   MUI010
      ** Facility Customer                                                MUI010
     C                   MOVE      FCUS          WKFCUS                                        MUI01
      *
      ** Facility Type
     C                   MOVEL(P)  FTYP          WKFTYP
      *
      ** Facility Sequence
     C                   MOVEL(P)  FSEQ          WKFSEQ
      *
      ** Credit Line Starting Date
     C*          ORED      IFNE *ZERO
     C     DTAP          IFNE      *ZERO
     C**********         CALL      'GLM053'                                                   LUC109
     C                   CALL      'XX000053'                                                 LUC109
     C                   PARM                    DTAP
     C*                    PARM           WKCSDE
     C                   PARM      *ZERO         WWCSDE            8 0
     C                   MOVE      WWCSDE        WKCSDE
      *
     C                   ENDIF
      *
      ** Credit Line Ending Date
     C     DTEX          IFNE      *ZERO
     C**********         CALL      'GLM053'                                                   LUC109
     C                   CALL      'XX000053'                                                 LUC109
     C                   PARM                    DTEX
     C*                    PARM           WKCEDE
     C                   PARM      *ZERO         WWCEDE            8 0
     C                   MOVE      WWCEDE        WKCEDE
      *
     C                   ENDIF
      *
      ** G/L Code
     C                   Z-ADD     UACDX         WKLGLC
      *
      ** G/L Code - Contra
     C                   Z-ADD     UACDY         WKLGCC
      *
      ** Country Code
     C                   MOVEL     BBCOLC        WKCCCL
      *
      ** Accounting Balance
     C                   Z-SUB     CPAM          @@AMT            15 0
     C**********         CALL      'GLM041'                                                   LUC109
     C                   CALL      'XX000041'                                                 LUC109
     C                   PARM                    CCY
     C*                    PARM           CPAM
     C                   PARM                    @@AMT
     C                   PARM                    WKACCB
     C                   PARM                    UERRID            1
      *
      ** Yearly Commission Percentage
     C                   Z-ADD     *ZEROS        WKYCOP
      *
      ** Type of Liability
     C                   MOVEL     '12'          WKLIBT
      *
      ** Released/Requested to
     C     MGCUS         IFEQ      *BLANKS
     C                   MOVEL     '1'           WKRRQT
     C                   ELSE
     C                   MOVEL     '2'           WKRRQT
     C                   ENDIF
      *
      ** Consortium Transaction
     C     MCONS         IFEQ      ' '
     C                   MOVE      '0'           MCONS
     C                   ENDIF
     C                   MOVEL     MCONS         WKCTRN
      *
      ** Type of underlying Transaction
     C                   MOVEL     MUNTR         WKTUDT
      *
      ** Linkage to Export Transaction
     C                   MOVEL     '0'           WKLETR
      *
      ** Banks Customer Number
     C                   MOVEL(P)  MGCUS         WKPCNB
      *
      ** Beneficiary Country Code
     C                   MOVEL(P)  MBCTY         WKBNCC
      *
      ** Credit Type
     C                   MOVEL     MCRTP         WKCDTP
      *
      ** Maturity Code
     C     MDAT          IFGT      MPDNB
     C     MDAT          ANDLT     MMDNB
      *
     C                   MOVEL     '0'           WKMATC
     C                   ELSE
     C                   MOVEL     '1'           WKMATC
     C                   ENDIF
      *
      ** Consortium Transaction File Leader
     C                   MOVEL     MCSLD         WKCTAN
      *
      ** write work file record
     C                   WRITE     WKFECRD0
      *
      ** Clear Work file area in preparation for next write
     C                   CLEAR                   WKFECRD0
      *
     C                   ENDIF
     C                   ENDIF
      *
      ** Read Next record
     C                   READ      CLOANV4                                20
      *
     C                   ENDDO
      *
     C                   ENDSR
      /EJECT
      *****************************************************************
      *                                                               *
      *  #S210  -      Retreive Corresponding Loan Details required   *
      *                                                               *
      *  Called By:    #S200 -  Main process                          *
      *                                                               *
      *  Calls:        #S250 -  Error Reporting                       *
      *                                                               *
      *****************************************************************
      *
     C     #S210         BEGSR
      *
      ** Access the Loan Extension details file
     C     LNRF          CHAIN     CLOANCY0                           21
      *
      ** If record not found - produce error report
     C     *IN21         IFEQ      *ON
      *
      ** Set up data for the error report
     C                   MOVEL(P)  LNRF          REPCNO
     C                   MOVEL(P)  '#S210'       REPPRG
     C                   MOVEL(P)  ERR@(1)       REPMSG
     C                   MOVEL(P)  LNRF          REPKEY
     C                   MOVEL(P)  *BLANKS       REPDTA
      *
     C                   EXSR      #S250
      *
      ** Clear all data fields
     C                   CLEAR                   MCRTP                          Credit type
     C                   CLEAR                   MCONS                          Cons Trans
     C                   CLEAR                   MCSLD                          Cons Trans FL
     C                   CLEAR                   MGCUS                          Rel/Req to
     C                   CLEAR                   MUNTR                          Undly Trans
     C                   CLEAR                   MBCTY                          Ben Cty Cde
     C                   CLEAR                   MDCGM                          Charges
     C                   CLEAR                   MDCMM                          Commission
      *
     C                   ENDIF
      *
      ** Determine Bank/company code for header
     C     BRCA          CHAIN     SDBRCHL1                           98        Branch
      *
     C     *IN98         IFEQ      *ON                                          Ended in error
     C                   Z-ADD     2             DBASE                          ***************
     C                   MOVEL(P)  'SDBRCHL1'    DBFILE                         * DB ERR  002 *
     C                   MOVEL(P)  BRCA          DBKEY                          ***************
     C                   EXSR      *PSSR
     C                   ENDIF
      *
      ** Access Facility Details record
     C     FACKL1        CHAIN     FCLTYMV0                           22
      *
     C     *IN22         IFEQ      *ON                                          Ended in error
      *
      ** Clear expiry and entry date
     C                   Z-ADD     *ZEROS        DTEX
     C*                    Z-ADD*ZEROS    ORED
     C                   Z-ADD     *ZEROS        DTAP
      *
      ** Convert key fields for DataBase error key
     C                   MOVEL     CNUM          UCNUM             6
     C                   MOVEL     FTYP          UFTYP             3
     C                   MOVEL     FSEQ          UFSEQ             2
      *
     C     UCNUM         CAT(P)    UFTYP:1       REPKEY                                     ***
     C                   CAT(P)    UFSEQ:1       REPKEY
      *
      ** Set up data for the error report
     C                   MOVEL(P)  LNRF          REPCNO
     C                   MOVEL(P)  '#S210'       REPPRG
     C                   MOVEL(P)  ERR@(2)       REPMSG
     C                   MOVEL(P)  *BLANKS       REPDTA
      *
     C                   EXSR      #S250
     C                   ENDIF
      *
      ** Set up Account Key for file Access
     C     RCSI          IFEQ      'Y'
     C                   MOVEL     'R'           RECIND
     C                   ELSE
     C                   MOVE      *BLANKS       RECIND
     C                   ENDIF
      *
      ** Access Account Keys
     C                   MOVE      'R A'         FILL02
     C     ACCKY         CHAIN     ACKEY                              23
      *
     C     *IN23         IFEQ      *OFF
     C     ACD1          ANDEQ     *ZEROS
     C     ACD2          ANDEQ     *ZEROS
     C     ACD3          ANDEQ     *ZEROS
     C     ACD4          ANDEQ     *ZEROS
     C     ACD5          ANDEQ     *ZEROS
     C     ACD6          ANDEQ     *ZEROS
     C                   MOVE      '  A'         FILL02
     C     ACCKY         CHAIN     ACKEY                              23
     C                   ENDIF
      *
     C     *IN23         IFEQ      *ON
     C                   MOVE      '  A'         FILL02
     C     ACCKY         CHAIN     ACKEY                              23
     C                   ENDIF
      *
     C     *IN23         IFEQ      *ON                                          Ended in error
      *
      ** Report failure to extract Account key and continue
     C                   MOVEL(P)  LNRF          REPCNO
     C                   MOVEL(P)  '#S210'       REPPRG
     C                   MOVEL(P)  ERR@(3)       REPMSG
     C                   MOVEL(P)  ACCKY         REPKEY
     C                   MOVEL(P)  *BLANKS       REPDTA
      *
     C                   EXSR      #S250
      *
      ** write Report Headings and initialise work fields
     C                   Z-ADD     *ZERO         UACDX
     C                   Z-ADD     *ZERO         UACDY
     C                   MOVEL(P)  *BLANKS       WKBSPA
     C                   MOVEL(P)  *BLANKS       WKBSPB
      *
     C                   ELSE
      *
      ** Initialise work fields
     C                   Z-ADD     *ZERO         UACDX
     C                   Z-ADD     *ZERO         UACDY
     C                   MOVEL(P)  *BLANKS       WKBSPA
     C                   MOVEL(P)  *BLANKS       WKBSPB
      *
      ** Determine which posting referenec to use for contingent
     C     PRF1          IFEQ      3
     C                   Z-ADD     ACD1          UACDY
     C                   ELSE
      *
     C     PRF2          IFEQ      3
     C                   Z-ADD     ACD2          UACDY
     C                   ELSE
      *
     C     PRF3          IFEQ      3
     C                   Z-ADD     ACD3          UACDY             4 0
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
      *
      ** Determine which posting referenec to use for contingent - Contra
     C     PRF4          IFEQ      3
     C                   Z-ADD     ACD4          UACDX
     C                   ELSE
      *
     C     PRF5          IFEQ      3
     C                   Z-ADD     ACD5          UACDX
     C                   ELSE
      *
     C     PRF6          IFEQ      3
     C                   Z-ADD     ACD6          UACDX
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
      *
      ** Access Midas Report Acounts File
     C                   MOVEL     '9'           G6RSNO
     C                   MOVEL     UACDX         G6ACCD
     C                   MOVEL     '0'           G6DRCR
      *
     C     ACCKY1        CHAIN     SDACRCL9                           24
      *
      ** If no record found - Find using Blank Cr/Dr code
     C     *IN24         IFEQ      *ON
      *
     C                   MOVEL     *BLANKS       G6DRCR
      *
     C     ACCKY1        CHAIN     SDACRCL9                           24
      *
      ** If no record found - report on error report
     C     *IN24         IFEQ      *ON
      *
      ** Clear BSPL Contingent
     C                   MOVEL     *BLANKS       WKBSPA
      *
      ** Report failure for Midas report codes
     C                   MOVEL(P)  LNRF          REPCNO
     C                   MOVEL(P)  '#S210'       REPPRG
     C                   MOVEL(P)  ERR@(5)       REPMSG
      *
     C     G6RSNO        CAT(P)    G6ACCD:1      REPKEY
     C                   CAT(P)    G6DRCR:1      REPKEY
     C                   MOVEL(P)  *BLANKS       REPDTA
      *
     C                   EXSR      #S250
     C                   ELSE
      *
      ** BSPL Code Contingent
     C                   MOVEL     G6RSCD        WKBSPA
     C                   ENDIF
     C                   ELSE
      *
      ** BSPL Code Contingent
     C                   MOVEL     G6RSCD        WKBSPA
     C                   ENDIF
      *
      ** Access Midas Report Acounts File
     C                   MOVEL     '9'           G6RSNO
     C                   MOVEL     UACDY         G6ACCD
     C                   MOVEL     '0'           G6DRCR
      *
     C     ACCKY1        CHAIN     SDACRCL9                           24
      *
      ** If no record found - Find using Blank Dr/Cr code
     C     *IN24         IFEQ      *ON
      *
     C                   MOVEL     *BLANKS       G6DRCR
      *
     C     ACCKY1        CHAIN     SDACRCL9                           24
      *
      ** If no record found - report on error report
     C     *IN24         IFEQ      *ON
      *
      ** Clear BSPL Contingent
     C                   MOVEL     *BLANKS       WKBSPA
      *
      ** Report failure for Midas report codes
     C                   MOVEL(P)  LNRF          REPCNO
     C                   MOVEL(P)  '#S210'       REPPRG
     C                   MOVEL(P)  ERR@(5)       REPMSG
      *
     C     G6RSNO        CAT(P)    G6ACCD:1      REPKEY
     C                   CAT(P)    G6DRCR:1      REPKEY
     C                   MOVEL(P)  *BLANKS       REPDTA
      *
     C                   EXSR      #S250
     C                   ELSE
      *
      ** BSPL Code Contingent - Contra
     C                   MOVEL     G6RSCD        WKBSPB
     C                   ENDIF
     C                   ELSE
      *
      ** BSPL Code Contingent - Contra
     C                   MOVEL     G6RSCD        WKBSPB
     C                   ENDIF
     C                   ENDIF
      *
      ** Retreive customer Details
     C***********MCSLD     CHAINSDCUSTL0             25                   159964
     C     MCSLD         CHAIN     SDCUSTV0                           25                       15996
      *
      ** If record not found - produce error report
     C     *IN25         IFEQ      *ON
      *
      ** Report failure for Consortium Team Leader
     C                   MOVEL(P)  LNRF          REPCNO
     C                   MOVEL(P)  '#S210'       REPPRG
     C                   MOVEL(P)  ERR@(6)       REPMSG
     C                   MOVEL(P)  MCSLD         REPKEY
     C                   MOVEL(P)  *BLANKS       REPDTA
      *
     C                   EXSR      #S250
      *
      ** Clear country code of Location
     C                   CLEAR                   BBCOLC
      *
     C                   ENDIF
      *
     C                   ENDSR
      /EJECT
      *****************************************************************
      *                                                               *
      *    #S250     - Extract Record Error Processing                *
      *                                                               *
      *    This section will write a record to an error report that   *
      *    details all file error's encountered during the run        *
      *                                                               *
      *    This replaces the normal Midas error routine for Database  *
      *    errors.                                                    *
      *                                                               *
      *    Called By -     #S210                                      *
      *    Calls     -     None                                       *
      *                                                               *
      *****************************************************************
      *
     C     #S250         BEGSR
      *
      ** Determine if a new page has to be written
      **   WWOFL1 - Overflow line number, WWPTL1 - Current line number
     C     WWOFL1        SUB       WWPTL1        WWLINE            2 0
      *
      ** write new error header if required
     C     WWLINE        IFLT      5
     C                   WRITE     ERRHDR
     C                   ENDIF
      *
      ** Accumulate the error count and write the detail record
     C                   ADD       1             ERRCNT
     C                   WRITE     ERRDET                                       Report error
      *
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  Subroutine  :  #S300                                         *
      *                                                               *
      *  Function    :  Program termination                           *
      *                                                               *
      *                 Controls the program termination and produces *
      *                 an audit report if any errors are found       *
      *                                                               *
      *  Called by   :  Main Line                                     *
      *                 *PSSR - If an error has been detected         *
      *                                                               *
      *  Calls       :  None                                          *
      *                                                               *
      *****************************************************************
      *
     C     #S300         BEGSR
      *
      ** Check switches to determine if Database error detected
     C     *IN88         IFEQ      *ON                                          Database error
      *
      ** Print audit report & stop run
     C                   WRITE     HEADAU                                       Report header
     C                   WRITE     DBERROR                                      Report error
      *
     C                   ELSE
      *
      **  If errors have been produced - set set of report
     C     ERRCNT        IFGT      *ZERO
     C                   WRITE     EOR
     C                   ENDIF
      *
     C                   ENDIF
      *
      ** Exit the program
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
     C     @@PSSR        IFEQ      'N'                                          Recursive call
      *
     C                   MOVE      'Y'           @@PSSR                         *PSSR Executed
      *
      ** Update local data area
     C     DBPGM         IFEQ      *BLANKS
     C**********         MOVEL(P)  'GLM032A'     DBPGM                          Set program idLUC109
     C                   MOVEL(P)  'XX00032A'    DBPGM                          Set program idLUC109
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
     C                   EXSR      #S300                                        Stop run
      *
     C                   ENDIF
      *
     C                   ENDSR
      /EJECT
      *****************************************************************
      ***
**  CPY@
(c) Finastra International Limited 2016
**  ERR@
Loan extension details not found
Facility Details not found
Account Keys not found
Error detected in amount conversion program XX000041
Midas Report Codes not found
Customer Details for Consortium File Leader N/F
