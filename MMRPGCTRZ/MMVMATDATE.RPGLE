     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas MM Validate maturity date')
      *****************************************************************
      *                                                               *
      *  Midas - Money Market Dealing Module                          *
      *                                                               *
      *  MMVMATDATE - Validate maturity date                          *
      *                                                               *
      *  Function:  This module receives a parameter containing the   *
      *             maturity date and confirms whether it has a valid *
      *             value. If it is valid the 10A return code will be *
      *             blank; if it is not it will contain 'Error'       *
      *                                                               *
      *  Component of: MMVALIDTE - MM validation service program      *
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
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      *  Prev Amend No. 256564             Date 17Sep08               *
      *                 245491             Date 08Feb07               *
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CSD027             Date 09Dec05               *
      *                 CDL033             Date 10Feb05               *
      *                 BUG3992            Date 05Oct04               *
      *                 CGL029             Date 01Sep03               *
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.02 -----------------------------------------------*
      *                 CSE006             Date 26Oct99               *
      * Midas DBA 3.01 -----------------------------------------------*
      *                 CDL006             Date 26Apr99               *
      * Midas DBA 3.00 ---------------- Base -------------------------*
      *                 CAP002  *CREATE    Date 10Sep97               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  256564 - Recompile due to PF changes done by fix 256330      *
      *  245491 - Remove DB error on CALL AONOSTR0. Settlement        *
      *           instructions may be not valid yet.                  *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CDL033 - Floating Rate CDs Issued                            *
      *  BUG3992 - Do not suppress warning messages.                  *
      *  CGL029 - Increase Account Code to 10 digits                  *
      *  CSE006 - Repos Maintenance                                   *
      *  CDL006 - Dealing Fiduciary.                                  *
      *  CAP002 - Conversion of MM inputs into modular structure to   *
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
 
      ** External data structure for access programs (short)
     D DSFDY         E DS                  EXTNAME(DSFDY)
 
     D* SECOND DS FOR ACCESS PROGRAMS, LONG DATA STRUCTURE
     D DSSDY         E DS                  EXTNAME(DSSDY)
 
      ** External data structure for nostros file
     D SDNOST        E DS                  EXTNAME(SDNOSTPD)
 
      ** +--------------------------------------+
      ** ¦ Named constants                      ¦
      ** ¦ ===============                      ¦
      ** +--------------------------------------+
 
     D ZAVDATE         C                   CONST('ZAVDATE')
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
      * Return code for ZAVDATE call
     D @RTCDE          S              1A
     D @KEYF           S              3A
     D @KEYG           S             10A
     D @KEYC           S             10A                                                      CGL029
     D @KEYH           S              1A
     D @MDYNO          S              5  0
 
      ** Deals file version of maturity date
     D IKMATD          S                   LIKE(@MDYNO)
     D BJDFIN          S              1A
     D BJLCCY          S              3A
     D BJSLCD          S              3A
     D BJRDNB          S              5  0
      ** Deal type from screen
     D DDTYPE          S              2A
      ** Deal currency from screen
     D DDCCY           S              3A
      ** Maturity date is received as a parameter
     D DDMdat          S              6A
      ** Error message code 1 received as a parameter
     D Msgid1          S                   LIKE(#MsgID)
      ** Error message code 2 received as a parameter
     D Msgid2          S                   LIKE(#MsgID)
      ** Warning message code 1 received as a parameter
     D WMsgid1         S                   LIKE(#MsgID)
      ** Warning message code 2 received as a parameter
     D WMsgid2         S                   LIKE(#MsgID)
      ** Payment error code
     D PMERCD          S            150A
      ** Our pay instructions
     D***PMPONS*         S             12A                                                    CGL029
     D PMPONS          S             18A                                                      CGL029
      ** Payment settlement method
     D PMPSTM          S              2S 0
      ** Payment nostro
     D***PMRONS*         S             12A                                                    CGL029
     D PMRONS          S             18A                                                      CGL029
      ** Receive settlement method
     D PMRSTM          S              2S 0
      ** Location code for holiday checking
     D ZLOC            S              3A
 
      ** Holiday indicator
     D ZIND            S              1A
      ** Action Code from screen
     D DDACTN          S              1A
      ** Flag to indicate module called from MMREPOSIN                          CSE006
     D RepoFlag        S              1A                                        CSE006
                                                                                CDL006
     D CDL006          S              1A   IMPORT                               CDL006
 
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
 
      ** Reset the error flag to prevent problems on subsequent calls
     C                   RESET                   ErrorFound
     C                   RESET                   WarnFound
     C                   RESET                   Msgid1
     C                   RESET                   Msgid2
     C                   RESET                   WMsgid1
     C                   RESET                   WMsgid2
 
     C**  If the deal type is CD,CL or DL.
     C     DDTYPE        IFEQ      'CD'
     C     DDTYPE        OREQ      'CL'
     C     DDTYPE        OREQ      'DL'
     C     DDTYPE        OREQ      'DT'                                         CDL006
     C     CDL006        ANDEQ     'Y'                                          CDL006
     C     DDTYPE        OREQ      'LT'                                         CDL006
     C     CDL006        ANDEQ     'Y'                                          CDL006
     C     DDTYPE        OREQ      'DP'                                         CDL006
     C     CDL006        ANDEQ     'Y'                                          CDL006
     C     DDTYPE        OREQ      'LP'                                         CDL006
     C     CDL006        ANDEQ     'Y'                                          CDL006
 
 
     C**  For Action = 'I', if a date has been entered, this is an error    1177
 
     C     DDACTN        IFEQ      'I'
     C     DDMDAT        ANDNE     *BLANK
     C     RepoFlag      ANDNE     'Y'                                          CSE006
     C                   EVAL      ErrorFound = 'Y'
     C     DDTYPE        IFEQ      'DT'                                         CDL006
     C     CDL006        ANDEQ     'Y'                                          CDL006
     C     DDTYPE        OREQ      'LT'                                         CDL006
     C     CDL006        ANDEQ     'Y'                                          CDL006
     C     DDTYPE        OREQ      'DP'                                         CDL006
     C     CDL006        ANDEQ     'Y'                                          CDL006
     C     DDTYPE        OREQ      'LP'                                         CDL006
     C     CDL006        ANDEQ     'Y'                                          CDL006
     C                   MOVEL     'MMM9014'     Msgid1                         CDL006
     C                   ELSE                                                   CDL006
     C                   MOVEL     'MMM0127'     Msgid1
     C                   ENDIF                                                  CDL006
     C                   END
 
     C****If*the*deal*type*is*not*CD,CL*or*DL,*and*no*date*has*been****         CDL006
      ** If deal type is not CD,CL,DL,DT,LT,DP, or LP and no date has been      CDL006
     C**  entered, this is an error.
     C                   ELSE
     C     DDMDAT        IFEQ      *BLANKS
     C                   EVAL      ErrorFound = 'Y'
     C     DDTYPE        IFEQ      'FL'                                         CDL006
     C     CDL006        ANDEQ     'Y'                                          CDL006
     C     DDTYPE        OREQ      'FT'                                         CDL006
     C     CDL006        ANDEQ     'Y'                                          CDL006
     C                   MOVEL     'MMM9015'     Msgid1                         CDL006
     C                   ELSE                                                   CDL006
     C                   MOVEL     'MMM0132'     Msgid1
     C                   ENDIF                                                  CDL006
     C                   END
     C                   END
     C*
     C**  Validate that the maturity date is valid as a date.
     C                   RESET                   ReturnCode
     C                   CALLB     ZAVDATE
     C                   PARM                    ReturnCode
     C                   PARM                    DDMdat
     C                   PARM                    BJDfin
     C                   PARM                    @Mdyno
 
     C*
     C**  If it is an error and a date was actually entered report this...
     C     ReturnCode    IFEQ      'Error'
     C     DDMDAT        IFNE      *BLANKS
     C                   EVAL      ErrorFound = 'Y'
     C                   MOVEL     'MMM0128'     Msgid2
     C                   ELSE
     C**  ...if no date was entered ensure spurious errors are not reported.
     C                   CLEAR                   ReturnCode
     C                   END
     C                   END
     C*
     C*
     C*****ErrorFound    IFNE      'Y'                                                       BUG3992
     C*****DDMDAT****    ANDNE     *BLANKS                                                   BUG3992
     C     DDMDAT        IFNE      *BLANKS                                                   BUG3992
     C*
     C**  If the date is not a working day in the deal currency and the
     C**  pay method is 01,07,08, and the deal type is IT,CD,CI or
     C**  TD, this is an error.
     C     DDTYPE        IFEQ      'IT'
     C     DDTYPE        OREQ      'CD'
     C     DDTYPE        OREQ      'CI'
     C     DDTYPE        OREQ      'TD'
     C     DDTYPE        OREQ      'CF'                                                       CDL033
     C     CDL033        ANDEQ     'Y'                                                        CDL033
     C     DDTYPE        OREQ      'DT'                                         CDL006
     C     CDL006        ANDEQ     'Y'                                          CDL006
     C     DDTYPE        OREQ      'LT'                                         CDL006
     C     CDL006        ANDEQ     'Y'                                          CDL006
     C     DDTYPE        OREQ      'FT'                                         CDL006
     C     CDL006        ANDEQ     'Y'                                          CDL006
 
     C     PMPSTM        IFEQ      01
     C     PMPSTM        OREQ      07
     C     PMPSTM        OREQ      08
     C*
     C**  Find whether the date is a holiday in the deal currency
     C**  at the pay nostro location.
     C**  First find pay nostro location.
      *  (database error handling done in access program)
     C* IF ERRORS OUTSTANDING IN SETTL.DETAILS, DON'T CALL ACCESS OBJ
     C*
     C     PMERCD        IFEQ      *BLANKS
     C*
     C                   CALLB     'AONOSTR0'
     C*******            PARM      '*DBERR '     @RTCD             7                          245491
     C                   PARM      *BLANKS       @RTCD             7                          245491
     C                   PARM      '*KEY   '     @OPTN             7
     C                   PARM      *BLANKS       @KEYA             6
     C                   PARM      DDCCY         @KEYB             3
     C**********         PARM      *BLANKS       @KEYC             4                          CGL029
     C                   PARM      *BLANKS       @KEYC                                        CGL029
     C                   PARM      *BLANKS       @KEYD             2
     C                   PARM      PMPONS        @KEYE             2
     C                   PARM      *BLANKS       @KEYF
     C                   PARM      *BLANKS       @KEYG
     C                   PARM      *BLANKS       @KEYH
     C     SDNOST        PARM      SDNOST        DSFDY
     C*
     C     @RTCD         IFEQ      *BLANKS                                                    245491
     C                   MOVE      A7NOSN        ZLOC
     C                   ELSE                                                                 245491
     C                   MOVE      *BLANKS       ZLOC                                         245491
     C                   END                                                                  245491
     C*
     C                   ELSE
     C                   MOVE      *BLANKS       ZLOC
     C                   END
     C*
     C                   CALLB     'ZCHKH'
     C                   PARM                    @MDYNO
     C                   PARM                    DDCCY
     C                   PARM                    ZLOC
     C                   PARM                    ZIND
     C*
     C**  If ZIND = 'H' then the date is a holiday.
     C     ZIND          IFEQ      'H'
     C                   EVAL      WarnFound = 'Y'
     C                   MOVEL     'MMM0134'     WMsgid1
     C                   END
     C                   END
     C*
     C**  If the date is not a working day in the deal currency and the
     C**  receive method is 01,07,08, and deal type is not IT,CD,CI or
     C**  TD, this is an error.
     C                   ELSE
     C     PMRSTM        IFEQ      01
     C     PMRSTM        OREQ      07
     C     PMRSTM        OREQ      08
     C*
     C**  Find whether the date is a holiday in the deal currency
     C**  at the receive nostro location.
     C**  First find receive nostro location.
      *  (database error handling done in access program)
     C* IF ERRORS OUTSTANDING IN SETTL.DETAILS, DON'T CALL ACCESS OBJ
     C*
     C     PMERCD        IFEQ      *BLANKS
     C*
     C                   CALLB     'AONOSTR0'
     C*******            PARM      '*DBERR '     @RTCD             7                          245491
     C                   PARM      *BLANKS       @RTCD             7                          245491
     C                   PARM      '*KEY   '     @OPTN             7
     C                   PARM      *BLANKS       @KEYA             6
     C                   PARM      DDCCY         @KEYB             3
     C**********         PARM      *BLANKS       @KEYC             4                          CGL029
     C                   PARM      *BLANKS       @KEYC                                        CGL029
     C                   PARM      *BLANKS       @KEYD             2
     C                   PARM      PMRONS        @KEYE             2
     C                   PARM      *BLANKS       @KEYF
     C                   PARM      *BLANKS       @KEYG
     C                   PARM      *BLANKS       @KEYH
     C     SDNOST        PARM      SDNOST        DSFDY
     C*
     C     @RTCD         IFEQ      *BLANKS                                                    245491
     C                   MOVE      A7NOSN        ZLOC
     C                   ELSE                                                                 245491
     C                   MOVE      *BLANKS       ZLOC                                         245491
     C                   END                                                                  245491
     C*
     C                   ELSE
     C                   MOVE      *BLANKS       ZLOC
     C                   END
     C*
     C*
     C                   CALLB     'ZCHKH'
     C                   PARM                    @MDYNO
     C                   PARM                    DDCCY
     C                   PARM                    ZLOC
     C                   PARM                    ZIND
     C*
     C**  If ZIND = 'H' then the date is a holiday.
     C     ZIND          IFEQ      'H'
     C                   EVAL      WarnFound    = 'Y'
     C                   MOVEL     'MMM0134'     WMsgid1
     C                   END
     C                   END
     C                   END
     C*
     C**  Find whether the date is a holiday in the local currency.
     C*
     C                   CALLB     'ZCHKH'
     C                   PARM                    @MDYNO
     C                   PARM                    BJLCCY
     C                   PARM                    BJSLCD
     C                   PARM                    ZIND
     C*
     C**  If settlement method is not blank,00,01,07 or 08 and it is
     C**  not a working day in the local currency, it is an error.
     C**  (Only if not settled through a nostro)
     C     PMRSTM        IFNE      1
     C     PMRSTM        ANDNE     7
     C     PMRSTM        ANDNE     8
     C     PMPSTM        ORNE      1
     C     PMPSTM        ANDNE     7
     C     PMPSTM        ANDNE     8
     C*
     C**  If ZIND = 'H' then the date is a holiday.
     C     ZIND          IFEQ      'H'
     C                   EVAL      WarnFound    = 'Y'
     C                   MOVEL     'MMM0135'     WMsgid2
     C                   END
     C                   END
     C*
     C                   END
 
     C**  Output valid maturity date
     C     ErrorFound    IFEQ      'N'
     C     DDMDAT        ANDNE     *BLANKS
     C     ErrorFound    OREQ      'Y'
     C     WarnFound     ANDEQ     'Y'
     C     DDMDAT        ANDNE     *BLANKS
     C                   Z-ADD     @MDYNO        IKMATD
     C                   ELSE
     C                   Z-ADD     0             IKMATD
     C                   END
 
      ** Return code set in /COPY
     C/COPY ZACPYSRC,SETRETCDE
 
     C                   RETURN
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * *INZSR - Program Initialisation routine                       *
      *                                                               *
      * Called by: Main processing                                    *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
 
     C     *INZSR        BEGSR
 
     C     *entry        PLIST
     C                   PARM                    ReturnCode
     C                   PARM                    Msgid1
     C                   PARM                    Msgid2
     C                   PARM                    WMsgid1
     C                   PARM                    WMsgid2
     C                   PARM                    IKMATD
     C                   PARM                    BJDFIN
     C                   PARM                    BJLCCY
     C                   PARM                    BJRDNB
     C                   PARM                    BJSLCD
     C                   PARM                    DDTYPE
     C                   PARM                    DDCCY
     C                   PARM                    DDMDAT
     C                   PARM                    PMERCD
     C                   PARM                    PMPONS
     C                   PARM                    PMPSTM
     C                   PARM                    PMRONS
     C                   PARM                    PMRSTM
     C                   PARM                    DDACTN
     C                   PARM                    RepoFlag                       CSE006
     C                   PARM                    CDL033            1                          CDL033
 
      ** Program, module and procedure names for database error processing.
      ** =================================================================
      ** The following /COPY sets these values, and also defines LDA as
      ** an external data area
 
     C/COPY ZACPYSRC,DBFIELDS
 
     C                   ENDSR                                                  *** InzEnd ***
 
      *****************************************************************
      /EJECT
      ********************************************************************
     C/COPY ZACPYSRC,PSSR_ILE
      ********************************************************************
**  CPY@
(c) Finastra International Limited 2001
