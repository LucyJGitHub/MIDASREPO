     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas IR Validate maturity date')
      *****************************************************************
      *                                                               *
      *  Midas - FRA/IRS module                                       *
      *                                                               *
      *  IRVMATDAT - Validate Maturity Date                           *
      *                                                               *
      *  Function:  This module receives a parameter containing the   *
      *             maturity date and confirms whether it has a valid *
      *             value. If it is valid the 10A return code will be *
      *             blank; if it is not it will contain 'Error'       *
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
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.02 -----------------------------------------------*
      *  Prev Amend No. 167511             Date 14Sep99               *
      * Midas DBA 3.00 ---------------- Base -------------------------*
      *                 CAP003  *CREATE    Date 01Feb98               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  167511 - FRA/IRS functions fail if dates contain invalid data*
      *           (also fix mistreatment of warning errors)           *
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
 
 
      ** +----------------------------------------+
      ** ¦ Indicators Used                        ¦
      ** ¦ ===============                        ¦
      ** ¦ 21 - Valid Maturity Date               ¦
      ** +----------------------------------------+
 
      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
 
      ** +--------------------------------------+
      ** ¦ Named constants                      ¦
      ** ¦ ===============                      ¦
      ** +--------------------------------------+
 
      *Valid value date passed as parameter
     D   VDATX         S              5P 0
 
      **BJDFIN passed as a parameter to ZDATE1
     D    BJDFIN       S              1A
 
      **Our dealing Currency passed as a parameter to ZCHKH
     D   SUCUCY        S              3A
 
      **Their dealing Currency passed as a parameter to ZCHKH
      ** Only used in IRS X-currency transactions
     D   STCUCY        S              3A
 
      **Local Currency passed as a parameter to ZCHKH
     D   BJLCCY        S              3A
 
      ** Run day number passed as a parameter from calling program
     D  BJRDNB         S              5  0
 
      **Local Location code passed as a parameter
     D   BJSLCD        S              3A
 
      ** Average Rate indicator passed as a parameter from calling program (Y/N)(DL1604I)
      ** If not used in calling program should have a value of 'N'
     D  SAVRAM         S              1A                                        +
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
      *Day number for holdiay passed as parameter
     D   ZDAYNO        S              5P 0
 
      *Maturity Date passed as a parameter
     D   SMDAT         S              6A
 
      *Maturity date passed as a parameter to ZDATE1
     D   ZDATE         S              6A
 
      **Our valid Currency indicator passed as a parameter (*IN23)
     D   SUCUCYok      S              1A
 
      **Their valid Currency indicator passed as a parameter
      ** Only used in IRS X-currency transactions
     D   STCUCYok      S              1A
 
      **Valid date indicator passed as a parameter (*IN20)
     D   VDATXok       S              1A
 
      **Holiday Check indicator passed from ZCHKH
     D   ZIND          S              1A
 
      **Error flag returned by ZDATE1
     D   Errorflag     S              1A
 
      *Error message to be handed back as a parameter
     D   Msgid1        S                   LIKE(#Msgid)
 
      * Warning message passed back to calling program as a parameter
     D  WMsgId1        S                   LIKE(#Msgid)
 
      * Warning message passed back to calling program as a parameter
     D  WMsgId2        S                   LIKE(#Msgid)
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
      **Reset Error messages
      *
     C                   RESET                   Errorfound
     C                   RESET                   WarnFound                      167511
     C                   RESET                   Msgid1
     C                   RESET                   WMsgid1
     C                   RESET                   WMsgid2
     C                   MOVE      *OFF          *IN21
      *
      *Ensure Maturity date is valid and not blanks.
      *
     C     SMDAT         IFNE      *BLANKS
                                                                                167511
     C*******************MOVE      '0'           *IN84                          167511
     C*******************MOVE      '0'           HIGHZ             1            167511
     C*******************TESTN                   SMDAT                84        167511
     C******IN84*********IFEQ      *ON                                          167511
                                                                                167511
     C                   TESTN                   SMDAT                9798      167511
     C     *IN97         IFEQ      '1'                                          167511
     C     *IN98         OREQ      '1'                                          167511
     C                   MOVE      'Y'           NUMok             1            167511
     C                   ELSE                                                   167511
     C                   MOVE      'N'           NUMok                          167511
     C                   ENDIF                                                  167511
                                                                                167511
     C     NUMok         IFEQ      'Y'                                          167511
     C                   MOVE      SMDAT         ZDATE
     C                   CALLB     'ZDATE1'
     C                   PARM                    ZDATE
     C                   PARM                    ZDAYNO
     C                   PARM                    BJDFIN
     C                   PARM                    Errorflag
     C                   END
     C                   END
      *
      **If SMDAT invalid/non-numeric/blank show error message
      *
     C     SMDAT         IFEQ      *blanks
     C     NUMok         OREQ      'N'                                          167511
     C******IN84*********OREQ      *OFF                                         167511
     C     Errorflag     OREQ      'Y'
     C                   MOVE      'Y'           Errorfound
     C                   MOVEL     'MMM0128'     Msgid1
     C                   MOVE      *ON           *IN21
     C                   ENDIF
 
      *
      **If the Maturity date is valid save it as a Midas Day number
      *
     C     *IN21         IFEQ      *OFF
     C                   MOVE      ZDAYNO        MDATX             5 0
     C                   END
 
      *
      *If the Maturity date is valid and less than a valid Value date.
      *Show an error
 
     C     *IN21         IFEQ      *OFF
     C*****VDATXok       ANDEQ     'Y'                                          167511
     C     VDATXok       ANDNE     'N'                                          167511
     C     MDATX         ANDLE     VDATX
     C                   MOVE      'Y'           Errorfound
     C                   MOVE      'MMM0130'     Msgid1
     C                   MOVE      *ON           *IN21
     C                   ENDIF
 
      ** Check Maturity date against run date if Average rate on. (DL1604I)
     C     *IN21         IFEQ      '0'
     C     SAVRAM        ANDEQ     'Y'
     C     MDATX         ANDLT     BJRDNB
     C                   MOVE      'Y'           ErrorFound
     C                   MOVEL     'MMA0077'     Msgid1
     C                   MOVE      *ON           *IN21
     C                   ENDIF
      *
      *Check that the valid maturity date is not a Holiday in the local ccy
      *
     C     *IN21         IFEQ      *OFF
     C     MDATX         IFNE      0
     C                   CALLB     'ZCHKH'
     C                   PARM                    MDATX
     C                   PARM                    BJLCCY
     C                   PARM                    BJSLCD
     C                   PARM                    ZIND
     C     ZIND          IFEQ      'H'
     C*******************MOVE      'Y'           Errorfound                     167511
     C                   EVAL      WarnFound    = 'Y'                           167511
     C                   MOVE      'MMM0135'     WMsgid1
     C                   ENDIF
     C                   ENDIF
      *
      *Check if maturity date is a holiday in dealing ccy
      *
     C*****SUCUCYok      IFEQ      'Y'                                          167511
     C     SUCUCYok      IFNE      'N'                                          167511
     C     SUCUCY        ANDNE     *BLANKS
     C     MDATX         IFNE      0
     C                   CALLB     'ZCHKH'
     C                   PARM                    MDATX
     C                   PARM                    SUCUCY
     C                   PARM                    BJSLCD
     C                   PARM                    ZIND
     C     ZIND          IFEQ      'H'
     C*******************MOVE      'Y'           ErrorFound                     167511
     C                   EVAL      WarnFound    = 'Y'                           167511
     C                   MOVE      'MMM0134'     WMsgId2
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
      *Check if maturity date is a holiday in their ccy
      *
     C*****STCUCYok      IFEQ      'Y'                                          167511
     C     STCUCYok      IFNE      'N'                                          167511
     C     STCUCY        ANDNE     *BLANKS
     C     MDATX         IFNE      0
     C                   CALLB     'ZCHKH'
     C                   PARM                    MDATX
     C                   PARM                    SUCUCY
     C                   PARM                    BJSLCD
     C                   PARM                    ZIND
     C     ZIND          IFEQ      'H'
     C*******************MOVE      'Y'           ErrorFound                     167511
     C                   EVAL      WarnFound    = 'Y'                           167511
     C                   MOVE      'MMA0131'     WMsgId2
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
     C
     C*******************IF        ErrorFound = 'Y'                             167511
     C*******************EVAL      RetCodeIn = 'Error'                          167511
     C*******************ENDIF                                                  167511
                                                                                167511
      ** The return code is set in the following /COPY:                         167511
     C/COPY ZACPYSRC,SETRETCDE                                                  167511
                                                                                167511
 
 
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
     C                   PARM                    ReturnCode                     167511
     C*******************PARM                    RetCodeIn                      167511
     C                   PARM                    Msgid1
     C                   PARM                    WMsgId1
     C                   PARM                    WMsgId2
     C                   PARM                    SMDAT
     C                   PARM                    VDATX
     C                   PARM                    SUCUCY
     C                   PARM                    BJLCCY
     C                   PARM                    BJSLCD
     C                   PARM                    SAVRAM
     C                   PARM                    BJRDNB
     C                   PARM                    BJDFIN
     C                   PARM                    VDATXok
     C                   PARM                    SUCUCYok
     C                   PARM                    MDATX
     C                   PARM                    STCUCY
     C                   PARM                    STCUCYok
 
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
