     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas SE Validate Price')                              *
      *****************************************************************
      *                                                               *
      *  Midas - Security Trading Module                              *
      *                                                               *
      *  SEVDPRICE - Validate Price.                                  *
      *                                                               *
      *  Function:  This module performs the validation for the       *
      *             Price field.                                      *
      *                                                               *
      *  This module is an ILE/RPG IV conversion of the validation    *
      *  routine for the said field. This routine has been retrieved  *
      *  from SE0070 and has been converted to ILE RPG and copied into*
      *  this member.  Necessary code to make this compileable has    *
      *  been added (entry and exit points and some declares).        *
      *                                                               *
      *  The existing code has not been changed except:               *
      *  - to remove dead lines                                       *
      *  - to convert a couple of EXSRs to CALLBs                     *
      *                                                               *
      *  (c) Finastra International Limited 2001                      *
      *                                                               *
      *    This source is centrally supported and must ONLY be        *
      *    amended by Core Development Personnel                      *
      *                                                               *
      *    /COPY, Client or Country amendments must not be            *
      *    applied to this source.                                    *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      *  Prev Amend No. AR1071702          Date 08Jan13               *
      *                 CRE073             Date 06Dec10               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CSD027             Date 09Dec05               *
      *                 CSE075             Date 17Nov05               *
      *                 CSE074             Date 30Aug05               *
      *                 CSE071             Date 19Jul05               *
      *                 CAS006             Date 21Jan03               *
      * Midas Release 4.01 -------------------------------------------*
      *                 CSE031             Date 13Dec01               *
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.05 -----------------------------------------------*
      *                 CSD006             Date 11Oct00               *
      * Midas DBA 3.03 -----------------------------------------------*
      *                 CAP137             Date 07Feb00               *
      * Midas DBA 3.00 ---------------- Base -------------------------*
      *                 CPL002             Date 08MAR99               *
      *                 CAP003  *CREATE    Date 25Feb98               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  AR1071702 - Market price not defaulted                       *
      *  CRE073 - Interest Rate Rounding (Recompile)                  *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CSE075 - US Enhanced Treasury Upgrade to MidasPlus           *
      *           (Recompile)                                         *
      *  CSE074 - Const. Yld Amort. Upgrade to MidasPlus (Recompile)  *
      *  CSE071 - Multiple Holidays Re Securities (recompile)         *
      *  CAS006 - Hedge Accounting Phase B (Recompile)                *
      *  CSE031 - Coupon Fixing for Floating Rate Notes.              *
      *           Recompiled due to changes in SECTYD.                *
      *  CSD006 - Recompiled over changed SECTYD.                     *
      *  CAP137 - Conversion of SE Security inputs into modular       *
      *           structure to use as APIs (SECTYD)                   *
      *  CPL002 - Midas-Plato Interface (Recompiled)                  *
      *  CAP003 - Conversion of SE inputs into modular structure to   *
      *           use as APIs.                                        *
      *                                                               *
      *****************************************************************
 
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
 
     FPRICM     IF   E           K DISK
     FINVTP     IF   E           K DISK
 
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
 
      ** Security Details
     D SECTY         E DS                  EXTNAME(SECTYD)
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
      ** Input fields
      ** ------------
 
      ** Screen input
     D DDMKTP          S             16A
 
      ** Transaction details
     D DPMD            S              5P 0
     D DPDO            S              5P 0
     D*DPID*****       S              6S 0                                                    CSD027
     D*DPOD*****       S              6S 0                                                    CSD027
     D DPID            S              6A                                                      CSD027
     D DPOD            S              6A                                                      CSD027
 
      ** ICD
      ** System inputs
 
     D S01496          S              1A
     D BJDFIN          S              1A
 
     ** Other inputs ***
 
     D Proctype        S              1A
     D ZNOML           S             15P 0
     D SCUMEX          S              1A
     D WRKPI           S             15P 9
     D NomCcyDec       S              1P 0
 
      *** Output ***
     D MKTP            S             15P 8
     D DDMKTPOk        S              1A
 
      *** WORKING VARIABLES ***
 
     D APWRK1          S             15P 8
     D APWRK2          S             15P 8
     D BLNKTT          S             15A
     D CKPRIC          S             15P 8
     D MKPRL           S             15P 8
     D MKPRP           S             15P 8
     D RES70X          S              1A
     D WK158           S             15P 8
     D WXPRIC          S             15P 8
     D WWDPVD          S              5P 0
     D WWPPRC          S             15P 8
     D WWPSSN          S             10A
     D WWTDDT          S              5P 0
     D ZADEC           S              1P 0
     D ZADIG           S              2P 0
     D ZAlignOk        S              1A
     D ZFIELD          S             16A
     D ZPRCIN          S             15P 8
     D ZPRCOT          S             15P 8
     D ZYLDOK          S              1A
     D ZFDATE          S              5P 0
 
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
 
 
      ** +--- Start of Main processing -----------------------------------+
      ** ¦                                                                ¦
      ** ¦ Initial processing is performed automatically: the *inzsr is   ¦
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
      *
      ** VALIDATION
      *
     C                   EXSR      MKTPV
      *
      ** If an error was found, set the return code appropriately
      *
     C     DDMKTPOK      IFEQ      'N'
     C                   EVAL      RetCodeIn = 'Error'
     C                   ENDIF
 
     C                   RETURN
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * MKTPV - Validation routine for Market Price                   *
      *                                                               *
      * Called by: Main                                               *
      *                                                               *
      * Calls: SR70XA                                                 *
      *                                                               *
      *****************************************************************
 
     C     MKTPV         BEGSR
 
      *
      ** Market price
      *
     C     DDMKTP        IFNE      *BLANKS
      *
      ** Check valid number entered
      *
     C                   MOVE      *BLANKS       ZFIELD
     C                   MOVE      DDMKTP        ZFIELD
     C                   ELSE
     C                   MOVE      *BLANKS       ZFIELD
     C                   MOVE      MKPR          ZFIELD
     C                   Z-ADD     8             ZADEC                                     AR1071702
      *                                                                                    AR1071702
     C                   CALLB     'ZEDIT'                                                 AR1071702
     C                   PARM                    ZFIELD                                    AR1071702
     C                   PARM                    ZADEC                                     AR1071702
     C                   END
      *
     C                   Z-ADD     7             ZADIG
     C                   Z-ADD     8             ZADEC
 
     C                   CALLB     'ZALIGN'
     C                   PARM                    ZALIGNok
     C                   PARM                    ZFIELD
     C                   PARM                    ZADEC
     C                   PARM                    ZADIG
      *
     C     ZAlignOk      IFEQ      'N'
      *
      ** Error 220
      *
     C                   ADD       1             Idx
     C                   MOVEL     'DDMKTP'      FldNamXAr(Idx)
     C                   MOVEL     'MMA0354'     MsgIdXAr(Idx)
     C                   MOVE      'N'           DDMKTPOk
     C                   Z-ADD     *ZEROS        MKTP
     C                   ELSE
     C                   MOVE      ZFIELD        MKTP
     C                   Z-ADD     8             ZADEC
 
     C                   CALLB     'ZEDIT'
     C                   PARM                    ZFIELD
     C                   PARM                    ZADEC
 
     C                   MOVE      ZFIELD        DDMKTP
      *
     C     S01496        IFNE      'Y'
      *
      ** Check entry is within 10% of current market price
      *
     C     MKPR          DIV(H)    10            WK158
     C     MKPR          ADD       WK158         MKPRP
     C     MKPR          SUB       WK158         MKPRL
      *
     C     MKTP          IFGT      MKPRP
      *
      ** Warning W05
      *
     C                   ADD       1             WIx
     C                   MOVEL     'DDMKTP'      WFldNmXAr(WIx)
     C                   MOVEL     'MMA0204'     WMsgIdXAr(WIx)
     C                   MOVE      'W'           DDMKTPOk
     C                   ELSE
      *
     C     MKTP          IFLT      MKPRL
      *
      ** Warning W05
      *
     C                   ADD       1             WIx
     C                   MOVEL     'DDMKTP'      WFldNmXAr(WIx)
     C                   MOVEL     'MMA0204'     WMsgIdXAr(WIx)
     C                   MOVE      'W'           DDMKTPOk
     C                   END
      *
     C                   END
 
     C                   ELSE
      *
      **  .... get depot value date into WWDPWD
      *
     C     DPMD          IFEQ      0
     C                   MOVE      DPDO          WWDPVD
     C                   ELSE
     C     DPDO          IFEQ      0
     C                   MOVE      DPMD          WWDPVD
     C                   ELSE
     C     DPMD          IFGT      DPDO
     C                   MOVE      DPDO          WWDPVD
     C                   ELSE
     C                   MOVE      DPMD          WWDPVD
     C                   END
     C                   END
     C                   END
      *
      ** Obtain and convert Market Price (Result kept in CKPRIC)
      *
     C                   MOVE      SESN          WWPSSN
     C                   Z-ADD     WWDPVD        WWTDDT
 
     C                   EXSR      SR70XA
      *
      ** IF PRICE FOUND IN SR70XA   USE THIS PRICE
      *
     C     RES70X        IFEQ      'Y'
     C                   Z-ADD     WWPPRC        WXPRIC
     C                   ELSE
     C                   Z-ADD     MKPR          WXPRIC
     C                   END
      *
      ** If Trade basis discount or yield convert to percentage price
      ** for checking
      *
     C     STBS          IFEQ      'D'
     C     STBS          OREQ      'Y'
     C                   MOVE      WXPRIC        ZPRCIN
     C                   MOVE      WWDPVD        ZFDATE
 
     C                   CALLB     'ZPRCI'
     C                   PARM                    ZPRCIN
     C                   PARM                    ZFDATE
     C                   PARM                    SECTY
     C                   PARM                    NomCcyDec
     C                   PARM                    ProcType
     C                   PARM                    ZNOML
     C                   PARM                    WRKPI
     C                   PARM                    SCUMEX
     C                   PARM                    BJDFIN
     C                   PARM                    ZYLDOk
     C                   PARM                    ZPRCOT
 
     C                   MOVE      ZPRCOT        CKPRIC
     C                   ELSE
     C                   Z-ADD     WXPRIC        CKPRIC
     C                   END
      *
      ** Obtain price tolerance limit from INVTP
      *
     C     INVKA         KLIST
     C                   KFLD                    NMCY
     C                   KFLD                    SITP
 
     C     INVKA         CHAIN     INVTPDF                            33
 
     C     *IN33         IFEQ      '1'
     C     RECI          OREQ      '*'
     C     PRTO          OREQ      0
     C                   Z-ADD     10            PRTO
     C                   END
      *
      ** If tolerance was not entered, use 10%
      *
     C     PRTO          IFEQ      0
     C                   Z-ADD     10            PRTO
     C                   END
      *
      **   ....  check for % tolerance interval (PRTO)
      *
     C     PRTO          DIV       100           APWRK1
     C     CKPRIC        MULT      APWRK1        APWRK1
     C     CKPRIC        ADD       APWRK1        APWRK2
 
     C     MKTP          IFGT      APWRK2
      *
      ** Warning W05
      *
     C                   ADD       1             WIx
     C                   MOVEL     'DDMKTP'      WFldNmXAr(WIx)
     C                   MOVEL     'MMA0204'     WMsgIdXAr(WIx)
     C                   MOVE      'W'           DDMKTPOk
     C                   ELSE
      *
     C     CKPRIC        SUB       APWRK1        APWRK2
 
     C     MKTP          IFLT      APWRK2
      *
      ** Warning W05
      *
     C                   ADD       1             WIx
     C                   MOVEL     'DDMKTP'      WFldNmXAr(WIx)
     C                   MOVEL     'MMA0204'     WMsgIdXAr(WIx)
     C                   MOVE      'W'           DDMKTPOk
     C                   END
 
     C                   END
     C                   END
      *
     C                   END
      *
      ** If Walk In/Out, default price to market price from security
      ** provided that price is not zero.
      *
      *
      ** Walk In
      *
     C*****DPID*         IFNE      *ZEROS                                                     CSD027
     C     DPID          IFNE      *BLANKS                                                    CSD027
     C     DPMD          ANDNE     *ZEROS
     C*****DPOD*         ANDEQ     *ZEROS                                                     CSD027
     C     DPOD          ANDEQ     *BLANKS                                                    CSD027
     C     DPDO          ANDEQ     *ZEROS
      *
      ** Walk Out
      *
     C*****DPID*         OREQ      *ZEROS                                                     CSD027
     C     DPID          OREQ      *BLANKS                                                    CSD027
     C     DPMD          ANDEQ     *ZEROS
     C*****DPOD*         ANDNE     *ZEROS                                                     CSD027
     C     DPOD          ANDNE     *BLANKS                                                    CSD027
     C     DPDO          ANDNE     *ZEROS
 
     C     MKTP          IFEQ      *ZEROS
     C     MKPR          ANDNE     *ZEROS
     C                   Z-ADD     MKPR          MKTP
     C                   END
 
     C                   MOVE      MKTP          BLNKTT
 
     C     MKTP          IFEQ      *ZEROS
     C     MKPR          ANDEQ     *ZEROS
     C     BLNKTT        OREQ      *BLANKS
     C     MKPR          ANDEQ     *ZEROS
      *
      ** Error 220
      *
     C                   ADD       1             Idx
     C                   MOVEL     'DDMKTP'      FldNamXAr(Idx)
     C                   MOVEL     'MMA0354'     MsgIdXAr(Idx)
     C                   MOVE      'N'           DDMKTPOk
     C                   END
 
     C                   END
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      ** SR70XA - SR to test price within % tolerance of market price *
      *                                                               *
      **  WWPSSN   : Securit Shortname                                *
      **  WWTDDT   : Trade date                                       *
      **  WWPPRC   : (OUT) Market price Found                         *
      **  RES70X   : (OUT) 'Y'= Do the check                          *
      **                   'N'= Do not do the check, Price not found  *
      *                                                               *
      *****************************************************************
      *
     C     SR70XA        BEGSR
      *
      ** KLIST for PRICES File
      *
     C     KPRICN        KLIST
     C                   KFLD                    WWPSSN
     C                   KFLD                    WWTDDT
      *
      ** Find Market Price with Correct Date
     C                   MOVE      'N'           RES70X
      *
     C     KPRICN        SETGT     PRICM
     C                   READP     PRICM                                  44
      *
      ** If record found use this price
      *
     C     *IN44         IFEQ      '0'
     C     PSSN          ANDEQ     WWPSSN
     C                   MOVE      'Y'           RES70X
      *
      ** ..Otherwise check for current price
      *
     C                   ELSE
     C                   Z-ADD     *HIVAL        WWTDDT
      *
     C     KPRICN        SETGT     PRICM
     C                   READP     PRICM                                  44
      *
      ** If record found use this price
      *
     C     *IN44         IFEQ      '0'
     C     PSSN          ANDEQ     WWPSSN
     C                   MOVE      'Y'           RES70X
     C                   END
     C                   END
      *
     C     RES70X        IFEQ      'N'
     C                   Z-ADD     0             WWPPRC
     C                   ELSE
     C                   Z-ADD     PPRC          WWPPRC
     C                   ENDIF
      *
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * *inzsr - Program Initialisation routine                       *
      *                                                               *
      * Called by: Implicitly on program activation                   *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
 
     C     *inzsr        BEGSR
 
     C     *entry        PLIST
 
      ** Return Code Error Indicator
     C                   PARM                    RetCodeIn
 
      ** Received parameters
      ** -------------------
 
      ** Screen inputs **
      ** Market Price (16A)
     C                   PARM                    DDMKTP
 
      ** Transaction Details
      ** Date In (5P 0)
      ** Date Out (5P 0)
      ** In Depot (6S 0)
      ** Out Depot (6S 0)
      ** Security details **
      ** Security Processing type (1A)
     C                   PARM                    DPMD
     C                   PARM                    DPDO
     C                   PARM                    DPID
     C                   PARM                    DPOD
     C                   PARM                    SECTY
     C                   PARM                    ProcType
 
      ** ICD
      ** System Input
 
      ** Date format (1A)
      ** S01496 indicator (1A)
     C                   PARM                    BJDFIN
     C                   PARM                    S01496
 
      ** Inputs used for ZPRCI subroutine
 
      ** Purchased interest working variable (15P 9)
      ** CUM/Ex-coupon indicator (1A)
      ** Nominal (15P 0)
      ** Nominal Currency Decimal Position  (1P 0)
     C                   PARM                    WRKPI
     C                   PARM                    SCUMEX
     C                   PARM                    ZNOML
     C                   PARM                    NomCcyDec
 
      ** Returned parameters
      ** -------------------
 
      * Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
     C                   PARM                    WFldNmXAr
     C                   PARM                    WMsgIDXAr
     C                   PARM                    WMsgDtXAr
 
      ** Price Ok Indicator (1A)
      ** Price (15P 8)
     C                   PARM                    DDMKTPOk
     C                   PARM                    MKTP
 
      **--------------------------------------------------------------------------------------------
      ** The following /COPY sets the values of program, module and
      ** procedure names for database error processing.
     C/COPY ZACPYSRC,DBFIELDS
      **--------------------------------------------------------------------------------------------
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      **--------------------------------------------------------------------------------------------
      ** The following /COPY contains the standard program status
      ** subroutine, including a bound call to the DBERRCTL module.
     C/COPY ZACPYSRC,PSSR_ILE
      **--------------------------------------------------------------------------------------------
      ********************************************************************
**  CPY@
(c) Finastra International Limited 2001
