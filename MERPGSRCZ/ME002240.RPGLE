     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas ME Network Account Desc.- Key Validation')       *
      *****************************************************************
      *                                                               *
      *  Midas - Messages Generation Module                           *
      *                                                               *
      *  RPGLE/ME002240 - Midas ME Network Account Description Maint. *
      *                   (Key Screen Validation)                     *
      *                                                               *
      *  Function:  This module validates the key fields of a Network *
      *             Accoutn record.                                   *
      *             Note that this module should only be called for   *
      *             "Insert".                                         *
      *                                                               *
      *  (c) Finastra International Limited 2002                      *
      *                                                               *
      *  Last Amend No. CMG008             Date 20Feb20               *
      *  Prev Amend No. MD046248           Date 27Oct17               *
      *                 CRE075             Date 06Dec10               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CSD027             Date 09Dec05               *
      *                 CLE025             Date 20Oct03               *
      *                 CGL029             Date 01Sep03               *
      *                 CGL013  *CREATE    Date 25Apr02               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CMG008 - MT940, MT941, MT942, MT950 Translation Table.       *
      *           (Recompile)                                         *
      *  MD046248 - Finastra Rebranding                               *
      *  CRE075 - Effective Date for Retail Accounts (Recompile)      *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CLE025 - Credit Lines (Recompile)                            *
      *  CGL029 - Increase Account Code to 10 digits                  *
      *  CGL013 - MT94x Message Generation                            *
      *                                                               *
      *****************************************************************

     FGLNWACL1  IF   E           K DISK    INFSR(*PSSR)
     F                                     RENAME(GLNWACD0:GLNWACD1)
      ** Midas GL Network Accounts
      *
      *****************************************************************
      *                                                               *
      * Use of Indicators                                             *
      *                                                               *
      * Error Indicators                                              *
      *                                                               *
      * 40 - General Error Indicator                                  *
      * 41 - Network Id.                                              *
      * 42 - Branch Code                                              *
      * 43 - Customer Number                                          *
      * 44 - Currency Code                                            *
      * 45 - Account Code                                             *
      * 46 - Account Sequence                                         *
      * 47 - Retail Account Number                                    *
      * 48 - Network Account Type                                     *
      * (The DS IN40_TO_70 is used to cover the whole set of reserved *
      *  error indicators)                                            *
      *                                                               *
      * Database Error Indicators                                     *
      *                                                               *
      * U7 - Abnormal Completion                                      *
      * U8 - File Out of Balance                                      *
      * U7 + U8 - Database Error                                      *
      *                                                               *
      * Other Indicators                                              *
      *                                                               *
      * 99 - Multi-purpose                                            *
      *                                                               *
      *****************************************************************

      ** Automatically included D-specs
      ** ==============================
      *

      ** The following /COPY line includes the LDA layout,
      ** the copyright array definition,
      ** and the following named constants:
      **    True       logical = *on (for indcator processing)
      **    False      logical = *off (for indcator processing)
      **    DBErrCtl   10A     = 'DBERRCTL' (the name of the database error
      **                                    handler)
      ** and the following variables:
      **    RunBefore  1A (for the PSSR)
      *
     D/COPY ZACPYSRC,STD_D_SPEC

      ** The following /COPY line includes all the defined fields in the
      ** PSDS.  They have meaningful names, prefixed by 'PS'.
      *
     D/COPY ZACPYSRC,PSDS

      ** Manually included D-specs
      ** =========================
      *

      ** Named constants
      ** ---------------
      *

      ** Arrays and Data Structures
      ** --------------------------
      *

     D NewFilRcd     E DS                  EXTNAME(GLNWACPD)
      ** New Network Account File Record (i.e. new state after amendments)
      *

     D ScrLayout     E DS                  EXTNAME(ME002220DF:ME002220F0)
      ** Key Screen Layout
      *

     D DsNWRK        E DS                  EXTNAME(SDNWRKPD)
      ** Network details record format data structure
      *

     D DsACCNT       E DS                  EXTNAME(ACCNTAB) PREFIX(AC_)
      ** Account details record format data structure
      *

     D DSSDY         E DS                  EXTNAME(DSSDY)
      ** DS (long) used as output parameter for Access Objects
      *

     D DSLDY         E DS                  EXTNAME(DSLDY)
      ** DS (longest) used as output parameter for Access Objects
      *

      ** Ds's used to compare two GL accounts
      *
     D ScrAccount      DS
     D  ScrBRCH                            LIKE(F0BRCH)
     D  ScrCNUM                            LIKE(F0CNUM)
     D  ScrCCY                             LIKE(F0CCY)
     D  ScrACOD                            LIKE(F0ACOD)
     D  ScrACSQ                            LIKE(F0ACSQ)

     D FilAccount      DS
     D  FilBRCA                            LIKE(AC_BRCA)
     D  FilCNUM                            LIKE(AC_CNUM)
     D  FilCCY                             LIKE(AC_CCY)
     D  FilACOD                            LIKE(AC_ACOD)
     D  FilACSQ                            LIKE(AC_ACSQ)

      ** Declared variables
      ** ------------------
      *

      ** Key fields
      *
     D KWCNUM          S                   LIKE(NACNUM)
     D KWACOD          S                   LIKE(NAACOD)
     D KWACSQ          S                   LIKE(NAACSQ)

      ** Error Indicators Array
      *
     D IN40_TO_70      S              1    DIM(31)

     D PACCD           S             10A                                                      CGL029
                                                                                              CGL029
      *------------------------------------------------------------------------*
      ** C Spec. Declaratives
      ** ====================
      *

      ** Entry Parameters
      *
     C     *ENTRY        PLIST
     C                   PARM                    RetCodeOut
     C                   PARM                    ActionCode
     C                   PARM                    CallerIn         10
     C                   PARM                    ScrLayout
     C                   PARM                    IN40_TO_70
     C                   PARM                    NewFilRcd

      ** Key lists
      *
     C     KGLNWACL1     KLIST
     C                   KFLD                    F0NWRK
     C                   KFLD                    F0BRCH
     C                   KFLD                    KWCNUM
     C                   KFLD                    F0CCY
     C                   KFLD                    KWACOD
     C                   KFLD                    KWACSQ
     C                   KFLD                    F0NATY

      *========================================================================*
      *              M  A  I  N     P  R  O  C  E  S  S  I  N  G               *
      *========================================================================*

      ** Init processing uses the standard *INZSR SR

      *------------------------------------------------------------------------*
      *                         Key Fields Validation                          *
      *------------------------------------------------------------------------*

      ** Network Id.
      *
      ** -- Field is Mandatory
      *
 B1  C                   IF        F0NWRK = *Blanks
     C                   MOVE      'ME00034'     ZAMSID
     C                   MOVE      *On           *IN41
 X1  C                   ELSE

      ** -- If the field contains a question mark in its first position,
      **    the screen should be redisplayed for user's control
      *
     C                   IF        %Scan('?':F0NWRK:1) = 1
     C                   EVAL      *IN40 = *On
     C                   ENDIF

      ** -- The field must contain a live network id.
      *
     C                   CALLB     'AONWRKR1'
     C                   PARM      *Blanks       @RtCd
     C                   PARM      '*KEY'        @Optn
     C                   PARM      F0NWRK        @NWRK             6
     C     DsNWRK        PARM                    DSLDY

 B2  C                   IF        @RtCd <> *Blanks OR EDTYLC = 'D'
     C                   MOVE      'ME00035'     ZAMSID
     C                   MOVE      *On           *IN41
 X2  C                   ELSE
     C                   EVAL      F0NWRK = EDNWRK
 E2  C                   ENDIF

 E1  C                   ENDIF

      ** -- If an error was found
      *
     C                   IF        *IN41
     C                   EXSR      $ZaSndMsg
     C                   MOVE      *On           *IN40
     C                   MOVEL(P)  '*MSG'        RetCodeOut
     C                   ENDIF
      *
      ** End Network Id.

      ** GL Account Number
      *
     C                   EVAL      ScrBRCH = F0BRCH
     C                   EVAL      ScrCNUM = F0CNUM
     C                   EVAL      ScrCCY  = F0CCY
     C                   EVAL      ScrACOD = F0ACOD
     C                   EVAL      ScrACSQ = F0ACSQ

      ** -- Must be an existing live GL account if specified
      *
 B1  C                   IF        ScrAccount <> *Blanks

     C                   CALLB     'AOACCTR0'
     C                   PARM      *Blanks       @RtCd
     C                   PARM      '*KEY'        @Optn
     C                   PARM      *Blanks       @RETL            10
     C                   PARM      F0CNUM        @CNUM             6
     C                   PARM      F0CCY         @CUCD             3
     C**********         PARM      F0ACOD        @ACCD             4                          CGL029
     C                   PARM      F0ACOD        PACCD                                        CGL029
     C                   PARM      F0ACSQ        @ACSQ             2
     C                   PARM      F0BRCH        @BRCA             3
     C     DsACCNT       PARM                    DSSDY

 B2  C                   IF        @RtCd <> *Blanks OR AC_RECI <> 'D'
     C                   MOVE      'ME00036'     ZAMSID
     C                   MOVE      *On           *IN42
     C                   MOVE      *On           *IN43
     C                   MOVE      *On           *IN44
     C                   MOVE      *On           *IN45
     C                   MOVE      *On           *IN46
 X2  C                   ELSE

      ** -- If the GL Account is OK and the Retail Number should be shown,
      **    fill it in and force screen re-display
      *
 B3  C                   IF        AC_ACNO <> 0 AND F0ACNO = *Blanks
     C                   MOVEL     AC_ACNO       F0ACNO
     C                   MOVE      *On           *IN40
 E3  C                   ENDIF

 E2  C                   ENDIF

      ** -- Otherwise, the Retail Account Number must be filled in
      *
 X1  C                   ELSE

 B2  C                   IF        F0ACNO = *Blanks
     C                   MOVE      'ME00037'     ZAMSID
     C                   MOVE      *On           *IN42
     C                   MOVE      *On           *IN43
     C                   MOVE      *On           *IN44
     C                   MOVE      *On           *IN45
     C                   MOVE      *On           *IN46
     C                   MOVE      *On           *IN47
 E2  C                   ENDIF

 E1  C                   ENDIF

      ** -- If an error was found
      *
     C                   IF        *IN42
     C                   EXSR      $ZaSndMsg
     C                   MOVE      *On           *IN40
     C                   MOVEL(P)  '*MSG'        RetCodeOut
     C                   ENDIF
      *
      ** End GL Account Number

      ** Retail Account Number
      *
      ** -- If specified, must refer to a live GL account number
      *
 B1  C                   IF        F0ACNO <> *Blanks
     C                   CALLB     'AOACCTR0'
     C                   PARM      *Blanks       @RtCd
     C                   PARM      '*KEY'        @Optn
     C                   PARM      F0ACNO        @RETL            10
     C                   PARM      *Blanks       @CNUM             6
     C                   PARM      *Blanks       @CUCD             3
     C**********         PARM      *Blanks       @ACCD             4                          CGL029
     C                   PARM      *BLANKS       PACCD                                        CGL029
     C                   PARM      *Blanks       @ACSQ             2
     C                   PARM      *Blanks       @BRCA             3
     C     DsACCNT       PARM                    DSSDY

 B2  C                   IF        @RtCd <> *Blanks OR AC_RECI <> 'D'
     C                   MOVE      'ME00038'     ZAMSID
     C                   MOVE      *On           *IN47
 X2  C                   ELSE
     C                   EVAL      FilBRCA = AC_BRCA
     C                   EVAL      FilCNUM = AC_CNUM
     C                   EVAL      FilCCY  = AC_CCY
     C                   EVAL      FilACOD = AC_ACOD
     C                   EVAL      FilACSQ = AC_ACSQ

      ** -- If the Retail Number is OK and the GL account should be shown,
      **    fill it in and force the screen re-display
      *
 B3  C                   IF        ScrAccount = *Blanks
     C                   MOVEL     AC_BRCA       F0BRCH
     C                   MOVEL     AC_CNUM       F0CNUM
     C                   MOVEL     AC_CCY        F0CCY
     C                   MOVEL     AC_ACOD       F0ACOD
     C                   MOVEL     AC_ACSQ       F0ACSQ
     C                   MOVEL     FilAccount    ScrAccount
     C                   MOVE      *On           *IN40
 E3  C                   ENDIF

      ** -- The GL Account refered to should be the same as the one specified
      **    in the fields "GL Account"
      *
 B3  C                   IF        FilAccount <> ScrAccount
     C                   MOVE      'ME00039'     ZAMSID
     C                   MOVE      *On           *IN47
 E3  C                   ENDIF

 E2  C                   ENDIF

 E1  C                   ENDIF

      ** -- If an error was found
      *
     C                   IF        *IN47
     C                   EXSR      $ZaSndMsg
     C                   MOVE      *On           *IN40
     C                   MOVEL(P)  '*MSG'        RetCodeOut
     C                   ENDIF
      *
      ** End Retail Account Number

      ** Network Account Type
      *
      ** -- The Field is mandatory
      *
 B1  C                   IF        F0NATY = *Blanks
     C                   MOVE      'ME00034'     ZAMSID
     C                   MOVE      *On           *IN48

      ** -- The valid values are 'S' and 'G'
      *
 X1  C                   ELSE

 B2  C                   IF        F0NATY <> 'S' AND F0NATY <> 'G'
     C                   MOVE      'ME00040'     ZAMSID
     C                   MOVE      *On           *IN48
 E2  C                   ENDIF

 E1  C                   ENDIF

      ** -- If an error was found
      *
     C                   IF        *IN48
     C                   EXSR      $ZaSndMsg
     C                   MOVE      *On           *IN40
     C                   MOVEL(P)  '*MSG'        RetCodeOut
     C                   ENDIF
      *
      ** End Network Account Type

      ** End the module if any error encountered
      *
     C   40              EXSR      $ExitMod

      *------------------------------------------------------------------------*
      *                  Database Keys Consistency Validation                  *
      *------------------------------------------------------------------------*

      ** Check if the key already exists in the database
      *
     C                   MOVEL     F0CNUM        KWCNUM
     C                   MOVEL     F0ACOD        KWACOD
     C                   MOVEL     F0ACSQ        KWACSQ
     C     KGLNWACL1     CHAIN     GLNWACD1                           99

      ** -- The record already exists ==> error if it is not deleted,
      **                    otherwise change the Action Code to Amend
      *
 B1  C                   IF        NOT *IN99
      *
 B2  C                   IF        NARECI = 'D'
     C                   MOVE      'ME00041'     ZAMSID
     C                   EXSR      $ZaSndMsg
     C                   MOVEL(P)  '*MSG'        RetCodeOut
     C                   MOVE      *On           *IN40
     C                   MOVE      *On           *IN41
     C                   MOVE      *On           *IN42
     C                   MOVE      *On           *IN43
     C                   MOVE      *On           *IN44
     C                   MOVE      *On           *IN45
     C                   MOVE      *On           *IN46
     C                   MOVE      *On           *IN48
 X2  C                   ELSE
     C                   EVAL      ActionCode = 'A'
 E2  C                   ENDIF
      *
 E1  C                   ENDIF

      ** End of the module
      *
     C                   EXSR      $ExitMod

      *========================================================================*
      *                    S  U  B  R  O  U  T  I  N  E  S                     *
      *========================================================================*

      *========================================================================*
      * $ZaSndMsg : Send message to the program message queue                  *
      *------------------------------------------------------------------------*
     C     $ZaSndMsg     BEGSR
      *    ----------    ------

     C                   CALL      'Y2SNMGC'
     C                   PARM                    ZAPGM
     C                   PARM                    ZAPGRL
     C                   PARM                    ZAMSID
     C                   PARM                    ZAMSGF
     C                   PARM                    ZAMSDA
     C                   PARM                    ZAMSTP
      *    ----------    ------
     C     @ZaSndMsg     ENDSR

      *========================================================================*
      * $ExitMod  : Exit from the module                                       *
      *------------------------------------------------------------------------*
     C     $ExitMod      BEGSR
      *    ----------    ------
      ** Return the current values of the error indicators
      *
     C                   MOVEA     *IN(40)       IN40_TO_70

     C                   MOVE      *On           *INLR
     C                   RETURN
      *    ----------    ------
     C     @ExitMod      ENDSR

      *========================================================================*
      * *INZSR    : Init Processing                                            *
      *========================================================================*
     C     *INZSR        BEGSR
      *    ----------    ------
      ** Initialise Copyright Array
      *
     C                   MOVEA     CPY@          CPY@@            80

      ** Define fields used by the message sending function
      *
      ** -- If no named caller --> set-up ZAPGM with the current program name
      *
     C                   IF        CallerIn = *Blanks
     C                   MOVEL     PSProcPgm     ZAPGM            10

      ** -- Otherwise set-up ZAPGM with the caller name
      *
     C                   ELSE
     C                   MOVEL     CallerIn      ZAPGM
     C                   ENDIF

     C                   MOVEL     'MEMSG'       ZAMSGF           10
     C                   MOVEL     '*SAME'       ZAPGRL            5
     C                   MOVEL     *Blanks       ZAMSID            7
     C                   MOVEL     *Blanks       ZAMSDA          132
     C                   MOVEL     *Blanks       ZAMSTP            7

      ** Initialize error indicators with the values passed by the caller
      *
     C                   MOVEA     IN40_TO_70    *IN(40)

      ** Reset general error indicator
      *
     C                   MOVE      *OFF          *IN40

      ** Clear the return code
      *
     C                   EVAL      RetCodeOut = *Blanks
      *    ----------    ------
     C     @INZSR        ENDSR

      *========================================================================*
      * *PSSR     : Program exception error subroutine                         *
      *------------------------------------------------------------------------*
     C     *PSSR         BEGSR
      *    ----------    ------
     C                   DUMP

     C                   EVAL      *INU7 = *On
     C                   EVAL      *INU8 = *On

     C                   CALLB     'DBERRCTL'                           99

     C                   MOVEL(P)  '*ERROR'      RetCodeOut
     C                   EXSR      $ExitMod
      *    ----------    ------
     C     @PSSR         ENDSR

      *========================================================================*
**  CPY@
(c) Finastra International Limited 2002
