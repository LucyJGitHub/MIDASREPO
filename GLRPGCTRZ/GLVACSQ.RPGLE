     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas GL Validate Account Code and Sequence Number')   *
      *****************************************************************
      *                                                               *
      *  Midas - General Ledger Module                                *
      *                                                               *
      *  GLVACSQ - Validate Account Code and Sequence Number          *
      *                                                               *
      *  (c) Finastra International Limited 2001                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      *  Prev Amend No. MD024819           Date 19Aug14               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CSD031             Date 10Apr06               *
      *                 CGL029             Date 01Sep03               *
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.02 -----------------------------------------------*
      *                 CAP035   *CREATE   Date 19Mar99               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  MD024819 - Incorrect error message for account sequence      *
      *  CSD031 - Enhanced Centralised Static Data (Recompile)        *
      *  CGL029 - Increase account code to 10 digits                  *
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
 
      ** External data structure for account code file
     D SDACOD        E DS                  EXTNAME(SDACODPD)
 
      ** External data structure for access programs (long)
     D DSFDY         E DS                  EXTNAME(DSFDY)
                                                                                              CGL029
      ** External data structure for access programs (long)                                   CGL029
     D DSSDY         E DS                  EXTNAME(DSSDY)                                     CGL029
 
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
 
     D SEQ             S              1    DIM(2)
     D NUM             S              1    DIM(10) CTDATA PERRCD(10)
                                                                                              CGL029
     D @ACOD           S             10                                                       CGL029
     D DDACod          S             10                                                       CGL029
 
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
 
     C                   Move      *BLANK        RetCodeIn
 
     C                   Move      *BLANK        FldNamXAr
     C                   Move      *BLANK        MsgIDXAr
     C                   Move      *BLANK        MsgDtaXAr
     C                   Z-add     0             Idx
      *
     C                   Exsr      SrVACod
      *
     C                   Exsr      SrVASeq
      *
      ** If an error was found, set the return code appropriately
      *
     C     DDACodOk      IfEq      'N'
     C     DDAcSqOk      OrEq      'N'
     C                   Eval      RetCodeIn = 'Error'
     C                   EndIf
      *
      * RETURN
      *
     C                   RETURN
      *****************************************************************
      /EJECT
      *****************************************************************
      * SrVACod - Validate Account Code                               *
      *****************************************************************
     C     SrVACod       BEGSR
      *
      ** Error if account code is not defined
      *
     C     DDACod        IfEq      *Blanks
     C                   Move      'N'           DDACodOK
     C                   Add       1             Idx
     C                   Movel     'DDACod'      FldNamXAr(Idx)
     C                   Movel     'RE71035'     MsgIdXAr(Idx)
      *
     C                   Else
      *
     C                   CallB     'AOACODR0'
     C                   Parm      *Blanks       @RTCD             7
     C                   Parm      '*KEY   '     @OPTN             7
     C**********         Parm      DDACod        @ACOD             4                          CGL029
     C*****SDACOD        Parm      SDACOD        DSFDY                                        CGL029
     C                   Parm      DDACod        @ACOD                                        CGL029
     C     SDACOD        Parm      SDACOD        DSSDY                                        CGL029
      *
      * Invalid Account Code
      *
     C     @RTCD         IfNe      *Blanks
     C                   Move      'N'           DDACodOk
     C                   Add       1             Idx
     C                   Movel     'DDACod'      FldNamXAr(Idx)
     C                   Movel     'RE71037'     MsgIdXAr(Idx)
     C                   Else
      *
      ** Load account type for further process
      *
     C                   MOVE      A5ACCD        DDACod
     C                   MOVE      A5ACTY        AMATYP
     C                   MOVE      A5ACST        AMSTYP
     C     A5ACTY        IFEQ      'R'
      ** ACCOUNT TYPE IS RETAIL
     C                   MOVE      'Y'           WWRetl
     C                   ELSE
     C                   MOVE      'N'           WWRetl
     C                   EndIf
      *
      ** Account code can not be a title
     C     A5TOIN        IfEq      'Y'
     C                   Move      'N'           DDACodOk
     C                   Add       1             Idx
     C                   Movel     'DDACod'      FldNamXAr(Idx)
     C                   Movel     'RE71038'     MsgIdXAr(Idx)
     C                   EndIf
     C                   EndIf
     C                   EndIf
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * SrVASeq - Validate Account Sequence                           *
      *****************************************************************
     C     SrVASeq       BEGSR
      *
      ** Error if account sequence is not defined
      *
     C     DDAcSq        IfEq      *Blanks
     C     AGMBIN        AndEq     'Y'
     C                   MoveL     '01'          DDAcSq
      *
     C                   Else
      *
      ** Must be numeric between 01 and 99
     C                   MoveA     DDAcSq        Seq
     C     SEQ(1)        LOOKUP    NUM                                    80
     C     SEQ(2)        LOOKUP    NUM                                    81
      ** Not numeric
     C     *In80         IfEq      '0'
     C     *In81         OrEq      '0'
     C     DDAcSq        OrEq      '00'
     C                   Move      'N'           DDACSQOK
     C                   Add       1             Idx
     C                   MoveL     'DDACSQ'      FldNamXAr(Idx)
     C**********         MoveL     'RE71041'     MsgIdXAr(Idx)                              MD024819
     C                   MoveL     'REL0020'     MsgIdXAr(Idx)                              MD024819
     C                   Endif
      *
     C                   EndIf
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * *INZSR - Program Initialisation routine                       *
      *****************************************************************
     C     *INZSR        BEGSR
 
     C     *Entry        Plist
      *
      * INPUTS
      *
      ** Return Code
     C                   Parm                    RetCodeIn
      *
      ** Account Screen fields
     C**********         Parm                    DDACod            4                          CGL029
     C                   Parm                    DDACod                                       CGL029
     C                   Parm                    DDAcSq            2
     C                   Parm                    DDCUSN            6
      *
      ** ICD
     C                   Parm                    A8BICN            6
     C                   Parm                    AGMBIN            1
      *
      * OUTPUTS
      *
      ** Error fields/message IDs/message data (arrays) from/to caller
     C                   Parm                    FldNamXAr
     C                   Parm                    MsgIDXAr
     C                   Parm                    MsgDtaXAr
      *
     C                   Parm                    AMATYP            1
     C                   Parm                    AMSTYP            1
     C                   Parm      A5TOIN        WWTOIN            1
     C                   Parm                    WWRETL            1
      *
      ** Account Code - Ok
      ** Account Seq  - Ok
     C                   Parm                    DDACodOk          1
     C                   Parm                    DDAcSqOk          1
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
** NUM
0123456789
