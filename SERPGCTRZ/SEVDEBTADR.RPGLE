     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2010')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas SE Validate Debtor Address')                     *
      *****************************************************************
      *                                                               *
      *  Midas - Securities Trading Module                            *
      *                                                               *
      *  SEVDEBTADR - Validate Debtor Address                         *
      *                                                               *
      *  Component of: SETSESVAL                                      *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2010            *
      *                                                               *
      *    This source is centrally supported and must ONLY be        *
      *    amended by Core Development Personnel.                     *
      *                                                               *
      *    /COPY, Client or Country amendments must not be            *
      *    applied to this source.                                    *
      *                                                               *
      *  Last Amend No. CSF011A            Date 28Nov11               *
      *  Prev Amend No. AR640670           Date 13Sep10               *
      *                 AR640699           Date 09Sep10               *
      *                 CSW210  *CREATE    Date 04May10               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CSF011A - CCR015: Display Order in Confirmation Pages        *
      *            (Recompile)                                        *
      *  AR640670 - Debtor address validation for warning messages    *
      *  AR640699 - Debtor Address - DSS/Account test                 *
      *  CSW210 - SWIFT 2010 Changes                                  *
      *                                                               *
      *****************************************************************
      *
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *
      ** +--------------------------------------+
      ** ¦ Automatically included D-specs       ¦
      ** ¦ ==============================       ¦
      ** +--------------------------------------+
      *
      ** Standard D-specs
      ** ================
      **
      ** The following /COPY line includes the LDA layout,
      ** the copyright array definition,
      ** and the following named constants:
      **    True       logical = *On (for indicator processing)
      **    False      logical = *Off (for indicator processing)
      **    DBErrCtl   10A     = 'DBERRCTL' (the name of the database error
      **                                    handler)
      ** and the following variables:
      **    RunBefore  1A (for the PSSR)
      *
      /COPY ZACPYSRC,STD_D_SPEC
      *
      ** Program Status Data Structure
      ** =============================
      ** The following /COPY line includes all the defined fields in the
      ** PSDS.  They have meaningful names, prefixed by 'PS'.
      *
      /COPY ZACPYSRC,PSDS
      *
      ** The following /COPY line includes all the definitions of the
      ** appended error arrays, including the named constant giving the size
      ** of the arrays.
      *
      /COPY ZACPYSRC,ERR_XARRYS
      *
      ** +--------------------------------------+
      ** ¦ End of automatically included D-specs¦
      ** ¦ =====================================¦
      ** +--------------------------------------+
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *
      ** +--------------------------------------+
      ** ¦ Manually included D-specs            ¦
      ** ¦ =========================            ¦
      ** +--------------------------------------+
      *
      ** +--------------------------------------+
      ** ¦ Named constants                      ¦
      ** ¦ ===============                      ¦
      ** +--------------------------------------+
      *
      * Named Constant used to determine if a field contains invalid
      * characters for Telex and S.W.I.F.T.
 
     D ISO             C                   'ABCDEFGHIJKLMNOPQRSTUVWXYZ-
     D                                      abcdefghijklmnopqrstuvwxyz-
     D                                      1234567890 /+-?:().,'''
      *
      ** Named Constant used to determine if a field is alphabetic
 
     D ALPHAB          C                   'ABCDEFGHIJKLMNOPQRSTUVWXYZ'
 
      * Named Constant used to determine if a field is alphabetic
      * with numbers
 
     D ALPHAN          C                   'ABCDEFGHIJKLMNOPQRSTUVWXYZ-
     D                                     1234567890'
      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
      *
      ** Security API Trades Extended Settlements from incoming transaction
      ** - screen format
     D NwSE1ScnFmt   E DS                  EXTNAME(SETESDPD)
      *
      ** Security API Trades Extended Settlements for file update - file format
     D NwSEFilFmt    E DS                  EXTNAME(SEVTRX2PD)
      *
      ** Security API Trades Extended Settlements error indicators
     D SEETES        E DS                  EXTNAME(SEETESPD)
      *
      ** Customer details
     D SDCUST        E DS                  EXTNAME(SDCUSTPD)
      *
      ** Counterparty Nostro details
     D SDCNST        E DS                  EXTNAME(SDCNSTPD)
      *
      ** DS for access programs - long data structure
     D DSSDY         E DS                  EXTNAME(DSSDY)
      *
      ** DS for access programs - short data structure
     D DSFDY         E DS                  EXTNAME(DSFDY)
      *
      ** Data structure to receive parameters from SE1805 for MT5xxs
     D PDATA         E DS                  EXTNAME(SE50DT)
      *
      ** BIC Directory
     D MEBICD        E DS                  EXTNAME(MEBICDPD)
      *
     D                 DS
      *
      ** Data Structure redefining Address fields
     D  ADDRSS                 1    140
     D  ADCHK1                 1     35
     D  ADCHK2                36     70
     D  ADCHK3                71    105
     D  ADCHK4               106    140
      *
      ** Blank Line Analysis data structure
     D  ADCH26                36    140
     D  ADCH36                71    140
      *
      ** SWIFT Address Analysis data structure
     D  ADSLSH                 1      1
     D  ADEXCS                11     35
     D  ADEXSW                12     35
      *
     D DSADRS          DS           140
     D  DSDAD1                 1     35
     D  DSDAD2                36     70
     D  DSDAD234              70     70                                                     AR640699
     D  DSDAD3                71    105
     D  DSDAD4               106    140
      *
     DCLSWTK           DS
     D SW                      1     12
      *
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
      *
      ** Index for arrays of error message ids, etc.
     D IDx             S              3P 0
      ** Index for arrays of warning message ids etc
     D WIx             S              3P 0
      *
     D C#RTCD          S              7
     D C#OPTN          S              7
     D C#CNUM          S             10
     D C#KYST          S              7
      *
     D ##CSID          S              1
     D PMode           S              6A
      *
     D DACFlag         S              1A
     D AD#1            S              1A
     D AD#2            S              1A
     D AD#3            S              1A
     D AD#4            S              1A
     D W@              S              5S 0
     D W@L             S              5S 0
     D W@P             S              5S 0
     D W@SBBL          S             12A
     D CSW201          S              1A
     D SwiftCode       S             35A
     D PRtCode         S              7A
     D FLD             S             35A
     D X#              S              3S 0
      * ME1400 workfields
     D W9Rtn           S              7
     D W9BICC          S              8
     D W9BICB          S              3
     D W9CUST          S              1
     D W9CNST          S              1
     D W9BICD          S              1
      **
      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
      *********************************************************************
      /EJECT                                                              *
      *********************************************************************
      *
      ** +--- Start of Main processing -----------------------------------+
      ** ¦                                                                ¦
      ** ¦ Initial processing is performed automatically: the *INZSR is   ¦
      ** ¦ executed at program activation.                                ¦
      ** ¦                                                                ¦
      ** +----------------------------------------------------------------+
      *
      ** Initialization
      *
     C                   EVAL      Idx = 0
     C                   EVAL      WIx = 0
     C                   EVAL      AD#1 = 'N'
     C                   EVAL      AD#2 = 'N'
     C                   EVAL      AD#3 = 'N'
     C                   EVAL      AD#4 = 'N'
      *
      ** Debtor Address
      *
     C                   EXSR      SRValDEBTADR
      *
      ** If an error was found, set the return code appropriately
      *
     C                   IF        ESDAD1OK = 'N' OR
     C                             ESDAD2OK = 'N' OR
     C                             ESDAD3OK = 'N' OR
     C                             ESDAD4OK = 'N'
     C                   EVAL      RetCodeIn = 'Error'
     C                   ENDIF
      *
     C                   RETURN
      ******************************************************************
      /EJECT
      ******************************************************************
      *                                                                *
      * SRValDEBTADR - Validation for Debtor Address                   *
      *                                                                *
      ******************************************************************
      *
     C     SRValDEBTADR  BEGSR
      *
     C                   EVAL      DSDAD1 = ESDAD1
     C                   EVAL      DSDAD2 = ESDAD2
     C                   EVAL      DSDAD3 = ESDAD3
     C                   EVAL      DSDAD4 = ESDAD4
     C                   EVAL      DACFlag = *BLANKS
      *
      ** Validate if debtor address is not blanks
      *
     C                   IF        DSADRS <> *BLANKS
      *
      ** If Pay Code is Free of Payment
      *
     C                   IF        PPCOD <> '1' AND
     C                             PPCOD <> '5'
     C                   EVAL      ESDAD1OK = 'N'
     C                   EVAL      IDx = IDx + 1
     C                   EVAL      FldNamXAr(IDx) = 'ESDAD1'
     C                   EVAL      MsgIdXAr(IDx) = 'ST00112'
     C                   GOTO      ExDEBTADR
     C                   ENDIF
     C                   ENDIF
      *
      ** Validate SWIFT Address
      *
     C                   EVAL      ADDRSS = DSADRS
      *
     C                   IF        DACFlag = *BLANKS AND
     C                             DSADRS <> *BLANKS
      *
      ** If 1st 11 Chars of 1st line then SWIFT address assumed
      ** Or first is '/' and second is SWIFT Address
      *
      ** If field does not begin with '/' and is not longer than 11
      ** characters, validate as a S.W.I.F.T. Address
      *
     C                   IF        ADCH26 = *BLANKS AND
     C                             ADEXSW = *BLANKS AND
     C                             ADSLSH <> '/'
      *
      ** First 11 characters should be key for CLSWT.
      *
     C                   EVAL      CLSWTK = ADCHK1
      *
     C                   EXSR      SrSwift
      *
     C                   IF        ##CSID = 'Y'
      *
      ** Send error to screen
      *
     C                   IF        *IN31 = *ON
     C                   EVAL      ESDAD1OK = 'N'
     C                   EVAL      IDx = IDx + 1
     C                   EVAL      FldNamXAr(IDx) = 'ESDAD1'
     C                   EVAL      MsgIdXAr(IDx) = 'ST00078'
     C                   GOTO      ExDEBTADR
      *
     C                   ELSE
     C                   EVAL      DACFlag = 'S'
      *
      ** No SWIFT address record. Send a warning message.
      *
     C                   IF        *IN32 = *ON AND
     C                             *IN31 = *OFF
     C**********         EVAL      ESDAD1OK = 'W'                                           AR640670
     C                   EVAL      ESDAD1OK = 'N'                                           AR640670
     C                   EVAL      WIx = WIx + 1
     C                   EVAL      WFldNmXAr(WIx) = 'ESDAD1'
     C                   EVAL      WMsgIdXAr(WIx) = 'ST00079'
     C                   GOTO      ExDEBTADR
     C                   ENDIF
      *
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
      *---------------------------------------------------------------------------------------------
      ** Validate Swift Codeword
      *
     C                   IF        DACFlag = *BLANKS AND
     C                             DSADRS <> *BLANKS
      *
      ** If first character is not '/'.
      *
     C                   IF        ADSLSH = '/'
      *
     C                   EVAL      DACFlag = 'C'
     C                   EVAL      SwiftCode = ESDAD1
      *
      ** check for presence and position of terminating '/'; W@ is
      ** position of second '/'
      *
     C     '/'           SCAN      SwiftCode:2   W@                       50
      *
      ** If second '/' not found - error: codeword must end '/'
     C                   IF        *IN50 = *OFF
     C                   EVAL      ESDAD1OK = 'N'
     C                   EVAL      IDx = IDx + 1
     C                   EVAL      FldNamXAr(IDx) = 'ESDAD1'
     C                   EVAL      MsgIdXAr(IDx) = 'ST00115'
     C                   GOTO      ExDEBTADR
     C                   ENDIF
      *
      ** If '/' is in posn. 2 - error: '//' invalid for codeword
     C                   IF        W@ = 2
     C                   EVAL      ESDAD1OK = 'N'
     C                   EVAL      IDx = IDx + 1
     C                   EVAL      FldNamXAr(IDx) = 'ESDAD1'
     C                   EVAL      MsgIdXAr(IDx) = 'ST00116'
     C                   GOTO      ExDEBTADR
     C                   ENDIF
      *
      ** If '/' is in posn. 11 or greater - error: codeword should be
      ** 8 characters or fewer.
     C                   IF        W@ > 10
      *
     C                   IF        CSW201 = 'Y'
     C                   EVAL      ESDAD1OK = 'N'
     C                   EVAL      IDx = IDx + 1
     C                   EVAL      FldNamXAr(IDx) = 'ESDAD1'
     C                   EVAL      MsgIdXAr(IDx) = 'ST00120'
     C                   GOTO      ExDEBTADR
     C                   ELSE
     C                   EVAL      ESDAD1OK = 'N'
     C                   EVAL      IDx = IDx + 1
     C                   EVAL      FldNamXAr(IDx) = 'ESDAD1'
     C                   EVAL      MsgIdXAr(IDx) = 'ST00117'
     C                   GOTO      ExDEBTADR
     C                   ENDIF
     C                   ENDIF
      *
      ** If any characters after second '/' - error: should be blank
      *
     C     35            SUB       W@            W@L
     C     W@            ADD       1             W@P
     C     W@L           SUBST     SwiftCode:W@P W@SBBL
     C                   IF        W@SBBL <> *BLANKS
     C                   EVAL      ESDAD1OK = 'N'
     C                   EVAL      IDx = IDx + 1
     C                   EVAL      FldNamXAr(IDx) = 'ESDAD1'
     C                   EVAL      MsgIdXAr(IDx) = 'ST00118'
     C                   GOTO      ExDEBTADR
     C                   ENDIF
      *
      ** If codeword contains non-upper case or non-numeric characters
      *
     C                   IF        CSW201 = 'Y'
      *
     C     ALPHAN        CHECK     SwiftCode:2   W@L
     C                   IF        W@L < W@
     C                   EVAL      ESDAD1OK = 'N'
     C                   EVAL      IDx = IDx + 1
     C                   EVAL      FldNamXAr(IDx) = 'ESDAD1'
     C                   EVAL      MsgIdXAr(IDx) = 'ST00121'
     C                   GOTO      ExDEBTADR
     C                   ENDIF
      *
     C                   ELSE
      *
      ** If codeword contains non-upper case alpha characters - error:
      ** codeword should be SWIFT 8a.
      *
     C     ALPHAB        CHECK     SwiftCode:2   W@L
     C                   IF        W@L < W@
     C                   EVAL      ESDAD1OK = 'N'
     C                   EVAL      IDx = IDx + 1
     C                   EVAL      FldNamXAr(IDx) = 'ESDAD1'
     C                   EVAL      MsgIdXAr(IDx) = 'ST00119'
     C                   GOTO      ExDEBTADR
     C                   ENDIF
     C                   ENDIF
      *
     C                   IF        ADEXCS <> *BLANKS
     C                   EVAL      ESDAD1OK = 'N'
     C                   EVAL      IDx = IDx + 1
     C                   EVAL      FldNamXAr(IDx) = 'ESDAD1'
     C                   EVAL      MsgIdXAr(IDx) = 'ST00117'
     C                   GOTO      ExDEBTADR
     C                   ELSE
     C                   IF        ESDAD2 = *BLANKS
     C                   EVAL      ESDAD2OK = 'N'
     C                   EVAL      IDx = IDx + 1
     C                   EVAL      FldNamXAr(IDx) = 'ESDAD2'
     C                   EVAL      MsgIdXAr(IDx) = 'ST00122'
     C                   GOTO      ExDEBTADR
     C                   ELSE
     C                   EVAL      FLD = ESDAD2
     C                   EXSR      SRSWSET
     C                   IF        *IN99 = *ON
     C                   EVAL      AD#2 = 'Y'
     C                   EVAL      ESDAD2OK = 'N'
     C                   EVAL      IDx = IDx + 1
     C                   EVAL      FldNamXAr(IDx) = 'ESDAD2'
     C                   EVAL      MsgIdXAr(IDx) = 'ST00081'
     C                   GOTO      ExDEBTADR
     C                   ENDIF
     C                   ENDIF
                                                                                            AR640699
      **  CODEWORD is valid and second line is more than 34 characters                      AR640699
                                                                                            AR640699
     C                   IF        ESDAD1OK  <> 'N'                                         AR640699
     C                             AND DSDAD234 <> *BLANKS                                  AR640699
     C                   EVAL      ESDAD1OK = 'N'                                           AR640699
     C                   EVAL      ESDAD2OK = 'N'                                           AR640699
     C                   EVAL      IDx = IDx + 1                                            AR640699
     C                   EVAL      FldNamXAr(IDx) = 'ESDAD1'                                AR640699
     C                   EVAL      MsgIdXAr(IDx) = 'ST00124'                                AR640699
     C                   ENDIF                                                              AR640699
                                                                                            AR640699
     C                   IF        ESDAD3 <> *BLANKS OR
     C                             ESDAD4 <> *BLANKS
     C                   EVAL      ESDAD1OK = 'N'
     C                   EVAL      IDx = IDx + 1
     C                   EVAL      FldNamXAr(IDx) = 'ESDAD1'
     C                   EVAL      MsgIdXAr(IDx) = 'ST00123'
     C                   GOTO      ExDEBTADR
     C                   ENDIF
     C                   ENDIF
      *
     C                   ENDIF                                                  ADSLSH <> '/'
     C                   ENDIF                                                  DACFlag = *BLANKS
      *---------------------------------------------------------------------------------------------
      ** Validate Standard Address
      *
     C                   IF        DACFlag = *BLANKS AND
     C                             DSADRS <> *BLANKS
     C                   EXSR      SrADChk
      *
     C                   IF        *IN92 = *ON
     C                   EVAL      ESDAD1OK = 'N'
     C                   EVAL      IDx = IDx + 1
     C                   EVAL      FldNamXAr(IDx) = 'ESDAD1'
     C                   EVAL      MsgIdXAr(IDx) = 'ST00080'
     C                   ENDIF
      *
     C                   IF        ESDAD1OK = 'Y' AND
     C                             ESDAD2OK = 'Y' AND
     C                             ESDAD3OK = 'Y' AND
     C                             ESDAD4OK = 'Y' AND
     C                             DACFlag = *BLANKS
     C                   EVAL      DACFlag = 'A'
     C                   ENDIF
      *
     C                   ENDIF                                                  DACFlag = *BLANKS
      *
     C     ExDEBTADR     ENDSR
      *****************************************************************
      *                                                               *
      * SRSwift - Validation for SWIFT Address                        *
      *                                                               *
      *****************************************************************
     C     SRSwift       BEGSR
      *
     C                   EVAL      *IN31 = *OFF
     C                   EVAL      *IN32 = *OFF
      *
      ** Test positions 1-8 for valid SWIFT Characters
      ** Check how many characters are alphanumeric
      *
     C                   EVAL      FLD = *Blanks
     C                   EVAL      FLD = CLSWTK
     C     ALPHAN        CHECK     FLD           X#                       90
      *
      ** If the first 8 or 11 are ok proceed
      *
     C                   IF        *IN90 = *ON AND
     C                             X# = 9      OR
     C                             *IN90 = *ON AND
     C                             X# = 12
     C     ' '           CHECK     FLD:X#                                 90
      *
      ** Check for blanks if before 8 or 11 then assume address
      *
     C                   IF        *IN90 = *ON AND
     C                             X# = 11
     C                   EVAL      *IN31 = *ON
     C                   EVAL      ##CSID = 'Y'
     C                   GOTO      EXSWFT
     C                   ENDIF
     C                   ENDIF
      *
      ** Invalid format - Not a S.W.I.F.T.
      *
     C                   IF        *IN90 = *ON
     C                   EVAL      ##CSID = 'N'
     C                   GOTO      EXSWFT
     C                   ENDIF
      *
      ** Call ME1400 to validate identifier
      *
     C                   MOVEL     FLD           W9BICC
     C     3             SUBST     FLD:9         W9BICB
      *
     C                   CALL      'ME1400'
     C                   PARM      *BLANKS       W9RTN
     C                   PARM                    W9BICC
     C                   PARM                    W9BICB
     C                   PARM                    SDCUST
     C                   PARM                    SDCNST
     C                   PARM                    MEBICD
     C                   PARM      *BLANKS       W9CUST
     C                   PARM      *BLANKS       W9CNST
     C                   PARM      *BLANKS       W9BICD
      *
     C                   SELECT
      *
      ** Record not found on directory but found on others
      ** - BIC directory has data so error
     C                   WHEN      W9RTN = 'MIN0244' OR
     C                             W9RTN = 'MIN0245' OR
     C                             W9RTN = 'MIN0246'
     C                   EVAL      *IN31 = *ON
     C                   EVAL      ##CSID = 'Y'
      *
      ** Record not found - S.W.I.F.T does not exist
     C                   WHEN      W9RTN = 'Y2U0005'
     C                   EVAL      *IN32 = *ON
     C                   EVAL      ##CSID = 'Y'
      *
      ** Record found - BIC exists
     C                   WHEN      W9RTN = *BLANKS
     C                   EVAL      ##CSID = 'Y'
      *
     C                   ENDSL
      *
     CSR   ExSwft        ENDSR
      *
      *****************************************************************
      *                                                               *
      * SRADChk - Validation for Standard Address                     *
      *                                                               *
      *****************************************************************
      *
     C     SRADChk       BEGSR
      *
      **  Set off indicators & error flags
      *
     C                   EVAL      *IN92 = *OFF
     C                   EVAL      AD#1 = 'N'
     C                   EVAL      AD#2 = 'N'
     C                   EVAL      AD#3 = 'N'
     C                   EVAL      AD#4 = 'N'
     C                   EVAL      FLD = *BLANKS
      *
      ** There should be no embedded spaces
      *
     C                   IF        ADCHK1 = *BLANKS  AND
     C                             ADCHK2 <> *BLANKS OR
      *
     C                             ADCHK1 = *BLANKS  AND
     C                             ADCHK3 <> *BLANKS OR
      *
     C                             ADCHK1 = *BLANKS  AND
     C                             ADCHK4 <> *BLANKS OR
      *
     C                             ADCHK2 = *BLANKS  AND
     C                             ADCHK3 <> *BLANKS OR
      *
     C                             ADCHK2 = *BLANKS  AND
     C                             ADCHK4 <> *BLANKS OR
      *
     C                             ADCHK3 = *BLANKS  AND
     C                             ADCHK4 <> *BLANKS
      *
     C                   EVAL      *IN92 = *ON
     C                   ENDIF
      *
      ** Check for non-valid SWIFT characters
      *
     C                   IF        ADCHK1 <> *BLANKS
     C                   EVAL      FLD = ADCHK1
     C                   EXSR      SRSWSET
     C                   IF        *IN99 = *ON
     C                   EVAL      AD#1 = 'Y'
     C                   EVAL      ESDAD1OK = 'N'
     C                   EVAL      IDx = IDx + 1
     C                   EVAL      FldNamXAr(IDx) = 'ESDAD1'
     C                   EVAL      MsgIdXAr(IDx) = 'ST00081'
     C                   ENDIF
     C                   ENDIF
      *
     C                   IF        ADCHK2 <> *BLANKS
     C                   EVAL      FLD = ADCHK2
     C                   EXSR      SRSWSET
     C                   IF        *IN99 = *ON
     C                   EVAL      AD#2 = 'Y'
     C                   EVAL      ESDAD2OK = 'N'
     C                   EVAL      IDx = IDx + 1
     C                   EVAL      FldNamXAr(IDx) = 'ESDAD2'
     C                   EVAL      MsgIdXAr(IDx) = 'ST00081'
     C                   ENDIF
     C                   ENDIF
      *
     C                   IF        ADCHK3 <> *BLANKS
     C                   EVAL      FLD = ADCHK3
     C                   EXSR      SRSWSET
     C                   IF        *IN99 = *ON
     C                   EVAL      AD#3 = 'Y'
     C                   EVAL      ESDAD3OK = 'N'
     C                   EVAL      IDx = IDx + 1
     C                   EVAL      FldNamXAr(IDx) = 'ESDAD3'
     C                   EVAL      MsgIdXAr(IDx) = 'ST00081'
     C                   ENDIF
     C                   ENDIF
      *
     C                   IF        ADCHK4 <> *BLANKS
     C                   EVAL      FLD = ADCHK4
     C                   EXSR      SRSWSET
     C                   IF        *IN99 = *ON
     C                   EVAL      AD#4 = 'Y'
     C                   EVAL      ESDAD4OK = 'N'
     C                   EVAL      IDx = IDx + 1
     C                   EVAL      FldNamXAr(IDx) = 'ESDAD4'
     C                   EVAL      MsgIdXAr(IDx) = 'ST00081'
     C                   ENDIF
     C                   ENDIF
      *
     CSR                 ENDSR
      *
      *****************************************************************
      *                                                               *
      * SRSWSet - Check for valid SWIFT characters used               *
      *                                                               *
      *****************************************************************
      *
     C     SRSWSet       BEGSR
      *
     C                   EVAL      *IN99 = *OFF
      *
     C     ISO           CHECK     FLD           X#                       99
      *
     CSR                 ENDSR
 
      *****************************************************************
      /EJECT
      *
      *****************************************************************
      *                                                               *
      *  *INZSR - Program Initialisation                              *
      *         - This subroutine runs automatically for program      *
      *           initialisation.                                     *
      *                                                               *
      *****************************************************************
      *
     C     *INZSR        BEGSR
      *
     C     *ENTRY        PLIST
      *
      ** INPUT
      ** =====
      *
      ** Return code
     C                   PARM                    RetCodeIn
      *
      ** Mode = '*FRONT' (Front Office Transaction Interface)
      ** Mode = '      ' (Not Front Office Transaction Interface)
      ** Mode = '*RPR  ' (Repair function)
      ** Mode = '*SIN  ' (Screen input function)
     C                   PARM                    PMode
      *
      ** Security Trades Extended Settlements from incoming transaction
      ** - screen format
     C                   PARM                    NwSE1ScnFmt
      *
     C                   PARM                    PDATA
      *
      ** OUTPUT
      ** ======
      *
      ** Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
      *                                                                                     AR640670
      ** Warning fields/message IDs/message data (arrays) from/to caller                    AR640670
     C                   PARM                    WFldNmXAr                                  AR640670
     C                   PARM                    WMsgIDXAr                                  AR640670
     C                   PARM                    WMsgDtXAr                                  AR640670
      *
      ** Security Trades Extended Settlements error indicators
     C                   PARM                    SEETES
      *
      ** Security Trades Extended Settlements Valid File
     C                   PARM                    NwSEFilFmt
      *
      ** Program, module and procedure names for dbase error processing
      ** ==============================================================
      ** The following /COPY sets these values.
      *
      /COPY ZACPYSRC,DBFIELDS
      *
      ** Check to see if switchable feature CSW201 is on
      *
     C                   CALL      'SWIF2001'
     C                   PARM      *BLANKS       PRtCode
 
     C                   IF        PRtCode  = 'CSW2001'
     C                   EVAL      CSW201 = 'Y'
     C                   ELSE
     C                   EVAL      CSW201 = 'N'
     C                   ENDIF
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *
      ** The following /COPY contains the standard program status
      ** subroutine, including a bound call to the DBERRCTL module.
      *
      /COPY ZACPYSRC,PSSR_ILE
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *
**  CPY@
(c) Misys International Banking Systems Ltd. 2010
