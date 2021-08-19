     H DEBUG DATEDIT(*YMD)
      *****************************************************************
/*S*D****RPGBASE*******************************************************                       LUC109
/*STD *  RPGBASEBND                                                   *                       LUC109
/*EXI *  TEXT('Daily ACCNTAB Extract to ACCNTBX0')                    *                       LUC109
      *****************************************************************
      *                                                               *
      *  Midas - Interface to Head Office Reporting                   *
      *                                                               *
      ***REM009**-*Daily*ACCNTAB*Extract*to*ACCNTBX0*******************                       LUC109
      *  XX000009 - Daily ACCNTAB Extract to ACCNTBX0                 *                       LUC109
  ?   *****************************************************************
  ?   * *** THIS PROGRAM MUST BE COMPILED WITH XXINTFLIB AT THE TOP   *
  ?   * OF LIBL ***                                                   *
  ?   *****************************************************************
      *                                                               *
      *                                                               *
      ***CALLED*BY**GLCM043*-*HOR*FILES*CREATION***********************                       LUC109
      *  CALLED BY XXC000043 - HOR FILES CREATION                     *                       LUC109
      *             Frequency: Automatically in Close of Business     *
      *                                                               *
      ***(C)*COPYRIGHT*MKI*LIMITED*1998********************************                       LUC109
      *  (c) Finastra International Limited 2016                      *                       LUC109
      *                                                               *
      *  Last Amend No. LUC109             Date 22Sep16               *
      *  Prev Amend No. MUI009             Date 16Feb04               *
      *                 174480             Date 13Feb00               *
      *                 171072             Date 22Nov99               *
      *                 167337             Date 10Nov99               *
      *                 167412             DATE 25OCT99               *
      *                 159964             Date 22Aug99               *
      *                 MMI043             Date 22Jun99               *
      *                 MMI043   *CREATE   Date 16Dec98               *
      *                                                               *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  LUC109 - HO Reporting (Upgrade to FB Midas 2.1)              *
      *  MUI009 - R4.1 Upgrade:                                       *
      *           Added ZDATE9 which is now required by ZCBDYS        *
      *           Added ZDATE10 which is now required by ZCBDYS       *
      *  174480 - Cleared the fields MDRPO and MCRPO at the start     *
      *           of the quarter.  Also corrected the updating of     *
      *           said fields.                                        *
      *  171072 - Retail monthly averages: wrong values passed        *
      *           into and out of averaging subroutine.               *
      *  167337 - Quarterly min and max debit incorrectly calculated. *
      *  167412 - Change the way monthly averages are calculated:     *
      *           include non-working days and do not count days      *
      *  159964 - PGM/GLM032A cannot allocate object LF/SDCUSTL0 due  *
      *           to SCC0406.                                         *
      *         - Seton job switches U7/U8 for error processing       *
      *  MMI043 - Amend to correct MDRPO, MCRPO, MNDPO, MNCPO, MNOCQ, *
      *           MQMAV & MQXAV fields                                *
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
     F***REM009AU  O    E             PRINTER INFDS(SPOOL)                                    LUC109
     FXX000009AUO    E             PRINTER INFDS(SPOOL)                                       LUC109
      *
      *****************************************************************
      *                                                               *
      *  F U N C T I O N   O F   I N D I C A T O R S                  *
      *                                                               *
      *   20 - PF/ACCNTBV1   File I/O                                 *
      *   88 - General chain indicator                                *
      *                                                               *
      *                                                               *
      *  89       Database Error                                      *
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
      ***/C*PY*ZSRSRC,ZDATE2Z1                                                                LUC109
     D/COPY ZSRSRC,ZDATE2Z1LE                                                                 LUC109
      ***/C*PY*ZSRSRC,ZDAYSZ1                                                                 LUC109
     D/COPY ZSRSRC,ZDAYSZ1LE                                                                  LUC109
     D***/C*PY*ZSRSRC,ZDATE9Z1                                                         MUI009 LUC109
     D/COPY ZSRSRC,ZDATE9Z1LE                                                                 LUC109
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
     I***/C*PY*ZSRSRC,ZCBDYSZ2                                                         MUI009 LUC109
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
     I***/C*PY*ZSRSRC,ZDATE9Z2                                                         MUI009 LUC109
     D/COPY ZSRSRC,ZDATE9Z2LE                                                                 LUC109
     I***/C*PY*ZSRSRC,ZDAT10Z1                                                         MUI009 LUC109
     D/COPY ZSRSRC,ZDAT10Z1LE                                                                 LUC109
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
     C                   KFLD                    KYCNUM            6 0
     C                   KFLD                    KYCCY             3
     C                   KFLD                    KYACOD            4 0
     C                   KFLD                    KYACSQ            2 0
     C                   KFLD                    KYBRCA            3
      *
     C     IAACCT        KLIST
     C                   KFLD                    IABRCA            3
     C                   KFLD                    IACNUM            6 0
     C                   KFLD                    IACCY             3
     C                   KFLD                    IAACOD            4 0
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
      *                                                                   167412
      ** Initialise variables for averaging subroutines                   167412
      *                                                                   167412
      *                                                                   167412
     C                   EXSR      AVINIT                                                      16741
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
     C     DACC          IFGT      MPEMB                                                       16741
     C     DACC          OREQ      0                                                           16741
     C                   EXSR      #PROC
     C                   ELSE                                                                  16741
     C                   EXSR      #DELET                                                      16741
     C                   ENDIF                                                                 16741
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
     C                   MOVE      ACOD          KYACOD
     C                   MOVE      ACSQ          KYACSQ
     C                   MOVE      BRCA          KYBRCA
     C     KYACCT        CHAIN     ACCNTBY2                           20
     C   20              EXSR      #CRTBX
     C   20KYACCT        CHAIN     ACCNTBY2                           20
      *
      * Increment MTD Working Days by 1.
      *
      * ... first day of month processing only
     C     MFSTM         IFEQ      'Y'
     C                   Z-ADD     0             MMTDY
     C                   ENDIF
      *
     C                   ADD       1             MMTDY
      *
      *                                                                   167412
      ** Store account opening and closure dates for averaging            167412
      *                                                                   167412
      *                                                                   167412
     C                   Z-ADD     DACO          @VDAT                                         16741
     C                   Z-ADD     DACC          @MDAT                                         16741
      * DR Interest Rate MTD
      *
     C                   Z-ADD     MDAVX         CUMDRX                                        16741
     C                   Z-ADD     CDIR          XAMNT                                         16741
     C                   MOVE      *OFF          WDRCR                                         16741
     C                   Z-ADD     MCDIRX        XAMNTX                                        16741
     C                   MOVE      *OFF          WDRCRX                                        16741
     C                   EXSR      AVEMTH                                                      16741
     C                   Z-ADD     CUMDR         MDAVX                                         16741
     C                   Z-ADD     AVEDR         MDAVR                                         16741
     C                   Z-ADD     CDIR          MCDIRX                                        16741
      **...*first*day of month processing only                            167412
     C***********MFSTM     IFEQ 'Y'                                       167412
     C**************       Z-ADD*ZERO     MDAVX                           167412
     C**************       ENDIF                                          167412
      **************                                                      167412
     C**************       ADD  CDIR      MDAVX                           167412
      **************                                                      167412
      **DR*Interest*Rate Mthly Average                                    167412
      **************                                                      167412
     C***********MMTDY     IFNE 0                                         167412
     C***********MDAVX     DIV  MMTDY     MDAVR                           167412
     C**************       ENDIF                                          167412
      *
      * CR Interest Rate MTD
      *
     C                   Z-ADD     MCAVX         CUMCRX                                        16741
     C                   Z-ADD     CCIR          XAMNT                                         16741
     C                   Z-ADD     MCCIRX        XAMNTX                                        16741
     C                   MOVE      *ON           WDRCR                                         16741
     C                   MOVE      *ON           WDRCRX                                        16741
     C                   EXSR      AVEMTH                                                      16741
     C                   Z-ADD     CUMCR         MCAVX                                         16741
     C                   Z-ADD     AVECR         MCAVR                                         16741
     C                   Z-ADD     CCIR          MCCIRX                                        16741
      **...*first*day of month processing only                            167412
     C***********MFSTM     IFEQ 'Y'                                       167412
     C**************       Z-ADD*ZERO     MCAVX                           167412
     C**************       ENDIF                                          167412
      **************                                                      167412
     C**************       ADD  CCIR      MCAVX                           167412
      **************                                                      167412
      **CR*Interest*Rate Mthly Average                                    167412
      **************                                                      167412
     C***********MMTDY     IFNE 0                                         167412
     C***********MCAVX     DIV  MMTDY     MCAVR                           167412
     C**************       ENDIF                                          167412
      *
      * DR/CR Accounting Balance MTD
      *
     C                   Z-ADD     MCALX         CUMCR                                         16741
     C                   Z-ADD     MDALX         CUMDR                                         16741
     C                   Z-SUB     LDBL          XAMNT                                         16741
     C                   Z-SUB     MLDBLX        XAMNTX                                        16741
     C     LDBL          IFGT      0                                                           16741
     C                   MOVE      *OFF          WDRCR                                         16741
     C                   ELSE
     C                   MOVE      *ON           WDRCR                                         16741
     C                   ENDIF
     C     MLDBLX        IFGT      0                                                           16741
     C                   MOVE      *OFF          WDRCRX                                        16741
     C                   ELSE
     C                   MOVE      *ON           WDRCRX                                        16741
     C                   ENDIF
     C                   EXSR      AVEMTH                                                      16741
     C                   Z-ADD     CUMDR         MDALX                                         16741
     C*********************Z-ADDCUMDR     MCALX                     167412171072
     C                   Z-ADD     CUMCR         MCALX                                         17107
     C                   Z-ADD     AVEDR         MDALB                                         16741
     C*********************Z-ADDAVEDR     MCALB                     167412171072
     C                   Z-ADD     AVECR         MCALB                                         17107
     C                   Z-ADD     LDBL          MLDBLX                                        16741
      **...*first*day of month processing only                            167412
     C***********MFSTM     IFEQ 'Y'                                       167412
     C**************       Z-ADD*ZERO     MDALX                           167412
     C**************       Z-ADD*ZERO     MCALX                           167412
     C**************       ENDIF                                          167412
      **...*reverse*sign before accumulating                              167412
     C**************       Z-SUBLDBL      WAMT                            167412
     C***********LDBL      IFGT 0                                         167412
     C**************       ADD  WAMT      MDALX                           167412
     C**************       ELSE                                           167412
     C**************       ADD  WAMT      MCALX                           167412
     C**************       END                                            167412
      **************                                                      167412
      **DR/CR*Accounting Balance Mthly Average                            167412
      **************                                                      167412
     C***********MMTDY     IFNE 0                                         167412
     C***********MDALX     DIV  MMTDY     MDALB                           167412
     C***********MCALX     DIV  MMTDY     MCALB                           167412
     C**************       ENDIF                                          167412
      *
      * DR/CR Available Balance MTD
      *
     C                   Z-ADD     MCACX         CUMCR                                         16741
     C                   Z-ADD     MDACX         CUMDR                                         16741
     C                   Z-SUB     CLBL          XAMNT                                         16741
     C                   Z-SUB     MCLBLX        XAMNTX                                        16741
     C***********LDBL      IFGT 0                                   167412171072
     C     CLBL          IFGT      0                                                           17107
     C                   MOVE      *OFF          WDRCR                                         16741
     C                   ELSE
     C                   MOVE      *ON           WDRCR                                         16741
     C                   ENDIF
     C***********MLDBLX    IFGT 0                                   167412171072
     C     MCLBLX        IFGT      0                                                           17107
     C                   MOVE      *OFF          WDRCRX                                        16741
     C                   ELSE
     C                   MOVE      *ON           WDRCRX                                        16741
     C                   ENDIF
     C                   EXSR      AVEMTH                                                      16741
     C                   Z-ADD     CUMDR         MDACX                                         16741
     C*********************Z-ADDCUMDR     MCACX                     167412171072
     C                   Z-ADD     CUMCR         MCACX                                         17107
     C                   Z-ADD     AVEDR         MDACB                                         16741
     C*********************Z-ADDAVEDR     MCACB                     167412171072
     C                   Z-ADD     AVECR         MCACB                                         17107
     C                   Z-ADD     CLBL          MCLBLX                                        16741
      **...*first*day of month processing only                            167412
     C***********MFSTM     IFEQ 'Y'                                       167412
     C**************       Z-ADD*ZERO     MDACX                           167412
     C**************       Z-ADD*ZERO     MCACX                           167412
     C**************       ENDIF                                          167412
      **...*reverse*sign before accumulating                              167412
     C**************       Z-SUBCLBL      WAMT                            167412
     C***********CLBL      IFGT 0                                         167412
     C**************       ADD  WAMT      MDACX                           167412
     C**************       ELSE                                           167412
     C**************       ADD  WAMT      MCACX                           167412
     C**************       END                                            167412
      **************                                                      167412
      **DR/CR*Available Balance Mthly Average                             167412
      **************                                                      167412
     C***********MMTDY     IFNE 0                                         167412
     C***********MDACX     DIV  MMTDY     MDACB                           167412
     C***********MCACX     DIV  MMTDY     MCACB                           167412
     C**************       ENDIF                                          167412
      *
      * DR/CR Interest Movements at end of last quarter
      *
      * ... first day of quarter processing only
     C     MFSTQ         IFEQ      'Y'
     C                   ADD       MQDIM         MQDIX
     C                   ADD       MQCIM         MQCIX
     C                   END
      *
      * DR/CR Interest Movements this quarter
      *
     C     DIIE          ADD       DAIC          WAMT
     C     WAMT          SUB       MQDIX         MQDIM
      *
     C     CIIE          ADD       CAIC          WAMT
     C     WAMT          SUB       MQCIX         MQCIM
      *
      * Quarterly Maximum DR Accounting Balance
      *
      * ... first day of quarter processing only
     C     MFSTQ         IFEQ      'Y'
     C*********************Z-SUB0         MQXAB                           167337
     C                   Z-SUB     LDBL          MQXAB                                         16733
     C                   END
      * ... note that MQXAB is stored as -ve value
     C***********LDBL******IFGT 0                                         167337
     C                   Z-SUB     MQXAB         WAMT
     C     LDBL          IFGT      WAMT
     C                   Z-SUB     LDBL          MQXAB
     C                   ENDIF
     C*********************ENDIF                                          167337
      *
      * Quarterly Minimum DR Available Balance
      *
      * ... first day of quarter processing only
     C     MFSTQ         IFEQ      'Y'
     C                   Z-ADD     MQMAV         MPQMA
     C*********************Z-ADDCLBL      MQMAV                     MMI043167337
     C                   Z-SUB     CLBL          MQMAV                                         16733
     C                   END
      * ... note that MQMAV is stored as -ve value
     C***********CLBL      IFGT 0                                         MMI043
     C                   Z-SUB     MQMAV         WAMT
     C     CLBL          IFLT      WAMT
     C                   Z-SUB     CLBL          MQMAV
     C                   ENDIF
     C***********          ENDIF                                          MMI043
      *
      * Quarterly Maximum DR Available Balance
      *
      * ... first day of quarter processing only
     C     MFSTQ         IFEQ      'Y'
     C                   Z-ADD     MQXAV         MPQXA                                         MMI04
     C*********************Z-ADDCLBL      MQMAV                     MMI043167337
     C                   Z-SUB     CLBL          MQXAV                                         16733
     C***********          Z-ADD0         MQXAV                           MMI043
     C                   END
      * ... note that MQXAV is stored as -ve value
     C***********CLBL      IFGT 0                                         MMI043
     C                   Z-SUB     MQXAV         WAMT
     C***********CLBL      IFLT WAMT                                      MMI043
     C     CLBL          IFGT      WAMT                                                        MMI04
     C                   Z-SUB     CLBL          MQXAV
     C                   ENDIF
     C***********          ENDIF                                          MMI043
      *
      * Get Charges and Commission for this Account.
      *
     C                   EXSR      #CHCM
      *
      * Charges/Commission DR at end of previous month.
      *
      * ... note that fields stored as -ve
     C     MFSTM         IFEQ      'Y'
     C                   SUB       MDCGM         MDGPV
     C                   SUB       MDCMM         MDCPV
     C                   ENDIF
      *
      * Charges/Commission DR this month
      *
      * ... note that fields stored as -ve
     C                   Z-SUB     MDGPV         WAMT
     C     WCHGS         SUB       WAMT          WAMT
     C                   Z-SUB     WAMT          MDCGM
      *
     C                   Z-SUB     MDCPV         WAMT
     C     WCOMM         SUB       WAMT          WAMT
     C                   Z-SUB     WAMT          MDCMM
      *
      * Read Postings File for this account.
      *
     C                   EXSR      #EOD
      *
      * Number of Cheques DR this Quarter
      *
      * ... first day of quarter processing only
     C     MFSTQ         IFEQ      'Y'
     C                   ADD       MNOCQ         MNOCX
     C                   Z-ADD     0             MNOCQ                                         MMI04
     C                   END
      *
     C***********WCHQNO    SUB  MNOCX     MNOCQ                           MMI043
     C                   ADD       WCHQNO        MNOCQ                                         MMI04
      *
      * Amount of Cheques DR this Quarter
      *
      * ... first day of quarter processing only
     C     MFSTQ         IFEQ      'Y'
     C                   ADD       MAMCQ         MAMCX
     C                   END
      * ... note that fields are stored as -ve
     C                   Z-SUB     WCHQSM        WAMT1
     C                   Z-SUB     MAMCX         WAMT2
     C     WAMT1         SUB       WAMT2         WAMT
     C                   Z-SUB     WAMT          MAMCQ
      *
      * Amount of Unpaid Chqs and Drafts
      *
      * ... field stored as -ve
     C                   Z-SUB     WUNPD         MUNPD
      *
      * Number of Reverses
      *
     C                   Z-ADD     WREVNO        MRVNO
      *
      * Amount of DR Postings this Quarter
      *
      * ... first day of quarter processing only
      ** Zeroise the field MDRPO at the start of the quarter.             174480
      *                                                                   174480
     C     MFSTQ         IFEQ      'Y'
     C                   ADD       MDRPO         MDRPX
     C                   Z-ADD     0             MDRPO                                         17448
     C                   END
      * ... note that fields are stored as -ve
      ** Update the amount of debit posting for this quarter (MDRPO).     174480
      *                                                                   174480
     C                   SUB       WDRPST        MDRPO                                         17448
     C***********          Z-SUBWDRPST    WAMT1                           174480
     C***********          Z-SUBMDRPX     WAMT2                           174480
     C***********WAMT1     SUB  WAMT2     WAMT                            174480
     C***********WAMT      IFGE 0                                         174480
     C***********          Z-SUBWAMT      MDRPO                    MMI043 174480
     C***********          ELSE                                           174480
     C***********          Z-ADDWAMT      MDRPO                    MMI043 174480
     C***********          ENDIF                                          174480
      *
      * Amount of CR Postings this Quarter
      *
      * ... first day of quarter processing only
      ** Zeroise the field MCRPO at the start of the quarter.             174480
      *                                                                   174480
     C     MFSTQ         IFEQ      'Y'
     C                   ADD       MCRPO         MCRPX
     C                   Z-ADD     0             MCRPO                                         17448
     C                   END
      **...*note*that*fields*are*stored*as*-ve*************               174480
      ** Note that the values are stored in the file as positive.         174480
      ** Update the amount of credit posting for this quarter (MCRPO).    174480
      *                                                                   174480
     C                   ADD       WCRPST        MCRPO                                         17448
     C***********          Z-SUBWCRPST    WAMT1                           174480
     C***********          Z-SUBMCRPX     WAMT2                           174480
     C***********WAMT1     SUB  WAMT2     WAMT                            174480
     C***********WAMT1     IFGT WAMT2                              MMI043 174480
     C***********          Z-ADDWAMT      MCRPO                    MMI043 174480
     C***********          ELSE                                    MMI043 174480
     C***********          Z-SUBWAMT      MCRPO                           174480
     C***********          END                                     MMI043 174480
      *
      * Number of DR Postings this Quarter
      *
      * ... first day of quarter processing only
     C     MFSTQ         IFEQ      'Y'
     C                   ADD       MNDPO         MNDPX
     C                   Z-ADD     0             MNDPO                                         MMI04
     C                   END
      *
     C***********WDRNO     SUB  MNDPX     MNDPO                           MMI043
     C                   ADD       WDRNO         MNDPO                                         MMI04
      *
      * Number of CR Postings this Quarter
      *
      * ... first day of quarter processing only
     C     MFSTQ         IFEQ      'Y'
     C                   ADD       MNCPO         MNCPX
     C                   Z-ADD     0             MNCPO                                         MMI04
     C                   END
      *
     C***********WCRNO     SUB  MNCPX     MNCPO                           MMI043
     C                   ADD       WCRNO         MNCPO                                         MMI04
      *
      * Update Record on ACCNTBX0
      *
     C                   UPDATE    ACCNBFX0
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *                                                                   167412
      ** Averaging subroutines:                                           167412
      *
      ***/C*PY*WNCPYSRC,AVEMTH1****************************************                       LUC109
      /COPY WNCPYSRC,AVEMTHI1                                                                 LUC109
      *
      *****************************************************************   167412
      *****************************************************************   167412
      *                                                               *   167412
      *  #DELET -  Delete ACCNTBX0 Record                             *   167412
      *                                                               *   167412
      *  Called By: #READ                                             *   167412
      *  Calls:                                                       *   167412
      *                                                               *   167412
      *****************************************************************   167412
      *                                                                   167412
     C     #DELET        BEGSR                                                                 16741
      *                                                                   167412
     C                   MOVE      CNUM          KYCNUM                                        16741
     C                   MOVE      CCY           KYCCY                                         16741
     C                   MOVE      ACOD          KYACOD                                        16741
     C                   MOVE      ACSQ          KYACSQ                                        16741
     C                   MOVE      BRCA          KYBRCA                                        16741
     C     KYACCT        CHAIN     ACCNTBY2                           20                       16741
     C  N20              DELETE    ACCNBFX0                                                    16741
      *                                                                   167412
     C                   ENDSR                                                                 16741
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
     C                   MOVE      ACOD          MACOD
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
     C                   MOVE      ACOD          IAACOD
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
     C                   MOVE      ACOD          EOACOD
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
     C     *IN89         IFEQ      *ON                                          Database error
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
     C                   MOVEL     'REM009'      DBPGM                          Set program id
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
