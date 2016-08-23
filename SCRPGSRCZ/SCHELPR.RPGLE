     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2003')
      *****************************************************************
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('Midas SC Help processing API')                         *
      *****************************************************************
      *                                                               *
      *  Midas - System Control Module                                *
      *                                                               *
      *  SCHELPR - Help Processing                                    *
      *                                                               *
      *  Function:  This program returns the appropriate html page    *
      *             for the calling program.                          *
      *                                                               *
      *  Called By: APTRANR                                           *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2003            *
      *                                                               *
      *  Last Amend No. CER059             Date 19Jul10               *
      *  Prev Amend No. BUG26787           Date 24Nov09               *
      *                 BUG27980           Date 05Aug10               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      *                 BG13987            Date 17May07               *
      *                 BG13727            Date 11Apr07               *
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CRE026             Date 24May06               *
      *                 239647             Date 01May06               *
      *                 CSC021  *CREATE    Date 15Dec03               *
      *                                                               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CER059 - German Feature Upgrade to Delhi                     *
      *  BUG26787 - Error in Retrieving Help Information.  Increase   *
      *             receiver length to maximum. Applied fix 252969.   *
      *  BUG27980 - Remove DBGVIEW (Recompile).                       *
      *  BG13987 - Ignore Consumer Banking Help search if found in    *
      *            Midas Plus Help Search                             *
      *  BG13727 - Allow use of alternative help references.          *
      *  CRE026 - Consumer Banking                                    *
      *  239647 - Use HTTPs for root help link.                       *
      *  CSC021 - Help Processing                                     *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  Use of indicators.                                           *
      *                                                               *
      *    XX         Function of Indicator                           *
      *    98         Date Format                                     *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  S U B R O U T I N E  I N D E X                               *
      *                                                               *
      * Webfac - Get job Information for Webfacing Job                *
      * AOHELP - Call access object to retrieve the link              *
      * CrtLnk - Create the HTML link                                 *
      * *PSSR - Error processing                                      *
      * *INZSR - Initialise                                           *
      *                                                               *
      *    The *INZSR subroutine will only get called automatically   *
      *    on entry to the module the first time it is run            *
      *    (unless you end the program with LR on).  Similarly        *
      *    D-spec initialisation only happens the first time.  Use    *
      *    RESET for subsequent passes.                               *
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
      ** ¦ D-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
 
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ Automatically included D-specs       ¦
      ** ¦ ==============================       ¦
      ** +--------------------------------------+
      **
      **-----------------------------------------------------------------------
      ** The following /COPY line includes (among others) the LDA layout
      ** and the copyright array definition:
     D/COPY ZACPYSRC,STD_D_SPEC
      **-----------------------------------------------------------------------
 
      **-----------------------------------------------------------------------
      ** The following /COPY includes the standard API declares:
     D/COPY ZACPYSRC,STDDECLARE
      **-----------------------------------------------------------------------
 
      **-----------------------------------------------------------------------
      ** The following /COPY line includes all the defined fields in the
      ** Program Status Data Structures.  They have meaningful
      ** names, prefixed by 'PS'.
     D/COPY ZACPYSRC,PSDS
      **-----------------------------------------------------------------------
 
      **-----------------------------------------------------------------------
     D/COPY ZACPYSRC,ERR_ARRAYS
      **-----------------------------------------------------------------------
 
      ** +--------------------------------------+
      ** ¦ End of automatically included D-specs¦
      ** ¦ =====================================¦
      ** +--------------------------------------+
      *
     D RUNDAT        E DS                  EXTNAME(RUNDAT)
      *
      ** Data Area giving Installation Control Details
 
      ** The following /COPY line includes all the defined fields in the
      ** PSDS.  They have meaningful names, prefixed by 'PS'.
 
      *
      ** +--------------------------------------+
      ** ¦ Named constants                      ¦
      ** ¦ ===============                      ¦
      ** +--------------------------------------+
 
      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
     D/COPY QSYSINC/QRPGLESRC,QDMLOPNF
      ** Format of Openfiles file Header and Records
     D/COPY QSYSINC/QRPGLESRC,QWCATTR
      ** Format of Job Description Information
 
      ** Error Data Structure for the Open File Call
     D   ERRC0100      DS
     D    BYTESPROV            1      4B 0 INZ(144)
     D    BYTESAVAIL           5      8B 0 INZ(0)
     D    EXCEPID              9     15A   INZ(*BLANKS)
     D    RESVD2              16     16A   INZ(*BLANKS)
     D    EXCEPTION           17    144A   INZ(*BLANKS)
                                                                                              CRE026
      ** DS for Access Objects - short data structure                                         CRE026
     D DSFDY         E DS                  EXTNAME(DSFDY)                                     CRE026
 
     D DSSDY         E DS                  EXTNAME(DSSDY)
     D SCHELP        E DS                  EXTNAME(SCHELPPD)
                                                                                              CRE026
      ** Externally described DS for SAR details                                              CRE026
     D SCSARD        E DS                  EXTNAME(SCSARDPD)                                  CRE026
 
      ** Index for arrays of of error message ids etc
     D Idx             S              3P 0
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
     D***ReceiverVar*****S           9999                                                     CRE026
     D*ReceiverVar     S          32764                                              CRE026 BUG26787
     D*ReceiverLen     S              4B 0 INZ(9999)                                        BUG26787
     D ReceiverVar     S          32767                                                     BUG26787
     D ReceiverLen     S              5B 0 INZ(32767)                                       BUG26787
     D ReceiverFmt     S              8
     D JobIDVar        S             56
     D JobIDFmt        S              8
     D ErrorCode       S              8
     D OpenFilRem      S                   Like(QDMNOFA)
     D FileLen         S                   Like(QDMLOFE)
     D Start           S                   Like(QDMLOFE)
     D Reclen          S              5  0
     D DisplayFile     S              1
     D ReturnC7        S              7
     D RtnCode         S              7
     D Option          S              7
     D Type            S              1
     D KeyInfo         S            200
     D KeyInformation  S            201
     D HTMLPage        S            807
     D @RUN            S              1
     D OVRDBFCmd       S             50    INZ('OVRDBF SCHELPL1 SCAHLPL1')                   BG13727
     D DLTOVRCmd       S             50    INZ('DLTOVR SCHELPL1')                            BG13727
     D AltHelp         S              1    INZ('N')                                          BG13727
     D HTTPS           S              1                                                      BG13727
     D Root            S            200                                                      BG13727
     D Command         S             50                                                      BG13727
     D CommandLen      S             15  5 INZ(50)                                           BG13727
 
      ** Parameters for call to access object modules                                         CRE026
     D PRtCd           S              7A                                                      CRE026
     D POptn           S              7A                                                      CRE026
     D CRE026          S              1A                                                      CRE026
                                                                                              CRE026
      * AOSVALR0 Call to access object fields
     D SVALKK          C                   CONST('RootHelpLocation')            Key to SDSVALPD
     D WHttps          C                   CONST('HTTPsEnabled')                              239647
     D AltHelpSysVal   S             20    INZ('AltRootHelpLocation')                        BG13727
     D AOHTMLPage      S            600
     D LinkRoot        S            207
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *
      ** +--- Start of Main processing -----------------------------------+
      ** ¦                                                                ¦
      ** ¦ Initial processing is performed automatically: the *INZSR is   ¦
      ** ¦ executed at program activation.                                ¦
      ** ¦                                                                ¦
      ** +----------------------------------------------------------------+
 
      *********************************************************************
      * MAIN PROCEDURE                                                    *
      *********************************************************************
      *
      ** Read in Installation Data
      *
     C     *DTAARA       DEFINE                  RUNDAT
     C                   IN        RUNDAT
 
      *
      ** If the program was called from Webfacing
      *
     C                   If        Type = 'W'
     C                   EXSR      WebFac
     C                   EndIf
 
      *
      ** If the program was called from a Java front end
      *
     C                   If        Type = 'J'
     C                   EXSR      AOHELP
     C                   EndIf
 
      *
      ** Create the link to the page on the system
      *
     C                   EXSR      CrtLnk
 
     C                   Eval      *INLR = *on
     C                   Return
 
      **********************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * WebFac - If Called from Webfacing this subroutine is called   *
      *                                                               *
      * Called by: Main                                               *
      *                                                               *
      * Calls: AOHELPR0                                               *
      *                                                               *
      *****************************************************************
 
     C     WebFac        BEGSR
 
      * Set up the default variables for the call to the API
 
     C                   Eval      ReceiverFmt = 'OPNF0100'
     C                   Eval      QWCJN02     = %SubSt(KeyInfo:17:10)
     C                   Eval      QWCJNBR00   = %SubSt(KeyInfo:1:6)
     C                   Eval      QWCUN       = %SubSt(KeyInfo:7:10)
     C                   Eval      JobIDFmt    = 'JIDF0100'
     C                   Eval      QWCERVED06  = X'0000'
     C                   Eval      QWCTI00     = 3
     C                   Eval      QWCTI01     = X'0000000000000000'
 
     C                   CALL      'QDMLOPNF'
     C                   PARM                    ReceiverVar
     C                   PARM                    ReceiverLen
     C                   PARM                    ReceiverFmt
     C                   PARM                    QWCF0100
     C                   PARM                    JobIDFmt
     C     ERRC0100      PARM                    ERRC0100
 
     C                   IF        BYTESAVAIL <> 0
     C                   MOVEL     'QDMLOPNF'    DBFile                         ************
     C                   MOVEL     '001'         DBase                          * DBERR 001*
     C                   MOVEL     Option        DBKey                          ************
     C                   EXSR      *PSSR
     C                   EndIf
 
      * Put the returned variable into the header record and retrieve the length of each record
     C                   Eval      QDMF0100 = ReceiverVar
     C                   Eval      FileLen = QDMLOFE
 
      * Calculate the length of the returned file
     C                   Eval      RecLen = (QDMNOFA * FileLen) + QDMTLOOF
 
      * Set the start position of the substring to the last record in the file and
      * put the value into the relevent format.  Calculate the number of open files remaining.
     C                   Eval      Start = RecLen - (FileLen - 1)
     C                   Eval      QDMOPNFE = %SubSt(ReceiverVar:Start:FileLen)
     C                   Eval      OpenFilRem = QDMNOFA - 1
     C                   Eval      DisplayFile = 'N'
 
      * Do while the last record wasn't a display file and there are still records
     C                   DoW       (DisplayFile = 'N') and (OpenFilRem <> 0)
 
      * If the last record was a display file and it was not a system display file set the
      * KeyInfo field to the file name and format and call the access object sub routine
      * Else read the previous record
     C                   If        (QDMFILT = 'DSPF') And
     C                             (QDMFILL <> 'QSYS') AND (QDMFILL <> 'QPDA')
     C                   Eval      KeyInfo = %trim(QDMFILN)+'.'+%trim(QDMRF)
     C                   Eval      DisplayFile = 'Y'
     C                   EXSR      AOHELP
     C                   Eval      OpenFilRem = 0
 
     C                   Else
     C                   Eval      Start = Start - FileLen
     C                   Eval      QDMOPNFE = %SubSt(ReceiverVar:Start:FileLen)
     C                   Eval      OpenFilRem = OpenFilRem - 1
     C                   EndIf
 
     C                   EndDo
 
     C                   ENDSR
 
      **********************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * AOHELP - Call to Access Object to get the Document and Page   *
      *                                                               *
      * Called by: Main                                               *
      *            WebFac                                             *
      *                                                               *
      * Calls: AOHELPR0                                               *
      *                                                               *
      *****************************************************************
 
     C     AOHELP        BEGSR
 
     C                   Eval      Option = '*KEY'
 
      * Check for alternative help first; override to alternative help file.                 BG13727
     C                   EVAL      Command = OVRDBFCmd                                       BG13727
     C                   CALL      'QCMDEXC'                                                 BG13727
     C                   PARM                    Command                                     BG13727
     C                   PARM                    CommandLen                                  BG13727
      *
     C                   CALL      'AOHELPR0'                                                BG13727
     C                   PARM                    ReturnC7                                    BG13727
     C                   PARM                    Option                                      BG13727
     C                   PARM                    KeyInfo                                     BG13727
     C                   PARM                    AOHTMLPage                                  BG13727
     C     SCHELP        PARM                    DSSDY                                       BG13727
      *
      * Delete override and check for success; if not found then check main help.            BG13727
     C                   EVAL      Command = DLTOVRCmd                                       BG13727
     C                   CALL      'QCMDEXC'                                                 BG13727
     C                   PARM                    Command                                     BG13727
     C                   PARM                    CommandLen                                  BG13727
      *
     C                   IF        ReturnC7 <> *blanks                                       BG13727
     C                   IF        ReturnC7 <> '*NRF'                                        BG13727
     C                   EVAL      DBFile = 'SCAHLPPD'                                       BG13727
     C                   EVAL      DBase = 004                                               BG13727
     C                   EVAL      DBKey = Option                                            BG13727
     C                   EXSR      *PSSR                                                     BG13727
     C                   ELSE                                                                BG13727
     C                   EVAL      ReturnC7 = *blanks                                        BG13727
      *
     C                   Call      'AOHELPR0'
     C                   Parm                    ReturnC7
     C                   Parm                    Option
     C                   Parm                    KeyInfo
     C                   Parm                    AOHTMLPage
     C     SCHELP        Parm                    DSSDY
      *
      * DATABASE ERROR
      *
     C     ReturnC7      IFNE      *BLANKS
     C     ReturnC7      ANDNE     '*NRF'
     C                   MOVEL     'SCHELPPD'    DBFile                         ************
     C                   MOVEL     '002'         DBase                          * DBERR 002*
     C                   MOVEL     Option        DBKey                          ************
     C                   EXSR      *PSSR
     C                   END
 
      ** If no record can be found in the database and Consumer Banking                       CRE026
      ** is installed, call the Consumer Banking Help API                                     CRE026
     C                   If        CRE026 = 'Y'                                               CRE026
     C                   If        ReturnC7 = '*NRF'                                          CRE026
     C                   Eval      ReturnC7 = *Blanks                                         CRE026
     C                   Eval      KeyInfo = QWCJNBR00 + QWCUN + QWCJN02 +                    CRE026
     C                                       QDMFILN                                          CRE026
     C                   Call      'AOEHLPR0'                                                 CRE026
     C                   Parm                    ReturnC7                                     CRE026
     C                   Parm                    Option                                       CRE026
     C                   Parm                    KeyInfo                                      CRE026
     C                   Parm                    AOHTMLPage                                   CRE026
     C     SCHELP        Parm                    DSSDY                                        CRE026
     C**********         EndIf                                                        CRE026 BG13987
                                                                                              CRE026
      ** The Consumer Banking menu option should now have been                                CRE026
      ** returned.  Need to retrieve the associated help document                             CRE026
      ** reference.  Set option to key on file and set KeyInfo to                             CRE026
      ** the menu option                                                                      CRE026
     C                   Eval      Option = '*KEY'                                            CRE026
     C                   Eval      KeyInfo = AOHTMLPage                                       CRE026
                                                                                              CRE026
     C                   Call      'AOHELPR0'                                                 CRE026
     C                   Parm                    ReturnC7                                     CRE026
     C                   Parm                    Option                                       CRE026
     C                   Parm                    KeyInfo                                      CRE026
     C                   Parm                    AOHTMLPage                                   CRE026
     C     SCHELP        Parm                    DSSDY                                        CRE026
                                                                                              CRE026
      *                                                                                       CRE026
      ** Database error                                                                       CRE026
      *                                                                                       CRE026
     C     ReturnC7      IFNE      *BLANKS                                                    CRE026
     C     ReturnC7      ANDNE     '*NRF'                                                     CRE026
     C                   MOVEL     'SCHELPPD'    DBFile                                       CRE026
     C                   MOVEL     '003'         DBase                                        CRE026
     C                   MOVEL     Option        DBKey                                        CRE026
     C                   EXSR      *PSSR                                                      CRE026
     C                   END                                                                  CRE026
                                                                                             BG13987
     C                   EndIf                                                               BG13987
                                                                                              CRE026
     C                   EndIf                                                                CRE026
                                                                                              CRE026
      * If no record can be found in the database then set the HTMLPage to the default
     C                   If        ReturnC7 = '*NRF'
     C                   Eval      AOHTMLPage = 'No_Help_Available.htm'
     C                   EndIf
 
     C                   ENDIF                                                               BG13727
      * Else if record was found on alternative help then set flag.                          BG13727
     C                   ELSE                                                                BG13727
     C                   EVAL      AltHelp = 'Y'                                             BG13727
     C                   ENDIF                                                               BG13727
      *
     C                   ENDSR
 
      /EJECT
      *****************************************************************
      *                                                               *
      * CrtLnk - Create the full Help Link                            *
      *                                                               *
      * Called by: Main                                               *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
 
     C     CrtLnk        BEGSR
      *                                                                               239647 BG13727
      ***Determine*if*HTTPs*serving*is*enabled.*                                      239647 BG13727
      **********                                                                      239647 BG13727
     C**********         CALL      'AOSVALR0'                                         239647 BG13727
     C**********         PARM                    @RTCD                                239647 BG13727
     C**********         PARM      WHttps        SVALK1                               239647 BG13727
     C**********         PARM                    SVAL1                                239647 BG13727
     C**********         PARM                    SVALK2                               239647 BG13727
     C**********         PARM                    SVAL2                                239647 BG13727
     C**********         PARM                    SVALK3                               239647 BG13727
     C**********         PARM                    SVAL3                                239647 BG13727
     C**********         PARM                    SVALK4                               239647 BG13727
     C**********         PARM                    SVAL4                                239647 BG13727
     C**********         PARM                    SVALK5                               239647 BG13727
     C**********         PARM                    SVAL5                                239647 BG13727
     C**********         PARM                    SVALK6                               239647 BG13727
     C**********         PARM                    SVAL6                                239647 BG13727
     C**********         PARM                    SVALK7                               239647 BG13727
     C**********         PARM                    SVAL7                                239647 BG13727
     C**********         PARM                    SVALK8                               239647 BG13727
     C**********         PARM                    SVAL8                                239647 BG13727
     C**********         PARM                    SVALK9                               239647 BG13727
     C**********         PARM                    SVAL9                                239647 BG13727
     C**********         PARM                    SVALK10                              239647 BG13727
     C**********         PARM                    SVAL10                               239647 BG13727
      **********                                                                      239647 BG13727
     C*****@RTCD         IFNE      *BLANKS                                            239647 BG13727
      **********                                                                      239647 BG13727
     C******LOCK         IN        LDA                                                239647 BG13727
      **********                                                                      239647 BG13727
     C*****SVAL10        IFEQ      '*NRF'                                             239647 BG13727
     C**********         MOVE      SVALK10       DBKEY                                239647 BG13727
     C**********         ENDIF                                                        239647 BG13727
     C*****SVAL9         IFEQ      '*NRF'                                             239647 BG13727
     C**********         MOVE      SVALK9        DBKEY                                239647 BG13727
     C**********         ENDIF                                                        239647 BG13727
     C*****SVAL8         IFEQ      '*NRF'                                             239647 BG13727
     C**********         MOVE      SVALK8        DBKEY                                239647 BG13727
     C**********         ENDIF                                                        239647 BG13727
     C*****SVAL7         IFEQ      '*NRF'                                             239647 BG13727
     C**********         MOVE      SVALK7        DBKEY                                239647 BG13727
     C**********         ENDIF                                                        239647 BG13727
     C*****SVAL6         IFEQ      '*NRF'                                             239647 BG13727
     C**********         MOVE      SVALK6        DBKEY                                239647 BG13727
     C**********         ENDIF                                                        239647 BG13727
     C*****SVAL5         IFEQ      '*NRF'                                             239647 BG13727
     C**********         MOVE      SVALK5        DBKEY                                239647 BG13727
     C**********         ENDIF                                                        239647 BG13727
     C*****SVAL4         IFEQ      '*NRF'                                             239647 BG13727
     C**********         MOVE      SVALK4        DBKEY                                239647 BG13727
     C**********         ENDIF                                                        239647 BG13727
     C*****SVAL3         IFEQ      '*NRF'                                             239647 BG13727
     C**********         MOVE      SVALK3        DBKEY                                239647 BG13727
     C**********         ENDIF                                                        239647 BG13727
     C*****SVAL2         IFEQ      '*NRF'                                             239647 BG13727
     C**********         MOVE      SVALK2        DBKEY                                239647 BG13727
     C**********         ENDIF                                                        239647 BG13727
     C*****SVAL1         IFEQ      '*NRF'                                             239647 BG13727
     C**********         MOVE      SVALK1        DBKEY                                239647 BG13727
     C**********         ENDIF                                                        239647 BG13727
      **********                                                                      239647 BG13727
     C**********         MOVEL     '003'         DBASE                                239647 BG13727
     C**********         MOVE      'SDSVALPD'    DBFILE                               239647 BG13727
     C**********         MOVE      'SC001000'    DBPGM                                239647 BG13727
     C**********         OUT       LDA                                                239647 BG13727
     C**********         EXSR      *PSSR                                              239647 BG13727
     C**********         ENDIF                                                        239647 BG13727
      **********                                                                      239647 BG13727
     C**********         MOVEL     SVAL1         HTTPS             1                  239647 BG13727
      **********                                                                      239647 BG13727
      *
      ***Call*AOSVALR0*to*get*the*system*value*for*the*help*root*location*                   BG13727
      ** Call AOSVALR0 to get all required System Values.                                    BG13727
      *
     C                   CALL      'AOSVALR0'
     C                   PARM                    @RTCD
     C                   PARM      SVALKK        SVALK1           20
     C                   PARM                    SVAL1           200
     C**********         PARM                    SVALK2           20                         BG13727
     C                   PARM      WHttps        SVALK2           20                         BG13727
     C                   PARM                    SVAL2           200
     C**********         PARM                    SVALK3           20                         BG13727
     C                   PARM      AltHelpSysVal SVALK3           20                         BG13727
     C                   PARM                    SVAL3           200
     C                   PARM                    SVALK4           20
     C                   PARM                    SVAL4           200
     C                   PARM                    SVALK5           20
     C                   PARM                    SVAL5           200
     C                   PARM                    SVALK6           20
     C                   PARM                    SVAL6           200
     C                   PARM                    SVALK7           20
     C                   PARM                    SVAL7           200
     C                   PARM                    SVALK8           20
     C                   PARM                    SVAL8           200
     C                   PARM                    SVALK9           20
     C                   PARM                    SVAL9           200
     C                   PARM                    SVALK10          20
     C                   PARM                    SVAL10          200
      *
     C     @RTCD         IFNE      *BLANKS
 
     C     *LOCK         IN        LDA
 
     C     SVAL10        IFEQ      '*NRF'
     C                   MOVE      SVALK10       DBKEY
     C                   ENDIF
     C     SVAL9         IFEQ      '*NRF'
     C                   MOVE      SVALK9        DBKEY
     C                   ENDIF
     C     SVAL8         IFEQ      '*NRF'
     C                   MOVE      SVALK8        DBKEY
     C                   ENDIF
     C     SVAL7         IFEQ      '*NRF'
     C                   MOVE      SVALK7        DBKEY
     C                   ENDIF
     C     SVAL6         IFEQ      '*NRF'
     C                   MOVE      SVALK6        DBKEY
     C                   ENDIF
     C     SVAL5         IFEQ      '*NRF'
     C                   MOVE      SVALK5        DBKEY
     C                   ENDIF
     C     SVAL4         IFEQ      '*NRF'
     C                   MOVE      SVALK4        DBKEY
     C                   ENDIF
     C     SVAL3         IFEQ      '*NRF'
     C                   MOVE      SVALK3        DBKEY
     C                   ENDIF
     C     SVAL2         IFEQ      '*NRF'
     C                   MOVE      SVALK2        DBKEY
     C                   ENDIF
     C     SVAL1         IFEQ      '*NRF'
     C                   MOVE      SVALK1        DBKEY
     C                   ENDIF
 
     C**********         MOVEL     '001'         DBASE                                       BG13727
     C                   EVAL      DBase = 001                                               BG13727
     C                   MOVE      'SDSVALPD'    DBFILE
     C**********         MOVE      'SC001000'    DBPGM                                       BG13727
     C                   EVAL      DBPgm = 'SCHELPR'                                         BG13727
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
      *
     C                   EVAL      HTTPS = SVAL2                                             BG13727
      * Set up root field based on System Value.                                             BG13727
     C                   IF        AltHelp = 'Y'                                             BG13727
     C                   EVAL      Root =  SVAL3                                             BG13727
     C                   ELSE                                                                BG13727
     C                   EVAL      Root =  SVAL1                                             BG13727
     C                   ENDIF                                                               BG13727
      *
      * Create root to connect to the correct place for help and put in Buffer for return
     C                   Eval       Keyinformation = Type + KeyInfo
     C                   IF        HTTPS = 'Y'                                                239647
     C**********         Eval       LinkRoot = 'https://' + %TRIMR(SVAL1)             239647 BG13727
     C                   Eval       LinkRoot = 'https://' + %TRIMR(Root)                     BG13727
     C                   ELSE                                                                 239647
     C**********         Eval       LinkRoot = 'http://' + %TRIMR(SVAL1)                     BG13727
     C                   Eval       LinkRoot = 'http://' + %TRIMR(Root)                      BG13727
     C                   ENDIF                                                                239647
     C                   Eval       Buffer = KeyInformation +
     C                                       %TRIMR(LinkRoot) +
     C                                       %TRIMR(AOHTMLPage)
 
     C                   ENDSR
 
      **********************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * *INZSR - Program Initialisation routine                       *
      *                                                               *
      * Called by: Implicitly on program activation                   *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
 
     C     *INZSR        BEGSR
 
     C     *entry        PLIST
     C                   Parm                    Type
     C                   Parm                    KeyInfo
     C                   Parm                    Buffer         6000
     C                   Parm                    FldNameArr
     C                   Parm                    MsgIDArr
     C                   Parm                    MsgDtaArr
     C                   Parm                    MsgFArray
     C                   Parm                    APIRetc           1
      *
      ** Check if CRE026 Consumer Banking is active                                           CRE026
      *                                                                                       CRE026
     C                   CALL      'AOSARDR0'                                                 CRE026
     C                   PARM      *BLANKS       PRtCd                                        CRE026
     C                   PARM      '*VERIFY'     POptn                                        CRE026
     C                   PARM      'CRE026'      PSARD             6                          CRE026
     C     SCSARD        PARM      SCSARD        DSFDY                                        CRE026
                                                                                              CRE026
     C                   MOVE      'N'           CRE026            1                          CRE026
     C                   IF        PRtCd = *Blanks                                            CRE026
     C                   EVAL      CRE026 = 'Y'                                               CRE026
     C                   ENDIF                                                                CRE026
                                                                                              CRE026
      ** Program, module and procedure names for dbase error processing                       CRE026
      ** ==============================================================                       CRE026
      ** The following /COPY sets these values.                                               CRE026
                                                                                              CRE026
      /COPY ZACPYSRC,DBFIELDS                                                                 CRE026
                                                                                              CRE026
     C                   ENDSR
 
      /EJECT
      *****************************************************************
      *                                                               *
      * *PSSR  - Program exception error routine                      *
      *          Called automatically if a program error occurs,      *
      *          or directly by the program code using EXSR.          *
      *          This subroutine DUMPs the program just once.         *
      *                                                               *
      * Called by: (**calling routines**)                             *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      **********************************************************************
      ** The following /COPY contains the standard program status
      ** subroutine, excluding a bound call to the DBERRCTL module.
      *********************************************************************
     C/COPY ZACPYSRC,PSSR_ILENE
     C                   RETURN
      *
     C                   ENDSR
