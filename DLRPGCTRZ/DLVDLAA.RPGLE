     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2012')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas DL Validate DLAA Fields')                        *
      *****************************************************************
      *                                                               *
      *  Midas - Dealing Module                                       *
      *                                                               *
      *  DLVDLAA  - Validate DLAA Fields                              *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2012            *
      *                                                               *
      *    This source is centrally supported and must ONLY be        *
      *    amended by Core Development Personnel                      *
      *                                                               *
      *    /COPY, Client or Country amendments must not be            *
      *    applied to this source.                                    *
      *                                                               *
      *  Last Amend No. CDL096             Date 22Sep14               *
      *  Prev Amend No. CDL094             Date 11Jun14               *
      *                 AR1096788          Date 18Mar13               *
      *                 CAP210  *CREATE    Date 28Sep12               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CDL096 - Business Day Conventions on MM Deals                *
      *           (Recompile)                                         *
      *  CDL094 - Enhance Receive Settlement Instructions             *
      *           (Recompiled)                                        *
      *  AR1096788 - DLAA details should be written in core STRANF    *
      *              file instead of the new DLSTRANFPD file          *
      *  CAP210 - Adjustment to Accrued Interests API                 *
      *                                                               *
      *****************************************************************
      *
     FDEALS     IF   E           K DISK    INFSR(*PSSR)
     F                                     USROPN
      *
      *****************************************************************
      **---------------------------------------------------------------
      ** The following /COPY line includes (among others) the LDA layout
      ** and the copyright array definition:
     D/COPY ZACPYSRC,STD_D_SPEC
      **---------------------------------------------------------------
 
      **---------------------------------------------------------------
      ** The following /COPY includes the MM standard declares:
     D/COPY ZACPYSRC,STDDECLARE
      **---------------------------------------------------------------
 
      **---------------------------------------------------------------
      ** The following /COPY line includes all the defined fields in the
      ** Program Status Data Structures.  They have meaningful
      ** names, prefixed by 'PS'.
     D/COPY ZACPYSRC,PSDS
      **---------------------------------------------------------------
      *
      **---------------------------------------------------------------
      ** The following /COPY line includes all the definitions of the
      ** appended error arrays, including the named constant giving the size
      ** of the arrays.
     D/COPY ZACPYSRC,ERR_XARRYS
      **---------------------------------------------------------------
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *
     D ZA1             S              1    DIM(16)
     D ZA2             S              1    DIM(16)
     D IRTYP           S              2    DIM(6) CTDATA PERRCD(6)
      *
     D TrnDets       E DS                  EXTNAME(DLDLAAPD)
     D TrnDetsOK     E DS                  EXTNAME(DLEDLAAPD)
      ** Transaction Details in Screen Format
      *
     D DSFDY         E DS                  EXTNAME(DSFDY)
      ** Firsy DS For access objects, short data structure
      *
     D @CURR         E DS                  EXTNAME(SDCURRPD)
     D @CUST         E DS                  EXTNAME(SDCUSTPD)
     D @MMOD         E DS                  EXTNAME(SDMMODPD)
      ** EXTERNAL DS FOR BANK DETAILS
     D @BANK         E DS                  EXTNAME(SDBANKPD)
     D SCSARD        E DS                  EXTNAME(SCSARDPD)
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
      *
     D CIR002          S              1A
     D CIR006          S              1A
     DDSBrcTyp         DS                                                                  AR1096788
     D DDBRCA                         3A                                                   AR1096788
     D DDDTYP                         2A                                                   AR1096788
      *
      ** Index for arrays of error message ids etc
      *
     D Idx             S              3P 0
     D WIdx            S              3P 0
      *
      *****************************************************************
      /EJECT
      *****************************************************************
     C
      ** +--- Start of Main processing -----------------------------------+
      ** ¦                                                                ¦
      ** ¦ Initial processing is performed automatically: the *INZSR is   ¦
      ** ¦ executed at program activation.                                ¦
      ** ¦                                                                ¦
      ** +----------------------------------------------------------------+
      *
      ** Initialization
      *
     C                   OPEN      DEALS
     C                   MOVE      *BLANK        RetCodeIn
      *
     C                   MOVE      *BLANK        FldNamXAr
     C                   MOVE      *BLANK        MsgIDXAr
     C                   MOVE      *BLANK        MsgDtaXAr
     C                   Z-ADD     0             Idx
     C                   Z-ADD     0             WIdx
      *
      ** Validate for DDDLNO
      *
     C                   EXSR      VSDLNO
      *
      ** Validate for DDCNUM
      *
     C                   EXSR      VSCNUM
      *
      ** Validate for DDMAAM
      *
     C                   EXSR      VSMAAM
      *
      ** Validate for DDCCY
      *
     C                   EXSR      VSSIGN
      *
      ** Validate for DDCCY
      *
     C                   EXSR      VSCCY
      *
      ** Validate for DDINIRS
      *
     C                   EXSR      VSINIR
      *
      ** Validate Unsettled Interest
      *
     C                   EXSR      VSUSIT
      *
      ** Validate COF Adjustment Amount
      *
     C                   EXSR      VSAACF
      *
      ** Validate COF Adjustment Amount
      *
     C                   EXSR      VSFSGN
     C                   CLOSE     DEALS
      *
     C                   RETURN
      *****************************************************************
     C/EJECT
      *****************************************************************
      * VSDLNO - Validate For DDDLNO                                  *
      *****************************************************************
     C     VSDLNO        BEGSR
      *
      ** Deal to be adjusted is mandatory
      *
     C                   IF        DDDLNO = *BLANK
      *
     C                   EVAL      DDDLNOOK = 'N'
     C                   EVAL      Idx = Idx + 1
     C                   EVAL      FldNamXAr(Idx) = 'DDDLNO    '
     C                   EVAL      MsgIdXAr(Idx) = 'DLAA001'
     C                   LEAVESR
     C                   ENDIF
      *
      ** Deal to be adjusted must exist
      *
     C                   MOVE      DDDLNO        DLKEY             6 0
     C     DLKEY         CHAIN     DEALS
     C                   IF        Not %Found
     C                   EVAL      DDDLNOOK = 'N'
     C                   EVAL      Idx = Idx + 1
     C                   EVAL      FldNamXAr(Idx) = 'DDDLNO    '
     C                   EVAL      MsgIdXAr(Idx) = 'DLAA001'
     C                   LEAVESR
     C                   ENDIF
      *
      ** Prevent Adjustments to non MMLN and NASP deals
      *
     C                   IF        RECI = 'D'
     C                             and RCDT = 'C'
     C                             or RECI = 'D'
     C                             and RCDT = 'D'
     C                             or RECI = 'D'
     C                             and RCDT = 'G'
     C                             or RECI = 'M'
     C                             and RCDT = 'C'
     C                   ELSE
      *
     C                   EVAL      DDDLNOOK = 'N'
     C                   EVAL      Idx = Idx + 1
     C                   EVAL      FldNamXAr(Idx) = 'DDDLNO    '
     C                   EVAL      MsgIdXAr(Idx) = 'DLAA001'
     C                   LEAVESR
     C                   ENDIF
      *
      ** Prevent Adjustments to Internal Deals
      *
     C                   IF        DTYP = 'IL'
     C                             or DTYP = 'ID'
 
     C                   EVAL      DDDLNOOK = 'N'
     C                   EVAL      Idx = Idx + 1
     C                   EVAL      FldNamXAr(Idx) = 'DDDLNO    '
     C                   EVAL      MsgIdXAr(Idx) = 'DLAA001'
     C                   LEAVESR
     C                   ENDIF
      *
      ** Allow Adjustment of Freq N Deal with NIDT<>0
      *
     C                   IF        RECI = 'M'
     C                             and RCDT = 'C'
     C                   EVAL      DDDLNOOK = 'N'
     C                   IF        IPFR = 'N'
     C                             and NIDT <> 0
     C                   EVAL      DDDLNOOK = 'Y'
     C                   ELSE
     C                   EVAL      Idx = Idx + 1
     C                   EVAL      FldNamXAr(Idx) = 'DDDLNO    '
     C                   EVAL      MsgIdXAr(Idx) = 'DLAA001'
     C                   LEAVESR
     C                   ENDIF
     C                   ENDIF
      *
      ** If Deal Type 'FR' the process differently
      *
     C                   IF        DTYP = 'FR'
      *
      ** If value date >= run date the adjustment is valid
      *
     C                   IF        VDAT >= BJRDNB
      *
      ** If our base rate type is <> 0 and our interest fix date < run date
      ** or our base rate type is  0 and their interest fix date < run date the
      ** adjustment is valid
      *
     C                   IF        UBRTT <> 0
     C                             and UINFD < BJRDNB
     C                             or UBRTT = 0
     C                             and TINFD < BJRDNB
     C                   ELSE
     C                   EVAL      DDDLNOOK = 'N'
     C                   EVAL      Idx = Idx + 1
     C                   EVAL      FldNamXAr(Idx) = 'DDDLNO    '
     C                   EVAL      MsgIdXAr(Idx) = 'DLAA002'
     C                   LEAVESR
     C                   ENDIF
      *
     C                   ELSE
     C                   EVAL      DDDLNOOK = 'N'
     C                   EVAL      Idx = Idx + 1
     C                   EVAL      FldNamXAr(Idx) = 'DDDLNO    '
     C                   EVAL      MsgIdXAr(Idx) = 'DLAA003'
     C                   LEAVESR
     C                   ENDIF
     C                   ELSE
      *
     C                   IF        VDAT > BJRDNB
     C                             or VDAT <= BJRDNB
     C                             and RECI = 'D'
     C                             and RCDT = 'D'
     C                             and INTR = 0
     C                   EVAL      DDDLNOOK = 'N'
     C                   EVAL      Idx = Idx + 1
     C                   EVAL      FldNamXAr(Idx) = 'DDDLNO    '
     C                   EVAL      MsgIdXAr(Idx) = 'DLAA001'
     C                   LEAVESR
     C                   ENDIF
     C                   ENDIF
      *
     C                   EVAL      DDBRCA = BRCA                                           AR1096788
     C                   EVAL      DDDTYP = DTYP                                           AR1096788
      *                                                                                    AR1096788
     C                   ENDSR
      *****************************************************************
     C/EJECT
      *****************************************************************
      * VSCNUM - Validate For DDCNUM                                  *
      *****************************************************************
     C     VSCNUM        BEGSR
      *
      ** Customer of deal to be adjusted is mandatory
      *
     C                   IF        DDCNUM = *BLANK
 
     C                   EVAL      DDCNUMOK = 'N'
     C                   EVAL      Idx = Idx + 1
     C                   EVAL      FldNamXAr(Idx) = 'DDCNUM    '
     C                   EVAL      MsgIdXAr(Idx) = 'DLAA004'
     C                   LEAVESR
     C                   ENDIF
      *
      ** Check if customer number is numeric or 10 Alpha
      *
     C                   EVAL      ZFIELD = *blanks
     C                   EVALR     ZFIELD = DDCNUM
     C                   EVAL      ZADIG = 6
     C                   EVAL      ZADEC = 0
     C                   EXSR      ZALIGN
      *
      ** Numeric field detected
      *
     C                   IF        not *IN99
     C                   MOVEL     DDCNUM        NUMCUS            6
     C                   IF        NUMCUS <> CNUM
     C                   EVAL      DDCNUMOK = 'N'
     C                   EVAL      Idx = Idx + 1
     C                   EVAL      FldNamXAr(Idx) = 'DDCNUM    '
     C                   EVAL      MsgIdXAr(Idx) = 'DLAA004'
     C                   LEAVESR
     C                   ENDIF
     C                   ENDIF
      *
     C                   IF        *IN99
     C                   CALL      'AOCUSTR0'
     C                   PARM      '*MSG   '     @RTCD
     C                   PARM      '*KEY   '     @OPTN
     C                   PARM      DDCNUM        @KEY1            10
     C                   PARM      *BLANKS       @KYST             7
     C     @CUST         PARM      @CUST         DSFDY
      *
     C     @RTCD         IFNE      *BLANK
     C                   EVAL      DDCNUMOK = 'N'
     C                   EVAL      Idx = Idx + 1
     C                   EVAL      FldNamXAr(Idx) = 'DDCNUM    '
     C                   EVAL      MsgIdXAr(Idx) = 'DLAA004'
     C                   LEAVESR
     C                   ELSE
      *
     C                   MOVEL     BBCUST        NUMCUS
     C                   IF        NUMCUS <> CNUM
     C                   EVAL      DDCNUMOK = 'N'
     C                   EVAL      Idx = Idx + 1
     C                   EVAL      FldNamXAr(Idx) = 'DDCNUM    '
     C                   EVAL      MsgIdXAr(Idx) = 'DLAA004'
     C                   LEAVESR
     C                   ELSE
     C                   MOVE      *blanks       DDCNUM
     C                   MOVEL     BBCUST        DDCNUM
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
      *
     C                   ENDSR
      *****************************************************************
     C/EJECT
      *****************************************************************
      * VSINIR - Validate For DDINIRS                                 *
      *****************************************************************
     C     VSINIR        BEGSR
      *
      ** IF Deal Type is not FRA/IRS (FR,RS,RX,RR,RP,RF) then
      ** IND must be ' '
      *
     C     DTYP          LOOKUP    IRTYP                                  99
     C                   IF        not %FOUND
     C                   IF        DDINIRS <> ' '
     C                   EVAL      DDINIRSOK = 'N'
     C                   EVAL      Idx = Idx + 1
     C                   EVAL      FldNamXAr(Idx) = 'DDINIRS   '
     C                   EVAL      MsgIdXAr(Idx) = 'DLAA009'
     C                   LEAVESR
     C                   ENDIF
     C                   ENDIF
      *
      ** If Deal Type is 'FR' then IND decided by Effective Interest Date
      *
     C                   IF        %FOUND
     C                   IF        DTYP = 'FR'
     C                   IF        UEINR >= TEINR
     C                             and DDINIRS <> 'O'
     C                             or UEINR < TEINR
     C                             and DDINIRS <> 'T'
     C                   EVAL      DDINIRSOK = 'N'
     C                   EVAL      Idx = Idx + 1
     C                   EVAL      FldNamXAr(Idx) = 'DDINIRS   '
     C                   EVAL      MsgIdXAr(Idx) = 'DLAA010'
     C                   MOVE      UCUCY         CCY
     C                   LEAVESR
     C                   ENDIF
     C                   ELSE
      *
      ** Deal Type is 'RS','RR','RP','RF' OR 'RX'
      *
     C                   IF        DDINIRS <> 'O'
     C                             and DDINIRS <> 'T'
     C                   EVAL      DDINIRSOK = 'N'
     C                   EVAL      Idx = Idx + 1
     C                   EVAL      FldNamXAr(Idx) = 'DDINIRS   '
     C                   EVAL      MsgIdXAr(Idx) = 'DLAA008'
     C                   MOVE      UCUCY         CCY
     C                   LEAVESR
     C                   ENDIF
      *
      **  If Cross Currency SWAP use their currency
      *
     C                   IF        DTYP = 'RX'
     C                             and DDINIRS = 'T'
     C                   MOVE      TCUCY         CCY
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
      *
     C                   ENDSR
      *****************************************************************
     C/EJECT
      *****************************************************************
      * VSMAAM - Validate For DDMAAM                                  *
      *****************************************************************
     C     VSMAAM        BEGSR
      *
      ** Validate adjustment - obtain correct no of decimal places
      *
      ** Call access object for currency details
      *
     C                   IF        DDMAAM <> *blanks
     C                   CALL      'AOCURRR0'
     C                   PARM      '        '    @RTCD
     C                   PARM      '*KEY    '    @OPTN
     C                   PARM                    DDCCY
     C     @CURR         PARM      @CURR         DSFDY
      *
     C                   IF        @RTCD = *blanks
     C                   EVAL      ZFIELD = *blanks
     C                   EVALR     ZFIELD = DDMAAM
     C                   Z-ADD     A6NBDP        ZADEC
     C     13            SUB       A6NBDP        ZADIG
     C                   EXSR      ZALIGN
     C                   ENDIF
      *
     C                   IF        @RTCD <> *blanks
     C                             or *IN99
     C                   EVAL      DDMAAMOK = 'N'
     C                   EVAL      Idx = Idx + 1
     C                   EVAL      FldNamXAr(Idx) = 'DDMAAM    '
     C                   EVAL      MsgIdXAr(Idx) = 'DLAA005'
     C                   LEAVESR
     C                   ELSE
     C                   Z-ADD     0             OTADJ            13 0
     C                   MOVE      ZFIELD        OTADJ
     C                   ENDIF
     C                   ENDIF
      *
     C                   SELECT
     C                   WHEN      BGN0ST = 'Y'
     C                   SELECT
      *
     C                   WHEN      CIR002 = 'Y'
     C                             or CIR006 = 'Y'
     C                   IF        DDMAAM     = *blanks
     C                             and DDUSIT = *blanks
     C                             and DDAACF = *blanks
     C                   EVAL      DDMAAMOK = 'N'
     C                   EVAL      Idx = Idx + 1
     C                   EVAL      FldNamXAr(Idx) = 'DDMAAM    '
     C                   EVAL      MsgIdXAr(Idx) = 'DLAA005'
     C                   LEAVESR
     C                   ENDIF
      *
     C                   WHEN      CIR002 = 'N'
     C                             or CIR006 = 'N'
     C                   IF        DDMAAM = *blanks
     C                             and DDAACF = *blanks
     C                   EVAL      DDMAAMOK = 'N'
     C                   EVAL      Idx = Idx + 1
     C                   EVAL      FldNamXAr(Idx) = 'DDMAAM    '
     C                   EVAL      MsgIdXAr(Idx) = 'DLAA005'
     C                   LEAVESR
     C                   ENDIF
     C                   ENDSL
     C                   OTHER
      *
     C                   SELECT
      *
     C                   WHEN      CIR002 = 'Y'
     C                             or CIR006 = 'Y'
     C                   IF        DDMAAM = *blanks
     C                             and DDUSIT = *blanks
     C                   EVAL      DDMAAMOK = 'N'
     C                   EVAL      Idx = Idx + 1
     C                   EVAL      FldNamXAr(Idx) = 'DDMAAM    '
     C                   EVAL      MsgIdXAr(Idx) = 'DLAA005'
     C                   LEAVESR
     C                   ENDIF
      *
     C                   WHEN      CIR002 = 'N'
     C                             or CIR006 = 'N'
     C                   IF        DDMAAM = *blanks
     C                   EVAL      DDMAAMOK = 'N'
     C                   EVAL      Idx = Idx + 1
     C                   EVAL      FldNamXAr(Idx) = 'DDMAAM    '
     C                   EVAL      MsgIdXAr(Idx) = 'DLAA005'
     C                   LEAVESR
     C                   ENDIF
     C                   ENDSL
     C                   ENDSL
      *
     C                   ENDSR
      *****************************************************************
     C/EJECT
      *****************************************************************
      * VSSIGN - Validate Sign                                        *
      *****************************************************************
     C     VSSIGN        BEGSR
      *
      ** Validate Sign
      *
     C                   IF        CIR002 = 'Y'
     C                             or CIR006 = 'Y'
     C                             or BGN0ST = 'Y'
     C                   IF        DDMAAM <> *blank
     C                             and DDSIGN <> '+'
     C                             and DDSIGN <> '-'
     C                             or DDMAAM = *blanks
     C                             and DDSIGN <> ' '
      *
     C                   EVAL      DDSIGNOK = 'N'
     C                   EVAL      Idx = Idx + 1
     C                   EVAL      FldNamXAr(Idx) = 'DDSIGN  '
     C                   EVAL      MsgIdXAr(Idx) = 'DLAA006'
     C                   ELSE
     C                   If        DDMAAM     = *blanks
     C                             and DDUSIT = *blanks
     C                             and DDAACF = *blanks
     C                             and DDSIGN =  ' '
      *
     C                   EVAL      DDSIGNOK = 'N'
     C                   EVAL      Idx = Idx + 1
     C                   EVAL      FldNamXAr(Idx) = 'DDSIGN  '
     C                   EVAL      MsgIdXAr(Idx) = 'DLAA006'
     C                   ENDIF
     C                   ENDIF
     C                   ELSE
      *
     C                   IF        DDSIGN <> '+'
     C                             and DDSIGN <> '-'
     C                   EVAL      DDSIGNOK = 'N'
     C                   EVAL      Idx = Idx + 1
     C                   EVAL      FldNamXAr(Idx) = 'DDSIGN  '
     C                   EVAL      MsgIdXAr(Idx) = 'DLAA006'
     C                   ENDIF
     C                   ENDIF
     C                   ENDSR
      *****************************************************************
     C/EJECT
      *****************************************************************
      * VSCCY  - Validate Currency                                    *
      *****************************************************************
     C     VSCCY         BEGSR
      *
      ** Get correct currency
      *
     C                   EXSR      VSGCCY
      *
      ** Validate Currency
      *
     C                   IF        DDCCY  = *BLANK
     C                             or DDCCY <> CCY
     C                   EVAL      DDCCYOK = 'N'
     C                   EVAL      Idx = Idx + 1
     C                   EVAL      FldNamXAr(Idx) = 'DDCCY    '
     C                   EVAL      MsgIdXAr(Idx) = 'DLAA007'
     C                   ENDIF
     C                   ENDSR
      *****************************************************************
     C/EJECT
      *****************************************************************
      * VSAACF - Validate For COF Adjustment Amount                   *
      *****************************************************************
     C     VSAACF        BEGSR
      *
      *
      ** Validate COF Adjustment Amount
      *
      ** if Analytical Accounting Module is switched on
      *
     C                   IF        BGN0ST = 'Y'
     C                   IF        DDAACF <> *blanks
     C                   IF        RECI = 'D'
     C                             and RCDT = 'C'
     C                             and FPRC = *blanks
     C                             or RECI = 'D'
     C                             and RCDT = 'D'
     C                             and FPRC = *blanks
     C                             or RECI = 'D'
     C                             and RCDT = 'G'
     C                   EVAL      DDAACFOK = 'N'
     C                   EVAL      Idx = Idx + 1
     C                   EVAL      FldNamXAr(Idx) = 'DDAACF  '
     C                   EVAL      MsgIdXAr(Idx) = 'DLAA019'
     C                   ELSE
     C                   EVAL      ZFIELD = *blanks
     C                   EVALR     ZFIELD = DDAACF
     C                   Z-ADD     A6NBDP        ZADEC
     C     13            SUB       A6NBDP        ZADIG
     C                   EXSR      ZALIGN
      *
     C                   IF        *IN99
     C                   EVAL      DDAACFOK = 'N'
     C                   EVAL      Idx = Idx + 1
     C                   EVAL      FldNamXAr(Idx) = 'DDAACF    '
     C                   EVAL      MsgIdXAr(Idx) = 'DLAA018'
     C                   ELSE
     C                   Z-ADD     0             OTCOF            13 0
     C                   MOVE      ZFIELD        OTCOF
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
      *
     C                   ENDSR
      *****************************************************************
     C/EJECT
      *****************************************************************
      * VSFSGN - Validate COF Sign                                    *
      *****************************************************************
     C     VSFSGN        BEGSR
      *
      ** Validate Sign
      *
     C                   IF        BGN0ST = 'Y'
     C                   IF        DDAACF <> *blanks
     C                             and DDFSGN <> '+'
     C                             and DDFSGN <> '-'
     C                             or DDAACF = *blanks
     C                             and DDFSGN <> ' '
     C                   EVAL      DDFSGNOK = 'N'
     C                   EVAL      Idx = Idx + 1
     C                   EVAL      FldNamXAr(Idx) = 'DDFSGN  '
     C                   EVAL      MsgIdXAr(Idx) = 'DLAA006'
     C                   ENDIF
     C                   ENDIF
      *
     C                   ENDSR
      *****************************************************************
     C/EJECT
      *****************************************************************
      * VSUSIT - Validate For Unsettled Interest                      *
      *****************************************************************
     C     VSUSIT        BEGSR
      *
      ** Validate Unsettled Interest Field
      *
     C                   IF        CIR002 = 'Y'
     C                             or CIR006 = 'Y'
      *
      ** Entry in 'Unsettled Interest' field is prohibited unless
      ** deal type is RS, RX, RP, RF or RR.
      *
     C                   IF        DTYP <> 'RS'
     C                             and DTYP <> 'RX'
     C                             and DTYP <> 'RP'
     C                             and DTYP <> 'RF'
     C                             and DTYP <> 'RR'
      *
     C                   IF        DDUSIT <> *blanks
     C                   EVAL      DDUSITOK = 'N'
     C                   EVAL      Idx = Idx + 1
     C                   EVAL      FldNamXAr(Idx) = 'DDUSIT  '
     C                   EVAL      MsgIdXAr(Idx) = 'DLAA011'
     C                   ENDIF
      *
     C                   IF        DDUSGN <> *blanks
     C                   EVAL      DDUSGNOK = 'N'
     C                   EVAL      Idx = Idx + 1
     C                   EVAL      FldNamXAr(Idx) = 'DDUSGN  '
     C                   EVAL      MsgIdXAr(Idx) = 'DLAA006'
     C                   LEAVESR
     C                   ENDIF
     C                   ELSE
      *
     C                   IF        DDUSIT <> *blanks
      *
      ** If the 'Unsettled Interest' field is specified, the currency
      ** and the 'Ours/Theirs' indicator must be specified.
      *
     C                   IF        DDINIRS = *blanks
     C                   EVAL      DDINIRSOK = 'N'
     C                   EVAL      Idx = Idx + 1
     C                   EVAL      FldNamXAr(Idx) = 'DDINIRS '
     C                   EVAL      MsgIdXAr(Idx) = 'DLAA012'
     C                   LEAVESR
     C                   ENDIF
      *
     C                   IF        DDCCY = *blanks
     C                   EVAL      DDCCYOK  = 'N'
     C                   EVAL      Idx = Idx + 1
     C                   EVAL      FldNamXAr(Idx) = 'DDCCY    '
     C                   EVAL      MsgIdXAr(Idx) = 'DLAA012'
     C                   LEAVESR
     C                   ENDIF
      *
      ** If 'Adjustment' is specified, 'Unsettled Interest' must be
      ** blank.
      *
     C                   IF        DDMAAM <> *blanks
     C                   EVAL      DDUSITOK = 'N'
     C                   EVAL      Idx = Idx + 1
     C                   EVAL      FldNamXAr(Idx) = 'DDUSIT   '
     C                   EVAL      MsgIdXAr(Idx) = 'DLAA013'
     C                   LEAVESR
     C                   ENDIF
      *
      ** If 'Unsettled Interest' is specified, the interest rate on the
      ** leg of the deal affected must be floating (base rate type <> 0)
      ** and its unsettled interest is not zero.
      *
     C                   IF        DDINIRS = 'O'
      *
     C                   IF        OUSI = 0
     C                   EVAL      DDUSITOK = 'N'
     C                   EVAL      Idx = Idx + 1
     C                   EVAL      FldNamXAr(Idx) = 'DDUSIT   '
     C                   EVAL      MsgIdXAr(Idx) = 'DLAA016'
     C                   LEAVESR
     C                   ENDIF
      *
     C                   IF        DTYP = 'RS'
     C                             and UBRTT = 0
     C                             or DTYP = 'RX'
     C                             and UBRTT = 0
     C                             or DTYP = 'RP'
     C                             and UBRTT = 0
     C                             and CIR006 = 'Y'
     C                             or DTYP = 'RR'
     C                             and UBRTT = 0
     C                             and CIR006 = 'Y'
     C                             or DTYP = 'RF'
     C                             and UBRTT = 0
     C                             and CIR006 = 'Y'
     C                   EVAL      DDUSITOK = 'N'
     C                   EVAL      Idx = Idx + 1
     C                   EVAL      FldNamXAr(Idx) = 'DDUSIT   '
     C                   EVAL      MsgIdXAr(Idx) = 'DLAA014'
     C                   LEAVESR
     C                   ENDIF
      *
      ** If Individual Compouding (CIR006) is installed, entry of
      ** unsettled interest is allowed only for processing types
      ** 'A', 'I', 'L'.
      *
     C                   IF        CIR006 = 'Y'
     C                             and UINPM <> 'A'
     C                             and UINPM <> 'I'
     C                             and UINPM <> 'L'
     C                   EVAL      DDUSITOK = 'N'
     C                   EVAL      Idx = Idx + 1
     C                   EVAL      FldNamXAr(Idx) = 'DDUSIT   '
     C                   EVAL      MsgIdXAr(Idx) = 'DLAA021'
     C                   LEAVESR
     C                   ENDIF
     C                   ENDIF
      *
     C                   IF        DDINIRS = 'T'
      *
     C                   IF        TUSI = 0
     C                   EVAL      DDUSITOK = 'N'
     C                   EVAL      Idx = Idx + 1
     C                   EVAL      FldNamXAr(Idx) = 'DDUSIT   '
     C                   EVAL      MsgIdXAr(Idx) = 'DLAA016'
     C                   LEAVESR
     C                   ENDIF
      *
     C                   IF        DTYP = 'RS'
     C                             and TBRTT = 0
     C                             or DTYP = 'RX'
     C                             and TBRTT = 0
     C                             or DTYP = 'RP'
     C                             and TBRTT = 0
     C                             and CIR006 = 'Y'
     C                             or DTYP = 'RR'
     C                             and TBRTT = 0
     C                             and CIR006 = 'Y'
     C                             or DTYP = 'RF'
     C                             and TBRTT = 0
     C                             and CIR006 = 'Y'
     C                   EVAL      DDUSITOK = 'N'
     C                   EVAL      Idx = Idx + 1
     C                   EVAL      FldNamXAr(Idx) = 'DDUSIT   '
     C                   EVAL      MsgIdXAr(Idx) = 'DLAA014'
     C                   LEAVESR
     C                   ENDIF
      *
      ** If Individual Compouding (CIR006) is installed, entry of
      ** unsettled interest is allowed only for processing types
      ** 'A', 'I', 'L'.
      *
     C                   IF        CIR006 = 'Y'
     C                             and TINPM <> 'A'
     C                             and TINPM <> 'I'
     C                             and TINPM <> 'L'
     C                   EVAL      DDUSITOK = 'N'
     C                   EVAL      Idx = Idx + 1
     C                   EVAL      FldNamXAr(Idx) = 'DDUSIT   '
     C                   EVAL      MsgIdXAr(Idx) = 'DLAA021'
     C                   LEAVESR
     C                   ENDIF
     C                   ENDIF
      *
      *
      ** 'Unsettled Interest' must be a valid amount in the specified
      ** currency.
      *
     C                   EVAL      ZFIELD = *blanks
     C                   EVALR     ZFIELD = DDUSIT
     C                   Z-ADD     A6NBDP        ZADEC
     C     13            SUB       A6NBDP        ZADIG
     C                   EXSR      ZALIGN
      *
     C                   IF        *IN99
     C                   EVAL      DDUSITOK = 'N'
     C                   EVAL      Idx = Idx + 1
     C                   EVAL      FldNamXAr(Idx) = 'DDUSIT    '
     C                   EVAL      MsgIdXAr(Idx) = 'DLAA015'
     C                   LEAVESR
     C                   ELSE
     C                   Z-ADD     0             WUSIT            13 0
     C                   MOVE      ZFIELD        WUSIT
     C                   ENDIF
      *
     C                   IF        DDUSGN <> '+'
     C                             and DDUSGN <> '-'
     C                   EVAL      DDUSGNOK = 'N'
     C                   EVAL      Idx = Idx + 1
     C                   EVAL      FldNamXAr(Idx) = 'DDUSGN  '
     C                   EVAL      MsgIdXAr(Idx) = 'DLAA017'
     C                   LEAVESR
     C                   ENDIF
      *
     C                   ELSE
     C                   IF        DDUSGN <> *blanks
     C                   EVAL      DDUSGNOK = 'N'
     C                   EVAL      Idx = Idx + 1
     C                   EVAL      FldNamXAr(Idx) = 'DDUSGN  '
     C                   EVAL      MsgIdXAr(Idx) = 'DLAA020'
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
      *
     C                   ENDSR
     C/EJECT
      *****************************************************************
      * VSGCCY - Validate Which currency to use                       *
      *****************************************************************
     C     VSGCCY        BEGSR
      *
      ** Use correct Currency
      *
      ** IF Deal Type is not FRA/IRS (FR,RS,RX,RR,RP,RF) then
      ** IND must be ' '
      *
     C     DTYP          LOOKUP    IRTYP                                  99
     C                   IF        not %FOUND
     C                   LEAVESR
     C                   ENDIF
      *
     C                   IF        %FOUND
     C                   IF        DDINIRS = 'T'
     C                   MOVE      TCUCY         CCY
     C                   ELSE
     C                   MOVE      UCUCY         CCY
     C                   LEAVESR
     C                   ENDIF
      *
      **  If Cross Currency SWAP use their currency
      *
     C                   IF        DTYP = 'RX'
     C                             and DDINIRS = 'T'
     C                   MOVE      TCUCY         CCY
     C                   MOVE      TCUCY         DDCCY
     C                   ENDIF
     C                   ENDIF
      *
     C                   ENDSR
      *****************************************************************
     C/EJECT
      *****************************************************************
      * *INZSR - Program Initialisation routine                       *
      *****************************************************************
     C     *INZSR        BEGSR
      *
     C     *ENTRY        PLIST
      *
      ** INPUTS
      *
      ** Return Code
      *
     C                   PARM                    RetCodeIn
      *
      ** Other parms
      *
      ** Field(s) requiring validation
     C                   PARM                    TrnDets
      *
      ** OUTPUTS
     C                   PARM                    DSBrcTyp                                  AR1096788
      *
      ** Fields validation flags
      *
     C                   PARM                    TrnDetsOk
      ** Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
      ** Warning fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    WFldNmXAr
     C                   PARM                    WMsgIDXAr
     C                   PARM                    WMsgDtXAr
      *
      ** Access Bank Details
      *
     C                   CALL      'AOBANKR0'
     C                   PARM      '*DBERR '     @RTCD
     C                   PARM      '*FIRST '     @OPTN
     C     @BANK         PARM      @BANK         DSFDY
      *
      ** Database Error
      *
     C                   IF        @RTCD <> *BLANKS
     C                   EVAL      DBFILE = 'SDBANKPD'
     C                   EVAL      DBASE = 901
     C                   EVAL      DBKEY = @OPTN
     C                   EXSR      *PSSR
     C                   ENDIF
      *
      ** Access Module Details
      *
     C                   CALL      'AOMMODR0'
     C                   PARM      '*DBERR '     @RTCD
     C                   PARM      '*FIRST '     @OPTN
     C     @MMOD         PARM      @MMOD         DSFDY
      *
      ** DATABASE ERROR
      *
     C     @RTCD         IFNE      *BLANKS
     C                   MOVEL     'SDMMODPD'    DBFILE
     C                   MOVEL     '902'         DBASE
     C                   MOVEL     @OPTN         DBKEY
     C                   EXSR      *PSSR
     C                   ENDIF
      *
      ** Check if switchable feature CIR002 is switched on
      *
     C                   CALL      'AOSARDR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*VERIFY'     @OPTN
     C                   PARM      'CIR002'      @SARD
     C     SCSARD        PARM      SCSARD        DSFDY
      *
     C     @RTCD         IFEQ      *BLANKS
     C                   EVAL      CIR002 = 'Y'
     C                   ELSE
     C                   EVAL      CIR002 = 'N'
     C                   ENDIF
      *
      ** Check if switchable feature CIR006 is switched on
      *
     C                   CALL      'AOSARDR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*VERIFY'     @OPTN
     C                   PARM      'CIR006'      @SARD
     C     SCSARD        PARM      SCSARD        DSFDY
      *
     C     @RTCD         IFEQ      *BLANKS
     C                   EVAL      CIR006 = 'Y'
     C                   ELSE
     C                   EVAL      CIR006 = 'N'
     C                   ENDIF
      *
      *
      ** Program, module and procedure names for database error processing.
      ** =================================================================
      ** The following /COPY sets these values, and also defines LDA as
      ** an external data area
      *
     C/COPY ZACPYSRC,DBFIELDS
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
1093  *****************************************************************
      **
      **   ZALIGN SR. TO VALIDATE AND RIGHT-ALIGN NUMERIC FIELDS.
      **
     C     ZALIGN        BEGSR
      *
     C                   SETOFF                                       929399
      *
      **   SAVE INPUT FIELD IN ARRAY, ZA1.
      *
     C                   MOVEA     ZFIELD        ZA1
      *
      **   CALCULATION TO DEFINE NUMBER STRUCTURE CONTROL FIELDS.
      *
     C                   Z-ADD     ZADIG         ZADIG             2 0
     C                   Z-ADD     ZADEC         ZADEC             1 0
      *
      **   CALCULATIONS TO DEFINE/CLEAR FIELDS.
      *
     C                   MOVE      ' '           ZA2
     C                   MOVEA     ZA2           ZFIELD           16
     C                   Z-ADD     0             ZX                2 0
     C                   Z-ADD     0             ZY                2 0
      *
      **   ENSURE REQUIRED STRUCTURE OF FIELD IS VALID.
      *
     C     ZADIG         ADD       ZADEC         ZZ                2 0
     C     ZZ            COMP      15                                 99
     C   99              GOTO      ZAEND
      *
      **   LOOP TO FIND DECIMAL POINT, BLANKS AND CHARACTERS.
      *
     C     ZATAG1        TAG
     C     ZX            ADD       1             ZX
      *
      **   CHECK FOR DECIMAL POINT. ERROR IF SECOND DECIMAL POINT.
      *
     C     ZA1(ZX)       COMP      '.'                                    90
     C   90
     CAN 93              SETON                                        99
     C   99              GOTO      ZAEND
      *
      **   CHECK FOR 'M' CONSTANT. ERROR IF NOT LAST CHARACTER ENTERED
      *
     C     ZA1(ZX)       COMP      'M'                                    96
     C   96              DO
     C     ZX            COMP      15                                 99  99
     C   99              GOTO      ZAEND
     C     ZX            ADD       1             ZX
     C     ZA1(ZX)       COMP      ' '                                9999
     C   99              GOTO      ZAEND
     C     ZX            SUB       1             ZX
     C     ZX            COMP      9                                  99
     C   99              GOTO      ZAEND
     C                   END
      *
      **   CHECK FOR 'T' CONSTANT. ERROR IF NOT LAST CHARACTER ENTERED
      *
     C     ZA1(ZX)       COMP      'T'                                    97
     C   97              DO
     C     ZX            COMP      15                                 99  99
     C   99              GOTO      ZAEND
     C     ZX            ADD       1             ZX
     C     ZA1(ZX)       COMP      ' '                                9999
     C   99              GOTO      ZAEND
     C     ZX            SUB       1             ZX
     C     ZX            COMP      12                                 99
     C   99              GOTO      ZAEND
     C                   END
      *
      **   CLEAR ALPHAMERIC CONSTANT FROM ZA1
      *
     C   96
     COR 97              MOVE      ' '           ZA1(ZX)
      *
      **   CHECK FOR BLANKS. BYPASS FOR FIRST BLANK AFTER A DIGIT.
      *
     C     ZA1(ZX)       COMP      ' '                                    91
     C   91
     CAN 92              GOTO      ZATAG2
      *
      **   CHECK FOR NUMERIC, IF NOT '.' OR ' '.
      *
     C  N90
     CANN91ZA1(ZX)       COMP      '0'                                  99
     C  N90
     CANN91
     CANN99ZA1(ZX)       COMP      '9'                                99
     C   99              GOTO      ZAEND
      *
      **   STORE DIGITS IN ARRAY AND HOW MANY.
      **   ZY, TOTAL OF DIGITS IN THE INPUT FIELD.
      **   ZZ, TOTAL OF DIGITS TO THE LEFT OF DECIMAL POINT.
      *
     C  N90
     CANN91ZY            ADD       1             ZY                   92
     C  N90
     CANN91              MOVE      ZA1(ZX)       ZA2(ZY)
     C   90              Z-ADD     ZY            ZZ                   93  93
      *
     C     ZX            COMP      16                                   94
     C   94              GOTO      ZATAG1
      *
     C     ZATAG2        TAG
      *
      **   IF 'M' SPECIFIED, MULTIPLY ZA1 BY 1 MILLION
      *
     C   96ZZ            ADD       6             ZZ
      *
      **   IF 'T' SPECIFIED, MULTIPLY ZA1 BY 1 THOUSAND
      *
     C   97ZZ            ADD       3             ZZ
      *
      **   FILL IN ZEROS IN ANY BLANKS LEFT OF DECIMAL POINT
      *
     C   96
     CAN 93
     COR 97
     CAN 93ZZ            DOWGT     ZY
     C     ZY            ADD       1             ZY
     C                   MOVE      '0'           ZA2(ZY)
     C                   END
      *
      **   IF CONSTANT SPECIFIED WITH NO DECIMAL POINT ZEROISE BLANKS
      *
     C   96
     CANN93              DO        6
     C     ZY            ADD       1             ZY
     C                   MOVE      '0'           ZA2(ZY)
     C                   END
      *
     C   97
     CANN93              DO        3
     C     ZY            ADD       1             ZY
     C                   MOVE      '0'           ZA2(ZY)
     C                   END
      *
      **   IF NO DECIMAL POINT FOUND, SET TOTAL FIELD ZZ.
      *
     C  N93              Z-ADD     ZY            ZZ
      *
      **   CHECK FOR EMBEDDED BLANKS.
      *
     C   91
     CAN 92              MOVEA     ZA1(ZX)       ZFIELD
     C   91
     CAN 92ZFIELD        COMP      ' '                                9999
     C   99              GOTO      ZAEND
      *
      **   ENSURE THAT NUMBER OF DIGITS ENTERED EITHER SIDE
      **   OF DECIMAL POINT ARE NOT MORE THAN ALLOWED.
      *
     C     ZZ            COMP      ZADIG                              99
     C     ZY            SUB       ZZ            ZX
     C  N99ZADEC         SUB       ZX            ZX                     9995
     C   99              GOTO      ZAEND
     C   95              GOTO      ZATAG4
      *
      **   FILL THE TRAILING BLANKS WITH ZEROS.
      *
     C     ZY            ADD       ZX            ZZ
     C     ZATAG3        TAG
     C     ZY            ADD       1             ZY
     C                   MOVE      '0'           ZA2(ZY)
     C     ZY            COMP      ZZ                                   94
     C   94              GOTO      ZATAG3
      *
      **   RIGHT-ALIGN THE VALUE BY MOVING BACK TO ARRAY, ZA1.
      *
     C     ZATAG4        TAG
     C                   MOVE      '0'           ZA1
     C                   Z-ADD     16            ZX
     C     ZATAG5        TAG
     C     ZY            COMP      0                                      94
     C   94              GOTO      ZATAG6
     C                   MOVE      ZA2(ZY)       ZA1(ZX)
     C     ZY            SUB       1             ZY
     C     ZX            SUB       1             ZX
     C                   GOTO      ZATAG5
     C     ZATAG6        TAG
      *
      **   MOVE VALIDATED AND RIGHT-ALIGNED NUMBER BACK INTO ZFIELD.
      *
     C                   MOVEA     ZA1           ZFIELD
      *
     C                   SETOFF                                       9697
      *
     C     ZAEND         ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      /COPY ZACPYSRC,PSSR_ILE
      *****************************************************************
**  CPY@
(c) Misys International Banking Systems Ltd. 2012
**   IRTYP - FRA/IRS DEAL TYPES
RXFRRSRPRRRF
