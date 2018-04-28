     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2005')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas GO BSPL Request Conversion')
      *****************************************************************
      *                                                               *
      *  Midas - Global Processing Module                             *
      *                                                               *
      *  GOBSRQCVT - BSPL Request Conversion                          *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2005            *
      *                                                               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *  Last Amend No. CAS014             Date 10Aug05               *
      *  Prev Amend No. CGP010  *CREATE    Date 17Jan05               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CAS014 - IAS21 The Effects of Changes in Foreign Exchange    *
      *           Rates                                               *
      *  CGP010 - Global BSPL                                         *
      *                                                               *
      *****************************************************************
 
 
      ** CAS014 variables                                                                     CAS014
     D CAS014          S              1A                                                      CAS014
     D PRTCD           S              7                                                       CAS014
     D POPTN           S              7                                                       CAS014
     D PSARD           S              6                                                       CAS014
 
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
      ** Externally described DS for bank details
     D DSFDY         E DS                  EXTNAME(DSFDY)
      ** Second DS for access programs
 
 
      * BSPL Request - File Format
     D GPBSRQ        E DS                  EXTNAME(GPBSRQPD)
      * BSPL Request - Screen Format
     D GOBSRQ        E DS                  EXTNAME(GOBSRQPD)
      ** Switchable Feature descriptions                                                      CAS014
     D SCSARD        E DS                  EXTNAME(SCSARDPD)                                  CAS014
                                                                                              CAS014
     D LDA           E DS           256    EXTNAME(LDA)                                       CAS014
      *                                                                                       CAS014
      ** Local data area for database error details                                           CAS014
      ** *LOCK IN LDA immediately before and OUT LDA immediately                              CAS014
      ** after each database error handling.                                                  CAS014
      **                                                                                      CAS014
      **                                    134 141 DBFILE                                    CAS014
      **       Defines:                     142 170 DBKEY                                     CAS014
      **                                    171 180 DBPGM                                     CAS014
      **                                    181 1830DBASE                                     CAS014
      *                                                                                       CAS014
 
 
      * Clear outputs
 
     C                   CLEAR                   GOBSRQ
 
      * Convert Fields to Screen Format
 
     C                   EXSR      CNV2SCREEN
 
     C                   RETURN
 
      /SPACE 5
      ********************************************************************
      * Convert Fields to Screen Format
      ********************************************************************
     C     CNV2SCREEN    BEGSR
 
      * Request Type
 
     C                   MOVEL     SCRQTYP       DDRQTYP
 
      * Request ID
 
     C                   MOVE      SCRQID        DDRQID
 
      * Zone/Global Indicator
 
     C                   MOVEL     SCZNGL        DDZNGL
 
      * Zone to Run Report
 
     C                   MOVEL     SCZONE        DDZONE
 
      * Branch Code
 
     C                   MOVEL     SCBRC         DDBRC
 
      * Branch Group
 
     C                   MOVEL     SCBRGRP       DDBRGRP
 
      * Branch Consolidation
 
     C                   MOVEL     SCBRCON       DDBRCON
 
      * BSPL Report Set
 
     C                   MOVEL     SCRPSET       DDRPSET
 
      * Hierarchy Depth
 
     C                   MOVE      *ZERO         ZFIELD
     C                   MOVE      SCHDPTH       ZFIELD
     C                   EXSR      ZEDIT
     C                   MOVE      ZFIELD        DDHDPTH
 
      * Chart of Accounts
 
     C                   MOVEL     SCCHART       DDCHART
 
      * Relative Period Number
 
     C     SCRELPN       IFNE      *ZERO
     C                   MOVE      *ZERO         ZFIELD
     C                   MOVE      SCRELPN       ZFIELD
     C                   EXSR      ZEDIT
     C                   MOVE      ZFIELD        DDRELPN
     C                   ELSE
     C                   MOVE      *BLANK        DDRELPN
     C                   ENDIF
 
      * Calendar Year and Month
 
     C     SCCYR         IFNE      *ZERO
     C                   MOVE      *ZERO         ZFIELD
     C                   MOVE      SCCYR         ZFIELD
     C                   EXSR      ZEDIT
     C                   MOVE      ZFIELD        DDCYR
     C                   ELSE
     C                   MOVE      *BLANK        DDCYR
     C                   ENDIF
 
     C     SCCMTH        IFNE      *ZERO
     C                   MOVE      *ZERO         ZFIELD
     C                   MOVE      SCCMTH        ZFIELD
     C                   EXSR      ZEDIT
     C                   MOVE      ZFIELD        DDCMTH
     C                   ELSE
     C                   MOVE      *BLANK        DDCMTH
     C                   ENDIF
 
      * Report Type
 
     C                   MOVEL     SCRPTYP       DDRPTYP
 
      * Report Movement Duration
 
     C                   MOVEL     SCRMDUR       DDRMDUR
 
      * Interim Currency Details
 
     C                   MOVEL     SCINT         DDINT
     C                   MOVEL     SCINTCCY      DDINTCCY
     C                   MOVEL     SCINTCNV      DDINTCNV
     C                   MOVEL     SCINTCZN      DDINTCZN
 
      * Report Currency Details
 
     C                   MOVEL     SCREP         DDREP
     C                   MOVEL     SCREPCCY      DDREPCCY
     C                   MOVEL     SCREPCNV      DDREPCNV
     C                   MOVEL     SCREPCZN      DDREPCZN
 
      * A/c Code Breakdown
 
     C                   MOVEL     SCACDBD       DDACDBD
 
      * Print Zero Balances
 
     C                   MOVEL     SCPRTZB       DDPRTZB
 
      * Rounding
 
     C                   MOVEL     SCROUND       DDROUND
 
      * Include For. Ccy Transfer and Include Base Ccy Transfer
 
     C                   MOVEL     SCIFCTFR      DDIFCTFR
     C                   MOVEL     SCIBCTFR      DDIBCTFR
 
      * Instruction ID
 
     C                   MOVEL     SCINSID       DDINSID
 
      * Description
 
     C                   MOVEL     SCDESC        DDDESC
 
      * Export
 
     C                   MOVEL     SCEXPRT       DDEXPRT
 
      * Report Frequency
 
     C                   MOVEL     SCRFREQ       DDRFREQ
 
      * Report Day Number
 
     C     SCRDAYN       IFNE      *ZERO
     C                   MOVE      *ZERO         ZFIELD
     C                   MOVE      SCRDAYN       ZFIELD
     C                   EXSR      ZEDIT
     C                   MOVE      ZFIELD        DDRDAYN
     C                   ELSE
     C                   MOVE      *BLANK        DDRDAYN
     C                   ENDIF
 
      * (Next) Report Date
 
     C     SCRDATE       IFNE      *ZERO
     C                   Z-ADD     SCRDATE       ZDAYNO
     C                   EXSR      ZDATE2
     C                   MOVEL     ZDATEN        DDRDATE
     C                   ELSE
     C                   MOVE      *BLANK        DDRDATE
     C                   ENDIF
 
     C     CAS014        IFEQ      'Y'                                                        CAS014
                                                                                              CAS014
      ** Retrieve Interim Conversion of I/E Using Average Rates                               CAS014
                                                                                              CAS014
     C                   MOVEL     SCINCAV       DDINCAV                                      CAS014
                                                                                              CAS014
      ** Retrieve Interim Average Rate Period                                                 CAS014
                                                                                              CAS014
     C                   MOVEL     SCINAPD       DDINAPD                                      CAS014
                                                                                              CAS014
      ** Retrieve Interim Average Period End                                                  CAS014
                                                                                              CAS014
     C                   MOVEL     SCINAPE       DDINAPE                                      CAS014
                                                                                              CAS014
      ** Retrieve Reporting Conversion of I/E Using Average Rate                              CAS014
                                                                                              CAS014
     C                   MOVEL     SCRPCAV       DDRPCAV                                      CAS014
                                                                                              CAS014
      ** Retrieve Reporting Average Rate Period                                               CAS014
                                                                                              CAS014
     C                   MOVEL     SCRPAPD       DDRPAPD                                      CAS014
                                                                                              CAS014
      ** Retrieve Reporting Average Period End                                                CAS014
                                                                                              CAS014
     C                   MOVEL     SCRPAPE       DDRPAPE                                      CAS014
                                                                                              CAS014
     C                   ENDIF                                                                CAS014
     C                   ENDSR
      *********************************************************************
      /SPACE 5
      ********************************************************************
      * Edit an amount
      ********************************************************************
     C     ZEDIT         BEGSR
     C                   CALLB     'ZEDIT'
     C                   PARM                    ZFIELD           16
     C                   PARM      0             ZADEC             1 0
     C                   ENDSR
      *********************************************************************
      /SPACE 5
      ********************************************************************
      * Convert a day number into a date
      ********************************************************************
     C     ZDATE2        BEGSR
     C                   CALLB     'ZDATE2'
     C                   PARM                    ZDAYNO            5 0
     C                   PARM                    BJDFIN
     C                   PARM      *ZERO         ZDATEN            6 0
     C                   PARM      *BLANK        ZADATE            7
     C                   ENDSR
      *********************************************************************
      /SPACE 5
      *******************************************************************
      * *INZSR - Initial Processing
      *******************************************************************
     C     *INZSR        BEGSR
 
     C     *ENTRY        PLIST
     C                   PARM                    I#RTCD            7
     C                   PARM                    I#ERMS           50
 
      * BSPL Request - File Format
     C                   PARM                    GPBSRQ
 
      * OUTPUTS
 
      * BSPL Request - Screen Format
     C                   PARM                    GOBSRQ
 
 
      * Access Bank Details
 
     C                   CALL      'AOBANKR0'
     C                   PARM      '*DBERR  '    @RTCD             7
     C                   PARM      '*FIRST  '    @OPTN             7
     C     SDBANK        PARM      SDBANK        DSFDY
 
                                                                                              CAS014
     C     *DTAARA       DEFINE                  LDA                                          CAS014
                                                                                              CAS014
      ** Determine if CAS014 is switched on                                                   CAS014
                                                                                              CAS014
     C                   CALL      'AOSARDR0'                                                 CAS014
     C                   PARM      *BLANKS       PRTCD                                        CAS014
     C                   PARM      '*VERIFY'     POPTN                                        CAS014
     C                   PARM      'CAS014'      PSARD                                        CAS014
     C     SCSARD        PARM      SCSARD        DSFDY                                        CAS014
                                                                                              CAS014
     C                   EVAL      CAS014 = 'N'                                               CAS014
     C                   IF        PRTCD = *BLANKS                                            CAS014
     C                   EVAL      CAS014 = 'Y'                                               CAS014
     C                   ELSE                                                                 CAS014
                                                                                              CAS014
     C                   IF        PRTCD <> '*NRF   '                                         CAS014
     C     *LOCK         IN        LDA                                                        CAS014
     C                   EVAL      DBFILE = 'SCSARDPD'                                        CAS014
     C                   EVAL      DBASE = 01                                                 CAS014
     C                   EVAL      DBKEY = 'CAS014'                                           CAS014
     C                   OUT       LDA                                                        CAS014
                                                                                              CAS014
     C                   EXSR      *PSSR                                                      CAS014
     C                   ENDIF                                                                CAS014
     C                   ENDIF                                                                CAS014
 
     C                   ENDSR
      **********************************************************************************
      /SPACE 5
      ********************************************************************
      * * P S S R  --- A B N O R M A L   E R R O R   C O N D I T I O N S
      /COPY GOCPYSRC,GOPSSR
      *****************************************************************
