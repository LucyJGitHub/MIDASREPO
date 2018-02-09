     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas SD Base Rate Codes Retrieve')                    *
      *****************************************************************
      *                                                               *
      *  Midas - Standing Data Module                                 *
      *                                                               *
      *  SDBSRTRTV - SD BASE RATE RETRIEVE                            *
      *                                                               *
      *  Function:  This module retrieves an Base Rate from           *
      *             the database. As it does so, it validates the     *
      *             action code and Base Rate Code .                  *
      *                                                               *
      *  (c) Finastra International Limited 2001                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      *  Prev Amend No. MD000091           Date 03May13               *
      *                 AR641183           Date 27Nov12               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CSD031             Date 10Apr06               *
      *                 BG2355             Date 15Jul03               *
      *                 CGL029             Date 01Sep03               *
      *                 CAP084             Date 15Jul03               *
      *                 CSD012             Date 15Oct02               *
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.05 -----------------------------------------------*
      *                 CSD006             Date 25Jan01               *
      *                 CAP038 *CREATE     Date 24Feb00               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  MD000091 - Event Codes Substitution                          *
      *  AR641183 - Allow amendment and deletion if Front Office ID   *
      *             is blank.(Child: AR641184)                        *
      *  CSD031 - Enhanced Centralised Static Data (Recompile)        *
      *  BG2355 - Can enter a base rate with no currency defined.     *
      *  CGL029 - Increase Account Code to 10 digits                  *
      *  CAP084 - Synchronous Calling of APIs                         *
      *  CSD012 - Standing Data Authorisation                         *
      *  CSD006 - Market Data Feeds                                   *
      *  CAP038 - Conversion of SD inputs into modular structure      *
      *           to use as APIs.                                     *
      *                                                               *
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
     FSDBSRFL0  IF   E           K DISK    INFSR(*PSSR)
     F                                     RENAME(@BAREDI:SDBSRFOI)
     FSDBSRTL0  IF   E           K DISK    INFSR(*PSSR)
     F                                     RENAME(@BAREDG:SDBSRTXX)
                                                                                              CSD012
     FSDAULGL0  IF   E           K DISK    INFSR(*PSSR)                                       CSD012
      * RTV : Authorisation Log - by Key                                                      CSD012
 
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
 
      ** Program Status Data Structure
      ** =============================
      ** The following /COPY line includes all the defined fields in the
      ** PSDS.  They have meaningful names, prefixed by 'PS'.
 
     D/COPY ZACPYSRC,PSDS
 
      **--------------------------------------------------------------------------------------------
      ** The following /COPY line includes the definitions for error and
      ** warning message arrays.
     D/COPY ZACPYSRC,ERR_ARRAYS
      **--------------------------------------------------------------------------------------------
 
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
 
     D SDAPI         E DS                  EXTNAME(SDAPIPD)
      ** External DS for API ICD
 
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
      ** EXTERNAL DS FOR BANK DETAILS
 
     D SDCURR        E DS                  EXTNAME(SDCURRPD)
      ** EXTERNAL DS FOR CURRENCY DETAILS
 
     D SCSARD        E DS                  EXTNAME(SCSARDPD)
      ** Switchable Features File
 
     D DSFDY         E DS                  EXTNAME(DSFDY)
      ** FIRST DS FOR ACCESS PROGRAMS, SHORT DATA STRUCTURE
     D DSSDY         E DS                  EXTNAME(DSSDY)
      ** SECOND DS FOR ACCESS PROGRAMS, LONG DATA STRUCTURE
 
     D ZMUSER          DS            17
     D  BRC                   11     13
     D  DEPT                  14     16
 
     D BasRFilFmt    E DS                  EXTNAME(SDBSRTPD)
      ** Base rate in File Format
 
     D PBTOBS        E DS                  EXTNAME(PBTOBSPD)
      ** EXTERNAL DS FOR BASE RATE NAME
 
     D***@AULG**         DS            20                                              CSD012 CGL029
     D @AULG           DS            26                                                       CGL029
     D @DDCYCD                 1      3                                                       CSD012
     D @DDBSRC                 4      5                                                       CSD012
      ** Data Structure to chain to log File SDAULGL0                                         CSD012
 
     D BChar           DS                                                                   MD000091
     D   BLen                  1      2B 0                                                  MD000091
     D   LenStr                1      2                                                     MD000091
      ** Data Structure for Event Codes Substitution                                        MD000091
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
      ** Index for arrays of of error message ids etc
     D Ix              S              3P 0
 
      ** Transaction Id
     D DDTRNN          DS
     D   DDTRCYCD                          LIKE(DDCYCD)
     D   DDTRBSRC                          LIKE(DDBSRC)
 
      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
      *****************************************************************
      /EJECT
     C**************************************************************
      *
      * INITIALIZATION
      *
     C                   EXSR      INIT
      *
      * IF THE MODE IS 'FRONT OFFICE TRANSACTION INTERFACE'
      * DO (EXTRA) VALIDATION FOR FRONT OFFICE TRANSACTION INTERFACE
      *
     C     ModeofOp      IFEQ      '*FRONT'
     C                   EXSR      VFRNT
      *
      **  Carry out no further validation if errors have occurred.
      *
     C     OKACTN        IFEQ      'N'
     C                   RETURN
     C                   END
     C                   END
      *
      * Check for any ? processing
     C                   EXSR      CHKSEL
 
      *
      * VALIDATE ACTION CODE & BASE RATE CODE
      *
     C                   EXSR      VAL
      *
      **  Carry out no further validation if errors have occurred.
      *
     C     OKACTN        IFEQ      'N'
     C     OKCYCD        OREQ      'N'
     C     OKBSRC        OREQ      'N'
     C                   RETURN
     C                   END
      *
      *  *--------------------------------*
      *  * Validation for Action Code 'I' *
      *  *--------------------------------*
      *
     C     DDACTN        IFEQ      'I'
     C     DDCYCD        ANDNE     *BLANKS
     C     DDBSRC        ANDNE     *BLANKS
     C                   EXSR      VALACI
     C                   END
      *
      *  *--------------------------------*
      *  * Validation for Action Code 'A' *
      *  *--------------------------------*
      *
     C     DDACTN        IFEQ      'A'
     C     SubForTRNN    IFEQ      0
     C     ModeofOp      ORNE      '*FRONT'
     C                   EXSR      VALACA
     C                   ENDIF
     C                   ENDIF
      *
      *  *--------------------------------*
      *  * Validation for Action Code 'D' *
      *  *--------------------------------*
      *
     C     DDACTN        IFEQ      'D'
     C     SubForTRNN    IFEQ      0
     C     ModeofOp      ORNE      '*FRONT'
     C                   EXSR      VALACD
     C                   END
     C                   END
      *
      *  *--------------------------------*
      *  * Validation for Action Code 'E' *
      *  *--------------------------------*
      *
     C     DDACTN        IFEQ      'E'
     C     SubForTRNN    IFEQ      0
     C     ModeofOp      ORNE      '*FRONT'
     C                   EXSR      VALACE
     C                   END
     C                   END
      *
      **  Carry out no further validation if errors occurred.
      *
     C     OKACTN        IFEQ      'N'
     C     OKCYCD        OREQ      'N'
     C     OKBSRC        OREQ      'N'
     C                   RETURN
     C                   END
      *
      *  *-----------------------------------------------*
      *  * Access Security Checking                      *
      *  *-----------------------------------------------*
      *
     C     RespMode      IFEQ      'S'
      *
      ** If single branching
      ** ACCESS SECURITY CHECKING - SINGLE BRANCHING
      *
     C     BJSBRC        IFNE      *BLANK
     C                   EXSR      ACSSES
     C                   END
      *
      ** If multibranching
      ** ACCESS SECURITY CHECKING - MULTI-BRANCHING
      *
     C     BJSBRC        IFEQ      *BLANK
     C                   EXSR      ACSSEM
     C                   END
     C                   END
      *
      * Return
      *
     C                   RETURN
     C********************************************************************
     C*                                                                  *
     C* CHKSEL - Subroutine to check whether a ? has been entered        *
     C*          on base rate code or currency code                      *
     C*                                                                  *
     C********************************************************************
     C*
     C     CHKSEL        BEGSR
 
     C                   IF        BGN4ST = 'Y'
 
      * Name search required?
     C                   MOVEL     DDBSRC        WKBSRC            1
 
     C                   IF        WKBSRC = '?'
      *
      * Check if Base Rate Code exists
     C                   MOVE      DDBSRC        @KEYBR
     C                   CALL      'AOTOBSR0'
     C                   PARM      *BLANKS       @RTCD             7
     C                   PARM      '*KEY   '     @OPTN             7
     C                   PARM                    @KEYBR            2
     C     PBTOBS        PARM      PBTOBS        DSSDY
     C                   MOVE      *BLANKS       DDBSRC
     C                   IF        @RTCD = *BLANKS
     C                   MOVEL     AOBACD        DDBSRC
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
 
      * Name search required?
     C                   MOVEL     DDCYCD        WKCYCD            1
 
     C                   IF        WKCYCD = '?'
     C                   CALL      'AOCURRR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*KEY   '     @OPTN
     C                   PARM                    DDCYCD
     C     SDCURR        PARM      SDCURR        DSSDY
 
     C                   MOVE      *BLANKS       DDCYCD
     C                   IF        @RTCD = *BLANKS
     C                   MOVE      A6CYCD        DDCYCD
     C                   ENDIF
     C                   ENDIF
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * VFRNT - VALIDATION FOR FRONT OFFICE TRANSACTION INTERFACE
      *****************************************************************
     C     VFRNT         BEGSR
      *
      * ERROR IF ACTION CODE IS NOT 'I', 'A or 'D'
      *
     C     DDACTN        IFNE      'I'
     C     DDACTN        ANDNE     'A'
     C     DDACTN        ANDNE     'D'
     C     DDACTN        ANDNE     'E'
     C                   MOVE      'N'           OKACTN
     C                   ADD       1             Ix
     C                   MOVEL     'DDACTN'      FldNameArr(Ix)
     C                   MOVEL     'USR4429'     MsgIdArr(Ix)
     C                   GOTO      EVFRNT
     C                   ENDIF
      *
      * ERROR IF FRONT OFFICE TRANSACTION ID IS BLANK
      *
     C     FOTRID        IFEQ      *BLANK
     C                   MOVE      'N'           OKACTN
     C                   ADD       1             Ix
     C                   MOVEL     'DDACTN'      FldNameArr(Ix)
     C                   MOVEL     'USR4430'     MsgIdArr(Ix)
     C                   GOTO      EVFRNT
     C                   ENDIF
 
      *
      * ACCESS BASE RATE WITH FRONT OFFICE TRANSACTION ID
      *
     C     FOTRID        CHAIN     SDBSRFOI                           99
      *
      * IF INSERT
      *
     C     DDACTN        IFEQ      'I'
      *
      * FRONT OFFICE TRANSACTION ID CAN'T BE PRESENT ALREADY
      *
     C     *IN99         IFEQ      '0'
     C                   MOVE      'N'           OKACTN
     C                   ADD       1             Ix
     C                   MOVEL     'DDACTN'      FldNameArr(Ix)
     C                   MOVEL     'USR4431'     MsgIdArr(Ix)
     C**********         MOVEL     FOTRID        MsgDtaArr(Ix)                              MD000091
     C                   EVAL      BLen = %Len(%Trim(FOTRID))                               MD000091
     C                   EVAL      MsgDtaArr(Ix) = LenStr + %Trim(FOTRID)                   MD000091
     C                   GOTO      EVFRNT
     C                   ENDIF
      *
     C                   ELSE
      *
      * IF NOT INSERT, FRONT OFFICE TRANSACTION ID MUST BE PRESENT
      *
     C     *IN99         IFEQ      '1'
      *                                                                                     AR641183
      ** Additional validation to allow amendment and deletion of                           AR641183
      ** Base Rate if Currency and Base Rate Code is existing while                         AR641183
      ** its Front Office ID is blank.                                                      AR641183
      *                                                                                     AR641183
     C                   MOVE      *BLANKS       BLNKFO           20                        AR641183
     C     FOBSRT        CHAIN     SDBSRFOI                           98                    AR641183
     C     *IN98         IFEQ      '1'                                                      AR641183
      *                                                                                     AR641183
     C                   MOVE      'N'           OKACTN
     C                   ADD       1             Ix
     C                   MOVEL     'DDACTN'      FldNameArr(Ix)
     C                   MOVEL     'USR4432'     MsgIdArr(Ix)
     C**********         MOVEL     FOTRID        MsgDtaArr(Ix)                              MD000091
     C                   EVAL      BLen = %Len(%Trim(FOTRID))                               MD000091
     C                   EVAL      MsgDtaArr(Ix) = LenStr + %Trim(FOTRID)                   MD000091
     C                   GOTO      EVFRNT
      *                                                                                     AR641183
     C                   ENDIF                                                              AR641183
     C                   END
 
     C                   ENDIF
      *
      *
     C     EVFRNT        ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * VAL - VALIDATION OF ACTION CODE AND BASE RATE CODE
      *****************************************************************
     C     VAL           BEGSR
      *
      ** Check action code is valid.
      *
     C     DDACTN        IFNE      'I'
     C     DDACTN        ANDNE     'A'
     C     DDACTN        ANDNE     'D'
     C     DDACTN        ANDNE     'E'
     C                   MOVE      'N'           OKACTN
     C                   ADD       1             Ix
     C                   MOVEL     'DDACTN'      FldNameArr(Ix)
     C                   MOVEL     'USR4429'     MsgIdArr(Ix)
     C                   END
     **********                                                                        CAP084 BG2355
     ***If*inserting, do not check currency and code                                   CAP084 BG2355
     C*********          IF        DDACTN = 'I' and                                    CAP084 BG2355
     C*********                    DDCYCD = *BLANKS and                                CAP084 BG2355
     C*********                    DDBSRC = *BLANKS                                    CAP084 BG2355
     C*********          LeaveSr                                                       CAP084 BG2355
     C*********          Endif                                                         CAP084 BG2355
      *
      * Base Rate Currency must be valid
      *
     C                   IF        DDCYCD = *BLANKS
     C                   MOVE      'N'           OKCYCD
     C                   ADD       1             Ix
     C                   MOVEL     'DDCYCD'      FldNameArr(Ix)
     C                   MOVEL     'USR4433'     MsgIdArr(Ix)
     C                   ENDIF
 
     C                   IF        OKCYCD <> 'N'
     C                             AND SubForTRNN = 0
     C                   CALL      'AOCURRR0'
     C                   PARM      *BLANKS       @RETC             7
     C                   PARM      '*KEY   '     @OPTN             7
     C                   PARM      DDCYCD        @CURR             3
     C     SDCURR        PARM      SDCURR        DSSDY
      *
     C     @RETC         IFNE      *BLANKS
     C                   MOVE      'N'           OKCYCD
     C                   ADD       1             Ix
     C                   MOVEL     'DDCYCD'      FldNameArr(Ix)
     C                   MOVEL     'USR4433'     MsgIdArr(Ix)
     C                   ENDIF
     C                   ENDIF
      *
      *
      * Base Rate Number must be numeric
      *
     C     SubForTRNN    IFEQ      0
     C     DDBSRC        IFLT      '0'
     C     DDBSRC        ORGT      '99'
     C                   MOVE      'N'           OKBSRC
     C                   ADD       1             Ix
     C                   MOVEL     'DDBSRC'      FldNameArr(Ix)
     C                   MOVEL     'USR4434'     MsgIdArr(Ix)
     C                   GOTO      EVAL
     C                   END
     C                   END
      *
      * If Authorisation check is on,                                                         CSD012
      * check if unathorised record exists on Authorisation Log.                              CSD012
     C     AUTHRQ        IFEQ      'Y'                                                        CSD012
     C     AUTHMD        ANDNE     'X'                                                        CSD012
     C     DDACTN        ANDNE     'E'                                                        CSD012
      *                                                                                       CSD012
     C                   MOVEL     DDCYCD        @DDCYCD                                      CSD012
     C                   MOVEL     DDBSRC        @DDBSRC                                      CSD012
     C     @AULG         CHAIN     SDAULGL0                           90                      CSD012
      *                                                                                       CSD012
      * If record exists then prevent amendment                                               CSD012
     C     *IN90         IFEQ      *OFF                                                       CSD012
                                                                                              CSD012
     C                   MOVE      'N'           OKBSRC                                       CSD012
     C                   MOVE      1             Ix                                           CSD012
     C                   MOVEL     @AULG         FldNameArr(Ix)                               CSD012
     C                   MOVEL     'USR9265'     MsgIdArr(Ix)                                 CSD012
     C                   ENDIF                                                                CSD012
      *                                                                                       CSD012
     C                   ENDIF                                                                CSD012
      *
     C     EVAL          ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * VALACI - VALIDATION OF ACTION CODE 'I'
      *****************************************************************
     C     VALACI        BEGSR
      *
      ** Check Base Rate does not exist on LF/SDBSRTL0
      *
     C     SDBSRT        CHAIN     SDBSRTXX                           99
     C     *IN99         IFEQ      '0'
     C                   MOVE      'N'           OKBSRC
     C                   ADD       1             Ix
     C                   MOVEL     'DDBSRC'      FldNameArr(Ix)
     C                   MOVEL     'USR4449'     MsgIdArr(Ix)
     C**********         MOVEL     DDCYCD        MsgDtaArr(Ix)                              MD000091
     C                   EVAL      BLen = %Len(%Trim(DDCYCD))                               MD000091
     C                   EVAL      MsgDtaArr(Ix) = LenStr + %Trim(DDCYCD)                   MD000091
     C                   ENDIF
      *
     C                   IF        BGN4ST = 'Y'
      *
      * Check if Base Rate Code exists
     C                   MOVE      DDBSRC        @KEYBR
     C                   CALL      'AOTOBSR0'
     C                   PARM      *BLANKS       @RTCD             7
     C                   PARM      '*KEY   '     @OPTN             7
     C                   PARM                    @KEYBR            2
     C     PBTOBS        PARM      PBTOBS        DSSDY
     C     @RTCD         IFNE      *BLANKS
     C                   MOVE      'N'           OKBSRC
     C                   ADD       1             Ix
     C                   MOVEL     'DDBSRC'      FldNameArr(Ix)
     C                   MOVEL     'USR4576'     MsgIdArr(Ix)
     C                   ELSE
     C                   MOVEL     AOBACD        DDBSRC
     C                   MOVEL     AOBANA        DDBSRN
     C     DDCYCD        CAT       DDBSRC        DDBSRS
     C                   ENDIF
     C                   ENDIF
      *
     C     EVALAI        ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * VALACA - VALIDATION OF ACTION CODE 'A'
      *****************************************************************
     C     VALACA        BEGSR
      *
      ** Check that the record exists
      *
     C     SDBSRT        CHAIN     SDBSRTXX                           99
     C     *IN99         IFEQ      '1'
     C                   MOVE      'N'           OKBSRC
     C                   ADD       1             Ix
     C                   MOVEL     'DDBSRC'      FldNameArr(Ix)
     C                   MOVEL     'USR4435'     MsgIdArr(Ix)
     C**********         MOVEL     DDCYCD        MsgDtaArr(Ix)                              MD000091
     C                   EVAL      BLen = %Len(%Trim(DDCYCD))                               MD000091
     C                   EVAL      MsgDtaArr(Ix) = LenStr + %Trim(DDCYCD)                   MD000091
     C                   ENDIF
      *
     C                   IF        BGN4ST = 'Y'
      *
      * Check if Base Rate Code exists
     C                   MOVE      DDBSRC        @KEYBR
     C                   CALL      'AOTOBSR0'
     C                   PARM      *BLANKS       @RTCD             7
     C                   PARM      '*KEY   '     @OPTN             7
     C                   PARM                    @KEYBR            2
     C     PBTOBS        PARM      PBTOBS        DSSDY
     C     @RTCD         IFNE      *BLANKS
     C                   MOVE      'N'           OKBSRC
     C                   ADD       1             Ix
     C                   MOVEL     'DDBSRC'      FldNameArr(Ix)
     C                   MOVEL     'USR4576'     MsgIdArr(Ix)
     C                   ELSE
     C                   MOVEL     AOBACD        DDBSRC
     C                   MOVEL     AOBANA        DDBSRN
     C     DDCYCD        CAT       DDBSRC        DDBSRS
     C                   ENDIF
     C                   ENDIF
     C     EVALAA        ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * VALACD - VALIDATION OF ACTION CODE 'D'
      *****************************************************************
     C     VALACD        BEGSR
      *
      ** Base rate code must exists
      *
     C     SDBSRT        CHAIN     SDBSRTXX                           99
     C     *IN99         IFEQ      '1'
     C                   MOVE      'N'           OKBSRC
     C                   ADD       1             Ix
     C                   MOVEL     'DDBSRC'      FldNameArr(Ix)
     C                   MOVEL     'USR4435'     MsgIdArr(Ix)
     C**********         MOVEL     DDCYCD        MsgDtaArr(Ix)                              MD000091
     C                   EVAL      BLen = %Len(%Trim(DDCYCD))                               MD000091
     C                   EVAL      MsgDtaArr(Ix) = LenStr + %Trim(DDCYCD)                   MD000091
      *
     C                   END
      *
     C     EVALAD        ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * VALACE - VALIDATION OF ACTION CODE 'E'
      *****************************************************************
     C     VALACE        BEGSR
      *
      ** Base rate code must exist
      *
     C     SDBSRT        CHAIN     SDBSRTXX                           99
     C     *IN99         IFEQ      '1'
     C                   MOVE      'N'           OKBSRC
     C                   ADD       1             Ix
     C                   MOVEL     'DDBSRC'      FldNameArr(Ix)
     C                   MOVEL     'USR4435'     MsgIdArr(Ix)
     C**********         MOVEL     DDCYCD        MsgDtaArr(Ix)                              MD000091
     C                   EVAL      BLen = %Len(%Trim(DDCYCD))                               MD000091
     C                   EVAL      MsgDtaArr(Ix) = LenStr + %Trim(DDCYCD)                   MD000091
      *
     C                   ENDIF
      *
     C     EVALAE        ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * ACSSES - ACCESS SECURITY CHECKING - SINGLE BRANCHING
      *****************************************************************
     C     ACSSES        BEGSR
      *
      ** validate action codes for user
      *
     C                   CALL      'ZVACTU'
     C                   PARM      DDACTN        ZACTN             1
     C                   PARM                    ERR               1 0
      *
      * This action code invalid for user
      *
     C     ERR           IFEQ      1
     C                   MOVE      'N'           OKACTN
     C                   MOVE      'N'           OKBSRC
     C                   ADD       1             Ix
     C                   MOVEL     'DDACTN'      FldNameArr(Ix)
     C                   MOVEL     'USR4436'     MsgIdArr(Ix)
     C                   END
      *
     C                   ENDSR
      *****************************************************************
      * ACSSEM - ACCESS SECURITY CHECKING - MULTI-BRANCHING
      *****************************************************************
     C     ACSSEM        BEGSR
      *
      **  Check user's authority for the action & Booking Branch.
      *
     C                   CALL      'ZVACTBU'
     C**********         PARM                    ZACTN             1                          CAP084
     C                   PARM      DDACTN        ZACTN             1                          CAP084
     C                   PARM      BRC           ZBR               3
     C                   PARM                    ERR               1 0
      *
      **   If action invalid for user
      *
     C     ERR           IFEQ      1
     C                   MOVEL     'N'           OKACTN
     C                   ADD       1             Ix
     C                   MOVEL     'DDACTN'      FldNameArr(Ix)
     C                   MOVEL     'RE71070'     MsgIdArr(Ix)
     C                   ELSE
     C     ERR           IFEQ      2
     C                   MOVEL     'N'           OKACTN
     C                   ADD       1             Ix
     C                   MOVEL     'DDACTN'      FldNameArr(Ix)
     C                   SELECT
     C                   WHEN      DDACTN='I'
     C                   MOVEL     'USR4438'     MsgIdArr(Ix)
     C                   WHEN      DDACTN='A'
     C                   MOVEL     'USR4439'     MsgIdArr(Ix)
     C                   WHEN      DDACTN='D'
     C                   MOVEL     'USR4440'     MsgIdArr(Ix)
     C                   ENDSL
     C                   END
     C                   END
      *
     C                   ENDSR
     C/EJECT
     C*****************************************************************
     C* INIT - INITIALIZATION
     C*****************************************************************
     C     INIT          BEGSR
      *
      * CLEAR OUTPUTS
      *
     C                   CLEAR                   BasRFilFmt
     C                   MOVEL     'Y'           OKACTN
     C                   MOVEL     'Y'           OKBSRC
     C                   MOVEL     'Y'           OKCYCD
     C                   MOVEL     DDCYCD        DDTRCYCD
     C                   MOVEL     DDBSRC        DDTRBSRC
      ** Check for the existence of the replacement character at the
      ** Transaction Id level.
     C     DDACTN        IFEQ      'A'
     C                   IF        GHSUBS <> *blank
     C     GHSUBS        SCAN      DDTRNN        SubForTRNN        2 0
     C                   ENDIF
     C                   ENDIF
      **  Get ZMUSER to access default branch                                                 CAP084
     C                   IN        ZMUSER                                                     CAP084
     C                   UNLOCK    ZMUSER                                                     CAP084
      *
     C                   ENDSR
     C********************************************************************
      /EJECT
      *****************************************************************
      * *INZSR - INITIAL PROCESSING
      *****************************************************************
     C     *INZSR        BEGSR
      *
      * Parameters
      *
     C     *ENTRY        PLIST
      *
      * INPUTS
      *
      * Return code
     C                   PARM                    RetCodeIn
      *
      * Mode = '*FRONT' (FRONT OFFICE TRANSACTION INTERFACE)
      * Mode = '      ' (NOT FRONT OFFICE TRANSACTION INTERFACE)
      *
     C                   PARM                    ModeofOp          6
      *
      * Response mode
     C                   PARM                    RespMode          1
      *
      * Action Code
     C                   PARM                    DDACTN            1
      *
      * Front Office Transaction ID
     C                   PARM                    FOTRID           20
      *
      * (Midas) Base Rate Currency
     C                   PARM                    DDCYCD            3
      *
      * (Midas) Base Rate Number
     C                   PARM                    DDBSRC            2
      *
      * OUTPUTS
      *
      * (Current) base rate in file format
     C                   PARM                    BasRFilFmt
      *
      * OK - Action code
     C                   PARM                    OKACTN            1
      *
      * OK - Currency Code
     C                   PARM                    OKCYCD            1
      *
      * OK - Base Rate Code
     C                   PARM                    OKBSRC            1
      *
      * Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIdArr
     C                   PARM                    MsgDtaArr
      *
      * Array index (3P0) from/to caller
     C                   PARM                    Ix
 
      * ICD - Private Banking
     C                   PARM                    BGN4ST            1
      *
      * (Midas) Base Rate Shortname
     C                   PARM                    DDBSRS            5
      *
      * (Midas) Base Rate Name
     C                   PARM                    DDBSRN           30
      * Base Rate Auth Req                                                                    CSD012
     C                   PARM                    AUTHRQ            1                          CSD012
      * Authorisation Mode                                                                    CSD012
     C                   PARM                    AUTHMD            1                          CSD012
      *
      ** Initialize program name
      *
     C                   MOVEL     'SDBSRTRTV'   DBPGM
      *
      * Key Lists
      *
     C     SDBSRT        KLIST
     C                   KFLD                    DDCYCD
     C                   KFLD                    DDBSRC
      *                                                                                     AR641183
     C     FOBSRT        KLIST                                                              AR641183
     C                   KFLD                    BLNKFO                                     AR641183
     C                   KFLD                    DDCYCD                                     AR641183
     C                   KFLD                    DDBSRC                                     AR641183
      *
      ** ACCESS BANK DETAILS
      *
     C                   CALL      'AOBANKR0'
     C                   PARM      *BLANKS       @RTCD             7
     C                   PARM      '*FIRST '     @OPTN             7
     C     SDBANK        PARM      SDBANK        DSFDY
      *
      * DATABASE ERROR
      *
     C     @RTCD         IFNE      *BLANKS
     C                   MOVEL     'SDBANKPD'    DBFILE                         ************
     C                   MOVEL     '101'         DBASE                          * DBERR 101*
     C                   MOVEL     @OPTN         DBKEY                          ************
     C                   EXSR      *PSSR
     C                   END
 
      ** Access API ICD via access program
     C                   CALLB     'AOAPIR0'
     C                   PARM      '*DBERR '     @RTCD
     C                   PARM      '*FIRST '     @OPTN
     C     SDAPI         PARM      SDAPI         DSFDY
     C*
      *
      **  GET ZMUSER to access default branch.
      *
     C     *DTAARA       DEFINE                  ZMUSER
     C                   IN        ZMUSER
     C                   UNLOCK    ZMUSER
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      ********************************************************************
      ** Program, module and procedure names for database error processing.
      ** =================================================================
      ** The following /COPY sets these values, and also defines LDA as
      ** an external data area
      ********************************************************************
     C/COPY ZACPYSRC,PSSR_ILE
      ********************************************************************
**  CPY@
(c) Finastra International Limited 2001
