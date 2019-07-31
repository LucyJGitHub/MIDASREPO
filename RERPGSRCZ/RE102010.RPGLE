     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas RE In MT101/MT103 Processed by Cash Managemt')
      *****************************************************************
      *                                                               *
      *  Midas - Retail Module                                        *
      *                                                               *
      *  RE102010 - Incoming MT101/MT103 Processed by Cash Management *
      *                                                               *
      *  Function: This module displays the overview of the MT101s    *
      *            and MT103s processed by Cash Management            *
      *                                                               *
      *  (c) Finastra International Limited 2002                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *  Prev Amend No. CSD027             Date 09Dec05               *
      *                 CGL029             Date 01Sep03               *
      *                 214360             Date 03Feb03               *
      *                 211210             Date 11Dec02               *
      *                 CRE008  *CREATE    Date 10Jun02               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CGL029 - Increase Account Code to 10 digits                  *
      *  214360 - Cash Management Deferred Posting                    *
      *  211210 - Various action code errors                          *
      *  CRE008 - Cash Management                                     *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  Use of indicators.                                           *
      *                                                               *
      *    01         SFLCLR indicator                                *
      *    02         SFLDSP indicator                                *
      *    03         SFLDSPCTL indicator                             *
      *    04         Rollup indicator                                *
      *    05         Subfile Change indicator                        *
      *    06         Show 'Enquire' and 'Rollup/Rolldown' in screen  *
      *    07         End of File REICSDL7                            *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  S U B R O U T I N E  I N D E X                               *
      *                                                               *
      *  SRBldSubf    - Build subfile record                          *
      *  SRFmtScrFlds - Format screen fields                          *
      *  SRDspScrn    - Display records on screen                     *
      *  SRChkActn    - Check action made after display of screen     *
      *  SRChkIn      - Check input fields                            *
      *  SRChkRec     - Check record if the same with selection       *
      *  SREnquire    - Process enquiry on records                    *
      *  *INZSR       - Initialise                                    *
      *  *PSSR        - Error processing                              *
      *                                                               *
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
 
      ** Midas RE I/C Zero Balancing/Sweeping Details
     FREICSDL7  IF   E           K DISK    INFSR(*PSSR)
 
      ** Midas MS In msg index by MIR + out date
     FMSIXI2LI  IF   E           K DISK    INFSR(*PSSR)
 
      ** Midas ME I.M Control  By Message Input Ref.
     FMEINCRL2  IF   E           K DISK    INFSR(*PSSR)
 
      ** Browse screen
     FRE102010DFCF   E             WORKSTN
     F                                     SFILE(RE102010S0:WRRN)
     F                                     INFSR(*PSSR)
 
      *****************************************************************
      /EJECT
      *****************************************************************
 
      ** +--------------------------------------+
      ** ¦ Automatically included D-specs       ¦
      ** ¦ ==============================       ¦
      ** +--------------------------------------+
 
      **--------------------------------------------------------------------------------------------
      * Standard D Specifications
     D/COPY ZACPYSRC,RECMSTDD
      **--------------------------------------------------------------------------------------------
 
      **--------------------------------------------------------------------------------------------
      ** The following /COPY line includes all the defined fields in the
      ** Program Status Data Structures.  They have meaningful
      ** names, prefixed by 'PS'.
     D/COPY ZACPYSRC,PSDS
      **--------------------------------------------------------------------------------------------
 
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
 
     D Up              C                   'ABCDEFGHIJKLMNOPQRSTUVWXYZ'
     D Lo              C                   'abcdefghijklmnopqrstuvwxyz'
 
      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
 
      * Cash Management Hierarchy Details
     D O_CMHD        E DS                  EXTNAME(RECMHDPD)
      * Zero Balancing/Sweeping Hierarchy Details
     D O_ZSHD        E DS                  EXTNAME(REZSHDPD)
     D A_HIER                  1      9
      * Group Account Hierarchy Details
     D O_GAHD        E DS                  EXTNAME(REGAHDPD)
 
     D NARR            S             15    DIM(3) CTDATA PERRCD(1)
     D MONTHS          S              3    DIM(12) CTDATA PERRCD(12)
     D WArMir          S             28    DIM(400)
 
      ** Externally described DS for bank details
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
 
      ** DS for access programs - short data structure
     D DSFDY         E DS                  EXTNAME(DSFDY)
 
     D DSTOPA          DS
     D  WCBRC                  1      3
     D  WDAS1                  4      4
     D  WCCUS                  5     10
     D  WDAS2                 11     11
     D  WCCCY                 12     14
     D  WDAS3                 15     15
     D***WCACD**               16     19                                                      CGL029
     D***WDAS4**               20     20                                                      CGL029
     D***WCASN**               21     22                                                      CGL029
     D  WCACD                 16     25                                                       CGL029
     D  WDAS4                 26     26                                                       CGL029
     D  WCASN                 27     28                                                       CGL029
 
     D DSINPUT         DS
     D  WPISND                 1     11
     D  WPIDAT                12     17
     D  WPITIM                18     25
     D  WPIMSR                26     41
     D  WPIMST                42     44
     D  WPIMSS                45     59
 
     D DSTIME          DS
     D  WHour                  1      2
     D  WColon1                3      3
     D  WMin                   4      5
     D  WColon2                6      6
     D  WSec                   7      8
 
      ** +--------------------------------------+
      ** ¦ D-specs: Declared variables          ¦
      ** ¦ =======  ==================          ¦
      ** +--------------------------------------+
 
      ** Parameters for access object programs
     D PRTCD           S              7A
     D POPTN           S              7A
 
      ** Parameters for ZSEDIT
     D PINAMT          S             15  0
     D PDECPL          S              1  0
     D PCODE           S              1A
     D POUTAMT         S             21A
 
      ** Parameters for ME1060
     DPPARM            DS            11
     D  PMSGR                  1      8S 0
 
     D PKPRT           S              3  0
     D PACTN           S              1A
     D PFTAC           S              2A
     D PFTRF           S            256A
     D PMIR            S             28A
 
      ** Other fields used
     D WRrn            S              5P 0
     D WCnt            S              3  0
     D WRecOk          S              1A
     D WSIMST          S              1A
     D WSISND          S              1A
     D WSIDAT          S              1A
     D WSITIM          S              1A
     D WSIMSS          S              1A
     D WPInput         S             59A
     D WX1             S              3  0
     D WX2             S              3  0
     D WTime           S              6A
     D WOTime          S              8A
     D WIMSS           S             13A
     D WMSGS           S             13A
     D WDate           S              6A
     D WYear           S              2A
     D WMon            S              2A
     D WDay            S              2A
     D WMonth          S              3A
     D WMDate          S              7A
     D WLast           S              1A
     D X               S              2  0
     D POS             S              1  0
 
      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
 
      *****************************************************************
      /EJECT
      *****************************************************************
 
      ** +--- Start of Main processing -------------------------------+
      ** ¦                                                            ¦
      ** ¦ *INZSR is executed at program activation.                  ¦
      ** ¦                                                            ¦
      ** +------------------------------------------------------------+
 
      *****************************************************************
      * MAIN PROCEDURE                                                *
      *****************************************************************
 
      ** Build record subfile
 
     C                   EXSR      SRBldSubf
 
      ** Display records on screen
 
     C                   EXSR      SRDspScrn
 
      ** End program when F3 is pressed
 
     C                   EVAL      *INLR = *ON
 
      *****************************************************************
      *  P R O G R A M   E N D                                        *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRBldSubf - Build record subfile                             *
      *                                                               *
      *  Called by: Main Processing, SRChkActn                        *
      *                                                               *
      *  Calls: SRFmtScrFlds, SRChkRec                                *
      *                                                               *
      *****************************************************************
     C     SRBldSubf     BEGSR
 
      ** Initialise subfile relative record number
 
     C                   EVAL      WRrn  = *ZERO
 
      **  Clear subfile before refilling by writing control record
      **  with SFLCLR active
 
     C                   EVAL      *IN01 = *ON
     C                   WRITE     RE102010C0
     C                   EVAL      *IN01 = *OFF
 
      ** Read record
 
     C     KSNDR         SETLL     REICSDL7
     C                   READ      REICSDL7                               07
 
      ** Enable SFLDSP and seton ROLLUP indicator to drive intial loop
 
     C                   EVAL      *IN02 = *ON
     C                   EVAL      *IN04 = *ON
 
      ** Loop 1: Read records from the file until end of file or
      **         ROLLUP has not been entered
 
     C                   DOW       NOT %EOF(REICSDL7) AND
     C                             *IN04 = *ON
 
 
      ** Initialise/Reset count of records written to subfile page
 
     C                   EVAL      WCnt = *ZERO
 
      ** Loop 2: Write each record read to subfile until end of file
      **         or subfile page is full
 
     C                   DOW       NOT %EOF(REICSDL7) AND
     C                             WCnt < 5
 
      ** Format screen fields for display
 
     C                   EXSR      SRFmtScrFlds
 
     C                   EXSR      SRChkRec
 
     C                   IF        WRecOk = 'Y'
 
      ** Increment the subfile record no. and records written fields
 
     C                   ADD       1             WRrn
     C                   ADD       1             WCnt
 
      ** Write the record to subfile
 
     C                   WRITE     RE102010S0
 
     C                   ENDIF
 
      ** Read next record
 
     C                   READ      REICSDL7                               07
 
      ** End of Loop 2
 
     C                   ENDDO
 
      ** End of Loop 1
 
     C                   ENDDO
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRFmtScrFlds - Format screen fields for output               *
      *                                                               *
      *  Called by: SRBldSubf                                         *
      *                                                               *
      *  Calls: None                                                  *
      *                                                               *
      *****************************************************************
     C     SRFmtScrFlds  BEGSR
 
      ** Write details to corresponding screen fields
 
     C                   EVAL      #0SNDR = IDSNDR
     C                   EVAL      #0OMSR = IDOMSR
 
     C                   IF        IDSMIR <> *BLANKS
     C     IDSMIR        CHAIN     MSIXI2LI
     C                   IF        NOT %FOUND(MSIXI2LI)
     C     *LOCK         IN        LDA
     C                   EVAL      DBKey = IDSMIR
     C                   EVAL      DBFile = 'MSIXI2LI'
     C                   EVAL      DBase = 004
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ELSE
     C                   EVAL      #0MSGT = MTPY
     C                   EVAL      #0MIR = MIR
 
      ** Format Date
 
     C                   MOVE      MODE          WDate
     C                   EVAL      WYear = %SUBST(WDate:1:2)
     C                   EVAL      WMon = %SUBST(WDate:3:2)
     C                   EVAL      WDay = %SUBST(WDate:5:2)
 
     C                   MOVE      WMon          X
     C                   MOVE      MONTHS(X)     WMonth
 
     C                   IF        BJDFIN = 'M'
     C                   EVAL      #0DATE = WMonth + WDay + WYear
     C                   ELSE
     C                   EVAL      #0DATE = WDay + WMonth + WYear
     C                   ENDIF
 
     C                   EVAL      #0TIME = MOTM
     C                   MOVE      #0TIME        WTime
     C                   EVAL      WHour = %SUBST(WTime:1:2)
     C                   EVAL      WMin = %SUBST(WTime:3:2)
     C                   EVAL      WSec = %SUBST(WTime:5:2)
     C                   EVAL      WOTime = DSTIME
     C                   ENDIF
     C                   ENDIF
 
     C                   Z-ADD     0             POS
     C     IDAMNT        IFEQ      0
     C                   Z-ADD     1             POS
     C                   ELSE
     C     IDTPSW        IFEQ      'S'
     C                   Z-ADD     2             POS
     C                   ENDIF
     C     IDTPSW        IFEQ      'T'
     C                   Z-ADD     3             POS
     C                   ENDIF
     C                   ENDIF
     C     POS           IFNE      0
     C                   MOVEL     NARR(POS)     #0MSGS
     C                   ENDIF
 
     C                   MOVE      IDCBRC        WCBRC
     C                   MOVE      IDCCUS        WCCUS
     C                   MOVE      IDCCCY        WCCCY
     C                   MOVE      IDCACD        WCACD
     C                   MOVE      IDCASN        WCASN
     C                   EVAL      #0TOPA = DSTOPA
 
     C     IDAMNT        IFNE      0
     C                   EVAL      PINAMT = IDAMNT
     C                   ELSE
     C                   EVAL      PINAMT = IDSWFA
     C                   ENDIF
     C                   EVAL      PDECPL = 2
     C                   EVAL      PCODE = *BLANKS
     C                   EVAL      POUTAMT = *BLANKS
     C                   CALLB     'ZSEDIT'
     C                   PARM                    PINAMT
     C                   PARM                    PDECPL
     C                   PARM                    PCODE
     C                   PARM                    POUTAMT
     C                   EVAL      #0AMNT = POUTAMT
 
     C                   CALLB     'RE100601'
      * Return code
      * Error Message
     C                   PARM      *BLANK        X_RTCD
     C                   PARM      *BLANK        X_ERMS
      * Option
     C                   PARM      '*EXCLCM'     X_OPTN            7
      * Hierarchy ID
     C                   PARM      IDHIER        I_HIER            9 0
      * Hierarchy Type
     C                   PARM      *BLANK        I_HTYP            2
 
     C                   PARM                    O_CMHD
     C                   PARM                    O_ZSHD
     C                   PARM                    O_GAHD
 
      * End if error occurred in module
      * or if no record found
 
     C     X_RTCD        IFEQ      '*ERROR'
     C     X_RTCD        OREQ      '*NOREC'
     C                   EVAL      X_ERMS = 'BAD HIERARCHY DETAIL:' + A_HIER
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   If        IDDSTT = 'R' or
     C                             IDDSTT = 'N'
     C                   Movel     ZDDEST        #0SETA
     C                   Else
     C                   Movel     ZDSNDC        #0SETA
     C                   Endif
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRDspScrn - Display output                                   *
      *                                                               *
      *  Called by: Main Processing                                   *
      *                                                               *
      *  Calls: SrChkActn                                             *
      *                                                               *
      *****************************************************************
     C     SRDspScrn     BEGSR
 
      ** Display screen until F3 is pressed
 
     C                   DOW       *INKC = *OFF
 
     C                   EVAL      WPIMSR = #0IMSR
     C                   EVAL      WPIMST = #0IMST
     C                   EVAL      WPISND = #0ISND
     C                   EVAL      WPIDAT = #0IDAT
     C                   EVAL      WPITIM = #0ITIM
     C                   EVAL      WPIMSS = #0IMSS
     C                   MOVE      DSINPUT       WPInput
 
      ** If no record read, disable SFLDSP and write 'No Details'
      ** record format
 
     C                   IF        WRrn = *ZERO And
     C                             WCnt = *ZERO
 
     C                   EVAL      *IN02 = *OFF
     C                   EVAL      *IN06 = *OFF
     C                   WRITE     RE102010F0
     C                   WRITE     RE102010F1
     C                   WRITE     RE102010F2
     C                   EXFMT     RE102010C0
 
     C                   EXSR      SrChkActn
 
     C                   ELSE
 
      ** Display subfile record
 
     C                   EVAL      *IN06 = *ON
     C                   WRITE     RE102010F0
     C                   WRITE     RE102010F1
     C                   EXFMT     RE102010C0
 
     C                   EXSR      SrChkActn
 
     C                   ENDIF
 
      ** If F3 is pressed, end the program
 
     C                   ENDDO
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRChkActn - Check action made after display of screen        *
      *                                                               *
      *  Called by: SRDspScrn                                         *
      *                                                               *
      *  Calls: SrChkIn, SrBldSubf, SREnquire                         *
      *                                                               *
      *****************************************************************
     C     SRChkActn     BEGSR
 
     C                   EVAL      WPIMSR = #0IMSR
     C                   EVAL      WPIMST = #0IMST
     C                   EVAL      WPISND = #0ISND
     C                   EVAL      WPIDAT = #0IDAT
     C                   EVAL      WPITIM = #0ITIM
     C                   EVAL      WPIMSS = #0IMSS
 
      ** Check if positioning required or selection made
 
     C                   IF        DSINPUT <> WPInput
 
      ** Check input fields
 
     C                   EXSR      SRChkIn
 
      ** Rebuild subfile
 
     C                   EXSR      SRBldSubf
 
     C                   ELSE
 
      ** Process if there is an enquiry
 
     C                   IF        WRrn <> *ZERO
     C                   EXSR      SREnquire
     C                   ENDIF
 
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRChkIn - Check Input fields                                 *
      *                                                               *
      *  Called by: SRChkActn                                         *
      *                                                               *
      *  Calls: None                                                  *
      *                                                               *
      *****************************************************************
     C     SRChkIn       BEGSR
 
     C                   EVAL      WSIMST = 'N'
     C                   EVAL      WSISND = 'N'
     C                   EVAL      WSIDAT = 'N'
     C                   EVAL      WSITIM = 'N'
     C                   EVAL      WSIMSS = 'N'
 
     C                   IF        #0IMST <> *BLANKS
     C                   EVAL      WSIMST = 'Y'
     C                   ENDIF
 
     C                   IF        #0ISND <> *BLANKS
     C                   EVAL      WSISND = 'Y'
     C                   ENDIF
 
     C                   IF        #0IDAT <> *BLANKS
     C                   EVAL      WSIDAT = 'Y'
     C                   EVAL      WMDate = #0IDAT
     C                   MOVE      WMDate        WLast
     C                   IF        WLast = *BLANKS
     C                   EVAL      WDate = WMDate
     C                   EVAL      WMDate = *ZEROS
     C                   MOVE      WDate         WMDate
     C                   EVAL      #0IDAT = WMDate
     C                   ENDIF
     C                   ENDIF
 
     C                   IF        #0ITIM <> *BLANKS
     C                   EVAL      WSITIM = 'Y'
     C                   ENDIF
 
     C                   IF        #0IMSS <> *BLANKS
     C                   EVAL      WSIMSS = 'Y'
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRChkRec - Check Record if the same with selection           *
      *                                                               *
      *  Called by: SRBldSubf                                         *
      *                                                               *
      *  Calls: None                                                  *
      *                                                               *
      *****************************************************************
     C     SRChkRec      BEGSR
 
     C                   EVAL      WRecOk = 'Y'
 
     C     Lo:Up         XLATE     #0IMSS        WIMSS
     C     Lo:Up         XLATE     #0MSGS        WMSGS
 
     C                   IF        WSIMST = 'Y' AND
     C                             #0MSGT <> #0IMST OR
     C                             WSISND = 'Y' AND
     C                             #0ISND <> #0SNDR OR
     C                             WSIDAT = 'Y' AND
     C                             #0IDAT <> #0DATE OR
     C                             WSITIM = 'Y' AND
     C                             #0ITIM <> WOTime  OR
     C                             WSIMSS = 'Y' AND
     C                             WIMSS <> WMSGS
     C                   EVAL      WRecOk = 'N'
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SREnquire - Process enquiry on records                       *
      *                                                               *
      *  Called by: SRChkActn                                         *
      *                                                               *
      *  Calls: None                                                  *
      *                                                               *
      *****************************************************************
     C     SREnquire     BEGSR
 
     C                   EVAL      WArMIR = *BLANKS
     C                   Z-ADD     0             WX1
 
     C                   DOU       *IN05 = *ON
     C                   READC     RE102010S0                             05
 
     C                   DOW       *IN05 = *OFF AND
     C                             #0ACTN = *BLANK
     C
     C                   UPDATE    RE102010S0
     C                   READC     RE102010S0                             05
     C                   ENDDO
 
     C                   IF        *IN05 = *OFF
     C                   EVAL      WX1 = WX1 + 1
     C                   EVAL      WArMIR(WX1) = #0MIR
     C                   EVAL      #0ACTN = *BLANKS
     C                   UPDATE    RE102010S0
     C                   ENDIF
 
     C                   ENDDO
 
     C                   IF        WX1 > 0
     C                   Z-ADD     WX1           WX2
 
     C                   DOW       WX1 <= WX2
 
     C                   EVAL      PMIR  = WArMIR(WX1)
 
     C     PMIR          CHAIN     MEINCRL2
     C                   IF        NOT %FOUND(MEINCRL2)
     C     *LOCK         IN        LDA
     C                   EVAL      DBKey = PMIR
     C                   EVAL      DBFile = 'MEINCRL2'
     C                   EVAL      DBase = 005
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ELSE
      *
      * Call ME1060 to display message if enquire
     C                   ADD       1             WX1
     C                   EVAL      PMSGR = CRMSGR
     C                   EVAL      PKPRT = CRNPRT
      *
     C                   CALL      'ME1060'                             90
     C                   PARM      *BLANKS       PRTCD
     C                   PARM                    PPARM
     C                   PARM      'V'           PACTN
     C                   PARM                    PKPRT
     C                   PARM      *BLANKS       PFTAC
     C                   PARM      *BLANKS       PFTRF
      *
      * Option ended in error
      *
     C     *IN90         IFEQ      '1'
     C                   MOVEL     'MIN0019'     PRTCD
     C                   EXSR      *PSSR
     C                   ENDIF
     C                   ENDIF
 
     C                   ENDDO
 
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  *INZSR - Program Initialisation routine                      *
      *                                                               *
      *  Called by: Implicitly on program activation                  *
      *                                                               *
      *  Calls: None                                                  *
      *                                                               *
      *****************************************************************
     C     *INZSR        BEGSR
 
      ** Access Bank Details
 
     C                   CALL      'AOBANKR0'
     C                   PARM      *BLANKS       PRTCD
     C                   PARM      '*FIRST '     POPTN
     C     SDBANK        PARM      SDBANK        DSFDY
 
      ** Database error
 
     C                   IF        PRTCD <> *BLANKS
     C     *LOCK         IN        LDA
     C                   EVAL      DBKEY = POPTN
     C                   EVAL      DBFILE = 'SDBANKPD'
     C                   EVAL      DBASE = 001
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   EVAL      #0USER = PSUSER
     C                   EVAL      #0RUND = BJMRDT
     C                   EVAL      #0WSID = PSJOBNAME
     C                   EVAL      #0SLSH = '/'
     C                   EVAL      #0CSLH = '/'
     C                   EVAL      WDAS1 = '-'
     C                   EVAL      WDAS2 = '-'
     C                   EVAL      WDAS3 = '-'
     C                   EVAL      WDAS4 = '-'
     C                   EVAL      WColon1 = ':'
     C                   EVAL      WColon2 = ':'
 
     C                   EVAL      *IN03 = *ON
 
      * Key lists
 
     C     KSNDR         KLIST
     C                   KFLD                    #0SNDR
     C                   KFLD                    #0MIR
 
     C                   ENDSR
      **********************************************************************
      /COPY ZACPYSRC,RECMPSSR
      **********************************************************************
** NARR - Narratives
Reply to MT101
Topping Request
Direct Sweep
** MONTHS - Months Short Names
JANFEBMARAPRMAYJUNJULAUGSEPOCTNOVDEC
