     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2001')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas IR Validate value date (IRS)')
      *****************************************************************
      *                                                               *
      *  Midas - FRA/IRS Module                                       *
      *                                                               *
      *  IRVIRSVDAT -  Validate Value Date for IRS                    *
      *                                                               *
      *  Function:  This module receives a parameter containing the   *
      *             value date and confirms whether it has a valid    *
      *             value. If it is valid the 10A return code will be *
      *             blank; if it is not it will contain 'Error'       *
      *                                                               *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2001            *
      *                                                               *
      *    This source is centrally supported and must ONLY be        *
      *    amended by Core Development Personnel                      *
      *                                                               *
      *    /COPY, Client or Country amendments must not be            *
      *    applied to this source.                                    *
      *                                                               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *  Last Amend No. CSD027             Date 09Dec05               *
      *  Prev Amend No. CGL029             Date 01Sep03               *
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.02 -----------------------------------------------*
      *                 167511             Date 14Sep99               *
      * Midas DBA 3.00 ---------------- Base -------------------------*
      *                 CAP003  *CREATE    Date 19May98               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CGL029 - Increase Account Code to 10 digits                  *
      *  167511 - FRA/IRS functions fail if dates contain invalid data*
      *           (also fix mistreatment of warning errors)           *
      *  CAP003 - Conversion of IRS inputs into modular structure to  *
      *           use as APIs.                                        *
      *                                                               *
      *****************************************************************
 
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
 
      *Day number for holdiay passed as parameter
     D   ZDAYNO        S              5P 0
 
      *Error message to be handed back as a parameter
     D   Msgid1        S                   LIKE(#Msgid)
 
      * Warning message passed back to calling program as a parameter
     D  WMsgId1        S                   LIKE(#Msgid)
 
      * Warning message passed back to calling program as a parameter
     D  WMsgId2        S                   LIKE(#Msgid)
 
      * Work Message field
     D  WorkMsg        S                   LIKE(#Msgid)
 
      *Maturity Date passed as a parameter
     D   SVDAT         S              6A
 
      ** Deal date passed as a parameter from calling program
     D  SDDAT          S              6A
 
      *Maturity date passed as a parameter to ZDATE1
     D   ZDATE         S              6A
 
      **Error flag returned by ZDATE1
     D   Errorflag     S              1A
 
      *Deal date as midas deal no. for file output. Passed as a parameter
     D   DDATX         S              5P 0
 
      *Run day number passed as a parameter
     D   BJRDNB        S              5  0
 
      **Date format indicator. Passed as an indicator to ZDATE1
     D   BJDFIN        S              1A
 
      *Local currency passed as a parameter
     D   BJLCCY        S              3A
 
      *Location code passed as a parameter
     D   BJSLCD        S              3A
 
      *Deal our currency passed as a parameter
     D   SUCUCY        S              3A
 
      *Deal their currency passed as a parameter
     D   STCUCY        S              3A
 
      *Effective currency set in program
     D   EFFCCY        S              3A
 
      **Holiday Check indicator passed from ZCHKH
     D   ZIND          S              1A
 
      **Currency passed to ZCHKH
     D   ZCCY          S              3A
 
      **Location code passed to ZCHKH
     D   ZLOC          S              3A
 
      ** Receive / Pay Settlement Method & Nostro
     D RecSetCcy       S              3A
     D RecSetMeth      S              2S 0
     D*RecNostro****** S             12A                                                      CGL029
     D RecNostro       S             18A                                                      CGL029
     D PaySetCcy       S              3A
     D PaySetMeth      S              2S 0
     D*PayNostro****** S             12A                                                      CGL029
     D PayNostro       S             18A                                                      CGL029
 
      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
 
      *Generel ledger details accessed via acess program
     D   SDGELR      E DS                  EXTNAME(SDGELRPD)
      ** External data structure for nostros file
     D SDNOST        E DS                  EXTNAME(SDNOSTPD)
     D  QQACC1       E                     EXTFLD(QQACCD)                                     CGL029
      ** External data structure for access programs (short)
     D DSFDY         E DS                  EXTNAME(DSFDY)
 
 
      ** +--------------------------------------+
      ** ¦ Named constants                      ¦
      ** ¦ ===============                      ¦
      ** +--------------------------------------+
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
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
 
      *
     C                   RESET                   Errorfound
     C                   RESET                   WarnFound                      166636
     C                   RESET                   Msgid1
     C                   RESET                   WMsgid1
     C                   RESET                   WMsgid2
     C                   RESET                   WorkMsg
      *
      ** Convert valid deal date into Midas day number for later processing
     C                   TESTN                   SDDAT                9798      167511
     C     *IN97         IFEQ      '1'                                          167511
     C     *IN98         OREQ      '1'                                          167511
     C                   MOVE      SDDAT         ZDATE
     C                   CALLB     'ZDATE1'
     C                   PARM                    ZDATE
     C                   PARM                    ZDAYNO
     C                   PARM                    BJDFIN
     C                   PARM                    Errorflag
     C                   MOVE      ZDAYNO        DDATX
     C                   ENDIF                                                  167511
      *                                                                         167511
      **Test value date to ensure not blank or not numeric
      *
     C     SVDAT         IFNE      *BLANKS
                                                                                167511
     C*******************MOVE      '0'           *IN84                          167511
     C*******************TESTN                   SVDAT                84        167511
     C******IN84*********IFEQ      *ON                                          167511
                                                                                167511
     C                   TESTN                   SVDAT                9798      167511
     C     *IN97         IFEQ      '1'                                          167511
     C     *IN98         OREQ      '1'                                          167511
     C                   MOVE      'Y'           NUMok             1            167511
     C                   ELSE                                                   167511
     C                   MOVE      'N'           NUMok                          167511
     C                   ENDIF                                                  167511
                                                                                167511
     C     NUMok         IFEQ      'Y'                                          167511
      *
      *If numeric valid date using ZDATE1
      *
     C                   MOVE      SVDAT         ZDATE
     C                   CALLB     'ZDATE1'
     C                   PARM                    ZDATE
     C                   PARM                    ZDAYNO
     C                   PARM                    BJDFIN
     C                   PARM                    Errorflag
     C                   END
     C                   END
     C     SVDAT         IFEQ      *BLANKS
     C     NUMok         OREQ      'N'                                          167511
     C******IN84*********OREQ      *OFF                                         167511
     C     Errorflag     OREQ      'Y'
     C                   MOVE      'Y'           Errorfound
     C                   MOVEL     'MMA0006'     Msgid1
     C                   ENDIF
 
      *
      *If the date is valid save it as a Midas day number
      *
     C     SVDAT         IFNE      *BLANKS
     C     NUMok         ANDEQ     'Y'                                          167511
     C******IN84*********ANDEQ     *ON                                          167511
     C     Errorfound    ANDNE     'Y'
     C                   MOVE      ZDAYNO        VDATX             5 0
     C                   END
 
      * Value Date must be greater or equal to deal date
     C
     C     Errorfound    IFNE      'Y'
     C     VDATX         IFLT      DDATX
     C                   MOVE      'Y'           Errorfound
     C                   MOVEL     'MMA0007'     Msgid1
     C                   ENDIF
     C                   ENDIF
      *
      * If no errors, validate for holidays
      *
     C     Errorfound    IFNE      'Y'
      *
      * Receipt details - checking only required if settlement details
      * are present
      *
     C     RecSetMeth    IFGT      00
      *
      **  If settlement method is via a nostro (01, 02, 07, 08, 12)
      *
     C     RecSetMeth    IFEQ      01
     C     RecSetMeth    OREQ      02
     C     RecSetMeth    OREQ      07
     C     RecSetMeth    OREQ      08
     C     RecSetMeth    OREQ      12
      *
      * Set effective currency from entry parms
      * Receipt Settle ccy, if present, otherwise transaction ccy
      * Set correct warning message, to be sent if date is a holiday
      *
     C     RecSetCcy     IFNE      *BLANK
     C                   EVAL      EFFCCY = RecSetCcy
     C                   EVAL      WorkMsg = 'MMM3000'
     C                   ELSE
     C                   EVAL      EFFCCY = STCUCY
     C                   EVAL      WorkMsg = 'MMM0129'
     C                   ENDIF
      *
      **  Effective currency.
     C                   MOVEL     EFFCCY        ZCCY
      *
      **  Get nostro details.
     C                   MOVEL     RecNostro     WRK2              2
      *
     C                   CALLB     'AONOSTR0'
     C                   PARM      *BLANKS       @RTCD             7
     C                   PARM      '*KEY   '     @OPTN             7
     C                   PARM      *BLANK        @CUST             6            Customer No.
     C                   PARM      EFFCCY        @CCY              3            Currency
     C**********         PARM      *BLANKS       @ACCD             4            A/C Code      CGL029
     C                   PARM      *BLANKS       @ACCD            10                          CGL029
     C                   PARM      *BLANKS       @ACSN             2            A/C Seq
     C                   PARM      WRK2          @NOST             2            Nostro No.
     C                   PARM      *BLANKS       @BRCD             3            Branch Code
     C                   PARM      *BLANKS       @CSSN            10            Cust. Shortname
     C                   PARM      *BLANKS       @PNOI             1            Prime Nost. Ind
     C     SDNOST        PARM      SDNOST        DSFDY
      *
      **  Get location from last 3 positions of Nostro shortname.
     C                   MOVE      A7NOSN        ZLOC
      *
     C                   ELSE
      *
      **  If settlement method not via a nostro,
      **  set ZLOC and ZCCY to local values.
      ** Set correct warning message, to be sent if date is a holiday
     C                   EVAL      WorkMsg = 'MMM0131'
     C                   MOVE      BJLCCY        ZCCY
     C                   MOVE      BJSLCD        ZLOC
      *
     C                   ENDIF
      *
      **  Check if holiday.
     C                   CALLB     'ZCHKH'
     C                   PARM                    VDATX
     C                   PARM                    ZCCY
     C                   PARM                    ZLOC
     C                   PARM                    ZIND
      *
      **  If it is a holiday, display warning error.
     C     ZIND          IFEQ      'H'
     C                   EVAL      WMsgId1 = WorkMsg
     C                   EVAL      WarnFound    = 'Y'                           166636
     C*******************MOVE      'Y'           ErrorFound                     166636
     C                   ENDIF
      *
     C                   ENDIF
      *
      * Payment details - checking only required if settlement details
      * are present
      *
     C     PaySetMeth    IFGT      00
      *
      **  If settlement method is via a nostro (01, 02, 07, 08, 12)
      *
     C     PaySetMeth    IFEQ      01
     C     PaySetMeth    OREQ      02
     C     PaySetMeth    OREQ      07
     C     PaySetMeth    OREQ      08
     C     PaySetMeth    OREQ      12
      *
      * Set effective currency from entry parms
      * Receipt Settle ccy, if present, otherwise transaction ccy
      * Set correct warning message, to be sent if date is a holiday
      *
     C     PaySetCcy     IFNE      *BLANK
     C                   EVAL      EFFCCY = PaySetCcy
     C                   EVAL      WorkMsg = 'MMM3000'
     C                   ELSE
     C                   EVAL      EFFCCY = SUCUCY
     C                   EVAL      WorkMsg = 'MMM0129'
     C                   ENDIF
      *
      **  Effective currency.
     C                   MOVEL     EFFCCY        ZCCY
      *
      **  Get nostro details.
     C                   MOVEL     PayNostro     WRK2
      *
     C                   CALLB     'AONOSTR0'
     C                   PARM      *BLANKS       @RTCD             7
     C                   PARM      '*KEY   '     @OPTN             7
     C                   PARM      *BLANK        @CUST             6            Customer No.
     C                   PARM      EFFCCY        @CCY              3            Currency
     C**********         PARM      *BLANKS       @ACCD             4            A/C Code      CGL029
     C                   PARM      *BLANKS       @ACCD                                        CGL029
     C                   PARM      *BLANKS       @ACSN             2            A/C Seq
     C                   PARM      WRK2          @NOST             2            Nostro No.
     C                   PARM      *BLANKS       @BRCD             3            Branch Code
     C                   PARM      *BLANKS       @CSSN            10            Cust. Shortname
     C                   PARM      *BLANKS       @PNOI             1            Prime Nost. Ind
     C     SDNOST        PARM      SDNOST        DSFDY
      *
      **  Get location from last 3 positions of Nostro shortname.
     C                   MOVE      A7NOSN        ZLOC
      *
     C                   ELSE
      *
      **  If settlement method not via a nostro,
      **  set ZLOC and ZCCY to local values.
      ** Set correct warning message, to be sent if date is a holiday
     C                   EVAL      WorkMsg = 'MMM0131'
     C                   MOVE      BJLCCY        ZCCY
     C                   MOVE      BJSLCD        ZLOC
      *
     C                   ENDIF
      *
      **  Check if holiday.
     C                   CALLB     'ZCHKH'
     C                   PARM                    VDATX
     C                   PARM                    ZCCY
     C                   PARM                    ZLOC
     C                   PARM                    ZIND
      *
      **  If it is a holiday, display warning error.
      **  No need to send same message as for receive side
     C     ZIND          IFEQ      'H'
     C     WorkMsg       IFNE      WMsgId1
     C                   EVAL      WMsgId2 = WorkMsg
     C                   ENDIF
     C                   EVAL      WarnFound    = 'Y'                           166636
     C*******************MOVE      'Y'           ErrorFound                     166636
     C                   ENDIF
      *
     C                   ENDIF
     C                   ENDIF
 
     C*******************IF        ErrorFound = 'Y'                             166636
     C*******************EVAL      RetCodeIn = 'Error'                          166636
     C*******************ENDIF                                                  166636
 
      ** The return code is set in the following /COPY:                         166636
     C/COPY ZACPYSRC,SETRETCDE                                                  166636
 
     C                   RETURN
 
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
     C                   PARM                    ReturnCode                     166636
     C*******************PARM                    RetCodeIn                      166636
     C                   PARM                    Msgid1
     C                   PARM                    WMsgId1
     C                   PARM                    WMsgId2
     C                   PARM                    SVDAT
     C                   PARM                    SDDAT
     C                   PARM                    VDATX
     C                   PARM                    DDATX
     C                   PARM                    BJDFIN
     C                   PARM                    BJRDNB
     C                   PARM                    BJLCCY
     C                   PARM                    BJSLCD
     C                   PARM                    SUCUCY
     C                   PARM                    STCUCY
      ** Deal settlement instruction fields
     C                   PARM                    RecSetCcy
     C                   PARM                    RecSetMeth                     rec settle meth
     C                   PARM                    RecNostro
     C                   PARM                    PaySetCcy
     C                   PARM                    PaySetMeth                     pay settle meth
     C                   PARM                    PayNostro
 
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
(c) Misys International Banking Systems Ltd. 2001
