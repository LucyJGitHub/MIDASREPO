     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2019')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas MG SWIFT2019 J Format')                          *
      *****************************************************************
      *                                                               *
      *  Midas - Message Management Module                            *
      *                                                               *
      *  MG001002 - Midas MG J Format Mapping                         *
      *                                                               *
      *  (c) Finastra International Limited 2019                      *
      *                                                               *
      *  Last Amend No. CSW219  *CREATE    Date 04Mar19               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CSW219 - SWIFT Changes 2019                                  *
      *                                                               *
      *                                                               *
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+

      *****************************************************************
      /EJECT
      *****************************************************************

      ** +--------------------------------------+
      ** ¦ Automatically included D-specs       ¦
      ** ¦ ==============================       ¦
      ** +--------------------------------------+

      ** Data Area Giving Installation Control Details
     D/COPY ZACPYSRC,STD_D_SPEC

      ** Include the MM standard declares
     D/COPY ZACPYSRC,STDDECLARE

      ** Program Status Data Structure
      ** =============================
      ** The following /COPY line includes all the defined fields in
      ** the PSDS.  They have meaningful names, prefixed by 'PS'.

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

     D SValK1          C                   CONST('MT300JFldAddressOvr')
     D SValK2          C                   CONST('MT300UseLEIJFld')
     D SValK3          C                   CONST('MT300LEIorAddress')
     D SValK4          C                   CONST('ReplaceJFormatSlash')

      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+

      **  Data Structure for Customer Details
     D SDCUST        E DS                  EXTNAME(SDCUSTPD)

      ** Data Structure for Additional Customer Details
     D SDACUS        E DS                  EXTNAME(SDACUSPD)

      ** Data structure for Customer Extensions SWIFT Details
     D SDCSSW        E DS                  EXTNAME(SDCSSWPD)

      ** Data structure for counterparty nostro file
     D SDCNST        E DS                  EXTNAME(SDCNSTPD)

     D DSLDY         E DS                  EXTNAME(DSLDY)
     D DSFDY         E DS                  EXTNAME(DSFDY)

     D CustDetails     DS           171
     D  DtlName                1     34
     D  DtlAdd1               35     68
     D  DtlAdd2               69    102
     D  DtlCity              103    136
     D  AcctLine             137    171

      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+

      ** Parameter Variables to call 'AOSVALR0'

     D PSValK1         S             20A
     D PSValK2         S             20A
     D PSValK3         S             20A
     D PSValK4         S             20A
     D PSValK5         S             20A
     D PSValK6         S             20A
     D PSValK7         S             20A
     D PSValK8         S             20A
     D PSValK9         S             20A
     D PSValK10        S             20A
     D PSVal1          S            200A
     D PSVal2          S            200A
     D PSVal3          S            200A
     D PSVal4          S            200A
     D PSVal5          S            200A
     D PSVal6          S            200A
     D PSVal7          S            200A
     D PSVal8          S            200A
     D PSVal9          S            200A
     D PSVal10         S            200A

      ** Parameter List
     D PCustomer       S             10A
     D PAcctLine       S             35A
     D PLine1          S             40A
     D PLine2          S             40A
     D PLine3          S             40A
     D PLine4          S             40A
     D PLine5          S             40A

      ** Work Variables
     D WFldAddOvr      S              1A
     D WUseLeiFld      S              1A
     D WLeiorAddr      S              1A
     D WRepSlash       S              1A
     D PRtcd           S              7A
     D PRtnCode        S              7A
     D PRtnCde2        S              7A
     D POption         S              7A
     D PCustA          S             10A
     D PMStat          S              7A
     D PCNCD           S              8A
     D WLen            S              5S 0
     D WStr            S              5S 0
     D CheckSlash      S              5S 0
     D CptyNostro      S              1A
     D PosBlank        S              3S 0
     D WName1          S             70A
     D WName2          S             70A
     D Slash           S              1A

      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
      ****************************************************************
      /EJECT
      ****************************************************************

      ** +--- Start of Main processing -------------------------------+
      ** ¦                                                            ¦
      ** ¦ Initial processing is performed automatically: the *INZSR  ¦
      ** ¦ is executed at program activation.                         ¦
      ** ¦                                                            ¦
      ** +------------------------------------------------------------+

      *****************************************************************
      * MAIN PROCEDURE                                                *
      *****************************************************************

      ** Retrieve Customer Details
     C                   EXSR      SrGetCus

      ** Determine the Address Information to be used
     C                   EXSR      SrAddressInfo

      ** Replacement character for slash in J format fields
     C                   EXSR      SrRepSlash

      ** Format tag J
     C                   EXSR      SrFormatJ

     C                   EVAL      *INLR = *ON
     C                   RETURN

      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * *INZSR - Program Initialisation Routine                       *
      *                                                               *
      *****************************************************************

     C     *INZSR        BEGSR

     C     *ENTRY        PLIST
     C                   PARM                    PCustomer
     C                   PARM                    PAcctLine
     C                   PARM                    PLine1
     C                   PARM                    PLine2
     C                   PARM                    PLine3
     C                   PARM                    PLine4
     C                   PARM                    PLine5

     C                   EVAL      DBPGM = 'MG001002'

     C                   CALL      'AOSVALR0'
     C                   PARM      *BLANKS       PRtcd
     C                   PARM      SValK1        PSValK1
     C                   PARM                    PSVal1
     C                   PARM      SValK2        PSValK2
     C                   PARM                    PSVal2
     C                   PARM      SValK3        PSValK3
     C                   PARM                    PSVal3
     C                   PARM      SValK4        PSValK4
     C                   PARM                    PSVal4
     C                   PARM      *BLANKS       PSValK5
     C                   PARM                    PSVal5
     C                   PARM      *BLANKS       PSValK6
     C                   PARM                    PSVal6
     C                   PARM      *BLANKS       PSValK7
     C                   PARM                    PSVal7
     C                   PARM      *BLANKS       PSValK8
     C                   PARM                    PSVal8
     C                   PARM      *BLANKS       PSValK9
     C                   PARM                    PSVal9
     C                   PARM      *BLANKS       PSValK10
     C                   PARM                    PSVal10

     C                   IF        PRtcd <> *BLANKS

     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE = 'SDSVALPD'

     C                   IF        PSVal1 = '*NRF  '
     C                   EVAL      DBASE = 001
     C                   EVAL      DBKEY = %TRIM(SValK1)
     C                   ENDIF

     C                   IF        PSVal2 = '*NRF  '
     C                   EVAL      DBASE = 002
     C                   EVAL      DBKEY = %TRIM(SValK2)
     C                   ENDIF

     C                   IF        PSVal3 = '*NRF  '
     C                   EVAL      DBASE = 003
     C                   EVAL      DBKEY = %TRIM(SValK3)
     C                   ENDIF

     C                   IF        PSVal4 = '*NRF  '
     C                   EVAL      DBASE = 004
     C                   EVAL      DBKEY = %TRIM(SValK4)
     C                   ENDIF

     C                   OUT       LDA
     C                   EXSR      *PSSR

     C                   ELSE
     C                   EVAL      WFldAddOvr = PSVal1
     C                   EVAL      WUseLeiFld = PSVal2
     C                   EVAL      WLeiorAddr = PSVal3
     C                   EVAL      WRepSlash = PSVal4
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

      ** Initially check for counterparty nostro.
     C                   EVAL      PCNCD = Pcustomer
     C                   EVAL      CptyNostro = 'N'
      *
     C                   CALL      'AOCNSTR0'
     C                   PARM      *BLANKS       PRtnCode
     C                   PARM      '*KEY'        POption
     C                   PARM                    PCNCD
     C     SDCNST        PARM      SDCNST        DSFDY
      *
      ** If found set C/party nostro to "Y"
      *
     C                   IF        PRtnCode = *BLANKS
     C                   EVAL      CptyNostro = 'Y'

     C                   ELSE
      ** Retrieve Customer details

     C                   EVAL      PCustA = PCustomer

     C                   Call      'AOCSSWR0'
     C                   Parm      *Blanks       PRtnCode
     C                   Parm      '*KEY'        POption
     C                   Parm                    PCustA
     C                   Parm                    PMStat
     C                   Parm                    DSLDY

     C                   IF        PRtnCode <> *Blanks
     C                   EVAL      DBKEY = 'SDCSSWPD'
     C                   EVAL      DBASE  = 05
     C                   EXSR      *PSSR
     C                   ELSE

      ** Extract SDCUSTPD and SDCSSWPD
     C                   Eval      WStr = %Len(SDCUST) + 1
     C                   Eval      WLen = %Len(SDCSSW)
     C                   Eval      SDCUST = DSLDY
     C                   Eval      SDCSSW = %Subst(DSLDY:WStr:WLen)
     C                   ENDIF

      ** Retrieve Additional Customer Details
     C                   CALL      'AOACUSR0'
     C                   PARM      *BLANKS       PRtnCde2
     C                   PARM      '*KEY'        POption
     C                   PARM                    PCustA
     C     SDACUS        PARM      SDACUS        DSLDY

     C                   IF        PRtnCde2 <> *BLANKS
     C                   EVAL      DBKEY = 'SDACUSPD'
     C                   EVAL      DBASE  = 06
     C                   EXSR      *PSSR
     C                   ENDIF
      *
     C                   ENDIF
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SrAddressInfo - Determine the Address Information based on    *
      *                 MT300JFldAddressOvr setup                     *
      *                                                               *
      *****************************************************************

     C     SrAddressInfo BEGSR

      ** COUNTERPARTY NOSTRO
     C                   IF        CptyNostro = 'Y'
     C                   EVAL      DtlName = AWCPNM
     C                   EVAL      DtlCity = AWCNTN
     C                   EVAL      DtlAdd1 = *BLANKS
     C                   EVAL      DtlAdd2 = *BLANKS

     C                   ELSE
      ** CUSTOMER

      ** MT300JFldAddressOvr = "D", this uses the address information
      **                            from Additional Customer Informa-
      **                            tion (SDACUSPD) if it is not blank.
      ** MT300JFldAddressOvr = "O", the standard name and address is
      **                            used (SDCUSTPD)

     C                   IF        WFldAddOvr = 'D' AND
     C                             E5CNA1 <> *BLANKS

      ** Check if there are multiple blanks in Customer and Family name
     C                   EVAL      E5CNA1 = %TRIM(E5CNA1)
     C                   DOW       %SCAN('  ':%TRIM(E5CNA1)) > 0
     C                   EVAL      PosBlank = %SCAN('  ':E5CNA1)
     C                   EVAL      E5CNA1 = %SUBST(E5CNA1:1:PosBlank) +
     C                             %TRIM(%SUBST(E5CNA1:PosBlank))
     C                   ENDDO
     C                   EVAL      E5CNA2 = %TRIM(E5CNA2)
     C                   DOW       %SCAN('  ':%TRIM(E5CNA2)) > 0
     C                   EVAL      PosBlank = %SCAN('  ':E5CNA2)
     C                   EVAL      E5CNA2 = %SUBST(E5CNA2:1:PosBlank) +
     C                             %TRIM(%SUBST(E5CNA2:PosBlank))
     C                   ENDDO
      ** Map Additional Information details
     C                   EVAL      DtlName = %TRIM(E5CNA1) + ' ' +
     C                                       %TRIM(E5CNA2)
     C                   IF        E5CNA3 <> *BLANKS
     C                   EVAL      DtlAdd1 = E5CNA3
     C                   EVAL      DtlAdd2 = E5CNA4
     C                   ELSE
     C                   EVAL      DtlAdd1 = E5CNA4
     C                   ENDIF
     C                   EVAL      DtlCity = E5CITY

      ** Map Standard Customer details
     C                   ELSE
     C                   EVAL      DtlName = BBCNA1

     C                   IF        BBCNA4 <> *BLANKS
     C                   EVAL      DtlCity = BBCNA4
      ** 4 non-blank lines
     C                   IF        BBCNA2 <> *BLANKS
     C                   EVAL      DtlAdd1 = BBCNA2
     C                   EVAL      DtlAdd2 = BBCNA3
     C                   ELSE
     C                   EVAL      DtlAdd1 = BBCNA3
     C                   ENDIF
      *
     C                   ELSEIF    BBCNA3 <> *BLANKS
      ** 3 non-blank lines
     C                   EVAL      DtlCity = BBCNA3
     C                   EVAL      DtlAdd1 = BBCNA2
      ** 2 non-blank lines
     C                   ELSEIF    BBCNA2 <> *BLANKS
     C                   EVAL      DtlCity = BBCNA2
     C                   ENDIF

     C                   ENDIF
     C                   ENDIF
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SrReplaceSlash - Replacement character of slash in J format   *
      *                 fields ReplaceJFormatSlash                    *
      *                                                               *
      *****************************************************************

     C     SrRepSlash    BEGSR

      ** ReplaceJFormatSlash , this defines the character to use as a
      ** replacement if the constructed J format field contains an
      ** embedded "/"

     C                   EVAL      AcctLine = *BLANKS
     C                   IF        PAcctLine <> *BLANKS
     C                   MOVEL     PAcctLine     Slash
     C                   IF        Slash = '/'
     C                   EVAL      AcctLine = %SUBST(PAcctLine:2)
     C                   ELSE
     C                   EVAL      AcctLine = PAcctLine
     C                   ENDIF
     C                   ENDIF

     C                   EVAL      CheckSlash = %SCAN('/' :CustDetails)
     C                   IF        CheckSlash <> 0
     C                   EVAL      CustDetails = %SCANRPL('/' :
     C                                           WRepSlash :
     C                                           CustDetails)
     C                   ENDIF

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SrFormatJ - J Format layout options                           *
      *             MT300UseLEIJFld, MT300LEIorAddress                *
      *           - Account line without LEI                          *
      *           - Account line with LEI                             *
      *           - No account line or LEI                            *
      *           - LEI without account                               *
      *                                                               *
      *                                                               *
      *****************************************************************

     C     SrFormatJ     BEGSR

      ** Account line is PRESENT
     C                   IF        AcctLine <> *BLANKS

      ** Only output LEI code if below conditions are satisfied:
      ** - MT300UseLEIJFld (system value to output LEI) is equal to "Y"
      ** - LEI field is not blanks
      ** - MT300LEIorAddress (system value to prioritised LEI over the
      **   full add) is "L" or
      ** - MT300LEIorAddress is "A" AND Name and Address fields contain
      **   3 or less  non-blank lines

     C                   IF        WUseLeiFld = 'Y' AND
     C                             CSLEIC <> *BLANKS AND
     C                             CptyNostro = 'N'
      ** Use LEI over Address
     C                   IF        WLeiorAddr = 'L'
     C     '/ACCT/'      CAT       AcctLine      PLine1
     C     '/LEIC/'      CAT       CSLEIC        Pline2
     C     '/NAME/'      CAT       DtlName       Pline3
     C     '/ADD1/'      CAT       DtlAdd1       Pline4
     C     '/CITY/'      CAT       DtlCity       PLine5
     C                   ELSE

      ** If WLEIorAddr = "A" and 3 or less non-blank lines are
      ** populated, include LEI code in J format

     C                   IF        DtlAdd1 = *BLANKS OR
     C                             DtlAdd2 = *BLANKS
     C     '/ACCT/'      CAT       AcctLine      PLine1
     C     '/LEIC/'      CAT       CSLEIC        Pline2
     C     '/NAME/'      CAT       DtlName       PLine3
     C                   IF        DtlAdd1 <> *BLANKS
     C     '/ADD1/'      CAT       DtlAdd1       PLine4
     C                   ELSE
     C     '/ADD1/'      CAT       DtlAdd2       PLine4
     C                   ENDIF
     C     '/CITY/'      CAT       DtlCity       PLine5

      ** Use Address over LEI if 4 non-blank lines are populated
     C                   ELSE
     C     '/ACCT/'      CAT       AcctLine      PLine1
     C     '/NAME/'      CAT       DtlName       PLine2
     C     '/ADD1/'      CAT       DtlAdd1       PLine3
     C     '/ADD2/'      CAT       DtlAdd2       PLine4
     C     '/CITY/'      CAT       DtlCity       PLine5
     C                   ENDIF
      *
     C                   ENDIF

     C                   ELSE

      ** No LEI code in J format
     C     '/ACCT/'      CAT       AcctLine      PLine1
     C     '/NAME/'      CAT       DtlName       PLine2
     C     '/ADD1/'      CAT       DtlAdd1       PLine3
     C     '/ADD2/'      CAT       DtlAdd2       PLine4
     C     '/CITY/'      CAT       DtlCity       PLine5
     C                   ENDIF

     C                   ELSE

      ** Account line is NOT PRESENT

      ** Only output LEI if below conditions are satisfied:
      ** - MT300UseLEIJFld (system value to output LEI) is equal to "Y"
      ** - LEI field is not blanks

     C                   IF        WUseLeiFld = 'Y' AND
     C                             CSLEIC <> *BLANKS AND
     C                             CptyNostro = 'N'
     C     '/LEIC/'      CAT       CSLEIC        PLine1
     C     '/NAME/'      CAT       DtlName       PLine2
     C     '/ADD1/'      CAT       DtlAdd1       PLine3
     C     '/ADD2/'      CAT       DtlAdd2       PLine4
     C     '/CITY/'      CAT       DtlCity       Pline5

     C                   ELSE

      ** No LEI code output
     C     '/NAME/'      CAT       DtlName       Pline1
     C     '/ADD1/'      CAT       DtlAdd1       PLine2
     C     '/ADD2/'      CAT       DtlAdd2       PLine3
     C     '/CITY/'      CAT       DtlCity       PLine4
     C                   ENDIF

     C                   ENDIF
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * *PSSR  - Program Exception Error Routine                      *
      *                                                               *
      *****************************************************************

     C     *PSSR         BEGSR

     C                   DUMP

     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   EVAL      *INLR = *ON
     C                   RETURN

     C                   ENDSR

      *****************************************************************
