     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2008')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas Extended Narrative validation program')          *
      *****************************************************************
      *                                                               *
      *  Midas - Access Objects                                       *
      *                                                               *
      *  MG001900 - Extended Narrative Validation ,Formatting ,       *
      *             Merging program                                   *
      *                                                               *
      *  Function : This program validates, formats, merges the       *
      *             extended narrative input based on the Network     *
      *             Account                                           *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2008            *
      *                                                               *
      *  Last Amend No. AR877174A          Date 21Dec11               *
      *  Prev Amend No. AR877174           Date 08Dec11               *
      *                 AR876305           Date 07Dec11               *
      *                 AR864881           Date 17Nov11               *
      *                 CER059             Date 19Jul10               *
      *                 BUG26826           Date 11Dec09               *
      *                 BUG26853           Date 15Dec09               *
      *                 BUG26822           Date 10Dec09               *
      *                 BUG26814A          Date 10Dec09               *
      *                 BUG26814           Date 07Dec09               *
      *                 BUG26738           Date 11Nov09               *
      *                 BUG26625           Date 04Nov09               *
      *                 BUG26538           Date 26Oct09               *
      *                 BUG25476           Date 13Aug09               *
      *                 BUG24069           Date 08Jun09               *
      *                 BUG24304           Date 12Jun09               *
      *                 BUG24071           Date 28May09               *
      *                 BUG23280D          Date 10May09               *
      *                 BUG23952           Date 08May09               *
      *                 BUG23280C          Date 21Apr09               *
      *                 BUG23445A          Date 19Apr09               *
      *                 BUG23280B          Date 18Apr09               *
      *                 BUG23040A          Date 23Mar09               *
      *                 BUG23280           Date 09Mar09               *
      *                 BUG23040           Date 04Mar09               *
      *                 BUG22853           Date 12Feb09               *
      *                 BUG22685           Date 10Feb09               *
      *                 BUG22701           Date 06Feb09               *
      *                 BG21987            Date 22Jan09               *
      *                 BUG21921           Date 16Dec08               *
      *                 BUG21877           Date 10Dec08               *
      *                 CER030  *CREATE    Date 09Jul08               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  AR877174A - Subfields 60-63 are missing in paper             *
      *              statement (Child:AR880105)                       *
      *  AR877174 - When extended narratives are 390A, program ended  *
      *             in error (Child:AR880105)                         *
      *  AR876305 - STRCT extended narrative was truncated            *
      *             (Child:AR876306)                                  *
      *  AR864881 - Conversion of journal entry extended narrative    *
      *             are wrong (Child:AR864882)                        *
      *  CER059 - German Feature Upgrade to Delhi                     *
      *         - LT092: Error for no. of lines not displayed         *
      *  BUG26826 - Unnecessary reformatting from STRCT to SWIFT      *
      *             occurred                                          *
      *  BUG26853 - GVC code received from interface was replaced     *
      *  BUG26822 - EN dropped for SWIFT messages when input has      *
      *             MULTICASH subfields.                              *
      *  BUG26814A - Change Request Ver 4                             *
      *  BUG26814 - Change Request Ver 4                              *
      *  BUG26738 - A serious Midas error occurred                    *
      *  BUG26625 - EN not in Field 86.                               *
      *  BUG26538 - ENs were not restructured accdg to alternate      *
      *             network's format                                  *
      *  BUG25476 - MT940 rejected by MMM                             *
      *  BUG24069 -  /IACC indicator not removed when network is not  *
      *              Multicash                                        *
      *  BUG24304 -  Error reformatting to STRCT format               *
      *  BUG24071  - MT940 and MT942 not reflected in MMM             *
      *  BUG23280D - Extended Narrative incorrectly displayed in      *
      *              MT942/MT940                                      *
      *  BUG23952  - Database Error Control                           *
      *  BUG23280C - Extended Narrative incorrectly displayed in      *
      *              MT942/MT940                                      *
      *  BUG23445A - Paper statements were not reformatted based on   *
      *              network *PAPER                                   *
      *  BUG23280B - Extended Narrative incorrectly displayed in      *
      *              MT942/MT940                                      *
      *  BUG23040A - MMM does not reformat Multicash MT942 with       *
      *             /IACC/Dn indicator                                *
      *  BUG23280 - Extended Narrative incorrectly displayed in       *
      *             MT942/MT940                                       *
      *  BUG23040 - MMM does not reformat Multicash MT942 with        *
      *             /IACC/Dn indicator                                *
      *  BUG22853 - /IACC/Dn indicator should not show on Field 86    *
      *             when the network is not multicash                 *
      *  BUG22685 - STRCT format not accepted in extended narrative   *
      *             fields                                            *
      *  BUG22701 - Data was not accepted after line separator        *
      *  BG21987 - Only 1 network can be assigned as a Default        *
      *            Field 86 Structure Validation for 1 retail account *
      *  BUG21921 - Does not properly handle error when the Number    *
      *             of Lines at Network Level is 1.                   *
      *  BUG21877 - No handling when line separator is blank          *
      *  CER030 - Multicash German Feature                            *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  S U B R O U T I N E  I N D E X                               *
      *                                                               *
      *  *INZSR     - Initialisation Subroutine                       *
      *  SRNwrk     - Get the Format type using the Network           *
      *  SRValidate - Validate the Format of the Extended Narrative   *
      *  SRNoChar   - Validate the No of Characters to be present     *
      *               in the Extended Narrative                       *
      *  SRFormat   - Formatting the Input (6*65) according to the    *
      *               definition at network level                     *
      *  SRFmt      - Process for the Formatting of extended          *
      *               narratives without separatrors                  *
      *  SRStrProc  - Process for the String length greater than 70   *
      *  SRMerge    - Merge Input (16*27) to Output (6*65)            *
      *               definition at network level                     *
      ***SRRemSep***-*Find*network*linked*to*transaction*and*remove****          BUG23445A BUG23280D
      ****************separators*from*incoming*ext*narratives**********          BUG23445A BUG23280D
      *  SrFnNet    - Find default network linked to transaction      *                    BUG23280D
      *  SRNarr     - Extract narratives in proper form for           *                    BUG23280D
      *               formatting                                      *                    BUG23280D
      *  SrMrgExt   - Merge narratives prioperly when default network *                    BUG23280D
      *  SrSTFmt    - Extract narratives when field separators are    *                    BUG23280D
      *               used in data for default Structured format      *                    BUG23280D
      *  SrSetNar   - Extract narratives and merge with Dummy         *                    BUG23280D
      *               separator is Structured                         *                    BUG23280D
      *  *PSSR      - Error processing                                *
      *                                                               *
      *    The *INZSR subroutine will only get called automatically   *
      *    on entry to the module the first time it is run            *
      *    (unless you end the program with LR on).  Similarly        *
      *    D-spec initialisation only happens the first time.  Use    *
      *    RESET for subsequent passes.                               *
      *                                                               *
      *****************************************************************
      /EJECT
      *****************************************************************
      *
      ** Midas GL Network Accounts - MT94x
      *
     FGLNW94L11 IF   E           K DISK
      *
     FGLNW94L8  IF   E           K DISK    RENAME(GLNW94D0:GLNW94D1)                         BG21987
      *                                                                                      BG21987
      *****************************************************************
      /EJECT
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ D-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
      *
      ** The following /COPY line includes the LDA layout,
      ** the copyright array definition,and the following
      ** named constants:
      **    True       logical = *on (for indicator processing)
      **    False      logical = *off (for indicator processing)
      **    DBErrCtl   10A     = 'DBERRCTL' (the name of the database
      **                                     error handler)
      ** and the following variables:
      **    RunBefore  1A (for the PSSR)
      *
     D/COPY ZACPYSRC,STD_D_SPEC
      *
      ** The following /COPY line includes the definitions
      ** for error and warning message arrays.
      *
     D/COPY ZACPYSRC,ERR_ARRAYS
      *
      ** The following /COPY line includes all the definitions of the
      ** appended error arrays, including the named constant giving
      ** the size of the arrays.
      *
      /COPY ZACPYSRC,ERR_XARRYS
      *
      ** The following /COPY line includes all the defined fields in
      ** the Program Status Data Structures. They have meaningful
      ** names, prefixed by 'PS'.
      *
      /COPY ZACPYSRC,PSDS
      *
      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
      *
      ** Array for storing extended narratives names in error
      *
     D ArrExtName      S              6A   DIM(6) CTDATA PERRCD(1)
      *
      ** Array for storing extended narratives Lengths
      *
     D ArrLen          S              3  0 DIM(6) CTDATA PERRCD(1)
      *                                                                                    AR877174A
      ** Array for valid Field 86                                                          AR877174A
      *                                                                                    AR877174A
     D ArrFld86        S              2A   DIM(20) CTDATA PERRCD(10)                       AR877174A
      *
      ** Array for storing extended narratives
      *
     D ArrExt          S             65A   DIM(6)
      *                                                                                     AR864881
      ** Array for storing extended narratives 2                                            AR864881
      *                                                                                     AR864881
     D ArrExt2         S             70A   DIM(20)                                          AR864881
      *
      ** Array for storing extended narratives in format 20 * 70
      *
     D ArrExtNarr      S            390A   DIM(50)
      *
      ** Array for storing extended narratives in format 6 * 65
      *
     D ArrExtMrg       S            390A   DIM(50)
      *
      ** Network details record format data structure
      *
     D DSNwrk        E DS                  EXTNAME(SDNWRKPD)
      *                                                                                    BUG23445A
     D DSNwrkN       E DS                  EXTNAME(SDNWRKPD)                               BUG23445A
     D                                     PREFIX(N_)                                      BUG23445A
      *                                                                                     BUG26814
     D SDSVAL        E DS                  EXTNAME(SDSVALPD)                                BUG26814
      *
      ** Long Access Object Data Structure
      *
     D DSLDY         E DS                  EXTNAME(DSLDY)
      *
     D WExtNarr1       DS
     D WNarr1                        65A
     D WNarr2                        65A
     D WNarr3                        65A
     D WNarr4                        65A
     D WNarr5                        65A
     D WNarr6                        65A
      *
      ** +--------------------------------------+
      ** ¦ Declared Variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
      *
      ** Program Parameters
      *
     D PRtcd           S             10A
     D POptn           S              7A
     D PNwrk           S              6A
     D PMsgTyp         S              3A
     D PBrca           S              3A
     D*PCNum****       S              6                                                       CER059
     D PCNum           S              6A                                                      CER059
     D PCcy            S              3A
     D PAccd           S             10S 0
     D PAcsq           S              2S 0
     D PDCInd          S              1A
     D PTranTp         S              5A
     D PNarr1          S             65A
     D PNarr2          S             65A
     D PNarr3          S             65A
     D PNarr4          S             65A
     D PNarr5          S             65A
     D PNarr6          S             65A
     D PFormL1         S             70A
     D PFormL2         S             70A
     D PFormL3         S             70A
     D PFormL4         S             70A
     D PFormL5         S             70A
     D PFormL6         S             70A
     D PFormL7         S             70A
     D PFormL8         S             70A
     D PFormL9         S             70A
     D PFormL10        S             70A
     D PFormL11        S             70A
     D PFormL12        S             70A
     D PFormL13        S             70A
     D PFormL14        S             70A
     D PFormL15        S             70A
     D PFormL16        S             70A
     D PFormL17        S             70A
     D PFormL18        S             70A
     D PFormL19        S             70A
     D PFormL20        S             70A
      *
      ** Key List Parameters
      *
     D KBrca           S                   LIKE(N4BRCA)
     D KCNum           S                   LIKE(N4CNUM)
     D KCcy            S                   LIKE(N4CCY)
     D KAccd           S                   LIKE(N4ACCD)
     D KAcsq           S                   LIKE(N4ACSQ)
      *
     D KNwrk           S                   LIKE(EDNWRK)
     D KNwrk1          S                   LIKE(EDNWRK)                                    BUG23445A
      *
      ** Work Variables
      *
     D WExtNarr        S            390A
     D WSysPos         S              3P 0                                                  BUG26814
     D WSysVal         S              2A                                                    BUG26814
     D WSysPos1        S              3P 0                                                  BUG26853
     D WString         S            390A
     D WRemStr         S            390A
     D WExtMrg         S            390A
     D WNarr           S            390A                                                   BUG23445A
     D WLen            S              3S 0                                                 BUG23445A
     D WLSep           S              2A                                                   BUG23445A
     D WTmp            S            390A                                                   BUG23280B
     D WStringLen      S              3S 0
     D WStringLen1     S              3S 0
     D WLngSTr         S              3S 0
     D WStart          S              3S 0
     D WStartPos       S              3S 0
     D WEnd            S              1A                                                    AR864881
     D WEndPos         S              3S 0
     D WPos            S              3S 0
     D WPos1           S              3S 0
     D WPos2           S              3S 0                                                 BUG23445A
     D WPos3           S              3S 0                                                  BUG26822
     D WSepPos         S              3S 0                                                 BUG23445A
     D WPs             S              3S 0                                                 BUG23280B
     D WNoChar         S              3S 0
     D WLSepLn         S              3S 0
     D WLenofRemStr    S              3S 0
     D WLIdx           S              3S 0
     D WLIdx1          S              3S 0
     D WLine           S              3S 0
     D WMrgLines       S              2S 0
     D WError          S              1A
     D WEmpty          S              1A
     D Idx             S              3  0
     D WFlg            S              1A
     D WNwLine         S              5I 0
     D WRem            S              5I 0
     D WIndx           S              1  0
     D WIndx1          S              1  0
     D WLnStr          S              1  0
     D WLnEnd          S              1  0
     D WNum            S              1  0
     D WStr            S              1  0
     D WRemain         S              3S 0                                                 BUG23280C
      *
     D POptnIn         S              7A
     D PRtcdIn         S              7A
     D PNwrkIn         S              6A
     D PSValK1         S             20A                                                    BUG26814
     D PSVal1          S            200A                                                    BUG26814
     D PSValK2         S             20A                                                    BUG26814
     D PSVal2          S            200A                                                    BUG26814
     D PSValK3         S             20A                                                    BUG26814
     D PSVal3          S            200A                                                    BUG26814
     D PSValK4         S             20A                                                    BUG26814
     D PSVal4          S            200A                                                    BUG26814
     D PSValK5         S             20A                                                    BUG26814
     D PSVal5          S            200A                                                    BUG26814
     D PSValK6         S             20A                                                    BUG26814
     D PSVal6          S            200A                                                    BUG26814
     D PSValK7         S             20A                                                    BUG26814
     D PSVal7          S            200A                                                    BUG26814
     D PSValK8         S             20A                                                    BUG26814
     D PSVal8          S            200A                                                    BUG26814
     D PSValK9         S             20A                                                    BUG26814
     D PSVal9          S            200A                                                    BUG26814
     D PSValK0         S             20A                                                    BUG26814
     D PSVal0          S            200A                                                    BUG26814
     D WLn             S              3S 0                                                 BUG23280D
     D WVal            S              3A                                                   BUG23280D
     D WVal1           S              3A                                                    BUG26853
     D WVal2           S              2A                                                    AR864881
     D WVal3           S              2A                                                    AR864881
     D WFmtFlg         S              1A                                                   BUG23280D
     D WFmtStrct       S              1A                                                   BUG23280D
     D WStrct          S              1A                                                   BUG23280D
     D WBlFlg          S              1A                                                   BUG23280D
     D WFldSep         S              1A                                                   BUG23280D
     D WDummy          S              2A                                                   BUG23280D
     D WExtStr         S             70A                                                   BUG23280D
     D WPsBl           S              3S 0                                                 BUG23280D
     D WPsFld          S              3S 0                                                 BUG23280D
     D WPsFld1         S              3S 0                                                 BUG23280D
     D WPsFld2         S              3S 0                                                  BUG26814
     D WTVal           S              3S 0                                                 BUG23280D
     D WNarrTmp        S            390A                                                   BUG23280D
     D Wnum1           S              2S 0                                                 BUG23280D
     D WPosCl          S              3S 0                                                  BUG24071
     D Wnum2           S              3S 0                                                 AR877174A
     D Wchar2          S              2A                                                   AR877174A
     D Wfound          S              1A                                                   AR877174A
     D WKeySysVal1     C                   CONST('MT94xFldTags')                            BUG26814
      *
      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *
      ** +---------------- Start of Main Processing ------------------+
      ** ¦                                                            ¦
      ** ¦  *INZSR is automatically executed at program activation.   ¦
      ** ¦                                                            ¦
      ** +------------------------------------------------------------+
      *
     C                   EVAL      WExtNarr = PNarr1 + PNarr2 +
     C                             PNarr3 + PNarr4 + PNarr5 + PNarr6
      *
      ** If Ext. narr. are blank, no need for further processing
      *
     C                   IF        WExtNarr = *BLANKS AND
     C                             POptn <> '*MERGE'
     C                   EVAL      *INLR = *ON
     C                   EVAL      PFormL1 = *BLANKS                                        BUG24304
     C                   RETURN
     C                   ENDIF
      *
     C                   EXSR      SRNwrk
      *
      **  Validate the input format of 6*65 using network details
      *
     C                   IF        POptn = '*VALID'
     C                   EXSR      SRValidate
      *
      ** In case of any error set the return code to '*ERROR'
      *
     C                   IF         WError = 'Y'
     C                   EVAL       PRtcd = '*ERROR'
     C                   ELSE
     C                   EVAL       PRtcd = *BLANKS
     C                   ENDIF
      *
     C                   ENDIF
      *
      **  Formatting 6*65 according to formatting options
      **  using network details
      *
     C                   IF        POptn = '*FORMAT'
      *
      ** Call the external program for additional formatting
      *
     C                   IF        EDEXFM <> '*NONE' AND
     C                             EDEXFM <> *BLANKS
     C                   CALL      EDEXFM
     C                   PARM                    PRtcd
     C                   PARM                    POptn
     C                   PARM                    PNwrk
     C                   PARM                    PMsgTyp
     C                   PARM                    PBrca
     C                   PARM                    PCNum
     C                   PARM                    PCcy
     C                   PARM                    PAccd
     C                   PARM                    PAcsq
     C                   PARM                    PDCInd
     C                   PARM                    PTranTp
     C                   PARM                    PNarr1
     C                   PARM                    PNarr2
     C                   PARM                    PNarr3
     C                   PARM                    PNarr4
     C                   PARM                    PNarr5
     C                   PARM                    PNarr6
     C                   PARM                    PFormL1
     C                   PARM                    PFormL2
     C                   PARM                    PFormL3
     C                   PARM                    PFormL4
     C                   PARM                    PFormL5
     C                   PARM                    PFormL6
     C                   PARM                    PFormL7
     C                   PARM                    PFormL8
     C                   PARM                    PFormL9
     C                   PARM                    PFormL10
     C                   PARM                    PFormL11
     C                   PARM                    PFormL12
     C                   PARM                    PFormL13
     C                   PARM                    PFormL14
     C                   PARM                    PFormL15
     C                   PARM                    PFormL16
     C                   PARM                    PFormL17
     C                   PARM                    PFormL18
     C                   PARM                    PFormL19
     C                   PARM                    PFormL20
     C                   PARM                    Idx
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
     C                   PARM                    WFldNmXAr
     C                   PARM                    WMsgIDXAr
     C                   PARM                    WMsgDtXAr
      *
     C                   ELSE
      *
      ** If called from CM remove line separators from data                                BUG23445A
      **********                                                                 BUG23445A BUG23280D
     C**********         IF        PCNum <> *ZEROS                               BUG23445A BUG23280D
     C**********         EXSR      SRRemSep                                      BUG23445A BUG23280D
     C**********         ENDIF                                                   BUG23445A BUG23280D
      **********                                                                 BUG23445A BUG23280D
     C                   EXSR      SrFnNet                                                 BUG23280D
     C                   EXSR      SrNarr                                                  BUG23280D
      *                                                                                    BUG23280D
     C                   EXSR      SRFormat
     C                   EVAL      PRtcd = '*FORMAT'
     C                   ENDIF
                                                                                            AR864881
     C                   EVAL      WExtNarr = %TRIM(PNarr1) +                               AR864881
     C                             %TRIM(PNarr2) + %TRIM(PNarr3) +                          AR864881
     C                             %TRIM(PNarr4) + %TRIM(PNarr5) +                          AR864881
     C                             %TRIM(PNarr6)                                            AR864881
     C                   EVAL      WVal2 = '?2'                                             AR864881
     C                   EVAL      WVal3 = '?3'                                             AR864881
     C                   EVAL      WPsFld = %SCAN(WVal2:WExtNarr)                           AR864881
     C                   EVAL      WPsFld1 = %SCAN(WVal3:WExtNarr)                          AR864881
     C                   IF        WPsFld > 0 OR                                            AR864881
     C                             WPsFld1 > 0                                              AR864881
     C                   EVAL      ArrExt2 = *BLANKS                                        AR864881
     C                   EVAL      ArrExtNarr = *BLANKS                                     AR864881
     C                   EVAL      WLn = 1                                                  AR864881
     C                   EVAL      WEND = 'N'                                               AR864881
     C**********         MOVEL     '?'           WVal                             AR864881 AR877174A
     C**********         MOVE      '20'          WVal                             AR864881 AR877174A
     C                   EXSR      SrFmtDta                                                 AR864881
     C**********         MOVE      '21'          WVal                             AR864881 AR877174A
     C**********         EXSR      SrFmtDta                                       AR864881 AR877174A
     C**********         MOVE      '22'          WVal                             AR864881 AR877174A
     C**********         EXSR      SrFmtDta                                       AR864881 AR877174A
     C**********         MOVE      '23'          WVal                             AR864881 AR877174A
     C**********         EXSR      SrFmtDta                                       AR864881 AR877174A
     C**********         MOVE      '24'          WVal                             AR864881 AR877174A
     C**********         EXSR      SrFmtDta                                       AR864881 AR877174A
     C**********         MOVE      '25'          WVal                             AR864881 AR877174A
     C**********         EXSR      SrFmtDta                                       AR864881 AR877174A
     C**********         MOVE      '26'          WVal                             AR864881 AR877174A
     C**********         EXSR      SrFmtDta                                       AR864881 AR877174A
     C**********         MOVE      '27'          WVal                             AR864881 AR877174A
     C**********         EXSR      SrFmtDta                                       AR864881 AR877174A
     C**********         MOVE      '28'          WVal                             AR864881 AR877174A
     C**********         EXSR      SrFmtDta                                       AR864881 AR877174A
     C**********         MOVE      '29'          WVal                             AR864881 AR877174A
     C**********         EXSR      SrFmtDta                                       AR864881 AR877174A
     C**********         MOVE      '30'          WVal                             AR864881 AR877174A
     C**********         EXSR      SrFmtDta                                       AR864881 AR877174A
     C**********         MOVE      '31'          WVal                             AR864881 AR877174A
     C**********         EXSR      SrFmtDta                                       AR864881 AR877174A
     C**********         MOVE      '32'          WVal                             AR864881 AR877174A
     C**********         EXSR      SrFmtDta                                       AR864881 AR877174A
     C**********         MOVE      '33'          WVal                             AR864881 AR877174A
     C**********         EXSR      SrFmtDta                                       AR864881 AR877174A
     C**********         MOVE      '34'          WVal                             AR864881 AR877174A
     C**********         EXSR      SrFmtDta                                       AR864881 AR877174A
     C**********         MOVE      '60'          WVal                             AR864881 AR877174A
     C**********         EXSR      SrFmtDta                                       AR864881 AR877174A
     C**********         MOVE      '61'          WVal                             AR864881 AR877174A
     C**********         EXSR      SrFmtDta                                       AR864881 AR877174A
     C**********         MOVE      '62'          WVal                             AR864881 AR877174A
     C**********         EXSR      SrFmtDta                                       AR864881 AR877174A
     C**********         MOVE      '63'          WVal                             AR864881 AR877174A
     C**********         EXSR      SrFmtDta                                       AR864881 AR877174A
                                                                                            AR864881
     C                   EVAL      PFormL1 = ArrExt2(1)                                     AR864881
     C                   EVAL      PFormL2 = ArrExt2(2)                                     AR864881
     C                   EVAL      PFormL3 = ArrExt2(3)                                     AR864881
     C                   EVAL      PFormL4 = ArrExt2(4)                                     AR864881
     C                   EVAL      PFormL5 = ArrExt2(5)                                     AR864881
     C                   EVAL      PFormL6 = ArrExt2(6)                                     AR864881
     C                   EVAL      PFormL7 = ArrExt2(7)                                     AR864881
     C                   EVAL      PFormL8 = ArrExt2(8)                                     AR864881
     C                   EVAL      PFormL9 = ArrExt2(9)                                     AR864881
     C                   EVAL      PFormL10 = ArrExt2(10)                                   AR864881
     C                   EVAL      PFormL11 = ArrExt2(11)                                   AR864881
     C                   EVAL      PFormL12 = ArrExt2(12)                                   AR864881
     C                   EVAL      PFormL13 = ArrExt2(13)                                   AR864881
     C                   EVAL      PFormL14 = ArrExt2(14)                                   AR864881
     C                   EVAL      PFormL15 = ArrExt2(15)                                   AR864881
     C                   EVAL      PFormL16 = ArrExt2(16)                                   AR864881
     C                   EVAL      PFormL17 = ArrExt2(17)                                   AR864881
     C                   EVAL      PFormL18 = ArrExt2(18)                                   AR864881
     C                   EVAL      PFormL19 = ArrExt2(19)                                   AR864881
     C                   EVAL      PFormL20 = ArrExt2(20)                                   AR864881
     C                   EVAL      PRtcd = '*FORMAT'                                        AR864881
     C                   ENDIF                                                              AR864881
      *
     C                   ENDIF
      *
     C                   IF        POptn = '*MERGE'
     C                   EXSR      SRMerge
     C                   EVAL      PRtcd = '*MERGE'
     C                   ENDIF
      *
     C                   EVAL      *INLR = *ON
     C                   RETURN
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRNwrk - Get the Format type using the Network               *
      *                                                               *
      *****************************************************************
     C     SRNwrk        BEGSR
      *
      ** When Network is blanks get the network from Network accounts
      ** file using the Account
      *
     C                   IF        PNwrk = *BLANKS
     C                   EVAL      KBrca = PBrca
     C                   EVAL      KCNum = PCNum
     C                   EVAL      KCcy = PCcy
     C                   EVAL      KAccd = PAccd
     C                   EVAL      KAcsq = PAcsq
      *
      ** When Account is not present then use the default 'SWIFT'
      *
     C     KAcct         CHAIN     GLNW94L11
      *
     C                   IF        NOT %FOUND (GLNW94L11)
      *                                                                                      BG21987
     C     KAcct         CHAIN     GLNW94L8                                                  BG21987
     C                   IF        NOT %FOUND (GLNW94L8)                                     BG21987
     C                   EVAL      KNwrk = 'SWIFT'
     C                   ELSE                                                                BG21987
      *                                                                                      BG21987
      ** Loop to get First network with Extended naarative flag as 'Y'                       BG21987
      *                                                                                      BG21987
     C                   DOW       NOT %EOF(GLNW94L8)                                        BG21987
     C                   EVAL      KNwrk = N4NWRK                                            BG21987
      *                                                                                      BG21987
     C                   CALL      'AONWRKR1'                                                BG21987
     C                   PARM      *BLANKS       PRtCdIn                                     BG21987
     C                   PARM      '*KEY'        POptnIn                                     BG21987
     C                   PARM      KNwrk         PNwrkIn                                     BG21987
     C     DSNwrk        PARM                    DSLDY                                       BG21987
      *                                                                                      BG21987
     C                   IF        PRtCdIn <> *BLANKS                                        BG21987
      *                                                                                      BG21987
     C     *LOCK         IN        LDA                                                       BG21987
      *                                                                                      BG21987
     C                   EVAL      DBASE = 998                                               BG21987
     C                   EVAL      DBFILE = 'SDNWRKPD'                                       BG21987
     C                   EVAL      DBKEY  = KNwrk                                            BG21987
     C                   EVAL      DBPGM = 'MG001900'                                        BG21987
      *                                                                                      BG21987
     C                   OUT       LDA                                                       BG21987
     C                   EXSR      *PSSR                                                     BG21987
     C                   ENDIF                                                               BG21987
      *                                                                                      BG21987
     C                   IF        EDENRA <> 'Y'                                             BG21987
     C     KAcct         READE     GLNW94L8                                                  BG21987
     C                   ELSE                                                                BG21987
     C                   LEAVE                                                               BG21987
     C                   ENDIF                                                               BG21987
     C                   ENDDO                                                               BG21987
      *                                                                                      BG21987
     C                   ENDIF                                                               BG21987
      *                                                                                      BG21987
     C                   ELSE
     C                   EVAL      KNwrk = N4NWRK
     C                   ENDIF
      *
     C                   ELSE
     C                   EVAL      KNwrk = PNwrk
     C                   ENDIF
      *
      ** Retrieve the associated network record and find the format
      ** related to the network else issue an error
      *
     C                   CALL      'AONWRKR1'
     C                   PARM      *BLANKS       PRtCdIn
     C                   PARM      '*KEY'        POptnIn
     C                   PARM      KNwrk         PNwrkIn
     C     DSNwrk        PARM                    DSLDY
      *
     C                   IF        PRtCdIn <> *BLANKS
      *
     C     *LOCK         IN        LDA
      *
     C                   EVAL      DBASE = 999
     C                   EVAL      DBFILE = 'SDNWRKPD'
     C                   EVAL      DBKEY  = KNwrk
     C                   EVAL      DBPGM = 'MG001900'
      *
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
      *
      ** Return if extended narrative flag for the network is not 'Y'
      *
     C                   IF        EDENRA <> 'Y'
     C                   EVAL      *INLR = *ON
     C                   RETURN
     C                   ENDIF
      *                                                                                     BUG23040
      ** Change No. of lines/chars as per the indicator of /IACC/Dn                         BUG23040
      *                                                                                     BUG23040
     C                   IF        POptn = '*FORMAT'                                        BUG23040
     C                             AND EDMCNW = 'Y'                                        BUG23280B
     C                   SELECT                                                             BUG23040
      *                                                                                     BUG23040
     C                   WHEN      PDCInd = '0'                                             BUG23040
     C                   EVAL      EDNOLN = 14                                              BUG23040
     C                   EVAL      EDNCLN = 27                                              BUG23040
      *                                                                                     BUG23040
     C                   WHEN      PDCInd = '1'                                             BUG23040
     C                   EVAL      EDNOLN = 06                                              BUG23040
     C                   EVAL      EDNCLN = 65                                              BUG23040
      *                                                                                     BUG23040
     C                   WHEN      PDCInd = '2'                                             BUG23040
     C                   EVAL      EDNOLN = 10                                              BUG23040
     C                   EVAL      EDNCLN = 32                                              BUG23040
      *                                                                                     BUG23040
     C                   WHEN      PDCInd = '3'                                             BUG23040
     C                   EVAL      EDNOLN = 16                                              BUG23040
     C                   EVAL      EDNCLN = 35                                              BUG23040
      *                                                                                     BUG23040
     C                   ENDSL                                                              BUG23040
     C                   ENDIF                                                              BUG23040
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRValidate - Validate the Format of the Extended Narrative   *
      *                                                               *
      *****************************************************************
     C     SRValidate    BEGSR
      *
     C                   EVAL      WStart = 1
     C                   EVAL      WLIdx = 1
     C                   EVAL      WError = 'N'
     C                   EVAL      WIndx = 1
     C                   EVAL      WIndx1 = 1
      *                                                                                     BUG24071
      ** ':' is not a valid character for multicash network                                 BUG24071
      *                                                                                     BUG24071
     C                   IF        EDMCNW = 'Y'                                             BUG24071
      *                                                                                     BUG24071
      ** Move values to an array                                                            BUG24071
      *                                                                                     BUG24071
     C                   EVAL      ArrExt(1) = PNarr1                                       BUG24071
     C                   EVAL      ArrExt(2) = PNarr2                                       BUG24071
     C                   EVAL      ArrExt(3) = PNarr3                                       BUG24071
     C                   EVAL      ArrExt(4) = PNarr4                                       BUG24071
     C                   EVAL      ArrExt(5) = PNarr5                                       BUG24071
     C                   EVAL      ArrExt(6) = PNarr6                                       BUG24071
      *                                                                                     BUG24071
     C                   DO        6                                                        BUG24071
     C                   EVAL      WPosCl = *ZEROS                                          BUG24071
     C                   EVAL      WPosCl = %SCAN(':' :ArrExt(WIndx):1)                     BUG24071
      *                                                                                     BUG24071
     C                   IF        WPosCl > *ZEROS                                          BUG24071
     C                   EVAL      Idx = Idx + 1                                            BUG24071
     C                   EVAL      FldNamXAr(Idx) = ArrExtName(WIndx)                       BUG24071
     C                   EVAL      MsgIDXAr(Idx) = 'USR5304'                                BUG24071
     C                   EVAL      WError = 'Y'                                             BUG24071
     C                   ENDIF                                                              BUG24071
      *                                                                                     BUG24071
     C                   EVAL      WIndx = WIndx + 1                                        BUG24071
     C                   ENDDO                                                              BUG24071
      *                                                                                     BUG24071
     C                   IF        WError = 'Y'                                             BUG24071
     C                   LEAVESR                                                            BUG24071
     C                   ENDIF                                                              BUG24071
      *                                                                                     BUG24071
     C                   ELSE                                                               BUG25476
      *                                                                                     BUG25476
      ** ':' is not a valid character if it is the first character                          BUG25476
      ** in the line                                                                        BUG25476
      *                                                                                     BUG25476
      ** Move values to an array                                                            BUG25476
      *                                                                                     BUG25476
     C                   EVAL      ArrExt(1) = PNarr1                                       BUG25476
     C                   EVAL      ArrExt(2) = PNarr2                                       BUG25476
     C                   EVAL      ArrExt(3) = PNarr3                                       BUG25476
     C                   EVAL      ArrExt(4) = PNarr4                                       BUG25476
     C                   EVAL      ArrExt(5) = PNarr5                                       BUG25476
     C                   EVAL      ArrExt(6) = PNarr6                                       BUG25476
      *                                                                                     BUG25476
     C                   DO        6                                                        BUG25476
     C                   EVAL      WPosCl = *ZEROS                                          BUG25476
     C                   EVAL      WPosCl = %SCAN(':' :ArrExt(WIndx):1)                     BUG25476
      *                                                                                     BUG25476
     C                   IF        WPosCl = 1                                               BUG25476
     C                   EVAL      Idx = Idx + 1                                            BUG25476
     C                   EVAL      FldNamXAr(Idx) = ArrExtName(WIndx)                       BUG25476
     C                   EVAL      MsgIDXAr(Idx) = 'USR5306'                                BUG25476
     C                   EVAL      WError = 'Y'                                             BUG25476
     C                   ENDIF                                                              BUG25476
      *                                                                                     BUG25476
     C                   EVAL      WIndx = WIndx + 1                                        BUG25476
     C                   ENDDO                                                              BUG25476
      *                                                                                     BUG25476
     C                   IF        WError = 'Y'                                             BUG25476
     C                   LEAVESR                                                            BUG25476
     C                   ENDIF                                                              BUG25476
      *                                                                                     BUG25476
     C                   ENDIF                                                              BUG24071
      *
      ** Get the position of the Line Separator
      *
     C**********         EVAL      WPos = %SCAN(EDLSEP:WExtNarr:WStart)                     BUG22701
     C                   IF        EDLSEP = *BLANKS                                         BUG22701
     C                   EVAL      WPos = *ZEROS                                            BUG22701
     C                   ELSE                                                               BUG22701
     C                   EVAL      WPos = %SCAN(%TRIM(EDLSEP):WExtNarr                      BUG22701
     C                                    :WStart)                                          BUG22701
     C                   ENDIF                                                              BUG22701
      *
      ** If Line separator is not found then do processing line by line
      ** for narratives
      *
     C                   IF        WPos = *ZEROS
     C                             OR   EDLSEP = *BLANKS                                    BUG21877
      *
     C**********         IF        EDNOLN > 1                                      BUG21921 BUG22685
     C                   IF        EDNOLN > 1                                               BUG22685
      *
      ** Move values to an array
      *
     C                   EVAL      ArrExt(1) = PNarr1
     C                   EVAL      ArrExt(2) = PNarr2
     C                   EVAL      ArrExt(3) = PNarr3
     C                   EVAL      ArrExt(4) = PNarr4
     C                   EVAL      ArrExt(5) = PNarr5
     C                   EVAL      ArrExt(6) = PNarr6
      *
      ** Get Number of lines in extended narratives
      *
     C                   EVAL      WIndx = 1                                                  CER059
      *                                                                                       CER059
     C                   DOW       WIndx < 7
     C                   EVAL      WNoChar = %LEN(%TRIM(ArrExt(WIndx)))
     C                   IF        WNoChar > *ZEROS
     C                   EVAL      WLIdx = WLIdx + 1
      *
      ** No Of lines in the Extended Narrative is greater than no of
      ** lines at Network Level
      *
     C                   IF        (WLIdx -1) > EDNOLN
     C                   DO        6
     C                   EVAL      Idx = Idx + 1
     C                   EVAL      FldNamXAr(Idx) = ArrExtName(WIndx1)
     C                   EVAL      MsgIDXAr(Idx) = 'USR5301'
     C                   EVAL      WIndx1 = WIndx1 + 1
     C                   ENDDO
      *
     C                   EVAL      WError = 'Y'
      *
      ** If error occurs , don't do any further processing
      *
     C                   LEAVESR
     C                   ENDIF
      *
     C                   ENDIF
     C                   EVAL      WIndx = WIndx + 1
     C                   ENDDO
      *
      ** Calculating no of chars/lines for extended narrative 1 - 6
     C**********         IF        EDNOLN > 1                                      BUG21921 BUG22685
      *
     C                   EVAL      WIndx = 1
      *
     C                   DO        6
     C                   EVAL      WNoChar = %LEN(%TRIM(ArrExt(WIndx)))
      *
      ** Check for error if No. of chars is greater than network level
      *
     C                   IF        WNoChar > EDNCLN
     C                   EVAL      Idx = Idx + 1
     C                   EVAL      FldNamXAr(Idx) = ArrExtName(WIndx)
     C                   EVAL      MsgIDXAr(Idx) = 'USR5302'
     C                   EVAL      WError = 'Y'
     C                   LEAVESR
     C                   ENDIF
      *
     C                   EVAL      WIndx = WIndx + 1
     C                   ENDDO
      *
     C                   ELSE
      *
      ** No. of lines at network level is 1
      *
     C                   EVAL      WNoChar = %LEN(%TRIM(WExtNarr))
      *
     C                   IF        WNoChar > EDNCLN
                                                                                            BUG26738
     C                   EVAL      WIndx = 1                                                BUG26738
                                                                                            BUG26738
     C                   DO        6
     C                   EVAL      Idx = Idx + 1
     C                   EVAL      FldNamXAr(Idx) = ArrExtName(WIndx)
     C                   EVAL      MsgIDXAr(Idx) = 'USR5302'
      *
     C                   EVAL      WIndx = WIndx + 1
     C                   ENDDO
      *
     C                   EVAL      WError = 'Y'
     C                   ENDIF
      *
     C                   ENDIF
      *
      ** Else validate according to separator position in narratives
      *
     C                   ELSE
      *
      ** Set the no of characters in the Line separator
      *
     C                   EVAL      WLSepLn = %LEN(%TRIM(EDLSEP))
     C                   EVAL      WLngStr = %LEN(%TRIM(WExtNarr))
      *
      ** Check for Number of lines
      *
     C                   DOW       WPos <> *ZEROS
      *
      ** If no more data in the Extended Narrative, then leave
      *
     C                   IF        %SUBST(WExtNarr: WStart) = *BLANKS
     C                   LEAVE
     C                   ENDIF
      *
     C                   EVAL      WLIdx = WLIdx + 1
      *
     C                   EVAL      WStart = WPos + WLSepLn
     C**********         EVAL      WPos = %SCAN(EDLSEP:WExtNarr:WStart)                     BUG22701
     C                   EVAL      WPos = %SCAN(%TRIM(EDLSEP):WExtNarr                      BUG22701
     C                                    :WStart)                                          BUG22701
      *
     C                   IF        WPos = *ZEROS  AND
     C                             %SUBST(WExtNarr: WStart) <> *BLANKS
     C                   EVAL      WLIdx = WLIdx + 1
     C                   ENDIF
      *
     C                   ENDDO
      *
      ** No Of lines in the Extended Narrative is greater than no of
      ** lines at Network Level
      *
     C                   IF        (WLIdx -1) > EDNOLN
      *
     C                   DO        6
     C                   EVAL      Idx = Idx + 1
     C                   EVAL      FldNamXAr(Idx) = ArrExtName(WIndx1)
     C                   EVAL      MsgIDXAr(Idx) = 'USR5301'
     C                   EVAL      WIndx1 = WIndx1 + 1
     C                   ENDDO
      *
     C                   EVAL      WError = 'Y'
     C                   LEAVESR
     C                   ENDIF
      *
      ** No of characters check
      *
     C                   EVAL      WStart = 1
      *
      ** Get the position of the Line Separator
      *
     C**********         EVAL      WPos = %SCAN(EDLSEP:WExtNarr:WStart)                     BUG22701
     C                   EVAL      WPos = %SCAN(%TRIM(EDLSEP):WExtNarr                      BUG22701
     C                                    :WStart)                                          BUG22701
      *
     C                   DOW       WPos <= WLngStr
      *
     C                   EXSR      SRNoChar
      *
     C                   IF        WError = 'Y'
     C                   LEAVESR
     C                   ENDIF
      *
     C                   EVAL      WStart = WPos + WLSepLn
      *
      ** Get the position of the next Line Separator, if not found
      ** then do the processing till end of WExtNarr
      *
     C**********         EVAL      WPos = %SCAN(EDLSEP:WExtNarr:WStart)                     BUG22701
     C                   EVAL      WPos = %SCAN(%TRIM(EDLSEP):WExtNarr                      BUG22701
     C                                    :WStart)                                          BUG22701
     C                   IF        WPos = *ZEROS
     C                   EVAL      WPos = WLngStr
     C                   EXSR      SRNoChar
     C                   LEAVE
     C                   ENDIF
      *
     C                   ENDDO
      *
     C                   ENDIF
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRNoChar - Validate the No of Characters to be present       *
      *             in the Extended Narrative                         *
      *                                                               *
      *****************************************************************
     C     SRNoChar      BEGSR
      *
      ** Get the no of characters in the line
      *
     C                   EVAL      WNoChar = WPos - WStart
      *
     C                   IF        WNoChar > EDNCLN
      *
      ** Finding the line number of starting of ext narr in error
      *
     C                   EVAL      WNum = 1
     C                   EVAL      WLnStr = *ZEROS
     C                   EVAL      WLnEnd = *ZEROS
      *
     C                   IF        WStart <= ArrLen(WNum)
     C                   EVAL      WLnStr = WNum
     C                   ELSE
     C                   DOW       WLnStr = *ZEROS
      *
     C                   EVAL      WNum  = WNum + 1
     C                   IF        WStart <= ArrLen(WNum)
     C                   EVAL      WLnStr = WNum
     C                   ENDIF
      *
     C                   ENDDO
     C                   ENDIF
      *
      ** Finding the end line for Ext Narr in error
      *
     C                   EVAL      WPos1 = WPos - 1
     C                   IF        WPos1 <= ArrLen(WNum)
     C                   EVAL      WLnEnd = WNum
     C                   ELSE
     C                   DOW       WLnEnd = *ZEROS
      *
     C                   EVAL      WNum  = WNum + 1
     C                   IF        WPos1 <= ArrLen(WNum)
     C                   EVAL      WLnEnd = WNum
     C                   ENDIF
      *
     C                   ENDDO
     C                   ENDIF
      *
     C                   EVAL      WStr = WLnStr
     C                   DOW       WStr <= WLnEnd
      *
     C                   EVAL      Idx = Idx + 1
     C                   EVAL      FldNamXAr(Idx) = ArrExtName(WStr)
     C                   EVAL      MsgIDXAr(Idx) = 'USR5302'
     C                   EVAL      WStr = WStr + 1
     C                   ENDDO
      *
     C                   EVAL      WError = 'Y'
      *
     C                   ENDIF
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRFormat - Formatting the Input (6*65) according the         *
      *             definition at network level                       *
      *                                                               *
      *****************************************************************
     C     SRFormat      BEGSR
      *
     C                   EVAL      WExtNarr = %TRIM(PNarr1) +
     C                             %TRIM(PNarr2) + %TRIM(PNarr3) +
     C                             %TRIM(PNarr4) + %TRIM(PNarr5) +
     C                             %TRIM(PNarr6)
      *
     C                   EVAL      WStartPos = 1
     C                   EVAL      WLIdx = 1
     C                   EVAL      WStart = 1
      *
      ** Set the no of characters in the Line separator
      *
     C                   EVAL      WLSepLn = %LEN(%TRIM(EDLSEP))
     C                   EVAL      WLngStr = %LEN(%TRIM(WExtNarr))
      *
      ** Find the position of the Line Separator
      *
     C**********         EVAL      WPos = %SCAN(EDLSEP:WExtNarr:WStart)                     BUG22701
     C                   IF        EDLSEP <> *BLANKS                                        BUG22853
     C                   EVAL      WPos = %SCAN(%TRIM(EDLSEP):WExtNarr                      BUG22701
     C                             :WStart)                                                 BUG22701
     C                   ELSE                                                               BUG22853
     C                   EVAL      WPos = *ZEROS                                            BUG22853
     C                   ENDIF                                                              BUG22853
      **********                                                                 BUG23280B BUG23280D
      ***If*/IACC/Dn*indicator*used*in*data*remove*it**from*Pnarr1               BUG23280B BUG23280D
      **********                                                                 BUG23280B BUG23280D
     C**********         IF        EDTRLN = 'Y'                                  BUG23280B BUG23280D
     C**********         IF        (PDCInd = '0' OR PDCInd = '1' OR              BUG23280B BUG23280D
     C**********                   PDCInd = '2' OR PDCInd = '3')                 BUG23280B BUG23280D
     C**********                   AND EDMCNW = 'Y'                              BUG23280B BUG23280D
     C**********         EVAL      WPs = %SCAN('/IACC/D':Pnarr1)                 BUG23280B BUG23280D
     C**********         IF        WPs > *ZEROS                                  BUG23280B BUG23280D
     C**********         EVAL      PNarr1 = %REPLACE('':Pnarr1:WPs:8)            BUG23280B BUG23280D
     C**********         ENDIF                                                   BUG23280B BUG23280D
     C**********         ENDIF                                                   BUG23280B BUG23280D
     C**********         ENDIF                                                   BUG23280B BUG23280D
      *                                                                                    BUG23280D
      ** Formatting when STRCT format with field separators is present                     BUG23280D
      *                                                                                    BUG23280D
     C                   IF        WFldSep ='Y'                                            BUG23280D
     C                   IF        EDF86F = 'STRCT' AND EDNOLN = 1                         BUG23280D
     C**********                   AND EDNCLN = 387                               BUG23280D BUG26814
     C**********         EVAL      EDNOLN = 15                                    BUG23280D BUG26814
     C**********         EVAL      EDNCLN = 27                                    BUG23280D BUG26814
     C                   EVAL      EDNOLN = 20                                              BUG26814
     C                   EVAL      EDNCLN = 34                                              BUG26814
     C                   ENDIF                                                             BUG23280D
      *                                                                                    BUG23280D
      ** Populate extended narratives into individual fields                               BUG23280D
      *                                                                                    BUG23280D
     C                   EVAL      WStart = 1                                              BUG23280D
     C                   EVAL      WLn = 1                                                 BUG23280D
     C                   EVAL      WPos1 = 0                                               BUG23280D
     C                   EVAL      WFlg = 'N'                                              BUG23280D
      *                                                                                    BUG23280D
      ** Find position of line separator                                                   BUG23280D
      *                                                                                    BUG23280D
     C                   EVAL      WPos1 = %SCAN(%TRIM(WLSep):WNarrTmp                     BUG23280D
     C                                    :WStart)                                         BUG23280D
     C                   EVAL      WLSepLn = %LEN(%TRIM(WLSep))                            BUG23280D
      *                                                                                    BUG23280D
     C**********         IF        EDNCLN > 27                                    BUG23280D BUG26814
     C**********         EVAL      WNum1= 27                                      BUG23280D BUG26814
     C                   IF        EDNCLN > 34                                    BUG23280D BUG26814
     C                   EVAL      WNum1= 34                                      BUG23280D BUG26814
     C                   ELSE                                                              BUG23280D
     C                   EVAL      WNum1= EDNCLN                                           BUG23280D
     C                   ENDIF                                                             BUG23280D
      * Remove separator when not STRCT                                                     BUG26822
     C                   IF        EDF86F <> 'STRCT'                                        BUG26822
     C                   EVAL      WPos3 = WPos1                                            BUG26822
     C                   DOW       WPos3 > 0                                                BUG26822
     C                   EVAL      WNarrTmp =                                               BUG26822
     C                             %REPLACE('  ':WNarrTmp:WPos3:WLSepLn)                    BUG26822
     C                   EVAL      WPos3 = %SCAN(%TRIM(WLSep):WNarrTmp)                     BUG26822
     C                   ENDDO                                                              BUG26822
     C                   ENDIF                                                              BUG26822
      *                                                                                    BUG23280D
      ** Extract and put the subfields in place                                            BUG23280D
      *                                                                                    BUG23280D
     C                   DOW       WLn <= EDNOLN                                           BUG23280D
      *                                                                                    BUG23280D
     C                   IF        %SUBST(WNarrTmp: WStart) = *BLANKS                      BUG23280D
     C                   LEAVE                                                             BUG23280D
     C                   ENDIF                                                             BUG23280D
      *                                                                                    BUG23280D
     C                   IF        EDF86F = 'STRCT'                                         BUG26822
     C                   IF        WPos1 = 0                                                BUG26814
     C                   EVAL      WPos1 = %LEN(%TRIM(WNarrTmp)) + 1                        BUG26814
     C                   EVAL      WFlg = 'Y'                                               BUG26814
     C                   ENDIF                                                              BUG26814
     C                   EVAL      WString = %SUBST(WNarrTmp:                              BUG23280D
     C                             WStart:(WPos1 - WStart))                                BUG23280D
     C                   EVAL      ArrExtNarr(WLn) = %SUBST(WString :1:Wnum1)              BUG23280D
     C                   ELSE                                                               BUG26822
     C                   EVAL      WString = %SUBST(WNarrTmp:WStart:EDNCLN)                 BUG26822
     C                   EVAL      ArrExtNarr(WLn) = WString                                BUG26822
     C                   ENDIF                                                              BUG26822
      *                                                                                    BUG23280D
     C                   IF        WFlg = 'Y'                                              BUG23280D
     C                   LEAVE                                                             BUG23280D
     C                   ENDIF                                                             BUG23280D
      *                                                                                    BUG23280D
     C                   IF        EDF86F = 'STRCT'                                         BUG26822
     C                   EVAL      WStart = WPos1 + WLSepLn                                BUG23280D
     C                   EVAL      WPos1 = %SCAN(%TRIM(WLSep):WNarrTmp                     BUG23280D
     C                                    :WStart)                                         BUG23280D
     C                   ELSE                                                               BUG26822
     C                   EVAL      WStart = WStart + EDNCLN                                 BUG26822
     C                   ENDIF                                                              BUG26822
     C**********         IF        WPos1 = *ZEROS                                 BUG23280D BUG26814
     C**********         EVAL      WPos1 = %LEN(%TRIM(WNarrTmp)) + 1              BUG23280D BUG26814
     C**********         EVAL      WFlg = 'Y'                                     BUG23280D BUG26814
     C**********         ENDIF                                                    BUG23280D BUG26814
      *                                                                                    BUG23280D
     C                   EVAL      WLn = WLn + 1                                           BUG23280D
     C                   ENDDO                                                             BUG23280D
      *                                                                                    BUG23280D
     C                   ELSE                                                              BUG23280D
      *                                                                                    BUG23280D
      ** If separator not found                                                            BUG23280D
      *                                                                                    BUG23280D
     C                   IF        WFmtFlg = 'Y'                                           BUG23280D
     C                   IF        WPos = *ZEROS
     C                             OR EDWTXT = 'Y'                                         BUG23280D
     C                             OR WFmtStrct = 'Y'                                      BUG23280D
     C**********         IF        EDNOLN > 1                                              BUG23280D
     C                   IF        EDTRLN ='Y' AND N_EDF86F <> 'STRCT'                     BUG23280D
     C                   EVAL      WTmp = PNarr1 + PNarr2 +                                BUG23280B
     C                                    PNarr3 + PNarr4 +                                BUG23280B
     C                                    PNarr5 + PNarr6                                  BUG23280B
     C                   ELSE                                                              BUG23280D
     C                   EVAL      WTmp = WNarr                                            BUG23280D
     C                   ENDIF                                                             BUG23280D
      *                                                                                    BUG23280D
     C                   EXSR      SRFmt                                                   BUG23280B
      *
      ** Process narrative line by line
      *
     C**********         EVAL      WString = PNarr1                                        BUG23280B
     C**********         EXSR      SRFmt                                                   BUG23280B
      *
     C**********         EVAL      WString = PNarr2                                        BUG23280B
     C**********         EXSR      SRFmt                                                   BUG23280B
      *
     C**********         EVAL      WString = PNarr3                                        BUG23280B
     C**********         EXSR      SRFmt                                                   BUG23280B
      *
     C**********         EVAL      WString = PNarr4                                        BUG23280B
     C**********         EXSR      SRFmt                                                   BUG23280B
      *
     C**********         EVAL      WString = PNarr5                                        BUG23280B
     C**********         EXSR      SRFmt                                                   BUG23280B
      *
     C**********         EVAL      WString = PNarr6                                        BUG23280B
     C**********         EXSR      SRFmt                                                   BUG23280B
      *
     C**********         ELSE                                                              BUG23280D
      **********                                                                           BUG23280D
      ***No*of*lines*at*network*level*is*1                                                 BUG23280D
      **********                                                                           BUG23280D
     C**********         EVAL      WExtNarr = WNarr                              BUG23445A BUG23280D
     C**********         MOVE      '   '         WExtNarr                        BUG23445A BUG23280D
     C**********         DO        6                                                       BUG23280D
     C**********         IF        (WStartPos + 70) >= %LEN(WExtNarr)             BUG22853 BUG23280D
     C**********         EVAL      ArrExtNarr(WLIdx) =                            BUG22853 BUG23280D
     C**********                   %SUBST(WExtNarr:WStartPos)                     BUG22853 BUG23280D
     C**********         LEAVE                                                    BUG22853 BUG23280D
     C**********         ELSE                                                     BUG22853 BUG23280D
     C**********         EVAL      ArrExtNarr(WLIdx) =                                     BUG23280D
     C**********                   %SUBST(WExtNarr:WStartPos:70)                           BUG23280D
     C**********         ENDIF                                                    BUG22853 BUG23280D
     C**********         EVAL      WLIdx = WLIdx + 1                                       BUG23280D
     C**********         EVAL      WStartPos = WStartPos + 70                              BUG23280D
      **********                                                                           BUG23280D
     C**********         DO        15                                                      BUG23280D
     C**********         EVAL      ArrExtNarr(WLIdx) =                                     BUG23280D
     C**********                   %SUBST(WExtNarr:WStartPos:27)                           BUG23280D
     C**********         EVAL      WLIdx = WLIdx + 1                                       BUG23280D
     C**********         EVAL      WStartPos  =  WStartPos + 27                            BUG23280D
     C**********                                                                           BUG23280D
     C**********         IF        %SUBST(WExtNarr:WStartPos) = *BLANKS                    BUG23280D
     C**********         LEAVE                                                             BUG23280D
     C**********         ENDIF                                                             BUG23280D
      **********                                                                           BUG23280D
     C**********         IF        WStartPos = 379                                         BUG23280D
     C**********         EVAL      ArrExtNarr(WLIdx) =                                     BUG23280D
     C**********                   %SUBST(WExtNarr:WStartPos:9)                            BUG23280D
     C**********                                                                           BUG23280D
     C**********         ENDIF                                                             BUG23280D
      **********                                                                           BUG23280D
     C**********         ENDDO                                                             BUG23280D
      **********                                                                           BUG23280D
     C**********         ENDIF                                                             BUG23280D
      *
      ** If Separator found
      *
     C                   ELSE
     C                   EVAL      WExtNarr = WNarr                                        BUG23280D
      *                                                                                    BUG23280D
      ** Retrieve separator's position                                                     BUG23280D
      *                                                                                    BUG23280D
     C                   EVAL      WPos = %SCAN(%TRIM(EDLSEP):WExtNarr                     BUG23280D
     C                             :1)                                                     BUG23280D
      *
      ** If no of character at network is greater than 70,
      ** set allowable 20 * 70 output accordingly
      *
     C                   IF        EDNCLN > 70
      *
     C                   EVAL      WNwLine = %DIV (EDNCLN : 70)
     C                   EVAL      WRem = %REM (EDNCLN : 70)
     C                   IF        WRem > *ZEROS
     C                   EVAL      WNwLine = WNwLine + 1
     C                   ENDIF
     C                   ENDIF
      *
      ** Format According to Number of lines at Network Level
      *
     C                   DOW       WLine  <  EDNOLN
     C                   EVAL      WStartPos = 1
      *
      ** Retrieve the Individual Line and its Length
      *
     C                   EVAL      WString = %SUBST(WExtNarr:
     C                                       WStart: (WPos - WStart))
     C                   EVAL      WStringLen = %LEN(%TRIM(WString))
      *
      ** If no data, Leave the loop
      *
     C                   IF        %SUBST(WExtNarr:WStart) = *BLANKS
     C                   LEAVE
     C                   ENDIF
      *
      ** Line length is greater than No of Characters per line
      ** defined at Network
      *
     C                   IF        WStringLen > EDNCLN
      *
      ** Truncate Lines according to No of Characters per line
      ** defined at Network
      *
     C                   IF        EDTRLN = 'Y'
      *
      ** No of characters per line are less than 70 (Output)
      *
     C                   IF        EDNCLN < 70
     C                   EVAL      ArrExtNarr(WLIdx) =
     C                             %SUBST(WString:1:EDNCLN)
     C                   EVAL      WLIdx = WLIdx + 1
     C                   EVAL      WLine = WLine + 1
      *
      ** No of characters per line are greater than 70 (Output),
      ** move it  to the next lines
      *
     C                   ELSE
     C                   EVAL      WEndPos = 70
     C                   EXSR      SRStrProc
      *
     C                   ENDIF
      *
     C                   ENDIF
      **********                                                                           BUG23280D
      ***Wrap*the*Text*according*to*No*of*Characters*per*line                              BUG23280D
      ***defined*at*Network                                                                BUG23280D
      **********                                                                           BUG23280D
     C**********         IF        EDWTXT = 'Y'                                            BUG23280D
      **********                                                                           BUG23280D
      ***No*of*characters*per*line*are*less*than*70*(Output)                               BUG23280D
      **********                                                                           BUG23280D
     C**********         IF        EDNCLN < 70                                             BUG23280D
     C**********         EVAL      ArrExtNarr(WLIdx) =                                     BUG23280D
     C**********                   %SUBST(WString:1:EDNCLN)                                BUG23280D
     C**********         EVAL      WLIdx = WLIdx +1                                        BUG23280D
     C**********         EVAL      WLine = WLine + 1                                       BUG23280D
      **********                                                                           BUG23280D
     C**********         IF        WLine > EDNOLN                                          BUG23280D
     C**********         LEAVE                                                             BUG23280D
     C**********         ENDIF                                                             BUG23280D
      **********                                                                           BUG23280D
     C**********         EVAL      WStartPos = WStartPos + EDNCLN                          BUG23280D
      **********                                                                           BUG23280D
     C**********         DOW       WStringLen >= WStartPos                                 BUG23280D
      **********                                                                           BUG23280D
     C**********         EVAL      ArrExtNarr(WLIdx) =                                     BUG23280D
     C**********                   %SUBST(WString:WStartPos:EDNCLN)                        BUG23280D
     C**********         EVAL      WLIdx = WLIdx +1                                        BUG23280D
     C**********         EVAL      WLine = WLine + 1                                       BUG23280D
      **********                                                                           BUG23280D
     C**********         IF        WLine > EDNOLN                                          BUG23280D
     C**********         EVAL      WFlg = 'Y'                                              BUG23280D
     C**********         LEAVE                                                             BUG23280D
     C**********         ENDIF                                                             BUG23280D
      **********                                                                           BUG23280D
     C**********         EVAL      WStartPos = WStartPos + EDNCLN                          BUG23280D
     C**********         ENDDO                                                             BUG23280D
      **********                                                                           BUG23280D
      ** No*of*characters*per*line*are*greater*than*70*(Output),                           BUG23280D
      ***move*it**to*the*next*lines                                                        BUG23280D
      **********                                                                           BUG23280D
     C**********         ELSE                                                              BUG23280D
     C**********         EVAL      WEndPos = 70                                            BUG23280D
     C**********         EXSR      SRStrProc                                               BUG23280D
     C**********         ENDIF                                                             BUG23280D
      **********                                                                           BUG23280D
     C**********         ENDIF                                                             BUG23280D
      *
      ** Line length is less than No of Characters per line
      ** defined at Network
      *
     C                   ELSE
     C                   EVAL      WEndPos = EDNCLN
     C                   IF        WStringLen <= 70
     C                   EVAL      ArrExtNarr(WLIdx) =
     C                             %SUBST(WString:1:WEndPos)
     C                   EVAL      WLIdx = WLIdx + 1
     C                   EVAL      WLine = WLine + 1
      *
     C                   ELSE
     C                   EVAL      WEndPos = 70
     C                   EXSR      SRStrProc
     C                   ENDIF
      *
     C                   ENDIF
      *
     C                   IF        WFlg = 'Y'
     C                   LEAVE
     C                   ENDIF
      *
     C                   EVAL      WStart = WPos + WLSepLn
      *
      ** Find the position of the Line Separator
      *
     C**********         EVAL      WPos = %SCAN(EDLSEP:WExtNarr:WStart)                     BUG22701
     C                   EVAL      WPos = %SCAN(%TRIM(EDLSEP):WExtNarr                      BUG22701
     C                                    :WStart)                                          BUG22701
     C                   IF        WPos = *ZEROS
     C                   EVAL      WPos = %LEN(%TRIM(WExtNarr)) + 1
     C                   EVAL      WFlg = 'Y'
     C                   ENDIF
      *
     C                   ENDDO
     C                   ENDIF
     C                   ENDIF                                                             BUG23280D
     C                   ENDIF                                                             BUG23280D
      *
      ** Set output params
      *
     C                   EVAL      PFormL1 = ArrExtNarr(1)
     C                   EVAL      PFormL2 = ArrExtNarr(2)
     C                   EVAL      PFormL3 = ArrExtNarr(3)
     C                   EVAL      PFormL4 = ArrExtNarr(4)
     C                   EVAL      PFormL5 = ArrExtNarr(5)
     C                   EVAL      PFormL6 = ArrExtNarr(6)
     C                   EVAL      PFormL7 = ArrExtNarr(7)
     C                   EVAL      PFormL8 = ArrExtNarr(8)
     C                   EVAL      PFormL9 = ArrExtNarr(9)
     C                   EVAL      PFormL10 = ArrExtNarr(10)
     C                   EVAL      PFormL11 = ArrExtNarr(11)
     C                   EVAL      PFormL12 = ArrExtNarr(12)
     C                   EVAL      PFormL13 = ArrExtNarr(13)
     C                   EVAL      PFormL14 = ArrExtNarr(14)
     C                   EVAL      PFormL15 = ArrExtNarr(15)
     C                   EVAL      PFormL16 = ArrExtNarr(16)
     C                   EVAL      PFormL17 = ArrExtNarr(17)
     C                   EVAL      PFormL18 = ArrExtNarr(18)
     C                   EVAL      PFormL19 = ArrExtNarr(19)
     C                   EVAL      PFormL20 = ArrExtNarr(20)
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRFmt - Process for the Formatting of extended narratives    *
      *          without separatrors                                  *
      *                                                               *
      *****************************************************************
     C     SRFmt         BEGSR
      *
     C                   IF        WLIdx  >  EDNOLN
     C                   LEAVESR
     C                   ENDIF
      *
     C                   EVAL      WStartPos = 1
     C                   EVAL      WRemain = EDNCLN                                        BUG23280C
      *                                                                                    BUG23280B
     C                   IF        EDWTXT = 'Y'                                            BUG23280B
     C                             OR N_EDF86F ='STRCT'                                    BUG23280D
      *                                                                                    BUG23280B
     C**********         IF        (PDCInd = '0' OR PDCInd = '1' OR              BUG23280B BUG23280D
     C**********                   PDCInd = '2' OR PDCInd = '3')                 BUG23280B BUG23280D
     C**********                   AND EDMCNW = 'Y'                              BUG23280B BUG23280D
     C**********         EVAL      WPs = %SCAN('/IACC/D':Pnarr1)                 BUG23280B BUG23280D
     C**********         EVAL      WTmp = %REPLACE('':WTmp:WPs:8)                BUG23280B BUG23280D
     C**********         ENDIF                                                   BUG23280B BUG23280D
      *                                                                                    BUG23280B
     C                   DOW       WLIdx <=  EDNOLN AND WStartPos < 390                    BUG23280B
      *                                                                                    BUG23280B
     C                   IF        %SUBST(WTmp :WStartPos) =  *BLANKS                      BUG23280B
     C                   LEAVESR                                                           BUG23280B
     C                   ENDIF                                                             BUG23280B
      *                                                                                    BUG23280B
      ** If the remaining characters are less than the number of                           BUG23280C
      ** characters per line, use the remaining characters instead                         BUG23280C
      *                                                                                    BUG23280C
     C                   IF        WRemain < EDNCLN                                        BUG23280C
     C                   EVAL      ArrExtNarr(WLIdx) =                                     BUG23280C
     C                             %SUBST(WTmp: WStartPos: WRemain + 1)                    BUG23280C
     C                   ELSE                                                              BUG23280C
     C                   EVAL      ArrExtNarr(WLIdx) =                                     BUG23280B
     C                             %SUBST(WTmp: WStartPos: EDNCLN)                         BUG23280B
     C                   ENDIF                                                             BUG23280C
      *                                                                                    BUG23280C
     C                   EVAL      WLIdx = WLIdx + 1                                       BUG23280B
     C                   EVAL      WStartPos = WStartPos + EDNCLN                          BUG23280B
     C                   EVAL      WRemain   = 390 - WStartPos                             BUG23280C
     C                   ENDDO                                                             BUG23280B
      *                                                                                    BUG23280B
     C                   ELSE                                                              BUG23280B
     C                   DOW       WLIdx <=  EDNOLN AND WStartPos < 390                    BUG23280B
      *                                                                                    BUG23280B
     C                   EVAL      WString = %SUBST(WTmp :WStartPos : 65)                  BUG23280B
     C                   IF        WString =  *BLANKS                                      BUG23280B
     C                   LEAVESR                                                           BUG23280B
     C                   ENDIF                                                             BUG23280B
      *                                                                                    BUG23280B
     C                   EVAL      ArrExtNarr(WLIdx) =                                     BUG23280B
     C                             %SUBST(WString: 1: EDNCLN)                              BUG23280B
     C                   EVAL      WLIdx = WLIdx + 1                                       BUG23280B
     C                   EVAL      WStartPos = WStartPos + 65                              BUG23280B
     C                   ENDDO                                                             BUG23280B
     C                   ENDIF                                                             BUG23280B
      *                                                                                    BUG23280B
     C**********         EVAL      WStringLen = %LEN(%TRIM(WString))                       BUG23280B
      *
      ** Line length is greater than No of Characters per line
      *
     C**********         IF        WStringLen > EDNCLN                                     BUG23280B
      *
      ** Truncate Lines according to No of Characters per line
      *
     C**********         IF        EDTRLN = 'Y'                                            BUG23280B
     C**********         EVAL      ArrExtNarr(WLIdx) =                                     BUG23280B
     C**********                   %SUBST(WString: WStartPos: EDNCLN)                      BUG23280B
     C**********         EVAL      WLIdx = WLIdx + 1                                       BUG23280B
     C**********         ENDIF                                                             BUG23280B
      *
      ** Wrap the Text according to No of Characters per line
      *
     C**********         IF        EDWTXT = 'Y'                                            BUG23280B
     C**********         EVAL      WStringLen1 = WStringLen                                BUG23280B
     C**********         EVAL      WEndPos = EDNCLN                                        BUG23280B
      *
     C**********         DOW       WStringLen1 > *ZEROS                                    BUG23280B
     C**********         EVAL      ArrExtNarr(WLIdx) =                                     BUG23280B
     C**********                   %SUBST(WString: WStartPos:WEndPos)                      BUG23280B
     C**********         EVAL      WLIdx = WLIdx + 1                                       BUG23280B
      *
     C**********         IF        WLIdx > EDNOLN                                          BUG23280B
     C**********         EVAL      WFlg = 'Y'                                              BUG23280B
     C**********         LEAVESR                                                 BUG23040A BUG23280B
     C**********         ENDIF                                                             BUG23280B
      *
     C**********         EVAL      WStringLen1 = WStringLen - WEndPos                       BUG23280
     C**********         EVAL      WStringLen1 = WStringLen1 - WEndPos            BUG23280 BUG23280B
     C**********         EVAL      WStartPos = WStartPos + WEndPos                         BUG23280B
     C**********         EVAL      WEndPos = WEndPos + EDNCLN                               BUG23280
      *
     C**********         ENDDO                                                             BUG23280B
      *
     C**********         IF        WFlg = 'Y'                                              BUG23280B
     C**********         LEAVESR                                                           BUG23280B
     C**********         ENDIF                                                             BUG23280B
      *
     C**********         ENDIF                                                             BUG23280B
      *
      ** Line length is less than No of Characters per line
      *
     C**********         ELSEIF    WStringLen > *ZEROS                                     BUG23280B
     C**********         EVAL      ArrExtNarr(WLIdx) = WString                             BUG23280B
     C**********         EVAL      WLIdx = WLIdx + 1                                       BUG23280B
      *
     C**********         ENDIF                                                             BUG23280B
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRStrProc - Process for the String length greater than 70    *
      *              (Output)                                         *
      *                                                               *
      *****************************************************************
     C     SRStrProc     BEGSR
      *
     C                   EVAL      WLIdx1 = 1
      *
     C                   EVAL      ArrExtNarr(WLIdx) =
     C                             %SUBST(WString:WStartPos:WEndPos)
     C                   EVAL      WLIdx = WLIdx + 1
     C                   EVAL      WLIdx1 = WLIdx1 + 1
      *
      ** Remaining String and its Length
      *
     C                   EVAL      WRemStr = %SUBST(WString: 71)
     C                   EVAL      WLenofRemStr = %LEN(%TRIM(WRemStr))
      *
      ** Truncate lines is yes at nework level
      *
     C                   IF        EDTRLN = 'Y'
     C                   IF        WLIdx1 > WNwLine
     C                   EVAL      WLine = WLine + 1
     C                   LEAVESR
     C                   ENDIF
      *
      ** No of characters per line are greater than 70 (Output),
      ** move it to the next lines
      *
     C                   DOW       WLenofRemStr - WStartPos > 0
      *
     C                   IF        EDNCLN - WEndPos < 70
      *
     C                   IF        EDNCLN - WEndPos <= 0
     C                   LEAVE
     C                   ENDIF
      *
     C                   EVAL      ArrExtNarr(WLIdx) = %SUBST(WRemStr:
     C                             WStartPos:EDNCLN-WEndPos)
     C                   ELSE
      *
     C                   EVAL      ArrExtNarr(WLIdx) =
     C                             %SUBST(WRemStr: WStartPos: WEndPos)
     C                   ENDIF
      *
     C                   EVAL      WLIdx = WLIdx + 1
     C                   EVAL      WLIdx1 = WLIdx1 + 1
      *
     C                   IF        WLIdx1 > WNwLine
     C                   EVAL      WLine = WLine + 1
     C                   LEAVESR
     C                   ENDIF
      *
     C                   EVAL      WStartPos = WStartPos + WEndPos
     C                   EVAL      WEndPos = WEndPos + 70
      *
     C                   IF        %SUBST(WRemStr: WStartPos) = *BLANKS
     C                   EVAL      WLine = WLine + 1
     C                   LEAVESR
     C                   ENDIF
      *
     C                   ENDDO
      *
     C                   ENDIF
      *
      ** Wrap text is yes at nework level
      *
     C                   IF        EDWTXT = 'Y'
     C                   IF        WLenofRemStr > 70
      *
     C                   DO        WLenofRemStr
      *
     C                   IF        WLIdx1 > WNwLine
     C                   EVAL      WLine = WLine + 1
     C                   EVAL      WLIdx1 = 1
     C                   IF        WLine > EDNOLN
     C                   EVAL      WFlg = 'Y'
     C                   LEAVE
     C                   ENDIF
     C                   ENDIF
      *
     C                   EVAL      ArrExtNarr(WLIdx) =
     C                             %SUBST(WRemStr: WStartPos: WEndPos)
     C                   EVAL      WLIdx = WLIdx + 1
     C                   EVAL      WLIdx1 = WLIdx1 + 1
      *
     C                   IF        WLIdx1 > WNwLine
     C                   EVAL      WLine = WLine + 1
     C                   EVAL      WLIdx1 = 1
     C                   IF        WLine > EDNOLN
     C                   EVAL      WFlg = 'Y'
     C                   LEAVE
     C                   ENDIF
     C                   ENDIF
      *
     C                   EVAL      WStartPos = WStartPos + WEndPos
     C                   IF        %SUBST(WRemStr: WStartPos) = *BLANKS
     C                   LEAVE
     C                   ENDIF
      *
     C                   ENDDO
      *
     C                   IF        WFlg = 'Y'
     C                   LEAVESR
     C                   ENDIF
      *
     C                   ELSE
     C                   EVAL      ArrExtNarr(WLIdx) =
     C                             %SUBST(WRemStr: WStartPos)
     C                   EVAL      WLIdx = WLIdx + 1
     C                   EVAL      WLIdx1 = WLIdx1 + 1
      *
     C                   IF        WLIdx1 > WNwLine
     C                   EVAL      WLine = WLine + 1
     C                   ENDIF
      *
     C                   ENDIF
     C                   ENDIF
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRMerge - Merge Input (16*27) to Output (6*65) definition    *
      *            at network level                                   *
      *                                                               *
      *****************************************************************
     C     SRMerge       BEGSR
      *
      ** Populate ArrExtMrg from input params
      *
     C                   EVAL      ArrExtMrg(1) = PFormL1
     C                   EVAL      ArrExtMrg(2) = PFormL2
     C                   EVAL      ArrExtMrg(3) = PFormL3
     C                   EVAL      ArrExtMrg(4) = PFormL4
     C                   EVAL      ArrExtMrg(5) = PFormL5
     C                   EVAL      ArrExtMrg(6) = PFormL6
     C                   EVAL      ArrExtMrg(7) = PFormL7
     C                   EVAL      ArrExtMrg(8) = PFormL8
     C                   EVAL      ArrExtMrg(9) = PFormL9
     C                   EVAL      ArrExtMrg(10) = PFormL10
     C                   EVAL      ArrExtMrg(11) = PFormL11
     C                   EVAL      ArrExtMrg(12) = PFormL12
     C                   EVAL      ArrExtMrg(13) = PFormL13
     C                   EVAL      ArrExtMrg(14) = PFormL14
     C                   EVAL      ArrExtMrg(15) = PFormL15
     C                   EVAL      ArrExtMrg(16) = PFormL16
     C                   EVAL      ArrExtMrg(17) = PFormL17
     C                   EVAL      ArrExtMrg(18) = PFormL18
     C                   EVAL      ArrExtMrg(19) = PFormL19
     C                   EVAL      ArrExtMrg(20) = PFormL20
      *
      ** Do not do any further processing if input is blank
      *
     C                   MOVEA     ArrExtMrg     WExtMrg
     C                   IF        WExtMrg = *BLANKS
     C                   EVAL      *INLR = *ON
     C                   RETURN
     C                   ENDIF
      *
     C                   EVAL      WLIdx = 1
     C                   EVAL      WLine = 1
     C                   EVAL      WStartPos = 1
     C                   EVAL      WEndPos = EDNCLN
     C                   EVAL      WRemain = %LEN(WExtNarr1)                                BUG23952
      *
      ** Merge Lines according to no of lines  to be Merged
      *
     C                   IF        EDMGLN = 0
     C                   EVAL      WMrgLines = 16
     C                   ELSEIF    EDMGLN < 4
     C                   EVAL      WMrgLines = EDMGLN * 6
     C                   ELSE
     C                   EVAL      WMrgLines = 20
     C                   ENDIF
      *
      ** Merge all 16 lines as one line if no of lines
      ** to be Merged is zero
      *
     C                   IF        EDMGLN = 0
     C                   DOW       WLIdx <= WMrgLines
     C                   EVAL      WString = %TRIM(%TRIM(WString) +
     C                             %TRIM(ArrExtMrg(WLIdx)))
     C                   EVAL      WLIdx = WLIdx + 1
     C                   ENDDO
      *
      ** Make a long string and put separators according to no. of
      ** characters per line
      *
     C                   IF        WString <> *BLANKS
     C                   DO        EDNOLN
     C                   EVAL      WExtNarr1 = %TRIM(%TRIM(WExtNarr1)+
     C                             %SUBST(WString:WStartPos:WEndPos))+
     C**********                   EDLSEP                                                   BUG22701
     C                             %TRIM(EDLSEP)                                            BUG22701
     C                   EVAL      WStartPos = WStartPos + WEndPos
      *
      ** Get the remaining characters.  If the remaining characters                         BUG23952
      ** are less than the number of characters per line compare the                        BUG23952
      ** string using the remaining characters                                              BUG23952
                                                                                            BUG23952
     C                   EVAL      WRemain   = %LEN(WExtNarr) - WStartPos                   BUG23952
     C                   IF        WRemain >= WEndPos                                       BUG23952
     C                   IF        %SUBST(WExtNarr1:WStartPos:WEndPos)
     C                             = *BLANKS
     C                   LEAVE
     C                   ENDIF
                                                                                            BUG23952
     C                   ELSE                                                               BUG23952
     C                   IF        %SUBST(WExtNarr1:WStartPos:WRemain)                      BUG23952
     C                             = *BLANKS                                                BUG23952
     C                   LEAVE                                                              BUG23952
     C                   ENDIF                                                              BUG23952
                                                                                            BUG23952
     C                   ENDIF                                                              BUG23952
                                                                                            BUG23952
     C                   ENDDO
      *
     C                   ENDIF
      *
     C                   ELSE
      *
      ** Merge the lines according to no of lines to be merged
      *
     C                   DOW       WLIdx <= WMrgLines
      *
     C                   EVAL      WString = *BLANKS
     C                   EVAL      WStartPos = 1
      *
     C                   DO        EDMGLN
     C                   EVAL      WString = %TRIM(%TRIM(WString) +
     C                             %TRIM(ArrExtMrg(WLIdx)))
     C                   EVAL      WLIdx = WLIdx + 1
      *
     C                   IF        WLIdx > WMrgLines
     C                   EVAL      WFlg = 'Y'
     C                   LEAVE
     C                   ENDIF
      *
     C                   ENDDO
      *
      ** Any String remaining from the last Wrap text
      *
     C                   IF        WRemStr <> *BLANKS AND EDWTXT = 'Y'
     C                   EVAL      WString = %TRIM(WRemStr) +
     C                             %TRIM(WString)
     C                   ENDIF
      *
     C                   EVAL      WStringLen = %LEN(%TRIM(WString))
      *
      ** If the String is Blanks then don't do any process
      *
     C                   IF        WString <> *BLANKS
      *
      ** Wrap text is set to Yes
      *
     C                   IF        EDWTXT = 'Y'
      *
     C                   DO        EDNOLN
     C                   EVAL      WExtNarr1 = %TRIM(%TRIM(WExtNarr1)+
     C                             %SUBST(WString:WStartPos:WEndPos))+
     C**********                   EDLSEP                                                   BUG22701
     C                             %TRIM(EDLSEP)                                            BUG22701
     C                   EVAL      WLine = WLine + 1
      *
     C                   IF        WLine > EDNOLN
     C                   EVAL      WFlg = 'Y'
     C                   LEAVE
     C                   ENDIF
      *
     C                   EVAL      WStartPos = WStartPos + WEndPos
     C                   EVAL      WRemStr = *BLANKS
      *
     C                   EVAL      WRemain   = %LEN(WExtNarr) - WStartPos                   BUG23952
     C                   IF        WRemain >= WEndPos                                       BUG23952
     C                   IF        %SUBST(WString:WStartPos:WEndPos)
     C                             = *BLANKS
     C                   LEAVE
     C                   ELSE
      *
     C                   IF        %LEN(%TRIM(%SUBST(WString:WStartPos
     C                             :WStringLen))) < EDNCLN
     C                   EVAL      WRemStr = %SUBST(WString:WStartPos
     C                             :WStringLen)
     C                   LEAVE
     C                   ENDIF
     C                   ENDIF
                                                                                            BUG23952
     C                   ELSE                                                               BUG23952
     C                   IF        %SUBST(WString:WStartPos:WRemain)                        BUG23952
     C                             = *BLANKS                                                BUG23952
     C                   LEAVE                                                              BUG23952
     C                   ELSE                                                               BUG23952
      *                                                                                     BUG23952
     C                   IF        %LEN(%TRIM(%SUBST(WString:WStartPos                      BUG23952
     C                             :WStringLen))) < EDNCLN                                  BUG23952
     C                   EVAL      WRemStr = %SUBST(WString:WStartPos                       BUG23952
     C                             :WStringLen)                                             BUG23952
     C                   LEAVE                                                              BUG23952
     C                   ENDIF                                                              BUG23952
     C                   ENDIF                                                              BUG23952
                                                                                            BUG23952
     C                   ENDIF                                                              BUG23952
                                                                                            BUG23952
      *
     C                   ENDDO
      *
     C                   ENDIF
      *
      ** Truncate Lines is set to yes at network level
      *
     C                   IF        EDTRLN = 'Y'
      *
     C                   EVAL      WExtNarr1 = %TRIM(%TRIM(WExtNarr1)+
     C                             %SUBST(WString:1:EDNCLN))+
     C**********                   EDLSEP                                                   BUG22701
     C                             %TRIM(EDLSEP)                                            BUG22701
     C                   EVAL      WLine = WLine + 1
      *
     C                   IF        WLine > EDNOLN
     C                   LEAVE
     C                   ENDIF
      *
     C                   ENDIF
     C                   ENDIF
      *
     C                   IF        WFlg = 'Y'
     C                   LEAVE
     C                   ENDIF
      *
     C                   ENDDO
      *
     C                   ENDIF
      *
      ** Remove the separator from last position
      *
     C                   EVAL      WLSepLn = %LEN(%TRIM(EDLSEP))
     C                   EVAL      WLngStr = %LEN(%TRIM(WExtNarr1))
     C                   EVAL      WExtNarr = WExtNarr1
     C                   EVAL      WExtNarr1 = *BLANKS
     C                   EVAL      WExtNarr1 = %SUBST(WExtNarr:
     C                             1:WLngStr - WLSepLn)
      *
     C                   EVAL      PNarr1 = WNarr1
     C                   EVAL      PNarr2 = WNarr2
     C                   EVAL      PNarr3 = WNarr3
     C                   EVAL      PNarr4 = WNarr4
     C                   EVAL      PNarr5 = WNarr5
     C                   EVAL      PNarr6 = WNarr6
      *
     C                   ENDSR
      *****************************************************************                    BUG23445A
      /EJECT                                                                               BUG23445A
      *****************************************************************                    BUG23445A
      *                                                               *                    BUG23445A
      ***SRRemSep*-*Find*network*linked*to*transaction*and*remove******          BUG23445A BUG23280D
      **************separators*from*incoming*ext*narratives************          BUG23445A BUG23280D
      *  SrFnNet - Find default network linked to transaction         *                    BUG23280D
      *                                                               *                    BUG23445A
      *  Called by : Main                                             *                    BUG23445A
      *                                                               *                    BUG23445A
      *  Calls : None                                                 *                    BUG23445A
      *                                                               *                    BUG23445A
      *****************************************************************                    BUG23445A
      *                                                                                    BUG23445A
     C*****SrRemSep      BEGSR                                                   BUG23445A BUG23280D
     C     SrFnNet       BEGSR                                                             BUG23280D
      *                                                                                    BUG23445A
     C                   IF        PFormL1 <> *BLANKS                                      BUG23280D
     C                   MOVEL     PFormL1       KNwrk1                                    BUG23280D
     C                   EVAL      PFormL1 = *BLANKS                                        BUG24304
     C                   ELSE                                                              BUG23280D
     C                   EVAL      KBrca = PBrca                                           BUG23445A
     C                   EVAL      KCNum = PCNum                                           BUG23445A
     C                   EVAL      KCcy = PCcy                                             BUG23445A
     C                   EVAL      KAccd = PAccd                                           BUG23445A
     C                   EVAL      KAcsq = PAcsq                                           BUG23445A
      *                                                                                    BUG23445A
      ** When Account is not present then use the default 'SWIFT'                          BUG23445A
      *                                                                                    BUG23445A
     C     KAcct         CHAIN     GLNW94L11                                               BUG23445A
      *                                                                                    BUG23445A
     C                   IF        NOT %FOUND (GLNW94L11)                                  BUG23445A
      *                                                                                    BUG23445A
     C     KAcct         CHAIN     GLNW94L8                                                BUG23445A
     C                   IF        NOT %FOUND (GLNW94L8)                                   BUG23445A
     C                   EVAL      KNwrk1= 'SWIFT'                                         BUG23445A
     C                   ELSE                                                              BUG23445A
      *                                                                                    BUG23445A
      ** Loop to get First network with Extended naarative flag as 'Y'                     BUG23445A
      *                                                                                    BUG23445A
     C                   DOW       NOT %EOF(GLNW94L8)                                      BUG23445A
     C                   EVAL      KNwrk1= N4NWRK                                          BUG23445A
      *                                                                                    BUG23445A
     C                   CALL      'AONWRKR1'                                              BUG23445A
     C                   PARM      *BLANKS       PRtCdIn                                   BUG23445A
     C                   PARM      '*KEY'        POptnIn                                   BUG23445A
     C                   PARM      KNwrk1        PNwrkIn                                   BUG23445A
     C     DSNwrkN       PARM                    DSLDY                                     BUG23445A
      *                                                                                    BUG23445A
     C**********         IF        PRtCd <> *BLANKS                              BUG23445A BUG23280D
     C                   IF        PRtCdIn <> *BLANKS                                      BUG23280D
      *                                                                                    BUG23445A
     C     *LOCK         IN        LDA                                                     BUG23445A
      *                                                                                    BUG23445A
     C                   EVAL      DBASE = 003                                             BUG23445A
     C                   EVAL      DBFILE = 'SDNWRKPD'                                     BUG23445A
     C                   EVAL      DBKEY  = KNwrk1                                         BUG23445A
     C                   EVAL      DBPGM = 'MG001900'                                      BUG23445A
      *                                                                                    BUG23445A
     C                   OUT       LDA                                                     BUG23445A
     C                   EXSR      *PSSR                                                   BUG23445A
     C                   ENDIF                                                             BUG23445A
      *                                                                                    BUG23445A
     C                   IF        EDENRA <> 'Y'                                           BUG23445A
     C     KAcct         READE     GLNW94L8                                                BUG23445A
     C                   ELSE                                                              BUG23445A
     C                   LEAVE                                                             BUG23445A
     C                   ENDIF                                                             BUG23445A
     C                   ENDDO                                                             BUG23445A
      *                                                                                    BUG23445A
     C                   ENDIF                                                             BUG23445A
      *                                                                                    BUG23445A
     C                   ELSE                                                              BUG23445A
     C                   EVAL      KNwrk1= N4NWRK                                          BUG23445A
     C                   ENDIF                                                             BUG23445A
      *                                                                                    BUG23445A
     C                   ENDIF                                                             BUG23280D
      *                                                                                    BUG23445A
      ** Retrieve the associated network record and find the format                        BUG23445A
      ** related to the network else issue an error                                        BUG23445A
      *                                                                                    BUG23445A
     C                   CALL      'AONWRKR1'                                              BUG23445A
     C                   PARM      *BLANKS       PRtCdIn                                   BUG23445A
     C                   PARM      '*KEY'        POptnIn                                   BUG23445A
     C                   PARM      KNwrk1        PNwrkIn                                   BUG23445A
     C     DSNwrkN       PARM                    DSLDY                                     BUG23445A
      *                                                                                    BUG23445A
     C**********         IF        PRtCd <> *BLANKS                              BUG23445A BUG23280D
     C                   IF        PRtCdIn <> *BLANKS                                      BUG23280D
      *                                                                                    BUG23445A
     C     *LOCK         IN        LDA                                                     BUG23445A
      *                                                                                    BUG23445A
     C                   EVAL      DBASE = 004                                             BUG23445A
     C                   EVAL      DBFILE = 'SDNWRKPD'                                     BUG23445A
     C                   EVAL      DBKEY  = KNwrk1                                         BUG23445A
     C                   EVAL      DBPGM = 'MG001900'                                      BUG23445A
      *                                                                                    BUG23445A
     C                   OUT       LDA                                                     BUG23445A
     C                   EXSR      *PSSR                                                   BUG23445A
     C                   ENDIF                                                             BUG23445A
      *                                                                                    BUG23445A
      ** Line Separator for the transaction                                                BUG23445A
      *                                                                                    BUG23445A
     C                   EVAL      WLSep = N_EDLSEP                                        BUG23445A
     C                   EVAL      EDLSEP = N_EDLSEP                                       BUG23280D
      *                                                                                    BUG23445A
     C                   ENDSR                                                             BUG23280D
      *****************************************************************                    BUG23280D
      /EJECT                                                                               BUG23280D
      *****************************************************************                    BUG23280D
      *                                                               *                    BUG23280D
      *  SRNarr - Extract narratives in proper form for formatting    *                    BUG23280D
      *                                                               *                    BUG23280D
      *  Called by : Main                                             *                    BUG23280D
      *                                                               *                    BUG23280D
      *  Calls : SrSTFmt , SrMrgExt                                   *                    BUG23280D
      *                                                               *                    BUG23280D
      *****************************************************************                    BUG23280D
     C     SrNarr        BEGSR                                                             BUG23280D
     C                   EVAL      WNarr = *BLANKS                                         BUG23445A
      *                                                                                    BUG23445A
      *                                                                                    BUG23445A
     C                   EVAL      WNarr=  PNarr1 + PNarr2 +                               BUG23445A
     C                                     PNarr3 + PNarr4 +                               BUG23445A
     C                                     PNarr5 + PNarr6                                 BUG23445A
      *                                                                                    BUG23445A
     C                   EVAL      WSepPos = *ZEROS                                        BUG23445A
     C                   IF        WLSep <> *BLANKS                                        BUG23445A
     C                   EVAL      WSepPos = %SCAN(%TRIM(WLSep):WNarr)                     BUG23445A
     C                   EVAL      WLen = %LEN(%TRIM(WLSep))                               BUG23445A
     C                   ENDIF                                                             BUG23445A
      *                                                                                    BUG23280D
      ** If /IACC/Dn indicator used in data remove it  from Pnarr1                         BUG23280D
      *                                                                                    BUG23280D
     C                   IF        (PDCInd = '0' OR PDCInd = '1' OR                        BUG23280D
     C                             PDCInd = '2' OR PDCInd = '3')                           BUG23280D
     C**********                   AND EDMCNW = 'Y'                               BUG23280D BUG24069
     C                   EVAL      WPs = %SCAN('/IACC/D':Pnarr1)                           BUG23280D
      *                                                                                    BUG23280D
     C                   IF        WPs > *ZEROS                                            BUG23280D
     C                   IF        WSepPos = *ZEROS                                        BUG23280D
     C                   EVAL      PNarr1 = %REPLACE('':Pnarr1:WPs:8)                      BUG23280D
     C                   ELSE                                                              BUG23280D
     C                   EVAL      WNarr = %REPLACE('':WNarr:WPs:8)                        BUG23280D
     C                   ENDIF                                                             BUG23280D
     C                   ENDIF                                                             BUG23280D
     C                   ENDIF                                                             BUG23280D
      *                                                                                    BUG23280D
      ** Formatting to be done differently when default network is STRCT                   BUG23280D
      *                                                                                    BUG23280D
     C                   EVAL      WPsFld  = 0                                             BUG23280D
     C                   IF        N_EDF86F = 'STRCT'                                      BUG23280D
     C                   MOVEL     N_EDFSEP      WVal                                      BUG23280D
     C                   MOVE      '20'          WVal                                      BUG23280D
     C                   EVAL      WPsFld = %SCAN(WVal : Wnarr)                            BUG23280D
     C                   MOVE      '00'          WVal                                       BUG26814
     C                   EVAL      WPsFld2 = %SCAN(WVal : Wnarr)                            BUG26814
     C                   ENDIF                                                             BUG23280D
      *                                                                                    BUG23280D
     C**********         IF        WPsFld > 0                                     BUG23280D BUG26814
     C                   IF        WPsFld > 0 OR WPsFld2 > 0                                BUG26814
     C                   EVAL      WNarrTmp = *BLANKS                                      BUG23280D
     C                   EVAL      WFldSep ='Y'                                            BUG23280D
      *                                                                                    BUG23280D
     C                   EXSR      SrSTFmt                                                 BUG23280D
     C                   EVAL      WNarr =  WNarrTmp                                       BUG23280D
     C                   EVAL      WLSep = WDummy                                          BUG23280D
     C                   ELSE                                                              BUG23280D
      *                                                                                    BUG23280D
      ** Initialize formatting flag                                                        BUG23280D
      *                                                                                    BUG23280D
     C                   EVAL      WStrct = 'N'                                            BUG23280D
     C                   EVAL      WFmtFlg = 'N'                                           BUG23280D
     C                   EVAL      WFmtStrct ='N'                                          BUG23280D
     C                   EVAL      WBlFlg ='N'                                             BUG23280D
     C                   EVAL      WIndx = 1                                               BUG23280D
     C                   EVAL      WLIdx = 1                                               BUG23280D
     C                   EVAL      WNoChar = *ZEROS                                        BUG23280D
     C                   EVAL      WPos1 = 0                                               BUG23280D
     C                   EVAL      WStart = 1                                              BUG23280D
      *                                                                                    BUG23280D
      ** For correspondance if requesting network is STRCT                                 BUG23280D
      *                                                                                    BUG23280D
     C                   IF        EDF86F = 'STRCT'  AND EDNOLN = 1                        BUG23280D
     C**********                   AND EDNCLN = 387                               BUG23280D BUG26814
     C**********         EVAL      EDNOLN = 15                                    BUG23280D BUG26814
     C**********         EVAL      EDNCLN = 27                                    BUG23280D BUG26814
     C                   EVAL      EDNOLN = 20                                              BUG26814
     C                   EVAL      EDNCLN = 34                                              BUG26814
     C                   ENDIF                                                             BUG23280D
      *                                                                                    BUG23280D
      ** If No line separators are used in data                                            BUG23280D
      *                                                                                    BUG23280D
     C                   IF        WSepPos = *ZEROS                                        BUG23280D
      *                                                                                    BUG23280D
      ** Move values to an array                                                           BUG23280D
      *                                                                                    BUG23280D
     C                   EVAL      ArrExt(1) = PNarr1                                      BUG23280D
     C                   EVAL      ArrExt(2) = PNarr2                                      BUG23280D
     C                   EVAL      ArrExt(3) = PNarr3                                      BUG23280D
     C                   EVAL      ArrExt(4) = PNarr4                                      BUG23280D
     C                   EVAL      ArrExt(5) = PNarr5                                      BUG23280D
     C                   EVAL      ArrExt(6) = PNarr6                                      BUG23280D
      *                                                                                    BUG23280D
      ** Get Number of lines/chars in extended narratives                                  BUG23280D
      *                                                                                    BUG23280D
     C                   DOW       WIndx < 7                                               BUG23280D
     C                   EVAL      WNoChar = %LEN(%TRIM(ArrExt(WIndx)))                    BUG23280D
      *                                                                                    BUG23280D
     C                   IF        WNoChar > *ZEROS                                        BUG23280D
     C                   EVAL      WLIdx = WLIdx + 1                                       BUG23280D
      *                                                                                    BUG23280D
      ** Check for STRCT format                                                            BUG23280D
      *                                                                                    BUG23280D
     C                   IF        N_EDF86F = 'STRCT' AND WNoChar > 27                     BUG23280D
     C                             AND EDF86F <> 'SWIFT'                                    BUG26826
     C                   EVAL      WFmtStrct ='Y'                                          BUG23280D
     C                   EVAL      WFmtFlg   ='Y'                                          BUG23280D
     C                   LEAVE                                                             BUG23280D
     C                   ENDIF                                                             BUG23280D
      *                                                                                    BUG23280D
      ** If input no. of lines/chars is greater than requesting n/w's max len/chars        BUG23280D
      ** then formatting is required.                                                      BUG23280D
      *                                                                                    BUG23280D
     C                   IF        (WLIdx -1) > EDNOLN OR                                  BUG23280D
     C                             WNoChar > EDNCLN                                        BUG23280D
      *                                                                                    BUG23280D
     C                   EVAL      WFmtFlg = 'Y'                                           BUG23280D
     C                   LEAVE                                                             BUG23280D
     C                   ENDIF                                                             BUG23280D
      *                                                                                    BUG23280D
     C                   ENDIF                                                             BUG23280D
      *                                                                                    BUG23280D
     C                   EVAL      WIndx = WIndx + 1                                       BUG23280D
     C                   ENDDO                                                             BUG23280D
      *                                                                                    BUG23280D
     C                   IF        WFmtStrct ='Y' AND N_EDF86F ='STRCT'                    BUG23280D
     C                   EXSR      SrMrgExt                                                BUG23280D
     C                   EVAL      WTVal =  EDNOLN * EDNCLN                                BUG23280D
     C                   IF        WTVal > 390                                             BUG23280D
     C                   EVAL      WTVal = 390                                             BUG23280D
     C                   ENDIF                                                             BUG23280D
     C                   EVAL      WNarrTmp = *BLANKS                                      BUG23280D
     C                   EVAL      WNarrTmp = %SUBST(WNarr : 1 : WTVal)                    BUG23280D
     C                   EVAL      WNarr  = *BLANKS                                        BUG23280D
     C                   EVAL      WNarr  = WNarrTmp                                       BUG23280D
     C                   ENDIF                                                             BUG23280D
      *                                                                                    BUG23280D
      ** Check for data with line separators                                               BUG23280D
      *                                                                                    BUG23280D
     C                   ELSE                                                              BUG23280D
      *                                                                                    BUG23280D
      ** Find position of line separator                                                   BUG23280D
      *                                                                                    BUG23280D
     C                   EVAL      WPos1 = %SCAN(%TRIM(WLSep):WNarr                        BUG23280D
     C                                    :WStart)                                         BUG23280D
     C                   EVAL      WLSepLn = %LEN(%TRIM(WLSep))                            BUG23280D
      *                                                                                    BUG23280D
     C                   DOW       WFmtFlg =  'N'                                          BUG23280D
      *                                                                                    BUG23280D
     C                   IF        %SUBST(WNarr: WStart) = *BLANKS                         BUG23280D
     C                   LEAVE                                                             BUG23280D
     C                   ENDIF                                                             BUG23280D
      *                                                                                    BUG23280D
     C                   EVAL      WNoChar = %LEN(%TRIM(%SUBST(WNarr:                      BUG23280D
     C                             WStart:(WPos1 - WStart))))                              BUG23280D
      *                                                                                    BUG23280D
     C                   IF        WNoChar > *ZEROS                                        BUG23280D
     C                   EVAL      WLIdx = WLIdx + 1                                       BUG23280D
      *                                                                                    BUG23280D
      ** If input no. of lines/chars is greater than requesting n/w's max len/chars        BUG23280D
      ** then formatting is required.                                                      BUG23280D
      *                                                                                    BUG23280D
     C                   IF        (WLIdx -1) > EDNOLN OR                                  BUG23280D
     C                             WNoChar > EDNCLN                                        BUG23280D
      *                                                                                    BUG23280D
     C                   EVAL      WFmtFlg = 'Y'                                           BUG23280D
     C                   LEAVE                                                             BUG23280D
     C                   ENDIF                                                             BUG23280D
      *                                                                                    BUG23280D
     C                   ENDIF                                                             BUG23280D
      *                                                                                    BUG23280D
     C                   IF        WFlg = 'Y'                                              BUG23280D
     C                   LEAVE                                                             BUG23280D
     C                   ENDIF                                                             BUG23280D
      *                                                                                    BUG23280D
     C                   EVAL      WStart = WPos1 + WLSepLn                                BUG23280D
     C                   EVAL      WPos1 = %SCAN(%TRIM(WLSep):WNarr                        BUG23280D
     C                                    :WStart)                                         BUG23280D
     C                   IF        WPos1 = *ZEROS                                          BUG23280D
     C                   EVAL      WPos1 = %LEN(%TRIM(WNarr)) + 1                          BUG23280D
     C                   EVAL      WFlg = 'Y'                                              BUG23280D
     C                   ENDIF                                                             BUG23280D
      *                                                                                    BUG23280D
     C                   ENDDO                                                             BUG23280D
      *                                                                                    BUG23280D
     C                   ENDIF                                                             BUG23280D
     C                   ENDIF                                                             BUG23280D
      *                                                                                    BUG23280D
      ** Check if formatting required                                                      BUG23280D
      *                                                                                    BUG23280D
     C                   IF        WFmtStrct = 'N'                                         BUG23280D
      *                                                                                    BUG23280D
     C                   IF        ((EDNWRK = N_EDNWRK) AND (N_EDNOLN = EDNOLN)            BUG23280D
     C**********                   AND (N_EDNCLN = EDNCLN)) OR WFmtFlg = 'N'      BUG23280D BUG26538
     C**********                   AND (N_EDNCLN = EDNCLN) AND (WFmtFlg = 'N'))    BUG26538 BUG26625
     C                             AND (EDF86F <> 'UNSD0') AND                              BUG26625
     C                             (EDF86F <> 'SWIFT') AND (N_EDNCLN = EDNCLN))             BUG26625
     C                             OR WFmtFlg = 'N'                                         BUG26625
     C                   EVAL      WFmtFlg = 'N'                                           BUG23280D
      *                                                                                    BUG23280D
      ** No formatting required                                                            BUG23280D
      *                                                                                    BUG23280D
     C                   IF        WSepPos = *ZEROS                                        BUG23280D
     C                   EVAL      ArrExtNarr(1) = PNarr1                                  BUG23280D
     C                   EVAL      ArrExtNarr(2) = PNarr2                                  BUG23280D
     C                   EVAL      ArrExtNarr(3) = PNarr3                                  BUG23280D
     C                   EVAL      ArrExtNarr(4) = PNarr4                                  BUG23280D
     C                   EVAL      ArrExtNarr(5) = PNarr5                                  BUG23280D
     C                   EVAL      ArrExtNarr(6) = PNarr6                                  BUG23280D
     C                   ELSE                                                              BUG23280D
      *                                                                                    BUG23280D
      ** Populate extended narratives into individual fields                               BUG23280D
      *                                                                                    BUG23280D
     C                   EVAL      WStart = 1                                              BUG23280D
     C                   EVAL      WLn = 1                                                 BUG23280D
     C                   EVAL      WPos1 = 0                                               BUG23280D
     C                   EVAL      WFlg = 'N'                                              BUG23280D
      *                                                                                    BUG23280D
      ** Find position of line separator                                                   BUG23280D
      *                                                                                    BUG23280D
     C                   EVAL      WPos1 = %SCAN(%TRIM(WLSep):WNarr                        BUG23280D
     C                                    :WStart)                                         BUG23280D
     C                   EVAL      WLSepLn = %LEN(%TRIM(WLSep))                            BUG23280D
      *                                                                                    BUG23280D
     C                   DOW       WLn < 21                                                BUG23280D
      *                                                                                    BUG23280D
     C                   IF        %SUBST(WNarr: WStart) = *BLANKS                         BUG23280D
     C                   LEAVE                                                             BUG23280D
     C                   ENDIF                                                             BUG23280D
      *                                                                                    BUG23280D
     C                   EVAL      ArrExtNarr(WLn) = %SUBST(WNarr:                         BUG23280D
     C                             WStart:(WPos1 - WStart))                                BUG23280D
      *                                                                                    BUG23280D
     C                   IF        WFlg = 'Y'                                              BUG23280D
     C                   LEAVE                                                             BUG23280D
     C                   ENDIF                                                             BUG23280D
      *                                                                                    BUG23280D
     C                   EVAL      WStart = WPos1 + WLSepLn                                BUG23280D
     C                   EVAL      WPos1 = %SCAN(%TRIM(WLSep):WNarr                        BUG23280D
     C                                    :WStart)                                         BUG23280D
     C                   IF        WPos1 = *ZEROS                                          BUG23280D
     C                   EVAL      WPos1 = %LEN(%TRIM(WNarr)) + 1                          BUG23280D
     C                   EVAL      WFlg = 'Y'                                              BUG23280D
     C                   ENDIF                                                             BUG23280D
      *                                                                                    BUG23280D
     C                   EVAL      WLn = WLn + 1                                           BUG23280D
     C                   ENDDO                                                             BUG23280D
      *                                                                                    BUG23280D
     C                   ENDIF                                                             BUG23280D
      *                                                                                    BUG23280D
      ** Else format the narratives as requested.                                          BUG23280D
      *                                                                                    BUG23280D
     C                   ELSE                                                              BUG23280D
      *                                                                                    BUG23280D
      ** If Wrap Text for requesting network is 'Y'                                        BUG23280D
      *                                                                                    BUG23280D
     C                   IF        EDWTXT = 'Y'                                            BUG23280D
      *                                                                                    BUG23280D
      ** If no line separator is used in the extended narrative                            BUG23280D
      *                                                                                    BUG23280D
     C                   IF        WSepPos = *ZEROS                                        BUG23280D
     C                   EVAL      WNarr = *BLANKS                                         BUG23280D
     C                   EVAL      WNarr = %TRIM(PNarr1) + '  '+                           BUG23280D
     C                                     %TRIM(PNarr2) + '  '+                           BUG23280D
     C                                     %TRIM(PNarr3) + '  '+                           BUG23280D
     C                                     %TRIM(PNarr4) + '  '+                           BUG23280D
     C                                     %TRIM(PNarr5) + '  '+                           BUG23280D
     C                                     %TRIM(PNarr6)                                   BUG23280D
      *                                                                                    BUG23280D
      ** If line separators are present                                                    BUG23280D
      *                                                                                    BUG23280D
     C                   ELSE                                                              BUG23280D
     C                   IF        EDKLSP = 'N' OR                                         BUG23280D
     C                             EDNWRK = N_EDNWRK                                       BUG23280D
     C                   EVAL      WPos = %SCAN(%TRIM(WLSep):WNarr)                        BUG23280D
      *                                                                                    BUG23280D
     C                   DOW       WPos > *ZEROS                                           BUG23280D
     C                   EVAL      WNarr = %REPLACE('  ':WNarr:WPos:WLen)                  BUG23280D
     C                   EVAL      WPos = %SCAN(%TRIM(WLSep):WNarr)                        BUG23280D
     C                   ENDDO                                                             BUG23280D
     C                   ENDIF                                                             BUG23280D
      **********                                                                 BUG23445A BUG23280D
      ***If*Wrap*Text*for*requesting*network*is*'Y'                              BUG23445A BUG23280D
      **********                                                                 BUG23445A BUG23280D
     C**********         IF        EDWTXT = 'Y'                                  BUG23445A BUG23280D
      **********                                                                 BUG23445A BUG23280D
      ***If*no*line*separator*is*used*in*the*extended*narrative                  BUG23445A BUG23280D
      **********                                                                 BUG23445A BUG23280D
     C**********         IF        WSepPos = *ZEROS                              BUG23445A BUG23280D
     C**********         EVAL      WNarr = *BLANKS                               BUG23445A BUG23280D
     C**********         EVAL      WNarr = %TRIM(PNarr1) + ' '+                  BUG23445A BUG23280D
     C**********                           %TRIM(PNarr2) + ' '+                  BUG23445A BUG23280D
     C**********                           %TRIM(PNarr3) + ' '+                  BUG23445A BUG23280D
     C**********                           %TRIM(PNarr4) + ' '+                  BUG23445A BUG23280D
     C**********                           %TRIM(PNarr5) + ' '+                  BUG23445A BUG23280D
     C**********                           %TRIM(PNarr6)                         BUG23445A BUG23280D
      **********                                                                 BUG23445A BUG23280D
      ***If*line*separators*are*present                                          BUG23445A BUG23280D
      **********                                                                 BUG23445A BUG23280D
     C**********         ELSE                                                    BUG23445A BUG23280D
     C**********         EVAL      WPos2= %SCAN(%TRIM(WLSep):WNarr)              BUG23445A BUG23280D
      **********                                                                 BUG23445A BUG23280D
     C**********         DOW       WPos2 > *ZEROS                                BUG23445A BUG23280D
     C**********         EVAL      WNarr = %REPLACE(' ':WNarr:WPos2:WLen)        BUG23445A BUG23280D
     C**********         EVAL      WPos2 = %SCAN(%TRIM(WLSep):WNarr)             BUG23445A BUG23280D
     C**********         ENDDO                                                   BUG23445A BUG23280D
      **********                                                                 BUG23445A BUG23280D
     C**********                                                                 BUG23445A BUG23280D
      **********                                                                 BUG23445A BUG23280D
      ***Else*if*truncate*is*set*for*the*network                                 BUG23445A BUG23280D
      **********                                                                 BUG23445A BUG23280D
     C**********         ELSE                                                    BUG23445A BUG23280D
      **********                                                                 BUG23445A BUG23280D
      ** If**line*separator*is*used*in*the*extended*narrative                    BUG23445A BUG23280D
      ***just*replace*the*incoming*line*separator*with*the*requesting            BUG23445A BUG23280D
      ***network's*line*separator                                                BUG23445A BUG23280D
      **********                                                                 BUG23445A BUG23280D
     C**********         IF        WSepPos > *ZEROS                              BUG23445A BUG23280D
     C**********         IF        EDLSEP <> N_EDLSEP                            BUG23445A BUG23280D
     C**********         EVAL      WPos2 = %SCAN(%TRIM(WLSep):WNarr)             BUG23445A BUG23280D
      **********                                                                 BUG23445A BUG23280D
     C**********         DOW       WPos2 > *ZEROS                                BUG23445A BUG23280D
     C**********         EVAL      WNarr = %REPLACE(%TRIM(EDLSEP):WNarr          BUG23445A BUG23280D
     C**********                           :WPos2 :WLen)                         BUG23445A BUG23280D
     C**********         EVAL      WPos2 = %SCAN(%TRIM(WLSep):WNarr)             BUG23445A BUG23280D
     C**********         ENDDO                                                   BUG23445A BUG23280D
     C**********         ENDIF                                                   BUG23445A BUG23280D
     C**********         ENDIF                                                   BUG23445A BUG23280D
      **********                                                                 BUG23445A BUG23280D
     C**********         ENDIF                                                   BUG23445A BUG23280D
      **********                                                                 BUG23445A BUG23280D
      ** Move the string back to original variables                                        BUG23445A
      *                                                                                    BUG23445A
     C                   EVAL      PNarr1 = %SUBST(WNarr:1 :65)                            BUG23445A
     C                   EVAL      PNarr2 = %SUBST(WNarr:66 :65)                           BUG23445A
     C                   EVAL      PNarr3 = %SUBST(WNarr:131 :65)                          BUG23445A
     C                   EVAL      PNarr4 = %SUBST(WNarr:196 :65)                          BUG23445A
     C                   EVAL      PNarr5 = %SUBST(WNarr:261 :65)                          BUG23445A
     C                   EVAL      PNarr6 = %SUBST(WNarr:326 :65)                          BUG23445A
      *                                                                                    BUG23280D
     C                   ENDIF                                                             BUG23280D
     C                   ENDIF                                                             BUG23280D
     C                   ENDIF                                                             BUG23280D
     C                   ENDIF                                                             BUG23280D
      *                                                                                    BUG23445A
     C                   ENDSR                                                             BUG23445A
      *                                                                                    BUG23280D
      *****************************************************************                    BUG23280D
      /EJECT                                                                               BUG23280D
      *****************************************************************                    BUG23280D
      *                                                               *                    BUG23280D
      *  SrMrgExt -  Merge narratives prioperly when default network  *                    BUG23280D
      *              is Structured                                    *                    BUG23280D
      *                                                               *                    BUG23280D
      *  Called by : Main                                             *                    BUG23280D
      *                                                               *                    BUG23280D
      *  Calls : None                                                 *                    BUG23280D
      *                                                               *                    BUG23280D
      *****************************************************************                    BUG23280D
     C     SrMrgExt      BEGSR                                                             BUG23280D
      *                                                                                    BUG23280D
     C                   EVAL      WIndx = 1                                               BUG23280D
     C                   EVAL      WNoChar = *ZEROS                                        BUG23280D
     C                   EVAL      WNarr= *BLANKS                                          BUG23280D
     C                   EVAL      WPsBl = 1                                               BUG23280D
     C                   EVAL      WBlFlg = 'N'                                            BUG23280D
      *                                                                                    BUG23280D
      ** If /IACC/Dn indicator used in data remove it  from Pnarr1                         BUG23280D
      *                                                                                    BUG23280D
     C                   IF        (PDCInd = '0' OR PDCInd = '1' OR                        BUG23280D
     C                             PDCInd = '2' OR PDCInd = '3')                           BUG23280D
     C**********                   AND EDMCNW = 'Y'                               BUG23280D BUG24069
     C                   EVAL      WPs = %SCAN('/IACC/D':ArrExt(1))                        BUG23280D
      *                                                                                    BUG23280D
     C                   IF        WPs > *ZEROS                                            BUG23280D
     C                   EVAL      ArrExt(1) = %REPLACE('': ArrExt(1) :WPs:8)              BUG23280D
     C                   ENDIF                                                             BUG23280D
     C                   ENDIF                                                             BUG23280D
      *                                                                                    BUG23280D
      ** When requesting network is STRCT                                                  BUG23280D
      *                                                                                    BUG23280D
     C**********         IF        EDNOLN = 1 and EDNCLN = 387  AND               BUG23280D BUG26814
     C                   IF        EDNOLN = 1 AND                                           BUG26814
     C                             EDF86F = 'STRCT'                                        BUG23280D
     C**********         EVAL      EDNOLN = 15                                    BUG23280D BUG26814
     C**********         EVAL      EDNCLN = 27                                    BUG23280D BUG26814
     C                   EVAL      EDNOLN = 20                                              BUG26814
     C                   EVAL      EDNCLN = 34                                              BUG26814
     C                   ENDIF                                                             BUG23280D
      *                                                                                    BUG23280D
     C                   DOW       WIndx < 7                                               BUG23280D
     C                   EVAL      WNoChar = %LEN(%TRIM(ArrExt(WIndx)))                    BUG23280D
      *                                                                                    BUG23280D
     C                   IF        WNoChar > 0                                             BUG23280D
      *                                                                                    BUG23280D
     C                   IF        WNoChar < 63                                            BUG23280D
     C                   EVAL      %SUBST(WNarr:WPsBl : WNoChar)                           BUG23280D
     C                             = %TRIMR(ArrExt(WIndx))                                 BUG23280D
      *                                                                                    BUG23280D
     C                   IF        WNoChar = EDNCLN  AND WBlFlg ='N'                       BUG23280D
     C                   EVAL      WPsBl = WPsBl + WNoChar                                 BUG23280D
     C                   ELSE                                                              BUG23280D
     C                   EVAL      WBlFlg ='Y'                                             BUG23280D
     C                   EVAL      WPsBl = WPsBl + WNoChar + 2                             BUG23280D
     C                   ENDIF                                                             BUG23280D
      *                                                                                    BUG23280D
     C                   ELSE                                                              BUG23280D
     C                   EVAL      %SUBST(WNarr:WPsBl : WNoChar)                           BUG23280D
     C                             = ArrExt(WIndx)                                         BUG23280D
     C                   EVAL      WPsBl = WPsBl + 65                                      BUG23280D
     C                   ENDIF                                                             BUG23280D
      *                                                                                    BUG23280D
     C                   ENDIF                                                             BUG23280D
      *                                                                                    BUG23280D
     C                   EVAL      WIndx = WIndx + 1                                       BUG23280D
     C                   ENDDO                                                             BUG23280D
      *                                                                                    BUG23280D
     C                   ENDSR                                                             BUG23280D
      *****************************************************************                    BUG23280D
      /EJECT                                                                               BUG23280D
      *****************************************************************                    BUG23280D
      *                                                               *                    BUG23280D
      *  SrSTFmt - Extract narratives when field separators are used  *                    BUG23280D
      *            in data for default Structured format              *                    BUG23280D
      *                                                               *                    BUG23280D
      *  Called by : Main                                             *                    BUG23280D
      *                                                               *                    BUG23280D
      *  Calls : SrSetNar                                             *                    BUG23280D
      *                                                               *                    BUG23280D
      *****************************************************************                    BUG23280D
     C     SrSTFmt       BEGSR                                                             BUG23280D
      *                                                                                    BUG23280D
     C                   EVAL      WPsFld  = 0                                             BUG23280D
     C                   EVAL      WPsFld1 = 0                                             BUG23280D
     C                   EVAL      WFlg  = *BLANKS                                         BUG23280D
      *                                                                                    BUG23280D
      ** Set a dummy separator different from requesting n/w                               BUG23280D
      *                                                                                    BUG23280D
     C                   IF        EDLSEP = '%%'                                           BUG23280D
     C                   EVAL      Wdummy ='..'                                            BUG23280D
     C                   ELSE                                                              BUG23280D
     C                   EVAL      Wdummy ='%%'                                            BUG23280D
     C                   ENDIF                                                             BUG23280D
      *                                                                                    BUG23280D
      ** Replace all field separators with dummy line separator                            BUG23280D
      ** from system value MT94xFldTags                                                     BUG26814
      *                                                                                    BUG23280D
     C                   EVAL      WSysPos  = 1                                             BUG26814
     C                   DOU       WSysPos  > 200                                           BUG26814
     C                   EVAL      WSysVal  = %SUBST(PSVal1:WSysPos:2)                      BUG26814
     C                   IF        WSysVal  = *BLANKS                                       BUG26814
     C                   LEAVE                                                              BUG26814
     C                   ENDIF                                                              BUG26814
     C**********         IF        (EDF86F = 'STRCT' AND N_EDF86F = 'STRCT')      BUG26814 BUG26814A
     C                   IF        (EDF86F = 'STRCT' AND N_EDF86F = 'STRCT'                BUG26814A
     C                             AND PNwrk <> 'PAPER')                                   BUG26814A
     C                             OR WSysVal >= '20'                                       BUG26814
     C                   MOVE      WSysVal       WVal                                       BUG26814
     C                   EXSR      SrSetNar                                                 BUG26814
     C                   ENDIF                                                              BUG26814
     C                   EVAL      WSysPos += 2                                             BUG26814
     C                   ENDDO                                                              BUG26814
                                                                                            BUG26814
     C**********         MOVE      '20'          WVal                             BUG23280D BUG26814
     C**********         EXSR      SrSetNar                                       BUG23280D BUG26814
      *                                                                                    BUG23280D
     C**********         MOVE      '21'          WVal                             BUG23280D BUG26814
     C**********         EXSR      SrSetNar                                       BUG23280D BUG26814
      *                                                                                    BUG23280D
     C**********         MOVE      '22'          WVal                             BUG23280D BUG26814
     C**********         EXSR      SrSetNar                                       BUG23280D BUG26814
      *                                                                                    BUG23280D
     C**********         MOVE      '23'          WVal                             BUG23280D BUG26814
     C**********         EXSR      SrSetNar                                       BUG23280D BUG26814
      *                                                                                    BUG23280D
     C**********         MOVE      '24'          WVal                             BUG23280D BUG26814
     C**********         EXSR      SrSetNar                                       BUG23280D BUG26814
      *                                                                                    BUG23280D
     C**********         MOVE      '25'          WVal                             BUG23280D BUG26814
     C**********         EXSR      SrSetNar                                       BUG23280D BUG26814
      *                                                                                    BUG23280D
     C**********         MOVE      '26'          WVal                             BUG23280D BUG26814
     C**********         EXSR      SrSetNar                                       BUG23280D BUG26814
      *                                                                                    BUG23280D
     C**********         MOVE      '27'          WVal                             BUG23280D BUG26814
     C**********         EXSR      SrSetNar                                       BUG23280D BUG26814
      *                                                                                    BUG23280D
     C**********         MOVE      '28'          WVal                             BUG23280D BUG26814
     C**********         EXSR      SrSetNar                                       BUG23280D BUG26814
      *                                                                                    BUG23280D
     C**********         MOVE      '29'          WVal                             BUG23280D BUG26814
     C**********         EXSR      SrSetNar                                       BUG23280D BUG26814
      *                                                                                    BUG23280D
     C**********         MOVE      '60'          WVal                             BUG23280D BUG26814
     C**********         EXSR      SrSetNar                                       BUG23280D BUG26814
      *                                                                                    BUG23280D
     C**********         MOVE      '61'          WVal                             BUG23280D BUG26814
     C**********         EXSR      SrSetNar                                       BUG23280D BUG26814
      *                                                                                    BUG23280D
     C**********         MOVE      '62'          WVal                             BUG23280D BUG26814
     C**********         EXSR      SrSetNar                                       BUG23280D BUG26814
      *                                                                                    BUG23280D
     C**********         MOVE      '63'          WVal                             BUG23280D BUG26814
     C**********         EXSR      SrSetNar                                       BUG23280D BUG26814
      *                                                                                    BUG23280D
     C**********         MOVE      '64'          WVal                             BUG23280D BUG26814
     C**********         EXSR      SrSetNar                                       BUG23280D BUG26814
      *                                                                                    BUG23280D
     C**********         MOVE      '65'          WVal                             BUG23280D BUG26814
     C**********         EXSR      SrSetNar                                       BUG23280D BUG26814
     C                                                                                     BUG23280D
     C                   ENDSR                                                             BUG23280D
      *****************************************************************                    BUG23280D
      /EJECT                                                                               BUG23280D
      *****************************************************************                    BUG23280D
      *                                                               *                    BUG23280D
      *  SrSetNar - Extract narratives and merge with Dummy separator *                    BUG23280D
      *                                                               *                    BUG23280D
      *  Called by : Main                                             *                    BUG23280D
      *                                                               *                    BUG23280D
      *  Calls : None                                                 *                    BUG23280D
      *                                                               *                    BUG23280D
      *****************************************************************                    BUG23280D
     C     SrSetNar      BEGSR                                                             BUG23280D
      *                                                                                    BUG23280D
     C                   IF        WFlg = 'Y'                                              BUG23280D
     C                   LEAVESR                                                           BUG23280D
     C                   ENDIF                                                             BUG23280D
      *                                                                                    BUG23280D
     C                   EVAL      WExtStr = *BLANKS                                       BUG23280D
     C                   EVAL      WPsFld = %SCAN(WVal: Wnarr)                             BUG23280D
      *                                                                                    BUG23280D
     C                   IF        WPsFld > *ZEROS                                         BUG23280D
     C                   MOVEL     N_EDFSEP      WVal1                                      BUG26853
     C                   EVAL      WSysPos1 = WSysPos                                       BUG26853
      * Loop Until we can get the next Subfield on the narrative                            BUG26853
     C                   DOU       WSysPos1 > 200                                           BUG26853
     C                             OR WPsFld1 > *ZERO                                       BUG26853
     C                   EVAL      WSysVal = %SUBST(PSVal1:WSysPos1:2)                      BUG26853
     C                   IF        WSysVal = *BLANKS                                        BUG26853
     C                   LEAVE                                                              BUG26853
     C                   ENDIF                                                              BUG26853
     C                   MOVE      WSysVal       WVal1                                      BUG26853
     C                   EVAL      WPsFld1= %SCAN(WVal1:Wnarr:WPsFld + 1)                   BUG26853
     C                   EVAL      WSysPos1 += 2                                            BUG26853
     C                   ENDDO                                                              BUG26853
      *                                                                                     BUG26853
     C**********         EVAL      WPsFld1= %SCAN(N_EDFSEP:Wnarr:WPsFld + 1)      BUG23280D BUG26853
      *                                                                                    BUG23280D
     C                   IF        WPsFld1 = *ZEROS                                        BUG23280D
     C                   EVAL      WPsFld1 = %LEN(%TRIM(WNarr)) + 1                        BUG23280D
     C                   EVAL      WFlg = 'Y'                                              BUG23280D
     C                   ENDIF                                                             BUG23280D
      *                                                                                    BUG23280D
     C                   EVAL      WExtStr = %SUBST(WNarr : WPsFld + 3:                    BUG23280D
     C                                       WPsFld1-(WPsFld + 3))                         BUG23280D
     C                   IF        WNarrTmp = *BLANKS                                      BUG23280D
     C                                                                                     BUG23280D
     C                   EVAL      WNarrTmp = %TRIM(WExtStr)                               BUG23280D
     C                   ELSE                                                              BUG23280D
     C                   EVAL      WNarrTmp = %TRIM(WNarrTmp)+WDummy+                      BUG23280D
     C                                      %TRIM(WExtStr)                                 BUG23280D
     C                   ENDIF                                                             BUG23280D
      *                                                                                    BUG23280D
     C                   ENDIF                                                             BUG23280D
      *                                                                                    BUG23280D
     C                   ENDSR                                                             BUG23280D
      *****************************************************************                     AR864881
      /EJECT                                                                                AR864881
      *****************************************************************                     AR864881
      *                                                               *                     AR864881
      *  SrFmtDta - Format data                                       *                     AR864881
      *                                                               *                     AR864881
      *  Called by : Main                                             *                     AR864881
      *                                                               *                     AR864881
      *  Calls : None                                                 *                     AR864881
      *                                                               *                     AR864881
      *****************************************************************                     AR864881
     C     SrFmtDta      BEGSR                                                              AR864881
                                                                                            AR864881
     C**********         IF        WEND = 'N'                                     AR864881 AR877174A
     C**********         EVAL      WPsFld = %SCAN(WVal:WExtNarr)                  AR864881 AR877174A
     C**********         IF        WPsFld > 0                                     AR864881 AR877174A
     C**********         EVAL      WPsFld1 = %SCAN('?':WExtNarr:                  AR864881 AR877174A
     C**********                             WPsFld+3)                            AR864881 AR877174A
     C**********         IF        WPsFld1 = 0                                    AR864881 AR877174A
     C**********         EVAL      WPsFld1 = %SCAN(' ':WExtNarr:                   AR864881 AR876305
     C**********                             WPsFld+3)                             AR864881 AR876305
     C**********         EVAL      WPsFld1 = %SCAN('   ':                         AR876305 AR877174A
     C**********                             WExtNarr:WPsFld+3)                   AR876305 AR877174A
     C**********         IF        WPsFld1 = 0                                    AR877174 AR877174A
     C**********         EVAL      WPsFld1 = 391                                  AR877174 AR877174A
     C**********         ENDIF                                                    AR877174 AR877174A
     C**********         EVAL      WEND = 'Y'                                     AR864881 AR877174A
     C**********         ENDIF                                                    AR864881 AR877174A
     C**********         EVAL      ArrExt2(WLn) = %SUBST(WExtNarr:                AR864881 AR877174A
     C**********                                  WPsFld+3:                       AR864881 AR877174A
     C**********                                  WPsFld1-(WPsFld+3))             AR864881 AR877174A
     C**********         EVAL      WLn = WLn + 1                                  AR864881 AR877174A
     C**********         ENDIF                                                    AR864881 AR877174A
     C**********         ENDIF                                                    AR864881 AR877174A
     C                   EVAL      Wnum2 = 1                                               AR877174A
     C                   DOU       WEND = 'Y'                                              AR877174A
     C                   EVAL      WPsFld = %SCAN('?':WExtNarr:                            AR877174A
     C                                      Wnum2)                                         AR877174A
                                                                                           AR877174A
     C                   IF        WPsFld > 0                                              AR877174A
     C                   EVAL      Wchar2 = %SUBST(WExtNarr:                               AR877174A
     C                                             WPsFld+1:2)                             AR877174A
     C                   EVAL      Wfound = 'N'                                            AR877174A
                                                                                           AR877174A
     C     Wchar2        LOOKUP    ArrFld86                               50               AR877174A
     C                   IF        *IN50 = *ON                                             AR877174A
     C                   EVAL      Wfound = 'Y'                                            AR877174A
     C                   ENDIF                                                             AR877174A
                                                                                           AR877174A
     C                   IF        Wfound = 'Y'                                            AR877174A
     C                   EVAL      WPsFld1 = %SCAN('?':WExtNarr:                           AR877174A
     C                                       WPsFld+1)                                     AR877174A
     C                   IF        WPsFld1 = 0                                             AR877174A
     C                   EVAL      WPsFld1 = 391                                           AR877174A
     C                   EVAL      WEND = 'Y'                                              AR877174A
     C                   ENDIF                                                             AR877174A
                                                                                           AR877174A
     C                   EVAL      ArrExt2(WLn) = %SUBST(WExtNarr:                         AR877174A
     C                                            WPsFld+3:                                AR877174A
     C                                            WPsFld1-(WPsFld+3))                      AR877174A
     C                   EVAL      WLn = WLn + 1                                           AR877174A
     C                   ENDIF                                                             AR877174A
                                                                                           AR877174A
     C                   IF        Wfound = 'N'                                            AR877174A
     C                   EVAL      Wnum2 = WPsFld + 1                                      AR877174A
     C                   ELSE                                                              AR877174A
     C                   EVAL      Wnum2 = WPsFld1                                         AR877174A
     C                   ENDIF                                                             AR877174A
                                                                                           AR877174A
     C                   ELSE                                                              AR877174A
                                                                                           AR877174A
     C                   EVAL      WEND = 'Y'                                              AR877174A
     C                   ENDIF                                                             AR877174A
                                                                                           AR877174A
     C                   ENDDO                                                             AR877174A
                                                                                            AR864881
     C                   ENDSR                                                              AR864881
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  *INZSR - Initialisation Subroutine                           *
      *                                                               *
      *****************************************************************
     C     *INZSR        BEGSR
      *
      ** Begin Parameter List
      *
     C     *ENTRY        PLIST
      *
      ** Return Code
      *
     C                   PARM                    PRtcd
      *
      ** Option
      *
     C                   PARM                    POptn
      *
      ** Network
      *
     C                   PARM                    PNwrk
      *
      ** Message Type
      *
     C                   PARM                    PMsgTyp
      *
      ** Branch code
      *
     C                   PARM                    PBrca
      *
      ** Customer Number
      *
     C                   PARM                    PCNum
      *
      ** Currency
      *
     C                   PARM                    PCcy
      *
      ** Account Number
      *
     C                   PARM                    PAccd
      *
      ** Account sequence
      *
     C                   PARM                    PAcsq
      *
      ** Debit/Credit Indicator
      *
     C                   PARM                    PDCInd
      *
      ** Transaction Type
      *
     C                   PARM                    PTranTp
      *
      ** Extended Narratives of length 6 * 65
      *
     C                   PARM                    PNarr1
     C                   PARM                    PNarr2
     C                   PARM                    PNarr3
     C                   PARM                    PNarr4
     C                   PARM                    PNarr5
     C                   PARM                    PNarr6
      *
      ** Narratives format 20 * 70
      *
     C                   PARM                    PFormL1
     C                   PARM                    PFormL2
     C                   PARM                    PFormL3
     C                   PARM                    PFormL4
     C                   PARM                    PFormL5
     C                   PARM                    PFormL6
     C                   PARM                    PFormL7
     C                   PARM                    PFormL8
     C                   PARM                    PFormL9
     C                   PARM                    PFormL10
     C                   PARM                    PFormL11
     C                   PARM                    PFormL12
     C                   PARM                    PFormL13
     C                   PARM                    PFormL14
     C                   PARM                    PFormL15
     C                   PARM                    PFormL16
     C                   PARM                    PFormL17
     C                   PARM                    PFormL18
     C                   PARM                    PFormL19
     C                   PARM                    PFormL20
      *
     C                   PARM                    Idx
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
     C                   PARM                    WFldNmXAr
     C                   PARM                    WMsgIDXAr
     C                   PARM                    WMsgDtXAr
      *
      ** End Parameter List
      *
      ** KList for file GLNW94L11
      *
     C     KAcct         KLIST
     C                   KFLD                    KBrca
     C                   KFLD                    KCNum
     C                   KFLD                    KCcy
     C                   KFLD                    KAccd
     C                   KFLD                    KAcsq
      *
      ** Initialize arrays
      *
     C                   EVAL      ArrExtNarr = *BLANKS
     C                   EVAL      ArrExtMrg = *BLANKS
     C                   EVAL       PRtcd = *BLANKS                                        BUG23445A
      *
                                                                                            BUG26814
      ** Retrieve system values.                                                            BUG26814
                                                                                            BUG26814
     C                   CALL      'AOSVALR0'                                               BUG26814
     C                   PARM      *BLANKS       PRtcd                                      BUG26814
     C                   PARM      WKeySysVal1   PSValK1                                    BUG26814
     C                   PARM                    PSVal1                                     BUG26814
     C                   PARM                    PSValK2                                    BUG26814
     C                   PARM                    PSVal2                                     BUG26814
     C                   PARM                    PSValK3                                    BUG26814
     C                   PARM                    PSVal3                                     BUG26814
     C                   PARM                    PSValK4                                    BUG26814
     C                   PARM                    PSVal4                                     BUG26814
     C                   PARM                    PSValK5                                    BUG26814
     C                   PARM                    PSVal5                                     BUG26814
     C                   PARM                    PSValK6                                    BUG26814
     C                   PARM                    PSVal6                                     BUG26814
     C                   PARM                    PSValK7                                    BUG26814
     C                   PARM                    PSVal7                                     BUG26814
     C                   PARM                    PSValK8                                    BUG26814
     C                   PARM                    PSVal8                                     BUG26814
     C                   PARM                    PSValK9                                    BUG26814
     C                   PARM                    PSVal9                                     BUG26814
     C                   PARM                    PSValK0                                    BUG26814
     C                   PARM                    PSVal0                                     BUG26814
                                                                                            BUG26814
      ** If the system value is not found then issue a database error.                      BUG26814
                                                                                            BUG26814
     C                   IF        PRtcd    <> *BLANKS                                      BUG26814
     C     *LOCK         IN        LDA                                                      BUG26814
     C                   EVAL      DBFile = 'SDSVALPD'                                      BUG26814
     C                   EVAL      DBase = 002                                              BUG26814
                                                                                            BUG26814
     C                   IF        PSVal1 = '*NRF'                                          BUG26814
     C                   EVAL      DBKey = PSValK1                                          BUG26814
     C                   ENDIF                                                              BUG26814
     C                   ENDIF                                                              BUG26814
                                                                                            BUG26814
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *
      ** The following /COPY sets these values, and also defines LDA
      ** as an external data area
      *
      /COPY ZACPYSRC,PSSR_ILE
      *****************************************************************
** CPY@
(c) Misys International Banking Systems Ltd. 2008
** ArrExtName
ADDI1
ADDI2
ADDI3
ADDI4
ADDI5
ADDI6
** ArrLen
065
130
195
260
325
390
** ArrFld86
20212223242526272829
303132333460616263##
