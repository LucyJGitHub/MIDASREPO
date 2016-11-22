     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas ME Network A/c MT94x Dtl Desc.- Dtl 1 Valid°')   *
      *****************************************************************
      *                                                               *
      *  Midas - Messages Generation Module                           *
      *                                                               *
      *  RPGLE/ME002341 - Midas ME Network Account MT94x Details      *
      *                   Description Maintenance                     *
      *                   (Details 1 Screen Validation - Destination) *
      *                                                               *
      *  Function:  This module validates the fields of the fisrt dtl *
      *             screen of a Network Account MT94x Details record. *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2002            *
      *                                                               *
      *  Last Amend No. CGL178             Date 04Aug16               *
      *  Prev Amend No. CER059             Date 19Jul10               *
      *                 BUG22481           Date 02Feb09               *
      *                 CER030             Date 09Jul08               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CSD027             Date 09Dec05               *
      *                 CGL029             Date 01Sep03               *
      *                 CGL013  *CREATE    Date 25Apr02               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CGL178 - Generate MT942 based on MT950.                      *
      *  CER059 - German Feature Upgrade to Delhi                     *
      *  BUG22481 - Field 86 Structure validation field not available *
      *             during Enquire and Amend                          *
      *  CER030 - Multicash German Feature (Recompile)                *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CGL029 - Increase Account Code to 10 digits (Recompile)      *
      *  CGL013 - MT94x Message Generation                            *
      *                                                               *
      *****************************************************************

      *****************************************************************
      *                                                               *
      * Use of Indicators                                             *
      *                                                               *
      * Error Indicators                                              *
      *                                                               *
      * 40 - General Error Indicator                                  *
      * 41 - Destination Description                                  *
      * 42 - Generates MT940                                          *
      * 43 - Generates MT941                                          *
      * 44 - Generates MT942                                          *
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

     FGLGS94L1  IF   E           K DISK    INFSR(*PSSR)
     F                                     RENAME(GLGS94D0:GLGS94D1)
      ** Midas GL MT941/942 Generation Schedules - Retrieve
      *
     FGLNW94L11 IF   E           K DISK    INFSR(*PSSR)                                     BUG22481
     F                                     RENAME(GLNW94D0:GLNW94D2)                        BUG22481
     F                                     PREFIX(M)                                        BUG22481

     FGLNWACL1  IF   E           K DISK    INFSR(*PSSR)                                       CGL178
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

     D NewFilRcd     E DS                  EXTNAME(GLNW94PD)
      ** New Network Account MT94x Details File Record (i.e. new state after amendments)
      *

     D ScrLayout     E DS                  EXTNAME(ME002321DF:ME002321F1)
      ** Detail 1 Screen Layout
      *
     D DsNWRK        E DS                  EXTNAME(SDNWRKPD)                                BUG22481
      *                                                                                     BUG22481
      ** Network details record format data structure                                       BUG22481
      *                                                                                     BUG22481
     D DSLDY         E DS                  EXTNAME(DSLDY)                                   BUG22481
      *                                                                                     BUG22481
      ** DS (longest) used as output parameter for Access Objects                           BUG22481
      *                                                                                     BUG22481

      ** Declared variables
      ** ------------------
      *

      ** Error Indicators Array
      *
     D IN40_TO_70      S              1    DIM(31)
      *                                                                                     BUG22481
     D POptn           S              7A                                                    BUG22481
     D PRtcd           S              7A                                                    BUG22481
     D PNwrk           S              6A                                                    BUG22481

      *------------------------------------------------------------------------*
      ** C Spec. Declaratives
      ** ====================
      *

      ** Entry Parameters
      *
     C     *ENTRY        PLIST
     C                   PARM                    RetCodeOut
     C                   PARM                    CallerIn         10
     C                   PARM                    ScrLayout
     C                   PARM                    IN40_TO_70
     C                   PARM                    NewFilRcd

      ** Key lists
      *
     C     KGLGS94L1     KLIST
     C                   KFLD                    N4NWRK
     C                   KFLD                    N4BRCA
     C                   KFLD                    N4CNUM
     C                   KFLD                    N4CCY
     C                   KFLD                    N4ACCD
     C                   KFLD                    N4ACSQ
     C                   KFLD                    N4NATY
     C                   KFLD                    N4DSTN
     C                   KFLD                    GSMTPY
      *                                                                                     BUG22481
     C     KGLNW94L11    KLIST                                                              BUG22481
     C                   KFLD                    N4BRCA                                     BUG22481
     C                   KFLD                    N4CNUM                                     BUG22481
     C                   KFLD                    N4CCY                                      BUG22481
     C                   KFLD                    N4ACCD                                     BUG22481
     C                   KFLD                    N4ACSQ                                     BUG22481

     C     KG950         KLIST                                                                CGL178
     C                   KFLD                    N4NWRK                                       CGL178
     C                   KFLD                    N4BRCA                                       CGL178
     C                   KFLD                    N4CNUM                                       CGL178
     C                   KFLD                    N4CCY                                        CGL178
     C                   KFLD                    N4ACCD                                       CGL178
     C                   KFLD                    N4ACSQ                                       CGL178
     C                   KFLD                    N4NATY                                       CGL178
                                                                                              CGL178
      *========================================================================*
      *              M  A  I  N     P  R  O  C  E  S  S  I  N  G               *
      *========================================================================*

      ** Init processing uses the standard *INZSR subroutine

      *------------------------------------------------------------------------*
      *                      Details 1 Fields Validation                       *
      *------------------------------------------------------------------------*

      ** Destination Description
      *
      ** -- The field is mandatory
      *
 B1  C                   IF        F1DSTD = *Blanks
     C                   MOVE      'ME00034'     ZAMSID
     C                   EXSR      $ZaSndMsg
     C                   MOVE      *On           *IN41
     C                   MOVE      *On           *IN40
     C                   MOVEL(P)  '*MSG'        RetCodeOut
 E1  C                   ENDIF
      *
      ** End Destination Description

      *                                                                                     BUG22481
      ** Default for Field 86 structure validation                                          BUG22481
      *                                                                                     BUG22481
     C                   IF        F1SV86 = *BLANKS                                         BUG22481
     C                   EVAL      ZAMSID = 'ME00034'                                       BUG22481
     C                   EVAL      *IN45 = *ON                                              BUG22481
      *                                                                                     BUG22481
     C                   ELSEIF    F1SV86 <> 'Y' AND F1SV86 <> 'N'                          BUG22481
     C                   EVAL      ZAMSID = 'ME00202'                                       BUG22481
     C                   EVAL      *IN45 = *ON                                              BUG22481
      *                                                                                     BUG22481
     C                   ELSEIF    EDENRA = 'N' AND F1SV86 = 'Y'                            BUG22481
     C                   EVAL      ZAMSID = 'ME00201'                                       BUG22481
     C                   EVAL      *IN45 = *ON                                              BUG22481
      *                                                                                     BUG22481
     C                   ELSEIF    F1SV86 = 'Y'                                             BUG22481
     C                   EVAL      MN4NWRK = *BLANKS                                        BUG22481
     C     KGLNW94L11    CHAIN     GLNW94L11                                                BUG22481
      *                                                                                     BUG22481
     C                   IF        %FOUND (GLNW94L11)                                       BUG22481
     C                             AND MN4NWRK <> N4NWRK                                    BUG22481
     C                   EVAL      ZAMSID = 'ME00204'                                       BUG22481
     C                   EVAL      *IN45 = *ON                                              BUG22481
     C                   ENDIF                                                              BUG22481
      *                                                                                     BUG22481
     C                   ENDIF                                                              BUG22481
      *                                                                                     BUG22481
      ** If an error was found                                                              BUG22481
      *                                                                                     BUG22481
     C                   IF        *IN45                                                    BUG22481
     C                   EXSR      $ZaSndMsg                                                BUG22481
     C                   MOVE      *On           *IN40                                      BUG22481
     C                   MOVEL(P)  '*MSG'        RetCodeOut                                 BUG22481
     C                   ENDIF                                                              BUG22481
      *                                                                                     BUG22481
      ** Generates MT940
      *
      ** -- The field is mandatory
      *
 B1  C                   IF        F1G940 = *Blanks
     C                   MOVE      'ME00034'     ZAMSID
     C                   MOVE      *On           *IN42
      *
      ** -- The valid values are 'Y' and 'N'
      *
 X1  C                   ELSE
      *
 B2  C                   IF        F1G940 <> 'Y' AND F1G940 <> 'N'
     C                   MOVE      'ME00042'     ZAMSID
     C                   MOVE      *On           *IN42
 E2  C                   ENDIF
      *
      ** -- The value can't be 'N' if the destination allows MT941 or MT942
      *
      ** unless feature CGL178 is on                                                          CGL178
     C                   IF        CGL178 = 'N'                                               CGL178
 B2  C                   IF        F1G940 = 'N' AND
     C                             (F1G941 = 'Y' OR F1G942 = 'Y')
     C                   MOVE      'ME00062'     ZAMSID
     C                   MOVE      *On           *IN42
 E2  C                   ENDIF
     C                   ENDIF                                                                CGL178

      *
 E1  C                   ENDIF
      *
      ** -- If an error was found
      *
     C                   IF        *IN42
     C                   EXSR      $ZaSndMsg
     C                   MOVE      *On           *IN40
     C                   MOVEL(P)  '*MSG'        RetCodeOut
     C                   ENDIF
      *
      ** End Generates MT940

      ** Generates MT941
      *
      ** -- The field is mandatory
      *
 B1  C                   IF        F1G941 = *Blanks
     C                   MOVE      'ME00034'     ZAMSID
     C                   MOVE      *On           *IN43
      *
      ** -- The valid values are 'Y' and 'N'
      *
 X1  C                   ELSE
      *
 B2  C                   IF        F1G941 <> 'Y' AND F1G941 <> 'N'
     C                   MOVE      'ME00042'     ZAMSID
     C                   MOVE      *On           *IN43
 E2  C                   ENDIF
      *
      ** -- The field can't be 'N' if there is at least one linked
      **    generation schedule
      *
 B2  C                   IF        F1G941 = 'N'
     C                   EVAL      GSMTPY = '941'
     C     KGLGS94L1     SETLL     GLGS94D1                               99
     C   99              MOVE      'ME00063'     ZAMSID
     C   99              MOVE      *On           *IN43
 E2  C                   ENDIF
      *
      ** if CGL178 is on and MT940 is not to be generated, ensure MT950 is to be generated    CGL178
     C                   IF        CGL178 = 'Y' and                                           CGL178
     C                             F1G941 = 'Y' and F1G940 ='N'                               CGL178
     C     KG950         CHAIN     GLNWACL1                                                   CGL178
     C                   IF        NAG950 = 'N'                                               CGL178
     C                   MOVE      'ME00999'     ZAMSID                                       CGL178
     C                   MOVE      *On           *IN43                                        CGL178
     C                   ENDIF                                                                CGL178
     C                   ENDIF                                                                CGL178
                                                                                              CGL178
 E1  C                   ENDIF
      *
      ** -- If an error was found
      *
     C                   IF        *IN43
     C                   EXSR      $ZaSndMsg
     C                   MOVE      *On           *IN40
     C                   MOVEL(P)  '*MSG'        RetCodeOut
     C                   ENDIF
      *
      ** End Generates MT941

      ** Generates MT942
      *
      ** -- The field is mandatory
      *
 B1  C                   IF        F1G942 = *Blanks
     C                   MOVE      'ME00034'     ZAMSID
     C                   MOVE      *On           *IN44
      *
      ** -- The valid values are 'Y' and 'N'
      *
 X1  C                   ELSE
      *
 B2  C                   IF        F1G942 <> 'Y' AND F1G942 <> 'N'
     C                   MOVE      'ME00042'     ZAMSID
     C                   MOVE      *On           *IN44
 E2  C                   ENDIF
      *
      ** -- The field can't be 'N' if there is at least one linked
      **    generation schedule
      *
 B2  C                   IF        F1G942 = 'N'
     C                   EVAL      GSMTPY = '942'
     C     KGLGS94L1     SETLL     GLGS94D1                               99
     C   99              MOVE      'ME00064'     ZAMSID
     C   99              MOVE      *On           *IN44
 E2  C                   ENDIF
      *
      ** if CGL178 is on and MT940 is not to be generated, ensure MT950 is to be generated    CGL178
     C                   IF        CGL178 = 'Y' and                                           CGL178
     C                             F1G942 = 'Y' and F1G940 ='N'                               CGL178
     C     KG950         CHAIN     GLNWACL1                                                   CGL178
     C                   IF        NAG950 = 'N'                                               CGL178
     C                   MOVE      'ME00999'     ZAMSID                                       CGL178
     C                   MOVE      *On           *IN44                                        CGL178
     C                   ENDIF                                                                CGL178
     C                   ENDIF                                                                CGL178
                                                                                              CGL178
 E1  C                   ENDIF
      *
      ** -- If an error was found
      *
     C                   IF        *IN44
     C                   EXSR      $ZaSndMsg
     C                   MOVE      *On           *IN40
     C                   MOVEL(P)  '*MSG'        RetCodeOut
     C                   ENDIF
      *
      ** End Generates MT942

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
      *                                                                                     BUG22481
      ** Retrieve the associated network record                                             BUG22481
      *                                                                                     BUG22481
     C                   CALLB     'AONWRKR1'                                               BUG22481
     C                   PARM      *Blanks       PRtCd                                      BUG22481
     C                   PARM      '*KEY'        POptn                                      BUG22481
     C                   PARM      N4NWRK        PNwrk                                      BUG22481
     C     DsNWRK        PARM                    DSLDY                                      BUG22481
      *                                                                                     BUG22481
     C                   IF        PRtCd <> *BLANKS                                         BUG22481
     C     *LOCK         IN        LDA                                                      BUG22481
     C                   EVAL      DBFile = 'SDNWRKPD'                                      BUG22481
     C                   EVAL      DBKey  = N4NWRK                                          BUG22481
     C                   EVAL      DBPgm  = ZAPGM                                           BUG22481
     C                   EVAL      DBase  = 001                                             BUG22481
     C                   EVAL      DBMod  = PSProcMod                                       BUG22481
     C                   EVAL      DBProc = PSProcName                                      BUG22481
     C                   OUT       LDA                                                      BUG22481
     C                   EXSR      *PSSR                                                    BUG22481
     C                   ENDIF                                                              BUG22481
                                                                                              CGL178
      ** Check if CGL178 is installed                                                         CGL178
      *                                                                                       CGL178
     C                   MOVEL     'N'           CGL178            1                          CGL178
     C                   CALLB     'AOSARDR0'                                                 CGL178
     C                   PARM      *BLANKS       PRtCd                                        CGL178
     C                   PARM      '*VERIFY'     POptn                                        CGL178
     C                   PARM      'CGL178'      @SARD                                        CGL178
                                                                                              CGL178
     C                   IF        PRtCd = *BLANKS                                            CGL178
     C                   MOVEL     'Y'           CGL178                                       CGL178
     C                   ENDIF                                                                CGL178
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
(c) Misys International Banking Systems Ltd. 2002
