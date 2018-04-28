     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2001')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas FF Economic Sector Validation')                  *
      *****************************************************************
      *                                                               *
      *  Midas - Futures and Options Module                           *
      *                                                               *
      *  FFVECSC01 - Economic Sector Validation                       *
      *                                                               *
      *  Function:  This module validates economic sector.            *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2001            *
      *                                                               *
      *  Last Amend No. AR798207           Date 13Jul11               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *  Prev Amend No. CSD027             Date 09Dec05               *
      *                 CSE071             Date 19Jul05               *
      * Midas Release 4 --------------- Base -------------------------*
      *                 CFF007  *CREATE    Date 13Feb01               *
      *                                    Date DDMmmYY               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  AR798207 - Required fields in New Instrument Details Tab     *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CSE071 - Multiple Holidays Re Securities (recompile)         *
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
 
     D SDECOS        E DS                  EXTNAME(SDECOSPD)
      ** Midas Economic Sector File Data Structure
 
     D SDINDS        E DS                  EXTNAME(SDINDSPD)
      ** Midas Local Industry Codes File Data Structure
 
     D DSSDY         E DS                  EXTNAME(DSSDY)
      ** First DS for Access Programs, Long Data Structure
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
     D STECO           S              3A
     D SUNSE           S             10A
     D BGSECS          S              1A
 
     D PRtCd           S              7A
     D POptn           S              7A
     D PInCd           S              3A
 
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
 
      ** Security module is installed
 
     C                   IF        BGSECS = 'Y'
     C                             AND  STECO = *Blanks
     C     SUNSE         CHAIN     SECTY                              01
 
     C                   IF        *IN01 = '0'
 
     C**********         MOVE      SIDY          PInCd                                      AR798207
     C                   MOVE      LOIC          PInCd                                      AR798207
 
      ** Access Local Industry Codes File
 
     C                   CALL      'AOINDSR0'
     C                   PARM      *Blanks       PRtCd
     C                   PARM      '*KEY  '      POptn
     C                   PARM                    PInCd
     C     SDINDS        PARM      SDINDS        DSSDY
 
      ** A valid economic sector must be entered
 
     C                   IF        PRtCd <> *Blanks
     C                   EVAL      XIdx = XIdx + 1
     C                   EVAL      FldNamXArr(XIdx) = 'STECO'
     C                   EVAL      MsgIDXArr(XIdx) = 'MMA0835'
     C                   EVAL      ReturnCode = 'Error'
     C                   ELSE
 
      ** Default value from Local Industry Codes File
 
     C                   EVAL      STECO = AOECOS
     C                   ENDIF
 
     C                   ELSE
 
      ** A valid economic sector must be entered
 
     C                   EVAL      XIdx = XIdx + 1
     C                   EVAL      FldNamXArr(XIdx) = 'STECO'
     C                   EVAL      MsgIDXArr(XIdx) = 'MMA0835'
     C                   EVAL      ReturnCode = 'Error'
     C                   ENDIF
 
     C                   ENDIF
 
     C                   IF        ReturnCode = *Blanks
 
      ** Access Economic Sector Description File
 
     C                   CALL      'AOECOSR0'
     C                   PARM      *Blanks       PRtCd
     C                   PARM      '*KEY  '      POptn
     C                   PARM                    STECO
     C     SDECOS        PARM      SDECOS        DSSDY
 
      ** A valid economic sector must be entered
 
     C                   IF        PRtCd <> *Blanks
     C                   EVAL      XIdx = XIdx + 1
     C                   EVAL      FldNamXArr(XIdx) = 'STECO'
     C                   EVAL      MsgIDXArr(XIdx) = 'MMA0835'
     C                   EVAL      ReturnCode = 'Error'
     C                   ELSE
     C                   EVAL      STECO = PCECOS
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
     C                   PARM                    STECO
     C                   PARM                    SUNSE
     C                   PARM                    BGSECS
     C                   PARM                    MsgIDXArr
     C                   PARM                    FldNamXArr
 
      **---------------------------------------------------------------
      ** The following /COPY sets the values of program, module and
      ** procedure names for database error processing.
     C/COPY ZACPYSRC,DBFIELDS
      **---------------------------------------------------------------
 
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
(c) Misys International Banking Systems Ltd. 2001
