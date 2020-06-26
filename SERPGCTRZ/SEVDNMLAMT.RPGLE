     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas SE: Validate Nominal Amount')                    *
      *****************************************************************
      *                                                               *
      *    Midas SE - Midas Security Trading validation module.       *
      *                                                               *
      *  SEVDNMLAMT - This module validates the Nominal Amount field  *
      *                                                               *
      *  This module is an ILE/RPG IV conversion of the validation    *
      *  routine for the said field. This routine has been retrieved  *
      *  from SE0070 and has been converted to ILE RPG and copied into*
      *  this member.  Necessary code to make this compileable has    *
      *  been added (entry and exit points and some declares).        *
      *                                                               *
      *  Component of: SE0070 (Depot movements maintenance)           *
      *                                                               *
      *  (c) Finastra International Limited 2001                      *
      *                                                               *
      *    This source is centrally supported and must ONLY be        *
      *    amended by Core Development Personnel                      *
      *                                                               *
      *    /COPY, Client or Country amendments must not be            *
      *    applied to this source.                                    *
      *                                                               *
      *  Last Amend No. AR1075401          Date 01Jun20               *      
      *  Prev Amend No. MD046248           Date 27Oct17               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CSD027             Date 09Dec05               *
      *                 CSE071             Date 19Jul05               *
      *                 227267             Date 10Jun04               *
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.02 -----------------------------------------------*
      *                 CPB001             Date 18Aug99               *
      *                 CGL011             Date 20Sep99               *
      * Midas DBA 3.00 ---------------- Base -------------------------*
      *                 CPL002             Date 08MAR99               *
      *                 CAP003  *CREATE    Date 23Apr98               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  AR1075401 - Increase parameter field @PNOPO of SE6710/SE7570.*
      *              (Child: AR1075402)                               *      
      *  MD046248 - Finastra Rebranding                               *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CSE071 - Multiple Holidays Re Securities (recompile)         *
      *  227267 - Position blocked although no block for allocation   *
      *  CPB001 - 'Private Banking' Module                            *
      *  CGL011 - Collateral Processing for Midas                     *
      *  CPL002 - Midas-Plato Interface (Recompiled)                  *
      *  CAP003 - Conversion of SE inputs into modular structure to   *
      *           use as APIs.                                        *
      *                                                               *
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ Manually included F-specs            ¦
      ** ¦ =========================            ¦
      ** +--------------------------------------+
 
     FSECTY     IF   E           K DISK
 
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ Automatically included D-specs       ¦
      ** ¦ ==============================       ¦
      ** +--------------------------------------+
      **
      ** Standard D-specs
      ** ================
      **
      ** The following /COPY line includes the LDA layout,
      ** the copyright array definition,
      ** and the following named constants:
      **    True       logical = *on (for indcator processing)
      **    False      logical = *off (for indcator processing)
      **    DBErrCtl   10A     = 'DBERRCTL' (the name of the database error
      **                                    handler)
      ** and the following variables:
      **    RunBefore  1A (for the PSSR)
 
     D/COPY ZACPYSRC,STD_D_SPEC
 
      ** Include the MM standard declares
     D/COPY ZACPYSRC,STDDECLARE
 
      ** Program Status Data Structure
      ** =============================
      ** The following /COPY line includes all the defined fields in the
      ** PSDS.  They have meaningful names, prefixed by 'PS'.
 
     D/COPY ZACPYSRC,PSDS
 
      ** +--------------------------------------+
      ** ¦ End of automatically included D-specs¦
      ** ¦ =====================================¦
      ** +--------------------------------------+
 
      *****************************************************************
      /EJECT
      *****************************************************************
 
      ** +--------------------------------------+
      ** ¦ Manually included D-specs            ¦
      ** ¦ =========================            ¦
      ** +--------------------------------------+
 
      ** +--------------------------------------+
      ** ¦ Named constants                      ¦
      ** ¦ ===============                      ¦
      ** +--------------------------------------+
 
      ** The maximum size of the appended error arrays
     D XArrayMax       C                   CONST(20)
 
      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
 
      ** Array of Fields in error.
     D FldNamXAr       S             10A   DIM(XArrayMax)
 
      ** Array of error message IDs
     D MsgIDXAr        S                   DIM(XArrayMax) LIKE(#MsgId)
 
      ** Array of error message data.
     D MsgDtaXAr       S                   DIM(XArrayMax) LIKE(#MsgData)
 
      ** Array of Fields with warnings.
     D WFldNmXAr       S             10A   DIM(XArrayMax)
 
      ** Array of warning message IDs
     D WMsgIDXAr       S                   DIM(XArrayMax) LIKE(#MsgId)
 
      ** Array of warning message data.
     D WMsgDtXAr       S                   DIM(XArrayMax) LIKE(#MsgData)
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
      *
      ** Input fields
      ** ------------
 
      ** Screen fields
     D DDDPNA          S             12A
     D DDDPID          S             10A
     D DDDPOD          S             10A
     D DDPTFR          S              4A
 
      ** Transaction Details
     D DPSS            S             10A
     D DPBA            S              3A
     D*DPBN*****       S              6S 0                                                    CSD027
     D DPBN            S              6A                                                      CSD027
     D BFCLASCust      S              1A
 
     ** System Details
 
     D RUND            S              5P 0
     D S01496          S              1A
     D FCR997          S              4A
 
      ** Output Fields
     D DDDPNAOk        S              1A
     D DPNA            S             11P 0
 
      * Working Variables
     D WK11N           S             11P 0
     D FACTOR          S             10P 0
     D WK158N          S             15P 8
     D WK11N2          S             11P 0
     D WK147N          S             14P 7
     D @PBLTY          S              1A
     D @PBRCD          S              3A
     D @PCNUM          S              6A
     D @PNOBL          S             13A
     D*@PNOPO***       S             13A                                                   AR1075401
     D @PNOPO          S             15A                                                   AR1075401
     D @POBPO          S              1A
     D @PPGB           S              1A
     D @PSGB           S              1A
     D @PPTFR          S              4A
     D @PRDNB          S              5A
     D @PSESN          S             10A
     D WWFONO          S             13P 0
     D WWNOBL          S             13P 0
     D*WWNOPO***       S             13P 0                                                 AR1075401
     D WWNOPO          S             15P 0                                                 AR1075401
 
      * Parameters for ZALIGN
     D ZFIELD          S             16A
     D ZADEC           S              1P 0
     D ZADIG           S              2P 0
     D ZALIGNok        S              1A
 
      ** Index for arrays of error message ids etc
      ** Index for arrays of warning message ids etc
 
     D Idx             S              3P 0
     D WIx             S              3P 0
 
      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
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
 
     C                   Z-ADD     *ZEROS        DPNA
      *
      ** VALIDATION
      ** ----------
      ** Error messages
      *
     C                   EXSR      DPNAVE
      *
      ** Warning messages
      *
     C                   EXSR      DPNAVW
      *
      ** If an error was found, set the return code appropriately
      *
     C     DDDPNAOk      IFEQ      'N'
     C                   EVAL      RetCodeIn = 'Error'
     C                   ENDIF
      *
      ** Return
      *
     C                   RETURN
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * DPNAVE- Validation routine for Nominal Amount for error msgs. *
      *                                                               *
      * Called by: Main                                               *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
 
     C     DPNAVE        BEGSR
 
     C     DDDPNA        IFEQ      *BLANKS
      *
      ** Error 218
      *
     C                   ADD       1             Idx
     C                   MOVEL     'DDDPNA'      FldNamXAr(Idx)
     C                   MOVEL     'MMA0200'     MsgIdXAr(Idx)
     C                   MOVE      'N'           DDDPNAOk
     C                   ELSE
      *
      ** check valid number entered
      *
     C                   MOVE      *BLANKS       ZFIELD
     C                   MOVE      DDDPNA        ZFIELD
 
     C     DPSS          CHAIN     SECTYDF                            33
     C                   Z-ADD     NMDP          ZADEC
     C     11            SUB       NMDP          ZADIG
 
     C                   CALLB     'ZALIGN'
     C                   PARM                    ZALIGNok
     C                   PARM                    ZFIELD
     C                   PARM                    ZADEC
     C                   PARM                    ZADIG
 
     C     ZALIGNok      IFEQ      'N'
      *
      ** Error 218
      *
     C                   ADD       1             Idx
     C                   MOVEL     'DDDPNA'      FldNamXAr(Idx)
     C                   MOVEL     'MMA0200'     MsgIdXAr(Idx)
     C                   MOVE      'N'           DDDPNAOk
     C                   ELSE
      *
      ** Update Transaction
      *
     C                   MOVE      ZFIELD        DPNA
 
     C     DPNA          IFEQ      *ZEROS
      *
      ** Error 218
      *
     C                   ADD       1             Idx
     C                   MOVEL     'DDDPNA'      FldNamXAr(Idx)
     C                   MOVEL     'MMA0200'     MsgIdXAr(Idx)
     C                   MOVE      'N'           DDDPNAOk
     C                   END
      *
      ** must be multiple of stock denomination (if entered)
      *
     C     SDNM          IFNE      *ZEROS
     C                   MOVE      ZFIELD        WK11N
     C                   Z-ADD     1             FACTOR
 
     C                   DO        NMDP
     C     FACTOR        MULT      10            FACTOR
     C                   ENDDO
 
     C     WK11N         DIV       FACTOR        WK158N
     C     WK158N        DIV       SDNM          WK11N2
     C                   MVR                     WK147N
 
     C     WK147N        IFNE      *ZEROS
      *
      ** Error 219
      *
     C     CSE007        IFEQ      'N'
     C     CEU017        ANDEQ     'N'
     C                   ADD       1             Idx
     C                   MOVEL     'DDDPNA'      FldNamXAr(Idx)
     C                   MOVEL     'MMA0201'     MsgIdXAr(Idx)
     C                   MOVE      'N'           DDDPNAOk
     C                   ELSE
     C                   MOVE      'W'           DDDPNAOk
     C                   ADD       1             WIx
     C                   MOVEL     'DDDPNA'      WFldNmXAr(WIx)
     C                   MOVEL     'MMA0668'     WMsgidXAr(WIx)
     C                   END
     C                   END
 
     C                   END
     C                   END
 
     C                   END
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * DPNAVW- Validation routine for Nominal Amount for Warn. msgs. *
      *                                                               *
      * Called by: Main                                               *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
 
     C     DPNAVW        BEGSR
 
     C     S01496        IFEQ      'Y'
     C     CSE007        OREQ      'Y'
     C     CEU017        OREQ      'Y'
      *
      ** Customer Classification S or D
      *
     C     BFCLASCUST    IFEQ      'S'
     C     BFCLASCUST    OREQ      'D'
      *
      **  Walk-in or walk-out only
      *
     C     DDDPID        IFNE      *BLANKS
     C     DDDPOD        ANDEQ     *BLANKS
     C     DDDPID        OREQ      *BLANKS
     C     DDDPOD        ANDNE     *BLANKS
      *
     C                   MOVE      DPBA          @PBRCD
     C                   MOVE      DPSS          @PSESN
     C                   MOVE      DPBN          @PCNUM
 
     C     DDPTFR        IFEQ      FCR997
     C     BGN4ST        ANDNE     'Y'                                          CPB001
     C                   MOVE      '9997'        @PPTFR
     C                   ELSE
     C                   MOVE      DDPTFR        @PPTFR
     C                   ENDIF
 
     C                   MOVE      'Y'           @POBPO
 
     C     DDDPOD        IFNE      *BLANKS
     C     DDDPID        ANDEQ     *BLANKS
     C                   MOVE      'P'           @PBLTY
     C                   ELSE
     C                   MOVE      'S'           @PBLTY
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
     C                   PARM                    @PCNUM                        227267
     C                   PARM                    @PPGB
     C                   PARM                    @PSGB
      *
      ***  If block found, send error message
      *
     C     @PPGB         IFEQ      'Y'
     C     DDDPOD        ANDNE     *BLANKS
     C     DDDPID        ANDEQ     *BLANKS
     C     @PSGB         OREQ      'Y'
     C     DDDPOD        ANDEQ     *BLANKS
     C     DDDPID        ANDNE     *BLANKS
     C                   MOVE      'N'           DDDPNAOk
     C                   ADD       1             Idx
     C                   MOVEL     'DDDPNA'      FldNamXAr(Idx)
     C                   MOVEL     'MMA0670'     MsgidXAr(Idx)
     C                   GOTO      EDPNAV
     C                   ENDIF
     C                   ENDIF
      *
      **  .. search if there is General Block for Security
      *
     C                   CALL      'SE6712'
     C                   PARM                    @PBRCD
     C                   PARM                    @PSESN
     C                   PARM                    @PPGB
     C                   PARM                    @PSGB
     C*
     C     @PPGB         IFEQ      'Y'
     C     DDDPOD        ANDNE     *BLANKS
     C     DDDPID        ANDEQ     *BLANKS
     C     @PSGB         OREQ      'Y'
     C     DDDPOD        ANDEQ     *BLANKS
     C     DDDPID        ANDNE     *BLANKS
      *
      ** Warning WR1
      *
     C                   ADD       1             WIx
     C                   MOVEL     'DDDPNA'      WFldNmXAr(WIx)
     C                   MOVEL     'MMA0123'     WMsgIdXAr(WIx)
     C                   MOVE      'W'           DDDPNAOk
     C                   ENDIF
      *
      ***  If Corporate Actions feature is installed.
      ***  or If Securities Redenominations feature is installed.
      *
     C     CSE007        IFEQ      'Y'
     C     CEU017        OREQ      'Y'
      *
      ***  Search if there is Corporate Actions General Block for
      ***  Customer.
      *
     C                   CALL      'SE7574'
     C                   PARM                    @PBRCD
     C                   PARM                    @PCNUM
     C                   PARM                    @PPTFR
     C                   PARM                    @PPGB
     C                   PARM                    @PSGB
      *
      ***  If block found, send error message
      *
     C     @PPGB         IFEQ      'Y'
     C     DDDPOD        ANDNE     *BLANKS
     C     DDDPID        ANDEQ     *BLANKS
     C     @PSGB         OREQ      'Y'
     C     DDDPOD        ANDEQ     *BLANKS
     C     DDDPID        ANDNE     *BLANKS
     C                   MOVE      'N'           DDDPNAOk
     C                   ADD       1             Idx
     C                   MOVEL     'DDDPNA'      FldNamXAr(Idx)
     C     @PPTFR        IFEQ      *BLANKS
     C                   MOVEL     'MMA0671'     MsgidXAr(Idx)
     C                   ELSE
     C                   MOVEL     'MMA0674'     MsgidXAr(Idx)
     C                   ENDIF
     C                   GOTO      EDPNAV
     C                   ENDIF
     C                   ENDIF
      *
      **   .... search if there is General Block for Customer
      *
     C                   CALL      'SE6714'
     C                   PARM                    @PBRCD
     C                   PARM                    @PCNUM
     C                   PARM                    @PPTFR
     C                   PARM                    @PPGB
     C                   PARM                    @PSGB
      *
     C     @PPGB         IFEQ      'Y'
     C     DDDPOD        ANDNE     *BLANKS
     C     DDDPID        ANDEQ     *BLANKS
     C     @PSGB         OREQ      'Y'
     C     DDDPOD        ANDEQ     *BLANKS
     C     DDDPID        ANDNE     *BLANKS
      *
     C                   MOVE      'Y'           WarnFound
 
     C     @PPTFR        IFEQ      *BLANKS
      *
      ** Warning WR2
      *
     C                   ADD       1             WIx
     C                   MOVEL     'DDDPNA'      WFldNmXAr(WIx)
     C                   MOVEL     'MMA0124'     WMsgIdXAr(WIx)
     C                   MOVE      'W'           DDDPNAOk
     C                   ELSE
      *
      ** Warning WR6
      *
     C                   ADD       1             WIx
     C                   MOVEL     'DDDPNA'      WFldNmXAr(WIx)
     C                   MOVEL     'MMA0127'     WMsgIdXAr(WIx)
     C                   MOVE      'W'           DDDPNAOk
     C                   ENDIF
      *
     C                   ENDIF
      *
      ***  If Corporate Actions feature is installed.
      ***  or If Securities Redenominations feature is installed.
      *
     C     CSE007        IFEQ      'Y'
     C     CEU017        OREQ      'Y'
      *
      ***  Search if there is Corporate Actions General Block for
      ***  Customer and Security
      *
     C                   MOVE      RUND          @PRDNB
     C                   CALL      'SE7570'
     C                   PARM                    @PRDNB
     C                   PARM                    @POBPO
     C                   PARM                    @PBRCD
     C                   PARM                    @PSESN
     C                   PARM                    @PCNUM
     C                   PARM                    @PPTFR
     C                   PARM                    @PBLTY
     C                   PARM                    @PNOBL
     C                   PARM                    @PNOPO
     C                   MOVE      @PNOBL        WWNOBL
     C                   MOVE      @PNOPO        WWNOPO
      *
      ***  If block found, send error message
      *
     C     WWNOBL        IFEQ      *HIVAL
     C                   MOVE      'N'           DDDPNAOk
     C                   ADD       1             Idx
     C                   MOVEL     'DDDPNA'      FldNamXAr(Idx)
     C     @PPTFR        IFEQ      *BLANKS
     C                   MOVEL     'MMA0672'     MsgidXAr(Idx)
     C                   ELSE
     C                   MOVEL     'MMA0675'     MsgidXAr(Idx)
     C                   END
     C                   GOTO      EDPNAV
     C                   ELSE
 
     C     WWNOBL        IFNE      *ZEROS
 
     C     DDDPID        IFNE      *BLANKS
     C     DDDPOD        ANDEQ     *BLANKS
     C     WWNOPO        ADD       DPNA          WWFONO
 
     C     WWFONO        IFGT      WWNOBL
 
     C                   ADD       1             Idx
     C                   MOVEL     'DDDPNA'      FldNamXAr(Idx)
     C                   MOVE      'N'           DDDPNAOk
      *
      ** Error CO4
      *
     C     @PPTFR        IFEQ      *BLANKS
     C                   MOVEL     'MMA0673'     MsgIdXAr(Idx)
     C                   ELSE
      *
      ** Error CO8
      *
     C                   MOVEL     'MMA0676'     MsgIdXAr(Idx)
     C                   ENDIF
     C                   GOTO      EDPNAV
 
     C                   ENDIF
 
     C                   ELSE
     C     WWNOPO        SUB       DPNA          WWFONO
 
     C     WWFONO        IFLT      WWNOBL
     C                   ADD       1             Idx
     C                   MOVEL     'DDDPNA'      FldNamXAr(Idx)
     C                   MOVE      'N'           DDDPNAOk
     C     @PPTFR        IFEQ      *BLANKS
      *
      ** Error CO4
      *
     C                   MOVEL     'MMA0673'     MsgIdXAr(Idx)
     C                   ELSE
      *
      ** Error CO8
      *
     C                   MOVEL     'MMA0676'     MsgIdXAr(Idx)
     C                   ENDIF
     C                   GOTO      EDPNAV
 
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
      *
      ** ... search if there is Specific Block for Customer and Secty
      *
     C                   MOVE      RUND          @PRDNB
 
     C                   CALL      'SE6710'
     C                   PARM                    @PRDNB
     C                   PARM                    @POBPO
     C                   PARM                    @PBRCD
     C                   PARM                    @PSESN
     C                   PARM                    @PCNUM
     C                   PARM                    @PPTFR
     C                   PARM                    @PBLTY
     C                   PARM                    @PNOBL
     C                   PARM                    @PNOPO
     C                   PARM                    @PCOLF                                       CGL011
     C                   PARM      *ZEROS        @PCOLA           15                          CGL011
      *
     C                   MOVE      @PNOBL        WWNOBL
     C                   MOVE      @PNOPO        WWNOPO
      *
     C     @PCOLF        IfEq      'Y'                                                        CGL011
     C     DDDPOD        AndNe     *BLANKS                                                    CGL011
     C     @PCOLA        AndNe     *ZEROS                                                     CGL011
     C                   Move      @PCOLA        WWCOLL           15 0                        CGL011
     C     WWNOPO        Sub       DPNA          WCOLLA           15 0                        CGL011
     C     WCOLLA        IfLt      WWCOLL                                                     CGL011
     C                   Add       1             WIx                                          CGL011
     C                   MoveL     'DDDPNA'      WFldNmXAr(WIx)                               CGL011
     C                   MoveL     'MMA0584'     WMsgIdXAr(WIx)                               CGL011
     C                   Move      'W'           DDDPNAOk                                     CGL011
     C                   EndIf                                                                CGL011
     C                   EndIf                                                                CGL011
     C     WWNOBL        IFEQ      *HIVAL
     C                   MOVE      'Y'           WarnFound
 
     C     @PPTFR        IFEQ      *BLANKS
      *
      ** Warning WR3
      *
     C                   ADD       1             WIx
     C                   MOVEL     'DDDPNA'      WFldNmXAr(WIx)
     C                   MOVEL     'MMA0125'     WMsgIdXAr(WIx)
     C                   MOVE      'W'           DDDPNAOk
     C                   ELSE
      *
      ** Warning WR7
      *
     C                   ADD       1             WIx
     C                   MOVEL     'DDDPNA'      WFldNmXAr(WIx)
     C                   MOVEL     'MMA0129'     WMsgIdXAr(WIx)
     C                   MOVE      'W'           DDDPNAOk
     C                   ENDIF
 
     C                   ELSE
 
     C     WWNOBL        IFNE      *ZEROS
 
     C     DDDPID        IFNE      *BLANKS
     C     DDDPOD        ANDEQ     *BLANKS
     C     WWNOPO        ADD       DPNA          WWFONO
 
     C     WWFONO        IFGT      WWNOBL
     C                   MOVE      'Y'           WarnFound
 
     C     @PPTFR        IFEQ      *BLANKS
      *
      ** Warning WR4
      *
     C                   ADD       1             WIx
     C                   MOVEL     'DDDPNA'      WFldNmXAr(WIx)
     C                   MOVEL     'MMA0126'     WMsgIdXAr(WIx)
     C                   MOVE      'W'           DDDPNAOk
     C                   ELSE
      *
      ** Warning WR8
      *
     C                   ADD       1             WIx
     C                   MOVEL     'DDDPNA'      WFldNmXAr(WIx)
     C                   MOVEL     'MMA0130'     WMsgIdXAr(WIx)
     C                   MOVE      'W'           DDDPNAOk
     C                   ENDIF
 
     C                   ENDIF
 
     C                   ELSE
     C     WWNOPO        SUB       DPNA          WWFONO
 
     C     WWFONO        IFLT      WWNOBL
     C                   MOVE      'Y'           WarnFound
 
     C     @PPTFR        IFEQ      *BLANKS
      *
      ** Warning WR4
      *
     C                   ADD       1             WIx
     C                   MOVEL     'DDDPNA'      WFldNmXAr(WIx)
     C                   MOVEL     'MMA0126'     WMsgIdXAr(WIx)
     C                   MOVE      'W'           DDDPNAOk
     C                   ELSE
      *
      ** Warning WR8
      *
     C                   ADD       1             WIx
     C                   MOVEL     'DDDPNA'      WFldNmXAr(WIx)
     C                   MOVEL     'MMA0130'     WMsgIdXAr(WIx)
     C                   MOVE      'W'           DDDPNAOk
     C                   ENDIF
 
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
     C*
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
 
     C     EDPNAV        ENDSR
 
      *****************************************************************
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
 
     C     *entry        PLIST
      ** Return Code Error Indicator (1A)
     C                   PARM                    RetCodeIn
 
      ** Received Parameters
      ** -------------------
      * Screen Inputs
      * Nominal Amount (12A)
      * In Depot (10A)
      * Out Depot (10A)
      * Portfolio Refernece  (4A)
     C                   PARM                    DDDPNA
     C                   PARM                    DDDPID
     C                   PARM                    DDDPOD
     C                   PARM                    DDPTFR
 
      * Transaction Details
      * Security Shortname (10A)
      * Branch (3A)
      * Beneficiary customer (6S 0)
     ** Customer Classification (1A)
     C                   PARM                    DPSS
     C                   PARM                    DPBA
     C                   PARM                    DPBN
     C                   PARM                    BFCLASCust
 
     **ICD
     ** System Details
 
     ** Rundate  (5P 0)
     ** S01496 Indicator (1A)
     ** Reference Attached (4A)
     C                   PARM                    RUND
     C                   PARM                    S01496
     C                   PARM                    FCR997
     C                   PARM                    CSE007            1
     C                   PARM                    CEU017            1
     C                   PARM                    BGN4ST            1            CPB001
 
 
     ** Returned Parameters
     ** -------------------
 
      * Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
     C                   PARM                    WFldNmXAr
     C                   PARM                    WMsgIDXAr
     C                   PARM                    WMsgDtXAr
 
      ** Nominal Amount Ok Indicator (1A)
      ** Nominal Amount (11P 0)
     C                   PARM                    DDDPNAOk
     C                   PARM                    DPNA
     C                   PARM                    @PCOLF            1                          CGL011
 
      ** Program, module and procedure names for database error processing.
      ** =================================================================
      ** The following /COPY sets these values
 
     C/COPY ZACPYSRC,DBFIELDS
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
     C/COPY ZACPYSRC,PSSR_ILE
      ********************************************************************
**  CPY@
(c) Finastra International Limited 2001
