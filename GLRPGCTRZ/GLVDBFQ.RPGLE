     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2001')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas GL Validate Debit Next Cap. Date, Freq, Day')    *
      *****************************************************************
      *                                                               *
      *  Midas - General Ledger Module                                *
      *                                                               *
      *  GLVDBFQ    - Validate Debit Next Capitalisation Date,        *
      *               Frequency and Day no.                           *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2001            *
      *                                                               *
      *  Last Amend No. CRE090             Date 14Feb14               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      *  Prev Amend No. 242793             Date 09Oct06               *
      * Midas Plus 1.3 ----------- Base ------------------------------*
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.02 -----------------------------------------------*
      *                 CAP035  *Create    Date 19Mar99               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CRE090 - Delay Capitalisation of Interest                    *
      *  242793 - Add new message ID to validate if BMLDAI is Y.      *
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
 
      ** Array of Frequency
     D FREQ            S              1    DIM(14) CTDATA PERRCD(14)
 
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
     D CRE090          S              1A                                                      CRE090
 
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
     C                   ExSr      SrVDRIF
      *
     C                   ExSr      SrVNDID
      *
     C                   ExSr      SrVDNCD
      *
      ** If an error was found, set the return code appropriately
      *
     C     DDNDIDOk      IfEq      'N'
     C     DDDRIFOk      OrEq      'N'
     C     DDDNCDOk      OrEq      'N'
     C                   Eval      RetCodeIn = 'Error'
     C                   EndIf
      *
      ** RETURN
      *
     C                   RETURN
      *****************************************************************
      /EJECT
      *****************************************************************
      *  SrVDRIF - Validate Next Capitalistion Frequency              *
      *****************************************************************
     C     SRVDRIF       BEGSR
      *
      ** If cap. date & freq. are blank and a/c is non-interest bearing,
      ** default it to 'Z'.
     C     DDDRIF        IFEQ      *BLANK
     C     DDNDID        ANDEQ     *BLANK
     C     DDDRIB        ANDEQ     *BLANK
     C     DDDRIS        ANDEQ     *BLANK
     C     DDDSIG        ANDEQ     *BLANK
     C     DDDICT        ANDEQ     *BLANK
     C     DDDCST        ANDEQ     *BLANK
     C                   MOVE      'Z'           DDDRIF
     C                   ENDIF
      *
      ** DEBIT CAPITALISATION FREQUENCY MANDATORY AND MUST BE 'ABDFLMQRSTWXYZ'
     C     DDDRIF        LOOKUP    FREQ                                   80
     C     *IN80         IFEQ      '0'
     C                   Move      'N'           DDDRIFOk
     C                   Add       1             Idx
     C                   MoveL     'DDDRIF'      FldNamXAr(Idx)
     C                   MoveL     'RE71221'     MsgIDXAr(Idx)
     C                   ENDIF
      *
      ** DEBIT CAPITALISATION FREQUENCY MUST BE 'Z' IF NEXT ONE IS BLANK
     C     DDNDID        IFEQ      *BLANK
     C     DDDRIF        ANDNE     'Z'
     C                   Move      'N'           DDDRIFOk
     C                   Add       1             Idx
     C                   MoveL     'DDDRIF'      FldNamXAr(Idx)
     C                   MoveL     'RE71222'     MsgIDXAr(Idx)
     C                   ENDIF
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *  SrVNDID - Validate Next Capitalistion Date                   *
      *****************************************************************
     C     SRVNDID       BEGSR
      *
     C     DDDRIB        IFNE      *BLANK
     C     DDDRIS        ORNE      *BLANK
     C     DDDSIG        ORNE      *BLANK
     C     DDDICT        ORNE      *BLANK
     C     DDDCST        ORNE      *BLANK
      *
      ** ENTRY MANDATORY IF DEBIT CAPITALISATION FREQUENCY IS NOT 'Z'
     C     DDNDID        IFEQ      *BLANK
     C     DDDRIF        ANDNE     'Z'
     C                   Move      'N'           DDNDIDOk
     C                   Add       1             Idx
     C                   MoveL     'DDNDID'      FldNamXAr(Idx)
     C                   MoveL     'RE71219'     MsgIDXAr(Idx)
     C                   ENDIF
      *
     C                   ENDIF
      *
     C     DDNDID        IFNE      *BLANK
     C                   CallB     'ZDATE1'
     C                   Parm      DDDACO        DateIn            6
     C                   Parm                    DaynoOut          5 0
     C                   Parm                    BJDFIN
     C                   Parm                    ErrorFlag         1
     C                   Z-Add     DaynoOut      WWDACO            5 0
      *
     C                   CallB     'ZDATE1'
     C                   Parm      DDNDID        DateIn            6
     C                   Parm                    DaynoOut          5 0
     C                   Parm                    BJDFIN
     C                   Parm                    ErrorFlag         1
      *
      ** NEXT DEBIT CAPITALISATION DATE IS WRONG OR LESS THAN RUN DATE
     C     ErrorFlag     IFEQ      'Y'
     C     DaynoOut      ORLT      BJRDNB
     C     CRE090        ANDEQ     'N'                                                        CRE090
     C*****DaynoOut      OREQ      BJRDNB                                                     242793
     C*****WWDACO        ANDEQ     BJRDNB                                                     242793
     C*****BMLDAI        ANDEQ     'Y'                                                        242793
     C                   Move      'N'           DDNDIDOk
     C                   Add       1             Idx
     C                   MoveL     'DDNDID'      FldNamXAr(Idx)
     C                   MoveL     'RE71220'     MsgIDXAr(Idx)
     C                   ENDIF
      *
      ** Must not be equal to date account opened if last day accrual is on.                  242793
      *                                                                                       242793
     C     DaynoOut      IFEQ      BJRDNB                                                     242793
     C     WWDACO        ANDEQ     BJRDNB                                                     242793
     C     BMLDAI        ANDEQ     'Y'                                                        242793
     C                   Move      'N'           DDNDIDOk                                     242793
     C                   Add       1             Idx                                          242793
     C                   MoveL     'DDNDID'      FldNamXAr(Idx)                               242793
     C                   MoveL     'RE71241'     MsgIDXAr(Idx)                                242793
     C                   ENDIF                                                                242793
      *                                                                                       242793
     C     DDNDIDOk      IfEq      'Y'
     C                   Z-Add     DaynoOut      AMNDID
     C                   EndIf
     C                   Else
      *
     C                   Z-Add     *Zeros        AMNDID
     C                   ENDIF
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *  SrVDNCD - Validate Next Capitalistion Day No.                *
      *****************************************************************
     C     SRVDNCD       BEGSR
      *
     C     DDDRIF        IFEQ      'M'
     C     DDDRIF        OREQ      'T'
     C     DDDRIF        OREQ      'Q'
     C     DDDRIF        OREQ      'X'
     C     DDDRIF        OREQ      'Y'
      *
     C     DDDNCD        IFNE      *BLANKS
     C     DDDNCD        ANDNE     '00'
     C                   MOVE      DDDNCD        @DNCD             2 0
      *
     C     @DNCD         IFLT      1
     C     @DNCD         ORGT      31
     C                   Move      'N'           DDDNCDOk
     C                   Add       1             Idx
     C                   MoveL     'DDDNCD'      FldNamXAr(Idx)
     C                   MoveL     'RE71853'     MsgIDXAr(Idx)
     C                   Else
     C                   Z-Add     @DNCD         AMDRDY
     C                   ENDIF
      *
     C                   Else
     C     DDNDIDOk      IfEq      'Y'
     C     BJDFIN        IfEq      'D'
     C                   MoveL     DDNDID        WDAY              2
     C                   Else
     C                   Eval      WDAY = %Subst(DDNDID:3)
     C                   EndIf
     C                   Move      WDAY          AMDRDY
     C                   ENDIF
     C                   ENDIF
      *
     C                   ELSE
      *
     C     DDDNCD        IFNE      *BLANKS
     C     DDDNCD        ANDNE     '00'
     C                   Move      'N'           DDDNCDOk
     C                   Add       1             Idx
     C                   MoveL     'DDDNCD'      FldNamXAr(Idx)
     C                   MoveL     'RE71854'     MsgIDXAr(Idx)
     C                   Else
     C                   Z-Add     *Zero         AMDRDY
     C                   ENDIF
      *
     C                   ENDIF
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
      ** INPUTS
      *
      ** Return Code
     C                   Parm                    RetCodeIn
      *
      ** Account Screen fields
     C                   Parm                    DDNDID            6
     C                   Parm                    DDDRIF            1
     C                   Parm                    DDDNCD            2
     C                   Parm                    DDDRIB            2
     C                   Parm                    DDDRIS           12
     C                   Parm                    DDDSIG            1
     C                   Parm                    DDDICT            2
     C                   Parm                    DDDCST            5
     C                   Parm                    DDDACO            6
      *
      ** ICD
     C                   Parm                    BJRDNB            5 0
     C                   Parm                    BJDFIN            1
     C                   Parm                    BMLDAI            1
     C                   PARM                    CRE090                                       CRE090
      *
      ** OUTPUTS
      *
      * Error fields/message IDs/message data (arrays) from/to caller
     C                   Parm                    FldNamXAr
     C                   Parm                    MsgIDXAr
     C                   Parm                    MsgDtaXAr
      *
     C                   Parm                    AMNDID            5 0
     C                   Parm                    AMDRDY            2 0
      *
      ** Next Capitalisation Date - Ok
      ** Next Capitalisation Freq - Ok
      ** Next Capitalisation Day  - Ok
     C                   Parm                    DDNDIDOk          1
     C                   Parm                    DDDRIFOk          1
     C                   Parm                    DDDNCDOk          1
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
(c) Misys International Banking Systems Ltd. 2001
** FREQ - ARRAY FOR DEBIT CAPITALISATION FREQUENCY VALIDATION
ABDFLMQRSTWXYZ
