     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas FF Weighting code validation')
      *****************************************************************
      *                                                               *
      *  Midas - Futures and Options Module                           *
      *                                                               *
      *  FFVWGCD01 - Weighting Code Validation                        *
      *                                                               *
      *  Function:  This module validates weighting code.             *
      *                                                               *
      *  (c) Finastra International Limited 2001                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *  Prev Amend No. CSD027             Date 09Dec05               *
      *                 CSE071             Date 19Jul05               *
      *                 CGP001             Date 08Sep03               *
      * Midas Release 4 --------------- Base -------------------------*
      *                 CFF007  *CREATE    Date 13Feb01               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CSE071 - Multiple Holidays Re Securities (recompile)         *
      *  CGP001 - Global Processing.                                  *
      *           - SDWEIG* files renamed to GPWEIG*.                 *
      *  CFF007 - Futures and Options Enhancement for Private Banking *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  Use of indicators.                                           *
      *                                                               *
      *    01         Record not found in SECTY                       *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  S U B R O U T I N E  I N D E X                               *
      *                                                               *
      * *PSSR - Error processing                                      *
      * *INZSR - Initialise                                           *
      *                                                               *
      *****************************************************************
 
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
 
     FSECTY     IF   E           K DISK
 
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ Automatically included D-specs       ¦
      ** ¦ ==============================       ¦
      ** +--------------------------------------+
      **
      **------------------------------------------------------------------------
      ** The following /COPY line includes (among others) the LDA layout
      ** and the copyright array definition:
     D/COPY ZACPYSRC,STD_D_SPEC
      **------------------------------------------------------------------------
 
      **------------------------------------------------------------------------
      ** The following /COPY line includes all the defined fields in the
      ** Program Status Data Structures.  They have meaningful
      ** names, prefixed by 'PS'.
     D/COPY ZACPYSRC,PSDS
 
      **--------------------------------------------------------------------------------------------
      ** The following /COPY line includes all the definitions of the error
      ** arrays, including the named constant giving the size of
      ** the arrays.  Note that it uses #MsgID and #MsgData, and so requires
      ** STD_D_SPEC.
     D/COPY ZACPYSRC,FVAL_ARRAY
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
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
 
     D*SDWEIG******* E DS                  EXTNAME(SDWEIGPD)                                  CGP001
     D GPWEIG        E DS                  EXTNAME(GPWEIGPD)                                  CGP001
      ** Midas Weighting Codes File Data Structure
 
     D*DSSDY******** E DS                  EXTNAME(DSSDY)                                     CGP001
     D DSFDY         E DS                  EXTNAME(DSFDY)                                     CGP001
      ** First DS for Access Programs, Long Data Structure
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
     D STWEI           S              2A
     D SUNSE           S             10A
     D BGSECS          S              1A
 
     D PRtCd           S              7A
     D POptn           S              7A
 
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
 
      ** Reset error fields
 
      **--------------------------------------------------------------------------------------------
      ** The following /COPY line resets the fields related to error
      ** handling: ReturnCode, ErrorFound, FldNamXArr, MsgIDXArr,
      ** MsgDtaXArr, XIdx.  It therefore requires FVAL_ARRAY and STD_D_SPEC.
     C/COPY ZACPYSRC,FVAL_RESET
 
     C                   IF        BGSECS = 'Y'
     C                             AND  STWEI = *Blanks
     C     SUNSE         CHAIN     SECTY                              01
 
      ** Default value from SECTY file
 
     C                   IF        *IN01 = '0'
     C                   MOVE      WEIC          STWEI
     C                   ELSE
 
      ** A valid weighting code must be entered
 
     C                   EVAL      XIdx = XIdx + 1
     C                   EVAL      FldNamXArr(XIdx) = 'STWEI'
     C                   EVAL      MsgIDXArr(XIdx) = 'MMA0836'
     C                   EVAL      ReturnCode = 'Error'
     C                   ENDIF
 
     C                   ENDIF
 
     C                   IF        ReturnCode = *Blanks
 
      ** Access Weighting Code Description File
 
     C**********         CALL      'AOWEIGR0'                                                 CGP001
     C                   CALL      'GPAOWEIGR0'                                               CGP001
     C                   PARM      *Blanks       PRtCd
     C                   PARM      '*KEY  '      POptn
     C                   PARM                    STWEI
     C*****SDWEIG        PARM      SDWEIG        DSSDY                                        CGP001
     C     GPWEIG        PARM      GPWEIG        DSFDY                                        CGP001
 
      ** A valid weighting code must be entered
 
     C                   IF        PRtCd <> *Blanks
     C                   EVAL      XIdx = XIdx + 1
     C                   EVAL      FldNamXArr(XIdx) = 'STWEI'
     C                   EVAL      MsgIDXArr(XIdx) = 'MMA0836'
     C                   EVAL      ReturnCode = 'Error'
     C                   ELSE
     C                   MOVE      PDWEIG        STWEI
     C                   ENDIF
 
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
 
     C     *ENTRY        PLIST
     C                   PARM                    ReturnCode
     C                   PARM                    STWEI
     C                   PARM                    SUNSE
     C                   PARM                    BGSECS
     C                   PARM                    MsgIDXArr
     C                   PARM                    FldNamXArr
 
      **--------------------------------------------------------------------------------------------
      ** The following /COPY sets the values of program, module and
      ** procedure names for database error processing.
     C/COPY ZACPYSRC,DBFIELDS
      **--------------------------------------------------------------------------------------------
 
     C                   ENDSR
 
      /EJECT
      *****************************************************************
      **--------------------------------------------------------------+
      ** The following /COPY contains the standard program status
      ** subroutine, including a bound call to the DBERRCTL module.
     C/COPY ZACPYSRC,PSSR_ILE
      **--------------------------------------------------------------+
      *****************************************************************
      /EJECT
      *****************************************************************
**  CPY@
(c) Finastra International Limited 2001
