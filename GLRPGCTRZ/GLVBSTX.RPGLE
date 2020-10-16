     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas GL Validate base rate tax category')
      *****************************************************************
      *                                                               *
      *  Midas - General Ledger Module                                *
      *                                                               *
      *  GLVBSTX   - Validate Base Rate Tax Category                  *
      *                                                               *
      *  (c) Finastra International Limited 2001                      *
      *                                                               *
      *  Last Amend No. 259496             Date 10Oct20               *
      *  Prev Amend No. MD046248           Date 27Oct17               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      * Midas Release 4.01.02 ----------------------------------------*
      *  Prev Amend No. 198865             Date 25Mar02               *
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.05 -----------------------------------------------*
      *                 CRE007             Date 01Mar01               *
      * Midas DBA 3.02 -----------------------------------------------*
      *                 CAP035  *CREATE    Date 19Mar99               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  259496 - Reversed fix 198865. BRT Category in accounts should*
      *           be mandatory.                                       *
      *         - Applied fix for MD056903.                           *
      *  MD046248 - Finastra Rebranding                               *
      *  198865 - Allow Base Rate Tax Category to be blanks.          *
      *  CRE007 - Base Rate Tax 2001.                                 *
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

     C                   MoveL     *Blanks       RetCodeIn
     C                   MoveL     *Blanks       FldNamXAr
     C                   MoveL     *Blanks       MsgIDXAr
     C                   MoveL     *Blanks       MsgDtaXAr
     C                   Z-Add     0             Idx
      *
      ** If Account Holder type is not R                                                      CRE007
      ** Validate field - Mandatory entry must be L,P,X,N,C OR B
      *
     C     ACHLRT        IFNE      'R'                                                        CRE007
     C*****DDBRTCA*******IFNE      'L'                                                        CRE007
     C     DDBRTCA       ANDNE     'L'                                                        CRE007
     C     DDBRTCA       ANDNE     'P'
     C     DDBRTCA       ANDNE     'X'
     C     DDBRTCA       ANDNE     'N'
     C     DDBRTCA       ANDNE     'C'
     C     DDBRTCA       ANDNE     'B'
      **Allow blanks.********                                                          198865 259496
     C*****DDBRTCA*****  ANDNE     ' '                                                 198865 259496
      *                                                                                       CRE007
      ** If Account Holder type is R                                                          CRE007
      ** Validate field - Mandatory entry must be L,P,X,N,C,B OR R                            CRE007
     C     ACHLRT        OREQ      'R'                                                        CRE007
     C     DDBRTCA       ANDNE     'L'                                                        CRE007
     C     DDBRTCA       ANDNE     'P'                                                        CRE007
     C     DDBRTCA       ANDNE     'X'                                                        CRE007
     C     DDBRTCA       ANDNE     'N'                                                        CRE007
     C     DDBRTCA       ANDNE     'C'                                                        CRE007
     C     DDBRTCA       ANDNE     'B'                                                        CRE007
     C     DDBRTCA       ANDNE     'R'                                                        CRE007
      **Allow blanks.********                                                          198865 259496
     C*****DDBRTCA*****  ANDNE     ' '                                                 198865 259496
      *                                                                                       CRE007
     C                   Move      'N'           DDBRTCAOk
     C                   Add       1             Idx
     C                   MoveL     'DDBRTCA'     FldNamXAr(Idx)
     C                   MoveL     'RE71861'     MsgIDXAr(Idx)
     C                   ENDIF
      *
      ** IF ACCOUNT IS A CORPORATE CUSTOMER, BRT ACCOUNT HOLDER TYPE
      ** MUST BE 'C'
      *
     C     DDBRTCA       IFEQ      'C'
     C     ACHLRT        ANDNE     'C'
     C                   Move      'N'           DDBRTCAOk
     C                   Add       1             Idx
     C                   MoveL     'DDBRTCA'     FldNamXAr(Idx)
     C                   MoveL     'RE71862'     MsgIDXAr(Idx)
     C                   ENDIF
      *
      ** IF ACCOUNT IS A BANK, BRT ACCOUNT HOLDER TYPE MUST BE 'B'
      *
     C     DDBRTCA       IFEQ      'B'
     C     ACHLRT        ANDNE     'B'
     C                   Move      'N'           DDBRTCAOk
     C                   Add       1             Idx
     C                   MoveL     'DDBRTCA'     FldNamXAr(Idx)
     C                   MoveL     'RE71863'     MsgIDXAr(Idx)
     C                   ENDIF
      *
      ** IF ACCOUNT IS EXEMPT, BRT ACCOUNT HOLDER TYPE MUST BE 'N' OR 'O'
      *
     C     DDBRTCA       IFEQ      'X'
     C     ACHLRT        ANDNE     'N'
     C     ACHLRT        ANDNE     'O'
     C                   Move      'N'           DDBRTCAOk
     C                   Add       1             Idx
     C                   MoveL     'DDBRTCA'     FldNamXAr(Idx)
     C                   MoveL     'RE71864'     MsgIDXAr(Idx)
     C                   ENDIF
      *
      ** If value entered is 'L' then Account Holder Type must be
      ** 'I' or 'J'.
      *
     C     DDBRTCA       IFEQ      'L'
     C     ACHLRT        IFNE      'I'
     C     ACHLRT        ANDNE     'J'
     C                   Move      'N'           DDBRTCAOk
     C                   Add       1             Idx
     C                   MoveL     'DDBRTCA'     FldNamXAr(Idx)
     C                   MoveL     'RE71865'     MsgIDXAr(Idx)
     C                   ENDIF
     C                   ENDIF
      *
      ** If value entered is 'P' then Account Holder Type must be 'J'
      *
     C     DDBRTCA       IFEQ      'P'
     C     ACHLRT        IFNE      'J'
     C                   Move      'N'           DDBRTCAOk
     C                   Add       1             Idx
     C                   MoveL     'DDBRTCA'     FldNamXAr(Idx)
     C                   MoveL     'RE71866'     MsgIDXAr(Idx)
     C                   ENDIF
     C                   ENDIF
      *
      ** If value entered is 'N' then Account Holder Type must be
      ** 'I' or 'J'.
      *
     C     DDBRTCA       IFEQ      'N'
     C     ACHLRT        IFNE      'I'
     C     ACHLRT        ANDNE     'J'
     C                   Move      'N'           DDBRTCAOk
     C                   Add       1             Idx
     C                   MoveL     'DDBRTCA'     FldNamXAr(Idx)
     C                   MoveL     'RE71867'     MsgIDXAr(Idx)
     C                   ENDIF
     C                   ENDIF
      *
      ** If value entered is 'P' then none of the parties to
      ** the account may be non-resident.(HxBRTL=X)
      *
     C     DDBRTCA       IFEQ      'P'
     C     H1BRTL        IFEQ      'X'
     C     H2BRTL        OREQ      'X'
     C     H3BRTL        OREQ      'X'
     C     H4BRTL        OREQ      'X'
     C     H5BRTL        OREQ      'X'
     C                   Move      'N'           DDBRTCAOk
     C                   Add       1             Idx
     C                   MoveL     'DDBRTCA'     FldNamXAr(Idx)
     C                   MoveL     'RE71868'     MsgIDXAr(Idx)
     C                   ENDIF
     C                   ENDIF
      *
      ** If value entered is 'L' then none of the parties to
      ** the account may be non-liable.(HxBRTL=N)
      *
     C     DDBRTCA       IFEQ      'L'
     C     H1BRTL        IFEQ      'N'
     C     H2BRTL        OREQ      'N'
     C     H3BRTL        OREQ      'N'
     C     H4BRTL        OREQ      'N'
     C     H5BRTL        OREQ      'N'
     C                   Move      'N'           DDBRTCAOk
     C                   Add       1             Idx
     C                   MoveL     'DDBRTCA'     FldNamXAr(Idx)
     C                   MoveL     'RE71869'     MsgIDXAr(Idx)
     C                   ENDIF
     C                   ENDIF
      *
      ** If value entered is 'N' then none of the parties to
      ** the account may be liable.(HxBRTL=Y)
      *
     C     DDBRTCA       IFEQ      'N'
     C     H1BRTL        IFEQ      'Y'
     C     H2BRTL        OREQ      'Y'
     C     H3BRTL        OREQ      'Y'
     C     H4BRTL        OREQ      'Y'
     C     H5BRTL        OREQ      'Y'
     C                   Move      'N'           DDBRTCAOk
     C                   Add       1             Idx
     C                   MoveL     'DDBRTCA'     FldNamXAr(Idx)
     C                   MoveL     'RE71870'     MsgIDXAr(Idx)
     C                   ENDIF
     C                   ENDIF
      *
      ** IF ACCOUNT IS PART LIABLE (P) FOR BRT NEITHER OF THE PARTIES
      ** MAY BE THE SAME OR NON RESIDENT (HXBRTL=X)
      *
     C     DDBRTCA       IFEQ      'P'
     C     H1BRTL        IFEQ      H2BRTL
     C     H1BRTL        OREQ      'X'
     C     H2BRTL        OREQ      'X'
     C                   Move      'N'           DDBRTCAOk
     C                   Add       1             Idx
     C                   MoveL     'DDBRTCA'     FldNamXAr(Idx)
     C                   MoveL     'RE71871'     MsgIDXAr(Idx)
     C                   ENDIF
     C                   ENDIF
      *
      *
      ** If an error was found, set the return code appropriately
      *
     C     DDBRTCAOK     IfEq      'N'
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
     C                   Parm                    DDBRTCA           1
      *
      ** ICD
     C                   Parm                    ACHLRT            1
     C                   Parm                    H1BRTL            1
     C                   Parm                    H2BRTL            1
     C                   Parm                    H3BRTL            1
     C                   Parm                    H4BRTL            1
     C                   Parm                    H5BRTL            1
      *
      ** OUTPUTS
      *
      * Error fields/message IDs/message data (arrays) from/to caller
     C                   Parm                    FldNamXAr
     C                   Parm                    MsgIDXAr
     C                   Parm                    MsgDtaXAr
      *
      ** BRT Category - Ok
     C                   Parm                    DDBRTCAOk         1
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
