     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2019')
      *****************************************************************
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('Midas LE Facility History Correction for CA')          *
      *****************************************************************
      *                                                               *
      *  Midas - Customer Lending Module                              *
      *                                                               *
      *  UTLE0840 - Facility History Correction for CA                *
      *                                                               *
      *  Function:  This program updates FARCIN in FACHISA with value *
      *             of 'T' for those affected live credit agreement   *
      *             history records having blank value or with value  *
      *             not equal to 'T'. All credit agreement with RVCR  *
      *             equal to 'T' are flagged for facility rework so as*
      *             to trigger recalculation during close of business.*
      *             This program runs in two modes according to the   *
      *             parameter being passed into it:                   *
      *             1. Audit ('A')                                    *
      *             2. Update ('U')                                   *
      *                                                               *
      *                                                               *
      *  Called By: UTCLE0840 - CL program                            *
      *                                                               *
      *  (c) Finastra International Limited 2020                      *
      *                                                               *
      *  Last Amend No. MD053826 *CREATE   Date 27Jul20               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD053826 - Facility amount in credit agreement is incorrect  *
      *             after back-valued transaction. Update FACHISA with*
      *             correct FARCIN 'T' for CA with RVCR = 'T'. Flag   *
      *             live CAs with RVCR = 'T' for facility rework.     *
      *                                                               *
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+

     FUT0840L1  IF   E           K DISK    INFSR(*PSSR)
     FFACHISHL  UF   E           K DISK    INFSR(*PSSR)
     FFACACT    UF A E           K DISK    INFSR(*PSSR)
     FHISUPD    UF   E           K DISK    INFSR(*PSSR)
     F                                     RENAME(FACHISAF:FACHIS1F)
     F                                     IGNORE(HISACTF)
     F                                     PREFIX(F1_)
     FUT0840P1  O    E             PRINTER OFLIND(*IN88)
     FUT0840P2  O    E             PRINTER OFLIND(*IN89)

      *****************************************************************
      *                                                               *
      *  F U N C T I O N  O F  I N D I C A T O R S                    *
      *                                                               *
      *   12 -  No Details to Report                                  *
      *   16 -  Update mode                                           *
      *   80 -  EOF in UT0840L1                                       *
      *   86 -  Chain in FACHISH/FACACT                               *
      *   87 -  EOF in HISUPD                                         *
      *   88 -  Overflow UT0840P1                                     *
      *   89 -  Overflow UT0840P2                                     *
      *                                                               *
      *****************************************************************
      *
      ** +--------------------------------------+
      ** ¦ Automatically included D-specs       ¦
      ** ¦ ==============================       ¦
      ** +--------------------------------------+
      **
      **--------------------------------------------------------------------------------------------
      ** The following /COPY line includes (among others) the LDA layout
      ** and the copyright array definition:
     D/COPY ZACPYSRC,STD_D_SPEC
      **--------------------------------------------------------------------------------------------

      **--------------------------------------------------------------------------------------------
      ** The following /COPY includes the LE standard declares:
     D/COPY ZACPYSRC,STDDECLARE
      **--------------------------------------------------------------------------------------------

      **--------------------------------------------------------------------------------------------
      ** The following /COPY line includes all the defined fields in the
      ** Program Status Data Structures.  They have meaningful
      ** names, prefixed by 'PS'.
     D/COPY ZACPYSRC,PSDS
      **--------------------------------------------------------------------------------------------

      **--------------------------------------------------------------------------------------------
      ** The following /COPY line includes the definitions for error and
      ** warning message arrays.
     D/COPY ZACPYSRC,ERR_ARRAYS
      **--------------------------------------------------------------------------------------------

      ** +--------------------------------------+
      ** ¦ End of automatically included D-specs¦
      ** ¦ =====================================¦
      ** +--------------------------------------+

      *****************************************************************
      /SPACE 5
      *****************************************************************
      *
      ** +--------------------------------------+
      ** ¦ Manually included D-specs            ¦
      ** ¦ =========================            ¦
      ** +--------------------------------------+
      *
      ** Rundate data structure
      *
     D RUNDAT        E DS                  EXTNAME(RUNDAT)
      *
      ** Bank Details.
      *
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
      *
      ** Data structure for Access Program
      *
     D DSFDY         E DS                  EXTNAME(DSFDY)
      *
      ** +--------------------------------------+
      ** ¦ Named constants                      ¦
      ** ¦ ===============                      ¦
      ** +--------------------------------------+
      *
      ** ZDATE2 parameters
      *
     D ZDAYNO          S              5  0
     D ZDATE           S              6  0
     D ZADATE          S              7A
      *
     D wfarcin         S              1A
      *
      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
      *
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
      *
      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
      *
      ** +----------------------------------------+
      ** ¦ Hook for non-core D-specs (all types)  ¦
      ** ¦ also any I-specs (if necessary)        ¦
      ** ¦ =====================================  ¦
      ** +----------------------------------------+
      *
      *****************************************************************
      /SPACE 5
      ************************************************D ***************
      *
      ** +--- Start of Main processing -----------------------------------+
      ** ¦                                                                ¦
      ** ¦ Initial processing is performed automatically: the *INZSR is   ¦
      ** ¦ executed at program activation.                                ¦
      ** ¦                                                                ¦
      ** +----------------------------------------------------------------+
      *
      ** Initial printing of report header
      *
     C                   WRITE     HEADER1
     C                   WRITE     HEADER2
      *
      ** Read FCLTYFM having TRCA = 'CA' and RVCR = 'T'
      *
     C     *LOVAL        SETLL     UT0840L1
     C                   READ      UT0840L1                               80
      *
     C                   DOW       *IN80 = '0'
      *
     C                   MOVEL     FACT          WFCTY             5 0
     C                   MOVE      FCNO          WFCTY
      *
      ** Check history records in FACHISA
      *
     C     KEY001        SETLL     HISUPD
     C     KEY001        READE     HISUPD                                 87
      *
     C                   DOW       *IN87 = '0'
      *
     C                   IF        F1_FAACTN = 'FS' or
     C                             F1_FAACTN = 'RC'
     C                   EVAL      WFARCIN = F1_FARCIN
     C                   ENDIF
      *
     C                   IF        F1_FARCIN <> WFARCIN
      *
     C                   IF        WDFLAG = 'N'
     C                   IF        F1_FARECI = 'D' AND
     C                             F1_FAREVI = ' '
     C                   Z-ADD     F1_FADATE     WDATE             5 0
     C                   ENDIF
     C                   ENDIF
      *
     C                   MOVE      'Y'           WDFLAG
     C                   ADD       1             WRECER
      *
     C                   IF        *IN16 = '1'
     C                   MOVE      WFARCIN       F1_FARCIN
     C                   ENDIF
      *
      ** Printer overflow checking
      *
     C                   IF        *IN88 = '1'
     C                   WRITE     HEADER1
     C                   EVAL      *IN88 = '0'
     C                   ENDIF
      *
      ** Populate printer file
      *
     C                   MOVE      F1_BRCA       PBRCA
     C                   MOVE      F1_FACNUM     PCNUM
     C                   MOVE      FACT          PFACT
     C                   MOVE      FCNO          PFCNO
     C                   MOVE      FCCY          PCCY
      *
     C                   MOVE      F1_FADATE     ZDAYNO
     C                   EXSR      SRFDAT
     C                   MOVEL     ZADATE        PDATE
      *
     C                   Z-ADD     F1_FATSEQ     PSEQ
      *
     C                   MOVE      F1_FAACTN     PACTN
      *
     C                   MOVE      *BLANK        PRCIN
     C                   MOVE      *BLANK        PRCINB
     C                   IF        F1_FARCIN = ' '
     C                   MOVE      'BLANK'       PRCINB
     C                   ELSE
     C                   MOVE      F1_FARCIN     PRCIN
     C                   ENDIF
      *
      ** Write details to printer file
      *
     C                   WRITE     DETAIL1
      *
      ** Update mode is ON
      *
     C                   IF        *IN16 = '1'
     C                   UPDATE    FACHIS1F
     C                   ENDIF
      *
     C                   ENDIF
      *
     C     KEY001        READE     HISUPD                                 87
      *
     C                   ENDDO
      *
      ** Accumulate facilities in error
      *
     C                   IF        WDFLAG = 'Y'
     C                   ADD       1             FACERR
      *
      ** Printer overflow checking
      *
     C                   IF        *IN89 = '1'
     C                   WRITE     HEADER2
     C                   EVAL      *IN89 = '0'
     C                   ENDIF
      *
      ** Populate printer file
      *
     C                   MOVE      F1_BRCA       PBRCA
     C                   MOVE      F1_FACNUM     PCNUM
     C                   MOVE      FACT          PFACT
     C                   MOVE      FCNO          PFCNO
     C                   MOVE      FCCY          PCCY
      *
      ** Update FACHISH and FACACT to recalculate facility on COB
      *
     C                   IF        *IN16 = '1'
      *
     C     KEY002        CHAIN     FACHISHF                           86
     C                   IF        *IN86 = '0'
     C                   EVAL      FHRWKR = 'Y'
     C                   EVAL      FHRWDT = WDATE
     C                   EVAL      FHRWTP = 'M'
     C                   UPDATE    FACHISHF
     C                   ENDIF
      *
     C     KEY003        CHAIN     FACACTF                            86
     C                   IF        *IN86 = '1'
     C                   EVAL      FCCNUM = F1_FACNUM
     C                   EVAL      FCFCTY = F1_FAFCTY
     C                   EVAL      FCDATE = WDATE
     C                   WRITE     FACACTF
     C                   ELSE
     C                   IF        WDATE < FCDATE
     C                   EVAL      FCDATE = WDATE
     C                   UPDATE    FACACTF
     C                   ENDIF
     C                   ENDIF
      *
     C                   ENDIF
      *
     C                   WRITE     DETAIL2
     C                   ENDIF
      *
     C                   READ      UT0840L1                               80
     C                   MOVE      'N'           WDFLAG
      *
     C                   ENDDO
      *
      ** Write Footer
      *
     C                   IF        WRECER = 0
     C                   EVAL      *IN12 = '1'
     C                   ENDIF
     C                   WRITE     TRAILER1
     C                   WRITE     TRAILER2
      *
     C                   EVAL      *INLR = '1'
     C                   RETURN
      /EJECT
      *****************************************************************
      *                                                               *
      * SRFDAT - Format Date                                          *
      *                                                               *
      * Called by: Main Processing                                    *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
     C     SRFDAT        BEGSR
      *
     C                   CALL      'ZDATE2'
     C                   PARM                    ZDAYNO
     C                   PARM                    BJDFIN
     C                   PARM      *ZERO         ZDATE
     C                   PARM      *BLANKS       ZADATE
      *
     C                   ENDSR
      /EJECT
      *****************************************************************
      *                                                               *
      * *INZSR - Program Initialisation routine                       *
      *                                                               *
      * Called by: Implicitly on program activation                   *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
     C     *INZSR        BEGSR
      *
      ** Parameter Entry List
      *
     C     *ENTRY        PLIST
     C                   PARM                    Mode              1
      *
     C     *DTAARA       DEFINE                  RUNDAT
     C                   IN        RUNDAT
      *
      ** Check mode if AUDIT or UPDATE
      *
     C                   IF        Mode = 'U'
     C                             OR Mode = 'u'
     C                   EVAL      *IN16 = '1'
     C                   ELSE
     C                   EVAL      *IN16 = '0'
     C                   ENDIF
      *
     C     KEY001        KLIST
     C                   KFLD                    BRCA
     C                   KFLD                    CNUM
     C                   KFLD                    WFCTY
      *
     C     KEY002        KLIST
     C                   KFLD                    BRCA
     C                   KFLD                    CNUM
     C                   KFLD                    FACT
     C                   KFLD                    FCNO
      *
     C     KEY003        KLIST
     C                   KFLD                    BRCA
     C                   KFLD                    CNUM
     C                   KFLD                    WFCTY
      *
     C                   EVAL      *IN12 = '0'
     C                   Z-ADD     0             FACERR            6 0
     C                   Z-ADD     0             WRECER            6 0
     C                   MOVE      'N'           WDFLAG            1
      *
      ** Access bank details
      *
     C                   CALL      'AOBANKR0'
     C                   PARM      '*MSG   '     @RTCD             7
     C                   PARM      '*FIRST '     @OPTN             7
     C     SDBANK        PARM      SDBANK        DSFDY
     C                   IF        @RTCD <> *BLANKS
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE = 'SDBANKPD'
     C                   EVAL      DBKEY = @OPTN                                *************
     C                   EVAL      DBPGM = 'UTLE0840'                           * DBERR 001 *
     C                   EVAL      DBASE = 001                                  *************
     C                   OUT       LDA
     C                   WRITE     HEADER1
     C                   WRITE     DBERROR1
     C                   EXSR      *PSSR
     C                   ENDIF
      *
     C                   ENDSR
      /EJECT
      *****************************************************************
      *                                                               *
      *  *PSSR - Subroutine to handle error conditions                *
      *                                                               *
      *  Called from:  After abnormal operation occurs                *
      *                                                               *
      *  Calls: Nothing                                               *
      *                                                               *
      *****************************************************************
     C     *PSSR         BEGSR
      *
     C                   IF        @RUN = *BLANKS
     C                   MOVE      'Y'           @RUN              1
     C                   DUMP
     C                   ENDIF
      *
     C                   EVAL      *INU7 = '1'
     C                   EVAL      *INU8 = '1'
     C                   EVAL      *INLR = '1'
     C                   RETURN

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
**  CPY@
(c) Finastra International Limited 2019
