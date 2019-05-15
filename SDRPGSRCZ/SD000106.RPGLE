     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2009')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas SD Retail Accnt/Authority Holder Link Maint')    *
      *****************************************************************
      *                                                               *
      *  Midas - Standing Data ILE Module                             *
      *                                                               *
      *  SD000106 - SD Retail Accnt/Authority Holder Link Maintenance *
      *             1st Screen                                        *
      *                                                               *
      *  (c) Finastra International Limited 2009                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      *  Prev Amend No. CRE075             Date 06Dec10               *
      *                 CER059             Date 19Jul10               *
      *                 BUG23995 *CREATE   Date 19May09               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CRE075 - Effective Date for Retail Accounts (Recompile)      *
      *  CER059 - German Feature Upgrade to Delhi                     *
      *  BUG23995 - Authority Holder/Retail account Link missing      *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  S U B R O U T I N E  I N D E X                               *
      *                                                               *
      *  SrLoadSfl - Subrotuine to Load Subfile                       *
      *  SrPgdn - Subrotuine to handle Pagedown                       *
      *  SrClr - Subrotuine to Clear Subfile and Reset Dsp Ind        *
      *  SrEntKy - Subrotuine to Process the Enter Key Pressed        *
      *  SrF03 - Subrotuine to Process the Exit form the Program      *
      *  SrF05 - Subrotuine to Process Refresh                        *
      *  SrF09 - Subrotuine to Process Insert through F9              *
      *  SrSflRc - Subrotuine to Process Changed Records              *
      *  SrDelete - Subrotuine to Process deletion of Records         *
      *  SrAmend - Subrotuine to Process Amendments of Records        *
      *  SrEnq - Subrotuine to Process Enquiring of Records           *
      *  SrCall105 - Subrotuine to Call Program SD000105              *
      *  SrClAccnt - Subrotuine to Call Accounts Acess Object         *
      *  SRRmvMsg - Subrotuine to Remove Messages                     *
      *  SRSndMsg - Subrotuine to Send Messages                       *
      *  SrValOpt - Subrotuine to Validate Option Taken               *
      *  *INZSR   - Program initialization routine                    *
      *    The *INZSR subroutine will only get called automatically   *
      *    on entry to the module the first time it is run            *
      *    (unless you end the program with LR on).  Similarly        *
      *    D-spec initialization only happens the first time.  Use    *
      *    RESET for subsequent passes.                               *
      *                                                               *
      *****************************************************************
      *
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
      *
      ** Screen 1 File
      *
     FSD000106DFCF   E             WORKSTN
     F                                     SFILE(SD000106S0:SFLRN)
      *
      ** Accounts/Authority holder Link - Update index
      *
     FSDACAHL0  UF A E           K DISK    INFSR(*PSSR)
     F
      *
      ** Accounts/Authority holder Link - Retrieval index
      *
     FSDACAHL1  IF   E           K DISK    INFSR(*PSSR)
     F                                     RENAME(SDACAHD0:SDACAHD1)
      *****************************************************************
      /EJECT
      *****************************************************************
      *
      ** +--------------------------------------+
      ** ¦ D-specs                              ¦
      ** ¦ =========================            ¦
      ** +--------------------------------------+
      *
      ** +--------------------------------------+
      ** ¦ Automatically included D-specs       ¦
      ** ¦ ==============================       ¦
      ** +--------------------------------------+
      *
      ** The following /COPY line include (among others) the LDA layout
      ** and the copyright array definition:
      *
     D/COPY ZACPYSRC,STD_D_SPEC
      *
      ** The following /COPY line includes all the defined fields in
      ** the Program Status Data Structures.  They have meaningful
      ** names, prefixed by 'PS'.
      *
     D/COPY ZACPYSRC,PSDS
      *
      ** The following /COPY line includes the definitions for error and
      ** warning message arrays.
      *
     D/COPY ZACPYSRC,ERR_ARRAYS
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
      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
      *
     D WValOpt         S              1A   DIM(500)
     D WAccNoA         S             10A   DIM(500)
      *
      ** Message related fields
      *
     D PMsgFile        S             10A   INZ('SDUSRMSG')
     D PMsgId          S             10A
     D PMsgData        S             45A
      *
      ** External DS for Account details
      *
     D SDACCT        E DS                  EXTNAME(ACCNTAB)
      *
      ** External DS for Bank details
      *
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
      *
      ** Short DS used as parameter for access objects
      *
     D DSFDY         E DS                  EXTNAME(DSFDY)
      *
      ** DS 800 char Long to pass Access Object Details
      *
     D DSSDY         E DS                  EXTNAME(DSSDY)
      *
      ** DS for Calling SD000105
      *
     D PAramDs         DS
     D  DsRetl                 1     10
     D  DsCnum                11     16
     D  DsCucd                17     19
     D  DsAccd                20     29
     D  DsAcsq                30     31
     D  DsBrca                32     34
      *
      ** Parameters for access object programs
      *
     D PRtcd           S              7A
     D POptn           S              7A
     D PCust           S             10A
     D PStKey          S              7A
      *
     D PRetcd          S             10A
     D PActn           S              1A
     D PRetl           S             10A
     D PCnum           S              6A
     D PCucd           S              3A
     D PAccd           S              4A
     D PAcsq           S              2A
     D PBrca           S              3A
      *
     D Ix              S              3P 0
     D WErr            S              1A
     D WFirst          S              1A
     D Wset            S              1A
     D WCount          S              2P 0
     D SFLRN           S              4P 0
     D KAcno           S             10S 0
     D WAcno           S             10S 0
     D WAacno          S             10A
     D TmAcno          S             10A
     D TmPRrn          S              4P 0
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
      ** +--- Start of Main processing -------------------------------+
      ** ¦                                                            ¦
      ** ¦ Initial processing is performed automatically: the         ¦
      ** ¦ *inzsr is executed at program activation.                  ¦
      ** ¦                                                            ¦
      ** +------------------------------------------------------------+
      *
      *****************************************************************
      * MAIN PROCEDURE                                                *
      *****************************************************************
      *
      ** Perform Initial Load
      *
     C                   EXSR      SrClr
     C                   EXSR      SrLoadSfl
      *
      ** Perform until exit requested Using F03
      *
     C                   DOW       *IN03 = *OFF
      *
     C                   TIME                    DDTME
      *
     C                   WRITE     SD000106M1
     C                   WRITE     SD000106F0
     C                   EXFMT     SD000106C0
      *
      ** Process response
      *
     C                   SELECT
     C                   WHEN      *IN03 = *ON
     C                   EXSR      SrF03
      *
     C                   WHEN      *IN05 = *ON
     C                   EXSR      SrF05
      *
     C                   WHEN      *IN09 = *ON
     C                   EXSR      SrF09
      *
     C                   WHEN      *IN91 = *ON
     C                   EXSR      SrPgdn
      *
     C                   OTHER
     C                   EXSR      SrEntKy
      *
     C                   ENDSL
      *
     C                   IF        *IN03 <> *ON AND
     C                             *IN91 <> *ON AND
     C                             WErr <> 'Y'
     C                   EXSR      SRRmvMsg
     C                   EXSR      SrClr
     C                   EXSR      SrLoadSfl
     C                   ENDIF
      *
     C                   ENDDO
      *
      ** End of program
      *
     C                   EVAL      *INLR = *ON
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SrLoadSfl - Subrotuine to Load Subfile                       *
      *                                                               *
      *  Called by: SrPgdn, SrF05, SrSflRc, *INZSR                    *
      *                                                               *
      *  Calls: SRSndMsg                                              *
      *                                                               *
      *****************************************************************
      *
     C     SrLoadSfl     BEGSR
      *
      ** Read the Main file
      *
     C                   EVAL      WAcno = *ZEROS
     C                   READ      SDACAHL1                               98
      *
     C                   DOW       Wcount < 14 And
     C                             NOT %EOF(SDACAHL1)
      *
      ** If selection check for Account Number
      *
     C                   IF        SSACNO <> *BLANKS
      *
     C                   MOVE      AAACNO        WAacno
      *
     C                   CALL      'QCLSCAN'
     C                   PARM                    WAacno
     C                   PARM      10            STRLEN            3 0
     C                   PARM      1             STRSTR            3 0
     C                   PARM                    SSACNO
     C                   PARM      10            PATLEN            3 0
     C                   PARM      '1'           TRANS             1
     C                   PARM      '1'           TRIM              1
     C                   PARM      ' '           WILD              1
     C                   PARM                    RESULT            3 0
      *
     C                   IF        RESULT < 1
     C                   GOTO      NEXT
     C                   ENDIF
      *
     C                   ENDIF
      *
      ** To keep unique accont numbers only
      *
     C                   IF        AAACNO = WAcno
     C                   GOTO      NEXT
     C                   ELSE
      *
      ** Move Database contents into subfile fields else move
      ** the previous stored selectoption from the screen.
      *
     C                   MOVE      AAACNO        DDACNO
     C                   EVAL      WACno = AAACNO
      *
     C                   EVAL      Ix = %LOOKUP(DDACNO:WAccNoA)
      *
     C                   IF        Ix <> *ZEROS
     C                   EVAL      DDSEL = WValOpt(Ix)
     C                   EVAL      *IN15 = *ON
     C                   ELSE
     C                   EVAL      DDSEL = *BLANKS
     C                   ENDIF
      *
      ** Reset before loading
      *
     C                   EVAL      DDCUST = *BLANKS
     C                   EVAL      DDBRCA = *BLANKS
     C                   EVAL      DDCCY  = *BLANKS
     C                   EVAL      DDACOD = *BLANKS
     C                   EVAL      DDACSQ = *BLANKS
      *
     C                   EVAL      PRetl = DDACNO
     C                   EXSR      SrClAccnt
      *
     C                   IF        PRtcd = *BLANKS
      *
     C                   MOVE      CNUM          DDCUST
     C                   EVAL      DDBRCA = BRCA
     C                   EVAL      DDCCY = CCY
     C                   MOVE      ACOD          DDACOD
     C                   MOVE      ACSQ          DDACSQ
      *
     C                   ENDIF
      *
     C                   ADD       1             WCount
     C                   ADD       1             SFLRN
     C                   WRITE     SD000106S0
     C                   EVAL      *IN15 = *OFF
      *
     C                   ENDIF
      *
     C     NEXT          TAG
      *
     C                   READ      SDACAHL1                               98
      *
     C                   ENDDO
      *
      ** If no records were added to subfile, set error indicators.
      *
     C     SFLRN         IFEQ      *ZEROS
     C                   EVAL      *IN42 = *OFF
      *
     C                   IF        SSACNO = *BLANKS
     C                   EVAL      *IN43 = *OFF
     C                   ELSE
     C                   EVAL      *IN43 = *ON
     C                   ENDIF
      *
     C                   EVAL      *IN97 = *ON
     C                   EVAL      PMsgId = 'USR3969'
     C                   EXSR      SRSndMsg
     C                   ELSE
      *
      ** Else, set indicators to display subfile.
      *
     C                   EVAL      *IN42 = *ON
     C                   EVAL      *IN43 = *ON
     C                   EVAL      TmAcno = DDACNO
     C                   EVAL      TmPRrn  = SFLRN
     C                   ENDIF
      *
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SrPgdn - Subrotuine to handle Pagedown                       *
      *                                                               *
      *  Called by: MAIN Processing                                   *
      *                                                               *
      *  Calls: None                                                  *
      *                                                               *
      *****************************************************************
      *
     C     SrPgdn        BEGSR
      *
      ** Only do if not EOF
      *
     C     *IN98         IFEQ      *OFF
      *
      ** Continue with record after the last one read.
      *
     C                   IF        (SSACNO <> *BLANKS AND
     C                             WErr = 'N') OR
     C                             SSACNO = *BLANKS
      *
     C                   EVAL      WCount = *ZEROS
     C                   MOVE      TmAcno        KAcno
     C                   EVAL      SFLRN = TmPRrn
     C     KAcno         SETGT     SDACAHL1
     C                   EXSR      SrLoadSfl
      *
      ** Set cursor position to first record on next page
      *
     C                   EVAL      DDSFRC = SFLRN - WCount
     C                   EVAL      DDSFRC = DDSFRC + 1
      *
     C                   ENDIF
      *
     C                   ENDIF
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SrClr - Subrotuine to Clear Subfile and Reset Dsp Ind        *
      *                                                               *
      *  Called by: SrF05, SrSflRc, *INZSR                            *
      *                                                               *
      *  Calls: None                                                  *
      *                                                               *
      *****************************************************************
      *
     C     SrClr         BEGSR
      *
     C                   EVAL      WCount = *ZEROS
     C                   EVAL      SFLRN = *ZEROS
     C                   EVAL      Ix = *ZEROS
     C                   EVAL      DDSFRC = 1
     C                   EVAL      WErr= 'N'
      *
      ** Clear subfile and reset subfile display indicator.
      *
     C                   EVAL      *IN42 = *OFF
     C                   EVAL      *IN40 = *ON
     C                   WRITE     SD000106C0
     C                   EVAL      *IN40 = *OFF
      *
     C     *LOVAL        SETLL     SDACAHL1
      *
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SrEntKy - Subrotuine to Process the Enter Key Pressed        *
      *                                                               *
      *  Called by: MAIN Processing                                   *
      *                                                               *
      *  Calls: SrSflRc                                               *
      *                                                               *
      *****************************************************************
      *
     C     SrEntKy       BEGSR
      *
      ** Process subfile records, if any thing is Displayed
      *
     C                   IF        *IN42 = *ON
     C                   EXSR      SrSflRc
     C                   ENDIF
      *
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SrF03 - Subrotuine to Process the Exit form the Program      *
      *                                                               *
      *  Called by: MAIN Processing                                   *
      *                                                               *
      *  Calls: None                                                  *
      *                                                               *
      *****************************************************************
      *
     C     SrF03         BEGSR
      *
     C                   EVAL      *INLR = *ON
      *
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SrF05 - Subrotuine to Process Refresh                        *
      *                                                               *
      *  Called by: MAIN Processing, SrF09                            *
      *                                                               *
      *  Calls: SRRmvMsg, SrClr, SrLoadSfl                            *
      *                                                               *
      *****************************************************************
     C     SrF05         BEGSR
      *
      ** Remove previous error messages
      *
     C                   EXSR      SRRmvMsg
      *
      ** Set off error indicators
      *
     C                   EVAL      SSACNO = *BLANKS
     C                   EVAL      WValOpt = *BLANKS
     C                   EVAL      WAccNoA = *BLANKS
     C                   EVAL      *IN32 = *OFF
     C                   EVAL      *IN34 = *OFF
     C                   EXSR      SrClr
     C                   EXSR      SrLoadSfl
      *
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SrF09 - Subrotuine to Process Insert through F9              *
      *                                                               *
      *  Called by: MAIN Processing                                   *
      *                                                               *
      *  Calls: SRRmvMsg, SrF05, SrClAccnt, SRSndMsg, SrCall105       *
      *                                                               *
      *****************************************************************
      *
     C     SrF09         BEGSR
      *
     C                   EVAL      *IN12 = *OFF
     C                   EVAL      *IN33 = *OFF
     C                   EVAL      DTACNO = *BLANKS
     C                   EVAL      PRetl = *BLANKS
     C                   EVAL      WSet = 'N'
     C                   EVAL      KAcno = *ZEROS
     C                   EXSR      SRRmvMsg
      *
     C                   DOW       *IN12 = *OFF AND
     C                             *IN03 = *OFF AND
     C                             WSet = 'N'
     C                   WRITE     SD000106M1
     C                   WRITE     SD000106F0
     C                   EXFMT     SD000106D0
      *
     C                   EXSR      SRRmvMsg
      *
     C                   SELECT
      *
     C                   WHEN      *IN12 = *ON
     C                   EXSR      SrF05
      *
     C                   WHEN      *IN03 = *ON
     C                   EVAL      DTACNO = *BLANKS
     C                   EVAL      *IN33 = *OFF
      *
     C                   OTHER
      *
     C                   IF        DTACNO <> *BLANKS
      *
      ** Validate account  number entered
      *
     C                   EVALR     PRetl = %TRIMR(DTACNO)
     C                   MOVE      PRetl         KAcno
      *
     C                   EXSR      SrClAccnt
      *
     C                   IF        PRTCD = *BLANKS
      *
      ** Check if record already present in SDACAHPD
      *
     C                   MOVE      PRetl         KAcno
     C     KAcno         CHAIN     SDACAHL0
     C                   IF        %FOUND(SDACAHL0)
      *
     C                   EVAL      PMsgId = 'SCC0022'
     C                   EXSR      SRSndMsg
     C                   EVAL      *IN33 = *ON
     C                   EVAL      WSet = 'N'
      *
     C                   ELSE
      *
     C                   IF        K24C <> 'Y'
      *
     C                   EVAL      PMsgId = 'USR9936'
     C                   EXSR      SRSndMsg
     C                   EVAL      *IN33 = *ON
     C                   EVAL      WSet = 'N'
      *
     C                   ELSE
      *
     C                   MOVE      KAcno         DsRetl
     C                   MOVE      CNUM          DsCnum
     C                   MOVE      CCY           DsCucd
     C                   MOVE      ACOD          DsAccd
     C                   MOVE      ACSQ          DsAcsq
     C                   MOVE      BRCA          DsBrca
      *
      ** Insert Record to SDACAHPD
      *
     C                   EVAL      PActn = 'I'
      *
      ** Call further to add other details
      *
     C                   EXSR      SrCall105
      *
     C                   EVAL      WSet = 'Y'
     C                   ENDIF
      *
     C                   ENDIF
      *
     C                   ELSE
      *
      ** Its an invalid account
      *
     C                   EVAL      PMsgId = 'USR0281'
     C                   EXSR      SRSndMsg
     C                   EVAL      *IN33 = *ON
     C                   EVAL      WSet = 'N'
      *
     C                   ENDIF
      *
     C                   ELSE
      *
      ** Value Required
      *
     C                   EVAL      PMsgId = 'USR0220'
     C                   EXSR      SRSndMsg
     C                   EVAL      *IN33 = *ON
     C                   EVAL      WSet = 'N'
      *
     C                   ENDIF
      *
     C                   ENDSL
      *
     C                   ENDDO
      *
     C                   EVAL      *IN09 = *OFF
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SrSflRc - Subrotuine to Process Changed Records              *
      *                                                               *
      *  Called by: SrEntKy                                           *
      *                                                               *
      *  Calls: SRRmvMsg, SrValOpt, SrClAccnt, SrDelete, SrAmend      *
      *         SrEnq, SrClr, SrLoadSfl                               *
      *                                                               *
      *****************************************************************
      *
     C     SrSflRc       BEGSR
      *
      * Remove previous error messages
      *
     C                   EXSR      SRRmvMsg
      *
      * Set off error indicators
      *
     C                   EVAL      WErr = 'N'
     C                   EVAL      WFirst = 'N'
     C                   EVAL      Ix = 1
     C                   EVAL      *IN32 = *OFF
     C                   EVAL      *IN34 = *OFF
     C                   EVAL      WValOpt = *BLANKS
     C                   EVAL      WAccNoA = *BLANKS
     C                   EVAL      PRetcd = *BLANKS
      *
      ** Read changed subfile records to end if sub file not empty
      *
     C                   READC     SD000106S0                             95
      *
     C                   DOW       *IN95 = *OFF
     C                   EXSR      SrValOpt
     C                   READC     SD000106S0                             95
     C                   ENDDO
      *
     C                   IF        WErr = 'N'
      *
     C                   EVAL      Ix = 1
      *
     C                   DOW       WValOpt(Ix) <> *BLANKS AND
     C                             PRetcd = *BLANKS
      *
     C                   EVAL      DDACNO = WAccNoA(Ix)
     C                   EVAL      DDSEL = WValopt(Ix)
     C                   EVAL      PRetl = WAccNoA(Ix)
      *
     C                   EXSR      SrClAccnt
      *
     C                   MOVE      PRetl         DsRetl
     C                   MOVE      CNUM          DsCnum
     C                   MOVE      CCY           DsCucd
     C                   MOVE      ACOD          DsAccd
     C                   MOVE      ACSQ          DsAcsq
     C                   MOVE      BRCA          DsBrca
      *
     C                   SELECT
      *
     C                   WHEN      DDSEL = 'D'
     C                   EXSR      SrDelete
      *
     C                   WHEN      DDSEL = 'A'
     C                   EXSR      SrAmend
      *
     C                   WHEN      DDSEL = 'E'
     C                   EXSR      SrEnq
      *
     C                   ENDSL
      *
     C                   EVAL      WValOpt(Ix) = *BLANKS
     C                   EVAL      WAccNoA(Ix) = *BLANKS
      *
     C                   EVAL      Ix = Ix + 1
      *
     C                   ENDDO
      *
     C                   ENDIF
      *
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SrDelete - Subrotuine to Process deletion of Records         *
      *                                                               *
      *  Called by: SrSflRc                                           *
      *                                                               *
      *  Calls: None                                                  *
      *                                                               *
      *****************************************************************
      *
     C     SrDelete      BEGSR
      *
      ** Retrieve relevant record to be deleted
      *
     C                   MOVE      DDACNO        KAcno
     C     KAcno         SETLL     SDACAHL0
     C     KAcno         READE     SDACAHL0                               16
     C                   DOW       *IN16 = *OFF
     C                   DELETE    SDACAHD0
     C     KAcno         READE     SDACAHL0                               16
     C                   ENDDO
      *
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SrAmend - Subrotuine to Process Amendments of Records        *
      *                                                               *
      *  Called by: SrSflRc                                           *
      *                                                               *
      *  Calls: SrCall105                                             *
      *                                                               *
      *****************************************************************
      *
     C     SrAmend       BEGSR
      *
      ** Amend the selected record
      *
     C                   EVAL      PActn = 'A'
     C                   EXSR      SrCall105
      *
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SrEnq - Subrotuine to Process Enquiring of Records           *
      *                                                               *
      *  Called by: SrSflRc                                           *
      *                                                               *
      *  Calls: SrCall105                                             *
      *                                                               *
      *****************************************************************
      *
     C     SrEnq         BEGSR
      *
      ** Enquiry the selected record
      *
     C                   EVAL      PActn = 'E'
     C                   EXSR      SrCall105
      *
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SrCall105 - Subrotuine to Call Program SD000105              *
      *                                                               *
      *  Called by: SrF09, SrAmend, SrEnq                             *
      *                                                               *
      *  Calls: None                                                  *
      *                                                               *
      *****************************************************************
      *
     C     SrCall105     BEGSR
      *
     C                   CALL      'SD000105'
     C                   PARM      *BLANKS       PRetcd
     C                   PARM                    PActn
     C                   PARM                    PAramDs
      *
     C                   IF        PRetcd = '*END'
     C                   EVAL      *IN03 = *ON
     C                   ELSEIF    PRetcd = '*PRV'
     C                   EVAL      *IN12 = *ON
     C                   ELSEIF    PRetcd = *BLANKS
     C                   EVAL      *IN03 = *OFF
     C                   EVAL      *IN12 = *OFF
     C                   ENDIF
      *
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SrClAccnt - Subrotuine to Call Accounts Acess Object         *
      *                                                               *
      *  Called by: SrF09, SrSflRc, SrValOpt                          *
      *                                                               *
      *  Calls: None                                                  *
      *                                                               *
      *****************************************************************
      *
     C     SrClAccnt     BEGSR
      *
     C                   CALL      'AOACCTR0'
     C                   PARM      *BLANKS       PRtcd
     C                   PARM      '*KEY    '    POptn
     C                   PARM                    PRetl
     C                   PARM      *BLANKS       PCnum
     C                   PARM      *BLANKS       PCucd
     C                   PARM      *BLANKS       PAccd
     C                   PARM      *BLANKS       PAcsq
     C                   PARM      *BLANKS       PBrca
     C     SDACCT        PARM      SDACCT        DSSDY
      *
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRRmvMsg - Subrotuine to Remove Messages                     *
      *                                                               *
      *  Called by: SrF05, SrF09, SrSflRc                             *
      *                                                               *
      *  Calls: None                                                  *
      *                                                               *
      *****************************************************************
      *
     C     SRRmvMsg      BEGSR
      *
     C                   CALL      'ZA0250'
      *
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRSndMsg - Subrotuine to Send Messages                       *
      *                                                               *
      *  Called by: SrLoadSfl, SrF09, SrValOpt                        *
      *                                                               *
      *  Calls: None                                                  *
      *                                                               *
      *****************************************************************
      *
     C     SRSndMsg      BEGSR
      *
      ** If no message file specified, use the default message file
      *
     C                   CALL      'ZA0350'
     C                   PARM                    PMsgFile
     C                   PARM                    PMsgId
     C                   PARM      *BLANKS       PMsgData
      *
     C                   EVAL      PMsgId = *BLANKS
      *
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SrValOpt - Subrotuine to Validate Option Taken               *
      *                                                               *
      *  Called by: SrSflRc                                           *
      *                                                               *
      *  Calls: SRSndMsg, SrClAccnt                                   *
      *                                                               *
      *****************************************************************
      *
     C     SrValOpt      BEGSR
      *
      ** Only action codes 'D' 'E' and 'A' allowed
      *
     C                   IF        DDSEL <> 'D' AND
     C                             DDSEL <> 'E' AND
     C                             DDSEL <> 'A' AND
     C                             DDSEL <> *BLANKS
      *
     C                   EVAL      PMsgId = 'SCC0013'
     C                   EXSR      SRSndMsg
     C                   EVAL      *IN32 = *ON
     C                   EVAL      WErr = 'Y'
      *
     C                   ENDIF
      *
      ** In Case of Amend, check if the account is still there
      ** If present check if K24C id set to 'Y' for this account
      *
     C                   IF        DDSEL = 'A' OR DDSEL = 'E'
      *
     C                   EVAL      PRetl = DDACNO
     C                   EXSR      SrClAccnt
      *
     C                   IF        PRTCD = *BLANKS
      *
     C                   IF        K24C <> 'Y'
     C                   EVAL      PMsgId = 'USR9936'
     C                   EXSR      SRSndMsg
     C                   EVAL      *IN32 = *ON
     C                   EVAL      WErr = 'Y'
     C                   ENDIF
      *
     C                   ELSE
      *
     C                   EVAL      PMsgId = 'USR0286'
     C                   EXSR      SRSndMsg
     C                   EVAL      *IN32 = *ON
     C                   EVAL      *IN34 = *ON
     C                   EVAL      WErr = 'Y'
      *
     C                   ENDIF
      *
     C                   ENDIF
      *
     C                   IF        WFirst = 'N' AND
     C                             WErr = 'Y'
     C                   EVAL      DDSFRC = SFLRN
     C                   EVAL      WFirst = 'Y'
     C                   ENDIF
      *
     C                   IF        DDSEL <> *BLANKS
     C                   EVAL      WValopt(Ix) = DDSEL
     C                   EVAL      WAccNoA(Ix) = DDACNO
     C                   EVAL      Ix = Ix + 1
     C                   ENDIF
      *
     C                   EVAL      *IN15 = *ON
     C                   UPDATE    SD000106S0
     C                   EVAL      *IN15 = *OFF
      *
     C                   EVAL      *IN32 = *OFF
     C                   EVAL      *IN34 = *OFF
      *
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  *INZSR - Program initialisation routine                      *
      *                                                               *
      *  Called by: Implicitly on program activation                  *
      *                                                               *
      *  Calls: SrClr, SrLoadSfl                                      *
      *                                                               *
      *****************************************************************
      *
     C     *INZSR        BEGSR
      *
     C                   EVAL      DDUSR = PSUser
     C                   EVAL      DDPGM = PSProcName
     C                   EVAL      DDPRGM = PSProcName
     C                   EVAL      DDJOB = PSJobName
      *
      ** Call Access Program for Bank Details - Title, Run Date and
      ** Run Day Number.
      *
     C                   CALL      'AOBANKR0'
     C                   PARM      '*MSG   '     PRtcd
     C                   PARM      '*FIRST '     POptn
     C     SDBANK        PARM      SDBANK        DSFDY
      *
      ** Database Error.
      *
     C                   IF        PRtcd <> *BLANKS
      *
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE = 'SDBANKPD'
     C                   EVAL      DBASE = 1
     C                   EVAL      DBKEY = *BLANKS
     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   OUT       LDA
     C                   EXSR      *PSSR
      *
     C                   ENDIF
      *
     C                   EVAL      DDMRDT = BJMRDT
      *
      ** Miscellaneous subfile program variables
      *
     C                   EVAL      WCount = *ZEROS
     C                   EVAL      TmPRrn = *ZEROS
     C                   EVAL      TmAcno = *BLANKS
     C                   EVAL      WValOpt = *BLANKS
     C                   EVAL      WAccNoA = *BLANKS
      *
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      ** Program, module and procedure names for database error
      ** processing.
      *****************************************************************
      *
      ** The following /COPY sets these values, and also defines LDA as
      ** an external data area
      *
      /COPY ZACPYSRC,PSSR_ILE
      *****************************************************************
