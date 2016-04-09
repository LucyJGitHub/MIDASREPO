     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2003')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas GO Setup FRA TRAP record')
      *****************************************************************
      *                                                               *
      *  Midas - Global Processing Module                             *
      *                                                               *
      *  GOSETFRAS - Setup FRA TRAP record                            *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2003            *
      *                                                               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      *  Last Amend No. 256564             Date 17Sep08               *
      *  Prev Amend No. BUG13562           Date 16Mar07               *
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 BUG11830           Date 11Aug06               *
      *                 CSD031             Date 10Apr06               *
      *                 CSD027             Date 09Dec05               *
      *                 CDL038             Date 10May05               *
      *                 CDL028             Date 07Feb05               *
      *                 BUG3860            Date 11Aug04               *
      *                 CGP001  *CREATE    Date 23May03               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  256564 - Recompile due to PF changes done by fix 256330      *
      *  BUG13562 - Matured FRAs and SE Trades are still linked       *
      *             to limits. Ensure Matured Indicator (T_MATI) is   *
      *             set to 'Y' if RECI=M. Same as MP121 Fix 246296.   *
      *  BUG11830- branch of settlement account not defaulted         *
      *  CSD031 - Enhanced Centralised Static Data (Recompile)        *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CDL038 - Extended Deal Sub Type (Recompile)                  *
      *  CDL028 - Automatic Rate Interpolations (Recompile)           *
      *  BUG3860 - (recompile)                                        *
      *  CGP001 - Global Processing                                   *
      *                                                               *
      *****************************************************************
 
     FGPUTXTL0  IF A E           K DISK    INFSR(*PSSR)
 
     D/COPY ZACPYSRC,STD_D_SPEC
 
 
     D FRAS          E DS                  EXTNAME(DEALSDG)
 
 
      ** T R A N S A C T I O N    D E T A I L S
     D T_TRAP        E DS                  EXTNAME(GPTRAPPD)
 
 
     D SDBSRT        E DS                  EXTNAME(SDBSRTPD)
     D SDCURR        E DS                  EXTNAME(SDCURRPD)
     D DSSDY         E DS                  EXTNAME(DSSDY)
 
     D SDCUST        E DS                  EXTNAME(SDCUSTPD)                                BUG11830
 
      * ENTRY PARAMETERS
 
     C     *ENTRY        PLIST
     C                   PARM                    I#RTCD            7            * RETURN CODE
     C                   PARM                    I#ERMS           50            * ERROR MESSAGE
      * INPUTS
     C                   PARM                    FRAS
      * OUTPUTS
     C                   PARM                    T_TRAP
 
     C                   PARM                    FltRateSet        1
     C                   PARM                    FltRateTyp        1
     C                   PARM                    FltRate          11 7
     C                   PARM                    FixRate          11 7
     C                   PARM                    SettleAmt        15 0
 
      * SETUP TRANSACTION INDEX RECORD
 
     C                   EXSR      SETUP_TRAP
 
      * RETURN
 
     C                   RETURN
      *
      *****************************************************************
      * SETUP TRANSACTION INDEX RECORD
      *****************************************************************
     C     SETUP_TRAP    BEGSR
 
      * Clear Transaction Index
 
     C                   CLEAR                   T_TRAP
 
      * Zone
     C                   MOVEL     O#ZONE        T_ZONE
      * Module
     C                   MOVEL     'DL'          T_MOD
      * Sub module
     C                   MOVEL     'FRAS'        T_SMOD
      * Customer
     C                   MOVEL     CNUM          T_CNUM
      * Portfolio reference
     C                   MOVEL     *BLANK        T_PTFR
      * Booking Branch
     C                   MOVEL     BRCA          T_BRCA
      * Book
     C                   MOVEL     BOKC          T_BOOK
      * Transaction Reference
     C                   MOVEL     DLNO          T_TREF
      * Identifier
     C     GPUTXTK       CHAIN     GPUTXTD0                           99
     C     *IN99         IFEQ      *ON
      /COPY GOCPYSRC,GOGETNTID
     C                   MOVEL     T_ZONE        XTZONE
     C                   MOVEL     T_MOD         XTMOD
     C                   MOVEL     T_SMOD        XTSMOD
     C                   MOVEL     T_TREF        XTTREF
     C                   Z-ADD     O#NTID        XTID
     C                   WRITE     GPUTXTD0
     C                   ENDIF
     C                   Z-ADD     XTID          T_ID
      * Shortname
     C                   EVAL      T_SNAM = T_TREF
      * Transaction Type
     C                   MOVEL     DTYP          T_TRTP
      * Transaction Sub-Type
     C                   MOVEL     DLST          T_TRST
      * Transaction Profit Centre
     C                   MOVEL     PRFC          T_TPFC
      * Risk Customer
     C                   MOVEL     CNUM          T_RCST
      * Risk Currency
     C                   MOVEL     UCUCY         T_RCCY
      * Transaction Date
     C                   Z-ADD     DDAT          T_TDAT
      * Start Date
     C                   Z-ADD     VDAT          T_SDAT
      * End Date
     C                   Z-ADD     MDAT          T_EDAT
 
      * CHECK WHETHER FRA RATE HAS BEEN FIXED
 
     C                   EXSR      CHKRATFIX
 
      * Current Market Value
 
     C     FltRateSet    IFEQ      'Y'
     C                   Z-ADD     SettleAmt     T_MKVL
     C                   ELSE
     C                   Z-ADD     UNRL          T_MKVL
     C                   ENDIF
      * Valuation Currency
     C                   MOVEL     UCUCY         T_VCCY
      * Valuation Ccy Dec Places
     C                   MOVEL     T_VCCY        @CYCD
     C                   EXSR      ACSCCY
     C                   MOVEL     A6NBDP        T_VCDP
      * Matured?
     C     VDAT          IFLT      I#RDNB
     C     RECI          OREQ      'M'                                                      BUG13562
     C                   MOVEL     'Y'           T_MATI
     C                   ENDIF
      * Action
     C     RECI          IFEQ      'R'
     C                   MOVEL     'D'           T_ACTN
     C                   ELSE
     C                   MOVEL     'A'           T_ACTN
     C                   ENDIF
 
      * Customer branch                                                                     BUG11830
     C                   MOVEL     T_CNUM        @KEY1                                      BUG11830
     C                   EXSR      ACS_CUST                                                 BUG11830
     C                   MOVEL     BBBRCD        T_RCBR                                     BUG11830
     C                   ENDSR
      *****************************************************************
      /SPACE 5
      ********************************************************************
      * CHECK WHETHER FRA RATE HAS BEEN FIXED
      ********************************************************************
     C     CHKRATFIX     BEGSR
 
      * Get floating side fields
 
     C     UBRTT         IFNE      *ZERO
     C                   EXSR      OUR
     C                   Z-ADD     TEINR         FixRate
     C                   ELSE
     C                   EXSR      THEIR
     C                   Z-ADD     UEINR         FixRate
     C                   ENDIF
 
      ** IF INITIAL RATE SET USE EFFECTIVE INTEREST RATE
 
     C                   TESTB     '0'           W#DNSI                   99
      *
     C     *IN99         IFEQ      '1'
     C                   MOVEL     'Y'           FltRateSet
     C                   MOVEL     'A'           FltRateTyp
     C                   Z-ADD     W#EINR        FltRate
     C                   ELSE
      *
      ** IF RATE DUE FOR FIXING, GET CURRENT BASE RATE
      *
     C     W#INFD        IFLT      I#DNWD
     C                   MOVEL     W#CUCY        @CYCD
     C                   MOVEL     W#BRTT        @DWNB
     C                   EXSR      ACSBSR
     C                   MOVEL     'Y'           FltRateSet
     C                   MOVEL     'C'           FltRateTyp
     C     W#INFD        IFLT      BAVDNR
     C                   Z-ADD     BACBSR        FltRate
     C                   ELSE
     C                   Z-ADD     BANBRT        FltRate
     C                   ENDIF
     C                   ELSE
     C                   MOVEL     'N'           FltRateSet
     C                   MOVEL     ' '           FltRateTyp
     C                   Z-ADD     0             FltRate
     C                   GOTO      ECHKRATFIX
     C                   END
     C                   END
 
      * Calculate FRA settlement amount
 
     C     UIPRD         IFNE      *ZERO
     C                   Z-SUB     UIPRD         SettleAmt
     C                   ELSE
     C     TIPRD         IFNE      *ZERO
     C                   Z-ADD     TIPRD         SettleAmt
     C                   ELSE
 
     C                   CALLB     'GOCALFRST'
     C                   PARM      *BLANK        W#RTCD            7
     C                   PARM      *BLANK        W#ERMS           50
     C                   PARM      BYSL          W#BYSL            1
     C                   PARM      SETF          W#SETF            1
     C                   PARM      VDAT          W#VDAT            5 0
     C                   PARM      MDAT          W#MDAT            5 0
     C                   PARM                    W#PAMT           13 0
     C                   PARM      FixRate       W#FIX            11 7
     C                   PARM      FltRate       W#FLT            11 7
     C                   PARM                    W#ICBS            1 0
     C                   PARM      *ZERO         W#IANP           13 0
     C                   PARM      *ZERO         W#RDS            13 0
     C                   PARM      *ZERO         SettleAmt        15 0
 
     C     W#RTCD        IFEQ      '*ERROR'
     C                   EVAL      I#ERMS = 'ERROR IN CALL TO GOCALFRST'
     C                   EXSR      *PSSR
     C                   END
 
     C                   ENDIF
     C                   ENDIF
 
     C     ECHKRATFIX    ENDSR
      *****************************************************************
      /SPACE 5
      ********************************************************************
      * MOVE 'OUR' DETAILS TO WORK FIELDS
      ********************************************************************
     C     OUR           BEGSR
      *
     C                   MOVE      'U'           W#OTIN            1
      *
     C                   MOVE      UCUCY         W#CUCY            3
     C                   Z-ADD     UPAMT         W#PAMT           13 0
     C                   Z-ADD     UBRTT         W#BRTT            2 0
     C                   Z-ADD     UBRTE         W#BRTE           11 7
     C                   Z-ADD     URTSP         W#RTSP           11 7
     C                   Z-ADD     UEINR         W#EINR           11 7
     C                   MOVE      USPIN         W#SPIN            1
     C                   Z-ADD     UICBS         W#ICBS            1 0
     C                   Z-ADD     UINFD         W#INFD            5 0
      *
     C                   Z-ADD     UIACD         W#IACD            5 0
     C                   Z-ADD     UAITC         W#AITC           13 0
     C                   Z-ADD     UAIAN         W#AIAN           13 0
     C                   Z-ADD     UAIAP         W#AIAP           13 0
     C                   Z-ADD     UIPRD         W#IPRD           13 0
      *
     C                   MOVE      UDNSI         W#DNSI            1
     C                   MOVE      UDSTI         W#DSTI            1
      *
     C                   ENDSR
      **************************************************************************
      /SPACE 5
      ********************************************************************
      * MOVE 'THEIR' DETAILS TO WORK FIELDS
      ********************************************************************
     C     THEIR         BEGSR
      *
     C                   MOVE      'T'           W#OTIN            1
      *
     C                   MOVE      TCUCY         W#CUCY            3
     C                   Z-ADD     TPAMT         W#PAMT           13 0
     C                   Z-ADD     TBRTT         W#BRTT            2 0
     C                   Z-ADD     TBRTE         W#BRTE           11 7
     C                   Z-ADD     TRTSP         W#RTSP           11 7
     C                   Z-ADD     TEINR         W#EINR           11 7
     C                   MOVE      TSPIN         W#SPIN            1
     C                   Z-ADD     TICBS         W#ICBS            1 0
     C                   Z-ADD     TINFD         W#INFD            5 0
      *
     C                   Z-ADD     TIACD         W#IACD            5 0
     C                   Z-ADD     TAITC         W#AITC           13 0
     C                   Z-ADD     TAIAN         W#AIAN           13 0
     C                   Z-ADD     TAIAP         W#AIAP           13 0
     C                   Z-ADD     TIPRD         W#IPRD           13 0
      *
     C                   MOVE      TDNSI         W#DNSI            1
     C                   MOVE      TDSTI         W#DSTI            1
      *
     C                   ENDSR
      **************************************************************************
      /SPACE 5
      ********************************************************************
      * ACCESS BASE RATE DETAILS
      ********************************************************************
     C     ACSBSR        BEGSR
      *
     C                   CALLB     'AOBSRTR0'
     C                   PARM      '*DBERR  '    @RTCD             7
     C                   PARM      '*KEY    '    @OPTN             7
     C                   PARM                    @CYCD             3
     C                   PARM                    @DWNB             2
     C     SDBSRT        PARM      SDBSRT        DSSDY
      *
     C                   ENDSR
      ********************************************************************
      /SPACE 5
      ********************************************************************
      * ACCESS CURRENCY DETAILS
      ********************************************************************
     C     ACSCCY        BEGSR
      *
     C                   CALL      'AOCURRR0'
     C                   PARM      '*DBERR  '    @RTCD             7
     C                   PARM      '*KEY    '    @OPTN             7
     C                   PARM                    @CYCD             3
     C     SDCURR        PARM      SDCURR        DSSDY
      *
     C                   ENDSR
      ********************************************************************
      /SPACE 5
      ********************************************************************                  BUG11830
      * Access customer details                                                             BUG11830
      ********************************************************************                  BUG11830
     C     ACS_CUST      BEGSR                                                              BUG11830
     C                   CALLB     'AOCUSTR0'                                               BUG11830
     C                   PARM      *BLANKS       @RTCD             7                        BUG11830
     C                   PARM      '*KEY   '     @OPTN             7                        BUG11830
     C                   PARM                    @KEY1            10                        BUG11830
     C                   PARM      *BLANKS       @KYST             7                        BUG11830
     C     SDCUST        PARM      SDCUST        DSSDY                                      BUG11830
     C     @RTCD         IFNE      *BLANK                                                   BUG11830
     C     @KYST         OREQ      '*ERROR'                                                 BUG11830
     C                   CLEAR                   SDCUST                                     BUG11830
     C                   ENDIF                                                              BUG11830
     C                   ENDSR                                                              BUG11830
      *****************************************************************                     BUG11830
      /SPACE 5                                                                              BUG11830
      ********************************************************************
      * *INZSR
      ********************************************************************
     C     *INZSR        BEGSR
 
      * Get Zone
 
      /COPY GOCPYSRC,GOGETZONE
 
      * Get Extract control information
 
      /COPY GOCPYSRC,GOGETEXCT
 
 
      * key list
 
     C     GPUTXTK       KLIST
     C                   KFLD                    T_ZONE
     C                   KFLD                    T_MOD
     C                   KFLD                    T_SMOD
     C                   KFLD                    T_TREF
     C                   ENDSR
      *****************************************************************
      /SPACE 5
      *****************************************************************
      * * P S S R  --- A B N O R M A L   E R R O R   C O N D I T I O N S
      /COPY GOCPYSRC,GOPSSR
      *********************************************************************
**  CPY@
(c) Misys International Banking Systems Ltd. 2003
