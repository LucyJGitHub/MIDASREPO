     H DEBUG
      *****************************************************************
/*STD *  RPGSQLBND                                                    *
/*EXI *  TEXT('Midas SD Trigger Program for T_APIMSG')                *
      *****************************************************************
      *                                                               *
      *  Midas - Standing Data Module                                 *
      *                                                               *
      *  SD000845 - Midas SD Write Queued Date file for Cust and A/c  *
      *             in NIGHT Mode                                     *
      *                                                               *
      *  Function:  This program applies an insert and amend trigger  *
      *             to PF/T_APIMSG                                    *
      *             For each record written to T_APIMSG               *
      *             Write Record to PF/API24X7SPD                     *
      *                                                               *
      *  Called By: APC001004                                         *
      *                                                               *
      *  (C) Finastra International Limited 2020                      *
      *                                                               *
      *  Last Amend No. CAP735             Date 12May20               *
      *  Prev Amend No. CAP734             Date 12May20               *
      *                 CAP702  *CREATE    Date 12May20               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CAP735 - 24x7 APIs - GL Accounts API                         *
      *  CAP734 - 24x7 APIs - SD Customer Details API                 *
      *  CAP702 - 24x7 APIs - Common Processing                       *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  SUBROUTINE INDEX                                             *
      *                                                               *
      *  SRINIT - Initial Processing.                                 *
      *  #IMAIN - Main Processing                                     *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  F U N C T I O N   O F   I N D I C A T O R S                  *
      *                                                               *
      *   LR  - Last Record Indicator                                 *
      *                                                               *
      *****************************************************************
      *
     FAPI24X7SL0UF A E           K DISK
      *
     D ARR@            S             80    DIM(1) CTDATA PERRCD(1)
      ** Array containing Copyright statement
      *
     D QPARM1          DS          8000
      ** Physical file name/library/member
      *
     D  QFNAME                 1     10
     D  QLNAME                11     20
     D  QMNAME                21     30
      ** Trigger Event ('1'=Insert, '2'=Update)
     D  QEVENT                31     31
      ** Trigger Time ('1'=After, '2'=Before)
     D  QTTIME                32     32
      ** Commit Lock Level ('0'=*NONE, '1'=*CHG, '2'=*CS, '3'=*ALL)
     D  QCOMIT                33     33
      ** CCSID
     D  QCCSID                37     40B 0
      ** Offset to original record
     D  Q1ROFF                49     52B 0
      ** Length of the original record
     D  Q1RLEN                53     56B 0
      ** Offset to original record null byte map
     D  Q1NOFF                57     60B 0
      ** Length of the original null byte map
     D  Q1NLEN                61     64B 0
      ** Offset to new record
     D  Q2ROFF                65     68B 0
      ** Length of new record
     D  Q2RLEN                69     72B 0
      ** Offset to the new record null byte map
     D  Q2NOFF                73     76B 0
      ** Length of null byte map
     D  Q2NLEN                77     80B 0
      *
     D QPARM2          DS
     D  QLENG                  1      4B 0
      ** "Before image of file"
      *
     D QFILEB          DS         32046
     D  MQMSIB                 1     19  0
     D  MQSTAB                20     20
     D  MQTMSB                21     46
     D  MQMSGB                47  32046
      *
      ** "After image of file"
     D QFILEA          DS         32046
     D  MQMSIA                 1     19  0
     D  MQMSIA_C               1     19
     D  MQSTAA                20     20
     D  MQTMSA                21     46
     D  MQMSGA                47  32046
      *
     D  MQMSGN         S          32000    VARYING
     D  MQMSIN         S             19  0
     D  MQSTAN         S              1
     D  MQTMSN         S             26
      *
     D SQLStmt         S           1000    VARYING INZ
     D SQLStmt2        S           1000    VARYING INZ
     D WError          S             10

     D DSAPIMsg        DS
     D  APMSID                       19S 0
     D  APSTAT                        1A
     D  APTMST                       26A
     D  APMSGS                    32000A   VARYING INZ
      *
     D DSZATMsg        DS
     D  ZAFOID                       20A
     D  ZATMES                       26A
     D  ZAMMOD                        2A
     D  ZATRID                        1A
     D  ZAACTN                        1A
     D  ZARESP                        1A
     D  ZARPRL                        1A
     D  ZACNFV                        1A
     D  ZASTAT                        1A
     D  ZAASOC                       20A
     D  ZAMSGS                       19S 0
     D  ZAMIDT                       50A
      *
     D WQMSGS          DS         32000
     D  APIACT                27     31
     D  APINME                46     49
      *
     D PSDS           SDS
     D  ##PGM            *PROC
     D  JOB                  244    253
     D  WSID                 244    246
     D  USER                 254    263
      ** Program Status Data Structure - gives Job/Workstation name and
      ** User ID
      *
     D LDA           E DS           256    EXTNAME(LDA)
     D  W24          E                     EXTFLD(SPARE)
      *
      ** Local data area for database error details
      ** *LOCK IN LDA immediately before and OUT LDA immediately
      ** after each database error handling.
      **                                    134 141 DBFILE
      **       Defines:                     142 170 DBKEY
      **                                    171 180 DBPGM
      **                                    181 1830DBASE
      **
      *
     D SDSTAT        E DS                  EXTNAME(SDSTAT) DTAARA(SDSTAT)
      *
     D Lib24x7         DS            10
     D Sys24x7                 1      2
     D DZ24x7                  3     10    INZ('DZLIB   ')
      *
     D SCSARD        E DS                  EXTNAME(SCSARDPD)
      *
      ** Data structure for rollover switch on file
     D DSFDY         E DS                  EXTNAME(DSFDY)
      *
      ** First DS for access programs, short data structure
      *
      *****************************************************************
     C/EJECT
      *****************************************************************
      *                                                               *
      *            MAIN     - Control Processing.                     *
      *                                                               *
      * CALLS      SRINIT   - Initial processing.                     *
      *                                                               *
      * CALLED BY         -                                           *
      *                                                               *
      *                                                               *
      *****************************************************************
      *
      ** If a record is added to T_APIMSG
      ** Write a record to API24X7SPD
      *
b1   C     QEVENT        IFEQ      '3'
      *
      ** Access API24X7SPD using MQMSID
      *
     C                   MOVEL     MQMSIA        KMQSID           19 0
      *
     C                   EVAL      SQLStmt = 'select * from '
     C                                      + %trim(LibDZ) + '/T_APIMSG '
     C                                      + 'where MQMSID = ' + MQMSIA_C

     C/exec SQL
     C+ prepare S1 from :SQLStmt
     C/end-exec

     C/exec SQL
     C+ declare C1 cursor for S1
     C/end-exec

     C/exec SQL
     C+ open C1
     C/end-exec

     C/exec SQL
     C+ fetch next from C1 into :DSAPIMsg
     C/end-exec

     C                   IF        SQLCOD <> 0 and SQLCOD <> 100
     C                   MOVEL     'SQLERROR'    WERROR
     C                   ENDIF

     C/exec SQL
     C+ close C1
     C/end-exec

     C                   EVAL      MQMSGN = APMSGS
     C                   eval      WQMSGS = MQMSGN
      *
     C     KMQSID        CHAIN     API24X7SL0                         71
b2   C                   IF        *IN71 = *on
      *
      *
      ** If record not found, then write record
     C                   EXSR      #PWRIT
e2   C                   ENDIF
e1   C                   ENDIF
      *
     C                   MOVE      '1'           *INLR
      *
      **   Exit from program
     C                   RETURN
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *    #PWRIT - Write record to PF/API24X7SPD                     *
      *                                                               *
      *****************************************************************
      *
     C     #PWRIT        BEGSR
      *
      ** Retrieve details from T_APIMSG
      ** to setup APMAPI
      *
      ** Set APMAPI based on
      ** if Customer                                                            CAP734
     C     CAP734        IFEQ      'Y'                                          CAP734
     C     APINME        ANDEQ     'CUSD'                                       CAP734
     C     APIACT        ANDEQ     'WRITE'                                      CAP734
     C                   MOVEL     '1CUSD'       APMAPI                         CAP734
     C                   MOVEL     MQMSGN        APXML                          CAP734
     C                   ENDIF                                                  CAP734
      ** if Account                                                             CAP735
     C     CAP735        IFEQ      'Y'                                          CAP735
     C     APINME        ANDEQ     'AMAD'                                       CAP735
     C     APIACT        ANDEQ     'WRITE'                                      CAP734
     C                   MOVEL     '2AMAD'       APMAPI                         CAP735
     C                   MOVEL     MQMSGN        APXML                          CAP735
     C                   ENDIF                                                  CAP735
      *
     C     APINME        IFEQ      'CUSD'                                       CAP734
     C     CAP734        ANDEQ     'Y'                                          CAP734
     C     APINME        OREQ      'AMAD'                                       CAP735
     C     CAP735        ANDEQ     'Y'                                          CAP735
     C     APIACT        IFEQ      'WRITE'
      *
      ** Write record to API24X7SPD
     C                   MOVEL     *BLANKS       APFOTR
     C                   MOVEL     *BLANKS       APMSGL
     C                   MOVEL     *BLANKS       APMMOD
      *
     C                   MOVEL     *BLANKS       APMIDT
     C                   MOVEL     *BLANKS       APTMP
     C                   MOVEL     *BLANKS       APACTN
     C                   MOVEL     *BLANKS       APRESP
     C                   MOVEL     *BLANKS       APRPRL
     C                   MOVEL     *BLANKS       APCNFV
     C                   MOVEL     *BLANKS       APSTAT
     C                   MOVEL     *BLANKS       APMQST
     C                   MOVEL     *BLANKS       APJRNS
      *
     C                   EVAL      SQLStmt = *BLANKS
     C                   EVAL      SQLStmt = 'select * from '
     C                                      + %trim(LibDZ) + '/ZATRNLOGPD '
     C                                      + 'where AAMSGLOGID = ' + MQMSIA_C

     C/exec SQL
     C+ prepare S2 from :SQLStmt
     C/end-exec

     C/exec SQL
     C+ declare C2 cursor for S2
     C/end-exec

     C/exec SQL
     C+ open C2
     C/end-exec

     C/exec SQL
     C+ fetch next from C2 into :DSZATMsg
     C/end-exec

     C                   IF        SQLCOD <> 0 and SQLCOD <> 100
     C                   MOVEL     'SQLERROR'    WERROR
     C                   ENDIF

     C/exec SQL
     C+ close C2
     C/end-exec

b3   C                   IF        ZASTAT = 'S'
     C                   MOVEL     ZAFOID        APFOTR
     C                   MOVEL     MQMSIA        APMSGL
     C                   MOVEL     ZAMMOD        APMMOD
      *
     C                   MOVEL     ZAMIDT        APMIDT
     C                   MOVEL     MQTMSA        APTMP
     C                   MOVEL     ZAACTN        APACTN
     C                   MOVEL     ZARESP        APRESP
     C                   MOVEL     ZARPRL        APRPRL
     C                   MOVEL     ZACNFV        APCNFV
     C                   MOVEL     *BLANKS       APSTAT
     C                   MOVEL     *BLANKS       APMQST
     C                   MOVEL     *BLANKS       APJRNS
     C                   MOVEL     *BLANKS       APSTAT
      *
     C                   WRITE     API24X7SD0
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF                                                  CAP734
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *            *INZSR - Initial Processing                        *
      *                                                               *
      * CALLS                                                         *
      *                                                               *
      * CALLED BY  MAIN   - Control Process                           *
      *                                                               *
      *****************************************************************
     C     *INZSR        BEGSR                                                  ** *INZSR **
      *
      ** Trigger Program parameters
     C     *ENTRY        PLIST
     C                   PARM                    QPARM1
     C                   PARM                    QPARM2
      *
      ** Set up copyright parameter
     C                   MOVEA     ARR@          CPY2@            80
      *
      ** Check CAP734 - 24X7 APIS Customer Details API                          CAP734
     C                   CALL      'AOSARDR0'                                   CAP734
     C                   PARM      '*MSG   '     @RTCD             7            CAP734
     C                   PARM      '*KEY   '     @OPTN             7            CAP734
     C                   PARM      'CAP734'      @SARD             6            CAP734
     C     SCSARD        PARM      SCSARD        DSFDY                          CAP734
      *                                                                         CAP734
     C     @RTCD         IFEQ      *BLANKS                                      CAP734
     C                   MOVE      'Y'           CAP734            1            CAP734
     C                   ELSE                                                   CAP734
     C                   MOVE      'N'           CAP734                         CAP734
     C                   ENDIF                                                  CAP734
      *
      ** Check CAP735 - 24X7 APIS GL Accounts API                               CAP735
     C                   CALL      'AOSARDR0'                                   CAP735
     C                   PARM      '*MSG   '     @RTCD             7            CAP735
     C                   PARM      '*KEY   '     @OPTN             7            CAP735
     C                   PARM      'CAP735'      @SARD             6            CAP735
     C     SCSARD        PARM      SCSARD        DSFDY                          CAP735
      *                                                                         CAP735
     C     @RTCD         IFEQ      *BLANKS                                      CAP735
     C                   MOVE      'Y'           CAP735            1            CAP735
     C                   ELSE                                                   CAP735
     C                   MOVE      'N'           CAP735                         CAP735
     C                   ENDIF                                                  CAP735
      *
     C                   IN        SDSTAT
     C                   MOVEL     LIBR          Sys24x7
     C                   MOVEL     Lib24x7       LibDZ            10
      *
      ** Using offsets and lengths provided get the before and after
      ** images
     C     Q1ROFF        ADD       1             Q                 5 0
     C     Q1RLEN        SUBST     QPARM1:Q      QFILEB
     C     Q2ROFF        ADD       1             Q
     C     Q2RLEN        SUBST     QPARM1:Q      QFILEA
      *
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
** ARR@
(C) Copyright Finastra International Limited 2020
