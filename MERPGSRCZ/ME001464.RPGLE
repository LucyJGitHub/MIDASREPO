     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2013')
      *****************************************************************
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('SWIFTRef - Copy to old Files')                         *
      *****************************************************************
      *                                                               *
      *  Midas - Message Management Module                            *
      *                                                               *
      *  ME001464 - SWIFTRef - Copy to old Files                      *
      *                                                               *
      *  Function:  Loader = 1 : This program Copy MEBIB3PD Records   *
      *             to old Version of BIC files: MEBICDPD, MEBICPPD   *
      *             and MEBICBPD.                                     *
      *             Loader = 2 : This program Copy MEIBNSPD Records   *
      *             to old version of Iban Structure file : MEBICSPD. *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2013            *
      *                                                               *
      *  Last Amend No. CSW218             Date 19Jun18               *
      *  Prev Amend No. MD022738           Date 08Oct13               *
      *                 CFT050  *CREATE    Date 03Jun13               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CSW218 - SWIFT Changes 2018                                  *
      *  MD022738 - The file MEBICDPD must only be loaded with records*
      *             having a SWIFT address.                           *
      *  CFT050 - SWIFTRef Directories upload                         *
      *                                                               *
      *****************************************************************
      *  Use of indicators.                                           *
      *                                                               *
      *       99  - Record found/not found indicator                  *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  S U B R O U T I N E  I N D E X                               *
      *                                                               *
      *  *PSSR    - Error Processing                                  *
      *  *INZSR   - Program Initialisation Routine                    *
      *                                                               *
      *    The *INZSR subroutine will only get Called automatically   *
      *    on entry to the module the first time it is run            *
      *    (unless you end the program with LR on).  Similarly        *
      *    D-spec initialisation only happens the first time.  Use    *
      *    RESET for subsequent passes.                               *
      *                                                               *
      *****************************************************************
      *
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
      *
     FMEBIB3L0  IF   E           K DISK
      ** Bank Directory Records
      *
     FMEIBNSL0  IF   E           K DISK
      ** IBAN Plus Directory/Structure
      *
     FMEBICDL3  UF A E           K DISK    USROPN
     F                                     Prefix(D_)
      ** BIC Directory
      *
     FMEBICPL0  UF A E           K DISK    USROPN
     F                                     Prefix(P_)
      ** BIC Plus Directory
      *
     FMEBICBL0  UF A E           K DISK    USROPN
     F                                     Prefix(B_)
      ** IBAN Plus Directorry
      *
     FMEBICSL0  UF A E           K DISK    USROPN
      ** IBAN Structures
      *
      /EJECT
      *****************************************************************
      *
      ** +--------------------------------------+
      ** ¦ D-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
      *
     D LDA           E DS           256    EXTNAME(LDA)
      *
      ** Local data area for database error details
     D RUNDAT        E DS                  EXTNAME(RUNDAT)
      *
      ** Data Area giving Installation Control Details
 
     D/COPY ZACPYSRC,PSDS
      *
      ** Program Status Data Structure
      *
      ** +--------------------------------------+
      ** ¦ Named constants                      ¦
      ** ¦ ===============                      ¦
      ** +--------------------------------------+
      *
      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
      *
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
      ** External DS for Bank Details
      *
     D DSFDY         E DS                  EXTNAME(DSFDY)
      ** Short data structure for access objects
      *
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
      *
     D RUN             S              1
      *
     D PLoader         S              1A
     D P1Answer        S              1A
     D P2Answer        S              1A
     D P3Answer        S              1A
      *
     D PRTCD           S              7A
     D POPTN           S              7A
      *
     D KREFKY          S              8A   INZ
     D KIBNKY          S              2A   INZ
                                                                                              CSW218
     D CSW218          S              1A                                                      CSW218
      *****************************************************************
      /EJECT
      *****************************************************************
      *
      ** +--- Start of Main processing -------------------------------+
      ** ¦                                                            ¦
      ** ¦ Initial processing is performed automatically: the *INZSR  ¦
      ** ¦ is executed at program activation.                         ¦
      ** ¦                                                            ¦
      ** +------------------------------------------------------------+
      *
      ** Execute Routine as per PLoader Parameter
      *
     C                   SELECT
     C                   WHEN      PLoader = '1'
     C                   EXSR      LOADER1
     C                   WHEN      PLoader = '2'
     C                   EXSR      LOADER2
     C                   ENDSL
      *
     C                   EVAL      *INLR = *ON
     C                   RETURN
      /EJECT
      *****************************************************************
      *                                                               *
      *  LOADER1 - Amend old file for BANK DIRECTORY Plus Loader      *
      *                                                               *
      *  Called by: MAIN                                              *
      *                                                               *
      *  Calls:  DO_BICD, DO_BICP and DO_BICB                         *
      *                                                               *
      *****************************************************************
      *
     C     LOADER1       BEGSR
      *
     C                   IF        P1Answer = 'Y'
     C                   EXSR      DO_BICD
     C                   ENDIF
      *
     C                   IF        P2Answer = 'Y'
     C                   EXSR      DO_BICP
     C                   ENDIF
      *
     C                   IF        P3Answer = 'Y'
     C                   EXSR      DO_BICB
     C                   ENDIF
      *
     C                   ENDSR
      /EJECT
      *****************************************************************
      *                                                               *
      *  LOADER2 - Amend old file for IBAN Plus DIRECTORY Loader      *
      *                                                               *
      *  Called by: MAIN                                              *
      *                                                               *
      *  Calls:  DO_BICS                                              *
      *                                                               *
      *****************************************************************
      *
     C     LOADER2       BEGSR
      *
     C                   IF        P1Answer = 'Y'
     C                   EXSR      DO_BICS
     C                   ENDIF
      *
     C                   ENDSR
      /EJECT
      *****************************************************************
      *                                                               *
      *  DO_BICD - Update MEBICDPD Details                            *
      *                                                               *
      *  Called by: LOADER1                                           *
      *                                                               *
      *  Calls: *PSSR                                                 *
      *                                                               *
      *****************************************************************
     C     DO_BICD       BEGSR
      *
     C                   OPEN      MEBICDL3                             99
     C     *IN99         IFEQ      *ON
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE =  'MEBICDL3'
     C                   EVAL      DBKEY  =  'OPEN File'
     C                   EVAL      DBASE  =  2
     C                   EVAL      DBPROC =  'SR/DO_BICD '
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
      *
     C     *LOVAL        SETLL     MEBIB3L0
     C                   READ      MEBIB3L0
     C                   DOW       NOT %EOF
      *
     C                   MOVEL     B3FIL2        KREFKY
     C     KBICF         CHAIN     @BICDPD
      *
     C                   IF        B3FLAG = 'D'
     C                             AND %FOUND(MEBICDL3)
     C                   DELETE    @BICDPD
     C                   ELSE
      *
     C                   IF        B3BICC <> *BLANKS                                        MD022738
     C                   MOVEL(P)  'BI'          D_BDTAG
     C                   MOVEL(P)  B3FLAG        D_BDMODF
     C                   MOVEL(P)  B3BICC        D_BDBICC
     C                   MOVEL(P)  B3BRCD        D_BDBICB
     C                   MOVEL(P)  B3INS1        D_BDINS1
     C                   MOVEL(P)  B3INS2        D_BDINS2
     C                   MOVEL(P)  B3INS3        D_BDINS3
     C                   MOVEL(P)  B3BIN1        D_BDBRC1
     C                   MOVEL(P)  B3BIN2        D_BDBRC2
     C                   MOVEL(P)  B3CITY        D_BDCITY
     C                   MOVEL(P)  B3STYP        D_BDSUBT
     C                   MOVEL(P)  B3SER1        D_BDADDS
     C                   MOVE      B3SER2        D_BDADDS
     C                   IF        CSW218 = 'Y'                                               CSW218
     C                   EVAL      %SUBST(D_BDXINF:19:1) = %SUBST(B3NWCY:1:1)                 CSW218
     C                   ELSE                                                                 CSW218
     C                   MOVEL(P)  *BLANKS       D_BDXINF
     C                   ENDIF                                                                CSW218
     C                   MOVEL(P)  B3ADD1        D_BDAPH1
     C                   MOVEL(P)  B3ADD2        D_BDAPH2
     C                   MOVEL(P)  B3ADD3        D_BDAPH3
     C                   MOVEL(P)  B3ADD4        D_BDAPH4
     C                   MOVEL(P)  B3ZIP         D_BDZIP
     C                   MOVEL(P)  B3CPS1        D_BDLOC1
     C                   MOVEL(P)  B3CPS2        D_BDLOC2
     C                   MOVEL(P)  B3CPS3        D_BDLOC3
     C                   MOVEL(P)  B3CNT1        D_BDCTY1
     C                   MOVEL(P)  B3CNT2        D_BDCTY2
     C                   MOVEL(P)  B3POBN        D_BDPOBN
     C                   MOVEL(P)  *BLANKS       D_BDPOB1
     C                   MOVEL(P)  *BLANKS       D_BDPOB2
     C                   MOVEL(P)  *BLANKS       D_BDPOB3
     C                   MOVEL(P)  *BLANKS       D_BDPBC1
     C                   MOVEL(P)  *BLANKS       D_BDPBC2
     C                   MOVEL(P)  *BLANKS       D_BDSRC
     C                   MOVEL(P)  *BLANKS       D_BDSPCD
     C                   MOVEL(P)  *BLANKS       D_BDNMFG
     C     6             SUBST     B3UDAT:3      D_BDUDAT
     C                   MOVEL(P)  *BLANKS       D_BDORGK
     C                   MOVEL(P)  B3FIL2        D_BDKEY
     C                   MOVEL(P)  B3CHIP        D_BDCHIP
     C                   MOVEL(P)  B3NATI        D_BDNATI
     C                   MOVEL(P)  *BLANKS       D_BDACTD
     C                   MOVEL(P)  *BLANKS       D_BDDACT
     C                   MOVEL(P)  *BLANKS       D_BDUMKY
     C                   MOVEL(P)  *BLANKS       D_BDUSER
     C                   MOVEL(P)  *BLANKS       D_BDCRS1
     C                   MOVEL(P)  *BLANKS       D_BDCRS2
     C                   MOVEL(P)  *BLANKS       D_BDCRS3
     C                   MOVEL(P)  *BLANKS       D_BDCRS4
     C                   MOVEL(P)  *BLANKS       D_BDCRD1
     C                   MOVEL(P)  *BLANKS       D_BDCRD2
     C                   MOVEL(P)  B3FILA        D_BDTRLR
     C                   EVAL      %SUBST(D_BDTRLR:36:35) = B3FLB1
     C                   EVAL      %SUBST(D_BDTRLR:71:8) = %SUBST(B3FLB2:1:8)
      *
     C                   IF        B3FLAG = 'A'
     C                             Or B3FLAG = 'M'
     C                             OR B3FLAG = 'U'
      *
     C                   IF        NOT %FOUND(MEBICDL3)
     C                   WRITE     @BICDPD
     C                   ELSE
      *
     C                   IF        B3FLAG = 'A'
     C                             OR B3FLAG = 'M'
     C                   UPDATE    @BICDPD
     C                   ENDIF
      *
     C                   ENDIF
     C                   ENDIF
      *                                                                                     MD022738
     C                   ENDIF                                                              MD022738
      *
     C                   ENDIF
      *
     C                   READ      MEBIB3L0
     C                   ENDDO
      *
     C                   ENDSR
      /EJECT
      *****************************************************************
      *                                                               *
      *  DO_BICP - Update MEBICPPD Details                            *
      *                                                               *
      *  Called by: LOADER1                                           *
      *                                                               *
      *  Calls: *PSSR                                                 *
      *                                                               *
      *****************************************************************
     C     DO_BICP       BEGSR
      *
     C                   OPEN      MEBICPL0                             99
     C     *IN99         IFEQ      *ON
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE =  'MEBICPL0'
     C                   EVAL      DBKEY  =  'OPEN File'
     C                   EVAL      DBASE  =  2
     C                   EVAL      DBPROC =  'SR/DO_BICP '
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
      *
     C     *LOVAL        SETLL     MEBIB3L0
     C                   READ      MEBIB3L0
     C                   DOW       NOT %EOF
      *
     C                   MOVEL     B3FIL2        KREFKY
     C     KBICF         CHAIN     @BICPPD
      *
     C                   IF        B3FLAG = 'D'
     C                             AND %FOUND(MEBICPL0)
     C                   DELETE    @BICPPD
     C                   ELSE
      *
     C                   MOVEL(P)  'BI'          P_BITAG
     C                   MOVEL(P)  B3FLAG        P_BIFLAG
     C                   MOVEL(P)  B3UBIC        P_BIBIC
     C                   EVAL      %SUBST(P_BIINST: 1:35) = B3INS1
     C                   EVAL      %SUBST(P_BIINST:36:35) = B3INS2
     C                   EVAL      %SUBST(P_BIINST:71:35) = B3INS3
     C                   MOVEL(P)  B3BIN1        P_BIBNCH
     C                   MOVE      B3BIN2        P_BIBNCH
     C                   MOVEL(P)  B3CITY        P_BICITY
     C                   MOVEL(P)  B3STYP        P_BISTYP
     C                   MOVEL(P)  B3SER1        P_BISERV
     C                   MOVE      B3SER2        P_BISERV
     C                   MOVEL(P)  *BLANKS       P_BIXINF
     C                   EVAL      %SUBST(P_BIADDR:  1:35) = B3ADD1
     C                   EVAL      %SUBST(P_BIADDR: 36:35) = B3ADD2
     C                   EVAL      %SUBST(P_BIADDR: 71:35) = B3ADD3
     C                   EVAL      %SUBST(P_BIADDR:106:35) = B3ADD4
     C                   MOVEL(P)  B3ZIP         P_BIZIP
     C                   MOVEL(P)  B3CITY        P_BILOCN
     C                   MOVEL(P)  B3CNT1        P_BICNTY
     C                   MOVEL     B3CNT2        P_BICNTY
     C                   MOVEL(P)  B3POBN        P_BIPOBN
     C                   MOVEL(P)  *BLANKS       P_BIPOBZ
     C                   MOVEL(P)  *BLANKS       P_BIPOBL
     C                   MOVEL(P)  *BLANKS       P_BIPOBC
     C                   MOVEL(P)  *BLANKS       P_BISRCI
     C                   MOVEL(P)  *BLANKS       P_BISPEC
     C                   MOVEL(P)  B3UDAT        P_BIUPDT
     C                   MOVEL(P)  *BLANKS       P_BIORIG
     C                   MOVEL(P)  B3FIL2        P_BIKEY
     C                   MOVEL(P)  *BLANKS       P_BICHCK
     C                   MOVEL(P)  B3CHIP        P_BICHIP
     C                   MOVEL(P)  B3NATI        P_BINATI
     C                   MOVEL(P)  *BLANKS       P_BIACTD
     C                   MOVEL(P)  *BLANKS       P_BIDCTD
     C                   MOVEL(P)  *BLANKS       P_BIUNDC
     C                   MOVEL(P)  *BLANKS       P_BIUNDN
     C                   MOVEL(P)  *BLANKS       P_BINKEY
     C                   MOVEL(P)  *BLANKS       P_BICFLG
     C                   MOVEL(P)  *BLANKS       P_BICINS
     C                   MOVEL(P)  *BLANKS       P_BIUSER
     C                   MOVEL(P)  *BLANKS       P_BICBI1
     C                   MOVEL(P)  *BLANKS       P_BICBI2
     C                   MOVEL(P)  *BLANKS       P_BICBI3
     C                   MOVEL(P)  *BLANKS       P_BICBI4
     C                   MOVEL(P)  *BLANKS       P_BICBD1
     C                   MOVEL(P)  *BLANKS       P_BICBD2
     C                   MOVEL(P)  *BLANKS       P_BIMFLG
     C                   MOVEL(P)  *BLANKS       P_BIMMTH
     C                   MOVEL(P)  *BLANKS       P_BIMRLT
     C                   MOVEL(P)  B3FILA        D_BDTRLR
     C                   EVAL      %SUBST(D_BDTRLR:36:35) = B3FLB1
     C                   EVAL      %SUBST(D_BDTRLR:71:8) = %SUBST(B3FLB2:1:8)
      *
     C                   IF        B3FLAG = 'A'
     C                             OR B3FLAG = 'M'
     C                             OR B3FLAG = 'U'
      *
     C                   IF        NOT %FOUND(MEBICPL0)
     C                   WRITE     @BICPPD
     C                   ELSE
      *
     C                   IF        B3FLAG = 'A'
     C                             OR B3FLAG = 'M'
     C                   UPDATE    @BICPPD
     C                   ENDIF
      *
     C                   ENDIF
     C                   ENDIF
      *
     C                   ENDIF
      *
     C                   READ      MEBIB3L0
     C                   ENDDO
      *
     C                   ENDSR
      /EJECT
      *****************************************************************
      *                                                               *
      *  DO_BICB - Update MEBICBPD Details                            *
      *                                                               *
      *  Called by: LOADER1                                           *
      *                                                               *
      *  Calls: *PSSR                                                 *
      *                                                               *
      *****************************************************************
     C     DO_BICB       BEGSR
      *
     C                   OPEN      MEBICBL0                             99
     C     *IN99         IFEQ      *ON
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE =  'MEBICBL0'
     C                   EVAL      DBKEY  =  'OPEN File'
     C                   EVAL      DBASE  =  2
     C                   EVAL      DBPROC =  'SR/DO_BICB '
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
      *
     C     *LOVAL        SETLL     MEBIB3L0
     C                   READ      MEBIB3L0
     C                   DOW       NOT %EOF
      *
     C                   MOVEL     B3FIL2        KREFKY
     C     KBICF         CHAIN     MEBICBD0
      *
     C                   IF        B3FLAG = 'D'
     C                             AND %FOUND(MEBICBL0)
     C                   DELETE    MEBICBD0
     C                   ELSE
      *
     C                   MOVEL(P)  B3BRQA        B_BIBRQA
     C                   MOVEL(P)  'BI'          B_BITAG
     C                   MOVEL(P)  B3FLAG        B_BIFLAG
     C                   MOVEL(P)  B3FIL2        B_BIKEY
     C                   EVAL      %SUBST(B_BIINST: 1:35) = B3INS1
     C                   EVAL      %SUBST(B_BIINST:36:35) = B3INS2
     C                   EVAL      %SUBST(B_BIINST:71:35) = B3INS3
     C                   EVAL      %SUBST(B_BIINST:71:35) = B3INS3
     C                   MOVEL(P)  B3CITY        B_BICITY
     C                   MOVEL(P)  B3BIN1        B_BIBINF
     C                   MOVE      B3BIN2        B_BIBINF
     C                   MOVEL(P)  B3BICC        B_BIBICC
     C                   MOVEL(P)  B3BRCD        B_BIBRCD
     C                   MOVEL(P)  B3BICC        B_BIUBIC
     C                   MOVEL(P)  B3BRCD        B_BIUBRC
     C                   MOVEL(P)  *BLANKS       B_BIIBIC
     C                   MOVEL(P)  *BLANKS       B_BIIBRC
     C                   MOVEL(P)  *BLANKS       B_BIRBIC
     C                   EVAL      B_BIPBCD = %SUBST(B3BICC:1:4)
     C                   MOVEL(P)  B3ISOC        B_BICTCD
     C                   MOVEL(P)  B3NATI        B_BINATI
     C                   MOVEL(P)  B3NATI        B_BIUNTI
     C                   MOVEL(P)  B3ISOC        B_BIICTY
     C                   MOVEL(P)  B3NATI        B_BIINAT
     C                   MOVEL(P)  B3NATI        B_BIUIND
     C                   MOVEL(P)  *BLANKS       B_BIOND1
     C                   MOVEL(P)  *BLANKS       B_BIOND2
     C                   MOVEL(P)  B3CHIP        B_BICHIP
     C                   MOVEL(P)  B3STYP        B_BISTYP
     C                   MOVEL(P)  B3SER1        B_BISERV
     C                   MOVE      B3SER2        B_BISERV
     C                   MOVEL(P)  B3BRQA        B_BIBRQA
     C                   MOVEL(P)  *BLANKS       B_BISPCD
     C                   EVAL      %SUBST(B_BIADDR:  1:35) = B3ADD1
     C                   EVAL      %SUBST(B_BIADDR: 36:35) = B3ADD2
     C                   EVAL      %SUBST(B_BIADDR: 71:35) = B3ADD3
     C                   EVAL      %SUBST(B_BIADDR:106:35) = B3ADD4
     C                   MOVEL(P)  B3ZIP         B_BIZIP
     C                   MOVEL(P)  *BLANKS       B_BILOCN
     C                   MOVEL(P)  B3CNT1        B_BICNTY
     C                   MOVE      B3CNT2        B_BICNTY
     C                   MOVEL(P)  B3POBN        B_BIPOBN
     C                   MOVEL(P)  *BLANKS       B_BIPOBZ
     C                   MOVEL(P)  *BLANKS       B_BIPLOC
     C                   MOVEL(P)  *BLANKS       B_BIPCNT
     C                   MOVEL(P)  *BLANKS       B_BINDED
     C                   MOVEL(P)  B3UDAT        B_BIUDAT
      *
     C                   IF        B3FLAG = 'A'
     C                             Or B3FLAG = 'M'
     C                             OR B3FLAG = 'U'
      *
     C                   IF        NOT %FOUND(MEBICBL0)
     C                   WRITE     MEBICBD0
     C                   ELSE
      *
     C                   IF        B3FLAG = 'A'
     C                             OR B3FLAG = 'M'
     C                   UPDATE    MEBICBD0
     C                   ENDIF
      *
     C                   ENDIF
     C                   ENDIF
      *
     C                   ENDIF
      *
     C                   READ      MEBIB3L0
     C                   ENDDO
      *
     C                   ENDSR
      /EJECT
      *****************************************************************
      *                                                               *
      *  DO_BICS - Update MEBICSPD Details                            *
      *                                                               *
      *  Called by: LOADER2                                           *
      *                                                               *
      *  Calls: *PSSR                                                 *
      *                                                               *
      *****************************************************************
     C     DO_BICS       BEGSR
      *
     C                   OPEN      MEBICSL0                             99
     C     *IN99         IFEQ      *ON
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE =  'MEBICSL0'
     C                   EVAL      DBKEY  =  'OPEN File'
     C                   EVAL      DBASE  =  2
     C                   EVAL      DBPROC =  'SR/DO_BICS '
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
      *
     C     *LOVAL        SETLL     MEIBNSL0
     C                   READ      MEIBNSL0
     C                   DOW       NOT %EOF
      *
     C                   MOVEL     NSCCOD        KIBNKY
     C     KCCDF         CHAIN     MEBICSD0
      *
     C                   IF        NSFLAG = 'D'
     C                             AND %FOUND(MEBICSL0)
     C                   DELETE    MEBICSD0
     C                   ELSE
      *
     C                   MOVE      NSTAG         ISTAG
     C                   MOVE      NSFLAG        ISFLAG
     C                   MOVE      NSCCOD        ISCCOD
     C                   MOVE      NSCPOS        ISCPOS
     C                   MOVE      NSCLEN        ISCLEN
     C                   MOVE      NSDPOS        ISDPOS
     C                   MOVE      NSDLEN        ISDLEN
     C                   MOVE      NSBIDP        ISBIDP
     C                   MOVE      NSBIDL        ISBIDL
     C                   MOVE      NSBRCP        ISCIDP
     C                   MOVE      NSBRCL        ISCIDL
     C                   MOVE      NSINAT        ISINDL
     C                   MOVE      NSACNP        ISACNP
     C                   MOVE      NSACNL        ISACNL
     C                   MOVE      NSIBNL        ISIBNL
      *
     C                   IF        NSFLAG = 'A'
     C                             OR NSFLAG = 'M'
     C                             OR NSFLAG = 'U'
      *
     C                   IF        NOT %FOUND(MEBICSL0)
     C                   WRITE     MEBICSD0
     C                   ELSE
      *
     C                   IF        NSFLAG = 'A'
     C                             OR NSFLAG = 'M'
     C                   UPDATE    MEBICSD0
     C                   ENDIF
      *
     C                   ENDIF
     C                   ENDIF
      *
     C                   ENDIF
      *
     C                   READ      MEIBNSL0
     C                   ENDDO
      *
     C                   ENDSR
      /EJECT
      *****************************************************************
      *                                                               *
      * *INZSR - Program Initialisation routine                       *
      *                                                               *
      * Called by: Implicitly on program activation                   *
      *                                                               *
      * Calls: AOBANKR0 and *PSSR                                     *
      *                                                               *
      *****************************************************************
      *
     C     *INZSR        BEGSR
      *
     C     *ENTRY        PLIST
     C                   PARM                    PLoader
     C                   PARM                    P1Answer
     C                   PARM                    P2Answer
     C                   PARM                    P3Answer
      *
     C     *DTAARA       DEFINE                  RUNDAT
     C     *DTAARA       DEFINE                  LDA
     C                   IN        RUNDAT
      *
      ** Define LDA
      *
     C     *LOCK         IN        LDA
     C                   MOVEL     'ME001463'    DBPGM
     C                   MOVE      *BLANKS       DBFILE
     C                   MOVE      *BLANKS       DBKEY
     C                   Z-ADD     0             DBASE
     C                   OUT       LDA
      *
      ** Retrieve bank details
      *
     C                   CALL      'AOBANKR0'
     C                   PARM      *BLANKS       PRTCD
     C                   PARM      '*FIRST  '    POPTN
     C     SDBANK        PARM      SDBANK        DSFDY
      *
     C     PRTCD         IFNE      *BLANKS
     C     *LOCK         IN        LDA
     C                   Z-ADD     1             DBASE
     C                   MOVEL     'SDBANKPD'    DBFILE
     C                   MOVEL     '*FIRST  '    DBKEY
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
      *                                                                                       CSW218
      ** Check if Swift 2018 Changes is installed.                                            CSW218
      *                                                                                       CSW218
     C                   CALL      'SWIF2018'                                                 CSW218
     C                   PARM      *BLANKS       PRTCD                                        CSW218
      *                                                                                       CSW218
     C     PRTCD         IFEQ      'CSW2018'                                                  CSW218
     C                   EVAL      CSW218 = 'Y'                                               CSW218
     C                   ELSE                                                                 CSW218
     C                   EVAL      CSW218 = 'N'                                               CSW218
     C                   ENDIF                                                                CSW218
      *
      ***  Key list definition
      *
     C     KBICF         KLIST
     C                   KFLD                    KREFKY
      *
     C     KCCDF         KLIST
     C                   KFLD                    KIBNKY
      *
     C                   ENDSR
      *
      /EJECT
      *****************************************************************
      *                                                               *
      * *PSSR  - Program exception error routine                      *
      *                                                               *
      * Called by: Called automatically if a program error occurs,    *
      *            or directly by the program code using EXSR.        *
      *            This subroutine DUMPs the program just once.       *
      *                                                               *
      * Calls: DBERRCTL                                               *
      *                                                               *
      *****************************************************************
      *
     C     *PSSR         BEGSR
      *
     C                   IF        RUN = *BLANK
     C                   EVAL      RUN = 'Y'
     C                   DUMP
      *
     C                   CALL      'DBERRCTL'
      *
     C                   ENDIF
      *
     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   EVAL      *INLR = *ON
     C                   RETURN
      *
     C                   ENDSR
      *
