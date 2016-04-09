     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2001')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas IR Validate our/their rate fix days (IRS)')      *
      *****************************************************************
      *                                                               *
      *  Midas - IRA Validation Dealing Module                        *
      *                                                               *
      *  IRVRTFXDAY - Validate Our/Their Rate Change Days             *
      *                                                               *
      *  Function:  This module receives a parameter containing the   *
      *             Rate fix day field and confirms whether it has a  *
      *             valid value. If it is valid the 10A retrun code   *
      *             will be blank; if it is not it will contain       *
      *             'Error'.                                          *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2001            *
      *                                                               *
      *    This source is centrally supported and must ONLY be        *
      *    amended by Core Development Personnel                      *
      *                                                               *
      *    /COPY, Client or Country amendments must not be            *
      *    applied to this source.                                    *
      *                                                               *
      *  Last Amend No. CIR018             Date 06Aug14               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      *  Prev Amend No. 256564             Date 17Sep08               *
      *                 247210             Date 24Apr07               *
      *                 BUG13857           Date 01May07               *
      *                 BUG13340           Date 15Feb07               *
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CSD031             Date 10Apr06               *
      *                 BUG6283            Date 21Mar05               *
      *                 CIR011             Date 03Sep02               *
      * Midas Release 4.01 -------------------------------------------*
      *                 CAP055             Date 13Mar02               *
      * Midas Release 4 --------------- Base -------------------------*
      *                 CIR007             Date 11May01               *
      * Midas DBA 3.02 -----------------------------------------------*
      *                 163378             Date 05Jul99               *
      * Midas DBA 3.00 ---------------- Base -------------------------*
      *                 CAP003  *CREATE    Date 01Feb98               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CIR018 - Daily Rate Change Frequency for SIRS                *
      *  256564 - Recompile due to PF changes done by fix 256330      *
      *  247210 - MMA0038 incorrectly displayed. Move defaulted value *
      *           to the screen field after call to ZALIGN.           *
      *  BUG13857 - If the rate change freq is 'O' then the           *
      *             Rate Fix Days must be zero or blank               *
      *  BUG13340 - Unable to insert SIRS transaction with subtype    *
      *             OIS and rate change frequency "Overnight".        *
      *  CSD031 - Enhanced Centralised Static Data (Recompile)        *
      *  BUG6283- Rate Fix Days is not defaulted when trading currency*
      *           is GBP                                              *
      *  CIR011 - FRA/IRS Rate Fix Day Adjustment                     *
      *  CAP055 - APIs for FRA/IRS Caps/Collars/Floors                *
      *  CIR007 - Overnight Index Swaps                               *
      *  163378 - Our/ Their  Fix/Floating  Rate Days  is defaulting  *
      *           to '02'   but not showing on the screen at the time *
      *           of insertion. Move the default value to the screen  *
      *           field                                               *
      *  CAP003 - Conversion of MM inputs into modular structure to   *
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
 
      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
 
 
      ** +--------------------------------------+
      ** ¦ Named constants                      ¦
      ** ¦ ===============                      ¦
      ** +--------------------------------------+
 
      **Decimal data length passed as a parameter to ZALIGN
     D   ZADEC         S              1  0
 
      **Digital data length passed as a parameter to ZALIGN
     D   ZADIG         S              2  0
 
      **Field Passed to ZALIGN on which the work is done
     D   ZFIELD        S             16A
 
      **Indicator to show whether or not ZALIGN was successful
     D   ZALIGNok      S              1A
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
      **Error message passed back to calling programme
     D Msgid1          S                   LIKE(#msgid)
 
      **Our/Their base rate code passed as a parameter from calling program
     D  STBRTT         S              2A
 
      **Our/Their Rate Fix days passed as a parameter from calling p   rogramme
     D  STFRFD         S              2A
 
      **Currency passed as a parameter from calling programme
     D   SUCUCY        S              3A
 
      **Currency code passed as a parameter from calling programme
     D   BLCYCD        S              3A
 
      **Local currency code passed as a parameter from calling programme
     D   BJLCCY        S              3A
 
      **Entry validated through ZALIGN passed back to calling programme
     DRatFixDays       S              2S 0
 
      ** Rate Change Frequency Code                                                           CIR007
     DPRAtChgFq        S              1A                                                      CIR007
                                                                                              CIR007
      ** Deal Type used as Parameter                                                          CIR007
     DPDealTyp         S              2A                                                      CIR007
                                                                                              CIR007
      ** OVERNIGHT INDEX SWAPS                                                                CIR007
     DCIR007           S              1A                                                      CIR007
                                                                                              CIR007
      **Our/Their Rate Fix days working field                                                 CIR007
     DWSTFRFD          S              2  0                                                    CIR007
      ** Average rate method indicator passed as a parameter from calling program (Default-N)
     D  SAVRAM         S              1A
      *                                                                                       CIR011
     D SCSARD        E DS                  EXTNAME(SCSARDPD)                                  CIR011
      ** EXTERNAL DS FOR SAR DETAILS                                                          CIR011
      *                                                                                       CIR011
     D DSFDY         E DS                  EXTNAME(DSFDY)                                     CIR011
      ** FIRST DS FOR ACCESS PROGRAMS, SHORT DATA STRUCTURE                                   CIR011
      *                                                                                       CIR011
     D SDCURR        E DS                  EXTNAME(SDCURRPD)                                  CIR011
      ** EXTERNAL DS FOR CURRENCY DETAILS                                                     CIR011
      *                                                                                       CIR011
     D DSSDY         E DS                  EXTNAME(DSSDY)                                     CIR011
      ** SECOND DS FOR ACCESS PROGRAMS, LONG DATA STRUCTURE                                   CIR011
      *                                                                                       CIR011
     D CIR011          S              1A                                                      CIR011
     D PAJCD           S              3A                                                      CIR011
     D PNDADJ          S              1  0                                                    CIR011
     D PFRFDX          S              2  0                                                    CIR011
                                                                                              CIR011
      ** Deal is cap, collar or floor                                                         CAP055
     D PDealCACF       S              1A                                                      CAP055
 
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
 
     C                   RESET                   ErrorFound
     C                   RESET                   Msgid1
     C                   Z-ADD     0             RatFixDays
                                                                                              CAP055
      ** Check if deal is cap, collar or floor                                                CAP055
                                                                                              CAP055
     C                   IF        PDealTyp = 'RR' OR PDealTyp = 'RP'                         CAP055
     C                             OR PDealTyp = 'RF'                                         CAP055
     C                   EVAL      PDealCACF = 'Y'                                            CAP055
     C                   ELSE                                                                 CAP055
     C                   EVAL      PDealCACF = 'N'                                            CAP055
     C                   ENDIF                                                                CAP055
                                                                                              CIR007
      ** If CIR007 is on , Deal Type is 'RS' and Rate Change Frequency                        CIR007
      ** Code is 'O', then the Rate Fix Days must be zero or blank.                           CIR007
                                                                                              CIR007
     C                   IF        CIR007 = 'Y' AND PDealTyp = 'RS'                           CIR007
     C                             AND PRatChgFq = 'O'                                        CIR007
     C                             OR CIR018 = 'Y' AND PDealTyp = 'RS'                        CIR018
     C                             AND PRatChgFq = 'D'                                        CIR018
                                                                                              CIR007
     C                   IF        STFRFD = '  ' OR STFRFD = ' 0' OR                        BUG13340
     C                             STFRFD = '0 ' OR STFRFD = '00'                           BUG13340
     C                   EVAL      WSTFRFD = 0                                              BUG13340
     C                   ELSE                                                               BUG13340
     C                   MOVE      STFRFD        WSTFRFD                                      CIR007
     C                   ENDIF                                                              BUG13340
                                                                                            BUG13340
     C                   IF        STFRFD <> *BLANKS AND WSTFRFD <> 0                         CIR007
     C                   MOVE      'Y'           ErrorFound                                   CIR007
     C                   If        CIR018 = 'Y' AND PRatChgFq = 'D'                           CIR018
     C                   MOVE      '5047297'     Msgid1                                       CIR018
     C                   else                                                                 CIR018
     C                   MOVE      'MMA1179'     Msgid1                                       CIR007
     C                   Endif                                                                CIR018
     C**********         ELSE                                                        CIR007 BUG13340
     C**********         EVAL      STFRFD = ' 0'                                     CIR007 BUG13340
     C                   ENDIF                                                                CIR007
                                                                                              CIR007
     C                   ELSE                                                                 CIR007
 
     C     STFRFD        IFNE      *BLANKS
     C     STBRTT        IFEQ      *BLANKS
     C     PDealCACF     ANDEQ     'N'                                                        CAP055
     C     SAVRAM        OREQ      'Y'
     C                   MOVE      'Y'           ErrorFound
                                                                                              CAP055
     C                   IF        SAVRAM = 'Y'                                               CAP055
     C                   MOVEL     'MMM3009'     MsgId1                                       CAP055
     C                   ELSE                                                                 CAP055
     C                   MOVEL     'MMA0033'     MsgId1
     C                   ENDIF                                                                CAP055
                                                                                              CAP055
     C                   ELSE
     C                   MOVE      *BLANK        ZFIELD
     C                   Z-ADD     0             ZADEC
     C                   Z-ADD     02            ZADIG
     C                   MOVE      STFRFD        ZFIELD
     C                   CALLB     'ZALIGN'
     C                   PARM                    ZALIGNok
     C                   PARM                    ZFIELD
     C                   PARM                    ZADEC
     C                   PARM                    ZADIG
 
     C     ZALIGNok      IFEQ      'Y'
     C                   MOVE      ZFIELD        RatFixDays
                                                                                              247210
      * Move defaulted value to the screen field as well                                      247210
     C                   MOVE      RatFixDays    STFRFD                                       247210
     C                   ELSE
     C                   MOVE      'Y'           ErrorFound
     C                   MOVEL     'MMA0027'     Msgid1
     C                   ENDIF
     C                   ENDIF
     C                   ELSE
     C     STBRTT        IFNE      *BLANKS
     C     PDealCACF     ANDEQ     'N'                                                        CAP055
     C     SAVRAM        ORNE      'Y'                                                        CAP055
     C     PDealCACF     ANDEQ     'Y'                                                        CAP055
     C     SUCUCY        IFEQ      BLCYCD
     C     SUCUCY        ANDEQ     BJLCCY
     C     SAVRAM        OREQ      'Y'
     C     SUCUCY        ANDEQ     BLCYCD
     C     PDealCACF     ANDEQ     'N'                                                        CAP055
     C     SAVRAM        OREQ      'Y'
     C     SUCUCY        ANDEQ     BJLCCY
     C     PDealCACF     ANDEQ     'N'                                                        CAP055
     C                   Z-ADD     0             RatFixDays
      *                                                                                      BUG6283
      * Move defaulted value to the screen field as well .                                   BUG6283
     C                   MOVE      RatFixDays    STFRFD                                      BUG6283
      *                                                                                      BUG6283
     C                   ELSE
     C                   Z-ADD     2             RatFixDays
      *                                                                        163378
      * Move defaulted value to the screen field as well .                     163378
     C                   MOVE      RatFixDays    STFRFD                         163378
      *                                                                        163378
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
                                                                                              CIR007
     C                   ENDIF                                                                CIR007
      *                                                                                       CIR011
     C                   EXSR      SRCHKDEC                                                 BUG13857
     C                   IF        (CIR011 = 'Y') and STBRTT <> *Blanks                       CIR011
     C                             AND WSTFRFD <> *ZEROS                                    BUG13857
                                                                                              CIR011
      ** Rate Fix Days must be greater that adjustment days in SDCURRPD                       CIR011
      ** Validate only rate fix days if error free                                            CIR011
                                                                                              CIR011
     C                   CALLB     'AOCURRR0'                                                 CIR011
     C                   PARM      *BLANK        @RTCD                                        CIR011
     C                   PARM      '*KEY   '     @OPTN                                        CIR011
     C                   PARM      SUCUCY        PAJCD                                        CIR011
     C     SDCURR        PARM      SDCURR        DSSDY                                        CIR011
                                                                                              CIR011
     C                   Z-ADD     A6FXDY        PNDADJ                                       CIR011
     C                   MOVE      STFRFD        WSTFRFD                                      CIR011
     C     WSTFRFD       SUB       PNDADJ        PFRFDX                                       CIR011
                                                                                              CIR011
      ** IF LESS, IT IS AN ERROR                                                              CIR011
                                                                                              CIR011
     C     PFRFDX        IFLT      0                                                          CIR011
     C                   MOVE      'Y'           ErrorFound                                   CIR011
     C                   MOVEL     'MMA0027'     Msgid1                                       CIR011
                                                                                              CIR011
     C                   END                                                                  CIR011
                                                                                              CIR011
     C                   END                                                                  CIR011
 
     C                   IF        ErrorFound = 'Y'
     C                   EVAL      RetCodeIn = 'Error'
     C                   ENDIF
 
 
 
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
     C                   PARM                    RetCodeIn
     C                   PARM                    Msgid1
     C                   PARM                    STFRFD
     C                   PARM                    STBRTT
     C                   PARM                    SUCUCY
     C                   PARM                    BLCYCD
     C                   PARM                    BJLCCY
     C                   PARM                    RatFixDays
     C                   PARM                    PRatChgFq                                    CIR007
     C                   PARM                    PDealTyp                                     CIR007
     C                   PARM                    CIR007                                       CIR007
     C                   PARM                    SAVRAM                                       CAP055
      *                                                                                       CIR011
      **  Access SAR details file to determine if Rate Fix Day Adj is on.                     CIR011
      *                                                                                       CIR011
     C                   CALL      'AOSARDR0'                                                 CIR011
     C                   PARM      *BLANKS       @RTCD                                        CIR011
     C                   PARM      '*VERIFY'     @OPTN                                        CIR011
     C                   PARM      'CIR011'      @SARD                                        CIR011
     C     SCSARD        PARM      SCSARD        DSFDY                                        CIR011
      *                                                                                       CIR011
     C     @RTCD         IFNE      *BLANKS                                                    CIR011
     C     @RTCD         ANDNE     '*NRF   '                                                  CIR011
     C     *LOCK         IN        LDA                                                        CIR011
     C                   MOVEL     'SCSARDPD'    DBFILE                                       CIR011
     C                   Z-ADD     901           DBASE                                        CIR011
     C                   MOVEL     'CIR011'      DBKEY                                        CIR011
     C                   OUT       LDA                                                        CIR011
     C                   EXSR      *PSSR                                                      CIR011
     C                   ENDIF                                                                CIR011
      *                                                                                       CIR011
     C     @RTCD         IFEQ      *BLANKS                                                    CIR011
     C                   MOVEL     'Y'           CIR011                                       CIR011
     C                   ELSE                                                                 CIR011
     C                   MOVEL     'N'           CIR011                                       CIR011
     C                   ENDIF
      *                                                                                       CIR018
      **  Access SAR details file to determine if CIR018 is on.                               CIR018
      *                                                                                       CIR018
     C                   CALL      'AOSARDR0'                                                 CIR018
     C                   PARM      *BLANKS       @RTCD                                        CIR018
     C                   PARM      '*VERIFY'     @OPTN                                        CIR018
     C                   PARM      'CIR018'      @SARD                                        CIR018
     C     SCSARD        PARM      SCSARD        DSFDY                                        CIR018
      *                                                                                       CIR018
     C     @RTCD         IFNE      *BLANKS                                                    CIR018
     C     @RTCD         ANDNE     '*NRF   '                                                  CIR018
     C     *LOCK         IN        LDA                                                        CIR018
     C                   MOVEL     'SCSARDPD'    DBFILE                                       CIR018
     C                   Z-ADD     902           DBASE                                        CIR018
     C                   MOVEL     'CIR018'      DBKEY                                        CIR018
     C                   OUT       LDA                                                        CIR018
     C                   EXSR      *PSSR                                                      CIR018
     C                   ENDIF                                                                CIR018
      *                                                                                       CIR018
     C     @RTCD         IFEQ      *BLANKS                                                    CIR018
     C                   MOVEL     'Y'           CIR018                                       CIR018
     C                   ELSE                                                                 CIR018
     C                   MOVEL     'N'           CIR018            1                          CIR018
     C                   ENDIF                                                                CIR018
 
      ** Program, module and procedure names for database error processing.
      ** =================================================================
      ** The following /COPY sets these values
 
     C/COPY ZACPYSRC,DBFIELDS
 
     C                   ENDSR
      *                                                                                     BUG13857
      *****************************************************************                     BUG13857
      *                                                               *                     BUG13857
      * SRCHKDEC - Validates numeric entry by the user                *                     BUG13857
      *                                                               *                     BUG13857
      * Called by: Main Program                                       *                     BUG13857
      *                                                               *                     BUG13857
      * Calls: ZALIGN                                                 *                     BUG13857
      *                                                               *                     BUG13857
      *****************************************************************                     BUG13857
     C     SRCHKDEC      BEGSR                                                              BUG13857
                                                                                            BUG13857
     C                   Eval      ZFIELD = *BLANKS                                         BUG13857
     C                   Eval      ZADEC  = *ZEROS                                          BUG13857
     C                   Eval      ZADIG  = 2                                               BUG13857
     C                   EvalR     ZFIELD = STFRFD                                          BUG13857
     C                   CallB     'ZALIGN'                                                 BUG13857
     C                   Parm                    ZALIGNok                                   BUG13857
     C                   Parm                    ZFIELD                                     BUG13857
     C                   Parm                    ZADEC                                      BUG13857
     C                   Parm                    ZADIG                                      BUG13857
                                                                                            BUG13857
     C                   IF        (ZALIGNok = 'Y')                                         BUG13857
     C                   Move      ZFIELD        WSTFRFD                                    BUG13857
     C                   ELSE                                                               BUG13857
     C                   Eval      ErrorFound = 'Y'                                         BUG13857
     C                   Eval      Msgid1     = 'MMA0027'                                   BUG13857
     C                   ENDIF                                                              BUG13857
                                                                                            BUG13857
     C                   ENDSR                                                              BUG13857
 
      *****************************************************************
      /EJECT
      *****************************************************************
     C/COPY ZACPYSRC,PSSR_ILE
      ********************************************************************
**  CPY@
(c) Misys International Banking Systems Ltd. 2001
