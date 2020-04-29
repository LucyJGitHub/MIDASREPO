     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2015')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas MG Validation & Formatting for 59F')             *
      *****************************************************************
      *                                                               *
      *  Midas - Message Generation Module                            *
      *                                                               *
      *  MG001001  - Midas MG Validation and Formatting for 59F       *
      *                                                               *
      *  (c) Finastra International Limited 2015                      *
      *                                                               *
      *  Last Amend No. MD055694           Date 09Mar20               *
      *  Prev Amend No. CER050             Date 16Jun19               *
      *                 MD037229           Date 03Sep18               *
      *                 MD038302           Date 03Sep18               *
      *                 MD046248           Date 27Oct17               *
      *                 MD035038           Date 14Jul15               *
      *                 MD034605           Date 04Jun15               *
      *                 MD034543           Date 03Jun15               *
      *                 MD034511           Date 26May15               *
      *                 CSW215  *CREATE    Date 06Apr15               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD055694 - SWIFT Changes 2021                                *
      *  CER050 - Annualised Percentage Rate (Recompile)              *
      *  MD037229 - Remove the validation of town after ISO code in   *
      *             first occurrence of 3/                            *
      *           - Applied for MD-51750                              *
      *  MD038302 - Wrong validation in beneficiary. Perform the 59F  *
      *             validation only if the entry into the field is a  *
      *             free-format name and address and the first non-   *
      *             line begins with "1/".                            *
      *           - Applied for MD-51750                              *
      *  MD046248 - Finastra Rebranding                               *
      *  MD035038 - Error in ACOUNTIBAN validation                    *
      *  MD034605 - Valid account is validated against 59F if starts  *
      *             with identifier 1-3                               *
      *  MD034543 - Additional 59F validation for Beneficiary Cover   *
      *  MD034511 - field tag 59 Beneficiary is not generated in      *
      *             OPAY MT103                                        *
      *  CSW215 - SWIFT Changes 2015                                  *
      *                                                               *
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+

     FMEISOCL0  IF   E           K DISK    INFSR(*PSSR)

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
      **    True       logical = *on (for indicator processing)
      **    False      logical = *off (for indicator processing)
      **    DBErrCtl   10A     = 'DBERRCTL' (the name of the database error
      **                                    handler)
      ** and the following variables:
      **    RunBefore  1A (for the PSSR)

     D/COPY ZACPYSRC,STD_D_SPEC

      ** Include the MM standard declares
     D/COPY ZACPYSRC,STDDECLARE

      ** Program Status Data Structure
      ** =============================
      ** The following /COPY line includes all the defined fields in the
      ** PSDS.  They have meaningful names, prefixed by 'PS'.

     D/COPY ZACPYSRC,PSDS

      **---------------------------------------------------------------
      ** The following /COPY line includes the definitions for error and
      ** warning message arrays.
     D/COPY ZACPYSRC,ERR_ARRAYS
      **---------------------------------------------------------------

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

     D NumCode         C                   CONST('123')

      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+

      ** Input Parameters

     D PRetCode        S              7A
     D PCallFrom       S              4A
     D PInpParm1       S             35A
     D PInpParm2       S             35A
     D PInpParm3       S             35A
     D PInpParm4       S             35A
     D PInpParm5       S             35A
     D PNetwork        S              6A
     D PMsgType        S              3A
     D PMsgTag         S              5A
     D PBranch         S              3A
     D PCountry        S              2A
     D PCurrCde        S              3A
     D PNostro         S              2A
     D POutParm1       S             35A
     D POutParm2       S             35A
     D POutParm3       S             35A
     D POutParm4       S             35A
     D POutParm5       S             35A
     D PMsgID          S              7A
     D PErrType        S              1A

      ** IBAN Parameters

     D PIBAN           S             47A
     D POWith          S             47A
     D PONobl          S             34A
     D WIBANR          S             34A
     D WIBCH1          S              1A
     D WIBCH2          S              1A
     D WIBNU1          S              1A
     D WIBNU2          S              1A
     D WIBANY          S              1A

      ** Program variables

     D POption         S              7A
     D PMSard          S              6A
     D CFT004          S              1A
     D WISOC           S              2A
     D WFrmtL          S            175A
     D WLayOut         S             35A
     D WOMFM1          S             35A
     D WOMFM2          S             35A
     D WOMFM3          S             35A
     D WOMFM4          S             35A
     D WOMFM5          S             35A
     D SaveFlag        S              1A
     D SveFlg1         S              1A
     D SveFlg2         S              1A
     D SveFlg3         S              1A
     D WISOFlg         S              1A
     D PAction         S             10A
     D WInpDSA         S            140A
     D PRtnCode        S              7A
     D PRtnCde2        S              7A
     D PBranch4        S              4A
     D PCountry4       S              4A
     D WdOMFM          S              1A
     D WLayFound       S              1A
     D PCustA          S             10A
     D PCKyst          S             10A
     D PAccType        S              7A
     D PMAccount       S             35A
     D Num3Exist       S              1A
     D NumCExist       S              1A
     D PCtry           S              2A
     D WAccLine        S              1A
     D WProhibit       S              1A
     D WACLNE          S              1A                                                    MD035038
     D CSW221          S              1A                                                    MD055694
     D PSWIFT          S              6A                                                    MD055694
     D PRTCD           S              7A                                                    MD055694
     D WPrev           S              1S 0                                                  MD055694
     D WNext           S              1S 0                                                  MD055694
     D WExsLine        S              1S 0
     D IDX             S              1S 0
     D W               S              1S 0                                                  MD055694
     D X               S              1S 0
     D Y               S              1S 0
     D Z               S              3S 0
     D WCtr            S              3S 0

      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+

     D WInpArr         S             35A   DIM(4)
     D WTrnArr         S             35A   DIM(5)
     D WFmtArr         S             15A   DIM(5)
     D Alpha           S              1    DIM(26) CTDATA PERRCD(26)
     D Numeric         S              1    DIM(10) CTDATA PERRCD(10)

     D MEOUFM        E DS                  EXTNAME(MEOUFMPD)
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
     D SDNWRK        E DS                  EXTNAME(SDNWRKPD)
     D SDMTAG        E DS                  EXTNAME(SDMTAGPD)
     D SDCUST        E DS                  EXTNAME(SDCUSTPD)
     D SDACUS        E DS                  EXTNAME(SDACUSPD)
     D SDNOST        E DS                  EXTNAME(SDNOSTPD)
     D SDCTRY        E DS                  EXTNAME(SDCTRYPD)
     D SDACNT        E DS                  EXTNAME(ACCNTAB)
     D DSFDY         E DS                  EXTNAME(DSFDY)
     D DSLDY         E DS                  EXTNAME(DSLDY)
     D DSSDY         E DS                  EXTNAME(DSSDY)

     D InpParmDS       DS
     D  InpDS1                 1    140
     D  InpDS2                36    175
     D  InpDS3                71    175

     D AcctLine        DS
     D  WSlash                 1      1
     D  WISO                   2      3
     D  WInfo1                 2     35
     D  WInfo2                 4     35

     D AddrLine        DS
     D  WCodeN                 1      2
     D  WCode                  1      1
     D  WSlash1                2      2
     D  WInfoA1                3     35
     D  WISO2                  3      4
     D  WSlash2                5      5
     D  WInfoA2                6     35

     D FrmtLine        DS            75

      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
      *****************************************************************
      /EJECT
      *****************************************************************
     C
      ** +--- Start of Main processing -------------------------------+
      ** ¦                                                            ¦
      ** ¦ Initial processing is performed automatically: the *INZSR  ¦
      ** ¦ is executed at program activation.                         ¦
      ** ¦                                                            ¦
      ** +------------------------------------------------------------+

     C                   EVAL      PRetCode = *BLANKS
     C                   EVAL      PErrType = *BLANKS

     C                   SELECT

      ** Select process if called from Outgoing Message Field Mngt

     C                   WHEN      PCallFrom = 'OMFM'

     C                   EXSR      SrOMFM

      ** Select process if called from Transaction input valdiation

     C                   WHEN      PCallFrom = 'TRAN'

     C                   EXSR      SrTran

      ** Select process if called from Message Generation

     C                   WHEN      PCallFrom = 'FRMT'

     C                   EXSR      SrFrmt

     C                   ENDSL

      ** Set error type base on the return code

     C                   IF        PRetCode = '*ERROR'
     C                   EVAL      PErrType = 'E'
     C                   ELSEIF    PRetCode = '*WARN'
     C                   EVAL      PErrType = 'W'
     C                   ENDIF

      ** Exit program

     C                   EVAL      *INLR = *ON
     C                   RETURN
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SrOMFM - Validate format entry for Outgoing Msg Fmt Mangt     *
      *                                                               *
      *****************************************************************
     C     SrOMFM        BEGSR

     C                   EXSR      SrValidate

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SrTran - Validate format entry for Transaction Input          *
      *                                                               *
      *****************************************************************
     C     SrTran        BEGSR

      ** Validate message type and tags keys for OMFM checking

     C                   EXSR      SrOMKeys

      ** Save the number sequence from input

     C                   EXSR      SrTranSeq

      ** If an identifier is inserted, continue
      ** with the validation

     C                   IF        NumCExist = 'Y'

     C                   EXSR      SrLayOMFM

      ** Retrieve Flag for ACOUNTLINE and ACOUNTIBAN

     C                   EXSR      SrAccLine

      ** Validate identifier sequence and format

     C                   EXSR      SrValidate

     C                   IF        PRetCode <> '*ERROR'

      ** If *FORMAT is defined in OMFM but no matching layout
      ** found against the input

     C                   IF        WdOMFM = 'Y'
     C                             AND WLayFound = 'N'

      ** Issue error, Format is not configured

     C                   IF        SveFlg3 = 'M'
     C                   EVAL      PRetCode = '*ERROR'
     C                   EVAL      PMsgID = 'ME00328'

      ** Issue warning error, Format is not configured

     C                   ELSEIF    SveFlg3 = 'W'
     C                   EVAL      PRetCode = '*WARN'
     C                   EVAL      PMsgID = 'ME00335'
     C                   ENDIF

     C                   ENDIF
     C                   ENDIF
     C                   ENDIF

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SrFrmt - Validate format entry for Message Generation         *
      *                                                               *
      *****************************************************************
     C     SrFrmt        BEGSR

      ** Validate and extract details of account

     C                   IF        (%SUBST(PInpParm1:1:1) = '/'
     C                             AND PInpParm2 <> *BLANKS AND
     C                             InpDS3 = *BLANKS) OR
     C                             (PInpParm1 <> *BLANKS AND
     C                             InpDS2 = *BLANKS)

     C                   EXSR      SrValAccnt

     C                   IF        PRtnCode = *BLANKS

      ** Retrieve Flag for ACOUNTLINE and ACOUNTIBAN

     C                   EXSR      SrAccLine

      ** Extract layout from OMFM to output 59F

     C                   EXSR      SrLayOMFM

     C                   IF        PRetCode = *BLANKS
     C                   EVAL      POutParm1 = WOMFM1
     C                   EVAL      POutParm2 = WOMFM2
     C                   EVAL      POutParm3 = WOMFM3
     C                   EVAL      POutParm4 = WOMFM4
     C                   EVAL      POutParm5 = WOMFM5
     C                   ENDIF

     C                   ELSE                                                               MD034511
                                                                                            MD034511
      ** Input is an adress without the 59F format                                          MD034511
      ** No checking must be done                                                           MD034511
                                                                                            MD034511
     C                   EVAL      PRetCode = '*NRF '                                       MD034511
     C                   ENDIF

     C                   ELSE

      ** Input is an adress without the 59F format
      ** No checking must be done

     C                   EVAL      PRetCode = '*NRF '
     C                   ENDIF

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SrValidate - Validation of Code Sequence                      *
      *                                                               *
      * Called By: SrOMFM, SrTran                                     *
      *                                                               *
      *****************************************************************

     C     SrValidate    BEGSR

      ** First Line cannot be blanks

     C                   IF        PInpParm1 = *BLANKS
     C                   EVAL      PRetCode = '*ERROR'
     C                   EVAL      PMsgID = 'ME00307'
     C                   LEAVESR
     C                   ENDIF

      ** Line 1 must start with '/' for Account line
      ** and 1/ for Name and Address Line

     C                   IF        %SUBST(PInpParm1:1:1) <> '/' AND
     C                             %SUBST(PInpParm1:1:1) <> '1'
     C                   EVAL      PRetCode = '*ERROR'
     C                   EVAL      PMsgID = 'ME00308'
     C                   LEAVESR
     C                   ENDIF

      ** If Line 1 is a '/', validate account line

     C                   IF        %SUBST(PInpParm1:1:1) = '/'

     C                   EVAL      AcctLine = PInpParm1

      ** Validate ISO Country code if inserted

     C                   EVAL      WISOFlg = ' '
     C                   IF        WISO <> *BLANKS
     C                   EVAL      WISOFlg = 'Y'
     C                   EVAL      WISOC = WISO
     C     WISOC         CHAIN     MEISOCL0
     C                   IF        NOT %FOUND(MEISOCL0)
     C                   EVAL      WISOFlg = 'N'
     C                   ENDIF
     C                   ENDIF

      ** Call validation of accountline subroutines

     C                   IF        PCallFrom = 'OMFM'
     C                   EXSR      SrValAccO
     C                   ELSEIF    PCallFrom = 'TRAN'
     C                   EXSR      SrValAccT
     C                   ENDIF

      ** If error is encountered, do not continue with the
      ** other validation

     C                   IF        PRetCode = '*ERROR'
     C                   LEAVESR
     C                   ENDIF

      ** Move the input parameter 2-5 to array
      ** for the validation of address lines

     C                   MOVE      InpDS2        WInpDSA
     C                   EXSR      SrMoveArr

      ** Else if first character is Numeric

     C                   ELSE

     C                   IF        PCallFrom = 'TRAN'

      ** Account Line is Mandatory
      ** Account IBAN is Mandatory

     C                   IF        SveFlg1 = 'M'
     C                   EVAL      PRetCode = '*ERROR'
     C                   EVAL      PMsgID = 'ME00324'
     C                   LEAVESR
     C                   ELSEIF    SveFlg2 = 'M'
     C                   EVAL      PRetCode = '*ERROR'
     C                   EVAL      PMsgID = 'ME00332'
     C                   LEAVESR
     C                   ENDIF

      ** Warning: Account Line is not inserted
      ** Warning: Account IBAN is not inserted

     C                   IF        SveFlg1 = 'W'
     C                   EVAL      PRetCode = '*WARN '
     C                   EVAL      PMsgID = 'ME00325'
     C                   ELSEIF    SveFlg2 = 'W'
     C                   EVAL      PRetCode = '*WARN '
     C                   EVAL      PMsgID = 'ME00333'
     C                   ENDIF
     C                   ENDIF

      ** Move the input parameter 1-4 to array
      ** for the validation of address lines

     C                   MOVE      InpDS1        WInpDSA
     C                   EXSR      SrMoveArr

     C                   ENDIF

     C                   IF        PRetCode = '*ERROR'
     C                   LEAVESR
     C                   ENDIF

      ** Validate Name and Address lines

     C                   EXSR      SrValAdd

      ** Fifth line must be blanks if account line is not present

     C                   IF        PRetCode <> '*ERROR' AND
     C                             %SUBST(PInpParm1:1:1) <> '/'
     C                             AND PInpParm5 <> *BLANKS
     C                   EVAL      PRetCode = '*ERROR'
     C                   EVAL      PMsgID = 'ME00321'
     C                   ENDIF

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SrValAccO - Validate Account Line from OMFM                   *
      *                                                               *
      *****************************************************************

     C     SrValAccO     BEGSR

      ** If /XX, Account Line must be followed by a valid ISO
      ** country code

     C                   IF        WISOFlg = 'N'
     C                             OR WInfo2 <> *BLANKS
     C                   EVAL      PRetCode = '*ERROR'
     C                   EVAL      PMsgID = 'ME00309'
     C                   LEAVESR
     C                   ENDIF

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SrValAccT - Validate Account Line from Transaction Input      *
      *                                                               *
      *****************************************************************

     C     SrValAccT     BEGSR

      ** Account number of beneficiary must be stated in
      ** the account line

     C                   IF        WInfo1 = *BLANKS
     C                   EVAL      PRetCode = '*ERROR'
     C                   EVAL      PMsgID = 'ME00322'
     C                   LEAVESR

     C                   ELSE

      ** Save flag from ACOUNTIBAN and ACOUNTLINE

     C                   EVAL      WACLNE = 'N'                                             MD035038
     C                   EVAL      WIBANY = 'N'                                             MD035038
     C                   IF        WISOFlg = 'Y'
     C                             AND CFT004 = 'Y'
     C                   EVAL      PMAccount = %SUBST(PInpParm1:2)
     C                   EXSR      SrValIBAN

     C                   IF        WIBANY = 'Y'                                             MD034543
     C                             AND SveFlg2 <> *BLANKS                                   MD035038
     C                   EVAL      SaveFlag = SveFlg2
     C                   ELSE                                                               MD034543
     C                   EVAL      SaveFlag = SveFlg1                                       MD034543
     C                   EVAL      WACLNE = 'Y'                                             MD035038
     C                   ENDIF                                                              MD034543
     C                   ELSE
     C                   EVAL      SaveFlag = SveFlg1
     C                   EVAL      WACLNE = 'Y'                                             MD035038
     C                   ENDIF

      ** Account line or Account IBAN is prohibited

     C                   IF        SaveFlag = 'P'
     C**********         EVAL      PRetCode = '*ERROR'                                      MD035038
     C                   IF        WIBANY = 'Y'
     C                             AND WACLNE = 'N'                                         MD035038
     C                   EVAL      PMsgID = 'ME00331'
     C                   EVAL      PRetCode = '*ERROR'                                      MD035038
     C                   LEAVESR                                                            MD035038
     C**********         ELSE                                                               MD035038
     C                   ELSEIF    WACLNE = 'Y'                                             MD035038
     C                             AND WIBANY = 'N'                                         MD035038
     C                   EVAL      PMsgID = 'ME00323'
     C                   EVAL      PRetCode = '*ERROR'                                      MD035038
     C                   LEAVESR
     C                   ENDIF
     C                   ENDIF

      ** Account Line or Account IBAN is mandatory for line 1                               MD035038
      ** starting with '/'                                                                  MD035038
                                                                                            MD035038
     C                   IF        SveFlg2 = 'M'                                            MD035038
     C                             AND WIBANY = 'N'                                         MD035038
     C                   EVAL      PMsgID = 'ME00332'                                       MD035038
     C                   EVAL      PRetCode = '*ERROR'                                      MD035038
     C                   LEAVESR                                                            MD035038
     C                   ELSEIF    SveFlg1 = 'M'                                            MD035038
     C                             AND WIBANY = 'Y'                                         MD035038
     C                   EVAL      PMsgID = 'ME00324'                                       MD035038
     C                   EVAL      PRetCode = '*ERROR'                                      MD035038
     C                   LEAVESR                                                            MD035038
     C                   ENDIF                                                              MD035038
                                                                                            MD035038
      ** Warning: Account Line or Account IBAN is not inserted                              MD035038
      ** for line 1 starting with '/'                                                       MD035038
                                                                                            MD035038
     C                   IF        SveFlg2 = 'W'                                            MD035038
     C                             AND WIBANY = 'N'                                         MD035038
     C                   EVAL      PMsgID = 'ME00333'                                       MD035038
     C                   EVAL      PRetCode = '*WARN'                                       MD035038
     C                   LEAVESR                                                            MD035038
     C                   ELSEIF    SveFlg1 = 'W'                                            MD035038
     C                             AND WIBANY = 'Y'                                         MD035038
     C                   EVAL      PMsgID = 'ME00325'                                       MD035038
     C                   EVAL      PRetCode = '*WARN'                                       MD035038
     C                   LEAVESR                                                            MD035038
     C                   ENDIF                                                              MD035038
                                                                                            MD035038
     C                   ENDIF

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SrMoveArr - Move Input entry to an array and check for        *
      *             embedded blanks                                   *
      *                                                               *
      *****************************************************************

     C     SrMoveArr     BEGSR

     C                   EVAL      Num3Exist = 'N'
     C                   MOVEA     WInpDSA       WInpArr

      ** No embedded blanks must exist

     C                   IF        PCallFrom <> 'FRMT'
     C                   FOR       X = 4 DOWNTO 2
     C                   IF        WInpArr(X) <> *BLANKS
     C                             AND WInpArr(X-1) = *BLANKS
     C                   EVAL      PRetCode = '*ERROR'
     C                   EVAL      PMsgID = 'ME00310'
     C                   LEAVESR
     C                   ENDIF
     C                   IF        %SUBST(WInpArr(X):1:1) = '3'
     C                   EVAL      Num3Exist = 'Y'
     C                   ENDIF
     C
     C                   ENDFOR
     C                   ENDIF

      ** Save number of lines with values to be validated

     C                   EVAL      IDX = %LOOKUP(*BLANKS:WInpArr)
     C                   IF        IDX = 0
     C                   EVAL      IDX = 4
     C                   ELSE
     C                   EVAL      IDX = IDX - 1
     C                   ENDIF

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SrValAdd - Validate Address Line                              *
      *                                                               *
      *****************************************************************
     C     SrValAdd      BEGSR

     C                   FOR       X = 1 TO IDX
     C                   EVAL      AddrLine = WInpArr(X)

      ** The First line of Name and Address Line
      ** must start with number 1

     C                   IF        X = 1 and WCode <> '1'
     C                   EVAL      PRetCode = '*ERROR'
     C                   EVAL      PMsgID = 'ME00311'
     C                   LEAVESR
     C                   ENDIF

      ** Name and Address Lines must start with number in
      ** range 1 to 3, followed by a '/'

     C                   IF        %CHECK(NumCode:WCode) <> 0
     C                             OR WSlash1 <> '/'
     C                   EVAL      PRetCode = '*ERROR'
     C                   EVAL      PMsgID = 'ME00312'
     C                   LEAVESR
     C                   ENDIF

      ** Numbers in Name and Address Lines must appear in
      ** increasing Numerical order

     C                   IF        X > 1 AND
     C                             WCode < %SUBST(WInpArr(X-1):1:1)
     C                   EVAL      PRetCode = '*ERROR'
     C                   EVAL      PMsgID = 'ME00313'
     C                   LEAVESR
     C                   ENDIF

      ** Number 2 of Name and Address Lines must not
      ** be used without number 3
      ** If CSW221 is on, 3/ is now mandatory every input                                   MD055694

     C                   IF        CSW221 = 'N'                                             MD055694
     C                   IF        WCode = '2' AND
     C                             Num3Exist <> 'Y'
     C                   EVAL      PRetCode = '*ERROR'
     C                   EVAL      PMsgID = 'ME00314'
     C                   LEAVESR
     C                   ENDIF
     C                   ENDIF                                                              MD055694
                                                                                            MD055694
      ** Additional Name and Address lines validation

     C                   IF        PCallFrom = 'OMFM'
     C                   EXSR      SrValAddOMFM
     C                   ELSEIF    PCallFrom = 'TRAN'
     C                   EXSR      SrValAddTran
     C                   ENDIF

     C                   IF        PRetCode = '*ERROR'
     C                   LEAVESR
     C                   ENDIF

     C                   ENDFOR

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SrValAddOMFM - Additional Name and Address lines validation   *
      *                for OMFM                                       *
      *                                                               *
      *****************************************************************

     C     SrValAddOMFM  BEGSR

      ** No repeating numbers must exist

     C                   IF        X > 1
     C                   IF        WCode = %SUBST(WInpArr(X-1):1:1)
     C                   EVAL      PRetCode = '*ERROR'
     C                   EVAL      PMsgID = 'ME00320'
     C                   LEAVESR
     C                   ENDIF
     C                   ENDIF
                                                                                            MD055694
      ** If CSW221 is ON, number 3 is required                                              MD055694
     C                   IF        CSW221 = 'Y'                                             MD055694
     C                   IF        X = IDX AND                                              MD055694
     C                             Num3Exist <> 'Y'                                         MD055694
     C                   EVAL      PRetCode = '*ERROR'                                      MD055694
     C                   EVAL      PMsgID = 'MES0001'                                       MD055694
     C                   LEAVESR                                                            MD055694
     C                   ENDIF                                                              MD055694
     C                   ENDIF                                                              MD055694

      ** Validate format for number 3
      ** Format should be 3/XX/

     C                   IF        WCode = '3'

     C                   EVAL      WISOC = WISO2
     C     WISOC         CHAIN     MEISOCL0
     C                   IF        NOT %FOUND(MEISOCL0)
     C                             OR WSlash2 <> '/'
     C                             OR WInfoA2 <> *BLANKS
     C                   EVAL      PRetCode = '*ERROR'
     C                   EVAL      PMsgID = 'ME00316'
     C                   LEAVESR
     C                   ENDIF

     C                   ELSE

      ** Else Validate format for number 1 and 2
      ** Format should be 1/ or 2/

     C                   IF        WInfoA1 <> *BLANKS
     C                   EVAL      PRetCode = '*ERROR'
     C                   EVAL      PMsgID = 'ME00315'
     C                   LEAVESR
     C                   ENDIF

     C                   ENDIF

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SrValAddTran - Additional Name and Address lines validation   *
      *                for Transaction Input                          *
      *                                                               *
      *****************************************************************

     C     SrValAddTran  BEGSR

      ** Number 1 of Name and Address Lines must be followed by a
      ** '/' and followed by name of Beneficiary customer

     C                   IF        WCode = '1' AND
     C                             WInfoA1 = *BLANKS
     C                   EVAL      PRetCode = '*ERROR'
     C                   EVAL      PMsgID = 'ME00326'
     C                   LEAVESR
     C                   ENDIF

      ** Number 2 of Name and Address Lines must be followed by a
      ** '/' and followed by address of Beneficiary customer

     C                   IF        WCode = '2' AND
     C                             WInfoA1 = *BLANKS
     C                   EVAL      PRetCode = '*ERROR'
     C                   EVAL      PMsgID = 'ME00327'
     C                   LEAVESR
     C                   ENDIF

      ** SWIFT 2021: Lines starting with 1/, 2/ & 3/ must only occur twice                  MD055694
                                                                                            MD055694
     C                   Z-ADD     *ZERO         WPrev                                      MD055694
     C                   Z-ADD     *ZERO         WNext                                      MD055694
     C                   IF        CSW221 = 'Y' AND X > 1 AND                               MD055694
     C                             X < IDX                                                  MD055694
     C                   EVAL      WPrev = X - 1                                            MD055694
     C                   EVAL      WNext = X + 1                                            MD055694
     C                   IF        WCode = %SUBST(WInpArr(WPrev):1:1) AND                   MD055694
     C                             WCode = %SUBST(WInpArr(WNext):1:1)                       MD055694
     C                   EVAL      PRetCode = '*ERROR'                                      MD055694
     C                   EVAL      PMsgID = 'MES0002'                                       MD055694
     C                   LEAVESR                                                            MD055694
     C                   ENDIF                                                              MD055694
     C                   ENDIF                                                              MD055694
      *                                                                                     MD055694
      ** SWIFT 2021: A line starting with '3/' must be present.                             MD055694
      *                                                                                     MD055694
     C                   IF        CSW221 = 'Y' AND X = IDX AND                             MD055694
     C                             Num3Exist <> 'Y'                                         MD055694
     C                   EVAL      PRetCode = '*ERROR'                                      MD055694
     C                   EVAL      PMsgID = 'MES0001'                                       MD055694
     C                   LEAVESR                                                            MD055694
     C                   ENDIF                                                              MD055694
                                                                                            MD055694
      ** Validate format for number 3

     C                   IF        WCode = '3'

     C                   IF        %SUBST(WInpArr(X-1):1:1) <> '3'
     C                   EVAL      WISOC = WISO2
     C     WISOC         CHAIN     MEISOCL0

      ***First*occurrence*of*number*3**********************************                     MD037229
      ***Format*should*be*3/XX/yyyyyy**********************************                     MD037229
      **********                                                                            MD037229
     C**********         IF        %SUBST(WInpArr(X-1):1:1) = '2'                           MD037229
      **********                                                                            MD037229
     C**********         IF        NOT %FOUND(MEISOCL0)                                     MD037229
     C**********                   OR WSlash2 <> '/'                                        MD037229
     C**********                   OR WInfoA2 = *BLANKS                                     MD037229
     C**********         EVAL      PRetCode = '*ERROR'                                      MD037229
     C**********         EVAL      PMsgID = 'ME00317'                                       MD037229
     C**********         LEAVESR                                                            MD037229
     C**********         ENDIF                                                              MD037229
      **********                                                                            MD037229
     C**********         ELSE                                                               MD037229

      ** Format should be 3/XX or 3/XX/yyyyyy

     C                   IF        NOT %FOUND(MEISOCL0)
     C                             OR (WSlash2 <> *BLANKS
     C                             AND WSlash2 <> '/')
     C                             OR (WSlash2 = *BLANKS
     C                             AND WInfoA2 <> *BLANKS)
     C                             OR (WSlash2 = '/'
     C                             AND WInfoA2 = *BLANKS)
     C                   EVAL      PRetCode = '*ERROR'
     C                   EVAL      PMsgID = 'ME00318'
     C                   LEAVESR
     C                   ENDIF

     C**********         ENDIF                                                              MD037229

     C                   ELSE

      ** Other occurrence of nunmber 3
      ** Format should be 3/yyyyyy

     C                   IF        WInfoA1 = *BLANKS
     C                             OR WSlash2= '/'
     C                   EVAL      PRetCode = '*ERROR'
     C                   EVAL      PMsgID = 'ME00319'
     C                   LEAVESR
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SrAccLine - Validation of ACOUNTLINE and ACOUNTIBAN           *
      *                                                               *
      *****************************************************************
     C     SrAccLine     BEGSR

     C                   EVAL      POption = '*KEY   '
     C                   EVAL      SaveFlag = *BLANKS

      ** Retrieve Flag for ACOUNTLINE if defined in OMFM

     C                   EVAL      PAction = 'ACOUNTLINE'
     C                   EXSR      SrOMFMAct
     C                   IF        SaveFlag <> *BLANKS
     C                   EVAL      SveFlg1 = SaveFlag
     C                   ENDIF

      ** Retrieve Flag for ACOUNTIBAN if defined in OMFM

     C                   IF        CFT004 = 'Y'
     C                   EVAL      PAction = 'ACOUNTIBAN'
     C                   EVAL      SaveFlag = *BLANKS
     C                   EXSR      SrOMFMAct
     C                   IF        SaveFlag <> *BLANKS
     C                   EVAL      SveFlg2 = SaveFlag
     C                   ENDIF
     C                   ENDIF

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SrSaveSeq - Save sequence eliminationg the repeating codes    *
      *                                                               *
      *****************************************************************
     C     SrSaveSeq     BEGSR

     C                   IF        X = 1 OR
     C                             (X > 1 AND WCode <>
     C                             %SUBST(WTrnArr(X-1):1:1))
     C                   IF        WCode = '/'
     C                   EVAL      WLayOut = WCode
     C                   ELSE
     C                   EVAL      WLayOut = WCodeN
     C                   ENDIF
     C                   EXSR      SrTranOM
     C                   ENDIF

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SrTranOM - Save codes to be used in comparing input against   *
      *            OMFM defined layout                                *
      *                                                               *
      *****************************************************************
     C     SrTranOM      BEGSR

     C                   SELECT
     C                   WHEN      WOMFM1 = *BLANKS
     C                   EVAL      WOMFM1 = WLayOut

     C                   WHEN      WOMFM2 = *BLANKS
     C                   EVAL      WOMFM2 = WLayOut

     C                   WHEN      WOMFM3 = *BLANKS
     C                   EVAL      WOMFM3 = WLayOut

     C                   WHEN      WOMFM4 = *BLANKS
     C                   EVAL      WOMFM4 = WLayOut

     C                   WHEN      WOMFM5 = *BLANKS
     C                   EVAL      WOMFM5 = WLayOut
     C                   ENDSL

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SrOMKeys - Validate OMFM parameters                           *
      *                                                               *
      *****************************************************************
     C     SrOMKeys      BEGSR

      ** Validate Network

     C                   IF        PNetwork <> *BLANKS
     C                   CALL      'AONWRKR0'
     C                   PARM      *BLANKS       PRtnCode
     C                   PARM      '*KEY'        POption
     C                   PARM                    PNetwork
     C     SDNWRK        PARM      SDNWRK        DSLDY

     C                   IF        PRtnCode <> *BLANKS
     C                   EVAL      PMsgID = 'ME00329'
     C                   LEAVESR
     C                   ENDIF
     C                   ENDIF

      ** Validate Message Tag and Type

     C                   IF        PMsgTag = *BLANKS
     C                   EVAL      PMsgTag = ':59F:'
     C                   ENDIF

     C                   CALL      'AOMTAGR0'
     C                   PARM      *BLANKS       PRtnCode
     C                   PARM      '*KEY'        POption
     C                   PARM                    PMsgTag
     C                   PARM                    PMsgType
     C     SDMTAG        PARM      SDMTAG        DSLDY
     C
     C                   IF        PRtnCode <> *BLANKS
     C                   EVAL      PMsgID = 'ME00330'
     C                   LEAVESR
     C                   ENDIF

     C                   IF        PMsgID <> *BLANKS
     C                   EVAL      PRetCode = '*WARN'
     C                   ENDIF
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SrLayOMFM - Extract Layout in OMFM                            *
      *                                                               *
      *****************************************************************
     C     SrLayOMFM     BEGSR

      ** Check OMFM with *FORMAT action

     C                   EVAL      PAction = '*FORMAT'
     C                   EVAL      POption = '*KEY'
     C                   EVAL      WdOMFM = 'N'
     C                   EVAL      WLayFound = 'N'

     C                   EXSR      SrOMFMAct

      ** If return code is not blanks, no OMFM entry
      ** has been defined for 59F for MT 103

     C                   IF        PRtnCode <> *BLANKS
     C                   EVAL      PRetCode = '*NRF '
     C                   LEAVESR
     C                   ENDIF

      ** Else if an OMFM record is found, check for the
      ** layout

     C                   DOW       PRtnCode <> '*EOF' AND
     C                             PRtnCode <> '*ERROR' AND
     C                             PRtnCode <> '*NRF' AND
     C                             WLayFound <> 'Y'

     C                   EVAL      WdOMFM = 'Y'
     C                   EVAL      SveFlg3 = OMFLAG

      ** For Transaction Input, check if there is a
      ** matching layout in OMFM

     C                   IF        PCallFrom = 'TRAN'
     C                             AND %SUBST(OM50F1:1:2) = WOMFM1
     C                             AND %SUBST(OM50F2:1:2) = WOMFM2
     C                             AND %SUBST(OM50F3:1:2) = WOMFM3
     C                             AND %SUBST(OM50F4:1:2) = WOMFM4
     C                             AND %SUBST(OM50F5:1:2) = WOMFM5
     C                   EVAL      WLayFound = 'Y'
     C                   ENDIF

      ** For Message Generation, check if account
      ** details matches the layout in OMFM

     C                   IF        PCallFrom = 'FRMT'
     C                   EVAL      WLayFound = 'Y'
     C                   EVAL      PRetCode = *BLANKS
     C                   EXSR      SrFmtMatch
     C                   ENDIF

      ** Check for the next layout, if the details is not
      ** enough to output 59F

     C                   IF        WLayFound <> 'Y'
     C                   EVAL      POption = '*NEXTEQ'
     C                   IF        PCallFrom = 'FRMT'
     C                   EVAL      WOMFM1 = *BLANKS
     C                   EVAL      WOMFM2 = *BLANKS
     C                   EVAL      WOMFM3 = *BLANKS
     C                   EVAL      WOMFM4 = *BLANKS
     C                   EVAL      WOMFM5 = *BLANKS
     C                   ENDIF
     C                   EXSR      SrOMFMAct
     C                   ENDIF

     C                   ENDDO

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SrOMFMAct - Call AOOUFMR0 to extract OMFM layout details      *
      *                                                               *
      *****************************************************************
     C     SrOMFMAct     BEGSR

     C                   CALL      'AOOUFMR0'
     C                   PARM      *BLANKS       PRtnCode
     C                   PARM                    POption
     C                   PARM                    PNetwork
     C                   PARM                    PMsgType
     C                   PARM                    PMsgTag
     C                   PARM      PBranch       PBranch4
     C                   PARM      PCountry      PCountry4
     C                   PARM                    PCurrCde
     C                   PARM                    PNostro
     C                   PARM                    PAction
     C     MEOUFM        PARM      MEOUFM        DSSDY

     C                   IF        PRtnCode = *BLANKS
     C                   EVAL      SaveFlag = OMFLAG
     C                   ENDIF

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SrValAccnt - Validate and extract details of account          *
      *                                                               *
      *****************************************************************
     C     SrValAccnt    BEGSR

     C                   EVAL      WIBANY = 'N'
     C                   EVAL      WAccLine = 'N'
     C                   IF        %SUBST(PInpParm1:1:1) = '/'
     C                   EVAL      WAccLine = 'Y'
     C                   IF        PInpParm2 = *BLANKS
     C                   EVAL      PMAccount = %SUBST(PInpParm1:2)
     C                   ELSE
     C                   EVAL      PMAccount = PInpParm2
     C                   ENDIF
     C                   ELSE
     C                   EVAL      PMAccount = PInpParm1
     C                   ENDIF

     C                   CALL      'AOACCTV1'
     C                   PARM      *BLANKS       PRtnCode
     C                   PARM      *BLANKS       PAccType
     C                   PARM                    PMAccount
     C                   PARM                    DSSDY

     C                   IF        PRtnCode = *BLANKS

      ** If valid account, save the customer number

     C                   SELECT
     C                   WHEN      PAccType = '*RETAIL'
     C                             OR PAccType = '*LEDGER'
     C                   MOVEL     DSSDY         SDACNT
     C                   MOVEL     CNUM          PCustA

     C                   WHEN      PAccType = '*NOSTRO'
     C                   MOVEL     DSSDY         SDNOST
     C                   MOVEL     A7CUST        PCustA

     C                   WHEN      PAccType = '*CUSTNO'
     C                             OR PAccType = '*SHNAME'
     C                   MOVEL     DSSDY         SDCUST
     C                   MOVEL     BBCUST        PCustA

     C                   ENDSL

     C                   ELSE

      ** Check if account is a valid IBAN

     C                   IF        CFT004 = 'Y'
     C                   EXSR      SrValIBAN
     C                   ENDIF

     C                   ENDIF

      ** Retrieve Customer Details

     C                   IF        PCustA <> *BLANKS
     C                   EXSR      SrGetCus
     C                   ENDIF

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SrValIBAN - Validate and extract details of IBAN account      *
      *                                                               *
      *****************************************************************
     C     SrValIBAN     BEGSR
     C
     C                   EVAL      PIBAN = PMAccount
     C                   CALL      'AOIBANR3'
     C                   PARM                    PRtnCode
     C                   PARM                    PIBAN
     C                   PARM                    POWith
     C     WIBANR        PARM                    PONobl

     C                   EVAL      WIBCH1 = %SUBST(WIBANR:1:1)
     C                   EVAL      WIBCH2 = %SUBST(WIBANR:2:1)
     C                   EVAL      WIBNU1 = %SUBST(WIBANR:3:1)
     C                   EVAL      WIBNU1 = %SUBST(WIBANR:4:1)
     C     WIBCH1        LOOKUP    Alpha                                  94
     C   94WIBCH2        LOOKUP    Alpha                                  94
     C   94WIBNU1        LOOKUP    Numeric                                94
     C   94WIBNU1        LOOKUP    Numeric                                94

     C                   IF        *IN94 = *ON
     C                   CALL      'AOIBANR2'
     C                   PARM      *BLANKS       PRtnCode
     C                   PARM                    PMAccount
     C     SDACNT        PARM      *BLANKS       DSSDY

     C                   IF        PRtnCode = *BLANKS
     C                   EVAL      WIBANY = 'Y'
     C                   MOVEL     CNUM          PCustA
     C                   ENDIF

     C                   ENDIF

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SrGetCus - Get the customer details                           *
      *                                                               *
      *****************************************************************
     C     SrGetCus      BEGSR

      ** Retrieve Customer details

     C                   CALL      'AOCUSTR0'
     C                   PARM      *BLANKS       PRtnCode
     C                   PARM      '*KEY'        POption
     C                   PARM                    PCustA
     C                   PARM                    PCKyst
     C     SDCUST        PARM      *BLANKS       DSSDY

     C                   IF        PRtnCode <> *BLANKS
     C                   EVAL      PRetCode = '*NRF'
     C                   ELSE

      ** Retrieve the ISO Country code of Country of Location

     C                   EVAL      PCtry = BBCOLC
     C                   CALL      'AOCTRYR0'
     C                   PARM      *BLANKS       PRtnCde2
     C                   PARM      '*KEY   '     POption
     C                   PARM                    PCtry
     C     SDCTRY        PARM      SDCTRY        DSSDY
     C                   ENDIF


      ** Retrieve Additional Customer Details

     C                   CALL      'AOACUSR0'
     C                   PARM      *BLANKS       PRtnCde2
     C                   PARM      '*KEY'        POption
     C                   PARM                    PCustA
     C     SDACUS        PARM      SDACUS        DSLDY

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SrFormat - Format output parameter                            *
      *                                                               *
      *****************************************************************
     C     SrFormat      BEGSR

     C                   SELECT

      ** '/' must be followed by the inserted account line

     C                   WHEN      WCode = '/'
     C                   EVAL      WFrmtL = PInpParm1

      ** '1/' must be followed by Customer Name
      ** and Address Lines 1 and 2

     C                   WHEN      WCode = '1'

     C                   IF        E5CNA2 <> *BLANKS
     C                   EVAL      WFrmtL = WCodeN + %TRIM(E5CNA1)
     C                              + ' ' + %TRIM(E5CNA2)
     C                   ELSEIF    E5CNA1 <> *BLANKS
     C                   EVAL      WFrmtL = WCodeN + %TRIM(E5CNA1)
     C                   ELSE
     C                   EVAL      WFrmtL = WCodeN + %TRIM(BBCNA1)
     C                   ENDIF

      ** '2/' must be followed by Customer Name
      ** and Address Lines 3 and 4

     C                   WHEN      WCode = '2'

     C                   IF        E5CNA4 <> *BLANKS
     C                   EVAL      WFrmtL = WCodeN + %TRIM(E5CNA3)
     C                              + ' ' + %TRIM(E5CNA4)
     C                   ELSEIF    E5CNA3 <> *BLANKS
     C                   EVAL      WFrmtL = WCodeN + %TRIM(E5CNA3)
     C                   ELSE
     C                   EVAL      WFrmtL = WCodeN + %TRIM(BBCNA2)
     C                   ENDIF

      ** '3/' must be followed by ISO Country Code
      ** City and ZipCode

     C                   WHEN      WCode = '3'

     C                   IF        E5CITY <> *BLANKS
     C                   EVAL      WFrmtL = WCodeN + %TRIM(A4ISOC)
     C                              + '/' + %TRIM(E5CITY)
     C                              + ' ' + %TRIM(E5ZIPC)
     C                   ELSE
     C                   EVAL      WFrmtL = WCodeN + %TRIM(A4ISOC)
     C                                + '/' + %TRIM(BBCRTN)
     C                   ENDIF

     C                   ENDSL

     C                   EVAL      AddrLine = WFrmtL

      ** If not enough information, set return code to error

     C                   IF        WInfoA1 = *BLANKS
     C                   EVAL      PRetCode = '*NRF'
     C                   ELSE

      ** Else, save the format to output parameter
      ** and check for excess lines

     C                   EVAL      WLayOut = WFrmtL
     C                   EXSR      SrTranOM
     C                   EXSR      SrExcess
     C                   ENDIF

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SrExcess - Check excess characters to ouput in next line      *
      *                                                               *
      *****************************************************************
     C     SrExcess      BEGSR

     C                   EVAL      WCtr = 35
     C                   IF        CSW221 = 'Y'                                             MD055694
     C                   EVAL      W = 1                                                    MD055694
     C                   ELSE                                                               MD055694
     C                   EVAL      W = 5                                                    MD055694
     C                   ENDIF                                                              MD055694
                                                                                            MD055694
     C**********         FOR       Y = 1 TO 5                                               MD055694
     C                   FOR       Y = 1 TO W                                               MD055694
     C                   EVAL      Z = %CHECKR(' ':WFrmtL)

     C                   IF        Z > WCtr
     C                             AND %SUBST(WFrmtL:WCtr+1:35) <> *BLANKS
     C                             AND WExsLine > 0
     C                   EVAL      WLayOut = WCodeN +
     C                             %SUBST(WFrmtL:WCtr+1:33)
     C                   EVAL      WCtr = WCtr + 33
     C                   EVAL      WExsLine = WExsLine - 1
     C                   EXSR      SrTranOM

     C                   ELSE
     C                   LEAVESR
     C                   ENDIF

     C                   ENDFOR

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SrTranSeq - Transaction sequence number                       *
      *                                                               *
      *****************************************************************
     C     SrTranSeq     BEGSR

     C                   EVAL      NumCExist = 'N'
     C                   MOVEA     InpParmDS     WTrnArr

     C                   FOR       X = 1 TO 5
     C                   EVAL      AddrLine = WTrnArr(X)

     C                   EXSR      SrSaveSeq

      ***Check*if*code*1*to*3*is*inserted*to*continue*******************                    MD038302
      ***with*59F*validation********************************************                    MD038302

     C**********         IF        %CHECK(NumCode:WCode) = 0                                MD038302
     C**********                   AND WSlash1 = '/'                               MD034605 MD038302
     C**********         EVAL      NumCExist = 'Y'                                          MD038302
     C**********         ENDIF                                                              MD038302
      ** Check if first non-account line begins with '1/'                                   MD038302
     C                   IF        X < 3 AND                                                MD038302
     C                             WCodeN = '1/'                                            MD038302
     C                   EVAL      NumCExist = 'Y'                                          MD038302
     C                   ENDIF                                                              MD038302
     C                   ENDFOR

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SrFmtMatch - Check if layout is a match and have enough       *
      *              information to output 59F                        *
      *                                                               *
      *****************************************************************
     C     SrFmtMatch    BEGSR

      ** Check number of allowed excess line

     C                   EVAL      WExsLine = 0
     C                   SELECT
     C                   WHEN      OM50F2 = *BLANKS
     C                   EVAL      WExsLine = 4
     C                   WHEN      OM50F3 = *BLANKS
     C                   EVAL      WExsLine = 3
     C                   WHEN      OM50F4 = *BLANKS
     C                   EVAL      WExsLine = 2
     C                   WHEN      OM50F5 = *BLANKS
     C                   EVAL      WExsLine = 1
     C                   ENDSL

     C                   EXSR      SRAccIBAN                                                MD035038
     C                   EVAL      WProhibit = 'N'
     C                   IF        (WIBANY = 'Y' AND SveFlg2 = 'P')
     C                             OR (WIBANY = 'N' AND SveFlg1 = 'P')
     C                   EVAL      WProhibit = 'Y'
     C                   ENDIF
     C
      ** Do not use layout with account line if existing
      ** ACOUNTLINE or ACOUNTIBAN is flagged as Prohibited
      ** or an Account line is not specified in the input

     C                   IF        %SUBST(OM50F1:1:1) = '/'
     C                   IF        WProhibit = 'Y' OR WAccLine = 'N'
     C                   EVAL      PRetCode = '*NRF'
     C                   EVAL      WLayFound = 'N'
     C                   LEAVESR
     C                   ENDIF

     C                   ELSE

      ** If account line is specified in the input,
      ** output it as part of the layout

     C                   IF        WAccLine = 'Y' AND WProhibit = 'N'
     C                   EVAL      WLayOut = PInpParm1
     C                   EXSR      SrTranOM
     C                   IF        WExsLine > 0
     C                   EVAL      WExsLine = WExsLine - 1
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF

      ** Start formatting based on the extracted layout from OMFM

     C                   EVAL      FrmtLine = OM50F1 + OM50F2
     C                             + OM50F3 + OM50F4 + OM50F5
     C                   MOVEA     FrmtLine      WFmtArr
     C                   EVAL      IDX = %LOOKUP(*BLANKS:WFmtArr)

     C                   IF        IDX = 0
     C                   EVAL      IDX = 5
     C                   ELSE
     C                   EVAL      IDX = IDX - 1
     C                   ENDIF

     C                   FOR       X = 1 TO IDX
     C                   EVAL      AddrLine = WFmtArr(X)
     C                   EXSR      SrFormat
     C                   IF        PRetCode <> *BLANKS
     C                   EVAL      WLayFound = 'N'
     C                   LEAVESR
     C                   ENDIF
     C                   ENDFOR

     C                   ENDSR
      *****************************************************************                     MD035038
      /EJECT                                                                                MD035038
      *****************************************************************                     MD035038
      *                                                               *                     MD035038
      * SRAccIBAN - Determine if Account IBAN is inserted             *                     MD035038
      *                                                               *                     MD035038
      *****************************************************************                     MD035038
     C     SRAccIBAN     BEGSR                                                              MD035038
     C                   EVAL      WIBANY = 'N'                                             MD035038
                                                                                            MD035038
     C                   EVAL      Acctline = PInpParm1                                     MD035038
     C                   IF        WSlash = '/'                                             MD035038
     C                   EVAL      WISOFlg = ' '                                            MD035038
     C                   IF        WISO <> *BLANKS                                          MD035038
     C                   EVAL      WISOFlg = 'Y'                                            MD035038
     C                   EVAL      WISOC = WISO                                             MD035038
     C     WISOC         CHAIN     MEISOCL0                                                 MD035038
     C                   IF        NOT %FOUND(MEISOCL0)                                     MD035038
     C                   EVAL      WISOFlg = 'N'                                            MD035038
     C                   ENDIF                                                              MD035038
     C                   ENDIF                                                              MD035038
     C                   IF        WISOFlg = 'Y'                                            MD035038
     C                             AND CFT004 = 'Y'                                         MD035038
     C                   EVAL      PMAccount = %SUBST(PInpParm1:2)                          MD035038
     C                   EXSR      SrValIBAN                                                MD035038
     C                   ENDIF                                                              MD035038
     C                   ENDIF                                                              MD035038
     C                   ENDSR                                                              MD035038
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * *INZSR - Program Initialisation routine                       *
      *                                                               *
      * Called by: Main processing                                    *
      *                                                               *
      *                                                               *
      *****************************************************************

     C     *INZSR        BEGSR

     C     *ENTRY        PLIST
     C                   PARM                    PRetCode
     C                   PARM                    PCallFrom
     C                   PARM                    PInpParm1
     C                   PARM                    PInpParm2
     C                   PARM                    PInpParm3
     C                   PARM                    PInpParm4
     C                   PARM                    PInpParm5
     C                   PARM                    PNetwork
     C                   PARM                    PMsgType
     C                   PARM                    PMsgTag
     C                   PARM                    PBranch
     C                   PARM                    PCountry
     C                   PARM                    PCurrCde
     C                   PARM                    PNostro
     C                   PARM                    POutParm1
     C                   PARM                    POutParm2
     C                   PARM                    POutParm3
     C                   PARM                    POutParm4
     C                   PARM                    POutParm5
     C                   PARM                    PMsgID
     C                   PARM                    PErrType

      ** International Bank Account Number

     C                   EVAL      CFT004 = 'N'
     C                   CALL      'AOSARDR0'
     C                   PARM      *BLANKS       PRetCode
     C                   PARM      '*VERIFY'     POption
     C                   PARM      'CFT004'      PMSard

     C                   IF        PRetCode = *BLANKS
     C                   EVAL      CFT004 = 'Y'
     C                   ENDIF

     C                   EVAL      InpParmDS = PInpParm1 +
     C                             PInpParm2 + PInpParm3 +
     C                             PInpParm4 + PInpParm5
                                                                                            MD055694
     C                   CALL      'SWIFTACTV'                                              MD055694
     C                   PARM      'CSW221'      PSWIFT                                     MD055694
     C                   PARM      *BLANKS       PRTCD                                      MD055694
      *                                                                                     MD055694
     C     PRTCD         IFEQ      'CSWACTV'                                                MD055694
     C                   MOVE      'Y'           CSW221                                     MD055694
     C                   ELSE                                                               MD055694
     C                   MOVE      'N'           CSW221                                     MD055694
     C                   ENDIF                                                              MD055694
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      ** Program, module and procedure names for database error processing.
      ** =================================================================
      ** The following /COPY sets these values, and also defines LDA as
      ** an external data area
      ********************************************************************
     C/COPY ZACPYSRC,PSSR_ILE
      ********************************************************************
**  CPY@
(c) Finastra International Limited 2015
**  Alpha - Array of Alphabetic characters
ABCDEFGHIJKLMNOPQRSTUVWXYZ
**  Numeric - Array of Numeric characters
0123456789
