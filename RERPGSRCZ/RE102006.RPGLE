     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas RE MT101/MT103 Reconciliation Enquiry')
/*XBIA*  OVRDBF FILE(REICSDL4X) TOFILE(REICSDL4) SHARE(*NO)           *         212995
      *****************************************************************
      *                                                               *
      *  Midas - Retail Module                                        *
      *                                                               *
      *  RE102006 - MT101/MT103 Reconciliation Enquiry                *
      *                                                               *
      *  Function: This enquiry function will display to the user all *
      *            MT101s that have been generated with cash          *
      *            management instructions matched with a MT103       *
      *            coming from an external source.                    *
      *                                                               *
      *  (c) Finastra International Limited 2002                      *
      *                                                               *
      *  Last Amend No. AR1048221          Date 12Mar13               *
      *  Prev Amend No. MD046248           Date 27Oct17               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CSD031             Date 10Apr06               *
      *                 CSD027             Date 09Dec05               *
      *                 CGL029             Date 01Sep03               *
      *                 212995             Date 07Jan03               *
      *                 211210             Date 11Dec02               *
      *                 CRE008  *CREATE    Date 19Feb02               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  AR1048221 - "+" sign appears even when there are no more     *
      *              records to display when rolling up. Amend to     *
      *              disable roll up properly. (Child: AR1053511)     *
      *  MD046248 - Finastra Rebranding                               *
      *  CSD031 - Enhanced Centralised Static Data (Recompile)        *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CGL029 - Increase Account Code to 10 digits                  *
      *  212995 - Allow deletion of input cycle sweeps                *
      *  211210 - Various action code errors                          *
      *  CRE008 - Cash Management                                     *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  Use of indicators.                                           *
      *                                                               *
      *    21         Enable Command Line for First Screen            *
      *****22****     Enable Command Line for Second Screen           *         212995
      *    22         Enable Command Line for Second Screen (w/o F10) *         212995
      *    23         LOOKUP Indicator                                *
      *    24         Force Input Format                              *
      *    25         MSGCTL Indicator                                *
      *    26         Display 'All MT101' Command Line                *
      *    27         Display 'All Reconciled' Command Line           *
      *    28         Display 'All Not Reconciled' Command Line       *
      *    29         CHAIN Indicator                                 *
      *    30         Invalid Action Code                             *
      *    31         Rollup/Rolldown Indicator                       *
      *    32         Enable Command line for Second Screen w/ F10    *         212995
      *    33         File access error REICSDL4                      *         212995
      *    34         Maintenance mode                                *         212995
      *    35         Enquiry mode                                    *         212995
      *    80         SFLCLR Indicator                                *
      *    81         SFLDSP Indicator                                *
      *    82         Enable Rollup/Rolldown                          *
      *    83         SFLNXTCHG Indicator                             *
      *    84         READC Indicator                                 *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  S U B R O U T I N E  I N D E X                               *
      *                                                               *
      *  SRBuild       -  Build Subfile                               *
      *  SRLoad        -  Load Subfile (All MT101)                    *
      *  SRLoad2       -  Load Subfile (All Reconciled)               *
      *  SRLoad3       -  Load Subfile (All Not Reconciled)             *
      *  SRDisplay     -  Display First Screen                        *
      *  SRProcess     -  Process Subfile Screen                      *
      *  SRVAction     -  Validate Action Code                        *
      *  SREnquire     -  Handle Enquire                              *
      *  SRDelete      -  Handle Delete                               *         212995
      *  SRMoveFS      -  Move File Fields to Screen Fields           *
      *  SRClear       -  Clear Fields                                *
      *  SRDate        -  Convert Date to DDMMMYY                     *
      *  SRDate2       -  Convert Date to Midas Number                *
      *  SRCurrency    -  Access Currency Details                     *
      *  SRSndMsg      -  Send Message                                *
      *                                                               *
      *  *PSSR - Error Processing                                     *
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
 
     FRE102006DFCF   E             WORKSTN INFSR(*PSSR)
     F                                     SFILE(RE102006S0:#0RLRN)
      ** Midas RE MT101/MT103 Reconciliation Enquiry DF
 
     FREICSDL4  IF   E           K DISK    INFSR(*PSSR)
     FREICSDL4X UF   E           K DISK    INFSR(*PSSR) USROPN                  212995
     F                                     RENAME(REICSDD0:REICSDDX)            212995
     F                                     COMMIT                               212995
      ** Midas RE Input Cycle Zero Balancing/Sweeping - Message Produced
 
     FREICSIL0  UF   E           K DISK    INFSR(*PSSR) USROPN                  212995
     F                                     COMMIT                               212995
      ** Midas Input Cycle Zero Balancing/Sweeping Items.                       212995
     FGLPSTTL0  UF   E           K DISK    INFSR(*PSSR) USROPN                  212995
     F                                     RENAME(APOSTPDF:GLPSTTD0)            212995
     F                                     COMMIT                               212995
      ** Midas GL Postings in Transit                                           212995
     FGLPSTZSL0 UF   E           K DISK    INFSR(*PSSR) USROPN                  212995
     F                                     RENAME(GLAPZSD0: GLPSTZSD0)          212995
     F                                     COMMIT                               212995
      ** Midas GL Postings in Transit - Zero Bal/Sweep Exts                     212995
                                                                                212995
     FMGOREFL0  IF   E           K DISK    INFSR(*PSSR)
      ** Midas MG Message Reference by TRNO
 
     FMSIXI2L2  UF A E           K DISK    INFSR(*PSSR)
     F                                     COMMIT
      ** Midas MS Incoming Message Reference by MIR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ D-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
 
      ** Standard D specifications
     D/COPY ZACPYSRC,RECMSTDD
 
      ** The following /COPY line includes all the defined fields in the
      ** PSDS.  They have meaningful names, prefixed by 'PS'.
     D/COPY ZACPYSRC,PSDS
 
      ** +--------------------------------------+
      ** ¦ Named constants                      ¦
      ** ¦ ===============                      ¦
      ** +--------------------------------------+
 
      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
 
     D MONTHS          S              3    DIM(12) CTDATA PERRCD(12)
     D OVR             S             50    DIM(1) PERRCD(1) CTDATA              212995
                                                                                212995
     D WFld            S              1    DIM(17)
 
     D TopAcct         DS
     D  IDCBRC                 1      3
     D**IDCCUS**               4      9  0                                                    CSD027
     D  IDCCUS                 4      9                                                       CSD027
     D  IDCCCY                10     12
     D***IDCACD*               13     16  0                                                   CGL029
     D***IDCASN*               17     18  0                                                   CGL029
     D  IDCACD                13     22  0                                                    CGL029
     D  IDCASN                23     24  0                                                    CGL029
 
      ** External data structure for Bank Details
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
 
      ** External data structure for Currency Details
     D SDCURR        E DS                  EXTNAME(SDCURRPD)
 
      ** Second DS for access programs, long data structure
     D DSSDY         E DS                  EXTNAME(DSSDY)
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
     D PZMsgFile       S             10
     D PZMsgID         S             10
 
      ** Parameters for Access Objects
     D PRtrnCode       S              7
     D POption         S              7
     D PKey1           S              3
 
      ** Parameters for ZDATE2
     D ZDateIn         S              5  0
     D ZDate           S              6  0
     D ZADATE          S              7
 
      ** Parameters for ZDATE1
     D DateIn          S              6
     D DayNoOut        S              5  0
     D PError          S              1
 
      ** Parameters for ZALIGN
     D ZRtCd           S              7
     D ZField          S             16
     D ZADEC           S              1  0
     D ZADIG           S              2  0
 
      ** Parameters for ZSEDIT
     D ZFld15          S             15  0
     D ZECODE          S              1
     D ZOUT21          S             21
 
      ** Parameters for QCLSCAN
     D WQA3N           S              3  0
     D WQB3N           S              3  0
     D WQDEST          S             11
     D WQC3N           S              3  0
     D WQD1            S              1
     D WQE1            S              1
     D WQF1            S              1
     D WQG3N           S              3  0
 
     D WLastRec        S              4  0
     D WRecPag         S              5  0
     D WSflPag         S              3  0
 
     D WError          S              1
     D WReload         S              1
     D WReload2        S              1
     D WSkipRec        S              1
 
     D WRMGD           S              5  0
     D WLast           S              1
 
     D WDay            S              2
     D WMonth          S              2
     D WYear           S              2
     D WMnDy           S              4
     D WMonNm          S              5
     D WMon            S              3
     D WMName          S              3
     D WDate           S              6
     D WMDate          S              7
 
     D X               S              2  0
     D Y               S              2  0
     D PMode           S              1                                         212995
 
      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
 
      *****************************************************************
      /EJECT
      *****************************************************************
 
     IMSIXI2D0
     I              CCY                         MSCCY
     I              SVDT                        MSSVDT
     I              AMTS                        MSAMTS
 
      *****************************************************************
      /EJECT
      *****************************************************************
 
      ** +--- Start of Main processing --------------------------------+
      ** ¦                                                             ¦
      ** ¦ Initial processing is performed automatically: the *INZSR is¦
      ** ¦ executed at program activation.                             ¦
      ** ¦                                                             ¦
      ** +-------------------------------------------------------------+
 
      *****************************************************************
      * MAIN PROCEDURE                                                *
      *****************************************************************
 
      ** Main Program
      *                                                                         212995
     C                   Eval      *IN34 = *off                                 212995
     C                   Eval      *IN35 = *off                                 212995
     C                   If        PMode = 'M'                                  212995
     C                   Eval      *IN34 = *ON                                  212995
     C                   Else                                                   212995
     C                   Eval      *IN35 = *ON                                  212995
     C                   Endif                                                  212995
 
     C                   DOU       *INKC = *ON
 
      ** Initialise and load subfile page
 
     C                   IF        WReload <> 'N' and WError <> 'Y'
     C                   EXSR      SRBuild
     C                   IF        WReload2 = 'N'
     C                   EVAL      WReload = 'N'
     C                   ENDIF
     C                   ENDIF
 
      ** Display screen
 
     C                   EXSR      SRDisplay
 
      ** Process response
 
     C                   IF        *INKC <> *ON
 
     C                   IF        *IN31 = *ON
 
     C                   SELECT
     C                   WHEN      *IN26 = *ON
     C                   EXSR      SRLoad
     C                   WHEN      *IN27 = *ON
     C                   EXSR      SRLoad2
     C                   WHEN      *IN28 = *ON
     C                   EXSR      SRLoad3
     C                   ENDSL
 
     C                   ELSE
 
     C                   IF        *INKP = *ON
     C                   EVAL      #0ROMS = *BLANKS
     C                   EVAL      #0RDES = *BLANKS
     C                   EVAL      #0RMGD = *BLANKS
     C                   EVAL      WReload = 'Y'
     C                   ELSE
 
      ** If file not empty, process subfile
 
     C                   IF        *IN81 = *ON or WReload2 = 'Y'
     C                   EXSR      SRProcess
     C                   ENDIF
 
     C                   ENDIF
 
     C                   ENDIF
 
     C                   ENDIF
 
     C                   ENDDO
 
     C                   EVAL      *INLR = *ON
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRBuild - Build Subfile                                      *
      *                                                               *
      *  Called by: Main                                              *
      *                                                               *
      *  Calls    : SRLoad, SRLoad2, SRLoad3                          *
      *                                                               *
      *****************************************************************
 
     C     SRBuild       BEGSR
 
      ** Initialise and load subfile page
 
     C                   EVAL      *IN80 = *ON
     C                   WRITE     RE102006C0
     C                   EVAL      *IN80 = *OFF
 
     C                   EVAL      *IN81 = *ON
     C                   EVAL      *IN82 = *OFF
 
      ** Reset number of records in subfile
 
     C                   EVAL      WLastRec = 0
 
      ** Clear messages from program message queue
 
     C                   CALL      'ZA0250'
 
      ** Setup key
 
     C     #0ROMS        SETLL     REICSDL4
 
      ** Load subfile page
 
     C                   EVAL      WRecPag = 0
 
     C                   IF        (*IN26 = *OFF and *IN27 = *OFF and
     C                             *IN28 = *OFF) or *IN28 = *ON
     C                   EXSR      SRLoad
     C                   ELSE
 
     C                   IF        *IN26 = *ON
     C                   EXSR      SRLoad2
     C                   ELSE
 
     C                   IF        *IN27 = *ON
     C                   EXSR      SRLoad3
     C                   ENDIF
 
     C                   ENDIF
 
     C                   ENDIF
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRLoad - Load Subfile (All MT101)                            *
      *                                                               *
      *  Called by: SRBuild                                           *
      *                                                               *
      *  Calls    : SRSndMsg, SRDate                                  *
      *                                                               *
      *****************************************************************
 
     C     SRLoad        BEGSR
 
     C                   EVAL      *IN30 = *OFF
     C                   EVAL      *IN26 = *ON
     C                   EVAL      *IN27 = *OFF
     C                   EVAL      *IN28 = *OFF
 
      ** Start at previous highest record in SFL
 
     C                   EVAL      #0RLRN = WLastRec
 
      ** Load next subfile page
 
     C                   DOU       %EOF(REICSDL4) or WRecPag = WSflPag
 
     C                   EVAL      WSkipRec = 'N'
     C                   EVAL      WReload2 = 'N'
 
     C                   READ      REICSDL4
 
      ** Retrieve subfile fields
 
     C                   IF        NOT %EOF(REICSDL4) and IDTPSW = 'T'
     C                             and IDOMSR <> *BLANKS
 
     C                   SELECT
     C                   WHEN      #0RMGD <> *BLANKS AND  IDPRCD <> WRMGD
     C                   EVAL      WSkipRec = 'Y'
 
     C                   WHEN      #0RDES <> *BLANKS
 
     C                   CALL      'QCLSCAN'
     C                   PARM                    IDDEST
     C                   PARM      11            WQA3N
     C                   PARM      1             WQB3N
     C                   PARM      #0RDES        WQDEST
     C                   PARM      11            WQC3N
     C                   PARM      '1'           WQD1
     C                   PARM      '1'           WQE1
     C                   PARM      '?'           WQF1
     C                   PARM                    WQG3N
 
     C                   IF        WQG3N < 1
     C                   EVAL      WSkipRec = 'Y'
     C                   ENDIF
 
     C                   ENDSL
 
     C                   IF        WSkipRec = 'N'
 
      ** Move fields from PF/REICSDPD
 
     C                   EVAL      #0ACTN = *BLANKS
     C                   EVAL      #0OMSR = IDOMSR
     C                   EVAL      #0DEST = IDDEST
     C                   EVAL      #0SMIR = IDSMIR
     C                   EVAL      #0MGTM = IDMSGT
     C                   EVAL      #0MTYN = IDMTYN                              212995
 
     C                   EVAL      ZDateIn = IDPRCD
     C                   EXSR      SRDate
     C                   EVAL      #0MGDE = ZADATE
 
     C                   IF        IDDELD = 'Y'
     C                   EVAL      #0STAT = '*** STOPPED ***'
     C                   ELSE
     C                   IF        IDMTYN <> 'Y' and IDDELD <> 'Y'
     C                   EVAL      #0STAT = '*** NOT RECONCILED ***'
     C                   ELSE
     C                   IF        IDSMIR <> *BLANKS and IDMTYN = 'Y'
     C                   EVAL      #0STAT = '*** RECONCILED ***'
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
 
      ** Move fields from PF/MSIXI2PD
 
     C     IDSMIR        CHAIN     MSIXI2L2                           29
 
     C                   IF        *IN29 = *OFF
     C                   MOVEL     MODE          WYear
     C                   MOVE      MODE          WMnDy
     C                   EVAL      WMonth = WMnDy
     C                   MOVE      WMnDy         WDay
 
     C                   MOVE      WMonth        X
     C                   MOVEA     MONTHS(X)     WMName
     C                   EVAL      #0SDAT = WDay + WMName + WYear
 
     C                   EVAL      #0STIM = MOTM
     C                   ENDIF
 
      ** Output to subfile
 
     C                   ADD       1             #0RLRN               81
     C                   ADD       1             WRecPag
 
     C                   WRITE     RE102006S0
     C                   ENDIF
 
     C                   ENDIF
 
     C                   ENDDO
 
      ** If no records found, display error message
 
     C                   IF        %EOF(REICSDL4) and #0RLRN = 0
     C                   EVAL      *IN81 = *OFF
     C                   EVAL      *IN82 = *ON
     C                   EVAL      WReload = 'Y'
     C                   EVAL      WReload2 = 'Y'
     C                   EVAL      PZMsgID = 'RE74041'
     C                   EVAL      PZMsgFile = 'GBREUSRMSG'
     C                   EXSR      SRSndMsg
     C                   ENDIF
      *                                                                                    AR1048221
     C                   IF        %EOF(REICSDL4)                                          AR1048221
     C                   EVAL      *IN82 = *ON                                             AR1048221
     C                   ENDIF                                                             AR1048221
 
      ** Save highest SFL record
 
     C                   IF        #0RLRN > WLastRec
     C                   EVAL      WLastRec = #0RLRN
     C                   ENDIF
 
     C                   EVAL      WRecPag = 0
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRLoad2 - Load Subfile (All Reconciled)                      *
      *                                                               *
      *  Called by: SRBuild                                           *
      *                                                               *
      *  Calls    : SRSndMsg, SRDate                                  *
      *                                                               *
      *****************************************************************
 
     C     SRLoad2       BEGSR
 
     C                   EVAL      *IN30 = *OFF
     C                   EVAL      *IN26 = *OFF
     C                   EVAL      *IN27 = *ON
     C                   EVAL      *IN28 = *OFF
 
      ** Start at previous highest record in SFL
 
     C                   EVAL      #0RLRN = WLastRec
 
      ** Load next subfile page
 
     C                   DOU       %EOF(REICSDL4) or WRecPag = WSflPag
 
     C                   EVAL      WSkipRec = 'N'
     C                   EVAL      WReload2 = 'N'
 
     C                   READ      REICSDL4
 
      ** Retrieve subfile fields
 
     C                   IF        NOT %EOF(REICSDL4) and IDTPSW = 'T'
     C                             and IDOMSR <> *BLANKS and IDMTYN = 'Y'
     C                             and IDSMIR <> *BLANKS
 
     C                   SELECT
     C                   WHEN      #0RMGD <> *BLANKS AND  IDPRCD <> WRMGD
     C                   EVAL      WSkipRec = 'Y'
 
     C                   WHEN      #0RDES <> *BLANKS
 
     C                   CALL      'QCLSCAN'
     C                   PARM                    IDDEST
     C                   PARM      11            WQA3N
     C                   PARM      1             WQB3N
     C                   PARM      #0RDES        WQDEST
     C                   PARM      11            WQC3N
     C                   PARM      '1'           WQD1
     C                   PARM      '1'           WQE1
     C                   PARM      '?'           WQF1
     C                   PARM                    WQG3N
 
     C                   IF        WQG3N < 1
     C                   EVAL      WSkipRec = 'Y'
     C                   ENDIF
 
     C                   ENDSL
 
     C                   IF        WSkipRec = 'N'
 
      ** Move fields from PF/REICSDPD
 
     C                   EVAL      #0ACTN = *BLANKS
     C                   EVAL      #0OMSR = IDOMSR
     C                   EVAL      #0DEST = IDDEST
     C                   EVAL      #0SMIR = IDSMIR
     C                   EVAL      #0STAT = '*** RECONCILED ***'
     C                   EVAL      #0MGTM = IDMSGT
     C                   EVAL      #0MTYN = IDMTYN                              212995
 
     C                   EVAL      ZDateIn = IDPRCD
     C                   EXSR      SRDate
     C                   EVAL      #0MGDE = ZADATE
 
      ** Move fields from PF/MSIXI2PD
 
     C     IDSMIR        CHAIN     MSIXI2L2                           29
 
     C                   IF        *IN29 = *OFF
     C                   MOVEL     MODE          WYear
     C                   MOVE      MODE          WMnDy
     C                   EVAL      WMonth = WMnDy
     C                   MOVE      WMnDy         WDay
 
     C                   MOVE      WMonth        X
     C                   MOVEA     MONTHS(X)     WMName
     C                   EVAL      #0SDAT = WDay + WMName + WYear
 
     C                   EVAL      #0STIM = MOTM
     C                   ENDIF
 
      ** Output to subfile
 
     C                   ADD       1             #0RLRN               81
     C                   ADD       1             WRecPag
 
     C                   WRITE     RE102006S0
     C                   ENDIF
 
     C                   ENDIF
 
     C                   ENDDO
 
      ** If no records found, display error message
 
     C                   IF        %EOF(REICSDL4) and #0RLRN = 0
     C                   EVAL      *IN81 = *OFF
     C                   EVAL      *IN82 = *ON
     C                   EVAL      WReload = 'Y'
     C                   EVAL      WReload2 = 'Y'
     C                   EVAL      PZMsgID = 'RE74041'
     C                   EVAL      PZMsgFile = 'GBREUSRMSG'
     C                   EXSR      SRSndMsg
     C                   ENDIF
      *                                                                                    AR1048221
     C                   IF        %EOF(REICSDL4)                                          AR1048221
     C                   EVAL      *IN82 = *ON                                             AR1048221
     C                   ENDIF                                                             AR1048221
 
      ** Save highest SFL record
 
     C                   IF        #0RLRN > WLastRec
     C                   EVAL      WLastRec = #0RLRN
     C                   ENDIF
 
     C                   EVAL      WRecPag = 0
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRLoad3 - Load Subfile (All Not Reconciled)                  *
      *                                                               *
      *  Called by: SRBuild                                           *
      *                                                               *
      *  Calls    : SRSndMsg, SRDate                                  *
      *                                                               *
      *****************************************************************
 
     C     SRLoad3       BEGSR
 
     C                   EVAL      *IN30 = *OFF
     C                   EVAL      *IN26 = *OFF
     C                   EVAL      *IN27 = *OFF
     C                   EVAL      *IN28 = *ON
 
      ** Start at previous highest record in SFL
 
     C                   EVAL      #0RLRN = WLastRec
 
      ** Load next subfile page
 
     C                   DOU       %EOF(REICSDL4) or WRecPag = WSflPag
 
     C                   EVAL      WSkipRec = 'N'
     C                   EVAL      WReload2 = 'N'
 
     C                   READ      REICSDL4
 
      ** Retrieve subfile fields
 
     C                   IF        NOT %EOF(REICSDL4) and IDTPSW = 'T'
     C                             and IDOMSR <> *BLANKS and IDMTYN <> 'Y'
     C                             and IDDELD <> 'Y'
 
     C                   SELECT
     C                   WHEN      #0RMGD <> *BLANKS AND  IDPRCD <> WRMGD
     C                   EVAL      WSkipRec = 'Y'
 
     C                   WHEN      #0RDES <> *BLANKS
 
     C                   CALL      'QCLSCAN'
     C                   PARM                    IDDEST
     C                   PARM      11            WQA3N
     C                   PARM      1             WQB3N
     C                   PARM      #0RDES        WQDEST
     C                   PARM      11            WQC3N
     C                   PARM      '1'           WQD1
     C                   PARM      '1'           WQE1
     C                   PARM      '?'           WQF1
     C                   PARM                    WQG3N
 
     C                   IF        WQG3N < 1
     C                   EVAL      WSkipRec = 'Y'
     C                   ENDIF
 
     C                   ENDSL
 
     C                   IF        WSkipRec = 'N'
 
      ** Move fields from PF/REICSDPD
 
     C                   EVAL      #0ACTN = *BLANKS
     C                   EVAL      #0OMSR = IDOMSR
     C                   EVAL      #0DEST = IDDEST
     C                   EVAL      #0SMIR = IDSMIR
     C                   EVAL      #0STAT = '*** NOT RECONCILED ***'
     C                   EVAL      #0MGTM = IDMSGT
     C                   EVAL      #0MTYN = IDMTYN                              212995
 
     C                   EVAL      ZDateIn = IDPRCD
     C                   EXSR      SRDate
     C                   EVAL      #0MGDE = ZADATE
 
      ** Move fields from PF/MSIXI2PD
 
     C     IDSMIR        CHAIN     MSIXI2L2                           29
 
     C                   IF        *IN29 = *OFF
     C                   MOVEL     MODE          WYear
     C                   MOVE      MODE          WMnDy
     C                   EVAL      WMonth = WMnDy
     C                   MOVE      WMnDy         WDay
 
     C                   MOVE      WMonth        X
     C                   MOVEA     MONTHS(X)     WMName
     C                   EVAL      #0SDAT = WDay + WMName + WYear
 
     C                   EVAL      #0STIM = MOTM
     C                   ENDIF
 
      ** Output to subfile
 
     C                   ADD       1             #0RLRN               81
     C                   ADD       1             WRecPag
 
     C                   WRITE     RE102006S0
     C                   ENDIF
 
     C                   ENDIF
 
     C                   ENDDO
 
      ** If no records found, display error message
 
     C                   IF        %EOF(REICSDL4) and #0RLRN = 0
     C                   EVAL      *IN81 = *OFF
     C                   EVAL      *IN82 = *ON
     C                   EVAL      WReload = 'Y'
     C                   EVAL      WReload2 = 'Y'
     C                   EVAL      PZMsgID = 'RE74041'
     C                   EVAL      PZMsgFile = 'GBREUSRMSG'
     C                   EXSR      SRSndMsg
     C                   ENDIF
      *                                                                                    AR1048221
     C                   IF        %EOF(REICSDL4)                                          AR1048221
     C                   EVAL      *IN82 = *ON                                             AR1048221
     C                   ENDIF                                                             AR1048221
 
      ** Save highest SFL record
 
     C                   IF        #0RLRN > WLastRec
     C                   EVAL      WLastRec = #0RLRN
     C                   ENDIF
 
     C                   EVAL      WRecPag = 0
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRDisplay - Display First Screen                             *
      *                                                               *
      *  Called by: Main                                              *
      *                                                               *
      *  Calls    : SRDate2                                           *
      *                                                               *
      *****************************************************************
 
     C     SRDisplay     BEGSR
 
      ** Update screen time
 
     C                   TIME                    #0TIME
 
      ** Seton indicator for appropriate command line
 
     C                   EVAL      *IN21 = *ON
     C                   EVAL      *IN22 = *OFF
     C                   EVAL      *IN32 = *OFF                                 212995
 
      ** Display screen
 
     C                   WRITE     RE102006F0
     C                   WRITE     RE102006F1
     C                   WRITE     RE102006C1
     C                   EXFMT     RE102006C0
 
      ** Clear program message queue
 
     C                   CALL      'ZA0250'
 
     C                   EVAL      WError = 'N'
 
      ** Format Message Date
 
     C                   IF        #0RMGD <> *BLANKS
 
     C                   EVAL      WMDate = #0RMGD
     C                   MOVE      WMDate        WLast
     C                   IF        WLast = *BLANKS
     C                   EVAL      WDate = WMDate
     C                   EVAL      WMDate = *ZEROS
     C                   MOVE      WDate         WMDate
     C                   ENDIF
 
     C                   MOVEL     WMDate        WDay
     C                   MOVE      WMDate        WYear
     C                   EVAL      WMonNm = WMDate
     C                   MOVE      WMonNm        WMon
     C                   EVAL      X = 1
 
     C                   DOW       X < 13
     C                   IF        MONTHS(X) = WMon
     C                   MOVE      X             WMonth
     C                   ENDIF
     C                   EVAL      X = X + 1
     C                   ENDDO
 
     C                   IF        BJDFIN = 'M'
     C                   EVAL      DateIn = WMonth + WDay + WYear
     C                   ELSE
     C                   EVAL      DateIn = WDay + WMonth + WYear
     C                   ENDIF
 
     C                   EXSR      SRDate2
     C                   EVAL      WRMGD = DayNoOut
     C                   ENDIF
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRProcess - Process Subfile Screen                           *
      *                                                               *
      *  Called by: Main                                              *
      *                                                               *
      *  Calls    : SRVAction, SREnquire                              *
      *                                                               *
      *****************************************************************
 
     C     SRProcess     BEGSR
 
     C                   IF        #0ROMS <> *BLANKS or #0RDES <> *BLANKS
     C                             or #0RMGD <> *BLANKS or WReload2 = 'Y'
     C                   EVAL      WReload = 'Y'
     C                   ELSE
 
     C                   READC     RE102006S0                             84
 
     C                   DOW       *IN84 = *OFF and *INKC = *OFF
 
     C                   EVAL      *IN30 = *OFF
     C                   EVAL      *IN24 = *OFF
 
      ** Validate Action Code
 
     C                   IF        #0ACTN <> *BLANKS
     C                   EXSR      SRVAction
 
     C                   IF        *IN30 = *ON
     C                   EVAL      *IN24 = *ON
     C                   ELSE
     C                   EVAL      *IN24 = *OFF
 
      ** Process Action Code
 
     C                   IF        WError = 'N'
     C                   IF        #0ACTN = 'D'                                 212995
     C                   EXSR      SRDelete                                     212995
     C                   Else                                                   212995
     C                   EXSR      SREnquire
     C                   Endif                                                  212995
     C                   ENDIF
 
     C                   ENDIF
 
     C                   IF        *IN84 = *OFF
 
      ** If there is an error, seton SFLNXTCHG indicator
 
     C                   IF        *IN24 = *ON
     C                   EVAL      *IN83 = *ON
     C                   ELSE
     C                   EVAL      *IN83 = *OFF
     C                   ENDIF
 
     C                   ENDIF
 
     C                   ENDIF
 
     C                   IF        *IN84 = *OFF
     C                   UPDATE    RE102006S0
     C                   READC     RE102006S0                             84
     C                   ENDIF
 
     C                   ENDDO
 
     C                   ENDIF
 
     C                   IF        *INKC <> *ON and WError = 'N'
 
     C                   EVAL      WReload = 'Y'
 
     C                   SELECT
 
     C                   WHEN      *IN26 = *ON
     C                   EVAL      *IN26 = *OFF
     C                   EVAL      *IN27 = *OFF
     C                   EVAL      *IN28 = *ON
 
     C                   WHEN      *IN27 = *ON
     C                   EVAL      *IN26 = *ON
     C                   EVAL      *IN27 = *OFF
     C                   EVAL      *IN28 = *OFF
 
     C                   WHEN      *IN28 = *ON
     C                   EVAL      *IN26 = *OFF
     C                   EVAL      *IN27 = *ON
     C                   EVAL      *IN28 = *OFF
 
     C                   ENDSL
 
     C                   ENDIF
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRVAction - Validate Action Code                             *
      *                                                               *
      *  Called by: SRProcess                                         *
      *                                                               *
      *  Calls    : SRSndMsg                                          *
      *                                                               *
      *****************************************************************
 
     C     SRVAction     BEGSR
 
     C                   EVAL      *IN30 = *OFF
 
      ** If entered, action code must be 'E'                                    212995
                                                                                212995
     C                   IF        #0ACTN <> 'E' and #0ACTN <> *BLANKS
     C                             and PMode  = 'E'                             212995
     C                   EVAL      *IN30 = *ON
     C                   EVAL      *IN82 = *ON
     C                   EVAL      WError = 'Y'
     C                   EVAL      PZMsgID = 'RE74063'
     C                   EVAL      PZMsgFile = 'GBREUSRMSG'
     C                   EXSR      SRSndMsg
     C                   ENDIF
                                                                                212995
      ** Action code can't be 'D' if the sweep is already matched               212995
                                                                                212995
     C                   IF        #0ACTN = 'D' and #0MTYN = 'Y'                212995
     C                             and PMode = 'M'                              212995
     C                   EVAL      *IN30 = *ON                                  212995
     C                   EVAL      *IN82 = *ON                                  212995
     C                   EVAL      WError = 'Y'                                 212995
     C                   EVAL      PZMsgID = 'RE74073'                          212995
     C                   EVAL      PZMsgFile = 'GBREUSRMSG'                     212995
     C                   EXSR      SRSndMsg                                     212995
     C                   ENDIF                                                  212995
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SREnquire - Handle Enquire                                   *
      *                                                               *
      *  Called by: SRProcess                                         *
      *                                                               *
      *  Calls    : SRClear, SRMoveFS                                 *
      *                                                               *
      *****************************************************************
 
     C     SREnquire     BEGSR
 
     C                   EXSR      SRClear
     C                   EXSR      SRMoveFS
 
      ** Update screen time
 
     C                   TIME                    #0TIME
 
     C                   EVAL      *IN21 = *OFF
     C                   EVAL      *IN22 = *ON
     C                   EVAL      *IN32 = *OFF                                 212995
 
     C                   WRITE     RE102006F0
     C                   WRITE     RE102006F1
     C                   WRITE     RE102006C1
     C                   EXFMT     RE102006D0
 
      ** Clear messages from program message queue
 
     C                   CALL      'ZA0250'
 
     C                   EVAL      WReload = 'Y'
 
     C                   ENDSR
                                                                                212995
      *****************************************************************         212995
      /EJECT                                                                    212995
      *****************************************************************         212995
      *                                                               *         212995
      *  SRDelete  - Handle Delete                                    *         212995
      *                                                               *         212995
      *  Called by: SRProcess                                         *         212995
      *                                                               *         212995
      *  Calls    : SRClear, SRMoveFS, SRSndMsg                       *         212995
      *                                                               *         212995
      *****************************************************************         212995
                                                                                212995
     C     SRDelete      BEGSR                                                  212995
                                                                                212995
     C                   EXSR      SRClear                                      212995
     C                   EXSR      SRMoveFS                                     212995
                                                                                212995
      ** Update screen time                                                     212995
                                                                                212995
     C                   TIME                    #0TIME                         212995
                                                                                212995
     C                   EVAL      *IN21 = *OFF                                 212995
     C                   EVAL      *IN22 = *OFF                                 212995
     C                   EVAL      *IN32 = *ON                                  212995
                                                                                212995
     C                   WRITE     RE102006F0                                   212995
     C                   WRITE     RE102006F1                                   212995
     C                   WRITE     RE102006C1                                   212995
     C                   EXFMT     RE102006D0                                   212995
                                                                                212995
      ** Clear messages from program message queue                              212995
                                                                                212995
     C                   CALL      'ZA0250'                                     212995
                                                                                212995
     C                   IF        *INKJ = *ON                                  212995
                                                                                212995
     C     #0OMSR        CHAIN     REICSDDX                           33        212995
                                                                                212995
     C                   IF        *IN33 = *ON                                  212995
     C                   EVAL      WError = 'Y'                                 212995
     C                   EVAL      PZMsgID = 'Y2U0004'                          212995
     C                   EVAL      PZMsgFile = 'GBY2USRMSG'                     212995
     C                   EXSR      SRSndMsg                                     212995
                                                                                212995
     C                   ELSE                                                   212995
                                                                                212995
      *  Delete REICSDPD record                                                 212995
     C                   DELETE    REICSDDX                             33      212995
                                                                                212995
     C                   IF        *IN33 = *ON                                  212995
     C                   EVAL      WError = 'Y'                                 212995
     C                   EVAL      PZMsgID = 'Y2U0004'                          212995
     C                   EVAL      PZMsgFile = 'GBY2USRMSG'                     212995
     C                   EXSR      SRSndMsg                                     212995
     C                   ROLBK                                                  212995
                                                                                212995
     C                   ELSE                                                   212995
                                                                                212995
      *  Read associated REICSIPD records                                       212995
                                                                                212995
     C     KSWPITMS      SETLL     REICSID0                                     212995
     C     KSWPITMS      READE     REICSID0                               33    212995
                                                                                212995
      * For each item record                                                    212995
                                                                                212995
     C                   DOW       *IN33 = *OFF                                 212995
                                                                                212995
      * Delete the item record                                                  212995
                                                                                212995
     C                   DELETE    REICSID0                                     212995
                                                                                212995
      * Delete 'posting in transit'                                             212995
                                                                                212995
     C     POSTK         CHAIN     GLPSTTD0                           33        212995
     C  N33              DELETE    GLPSTTD0                                     212995
                                                                                212995
      * Delete 'posting in transit' extension                                   212995
                                                                                212995
     C     POSTK         CHAIN     GLPSTZSD0                          33        212995
     C  N33              DELETE    GLPSTZSD0                                    212995
                                                                                212995
     C     KSWPITMS      READE     REICSID0                               33    212995
     C                   ENDDO                                                  212995
                                                                                212995
      ** Commit Changes                                                         212995
     C                   COMMIT                                                 212995
                                                                                212995
     C                   ENDIF                                                  212995
     C                   ENDIF                                                  212995
     C                   ENDIF                                                  212995
                                                                                212995
     C                   EVAL      WReload = 'Y'                                212995
                                                                                212995
     C                   ENDSR                                                  212995
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRMoveFS - Move File Fields to Screen Fields                 *
      *                                                               *
      *  Called by: SREnquire                                         *
      *                                                               *
      *  Calls    : SRCurrency                                        *
      *                                                               *
      *****************************************************************
 
     C     SRMoveFS      BEGSR
 
     C                   EVAL      #0STT1 = #0STAT
     C                   EVAL      #0OMS1 = #0OMSR
     C                   EVAL      #0DES1 = #0DEST
     C                   EVAL      #0SMI1 = #0SMIR
 
     C     #0OMSR        CHAIN     REICSDL4                           29
 
     C                   IF        *IN29 = *OFF
     C                   EVAL      #0TOPA = TopAcct
     C                   EVAL      #0EXA1 = IDEXA1
     C                   EVAL      #0SMSR = IDSMSR
     C                   ENDIF
 
     C     #0OMSR        CHAIN     MGOREFL0                           29
 
     C                   IF        *IN29 = *OFF
 
      ** Format Value Date for MT101 Details
 
     C                   EVAL      WYear = SVDT
     C                   MOVE      SVDT          WMnDy
     C                   EVAL      WMonth = WMnDy
     C                   MOVE      WMnDy         WDay
 
     C                   MOVE      WMonth        X
     C                   MOVEA     MONTHS(X)     WMName
     C                   EVAL      #0SVD1 = WDay + WMName + WYear
 
      ** Format Amount for MT101 Details
 
     C                   EVAL      ZField = AMTS
 
      ** Replace ',' with '.' for conversion
 
     C                   MOVEA     ZField        WFld
     C                   EVAL      X = 1
     C     ','           LOOKUP    WFld(X)                                23
     C                   IF        *IN23 = *ON
     C                   EVAL      WFld(X) = '.'
     C                   ENDIF
 
      ** Remove leading zeros before amount
 
     C                   EVAL      X = 1
     C                   DOW       WFld(X) = '0' or WFld(X) = ' ' and
     C                             X < 17
     C                   IF        WFld(X) = '0'
     C                   EVAL      WFld(X) = ' '
     C                   ENDIF
     C                   ADD       1             X
     C                   ENDDO
 
     C                   EVAL      PKey1 = CCY
     C                   EXSR      SRCurrency
 
     C                   MOVEA     WFld          ZField
     C                   EVAL      ZADEC = A6NBDP
     C                   EVAL      ZADIG = 15 - ZADEC
 
     C                   CALLB     'ZALIGN'
     C                   PARM                    ZRtCd
     C                   PARM                    ZField
     C                   PARM                    ZADEC
     C                   PARM                    ZADIG
 
     C                   MOVE      ZField        ZFld15
 
     C                   CALLB     'ZSEDIT'
     C                   PARM                    ZFld15
     C                   PARM                    ZADEC
     C                   PARM      *BLANKS       ZECODE
     C                   PARM                    ZOUT21
 
     C                   EVAL      #0AMT1 = ZOUT21
 
     C                   ENDIF
 
     C     #0SMIR        CHAIN     MSIXI2L2                           29
 
     C                   IF        *IN29 = *OFF
 
      ** Format Value Date for MT103 Details
 
     C                   EVAL      WYear = MSSVDT
     C                   MOVE      MSSVDT        WMnDy
     C                   EVAL      WMonth = WMnDy
     C                   MOVE      WMnDy         WDay
 
     C                   MOVE      WMonth        X
     C                   MOVEA     MONTHS(X)     WMName
     C                   EVAL      #0SVD2 = WDay + WMName + WYear
 
      ** Format Amount for MT103 Details
 
     C                   EVAL      ZField = MSAMTS
 
      ** Replace ',' with '.' for conversion
 
     C                   MOVEA     ZField        WFld
     C                   EVAL      X = 1
     C     ','           LOOKUP    WFld(X)                                23
     C                   IF        *IN23 = *ON
     C                   EVAL      WFld(X) = '.'
     C                   ENDIF
 
      ** Remove leading zeros before amount
 
     C                   EVAL      X = 1
     C                   DOW       WFld(X) = '0' or WFld(X) = ' ' and
     C                             X < 17
     C                   IF        WFld(X) = '0'
     C                   EVAL      WFld(X) = ' '
     C                   ENDIF
     C                   ADD       1             X
     C                   ENDDO
 
     C                   EVAL      PKey1 = MSCCY
     C                   EXSR      SRCurrency
 
     C                   MOVEA     WFld          ZField
     C                   EVAL      ZADEC = A6NBDP
     C                   EVAL      ZADIG = 15 - ZADEC
 
     C                   CALLB     'ZALIGN'
     C                   PARM                    ZRtCd
     C                   PARM                    ZField
     C                   PARM                    ZADEC
     C                   PARM                    ZADIG
 
     C                   MOVE      ZField        ZFld15
 
     C                   CALLB     'ZSEDIT'
     C                   PARM                    ZFld15
     C                   PARM                    ZADEC
     C                   PARM      *BLANKS       ZECODE
     C                   PARM                    ZOUT21
 
     C                   EVAL      #0AMT2 = ZOUT21
 
     C                   ENDIF
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRClear - Clear Fields                                       *
      *                                                               *
      *  Called by: SREnquire                                         *
      *                                                               *
      *  Calls    : None                                              *
      *                                                               *
      *****************************************************************
 
     C     SRClear       BEGSR
 
     C                   EVAL      #0ACTN = *BLANKS
     C                   EVAL      #0STT1 = *BLANKS
     C                   EVAL      #0OMS1 = *BLANKS
     C                   EVAL      #0DES1 = *BLANKS
     C                   EVAL      #0SVD1 = *BLANKS
     C                   EVAL      #0AMT1 = *BLANKS
     C                   EVAL      #0TOPA = *BLANKS
     C                   EVAL      #0EXA1 = *BLANKS
     C                   EVAL      #0SMI1 = *BLANKS
     C                   EVAL      #0SMSR = *BLANKS
     C                   EVAL      #0SVD2 = *BLANKS
     C                   EVAL      #0AMT2 = *BLANKS
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRDate - Convert Date to DDMMMYY                              *
      *                                                               *
      * Called by: SRLoad, SRLoad2, SRLoad3                           *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
 
     C     SRDate        BEGSR
 
     C                   CALLB     'ZDATE2'
     C                   PARM                    ZDateIn
     C                   PARM                    BJDFIN
     C                   PARM      *ZEROS        ZDate
     C                   PARM      *BLANKS       ZADATE
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRDate2 - Convert Date to Midas Number                        *
      *                                                               *
      * Called by: SRDisplay                                          *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
 
     C     SRDate2       BEGSR
 
     C                   CALLB     'ZDATE1'
     C                   PARM                    DateIn
     C                   PARM                    DayNoOut
     C                   PARM                    BJDFIN
     C                   PARM                    PError
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRCurrency - Access Currency Details                          *
      *                                                               *
      * Called by: SRMoveFS                                           *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
 
     C     SRCurrency    BEGSR
 
     C                   CALLB     'AOCURRR0'
     C                   PARM      '*MSG   '     PRtrnCode
     C                   PARM      '*KEY   '     POption
     C                   PARM                    PKey1
     C     SDCURR        PARM      SDCURR        DSSDY
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRSndMsg - Send Message                                      *
      *                                                               *
      *  Called by: SRVAction, SRLoad, SRLoad2, SRLoad3               *
      *                                                               *
      *  Calls    : None                                              *
      *                                                               *
      *****************************************************************
 
     C     SRSndMsg      BEGSR
 
     C                   CALL      'ZA0340'
     C                   PARM                    PZMsgFile
     C                   PARM                    PZMsgID
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  *INZSR - Program Initialisation Routine                      *
      *                                                               *
      *  Called by: Implicitly on program activation                  *
      *                                                               *
      *  Calls    : None                                              *
      *                                                               *
      *****************************************************************
 
     C     *INZSR        BEGSR
                                                                                212995
     C     *ENTRY        PLIST                                                  212995
     C                   PARM                    PMode                          212995
                                                                                212995
     C                   MOVEL     'ZS '         ZSRFI             3            212995
 
      ** Call Access Program for Bank Details
 
     C                   CALLB     'AOBANKR0'
     C                   PARM      *BLANKS       PRtrnCode
     C                   PARM      '*FIRST '     POption
     C     SDBANK        PARM      SDBANK        DSSDY
 
     C                   IF        PRtrnCode <> *BLANKS
     C                   EVAL      X_ERMS = 'Database error in file SDBANKPD'
     C                   EXSR      *PSSR
     C                   ENDIF
 
      ** Initialise subfile control
 
     C                   EVAL      #0RUNA = BJMRDT
     C                   EVAL      #0WSID = PSJobName
     C                   EVAL      #0USER = PSUser
     C                   EVAL      #1PGMQ = PSProcName
 
     C                   Z-ADD     5             WSflPag
                                                                                212995
      * Open files for update                                                   212995
                                                                                212995
     C     PMode         IFEQ      'M'                                          212995
     C                   CALL      'QCMDEXC'                                    212995
     C                   PARM                    OVR                            212995
     C                   PARM      50            LEN              15 5          212995
     C                   OPEN      REICSDL4X                                    212995
     C                   OPEN      REICSIL0                                     212995
     C                   OPEN      GLPSTTL0                                     212995
     C                   OPEN      GLPSTZSL0                                    212995
     C                   ENDIF                                                  212995
                                                                                212995
      ** Key to Input Cycle Zero Balancing/Sweeping Items.                      212995
     C     KSWPITMS      KLIST                                                  212995
     C                   KFLD                    IDHIER                         212995
     C                   KFLD                    IDLINK                         212995
     C                   KFLD                    IDPRCD                         212995
     C                   KFLD                    IDSNUM                         212995
      * Key to related postings/extensions.                                     212995
     C     POSTK         KLIST                                                  212995
     C                   KFLD                    ZSRFI                          212995
     C                   KFLD                    IIXRFN                         212995
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      /COPY ZACPYSRC,RECMPSSR
      ********************************************************************
**   MONTHS - Months Short Names
JANFEBMARAPRMAYJUNJULAUGSEPOCTNOVDEC
** OVR                                                                          212995
OVRDBF FILE(REICSDL4X) TOFILE(REICSDL4) SHARE(*NO)                              212995
