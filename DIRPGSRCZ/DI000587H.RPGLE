     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2013')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas OF Accounting Rules Submit JRNE - HTTP')         *
      *****************************************************************
      *                                                               *
      *  Midas - General Ledger module                                *
      *                                                               *
      ***GL000587H*-*Midas*OF*Accounting*Rules*Call*JRNE*thru*HTTP*****                     MD029739
      *  DI000587H - Midas OF Accounting Rules Call JRNE thru HTTP    *                     MD029739
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2013            *
      *                                                               *
      *  Last Amend No. MD027107           Date 11Dec14               *
      *  Prev Amend No. MD029739 *RENAMED* Date 15Aug14               *
      *                 MD033895           Date 03Feb14               *
      *                 MD024772           Date 03Feb14               *
      *                 MD024681A          Date 18Feb14               *
      *                 MD024513           Date 23Jan14               *
      *                 MD024534           Date 24Jan14               *
      *                 MD023629           Date 08Jan14               *
      *                 MD023837           Date 27Nov13               *
      *                 MD023747           Date 23Nov13               *
      *                 CGL135B  *CREATE   Date 11Oct13               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD027107 - Split the Accounting Rules Journal Batch Entry    *
      *             once it reach 998 entries. (Recompile)            *
      *  MD029739 - File renaming for integration layer.              *
      *  MD033895 - Correct parameters for UT000033.                  *
      *  MD024772 - Problems with Accounting Interface postings and   *
      *             enquiries.                                        *
      *  MD024681A - Report name, Report Town, Narratives may contain *
      *             special characters and this gives error when      *
      *             details sent thru the APIs                        *
      *  MD024513 - Add Description field (30A) to the Accounting     *
      *             Rules. (Recompile)                                *
      *  MD024534 - According to-authorize, insert batch header as    *
      *             authorized or not                                 *
      *  MD023629 - Accounting Rules Processing - Restart             *
      *  MD023837 - Triggers on tables GLACMNTD, GLACBHTD, GLACBDTD   *
      *             failed (Recompile)                                *
      *  MD023747 - Accounting Rules Process (Recompile)              *
      *  CGL135B - Accounting Rules Process                           *
      *                                                               *
      *****************************************************************
      *
      ** Midas OF Accounting Rules Submit JRNE - DEBUG
     F***GL000587P1  E             PRINTER INFSR(*PSSR)                                     MD029739
     FDI000587P1O    E             PRINTER USROPN                                           MD029739
     F                                     INFSR(*PSSR)
     F                                     INFDS(SPOOL1)
      *
      ** File DS
      *
      **   Midas GL Accounting Rules Batch Header
     D*DSACBHTD*     E DS                  EXTNAME(GLACBHTD)                                MD029739
     D DSACBHTD      E DS                  EXTNAME(DIACBHTD)                                MD029739
      *
      **   Midas GL Accounting Rules Batch Details
     D*DSACBDTD*     E DS                  EXTNAME(GLACBDTD)                                MD029739
     D DSACBDTD      E DS                  EXTNAME(DIACBDTD)                                MD029739
      *
      * Bank Details
     D DsBANK        E DS                  EXTNAME(SDBANKPD)
      *
      ***File*Information*Data*Structure*for*GL000587P1****************                     MD029739
      ** File Information Data Structure for DI000587P1                                     MD029739
     D SPOOL1          DS
     D  PSFile1               83     92
     D  PSFNum1              123    124B 0
     D  OflLn1               188    189B 0
     D  PrtLn1               367    368B 0
      *
      * Short DS for access programs
     D DSFDY         E DS                  EXTNAME(DSFDY)
      *
      * Long DS for access programs
     D DSSDY         E DS                  EXTNAME(DSSDY)
      *
      ** Local data Area
     D LDA           E DS                  EXTNAME(LDA) DTAARA
      *
      ** Web Config data area
     D BFWBCONF      E DS                  EXTNAME(BFWBCONF) DTAARA
      *
     D WkBITHType      S              4A   INZ('BITH')                          Message Type
     D WkBITHAction    S             20A   INZ('WRITE!MIDAS.BITH')              Action
     D WkBITPType      S              4A   INZ('BITP')                          Message Type
     D WkBITPAction    S             20A   INZ('WRITE!MIDAS.BITP')              Action
      *
      * Entry's parameters
     D P_RtrnCode      S              7A                                        Return Code
     D P_Option        S              7A                                        Option
     D P_ActCode       S              1A                                        Action Code
     D P_TransType     S              4A                                        Transaction Type
     D P_BITH          S                   LIKE(DSACBHTD)                       JRNE - Batch Header
     D P_BITP          S                   LIKE(DSACBDTD)                       JRNE - Batch Item
      *
      * Access objects parameters
     D P@RTCD          S              7A                                        Return Code
     D P@OPTN          S              7A                                        Option
     D P@OP01          S             20A
     D P@VL01          S            200A
     D P@OP02          S             20A
     D P@VL02          S            200A
     D P@OP03          S             20A
     D P@VL03          S            200A
     D P@OP04          S             20A
     D P@VL04          S            200A
     D P@OP05          S             20A
     D P@VL05          S            200A
     D P@OP06          S             20A
     D P@VL06          S            200A
     D P@OP07          S             20A
     D P@VL07          S            200A
     D P@OP08          S             20A
     D P@VL08          S            200A
     D P@OP09          S             20A
     D P@VL09          S            200A
     D P@OP10          S             20A
     D P@VL10          S            200A
     D P@ACTN          S              1A                                        Action
     D P@VLIS          S             10A                                        Valid List
     D P@VLIB          S             10A                                        Valib List Library
     D***P@USER*       S            256A                                        User ID     MD033895
     D***P@PWD1*       S            256A                                        Password 1  MD033895
     D***P@PWD2*       S            256A                                        Password 1  MD033895
     D***P@DESC*       S             50A                                        Description MD033895
     D P@USER          S            100A                                                    MD033895
     D P@PWD1          S            600A                                                    MD033895
     D P@PWD2          S            600A                                                    MD033895
     D P@DESC          S           1000A                                                    MD033895
      *
     D WkIpAddress     S             64A   VARYING                              IP address
     D WkValLstLoc     S             10A                                        Valib List Library
     D WkZone          S             10A                                        WkZone
     D WkUserId        S             10A                                        User Id
     D WkPassWord      S             10A                                        Password
     D WKMsgType       S              4A                                        Message Type
     D WKAction        S             20A                                        Action
     D WKAutoAuth      S              1A                                        Auto-Author MD024534
      *
     D WkIdx           S             10I 0                                      Index
     D WkPos           S             10I 0                                      Position
      *
     D WkProcRtrn      S                   like(WEB_INT)                        Procedure Return Cod
     D WkSoap          S                   like(WEB_STRVAR)
     D WkSoapDtl       S           6000A
      *
      *  Collection of all Midas Error Messages
      *
     D WkMidasErrs     DS                  likeDS(midasErrors)
     D WkMidasWarns    DS                  likeDS(midasWarnings)
     D WkOverErrs      DS                  likeDS(overErrors)
     D WkSystemErrs    DS                  likeDS(systemErrors)
      *
     D WkNbErr         S             10I 0                                      Number of Errors
     D WkFldErr        S             20A                                        Field in Error
     D WkDescErr       S            200A                                        Description of error
     D WkOveridden     S              1A                                        Overriden flag
      *
     D Recursive       S              1
      *
     D Pos             S              3  0                                                 MD024681A
     D ChkFld          S            100A   varying                                         MD024681A
     D Tmp             S            100A   varying                                         MD024681A
     D Tmp2            S            100A   varying                                         MD024681A
     D Tmp3            S            100A   varying                                         MD024681A
      *                                                                                     MD024772
     D BDTSTYTMP       S              5                                                     MD024772
      *---------------------------------------------------------------------------------------
      ** PROTOTYPE
      *---------------------------------------------------------------------------------------
     D/COPY BFCPYSRC,BF000007
      *
      /EJECT
      *****************************************************************
      *                                                               *
      ** Main                                                         *
      *                                                               *
      *****************************************************************
      *
      ** Clear Return Code
      *
     C                   EVAL      P_RtrnCode = *Blanks                         Return Code
      *
      ** Release resource
      ** ----------------
      *
     C                   IF        P_Option    = '*CLOSE ' AND                  Option
     C                             P_ActCode   = *Blanks   AND                  Action Code
     C                             P_TransType = *Blanks   AND                  Transaction Type
     C                             P_BITH      = *Blanks   AND                  Header details
     C                             P_BITP      = *Blanks                        Item details
     C                   GOTO      EndPgm
     C                   ENDIF
      *
      ** Clear SOAP details.
      *
     C                   RESET                   WkSoap                         SOAP details
     C                   RESET                   WkMidasErrs                    Midas Errs
     C                   RESET                   WkMidasWarns                   Midas Warns
     C                   RESET                   WkOverErrs                     Over Errs
     C                   RESET                   WkSystemErrs                   System Errs
      *
     C                   SELECT
      *
      ** Insert Jounal entry - Batch Header details
      *
     C                   WHEN      P_TransType = 'BITH' AND P_BITH <> *Blanks
      *
     C                   EXSR      SrBITH
      *
      ** Insert Jounal entry - Batch Item details
      *
     C                   WHEN      P_TransType = 'BITP' AND P_BITP <> *Blanks
      *
     C                   EXSR      SrBITP
      *
     C                   ENDSL
      *
     C     EndPgm        TAG
      *
      ** Release resources
      *
     C                   IF        P_Option = '*CLOSE '
     C                   EVAL      *INLR = *ON
     C                   ENDIF
      *
     C                   RETURN
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SrBITH     - Insert Jounal entry - Batch Header details       *
      *                                                               *
      *****************************************************************
      *
     C     SrBITH        BEGSR
      *
      ** - API action
      *
     C                   EVAL      WKMsgType = WkBITHType
     C                   EVAL      WkAction  = WkBITHAction
      *
      ** - Target System
      *
     C                   EVAL      WkSoap = WkSoap +
     C                                      getOldSoapParm('APTGTSYS'
     C                                                    :'MIDAS' )
      *
      ** - Respond Mode - Sync/Async
      *
     C                   EVAL      WkSoap = WkSoap +
     C                                      getOldSoapParm('APRESPMODE'
     C                                                    :'S' )
      *
      ** - Front Office transaction ID
      *
     C                   EVAL      WkSoap = WkSoap +
     C                                      getOldSoapParm('APFOTRANID'
     C                                                    : BHFRNT )
      *
      ** - Front Office Assoc Deal ID
      *
     C                   EVAL      WkSoap = WkSoap +
     C                                      getOldSoapParm('APFOASOCID'
     C                                                    : BHFRNT )
      *
      ** - Confirm valid transaction to front office
      *
     C                   EVAL      WkSoap = WkSoap +
     C                                      getOldSoapParm('APCNFVALFO'
     C                                                    : 'Y' )
      *
      ** - Repair location
      *
     C                   EVAL      WkSoap = WkSoap +
     C                                      getOldSoapParm('APRPRLOCN'
     C                                                    : 'B' )
      *
      ** - Auto-Authorized
      *
     C**********         EVAL      WkSoap = WkSoap +                                        MD024534
     C**********                            getOldSoapParm('AUTH'                           MD024534
     C**********                                          : 'Y' )                           MD024534
     C                   EVAL      WkSoap = WkSoap +                                        MD024534
     C                                      getOldSoapParm('AUTH'                           MD024534
     C                                                    : WKAutoAuth )                    MD024534
      *
      ** - Action Code
      *
     C                   IF        P_ActCode <> *Blanks
     C                   EVAL      WkSoap = WkSoap +
     C                                      getOldSoapParm('DDACTN'
     C                                                    : P_ActCode )
     C                   ENDIF
      *
      ** - Batch Number
      *
     C                   IF        BHBTNB <> *Blanks
     C                   EVAL      WkSoap = WkSoap +
     C                                      getOldSoapParm('DDBTNB'
     C                                                    : BHBTNB )
     C                   ENDIF
      *
      ** - Branch Code
      *
     C                   IF        BHBKBR <> *Blanks
     C                   EVAL      WkSoap = WkSoap +
     C                                      getOldSoapParm('DDBCDA'
     C                                                    : BHBKBR )
     C                   ENDIF
      *
      ** - Dept Code
      *
     C                   IF        BHPCD  <> *Blanks
     C                   EVAL      WkSoap = WkSoap +
     C                                      getOldSoapParm('DDDPCD'
     C                                                    : BHPCD  )
     C                   ENDIF
      *
      ** - Multiple Branch Batch
      *
     C                   IF        BHMBRB <> *Blanks
     C                   EVAL      WkSoap = WkSoap +
     C                                      getOldSoapParm('DDMBRB'
     C                                                    : BHMBRB )
     C                   ENDIF
      *
      ** - Batch Description
      *
     C                   IF        BHDESC <> *Blanks
     C                   EVAL      WkSoap = WkSoap +
     C                                      getOldSoapParm('DDBDES'
     C                                                    : BHDESC )
     C                   ENDIF
      *
      ** - Batch Total
      *
     C                   IF        BHSMAM <> *Zeros
     C                   EVAL      WkSoap = WkSoap +
     C                                      getOldSoapParm('DDFMAM'
     C                                                    : BHSMAM )
     C                   ENDIF
      *
      ** - No. of Items
      *
     C                   IF        BHNITM <> *Blanks
     C                   EVAL      WkSoap = WkSoap +
     C                                      getOldSoapParm('DDNOIS'
     C                                                    : BHNITM )
     C                   ENDIF
      *
      ** - Batch Held/Accepted Ind.
      *
     C                   IF        BHBTSF <> *Zeros
     C                   EVAL      WkSoap = WkSoap +
     C                                      getOldSoapParm('DDBHAI'
     C                                                    : BHBTSF )
     C                   ENDIF
      *
      ** Submit Soap
      *
     C                   EXSR      SrSbmSOAP
      *
     C     SrBITHE       ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SrBITP     - Insert Jounal entry - Batch Item details         *
      *                                                               *
      *****************************************************************
      *
     C     SrBITP        BEGSR
      *
      ** - API action
      *
     C                   EVAL      WKMsgType = WkBITPType
     C                   EVAL      WkAction  = WkBITPAction
      *
      ** APHEADPD
      *
      ** - Target System
      *
     C                   IF        BDTGTS <> *Blanks
     C                   EVAL      WkSoap = WkSoap +
     C                                      getOldSoapParm('APTGTSYS'
     C                                                    : BDTGTS )
     C                   ELSE
     C                   EVAL      WkSoap = WkSoap +
     C                                      getOldSoapParm('APTGTSYS'
     C                                                    :'MIDAS' )
     C                   ENDIF
      *
      ** - Original Message Type
      *
     C                   IF        BDSRCT <> *Blanks
     C                   EVAL      WkSoap = WkSoap +
     C                                      getOldSoapParm('APSRCTYPE'
     C                                                    : BDSRCT )
     C                   ENDIF
      *
      ** - Source System
      *
     C                   IF        BDSRCS <> *Blanks
     C                   EVAL      WkSoap = WkSoap +
     C                                      getOldSoapParm('APSRCSYS'
     C                                                    : BDSRCS )
     C                   ENDIF
      *
      ** - User Id
      *
     C                   IF        BDUSER <> *Blanks
     C                   EVAL      WkSoap = WkSoap +
     C                                      getOldSoapParm('APUSERID'
     C                                                    : BDUSER )
     C                   ENDIF
      *
      ** - Password
      *
     C                   IF        BDPASS <> *Blanks
     C                   EVAL      WkSoap = WkSoap +
     C                                      getOldSoapParm('APPASSWORD'
     C                                                    : BDPASS )
     C                   ENDIF
      *
      ** - Message Format
      *
     C                   IF        BDFORM <> *Blanks
     C                   EVAL      WkSoap = WkSoap +
     C                                      getOldSoapParm('APFORMAT'
     C                                                    : BDFORM )
     C                   ENDIF
      *
      ** - Message Version No
      *
     C                   IF        BDVERS <> *Blanks
     C                   EVAL      WkSoap = WkSoap +
     C                                      getOldSoapParm('APVERSION'
     C                                                    : BDVERS )
     C                   ENDIF
      *
      ** - Reply Queue
      *
     C                   IF        BDRPYQ <> *Blanks
     C                   EVAL      WkSoap = WkSoap +
     C                                      getOldSoapParm('APRPYQUEUE'
     C                                                    : BDRPYQ )
     C                   ENDIF
      *
      ** - Respond Mode - Sync/Async
      *
     C                   IF        BDRESP <> *Blanks
     C                   EVAL      WkSoap = WkSoap +
     C                                      getOldSoapParm('APRESPMODE'
     C                                                    : BDRESP )
     C                   ELSE
     C                   EVAL      WkSoap = WkSoap +
     C                                      getOldSoapParm('APRESPMODE'
     C                                                    :'S' )
     C                   ENDIF
      *
      ** - Front Office transaction ID
      *
     C                   IF        BDFOTR <> *Blanks
     C                   EVAL      WkSoap = WkSoap +
     C                                      getOldSoapParm('APFOTRANID'
     C                                                    : BDFOTR )
     C                   ENDIF
      *
      ** - Front Office Assoc Deal ID
      *
     C                   IF        BDFOAS <> *Blanks
     C                   EVAL      WkSoap = WkSoap +
     C                                      getOldSoapParm('APFOASOCID'
     C                                                    : BDFOAS )
     C                   ENDIF
      *
      ** - Confirm valid transaction to front office
      *
     C                   IF        BDCNFV <> *Blanks
     C                   EVAL      WkSoap = WkSoap +
     C                                      getOldSoapParm('APCNFVALFO'
     C                                                    : BDCNFV )
     C                   ELSE
     C                   EVAL      WkSoap = WkSoap +
     C                                      getOldSoapParm('APCNFVALFO'
     C                                                    : 'Y' )
     C                   ENDIF
      *
      ** - Repair location
      *
     C                   IF        BDRPRL <> *Blanks
     C                   EVAL      WkSoap = WkSoap +
     C                                      getOldSoapParm('APRPRLOCN'
     C                                                    : BDRPRL )
     C                   ELSE
     C                   EVAL      WkSoap = WkSoap +
     C                                      getOldSoapParm('APRPRLOCN'
     C                                                    : 'B' )
     C                   ENDIF
      *
      ** - Auto-Authorized
      *
     C**********         EVAL      WkSoap = WkSoap +                                        MD024534
     C**********                            getOldSoapParm('AUTH'                           MD024534
     C**********                                          : 'Y' )                           MD024534
      *
      ** - Return Code
      *
     C                   IF        BDRETC <> *Blanks
     C                   EVAL      WkSoap = WkSoap +
     C                                      getOldSoapParm('APRETCODE'
     C                                                    : BDRETC )
     C                   ENDIF
      *
      ** - User id
      *
     C                   IF        BDMIDU <> *Blanks
     C                   EVAL      WkSoap = WkSoap +
     C                                      getOldSoapParm('APMIDUSR'
     C                                                    : BDMIDU )
     C                   ENDIF
      *
      ** GLBITPPD
      *
      ** - Account Identifier
      *
     C                   IF        BDACID <> *Blanks
     C                   EVAL      WkSoap = WkSoap +
     C                                      getOldSoapParm('DDACID'
     C                                                    : BDACID )
     C                   ENDIF
      *
      ** - Account Customer shortname
      *
     C                   IF        BDATSN <> *Blanks
                                                                                           MD024681A
     C                   EVAL      ChkFld = BDATSN                                         MD024681A
     C                   EXSR      CHKAMP                                                  MD024681A
                                                                                           MD024681A
     C                   EVAL      WkSoap = WkSoap +
     C**********                            getOldSoapParm('DDCSSN'                        MD024681A
     C**********                                          : BDATSN )                       MD024681A
                                                                                           MD024681A
     C                                      getOldSoapParm('DDCSSN'                        MD024681A
     C                                                    : CHKFLD )                       MD024681A
     C                   ENDIF
      *
      ** - Account Customer Report Name
      *
     C                   IF        BDATNM <> *Blanks
                                                                                           MD024681A
     C                   EVAL      ChkFld = BDATNM                                         MD024681A
     C                   EXSR      CHKAMP                                                  MD024681A
                                                                                           MD024681A
     C                   EVAL      WkSoap = WkSoap +
     C**********                            getOldSoapParm('DDCRNM'                        MD024681A
     C**********                                          : BDATNM )                       MD024681A
                                                                                           MD024681A
     C                                      getOldSoapParm('DDCRNM'                        MD024681A
     C                                                    : CHKFLD )                       MD024681A
     C                   ENDIF
      *
      ** - Account Customer Name
      *
     C                   IF        BDATAN <> *Blanks
                                                                                           MD024681A
     C                   EVAL      ChkFld = BDATAN                                         MD024681A
     C                   EXSR      CHKAMP                                                  MD024681A
                                                                                           MD024681A
     C                   EVAL      WkSoap = WkSoap +
     C**********                            getOldSoapParm('DDACNM'                        MD024681A
     C**********                                          : BDATAN )                       MD024681A
                                                                                           MD024681A
     C                                      getOldSoapParm('DDCSSN'                        MD024681A
     C                                                    : CHKFLD )                       MD024681A
     C                   ENDIF
      *
      ** - Currency Code
      *
     C                   IF        BDCYCD <> *Blanks
     C                   EVAL      WkSoap = WkSoap +
     C                                      getOldSoapParm('DDCYCD'
     C                                                    : BDCYCD)
     C                   ENDIF
      *
      ** - Account Code
      *
     C                   IF        BDACCD <> *Blanks
     C                   EVAL      WkSoap = WkSoap +
     C                                      getOldSoapParm('DDACCD'
     C                                                    : BDACCD)
     C                   ENDIF
      *
      ** - Account Sequence
      *
     C                   IF        BDACSN <> *Blanks
     C                   EVAL      WkSoap = WkSoap +
     C                                      getOldSoapParm('DDACSN'
     C                                                    : BDACSN)
     C                   ENDIF
      *
      ** - Input Branch Code
      *
     C                   IF        BDIBCA <> *Blanks
     C                   EVAL      WkSoap = WkSoap +
     C                                      getOldSoapParm('DDIBCA'
     C                                                    : BDIBCA)
     C                   ENDIF
      *
      ** - Posting Amount
      *
     C                   IF        BDPTAM <> *Blanks
     C                   EVAL      WkSoap = WkSoap +
     C                                      getOldSoapParm('DDPTAM'
     C                                                    : BDPTAM)
     C                   ENDIF
      *
      ** - Debit/Credit Indicator
      *
     C                   IF        BDDCIN <> *Blanks
     C                   EVAL      WkSoap = WkSoap +
     C                                      getOldSoapParm('DDDCIN'
     C                                                    : BDDCIN)
     C                   ENDIF
      *
      ** - Narrative
      *
     C                   IF        BDINAR <> *Blanks
     C                   EVAL      WkSoap = WkSoap +
     C                                      getOldSoapParm('DDNARR'
     C                                                    : BDINAR)
     C                   ENDIF
      *
      ** - Transaction Type
      *
     C                   IF        BDTRTY <> *Blanks
     C                   EVAL      WkSoap = WkSoap +
     C                                      getOldSoapParm('DDTRTY'
     C                                                    : BDTRTY)
     C                   ENDIF
      *
      ** - Transaction Sub Type
      *
     C                   IF        BDTSTY <> *Blanks
     C                   MOVE      *BLANKS       BDTSTYTMP                                  MD024772
     C                   MOVE      BDTSTY        BDTSTYTMP                                  MD024772
     C                   EVAL      WkSoap = WkSoap +
     C                                      getOldSoapParm('DDTSTY'
     C**********                                          : BDTSTY)                         MD024772
     C                                                    : BDTSTYTMP)                      MD024772
     C                   ENDIF
      *
      ** - Value Date
      *
     C                   IF        BDVLDT <> *Blanks
     C                   EVAL      WkSoap = WkSoap +
     C                                      getOldSoapParm('DDVLDT'
     C                                                    : BDVLDT)
     C                   ENDIF
      *
      ** - Cheque Number
      *
     C                   IF        BDCQNB <> *Blanks
     C                   EVAL      WkSoap = WkSoap +
     C                                      getOldSoapParm('DDCQNB'
     C                                                    : BDCQNB)
     C                   ENDIF
      *
      ** - Swift Common Reference
      *
     C                   IF        BDSWCR <> *Blanks
     C                   EVAL      WkSoap = WkSoap +
     C                                      getOldSoapParm('DDSWCR'
     C                                                    : BDSWCR)
     C                   ENDIF
      *
      ** - Profit Centre
      *
     C                   IF        BDPRCN <> *Blanks
                                                                                           MD024681A
     C                   EVAL      ChkFld = BDPRCN                                         MD024681A
     C                   EXSR      CHKAMP                                                  MD024681A
                                                                                           MD024681A
     C                   EVAL      WkSoap = WkSoap +
     C**********                            getOldSoapParm('DDPRCN'                        MD024681A
     C**********                                          : BDPRCN)                        MD024681A
                                                                                           MD024681A
     C                                      getOldSoapParm('DDPRCN'                        MD024681A
     C                                                    : ChkFld)                        MD024681A
     C                   ENDIF
      *
      ** - Associated Customer
      *
     C                   IF        BDACNB <> *Blanks
                                                                                           MD024681A
     C                   EVAL      ChkFld = BDACNB                                         MD024681A
     C                   EXSR      CHKAMP                                                  MD024681A
                                                                                           MD024681A
     C                   EVAL      WkSoap = WkSoap +
     C**********                            getOldSoapParm('DDACNB'                        MD024681A
     C**********                                          : BDACNB)                        MD024681A
                                                                                           MD024681A
     C                                      getOldSoapParm('DDACNB'                        MD024681A
     C                                                    : ChkFld)                        MD024681A
     C                   ENDIF
      *
      ** - Book Code
      *
     C                   IF        BDIBKC <> *Blanks
     C                   EVAL      WkSoap = WkSoap +
     C                                      getOldSoapParm('DDBKCD'
     C                                                    : BDIBKC)
     C                   ENDIF
      *
      ** - Reverse/VOID Indicator
      *
     C                   IF        BDRVDI <> *Blanks
     C                   EVAL      WkSoap = WkSoap +
     C                                      getOldSoapParm('DDRVDI'
     C                                                    : BDRVDI)
     C                   ENDIF
      *
      ** - No. of Items
      *
     C                   IF        BDNITM <> *Blanks
     C                   EVAL      WkSoap = WkSoap +
     C                                      getOldSoapParm('DDNITM'
     C                                                    : BDNITM)
     C                   ENDIF
      *
      ** - Retail Ind. Override
      *
     C                   IF        BDRINO <> *Blanks
     C                   EVAL      WkSoap = WkSoap +
     C                                      getOldSoapParm('DDRINO'
     C                                                    : BDRINO)
     C                   ENDIF
      *
      ** - Original CCY
      *
     C                   IF        BDOCCY <> *Blanks
     C                   EVAL      WkSoap = WkSoap +
     C                                      getOldSoapParm('DDOCCY'
     C                                                    : BDOCCY)
     C                   ENDIF
      *
      ** - Original Amount
      *
     C                   IF        BDOAMT <> *Blanks
     C                   EVAL      WkSoap = WkSoap +
     C                                      getOldSoapParm('DDOAMT'
     C                                                    : BDOAMT)
     C                   ENDIF
      *
      ** - Batch Header Number
      *
     C                   IF        BDBTNB <> *Blanks
     C                   EVAL      WkSoap = WkSoap +
     C                                      getOldSoapParm('DDBTNB'
     C                                                    : BDBTNB)
     C                   ENDIF
      *
      ** - Batch Item Number
      *
     C                   IF        BDBINB <> *Blanks AND
     C                             BDACTN <> 'I'
     C                   EVAL      WkSoap = WkSoap +
     C                                      getOldSoapParm('DDBINB'
     C                                                    : BDBINB)
     C                   ENDIF
      *
      ** - Delete Item Flag
      *
     C                   IF        BDDLIT <> *Blanks
     C                   EVAL      WkSoap = WkSoap +
     C                                      getOldSoapParm('DDDLIT'
     C                                                    : BDDLIT)
     C                   ENDIF
      *
      ** - Action Code
      *
     C                   IF        BDACTN <> *Blanks
     C                   EVAL      WkSoap = WkSoap +
     C                                      getOldSoapParm('DDACTN'
     C                                                    : BDACTN)
     C                   ELSE
     C                   EVAL      WkSoap = WkSoap +
     C                                      getOldSoapParm('DDACTN'
     C                                                    : P_ActCode )
     C                   ENDIF
      *
      ** GLBITPXPD
      *
      ** - Additional Information
      *
     C                   IF        BDADIF1 <> *Blanks  OR
     C                             BDADIF2 <> *Blanks  OR
     C                             BDADIF3 <> *Blanks  OR
     C                             BDADIF4 <> *Blanks  OR
     C                             BDADIF5 <> *Blanks  OR
     C                             BDADIF6 <> *Blanks  OR
     C                             BDAERI  <> *Blanks
     C                   EVAL      WkSoap = WkSoap +
     C                                      getOldSoapParm('DDADIN'
     C                                                    :'Y' )
     C                   ENDIF
      *
      ** - Additional Information 1
      *
     C                   IF        BDADIF1 <> *Blanks
                                                                                           MD024681A
     C                   EVAL      ChkFld = BDADIF1                                        MD024681A
     C                   EXSR      CHKAMP                                                  MD024681A
                                                                                           MD024681A
     C                   EVAL      WkSoap = WkSoap +
     C**********                            getOldSoapParm('DDADI1'                        MD024681A
     C**********                                          : BDADIF1)                       MD024681A
                                                                                           MD024681A
     C                                      getOldSoapParm('DDADI1'                        MD024681A
     C                                                    : ChkFld)                        MD024681A
     C                   ENDIF
      *
      ** - Additional Information 2
      *
     C                   IF        BDADIF2 <> *Blanks
                                                                                           MD024681A
     C                   EVAL      ChkFld = BDADIF2                                        MD024681A
     C                   EXSR      CHKAMP                                                  MD024681A
                                                                                           MD024681A
     C                   EVAL      WkSoap = WkSoap +
     C**********                            getOldSoapParm('DDADI2'                        MD024681A
     C**********                                          : BDADIF2)                       MD024681A
                                                                                           MD024681A
     C                                      getOldSoapParm('DDADI2'                        MD024681A
     C                                                    : ChkFld)                        MD024681A
     C                   ENDIF
      *
      ** - Additional Information 3
      *
     C                   IF        BDADIF3 <> *Blanks
                                                                                           MD024681A
     C                   EVAL      ChkFld = BDADIF3                                        MD024681A
     C                   EXSR      CHKAMP                                                  MD024681A
                                                                                           MD024681A
     C                   EVAL      WkSoap = WkSoap +
     C**********                            getOldSoapParm('DDADI3'                        MD024681A
     C**********                                          : BDADIF3)                       MD024681A
                                                                                           MD024681A
     C                                      getOldSoapParm('DDADI3'                        MD024681A
     C                                                    : ChkFld)                        MD024681A
     C                   ENDIF
      *
      ** - Additional Information 4
      *
     C                   IF        BDADIF4 <> *Blanks
                                                                                           MD024681A
     C                   EVAL      ChkFld = BDADIF4                                        MD024681A
     C                   EXSR      CHKAMP                                                  MD024681A
                                                                                           MD024681A
     C                   EVAL      WkSoap = WkSoap +
     C**********                            getOldSoapParm('DDADI4'                        MD024681A
     C**********                                          : BDADIF4)                       MD024681A
                                                                                           MD024681A
     C                                      getOldSoapParm('DDADI4'                        MD024681A
     C                                                    : ChkFld)                        MD024681A
     C                   ENDIF
      *
      ** - Additional Information 5
      *
     C                   IF        BDADIF5 <> *Blanks
                                                                                           MD024681A
     C                   EVAL      ChkFld = BDADIF5                                        MD024681A
     C                   EXSR      CHKAMP                                                  MD024681A
                                                                                           MD024681A
     C                   EVAL      WkSoap = WkSoap +
     C**********                            getOldSoapParm('DDADI5'                        MD024681A
     C**********                                          : BDADIF5)                       MD024681A
                                                                                           MD024681A
     C                                      getOldSoapParm('DDADI5'                        MD024681A
     C                                                    : ChkFld)                        MD024681A
     C                   ENDIF
      *
      ** - Additional Information 6
      *
     C                   IF        BDADIF6 <> *Blanks
                                                                                           MD024681A
     C                   EVAL      ChkFld = BDADIF6                                        MD024681A
     C                   EXSR      CHKAMP                                                  MD024681A
                                                                                           MD024681A
     C                   EVAL      WkSoap = WkSoap +
     C**********                            getOldSoapParm('DDADI6'                        MD024681A
     C**********                                          : BDADIF6)                       MD024681A
                                                                                           MD024681A
     C                                      getOldSoapParm('DDADI6'                        MD024681A
     C                                                    : ChkFld)                        MD024681A
     C                   ENDIF
      *
      ** - ERI indicator
      *
     C                   IF        BDAERI <> *Blanks
     C                   EVAL      WkSoap = WkSoap +
     C                                      getOldSoapParm('DDAERI'
     C                                                    : BDAERI)
     C                   ENDIF
      *
      ** GLBPRXPD
      *
      ** - IBLC Operation Code 1
      *
     C                   IF        BDLXOPC1 <> *Blanks
     C                   EVAL      WkSoap = WkSoap +
     C                                      getOldSoapParm('LLLXOPC1'
     C                                                    : BDLXOPC1)
     C                   ENDIF
      *
      ** - Country Code 1
      *
     C                   IF        BDLXCOC1 <> *Blanks
     C                   EVAL      WkSoap = WkSoap +
     C                                      getOldSoapParm('LLLXCOC1'
     C                                                    : BDLXCOC1)
     C                   ENDIF
      *
      ** - Identification Code 1
      *
     C                   IF        BDLXIDC1 <> *Blanks
     C                   EVAL      WkSoap = WkSoap +
     C                                      getOldSoapParm('LLLXIDC1'
     C                                                    : BDLXIDC1)
     C                   ENDIF
      *
      ** - Identification 1
      *
     C                   IF        BDLXIDE1 <> *Blanks
     C                   EVAL      WkSoap = WkSoap +
     C                                      getOldSoapParm('LLLXIDE1'
     C                                                    : BDLXIDE1)
     C                   ENDIF
      *
      ** - IBLC Operation Code 2
      *
     C                   IF        BDLXOPC2 <> *Blanks
     C                   EVAL      WkSoap = WkSoap +
     C                                      getOldSoapParm('LLLXOPC2'
     C                                                    : BDLXOPC2)
     C                   ENDIF
      *
      ** - Country Code 2
      *
     C                   IF        BDLXCOC2 <> *Blanks
     C                   EVAL      WkSoap = WkSoap +
     C                                      getOldSoapParm('LLLXCOC2'
     C                                                    : BDLXCOC2)
     C                   ENDIF
      *
      ** - Identification Code 2
      *
     C                   IF        BDLXIDC2 <> *Blanks
     C                   EVAL      WkSoap = WkSoap +
     C                                      getOldSoapParm('LLLXIDC2'
     C                                                    : BDLXIDC2)
     C                   ENDIF
      *
      ** - Identification 2
      *
     C                   IF        BDLXIDE2 <> *Blanks
     C                   EVAL      WkSoap = WkSoap +
     C                                      getOldSoapParm('LLLXIDE2'
     C                                                    : BDLXIDE2)
     C                   ENDIF
      *
      ** - IBLC Operation Code 3
      *
     C                   IF        BDLXOPC3 <> *Blanks
     C                   EVAL      WkSoap = WkSoap +
     C                                      getOldSoapParm('LLLXOPC3'
     C                                                    : BDLXOPC3)
     C                   ENDIF
      *
      ** - Country Code 3
      *
     C                   IF        BDLXCOC3 <> *Blanks
     C                   EVAL      WkSoap = WkSoap +
     C                                      getOldSoapParm('LLLXCOC3'
     C                                                    : BDLXCOC3)
     C                   ENDIF
      *
      ** - Identification Code 3
      *
     C                   IF        BDLXIDC3 <> *Blanks
     C                   EVAL      WkSoap = WkSoap +
     C                                      getOldSoapParm('LLLXIDC3'
     C                                                    : BDLXIDC3)
     C                   ENDIF
      *
      ** - Identification 3
      *
     C                   IF        BDLXIDE3 <> *Blanks
     C                   EVAL      WkSoap = WkSoap +
     C                                      getOldSoapParm('LLLXIDE3'
     C                                                    : BDLXIDE3)
     C                   ENDIF
      *
      ** - Posting Amount 1
      *
     C                   IF        BDLXPTA1 <> *Blanks
     C                   EVAL      WkSoap = WkSoap +
     C                                      getOldSoapParm('LLLXPTA1'
     C                                                    : BDLXPTA1)
     C                   ENDIF
      *
      ** - Debit / Credit Ind 1
      *
     C                   IF        BDLXDCI1 <> *Blanks
     C                   EVAL      WkSoap = WkSoap +
     C                                      getOldSoapParm('LLLXDCI1'
     C                                                    : BDLXDCI1)
     C                   ENDIF
      *
      ** - Posting Amount 2
      *
     C                   IF        BDLXPTA2 <> *Blanks
     C                   EVAL      WkSoap = WkSoap +
     C                                      getOldSoapParm('LLLXPTA2'
     C                                                    : BDLXPTA2)
     C                   ENDIF
      *
      ** - Debit / Credit Ind 2
      *
     C                   IF        BDLXDCI2 <> *Blanks
     C                   EVAL      WkSoap = WkSoap +
     C                                      getOldSoapParm('LLLXDCI2'
     C                                                    : BDLXDCI2)
     C                   ENDIF
      *
      ** - Posting Amount 3
      *
     C                   IF        BDLXPTA3 <> *Blanks
     C                   EVAL      WkSoap = WkSoap +
     C                                      getOldSoapParm('LLLXPTA3'
     C                                                    : BDLXPTA3)
     C                   ENDIF
      *
      ** - Debit / Credit Ind 3
      *
     C                   IF        BDLXDCI3 <> *Blanks
     C                   EVAL      WkSoap = WkSoap +
     C                                      getOldSoapParm('LLLXDCI3'
     C                                                    : BDLXDCI3)
     C                   ENDIF
      *
      ** GLJEPDTD
      *
      ** - Posting Date (New)
      *
     C                   IF        BDNPSDT <> *Blanks
     C                   EVAL      WkSoap = WkSoap +
     C                                      getOldSoapParm('DDPSDN'
     C                                                    : BDNPSDT)
     C                   ENDIF
      *
      ** Submit Soap
      *
     C                   EXSR      SrSbmSOAP
      *
     C     SrBITPE       ENDSR
      *
      *****************************************************************
      *
      /EJECT
      *****************************************************************
      *                                                               *
      * SrSbmSOAP  - Submit Soap                                      *
      *                                                               *
      *****************************************************************
      *
     C     SrSbmSOAP     BEGSR
      *
      ** Setup authentification data
      *
     C                   EVAL      WkProcRtrn =
     C                                 http_setauth( HTTP_AUTH_BASIC
     C                                             : WkUserId
     C                                             : WkPassWord)
      *
      ** Call the Web Service
      *
     C                   EVAL      WkProcRtrn =
     C                                 MPlusAPICoarse( WkIpAddress
     C                                               : WkZone
     C                                               : WKMsgType
     C                                               : WkAction
     C                                               : WkSoap
     C                                               : WkMidasErrs
     C                                               : WkMidasWarns
     C                                               : WkOverErrs
     C                                               : WkSystemErrs)
      *
     C                   IN        BFWBCONF
      *
      ** If Web Service failed
      *
     C                   IF        WkProcRtrn <> 1
      *
     C                   EVAL      P_RtrnCode = '*ERROR'                        Return Code
      *
     C                   IF        BfCrash = 'Y'
     C****               CALLP     http_crash
     C                   DUMP
     C                   ENDIF
      *
     C                   ENDIF
      *
      ** If Transaction failed
      *
     C                   IF        WkMidasErrs.eCount <> 0
     C                   EVAL      P_RtrnCode = '*FAILED'                       Return Code
     C                   ENDIF
      *
      ** - Midas System Error Messages
      *
     C                   IF        WkSystemErrs.sCount <> 0
     C                   EVAL      P_RtrnCode = '*ERROR'                        Return Code
     C                   ENDIF
      *
      ** Debug details
      *
     C                   IF        BfDebug = 'Y'
      *
     C**********         OPEN      GL000587P1                                               MD029739
     C                   OPEN      DI000587P1                                               MD029739
      *
     C                   WRITE     HEADP1
      *
      ** Print Batch Id and Front Office Transaction
      *
     C                   EVAL      RDETAIL = 'Transaction reference'
     C                   WRITE     DETLP1
     C                   EVAL      RDETAIL = '---------------------'
     C                   WRITE     DETLP1
     C                   EVAL      RDETAIL = 'Transaction type:       '
     C                                        + WkMsgType
     C                   WRITE     DETLP1
     C                   IF        WkMsgType = 'BITH'
     C                   EVAL      RDETAIL = 'Batch Id:               ' + BHBTID
     C                   WRITE     DETLP1
     C                   EVAL      RDETAIL = 'Front office reference: ' + BHFRNT
     C                   WRITE     DETLP1
     C                   ELSE
     C                   EVAL      RDETAIL = 'Batch Id:               ' + BDBTID
     C                   WRITE     DETLP1
     C                   EVAL      RDETAIL = 'Front office reference: ' + BDFOTR
     C                   WRITE     DETLP1
     C                   ENDIF
     C                   EVAL      RDETAIL = *Blanks
     C                   WRITE     DETLP1
      *
      ** Soap details
      *
     C                   EVAL      RDETAIL = 'SOAP details'
     C                   WRITE     DETLP1
     C                   EVAL      RDETAIL = '------------'
     C                   WRITE     DETLP1
     C                   EVAL      RDETAIL = *Blanks
     C                   WRITE     DETLP1
      *
     C                   EVAL      WkSoapDtl = WkSoap
      *
     C                   EVAL      WkPos = 1
     C                   DOW       WkPos > *Zeros
     C                   EVAL      WkPos = %SCAN('&lt;':WkSoapDtl:WkPos)
     C                   IF        WkPos = *Zeros
     C                   LEAVE
     C                   ENDIF
     C                   EVAL      %SUBST(WkSoapDtl:WkPos:4) = '  < '
     C                   EVAL      WkPos = WKpos + 4
     C                   ENDDO
      *
     C                   EVAL      WkPos = 1
     C                   DOW       WkPos > *Zeros
     C                   EVAL      WkPos = %SCAN('&gt;':WkSoapDtl:WkPos)
     C                   IF        WkPos = *Zeros
     C                   LEAVE
     C                   ENDIF
     C                   EVAL      %SUBST(WkSoapDtl:WkPos:4) = ' >  '
     C                   EVAL      WkPos = WKpos + 4
     C                   ENDDO
      *
      ** Print SOAP details
      *
     C                   Eval      WkPos = 1
     C                   EVAL      RDETAIL = *Blanks
     C                   DOU       RDETAIL = *Blanks OR
     C                             WkPos >= 6000
     C                   EVAL      RDETAIL = %SUBST(WkSoapDtl:WkPos:100)
     C                   IF        (OflLn1 - PrtLn1) < 2                                    MD023629
     C                   WRITE     HEADP1                                                   MD023629
     C                   ENDIF                                                              MD023629
     C                   WRITE     DETLP1
     C                   EVAL      WkPos = WkPos + 100
     C                   ENDDO
      *
      ** - Midas Error Messages
      *
     C                   IF        WkMidasErrs.eCount <> 0
      *
     C                   IF        (OflLn1 - PrtLn1) < 7                                    MD023629
     C                   WRITE     HEADP1                                                   MD023629
     C                   ENDIF                                                              MD023629
     C                   EVAL      RDETAIL = *Blanks
     C                   WRITE     DETLP1
     C                   EVAL      RDETAIL = 'Midas Error Messages'
     C                   WRITE     DETLP1
     C                   EVAL      RDETAIL = '--------------------'
     C                   WRITE     DETLP1
     C                   EVAL      RDETAIL = *Blanks
     C                   WRITE     DETLP1
      *
     C                   EVAL      WkNbErr   = WkMidasErrs.eCount               Number of errors
      *
     C     1             DO        WkNbErr       WkIdx
      *
     C                   EVAL      WkFldErr  =
     C                             WkMidasErrs.midasErr(WkIdx).eFldName         Field in error
     C                   EVAL      RDETAIL = WkFldErr
     C                   IF        (OflLn1 - PrtLn1) < 3                                    MD023629
     C                   WRITE     HEADP1                                                   MD023629
     C                   ENDIF                                                              MD023629
     C                   WRITE     DETLP1
      *
     C                   EVAL      WkDescErr =
     C                             WkMidasErrs.midasErr(WkIdx).eDescription     Description of error
     C                   MOVEL     WkDescErr     RDETAIL
     C                   WRITE     DETLP1
     C                   MOVE      WkDescErr     RDETAIL
     C                   WRITE     DETLP1
      *
     C                   ENDDO
      *
     C                   ENDIF
      *
      ** - Midas Warning messages
      *
     C                   IF        WkMidasWarns.wnCount <> 0
      *
     C                   IF        (OflLn1 - PrtLn1) < 7                                    MD023629
     C                   WRITE     HEADP1                                                   MD023629
     C                   ENDIF                                                              MD023629
     C                   EVAL      RDETAIL = *Blanks
     C                   WRITE     DETLP1
     C                   EVAL      RDETAIL = 'Midas Warning messages'
     C                   WRITE     DETLP1
     C                   EVAL      RDETAIL = '----------------------'
     C                   WRITE     DETLP1
     C                   EVAL      RDETAIL = *Blanks
     C                   WRITE     DETLP1
      *
     C                   EVAL      WkNbErr   = WkMidasWarns.wnCount             Number of errors
      *
     C     1             DO        WkNbErr       WkIdx
      *
     C                   EVAL      WkFldErr  =
     C                             WkMidasWarns.midasWarn(WkIdx).wFldName       Field in error
     C                   IF        (OflLn1 - PrtLn1) < 3                                    MD023629
     C                   WRITE     HEADP1                                                   MD023629
     C                   ENDIF                                                              MD023629
     C                   EVAL      RDETAIL = WkFldErr
     C                   WRITE     DETLP1
      *
     C                   EVAL      WkDescErr =
     C                             WkMidasWarns.midasWarn(WkIdx).wDescription   Description of error
     C                   MOVEL     WkDescErr     RDETAIL
     C                   WRITE     DETLP1
     C                   MOVE      WkDescErr     RDETAIL
     C                   WRITE     DETLP1
      *
     C                   ENDDO
      *
     C                   ENDIF
      *
      ** - Midas Overridable Error Messages
      *
     C                   IF        WkOverErrs.oCount <> 0
      *
     C                   IF        (OflLn1 - PrtLn1) < 8                                    MD023629
     C                   WRITE     HEADP1                                                   MD023629
     C                   ENDIF                                                              MD023629
     C                   EVAL      RDETAIL = *Blanks
     C                   WRITE     DETLP1
     C                   EVAL      RDETAIL = 'Midas Overridable Error Messages'
     C                   WRITE     DETLP1
     C                   EVAL      RDETAIL = '--------------------------------'
     C                   WRITE     DETLP1
     C                   EVAL      RDETAIL = *Blanks
     C                   WRITE     DETLP1
      *
     C                   EVAL      WkNbErr   = WkOverErrs.oCount                Number of errors
      *
     C     1             DO        WkNbErr       WkIdx
      *
     C                   IF        (OflLn1 - PrtLn1) < 4                                    MD023629
     C                   WRITE     HEADP1                                                   MD023629
     C                   ENDIF                                                              MD023629
     C                   EVAL      WkFldErr  =
     C                             WkOverErrs.overErr(WkIdx).oFldName           Field in error
     C                   EVAL      RDETAIL = WkFldErr
     C                   WRITE     DETLP1
      *
     C                   EVAL      WkDescErr =
     C                             WkOverErrs.overErr(WkIdx).oDescription       Description of error
     C                   MOVEL     WkDescErr     RDETAIL
     C                   WRITE     DETLP1
     C                   MOVE      WkDescErr     RDETAIL
     C                   WRITE     DETLP1
      *
     C                   EVAL      WkOveridden =
     C                             WkOverErrs.overErr(WkIdx).isOveridden        Overriden flag
     C                   EVAL      RDETAIL = WkOveridden
     C                   WRITE     DETLP1
      *
     C                   ENDDO
      *
     C                   ENDIF
      *
      ** - Midas System Error Messages
      *
     C                   IF        WkSystemErrs.sCount <> 0
      *
     C                   IF        (OflLn1 - PrtLn1) < 6                                    MD023629
     C                   WRITE     HEADP1                                                   MD023629
     C                   ENDIF                                                              MD023629
     C                   EVAL      RDETAIL = *Blanks
     C                   WRITE     DETLP1
     C                   EVAL      RDETAIL = 'Midas System Error Messages'
     C                   WRITE     DETLP1
     C                   EVAL      RDETAIL = '---------------------------'
     C                   WRITE     DETLP1
     C                   EVAL      RDETAIL = *Blanks
     C                   WRITE     DETLP1
      *
     C                   EVAL      WkNbErr   = WkSystemErrs.sCount              Number of errors
      *
     C     1             DO        WkNbErr       WkIdx
      *
     C                   IF        (OflLn1 - PrtLn1) < 2                                    MD023629
     C                   WRITE     HEADP1                                                   MD023629
     C                   ENDIF                                                              MD023629
     C                   EVAL      WkDescErr =
     C                             WkSystemErrs.systemErr(WkIdx).sDescription   Description of error
     C                   MOVEL     WkDescErr     RDETAIL
     C                   WRITE     DETLP1
     C                   MOVE      WkDescErr     RDETAIL
     C                   WRITE     DETLP1
      *
     C                   ENDDO
      *
     C                   ENDIF
      *
     C                   IF        (OflLn1 - PrtLn1) < 4                                    MD023629
     C                   WRITE     HEADP1                                                   MD023629
     C                   ENDIF                                                              MD023629
      *
     C                   WRITE     TRLRP1
      *
     C**********         CLOSE     GL000587P1                                               MD029739
     C                   CLOSE     DI000587P1                                               MD029739
      *
     C                   ENDIF
      *
     C     SrSbmSOAPE    ENDSR
      *
      /EJECT
      *****************************************************************
      *                                                               *
      * *INZSR - Program initialisation routine                       *
      *                                                               *
      * Called by: Implicitly on program activation                   *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
      *
     C     *INZSR        BEGSR
      *
     C     *ENTRY        PLIST
     C                   PARM                    P_RtrnCode                     Return Code
     C                   PARM                    P_Option                       Option
     C                   PARM                    P_ActCode                      Action Code
     C                   PARM                    P_TransType                    Transaction Type
     C     DSACBHTD      PARM      DSACBHTD      P_BITH                         Header details
     C     DSACBDTD      PARM      DSACBDTD      P_BITP                         Item details
      *
      *
      ** Retrieve Bank ICD details.
      *
     C                   CALL      'AOBANKR0'
     C                   PARM      '*DBERR '     P@RTCD
     C                   PARM      '*KEY'        P@OPTN
     C     DsBANK        PARM      *Blanks       DSFDY
      *
      ** Retrieve IP address
      *
     C                   EVAL      P@OP01 = 'BankFusionIPAddress'
     C                   CALL      'GPAOSVALR0'
     C                   PARM      *Blanks       P@RTCD
     C                   PARM                    P@OP01
     C                   PARM                    P@VL01
     C                   PARM                    P@OP02
     C                   PARM                    P@VL02
     C                   PARM                    P@OP03
     C                   PARM                    P@VL03
     C                   PARM                    P@OP04
     C                   PARM                    P@VL04
     C                   PARM                    P@OP05
     C                   PARM                    P@VL05
     C                   PARM                    P@OP06
     C                   PARM                    P@VL06
     C                   PARM                    P@OP07
     C                   PARM                    P@VL07
     C                   PARM                    P@OP08
     C                   PARM                    P@VL08
     C                   PARM                    P@OP09
     C                   PARM                    P@VL09
     C                   PARM                    P@OP10
     C                   PARM                    P@VL10
      *
     C     P@RTCD        IFEQ      *Blanks
     C                   EVAL      WkIpAddress = P@VL01
     C                   ENDIF
      *
      ** Retrieve Global Master Library, System and Accounting Rules User
      *
     C                   EVAL      P@OP01 = 'GlobalSystemPrefix'
     C                   EVAL      P@OP02 = 'ZoneSystemName'
     C                   EVAL      P@OP03 = 'AcctRulesUser'
     C                   EVAL      P@OP04 = 'AcctRulesAutoAuth'                             MD024534
      *
     C                   CALL      'AOSVALR0'
     C                   PARM      *Blanks       P@RTCD
     C                   PARM                    P@OP01
     C                   PARM      *Blanks       P@VL01
     C                   PARM                    P@OP02
     C                   PARM                    P@VL02
     C                   PARM                    P@OP03
     C                   PARM                    P@VL03
     C                   PARM                    P@OP04
     C                   PARM                    P@VL04
     C                   PARM                    P@OP05
     C                   PARM                    P@VL05
     C                   PARM                    P@OP06
     C                   PARM                    P@VL06
     C                   PARM                    P@OP07
     C                   PARM                    P@VL07
     C                   PARM                    P@OP08
     C                   PARM                    P@VL08
     C                   PARM                    P@OP09
     C                   PARM                    P@VL09
     C                   PARM                    P@OP10
     C                   PARM                    P@VL10
      *
     C     P@RTCD        IFEQ      *Blanks
      *
     C                   EVAL      WkValLstLoc = %TRIM(P@VL01) + 'GMLIB'        Value List Location
     C                   EVAL      WkZone      = P@VL02                         Zone
     C                   EVAL      WkUserId    = P@VL03                         User Id
     C                   IF        P@VL04 = 'Y'                                             MD024534
     C                   EVAL      WKAutoAuth = P@VL04                          Auto-Author.MD024534
     C                   ELSE                                                               MD024534
     C                   EVAL      WKAutoAuth = 'N'                                         MD024534
     C                   ENDIF                                                              MD024534
      *
     C                   ENDIF
      *
      ** Retrieve password
      *
     C                   CALL      'UT000033'
     C                   PARM      *Blanks       P@RTCD
     C                   PARM      'F'           P@ACTN                         Find
     C                   PARM      'GPLDAPVL'    P@VLIS                         Valid List
     C                   PARM      WkValLstLoc   P@VLIB                         Valid List Location
     C                   PARM      WkUserId      P@USER                         User Id
     C                   PARM      *Blanks       P@PWD1                         Password 1
     C                   PARM      *Blanks       P@PWD2                         Password 2
     C                   PARM      *Blanks       P@DESC                         Description
      *
     C     P@RTCD        IFEQ      *Blanks
     C                   EVAL      WkPassWord  = P@PWD1                         Password
     C                   ENDIF
      *
     C     EINZSR        ENDSR
      *
      /EJECT
      *********************************************************************                MD024681A
      *                                                                   *                MD024681A
      * CHKAMP -  Check if special Character & is existing in a variable  *                MD024681A
      *                                                                   *                MD024681A
      * Called by:                                                        *                MD024681A
      *                                                                   *                MD024681A
      * Calls: None                                                       *                MD024681A
      *                                                                   *                MD024681A
      *********************************************************************                MD024681A
     C     CHKAMP        BEGSR                                                             MD024681A
                                                                                           MD024681A
     C                   Eval      Pos =  %SCAN ('&' : ChkFld)                             MD024681A
                                                                                           MD024681A
     C                   DOW       Pos <> 0                                                MD024681A
                                                                                           MD024681A
     C                   Eval      Tmp =  %SUBST(ChkFld:1:Pos)                             MD024681A
                                                                                           MD024681A
     C                   Eval      Tmp3 = %TRIM(Tmp) + 'amp;'                              MD024681A
                                                                                           MD024681A
     C                   Eval      Pos = Pos + 1                                           MD024681A
     C                   Eval      Tmp2 = %SUBST(ChkFld:Pos)                               MD024681A
                                                                                           MD024681A
     C                   Eval      ChkFld = *blanks                                        MD024681A
     C                   Eval      ChkFld = Tmp3 + %TRIMR(Tmp2)                            MD024681A
                                                                                           MD024681A
     C                   Eval      Pos =  %SCAN ('&' : ChkFld : Pos)                       MD024681A
                                                                                           MD024681A
     C                   ENDDO                                                             MD024681A
                                                                                           MD024681A
     C                   Eval      ChkFld = %TRIM(ChkFld)                                  MD024681A
                                                                                           MD024681A
     C                   ENDSR                                                             MD024681A
      *********************************************************************
      *                                                                   *
      * *PSSR  - Program exception error routine                          *
      *                                                                   *
      * Called by:                                                        *
      *                                                                   *
      * Calls: None                                                       *
      *                                                                   *
      *********************************************************************
     C     *PSSR         BEGSR
      *
     C                   IF        Recursive = *blank
     C                   EVAL      Recursive = 'Y'
     C                   DUMP
     C                   ENDIF
      *
     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   EVAL      *INLR = *ON
     C                   RETURN
      *
     C     PSSRE         ENDSR
      *
      ********************************************************************
