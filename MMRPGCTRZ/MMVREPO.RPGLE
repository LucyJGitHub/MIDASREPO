     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2001')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas MM Validate Repo/Pledge Indicator')
      *****************************************************************
      *                                                               *
      *  Midas - Money Market Dealing Module                          *
      *                                                               *
      *  MMVREPO  -  Validate Rep/Pledge Indicator                    *
      *                                                               *
      *  Function:  This module receives a parameter containing the   *
      *             Repo/Pledge Indicator and confirms it has a valid *
      *             value. If it is valid the 10A return code will be *
      *             blank; if it is not it will contain 'Error'       *
      *                                                               *
      *  Component of: MMVALIDTE - MM validation service program      *
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
      *  Last Amend No. BUG11663           Date 30Jun06               *
      *  Prev Amend No. CSD027             Date 09Dec05               *
      *                 BUG3122            Date 17Jul04               *
      * Midas Release 4 --------------- Base -------------------------*
      *                 CSE022             Date 29Mar01               *
      * Midas DBA 3.00 ---------------- Base -------------------------*
      *                 CAP002  *CREATE    Date 03Sep97               *
      *                                    Date ddmmmyy               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  BUG11663 - Bond left out in the Repo/Pledge Indicator        *
      *             validation                                        *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  BUG3122 - Recompiled due to changes in SDSECSPD.             *
      *  CSE022 - Depository Definition Enhancement (Recompile)       *
      *  CAP002 - Conversion of MM inputs into modular structure to   *
      *           use as APIs.                                        *
      *                                                               *
      *****************************************************************
 
      *****************************************************************
      ** +----------------------------+
      ** ¦ Manually Included F-Specs  ¦
      ** ¦ =========================  ¦
      ** +----------------------------+
      **
      **
      ** +-----------------------------------+
      ** ¦ End of Manually Included F-Specs  ¦
      ** ¦ ================================  ¦
      ** +-----------------------------------+
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
 
      ** External data structure for Securities Static Data
     D SDSECS        E DS                  EXTNAME(SDSECSPD)
 
 
      ** +--------------------------------------+
      ** ¦ Named constants                      ¦
      ** ¦ ===============                      ¦
      ** +--------------------------------------+
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
      ** Error message code 1 received as a parameter
     D Msgid1          S                   LIKE(#MsgID)
 
      ** Error Message code 2 received as a parameter
     D MSgid2          S                   LIKE(#MsgID)
 
      ** Securities Trading Installed Indicator received as a parameter.
     D BGSECS          S              1A
      *** Repo/Pledge Indicator received as a parameter
     D DDDRID          S              1A
      *** Deal File Customer Number/Shortname received as parameter
     D*IKCNUM***       S              6S 0                                                    CSD027
     D IKCNUM          S              6A                                                      CSD027
      *
      *** Repo/Pledge Number
     D DDDDMR          S              6A
      *
      ** Deal File Repo/Pledge Indicator passed as a parameter
     D IKDRID          S              1A
      **
      ** Deal File Repo/Pledge Number passed as a parameter
     D IKDDMR          S              6A
      **
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
     C                   RESET                   Msgid1
     C                   RESET                   Msgid2
      *
     C** Repo/Pledge Indicator Validation
     C**
     C**
     C                   MOVE      *BLANKS       @TEST             1
     C*
     C*  If Securities Trading module is installed
     C*
     C     BGSECS        IFEQ      'Y'
     C*
     C***Repo/Pledge*Ind*must*be*blank,'R'*or*'P'**********************                     BUG11663
     C** Repo/Pledge Ind must be blank,'R','P' or 'B'                                       BUG11663
     C*
     C     DDDRID        IFNE      ' '
     C     DDDRID        ANDNE     'R'
     C     DDDRID        ANDNE     'P'
     C     DDDRID        ANDNE     'B'                                                      BUG11663
     C                   MOVE      'Y'           ErrorFound
     C                   MOVEL     'MMM0521'     Msgid1
     C                   END
     C*
     C***Do*the*following*validation*if*Repo/Pledge*Ind*is*'R'*or*'P'**                     BUG11663
     C** Do the following validation if Repo/Pledge Ind is 'R', 'P' or 'B'                  BUG11663
     C*
     C     DDDRID        IFEQ      'R'
     C     DDDRID        OREQ      'P'
     C     DDDRID        OREQ      'B'                                                      BUG11663
     C                   MOVE      IKCNUM        @CNUMA            6
     C                   CALL      'AOSECSR0'
     C                   PARM      *BLANKS       @RTCD             7
     C                   PARM      '*KEY   '     @OPTN             7
     C                   PARM      @CNUMA        @AENB             6
     C     SDSECS        PARM      SDSECS        DSFDY
     C     @RTCD         IFNE      *BLANKS
     C                   MOVE      'Y'           ErrorFound
     C                   MOVEL     'MMM0522'     Msgid1
     C                   ELSE
     C*
     C** If client record found Pledge Agreement ind must be 'Y'
     C*
     C     BFPLAG        IFNE      'Y'
     C                   MOVE      'Y'           ErrorFound
     C                   MOVEL     'MMM0523'     Msgid1
     C                   END
     C                   END
     C*
     C** If Repo/Pledge Number input when Repo/Pledge Ind is 'R' or 'P'
     C** Then Repo/Pledge Number must be non-zero and numeric
     C*
     C     DDDDMR        IFNE      *BLANK
     C*
     C**  Check that the input is numeric and non-zero
     C                   TESTN                   DDDDMR               73
     C                   MOVE      DDDDMR        @TEST
     C   73              TESTZ                   @TEST                    73
     C   73DDDDMR        COMP      '000000'                           7373
     C*
     C     *IN73         IFEQ      '0'
     C                   MOVE      'Y'           ErrorFound
     C                   MOVEL     'MMM0524'     Msgid2
     C                   ELSE
     C                   END
     C                   END
     C*
     C** Do the following validation if Repo/Pledge Ind is not 'R' or 'P'
     C*
     C                   ELSE
     C*
     C** Repo/Pledge Number must be blank
     C*
     C     DDDDMR        IFNE      *BLANK
     C                   MOVE      'Y'           ErrorFound
     C                   MOVEL     'MMM0525'     Msgid2
     C                   END
     C                   END
     C                   END
     C                   MOVEL     DDDRID        IKDRID
     C                   MOVEL     DDDDMR        IKDDMR
     C*
     C*
     C*
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
      * Called by: Main processing                                    *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
 
     C     *INZSR        BEGSR
 
     C     *entry        PLIST
     C                   PARM                    RetCodeIn
     C                   PARM                    Msgid1
     C                   PARM                    Msgid2
     C                   PARM                    BGSECS
     C                   PARM                    DDDRID
     C                   PARM                    IKCNUM
     C                   PARM                    DDDDMR
     C                   PARM                    IKDRID
     C                   PARM                    IKDDMR
 
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
(c) Misys International Banking Systems Ltd. 2001
