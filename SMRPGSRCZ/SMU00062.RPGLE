     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2007')
      *****************************************************************
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('Midas SM Change ST record to MC for multi-ccy')        *
      *****************************************************************
      *                                                               *
      *  Midas - Implementation module                                *
      *                                                               *
      *  SMU00062 - Program to change ST record to MC in FACHISA if   *
      *             if ST record is for multi-ccy.                    *
      *                                                               *
      *  (c) Finastra International Limited 2002                      *
      *                                                               *
      *  Last Amend No. AR674226           Date 04Dec19               *
      *  Prev Amend No. MD046248           Date 27Oct17               *
      *                 CLE154             Date 07Aug12               *
      *                 CLE148             Date 23Jul12               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      *                 BG26993            Date 26Jan10               *
      *                 216111             Date 20Mar03               *
      *                 194912 *CREATE     Date 25Feb02               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD054782 - Manual transaction reached 999. Increase the size *
      *             of SQNO to accomodate 9999 transactions.          *
      *             Recompile.                                        *
      *  MD046248 - Finastra Rebranding                               *
      *  CLE154 - Loan Repayment Schedule Enhancement (Recompile)     *
      *  CLE148 - Alpha Loan Reference (Recompile)                    *
      *  BG26993- Delivery of upgrade programs to core.               *
      *         - Renamed program SC19491201.                         *
      *  216111 - Database error unnecessary if facility doesnt exist.*
      *  194912 - Change 'ST' record to 'MC' in FACHISA if record     *
      *           is for Multi-ccy rollover, not Loan start.          *
      *                                                               *
      *****************************************************************
      *
      ** Facility History file
     FFACHSAL1  UF   E           K DISK
      *
      ** Loan History file
     FHISTR     IF   E           K DISK
     F                                     IGNORE(HISTSHMF)
     F                                     IGNORE(HISTSHPF)
      *
      ** Matured Loan History file
     FMHISR     IF   E           K DISK
     F                                     RENAME(HISTSHQF:MHISTHQF)
     F                                     IGNORE(HISTSHMF)
     F                                     IGNORE(HISTSHPF)
      *
      ** Facility file
     FFCLTY     IF   E           K DISK
     F                                     IGNORE(FCLTYFNF)
     F                                     IGNORE(FCLTYHHF)
     F                                     IGNORE(FCLTYZZF)
      *
      ** Loans File
     FCLOAN     IF   E           K DISK
     F                                     IGNORE(CLOANHHF)
     F                                     IGNORE(CLOANCKF)
     F                                     IGNORE(CLOANZ1F)
      *
      ** Matured Loans File
     FMLOAN     IF   E           K DISK
     F                                     RENAME(CLOANCLF:MCLONCLF)
     F                                     IGNORE(CLOANHHF)
     F                                     IGNORE(CLOANCKF)
     F                                     IGNORE(CLOANZ1F)
      *
     FSMU00062P1O    E             PRINTER INFDS(SPOOL1)
      *****************************************************************
      /EJECT
      *****************************************************************
      *  FUNCTION OF INDICATORS                                       *
      *                                                               *
      *   11 -  No Details to Report                                  *
      *   14 -  Update mode                                           *
      *   70 -  EOF in HISTSHQ/MHISTHQ                                *
      *   71 -  Record not found in FCLTY                             *
      *   72 -  Record not found in CLOAN                             *
      *   73 -  EOF in FACHISAF                                       *
      *   98  - Date Format: DDMMYY (off); MMDDYY (on)                *
      *                                                               *
      * U7+U8 - Database Error                                        *
      *                                                               *
      *****************************************************************
      /SPACE 3
      *****************************************************************
      *                                                               *
      *  S U B R O U T I N E   I N D E X                              *
      *                                                               *
      *  SRINIT - Program Initialisation                              *
      *  SRMAIN - Detail Processing                                   *
      *  SRPROC - Process FACHISA - ST Records                        *
      *  SRAUDT - Produce Audit Report and End Program                *
      *  *PSSR  - Program Error Processing Subroutine                 *
      *                                                               *
      *  ZDATE2 - Convert Midas Day Number into Date (DDMMYY/MMDDYY)  *
      *                                                               *
      *****************************************************************
      /EJECT
     D LDA             DS           256
      *
      ** Local Data Area for Database Error Details
      *
     D  DBFILE               134    141
     D  DBKEY                142    170
     D  DBPGM                171    180
     D  DBASE                181    183  0
      ** Data Area giving Installation Control Details
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
      *
      ** Bank details and rundate
     D DSFDY         E DS                  EXTNAME(DSFDY)
     D DSSDY         E DS                  EXTNAME(DSSDY)
      *
      ** Data structure for Access Program
      *
     D SPOOL1          DS
     D  OFFLN                188    189B 0
     D  CURLIN               367    368B 0
     I/COPY ZSRSRC,ZDATE2Z1LE
      *
     IFACHISAF
     I              BRCA                        FABRCA
      /EJECT
      *================================================================
      *  P R O G R A M   S T A R T                                    *
      *================================================================
      *
      ** Parameter Entry List
      *
     C     *ENTRY        PLIST
     C                   PARM                    MODE              1
      *
     C                   EXSR      SRINIT
      *
     C                   EXSR      SRMAIN
      *
     C                   EXSR      SRAUDT
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRINIT  Program Initialisation                               *
      *                                                               *
      *  Called by: Main Processing                                   *
      *  Calls:     AOBANKR0                                          *
      *                                                               *
      *****************************************************************
     C     SRINIT        BEGSR
      *
      ** Initialise LDA
      *
     C     *DTAARA       DEFINE                  LDA
      *
      ** Check mode if AUDIT or UPDATE.
      *
     C     MODE          IFEQ      'U'
     C     MODE          OREQ      'u'
     C                   MOVE      '1'           *IN14
     C                   ELSE
     C                   MOVE      '0'           *IN14
     C                   ENDIF
      *
     C     KEY001        KLIST
     C                   KFLD                    KCNUM             6
     C                   KFLD                    KFCTY             5 0
     C                   KFLD                    KVDAT             5 0
      *
     C     KEY002        KLIST
     C                   KFLD                    KCNUM             6
     C                   KFLD                    KFACT             3 0
     C                   KFLD                    KFCNO             2 0
      *
     C     KEY003        KLIST
     C                   KFLD                    PMFC
     C                   KFLD                    PMFT
     C                   KFLD                    PMFN
     C                   KFLD                    WRCTP             1
      *
      ** Access bank details
      *
     C                   CALL      'AOBANKR0'
     C                   PARM      '*MSG   '     PRTCD             7
     C                   PARM      '*FIRST '     POPTN             7
     C     SDBANK        PARM      SDBANK        DSFDY
      *
     C     PRTCD         IFNE      *BLANKS
     C     *LOCK         IN        LDA
     C                   MOVE      *BLANKS       DBKEY
     C                   MOVEL     POPTN         DBKEY
     C                   MOVEL     'SMU00062'    DBPGM
     C                   MOVE      '01'          DBPGM
     C                   MOVEL     'SDBANKPD'    DBFILE
     C                   Z-ADD     1             DBASE
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
      *
     C     BJDFIN        IFEQ      'M'
     C                   MOVE      '0'           *IN98
     C                   ENDIF
      *
     C                   WRITE     HEADER1
      *
     C                   ENDSR
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRMAIN - Detail Processing                                   *
      *                                                               *
      *  Called by: Main Processing                                   *
      *  Calls:     SRPROC, ZDATE2, *PSSR                             *
      *                                                               *
      *****************************************************************
     C     SRMAIN        BEGSR
     C                   Z-ADD     1             WCTR              1 0
      *
     C     WCTR          DOWLE     2
      *
     C     WCTR          IFEQ      1
     C                   READ      HISTSHQF                               70
     C                   ELSE
     C                   READ      MHISTHQF                               70
     C                   ENDIF
      *
     C     *IN70         DOWEQ     '0'
     C     AMTP          IFEQ      'MC'
     C                   ADD       1             RNORE
     C                   MOVE      FCUS          KCNUM
     C                   MOVEL     FTYP          KFCTY
     C                   MOVE      FSEQ          KFCTY
     C                   MOVE      VDAT          KVDAT
      *
      ** Update main facility history file
      *
     C                   EXSR      SRPROC
      *
     C                   MOVE      FTYP          KFACT
     C                   MOVE      FSEQ          KFCNO
     C                   MOVEL     FTYP          WFCTP             5 0
     C                   MOVE      FSEQ          WFCTP
     C     KEY002        CHAIN     FCLTY                              71
      *
     C********** *IN71     IFEQ '1'                                                           216111
     C********** *LOCK     IN   LDA                                                           216111
     C**********           MOVE *BLANKS   DBKEY                                               216111
     C**********           MOVEL'FCLTY   'DBFILE                                              216111
     C**********           Z-ADD2         DBASE                                               216111
     C**********           MOVELCNUM      DBKEY                                               216111
     C**********           MOVE WFCTP     DBKEY                                               216111
     C**********           MOVEL'SC194912'DBPGM                                               216111
     C**********           MOVE '01'      DBPGM                                               216111
     C**********           OUT  LDA                                                           216111
     C**********           EXSR *PSSR                                                         216111
     C**********           ELSE                                                               216111
      *                                                                                       216111
     C     *IN71         IFEQ      '0'
      ** If facility is found, check TRCA:                                                    216111
      *
      ** If facility is a tranche, update also Credit Agreement Faclty
      *
     C     TRCA          IFEQ      'TR'
     C                   MOVE      CANM          KCNUM
     C                   MOVEL     CAFT          KFCTY
     C                   MOVE      CAFN          KFCTY
     C                   MOVE      VDAT          KVDAT
     C                   EXSR      SRPROC
     C                   ENDIF
     C**********           ENDIF                                                              216111
      *
      ** If loan is participant, update also Prime Facility
      *
     C     LNRF          CHAIN     CLOANCLF                           72
     C     *IN72         IFEQ      '1'
     C     LNRF          CHAIN     MCLONCLF                           72
     C                   ENDIF
      *
     C     *IN72         IFEQ      '0'
      *
     C     LPFI          IFEQ      'I'
     C     LPFI          OREQ      'P'
     C                   MOVE      PMFC          KCNUM
     C                   MOVEL     PMFT          KFCTY
     C                   MOVE      PMFN          KFCTY
     C                   MOVE      VDAT          KVDAT
     C                   EXSR      SRPROC
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
      *
     C     WCTR          IFEQ      1
     C                   READ      HISTSHQF                               70
     C                   ELSE
     C                   READ      MHISTHQF                               70
     C                   ENDIF
      *
     C                   ENDDO
     C                   ADD       1             WCTR
     C                   ENDDO
      *
     C                   ENDSR
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRAUDT  Process AUDIT Report and End Program                 *
      *                                                               *
      *  Called by: Main Processing                                   *
      *  Calls    : None                                              *
      *****************************************************************
     C     SRAUDT        BEGSR
      *
      ** Write Footer.
      *
     C     RCHNG         IFEQ      0
     C                   MOVE      '1'           *IN11
     C                   ENDIF
      *
     C                   Z-ADD     10            RQDLIN
     C     OFFLN         SUB       CURLIN        AVALIN
     C     AVALIN        IFLT      RQDLIN
     C                   WRITE     HEADER1
     C                   ENDIF
      *
     C                   WRITE     TRAILER1
      *
     C                   MOVE      '1'           *INLR
     C                   RETURN
      *
     C                   ENDSR
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRPROC - Process FACHISA - ST Records                        *
      *                                                               *
      *  Called by: SRMAIN                                            *
      *  Calls    : None                                              *
      *                                                               *
      *****************************************************************
     C     SRPROC        BEGSR
      *
     C                   MOVE      'N'           WFND              1
      *
      ** Check on facility history file for the ST record of the
      ** multi-ccy rollover action for the loan
      *
     C     KEY001        SETGT     FACHISAF
     C     KEY001        READPE    FACHISAF                               73
      *
     C     *IN73         DOWEQ     '0'
     C     WFND          ANDEQ     'N'
      *
      ** If 'MC' record found, that means facility history already
      ** updated
      *
     C     FAACTN        IFEQ      'MC'
     C     FALOAN        ANDEQ     LNRF
     C                   MOVE      'Y'           WFND
     C                   ENDIF
      *
     C     FAACTN        IFEQ      'ST'
     C     FALOAN        ANDEQ     LNRF
     C                   ADD       1             RCHNG
     C                   MOVE      'Y'           WFND
     C                   MOVE      FABRCA        RBRCA
     C                   MOVE      FACNUM        RCNUM
     C                   MOVEL     FAFCTY        RFACT
     C                   MOVE      FAFCTY        RFCNO
     C                   MOVE      FAFSEQ        RFSEQ
     C                   MOVE      FADATE        ZDAYNO
     C                   EXSR      ZDATE2
     C                   MOVE      ZADATE        RVDAT
     C                   MOVE      FALOAN        RLNRF
      *
     C     *IN14         IFEQ      '1'
     C                   MOVE      'MC'          FAACTN
     C                   UPDATE    FACHISAF
     C                   ENDIF
      *
     C                   Z-ADD     2             RQDLIN            3 0
     C     OFFLN         SUB       CURLIN        AVALIN            3 0
     C     AVALIN        IFLT      RQDLIN
     C                   WRITE     HEADER1
     C                   ENDIF
     C                   WRITE     DETAIL1
     C                   ENDIF
      *
     C     KEY001        READPE    FACHISAF                               73
     C                   ENDDO
      *
     C                   ENDSR
      /EJECT
      *****************************************************************
      *                                                               *
      *  *PSSR - Subroutine to handle error conditions                *
      *                                                               *
      *  Called by:  After abnormal operation occurs                  *
      *  Calls: None                                                  *
      *                                                               *
      *****************************************************************
      *
     C     *PSSR         BEGSR
     C     @RUN          IFEQ      *BLANKS
     C                   MOVE      'Y'           @RUN              1
     C                   DUMP
     C                   WRITE     HEADER1
     C                   WRITE     DBERROR1
     C                   ENDIF
     C                   MOVE      '1'           *INU7
     C                   MOVE      '1'           *INU8
     C                   MOVE      '1'           *INLR
     C                   RETURN
     C                   ENDSR
      /TITLE SR/ZDATE2
     C/COPY ZSRSRC,ZDATE2Z2LE
      *
      *****************************************************************
**   ZYDY - YEARS IN DAYS CUMULATIVE, FOUR YEAR SPAN
0366073110961461
**   ZMDY - MONTHS IN DAYS CUMULATIVE THROUGH YEAR
000031059090120151181212243273304334365
**   ZMNM - MONTHS SHORT NAMES
JANFEBMARAPRMAYJUNJULAUGSEPOCTNOVDEC
