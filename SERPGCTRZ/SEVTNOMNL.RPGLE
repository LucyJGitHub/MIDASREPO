     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas SE Validate Trade Nominal')                      *
      *****************************************************************
      *                                                               *
      *  Midas - Securities Trading Module                            *
      *                                                               *
      *  SEVTNOMNL - Validate Trade Nominal.                          *
      *                                                               *
      *  (c) Finastra International Limited 2001                      *
      *                                                               *
      *    This source is centrally supported and must ONLY be        *
      *    amended by Core Development Personnel                      *
      *                                                               *
      *    /COPY, Client or Country amendments must not be            *
      *    applied to this source.                                    *
      *                                                               *
      *  Last Amend No. CSD103             Date 10Aug20               *
      *  Prev Amend No. MD046248           Date 27Oct17               *
      *                 CRE073             Date 06Dec10               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CSD027             Date 09Dec05               *
      *                 CSE075             Date 17Nov05               *
      *                 CGL035             Date 01Mar05               *
      *                 CSE074             Date 30Aug05               *
      *                 CSE071             Date 19Jul05               *
      *                 227267             Date 10Jun04               *
      *                 CGL031             Date 05Jul04               *
      *                 CAS006             Date 21Jan03               *
      * Midas Release 4.01 -------------------------------------------*
      *                 CSE031             Date 13Dec01               *
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.05 -----------------------------------------------*
      *                 CSD006             Date 11Oct00               *
      * Midas DBA 3.03 -----------------------------------------------*
      *                 CAP137             Date 07Feb00               *
      * Midas DBA 3.02 -----------------------------------------------*
      *                 CPB001             Date 19Aug99               *
      *                 CGL011             Date 20Sep99               *
      * Midas DBA 3.00 ---------------- Base -------------------------*
      *                 CPL002             Date 08MAR99               *
      *                 CAP003  *CREATE    Date 09Apr98               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CSD103 - LIBOR Deregulation - Common Layer/Standing Data   *
      *             (Recompile)                                       *
      *  MD046248 - Finastra Rebranding                               *
      *  CRE073 - Interest Rate Rounding (Recompile)                  *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CSE075 - US Enhanced Treasury Upgrade to MidasPlus           *
      *           (Recompile)                                         *
      *  CGL035 - EUSD Upgrade to Midasplus (Recompile)               *
      *  CSE074 - Const. Yld Amort. Upgrade to MidasPlus (Recompile)  *
      *  CSE071 - Multiple Holidays Re Securities (recompile)         *
      *  227267 - position blocked although no block for allocation   *
      *  CGL031 - Taxation of Savings Income (Recompile)              *
      *  CAS006 - Hedge Accounting Phase B (Recompile)                *
      *  CSE031 - Coupon Fixing for Floating Rate Notes.              *
      *           Recompiled due to changes in SECTYD.                *
      *  CSD006 - Recompiled over changed SECTYD.                     *
      *  CAP137 - Conversion of SE Security inputs into modular       *
      *           structure to use as APIs (SECTYD)                   *
      *  CPB001 - 'Private Banking' Module                            *
      *  CGL011 - Collateral Processing for Midas                     *
      *  CPL002 - Midas-Plato Interface (Recompiled)                  *
      *  CAP003 - Conversion of SE inputs into modular structure to   *
      *           use as APIs.                                        *
      *                                                               *
      *****************************************************************
 
      ** +--------------------------------------+
      ** ¦            F-specs                   ¦
      ** ¦            =======                   ¦
      ** +--------------------------------------+
 
      * Customer Positions
     FCPOSC     IF   E           K DISK
     F                                     RENAME(CPOSNDF:CPOSNDF1)
 
      *****************************************************************
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
      ** The following /COPY includes the MM standard declares:
     D/COPY ZACPYSRC,STDDECLARE
      **--------------------------------------------------------------------------------------------
 
      **--------------------------------------------------------------------------------------------
      ** The following /COPY line includes all the defined fields in the
      ** Program Status Data Structures.  They have meaningful
      ** names, prefixed by 'PS'.
     D/COPY ZACPYSRC,PSDS
      **--------------------------------------------------------------------------------------------
 
      **--------------------------------------------------------------------------------------------
      ** The following /COPY line includes all the definitions of the
      ** appended error arrays, including the named constant giving the size
      ** of the arrays.
     D/COPY ZACPYSRC,ERR_XARRYS
      **--------------------------------------------------------------------------------------------
 
      ** +--------------------------------------+
      ** ¦ End of automatically included D-specs¦
      ** ¦ =====================================¦
      ** +--------------------------------------+
 
      *****************************************************************
      /EJECT
      *****************************************************************
 
      ** +--------------------------------------+
      ** ¦ Named constants                      ¦
      ** ¦ ===============                      ¦
      ** +--------------------------------------+
 
      ** +--------------------------------------+
      ** ¦ Manually included D-specs            ¦
      ** ¦ =========================            ¦
      ** +--------------------------------------+
 
      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
 
      ** Security Details
     D SECTY         E DS                  EXTNAME(SECTYD)
 
 
      ** Array for manipulating decimal positions
     D POWER8          S              8  4 DIM(8) CTDATA PERRCD(1)
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
      ** Index for arrays of error message ids etc
     D Idx             S              3P 0
 
      ** Index for arrays of warning message ids etc
     D WIx             S              3P 0
 
      ** Inputs
      ** ------
 
      ** Screen Details
      ** --------------
 
      ** Nominal
     D DDNOML          S             12A
      ** Branch
     D DDBRCD          S              3A
      ** Trade Type
     D DDTDTP          S              2A
 
 
      ** Trade Details
      ** --------------
 
      ** Customer
     D*TCNR*****       S              6S 0                                                    CSD027
     D TCNR            S              6A                                                      CSD027
 
      ** The following /COPY includes the customer details data structure
     D/COPY SECPYSRC,SE_CUSTDT
 
      ** Nominal Currency Decimal Places
     D NomCcyDec       S              1P 0
 
      ** System Input
      ** ------------
 
      ** Portfolio Mgmt indicator
     D BGPFMG          S              1A
      ** Run date
     D BJRDNB          S              5P 0
 
      ** Output  field(s)
      ** ----------------
 
      ** Nominal Ok Indicator
     D DDNOMLOK        S              1A
      ** Nominal
     D NOML            S             11P 0
 
      ** Work fields
      ** -----------
 
     D ZADIG           S              2P 0
     D ZADEC           S              1P 0
     D ZFIELD          S             16A
     D ZAlignOK        S              1A
     D SNWORK          S             15P 0
 
      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
      *****************************************************************
      /EJECT
      *****************************************************************
 
      ** +--- Start of Main processing -----------------------------------+
      ** ¦                                                                ¦
      ** ¦ Initial processing is performed automatically: the *INZSR is   ¦
      ** ¦ executed at program activation.                                ¦
      ** ¦                                                                ¦
      ** +----------------------------------------------------------------+
     C
      ** Initialization
 
     C                   MOVE      *BLANK        RetCodeIn
 
     C                   MOVE      *BLANK        FldNamXAr
     C                   MOVE      *BLANK        MsgIDXAr
     C                   MOVE      *BLANK        MsgDtaXAr
     C                   Z-ADD     0             Idx
     C                   MOVE      *BLANK        WFldNmXAr
     C                   MOVE      *BLANK        WMsgIDXAr
     C                   MOVE      *BLANK        WMsgDtXAr
     C                   Z-ADD     0             WIx
 
      ** Clear output trade fields
 
     C                   Z-ADD     *ZERO         NOML
      *
      ** VALIDATION
      *
     C     Validate      IFEQ      'Y'
     C                   EXSR      NOMLV
     C                   END
      *
      ** If an error was found, set the return code appropriately
      *
     C     DDNomlOK      IFEQ      'N'
     C                   EVAL      RetCodeIn = 'Error'
     C                   ENDIF
 
     C                   RETURN
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * NOMLV - Nominal Validation                                    *
      *                                                               *
      *****************************************************************
     C     NOMLV         BEGSR
      *
      * Nominal
      *    .. must be entered
      *
     C     DDNOML        IFEQ      *BLANKS
     C                   MOVE      'N'           DDNomlOk
     C                   ADD       1             Idx
     C                   MOVEL     'DDNOML'      FldNamXAr(Idx)
     C                   MOVEL     'MMA0119'     MsgidXAr(Idx)
     C                   GOTO      ENOMLV
     C                   END
      *
      **   If entered, must be a valid amount
      *
     C     DDNOML        IFNE      *BLANKS
     C                   MOVE      *BLANKS       ZFIELD
     C                   MOVEL     DDNOML        ZFIELD
     C                   Z-ADD     NMDP          ZADEC
     C     11            SUB       NMDP          ZADIG
 
     C                   CALLB     'ZALIGN'
     C                   PARM                    ZAlignOk
     C                   PARM                    ZFIELD
     C                   PARM                    ZADEC
     C                   PARM                    ZADIG
 
     C     ZAlignOk      IFEQ      'Y'
     C                   MOVE      ZFIELD        NOML
     C                   END
      *
     C     ZAlignOk      IFEQ      'N'
     C     ZAlignOk      OREQ      'Y'
     C     NOML          ANDEQ     *ZEROS
 
     C                   MOVE      'N'           DDNomlOk
     C                   ADD       1             Idx
     C                   MOVEL     'DDNOML'      FldNamXAr(Idx)
     C                   MOVEL     'MMA0120'     MsgidXAr(Idx)
     C                   GOTO      ENOMLV
     C                   ENDIF
     C                   ENDIF
      *
      ** Re-format Nominal to nominal currency decimal places
      *
     C     NomCcyDec     SUB       NMDP          DEC               1 0
     C                   ADD       5             DEC
     C     NOML          MULT      POWER8(DEC)   WNOML            15 0
      *
      ** .. Warning, if the customer position would be short
      *
     C     S01496        IFEQ      'Y'
     C     DDTDTP        ANDEQ     'TP'
 
     C     CustClass     IFEQ      'S'
     C     CustClass     OREQ      'D'
     C                   MOVE      DDBRCD        WWBRCH            3
     C**********         MOVE      TCNR          WWCNUM            6 0                        CSD027
     C                   MOVE      TCNR          WWCNUM            6                          CSD027
     C                   MOVE      SESN          WWSESN           10
     C                   Z-ADD     NOML          WWNOML           15 0
 
     C                   EXSR      SR50YA
 
     C     RES50Y        IFEQ      '1'
     C                   MOVE      'W'           DDNomlOk
     C                   ADD       1             WIx
     C                   MOVEL     'DDNOML'      WFldNmXAr(WIx)
     C                   MOVEL     'MMA0122'     WMsgidXAr(WIx)
     C                   ENDIF
 
     C                   ENDIF
     C                   ENDIF
      *
      ** It must be a multiple of Stock Denomination  (if not 0 on Secty)
      *
     C     SDNM          IFNE      *ZEROS
      *
      **   .. re-format Stock Denomination to currency decimal places
      *
     C     NomCcyDec     IFLT      4
     C     NomCcyDec     ADD       5             DEC               1 0
     C     SDNM          MULT      POWER8(DEC)   WSDNM            15 0
     C                   ELSE
     C     SDNM          MULT      10000         WSDNM
     C                   END
      *
     C     WSDNM         IFEQ      0
     C                   Z-ADD     0             SNWORK
     C                   ELSE
     C     WNOML         DIV       WSDNM         SNWORK
     C                   END
 
     C                   MULT      WSDNM         SNWORK
 
     C     SNWORK        IFNE      WNOML
     C     CSE007        IFEQ      'N'
     C     CEU017        ANDEQ     'N'
     C                   MOVE      'N'           DDNomlOk
     C                   ADD       1             Idx
     C                   MOVEL     'DDNOML'      FldNamXAr(Idx)
     C                   MOVEL     'MMA0121'     MsgidXAr(Idx)
     C                   GOTO      ENOMLV
     C                   ELSE
     C                   MOVE      'W'           DDNomlOk
     C                   ADD       1             WIx
     C                   MOVEL     'DDNOML'      WFldNmXAr(WIx)
     C                   MOVEL     'MMA0668'     WMsgidXAr(WIx)
     C                   END
     C                   END
 
     C                   END
 
      * Check for blocks
 
     C     S01496        IFEQ      'Y'
     C     CSE007        OREQ      'Y'                                                         CSE00
     C     CEU017        OREQ      'Y'                                                         CEU01
 
     C     CustClass     IFEQ      'S'
     C     CustClass     OREQ      'D'
 
     C                   MOVE      DDBRCD        @PBRCD            3
     C                   MOVE      SESN          @PSESN           10
     C                   MOVE      TCNR          @PCNUM            6
     C**********         MOVE      TCNR          @PCUST            6 0                 227267 CSD027
     C                   MOVE      TCNR          @PCUST            6                          CSD027
     C                   MOVE      'Y'           @POBPO            1
 
     C     DDTDTP        IFEQ      'TP'
     C                   MOVE      'P'           @PBLTY            1
     C                   ELSE
     C                   MOVE      'S'           @PBLTY            1
     C                   ENDIF
      *
      ***  If Corporate Actions feature is installed.
      ***  or If Securities Redenominations feature is installed.
      *
     C     CSE007        IFEQ      'Y'
     C     CEU017        OREQ      'Y'
      *
      ***  Search if there is Corporate Actions General Block for
      ***  Security.
      *
     C                   CALL      'SE7572'
     C                   PARM                    @PBRCD
     C                   PARM                    @PSESN
     C                   PARM                    @PCUST                        227267
     C                   PARM                    @PPGB             1
     C                   PARM                    @PSGB             1
      *
      ***  If block found, send error message
      *
     C     @PPGB         IFEQ      'Y'
     C     DDTDTP        ANDEQ     'TP'
     C     @PSGB         OREQ      'Y'
     C     DDTDTP        ANDEQ     'TS'
     C                   MOVE      'N'           DDNomlOk
     C                   ADD       1             Idx
     C                   MOVEL     'DDNOML'      FldNamXAr(Idx)
     C                   MOVEL     'MMA0670'     MsgidXAr(Idx)
     C                   GOTO      ENOMLV
     C                   ENDIF
     C                   ENDIF
      *
      ** Search if there is General Block for Security
      *
     C                   CALL      'SE6712'
     C                   PARM                    @PBRCD
     C                   PARM                    @PSESN
     C                   PARM                    @PPGB             1
     C                   PARM                    @PSGB             1
      *
     C     @PPGB         IFEQ      'Y'
     C     DDTDTP        ANDEQ     'TP'
     C     @PSGB         OREQ      'Y'
     C     DDTDTP        ANDEQ     'TS'
     C                   MOVE      'W'           DDNomlOk
     C                   ADD       1             WIx
     C                   MOVEL     'DDNOML'      WFldNmXAr(WIx)
     C                   MOVEL     'MMA0123'     WMsgidXAr(WIx)
     C                   ENDIF
      *
      **  If PM not installed or customer non portfolio
      **  And PB not installed or customer non private banking                  CPB001
      **  Do more block checking
      *
     C     BGPFMG        IFEQ      'N'
     C     BGN4ST        ANDNE     'Y'                                          CPB001
     C     CustPM        ORNE      'Y'
     C     CustPB        ANDNE     'Y'                                          CPB001
     C                   MOVE      *BLANKS       @PPTFR            4
     C                   EXSR      WBLOCK
     C                   ENDIF
 
     C                   ENDIF
     C                   ENDIF
 
     C     ENOMLV        ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *   SR50YA - Test for trade making short position               *
      *                                                               *
      *****************************************************************
     C     SR50YA        BEGSR
      *
      ** Klist for CPOSC
      *
     C     KCPOSC        KLIST
     C                   KFLD                    WWBRCH            3
     C**********         KFLD                    WWCNUM            6 0                        CSD027
     C                   KFLD                    WWCNUM            6                          CSD027
     C                   KFLD                    WWSESN           10
      *
      ** initialization
      *
     C                   Z-ADD     WWNOML        WWNOML           15 0
     C     *LIKE         DEFINE    WWNOML        WWPOS
     C                   MOVE      '0'           RES50Y            1
      *
      ** find customer position prev. day
      *
     C     KCPOSC        CHAIN     CPOSNDF1                           44
     C     *IN44         IFEQ      '1'
     C                   MOVE      '1'           RES50Y
     C                   END
      *
      ** test nominal vs. current position
      *
     C     CSNT          IFGT      0
 
     C     WWNOML        IFGT      CSNT
     C                   MOVE      '1'           RES50Y
     C                   END
      *
      ** ...otherwise if position already short output error showing
      ** that position will go even shorter
      *
     C                   ELSE
     C                   MOVE      '1'           RES50Y
     C                   END
     C*
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  WBLOCK - Subroutine to check blocks in validation            *
      *                                                               *
      *****************************************************************
     C     WBLOCK        BEGSR
      *
      ***  If Corporate Actions feature is installed.
      ***  or If Securities Redenomination feature is installed.
      *
     C     CSE007        IFEQ      'Y'
     C     CEU017        OREQ      'Y'
      *
      ***  Search if there is Corporate Actions General Block for
      ***  Customer.
      *
     C                   CALL      'SE7574'
     C                   PARM                    @PBRCD            3
     C                   PARM                    @PCNUM            6
     C                   PARM                    @PPTFR            4
     C                   PARM                    @PPGB             1
     C                   PARM                    @PSGB             1
      *
      ***  If block found, send error message
      *
     C     @PPGB         IFEQ      'Y'
     C     DDTDTP        ANDEQ     'TP'
     C     @PSGB         OREQ      'Y'
     C     DDTDTP        ANDEQ     'TS'
     C     @PPTFR        IFEQ      *BLANKS
     C                   MOVE      'N'           DDNomlOk
     C                   ADD       1             Idx
     C                   MOVEL     'DDNOML'      FldNamXAr(Idx)
     C                   MOVEL     'MMA0671'     MsgidXAr(Idx)
     C                   ELSE
     C                   MOVE      'N'           DDNomlOk
     C                   ADD       1             Idx
     C                   MOVEL     'DDNOML'      FldNamXAr(Idx)
     C                   MOVEL     'MMA0674'     MsgidXAr(Idx)
     C                   ENDIF
     C                   GOTO      WBEND
     C                   ENDIF
      *
     C                   ENDIF
      *
      *    .... search if there is General Block for Customer
      *
     C                   CALL      'SE6714'
     C                   PARM                    @PBRCD            3
     C                   PARM                    @PCNUM            6
     C                   PARM                    @PPTFR            4
     C                   PARM                    @PPGB             1
     C                   PARM                    @PSGB             1
     C*
     C     @PPGB         IFEQ      'Y'
     C     DDTDTP        ANDEQ     'TP'
     C     @PSGB         OREQ      'Y'
     C     DDTDTP        ANDEQ     'TS'
     C*
     C     @PPTFR        IFEQ      *BLANKS
     C                   MOVE      'W'           DDNomlOk
     C                   ADD       1             WIx
     C                   MOVEL     'DDNOML'      WFldNmXAr(WIx)
     C                   MOVEL     'MMA0124'     WMsgidXAr(WIx)
     C                   ELSE
     C                   MOVE      'W'           DDNomlOk
     C                   ADD       1             WIx
     C                   MOVEL     'DDNOML'      WFldNmXAr(WIx)
     C                   MOVEL     'MMA0127'     WMsgidXAr(WIx)
     C                   ENDIF
 
      *
     C                   ENDIF
      *
      ***  If Corporate Actions feature is installed.
      ***  or If Securities Redenomination feature is installed.
      *
     C     CSE007        IFEQ      'Y'
     C     CEU017        OREQ      'Y'
      *
      ***  Search if there is Corporate Actions Specific Block for
      ***  Customer and Security.
      *
     C                   MOVE      BJRDNB        @PRDNB            5
     C                   CALL      'SE7570'
     C                   PARM                    @PRDNB
     C                   PARM                    @POBPO
     C                   PARM                    @PBRCD
     C                   PARM                    @PSESN
     C                   PARM                    @PCNUM
     C                   PARM                    @PPTFR
     C                   PARM                    @PBLTY
     C                   PARM                    @PNOBL           13
     C                   PARM                    @PNOPO           13
      *
     C                   MOVE      @PNOBL        WWNOBL           13 0
     C                   MOVE      @PNOPO        WWNOPO           13 0
      *
      ***  If block found, send error message
      *
     C     WWNOBL        IFEQ      *HIVAL
     C     @PPTFR        IFEQ      *BLANKS
     C                   MOVE      'N'           DDNomlOk
     C                   ADD       1             Idx
     C                   MOVEL     'DDNOML'      FldNamXAr(Idx)
     C                   MOVEL     'MMA0672'     MsgidXAr(Idx)
     C                   ELSE
     C                   MOVE      'N'           DDNomlOk
     C                   ADD       1             Idx
     C                   MOVEL     'DDNOML'      FldNamXAr(Idx)
     C                   MOVEL     'MMA0675'     MsgidXAr(Idx)
     C                   ENDIF
     C                   GOTO      WBEND
     C                   ELSE
     C     WWNOBL        IFNE      *ZEROS
     C     DDTDTP        IFEQ      'TP'
     C     WWNOPO        SUB       NOML          WWFONO           13 0
     C     WWFONO        IFLT      WWNOBL
     C     @PPTFR        IFEQ      *BLANKS
     C                   MOVE      'N'           DDNomlOk
     C                   ADD       1             Idx
     C                   MOVEL     'DDNOML'      FldNamXAr(Idx)
     C                   MOVEL     'MMA0673'     MsgidXAr(Idx)
     C                   ELSE
     C                   MOVE      'N'           DDNomlOk
     C                   ADD       1             Idx
     C                   MOVEL     'DDNOML'      FldNamXAr(Idx)
     C                   MOVEL     'MMA0676'     MsgidXAr(Idx)
     C                   ENDIF
     C                   GOTO      WBEND
     C                   ENDIF
     C                   ELSE
     C     WWNOPO        ADD       NOML          WWFONO
     C     WWFONO        IFGT      WWNOBL
     C     @PPTFR        IFEQ      *BLANKS
     C                   MOVE      'N'           DDNomlOk
     C                   ADD       1             Idx
     C                   MOVEL     'DDNOML'      FldNamXAr(Idx)
     C                   MOVEL     'MMA0673'     MsgidXAr(Idx)
     C                   ELSE
     C                   MOVE      'N'           DDNomlOk
     C                   ADD       1             Idx
     C                   MOVEL     'DDNOML'      FldNamXAr(Idx)
     C                   MOVEL     'MMA0676'     MsgidXAr(Idx)
     C                   ENDIF
     C                   GOTO      WBEND
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
      *
     C                   ENDIF
      *
      ** ... search if there is Specific Block for Customer and security
      *
     C                   MOVE      BJRDNB        @PRDNB            5
 
     C                   CALL      'SE6710'
 
     C                   PARM                    @PRDNB
     C                   PARM                    @POBPO
     C                   PARM                    @PBRCD
     C                   PARM                    @PSESN
     C                   PARM                    @PCNUM
     C                   PARM                    @PPTFR
     C                   PARM                    @PBLTY
     C                   PARM                    @PNOBL           13
     C                   PARM                    @PNOPO           13
     C                   PARM                    @PCOLF                                       CGL011
     C                   PARM      *ZEROS        @PCOLA           15                          CGL011
      *
     C                   MOVE      @PNOBL        WWNOBL           13 0
     C                   MOVE      @PNOPO        WWNOPO           13 0
      *
     C     @PCOLF        IfEq      'Y'                                                        CGL011
     C     DDTDTP        AndEq     'TP'                                                       CGL011
     C     @PCOLA        AndNe     *ZEROS                                                     CGL011
     C                   Move      @PCOLA        WWCOLL           15 0                        CGL011
     C     WWNOPO        Sub       NOML          WCOLLA           15 0                        CGL011
     C     WCOLLA        IfLt      WWCOLL                                                     CGL011
     C                   Add       1             WIx                                          CGL011
     C                   MoveL     'DDNOML'      WFldNmXAr(WIx)                               CGL011
     C                   MoveL     'MMA0584'     WMsgIdXAr(WIx)                               CGL011
     C                   EndIf                                                                CGL011
     C                   EndIf                                                                CGL011
      *
     C     WWNOBL        IFEQ      *HIVAL
 
     C     @PPTFR        IFEQ      *BLANKS
     C                   MOVE      'W'           DDNomlOk
     C                   ADD       1             WIx
     C                   MOVEL     'DDNOML'      WFldNmXAr(WIx)
     C                   MOVEL     'MMA0125'     WMsgidXAr(WIx)
     C                   ELSE
     C                   MOVE      'W'           DDNomlOk
     C                   ADD       1             WIx
     C                   MOVEL     'DDNOML'      WFldNmXAr(WIx)
     C                   MOVEL     'MMA0129'     WMsgidXAr(WIx)
     C                   ENDIF
 
     C                   ELSE
 
     C     WWNOBL        IFNE      *ZEROS
 
     C     DDTDTP        IFEQ      'TP'
     C     WWNOPO        SUB       NOML          WWFONO           13 0
 
     C     WWFONO        IFLT      WWNOBL
 
     C     @PPTFR        IFEQ      *BLANKS
     C                   MOVE      'W'           DDNomlOk
     C                   ADD       1             WIx
     C                   MOVEL     'DDNOML'      WFldNmXAr(WIx)
     C                   MOVEL     'MMA0126'     WMsgidXAr(WIx)
     C                   ELSE
     C                   MOVE      'W'           DDNomlOk
     C                   ADD       1             WIx
     C                   MOVEL     'DDNOML'      WFldNmXAr(WIx)
     C                   MOVEL     'MMA0130'     WMsgidXAr(WIx)
     C                   ENDIF
 
     C                   ENDIF
 
     C                   ELSE
     C     WWNOPO        ADD       NOML          WWFONO
 
     C     WWFONO        IFGT      WWNOBL
 
     C     @PPTFR        IFEQ      *BLANKS
     C                   MOVE      'W'           DDNomlOk
     C                   ADD       1             WIx
     C                   MOVEL     'DDNOML'      WFldNmXAr(WIx)
     C                   MOVEL     'MMA0126'     WMsgidXAr(WIx)
     C                   ELSE
     C                   MOVE      'W'           DDNomlOk
     C                   ADD       1             WIx
     C                   MOVEL     'DDNOML'      WFldNmXAr(WIx)
     C                   MOVEL     'MMA0130'     WMsgidXAr(WIx)
     C                   ENDIF
 
 
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
      *
     C     WBEND         ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * *INZSR - Program Initialisation routine                       *
      *****************************************************************
     C     *INZSR        BEGSR
 
     C     *ENTRY        PLIST
      *
      * INPUTS
      *
      ** Return Code
     C                   PARM                    RetCodeIn
      *
      ** Default & Validate (Y or N)
     C                   PARM                    Default           1
     C                   PARM                    Validate          1
      *
      ** Trade Screen fields
      ** Nominal (12A)
      ** Branch (3A)
      ** Trade Type (2A)
     C                   PARM                    DDNOML
     C                   PARM                    DDBRCD
     C                   PARM                    DDTDTP
 
      ** Trade Details:
      ** Customer (6S 0)
      ** Customer Details
     C                   PARM                    TCNR
     C                   PARM                    CustDts                                       S0111
 
      ** Security Details
      ** Nominal Currency Decimal Places (1P 0)
 
     C                   PARM                    SECTY
     C                   PARM                    NomCcyDec
 
      ** System Input
 
      ** Portfolio Mgmt Indicator (1A)
      ** Run Date (5P 0)
      ** S01496 Indicator (PB SE enhancements)
      ** CSE007 Indicator (Corporate Actions)
      ** CEU017 Indicator (SE Rednomination Euro changes)
      ** BGN4ST Indicator (Private Banking Module)                              CPB001
 
     C                   PARM                    BGPFMG
     C                   PARM                    BJRDNB
     C                   PARM                    S01496            1
     C                   PARM                    CSE007            1
     C                   PARM                    CEU017            1
     C                   PARM                    BGN4ST            1            CPB001
      *
      * OUTPUTS
      *
      * Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
     C                   PARM                    WFldNmXAr
     C                   PARM                    WMsgIDXAr
     C                   PARM                    WMsgDtXAr
 
      ** Nominal Ok Indicator  (1A)
      ** Nominal Amount  (11P 0)
     C                   PARM                    DDNomlOK
     C                   PARM                    NOML
     C                   PARM                    @PCOLF            1                          CGL011
      *
      ** Program, module and procedure names for database error processing.
      ** =================================================================
      ** The following /COPY sets these values, and also defines LDA as
      ** an external data area
 
     C/COPY ZACPYSRC,DBFIELDS
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
     C/COPY ZACPYSRC,PSSR_ILE
      ********************************************************************
**  CPY@
(c) Finastra International Limited 2001
**  POWER8 - ARRAY OF POWERS FOR CURRENCY CONVERSION
00000001
00000010
00000100
00001000
00010000
00100000
01000000
10000000
