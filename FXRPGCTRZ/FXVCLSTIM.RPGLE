     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas FX Validate CLS time')
      *****************************************************************
      *                                                               *
      *  Midas - Common Validation Routine                            *
      *                                                               *
      *  FXVCLSTIM - Validate Time                                    *
      *              (for CLS Pay-in Schedule)                        *
      *                                                               *
      *  Function:  This module receives a parameter containing the   *
      *             CLS Pay-in Time and confirms if valid.            *
      *             If it is valid then 10A return code will be       *
      *             blank; if it is not it will contain 'Error'       *
      *             If it is blank, return code will be 'NoTime'      *                       189658
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
      * Midas DBA 3.05 -----------------------------------------------*
      *  Prev Amend No. 189658             Date 06Feb01               *
      * Midas DBA 3.04 -----------------------------------------------*
      *                 CDL008  *CREATE    Date 02May00               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  189658 - CLS pay-in schedule can be input without a time     *
      *  CDL008 - Continuous Linked Settlement                        *
      *                                                               *
      *****************************************************************
 
      *****************************************************************
      ** +----------------------------+
      ** ¦ Manually Included F-Specs  ¦
      ** ¦ =========================  ¦
      ** +----------------------------+
      **
      ** +-----------------------------------+
      ** ¦ End of Manually Included F-Specs  ¦
      ** ¦ ================================  ¦
      ** +-----------------------------------+
      **
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
 
      ** Program, procedure and module names for parameters
      ** ==================================================
 
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
 
      ** The maximum size of the appended error arrays
     D XArrayMax       C                   CONST(20)
 
      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
 
      ** Array of Fields in error.
     D FldNamXAr       S             10A   DIM(XArrayMax)
 
      ** Array of error message IDs
     D MsgIDXAr        S                   DIM(XArrayMax) LIKE(#MsgId)
 
      ** Array of error message data.
     D MsgDtaXAr       S                   DIM(XArrayMax) LIKE(#MsgData)
 
     D INFDS           DS
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
      ** Index of errors accumulated from previous modules
      ** received as a parameter
     D Idx             S              3  0
 
      *
      ** CLS Time in file field
     D @PYTIM          S              4
 
      ** Parameter used for ZALIGN
     D ZFIELD          S             16A
     D ZADEC           S              1P 0
     D ZADIG           S              2P 0
     D ZALIGNok        S              1A
 
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
 
     C                   MOVE      *BLANK        RetCodeIn
 
     C                   MOVE      *BLANK        FldNamXAr
     C                   MOVE      *BLANK        MsgIDXAr
     C                   MOVE      *BLANK        MsgDtaXAr
     C                   Z-ADD     0             Idx
      *
      *  *---------------*
      *  * Validate Time *
      *  *---------------*
      *
     C     @CLSTIM       IFNE      *BLANK
     C                   MOVE      *BLANKS       WTIME             4
     C                   MOVE      @CLSTIM       WTIME
     C                   MOVE      *BLANKS       ZFIELD
     C                   MOVE      WTIME         ZFIELD
     C                   CALLB     'ZALIGN'
     C                   PARM                    ZALIGNOK
     C                   PARM                    ZFIELD
     C                   PARM      0             ZADEC
     C                   PARM      4             ZADIG
      *
     C     ZALIGNOK      IFEQ      'N'
     C                   MOVE      'N'           CLSTIMOK
     C                   ELSE
     C     2             SUBST     ZFIELD:13     WHRST             2
     C                   MOVE      WHRST         WHOUR             2 0
     C                   MOVE      ZFIELD        WMINS             2 0
      *
      ** Check for HH:MM format
      *
     C     WHOUR         IFGE      0
     C     WHOUR         ANDLE     23
     C     WMINS         ANDGE     0
     C     WMINS         ANDLE     59
     C                   MOVEL     WHOUR         WTIME
     C                   MOVE      WMINS         WTIME
     C                   MOVEL     WTIME         @CLSTIM
     C                   ELSE
     C                   MOVE      'N'           CLSTIMOK
     C                   ENDIF
     C                   ENDIF
      *
      ** If CLS time is not valid, issue error msgs
      *
     C                   IF        CLSTIMOK = 'N'
     C                   ADD       1             Idx
     C                   MOVEL     '@CLSTIM'     FldNamXAr(Idx)
     C                   MOVEL     'FXM3025'     MsgIdXAr(Idx)
     C                   ENDIF
      *
      ***CLS*time*must*not*be*blank***                                                        189658
      ** If CLS time is blank, set return code = NoTime                                       189658
      *
     C                   ELSE
     C***********        MOVE      'N'           CLSTIMOK                                     189658
     C***********        ADD       1             Idx                                          189658
     C***********        MOVEL     '@CLSTIM'     FldNamXAr(Idx)                               189658
     C***********        MOVEL     'FXM3028'     MsgIdXAr(Idx)                                189658
     C                   EVAL      RetCodeIn = 'NoTime    '                                   189658
     C                   ENDIF
     C
      *
      ** If the time is valid, set up time for output
      *
     C     Idx           IFEQ      0
     C     @CLSTIM       IFNE      *BLANK
     C                   EVAL      @PYTIM = @CLSTIM
     C                   ELSE
     C                   EVAL      @PYTIM = *BLANKS
     C                   ENDIF
     C                   ENDIF
      *
     C                   IF        CLSTIMOK  = 'N'
     C                   EVAL      RetCodeIn = 'Error'
     C                   ENDIF
      *
     C                   RETURN
 
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
 
     C     *ENTRY        PLIST
     C                   PARM                    RetCodeIn
     C                   PARM                    @CLSTIM           4
      *
      * Error fields/message IDs/message data (arrays) from/to caller
      *
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
     C                   PARM                    @PYTIM
     C                   PARM                    CLSTIMOK          1
 
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
