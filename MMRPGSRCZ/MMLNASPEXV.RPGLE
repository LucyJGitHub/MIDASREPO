     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 1998')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas MM NA''s Purchased Validate BoE window fields')  *
      *****************************************************************
      *                                                               *
      *  Midas - Money Market Dealing Module                          *
      *                                                               *
      *  MMLNASPEXV - NA's Purchased Validate BOE Window fields       *
      *                                                               *
      *  (c) Finastra International Limited 2000                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      * Midas Plus 1.4 Base ------------------------------------------*
      *  Prev Amend No. LLN022             Date 24Jan05               *
      *                 LLN016             Date 08May00               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
    1 *  LLN022 - BoE Uprade to MidasPlus.                            *
      *  LLN016 - Upgrade BoE to DBAR3                                *
      *                                                               *
      *****************************************************************
     FBYGTEEPP  IF   E           K DISK
     FBYNASPY0  IF   E           K DISK
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
 
      **--------------------------------------------------------------------------------------------
      ** The following /COPY line includes all the defined fields in the
      ** Program Status Data Structures.  They have meaningful
      ** names, prefixed by 'PS'.
     D/COPY ZACPYSRC,PSDS
      **--------------------------------------------------------------------------------------------
 
      **--------------------------------------------------------------------------------------------
      ** The following /COPY line includes the definitions for error and
      ** warning message arrays.
     D/COPY ZACPYSRC,ERR_ARRAYS
      **--------------------------------------------------------------------------------------------
 
 
     D ExtData       E DS                  EXTNAME(MMNPEXPD)
      * MM NASP Extra Data - File (D/B) format
 
   42D OkFlags       E DS                  EXTNAME(MMENASPX0)                                 LLN022
   42 * MM NASP Extra Data - File (D/B) format                                                LLN022
   42                                                                                         LLN022
      ** Key for chain to BYGTEEPP
     D ULBYGTKEY       S              2A
 
      ** Key for chain to BYNASPY0
     D ULBYNASPK       S              6  0
   43                                                                                         LLN022
   43 ** Additional parameter field                                                           LLN022
   43D LDLNOEX         S              6A                                                      LLN022
 
      *****************************************************************
      /EJECT
      *****************************************************************
 
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
      ** Index for arrays of of error message ids etc
     D Idx             S              3P 0
 
      * Input Parameters
      *
     D I#PARM          DS           512
      * Field to be validated
      /EJECT
     C*******************************************************************
     C*  MAIN PROCESSING
     C*******************************************************************
      *
      ** INITIAL PROCESSING
      *
     C                   EXSR      EXDATAVAL
      *
     C                   RETURN
      *
      * PAYMENT INSTRUCTIONS
      *
     C*****************************************************************
      /EJECT
     C*****************************************************************
     C*                                                               *
     C* EXDATAVAL - Valadate data in extra data file                  *
     C*                                                               *
     C*****************************************************************
 
     C     EXDATAVAL     BEGSR
   48 *                                                                                       LLN022
   48C                   EVAL      GTEEOK = 'Y'                                               LLN022
   48C                   EVAL      QUALOK = 'Y'                                               LLN022
   48C                   EVAL      FMATOK = 'Y'                                               LLN022
      *                                                                                       LLN022
      ** Default qualifying flag to '0'                                                       LLN022
      *                                                                                       LLN022
     C     LQUALEX       IFEQ      *BLANK                                                     LLN022
     C                   EVAL      LQUALEX = '0'                                              LLN022
     C                   ENDIF                                                                LLN022
   48 *                                                                                       LLN022
      ** Validate Guarantee Code
     C     LGTEEEX       IFNE      *BLANK
     C                   MOVE      LGTEEEX       ULBYGTKEY
     C     ULBYGTKEY     CHAIN     BYGTEEPP                           86
     C     *IN86         IFEQ      *ON
     C                   ADD       1             Idx
     C**********         EVAL      FldNameArr(Idx) = 'LGTEE'                                  LLN022
     C                   EVAL      FldNameArr(Idx) = 'LGTEEEX'                                LLN022
     C                   EVAL      MsgIDArr(Idx) = 'XXX0010'
   49C                   EVAL      GTEEOK        = 'N'                                        LLN022
 
     C                   ENDIF
     C                   ENDIF
      *
      ** Validate Qualifying Flag
     C     LQUALEX       IFNE      ' '
     C     LQUALEX       ANDNE     '0'
     C     LQUALEX       ANDNE     '1'
     C     LQUALEX       ANDNE     '2'
     C     LQUALEX       ANDNE     '3'
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'LQUALEX'
     C                   EVAL      MsgIDArr(Idx) = 'XXX0011'
   50C                   EVAL      QUALOK        = 'N'                                        LLN022
     C                   ENDIF
      *
      ** Check Final Maturity Date
     C     LFMATEX       IFNE      *BLANK
     C                   MOVE      LFMATEX       DateIn            6
     C                   TESTN                   DateIn               7778                    LLN022
     C     *IN77         IFEQ      '1'                                                        LLN022
     C     *IN78         OREQ      '1'                                                        LLN022
     C                   CALLB     'ZDATE1'
     C                   PARM                    DateIn
     C                   PARM                    DaynoOut          5 0
     C                   PARM                    BJDFIN            1
     C                   PARM                    ErrorFlag         1
     C                   MOVE      DaynoOut      ULFMAT            5 0
     C                   ENDIF                                                                LLN022
      *
      ** Date not valid DDMMYY format
     C     ErrorFlag     IFEQ      'Y'
     C     *IN77         OREQ      '0'                                                        LLN022
     C     *IN78         ANDEQ     '0'                                                        LLN022
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'LFMATEX'
     C                   EVAL      MsgIDArr(Idx) = 'XXX0012'
   52C                   EVAL      FMATOK        = 'N'                                        LLN022
     C                   ELSE
      ** Final Maturity Date must be on or after the maturity date
      ** of the deal
      ** Get extension file details for initial display
     C                   MOVE      LDLNOEX       ULBYNASPK
     C     ULBYNASPK     CHAIN     BYNASPY0                           87
      *
      ** Convert Extra Data Maturity Date to midas day number
     C                   MOVE      LFMATEX       DateIn            6
     C                   CALLB     'ZDATE1'
     C                   PARM                    DateIn
     C                   PARM                    DaynoOut          5 0
     C                   PARM                    BJDFIN            1
     C                   PARM                    ErrorFlag         1
 
     C                   MOVE      DaynoOut      LFMATEXDN         5 0
      *
     C     LFMATEXDN     IFLT      ULMDAT
     C                   ADD       1             Idx
     C**********         EVAL      FldNameArr(Idx) = 'ULFMAT'                                 LLN022
     C                   EVAL      FldNameArr(Idx) = 'LFMATEX'                                LLN022
     C                   EVAL      MsgIDArr(Idx) = 'XXX0013'
   54C                   EVAL      FMATOK        = 'N'                                        LLN022
     C                   ENDIF
      *
     C                   ENDIF
      *
     C                   ENDIF
      *
     C                   ENDSR
      *****************************************************************
     C/EJECT
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
      *
      * PARAMETERS
      *
     C     *ENTRY        PLIST
     C                   PARM                    ExtData
     C                   PARM                    ULMDAT            5 0
     C                   PARM                    Idx
      * OUTPUTS
      * Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIDArr
   57C                   PARM                    LDLNOEX                                      LLN022
   58C                   PARM                    OkFlags                                      LLN022
     C                   PARM                    BJDFIN                                       LLN022
 
     C                   ENDSR
      /EJECT
     C*****************************************************************
