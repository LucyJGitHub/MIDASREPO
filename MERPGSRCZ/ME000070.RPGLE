     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas ME MT942 Movements Enq for Spec Ntwrk Acnt')     *
      *****************************************************************
      *                                                               *
      *  Midas - Messages Management Module                           *
      *                                                               *
      *  ME000070 - Midas ME Movements Enquiry by Network Account and *
      *             Message Type                                      *
      *                                                               *
      *  (c) Finastra International Limited 2002                      *
      *                                                               *
      *  Last Amend No. CSD103             Date 10Aug20               *
      *  Prev Amend No. CMG008             Date 20Feb20               *
      *                 MD046248           Date 27Oct17               *
      *                 CRE075             Date 06Dec10               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CSD031             Date 10Apr06               *
      *                 CSD027             Date 09Dec05               *
      *                 CLE025             Date 20Oct03               *
      *                 CGL029             Date 01Sep03               *
      *                 CGL013  *CREATE    Date 08Apr02               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CSD103 - LIBOR Deregulation - Common Layer/Standing Data     *
      *           (Recompile)                                         *
      *  CMG008 - SWIFT Character Translation Table (Recompile)       *
      *  MD046248 - Finastra Rebranding                               *
      *  CRE075 - Effective Date for Retail Accounts (Recompile)      *
      *  CSD031 - Enhanced Centralised Static Data (Recompile)        *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CLE025 - Credit Lines (Recompile)                            *
      *  CGL029 - Increase Account Code to 10 digits                  *
      *  CGL013 - MT94x Messages Generation                           *
      *                                                               *
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+

     FME000070DFCF   E             WORKSTN INFSR(*PSSR)
     F                                     SFILE(ME000070S1:C1SFRN)
     F                                     SFILE(ME000070S2:C2SFRN)
     F                                     SFILE(ME000070S3:WLstRRN3)
      ** MT942 Movements Enquiry for a Specific Network Accnt Display File

     FGLNW94L5  IF   E           K DISK    INFSR(*PSSR)
      ** Midas GL Network Accounts - MT94x Live Network Accounts by Account
      ** and Destination

     FGLNWACL4  IF   E           K DISK    INFSR(*PSSR)
      ** Midas GL Network Accounts - MT94x Live Network Accounts by Account
      ** and Destination - Generating MT950

     FGLACBTL0  IF   E           K DISK    PREFIX(AC_)
      ** Midas GL Account Balances Today.

     FGLPOSTL0  IF   E           K DISK    INFSR(*PSSR)
      ** Midas GL Postings for MT94x Msg - by Value Date

     FGLPOSTL8  IF   E           K DISK    INFSR(*PSSR)
     F                                     RENAME(GLPOSTD0:GLPOSTD8)
      ** Midas GL Postings for MT94x Msg - by Posting Date

     FPRONO     IF   E           K DISK    INFSR(*PSSR)
     F                                     PREFIX(PR)
      ** Midas GL Projected Nostro Balances.

     FMEMOSM1   IF   E           K DISK    USROPN         INFSR(*PSSR)
     F                                     PREFIX(FM_)
      ** Midas FF Retail Shadow Balances

     FPRONOM1   IF   E           K DISK    USROPN         INFSR(*PSSR)
     F                                     PREFIX(FP_)
      ** Midas FF Projected Nostro Balances

      *****************************************************************
      /EJECT
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ Automatically included D-specs       ¦
      ** ¦ ==============================       ¦
      ** +--------------------------------------+

      ** The following /COPY line includes (among others) the LDA layout
      ** and the copyright array definition:

     D/COPY ZACPYSRC,STD_D_SPEC

      ** The following /COPY line includes all the defined fields in the
      ** Program Status Data Structures.  They have meaningful
      ** names, prefixed by 'PS'.

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

      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+

     D MMOD          E DS                  EXTNAME(MMODF)    DTAARA(MMOD)
     D                                                       PREFIX(Mo_)
      **  Data Structure for Midas SD Module

     D RUNDAT        E DS                  EXTNAME(RUNDAT)

     D SDBANK        E DS                  EXTNAME(SDBANKPD)
      ** External DS for Bank Details

     D SDCURR        E DS                  EXTNAME(SDCURRPD)
      ** External data structure for Currency Details

     D DsNWRK        E DS                  EXTNAME(SDNWRKPD)
      ** Network details record format data structure

     D MEMOS         E DS                  EXTNAME(MEMOS)    PREFIX(ME)
      **  Data Structure for RE Shadow Balances.

     D SDNOST        E DS                  EXTNAME(SDNOSTPD)
     D  QQACC1       E                     EXTFLD(QQACCD)                                     CGL029
      **  Data Structure for SD Nostro details.

     D DSFDY         E DS                  EXTNAME(DSFDY)
      ** Short Data Structure for Access Programs

     D DSSDY         E DS                  EXTNAME(DSSDY)
      ** Long Data Structure for Access Programs

     D DSLDY         E DS                  EXTNAME(DSLDY)
      ** DS (longest) used as output parameter for Access Objects

     D DsACCNT       E DS                  EXTNAME(ACCNTAB) PREFIX(AC_)
      ** External data structure for Account Details

     D GLMR94        E DS                  EXTNAME(GLMR94PD)
     D  QQACC2       E                     EXTFLD(QQACCD)                                     CGL029
      **  Data Structure for GL MT941/942 Messages Requests.

     D                 DS
     D***AccNumSel               1     18                                                     CGL029
     D AccNumSel               1     24                                                       CGL029
     D C1BRCA                  1      3
     D C1CNUM                  4      9
     D C1CCY                  10     12
     D***C1ACCD*                13     16                                                     CGL029
     D***C1ACSQ*                17     18                                                     CGL029
     D C1ACCD                 13     22                                                       CGL029
     D C1ACSQ                 23     24                                                       CGL029
     D*W_CNUM***               4      9  0                                                    CSD027
     D W_CNUM                  4      9                                                       CSD027
     D***W_ACCD*                13     16  0                                                  CGL029
     D***W_ACSQ*                17     18  0                                                  CGL029
     D W_ACCD                 13     22  0                                                    CGL029
     D W_ACSQ                 23     24  0                                                    CGL029

     D                 DS
     D***AccNumSel2              1     18                                                     CGL029
     D AccNumSel2              1     24                                                       CGL029
     D C2BRCA                  1      3
     D C2CNUM                  4      9
     D C2CCY                  10     12
     D***C2ACCD*                13     16                                                     CGL029
     D***C2ACSQ*                17     18                                                     CGL029
     D C2ACCD                 13     22                                                       CGL029
     D C2ACSQ                 23     24                                                       CGL029

     D                 DS
     D***AccNumRed               1     18                                                     CGL029
     D AccNumRed               1     24                                                       CGL029
     D N4BRCA                  1      3
     D*N4CNUM***               4      9  0                                                    CSD027
     D N4CNUM                  4      9                                                       CSD027
     D N4CCY                  10     12
     D***N4ACCD*                13     16  0                                                  CGL029
     D***N4ACSQ*                17     18  0                                                  CGL029
     D N4ACCD                 13     22  0                                                    CGL029
     D N4ACSQ                 23     24  0                                                    CGL029

     D                 DS
     D***AccNumKey               1     18                                                     CGL029
     D AccNumKey               1     24                                                       CGL029
     D KBRCA                   1      3
     D*KCNUM****               4      9  0                                                    CSD027
     D KCNUM                   4      9                                                       CSD027
     D KCCY                   10     12
     D***KACCD**                13     16  0                                                  CGL029
     D***KACSQ**                17     18  0                                                  CGL029
     D KACCD                  13     22  0                                                    CGL029
     D KACSQ                  23     24  0                                                    CGL029

     D                 DS
     D***AccNumEnt               1     18                                                     CGL029
     D AccNumEnt               1     24                                                       CGL029
     D F0BRCA                  1      3
     D WCnum                   4      9
     D F0CCY                  10     12
     D***F0ACCD*                13     16                                                     CGL029
     D***F0ACSQ*                17     18                                                     CGL029
     D F0ACCD                 13     22                                                       CGL029
     D F0ACSQ                 23     24                                                       CGL029
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+

      ** Parameters for ZAMSGTOSCN
     D PZMsgFile       S             10A
     D PZMsgID         S              7A
     D PZMsgDta        S             45A
     D PZMsgPgm        S             10A
     D PZMsgMod        S             10A
     D PZMsgProc       S             10A

      ** Parameter for SDRTVTXT
     D PMsgDNb         S              7A
     D PMsgNm          S             10A
     D PMsgTxt         S             80A

      ** Parameters for Access Objects
     D PRtCd           S              7A
     D POptn           S              7A
     D PRetl           S             10A
     D PCnum           S              6A
     D PCucd           S              3A
     D***PAccd*          S              4A                                                    CGL029
     D PAccd           S             10A                                                      CGL029
     D PAcsq           S              2A
     D PBrca           S              3A
     D PNwrk           S              6A
     D PRetlN          S             10  0
     D*PCnumN***       S              6  0                                                    CSD027
     D PCnumN          S              6                                                       CSD027
     D***PAccdN*         S              4  0                                                  CGL029
     D PAccdN          S             10  0                                                    CGL029
     D PAcsqN          S              2  0
     D PNonb           S              2A
     D PCssn           S             10A
     D PPnoi           S              1A

      ** Parameters for ZVACTBU/ZVACTU
     D PZAction        S              1A
     D PBrCde          S              3A
     D PError          S              1P 0

      ** Parameters for ZDATE1 and ZDATE2
     D PZDateA         S              6A
     D PZDayNo         S              5P 0
     D PZADate         S              7A
     D PZDatFmt        S              1A
     D PZDate          S              6P 0
     D PErrorFlag      S              1A

      ** Parameters for ZSEDIT fields
     D PZFld15         S             15  0
     D PZFld15_2       S             15  0
     D PZDecPl         S              1  0
     D PZECode         S              1
     D PZOUT21         S             21

      ** Work fields
     D WNoData1        S              1A
     D WLstRRN1        S              4P 0
     D WLstRRN2        S              4P 0
     D WLstRRN3        S              4P 0
     D WSflPag1        S              5P 0 INZ(12)
     D WSflPag2        S              5P 0 INZ(9)
     D WSflPag3        S              5P 0 INZ(8)
     D WCounter        S              5P 0
     D WPrevNWRK       S              6A
     D WPrAccNums      S             18A
     D WPrevACNO       S             10A
     D WPrevNATY       S              1A
     D WPrevDSTN       S             11A
     D WPrevPSTD       S              7A
     D WPrevVALD       S              7A
     D WSavVALD        S              5P 0
     D WResetFld       S              1A
     D WResetFld3      S              1A
     D WValid          S              1A
     D W_ACNO          S             10A
     D WFrmInit1       S              1A
     D WFrmInit2       S              1A
     D WkATYP          S              1A
     D WkLDBL          S             15P 0
     D WkCLBL          S             15P 0
     D WfBRCA          S              3A                                        Branch Code
     D*WfCNUM****      S              6S 0                                    Customer Number CSD027
     D WfCNUM          S              6A                                        Customer Numb CSD027
     D WfCCY           S              3A                                        Currency
     D***WfACOD          S              4S 0                                                  CGL029
     D WfACOD          S             10S 0                                                    CGL029
     D WfACSQ          S              2S 0                                      Account Sequence

     D ProjNostBal     S             15P 0 BASED(Pointer1)
     D  Pointer1       S               *   INZ(%Addr(PRPNB))

      ** Fields used to define Key Lists
     D KNwrk           S              6A
     D KNaty           S              1A
     D KDstn           S             11A
     D KMgtp           S              3A
     D KPstd           S              5P 0
     D KVald           S              5P 0

     D WkNostNumb      S              2S 0 BASED(Pointer2)
     D  Pointer2       S               *   INZ(%Addr(A7NONB))

      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+

      *****************************************************************
      /EJECT
      *****************************************************************
      ** +--- Start of Main processing -----------------------------------+
      ** ¦                                                                ¦
      ** ¦ Initial processing is performed automatically: the *INZSR is   ¦
      ** ¦ executed at program activation.                                ¦
      ** ¦                                                                ¦
      ** +----------------------------------------------------------------+

     C                   DOW       *INKC = *OFF

      ** Display the Initial Screen

     C                   EXSR      SRInitScn

     ** If F3 was pressed

     C     *INKC         CASEQ     *ON           SrEnd

     ** If F5 was pressed

     C     *INKE         CASEQ     *ON           SrRefresh

     ** If F15 was pressed

     C     *INKP         CASEQ     *ON           SrProcSfl1

     C                   CAS                     SrValdInit
     C                   ENDCS

     C                   ENDDO

      *****************************************************************
      /EJECT
      *****************************************************************
      *  SrChckAut - Check For User Authority If Not Multi-branching  *
      *****************************************************************
     C     SrChckAut     BEGSR

     C                   CALL      'ZVACTU'
     C                   PARM      'E'           PZAction
     C                   PARM      *ZERO         PError

      ** Return Error Message

     C                   IF        PError = 1
     C                   EVAL      PZMsgID='MIN0147'
     C                   EVAL      WValid = 'N'
     C                   EVAL      PZMsgFile = 'MEMSG'
     C                   EXSR      SrZaSnms
     C                   RETURN
     C                   ENDIF

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *  SrInitScn - Display the Initial Screen                       *
      *****************************************************************
     C     SrInitScn     BEGSR

      ** Initialize.

     C                   IF        WValid = 'Y'
     C                   EXSR      SRRefresh
     C                   EXSR      SRRefres1
     C                   EXSR      SRRefres2
     C                   ENDIF

     C                   WRITE     #MSGCTL
     C                   EXFMT     ME000070F0

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *  SrProcSfl1 - Build Subfile for Network Account Selection     *
      *****************************************************************
     C     SrProcSfl1    BEGSR

      ** Do While not CMD-3 and CMD-12.

     C                   DOW       *INKC = *OFF AND *INKL = *OFF

      ** Initialise and load subfile page

     C                   EXSR      SrSbfInz1

      ** Initialise reset field

     C                   EVAL      WResetFld = 'N'

     C                   DOW       WResetFld = 'N'

      ** Display the Subfile Screen

     C                   EXSR      SrDspSfl1

      ** Perform detailed processing

      ** F3 = Exit

     C     *INKC         CASEQ     *ON           SrEnd

      ** F12 = Cancel

     C     *INKL         CASEQ     *ON           SrCancl1

      ** F5 = Refresh

     C     *INKE         CASEQ     *ON           SrRefres1

      ** Rollup/Rolldown

     C     *IN51         CASEQ     *ON           SrLoad1

      ** Process the subfile's action codes

     C                   CAS                     SrProcSel1
     C                   ENDCS

     C                   ENDDO
     C                   ENDDO

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *  SrSbfInz1 - Subfile initialisation and load routine          *
      *****************************************************************
     C     SrSbfInz1     BEGSR

     C                   EVAL      *IN52 = *OFF
     C                   WRITE     ME000070C1
     C                   EVAL      *IN52 = *ON

     C                   Z-ADD     *ZERO         WLstRRN1

      ** Set GL Network Accounts to appropriate record

     C     *LOVAL        SETLL     GLNW94D0

     C                   IF        C1NWRK <> *BLANKS

     C                   IF        WValid = 'N'
     C                   EXSR      SrClearMsgQ
     C                   ENDIF
     C                   EVAL      KNwrk = C1NWRK
     C     KNwrk         SETLL     GLNW94D0
     C                   ENDIF

     C                   EVAL      WPrevNWRK = C1NWRK
     C                   EVAL      WPrAccNumS = AccNumSel
     C                   EVAL      WPrevNATY = C1NATY
     C                   EVAL      WPrevACNO = C1ACNO
     C                   EVAL      WPrevDSTN = C1DSTN

      ** Load Subfile Page

     C                   EXSR      SrLoad1

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *  SrLoad1- Load one page of subfile                            *
      *****************************************************************
     C     SrLoad1       BEGSR

      ** Set subfile record load counter to 0.

     C                   Z-ADD     0             WCounter
     C                   Z-ADD     WLstRRN1      C1SFRN
     C                   EVAL      S1SELE = *BLANKS

      ** Loads a subfile page

     C                   READ      GLNW94D0                               80
     C
     C                   DOW       *IN80 = *OFF AND WCounter < WSflPag1

     C                   EVAL      PError = *ZERO

     C                   IF        BJSBRC = *BLANKS
     C                   EVAL      PBrCde = N4BRCA
     C                   CALL      'ZVACTBU'
     C                   PARM      'E'           PZAction
     C                   PARM                    PBrCde
     C                   PARM      *ZERO         PError
     C                   ENDIF

     C                   IF        PError = *ZERO
     C                   MOVEL     N4CNUM        PCNUM
     C                   MOVEL     N4ACCD        PACCD
     C                   MOVEL     N4ACSQ        PACSQ

     C                   CALL      'AOACCTR0'
     C                   PARM      *Blanks       PRtCd
     C                   PARM      '*KEY'        POptn
     C                   PARM      *Blanks       PRetl
     C                   PARM                    PCnum
     C                   PARM      N4CCY         PCucd
     C                   PARM                    PAccd
     C                   PARM                    PAcsq
     C                   PARM      N4BRCA        PBrca
     C     DsACCNT       PARM                    DSSDY

     C                   IF        PRtcd <> *BLANKS
     C     *LOCK         IN        LDA
     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   EVAL      DBFILE =  'ACCNTAB'
     C                   EVAL      DBASE  =  002
     C                   EVAL      DBPROC =  'SR/SrLoad1'
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF

      ** Retrieve balance at the beginning of the day. If it does not exist,
      ** the program uses the current one. (same fields names).

     C     KAcBlTd       CHAIN     GLACBTL0                           99

     C                   MOVEL     AC_ACNO       W_ACNO
     C                   IF            (C1BRCA = *BLANKS or C1BRCA = N4BRCA)
     C                             AND (C1CNUM = *BLANKS or W_CNUM = N4CNUM)
     C                             AND (C1CCY  = *BLANKS or C1CCY  = N4CCY )
     C                             AND (C1ACCD = *BLANKS or W_ACCD = N4ACCD)
     C                             AND (C1ACSQ = *BLANKS or W_ACSQ = N4ACSQ)
     C                             AND (C1NATY = *BLANKS or C1NATY = N4NATY)
     C                             AND (C1ACNO = *BLANKS or C1ACNO = W_ACNO)
     C                             AND (C1DSTN = *BLANKS or C1DSTN = N4DSTN)
     C                   EXSR      SrClrSFld1
     C                   EXSR      SrMovSFld1

     C                   ADD       1             C1SFRN
     C                   ADD       1             WCounter

     C                   WRITE     ME000070S1
     C                   ENDIF
     C                   ENDIF

     C                   READ      GLNW94D0                               80
     C                   ENDDO

     C                   IF        *IN80 = *OFF
     C                   READP     GLNW94D0                               80
     C                   ENDIF

      ** Save last relative record number to a workfield.

     C                   Z-ADD     C1SFRN        WLstRRN1
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *  SrDspSfl1 - Display Subfile Page                             *
      *****************************************************************
     C     SrDspSfl1     BEGSR

      ** If No Data to Display

     C                   IF        C1SFRN = *ZERO
     C                   EVAL      WNoData1 = 'Y'
     C                   EVAL      WValid = 'N'
     C                   EVAL      *IN50 = *OFF
     C                   EVAL      PZMsgID = 'Y2U0008'
     C                   EVAL      PZMsgFile = 'Y2USRMSG'
     C                   EXSR      SrZaSnms
     C                   ELSE
     C                   EVAL      WNoData1 = 'N'

      ** Seton SFLDSP

     C                   EVAL      *IN50 = *ON
     C                   ENDIF

      ** Sets up RollUp and SFLEND indicator according to EOF or not

     C                   IF        *IN80 = *ON
     C                   EVAL      *IN53 = *ON
     C                   ELSE
     C                   EVAL      *IN53 = *OFF
     C                   ENDIF

     C                   WRITE     #MSGCTL
     C                   WRITE     ME000070F1
     C                   EXFMT     ME000070C1

     C                   EXSR      SrClearMsgQ

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *  SrValdInit - Validation of Initial Screen                    *
      *****************************************************************
     C     SrValdInit    BEGSR

     ** Clear messages from program message queue

     C                   EXSR      SrClearMsgQ

      ** Set of error indicators

     C                   EVAL      *IN25 = *OFF
     C                   EVAL      *IN26 = *OFF
     C                   EVAL      *IN28 = *OFF
     C                   EVAL      *IN29 = *OFF
     C                   EVAL      *IN31 = *OFF
     C                   EVAL      *IN32 = *OFF

      ** Initialize.

     C                   EVAL      WValid = 'Y'
     C                   EVAL      WCnum = *BLANKS
     C                   MOVEL     F0CNUM        WCnum

      ** Network Id. Field is mandatory

     C                   IF        F0NWRK  = *Blanks
     C                   EVAL      PZMsgID = 'ME00034'
     C                   EVAL      *IN29 = *ON
     C                   ELSE

      ** The field must contain a live network id.

     C                   CALL      'AONWRKR1'
     C                   PARM      *Blanks       PRtCd
     C                   PARM      '*KEY'        POptn
     C                   PARM      F0NWRK        PNwrk
     C     DsNWRK        PARM                    DSLDY

     C                   IF        PRtCd <> *Blanks OR EDTYLC = 'D'
     C                   EVAL      PZMsgID = 'ME00035'
     C                   EVAL      *IN29 = *ON
     C                   ELSE
     C                   EVAL      C2NWRK = EDNWRK
     C                   ENDIF

     C                   ENDIF

      ** If an error was found

     C                   IF        *IN29 = *ON
     C                   EVAL      WValid = 'N'
     C                   EVAL      PZMsgFile = 'MEMSG'
     C                   EXSR      SrZaSnms
     C                   ENDIF

      ** Account Number is mandatory.

      ** Must be an existing live GL account or a Retail Account Number

     C                   IF        AccNumEnt = *BLANKS and F0CNUM  = *BLANKS
     C                   MOVE      'ME00034'     PZMsgId
     C                   EVAL      *IN25 = *ON
     C                   ELSE

     C                   IF        F0CCY = *BLANKS
     C                             AND F0ACCD  = *BLANKS
     C                             AND F0ACSQ  = *BLANKS
     C                             AND F0BRCA  = *BLANKS
     C                             AND %SUBST(F0CNUM :7:4)<>*BLANKS
     C                   CALL      'AOACCTR0'
     C                   PARM      *Blanks       PRtCd
     C                   PARM      '*KEY'        POptn
     C                   PARM      F0CNUM        PRetl
     C                   PARM      *Blanks       PCnum
     C                   PARM      *Blanks       PCucd
     C                   PARM      *Blanks       PAccd
     C                   PARM      *Blanks       PAcsq
     C                   PARM      *Blanks       PBrca
     C     DsACCNT       PARM                    DSSDY

     C                   IF        PRtCd <> *Blanks OR AC_RECI <> 'D'
     C                   EVAL      PZMsgID = 'ME00038'
     C                   EVAL      *IN25 = *ON
     C                   ENDIF

     C                   ELSE
     C                   CALL      'AOACCTR0'
     C                   PARM      *Blanks       PRtCd
     C                   PARM      '*KEY'        POptn
     C                   PARM      *Blanks       PRetl
     C                   PARM      F0CNUM        PCnum
     C                   PARM      F0CCY         PCucd
     C                   PARM      F0ACCD        PAccd
     C                   PARM      F0ACSQ        PAcsq
     C                   PARM      F0BRCA        PBrca
     C     DsACCNT       PARM                    DSSDY

     C                   IF        PRtCd <> *Blanks OR AC_RECI <> 'D'
     C                   EVAL      PZMsgID = 'ME00037'
     C                   EVAL      *IN25 = *ON
     C                   ENDIF

     C                   ENDIF
     C                   ENDIF

      ** If an error was found

     C                   IF        *IN25= *ON
     C                   EVAL      WValid = 'N'
     C                   EVAL      PZMsgFile = 'MEMSG'
     C                   EXSR      SrZaSnms
     C                   ENDIF

      ** Posting Date

     C                   IF        F0PSTD  <> *BLANKS
     C                   EVAL      PZDateA = F0PSTD
     C                   EXSR      SRZDate1
     C                   IF        PErrorFlag = 'Y'
     C                   EVAL      PZMsgID='ME00047'
     C                   EVAL      *IN26 = *ON
     C                   EVAL      WValid = 'N'
     C                   EVAL      PZMsgFile = 'MEMSG'
     C                   EXSR      SrZaSnms
     C                   ELSE
     C                   EVAL      KPstd = PZDayNo
     C                   ENDIF
     C                   ENDIF

      ** Destination. Field is mandatory

     C                   IF        F0DSTN  = *Blanks
     C                   EVAL      WValid = 'N'
     C                   EVAL      PZMsgID = 'ME00034'
     C                   EVAL      *IN28 = *ON
     C                   EVAL      PZMsgFile = 'MEMSG'
     C                   EXSR      SrZaSnms
     C                   ENDIF

      ** Network Account type is mandatory and must be 'S' or 'G'

     C                   IF        F0NATY  = *Blanks
     C                   EVAL      PZMsgID = 'ME00034'
     C                   EVAL      *IN31 = *ON
     C                   ELSE

     C                   IF        F0NATY  <> 'S' AND F0NATY  <> 'G'
     C                   EVAL      PZMsgID = 'ME00040'
     C                   EVAL      *IN31 = *ON
     C                   ENDIF

     C                   ENDIF

      ** If an error was found

     C                   IF        *IN31 = *ON
     C                   EVAL      WValid = 'N'
     C                   EVAL      PZMsgFile = 'MEMSG'
     C                   EXSR      SrZaSnms
     C                   ENDIF

      ** Message Type field is mandatory

     C                   IF        F0MGTP = *Blanks
     C                   EVAL      PZMsgID = 'ME00034'
     C                   EVAL      *IN32 = *ON
     C                   ELSE

      ** The field must contain a valid message type

     C                   IF        F0MGTP <> '940' AND
     C                             F0MGTP <> '941' AND F0MGTP <> '942'
     C                   EVAL      PZMsgID = 'ME00134'
     C                   EVAL      *IN32 = *ON
     C                   ENDIF

     C                   ENDIF

      ** If an error was found

     C                   IF        *IN32 = *ON
     C                   EVAL      WValid = 'N'
     C                   EVAL      PZMsgFile = 'MEMSG'
     C                   EXSR      SrZaSnms
     C                   ENDIF

      ** Process the request if all is O.K.

     C                   IF        WValid = 'Y'

      ** Retrieve balance at the beginning of the day. If it does not exist,
      ** the program uses the current one. (same fields names).
     C     KAcBlTd       CHAIN     GLACBTL0                           99

     C                   EVAL      WkATYP = AC_ATYP
     C                   EVAL      WkLDBL = AC_LDBL
     C                   EVAL      WkCLBL = AC_CLBL
     C                   EXSR      SRDetIni
     C                   ENDIF

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *  SrMovSFld1- Move Record Fields to Subfile Fields             *
      *****************************************************************
     C     SrMovSFld1    BEGSR

      ** Network

     C                   EVAL      S1NWRK = N4NWRK

      ** Account Branch

     C                   EVAL      S1BRCA = N4BRCA

      ** Account Customer

     C                   MOVEL     N4CNUM        S1CNUM

      ** Account Currency

     C                   EVAL      S1CCY = N4CCY

      ** Account Code

     C                   MOVEL     N4ACCD        S1ACCD

      ** Account Sequence

     C                   MOVEL     N4ACSQ        S1ACSQ

      ** Account Type

     C                   EVAL      S1NATY = N4NATY

      ** Retail Number

     C                   MOVEL     AC_ACNO       S1ACNO

      ** MT94x Destination

     C                   EVAL      S1DSTN = N4DSTN

      ** Message type generation indicators

     C                   EVAL      S1G940 = N4G940
     C                   EVAL      S1G941 = N4G941
     C                   EVAL      S1G942 = N4G942

     C                   IF        S1G940 = *Blank
     C                   EVAL      S1G940 = 'N'
     C                   ENDIF

     C                   IF        S1G941 = *Blank
     C                   EVAL      S1G941 = 'N'
     C                   ENDIF

     C                   IF        S1G942 = *Blank
     C                   EVAL      S1G942 = 'N'
     C                   ENDIF

     C     KGlNwAc       SETLL     GLNWACD0

     C                   IF        %EQUAL(GLNWACL4)
     C                   EVAL      S1G950 = 'Y'
     C                   ELSE
     C                   EVAL      S1G950 = 'N'
     C                   ENDIF

      ** General Ledger Balances and Account type

     C                   EVAL      S1LDBL = AC_LDBL
     C                   EVAL      S1CLBL = AC_CLBL
     C                   EVAL      S1ATYP = AC_ATYP
     C                   EVAL      S1ANAM = AC_ANAM

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *  SRClrSFld1- Clear Subfile Fields Routine                     *
      *****************************************************************
     C     SRClrSFld1    BEGSR

     C                   EVAL      S1SELE = *BLANKS
     C                   EVAL      S1NWRK = *BLANKS
     C                   EVAL      S1BRCA = *BLANKS
     C                   EVAL      S1CNUM = *BLANKS
     C                   EVAL      S1CCY = *BLANKS
     C                   EVAL      S1ACCD = *BLANKS
     C                   EVAL      S1ACSQ = *BLANKS
     C                   EVAL      S1NATY = *BLANKS
     C                   EVAL      S1ACNO = *BLANKS
     C                   EVAL      S1DSTN = *BLANKS
     C                   EVAL      S1G950 = *BLANKS
     C                   EVAL      S1G940 = *BLANKS
     C                   EVAL      S1G941 = *BLANKS
     C                   EVAL      S1G942 = *BLANKS

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *  SrRefresh - Initialise the 1st Screen Fields to Blanks       *
      *****************************************************************
     C     SrRefresh     BEGSR

     C                   EVAL      F0NWRK = *BLANKS
     C                   EVAL      F0CNUM = *BLANKS
     C                   EVAL      F0CCY  = *BLANKS
     C                   EVAL      F0ACCD = *BLANKS
     C                   EVAL      F0ACSQ = *BLANKS
     C                   EVAL      F0BRCA = *BLANKS
     C                   EVAL      F0PSTD = *BLANKS
     C                   EVAL      F0DSTN = *BLANKS
      ** The following statement should be activated once the network account
      ** type will no more be hidden
     C**                 EVAL      F0NATY  = *BLANKS
     C                   EVAL      F0MGTP = *BLANKS

     C                   EVAL      WValid = 'Y'
     C                   EVAL      *IN25 = *OFF
     C                   EVAL      *IN26 = *OFF
     C                   EVAL      *IN28 = *OFF
     C                   EVAL      *IN29 = *OFF
     C                   EVAL      *IN31 = *OFF
     C                   EVAL      *IN32 = *OFF
     C                   EXSR      SrClearMsgQ

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *  SrEnd - End Program Routine                                  *
      *****************************************************************
     C     SrEnd         BEGSR

     C                   EVAL      *INLR = *ON
     C                   RETURN

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *  SrCancl1 - Process CMD-12                                    *
      *****************************************************************
     C     SrCancl1      BEGSR

     C                   EXSR      SrClearMsgQ

      ** Clear Screen Error Indicators

     C                   EVAL      *IN25 = *OFF
     C                   EVAL      *IN26 = *OFF
     C                   EVAL      *IN28 = *OFF
     C                   EVAL      *IN29 = *OFF
     C                   EVAL      *IN31 = *OFF
     C                   EVAL      *IN32 = *OFF

      ** Initialize the fields

     C                   EVAL      F0NWRK  = *BLANKS
     C                   EVAL      F0CNUM  = *BLANKS
     C                   EVAL      F0CCY  = *BLANKS
     C                   EVAL      F0ACCD  = *BLANKS
     C                   EVAL      F0ACSQ  = *BLANKS
     C                   EVAL      F0BRCA  = *BLANKS
     C                   EVAL      F0PSTD  = *BLANKS
     C                   EVAL      F0DSTN  = *BLANKS
      ** The following statement should be activated once the network account
      ** type will no more be hidden
     C**                 EVAL      F0NATY  = *BLANKS
     C                   EVAL      WResetFld = 'Y'
     C                   EVAL      F0MGTP  = *BLANKS

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *  SrRefres1 - Refresh Subfile Screen                           *
      *****************************************************************
     C     SrRefres1     BEGSR

     C                   EVAL      WResetFld = 'Y'
     C                   EVAL      C1NWRK = *BLANKS
     C                   EVAL      C1BRCA = *BLANKS
     C                   EVAL      C1CNUM = *BLANKS
     C                   EVAL      C1CCY = *BLANKS
     C                   EVAL      C1ACCD = *BLANKS
     C                   EVAL      C1ACSQ = *BLANKS
      ** The following statement should be activated once the network account
      ** type will no more be hidden
     C**                 EVAL      C1NATY = *BLANKS
     C                   EVAL      C1ACNO = *BLANKS
     C                   EVAL      C1DSTN = *BLANKS
     C                   EXSR      SrClearMsgQ

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *  SrProcSel1- Subfile Screen Processing                        *
      *****************************************************************
     C     SrProcSel1    BEGSR

     C                   EVAL      *IN27 = *OFF
     C                   EVAL      WValid = 'Y'

      ** Change in selection criteria, exit subroutine

     C                   IF        WPrevNWRK <> C1NWRK
     C                             OR WPrAccNums <> AccNumSel
     C                             OR WPrevNATY <> C1NATY
     C                             OR WPrevACNO <> C1ACNO
     C                             OR WPrevDSTN <> C1DSTN

     C                   EVAL      *IN45 = *OFF
     C                   EVAL      *IN27 = *OFF

     C                   EVAL      WResetFld = 'Y'

     C                   ELSE

      ** Validate Selection fields

     C                   IF        WNoData1 = 'N' AND WValid = 'Y'
     C                   EXSR      SrValSel

     C                   IF        WValid = 'Y'
     C                   EXSR      SrDetSfl
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *  SrValSel - Validate Selection Field on Subfile               *
      *****************************************************************
     C     SrValSel      BEGSR

     C                   EVAL      WValid = 'Y'
     C                   EXSR      SrClearMsgQ

      ** Set subfile record pointer to top of subfile

     C                   Z-ADD     1             C1SFRN

     C                   READC     ME000070S1                             81

     C                   DOW       *IN81 = *OFF
      *
     C                   IF        S1SELE <> *BLANKS
      *
     C                   SELECT
     C                   WHEN      S1SELE <> '0' AND
     C                             S1SELE <> '1' AND S1SELE <> '2'
     C                   EVAL      WValid = 'N'
      *
     C                   WHEN      S1SELE = '5' AND S1G950 <> 'Y'
     C                   EVAL      WValid = 'N'
      *
     C                   WHEN      S1SELE = '0' AND S1G940 <> 'Y'
     C                   EVAL      WValid = 'N'
      *
     C                   WHEN      S1SELE = '1' AND S1G941 <> 'Y'
     C                   EVAL      WValid = 'N'
      *
     C                   WHEN      S1SELE = '2' AND S1G942 <> 'Y'
     C                   EVAL      WValid = 'N'
     C                   ENDSL
      *
     C                   IF        WValid = 'N'
     C                   EVAL      PZMsgID = 'MEM7000'
     C                   EVAL      PZMsgFile = 'MEMSG'
     C                   EVAL      *IN27 = *ON
     C                   EXSR      SrZaSnms
     C                   ENDIF
      *
      ** Switch *ON SFLNXTCHG
      *
     C                   EVAL      *IN45 = *ON
     C                   ENDIF
      *
     C                   UPDATE    ME000070S1
     C                   EVAL      PZMsgID = *BLANKS
     C                   EVAL      *IN27 = *OFF
     C                   EVAL      *IN45 = *OFF
      *
     C                   READC     ME000070S1                             81
     C                   ENDDO

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *  SrDetSfl - Process the Selected Record                       *
      *****************************************************************
     C     SrDetSfl      BEGSR

     C                   EVAL      WValid = 'Y'

      ** Set subfile record pointer to top of subfile

     C                   Z-ADD     1             C1SFRN
     C                   EVAL      *IN45 = *OFF

     C                   READC     ME000070S1                             81

     C                   DOW       *IN81 = *OFF AND *INKL=*OFF
      *
     C                   IF        S1SELE <> *BLANKS
     C                   EVAL      C2NWRK = S1NWRK
     C                   EVAL      C2BRCA = S1BRCA
     C                   EVAL      C2CNUM = S1CNUM
     C                   EVAL      C2CCY = S1CCY
     C                   EVAL      C2ACCD = S1ACCD
     C                   EVAL      C2ACSQ = S1ACSQ
     C                   EVAL      C2NATY = S1NATY
     C                   EVAL      C2ACNO = S1ACNO
     C                   EVAL      C2DSTN = S1DSTN
     C                   EVAL      C2ANAM = S1ANAM
      *
     C                   SELECT
     C                   WHEN      S1SELE = '5'
     C                   EVAL      C2MGTP = 'MT950'
     C                   EVAL      KMgtp  = '950'
     C                   EVAL      *IN12 = *On                                  Open/closing balance
     C                   EVAL      *IN15 = *Off                                 Available Balance
     C                   EVAL      *IN11 = *Off                                 Forward Balances
      *
     C                   WHEN      S1SELE = '0'
     C                   EVAL      C2MGTP = 'MT940'
     C                   EVAL      KMgtp  = '940'
     C                   EVAL      *IN12 = *On                                  Open/closing balance
     C                   EVAL      *IN15 = *On                                  Available Balance
     C                   EVAL      *IN11 = *On                                  Forward Balances
      *
     C                   WHEN      S1SELE = '1'
     C                   EVAL      C2MGTP = 'MT941'
     C                   EVAL      KMgtp  = '941'
     C                   EVAL      *IN12 = *On                                  Open/closing balance
     C                   EVAL      *IN15 = *On                                  Available Balance
     C                   EVAL      *IN11 = *On                                  Forward Balances
      *
     C                   WHEN      S1SELE = '2'
     C                   EVAL      C2MGTP = 'MT942'
     C                   EVAL      KMgtp  = '942'
     C                   EVAL      *IN12 = *Off                                 Open/closing balance
     C                   EVAL      *IN15 = *Off                                 Available Balance
     C                   EVAL      *IN11 = *Off                                 Forward Balances
     C                   ENDSL
      *
     C                   EVAL      KNwrk = C2NWRK
     C                   EVAL      AccNumKey = AccNumSel2
     C                   EVAL      KNaty = C2NATY
     C                   EVAL      KDstn = C2DSTN
     C     KGlNw94       CHAIN     GLNW94D0
      *
     C                   IF        NOT %FOUND(GLNW94L5)
     C     *LOCK         IN        LDA
     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   EVAL      DBFILE =  'GLNW94L5'
     C                   EVAL      DBASE  =  003
     C                   EVAL      DBPROC =  'SR/SrDetSfl'
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
      *
     C                   IF        KMgtp = '950'
     C     KGlNwAc       CHAIN     GLNWACD0
      *
     C                   IF        NOT %FOUND(GLNWACL4)
     C     *LOCK         IN        LDA
     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   EVAL      DBFILE =  'GLNWACL4'
     C                   EVAL      DBASE  =  007
     C                   EVAL      DBPROC =  'SR/SrDetSfl'
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
      *
     C                   ENDIF
      *
     C                   EVAL      WkATYP = S1ATYP
     C                   EVAL      WkLDBL = S1LDBL
     C                   EVAL      WkCLBL = S1CLBL
      *
     C                   EXSR      SrOpenBal
     C                   EXSR      SrClosBal
      *
      ** Build Subfile for all movements
      *
     C                   EVAL      WFrmInit1 = 'N'
     C                   EVAL      WFrmInit2 = 'N'
     C                   EXSR      SrProcSfl2
      *
     C                   EVAL      S1SELE = *BLANKS
      *
     C                   UPDATE    ME000070S1
     C                   ENDIF
      *
     C                   READC     ME000070S1                             81
     C                   ENDDO

     C                   EVAL      *INKL = *OFF
     C                   EVAL      WResetFld = 'Y'

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *  SrProcSfl2 - Build Subfile for All Movements until Today     *
      *****************************************************************
     C     SrProcSfl2    BEGSR

     C                   DOU       *INKC = *ON  OR *INKL = *ON OR
     C                             (WPrevPSTD = C2PSTD AND *INKE = *OFF AND
     C                              WFrmInit2 = 'N')

      ** Initialise and load subfile page

     C                   EXSR      SrSbfInz2

      ** Initialise reset field

     C                   EVAL      WResetFld = 'N'

     C                   DOW       WResetFld = 'N'

      ** Display the Subfile Screen

     C                   EXSR      SrDspSfl2

      ** Perform detailed processing

      ** F3 = Exit

     C     *INKC         CASEQ     *ON           SrEnd

     ** If F5 was pressed

     C     *INKE         CASEQ     *ON           SrRefres2

      ** F11 = Forward Balances

     C     *INKK         CASEQ     *ON           SrProcSfl3

      ** F12 = Cancel

     C     *INKL         CASEQ     *ON           SrCancl2

      ** Rollup/Rolldown

     C     *IN51         CASEQ     *ON           SrLoad2

      ** Process the subfile's action codes (none)

     C                   CAS                     SrProcSel2
     C                   ENDCS

     C                   ENDDO
     C                   ENDDO

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *  SrSbfInz2 - Subfile initialisation and load routine          *
      *****************************************************************
     C     SrSbfInz2     BEGSR

     C                   EVAL      *IN52 = *OFF
     C                   WRITE     ME000070C2
     C                   EVAL      *IN52 = *ON

     C                   Z-ADD     *ZERO         WLstRRN2

      ** Set GL Postings for MT94x messages.

     C                   IF        WFrmInit1 = 'N'
     C                   EVAL      WPrevPSTD = C2PSTD
     C                   IF        C2PSTD <> *BLANKS
     C                   IF        WValid = 'N'
     C                   EXSR      SrClearMsgQ
     C                   ENDIF
     C                   EVAL      PZDateA = C2PSTD
     C                   EXSR      SrZDATE1
     C                   IF        PErrorFlag = 'Y'
     C                   EVAL      PZMsgID='ME00047'
     C                   EVAL      *IN30=*ON
     C                   EVAL      WValid = 'N'
     C                   EVAL      PZMsgFile = 'MEMSG'
     C                   EXSR      SrZaSnms
     C                   ELSE
     C                   EVAL      KPstd = PZDayNo
     C                   EVAL      *IN30=*OFF
     C                   EVAL      WValid = 'Y'
     C                   ENDIF
     C                   ELSE
     C                   EVAL      KPstd = *ZERO
     C                   EVAL      *IN30=*OFF
     C                   EVAL      WValid = 'Y'
     C                   ENDIF
     C                   ENDIF

     C                   EVAL      WFrmInit1 = 'N'

     C     KGLPost1      SETLL     GLPOSTD8


      ** Load Subfile Page

     C                   EXSR      SrLoad2

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *  SrLoad2- Load one page of subfile                            *
      *****************************************************************
     C     SrLoad2       BEGSR

      ** Set subfile record load counter to 0.

     C                   Z-ADD     0             WCounter
     C                   Z-ADD     WLstRRN2      C2SFRN

      ** Loads a subfile page

     C     KGLPost2      READE     GLPOSTD8                               82

     C                   DOW       WValid = 'Y' AND *IN82 = *OFF AND
     C                             WCounter < WSflPag2

     C                   IF        MGPROC <> 'Y'

     C                   EXSR      SrClrSFld2
     C                   EXSR      SrMovSFld2

     C                   ADD       1             C2SFRN
     C                   ADD       1             WCounter

     C                   WRITE     ME000070S2
     C                   ENDIF

     C     KGLPost2      READE     GLPOSTD8                               82
     C                   ENDDO

      ** Look if a further record will be selected on the following roll-up request

     C                   DOW       WValid = 'Y' AND *IN82 = *OFF
      *
     C                   IF        MGPROC <> 'Y'
     C                   LEAVE
     C                   ENDIF
      *
     C     KGLPost2      READE     GLPOSTD8                               82
     C                   ENDDO

     C                   IF        *IN82 = *OFF
     C                   READP     GLPOSTD8                               82
     C                   ENDIF

      ** Save last relative record number to a workfield.

     C                   Z-ADD     C2SFRN        WLstRRN2

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *  SRClrSFld2- Clear Subfile Fields Routine                     *
      *****************************************************************
     C     SRClrSFld2    BEGSR

     C                   EVAL      S2PSTD = *BLANKS
     C                   EVAL      S2VALD = *BLANKS
     C                   EVAL      S2PNAR = *BLANKS
     C                   EVAL      S2PSTA = *BLANKS
     C                   EVAL      S2DRCR = *BLANKS

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *  SrMovSFld2- Move Record Fields to Subfile Fields             *
      *****************************************************************
     C     SrMovSFld2    BEGSR

      ** Posting Date

     C                   EVAL      PZDayNO = PSTD
     C                   EXSR      SrZdate2
     C                   EVAL      S2PSTD = PZADate

      ** Value Date

     C                   EVAL      PZDayNO = VALD
     C                   EXSR      SrZdate2
     C                   EVAL      S2VALD = PZADate

      ** Posting Narrative

     C                   EVAL      S2PNAR = PNAR

      ** Posting Amount

     C                   EVAL      PZFld15 = PSTA

     C                   EXSR      SrZSEdit
     C                   EVAL      S2PSTA = PZOut21
      ** Debit/Credit

     C                   IF        DRCR = 1
     C                   EVAL      S2DRCR = 'CR'
     C                   ELSE
     C                   EVAL      S2DRCR = 'DB'
     C                   ENDIF

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *  SrDspSfl2 - Display Subfile Page                             *
      *****************************************************************
     C     SrDspSfl2     BEGSR

     C                   IF        C2SFRN = 0
     C                   EVAL      *IN50 = *OFF
     C                   EVAL      PZMsgID = 'Y2U0008'
     C                   EVAL      PZMsgFile = 'Y2USRMSG'
     C                   EXSR      SRZaSnms
     C                   ELSE
     C                   EVAL      *IN50 = *ON
     C                   ENDIF

     C                   IF        *IN82 = *ON
     C                   EVAL      *IN53 = *ON
     C                   ELSE
     C                   EVAL      *IN53 = *OFF
     C                   ENDIF

     C                   WRITE     #MSGCTL
     C                   WRITE     ME000070F2
     C                   EXFMT     ME000070C2

     C                   EXSR      SrClearMsgQ

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *  SrRefres2 - Refresh Subfile Screen                           *
      *****************************************************************
     C     SrRefres2     BEGSR

     C                   EVAL      WResetFld = 'Y'
     C                   EVAL      C2PSTD = *BLANKS

     C                   EVAL      *IN30 = *OFF

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *  SrCancl2 - Process CMD-12                                    *
      *****************************************************************
     C     SrCancl2      BEGSR

     C                   EXSR      SrRefresh
     C                   EVAL      WResetFld ='Y'
     C                   EVAL      C2PSTD = *BLANKS
     C                   EVAL      *IN30 = *OFF
     C                   EXSR      SrClearMsgQ

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *  SrProcSel2- Subfile Screen Processing                        *
      *****************************************************************
     C     SrProcSel2    BEGSR

     C                   EVAL      WResetFld = 'Y'

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *  SrProcSfl3 - Build Subfile for forward Movements             *
      *****************************************************************
     C     SrProcSfl3    BEGSR

     C                   DOU       *INKC = *ON  OR *INKL = *ON

      ** Initialise and load subfile page

     C                   EXSR      SrSbfInz3

      ** Initialise reset field

     C                   EVAL      WResetFld3 = 'N'

     C                   DOW       WResetFld3 = 'N'

      ** Display the Subfile Screen

     C                   EXSR      SrDspSfl3

      ** Perform detailed processing

      ** F3 = Exit

     C     *INKC         CASEQ     *ON           SrEnd

     ** If F5 was pressed

     C     *INKE         CASEQ     *ON           SrRefres3

      ** F12 = Cancel

     C     *INKL         CASEQ     *ON           SrCancl3

      ** Rollup/Rolldown

     C     *IN51         CASEQ     *ON           SrLoad3

      ** Process the subfile's action codes (none)

     C                   CAS                     SrProcSel3
     C                   ENDCS

     C                   ENDDO
     C                   ENDDO

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *  SrSbfInz3 - Subfile initialisation and load routine          *
      *****************************************************************
     C     SrSbfInz3     BEGSR

      ** Clear the subfile

     C                   EVAL      *IN52 = *OFF
     C                   WRITE     ME000070C3
     C                   EVAL      *IN52 = *ON
     C                   Z-ADD     *ZERO         WLstRRN3

     C                   EXSR      SrClearMsgQ

      ** Setup subfile control fields

     C                   EVAL      C3MGTP = C2MGTP
     C                   EVAL      C3NWRK = C2NWRK
     C                   EVAL      C3BRCA = C2BRCA
     C                   EVAL      C3CNUM = C2CNUM
     C                   EVAL      C3CCY  = C2CCY
     C                   EVAL      C3ACCD = C2ACCD
     C                   EVAL      C3ACSQ = C2ACSQ
     C                   EVAL      C3ACNO = C2ACNO
     C                   EVAL      C3ANAM = C2ANAM
     C                   EVAL      C3DSTN = C2DSTN
     C                   EVAL      C3NATY = C2NATY
     C                   EVAL      C3BALA = C2BALA
     C                   EVAL      C3CLOS = C2CLOS
     C                   EVAL      C3AVBL = C2AVBL

      ** First access to the file (value date >= to the next working date)

     C                   Z-ADD     BJDNWD        KVald
     C     KGLPost3      SETLL     GLPOSTD0
     C     KGLPost2      READE     GLPOSTD0
     C                   EVAL      WSavVALD = VALD

      ** Validate the position field (value date)

     C                   EVAL      WPrevVALD = C3VALD
     C                   EVAL      WValid = 'Y'

     C                   IF        C3VALD <> *BLANKS
     C                   EVAL      PZDateA = C3VALD
     C                   EXSR      SrZDATE1
      *
     C                   IF        PErrorFlag = 'Y'
     C                   EVAL      PZMsgID='ME00047'
     C                   EVAL      *IN30 = *On
     C                   EVAL      WValid = 'N'
     C                   EVAL      PZMsgFile = 'MEMSG'
     C                   EXSR      SrZaSnms
     C                   ELSE
     C                   EVAL      KVald = PZDayNo
     C                   EVAL      *IN30 = *Off
     C                   ENDIF
      *
     C                   ENDIF

      ** Load Subfile Page

     C                   EXSR      SrLoad3

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *  SrLoad3- Load one page of subfile                            *
      *****************************************************************
     C     SrLoad3       BEGSR

      ** Set subfile record load counter to 0.

     C                   Z-ADD     0             WCounter
     C                   Z-ADD     0             C3SFRN

      ** Loads a subfile page
      ** N.B.: The counter will start to increase when we'll encounter the first
      **       value date >= to the one required for positionning

     C                   DOW       WValid = 'Y' AND NOT %Eof(GLPOSTL0) AND
     C                             WCounter < WSflPag3
      *
      ** -- The requested value date has been reached, so set the no of the first subfile
      **    record to be displayed
     C                   IF        VALD >= KVald AND C3SFRN = 0
     C                   EVAL      C3SFRN = WLstRRN3 + 1
     C                   ENDIF
      *
      ** -- A total ligne (forward balance) is to be displayed; this should lead the
      **    subfile page to be full. If so, the current GLPOSTL0 record will be
      **    processed at the next user's rollup request
     C                   IF        VALD <> WSavVALD
     C                   EXSR      SrTotSfl3
     C                   ADD       1             WLstRRN3
     C                   WRITE     ME000070S3
     C                   EVAL      WSavVALD = VALD
      *
     C                   IF        C3SFRN > 0
     C                   ADD       1             WCounter
      *
     C                   IF        WCounter >= WSflPag3
     C                   LEAVE
     C                   ENDIF
      *
     C                   ENDIF
      *
     C                   ENDIF
      *
      ** -- Output a subfile record for the current file record
     C                   EXSR      SrMovSFld3
      *
     C                   ADD       1             WLstRRN3
      *
     C                   IF        C3SFRN > 0
     C                   ADD       1             WCounter
     C                   ENDIF
      *
     C                   WRITE     ME000070S3
      *
      ** -- Holding for forward balance
     C                   IF        DRCR = 1
     C                   SUB       PZFld15       PZFld15_2
     C                   ELSE
     C                   ADD       PZFld15       PZFld15_2
     C                   ENDIF
      *
     C     KGLPost2      READE     GLPOSTD0
     C                   ENDDO

      ** -- Eventually output the last total line
     C                   IF        %Eof(GLPOSTL0) AND WLstRRN3 > 0
     C                   EXSR      SrTotSfl3
     C                   ADD       1             WLstRRN3
     C                   WRITE     ME000070S3
     C                   ENDIF

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *  SrMovSFld3- Move Record Fields to Subfile Fields             *
      *****************************************************************
     C     SrMovSFld3    BEGSR

      ** Value Date

     C                   EVAL      PZDayNO = VALD
     C                   EXSR      SrZdate2
     C                   EVAL      S3VALD = PZADate

      ** Posting Date

     C                   EVAL      PZDayNO = PSTD
     C                   EXSR      SrZdate2
     C                   EVAL      S3PSTD = PZADate

      ** Posting Narrative

     C                   EVAL      S3PNAR = PNAR

      ** Posting Amount

     C                   EVAL      PZFld15 = PSTA

     C                   EXSR      SrZSEdit
     C                   EVAL      S3PSTA = PZOut21

      ** Debit/Credit

     C                   IF        DRCR = 1
     C                   EVAL      S3DRCR = 'CR'
     C                   ELSE
     C                   EVAL      S3DRCR = 'DB'
     C                   ENDIF

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *  SrTotSFl3 - Move Record Fields to Subfile Fields             *
      *****************************************************************
     C     SrTotSFl3     BEGSR

     C                   EVAL      S3VALD = *Blanks
     C                   EVAL      S3PSTD = *Blanks
     C                   EVAL      S3PNAR = 'Forward balance:'

     C                   EVAL      PZFld15 = PZFld15_2
     C                   EXSR      SrZSEdit
     C                   EVAL      S3PSTA = %Subst(PZOut21:1:20) + ' '

     C                   IF        %Subst(PZOut21:21:1) = '-'
     C                   EVAL      S3DRCR = 'CR'
     C                   ELSE
     C                   EVAL      S3DRCR = 'DB'
     C                   ENDIF

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *  SrDspSfl3 - Display Subfile Page                             *
      *****************************************************************
     C     SrDspSfl3     BEGSR

      ** Sets up RollUp and SFLEND indicator according to EOF or not

     C                   IF        %Eof(GLPOSTL0)
     C                   EVAL      *IN53 = *On
     C                   ELSE
     C                   EVAL      *IN53 = *Off
     C                   ENDIF

      ** No Records on Subfile

     C                   IF        C3SFRN = 0
     C                   EVAL      *IN50 = *Off
     C                   EVAL      PZMsgID = 'Y2U0008'
     C                   EVAL      PZMsgFile = 'Y2USRMSG'
     C                   EXSR      SRZaSnms
     C                   ELSE
     C                   EVAL      *IN50 = *On
     C                   ENDIF

     C                   WRITE     #MSGCTL
     C                   WRITE     ME000070F3
     C                   EXFMT     ME000070C3

     C                   EXSR      SrClearMsgQ

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *  SrRefres3 - Refresh Subfile Screen                           *
      *****************************************************************
     C     SrRefres3     BEGSR

     C                   EVAL      WResetFld3 = 'Y'
     C                   EVAL      C3VALD = *BLANKS

     C                   EVAL      *IN30 = *OFF

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *  SrCancl3 - Process CMD-12                                    *
      *****************************************************************
     C     SrCancl3      BEGSR

     C                   EVAL      WResetFld3 ='Y'
     C                   EVAL      C3VALD = *BLANKS
     C                   EVAL      *IN30 = *OFF
     C                   EXSR      SrClearMsgQ

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *  SrProcSel3 - Subfile Screen Processing                       *
      *****************************************************************
     C     SrProcSel3    BEGSR

     C                   IF        C3VALD = WPrevVALD
     C                   EVAL      WResetFld3 = 'N'
     C                   ELSE
     C                   EVAL      WResetFld3 = 'Y'
     C                   ENDIF

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *  SrDetIni - Process the Network Account Entered               *
      *****************************************************************
     C     SrDetIni      BEGSR

     C                   EVAL      C2NWRK = F0NWRK
     C                   EVAL      C2BRCA = AC_BRCA
     C                   MOVEL     AC_CNUM       C2CNUM
     C                   EVAL      C2CCY = AC_CCY
     C                   MOVEL     AC_ACOD       C2ACCD
     C                   MOVEL     AC_ACSQ       C2ACSQ
     C                   MOVEL     AC_ACNO       C2ACNO
     C                   EVAL      C2DSTN = F0DSTN
     C                   EVAL      C2NATY = F0NATY
     C                   EVAL      C2MGTP = 'MT' + F0MGTP

     C                   EVAL      KNwrk = C2NWRK
     C                   EVAL      AccNumKey = AccNumSel2
     C                   EVAL      KNaty = C2NATY
     C                   EVAL      KDstn = C2DSTN
     C                   EVAL      KMgtp = F0MGTP
     C                   EVAL      C2ANAM = AC_ANAM

      ** It must be an existing network account, and generate the requested
      ** message type

     C     KGlNw94       CHAIN     GLNW94D0

     C                   IF        NOT %FOUND(GLNW94L5)
     C                   EVAL      PZMsgID='ME00032'
     C                   EVAL      *IN25 = *ON
     C                   EVAL      *IN26 = *ON
     C                   EVAL      *IN28 = *ON
     C                   EVAL      *IN29 = *ON
     C                   EVAL      *IN31 = *ON
     C                   EVAL      WValid = 'N'
     C                   EVAL      PZMsgFile = 'MEMSG'
     C                   EXSR      SrZaSnms
     C                   ELSE
      *
     C                   SELECT
     C                   WHEN      F0MGTP = '940' AND N4G940 <> 'Y'
     C                   EVAL      WValid = 'N'
      *
     C                   WHEN      F0MGTP = '941' AND N4G941 <> 'Y'
     C                   EVAL      WValid = 'N'
      *
     C                   WHEN      F0MGTP = '942' AND N4G942 <> 'Y'
     C                   EVAL      WValid = 'N'
      *
     C                   WHEN      F0MGTP = '950'
     C     KGlNwAc       CHAIN     GLNWACD0
      *
     C                   IF        NOT %FOUND(GLNWACL4)
     C                   EVAL      WValid = 'N'
     C                   ENDIF
      *
     C                   ENDSL
      *
     C                   IF        WValid = 'N'
     C                   EVAL      PZMsgID='ME00135'
     C                   EVAL      *IN32 = *ON
     C                   EVAL      PZMsgFile = 'MEMSG'
     C                   EXSR      SrZaSnms
     C                   ENDIF
      *
     C                   ENDIF

     C                   IF        WValid = 'Y' AND BJSBRC = *BLANKS
     C                   CALL      'ZVACTBU'
     C                   PARM      'E'           PZAction
     C                   PARM      N4BRCA        PBrCde
     C                   PARM      *ZERO         PError

     C                   IF        PError <> *ZERO
     C                   EVAL      PZMsgID='MEM1077'
     C                   EVAL      *IN25 = *ON
     C                   EVAL      *IN26 = *ON
     C                   EVAL      *IN28 = *ON
     C                   EVAL      *IN29 = *ON
     C                   EVAL      *IN31 = *ON
     C                   EVAL      WValid = 'N'
     C                   EVAL      PZMsgFile = 'MEMSG'
     C                   EXSR      SrZaSnms
     C                   ENDIF
     C                   ENDIF

      ** Opening Balance

     C                   IF        WValid = 'Y'
      *
     C                   SELECT
     C                   WHEN      KMgtp  = '950'
     C                   EVAL      *IN12 = *On                                  Open/closing balance
     C                   EVAL      *IN15 = *Off                                 Available Balance
     C                   EVAL      *IN11 = *Off                                 Forward Balances
      *
     C                   WHEN      KMgtp  = '940'
     C                   EVAL      *IN12 = *On                                  Open/closing balance
     C                   EVAL      *IN15 = *On                                  Available Balance
     C                   EVAL      *IN11 = *On                                  Forward Balances
      *
     C                   WHEN      KMgtp  = '941'
     C                   EVAL      *IN12 = *On                                  Open/closing balance
     C                   EVAL      *IN15 = *On                                  Available Balance
     C                   EVAL      *IN11 = *On                                  Forward Balances
      *
     C                   WHEN      KMgtp  = '942'
     C                   EVAL      *IN12 = *Off                                 Open/closing balance
     C                   EVAL      *IN15 = *Off                                 Available Balance
     C                   EVAL      *IN11 = *Off                                 Forward Balances
     C                   ENDSL
      *
     C                   EXSR      SrOpenBal
     C                   EXSR      SrClosBal

      ** Build Subfile for all movements

     C                   EVAL      WFrmInit1 = 'Y'
     C                   EVAL      WFrmInit2 = 'Y'
     C                   EXSR      SrProcSfl2
     C                   ENDIF

     C                   ENDSR
      *****************************************************************
     C/EJECT
      *****************************************************************
      *  SrOpenBal - Convert Opening Balance to Screen Field          *
      *****************************************************************
     C     SrOpenBal     BEGSR

      ** Opening Balance

     C                   CALL      'AOCURRR0'
     C                   PARM      *BLANKS       PRtCd
     C                   PARM      '*KEY'        POptn
     C                   PARM      N4CCY         PCucd
     C     SDCURR        PARM                    DSSDY

     C                   IF        PRtCd = *Blanks
     C                   Z-ADD     A6NBDP        PZDecPl
     C                   ELSE
     C     *LOCK         IN        LDA
     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   EVAL      DBFILE = 'SDCURRPD'
     C                   EVAL      DBASE = 005
     C                   EVAL      DBKEY = CCY
     C                   EVAL      DBPROC =  'SR/SrOpenBal'
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF

     C                   SELECT
     C                   WHEN      C2MGTP = 'MT940'
     C                   EVAL      PZFld15 = N40LCA
      *
     C                   WHEN      C2MGTP = 'MT941'
     C                   EVAL      PZFld15 = N41LCB
      *
     C                   WHEN      C2MGTP = 'MT942'
     C                   EVAL      PZFld15 = 0
      *
     C                   WHEN      C2MGTP = 'MT950'
     C                   EVAL      PZFld15 = NA5LCB
     C                   ENDSL

      ** Edit the result

     C                   EXSR      SrZSEdit
     C                   EVAL      C2BALA = %Subst(PZOut21:2:20)+ ' '

     C                   IF        %Subst(PZOut21:21:1) = '-'
     C                   MOVE      'CR'          C2BALA
     C                   ELSE
     C                   MOVE      'DB'          C2BALA
     C                   ENDIF
     C
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *  SrClosBal - Compute for the Closing Balance                  *
      *****************************************************************
     C     SrClosBal     BEGSR

      ** Closing Balance

      ** 1. For messages except MT942, first try to retrieve the closing and available
      **    balances

 B1  C                   IF        C2MGTP <> 'MT942'
      *
      ** 1.a. Retail account
      *
 B2  C                   IF        WkATYP = 'R'
      *
     C                   CALL      'AOMEMSR0'
     C                   PARM      *BLANKS       PRtCd
     C                   PARM      '*KEY'        POptn
     C                   PARM      *ZEROS        PRetlN
     C                   PARM      N4CNUM        PCnumN
     C                   PARM      N4CCY         PCucd
     C                   PARM      N4ACCD        PAccdN
     C                   PARM      N4ACSQ        PAcsqN
     C                   PARM      N4BRCA        PBrca
     C     MEMOS         PARM                    DSFDY
      *
 B3  C                   IF        PRtCd = *Blanks
     C                   EVAL      PZFld15   = MELDBLN                          Closing
     C                   EVAL      PZFld15_2 = MECLBLN                          Available
      *
      ** If MM module is installed, retrieve FF balances to update projected balances.
      *
     C                   IF        Mo_FFFL = 'Y'
     C                   EVAL      WfBRCA = N4BRCA
     C                   EVAL      WfCNUM = N4CNUM
     C                   EVAL      WfCCY  = N4CCY
     C                   EVAL      WfACOD = N4ACCD
     C                   EVAL      WfACSQ = N4ACSQ
     C                   OPEN      MEMOSM1
     C     KFFProj       SETLL     MEMOSM1
     C     KFFProj       READE     MEMOSM1                                99
     C                   DOW       NOT *IN99
     C                   IF        FM_RECI = 'D'
     C                   EVAL      PZFld15   = PZFld15   + FM_LDBL              Closing
     C                   EVAL      PZFld15_2 = PZFld15_2 + FM_CLBL              Available
     C                   ENDIF
     C     KFFProj       READE     MEMOSM1                                99
     C                   ENDDO
     C                   CLOSE     MEMOSM1
     C                   ENDIF
      *
 X3  C                   ELSE
     C                   EVAL      WkATYP = *Blank
 E3  C                   ENDIF
      *
 E2  C                   ENDIF
      *
      ** 1.b. Nostro account
      *
 B2  C                   IF        WkATYP = 'N'
      *
     C                   CALLB     'AONOSTR0'
     C                   PARM      *BLANKS       PRtCd
     C                   PARM      '*KEY'        POptn
     C                   PARM      C2CNUM        PCnum
     C                   PARM      C2CCY         PCucd
     C                   PARM      C2ACCD        PAccd
     C                   PARM      C2ACSQ        PAcsq
     C                   PARM      *Blanks       PNonb
     C                   PARM      C2BRCA        PBrca
     C                   PARM      *Blanks       PCssn
     C                   PARM      *Blanks       PPnoi
     C     SDNOST        PARM                    DSFDY
      *
 B3  C                   IF        PRtCd = *Blanks
     C     KProno        CHAIN     PRONO
      *
 B4  C                   IF        %FOUND(PRONO)
     C                   EVAL      PZFld15   = ProjNostBal
     C                   EVAL      PZFld15_2 = ProjNostBal
      *
      ** If MM module is installed, retrieve FF balances to update projected balances.
      *
     C                   IF        Mo_FFFL = 'Y'
     C                   OPEN      PRONOM1
     C     KProno        SETLL     PRONOM1
     C     KProno        READE     PRONOM1                                99
     C                   DOW       NOT *IN99
     C                   IF        FP_RECI = 'D'
     C                   EVAL      PZFld15   = PZFld15   + FP_PNBL              Closing
     C                   EVAL      PZFld15_2 = PZFld15_2 + FP_PNBL              Available
     C                   ENDIF
     C     KProno        READE     PRONOM1                                99
     C                   ENDDO
     C                   CLOSE     PRONOM1
     C                   ENDIF
      *
 X4  C                   ELSE
     C                   EVAL      WkATYP = *Blank
 E4  C                   ENDIF
      *
 X3  C                   ELSE
     C                   EVAL      WkATYP = *Blank
 E3  C                   ENDIF
      *
 E2  C                   ENDIF
      *
      ** 1.c. Other account
      *
 B2  C                   IF        WkATYP <> 'N' AND WkATYP <> 'R'
      *
     C                   EVAL      PZFld15   = WkLDBL
     C                   EVAL      PZFld15_2 = WkCLBL
      *
 E2  C                   ENDIF
      *
 E1  C                   ENDIF

      ** 2. For messages type other than MT942 (including MT941 for non Retail/Nostro),
      **    compute the closing (and eventually the available) balances by using GLPOSTPD

 B1  C                   IF        C2MGTP = 'MT942'
     C                   EVAL      PZFld15   = 0
     C                   EVAL      PZFld15_2 = 0
 E1  C                   ENDIF
      *
      ** 2.b. For MT950, there is no available balance.
      *
 B1  C                   IF        C2MGTP = 'MT950'
     C                   EVAL      PZFld15_2 = 0
 E1  C                   ENDIF
      *
      ** Edit the results

     C                   EXSR      SrZSEdit
     C                   EVAL      C2CLOS = %Subst(PZOut21:2:20)+ ' '

     C                   IF        %Subst(PZOut21:21:1) = '-'
     C                   MOVE      'CR'          C2CLOS
     C                   ELSE
     C                   MOVE      'DB'          C2CLOS
     C                   ENDIF

     C                   EVAL      PZFld15 = PZFld15_2
     C                   EXSR      SrZSEdit
     C                   EVAL      C2AVBL = %Subst(PZOut21:2:20)+ ' '

     C                   IF        %Subst(PZOut21:21:1) = '-'
     C                   MOVE      'CR'          C2AVBL
     C                   ELSE
     C                   MOVE      'DB'          C2AVBL
     C                   ENDIF

      ** Retrieve last postings from RSACMTPD.
      ** Remark: RSACMTPD contains shadow postings for:
      **                  - Retail account
      **                  - Nostro account
      **                  - General Ledger BUT ONLY FOR BATCH INPUT, the other
      **                    transaction types does not fill RSACMTPD.
      **                    => Thus, not consistent.

 B1  C                   IF        WkATYP = 'R'
     C                             OR WkATYP = 'N'

     C                   CLEAR                   GLMR94

     C                   EVAL      MRNWRK = KNwrk
     C                   EVAL      MRBRCA = KBrca
     C                   EVAL      MRCNUM = KCnum
     C                   EVAL      MRCCY  = KCcy
     C                   EVAL      MRACCD = KAccd
     C                   EVAL      MRACSQ = KAcsq
     C                   EVAL      MRNATY = KNaty
     C                   EVAL      MRDSTN = KDstn
     C                   EVAL      MRMTPY = KMgtp

     C                   CALLB     'GL001416'
     C                   PARM                    ReturnCode
     C                   PARM                    GLMR94

 B2  C                   IF        ReturnCode <> *BLANKS
     C     *LOCK         IN        LDA
     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   EVAL      DBFILE =  'GL001416'
     C                   EVAL      DBASE  =  006
     C                   EVAL      DBPROC =  'SR/SrClosBal'
     C                   OUT       LDA
     C                   EXSR      *PSSR
 E2  C                   ENDIF

      ** If FF module is activated, extract FF shadow postings.

     C                   IF        Mo_FFFL = 'Y'

     C                   CALLB     'GL001417'
     C                   PARM                    ReturnCode
     C                   PARM                    GLMR94

     C                   IF        ReturnCode <> *BLANKS
     C     *LOCK         IN        LDA
     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   EVAL      DBFILE =  'GL001417'
     C                   EVAL      DBASE  =  008
     C                   EVAL      DBPROC =  'SR/FF_Shadow'
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
     C                   ENDIF

 E1  C                   ENDIF

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *  SrZDate1 - Validate date input and convert to day number     *
      *****************************************************************
     C     SrZDate1      BEGSR

      ** Call ZDATE1 to validate and convert date to day number

     C                   CALLB     'ZDATE1'
     C                   PARM                    PZDateA
     C                   PARM                    PZDayno
     C                   PARM      BJDFIN        PZDatFmt
     C                   PARM      *BLANKS       PErrorFlag

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *  SrZDate2 - Validate date input and convert to DDMMMYY        *
      *****************************************************************
     C     SrZDate2      BEGSR

      ** Call ZDATE1 to validate and convert date to DDMMMYY

     C                   CALLB     'ZDATE2'
     C                   PARM                    PZDayNo
     C                   PARM      BJDFIN        PZDatFmt
     C                   PARM                    PZDate
     C                   PARM      *BLANKS       PZADate

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *  SrZSEdit - Insert a decimal point and remove leading         *
      *             zeros from signed numeric field                   *
      *****************************************************************
     C     SrZSEdit      BEGSR

     C                   CALLB     'ZSEDIT'
     C                   PARM                    PZFld15
     C                   PARM                    PZDecPl
     C                   PARM      *BLANKS       PZECode
     C                   PARM      *BLANKS       PZOut21

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *  SRZASNMS - Message Handling Routine                          *
      *****************************************************************
     C     SRZASNMS      BEGSR

     C                   CALLB     'ZAMSGTOSCN'
     C                   PARM                    PZMsgFile
     C                   PARM                    PZMsgID
     C                   PARM                    PZMsgDta
     C                   PARM                    PZMsgPgm
     C                   PARM                    PZMsgMod
     C                   PARM                    PZMsgProc

     C                   EVAL      PZMsgID = *BLANKS
     C                   EVAL      PZMsgDta = *BLANKS

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *  SrClearMsgQ - Clear messages from Program Message Queue      *
      *****************************************************************
     C     SrClearMsgQ   BEGSR

     C                   CALLB     'ZAMSGCLRPG'
     C                   PARM                    PZMsgPgm
     C                   PARM                    PZMsgMod
     C                   PARM                    PZMsgProc

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *  *INZSR - Program Initialisation                              *
      *****************************************************************
     C     *INZSR        BEGSR

      ** Define LDA

     C     *LOCK         IN        LDA
     C                   EVAL      DBPGM = PSProcPgm
     C                   EVAL      DBMOD = PSProcMod
     C                   EVAL      DBFILE = *BLANKS
     C                   EVAL      DBKEY = *BLANKS
     C                   EVAL      DBASE = *ZERO
     C                   OUT       LDA

     ** Get RUNDAT to access MULTI-BRANCHING flag.

     C     *DTAARA       DEFINE                  RUNDAT
     C                   IN        RUNDAT

     C                   IF        AGMBIN <> 'Y'
     C                   EXSR      SrChckAut
     C                   ENDIF

      ** Access bank details

     C                   CALL      'AOBANKR0'
     C                   PARM      *BLANKS       PRTCD
     C                   PARM      '*FIRST '     POPTN
     C     SDBANK        PARM      *BLANKS       DSFDY

      ** Database error

     C                   IF        PRTCD <> *BLANKS
     C     *LOCK         IN        LDA
     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   EVAL      DBFILE = 'SDBANKPD'
     C                   EVAL      DBASE = 001
     C                   EVAL      DBKEY = '*CALL'
     C                   EVAL      DBPROC =  'SR/*INZSR'
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF

      ** Retrieve Modules installed.

     C                   IN        MMOD

      ** Initialise message fields

     C                   EVAL      PZMsgFile = 'MEMSG'
     C                   EVAL      PZMsgPgm = PSProcPgm
     C                   EVAL      PZMsgMod = PSProcMod
     C                   EVAL      PZMsgProc = PSProcName

      ** Initialise screen fields

     C                   EVAL      WValid='Y'

      ** N.B.: the following initialisations of the different "network account type"
      **       screen fields should be removed once the network account type will
      **       no more be hidden

     C                   EVAL      F0NATY = 'S'
     C                   EVAL      C1NATY = 'S'

      ** Key lists

     C     KGlNw94       KLIST
     C                   KFLD                    KNwrk
     C                   KFLD                    KBrca
     C                   KFLD                    KCnum
     C                   KFLD                    KCcy
     C                   KFLD                    KAccd
     C                   KFLD                    KAcsq
     C                   KFLD                    KNaty
     C                   KFLD                    KDstn

     C     KGlNwAc       KLIST
     C                   KFLD                    N4NWRK
     C                   KFLD                    N4BRCA
     C                   KFLD                    N4CNUM
     C                   KFLD                    N4CCY
     C                   KFLD                    N4ACCD
     C                   KFLD                    N4ACSQ
     C                   KFLD                    N4NATY

     C     KGlPost1      KLIST
     C                   KFLD                    KNwrk
     C                   KFLD                    KBrca
     C                   KFLD                    KCnum
     C                   KFLD                    KCcy
     C                   KFLD                    KAccd
     C                   KFLD                    KAcsq
     C                   KFLD                    KNaty
     C                   KFLD                    KDstn
     C                   KFLD                    KMgtp
     C                   KFLD                    KPstd

     C     KGlPost2      KLIST
     C                   KFLD                    KNwrk
     C                   KFLD                    KBrca
     C                   KFLD                    KCnum
     C                   KFLD                    KCcy
     C                   KFLD                    KAccd
     C                   KFLD                    KAcsq
     C                   KFLD                    KNaty
     C                   KFLD                    KDstn
     C                   KFLD                    KMgtp

     C     KGlPost3      KLIST
     C                   KFLD                    KNwrk
     C                   KFLD                    KBrca
     C                   KFLD                    KCnum
     C                   KFLD                    KCcy
     C                   KFLD                    KAccd
     C                   KFLD                    KAcsq
     C                   KFLD                    KNaty
     C                   KFLD                    KDstn
     C                   KFLD                    KMgtp
     C                   KFLD                    KVald

     C     KAcBlTd       KLIST
     C                   KFLD                    AC_CNUM
     C                   KFLD                    AC_CCY
     C                   KFLD                    AC_ACOD
     C                   KFLD                    AC_ACSQ
     C                   KFLD                    AC_BRCA

     C     KProno        KLIST
     C                   KFLD                    A7CYCD
     C                   KFLD                    WkNostNumb

     C     KFFProj       KLIST
     C                   KFLD                    WfBRCA                         Branch Code
     C                   KFLD                    WfCNUM                         Customer Number
     C                   KFLD                    WfCCY                          Currency
     C                   KFLD                    WfACOD                         Account Code
     C                   KFLD                    WfACSQ                         Account Sequence

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************

      ** The following /COPY contains the standard program status
      ** subroutine, including a bound call to the DBERRCTL module.

     C/COPY ZACPYSRC,PSSR_ILE

      *****************************************************************
**  CPY@
(c) Finastra International Limited 2002
