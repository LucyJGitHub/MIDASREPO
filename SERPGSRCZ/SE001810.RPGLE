     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2001')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas SE Settlement Detail for SWIFT')                 *
      *****************************************************************
      *                                                               *
      *  Midas - Securities Trading Module                            *
      *                                                               *
      *  SE001810 - Settlement Detail for SWIFT                       *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2001            *
      *                                                               *
      *  Last Amend No. AR586118           Date 03Aug10               *
      *  Prev Amend No. AR580857           Date 21Jul10               *
      *                 AR325362           Date 26May10               *
      *                 CSW210             Date 04May10               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CSD031             Date 10Apr06               *
      *                 CSW037A            Date 02May05               *
      *                 CSD025             Date 11Jan05               *
      *                 CSW037             Date 15Dec04               *
      *                 CSW036             Date 15Dec04               *
      *                 CLE025             Date 20Oct03               *
      * Midas Release 4.01.02 ----------------------------------------*
      *                 209934             Date 06Nov02               *
      * Midas Release 4.01 -------------------------------------------*
      *                 205141             Date 10May02               *
      *                 199797             Date 01Nov01               *
      * Midas Release 4 --------------- Base -------------------------*
      *                 CSE028  *CREATE    Date 06Jun01               *
      *                                    Date ddmmmyy               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  AR586118 - Place of Clearing, Place of Settlement and QFIN   *
      *           not populated from SEST (Recompile).                *
      *  AR580857 - QFIN label is erroneous (Recompile)               *
      *  AR325362 - Bulk Input Intermediaries 3 - 9 must not          *
      *             appear                                            *
      *  CSW210 - SWIFT 2010 Changes                                  *
      *  CSD031 - Enhanced Centralised Static Data (Recompile)        *
      *  CSW037A- Additional Field extended to 40 chars (recompile)   *
      *  CSD025 - Customer De-Activation                              *
      *  CSW037 - Additional Field Data on MT300/MT320                *
      *  CSW036 - Dual SWIFT BIC held on Client Details               *
      *  CLE025 - Credit Lines (Recompile)                            *
      *  209934 - Intermediary 9 field is independent of Intermediary *
      *           8 field                                             *
      *  205141 - Intermediaries to be converted to SWIFT ID.         *
      *  199797 - Additional changes and fixes for CSE028 (SSIs).     *
      *  CSE028 - Standing Settlement Instructions Enhancement.       *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  Use of indicators.                                           *
      *                                                               *
      *    20         Error on settlement party 1                     *
      *    21         Error on safekeeping account 1                  *
      *    22         Error on settlement party 2                     *
      *    23         Error on safekeeping account 2                  *
      *    24         Error on settlement party 3                     *
      *    25         Error on safekeeping account 3                  *
      *    26         Error on settlement party 4                     *
      *    27         Error on safekeeping account 4                  *
      *    28         Error on settlement party 5                     *
      *    29         Error on safekeeping account 5                  *
      *    30         Error on settlement party 6                     *
      *    31         Error on safekeeping account 6                  *
      *    32         Error on settlement party 7                     *
      *    33         Error on safekeeping account 7                  *
      *    34         Error on settlement party 8                     *
      *    35         Error on safekeeping account 8                  *
      *    36         Error on settlement party 9                     *
      *    37         Error on safekeeping account 9                  *
      *    38         Error on place of settlement                    *
      *****39*********Error*on*narrative*for*cash*parties*line*1*******                       CSW210
      *****40*********Error*on*narrative*for*cash*parties*line*2*******                       CSW210
      *    39         Error on registration details 1                 *                       CSW210
      *    40         Error on registration details 2                 *                       CSW210
      *    41         Error on place of clearing                      *                       CSW210
      *    42         Error on qualified foreign institution          *                       CSW210
      *    43         Error on investor                               *                       CSW210
      *    34         Error on narrative for cash parties line 1      *                       CSW210
      *    45         Error on narrative for cash parties line 2      *                       CSW210
      *                                                               *
      *    70         Protect/Underline Indicator                     *
      *    75         Rolldown Indicator                              *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  S U B R O U T I N E  I N D E X                               *
      *                                                               *
      *  SRMain       -  Program Main Processing                      *
      *  SRInit       -  Initial Processing                           *
      *  SRRetry      -  Refresh Screen                               *
      *  SRDisplay    -  Display Screen Details                       *
      *  SRValidate   -  Validate Screen Details                      *
      *  SRINTM       -  Validate Intermediary Fields                 *
      *  SRSAFE       -  Validate Safekeeping Account Fields          *
      *  SRPSET       -  Validate Place of Settlement                 *
      *  SRNAC1       -  Validate Narrative for Cash Parties 1        *
      *  SRNAC2       -  Validate Narrative for Cash Parties 2        *
      *  SRCUST       -  Check Intermediary Field                     *
      *  SRRED1       -  Validate Registration Details 1              *                       CSW210
      *  SRRED2       -  Validate Registration Details 2              *                       CSW210
      *  SRPCLR       -  Validate Place of Clearing                   *                       CSW210
      *  SRQFIN       -  Validate Qualified Foreign Intermediary      *                       CSW210
      *  SRINVE       -  Validate Investor                            *                       CSW210
      *  SRCUST2      -  Validate Customer Number/Shortname/Nostro    *                       CSW210
      *  SRUpdate     -  Update Additional Standard Settlement        *
      *                  Instructions                                 *
      *  SRReturn     -  Return to Calling Program                    *
      *                                                               *
      *  *PSSR - Error processing                                     *
      *  *INZSR - Initialise                                          *
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
 
     FSESWFPDF  CF   E             WORKSTN INFSR(*PSSR)
 
      ** Table of field numbers and names
     FZAFLDNPD  IT   F   15        DISK    INFSR(*PSSR)
 
      *****************************************************************
      /EJECT
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ Automatically included D-specs       ¦
      ** ¦ ==============================       ¦
      ** +--------------------------------------+
 
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
 
      ** Program Status Data Structure
      ** =============================
      ** The following /COPY line includes all the defined fields in the
      ** PSDS.  They have meaningful names, prefixed by 'PS'.
 
     D/COPY ZACPYSRC,PSDS
 
      ** The following /COPY line includes the definitions for error and
      ** warning message arrays.
 
     D/COPY ZACPYSRC,ERR_ARRAYS
 
      ** The following /COPY includes the MM standard declares:
 
     D/COPY ZACPYSRC,STDDECLARE
 
      ** The following /COPY line includes the definitions for fields
      ** required by the message handler.
 
     D/COPY ZACPYSRC,MSGHNDDCL
 
      ** The following /COPY line declares the arrays for processing that
      ** take place in the *CTL modules.
 
     D/COPY ZACPYSRC,APICTLARR
 
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
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
 
     D*@EI******       S              1    DIM(25)                                            CSW210
     D*@Z0******       S              1    DIM(25) CTDATA PERRCD(25)                          CSW210
     D @EI             S              1    DIM(30)                                            CSW210
     D @Z0             S              1    DIM(30) CTDATA PERRCD(30)                          CSW210
     D @IM             S             12    DIM(9)
     D @SA             S             20    DIM(9)
     D WIMDArr         S             12    DIM(9)
 
      ** DS for Validation of Intermediary
 
     D WInterMEd       DS
     D #0IMMD1                 1     12
     D #0IMMD2                13     24
     D #0IMMD3                25     36
     D #0IMMD4                37     48
     D #0IMMD5                49     60
     D #0IMMD6                61     72
     D #0IMMD7                73     84
     D #0IMMD8                85     96
     D #0IMMD9                97    108
 
      ** DS for Validation of Safekeeping Account
 
     D WSafeAcct       DS
     D #0IMSA1                 1     20
     D #0IMSA2                21     40
     D #0IMSA3                41     60
     D #0IMSA4                61     80
     D #0IMSA5                81    100
     D #0IMSA6               101    120
     D #0IMSA7               121    140
     D #0IMSA8               141    160
     D #0IMSA9               161    180
 
      ** DS for Entry Parameter of Intermediary
 
     D PInterMed       DS
     D PIMMD1                  1     12
     D PIMMD2                 13     24
     D PIMMD3                 25     36
     D PIMMD4                 37     48
     D PIMMD5                 49     60
     D PIMMD6                 61     72
     D PIMMD7                 73     84
     D PIMMD8                 85     96
     D PIMMD9                 97    108
 
      ** DS for Entry Parameter of Safekeeping Account
 
     D PSafeAcct       DS
     D PIMSA1                  1     20
     D PIMSA2                 21     40
     D PIMSA3                 41     60
     D PIMSA4                 61     80
     D PIMSA5                 81    100
     D PIMSA6                101    120
     D PIMSA7                121    140
     D PIMSA8                141    160
     D PIMSA9                161    180
 
      ** DS for Narrative for Cash Parties
 
     D PNarrCash       DS
     D PNarrCash1              1     35
     D PNarrCash2             36     70
 
      ** DS for Error Flags - Intermediary
 
     D OkSCRN          DS
     D OkIMD1                  1      1
     D OkIMS1                  2      2
     D OkIMD2                  3      3
     D OkIMS2                  4      4
     D OkIMD3                  5      5
     D OkIMS3                  6      6
     D OkIMD4                  7      7
     D OkIMS4                  8      8
     D OkIMD5                  9      9
     D OkIMS5                 10     10
     D OkIMD6                 11     11
     D OkIMS6                 12     12
     D OkIMD7                 13     13
     D OkIMS7                 14     14
     D OkIMD8                 15     15
     D OkIMS8                 16     16
     D OkIMD9                 17     17
     D OkIMS9                 18     18
     D OkPSET                 19     19
     D*OkNAC1***              20     20                                                       CSW210
     D*OkNAC2***              21     21                                                       CSW210
     D OkRED1                 20     21                                                       CSW210
     D OkRED2                 21     21                                                       CSW210
     D OkPLCR                 22     22                                                       CSW210
     D OkQFIN                 23     23                                                       CSW210
     D OkINVE                 24     24                                                       CSW210
     D OkNAC1                 25     25                                                       CSW210
     D OkNAC2                 26     26                                                       CSW210
 
     D PRegDetail      DS                                                                     CSW210
     D PRegDet1                1     35                                                       CSW210
     D PRegDet2               36     70                                                       CSW210
                                                                                              CSW210
      ** Bank details
 
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
 
      ** Customer details
 
     D SDCUST        E DS                  EXTNAME(SDCUSTPD)
 
      ** BIC Directory
 
     D MEBICD        E DS                  EXTNAME(MEBICDPD)
 
      ** Counterparty Details
 
     DSDCNST         E DS                  EXTNAME(SDCNSTPD)
                                                                                            AR325362
      ** Switchable Feature                                                                 AR325362
                                                                                            AR325362
     DSCSARD         E DS                  EXTNAME(SCSARDPD)                                AR325362
 
      ** First Data Structure for Access Objects
 
     D DSFDY         E DS                  EXTNAME(DSFDY)
 
      ** Second Data Structure for Access Objects
 
     D DSSDY         E DS                  EXTNAME(DSSDY)
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
      ** Entry Parameters
 
     DPActn            S              1A
     DPPlaceSet        S             12A
     DPInvestor        S             10A                                                      CSW210
     DPQualiFin        S             10A                                                      CSW210
     DPPlaceClr        S             10A                                                      CSW210
 
      ** Parameters for SDCUSTPD
 
     DPKEY1            S             10A
     DPKYST            S              7A
 
      ** Variable used for validation
 
     DIdx              S              3P 0
     DWFldNum          S              1A
     DWCLAS            S              1A
     DWERROR           S              1A
     DWFIELD           S              7A
     DWWLI02           S              2A
     DWWLI19           S             19A
     DWWLI33           S             33A
     DWWLI34           S             34A
     DWWNAL1           S              1A
     DWWNAL2           S              1A
     DWWSKAL           S              1A
 
      ** Parameters for ME1400
 
     DPBICR            S              7A
     DPCSID8           S              8A
     DPCSID4           S              4A
     DPCSID3           S              3A
     DPBICC            S              1A
     DPBICS            S              1A
     DPBICI            S              1A
 
     DPMode            S              1A
 
     DWCtr             S              3P 0
     DWIMFlg           S              1A
     DWUnqeFlg         S              1A
     DWWIMMD           S             12A
     DJFIMMD           S             12A                                                      205141
     DWPInterMed       S            108A
     DWPPSET           S             12A
     DWWLI01           S              1A                                                      CSW210
     DWWCUSS           S              1A                                                      CSW210
     DWWNOST           S              8A                                                      CSW210
     DWWINVE           S             10A                                                      CSW210
     DWWCUST           S             10A                                                      CSW210
     DWWPCLR           S             10A                                                      CSW210
     DWWQFIN           S             10A                                                      CSW210
     DPKEY2            S              8A                                                      CSW210
     DCSW210           S              1A                                                      CSW210
     D WWCABA          S                   LIKE(BBCABA)                                       CSW210
     D WWCSID          S                   LIKE(BBCSID)                                       CSW210
     D WWBLCD          S                   LIKE(BBBLCD)                                       CSW210
     D WWFWCD          S                   LIKE(BBFWCD)                                       CSW210
     D WWCHID          S                   LIKE(BBCHID)                                       CSW210
     D WWCHSC          S                   LIKE(BBCHSC)                                       CSW210
     D WWBNBI          S                   LIKE(BBBNBI)                                       CSW210
 
      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
 
      *****************************************************************
      /EJECT
      *****************************************************************
 
      ** +--- Start of Main processing -----------------------------------+
      ** ¦                                                                ¦
      ** ¦ *INZSR is executed at program activation.                      ¦
      ** ¦                                                                ¦
      ** +----------------------------------------------------------------+
 
     C                   EXSR      SRMAIN
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRMAIN - Program Main Processing                              *
      *                                                               *
      * Called by: Main Processing                                    *
      *                                                               *
      * Calls: SRINIT    - Initial Processing                         *
      *        SRDISPLAY - Display Screen Details                     *
      *        SRUPDATE  - Update Add'l Standard Settlement Ins.      *
      *        SRRETURN  - Return to Calling Program                  *
      *                                                               *
      *****************************************************************
 
     C     SRMAIN        BEGSR
 
     C                   EXSR      SRINIT
     C                   EXSR      SRMOVE
 
     C                   DOW       PMode = 'S'
     C                   EXSR      SRDISPLAY
     C                   ENDDO
 
     C                   IF        PMode = 'U'
     C                   EXSR      SRUPDATE
     C                   ENDIF
 
     C                   IF        PMode = 'R'
     C                   EXSR      SRRETURN
     C                   ENDIF
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRINIT - Initial Processing                                   *
      *                                                               *
      * Called by: SRMAIN - Program Main Processing                   *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
 
     C     SRINIT        BEGSR
 
     C                   EVAL      PMode = 'S'
 
     C                   IF        PActn = 'E' or PActn = 'D'
     C                   EVAL      *IN70 = *ON
     C                   ELSE
     C                   EVAL      *IN70 = *OFF
     C                   ENDIF
 
     C                   EVAL      WPInterMed = *BLANKS
     C                   EVAL      WPPSET = *BLANKS
                                                                                              CSW210
      ** Call SWIF2010 to check if CSW210 is switched on                                      CSW210
                                                                                              CSW210
     C                   CALL      'SWIF2010'                           7373                  CSW210
     C                   PARM      *BLANKS       @RTCD                                        CSW210
      *                                                                                       CSW210
     C                   IF        *IN73 = *ON                                                CSW210
     C                   MOVEL     'SDBANKPD'    DBFILE                                       CSW210
     C                   MOVEL     '002'         DBASE                                        CSW210
     C                   MOVEL     '*CALL'       DBKEY                                        CSW210
     C                   EXSR      *PSSR                                                      CSW210
     C                   ELSE                                                                 CSW210
      *                                                                                       CSW210
     C                   IF        @RTCD = 'CSW2010'                                          CSW210
     C                   EVAL      *IN72 = *ON                                                CSW210
     C                   MOVE      'Y'           CSW210                                       CSW210
     C                   ELSE                                                                 CSW210
     C                   MOVE      'N'           CSW210                                       CSW210
     C                   EVAL      *IN72 = *OFF                                               CSW210
     C                   ENDIF                                                                CSW210
     C                   ENDIF                                                                CSW210
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRDISPLAY - Display Screen Details                            *
      *                                                               *
      * Called by: SRMAIN - Program Main Processing                   *
      *                                                               *
      * Calls: SRVALIDATE - Validate Screen Details                   *
      *                                                               *
      *****************************************************************
 
     C     SRDISPLAY     BEGSR
 
     C                   MOVEA     OKSCRN        @EI
 
      ** Set screen error indicators according to status of 'OK' flags
 
     C                   Z-ADD     1             C                 2 0
     C                   Z-ADD     20            E                 2 0
 
     C*****C****         DOUGT     22                                                         CSW210
     C     C             DOUGT     27                                                         CSW210
 
     C     @EI(C)        IFEQ      'N'
     C     @EI(C)        OREQ      'W'
     C                   MOVEL     '1'           *IN(E)
     C                   ENDIF
 
     C                   ADD       1             C
     C                   ADD       1             E
 
     C                   ENDDO
 
      ** The following /COPY line includes processing for the error and
      ** warning messages.
 
     C/COPY ZACPYSRC,MSGHNDDSP1
 
     C                   WRITE     SESWFPS0
     C                   EXFMT     SESWFPF0
 
      ** Clear messages from screen message subfile
 
     C                   CALL      'ZA0250'
 
      ** Set screen error indicators off
 
     C                   EVAL      Idx = 0
     C                   MOVEA     @Z0           *IN(20)
     C                   MOVE      *BLANKS       OkSCRN
 
     C                   CLEAR                   MsgIdArr
     C                   CLEAR                   FldNameArr
     C                   CLEAR                   WMsgIdArr
 
     C                   SELECT
 
     C                   WHEN      *INKC = *ON
     C                   EVAL      RetCodeOut = 'SE10000'
     C                   EVAL      PMode = 'R'
 
     C                   WHEN      *INKE = *ON
     C                   EXSR      SRRETRY
     C                   EVAL      PMode = 'S'
 
     C                   WHEN      *INKL = *ON
     C                   EVAL      RetCodeOut = 'SE10001'
     C                   EVAL      PMode = 'R'
 
     C                   WHEN      *IN75 = *ON
     C                   EVAL      RetCodeOut = 'SE10029'
     C                   IF        PActn <> 'E'                                               CSW210
     C                   EXSR      SRVALIDATE
     C                   ELSE                                                                 CSW210
     C                   EVAL      PMode = 'R'                                                CSW210
     C                   ENDIF                                                                CSW210
 
     C                   OTHER
     C                   EXSR      SRVALIDATE
 
     C                   ENDSL
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRVALIDATE - Validate Screen Details                          *
      *                                                               *
      * Called by: SRDISPLAY - Display Screen Details                 *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
 
     C     SRVALIDATE    BEGSR
 
      ** Perform validation
 
     C                   EXSR      SRINTM
     C                   EXSR      SRSAFE
     C                   EXSR      SRPSET
     C                   EXSR      SRRED1                                                     CSW210
     C                   EXSR      SRRED2                                                     CSW210
     C                   IF        CSW210 = 'Y'                                               CSW210
     C                   EXSR      SRPCLR                                                     CSW210
     C                   EXSR      SRQFIN                                                     CSW210
     C                   ENDIF                                                                CSW210
     C                   EXSR      SRINVE                                                     CSW210
     C**********         EXSR      SRNAC1                                                     199797
     C**********         EXSR      SRNAC2                                                     199797
 
      ** If no errors found, update file else redisplay screen
 
     C                   IF        Idx = 0  AND
     C                             WInterMed = WPInterMed AND
     C                             #0PSET = WPPSET
     C                   EVAL      PMode = 'U'
     C                   ELSE
     C                   EVAL      PMode = 'S'
     C                   ENDIF
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRINTM - Validate Intermediary Fields                         *
      *                                                               *
      * Called by: SRDISPLAY - Display Screen Details                 *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
 
     C     SRINTM        BEGSR
 
     C                   EVAL      WERROR = 'N'
     C                   EVAL      WImFlg = 'Y'
     C                   CLEAR                   WIMDArr
 
      ** Previous Intermediary field should not be blank
 
     C                   IF        #0IMMD1 = *BLANKS and #0IMMD2 <> *BLANKS
     C                   EVAL      OkIMD1 = 'N'
     C                   EVAL      Idx = Idx + 1
     C                   EVAL      MsgIdArr(Idx) = 'SE10025'
     C                   EVAL      FldNameArr(Idx) = '#0IMMD1'
     C                   EVAL      WERROR = 'Y'
     C                   ENDIF
 
     C                   IF        #0IMMD2 = *BLANKS and #0IMMD3 <> *BLANKS and
     C                             WERROR <> 'Y'
     C                   EVAL      OkIMD2 = 'N'
     C                   EVAL      Idx = Idx + 1
     C                   EVAL      MsgIdArr(Idx) = 'SE10024'
     C                   EVAL      FldNameArr(Idx) = '#0IMMD2'
     C                   EVAL      WERROR = 'Y'
     C                   ENDIF
 
     C                   IF        #0IMMD3 = *BLANKS and #0IMMD4 <> *BLANKS and
     C                             WERROR <> 'Y'
     C                   EVAL      OkIMD3 = 'N'
     C                   EVAL      Idx = Idx + 1
     C                   EVAL      MsgIdArr(Idx) = 'SE10023'
     C                   EVAL      FldNameArr(Idx) = '#0IMMD3'
     C                   EVAL      WERROR = 'Y'
     C                   ENDIF
 
     C                   IF        #0IMMD4 = *BLANKS and #0IMMD5 <> *BLANKS and
     C                             WERROR <> 'Y'
     C                   EVAL      OkIMD4 = 'N'
     C                   EVAL      Idx = Idx + 1
     C                   EVAL      MsgIdArr(Idx) = 'SE10022'
     C                   EVAL      FldNameArr(Idx) = '#0IMMD4'
     C                   EVAL      WERROR = 'Y'
     C                   ENDIF
 
     C                   IF        #0IMMD5 = *BLANKS and #0IMMD6 <> *BLANKS and
     C                             WERROR <> 'Y'
     C                   EVAL      OkIMD5 = 'N'
     C                   EVAL      Idx = Idx + 1
     C                   EVAL      MsgIdArr(Idx) = 'SE10021'
     C                   EVAL      FldNameArr(Idx) = '#0IMMD5'
     C                   EVAL      WERROR = 'Y'
     C                   ENDIF
 
     C                   IF        #0IMMD6 = *BLANKS and #0IMMD7 <> *BLANKS and
     C                             WERROR <> 'Y'
     C                   EVAL      OkIMD6 = 'N'
     C                   EVAL      Idx = Idx + 1
     C                   EVAL      MsgIdArr(Idx) = 'SE10020'
     C                   EVAL      FldNameArr(Idx) = '#0IMMD6'
     C                   EVAL      WERROR = 'Y'
     C                   ENDIF
 
     C                   IF        #0IMMD7 = *BLANKS and #0IMMD8 <> *BLANKS and
     C                             WERROR <> 'Y'
     C                   EVAL      OkIMD7 = 'N'
     C                   EVAL      Idx = Idx + 1
     C                   EVAL      MsgIdArr(Idx) = 'SE10019'
     C                   EVAL      FldNameArr(Idx) = '#0IMMD7'
     C                   EVAL      WERROR = 'Y'
     C                   ENDIF
 
     C**********         IF        #0IMMD8 = *BLANKS and #0IMMD9 <> *BLANKS and               209934
     C**********                   WERROR <> 'Y'                                              209934
     C**********         EVAL      OkIMD8 = 'N'                                               209934
     C**********         EVAL      Idx = Idx + 1                                              209934
     C**********         EVAL      MsgIdArr(Idx) = 'SE10018'                                  209934
     C**********         EVAL      FldNameArr(Idx) = '#0IMMD8'                                209934
     C**********         EVAL      WERROR = 'Y'                                               209934
     C**********         ENDIF                                                                209934
 
      ** Check if Intermediary is valid customer or BIC code
 
     C                   IF        WERROR = 'N'
 
     C                   MOVEA     WInterMed     @IM
     C                   EVAL      WPInterMed = WInterMed
     C                   Z-ADD     1             X                 2 0
     C                   Z-ADD     1             C
 
     C                   DOW       X < 10
 
     C                   IF        @IM(X) <> *BLANKS
 
     C                   EVAL      WWIMMD = @IM(X)
     C                   EXSR      SRCUST
     C                   IF        JFIMMD <> *BLANKS                                          205141
     C                   EVAL      WWIMMD = JFIMMD                                            205141
     C                   ENDIF                                                                205141
     C                   EVAL      @IM(X) = WWIMMD
 
     C**********         IF        (@RTCD = 'MIN0244' and WCLAS = 'B') or                     199797
     C**********                   (@RTCD = 'MIN0245' and WCLAS = 'B') or                     199797
     C**********                   (@RTCD = 'MIN0246' and WCLAS = 'B') or                     199797
     C**********                   @RTCD <> *BLANKS or WUNqeFlg = 'Y'                         199797
     C                   IF        (PBICR = 'MIN0246' and WCLAS = 'B') or                     199797
     C                             (@RTCD <> *BLANKS) or (WUnqeFlg = 'Y')                     199797
 
     C                   MOVE      X             WFldNum
     C     '#0IMMD'      CAT       WFldNum       WFIELD
 
      ** Select OK flag to set to 'N'
 
     C                   SELECT
     C                   WHEN      C = 1
     C                   EVAL      OkIMD1 = 'N'
     C                   WHEN      C = 3
     C                   EVAL      OkIMD2 = 'N'
     C                   WHEN      C = 5
     C                   EVAL      OkIMD3 = 'N'
     C                   WHEN      C = 7
     C                   EVAL      OkIMD4 = 'N'
     C                   WHEN      C = 9
     C                   EVAL      OkIMD5 = 'N'
     C                   WHEN      C = 11
     C                   EVAL      OkIMD6 = 'N'
     C                   WHEN      C = 13
     C                   EVAL      OkIMD7 = 'N'
     C                   WHEN      C = 15
     C                   EVAL      OkIMD8 = 'N'
     C                   WHEN      C = 17
     C                   EVAL      OkIMD9 = 'N'
     C                   ENDSL
 
     C                   EVAL      Idx = Idx + 1
     C                   IF        WUnqeFlg = 'Y'
     C                   EVAL      MsgIdArr(Idx) = 'SE10038'
     C                   ELSE
     C                   EVAL      MsgIdArr(Idx) = 'SE10026'
     C                   ENDIF
     C                   EVAL      FldNameArr(Idx) = WFIELD
 
     C                   ENDIF
 
     C                   ENDIF
 
     C                   ADD       2             C
     C                   ADD       1             X
 
     C                   ENDDO
 
     C                   MOVEA     @IM           WInterMed
     C                   ENDIF
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRSAFE - Validate Safekeeping Account Fields                  *
      *                                                               *
      * Called by: SRDISPLAY - Display Screen Details                 *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
 
     C     SRSAFE        BEGSR
 
     C                   EVAL      WERROR = 'N'
 
      ** Corresponding Intermediary field should not be blank
 
     C                   IF        #0IMSA1 <> *BLANKS and #0IMMD1 = *BLANKS
     C                   EVAL      OkIMS1 = 'N'
     C                   EVAL      Idx = Idx + 1
     C                   EVAL      MsgIdArr(Idx) = 'SE10009'
     C                   EVAL      FldNameArr(Idx) = '#0IMSA1'
     C                   EVAL      WERROR = 'Y'
     C                   ENDIF
 
     C                   IF        #0IMSA2 <> *BLANKS and #0IMMD2 = *BLANKS
     C                   EVAL      OkIMS2 = 'N'
     C                   EVAL      Idx = Idx + 1
     C                   EVAL      MsgIdArr(Idx) = 'SE10010'
     C                   EVAL      FldNameArr(Idx) = '#0IMSA2'
     C                   EVAL      WERROR = 'Y'
     C                   ENDIF
 
     C                   IF        #0IMSA3 <> *BLANKS and #0IMMD3 = *BLANKS
     C                   EVAL      OkIMS3 = 'N'
     C                   EVAL      Idx = Idx + 1
     C                   EVAL      MsgIdArr(Idx) = 'SE10011'
     C                   EVAL      FldNameArr(Idx) = '#0IMSA3'
     C                   EVAL      WERROR = 'Y'
     C                   ENDIF
 
     C                   IF        #0IMSA4 <> *BLANKS and #0IMMD4 = *BLANKS
     C                   EVAL      OkIMS4 = 'N'
     C                   EVAL      Idx = Idx + 1
     C                   EVAL      MsgIdArr(Idx) = 'SE10012'
     C                   EVAL      FldNameArr(Idx) = '#0IMSA4'
     C                   EVAL      WERROR = 'Y'
     C                   ENDIF
 
     C                   IF        #0IMSA5 <> *BLANKS and #0IMMD5 = *BLANKS
     C                   EVAL      OkIMS5 = 'N'
     C                   EVAL      Idx = Idx + 1
     C                   EVAL      MsgIdArr(Idx) = 'SE10013'
     C                   EVAL      FldNameArr(Idx) = '#0IMSA5'
     C                   EVAL      WERROR = 'Y'
     C                   ENDIF
 
     C                   IF        #0IMSA6 <> *BLANKS and #0IMMD6 = *BLANKS
     C                   EVAL      OkIMS6 = 'N'
     C                   EVAL      Idx = Idx + 1
     C                   EVAL      MsgIdArr(Idx) = 'SE10014'
     C                   EVAL      FldNameArr(Idx) = '#0IMSA6'
     C                   EVAL      WERROR = 'Y'
     C                   ENDIF
 
     C                   IF        #0IMSA7 <> *BLANKS and #0IMMD7 = *BLANKS
     C                   EVAL      OkIMS7 = 'N'
     C                   EVAL      Idx = Idx + 1
     C                   EVAL      MsgIdArr(Idx) = 'SE10015'
     C                   EVAL      FldNameArr(Idx) = '#0IMSA7'
     C                   EVAL      WERROR = 'Y'
     C                   ENDIF
 
     C                   IF        #0IMSA8 <> *BLANKS and #0IMMD8 = *BLANKS
     C                   EVAL      OkIMS8 = 'N'
     C                   EVAL      Idx = Idx + 1
     C                   EVAL      MsgIdArr(Idx) = 'SE10016'
     C                   EVAL      FldNameArr(Idx) = '#0IMSA8'
     C                   EVAL      WERROR = 'Y'
     C                   ENDIF
 
     C                   IF        #0IMSA9 <> *BLANKS and #0IMMD9 = *BLANKS
     C                   EVAL      OkIMS9 = 'N'
     C                   EVAL      Idx = Idx + 1
     C                   EVAL      MsgIdArr(Idx) = 'SE10017'
     C                   EVAL      FldNameArr(Idx) = '#0IMSA9'
     C                   EVAL      WERROR = 'Y'
     C                   ENDIF
 
     C**********         IF        WERROR = 'N'                                               199797
      **********                                                                              199797
     C**********         MOVEA     WSafeAcct     @SA                                          199797
     C**********         Z-ADD     1             X                                            199797
     C**********         Z-ADD     2             C                                            199797
      **********                                                                              199797
     C**********         DOW       X < 10                                                     199797
      **********                                                                              199797
     C**********         IF        @SA(X) <> *BLANKS                                          199797
      **********                                                                              199797
     C**********         MOVE      X             WFldNum                                      199797
     C**********         MOVEL     @SA(X)        WWSKAL                                       199797
      **********                                                                              199797
     C**********         IF        WWSKAL <> '/'                                              199797
     C**********         EVAL      WERROR = 'Y'                                               199797
     C*****'#0IMSA'      CAT       WFldNum       WFIELD                                       199797
     C**********         EVAL      Idx = Idx + 1                                              199797
     C**********         EVAL      MsgIdArr(Idx) = 'SEW5210'                                  199797
     C**********         EVAL      FldNameArr(Idx) = WFIELD                                   199797
     C**********         ENDIF                                                                199797
      **********                                                                              199797
     C**********         MOVEL     @SA(X)        WWLI02                                       199797
      **********                                                                              199797
     C**********         IF        WWLI02 = '//'                                              199797
     C**********         EVAL      WERROR = 'Y'                                               199797
     C*****'#0IMSA'      CAT       WFldNum       WFIELD                                       199797
     C**********         EVAL      Idx = Idx + 1                                              199797
     C**********         EVAL      MsgIdArr(Idx) = 'SEW5211'                                  199797
     C**********         EVAL      FldNameArr(Idx) = WFIELD                                   199797
     C**********         ENDIF                                                                199797
      **********                                                                              199797
     C**********         MOVE      @SA(X)        WWLI19                                       199797
      **********                                                                              199797
     C**********         IF        WWSKAL = '/' and WWLI19 = *BLANKS                          199797
     C**********         EVAL      WERROR = 'Y'                                               199797
     C*****'#0IMSA'      CAT       WFldNum       WFIELD                                       199797
     C**********         EVAL      Idx = Idx + 1                                              199797
     C**********         EVAL      MsgIdArr(Idx) = 'SEW5212'                                  199797
     C**********         EVAL      FldNameArr(Idx) = WFIELD                                   199797
     C**********         ENDIF                                                                199797
      **********                                                                              199797
      ***Select*OK flag to set to 'N'                                                         199797
      **********                                                                              199797
     C**********         IF        WERROR = 'Y'                                               199797
      **********                                                                              199797
     C**********         SELECT                                                               199797
     C**********         WHEN      C = 2                                                      199797
     C**********         EVAL      OkIMS1 = 'N'                                               199797
     C**********         WHEN      C = 4                                                      199797
     C**********         EVAL      OkIMS2 = 'N'                                               199797
     C**********         WHEN      C = 6                                                      199797
     C**********         EVAL      OkIMS3 = 'N'                                               199797
     C**********         WHEN      C = 8                                                      199797
     C**********         EVAL      OkIMS4 = 'N'                                               199797
     C**********         WHEN      C = 10                                                     199797
     C**********         EVAL      OkIMS5 = 'N'                                               199797
     C**********         WHEN      C = 12                                                     199797
     C**********         EVAL      OkIMS6 = 'N'                                               199797
     C**********         WHEN      C = 14                                                     199797
     C**********         EVAL      OkIMS7 = 'N'                                               199797
     C**********         WHEN      C = 16                                                     199797
     C**********         EVAL      OkIMS8 = 'N'                                               199797
     C**********         WHEN      C = 18                                                     199797
     C**********         EVAL      OkIMS9 = 'N'                                               199797
     C**********         ENDSL                                                                199797
      **********                                                                              199797
     C**********         ENDIF                                                                199797
      **********                                                                              199797
     C**********         ENDIF                                                                199797
      **********                                                                              199797
     C**********         ADD       2             C                                            199797
     C**********         ADD       1             X                                            199797
      **********                                                                              199797
     C**********         ENDDO                                                                199797
      **********                                                                              199797
     C**********         ENDIF                                                                199797
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRPSET - Validate Place of Settlement                         *
      *                                                               *
      * Called by: SRVALIDATE - Validate Screen Details               *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
 
     C     SRPSET        BEGSR
 
     C                   EVAL      WImFlg = 'Y'
     C                   IF        #0PSET <> *BLANKS
 
     C                   EVAL      WWIMMD = #0PSET
     C                   EVAL      WPPSET = #0PSET
     C                   EXSR      SRCUST
     C                   EVAL      #0PSET = WWIMMD
 
     C**********         IF        (@RTCD = 'MIN0244' and WCLAS = 'B') or                     199797
     C**********                   (@RTCD = 'MIN0245' and WCLAS = 'B') or                     199797
     C**********                   (@RTCD = 'MIN0246' and WCLAS = 'B') or                     199797
     C**********                   @RTCD <> *BLANKS                                           199797
     C                   IF        (PBICR = 'MIN0246' and WCLAS = 'B') or                     199797
     C                             (@RTCD <> *BLANKS)                                         199797
 
     C                   EVAL      OkPSET = 'N'
     C                   EVAL      Idx = Idx + 1
     C                   EVAL      MsgIdArr(Idx) = 'SE10031'
     C                   EVAL      FldNameArr(Idx) = #0PSET
 
     C                   ENDIF
 
     C                   ENDIF
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRNAC1 - Validate Narrative for Cash Parties 1                *
      *                                                               *
      * Called by: SRDISPLAY - Display Screen Details                 *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
 
     C     SRNAC1        BEGSR
 
     C                   IF        #0NAC1 <> *BLANKS
 
     C                   MOVEL     #0NAC1        WWNAL1
     C                   MOVE      #0NAC1        WWLI34
 
     C                   IF        WWNAL1 = '/' and WWLI34 = *BLANKS
     C                   EVAL      OkNAC1 = 'N'
     C                   EVAL      Idx = Idx + 1
     C                   EVAL      MsgIdArr(Idx) = 'SEW5263'
     C                   EVAL      FldNameArr(Idx) = '#0NAC1'
     C                   ENDIF
 
     C                   ENDIF
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRNAC2 - Validate Narrative for Cash Parties 2                *
      *                                                               *
      * Called by: SRDISPLAY - Display Screen Details                 *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
 
     C     SRNAC2        BEGSR
 
     C                   IF        #0NAC2 <> *BLANKS
 
     C                   IF        #0NAC1 = *BLANKS
     C                   EVAL      OkNAC2 = 'N'
     C                   EVAL      Idx = Idx + 1
     C                   EVAL      MsgIdArr(Idx) = 'SEW5255'
     C                   EVAL      FldNameArr(Idx) = '#0NAC2'
     C                   ENDIF
 
     C                   MOVEL     #0NAC2        WWNAL2
 
     C                   IF        WWNAL1 <> '/' and WWNAL2 = '/'
     C                   EVAL      OkNAC2 = 'N'
     C                   EVAL      Idx = Idx + 1
     C                   EVAL      MsgIdArr(Idx) = 'SEW5256'
     C                   EVAL      FldNameArr(Idx) = '#0NAC2'
     C                   ENDIF
 
     C                   MOVEL     #0NAC2        WWLI02
 
     C                   IF        WWNAL1 = '/' and WWLI02 <> '//'
     C                   EVAL      OkNAC2 = 'N'
     C                   EVAL      Idx = Idx + 1
     C                   EVAL      MsgIdArr(Idx) = 'SEW5214'
     C                   EVAL      FldNameArr(Idx) = '#0NAC2'
     C                   ENDIF
 
     C                   IF        WWNAL2 = '/' and WWLI02 <> '//'
     C                   EVAL      OkNAC2 = 'N'
     C                   EVAL      Idx = Idx + 1
     C                   EVAL      MsgIdArr(Idx) = 'SEW5257'
     C                   EVAL      FldNameArr(Idx) = '#0NAC2'
     C                   ENDIF
 
     C                   MOVE      #0NAC2        WWLI33
 
     C                   IF        WWLI02 = '//' and WWLI33 = *BLANKS
     C                   EVAL      OkNAC2 = 'N'
     C                   EVAL      Idx = Idx + 1
     C                   EVAL      MsgIdArr(Idx) = 'SEW5213'
     C                   EVAL      FldNameArr(Idx) = '#0NAC2'
     C                   ENDIF
 
     C                   IF        #0NAC2 = #0NAC1
     C                   EVAL      OkNAC2 = 'N'
     C                   EVAL      Idx = Idx + 1
     C                   EVAL      MsgIdArr(Idx) = 'SEW5258'
     C                   EVAL      FldNameArr(Idx) = '#0NAC2'
     C                   ENDIF
 
     C                   ENDIF
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRCUST - Check Intermediary Field                             *
      *                                                               *
      * Called by: SRVALIDATE - Validate Screen Details               *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
 
     C     SRCUST        BEGSR
 
     C                   EVAL      WCLAS = 'C'
     C                   EVAL      PKEY1 = WWIMMD
     C                   EVAL      WUnqeFlg = 'N'
     C                   EVAL      JFIMMD = *BLANKS                                           205141
 
     C                   CALLB     'AOCUSTR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*KEY   '     @OPTN
     C                   PARM                    PKEY1
     C                   PARM                    PKYST
     C     SDCUST        PARM      SDCUST        DSSDY
 
      ** If Return code is not blank then check if entry is a valid BIC code
 
     C                   IF        @RTCD <> *BLANKS
 
     C                   MOVEL     WWIMMD        PCSID8
     C                   MOVE      WWIMMD        PCSID4
     C                   MOVEL     PCSID4        PCSID3
 
     C                   EVAL      WCLAS = 'B'
 
     C                   CALL      'ME1400'
     C                   PARM      *BLANKS       PBICR
     C                   PARM                    PCSID8
     C                   PARM                    PCSID3
     C                   PARM                    SDCUST
     C                   PARM                    SDCNST
     C                   PARM                    MEBICD
     C                   PARM      *BLANKS       PBICC
     C                   PARM      *BLANKS       PBICS
     C                   PARM      *BLANKS       PBICI
 
     C                   IF        PBICR = *BLANKS                                            199797
     C                             OR PBICR = 'MIN0244' AND                                   205141
     C                             PBICC = 'Y'                                                205141
     C                   EVAL      @RTCD = *BLANKS                                            199797
     C                   ENDIF                                                                199797
                                                                                              199797
     C                   ELSE
 
     C                   EVAL      WWIMMD = BBCUST
     C                   EVAL      JFIMMD = BBCSID                                            205141
 
     C                   ENDIF
 
      ** Check settlement account is unique
 
     C                   IF        WImFlg = 'Y'
 
     C                   EVAL      WCtr = 1
 
     C                   DOW       WCtr <= 9
 
     C                   IF        WIMDArr(WCtr) = *BLANKS
     C                   MOVEL     WWIMMD        WIMDArr(WCtr)
     C                   LEAVE
     C                   ELSE
 
     C                   IF        WIMDArr(WCtr) = WWIMMD
     C                   EVAL      WUnqeFlg = 'Y'
     C                   LEAVE
     C                   ENDIF
 
     C                   ENDIF
 
     C                   EVAL      WCtr = WCtr + 1
     C                   ENDDO
 
     C                   ENDIF
 
     C                   ENDSR
 
     C/COPY WNCPYSRC,SE1806C052                                                               CSW210
      *****************************************************************                       CSW210
      /EJECT                                                                                  CSW210
      *****************************************************************                       CSW210
      *                                                               *                       CSW210
      * SRRED1 - Validate Registration Details Line 1                 *                       CSW210
      *                                                               *                       CSW210
      * Called by: SRVALIDATE - Validate Screen Details               *                       CSW210
      *                                                               *                       CSW210
      * Calls: None                                                   *                       CSW210
      *                                                               *                       CSW210
      *****************************************************************                       CSW210
                                                                                              CSW210
     C     SRRED1        BEGSR                                                                CSW210
     C/COPY WNCPYSRC,SE1806C005                                                               CSW210
      ** Validate Field If not Blank                                                          CSW210
     C     #0RED1        IFNE      *BLANKS                                                    CSW210
     C/COPY WNCPYSRC,SE1806C006                                                               CSW210
      *                                                                                       CSW210
     C                   MOVE      *BLANKS       WWLI01                                       CSW210
     C                   MOVEL     #0RED1        WWLI01                                       CSW210
     C     WWLI01        IFEQ      '/'                                                        CSW210
     C/COPY WNCPYSRC,SE1806C003                                                               CSW210
     C                   EVAL      OkRED1 = 'N'                                               CSW210
     C                   EVAL      Idx = Idx + 1                                              CSW210
     C                   EVAL      MsgIdArr(Idx) = 'SEW5285'                                  CSW210
     C                   EVAL      FldNameArr(Idx) = '#0RED1'                                 CSW210
     C                   ENDIF                                                                CSW210
      *                                                                                       CSW210
     C                   ENDIF                                                                CSW210
     C                   ENDSR                                                                CSW210
                                                                                              CSW210
      *****************************************************************                       CSW210
      /EJECT                                                                                  CSW210
      *****************************************************************                       CSW210
      *                                                               *                       CSW210
      * SRRED2 - Validate Registration Details Line 2                 *                       CSW210
      *                                                               *                       CSW210
      * Called by: SRVALIDATE - Validate Screen Details               *                       CSW210
      *                                                               *                       CSW210
      * Calls: None                                                   *                       CSW210
      *                                                               *                       CSW210
      *****************************************************************                       CSW210
                                                                                              CSW210
     C     SRRED2        BEGSR                                                                CSW210
      *                                                                                       CSW210
      ** Validate Field If not Blank                                                          CSW210
     C     #0RED2        IFNE      *BLANKS                                                    CSW210
     C/COPY WNCPYSRC,SE1806C007                                                               CSW210
      *                                                                                       CSW210
     C     #0RED1        IFEQ      *BLANKS                                                    CSW210
     C                   EVAL      OkRED2 = 'N'                                               CSW210
     C                   EVAL      Idx = Idx + 1                                              CSW210
     C                   EVAL      MsgIdArr(Idx) = 'SEW5255'                                  CSW210
     C                   EVAL      FldNameArr(Idx) = '#0RED2'                                 CSW210
     C                   ENDIF                                                                CSW210
      *                                                                                       CSW210
     C     #0RED2        IFEQ      #0RED1                                                     CSW210
     C                   EVAL      OkRED2 = 'N'                                               CSW210
     C                   EVAL      Idx = Idx + 1                                              CSW210
     C                   EVAL      MsgIdArr(Idx) = 'SEW5258'                                  CSW210
     C                   EVAL      FldNameArr(Idx) = '#0RED2'                                 CSW210
     C                   ENDIF                                                                CSW210
      *                                                                                       CSW210
     C                   MOVE      *BLANKS       WWLI01                                       CSW210
     C                   MOVEL     #0RED2        WWLI01                                       CSW210
     C     WWLI01        IFEQ      '/'                                                        CSW210
     C/COPY WNCPYSRC,SE1806C004                                                               CSW210
     C                   EVAL      OkRED2 = 'N'                                               CSW210
     C                   EVAL      Idx = Idx + 1                                              CSW210
     C                   EVAL      MsgIdArr(Idx) = 'SEW5285'                                  CSW210
     C                   EVAL      FldNameArr(Idx) = '#0RED2'                                 CSW210
     C                   ENDIF                                                                CSW210
      *                                                                                       CSW210
     C/COPY WNCPYSRC,SE1806C008                                                               CSW210
     C                   ENDIF                                                                CSW210
     C                   ENDSR                                                                CSW210
                                                                                              CSW210
      *****************************************************************                       CSW210
      /EJECT                                                                                  CSW210
      *****************************************************************                       CSW210
      *                                                               *                       CSW210
      * SRCUST2 - Validate Customer Number/Shortname/Nostro           *                       CSW210
      *                                                               *                       CSW210
      * Called by: SRINVE - Validate Investor                         *                       CSW210
      *            SRPCLR - Validate Place of Clearing                *                       CSW210
      * Calls: None                                                   *                       CSW210
      *                                                               *                       CSW210
      *****************************************************************                       CSW210
                                                                                              CSW210
     C     SRCUST2       BEGSR                                                                CSW210
                                                                                              CSW210
     C                   MOVE      *BLANKS       WWCUSS                                       CSW210
      *                                                                                       CSW210
      ** Call Access Program for Customer Details using the Customer                          CSW210
      ** Number or the Customer Shortname.                                                    CSW210
                                                                                              CSW210
     C                   CALL      'AOCUSTR0'                                                 CSW210
     C                   PARM      *BLANKS       @RTCD                                        CSW210
     C                   PARM      '*KEY   '     @OPTN                                        CSW210
     C                   PARM      WWCUST        PKEY1                                        CSW210
     C                   PARM      *BLANKS       PKYST                                        CSW210
     C     SDCUST        PARM      SDCUST        DSSDY                                        CSW210
      *                                                                                       CSW210
      ** If Return code is blank then set WWCUSS to 'C' if Customer                           CSW210
      ** Number; to 'S' if Customer Shortname.                                                CSW210
     C                   IF        @RTCD = *BLANK                                             CSW210
     C                             AND PKYST <> '*ERROR'                                      CSW210
     C                   IF        PKYST = '*CNUM'                                            CSW210
     C                   MOVE      'C'           WWCUSS                                       CSW210
     C                   ELSE                                                                 CSW210
     C                   MOVE      'S'           WWCUSS                                       CSW210
     C                   ENDIF                                                                CSW210
      *                                                                                       CSW210
     C                   MOVE      BBCABA        WWCABA                                       CSW210
     C                   MOVE      BBCSID        WWCSID                                       CSW210
     C                   MOVE      BBBLCD        WWBLCD                                       CSW210
     C                   MOVE      BBFWCD        WWFWCD                                       CSW210
     C                   MOVE      BBCHID        WWCHID                                       CSW210
     C                   MOVE      BBCHSC        WWCHSC                                       CSW210
     C                   MOVE      BBBNBI        WWBNBI                                       CSW210
      *                                                                                       CSW210
      ** Else (error on Customer file) may be a Counterparty Nostro                           CSW210
                                                                                              CSW210
     C                   ELSE                                                                 CSW210
     C                   MOVEL     WWCUST        WWNOST                                       CSW210
     C                   CALL      'AOCNSTR0'                                                 CSW210
     C                   PARM      *BLANKS       @RTCD                                        CSW210
     C                   PARM      '*KEY   '     @OPTN                                        CSW210
     C                   PARM      WWNOST        PKEY2                                        CSW210
     C     SDCNST        PARM      SDCNST        DSFDY                                        CSW210
      *                                                                                       CSW210
     C                   IF        @RTCD = *BLANK                                             CSW210
     C                   MOVE      'N'           WWCUSS                                       CSW210
     C                   MOVE      AWSWID        WWCSID                                       CSW210
     C                   MOVE      AWFWCD        WWFWCD                                       CSW210
     C                   MOVE      'Y'           WWBNBI                                       CSW210
     C                   ENDIF                                                                CSW210
     C                   ENDIF                                                                CSW210
      *                                                                                       CSW210
     C                   ENDSR                                                                CSW210
                                                                                              CSW210
      *****************************************************************                       CSW210
      /EJECT                                                                                  CSW210
      *****************************************************************                       CSW210
      *                                                               *                       CSW210
      * SRINVE - Validate Registration Details Line 2                 *                       CSW210
      *                                                               *                       CSW210
      * Called by: SRVALIDATE - Validate Screen Details               *                       CSW210
      *                                                               *                       CSW210
      * Calls: None                                                   *                       CSW210
      *                                                               *                       CSW210
      *****************************************************************                       CSW210
                                                                                              CSW210
     C     SRINVE        BEGSR                                                                CSW210
      *                                                                                       CSW210
      ** Validate Field If not Blank                                                          CSW210
     C     #0INVE        IFNE      *BLANKS                                                    CSW210
     C                   MOVEL     *BLANKS       WWINVE                                       CSW210
     C                   MOVEL     #0INVE        WWCUST                                       CSW210
     C                   EXSR      SRCUST2                                                    CSW210
      *                                                                                       CSW210
     C                   SELECT                                                               CSW210
     C     WWCUSS        WHENEQ    'C'                                                        CSW210
     C     WWCUSS        OREQ      'S'                                                        CSW210
     C                   MOVEL     BBCUST        WWINVE                                       CSW210
     C     WWCUSS        WHENEQ    'N'                                                        CSW210
     C                   MOVEL     AWCPNC        WWINVE                                       CSW210
      *                                                                                       CSW210
     C                   OTHER                                                                CSW210
     C                   EVAL      OkINVE = 'N'                                               CSW210
     C                   EVAL      Idx = Idx + 1                                              CSW210
     C                   EVAL      MsgIdArr(Idx) = 'SEW5205'                                  CSW210
     C                   EVAL      FldNameArr(Idx) = '#0INVE'                                 CSW210
     C                   ENDSL                                                                CSW210
     C                   ELSE                                                                 CSW210
     C                   MOVE      *BLANKS       WWINVE                                       CSW210
     C                   ENDIF                                                                CSW210
     C                   ENDSR                                                                CSW210
                                                                                              CSW210
      *****************************************************************                       CSW210
      /EJECT                                                                                  CSW210
      *****************************************************************                       CSW210
      *                                                               *                       CSW210
      * SRPCLR - Validate Place of Clearing                           *                       CSW210
      *                                                               *                       CSW210
      * Called by: SRVALIDATE - Validate Screen Details               *                       CSW210
      *                                                               *                       CSW210
      * Calls: None                                                   *                       CSW210
      *                                                               *                       CSW210
      *****************************************************************                       CSW210
                                                                                              CSW210
     C     SRPCLR        BEGSR                                                                CSW210
      *                                                                                       CSW210
      ** Validate Field If not Blank                                                          CSW210
     C     #0PCLR        IFNE      *BLANKS                                                    CSW210
     C                   MOVEL     *BLANKS       WWPCLR                                       CSW210
     C                   MOVEL     #0PCLR        WWCUST                                       CSW210
     C                   EXSR      SRCUST2                                                    CSW210
      *                                                                                       CSW210
     C                   SELECT                                                               CSW210
     C     WWCUSS        WHENEQ    'C'                                                        CSW210
     C     WWCUSS        OREQ      'S'                                                        CSW210
     C                   MOVEL     BBCUST        WWPCLR                                       CSW210
     C     WWCUSS        WHENEQ    'N'                                                        CSW210
     C                   MOVEL     AWCPNC        WWPCLR                                       CSW210
      *                                                                                       CSW210
     C                   OTHER                                                                CSW210
     C                   EVAL      OkPLCR = 'N'                                               CSW210
     C                   EVAL      Idx = Idx + 1                                              CSW210
     C                   EVAL      MsgIdArr(Idx) = 'ST00084'                                  CSW210
     C                   EVAL      FldNameArr(Idx) = '#0PCLR'                                 CSW210
     C                   ENDSL                                                                CSW210
     C                   ELSE                                                                 CSW210
     C                   MOVE      *BLANKS       WWPCLR                                       CSW210
     C                   ENDIF                                                                CSW210
     C                   ENDSR                                                                CSW210
                                                                                              CSW210
      *****************************************************************                       CSW210
      /EJECT                                                                                  CSW210
      *****************************************************************                       CSW210
      *                                                               *                       CSW210
      * SRQFIN - Validate Qualified Foreign Intermediary              *                       CSW210
      *                                                               *                       CSW210
      * Called by: SRVALIDATE - Validate Screen Details               *                       CSW210
      *                                                               *                       CSW210
      * Calls: None                                                   *                       CSW210
      *                                                               *                       CSW210
      *****************************************************************                       CSW210
                                                                                              CSW210
     C     SRQFIN        BEGSR                                                                CSW210
      *                                                                                       CSW210
      ** Validate Field If not Blank                                                          CSW210
     C     #0QFIN        IFNE      *BLANKS                                                    CSW210
     C                   MOVEL     *BLANKS       WWQFIN                                       CSW210
     C                   MOVEL     #0QFIN        WWCUST                                       CSW210
     C                   EXSR      SRCUST2                                                    CSW210
      *                                                                                       CSW210
     C                   SELECT                                                               CSW210
     C     WWCUSS        WHENEQ    'C'                                                        CSW210
     C     WWCUSS        OREQ      'S'                                                        CSW210
     C                   MOVEL     BBCUST        WWQFIN                                       CSW210
     C     WWCUSS        WHENEQ    'N'                                                        CSW210
     C                   MOVEL     AWCPNC        WWQFIN                                       CSW210
      *                                                                                       CSW210
     C                   OTHER                                                                CSW210
     C                   EVAL      OkQFIN = 'N'                                               CSW210
     C                   EVAL      Idx = Idx + 1                                              CSW210
     C                   EVAL      MsgIdArr(Idx) = 'ST00083'                                  CSW210
     C                   EVAL      FldNameArr(Idx) = '#0QFIN'                                 CSW210
     C                   ENDSL                                                                CSW210
     C                   ELSE                                                                 CSW210
     C                   MOVE      *BLANKS       WWQFIN                                       CSW210
     C                   ENDIF                                                                CSW210
     C                   ENDSR                                                                CSW210
                                                                                              CSW210
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRMOVE   - Move Value of Parameter to Screen                  *
      *                                                               *
      * Called by: SRMAIN - Program Main Processing                   *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
 
     C     SRMOVE        BEGSR
 
      ** Move parameter value to screen
 
     C                   EVAL      #0IMMD1 = PIMMD1
     C                   EVAL      #0IMMD2 = PIMMD2
     C                   EVAL      #0IMMD3 = PIMMD3
     C                   EVAL      #0IMMD4 = PIMMD4
     C                   EVAL      #0IMMD5 = PIMMD5
     C                   EVAL      #0IMMD6 = PIMMD6
     C                   EVAL      #0IMMD7 = PIMMD7
     C                   EVAL      #0IMMD8 = PIMMD8
     C                   EVAL      #0IMMD9 = PIMMD9
     C                   EVAL      #0IMSA1 = PIMSA1
     C                   EVAL      #0IMSA2 = PIMSA2
     C                   EVAL      #0IMSA3 = PIMSA3
     C                   EVAL      #0IMSA4 = PIMSA4
     C                   EVAL      #0IMSA5 = PIMSA5
     C                   EVAL      #0IMSA6 = PIMSA6
     C                   EVAL      #0IMSA7 = PIMSA7
     C                   EVAL      #0IMSA8 = PIMSA8
     C                   EVAL      #0IMSA9 = PIMSA9
     C                   EVAL      #0PSET = PPlaceSet
     C                   EVAL      #0NAC1 = PNarrCash1
     C                   EVAL      #0NAC2 = PNarrCash2
     C                   EVAL      #0RED1 = PRegDet1                                          CSW210
     C                   EVAL      #0RED2 = PRegDet2                                          CSW210
     C                   EVAL      #0INVE = PInvestor                                         CSW210
     C                   EVAL      #0QFIN = PQualiFin                                         CSW210
     C                   EVAL      #0PCLR = PPlaceClr                                         CSW210
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRUPDATE - Update Add'l Standard Settlement Instruction       *
      *                                                               *
      * Called by: SRMAIN - Program Main Processing                   *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
 
     C     SRUPDATE      BEGSR
 
      ** Move screen fields to file
 
     C                   EVAL      PIMMD1 = #0IMMD1
     C                   EVAL      PIMMD2 = #0IMMD2
     C                   EVAL      PIMMD3 = #0IMMD3
     C                   EVAL      PIMMD4 = #0IMMD4
     C                   EVAL      PIMMD5 = #0IMMD5
     C                   EVAL      PIMMD6 = #0IMMD6
     C                   EVAL      PIMMD7 = #0IMMD7
     C                   EVAL      PIMMD8 = #0IMMD8
     C                   EVAL      PIMMD9 = #0IMMD9
     C                   EVAL      PIMSA1 = #0IMSA1
     C                   EVAL      PIMSA2 = #0IMSA2
     C                   EVAL      PIMSA3 = #0IMSA3
     C                   EVAL      PIMSA4 = #0IMSA4
     C                   EVAL      PIMSA5 = #0IMSA5
     C                   EVAL      PIMSA6 = #0IMSA6
     C                   EVAL      PIMSA7 = #0IMSA7
     C                   EVAL      PIMSA8 = #0IMSA8
     C                   EVAL      PIMSA9 = #0IMSA9
     C                   EVAL      PPlaceSet = #0PSET
     C                   EVAL      PNarrCash1 = #0NAC1
     C                   EVAL      PNarrCash2 = #0NAC2
     C                   EVAL      PRegDet1 = #0RED1                                          CSW210
     C                   EVAL      PRegDet2 = #0RED2                                          CSW210
     C                   EVAL      PInvestor = WWINVE                                         CSW210
     C                   EVAL      PQualiFin = WWQFIN                                         CSW210
     C                   EVAL      PPlaceClr = WWPCLR                                         CSW210
 
     C                   EVAL      PMode = 'R'
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRRETRY - Refresh Screen                                      *
      *                                                               *
      * Called by: SRDISPLAY - Display Screen Details                 *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
 
     C     SRRETRY       BEGSR
 
     C                   IF        PActn = 'I'
 
     C                   EVAL      WInterMed = *BLANKS
     C                   EVAL      WSafeAcct = *BLANKS
     C                   EVAL      #0PSET = *BLANKS
     C                   EVAL      #0NAC1 = *BLANKS
     C                   EVAL      #0NAC2 = *BLANKS
     C                   EVAL      #0RED1 = *BLANKS                                           CSW210
     C                   EVAL      #0RED2 = *BLANKS                                           CSW210
     C                   EVAL      #0INVE = *BLANKS                                           CSW210
     C                   EVAL      #0QFIN = *BLANKS                                           CSW210
     C                   EVAL      #0PCLR = *BLANKS                                           CSW210
 
     C                   ELSE
 
     C                   EVAL      WInterMed = PInterMed
     C                   EVAL      WSafeAcct = PSafeAcct
     C                   EVAL      #0PSET = PPlaceSet
     C                   EVAL      #0NAC1 = PNarrCash1
     C                   EVAL      #0NAC2 = PNarrCash2
     C                   EVAL      #0RED1 = PRegDet1                                          CSW210
     C                   EVAL      #0RED2 = PRegDet2                                          CSW210
     C                   EVAL      #0INVE = PInvestor                                         CSW210
     C                   EVAL      #0QFIN = PQualiFin                                         CSW210
     C                   EVAL      #0PCLR = PPlaceClr                                         CSW210
 
     C                   ENDIF
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRRETURN - Return to Calling Program                          *
      *                                                               *
      * Called by: SRMAIN - Program Main Processing                   *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
 
     C     SRRETURN      BEGSR
 
     C                   RETURN
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
 
      ** The following /COPY line includes the ProcMsgs subroutine
      ** to process error and warning messages.
 
     C/COPY ZACPYSRC,MSGHNDDSP2
 
      *****************************************************************
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
 
     C     *ENTRY        PLIST
     C                   PARM                    PActn
     C                   PARM                    PInterMed
     C                   PARM                    PSafeAcct
     C                   PARM                    PPlaceSet
     C                   PARM                    PNarrCash
     C                   PARM                    RetCodeOut
     C                   PARM                    PRegDetail                                   CSW210
     C                   PARM                    PInvestor                                    CSW210
     C                   PARM                    PQualiFin                                    CSW210
     C                   PARM                    PPlaceClr                                    CSW210
 
      ** Access Bank Details
 
     C                   CALLB     'AOBANKR0'
     C                   PARM      '*DBERR '     @RTCD
     C                   PARM      '*FIRST '     @OPTN
     C     SDBANK        PARM      SDBANK        DSFDY
 
      ** Database Error
 
     C                   IF        @RTCD <> *BLANKS
     C                   MOVEL     'SDBANKPD'    DBFILE
     C                   MOVEL     '001'         DBASE
     C                   MOVEL     @OPTN         DBKEY
     C                   EXSR      *PSSR
     C                   ENDIF
                                                                                            AR325362
      ** Check if CSW206 is switched on                                                     AR325362
                                                                                            AR325362
     C                   MOVE      '0'           *IN50                                      AR325362
     C                   CALL      'AOSARDR0'                                               AR325362
     C                   PARM      *BLANKS       @RTCD                                      AR325362
     C                   PARM      '*VERIFY'     @OPTN                                      AR325362
     C                   PARM      'CSW206'      @SARD                                      AR325362
     C     SCSARD        PARM      SCSARD        DSFDY                                      AR325362
                                                                                            AR325362
     C                   IF        @RTCD = *BLANKS                                          AR325362
     C                   MOVE      '1'           *IN50                                      AR325362
     C                   ENDIF                                                              AR325362
 
      ** Move workstation ID to screen field.
 
     C                   MOVEL     PsUser        #0USER
     C                   MOVEL     PsJobName     #0WSID
     C                   MOVEL     BJMRDT        #0RUNA
 
      ** Initialise the fixed parameters for ZAMSGHNDLE.
 
     C                   EVAL      ModuleID     = 'SE'
     C                   EVAL      APRPRLOCN    = 'S'
     C                   EVAL      APCNFVALFO   = 'N'
     C                   EVAL      APRespMode   = 'S'
 
      ** Set up the prime and secondary message files for
      ** finding message IDs.
 
     C                   EVAL      #MsgFile     = 'SEUSRMSG'
     C                   EVAL      MsgFArray(1) = 'DRSMM'
     C                   EVAL      MsgFArray(2) = 'MEMSG'
 
      ** Message subfile control
 
     C                   EVAL      *IN97 = *ON
     C                   EVAL      DDPGMQ = '*'
 
      ** Program, module and procedure names for database error processing
      ** =================================================================
      ** The following /COPY sets these values.
 
      /COPY ZACPYSRC,DBFIELDS
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
 
      ** The following /COPY contains the standard program status
      ** subroutine, including a bound call to the DBERRCTL module.
 
     C/COPY ZACPYSRC,PSSR_ILE
 
      ********************************************************************
      /EJECT
      *****************************************************************
 
**  CPY@
(c) Misys International Banking Systems Ltd. 2001
** @Z0
0000000000000000000000000
