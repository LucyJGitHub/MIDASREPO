     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas CG Schema and elmnt names group set defn')
      *****************************************************************
      *                                                               *
      *  Midas - User Defined Correspondence                          *
      *                                                               *
      *  CG3617 - Schema and Element names maintenance                *
      *           Group Set Definition                                *
      *                                                               *
      *  Function:  This program will list in alphabetical order      *
      *             all the Group Set Definitions.                    *
      *                                                               *
      *  (c) Finastra International Limited 2001                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      * Midas Release 4.01 -------------------------------------------*
      *  Prev Amend No. CCG015  *CREATE    Date 09Aug01               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CCG015 - Correspondence Manager Phase 1                      *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  Use of indicators.                                           *
      *                                                               *
      *    15         End of File indicator for READ command          *
      *    23         Error on Selection Field Indicator              *
      *    25         SFLEND Indicator for Message Subfile            *
      *    27         Rolldown                                        *
      *    28         Subfile Display Indicator                       *
      *    29         Subfile Clear                                   *
      *    31         Subfile Reset Modified Tags Indicator           *
      *    37         Subfile End/Enable Rollup Indicator             *
      *    39         Protect Selection Field Indicator               *
      *                                                               *
      *    90-99      Used by Standard Subroutines                    *
      *                                                               *
      *    U7+U8      Database Error                                  *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  S U B R O U T I N E  I N D E X                               *
      *                                                               *
      *  SRERRO - Send Error Message                                  *
      *  SRRFRSH - Refresh Subfile                                    *
      *  SRRVIEW - Position on field entered                          *
      *  SRBUILD - Build Non-blank Subfile                            *
      *  SRVALD - Validate Selection Fields                           *
      *  *PSSR - Error processing                                     *
      *  *INZSR - Initialise                                          *
      *                                                               *
      *    The *INZSR subroutine will only get called automatically   *
      *    on entry to the module the first time it is run            *
      *    (unless you end the program with LR on).  Similarly        *
      *    D-spec initialisation only happens the first time.  Use    *
      *    RESET for subsequent passes.                               *
      *                                                               *
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
      *
     FCG3617DF  CF   E             WORKSTN
      **  Data Extract Name MNT - Group Set Definition
      *
     F                                     SFILE(CG3617S0:#0SFRN)
      *
     FCGGSETL1  IF   E           K DISK    INFSR(*PSSR)
      **  Group Set File (Type 'T')
      *
      *****************************************************************
      /SPACE 3
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ Automatically included D-specs       ¦
      ** ¦ ==============================       ¦
      ** +--------------------------------------+
 
      ** Standard D-specs
      ** ================
      **
      ** The following /COPY line includes the LDA layout,
      ** the copyright array definition,
      ** and the following named constants:
      **    True       logical = *on (for indcator processing)
      **    False      logical = *off (for indicator processing)
      **    DBErrCtl   10A     = 'DBERRCTL' (the name of the database error
      **                                    handler)
      ** and the following variables:
      **    RunBefore  1A (for the PSSR)
 
     D/COPY ZACPYSRC,STD_D_SPEC
 
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
 
     D PMsgId          S              7A
 
     D PMsgFile        S             10
 
     D PMsgFLib        S             10
 
     D PMsgDt          S            256
 
     D PMsgr           S              5
 
     D PPrgm           S             10
 
     D PMsgQ           S             10
 
     D PMsgType        S              7
 
     D PGroupSet       S              6A
 
     D PGrpStDesc      S             30A
 
     D PFuncKey        S              2A
 
     D WSFRRN          S              4  0
 
     D WSFCntr         S              2  0
 
     D WGrpSet         S              6A
 
     D WError          S              1A
 
     D PRtCd           S              7A
 
     D POptn           S              7A
 
     D WView           S              1A
 
     D WBuild          S              1A
 
     D WFirst          S              1A
 
     D WEmpty          S              1A
 
      ** External DS for bank details
     DSDBANK         E DS                  EXTNAME(SDBANKPD)
 
      ** First Data Structure for Access Objects
     D DSFDY         E DS                  EXTNAME(DSFDY)
 
     D WRun            S              1A
 
      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                      M A I N L I N E S                        *
      *****************************************************************
      ** +--- Start of Main processing -------------------------------+
      ** ¦                                                            ¦
      ** ¦ *INZSR is executed at program activation.                  ¦
      ** ¦                                                            ¦
      ** +------------------------------------------------------------+
 
      **  Clear subfile before refilling by writing control record
      **  with SFLCLR active
 
     C                   EVAL      *IN29 = '1'
     C                   WRITE     CG3617C0
     C                   EVAL      *IN29 = '0'
     C                   EVAL      *IN28 = '1'
 
      ** Initialise screen fields, indicators and function key
 
     C                   EVAL      #0SELE = *BLANKS
     C                   EVAL      #0CGSE = *BLANKS
     C                   EVAL      #0GSET = *BLANKS
     C                   EVAL      #0GSTD = *BLANKS
     C                   EVAL      WFirst = 'Y'
     C                   EVAL      WEmpty = *BLANK
 
      ** Initialise subfile relative record number
 
     C                   Z-ADD     0             WSFRRN
 
      ** Do While not F3
 
     C     *INKC         DOUEQ     *ON
     C     PFuncKey      OREQ      '03'
 
     C     WBuild        IFEQ      *BLANK
 
     C                   READ      CGGSETL1                               15
 
     C     *IN15         IFEQ      *ON
     C     WFirst        ANDEQ     'Y'
     C                   EVAL      WEmpty = 'Y'
     C                   ELSE
     C                   EVAL      WFirst = 'N'
     C                   EVAL      WEmpty = 'N'
     C                   Endif
 
     C                   Z-ADD     0             WSFCntr
     C                   EVAL      PFuncKey = *BLANKS
 
      **  Build Subfile
 
     C     *IN15         IFEQ      *ON
 
      ** Send 'No Details to Display' Error Message
 
     C                   EVAL      PMsgId = 'CGD2580'
     C                   EXSR      SRERRO
 
     C                   EVAL      *IN27 = '0'
     C                   EVAL      *IN28 = '0'
     C                   EVAL      *IN37 = '1'
     C                   EVAL      *IN39 = '1'
     C                   EVAL      WBuild = 'N'
     C                   Z-ADD     1             WSFCntr
 
     C                   ELSE
     C                   EVAL      *IN28 = '1'
     C                   EVAL      *IN39 = '0'
     C                   EXSR      SRBUILD
     C                   ENDIF
 
     C                   ENDIF
 
     C     WSFCntr       IFGT      0
     C                   WRITE     CG3617F0
     C                   WRITE     CG3617C1
     C                   EXFMT     CG3617C0
 
     C                   CALL      'ZA0250'
     C                   EVAL      *IN37 = '0'
     C                   ELSE
     C                   ITER
     C                   ENDIF
 
      **  If Rollup is not done and F3 is not pressed
 
     C     *IN27         IFEQ      *OFF
     C     *INKC         ANDEQ     *OFF
 
     C                   SELECT
 
      ** If F5 is pressed
 
     C     *INKE         WHENEQ    *ON
     C                   EXSR      SRRFRSH
 
      ** If Position On field is not blank and save variable is not the same
      ** as the value entered.
 
     C     #0CGSE        WHENNE    *BLANKS
     C     #0CGSE        ANDNE     WGrpSet
     C                   EXSR      SRRVIEW
 
      ** If Position On field is the same as the save variable
 
     C     #0CGSE        WHENEQ    WGrpSet
     C     WEmpty        ANDEQ     'N'
     C                   EVAL      WBuild = 'N'
     C                   EXSR      SRVALD
 
     C     #0CGSE        WHENEQ    *BLANK
     C     #0CGSE        ANDNE     WGrpSet
     C     WEmpty        ANDEQ     'N'
     C                   EXSR      SRRFRSH
 
     C                   ENDSL
 
     C                   ELSE
 
      **  If Rollup, Build Subfile
 
     C                   EVAL      WBuild = *BLANKS
 
     C                   ENDIF
 
     C                   ENDDO
 
     C                   MOVE      *ON           *INLR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRERRO - Send Error Message                                  *
      *                                                               *
      *****************************************************************
 
     C     SRERRO        BEGSR
 
     C                   CALL      'AOCREPT'
     C                   PARM                    PMsgID
     C                   PARM                    PMsgFile
     C                   PARM      *BLANKS       PMsgFLib
     C                   PARM      *BLANKS       PMsgDt
     C                   PARM      *BLANKS       PMsgr
     C                   PARM      *BLANKS       PPrgm
     C                   PARM      *BLANKS       PMsgQ
     C                   PARM      *BLANKS       PMsgType
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRRFRSH - Refresh Subfile                                    *
      *                                                               *
      *****************************************************************
 
     C     SRRFRSH       BEGSR
 
      **  Clear subfile before refilling by writing control record
      **  with SFLCLR active
 
     C                   EVAL      *IN29 = '1'
     C                   WRITE     CG3617C0
     C                   EVAL      *IN29 = '0'
 
     C                   Z-ADD     0             WSFRRN
 
     C                   EVAL      *IN37 = '0'
     C                   EVAL      #0SELE = *BLANK
     C                   EVAL      #0CGSE = *BLANKS
     C                   EVAL      WBuild = *BLANK
     C                   EVAL      WGrpSet = *BLANKS
 
     C     *LOVAL        SETLL     CGGSETL1
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRRVIEW - Position on field entered                          *
      *                                                               *
      *****************************************************************
 
     C     SRRVIEW       BEGSR
 
      **  Move #0CGSE to save variable
 
     C                   EVAL      WGrpSet = #0CGSE
 
      **  Clear subfile before refilling by writing control record
      **  with SFLCLR active
 
     C                   EVAL      *IN29 = '1'
     C                   WRITE     CG3617C0
     C                   EVAL      *IN29 = '0'
 
     C                   Z-ADD     0             WSFRRN
     C                   EVAL      *IN37 = '0'
     C                   EVAL      #0SELE = *BLANK
     C                   EVAL      WBuild = *BLANK
 
     C     WGrpSet       SETLL     CGGSETL1
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRBUILD - Build Non-blank Subfile                            *
      *                                                               *
      *****************************************************************
 
     C     SRBUILD       BEGSR
 
      ** Do while not End of File
 
     C     *IN15         DOWEQ     *OFF
     C     WSFCntr       ANDLT     11
 
      ** Display only Top Group Sets
 
     C     GSCSET        IFEQ      'T'
     C                   EVAL      #0SELE = *BLANKS
     C                   EVAL      #0GSET = GSGRPS
     C                   EVAL      #0GSTD = GSDESC
 
     C                   ADD       1             WSFCntr
     C                   ADD       1             WSFRRN
     C                   Z-ADD     WSFRRN        #0SFRN
 
     C                   WRITE     CG3617S0
 
     C                   ENDIF
     C
     C     WSFCntr       IFLT      11
     C                   READ      CGGSETL1                               15
     C                   ENDIF
 
     C     *IN15         IFEQ      *ON
     C                   EVAL      *IN37 = '1'
     C                   EVAL      *IN27 = '0'
     C                   ENDIF
 
     C                   ENDDO
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRVALD - Validate Selection Fields                           *
      *                                                               *
      *****************************************************************
 
     C     SRVALD        BEGSR
 
      ** Read Subfile
 
     C                   READC     CG3617S0                               15
 
      **  Do while F3 is not pressed, roll-up key is not
      **  pressed, PFuncKey is not '03' and not End of File
 
     C     *INKC         DOWEQ     *OFF
     C     *IN27         ANDEQ     *OFF
     C     *IN15         ANDEQ     *OFF
     C     PFuncKey      ANDNE     '03'
 
     C                   EVAL      WError = 'N'
 
      ** Validate selection field while not End of File
 
     C     *IN15         DOWEQ     *OFF
 
     C     #0SELE        IFNE      '1'
     C     #0SELE        ANDNE     *BLANK
     C                   EVAL      *IN23 = '1'
     C                   EVAL      WError = 'Y'
     C                   ENDIF
 
     C                   EVAL      *IN31 = '1'
     C                   UPDATE    CG3617S0
     C                   EVAL      *IN31 = '0'
     C                   EVAL      *IN23 = '0'
     C                   READC     CG3617S0                               15
 
     C                   ENDDO
 
      ** If Errors are found, send error message
 
     C     WError        IFEQ      'Y'
     C                   EVAL      PMsgId = 'CGD2561'
     C                   EXSR      SRERRO
     C                   ENDIF
 
      ** If no errors are found, call CG3618
 
     C     WError        IFEQ      'N'
      *
     C                   EVAL      *IN15 = '0'
     C                   EVAL      PFuncKey = *BLANKS
 
     C     *IN15         DOWEQ     *OFF
     C     PFuncKey      ANDEQ     *BLANKS
     C                   READC     CG3617S0                               15
 
     C     #0SELE        IFEQ      '1'
     C     *IN15         ANDEQ     *OFF
     C                   EVAL      PFuncKey = *BLANKS
     C                   EVAL      PGroupSet = #0GSET
     C                   EVAL      PGrpStDesc = #0GSTD
 
     C                   CALLB     'CG3618'
     C                   PARM                    RetCodeOut
     C                   PARM                    PGroupSet
     C                   PARM                    PGrpStDesc
     C                   PARM                    PFuncKey
 
     C                   EVAL      #0SELE = *BLANKS
     C                   EVAL      *IN31 = '1'
     C                   UPDATE    CG3617S0
     C                   EVAL      *IN31 = '0'
     C                   ENDIF
 
     C                   ENDDO
 
     C                   ENDIF
 
      ** Display screen if there is an error message, if F12 is pressed in
      ** CG3618, or if there are no more records selected to process
 
     C     WError        IFEQ      'Y'
     C     PFuncKey      OREQ      '12'
     C     *IN15         OREQ      *ON
     C     #0CGSE        ANDEQ     WGrpSet
     C                   WRITE     CG3617F0
     C                   WRITE     CG3617C1
     C                   EXFMT     CG3617C0
     C                   CALL      'ZA0250'
 
     C                   SELECT
 
      ** If F5 is pressed
 
     C     *INKE         WHENEQ    *ON
     C                   EXSR      SRRFRSH
     C                   LEAVE
 
      ** If Position On field is not blank and save variable is not the same
      ** as the value entered
 
     C     *INKC         WHENNE    *ON
     C     #0CGSE        ANDNE     *BLANKS
     C     #0CGSE        ANDNE     WGrpSet
     C                   EVAL      WView = 'Y'
     C                   EXSR      SRRVIEW
     C                   LEAVE
 
      ** If Rollup is Pressed
 
     C     *IN27         WHENEQ    *ON
     C                   EVAL      WBuild = *BLANKS
     C                   LEAVE
 
     C                   ENDSL
 
     C                   ENDIF
 
     C                   READC     CG3617S0                               15
 
     C                   ENDDO
 
     ** When Position on Field is Blank
 
     C     WView         IFEQ      *BLANK
     C     #0CGSE        ANDEQ     *BLANKS
     C                   EXSR      SRRFRSH
     C                   ENDIF
 
     C                   EVAL      WView = *BLANK
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  *INZSR - Program Initialisation Routine                      *
      *                                                               *
      *****************************************************************
 
     C     *INZSR        BEGSR
 
      ** Move workstation ID to screen field.
 
     C                   MOVEL     PsUser        #0USER
     C                   MOVEL     PsJobName     #0WSID
     C                   MOVEL     PSProcPgm     #1PGMQ
     C                   EVAL      PMsgFile = 'CGUSRMSG'
 
      ** The following /COPY sets the program, module and procedure
      ** names for database error processing.
 
     C/COPY ZACPYSRC,DBFIELDS
 
      ** Access bank details
 
     C                   CALL      'AOBANKR0'
     C                   PARM      *BLANKS       PRtCd
     C                   PARM      '*FIRST '     POptn
     C     SDBANK        PARM      SDBANK        DSFDY
 
      ** Database error
 
     C     PRtCd         IFNE      *BLANKS
     C     *LOCK         IN        LDA
     C                   Z-ADD     01            DBase
     C                   MOVEL     'SDBANKPD'    DBfile
     C                   MOVEL     '*FIRST'      DBKey
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   MOVEL     BJMRDT        #0RUNA
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  *PSSR - Program exception error routine                      *
      *          Called automatically if a program error occurs,      *
      *          or directly by the program code using EXSR.          *
      *          This subroutine DUMPs the program just once.         *
      *                                                               *
      *****************************************************************
 
     C     *PSSR         BEGSR
 
     C                   DUMP
 
     C                   IF        WRun = *BLANK
     C                   EVAL      WRun = 'Y'
     C                   CALLB     'DBERRCTL'
     C                   ENDIF
 
     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   EVAL      *INLR = *ON
     C                   RETURN
 
     C                   ENDSR
 
      ********************************************************************
**  CPY@
(c) Finastra International Limited 2002
