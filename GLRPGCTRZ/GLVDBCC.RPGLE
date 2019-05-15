     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas GL Validate Debit Calculation Basis')            *
      *****************************************************************
      *                                                               *
      *  Midas - General Ledger Module                                *
      *                                                               *
      *  GLVDBCC    - Validate Debit Calculation Basis                *
      *                                                               *
      *  (c) Finastra International Limited 2001                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      *  Prev Amend No. AR994725           Date 27Jun12               *
      *                 CER059             Date 19Jul10               *
      *                 CER016             Date 19May08               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.02 -----------------------------------------------*
      *                 CAP035  *CREATE    Date 19Mar99               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  AR994725 - No error message was generated when calcuation    *
      *             basis was not left blank (DR/CR)                  *
      *  CER059 - German Feature Upgrade to Delhi                     *
      *  CER016 - German Interest Calculation: Upgarde of FGE059      *
      *           to Midas Plus                                       *
      *  CAP035 - Midas/ToF Interface                                 *
      *                                                               *
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
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
      ** ¦ Named constants                      ¦
      ** ¦ ===============                      ¦
      ** +--------------------------------------+
 
      ** The maximum size of the appended error arrays
     D XArrayMax       C                   CONST(20)
 
      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
      *                                                                                       CER016
      ** External DS for SAR Details                                                          CER016
      *                                                                                       CER016
     D SCSARD        E DS                  EXTNAME(SCSARDPD)                                  CER016
      *                                                                                       CER016
      ** First DS for Access Programs, Short Data Structure                                   CER016
      *                                                                                       CER016
     D DSFDY         E DS                  EXTNAME(DSFDY)                                     CER016
 
      ** Array of Fields in error.
     D FldNamXAr       S             10A   DIM(XArrayMax)
 
      ** Array of error message IDs
     D MsgIDXAr        S                   DIM(XArrayMax) LIKE(#MsgId)
 
      ** Array of error message data.
     D MsgDtaXAr       S                   DIM(XArrayMax) LIKE(#MsgData)
 
      ** +--------------------------------------+
      ** ¦ Named constants                      ¦
      ** ¦ ===============                      ¦
      ** +--------------------------------------+
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
      ** Index for arrays of error message ids etc
     D Idx             S              3P 0
      *                                                                                       CER016
      ** Fields defined for Enhancement CER016                                                CER016
      *                                                                                       CER016
     D CER016          S              1A                                                      CER016
     D PRtCd           S              7A                                                      CER016
     D POptn           S              7A                                                      CER016
     D PSard           S              6A                                                      CER016
 
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
 
      ** Initialization
 
     C                   MoveL     *Blanks       RetCodeIn
     C                   MoveL     *Blanks       FldNamXAr
     C                   MoveL     *Blanks       MsgIDXAr
     C                   MoveL     *Blanks       MsgDtaXAr
     C                   Z-Add     0             Idx
      *
      ** If DR calc. basis is blank and a/c is non-interest bearing,
      ** default it to the Default Interest Calc. Basis for the currency,
      ** if this is blank, default to '1'.
     C     DDDRIC        IFEQ      *BLANK
     C     DDDRIB        ANDEQ     *BLANK
     C     DDDRIS        ANDEQ     *BLANK
     C     DDDSIG        ANDEQ     *BLANK
     C     DDDICT        ANDEQ     *BLANK
     C     DDDCST        ANDEQ     *BLANK
     C*
     C     A6DICB        IFNE      *BLANK
     C                   MOVE      A6DICB        DDDRIC
     C                   ELSE
     C                   MOVE      '1'           DDDRIC
     C                   ENDIF
      *
     C                   ENDIF
      *
      **  ENTRY MANDATORY AND MUST BE = 1,...,7
     C     DDDRIC        IFLT      '1'
     C     DDDRIC        ORGT      '7'
      *                                                                                       CER016
     C     DDDRIC        IFEQ      '0'                                                        CER016
     C     CER016        ANDNE     'Y'                                                        CER016
     C     DDDRIC        OREQ      ' '                                                      AR994725
     C     CER016        ANDNE     'Y'                                                      AR994725
     C                   Move      'N'           DDDRICOk
     C                   Add       1             Idx
     C                   MoveL     'DDDRIC'      FldNamXAr(Idx)
     C                   MoveL     'RE71218'     MsgIDXAr(Idx)
     C                   ELSE                                                                 CER016
     C     DDDRIC        IFGT      '7'                                                        CER016
     C                   Move      'N'           DDDRICOk                                     CER016
     C                   Add       1             Idx                                          CER016
     C                   MoveL     'DDDRIC'      FldNamXAr(Idx)                               CER016
     C                   MoveL     'RE71218'     MsgIDXAr(Idx)                                CER016
     C                   ENDIF                                                                CER016
      *                                                                                       CER016
     C                   ENDIF                                                                CER016
      *                                                                                       CER016
     C                   ENDIF
      *
      ** If an error was found, set the return code appropriately
      *
     C     DDDRICOk      IfEq      'N'
     C                   Eval      RetCodeIn = 'Error'
     C                   EndIf
      *
      ** RETURN
      *
     C                   RETURN
      *****************************************************************
      /EJECT
      *****************************************************************
      * *INZSR - Program Initialisation routine                       *
      *****************************************************************
     C     *INZSR        BEGSR
 
     C     *Entry        Plist
      *
      ** INPUTS
      *
      ** Return Code
     C                   Parm                    RetCodeIn
      *
      ** Account Screen fields
     C                   Parm                    DDDRIC            1
     C                   Parm                    DDDRIB            2
     C                   Parm                    DDDRIS           12
     C                   Parm                    DDDSIG            1
     C                   Parm                    DDDICT            2
     C                   Parm                    DDDCST            5
      *
      ** Standing Data
     C                   PARM                    A6DICB            1
      *
      ** OUTPUTS
      *
      * Error fields/message IDs/message data (arrays) from/to caller
     C                   Parm                    FldNamXAr
     C                   Parm                    MsgIDXAr
     C                   Parm                    MsgDtaXAr
      *
      ** Calculation Basis - OK
     C                   Parm                    DDDRICOk          1
      *                                                                                       CER016
      ** Check if switchable feature CER016 is installed                                      CER016
      *                                                                                       CER016
     C                   CALLB     'AOSARDR0'                                                 CER016
     C                   PARM      *BLANKS       PRtCd                                        CER016
     C                   PARM      '*VERIFY'     POptn                                        CER016
     C                   PARM      'CER016'      PSard                                        CER016
     C     SCSARD        PARM      SCSARD        DSFDY                                        CER016
      *                                                                                       CER016
     C                   IF        PRtCd <> *BLANKS AND                                       CER016
     C                             PRtCd <> '*NRF'                                            CER016
     C     *LOCK         IN        LDA                                                        CER016
     C                   EVAL      DBFILE = 'SCSARDPD'                                        CER016
     C                   EVAL      DBASE = 1                                                  CER016
     C                   EVAL      DBKEY = 'CER016'                                           CER016
     C                   OUT       LDA                                                        CER016
     C                   EXSR      *PSSR                                                      CER016
     C                   ENDIF                                                                CER016
      *                                                                                       CER016
     C                   IF        PRtCd = *BLANKS                                            CER016
     C                   EVAL      CER016 = 'Y'                                               CER016
     C                   ENDIF                                                                CER016
      *
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
