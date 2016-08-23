     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2001')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas FT Validate IP rate')                            *
      *****************************************************************
      *                                                               *
      *  Midas - Funds Transfer Module                                *
      *                                                               *
      *  FTVIRATE - Validate Rate                                     *
      *                                                               *
      *  Component of: FTIPAYSIN                                      *
      *                FTIPAYCTL                                      *
      *                FTIPAYRPR                                      *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2001            *
      *                                                               *
      *    This source is centrally supported and must ONLY be        *
      *    amended by Core Development Personnel.                     *
      *                                                               *
      *    /COPY, Client or Country amendments must not be            *
      *    applied to this source.                                    *
      *                                                               *
      *  Last Amend No. AR895223           Date 19Nov12               *
      *  Prev Amend No. CFT120             Date 28Sep12               *
      *                 CSF011A            Date 28Nov11               *
      *                 CER059             Date 19Jul10               *
      *                 CER030             Date 09Jul08               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      *                 244103             Date 03Dec06               *
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 242480             Date 11Oct06               *
      *                 CSD031             Date 10Apr06               *
      *                 CDL049             Date 06Jul06               *
      *                 CSD027             Date 09Dec05               *
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.05 -----------------------------------------------*
      *                 CFT009             Date 13Nov00               *
      * Midas DBA 3.04 -----------------------------------------------*
      *                 CFT014             Date 25May00               *
      * Midas DBA 3.03 -----------------------------------------------*
      *                 CAP136  *CREATE    Date 15Nov99               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  AR895223 - Exchange rates should allow 5 digits. Fix is to   *
      *             increase the number of digits to five. Applied    *
      *             fix 257663. (Child: AR895224)                     *
      *  CFT120 - FT IN/OP - Charges to DR of Account Currency        *
      *           (Recompile)                                         *
      *  CSF011A - CCR015: Display Order in Confirmation Pages        *
      *            (Recompile)                                        *
      *  CER059 - German Feature Upgrade to Delhi                     *
      *  CER030 - Multicash German Feature (Recompile)                *
      *  244103 - Pay amount and exchange rate are not shown by the   *
      *           system during insertion of Incoming Payments.       *
      *  242480 - Change error message for validation of Settle       *
      *           amount from FTA0044 to FTA0171.                     *
      *  CSD031 - Enhanced Centralised Static Data (Recompile)        *
      *  CDL049 - Addition of a Reference Rate field (recompile)      *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CFT009 - Funds Transfer Fees and Charges                     *
      *  CFT014 - Straight-through Processing Phase 2 MT103           *
      *           Messages Generation for FT.                         *
      *  CAP136 - Conversion of FT Incoming Payment inputs into       *
      *           modular structure to use as APIs.                   *
      *                                                               *
      *****************************************************************
      *
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
      *
     FPYCHGDB   IF   E           K DISK    INFSR(*PSSR)
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *
      ** +--------------------------------------+
      ** ¦ Automatically included D-specs       ¦
      ** ¦ ==============================       ¦
      ** +--------------------------------------+
      *
      ** Standard D-specs
      ** ================
      **
      ** The following /COPY line includes the LDA layout,
      ** the copyright array definition,
      ** and the following named constants:
      **    True       logical = *On (for indicator processing)
      **    False      logical = *Off (for indicator processing)
      **    DBErrCtl   10A     = 'DBERRCTL' (the name of the database error
      **                                    handler)
      ** and the following variables:
      **    RunBefore  1A (for the PSSR)
      *
      /COPY ZACPYSRC,STD_D_SPEC
      *
      ** Program Status Data Structure
      ** =============================
      ** The following /COPY line includes all the defined fields in the
      ** PSDS.  They have meaningful names, prefixed by 'PS'.
      *
      /COPY ZACPYSRC,PSDS
      *
      ** The following /COPY line includes all the definitions of the
      ** appended error arrays, including the named constant giving the size
      ** of the arrays.
      *
      /COPY ZACPYSRC,ERR_XARRYS
      *
      ** +--------------------------------------+
      ** ¦ End of automatically included D-specs¦
      ** ¦ =====================================¦
      ** +--------------------------------------+
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *
      ** +--------------------------------------+
      ** ¦ Manually included D-specs            ¦
      ** ¦ =========================            ¦
      ** +--------------------------------------+
      *
      ** +--------------------------------------+
      ** ¦ Named constants                      ¦
      ** ¦ ===============                      ¦
      ** +--------------------------------------+
      *
      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
      *
      ** Incoming Payments Lvl 1 Scrn details from incoming transaction
      ** - screen format
     D NwIP1ScnFmt   E DS                  EXTNAME(FTIPY1PD)
      *
      ** Incoming Payments Lvl 1 Scrn details retrieved from file
      ** - screen format
     D CrIP1ScnFmt   E DS                  EXTNAME(FTIPY1PD)
     D                                     PREFIX(O)
      *
      ** Incoming Payments for file update - file format
     D NwIPFilFmt    E DS                  EXTNAME(FTVIPAYPD)
      *
      ** Incoming Payments Lvl 1 Scrn error indicators
     D FTEIPY1       E DS                  EXTNAME(FTEIPY1PD)
      *
      ** External DS for Bank details
     D SDCURR        E DS                  EXTNAME(SDCURRPD)
      *
      ** External DS for FT Details
     D SDFTFR        E DS                  EXTNAME(SDFTFRPD)
     D  RATDIS                44     48  4
      *
      ** DS for access programs - Short data structure
     D DSFDY         E DS                  EXTNAME(DSFDY)
      *
      ** DS for access programs - Long data structure
     D DSSDY         E DS                  EXTNAME(DSSDY)
      /EJECT
      /COPY FTCPYSRC,FT0010D001
      *
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
      *
      *
     D ZalignOK        S              1
     D ZFIELD          S             16
     D ZADIG           S              2  0
     D ZADEC1          S              1  0
     D ZADEC2          S              2  0
     D ZMDIX           S              1
     D ZMDI1           S              1
     D ZMDI2           S              1
      *
     D POWER           S              7  3 DIM(7) CTDATA PERRCD(1)
      *
      ** Index for arrays of error message ids, etc.
     D IDx             S              3P 0
      *
      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *
      ** +--- Start of Main processing -------------------------------+
      ** ¦                                                            ¦
      ** ¦ *INZSR is executed at program activation.                  ¦
      ** ¦                                                            ¦
      ** +------------------------------------------------------------+
      *
      ** Initialise output parameters.
     C                   MOVEL     *Blanks       PPYBR             3
      *
      ** Initialise variables for update of Valid File fields.
     C                   Z-ADD     *Zeros        WRATE            13 8
     C                   Z-ADD     *Zeros        WSMAM            13 0
     C                   Z-ADD     *Zeros        WPYAM            13 0
     C                   Z-ADD     *Zeros        WNDAM            13 0          CFT014
     C                   Z-ADD     *ZERO         WMDIN             1 0
      *
      ** Initialise work variables.
      *
     C                   EVAL      IDx = 0
      *
      ** Validate Rate
      *
     C                   EXSR      SRValRate
      *
      ** If an error has been found, set return code appropriately.
      ** Otherwise, update Valid File fields.
      *
     C                   IF        OKRATE = 'N' or
     C                             OKSMAM = 'N' or
     C                             OKBRCA = 'N' or
     C                             OKORBR = 'N'
     C                   EVAL      RetCodeIn = 'ERROR'
     C                   ENDIF
      *
     C                   IF        OKRATE <> 'N' and
     C                             WRATE <> *Zeros
      *
     C                   Z-ADD     WRATE         IPRATE
 
     C                   Z-ADD     WMDIN         IPMDIN
 
     C                   IF        CFT009 = 'Y'                                 CFT009
     C                   IF        CEU006 = 'Y' OR CFT014 = 'Y'                 CFT009
     C                   Z-ADD     P#MDIN        IPMDIN                         CFT009
     C                   ENDIF                                                  CFT009
     C                   ENDIF                                                  CFT009
      *
      ** Setup settlement fields.
      *
     C     OKSMAM        IFNE      'N'
     C     OKSMCY        ANDNE     'N'
      *
     C                   Z-ADD     WSMAM         IPSMAM
      *
      ** Setup DAF Settle Amount, depending on number of decimal places
      ** in settle currency.
     C                   IF        PSetNumDP = *Zero
     C                   Z-ADD     IPSMAM        IPSMAMD
     C                   ELSE
      *
     C                   If        PSetNumDP = 1
     C     IPSMAM        DIV       10            IPSMAMD
     C                   Else
      *
     C                   If        PSetNumDP = 2
     C     IPSMAM        DIV       100           IPSMAMD
     C                   Else
     C     IPSMAM        DIV(H)    1000          IPSMAMD
     C                   EndIf
      *
     C                   EndIf
      *
     C                   ENDIF
      *
      ** Calculate settlement base currency equivalent
     C     PSetNumDp     SUB       PBCDP         Wn                1 0
     C                   ADD       4             Wn
     C                   IF        PSetMDIN = 0
     C     PSetSpotRat   MULT(H)   POWER(Wn)     WK159
     C     IPSMAM        DIV(H)    WK159         IPSBCQ
     C                   ELSE
     C     PSetSpotRat   DIV(H)    POWER(Wn)     WK159            15 9
     C     IPSMAM        MULT(H)   WK159         IPSBCQ
     C                   ENDIF
      *
     C                   ENDIF
      *
      ** Setup payment fields.
      *
     C     OKPYAM        IFNE      'N'
     C     OKPCCY        ANDNE     'N'
      *
     C                   Z-ADD     WPYAM         IPPYAM
      *
      ** Setup DAF Pay Amount, depending on number of decimal places
      ** in Pay Currency
     C                   IF        PPayNumDP = *Zero
     C                   Z-ADD     IPPYAM        IPPYAMD
     C                   ELSE
      *
     C                   If        PPayNumDP = 1
     C     IPPYAM        DIV       10            IPPYAMD
     C                   Else
      *
     C                   If        PPayNumDP = 2
     C     IPPYAM        DIV       100           IPPYAMD
     C                   Else
     C     IPPYAM        DIV(H)    1000          IPPYAMD
     C                   EndIf
      *
     C                   EndIf
      *
     C                   ENDIF
      *
      ** Calculate payment base currency equivalent
     C     PPayNumDp     SUB       PBCDP         Wn
     C                   ADD       4             Wn
     C                   IF        PPayMDIN  = 0
     C     PPaySpotRat   MULT(H)   POWER(Wn)     WK159
     C     IPPYAM        DIV(H)    WK159         IPPBCQ
     C                   ELSE
     C     PPaySpotRat   DIV(H)    POWER(Wn)     WK159
     C     IPPYAM        MULT(H)   WK159         IPPBCQ
     C                   ENDIF
      *
     C     IPPCCY        IFEQ      BJCYCD                                       B001           S0119
     C                   Z-ADD     IPPBCQ        IPSBCQ
     C                   ELSE                                                   X001
     C                   Z-ADD     IPSBCQ        IPPBCQ
     C                   ENDIF                                                  E001
      *
     C                   ENDIF
      *
      ** Setup DAF Rate
      *
     C                   If        IPMDIN = 1
     C                   Z-ADD     IPRATE        IPRATED
     C                   Else
     C     1             DIV(H)    IPRATE        IPRATED
     C                   EndIf
      *                                                                         CFT014
      ** Setup Instructed fields.                                               CFT014
      *                                                                         CFT014
     C     OKNDCY        IFNE      'N'                                          CFT014
     C     OKNDAM        ANDNE     'N'                                          CFT014
     C                   Z-ADD     WNDAM         IPNDAM                         CFT014
     C                   EndIf                                                  CFT014
      *
     C                   ELSE
      *
     C                   Z-ADD     *Zeros        IPRATE
     C                   Z-ADD     *Zeros        IPRATED
      *
     C                   ENDIF
      *
     C                   RETURN
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRVALRATE - Rate Validation                                  *
      *                                                               *
      *****************************************************************
     C     SRValRate     BEGSR
      *
      ** Only if amounts and currencies are Ok
      ** need payment charges record to validate rate
      ** and cannot access this with invalid originating branch
      *
     C                   IF        OKSMAM <> 'N' and
     C                             OKSMCY <> 'N' and
     C                             OKPYAM <> 'N' and
     C                             OKPCCY <> 'N' and
     C                             OKNDAM <> 'N' and
     C                             OKNDCY <> 'N' and
     C                             OKORBR <> 'N'
      *
     C                   EXSR      SRPYCHRG
      *
     C                   IF        CEU006 <> 'Y'
     C                             AND CFT014 <> 'Y'                            CFT014
      *
     C                   EXSR      SRRates
      *
     C                   ELSE
      *
      ** Check that rate has been entered in a valid format before
      ** FT0010 is called.
     C                   MOVE      *Blanks       ZFIELD
     C                   MOVE      DDRATE        ZFIELD
     C**********         EVAL      ZADIG = 4                                                AR895223
     C                   EVAL      ZADIG = 5                                                AR895223
     C                   EVAL      ZADEC1 = 8
      *
     C                   CALLB     'ZALIGN'
     C                   PARM                    ZalignOK
     C                   PARM                    ZFIELD
     C                   PARM                    ZADEC1
     C                   PARM                    ZADIG
      *
     C                   If        ZalignOK = 'N'
     C                   MOVE      'N'           OKRATE
     C                   Add       1             IDx
     C                   MOVEL     'DDRATE'      FldNamXAr(IDx)
     C                   MOVEL     'FTA0043'     MsgIdXAr(IDx)
     C                   Else
     C                   MOVE      ZFIELD        WRATE
     C                   EndIf
      *
     C                   ENDIF
      *
     C                   ENDIF
      **********                                                                              244103
      ***Check*if*both*amounts*entered*-*invalid*if*insert*mode*but****                       244103
      ***valid*otherwise*(Amend mode)*if*none*of*Settle*Amount,Pay*****                       244103
      ***Amount*&*Rate*have*been*altered.******************************                       244103
      **********                                                                              244103
     C**********         IF        CEU006 <> 'Y'                                              244103
     C**********                   AND CFT014 <> 'Y'                                   CFT014 244103
      **********                                                                              244103
     C**********         IF        DDSMAM <> *Blanks and                                      244103
     C**********                   DDPYAM <> *Blanks                                          244103
     C**********         If        DDACTN = 'I' or                                            244103
     C**********                   ODDSMAM <> DDSMAM or                                       244103
     C**********                   ODDPYAM <> DDPYAM or                                       244103
     C**********                   ODDRATE <> DDRATE                                          244103
     C**********         MOVE      'N'           OKSMAM                                       244103
     C**********         MOVE      'N'           OKPYAM                                       244103
     C**********         Add       1             IDx                                          244103
     C**********         MOVEL     'DDSMAM'      FldNamXAr(IDx)                               244103
     C**********         MOVEL     'FTA0044'     MsgIdXAr(IDx)                                242480
     C**********         MOVEL     'FTA0171'     MsgIdXAr(IDx)                         242480 244103
     C**********         EndIf                                                                244103
     C**********         ENDIF                                                                244103
      **********                                                                              244103
     C**********         ELSE                                                                 244103
      *
      ** Check that all amounts, currencies and rates are in valid
      ** format.
      *
     C                   IF        OKSMAM <> 'N' and
     C                             OKSMCY <> 'N' and
     C                             OKPYAM <> 'N' and
     C                             OKPCCY <> 'N' and
     C                             OKNDAM <> 'N' and
     C                             OKNDCY <> 'N' and
     C                             OKRATE <> 'N'
      *                                                                         CFT014
     C                   MOVE      *BLANKS       WFT10A            1            CFT014
     C                   MOVE      *BLANKS       WFT10B            1            CFT014
     C                   Z-ADD     IPNDAM        WNDAM                          CFT014
     C                   Z-ADD     IPNDAM        WPYAM                          CFT014
     C                   IF        CFT014 = 'N'                                 CFT014
     C                   EVAL      WFT10A = 'Y'                                 CFT014
     C                   ELSE                                                   CFT014
      *                                                                         CFT014
     C                   IF        IPNDAM = *ZERO                               CFT014
      *                                                                         CFT014
     C     CEU006        IFEQ      'Y'                                          CFT014
     C     PSetInCcy     ANDEQ     'Y'                                          CFT014
     C     DDNDCY        ANDEQ     BKEURO                                       CFT014
     C     CEU006        OREQ      'Y'                                          CFT014
     C     PInsInCcy     ANDEQ     'Y'                                          CFT014
     C     DDSMCY        ANDEQ     BKEURO                                       CFT014
     C                   MOVE      'Y'           WFT10A                         CFT014
      *                                                                         CFT014
     C                   ELSE                                                   CFT014
     C                   MOVE      'Y'           WFT10B                         CFT014
     C                   ENDIF                                                  CFT014
      *                                                                         CFT014
     C                   ENDIF                                                  CFT014
     C                   ENDIF                                                  CFT014
      *
      ** Set up parameters to call FT0010
     C***********        MOVE      *Blanks       P#0010                         CFT014
     C                   CLEAR                   P#0010                         CFT014
      *                                                                         CFT014
     C                   IF        WFT10A = 'Y'                                 CFT014
     C                   MOVE      DDNDCY        P#NDCY
     C                   Z-ADD     IPNDAM        P#NDAM
     C                   ENDIF                                                  CFT014
      *                                                                         CFT014
     C                   MOVE      DDSMCY        P#DBCY
     C                   Z-ADD     IPSMAM        P#DBAM
     C                   MOVE      DDPCCY        P#CRCY
     C                   Z-ADD     IPPYAM        P#CRAM
     C                   MOVE      *Blanks       P#PDCY
     C                   Z-ADD     *Zeros        P#PDAM
     C                   Z-ADD     IPSLDT        P#DBDT
     C                   Z-ADD     IPPVDT        P#CRDT
     C                   MOVE      WRATE         P#RATE
     C                   MOVE      IPOVRD        P#OVRT
     C                   MOVE      'Y'           P#SDIN
     C                   MOVE      BTPCRD        P#RTDS
     C                   EVAL      P#PMSQ = 'FTVIRATE'
     C                   MOVE      *Blanks       P#INDC
     C                   MOVE      *Blanks       P#RTCD
      *
     C                   CALL      'FT0010'
     C                   PARM                    P#0010
      *
      ** Database error handling.
      *
     C                   IF        P#RTCD = '*ERROR*'
      *
     C                   MOVEL     'FT0010  '    DBFILE
     C                   MOVEL     '020'         DBASE
     C                   MOVEL     '*FIRST '     DBKEY
     C                   EXSR      *PSSR
      *
     C                   ELSE
      *
      ** Check if validation error occurred. If not convert validated
      ** amounts to screen-ready format.
      *
     C                   IF        P#INDC = '00000'
      *
      ** Set Notified Currency Amount
     C***********        If        DDNDCY <> *Blanks                            CFT014
     C                   If        P#NDCY <> *Blanks                            CFT014
     C                   MOVE      P#NDAM        WNDAM                          CFT014
     C                   MOVE      *Blanks       ZFIELD
     C                   MOVE      P#NDAM        ZFIELD
     C                   Z-ADD     PNotNumDP     ZADEC2
      *
     C                   CALLB     'ZAEDITM'
     C                   PARM                    ZFIELD
     C                   PARM                    ZADEC2
      *
     C                   MOVE      ZFIELD        DDNDAM
     C***********        Else                                                   CFT014
     C***********        MOVE      *Blanks       DDNDAM                         CFT014
     C                   EndIf
      *
      ** Set Settlement Amount
     C                   MOVE      P#DBAM        WSMAM
     C                   MOVE      *Blanks       ZFIELD
     C                   MOVE      P#DBAM        ZFIELD
     C                   Z-ADD     PSetNumDP     ZADEC2
      *
     C                   CALLB     'ZAEDITM'
     C                   PARM                    ZFIELD
     C                   PARM                    ZADEC2
      *
     C                   IF        CFT009 = 'N'                                 CFT009
     C                             OR CFT009 = 'Y' AND DDSMAM <> *BLANK         CFT009
     C                             OR CFT009 = 'Y' AND DDSMAM = *BLANK          CFT009
     C                             AND DDRATE <> *BLANKS                        CFT009
     C                   MOVE      ZFIELD        DDSMAM
     C                   ENDIF                                                  CFT009
      *
      ** Set Payment Amount
     C                   MOVE      P#CRAM        WPYAM
     C                   MOVE      *Blanks       ZFIELD
     C                   MOVE      P#CRAM        ZFIELD
     C                   Z-ADD     PPayNumDP     ZADEC2
      *
     C                   CALLB     'ZAEDITM'
     C                   PARM                    ZFIELD
     C                   PARM                    ZADEC2
      *
     C                   IF        CFT009 = 'N'                                 CFT009
     C                             OR CFT009 = 'Y' AND DDPYAM <> *BLANK         CFT009
     C                             OR CFT009 = 'Y' AND DDPYAM = *BLANK          CFT009
     C                             AND DDRATE <> *BLANKS                        CFT009
     C                   MOVE      ZFIELD        DDPYAM
     C                   ENDIF                                                  CFT009
      *
      ** Set Rate
     C                   MOVE      P#RATE        WRATE
     C                   MOVE      *Blanks       ZFIELD
     C                   MOVE      P#RATE        ZFIELD
     C                   Z-ADD     8             ZADEC2
      *
     C                   CALLB     'ZAEDITM'
     C                   PARM                    ZFIELD
     C                   PARM                    ZADEC2
      *
     C                   IF        CFT009 = 'N' OR                              CFT009
     C                             CFT009 = 'Y' AND DDRATE <> *BLANKS           CFT009
     C                   MOVE      ZFIELD        DDRATE
     C                   ENDIF                                                  CFT009
      *
      ** Set Settle Value Date
     C                   Z-ADD     P#DBDT        ZDAYNO
     C                   CALLB     'ZDATE2'
     C                   PARM                    ZDAYNO            5 0
     C                   PARM      BJDFIN        ZDAYFM            1
     C                   PARM      *Zeros        ZDATE             6 0
     C                   PARM      *Blanks       ZADATE            7
      *
     C                   IF        CFT009 = 'N' OR                              CFT009
     C                             CFT009 = 'Y' AND DDSLDT <> *BLANKS           CFT009
     C                   MOVE      ZDATE         DDSLDT
     C                   ENDIF                                                  CFT009
      *
      ** Set Settle Value Date
     C                   Z-ADD     P#CRDT        ZDAYNO
     C                   CALLB     'ZDATE2'
     C                   PARM                    ZDAYNO
     C                   PARM      BJDFIN        ZDAYFM
     C                   PARM      *Zeros        ZDATE
     C                   PARM      *Blanks       ZADATE
      *
     C                   IF        CFT009 = 'N' OR                              CFT009
     C                             CFT009 = 'Y' AND DDPYDT <> *BLANKS           CFT009
     C                   MOVE      ZDATE         DDPYDT
     C                   ENDIF                                                  CFT009
      *
     C                   ELSE
      *
      ** Set up amount and rates fields as error fields
      ** From FT0010
      *
      ** Notified Delivery Amount
     C                   If        %subst(P#INDC:1:1) = '1'
     C                   MOVE      'N'           OKNDAM
     C                   EndIf
      *
      ** Settlement Amount
     C                   If        %subst(P#INDC:2:1) = '1'
     C                   MOVE      'N'           OKSMAM
     C                   EndIf
      *
      ** Payment Amount
     C                   If        %subst(P#INDC:3:1) = '1'
     C                   MOVE      'N'           OKPYAM
     C                   EndIf
      *
      ** Rate
     C                   If        %subst(P#INDC:5:1) = '1'
     C                   MOVE      'N'           OKRATE
     C                   EndIf
 
      * Set error message Ids from  FT0010
     C                   If        P#PMSQ = 'FTM2572   '
     C                   Add       1             Idx
     C                   MOVEL     'DDSMAM'      FldNamXAr(Idx)
     C                   MOVEL     'MMA1015'     MsgIdXAr(Idx)
     C                   EndIf
 
     C                   If        P#PMSQ = 'FTM2573   '
     C                   Add       1             Idx
     C                   MOVEL     'DDRATE'      FldNamXAr(Idx)
     C                   MOVEL     'MMA1016'     MsgIdXAr(Idx)
     C                   EndIf
 
     C                   If        P#PMSQ = 'FTM2574   '
     C                   Add       1             Idx
     C                   MOVEL     'DDRATE'      FldNamXAr(Idx)
     C                   MOVEL     'MMA1017'     MsgIdXAr(Idx)
     C                   EndIf
 
     C                   If        P#PMSQ = 'FTM2575   '
     C                   Add       1             Idx
     C                   MOVEL     'DDRATE'      FldNamXAr(Idx)
     C                   MOVEL     'MMA1018'     MsgIdXAr(Idx)
     C                   EndIf
 
     C                   If        P#PMSQ = 'FTM2577   '
     C                   Add       1             Idx
     C                   MOVEL     'DDRATE'      FldNamXAr(Idx)
     C                   MOVEL     'MMA1019'     MsgIdXAr(Idx)
     C                   EndIf
 
     C                   If        P#PMSQ = 'FTM2578   '
     C                   Add       1             Idx
     C                   MOVEL     'DDRATE'      FldNamXAr(Idx)
     C                   MOVEL     'MMA1020'     MsgIdXAr(Idx)
     C                   EndIf
 
     C                   If        P#PMSQ = 'FTM2579   '
     C                   Add       1             Idx
     C                   MOVEL     'DDSMAM'      FldNamXAr(Idx)
     C                   MOVEL     'MMA1021'     MsgIdXAr(Idx)
     C                   EndIf
 
     C                   If        P#PMSQ = 'FTM2580   '
     C                   Add       1             Idx
     C                   MOVEL     'DDSMAM'      FldNamXAr(Idx)
     C                   MOVEL     'MMA1022'     MsgIdXAr(Idx)
     C                   EndIf
 
     C                   If        P#PMSQ = 'FTM2581   '
     C                   Add       1             Idx
     C                   MOVEL     'DDPYAM'      FldNamXAr(Idx)
     C                   MOVEL     'MMA1023'     MsgIdXAr(Idx)
     C                   EndIf
 
     C                   If        P#PMSQ = 'FTM2582   '
     C                   Add       1             Idx
     C                   MOVEL     'DDPYAM'      FldNamXAr(Idx)
     C                   MOVEL     'MMA1023'     MsgIdXAr(Idx)
     C                   EndIf
 
     C                   If        P#PMSQ = 'FTM2583   '
     C                   Add       1             Idx
     C                   MOVEL     'DDPYAM'      FldNamXAr(Idx)
     C                   MOVEL     'MMA1024'     MsgIdXAr(Idx)
     C                   EndIf
 
     C                   If        P#PMSQ = 'FTM2587   '
     C                   Add       1             Idx
     C                   MOVEL     'DDRATE'      FldNamXAr(Idx)
     C                   MOVEL     'MMA1100'     MsgIdXAr(Idx)
     C                   EndIf
     C                   ENDIF
      *
     C                   ENDIF
      *                                                                         CFT014
     C                   IF        WFT10B = 'Y' and OKSMCY <> 'N' and           CFT014
     C                             DDNDCY <> *BLANKS                            CFT014
      *                                                                         CFT014
     C                   MOVE      *BLANKS       P#NDCY                         CFT014
     C                   Z-ADD     *ZEROS        P#NDAM                         CFT014
     C                   MOVE      DDPCCY        P#DBCY                         CFT014
     C                   Z-ADD     WPYAM         P#DBAM                         CFT014
     C                   MOVE      DDNDCY        P#CRCY                         CFT014
     C                   Z-ADD     WNDAM         P#CRAM                         CFT014
     C                   MOVE      *Blanks       P#PDCY                         CFT014
     C                   Z-ADD     *ZEROS        P#PDAM                         CFT014
     C                   Z-ADD     *ZEROS        P#DBDT                         CFT014
     C                   Z-ADD     *ZEROS        P#CRDT                         CFT014
     C                   MOVE      *ZEROS        P#RATE                         CFT014
     C                   MOVE      *BLANKS       P#OVRT                         CFT014
     C                   MOVE      *BLANKS       P#SDIN                         CFT014
     C                   MOVE      BTPCRD        P#RTDS                         CFT014
     C                   EVAL      P#PMSQ = 'FTVIRATE'                          CFT014
     C                   MOVE      *Blanks       P#INDC                         CFT014
     C                   MOVE      *Blanks       P#RTCD                         CFT014
      *                                                                         CFT014
     C                   CALL      'FT0010'                                     CFT014
     C                   PARM                    P#0010                         CFT014
      *                                                                         CFT014
      ** Database error handling.                                               CFT014
      *                                                                         CFT014
     C                   IF        P#RTCD = '*ERROR*'                           CFT014
     C                   MOVEL     'FT0010  '    DBFILE                         CFT014
     C                   MOVEL     '021'         DBASE                          CFT014
     C                   MOVEL     '*FIRST '     DBKEY                          CFT014
     C                   EXSR      *PSSR                                        CFT014
     C                   ENDIF                                                  CFT014
      *                                                                         CFT014
     C                   IF        P#INDC = '00000'                             CFT014
      *                                                                         CFT014
      ** Set Instructed Amount                                                  CFT014
     C                   MOVE      P#CRAM        WNDAM                          CFT014
     C                   MOVE      *Blanks       ZFIELD                         CFT014
     C                   MOVE      P#CRAM        ZFIELD                         CFT014
     C                   Z-ADD     PNotNumDP     ZADEC2                         CFT014
      *                                                                         CFT014
     C                   CALLB     'ZAEDITM'                                    CFT014
     C                   PARM                    ZFIELD                         CFT014
     C                   PARM                    ZADEC2                         CFT014
      *                                                                         CFT014
     C                   MOVE      ZFIELD        DDNDAM                         CFT014
      *                                                                         CFT014
     C                   ELSE                                                   CFT014
      *                                                                         CFT014
      ** Instructed Amount                                                      CFT014
     C                   If        %subst(P#INDC:3:1) = '1'                     CFT014
     C                   MOVE      'N'           OKNDAM                         CFT014
     C                   EndIf                                                  CFT014
      *                                                                         CFT014
      ** Payment Amount                                                         CFT014
     C                   If        %subst(P#INDC:2:1) = '1'                     CFT014
     C                   MOVE      'N'           OKPYAM                         CFT014
     C                   EndIf                                                  CFT014
                                                                                CFT014
      * Set error message Ids from  FT0010                                      CFT014
                                                                                CFT014
     C                   If        P#PMSQ = 'FTM2581   '                        CFT014
     C                   Add       1             Idx                            CFT014
     C                   MOVEL     'DDPYAM'      FldNamXAr(Idx)                 CFT014
     C                   MOVEL     'MMA1023'     MsgIdXAr(Idx)                  CFT014
     C                   EndIf                                                  CFT014
                                                                                CFT014
     C                   If        P#PMSQ = 'FTM2582   '                        CFT014
     C                   Add       1             Idx                            CFT014
     C                   MOVEL     'DDPYAM'      FldNamXAr(Idx)                 CFT014
     C                   MOVEL     'MMA1023'     MsgIdXAr(Idx)                  CFT014
     C                   EndIf                                                  CFT014
                                                                                CFT014
     C                   If        P#PMSQ = 'FTM2583   '                        CFT014
     C                   Add       1             Idx                            CFT014
     C                   MOVEL     'DDPYAM'      FldNamXAr(Idx)                 CFT014
     C                   MOVEL     'MMA1024'     MsgIdXAr(Idx)                  CFT014
     C                   EndIf                                                  CFT014
                                                                                CFT014
     C                   If        P#PMSQ = 'FTM2575   '                        CFT014
     C                   Add       1             Idx                            CFT014
     C                   MOVEL     'DDPYAM'      FldNamXAr(Idx)                 CFT014
     C                   MOVEL     'MMA1018'     MsgIdXAr(Idx)                  CFT014
     C                   EndIf                                                  CFT014
      *                                                                         CFT014
     C                   ENDIF                                                  CFT014
      *                                                                         CFT014
     C                   ENDIF                                                  CFT014
      *
     C                   ENDIF
      *
     C**********         ENDIF                                                                244103
      *
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRPYCHRG - Access PYCHGB file                                *
      *                                                               *
      *****************************************************************
     C     SRPYCHRG      BEGSR
      *
      ** If single branch mode, use single branch code from SDBANKPD
      *
     C                   IF        BGMBIN <> 'Y'
     C                   MOVE      BJSBRC        PPYBR
     C                   ELSE
      *
      ** Multibrached, Take originating branch if used otherwise
      ** take Booking Branch
      *
     C                   If        BKOBRU = 'Y'
     C                   MOVE      DDORBR        PPYBR
     C                   Else
     C                   MOVE      DDBRCA        PPYBR
     C                   EndIf
     C                   ENDIF
      *
     C     PPYBR         CHAIN     PYCHGDB                            99
      *
      ** Error if payment/charges record not found for branch
     C                   IF        *IN99 = *On
     C                             AND CFT009 = 'N'                             CFT009
      *
      ** If multi branch, highlight originating branch or booking branch
     C                   If        BGMBIN = 'Y' and
     C                             BKOBRU = 'Y'
      *
      ** Branch has no payment and charges details
     C                   MOVE      'N'           OKORBR
     C                   Add       1             IDx
     C                   MOVEL     'DDORBR'      FldNamXAr(IDx)
     C                   MOVEL     'FTM2001'     MsgIdXAr(IDx)
     C                   MOVEL     PPYBR         MsgDtaXAr
     C                   Else
      *
      ** Branch has no payment and charges details
     C                   MOVE      'N'           OKBRCA
     C                   Add       1             IDx
     C                   MOVEL     'DDBRCA'      FldNamXAr(IDx)
     C                   MOVEL     'FTM2001'     MsgIdXAr(IDx)
     C                   MOVEL     PPYBR         MsgDtaXAr
     C                   EndIf
      *
     C                   ELSE
      *
      ** Zeroise default cheque charge so it does not write to file
     C                   IF        CFT009 = 'N'                                 CFT009
     C                   Z-ADD     0             IPCQCH
     C                   ENDIF                                                  CFT009
      *
      ** Convert rate % discrepancy to higher & lower rate margins.
     C     1             ADD       RATDIS        UPMARG            7 4
     C     1             SUB       RATDIS        LWMARG            7 4
      *
     C                   ENDIF
      *
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRRATES - Rates Validation                                   *
      *            Optional Defaults to cross rate if regular         *
      *            payment not entered.                               *
      *                                                               *
      *****************************************************************
     C     SRRates       BEGSR
      *
      ** Check if settle or pay ccy amended and rate not altered.
      *
     C                   IF        DDACTN = 'A'
     C                   If        DDSMCY <> ODDSMCY or
     C                             DDPCCY <> ODDPCCY
     C                   If        DDRATE = ODDRATE
     C                   MOVE      'N'           OKRATE
     C                   Add       1             IDx
     C                   MOVEL     'DDRATE'      FldNamXAr(IDx)
     C                   MOVEL     'FTA0045'     MsgIdXAr(IDx)
     C                   EndIf
     C                   EndIf
     C                   ENDIF
      *
     C                   EXSR      SRRatDef
      *
     C                   IF        DDRATE = *Blanks
     C                   Z-ADD     DRATE         WRATE
     C                   Z-ADD     DMDIN         WMDIN
     C                   ELSE
      *
      ** Check if valid numeric
     C                   MOVE      *Blanks       ZFIELD
     C                   MOVE      DDRATE        ZFIELD
     C**********         EVAL      ZADIG = 4                                                AR895223
     C                   EVAL      ZADIG = 5                                                AR895223
     C                   EVAL      ZADEC1 = 8
      *
     C                   CALLB     'ZALIGN'
     C                   PARM                    ZalignOK
     C                   PARM                    ZFIELD
     C                   PARM                    ZADEC1
     C                   PARM                    ZADIG
      *
     C                   If        ZalignOK = 'N'
     C                   MOVE      'N'           OKRATE
     C                   Add       1             IDx
     C                   MOVEL     'DDRATE'      FldNamXAr(IDx)
     C                   MOVEL     'FTA0046'     MsgIdXAr(IDx)
     C                   Else
     C                   MOVE      ZFIELD        WRATE
     C                   Z-ADD     DMDIN         WMDIN
      *
     C                   If        DDOVRD <> 'Y' or
     C                             DDSMCY = DDPCCY and
     C                             DDOVRD = 'Y'
     C                   EXSR      SRRatVaL
     C                   EndIf
     C                   EndIf
     C                   ENDIF
      *
     C                   If        OKRATE = 'Y'
     C                   EXSR      SRRatCal
     C                   EndIf
      *
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRRATDEF - Default Rate Calculation                          *
      *                                                               *
      *****************************************************************
     C     SRRatDef      BEGSR
      *
      ** Setup to and from rates
      *
     C                   IF        IPSMAM = 0
     C                   MOVE      DDSMCY        TCCY              3
     C                   MOVE      DDPCCY        FCCY              3
     C                   Z-ADD     PSetBRat      TSRAT            13 8
     C                   Z-ADD     PSetMDIn      TMDIN             1 0
     C                   Z-ADD     PSetNumDP     TCDP              1 0
     C                   Z-ADD     PSetBRat      TBRAT            13 8
     C                   Z-ADD     PPaySRat      FBRAT            13 8
     C                   Z-ADD     PPayMDIn      FMDIN             1 0
     C                   Z-ADD     PPayNumDP     FCDP              1 0
     C                   ELSE
     C                   MOVE      DDSMCY        FCCY
     C                   MOVE      DDPCCY        TCCY
     C                   Z-ADD     PSetBRat      FBRAT            13 8
     C                   Z-ADD     PSetMDIn      FMDIN
     C                   Z-ADD     PPaySRat      TBRAT            13 8
     C                   Z-ADD     PSetNumDP     FCDP
     C                   Z-ADD     PPaySRat      TSRAT            13 8
     C                   Z-ADD     PPayMDIn      TMDIN
     C                   Z-ADD     PPayNumDP     TCDP
     C                   ENDIF
      *
      ** If currencies equal rate is 1.0
      *
     C                   IF        FCCY = TCCY
     C                   Z-ADD     1             DRATE            13 8
     C                   Z-ADD     0             DMDIN             1 0
      *
     C                   ELSE
      *
      ** If from currency is base rate is to currency
      *
     C                   IF        FCCY = BJCYCD
     C                   Z-ADD     TBRAT         DRATE
      *
     C                   If        DDPCCY = TCCY
     C     1             SUB       TMDIN         DMDIN
     C                   Else
     C                   Z-ADD     TMDIN         DMDIN
     C                   EndIF
      *
     C                   ELSE
      *
      ** If to currency is base rate is from currency
      *
     C                   IF        TCCY = BJCYCD
     C                   Z-ADD     FBRAT         DRATE
      *
     C                   If        DDPCCY = TCCY
     C                   Z-ADD     FMDIN         DMDIN
     C                   Else
     C     1             SUB       FMDIN         DMDIN
     C                   EndIf
      *
     C                   ELSE
      *
      ** If neither currency is base
      ** If both divide currencies
      *
     C                   IF        FMDIN = 0
     C                   IF        TMDIN = 0
      *
      ** Rate is to sell rate divide by from but rate
      *
     C     TSRAT         DIV(H)    FBRAT         DRATE
     C                   Z-ADD     1             DMDIN
      *
     C                   If        DRATE < 1
     C     FBRAT         DIV(H)    TSRAT         DRATE
     C                   Z-ADD     0             DMDIN
     C                   EndIf
      *
     C                   ELSE
     C     FBRAT         MULT(H)   TSRAT         DRATE
     C                   Z-ADD     0             DMDIN
      *
     C                   If        DRATE < 1
     C     1             DIV(H)    DRATE         DRATE
     C                   Z-ADD     1             DMDIN
     C                   EndIf
      *
     C                   ENDIF
      *
     C                   ELSE
      *
     C                   IF        TMDIN = 0
     C     TSRAT         MULT(H)   FBRAT         DRATE
     C                   Z-ADD     1             DMDIN
      *
     C                   If        DRATE < 1
     C     1             DIV(H)    DRATE         DRATE
     C                   Z-ADD     0             DMDIN
     C                   EndIf
      *
     C                   ELSE
     C     FBRAT         DIV(H)    TSRAT         DRATE
     C                   Z-ADD     1             DMDIN
      *
     C                   If        DRATE < 1
     C     TSRAT         DIV(H)    FBRAT         DRATE
     C                   Z-ADD     0             DMDIN
     C                   EndIf
      *
     C                   ENDIF
     C                   ENDIF
      *
     C                   If        IPSMAM = 0
     C     1             SUB       DMDIN         DMDIN
     C                   EndIf
      *
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
      *
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRRATVAL - Validate rate when entered.                       *
      *                                                               *
      *****************************************************************
     C     SRRatVal      BEGSR
      *
     C                   IF        DDSMCY = DDPCCY
      *
     C                   If        WRATE <> 1
     C                   MOVE      'N'           OKRATE
     C                   Add       1             IDx
     C                   MOVEL     'DDRATE'      FldNamXAr(IDx)
     C                   MOVEL     'FTA0047'     MsgIdXAr(IDx)
     C                   EndIf
      *
     C                   ELSE
      *
      ** Upper and lower limits are determined by % rate discrepancy
      ** from payment charges file.
     C     DRATE         MULT(H)   UPMARG        UPRATE           13 8
     C     DRATE         MULT(H)   LWMARG        DORATE           13 8
      *
     C                   IF        WRATE < DORATE or
     C                             WRATE > UPRATE
      *
      ** Entered rate may be Settle ccy/Pay ccy or vice versa
      **     (whichever is nearer the default rate(DRATE) is assumed)
     C     1             DIV       DRATE         DRATE
     C     DRATE         MULT(H)   UPMARG        UPRATE           13 8
     C     DRATE         MULT(H)   LWMARG        DORATE           13 8
      *
     C                   If        WRATE < DORATE or
     C                             WRATE > UPRATE
     C                   MOVE      'N'           OKRATE
     C                   Add       1             IDx
     C                   MOVEL     'DDRATE'      FldNamXAr(IDx)
     C                   MOVEL     'FTA0047'     MsgIdXAr(IDx)
     C                   Else
     C     1             SUB       WMDIN         WMDIN
     C                   EndIf
      *
     C                   ENDIF
     C                   ENDIF
      *
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRRATCAL - Validate value when rate is not entered.          *
      *                                                               *
      *****************************************************************
     C     SRRatCal      BEGSR
      *
     C                   Z-ADD     IPSMAM        WSMAM
     C                   Z-ADD     IPPYAM        WPYAM
      *
     C                   IF        IPSMAM = 0
     C     PPayNumDP     SUB       PSetNumDP     N                 1 0
     C                   ADD       4             N
      *
     C                   If        WMDIN = 1
     C     WRATE         MULT      POWER(N)      WK159
     C     IPPYAM        DIV(H)    WK159         WSMAM
     C                   Else
     C     WRATE         DIV(H)    POWER(N)      WK159            15 9
     C     IPPYAM        MULT(H)   WK159         WSMAM
     C                   EndIf
      *
     C                   ELSE
     C     PSetNumDP     SUB       PPayNumDP     N                 1 0
     C                   ADD       4             N
      *
     C                   If        WMDIN = 1
     C     WRATE         DIV(H)    POWER(N)      WK159            15 9
     C     IPSMAM        MULT(H)   WK159         WPYAM
     C                   Else
     C     WRATE         MULT      POWER(N)      WK159
     C     IPSMAM        DIV(H)    WK159         WPYAM
     C                   EndIf
      *
     C                   ENDIF
      *
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  *INZSR - Program Initialisation                              *
      *         - This subroutine runs automatically for program      *
      *           initialisation.                                     *
      *                                                               *
      *****************************************************************
      *
     C     *INZSR        BEGSR
      *
     C     *ENTRY        PLIST
      *
      ** INPUT
      ** =====
      *
      ** Return Code
     C                   PARM                    RetCodeIn
      *
      ** Incoming Payments Lvl 1 Scrn details from incoming transaction
      ** - screen format
     C                   PARM                    NwIP1ScnFmt
      *
      ** Incoming Payments Lvl 1 Scrn details retrieved from file
      ** - screen format
     C                   PARM                    CrIP1ScnFmt
      *
      ** Mode = '*FRONT' (Front Office Transaction Interface)
      ** Mode = '      ' (Not Front Office Transaction Interface)
      ** Mode = '*SIN  ' (SCREEN INPUT function)
     C                   PARM                    PMode             6
      *
      ** Base Currency No. of Decimal Places
     C                   PARM                    PBCDP             1 0
      *
      ** Notified Delivery Number of Decimal Places
     C                   PARM                    PNotNumDP         1 0
      *                                                                         CFT014
      ** Instructed In currency indicator                                       CFT014
     C                   PARM                    PInsInCcy         1            CFT014
      *
      ** Settlement Spot by Buy Spread
     C                   PARM                    PSetBRat         13 8
      *
      ** Settlement Number of Decimal Places
     C                   PARM                    PSetNumDP         1 0
      *
      ** Settlement Multiply/Divide indicator
     C                   PARM                    PSetMDIn          1 0
      *
      ** Settlement Spot Rate
     C                   PARM                    PSetSpotRat      13 8
      *                                                                         CFT014
      ** Settlement In currency indicator                                       CFT014
     C                   PARM                    PSetInCcy         1            CFT014
      *
      ** Payment Spot Rate by Sell Spread
     C                   PARM                    PPaySRat         13 8
      *
      ** Payment of Decimal Places
     C                   PARM                    PPayNumDP         1 0
      *
      ** Payment Multiply/Divide Indicator
     C                   PARM                    PPayMDIn          1 0
      *
      ** Payment Spot Rate
     C                   PARM                    PPaySpotRat      13 8
      *
      ** STANDING DATA
      ** =============
      *
      ** SDMMOD - Multi-Branching Indicator
     C                   PARM                    BGMBIN            1
      *
      ** SDGELR - Currency Code for Euro
     C                   PARM                    BKEURO            3
      *
      ** SDGELR - Originating Branch Used
     C                   PARM                    BKOBRU            1
      *
      ** SDBANK - Currency Code
     C                   PARM                    BJCYCD            3
      *
      ** SDBANK - Date Format Indicator
     C                   PARM                    BJDFIN            1
      *
      ** SDBANK - Banks Detail
     C                   PARM                    BJSBRC            3
      *
      ** SWITCHABLE FEATURES
      ** ===================
      *
      ** EMU FT Settlement Currency Conversion
     C                   PARM                    CEU006            1
      *                                                                         CFT014
      ** STP Phase 2 MT103                                                      CFT014
     C                   PARM                    CFT014            1            CFT014
      *                                                                         CFT009
      ** Fees & Charges                                                         CFT009
     C                   PARM                    CFT009            1            CFT009
      *
      ** OUTPUT
      ** ======
      *
      ** Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
      *
      ** Incoming Payments Lvl 1 Scrn error indicators
     C                   PARM                    FTEIPY1
      *
      ** Incoming Payments for file update - file format
     C                   PARM                    NwIPFilFmt
      *
      ** Branch Code - Alpha
     C                   PARM                    PPYBR
      *
      ** Retrieve Funds Transfer details
      *
     C                   CALL      'AOFTFRR0'
     C                   PARM      '*DBERR '     PRTCD             7
     C                   PARM      '*FIRST '     POPTN             7
     C     SDFTFR        PARM      SDFTFR        DSFDY
      *
      ** Program, module and procedure names for dbase error processing
      ** ==============================================================
      ** The following /COPY sets these values.
      *
      /COPY ZACPYSRC,DBFIELDS
      *
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *
      ** The following /COPY contains the standard program status
      ** subroutine, including a bound call to the DBERRCTL module.
      *
      /COPY ZACPYSRC,PSSR_ILE
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *
**CTDATA CPY@
(c) Misys International Banking Systems Ltd. 2001
**CTDATA POWER
0000001
0000010
0000100
0001000
0010000
0100000
1000000
