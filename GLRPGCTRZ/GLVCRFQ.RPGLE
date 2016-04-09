     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2001')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas GL Validate Credit Next Cap. Date, Freq, Day')   *
      *****************************************************************
      *                                                               *
      *  Midas - General Ledger Module                                *
      *                                                               *
      *  GLVCRFQ    - Validate Credit Next Capitalisation Date,       *
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
     C                   ExSr      SrVCRIF
      *
     C                   ExSr      SrVNCID
      *
     C                   ExSr      SrVCNCD
      *
      ** If an error was found, set the return code appropriately
      *
     C     DDNCIDOk      IfEq      'N'
     C     DDCRIFOk      OrEq      'N'
     C     DDCNCDOk      OrEq      'N'
     C                   Eval      RetCodeIn = 'Error'
     C                   EndIf
      *
      ** RETURN
      *
     C                   RETURN
      *****************************************************************
      /EJECT
      *****************************************************************
      *  SrVCRIF - Validate Next Capitalistion Frequency              *
      *****************************************************************
     C     SRVCRIF       BEGSR
      *
      ** If cap. date & freq. are blank and a/c is non-interest bearing,
      ** default it to 'Z'.
     C     DDCRIF        IFEQ      *BLANK
     C     DDNCID        ANDEQ     *BLANK
     C     DDCRIB        ANDEQ     *BLANK
     C     DDCRIS        ANDEQ     *BLANK
     C     DDCSIG        ANDEQ     *BLANK
     C     DDCICT        ANDEQ     *BLANK
     C     DDCCST        ANDEQ     *BLANK
     C                   MOVE      'Z'           DDCRIF
     C                   ENDIF
      *
      ** CREDIT CAPITALISATION FREQUENCY MANDATORY AND MUST BE 'ABDFLMQRSTWXYZ'
     C     DDCRIF        LOOKUP    FREQ                                   80
     C     *IN80         IFEQ      '0'
     C                   Move      'N'           DDCRIFOk
     C                   Add       1             Idx
     C                   MoveL     'DDCRIF'      FldNamXAr(Idx)
     C                   MoveL     'RE71321'     MsgIDXAr(Idx)
     C                   ENDIF
      *
      ** CREDIT CAPITALISATION FREQUENCY MUST BE 'Z' IF NEXT ONE IS BLANK
     C     DDNCID        IFEQ      *BLANK
     C     DDCRIF        ANDNE     'Z'
     C                   Move      'N'           DDCRIFOk
     C                   Add       1             Idx
     C                   MoveL     'DDCRIF'      FldNamXAr(Idx)
     C                   MoveL     'RE71320'     MsgIDXAr(Idx)
     C                   ENDIF
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *  SrVNCID - Validate Next Capitalistion Date                   *
      *****************************************************************
     C     SRVNCID       BEGSR
      *
     C     DDCRIB        IFNE      *BLANK
     C     DDCRIS        ORNE      *BLANK
     C     DDCSIG        ORNE      *BLANK
     C     DDCICT        ORNE      *BLANK
     C     DDCCST        ORNE      *BLANK
      *
      ** ENTRY MANDATORY IF CREDIT CAPITALISATION FREQUENCY IS NOT 'Z'
     C     DDNCID        IFEQ      *BLANK
     C     DDCRIF        ANDNE     'Z'
     C                   Move      'N'           DDNCIDOk
     C                   Add       1             Idx
     C                   MoveL     'DDNCID'      FldNamXAr(Idx)
     C                   MoveL     'RE71317'     MsgIDXAr(Idx)
     C                   ENDIF
      *
     C                   ENDIF
      *
     C     DDNCID        IFNE      *BLANK
     C                   CallB     'ZDATE1'
     C                   Parm      DDDACO        DateIn            6
     C                   Parm                    DaynoOut          5 0
     C                   Parm                    BJDFIN
     C                   Parm                    ErrorFlag         1
     C                   Z-Add     DaynoOut      WWDACO            5 0
      *
     C                   CallB     'ZDATE1'
     C                   Parm      DDNCID        DateIn            6
     C                   Parm                    DaynoOut          5 0
     C                   Parm                    BJDFIN
     C                   Parm                    ErrorFlag         1
      *
      ** NEXT CREDIT CAPITALISATION DATE IS WRONG OR LESS THAN RUN DATE
     C     ErrorFlag     IFEQ      'Y'
     C                   Move      'N'           DDNCIDOk
     C                   Add       1             Idx
     C                   MoveL     'DDNCID'      FldNamXAr(Idx)
     C                   MoveL     'RE71318'     MsgIDXAr(Idx)
     C                   EndIf
      *
      ** Must be greater than or equal to rundate.
     C     DaynoOut      IFLT      BJRDNB
     C     CRE090        ANDEQ     'N'                                                        CRE090
     C*****DaynoOut      OREQ      BJRDNB                                                     242793
     C*****WWDACO        ANDEQ     BJRDNB                                                     242793
     C*****BMLDAI        ANDEQ     'Y'                                                        242793
     C                   Move      'N'           DDNCIDOk
     C                   Add       1             Idx
     C                   MoveL     'DDNCID'      FldNamXAr(Idx)
     C                   MoveL     'RE71319'     MsgIDXAr(Idx)
     C                   ENDIF
      *
      ** Must not be equal to date account opened if last day accrual is on.                  242793
      *                                                                                       242793
     C     DaynoOut      IFEQ      BJRDNB                                                     242793
     C     WWDACO        ANDEQ     BJRDNB                                                     242793
     C     BMLDAI        ANDEQ     'Y'                                                        242793
     C                   Move      'N'           DDNCIDOk                                     242793
     C                   Add       1             Idx                                          242793
     C                   MoveL     'DDNCID'      FldNamXAr(Idx)                               242793
     C                   MoveL     'RE71338'     MsgIDXAr(Idx)                                242793
     C                   ENDIF                                                                242793
      *
     C     DDNCIDOk      IfEq      'Y'
     C                   Z-Add     DaynoOut      AMNCID
     C                   EndIf
     C                   Else
      *
     C                   Z-Add     *Zeros        AMNCID
     C                   ENDIF
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *  SrVCNCD - Validate Next Capitalistion Day No.                *
      *****************************************************************
     C     SRVCNCD       BEGSR
      *
     C     DDCRIF        IFEQ      'M'
     C     DDCRIF        OREQ      'T'
     C     DDCRIF        OREQ      'Q'
     C     DDCRIF        OREQ      'X'
     C     DDCRIF        OREQ      'Y'
      *
     C     DDCNCD        IFNE      *BLANKS
     C     DDCNCD        ANDNE     '00'
     C                   MOVE      DDCNCD        @CNCD             2 0
      *
     C     @CNCD         IFLT      1
     C     @CNCD         ORGT      31
     C                   Move      'N'           DDCNCDOk
     C                   Add       1             Idx
     C                   MoveL     'DDCNCD'      FldNamXAr(Idx)
     C                   MoveL     'RE71853'     MsgIDXAr(Idx)
     C                   Else
     C                   Z-Add     @CNCD         AMCRDY
     C                   ENDIF
      *
     C                   Else
     C     DDNCIDOk      IfEq      'Y'
     C     BJDFIN        IfEq      'D'
     C                   MoveL     DDNCID        WDAY              2
     C                   Else
     C                   Eval      WDAY = %Subst(DDNCID:3)
     C                   EndIf
     C                   Move      WDAY          AMCRDY
     C                   ENDIF
     C                   ENDIF
      *
     C                   ELSE
      *
     C     DDCNCD        IFNE      *BLANKS
     C     DDCNCD        ANDNE     '00'
     C                   Move      'N'           DDCNCDOk
     C                   Add       1             Idx
     C                   MoveL     'DDCNCD'      FldNamXAr(Idx)
     C                   MoveL     'RE71854'     MsgIDXAr(Idx)
     C                   Else
     C                   Z-Add     *Zero         AMCRDY
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
     C                   Parm                    DDNCID            6
     C                   Parm                    DDCRIF            1
     C                   Parm                    DDCNCD            2
     C                   Parm                    DDCRIB            2
     C                   Parm                    DDCRIS           12
     C                   Parm                    DDCSIG            1
     C                   Parm                    DDCICT            2
     C                   Parm                    DDCCST            5
     C                   Parm                    DDDACO            6
      *
      ** ICD
     C                   Parm                    BJRDNB            5 0
     C                   Parm                    BJDFIN            1
     C                   Parm                    BMLDAI            1
     C                   Parm                    CRE090                                       CRE090
      *
      ** OUTPUTS
      *
      * Error fields/message IDs/message data (arrays) from/to caller
     C                   Parm                    FldNamXAr
     C                   Parm                    MsgIDXAr
     C                   Parm                    MsgDtaXAr
      *
     C                   Parm                    AMNCID            5 0
     C                   Parm                    AMCRDY            2 0
      *
      ** Next Capitalisation Date - Ok
      ** Next Capitalisation Freq - Ok
      ** Next Capitalisation Day  - Ok
     C                   Parm                    DDNCIDOk          1
     C                   Parm                    DDCRIFOk          1
     C                   Parm                    DDCNCDOk          1
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
** FREQ - ARRAY FOR CREDIT CAPITALISATION FREQUENCY VALIDATION
ABDFLMQRSTWXYZ
