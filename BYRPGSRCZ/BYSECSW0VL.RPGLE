     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2001')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas BoE Extra Securities Data validation')           *
      *****************************************************************
      *                                                               *
      *  Midas - Bank Of England                                      *
      *                                                               *
      *  BYSECSW0VL - Bank Of England Extra Security Data validation  *
      *                                                               *
      *  Function:  This module  validates the fields entered via     *
      *             the front office, screen input and repair pgms.   *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2001            *
      *                                                               *
      * Midas Plus 1.4 Base ------------------------------------------*
      *  Last Amend No. LLN022             Date 24Jan05               *
      *  Prev Amend No. LLN020             Date 15Jul02               *             LLN018
      *                 LLN018  *CREATE    Date 17Apr01               *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  LLN022 - BOE Upgrade to MidasPlus                            *
      *  LLN020 - Upgrade BOE to Midas Release 4.                     *
      *           Rename fields to avoid conflict with CARS.          *
      *  LLN018 - Upgrade BoE to APIs and addition of 2 new fields    *
      *           on ICD.
      *                                                               *
      *****************************************************************
      /TITLE    S U B R O U T I N E   I N D E X .                     *
      *                                                               *
      *     Subroutine Index                                          *
      *     ================                                          *
      *                                                               *
      *     1. SRSETUP -   Move fields to valid file                  *
      *     2. *PSSR   -   Database Error Handling                    *
      *     3. END     -   Leave program                              *
      *                                                               *
      *                                                               *
      *****************************************************************
      * ID F  C  H  L    FUNCTION OF INDICATORS                       *
      *                                                               *
      *---------------------------------------------------------------*
      *---------------------------------------------------------------*
      *****************************************************************
      *
      ** Files needed for field validation
      *
      *
      *****************************************************************
      /EJECT
      *
      *****************************************************************
      /SPACE 3
      *****************************************************************
      *
     FBYGTEEPP  IF   E           K DISK    INFSR(*PSSR)
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
 
      ** The following /COPY line includes all the defined fields in the
      ** PSDS.  They have meaningful names, prefixed by 'PS'.
     D/COPY ZACPYSRC,PSDS
 
      ** The following /COPY line includes the definitions for error and
      ** warning message arrays.
 COPYD/COPY ZACPYSRC,ERR_ARRAYS
 
      *****************************************************************
      /EJECT
      *****************************************************************
 
      ** +--------------------------------------+
      ** ¦ Manually included D-specs            ¦
      ** ¦ =========================            ¦
      ** +--------------------------------------+
 
      **
      **   Named constants
      **   ===============
      **
 
      **
      **   Arrays and Data Structures
      **   ==========================
      **
     D @EI             S              1    DIM(11)
 
      *** Datastructure to define input parameter DATA
      /COPY QWINDSRC,SESECSDTA
 
      *
     D DSFDY         E DS                  EXTNAME(DSFDY)
      ***  First DS for Access programs, Short data structure.
      *
     D DSSDY         E DS                  EXTNAME(DSSDY)
      ***  Second DS for Access programs, Long data structure.
      *
 
     D NwSeFilFmt    E DS                  EXTNAME(SEVSECSX0)
 
      ** New Deal in Screen Format (#S)
     D NwSeScnFmt    E DS                  EXTNAME(SESEEXPD)
     D                                     PREFIX(#S)
 
      ** Error indicators (OK#S)
     D OkFlags       E DS                  EXTNAME(SEESECSX0)
 
      **   Declared variables
      **   ==================
      **
 
     D ACTN            S              1
     D W0RTN           S              7
     D WLEN            S              3S 0
     D WWID            S              3S 0
     D WFIRST          S              1
     D WWERR           S              1
     D WFIND           S              1
     D TITLE           S              7
 
      ** Define *entry parameters
 
 
 
     D Idx             S              3P 0                                      Index error array
     D WIdx            S              3P 0                                      Index warning array
 
 
      *****************************************************************
     C/EJECT
      *****************************************************************
      *
     C     *ENTRY        PLIST
     C                   PARM                    ACTN              1            Action Code
     C                   PARM                    DATA                           Data from deal
     C                   PARM                    NwSeScnFmt                     New deal screen form
     C                   PARM                    OKFlags                        Field OK Flags
     C                   PARM                    FldNameArr                     Errors fields
     C                   PARM                    MsgIDArr                         ""
     C                   PARM                    MsgDtaArr                        ""
     C                   PARM                    Idx                            Error array index
     C                   PARM                    WFldNamArr                     Warnings fields
     C                   PARM                    WMsgIDArr                        ""
     C                   PARM                    WMsgDtaArr                       ""
     C                   PARM                    WIdx                           Warning array index
     C                   PARM                    NwSeFilFmt                     New deal file format
      *
      *
      *****************************************************************
      *
      *                M A I N  P R O C E S S I N G
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      * VALIDATE THE SCREEN
      *****************************************************************
      *
     C                   MOVE      *BLANKS       VALID             1
      *                                                                                       LLN022
      ** Default the qualifying flag to '0' if not entered                                    LLN022
      *                                                                                       LLN022
     C                   IF        #SQUAL = *BLANK                                            LLN022
     C                   EVAL      #SQUAL = '0'                                               LLN022
     C                   ENDIF                                                                LLN022
      *
      *
      *----------------------------------------------------------------
      *
      ** Validate Qualifying Flag
     C     #SQUAL        IFNE      ' '
     C     #SQUAL        ANDNE     '0'
     C     #SQUAL        ANDNE     '1'
     C     #SQUAL        ANDNE     '2'
     C     #SQUAL        ANDNE     '3'
     C                   ADD       1             Idx
     C**********         EVAL      FldNameArr(Idx) = '#SQUAL'                                 LLN022
     C                   EVAL      FldNameArr(Idx) = 'QUAL'                                   LLN022
     C                   EVAL      MsgIDArr(Idx) = 'BYM0204'
     C                   EVAL      ReturnCode = 'Error'
 
      ** Use the return code's value to set the field's OK flag
     C                   CALLB     'ZASETOKFLG'
     C                   PARM                    QUALFLAGOK
     C                   PARM                    ReturnCode
     C                   PARM                    WarnGlobal
     C                   ENDIF
      *
      *----------------------------------------------------------------
      *----------------------------------------------------------------
      *
      ** Validate Guarantee Code
     C     #SGTEE        IFNE      *BLANK
     C     #SGTEE        CHAIN     BYGTEEPP                           90
     C     *IN90         IFEQ      *ON
     C                   ADD       1             Idx
     C**********         EVAL      FldNameArr(Idx) = '#SGTEE'                                 LLN022
     C                   EVAL      FldNameArr(Idx) = 'GTEE'                                   LLN022
     C                   EVAL      MsgIDArr(Idx) = 'BYM0203'
     C                   EVAL      ReturnCode = 'Error'
      ** Use the return code's value to set the field's OK flag
     C                   CALLB     'ZASETOKFLG'
     C                   PARM                    GUARCODEOK
     C                   PARM                    ReturnCode
     C                   PARM                    WarnGlobal
     C                   ENDIF
     C                   ENDIF
      *----------------------------------------------------------------
      *----------------------------------------------------------------
 
     C                   IF        Idx = 0
     C                   EXSR      SRSETUP
     C                   ENDIF
      *
 
     C                   EXSR      END
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRSETUP - Set up fields that are needed on the Valid file     *
      *           record.                                             *
      *                                                               *
      *****************************************************************
     C     SRSETUP       BEGSR
      *
     C***                MOVE      ULSESN        LVSESN                             LLN020
     C                   MOVE      BYSESN        LVSESN                             LLN020
     C                   MOVE      #SGTEE        LVGTEE
     C                   MOVE      #SQUAL        LVQUAL
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * *PSSR  - Program exception error routine                      *
      *          Called automatically if a program error occurs,      *
      *          or directly by the program code using EXSR.          *
      *          This subroutine DUMPs the program just once.         *
      *                                                               *
      *****************************************************************
      *
     C     *PSSR         BEGSR                                                  ** *PSSR SR **
      *
     C     @RUN          IFEQ      *BLANKS
     C                   MOVE      'Y'           @RUN              1
     C                   SETON                                        U7U8LR
     C                   DUMP
      *
     C                   CALL      'DBERRCTL'
      *
     C                   ENDIF
      *
     C                   ENDSR
      *
      ********************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  END   - End Program, no errors                               *
      *                                                               *
      *****************************************************************
      *
     C     END           BEGSR                                                              **
      *
     C                   SETON                                            LR
     C                   RETURN
      *
     C                   ENDSR
      *
      ********************************************************************
      /EJECT
      *****************************************************************
**CTDATA CPY@
(c) Misys International Banking Systems Ltd. 2001
