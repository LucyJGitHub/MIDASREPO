     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas SD Network Description - Details 1 Validat°')    *
      *****************************************************************
      *                                                               *
      *  Midas - Standing Data Module                                 *
      *                                                               *
      *  RPGLE/SD200141 - Midas SD Network Description Maintenance    *
      *                   (Details 1 Screen Validation - Network)     *
      *                                                               *
      *  Function:  This module validates the fields of the first     *
      *             detail screen of a Network record.                *
      *                                                               *
      *  (c) Finastra International Limited 2003                      *
      *                                                               *
      *  Last Amend No. CMG008             Date 20Feb20               *
      *  Prev Amend No. MD046248           Date 27Oct17               *
      *                 CGL178             Date 04Aug16               *
      *                 MD023441           Date 15Nov13               *
      *                 CGL146             Date 10Jul13               *
      *                 CER059             Date 19Jul10               *
      *                 BUG26393           Date 12Oct09               *
      *                 BUG25800           Date 02Sep09               *
      *                 CER030             Date 09Jul08               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CSD027             Date 09Dec05               *
      *                 CGL013  *CREATE    Date 25Mar02               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CMG008 - MT940, MT941, MT942, MT950 Translation Table.
      *  MD046248 - Finastra Rebranding                               *
      *  CGL178 - Generate MT942 based on MT950.                      *
      *  MD023441 - Spurious error message is shown when CGL146       *
      *             is switch off                                     *
      *  CGL146 - MT940/MT950 Production in Input Cycle               *
      *           Added hooks: CGL146_001, CGL146_002, CGL146_003     *
      *  CER059 - German Feature Upgrade to Delhi                     *
      *  BUG26393 - Account Number Format should still be available   *
      *             when CER030 is OFF                                *
      *  BUG25800 - Missing subfield 4 - field 61 of MT940            *
      *             at regression test                                *
      *  CER030 - Multicash German Feature                            *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CGL013 - MT94x Messages Generation                           *
      *                                                               *
      *****************************************************************

     FGLNWACL2  IF   E           K DISK    INFSR(*PSSR)
     F                                     RENAME(GLNWACD0:GLNWACD2)
      ** Midas GL Network Accounts - Live Records Allowing MT950
      *

     FGLNW94L2  IF   E           K DISK    INFSR(*PSSR)
     F                                     RENAME(GLNW94D0:GLNW94D2)
      ** Midas GL Network Accounts - MT94x - Live Records Allowing MT940
      *

     FGLNW94L3  IF   E           K DISK    INFSR(*PSSR)
     F                                     RENAME(GLNW94D0:GLNW94D3)
      ** Midas GL Network Accounts - MT94x - Live Records Allowing MT941
      *

     FGLNW94L4  IF   E           K DISK    INFSR(*PSSR)
     F                                     RENAME(GLNW94D0:GLNW94D4)
      ** Midas GL Network Accounts - MT94x - Live Records Allowing MT942
      *

     FGLNW94L5  IF   E           K DISK    INFSR(*PSSR)
     F                                     RENAME(GLNW94D0:GLNW94D5)
      ** Midas GL Network Accounts - MT94x - Live Network Accounts
      **                                     by Account & Destination
      *

      *========================================================================*
      *                                                                        *
      * Use of Indicators                                                      *
      *                                                                        *
      * Error Indicators                                                       *
      *                                                                        *
      * 40 - General Error Indicator                                           *
      * 41 - Network Description                                               *
      * 42 - Protocol Type                                                     *
      * 43 - Allow MT940 Generation                                            *
      * 44 - Allow MT941 Generation                                            *
      * 45 - Allow MT942 Generation                                            *
      * 46 - Allow MT950 Generation                                            *
      * 48 - Allow Multiple Destinations for MT94x                             *
      * 49 - Allow Extended Narrative                                          *
      * 50 - Retention Period for Schedule Request                             *
      * 51 - Prevent Automatic Submission at Start of Business                 *
      * 52 - Prevent Automatic Submission if Non-Working Day                   *
      * (The DS IN40_TO_70 is used to cover the whole set of reserved error    *
      *  indicators)                                                           *
      *                                                                        *
      * Database Error Indicators                                              *
      *                                                                        *
      * U7 - Abnormal Completion                                               *
      * U8 - File Out of Balance                                               *
      * U7 + U8 - Database Error                                               *
      *                                                                        *
      * Other Indicators                                                       *
      *                                                                        *
      * 99 - Multi-purpose                                                     *
      *                                                                        *
      *========================================================================*

      *========================================================================*
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
     D WDigits         C                   CONST(' 0123456789')                               CER030

      ** Arrays and Data Structures
      ** --------------------------
      *

     D NewFilRcd     E DS                  EXTNAME(SDNWRKPD)
      ** New Network File Record (i.e. new state after amendments)
      *

     D ScrLayout     E DS                  EXTNAME(SD200121DF:SD200121F1)
      ** Detail 1 Screen Layout
      *

      ** Declared variables
      ** ------------------
      *

      ** Error Indicators Array
      *
     D IN40_TO_70      S              1    DIM(31)
      *                                                                                       CER030
      ** Variables for CER030                                                                 CER030
      *                                                                                       CER030
     D PRtcd           S              7A                                                      CER030
     D POptn           S              7A                                                      CER030
     D PSard           S              6A                                                      CER030
     D CFT004          S              1A                                                      CER030
     D CER030          S              1A                                                      CER030
     D WNum            S              2S 0                                                    CER030
     D WTrTp           S              2S 0                                                    CER030
     D CGL178          S              1A                                                      CGL178
     D CMG008          S              1A                                                      CMG008
      *                                                                                       CER030
      ** External DS for SAR Details                                                          CER030
      *                                                                                       CER030
     D SCSARD        E DS                  EXTNAME(SCSARDPD)                                  CER030
      *                                                                                       CER030
      ** Short data structure                                                                 CER030
      *                                                                                       CER030
     D DSFDY         E DS                  EXTNAME(DSFDY)                                     CER030
     D/COPY OFCPYSRCZ,CGL146_001                                                              CGL146

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

      ** Fields Definition
      *
     C     *LIKE         DEFINE    N4BRCA        SvBRCA
     C     *LIKE         DEFINE    N4CNUM        SvCNUM
     C     *LIKE         DEFINE    N4CCY         SvCCY
     C     *LIKE         DEFINE    N4ACCD        SvACCD
     C     *LIKE         DEFINE    N4ACSQ        SvACSQ
     C     *LIKE         DEFINE    N4NATY        SvNATY

      *========================================================================*
      *              M  A  I  N     P  R  O  C  E  S  S  I  N  G               *
      *========================================================================*

      ** Init processing uses the standard *INZSR subroutine

      *------------------------------------------------------------------------*
      *                      Details 1 Fields Validation                       *
      *------------------------------------------------------------------------*

      ** Network Description
      *
      ** -- The Field is mandatory
      *
     C                   IF        F1NETD = *Blanks
     C                   MOVE      'USR3970'     ZAMSID
     C                   EXSR      $ZaSndMsg
     C                   MOVE      *On           *IN40
     C                   MOVE      *On           *IN41
     C                   MOVEL(P)  '*MSG'        RetCodeOut
     C                   ENDIF
      *
      ** End Network Description

      ** Type of Protocol
      *
      ** -- The Field is mandatory
      *
 B1  C                   IF        F1PROT = *Blanks
     C                   MOVE      'USR3970'     ZAMSID
     C                   MOVE      *On           *IN42

      ** -- The protocol must be *SWIFT for a network id. SWIFT, or
      **                         *MDBA, *DA or *FTP for other network Id's
      *
 X1  C                   ELSE

 B2  C                   IF        (EDNWRK = 'SWIFT' AND F1PROT <> '*SWIFT')
     C                                               OR
     C                             (EDNWRK <> 'SWIFT' AND F1PROT <> '*MDBA'
     C                                                AND F1PROT <> '*DA'
     C                                                AND F1PROT <> '*FTP')
     C**********         MOVE      'USR3972'     ZAMSID                                     MD023441
     C                   MOVE      'USR9972'     ZAMSID                                     MD023441
     C                   MOVE      *On           *IN42
     C/COPY OFCPYSRCZ,CGL146_003                                                              CGL146
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
      ** End Type of Protocol

      ** Allow MT940 Generation
      *
      ** -- The Field is mandatory
      *
 B1  C                   IF        F1M940 = *Blanks
     C                   MOVE      'USR3970'     ZAMSID
     C                   MOVE      *On           *IN43

      ** -- The valid values are 'Y' and 'N'
      *
 X1  C                   ELSE

 B2  C                   IF        F1M940 <> 'Y' AND F1M940 <> 'N'
     C                   MOVE      'USR3973'     ZAMSID
     C                   MOVE      *On           *IN43
 E2  C                   ENDIF

      ** -- The value can't be 'N' if the network allows MT941 or MT942
      ** -- This is allowed if feature CGL178 is on                                           CGL178
      *
 B2  C                   IF        F1M940 = 'N' AND
     C                             (F1M941 = 'Y' OR F1M942 = 'Y')
     C                             AND CGL178 ='N'                                            CGL178
     C                   MOVE      'USR3996'     ZAMSID
     C                   MOVE      *On           *IN43

      ** -- The value can't be 'N' if there is at least one Network Account
      **    linked to the current Network Id. and allowing MT940 generation
      *
 X2  C                   ELSE

 B3  C                   IF        F1M940 = 'N'
     C     EDNWRK        SETLL     GLNW94D2                               99
     C   99              MOVE      'USR3974'     ZAMSID
     C   99              MOVE      *On           *IN43
 E3  C                   ENDIF

 E2  C                   ENDIF

 E1  C                   ENDIF

      ** -- If an error was found
      *
     C                   IF        *IN43
     C                   EXSR      $ZaSndMsg
     C                   MOVE      *On           *IN40
     C                   MOVEL(P)  '*MSG'        RetCodeOut
     C                   ENDIF
      *
      ** End Allow MT940 Generation

      ** Allow MT941 Generation
      *
      ** -- The Field is mandatory
      *
 B1  C                   IF        F1M941 = *Blanks
     C                   MOVE      'USR3970'     ZAMSID
     C                   MOVE      *On           *IN44

      ** -- The valid values are 'Y' and 'N'
      *
 X1  C                   ELSE

 B2  C                   IF        F1M941 <> 'Y' AND F1M941 <> 'N'
     C                   MOVE      'USR3973'     ZAMSID
     C                   MOVE      *On           *IN44

      ** -- The value can't be 'N' if there is at least one Network Account
      **    linked to the current Network Id. and allowing MT941 generation
      *
 X2  C                   ELSE

 B3  C                   IF        F1M941 = 'N'
     C     EDNWRK        SETLL     GLNW94D3                               99
     C   99              MOVE      'USR3974'     ZAMSID
     C   99              MOVE      *On           *IN44
 E3  C                   ENDIF

      ** if CGL178 is on and MT940 is not to be generated, ensure MT950 is to be generated    CGL178
     C                   IF        CGL178 = 'Y' and                                           CGL178
     C                             F1M941 = 'Y' and F1M940 ='N'                               CGL178
     C                             and F1M950 = 'N'                                           CGL178
     C                   MOVE      'USR4646'     ZAMSID                                       CGL178
     C                   MOVE      *On           *IN44                                        CGL178
     C                   ENDIF                                                                CGL178
                                                                                              CGL178
 E2  C                   ENDIF

 E1  C                   ENDIF

      ** -- If an error was found
      *
     C                   IF        *IN44
     C                   EXSR      $ZaSndMsg
     C                   MOVE      *On           *IN40
     C                   MOVEL(P)  '*MSG'        RetCodeOut
     C                   ENDIF
      *
      ** End Allow MT941 Generation

      ** Allow MT942 Generation
      *
      ** -- The Field is mandatory
      *
 B1  C                   IF        F1M942 = *Blanks
     C                   MOVE      'USR3970'     ZAMSID
     C                   MOVE      *On           *IN45

      ** -- The valid values are 'Y' and 'N'
      *
 X1  C                   ELSE

 B2  C                   IF        F1M942 <> 'Y' AND F1M942 <> 'N'
     C                   MOVE      'USR3973'     ZAMSID
     C                   MOVE      *On           *IN45

      ** -- The value can't be 'N' if there is at least one Network Account
      **    linked to the current Network Id. and allowing MT942 generation
      *
 X2  C                   ELSE

 B3  C                   IF        F1M942 = 'N'
     C     EDNWRK        SETLL     GLNW94D4                               99
     C   99              MOVE      'USR3974'     ZAMSID
     C   99              MOVE      *On           *IN45
 E3  C                   ENDIF

 E2  C                   ENDIF

 E1  C                   ENDIF

      ** if CGL178 is on and MT940 is not to be generated, ensure MT950 is to be generated    CGL178
     C                   IF        CGL178 = 'Y' and                                           CGL178
     C                             F1M942 = 'Y' and F1M940 ='N'                               CGL178
     C                             and F1M950 = 'N'                                           CGL178
     C                   MOVE      'USR4646'     ZAMSID                                       CGL178
     C                   MOVE      *On           *IN45                                        CGL178
     C                   ENDIF                                                                CGL178
                                                                                              CGL178
      ** -- If an error was found
      *
     C                   IF        *IN45
     C                   EXSR      $ZaSndMsg
     C                   MOVE      *On           *IN40
     C                   MOVEL(P)  '*MSG'        RetCodeOut
     C                   ENDIF
      *
      ** End Allow MT942 Generation

      ** Allow MT950 Generation
      *
      ** -- The Field is mandatory
      *
 B1  C                   IF        F1M950 = *Blanks
     C                   MOVE      'USR3970'     ZAMSID
     C                   MOVE      *On           *IN46

      ** -- The valid values are 'Y' and 'N'
      *
 X1  C                   ELSE

 B2  C                   IF        F1M950 <> 'Y' AND F1M950 <> 'N'
     C                   MOVE      'USR3973'     ZAMSID
     C                   MOVE      *On           *IN46

      ** -- The value can't be 'N' if there is at least one Network Account
      **    linked to the current Network Id. and allowing MT950 generation
      *
 X2  C                   ELSE

 B3  C                   IF        F1M950 = 'N'
     C     EDNWRK        SETLL     GLNWACD2                               99
     C   99              MOVE      'USR3974'     ZAMSID
     C   99              MOVE      *On           *IN46
 E3  C                   ENDIF

 E2  C                   ENDIF

 E1  C                   ENDIF

      ** -- If an error was found
      *
     C                   IF        *IN46
     C                   EXSR      $ZaSndMsg
     C                   MOVE      *On           *IN40
     C                   MOVEL(P)  '*MSG'        RetCodeOut
     C                   ENDIF
      *
      ** End Allow MT950 Generation


      ** Allow Multiple Destinations for MT94x
      *
      ** -- The Field is mandatory
      *
 B1  C                   IF        F1AMDS = *Blanks
     C                   MOVE      'USR3970'     ZAMSID
     C                   MOVE      *On           *IN48

      ** -- The valid values are 'Y' and 'N'
      *
 X1  C                   ELSE

 B2  C                   IF        F1AMDS <> 'Y' AND F1AMDS <> 'N'
     C                   MOVE      'USR3973'     ZAMSID
     C                   MOVE      *On           *IN48

      ** -- The value can't be 'N' if there is at least one Network Account
      **    linked to the current Network Id. and allowing multiple destinations
      **    (The trick is to find in GLNW94L5 at least two records with the same
      **     Network Account. This can only occur if the Network Account has
      **     several destinations)
      *
 X2  C                   ELSE

 B3  C                   IF        F1AMDS = 'N'
     C     EDNWRK        SETLL     GLNW94D5
     C     EDNWRK        READE     GLNW94D5                               99

 B4  C                   DOW       NOT *IN99
     C                   EVAL      SvBRCA = N4BRCA
     C                   EVAL      SvCNUM = N4CNUM
     C                   EVAL      SvCCY  = N4CCY
     C                   EVAL      SvACCD = N4ACCD
     C                   EVAL      SvACSQ = N4ACSQ
     C                   EVAL      SvNATY = N4NATY
     C     EDNWRK        READE     GLNW94D5                               99

 B5  C                   IF        NOT *IN99       AND
     C                             N4BRCA = SvBRCA AND N4CNUM = SvCNUM AND
     C                             N4CCY  = SvCCY  AND N4ACCD = SvACCD AND
     C                             N4ACSQ = SvACSQ AND N4NATY = SvNATY
     C                   MOVE      'USR3976'     ZAMSID
     C                   MOVE      *On           *IN48
     C                   LEAVE
 E5  C                   ENDIF

 E4  C                   ENDDO

 E3  C                   ENDIF

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
      ** End Allow Multiple Destinations for MT94x

      ** Allow Extended Narrative
      *
      ** -- The Field is mandatory
      *
 B1  C                   IF        F1ENRA = *Blanks
     C                   MOVE      'USR3970'     ZAMSID
     C                   MOVE      *On           *IN49

      ** -- The valid values are 'Y' and 'N'
      *
 X1  C                   ELSE

 B2  C                   IF        F1ENRA <> 'Y' AND F1ENRA <> 'N'
     C                   MOVE      'USR3973'     ZAMSID
     C                   MOVE      *On           *IN49
 E2  C                   ENDIF

 E1  C                   ENDIF

      ** -- If an error was found
      *
     C                   IF        *IN49
     C                   EXSR      $ZaSndMsg
     C                   MOVE      *On           *IN40
     C                   MOVEL(P)  '*MSG'        RetCodeOut
     C                   ENDIF
      *
      ** End Allow Extended Narrative

      ** Retention Period for Schedule Request
      *
      ** -- The value must be between 0 and 99. As the field is two digits
      **    long, it is not necessary to test the upper limit
      *
 B1  C                   IF        F1RPSR < 0
     C                   MOVE      'USR3995'     ZAMSID
     C                   EXSR      $ZaSndMsg
     C                   MOVE      *On           *IN50
     C                   MOVE      *On           *IN40
     C                   MOVEL(P)  '*MSG'        RetCodeOut
 E1  C                   ENDIF
      *
      ** End Retention Period for Schedule Request

      ** Prevent Automatic Submission at Start of Business
      *
      ** -- The Field is mandatory
      *
 B1  C                   IF        F1PASS = *Blanks
     C                   MOVE      'USR3970'     ZAMSID
     C                   MOVE      *On           *IN51

      ** -- The valid values are 'Y' and 'N'
      *
 X1  C                   ELSE

 B2  C                   IF        F1PASS <> 'Y' AND F1PASS <> 'N'
     C                   MOVE      'USR3973'     ZAMSID
     C                   MOVE      *On           *IN51
 E2  C                   ENDIF

 E1  C                   ENDIF

      ** -- If an error was found
      *
     C                   IF        *IN51
     C                   EXSR      $ZaSndMsg
     C                   MOVE      *On           *IN40
     C                   MOVEL(P)  '*MSG'        RetCodeOut
     C                   ENDIF
      *
      ** End Prevent Automatic Submission at Start of Business

      ** Prevent Automatic Submission if Non-Working Day
      *
      ** -- The Field is mandatory
      *
 B1  C                   IF        F1PASN = *Blanks
     C                   MOVE      'USR3970'     ZAMSID
     C                   MOVE      *On           *IN52

      ** -- The valid values are 'Y' and 'N'
      *
 X1  C                   ELSE

 B2  C                   IF        F1PASN <> 'Y' AND F1PASN <> 'N'
     C                   MOVE      'USR3973'     ZAMSID
     C                   MOVE      *On           *IN52
 E2  C                   ENDIF

 E1  C                   ENDIF

      ** -- If an error was found
      *
     C                   IF        *IN52
     C                   EXSR      $ZaSndMsg
     C                   MOVE      *On           *IN40
     C                   MOVEL(P)  '*MSG'        RetCodeOut
     C                   ENDIF
      *
      ** End Prevent Automatic Submission if Non-Working Day

      *                                                                                       CER030
      ** Validate Alternate Transaction Type length                                           CER030
      *                                                                                       CER030
     C                   IF        D1TRTP <> *ZEROS AND                                       CER030
     C                             D1TRTP <> *BLANKS                                          CER030
      *                                                                                       CER030
     C                   EVAL      WNum = %CHECK(WDigits:D1TRTP)                              CER030
      *                                                                                       CER030
     C                   IF        WNum <> *ZEROS                                             CER030
     C                   EVAL      ZAMSID = 'USR5303'                                         CER030
     C                   EVAL      *IN53 = *ON                                                CER030
     C                   EXSR      $ZaSndMsg                                                  CER030
     C                   EVAL      *IN40 = *ON                                                CER030
     C                   EVAL      RetCodeOut = '*MSG'                                        CER030
      *                                                                                       CER030
     C                   ELSE                                                                 CER030
      *                                                                                       CER030
     C                   EVAL      WTrTp = %DEC(%TRIM(D1TRTP):2:0)                            CER030
      *                                                                                       CER030
     C                   IF        WTrTp < 0 OR WTrTp > 10                                    CER030
     C                   EVAL      ZAMSID = 'USR5303'                                         CER030
     C                   EVAL      *IN53 = *ON                                                CER030
     C                   EXSR      $ZaSndMsg                                                  CER030
     C                   EVAL      *IN40 = *ON                                                CER030
     C                   EVAL      RetCodeOut = '*MSG'                                        CER030
     C                   ENDIF                                                                CER030
      *                                                                                       CER030
     C                   ENDIF                                                                CER030
      *                                                                                       CER030
     C                   ENDIF                                                                CER030
      *                                                                                       CER030
      ** Validate Multicash Network                                                           CER030
      *                                                                                       CER030
     C                   IF        CER030 = 'Y'                                               CER030
      *                                                                                       CER030
     C                   IF        D1MCNW = *BLANKS                                           CER030
      *                                                                                       CER030
     C                   EVAL      ZAMSID = 'USR3970'                                         CER030
     C                   EVAL      *IN55 = *ON                                                CER030
      *                                                                                       CER030
     C                   ELSEIF    D1MCNW <> 'Y' AND D1MCNW <> 'N'                            CER030
      *                                                                                       CER030
     C                   EVAL      ZAMSID = 'USR3973'                                         CER030
     C                   EVAL      *IN55 = *ON                                                CER030
      *                                                                                       CER030
     C                   ENDIF                                                                CER030
      *                                                                                       CER030
     C                   IF        D1MCNW = 'Y' AND                                           CER030
     C                             (EDNWRK = 'SWIFT' OR                                       CER030
     C                             EDNWRK = 'TELEX' OR                                        CER030
     C                             EDNWRK = 'PAPER' OR                                        CER030
     C                             EDNWRK = 'FONTIS' OR                                       CER030
     C                             EDNWRK = 'CASHV8' OR                                       CER030
     C                             EDNWRK = 'YENKSI' OR                                       CER030
     C                             EDNWRK = 'STTX'   OR                                       CER030
     C                             EDNWRK = 'UNROUT' OR                                       CER030
     C                             EDNWRK = 'SIC')                                            CER030
     C                   EVAL      ZAMSID = 'USR5317'                                         CER030
     C                   EVAL      *IN55 = *ON                                                CER030
     C                   ENDIF                                                                CER030
      *                                                                                       CER030
      ** If an error found                                                                    CER030
      *                                                                                       CER030
     C                   IF        *IN55 = *ON                                                CER030
      *                                                                                       CER030
     C                   EXSR      $ZaSndMsg                                                  CER030
     C                   EVAL      *IN40 = *ON                                                CER030
     C                   EVAL      RetCodeOut = '*MSG'                                        CER030
      *                                                                                       CER030
     C                   ENDIF                                                                CER030
      *                                                                                       CER030
     C                   ENDIF                                                                CER030
      *                                                                                       CER030
      ** Validate account number format                                                       CER030
      *                                                                                       CER030
     C**********         If        CER030 = 'Y' AND                                BUG25800 BUG26393
     C**********                   D1MCNW = 'Y'                                    BUG25800 BUG26393
      *                                                                                     BUG25800
     C                   IF        D1ACNF = *BLANKS                                           CER030
     C                   EVAL      ZAMSID = 'USR3970'                                         CER030
     C                   EVAL      *IN54 = *ON                                                CER030
      *                                                                                       CER030
     C                   ELSEIF    D1ACNF <> '*LEDGER' AND                                    CER030
     C                             D1ACNF <> '*RETAIL'                                        CER030
      *                                                                                       CER030
     C                   IF        CFT004 = 'Y' AND D1ACNF <> '*IBAN'                         CER030
      *                                                                                       CER030
     C                   EVAL      ZAMSID = 'USR5304'                                         CER030
     C                   EVAL      ZAMSDA = '*IBAN,'+'*LEDGER,'+                              CER030
     C                                      '*RETAIL'                                         CER030
     C                   EVAL      *IN54 = *ON                                                CER030
      *                                                                                       CER030
     C                   IF        CER030 = 'Y' AND D1MCNW = 'Y'                              CER030
      *                                                                                       CER030
     C                   IF        D1ACNF <> '*BLZ'                                           CER030
      *                                                                                       CER030
     C                   EVAL      ZAMSID = 'USR5304'                                         CER030
     C                   EVAL      ZAMSDA = '*IBAN,'+'*LEDGER,'+                              CER030
     C                                      '*RETAIL,'+'*BLZ'                                 CER030
     C                   EVAL      *IN54 = *ON                                                CER030
      *                                                                                       CER030
     C                   ELSE                                                                 CER030
      *                                                                                       CER030
     C                   EVAL      ZAMSID = *BLANKS                                           CER030
     C                   EVAL      ZAMSDA = *BLANKS                                           CER030
     C                   EVAL      *IN54 = *OFF                                               CER030
      *                                                                                       CER030
     C                   ENDIF                                                                CER030
      *                                                                                       CER030
     C                   ENDIF                                                                CER030
      *                                                                                       CER030
     C                   ENDIF                                                                CER030
      *                                                                                       CER030
     C**********         IF        CFT004 = 'N' AND CER030 = 'Y'                     CER030 BUG25800
     C                   IF        CFT004 = 'N'                                             BUG25800
      *                                                                                       CER030
     C**********         IF        D1ACNF <> '*BLZ' AND D1MCNW = 'Y'                 CER030 BUG25800
     C                   If        D1MCNW = 'Y'                                             BUG25800
     C                   If        D1ACNF <> '*BLZ'                                         BUG25800
     C                   EVAL      ZAMSID = 'USR5304'                                         CER030
     C                   EVAL      ZAMSDA = '*BLZ,'+'*LEDGER,'+                               CER030
     C                                      '*RETAIL'                                         CER030
     C                   EVAL      *IN54 = *ON                                                CER030
     C                   EndIf                                                              BUG25800
     C**********         ELSEIF    D1MCNW = 'N'                                      CER030 BUG25800
      ** USR0264  20   Entry not allowed                                                    BUG25800
     C                   ELse                                                               BUG25800
     C**********         EVAL      ZAMSID = 'USR5304'                                CER030 BUG25800
     C                   EVAL      ZAMSID = 'USR0264'                                       BUG25800
     C**********         EVAL      ZAMSDA = '*LEDGER,'+'*RETAIL'                     CER030 BUG25800
     C                                                                                        CER030
     C                   EVAL      *IN54 = *ON                                                CER030
     C                   ENDIF                                                                CER030
      *                                                                                       CER030
     C                   ENDIF                                                                CER030
      *                                                                                       CER030
     C**********         IF        CFT004 = 'N' AND CER030 = 'N'                     CER030 BUG25800
      **********                                                                     CER030 BUG25800
     C**********         EVAL      ZAMSID = 'USR5304'                                CER030 BUG25800
     C**********         EVAL      ZAMSDA = '*LEDGER,'+'*RETAIL'                     CER030 BUG25800
     C**********         EVAL      *IN54 = *ON                                       CER030 BUG25800
     C**********         ENDIF                                                       CER030 BUG25800
      *                                                                                       CER030
     C                   ENDIF                                                                CER030
      *                                                                                     BUG25800
     C**********         ENDIF                                                     BUG25800 BUG26393
      *                                                                                       CER030
      ** If an error found                                                                    CER030
      *                                                                                       CER030
     C                   IF        *IN54 = *ON                                                CER030
      *                                                                                       CER030
     C                   EXSR      $ZaSndMsg                                                  CER030
     C                   EVAL      *IN40 = *ON                                                CER030
     C                   EVAL      RetCodeOut = '*MSG'                                        CER030
      *                                                                                       CER030
     C                   ENDIF                                                                CER030
      *                                                                                       CMG008
      ** Validate Allow Non-SWIFT Character Conversion flag                                   CMG008
      *                                                                                       CMG008
     C                   IF        CMG008 = 'Y'                                               CMG008
      *                                                                                       CMG008
     C                   IF        D1CONV = *BLANKS                                           CMG008
      *                                                                                       CMG008
     C                   EVAL      ZAMSID = 'USR3970'                                         CMG008
     C                   EVAL      *IN56 = *ON                                                CMG008
      *                                                                                       CMG008
     C                   ELSEIF    D1CONV <> 'Y' AND D1CONV <> 'N'                            CMG008
      *                                                                                       CMG008
     C                   EVAL      ZAMSID = 'USR3973'                                         CMG008
     C                   EVAL      *IN56 = *ON                                                CMG008
      *                                                                                       CMG008
     C                   ENDIF                                                                CMG008
      *                                                                                       CMG008
     C                   IF        D1CONV = 'Y' AND D1MCNW = 'Y'                              CMG008
     C                   EVAL      ZAMSID = 'USR4015'                                         CMG008
     C                   EVAL      *IN56 = *ON                                                CMG008
     C                   ENDIF                                                                CMG008
      *                                                                                       CMG008
      ** If an error found                                                                    CMG008
      *                                                                                       CMG008
     C                   IF        *IN56 = *ON                                                CMG008
      *                                                                                       CMG008
     C                   EXSR      $ZaSndMsg                                                  CMG008
     C                   EVAL      *IN40 = *ON                                                CMG008
     C                   EVAL      RetCodeOut = '*MSG'                                        CMG008
      *                                                                                       CMG008
     C                   ENDIF                                                                CMG008
      *                                                                                       CMG008
     C                   ENDIF                                                                CMG008
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

     C                   MOVEL     'SDUSRMSG'    ZAMSGF           10
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
      *                                                                                       CER030
     C                   EVAL      CER030 = 'N'                                               CER030
     C                   EVAL      CFT004 = 'N'                                               CER030
      *                                                                                       CER030
      ** Check the switchable feature CER030 with the corresponding                           CER030
      ** parameters.                                                                          CER030
      *                                                                                       CER030
     C                   CALLB     'AOSARDR0'                                                 CER030
     C                   PARM      *BLANKS       PRtcd                                        CER030
     C                   PARM      '*VERIFY'     POptn                                        CER030
     C                   PARM      'CER030'      PSard                                        CER030
     C     SCSARD        PARM      SCSARD        DSFDY                                        CER030
      *                                                                                       CER030
      ** Database error (return code other than *NRF and blanks)                              CER030
      *                                                                                       CER030
     C                   IF        PRtcd <> '*NRF' AND                                        CER030
     C                             PRtcd <> *BLANKS                                           CER030
     C     *LOCK         IN        LDA                                                        CER030
     C                   EVAL      DBFILE = 'SCSARDPD'                                        CER030
     C                   EVAL      DBASE = 1                                                  CER030
     C                   EVAL      DBKEY = PSard                                              CER030
     C                   OUT       LDA                                                        CER030
     C                   EXSR      *PSSR                                                      CER030
     C                   ENDIF                                                                CER030
      *                                                                                       CER030
     C                   IF        PRtcd = *BLANKS                                            CER030
     C                   EVAL      CER030 = 'Y'                                               CER030
     C                   ENDIF                                                                CER030
      *                                                                                       CER030
      ** Check the switchable feature CFT004 with the corresponding                           CER030
      ** parameters.                                                                          CER030
      *                                                                                       CER030
     C                   CALLB     'AOSARDR0'                                                 CER030
     C                   PARM      *BLANKS       PRtcd                                        CER030
     C                   PARM      '*VERIFY'     POptn                                        CER030
     C                   PARM      'CFT004'      PSard                                        CER030
     C     SCSARD        PARM      SCSARD        DSFDY                                        CER030
      *                                                                                       CER030
      ** Database error (return code other than *NRF and blanks)                              CER030
      *                                                                                       CER030
     C                   IF        PRtcd <> '*NRF' AND                                        CER030
     C                             PRtcd <> *BLANKS                                           CER030
     C     *LOCK         IN        LDA                                                        CER030
     C                   EVAL      DBFILE = 'SCSARDPD'                                        CER030
     C                   EVAL      DBASE = 2                                                  CER030
     C                   EVAL      DBKEY = PSard                                              CER030
     C                   OUT       LDA                                                        CER030
     C                   EXSR      *PSSR                                                      CER030
     C                   ENDIF                                                                CER030
      *                                                                                       CER030
     C                   IF        PRtcd = *BLANKS                                            CER030
     C                   EVAL      CFT004 = 'Y'                                               CER030
     C                   ENDIF                                                                CER030
      *                                                                                       CER030
      ** Check the switchable feature CGL178 with the corresponding                           CGL178
      ** parameters.                                                                          CGL178
      *                                                                                       CGL178
     C                   CALLB     'AOSARDR0'                                                 CGL178
     C                   PARM      *BLANKS       PRtcd                                        CGL178
     C                   PARM      '*VERIFY'     POptn                                        CGL178
     C                   PARM      'CGL178'      PSard                                        CGL178
     C     SCSARD        PARM      SCSARD        DSFDY                                        CGL178
      *                                                                                       CGL178
      ** Database error (return code other than *NRF and blanks)                              CGL178
      *                                                                                       CGL178
     C                   IF        PRtcd <> '*NRF' AND                                        CGL178
     C                             PRtcd <> *BLANKS                                           CGL178
     C     *LOCK         IN        LDA                                                        CGL178
     C                   EVAL      DBFILE = 'SCSARDPD'                                        CGL178
     C                   EVAL      DBASE = 9                                                  CGL178
     C                   EVAL      DBKEY = PSard                                              CGL178
     C                   OUT       LDA                                                        CGL178
     C                   EXSR      *PSSR                                                      CGL178
     C                   ENDIF                                                                CGL178
      *                                                                                       CGL178
     C                   EVAL      CGL178 = 'N'                                               CGL178
     C                   IF        PRtcd = *BLANKS                                            CGL178
     C                   EVAL      CGL178 = 'Y'                                               CGL178
     C                   ENDIF                                                                CGL178
      *                                                                                       CGL178
                                                                                              CMG008
      ** Check if feature CMG008 is installed                                                 CMG008
                                                                                              CMG008
     C                   EVAL      CMG008 = 'N'                                               CMG008
                                                                                              CMG008
     C                   CALL      'AOSARDR0'                                                 CMG008
     C                   PARM      *BLANKS       PRtcd                          Return Code   CMG008
     C                   PARM      '*VERIFY'     POptn                          Option        CMG008
     C                   PARM      'CMG008 '     PSard                          Feature Ref   CMG008
     C     SCSARD        PARM      SCSARD        DSFDY                                        CMG008
                                                                                              CMG008
     C                   IF        PRtcd = *BLANKS                                            CMG008
     C                   MoveL     'Y'           CMG008                                       CMG008
     C                   ENDIF                                                                CMG008
     C/COPY OFCPYSRCZ,CGL146_002                                                              CGL146
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

     C                   CALLB     'DBERRCTL'

     C                   MOVEL(P)  '*ERROR'      RetCodeOut
     C                   EXSR      $ExitMod
      *    ----------    ------
     C     @PSSR         ENDSR

      *========================================================================*
**  CPY@
(c) Finastra International Limited 2002
