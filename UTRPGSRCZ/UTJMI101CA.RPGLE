     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2019')
      *****************************************************************
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('Midas UT Transfer Tax Rate Definitions')               *
      *****************************************************************
      *                                                               *
      *  Midas - Standing Data                                        *
      *                                                               *
      *  UTJMI101CA- Midas UT Transfer Tax Rate Definitions IPDS      *
      *                                                               *
      *  (c) Finastra Systems Technology, Inc. 2019                   *
      *                                                               *
      *  Last Amend No. JMI101A  *Create   Date 04Jul19               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  JMI101 - Tax Changes                                         *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  F U N C T I O N  O F  I N D I C A T O R S                    *
      *                                                               *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  S U B R O U T I N E  I N D E X                               *
      *                                                               *
      * *PSSR - Error processing                                      *
      * *INZSR - Initialise                                           *
      * SRAKEY - Account Key Processing                               *
      *                                                               *
      *****************************************************************

      * Midas SD Account Keys Detail
     FACKEYAL   IF   E             DISK    INFSR(*PSSR)
     F                                     USROPN
      *
      * Midas SD Account Keys Header
     FACKEYAK   UF   E           K DISK    INFSR(*PSSR)
     F                                     USROPN
      * Midas SD Account Keys Rtv
     FACKEYL0   IF   E           K DISK    INFSR(*PSSR)
     F                                     USROPN
     F                                     RENAME(ACKEYALF:ACKEYALFD)
     F                                     PREFIX(D)
      *
      * Midas SD Account Keys Update
     FXACKEYAL  O    E             DISK    INFSR(*PSSR)
     F                                     USROPN
     F                                     RENAME(ACKEYALF:ACKEYALF2)
     F                                     PREFIX(X)
      *
     D @RUN            S              1
     D ZWDTIN          S              8S 0
     D DateOut         S              8S 0
     D @@DAYN          S              5P 0
     D TimeStamp       S               Z
     D DSAKEY          S             14
      *
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
      ** Bank details
      *
     D DSFDY         E DS                  EXTNAME(DSFDY)
      ** First DS for access programs, short data structure
      *
     D DSSDY         E DS                  EXTNAME(DSSDY)
      ** First DS for access programs, long data structure
      *
     D LDA           E DS           256    EXTNAME(LDA)
      *
      ** Local data area for database error details
      ** *LOCK IN LDA immediately before and OUT LDA immediately
      ** after each database error handling.
      **
      **                                    134 141 DBFILE
      **       Defines:                     142 170 DBKEY
      **                                    171 180 DBPGM
      **                                    181 1830DBASE

      ** Main Processing
     C                   Exsr      SRAKEY
      *
     C                   RETURN
      /SPACE 5
      ********************************************************************
      * SRAKEY - Account Key Processing
      ********************************************************************
     C     SRAKEY        BEGSR

     C                   Z-ADD     0             COUNT             4 0
     C                   READ      ACKEYAL
     C                   DOW       NOT %EOF(ACKEYAL)
      *
      * Only process keys for deal types TD, IT and CD
     C                   IF        %SUBST(AKEY:1:2) = 'TD' or
     C                             %SUBST(AKEY:1:2) = 'IT' or
     C                             %SUBST(AKEY:1:2) = 'CD'
      *
      * For existing Maturity Interest key, write new Interest Paid Separately
      * key (so that it has same Dr side details as Maturity Interest key, and no CR details)
     C                   IF        %SUBST(AKEY:3:1) = 'R' and
     C                             %SUBST(AKEY:10:1) = 'I' and
     C                             %SUBST(AKEY:6:1) = ' '
     C                   EXSR      SRMOVE
     C                   EVAL      %SUBST(XAKEY:8:1) = 'G'
     C                   WRITE     ACKEYALF2
     C                   ADD       1             COUNT
     C                   ENDIF
      *
     C                   ENDIF
      *
     C                   READ      ACKEYAL
     C                   ENDDO
      *
     C                   CLOSE     ACKEYAL
     C                   CLOSE     XACKEYAL
     C                   CLOSE     ACKEYL0
     C                   OPEN      ACKEYAK
     C                   READ      ACKEYAK
     C                   ADD       COUNT         NREC1
     C                   ADD       COUNT         NINS
     C                   UPDATE    ACKEYAKF
     C                   CLOSE     ACKEYAK
      *
     C                   ENDSR

      *****************************************************************
      /SPACE 5
      *****************************************************************
      * SRMOVE - Subroutine to move fields from ACKEYAL to XACKEYAL   *
      *****************************************************************
     C     SRMOVE        BEGSR
      *
     C                   EVAL      XRECI = RECI
     C                   EVAL      XQQAKEY =  QQAKEY
     C                   EVAL      XZZ002 = ZZ002
     C                   EVAL      XACD2QQ = ACD2QQ
     C                   EVAL      XACD3QQ = ACD3QQ
     C                   EVAL      XACD5QQ = ACD5QQ
     C                   EVAL      XACD6QQ = ACD6QQ
     C                   EVAL      XNCD2 = NCD2
     C                   EVAL      XNCD3 = NCD3
     C                   EVAL      XNCD5 = NCD5
     C                   EVAL      XNCD6 = NCD6
     C                   EVAL      XPRF2 = PRF2
     C                   EVAL      XPRF3 = PRF3
     C                   EVAL      XPRF5 = PRF5
     C                   EVAL      XPRF6 = PRF6
     C                   EVAL      XZZ034 = ZZ034
     C                   EVAL      XLCD = LCD
     C                   EVAL      XCHTP = CHTP
     C                   EVAL      XTNLU = TNLU
     C                   EVAL      XACD2 = ACD2
     C                   EVAL      XACD3 = ACD3
     C                   EVAL      XACD5 = ACD5
     C                   EVAL      XACD6 = ACD6
     C                   EVAL      XAKEY = AKEY
     C                   EVAL      XZONE = ZONE
     C                   EVAL      XIUSR = IUSR
     C                   EVAL      XAUSR = AUSR
     C                   EVAL      XXUSR = XUSR
     C                   EVAL      XAACC = AACC
     C                   EVAL      XEACC = EACC
     C                   EVAL      XGPDT = GPDT
     C                   EVAL      XASQ2 = ASQ2
     C                   EVAL      XASQ3 = ASQ3
     C                   EVAL      XASQ5 = ASQ5
     C                   EVAL      XASQ6 = ASQ6
      *
     C                   Eval      DSAKEY = *Blanks
     C                   Eval      DSAKEY = AKEY
     C                   Eval      %SUBST(DSAKEY:3:1) = 'M'
     C     DSAKEY        Chain     ACKEYL0                            70
     C     *In70         Ifeq      *Off
     C                   EVAL      XACD1QQ = DACD1QQ
     C                   EVAL      XNCD1 = DNCD1
     C                   EVAL      XPRF1 = DPRF1
     C                   EVAL      XACD1 = DACD1
     C                   EVAL      XASQ1 = DASQ1
     C                   else
     C                   EVAL      XACD1QQ = 0
     C                   EVAL      XNCD1 = *Blank
     C                   EVAL      XPRF1 = 0
     C                   EVAL      XACD1 = 0
     C                   EVAL      XASQ1 = *Blank
     C                   Endif
      *
     C                   Eval      %SUBST(DSAKEY:10:1) = 'T'
     C                   Eval      %SUBST(DSAKEY:8:1) = 'G'
     C     DSAKEY        Chain     ACKEYL0                            70
     C     *In70         Ifeq      *Off
     C                   EVAL      XACD4QQ = DACD1QQ
     C                   EVAL      XNCD4 = DNCD1
     C                   EVAL      XPRF4 = DPRF1
     C                   EVAL      XACD4 = DACD1
     C                   EVAL      XASQ4 = DASQ1
     C                   else
     C                   EVAL      XACD4QQ = 0
     C                   EVAL      XNCD4 = *Blank
     C                   EVAL      XPRF4 = 0
     C                   EVAL      XACD4 = 0
     C                   EVAL      XASQ4 = *Blank
     C                   Endif
      *
     C                   ENDSR
      *****************************************************************
      /SPACE 5
      *****************************************************************
      * *INZSR - Program Initialisation routine                       *
      *****************************************************************
     C     *INZSR        BEGSR

      *
     C     *DTAARA       DEFINE                  LDA
      *
      ** Access Bank Details
      *
     C                   CALL      'AOBANKR0'
     C                   PARM      '*MSG   '     PRTCD             7
     C                   PARM      '*FIRST '     POPTN             7
     C     SDBANK        PARM      SDBANK        DSFDY
      *
     C     PRTCD         IFNE      *BLANKS
     C     *LOCK         IN        LDA
     C                   MOVEL     'SDBANKPD'    DBFILE
     C                   Z-ADD     001           DBASE
     C                   MOVEL     *BLANKS       DBKEY
     C                   MOVEL     'BANK'        DBKEY
     C                   MOVEL     'UTJMI101CA'  DBPGM
     C                   MOVE      '1'           *INU7
     C                   MOVE      '1'           *INU8
     C                   MOVE      '1'           *INLR
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
      *
     C                   OPEN      ACKEYAL
     C                   OPEN      XACKEYAL
     C                   OPEN      ACKEYL0
      *
     C                   ENDSR
      *****************************************************************
      /SPACE 5
      *****************************************************************
      *                                                               *
      * *PSSR  - Program exception error routine                      *
      *                                                               *
      *****************************************************************
     C     *PSSR         BEGSR

     C                   IF        @RUN = *BLANK
     C                   EVAL      @RUN = 'Y'
     C                   DUMP
     C                   ENDIF

     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   EVAL      *INLR = *ON
     C                   RETURN

     C                   ENDSR
      *****************************************************************
