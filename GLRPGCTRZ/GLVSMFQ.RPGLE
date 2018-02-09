     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas GL Validate Freq, No of Copies, Nxt S Day no')   *
      *****************************************************************
      *                                                               *
      *  Midas - General Ledger Module                                *
      *                                                               *
      *  GLVSMFQ    - Validate Frequency, No. of Copies and           *
      *              Next Statement Day No.                           *
      *                                                               *
      *  (c) Finastra International Limited 2001                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      *  Prev Amend No. CGL184             Date 07Dec16               *
      *                 MD025568           Date 11Mar14               *
      *                 CGL001             Date 06Aug12               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 225792  BUG548     Date 16Mar04               *
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.02 -----------------------------------------------*
      *                 CAP035  *CREATE    Date 19Mar99               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CGL184 - New Frequencies for Account Statements              *
      *  MD025568 - Incorrect error message displayed upon            *
      *             selecting Frequency E                             *
      *  CGL001 - Introduction of New statement frequency 'N' (NEVER) *
      *  225792 - Error RE71110 should not be display together with   *
      *                 RE71111 and RE71112.                          *
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
 
      ** Valid Frequency Data
     D***Frequency       C                   CONST('ABDEFLMQRSTWXYZ')                         CGL001
     D********** Frequency       C                   CONST('ABDEFLMNQRSTWXYZ')         CGL001 CGL184
     D Frequency       C                   CONST('ABDEFLMNQRSTWXYZKGHO')                      CGL184
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
      ** Index for arrays of error message ids etc
     D Idx             S              3P 0
 
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
 
     C                   Movel     *Blanks       RetCodeIn
     C                   Movel     *Blanks       FldNamXAr
     C                   Movel     *Blanks       MsgIDXAr
     C                   Movel     *Blanks       MsgDtaXAr
     C                   Z-add     0             Idx
      *
     C                   ExSr      SrVStFq
      *
     C                   ExSr      SrVENoC
      *
     C                   ExSr      SrVNSDN
      *
      ** If an error was found, set the return code appropriately
      *
     C     DDStFqOK      IfEq      'N'
     C     DDENoCOK      OrEq      'N'
     C     DDNSDNOK      OrEq      'N'
     C                   Eval      RetCodeIn = 'Error'
     C                   EndIf
      *
      ** RETURN
      *
     C                   RETURN
      *****************************************************************
      /EJECT
      *****************************************************************
      * SRVStFq - Validate Statement Frequency                        *
      *****************************************************************
     C     SRVStFq       BEGSR
      *
      **  DDFREQ is mandatory
     C     DDStFq        IfEq      *Blanks
     C                   Move      'N'           DDStFqOk
     C                   Add       1             Idx
     C                   Movel     'DDStFq'      FldNamXAr(Idx)
     C                   Movel     'RE71108'     MsgIDXAr(Idx)
     C                   EndIf
      *
      ** DDStFq must be valid.
      ** DDStFq 'E' is not allowed if Turnover Statements not installed.
     C     DDStFq        SCAN      Frequency                              80
     C     *In80         IfEq      False
     C     DDStFq        OrEq      'E'
     C     TTURN         AndNE     'Y'
     C     DDStFq        OrEQ      'K'                                                        CGL184
     C     CGL184        ANDEQ     'N'                                                        CGL184
     C     DDStFq        OrEQ      'G'                                                        CGL184
     C     CGL184        ANDEQ     'N'                                                        CGL184
     C     DDStFq        OrEQ      'H'                                                        CGL184
     C     CGL184        ANDEQ     'N'                                                        CGL184
     C     DDStFq        OrEQ      'O'                                                        CGL184
     C     CGL184        ANDEQ     'N'                                                        CGL184
     C/COPY WNCPYSRC,GLH00724
     C                   Move      'N'           DDStFqOk
     C                   Add       1             Idx
     C                   Movel     'DDStFq'      FldNamXAr(Idx)
     C**********         Movel     'RE71109'     MsgIDXAr(Idx)                              MD025568
     C                   MOVEL     '5046261'     MsgIDXAr(Idx)                              MD025568
     C                   EndIf
     C/COPY WNCPYSRC,GLH00725
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * SRVENoC - Validate Extra Number of Copies                     *
      *****************************************************************
     C     SRVENoC       BEGSR
      *
     C     DDStFq        IfNE      'E'
     C     DDENoC        AndNE     *blanks
     C                   Move      'N'           DDENoCOk
     C                   Add       1             Idx
     C                   Movel     'DDENoC'      FldNamXAr(Idx)
     C                   Movel     'RE71110'     MsgIDXAr(Idx)
     C                   EndIf
      *
      ** Must be numeric
     C     DDENoC        IfNE      *Blanks
     C     DDStFq        ANDEQ     'E'                                                        225792
     C                   CallB     'ZALIGN'
     C                   Parm                    ZAlignOk          1
     C                   Parm      DDENoC        ZField           16
     C                   Parm      0             ZADec             1 0
     C                   Parm      2             ZADig             2 0
      *
     C     ZAlignOk      IfNe      'Y'
     C                   Move      'N'           DDENoCOk
     C                   Add       1             Idx
     C                   Movel     'DDENoC'      FldNamXAr(Idx)
     C                   Movel     'RE71111'     MsgIDXAr(Idx)
     C                   Else
     C                   Move      ZField        DDENoC
     C                   EndIf
      *
      ** Must be greater than zero
     C     DDENoC        IfLE      *Zero
     C                   Move      'N'           DDENoCOk
     C                   Add       1             Idx
     C                   Movel     'DDENoC'      FldNamXAr(Idx)
     C                   Movel     'RE71112'     MsgIDXAr(Idx)
     C                   EndIf
     C                   EndIf
      *
      ** Default to '1' if no entry & DDStFq set to 'E'
     C     DDStFq        IfEq      'E'
     C     DDENoC        AndEq     *Blanks
     C     CNDS          AndEq     'Y'                                          - B1
     C                   Move      '1'           DDENoC
     C                   EndIf
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * SRVNSDN - Validate Next Statement Day Number                  *
      *****************************************************************
     C     SRVNSDN       BEGSR
      *
     C     DDStFq        IfEq      'M'
     C     DDStFq        OrEq      'T'
     C     DDStFq        OrEq      'Q'
     C     DDStFq        OrEq      'X'
     C     DDStFq        OrEq      'Y'
     C     DDStFq        OrEq      'K'                                                        CGL184
     C     DDStFq        OrEq      'G'                                                        CGL184
     C     DDStFq        OrEq      'H'                                                        CGL184
     C     DDStFq        OrEq      'O'                                                        CGL184
      *
     C     DDNSDN        IfNE      *Blanks
     C     DDNSDN        AndNE     '00'
      *
     C                   MoveL     DDNSDN        WNSDN             2 0
     C     WNSDN         IfLT      01
     C     WNSDN         OrGT      31
     C                   Move      'N'           DDNSDNOk
     C                   Add       1             Idx
     C                   Movel     'DDNSDN'      FldNamXAr(Idx)
     C                   Movel     'RE71851'     MsgIDXAr(Idx)
     C                   EndIf
      *
     C                   Else
      *
     C     DDNStDOk      IfEq      'Y'
     C                   MoveL     WDAY          DDNSDN
     C                   EndIf
     C
     C                   EndIf
      *
     C                   Else
      *
     C     DDNSDN        IfNE      *Blanks
     C     DDNSDN        AndNE     '00'
     C                   Move      'N'           DDNSDNOk
     C                   Add       1             Idx
     C                   Movel     'DDNSDN'      FldNamXAr(Idx)
     C                   Movel     'RE71851'     MsgIDXAr(Idx)
     C                   EndIf
      *
     C                   EndIf
      *
     CSR                 ENDSR
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
     C                   Parm                    DDStFq            1
     C                   Parm                    DDENoC            2
     C                   Parm                    DDNSDN            2
     C/COPY WNCPYSRC,GLH00726
      *
      ** Next Statement Date - Ok
     C                   Parm                    DDNStDOk          1
      *
      ** ICD
     C                   Parm                    TTURN             1
     C                   Parm                    CNDS              1
      *
      ** Day no in next statement date field
     C                   Parm                    WDAY              2
     C                   Parm                    CGL184            1                          CGL184
      *
      ** OUTPUTS
      *
      * Error fields/message IDs/message data (arrays) from/to caller
     C                   Parm                    FldNamXAr
     C                   Parm                    MsgIDXAr
     C                   Parm                    MsgDtaXAr
      *
      ** Statement Frequency - Ok
      ** Number of Copies - Ok
      ** Next Statement Day no - Ok
     C                   Parm                    DDStFqOk          1
     C                   Parm                    DDENoCOk          1
     C                   Parm                    DDNSDNOk          1
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
