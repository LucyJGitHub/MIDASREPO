     H DEBUG DATEDIT(*YMD)
      *****************************************************************
/*S*D****RPGBASE*******************************************************                       LUC109
/*STD *  RPGBASEBND                                                   *                       LUC109
/*EXI *  TEXT('Initial Setup of ACCNTBX0 File')                       *                       LUC109
      *****************************************************************
      *                                                               *
      *  Midas - Interface to Head Office Reporting                   *
      *                                                               *
      ***UTIL05**-*Initial*Setup*of*ACCNTBX0*File**********************                       LUC109
      *  XXUT0005 - Initial Setup of ACCNTBX0 File                    *                       LUC109
  ?   *****************************************************************
  ?   * *** THIS PROGRAM MUST BE COMPILED WITH XXINTFLIB AT THE BOTTOM*
  ?   * OF LIBL ***                                                   *
  ?   *****************************************************************
      *                                                               *
      *                                                               *
      *  CALLED BY  XXXXXXXX- XXXXXXXXXXXXXXXXXXXXXXXX                *
      *             Frequency: Automatically in Close of Business     *
      *                                                               *
      ***(C)*COPYRIGHT*MKI*LIMITED*1998********************************                       LUC109
      *  (c) Finastra International Limited 2016                      *                       LUC109
      *                                                               *
      *  Last Amend No. LUC109             Date 22Sep16               *
      *  Prev Amend No. LUC013             Date 21May08               *
      *                 MUI009             Date 16Feb04               *
      *                 MMI043 *Create     Date 16Dec98               *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  LUC109 - HO Reporting (Upgrade to FB Midas 2.1)              *
      *  LUC013 - Change ACOD to 10 long.                             *
      *  MUI009 - R4.1 Upgrade:                                       *
      *           Added ZDATE9 which is now required by ZCBDYS        *
      *           Added ZDATE10 which is now required by ZCBDYS       *
      *  MMI043 - Head Office Reporting                               *
      *                                                               *
      *****************************************************************
      *
     FSDGELRPP  IF   E             DISK    INFSR(*PSSR)
     FSDBANKPD  IF   E             DISK    INFSR(*PSSR)
     FACCNTBV1  IF   E           K DISK    INFSR(*PSSR)
     FIACBR     IF   E           K DISK    INFSR(*PSSR)
     FEODPOPL   IF   E           K DISK    INFSR(*PSSR)
     FACCNTBY2  UF A E           K DISK    INFSR(*PSSR)
     F***UTIL05AU  O    E             PRINTER INFDS(SPOOL)                                    LUC109
     FXXUT0005AUO    E             PRINTER INFDS(SPOOL)                                       LUC109
      *
      *****************************************************************
      *                                                               *
      *  F U N C T I O N   O F   I N D I C A T O R S                  *
      *                                                               *
      *   20 - PF/ACCNTBV1   File I/O                                 *
      *   88 - General chain indicator                                *
      *                                                               *
      *                                                               *
      *  U7+U8    Database Error                                      *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  S U B R O U T I N E   I N D E X                              *
      *                                                               *
      *  #INIT  - Initial Processing                                  *
      *  #READ  - Read ACCNTBV1 File                                  *
      *  #PROC  - Process ACCNTBV1 Record                            *
      *  #CRTCX - Create ACCNTBX0 Record                              *
      *  #TERM  - Program termination                                 *
      *  *PSSR  - Abnormal termination                                *
      *                                                               *
      *****************************************************************
      * COMPILE TIME ARRAYS                                           *
     D CPY@            S             80    DIM(1) CTDATA PERRCD(1)              Copyright
      *
     D SPOOL           DS
     D  WWOFL1               188    189B 0
     D  WWPTL1               367    368B 0
      *
      ** Data structure for data-base error processing
      *
     D DBERR           DS           256
     D  DBFILE               134    141
     D  DBKEY                142    170
     D  DBPGM                171    180
     D  DBASE                181    183  0
      *
      ***/C*PY*ZSRSRC,ZDATE2Z1                                                                LUC109
     D/COPY ZSRSRC,ZDATE2Z1LE                                                                 LUC109
      ***/C*PY*ZSRSRC,ZDAYSZ1                                                                 LUC109
     D/COPY ZSRSRC,ZDAYSZ1LE                                                                  LUC109
     D***/C*PY*ZSRSRC,ZDATE9Z1                                                         MUI009 LUC109
     D/COPY ZSRSRC,ZDATE9Z1LE                                                                 LUC109
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
      *                                                                                       LUC109
     D/COPY ZSRSRC,ZDATE9Z2LE                                                                 LUC109
     D/COPY ZSRSRC,ZDAT10Z1LE                                                                 LUC109
     I/EJECT                                                                             LUC013
     IREIACDF                                                                                  LUC01
      *                                                                                  LUC013
      ** Rename REIACDF Format fields - IACBR file                                       LUC013
      *                                                                                  LUC013
     I              ACOD                        XXACOD                                         LUC01
     I              CNUM                        XXCNUM                                        LUC109
     I***/C*PY*ZSRSRC,ZCBDYSZ2                                                         MUI009 LUC109
     I***/C*PY*ZSRSRC,ZDATE9Z2                                                         MUI009 LUC109
     I***/C*PY*ZSRSRC,ZDAT10Z1                                                         MUI009 LUC109
      *
      *****************************************************************
      *
     C                   EXSR      #INIT                                        Housekeeping
      *
     C                   EXSR      #READ                                        Main process
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
      * Careful cause this indicator is used in date routines
      *
     C     BJDFIN        IFEQ      'D'
     C                   MOVE      *OFF          *IN98
     C                   ELSE
     C                   MOVE      *ON           *IN98
     C                   END
      *
      ** Data definition
      *
     C     *DTAARA       DEFINE    LDA           WLDA            256
     C     *LIKE         DEFINE    MDCPV         WCHGS
     C     *LIKE         DEFINE    MDCPV         WCOMM
     C     *LIKE         DEFINE    MDCPV         WAMT
     C     *LIKE         DEFINE    MDCPV         WAMT1
     C     *LIKE         DEFINE    MDCPV         WAMT2
     C     *LIKE         DEFINE    MDCPV         WCHQNO
     C     *LIKE         DEFINE    MDCPV         WCHQSM
     C     *LIKE         DEFINE    MDCPV         WCRNO
     C     *LIKE         DEFINE    MDCPV         WCRPST
     C     *LIKE         DEFINE    MDCPV         WDRNO
     C     *LIKE         DEFINE    MDCPV         WDRPST
     C     *LIKE         DEFINE    MDCPV         WREVNO
     C     *LIKE         DEFINE    MDCPV         WUNPD
      *
      ** Key List Definitions
      *
     C     KYACCT        KLIST
     C**********         KFLD                    KYCNUM            6 0                        LUC109
     C                   KFLD                    KYCNUM            6                          LUC109
     C                   KFLD                    KYCCY             3
     C****                 KFLD           KYACOD  40                                     LUC013
     C                   KFLD                    KYACOD           10 0
     C                   KFLD                    KYACSQ            2 0
     C                   KFLD                    KYBRCA            3
      *
     C     IAACCT        KLIST
     C                   KFLD                    IABRCA            3
     C**********         KFLD                    IACNUM            6 0                        LUC109
     C                   KFLD                    IACNUM            6                          LUC109
     C                   KFLD                    IACCY             3
     C****                 KFLD           IAACOD  40                                     LUC013
     C                   KFLD                    IAACOD           10 0
     C                   KFLD                    IAACSQ            2 0
      *
     C     EOACCT        KLIST
     C                   KFLD                    EOBRCA            3
     C                   KFLD                    EOCNUM            6 0
     C                   KFLD                    EOCCY             3
     C                   KFLD                    EOACOD            4 0
     C                   KFLD                    EOACSQ            2 0
      *
      ** Initial housekeeping
      *
     C                   MOVEA     CPY@          BIS@             80            Copyright
     C                   MOVE      'N'           @@PSSR            1            *PSSR Control
     C                   MOVE      *OFF          *IN88
      *
     C                   READ      SDBANKPD                               88
      *
     C     *IN88         IFEQ      *ON                                          Ended in error
     C                   MOVEL     '001'         DBASE                          ***************
     C                   MOVEL     'SDBANKPD'    DBFILE                         * DB ERR  001 *
     C                   MOVE      *BLANKS       DBKEY                          ***************
     C                   EXSR      *PSSR
     C                   ENDIF
      *
     C                   READ      SDGELRPP                               88
      *
     C     *IN88         IFEQ      *ON                                          Ended in error
     C                   MOVEL     '002'         DBASE                          ***************
     C                   MOVEL     'SDGELRPP'    DBFILE                         * DB ERR  002 *
     C                   MOVE      *BLANKS       DBKEY                          ***************
     C                   EXSR      *PSSR
     C                   ENDIF
      *
     C                   ENDSR
      *
      *****************************************************************
      *                                                               *
      *  #READ  -  Read File                                          *
      *                                                               *
      *  Called By: Main line                                         *
      *  Calls: S200                                                  *
      *                                                               *
      *****************************************************************
      *
     C     #READ         BEGSR
      *
      * Read ACCNTBV1 File
      *
     C                   READ      ACCNTBV1                               20
      *
      *
     C     *IN20         DOWEQ     *OFF                                         Until eof
      *
     C                   EXSR      #PROC
      *
     C                   READ      ACCNTBV1                               20
      *
     C                   ENDDO
      *
      *
     C                   ENDSR
      *****************************************************************
      *                                                               *
      *  #PROC  -  Process ACCNTBV1 Record                            *
      *                                                               *
      *  Called By: #READ                                             *
      *  Calls:     #BSPL                                             *
      *                                                               *
      *****************************************************************
      *
     C     #PROC         BEGSR
      *
      * Read ACCNTBX0 File - if record not found, create it.
      *
     C                   MOVE      CNUM          KYCNUM
     C                   MOVE      CCY           KYCCY
     C****                 MOVE ACOD      KYACOD                                         LUC013
     C                   MOVEL     ACOD          KYACOD
     C                   MOVE      ACSQ          KYACSQ
     C                   MOVE      BRCA          KYBRCA
     C     KYACCT        CHAIN     ACCNTBY2                           20
     C   20              EXSR      #CRTBX
     C   20KYACCT        CHAIN     ACCNTBY2                           20
      *
      * Increment MTD Working Days by 1.
      *
     C                   Z-ADD     0             MMTDY
      *
      * DR Interest Rate MTD
      *
     C                   Z-ADD     *ZERO         MDAVX
      *
      * DR Interest Rate Mthly Average
      *
     C                   Z-ADD     0             MDAVR
      *
      * CR Interest Rate MTD
      *
     C                   Z-ADD     *ZERO         MCAVX
      *
      * CR Interest Rate Mthly Average
      *
     C                   Z-ADD     0             MCAVR
      *
      * DR/CR Accounting Balance MTD
      *
     C                   Z-ADD     *ZERO         MDALX
     C                   Z-ADD     *ZERO         MCALX
      *
      * DR/CR Accounting Balance Mthly Average
      *
     C                   Z-ADD     0             MDALB
     C                   Z-ADD     0             MCALB
      *
      * DR/CR Available Balance MTD
      *
     C                   Z-ADD     *ZERO         MDACX
     C                   Z-ADD     *ZERO         MCACX
      *
      * DR/CR Available Balance Mthly Average
      *
     C                   Z-ADD     0             MDACB
     C                   Z-ADD     0             MCACB
      *
      * DR/CR Interest Movements at end of last quarter
      *
     C     DIIE          ADD       DAIC          MQDIX
     C     CIIE          ADD       CAIC          MQCIX
      *
      * DR/CR Interest Movements this quarter
      *
     C                   Z-ADD     0             MQDIM
     C                   Z-ADD     0             MQCIM
      *
      * Quarterly Maximum DR Accounting Balance
      *
     C                   Z-ADD     0             MQXAB
      *
      * Quarterly Minimum DR Available Balance
      *
     C                   Z-ADD     0             MPQMA
      *
      * Quarterly Maximum DR Available Balance
      *
     C                   Z-ADD     0             MQXAV
      *
      * Get Charges and Commission for this Account.
      *
     C                   EXSR      #CHCM
      *
      * Charges/Commission DR at end of previous month.
      *
      * ... note that fields stored as -ve
     C                   SUB       WCHGS         MDGPV
     C                   SUB       WCOMM         MDCPV
      *
      * Charges/Commission DR this month
      *
     C                   Z-ADD     0             MDCGM
     C                   Z-ADD     0             MDCMM
      *
      * Read Postings File for this account.
      *
     C                   EXSR      #EOD
      *
      * Number of Cheques DR this Quarter
      *
     C                   Z-ADD     WCHQNO        MNOCX
     C                   Z-ADD     0             MNOCQ
      *
      * Amount of Cheques DR this Quarter
      *
      * ... note that fields are stored as -ve
     C                   Z-SUB     WCHQSM        MAMCX
     C                   Z-ADD     0             MAMCQ
      *
      * Amount of Unpaid Chqs and Drafts
      *
     C                   Z-ADD     0             MUNPD
      *
      * Number of Reverses
      *
     C                   Z-ADD     0             MRVNO
      *
      * Amount of DR Postings this Quarter
      *
      * ... note that fields are stored as -ve
     C                   Z-SUB     WDRPST        MDRPX
     C                   Z-ADD     0             MDRPO
      *
      * Amount of CR Postings this Quarter
      *
      * ... note that fields are stored as -ve
     C                   Z-SUB     WCRPST        MCRPX
     C                   Z-ADD     0             MCRPO
      *
      * Number of DR Postings this Quarter
      *
     C                   Z-ADD     WDRNO         MNDPX
     C                   Z-ADD     0             MNDPO
      *
      * Number of CR Postings this Quarter
      *
     C                   Z-ADD     WCRNO         MNCPX
     C                   Z-ADD     0             MNCPO
      *
      * Update Record on ACCNTBX0
      *
     C                   UPDATE    ACCNBFX0
      *
     C                   ENDSR
      *****************************************************************
      *                                                               *
      *  #CRTBX -  Create ACCNTBX0 Record                             *
      *                                                               *
      *  Called By: #PROC                                             *
      *  Calls:                                                       *
      *                                                               *
      *****************************************************************
      *
     C     #CRTBX        BEGSR
      *
     C                   CLEAR                   ACCNBFX0
     C                   MOVE      CNUM          MCNUM
     C                   MOVE      CCY           MCCY
     C****                 MOVE ACOD      MACOD                                          LUC013
     C                   MOVEL     ACOD          MACOD
     C                   MOVE      ACSQ          MACSQ
     C                   MOVE      BRCA          MBRCA
      *
     C                   WRITE     ACCNBFX0
      *
     C                   ENDSR
      *****************************************************************
      *                                                               *
      *  #CHCM  -  Calculate Charges and Commission for this account. *
      *                                                               *
      *  Called By: #PROC                                             *
      *  Calls:                                                       *
      *                                                               *
      *****************************************************************
      *
     C     #CHCM         BEGSR
      *
     C                   Z-ADD     0             WCOMM
     C                   Z-ADD     0             WCHGS
     C                   MOVE      BRCA          IABRCA
     C                   MOVE      CNUM          IACNUM
     C                   MOVE      CCY           IACCY
     C****                 MOVE ACOD      IAACOD                                         LUC013
     C                   MOVEL     ACOD          IAACOD
     C                   MOVE      ACSQ          IAACSQ
      *
     C     IAACCT        SETLL     IACBR
     C     IAACCT        READE     IACBR                                  90
      *
     C     *IN90         DOWEQ     *OFF
      *
     C                   ADD       TCHO          WCHGS
     C                   ADD       RCA           WCOMM
     C                   ADD       NRCA          WCOMM
      *
     C     IAACCT        READE     IACBR                                  90
      *
     C                   ENDDO
      *
     C                   ENDSR
      *****************************************************************
      *                                                               *
      *  #EOD   -  Read EODPOPD File and accumulate fields            *
      *                                                               *
      *  Called By: #PROC                                             *
      *  Calls:                                                       *
      *                                                               *
      *****************************************************************
      *
     C     #EOD          BEGSR
      *
     C                   Z-ADD     0             WCHQNO
     C                   Z-ADD     0             WCHQSM
     C                   Z-ADD     0             WUNPD
     C                   Z-ADD     0             WREVNO
     C                   Z-ADD     0             WDRPST
     C                   Z-ADD     0             WCRPST
     C                   Z-ADD     0             WDRNO
     C                   Z-ADD     0             WCRNO
      *
     C                   MOVE      BRCA          EOBRCA
     C                   MOVE      CNUM          EOCNUM
     C                   MOVE      CCY           EOCCY
     C****                 MOVE ACOD      EOACOD                                         LUC013
     C                   MOVEL     ACOD          EOACOD
     C                   MOVE      ACSQ          EOACSQ
      *
     C     EOACCT        SETLL     EODPOPL
     C     EOACCT        READE     EODPOPL                                90
      *
     C     *IN90         DOWEQ     *OFF
      * ... Cheques.
     C     TRAT          IFEQ      99515
     C     DRCR          ANDEQ     0
     C                   ADD       1             WCHQNO
     C                   ADD       PSTA          WCHQSM
     C                   ENDIF
      * ... Unpaid Cheques and Drafts
     C     TRAT          IFEQ      00010
     C     DRCR          ANDEQ     0
     C                   ADD       PSTA          WUNPD
     C                   ENDIF
      * ... Reverses.
     C     TRAT          IFEQ      00020
     C     DRCR          ANDEQ     0
     C                   ADD       1             WREVNO
     C                   ENDIF
      * ... Postings.
     C     DRCR          IFEQ      0
     C                   ADD       1             WDRNO
     C                   ADD       PSTA          WDRPST
     C                   ELSE
     C                   ADD       1             WCRNO
     C                   ADD       PSTA          WCRPST
     C                   ENDIF
      *
     C     EOACCT        READE     EODPOPL                                90
      *
     C                   ENDDO
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
     C     *INU7         IFEQ      *ON                                          Database error
      *
      ** Print audit report & stop run
      *
     C                   WRITE     HEADAU                                       Report header
      *
     C                   WRITE     DBERROR                                      Report error
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
     C                   MOVEL     'UTIL05'      DBPGM                          Set program id
     C                   ENDIF
      *
     C     *LOCK         IN        WLDA
     C                   MOVEL     DBERR         WLDA
     C                   OUT       WLDA
      *
     C                   MOVE      *ON           *INU7                          Database error
     C                   MOVE      *ON           *INU8                          Database error
     C                   DUMP                                                   Dump system var
      *
     C                   EXSR      #TERM                                        Stop run
      *
     C                   ENDIF
      *
     C                   ENDSR
      /EJECT
      *****************************************************************
      ***/C*PY*ZSRSRC,ZCBDYSZ1                                                                LUC109
     C/COPY ZSRSRC,XCBDYSZ1LE                                                                 LUC109
      ***/C*PY*ZSRSRC,ZDATE2Z2                                                                LUC109
     C/COPY ZSRSRC,ZDATE2Z2LE                                                                 LUC109
      ***/C*PY*ZSRSRC,ZDLINTZ1                                                                LUC109
     C/COPY ZSRSRC,ZDLINTZ1LE                                                                 LUC109
     C***/C*PY*ZSRSRC,ZDATE9Z3                                                         MUI009 LUC109
     C***/C*PY*ZSRSRC,ZDAT10Z2                                                                LUC109
     C/COPY ZSRSRC,ZDAT10Z2LE                                                          MUI009 LUC109
      ***
**  CPY@
(c) Finastra International Limited 2016
**   ZYDY - YEARS IN DAYS CUMULATIVE, FOUR YEAR SPAN
0366073110961461
**   ZMDY - MONTHS IN DAYS CUMULATIVE THROUGH YEAR
000031059090120151181212243273304334365
**   ZMNM - MONTHS SHORT NAMES
JANFEBMARAPRMAYJUNJULAUGSEPOCTNOVDEC
**   ZF29 DAY NOS OF FEB 29 TO 2096 (INCLUDING 2000)
0006001521029820444305904073650882610287117481320914670161311759219053
2051421975234362489726358278192928030741322023366335124365853804639507
40968424294389045351
**   @YD  - YEARS IN DAYS CUMULATIVE, FOUR YEAR SPAN
00366007310109601461
**   @MD  - MONTHS IN DAYS CUMULATIVE THROUGH YEAR
00000000310005900090001200015100181002120024300273003040033400365
