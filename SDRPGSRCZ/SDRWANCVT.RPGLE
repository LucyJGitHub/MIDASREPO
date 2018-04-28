     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2007')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Customer Risk Weighted Assets Conversion')
      *****************************************************************
      *                                                               *
      *  Midas - Standing Data ILE Module                             *
      *                                                               *
      *  SDRWANCVT - Customer Risk Weighted Assets Details Conversion:*
      *              File to Screen                                   *
      *                                                               *
      *  Function:  This module converts the fields of the Customer   *
      *             Risk Weighted Assets Details from file to screen  *
      *             format                                            *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2007            *
      *                                                               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      *  Last Amend No. CSD079  *CREATE    Date 05Feb07               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CSD079 - Enhanced Customer Maintenance API                   *
      *                                                               *
      *****************************************************************
 
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ Automatically included D-specs       ¦
      ** ¦ ==============================       ¦
      ** +--------------------------------------+
      **
      **------------------------------------------------------------------
      ** The following /COPY line includes (among others) the LDA layout
      ** and the copyright array definition:
     D/COPY ZACPYSRC,STD_D_SPEC
      **------------------------------------------------------------------
 
      **------------------------------------------------------------------
      ** The following /COPY includes the MM standard declares:
     D/COPY ZACPYSRC,STDDECLARE
      **------------------------------------------------------------------
 
      **------------------------------------------------------------------
      ** The following /COPY line includes all the defined fields in the
      ** Program Status Data Structures.  They have meaningful
      ** names, prefixed by 'PS'.
     D/COPY ZACPYSRC,PSDS
      **------------------------------------------------------------------
 
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
 
      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
 
     D TranFilFmt    E DS                  EXTNAME(SDVRWANPD)
      ** Risk Weighted Assets Details in File Format
 
     D TrnDets       E DS                  EXTNAME(SDRWANPD)
      ** Risk Weighted Assets Details in Screen Format
 
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
      ** EXTERNAL DS FOR BANK DETAILS
 
     D SCSARD        E DS                  EXTNAME(SCSARDPD)
      ** EXTERNAL DS FOR SAR DETAILS
 
     D DSFDY         E DS                  EXTNAME(DSFDY)
      ** FIRST DS FOR ACCESS PROGRAMS, SHORT DATA STRUCTURE
 
     D DSSDY         E DS                  EXTNAME(DSSDY)
      ** SECOND DS FOR ACCESS PROGRAMS, LONG DATA STRUCTURE
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
     D WACTN           S              1A
     D ZDAYNO          S              5P 0
     D ZDATE           S              6P 0
     D ZADATE          S              7A
     D ZFIELD          S             16A
     D ZADEC           S              1P 0
 
      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
      *****************************************************************
 
 
      *****************************************************************
      /EJECT
      *****************************************************************
 
      ** Initialisation
 
     C                   EXSR      SRINIT
 
      ** Set screen fields
 
     C                   EXSR      SRSCREEN
 
      ** Return
 
     C                   RETURN
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  *INZSR - INITIAL PROCESSING                                  *
      *                                                               *
      *****************************************************************
     C     *INZSR        BEGSR
 
      ** Program Parameters
 
     C     *ENTRY        PLIST
 
      ** Input Parameters
      ** Return Code
 
     C                   PARM                    RetCodeIn
 
      ** Risk Weighted Assets Details File Format
 
     C                   PARM                    TranFilFmt
 
      ** Output Parameters
      ** Risk Weighted Assets Details Screen Format
 
     C                   PARM                    TrnDets
 
      ** Initialise program name
 
     C                   EVAL      DBPGM = 'SDRWANCVT'
 
      ** Access Bank Details
 
     C                   CALL      'AOBANKR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*FIRST  '    @OPTN
     C     SDBANK        PARM      SDBANK        DSFDY
 
      ** Database Error
 
     C                   IF        @RTCD <> *BLANK
     C                   EVAL      DBKEY = @OPTN
     C                   EVAL      DBFILE = 'SDBANKPD'
     C                   EVAL      DBASE =  900
     C                   EXSR      *PSSR
     C                   ENDIF
 
      ** Program, module and procedure names for dbase error processing
      ** ==============================================================
      ** The following /COPY sets these values.
      /COPY ZACPYSRC,DBFIELDS
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRINIT - Initialisation                                      *
      *                                                               *
      *****************************************************************
     C     SRINIT        BEGSR
 
      ** Blank outputs (EXCEPT FOR ACTION CODE)
 
     C                   MOVEL     DDACTN        WACTN
     C                   MOVEL     *BLANK        TrnDets
     C                   MOVEL     WACTN         DDACTN
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRSCREEN - SET SCREEN FIELDS                                 *
      *                                                               *
      *****************************************************************
     C     SRSCREEN      BEGSR
 
      ** Customer Number
 
     C                   EVAL      DDCUST      =  RACUST
 
      ** RWA Code & Set Number
 
     C                   EVAL      DDCOD1 = RACOD1
     C                   EVAL      DDSET1 = RASET1
     C                   EVAL      DDCOD2 = RACOD2
     C                   EVAL      DDSET2 = RASET2
     C                   EVAL      DDCOD3 = RACOD3
     C                   EVAL      DDSET3 = RASET3
     C                   EVAL      DDCOD4 = RACOD4
     C                   EVAL      DDSET4 = RASET4
     C                   EVAL      DDCOD5 = RACOD5
     C                   EVAL      DDSET5 = RASET5
     C                   EVAL      DDCOD6 = RACOD6
     C                   EVAL      DDSET6 = RASET6
     C                   EVAL      DDCOD7 = RACOD7
     C                   EVAL      DDSET7 = RASET7
     C                   EVAL      DDCOD8 = RACOD8
     C                   EVAL      DDSET8 = RASET8
     C                   EVAL      DDCOD9 = RACOD9
     C                   EVAL      DDSET9 = RASET9
     C                   EVAL      DDCOD10 = RACOD10
     C                   EVAL      DDSET10 = RASET10
     C                   EVAL      DDCOD11 = RACOD11
     C                   EVAL      DDSET11 = RASET11
     C                   EVAL      DDCOD12 = RACOD12
     C                   EVAL      DDSET12 = RASET12
     C                   EVAL      DDCOD13 = RACOD13
     C                   EVAL      DDSET13 = RASET13
     C                   EVAL      DDCOD14 = RACOD14
     C                   EVAL      DDSET14 = RASET14
     C                   EVAL      DDCOD15 = RACOD15
     C                   EVAL      DDSET15 = RASET15
     C                   EVAL      DDCOD16 = RACOD16
     C                   EVAL      DDSET16 = RASET16
     C                   EVAL      DDCOD17 = RACOD17
     C                   EVAL      DDSET17 = RASET17
     C                   EVAL      DDCOD18 = RACOD18
     C                   EVAL      DDSET18 = RASET18
     C                   EVAL      DDCOD19 = RACOD19
     C                   EVAL      DDSET19 = RASET19
     C                   EVAL      DDCOD20 = RACOD20
     C                   EVAL      DDSET20 = RASET20
     C                   EVAL      DDCOD21 = RACOD21
     C                   EVAL      DDSET21 = RASET21
     C                   EVAL      DDCOD22 = RACOD22
     C                   EVAL      DDSET22 = RASET22
     C                   EVAL      DDCOD23 = RACOD23
     C                   EVAL      DDSET23 = RASET23
     C                   EVAL      DDCOD24 = RACOD24
     C                   EVAL      DDSET24 = RASET24
     C                   EVAL      DDCOD25 = RACOD25
     C                   EVAL      DDSET25 = RASET25
     C                   EVAL      DDCOD26 = RACOD26
     C                   EVAL      DDSET26 = RASET26
     C                   EVAL      DDCOD27 = RACOD27
     C                   EVAL      DDSET27 = RASET27
     C                   EVAL      DDCOD28 = RACOD28
     C                   EVAL      DDSET28 = RASET28
     C                   EVAL      DDCOD29 = RACOD29
     C                   EVAL      DDSET29 = RASET29
     C                   EVAL      DDCOD30 = RACOD30
     C                   EVAL      DDSET30 = RASET30
     C                   EVAL      DDCOD31 = RACOD31
     C                   EVAL      DDSET31 = RASET31
     C                   EVAL      DDCOD32 = RACOD32
     C                   EVAL      DDSET32 = RASET32
     C                   EVAL      DDCOD33 = RACOD33
     C                   EVAL      DDSET33 = RASET33
     C                   EVAL      DDCOD34 = RACOD34
     C                   EVAL      DDSET34 = RASET34
     C                   EVAL      DDCOD35 = RACOD35
     C                   EVAL      DDSET35 = RASET35
     C                   EVAL      DDCOD36 = RACOD36
     C                   EVAL      DDSET36 = RASET36
     C                   EVAL      DDCSSN = RACSSN
     C                   EVAL      DDCRNM = RACRNM
     C                   EVAL      DDCNA2 = RACNA2
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  ZDATE2 - Format a date for output                            *
      *                                                               *
      *****************************************************************
     C     ZDATE2        BEGSR
 
     C                   CALLB     'ZDATE2'
     C                   PARM                    ZDAYNO
     C                   PARM                    BJDFIN
     C                   PARM                    ZDATE
     C                   PARM                    ZADATE
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  ZEDIT - Edit an unsigned field                               *
      *                                                               *
      *****************************************************************
     C     ZEDIT         BEGSR
 
     C                   CALLB     'ZEDIT'
     C                   PARM                    ZFIELD           16
     C                   PARM      0             ZADEC             1 0
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * *PSSR  - Program exception error routine                      *
      *          Called automatically if a program error occurs,      *
      *          or directly by the program code using EXSR.          *
      *          This subroutine DUMPs the program, and performs      *
      *          a ROLLBACK.                                          *
      *                                                               *
      *****************************************************************
      ** The following /COPY contains the standard program status
      ** subroutine, including a bound call to the DBERRCTL module.
     C/COPY ZACPYSRC,PSSR_ILE
 
      *  Note: if non-standard processing required, use the PSSR_ILENE
      *  subroutine
      ****************************************************************
      /EJECT
      ****************************************************************
**  CPY@
(c) Misys International Banking Systems Ltd. 2007
