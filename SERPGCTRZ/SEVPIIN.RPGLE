     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2001')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas SE Cum-Ex and Print Advice Ind Validation')      *
      *****************************************************************
      *                                                               *
      *  Midas - Securities Trading Module                            *
      *                                                               *
      *  SEVDPIN   - Cum-Ex and Print Advice Indicator Validation     *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2001            *
      *                                                               *
      *  Last Amend No. CRE073             Date 06Dec10               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *  Prev Amend No. CSD027             Date 09Dec05               *
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
      * Midas DBA 3.02 -----------------------------------------------*
      *                 CSE017  *CREATE    Date 20Oct99               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
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
      *  CSE017 - Cum/Ex Indicator on Depot Movements                 *
      *                                                               *
      *****************************************************************
 
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
 
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
 
      ** Include the SE standard declares
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
 
      ** DS for Access programs, short DS
     D DSFDY         E DS                  EXTNAME(DSFDY)
 
      ** DS for Security Details
     D Secty         E DS                  EXTNAME(SECTYD)
 
      ** The maximum size of the appended error arrays
      ** Array of Fields in error.
      ** Array of error message IDs
      ** Array of error message data.
     D XArrayMax20     C                   CONST(20)
     D FldName20       S             10A   DIM(XArrayMax20)
     D MsgID20         S                   DIM(XArrayMax20) LIKE(#MsgId)
     D MsgDta20        S                   DIM(XArrayMax20) LIKE(#MsgData)
      ** This include member declares the arrays for overall error
      ** message handling in Midas APIs
 
     D/COPY ZACPYSRC,ERR_ARRAYS
 
     D/COPY ZACPYSRC,ERR_XARRYS
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
      ** Index for arrays of error message ids etc
     D Idx             S              3P 0
 
      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
 
      ** +----------------------------------------+
      ** ¦ Hook for non-core D-specs (all types)  ¦
      ** ¦ also any I-specs (if necessary)        ¦
      ** ¦ =====================================  ¦
      ** +----------------------------------------+
 
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
     C                   MOVE      *BLANK        ReturnCode
     C                   MOVE      *BLANK        FldName20
     C                   MOVE      *BLANK        MsgId20
     C                   MOVE      *BLANK        MsgDta20
     C                   Z-ADD     0             Idx
      *
     C                   MOVE      DDDPIN        SDDDPIN           1
      *
      ** Print Advice Indicator, if it is not entered, it should be
      ** defaulted to 'Y'
      *
     C     DDDPAP        IFEQ      *Blanks
     C                   MOVE      'Y'           DDDPAP
     C                   ENDIF
      *
     C     DDDPAP        IFNE      'Y'
     C     DDDPAP        ANDNE     'N'
     C                   Move      'N'           DDDPAPOk
     C                   Add       1             Idx
     C                   EVAL      FldName20(Idx) = 'DDDPAP'
     C                   EVAL      MsgId20(Idx) = 'SEM0001'
     C                   ENDIF
      *
      ** Cum/Ex Indicator
      *
     C                   SELECT
     C     PROT          WHENEQ    '2'
     C     DDDPIN        IFNE      *Blanks
     C                   Move      'N'           DDDPINOk
     C                   Add       1             Idx
     C                   EVAL      FldName20(Idx) = 'DDDPIN'
     C                   EVAL      MsgId20(Idx) = 'SEM0002'
     C                   ENDIF
      *
     C     PROT          WHENEQ    '4'
     C     PROT          OREQ      '7'
     C                   Move      *Blanks       Validate
     C                   Move      'Y'           Default           1
     C                   Move      *Blanks       DDDPIN
     C                   EXSR      SRVTEX
     C                   MOVE      DDDPIN        WDPIN             1
      *
     C     SDDDPIN       IFNE      *Blanks
     C                   Move      *Blanks       Default
     C                   Move      'Y'           Validate          1
     C                   Move      SDDDPIN       DDDPIN
     C                   EXSR      SRVTEX
      *
      ** If Cum/Ex Indicator is Ok, compare with the default value
      *
     C     DDDPINOk      IFNE      'N'
     C     SDDDPIN       IFNE      WDPIN
     C                   MOVE      'N'           DDDPINOk
     C                   Add       1             Idx
     C                   EVAL      FldName20(Idx) = 'DDDPIN'
     C                   EVAL      MsgId20(Idx) = 'SEM0003'
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
      *
     C                   OTHER
     C                   Move      *Blanks       Validate
     C                   Move      'Y'           Default
     C                   Move      *Blanks       DDDPIN
     C                   EXSR      SRVTACC
     C                   MOVE      DDDPIN        WDPIN
      *
     C     SDDDPIN       IFNE      *Blanks
     C                   Move      *Blanks       Default
     C                   Move      'Y'           Validate
     C                   EXSR      SRVTACC
      *
      ** If Cum/Ex Indicator is Ok, compare with the default value
      *
     C     DDDPINOk      IFNE      'N'
     C     SDDDPIN       IFNE      WDPIN
     C                   MOVE      'N'           DDDPINOk
     C                   Add       1             Idx
     C                   EVAL      FldName20(Idx) = 'DDDPIN'
     C                   EVAL      MsgId20(Idx) = 'SEM0003'
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
     C                   ENDSL
      *
     C     DDDPINOk      IFEQ      'N'
     C                   Move      SDDDPIN       DDDPIN
     C                   ENDIF
      *
      ** Update Error Arrays
      *
     C                   Z-ADD     1             I                 2 0
     C     *Blanks       LOOKUP    FldName20(I)                           99
     C     *IN99         IFEQ      '1'
     C                   MoveA     FldNamXAr     FldName20(I)
     C                   MoveA     MsgIdXAr      MsgId20(I)
     C                   MoveA     MsgDtaXAr     MsgDta20(I)
     C                   ENDIF
      *
      ** Return
      *
     C                   RETURN
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRVTEX - Validation for Cum/Ex Indicator using SEVTEXDIV      *
      *                                                               *
      * Called by: Main Processing                                    *
      *                                                               *
      * Calls:  SEVTEXDIV                                             *
      *                                                               *
      *****************************************************************
     C     SRVTEX        Begsr
      *
     C                   CALLB     'SEVTEXDIV'
      *
      ** Return Code
      *
     C                   PARM                    ReturnCode
      *
      ** Default or Validate
      *
     C                   PARM                    Default
     C                   PARM                    Validate
      *
      ** Cum/Ex Indicator
      ** Value Date
      ** Trade Date
      ** Security Details
      *
     C                   PARM                    DDDPIN            1
     C                   PARM      Date          TDVD              5 0
     C                   PARM      Date          TDDT              5 0
     C                   PARM                    SECTY
      *
      ** S01510 Indicator
      ** Date Format
      *
     C                   PARM                    S01510
     C                   PARM                    BJDFIN
      *
      ** Error fields/message IDs/message data (arrays) from/to caller
      *
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIdXAr
     C                   PARM                    MsgDtaXAr
      *
      ** Cum-Ex Ok Indicator
      ** Cum-Ex Indicator
      *
     C                   PARM                    DDDPINOk
     C                   PARM                    DPIN              1
      *
     C                   Endsr
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRVTACC - Validation for Cum/Ex Indicator using SEVTACCRIN    *
      *                                                               *
      * Called by: Main Processing                                    *
      *                                                               *
      * Calls:  SEVTACCRIN                                            *
      *                                                               *
      *****************************************************************
     C     SRVTACC       Begsr
      *
     C                   CALLB     'SEVTACCRIN'
      *
      ** Return Code
      *
     C                   PARM                    ReturnCode
      *
      ** Default or Validate
      *
     C                   PARM                    Default
     C                   PARM                    Validate
      *
      ** Cum-Ex Indicator
      ** Trade Value Date
      ** Security Details
      ** Processing Type
      *
     C                   PARM                    DDDPIN
     C                   PARM      Date          TDVD
     C                   PARM                    SECTY
     C                   PARM                    PROT
      *
      ** Date Format
      *
     C                   PARM                    BJDFIN
      *
      ** Error fields/message IDs/message data (arrays) from/to caller
      *
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIdXAr
     C                   PARM                    MSgDtaXAr
      *
      ** Cum-Ex Ok Indicator
      ** Cum-Ex Indicator
      *
     C                   PARM                    DDDPINOk
     C                   PARM                    DPIN
      *
     C                   Endsr
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRERR - EXCEPTION ERRORS                                      *
      *                                                               *
      * Called by: *InzSR                                             *
      *                                                               *
      * Calls:  *PSSR                                                 *
      *                                                               *
      *****************************************************************
     C     SRERR         BEGSR
      *
     C                   MOVE      '1'           *INU7
     C                   MOVE      '1'           *INU8
     C                   MOVE      '1'           *INLR
      *
      **  Terminte the program
      *
     C                   EXSR      *PSSR
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * *InzSR - Program Initialisation routine                       *
      *                                                               *
      * Called by: Implicitly on program activation                   *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
 
     C     *InzSR        BEGSR
 
     C     *ENTRY        PLIST
      *
      ** Return Code
      ** Print Advice Indicator
      ** Cum-Ex Indicator
      ** Security Details
      ** Processing Type
      ** Depot Movement Type
      ** In/Out Date
      ** Date Format
      *
     C                   PARM                    ReturnCode
     C                   PARM                    DDDPAP            1
     C                   PARM                    DDDPIN            1
     C                   PARM                    Secty
     C                   PARM                    PROT              1
     C                   PARM                    DPMVType          2
     C                   PARM                    Date              5 0
     C                   PARM                    BJDFIN            1
      *
      ** Warning Messages
      *
     C                   PARM                    FldName20
     C                   PARM                    MsgId20
     C                   PARM                    MsgDta20
      *
      ** Cum/Ex Indicator - Ok Flag
      ** Print Advice Indicator - Ok Flag
      *
     C                   PARM                    DDDPINOk          1
     C                   PARM                    DDDPAPOk          1
      *
     C                   MOVEL     'SEVDPIN'     DBPGM
      *
      ** Check if switchable feature S01510 is switched on.
      *
     C                   MOVE      'N'           S01510            1
 
     C                   CALL      'AOSARDR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*VERIFY'     @OPTN
     C                   PARM      'S01510'      @SARD
      *
      ** Database error
      *
     C     @RTCD         IFNE      *BLANKS
     C     @RTCD         ANDNE     '*NRF   '
     C                   MOVEL     'S01510'      DBKEY
     C                   MOVEL     'SCSARDPD'    DBFILE                         ************
     C                   MOVEL     '901'         DBASE                          * DBERR 903*
     C                   EXSR      SRERR                                        ************
     C                   ELSE
     C                   MOVE      'Y'           S01510
     C                   END
      *
      ** Program, module and procedure names for database error processing.
      ** =================================================================
      ** The following /COPY sets these values, and also defines LDA as
      ** an external data area
 
     C/COPY ZACPYSRC,DBFIELDS
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      ********************************************************************
      /COPY ZACPYSRC,PSSR_ILE
      ********************************************************************
**  CPY@
(c) Misys International Banking Systems Ltd. 2001
