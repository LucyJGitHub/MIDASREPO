     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas SD Yield Rates Display')
      *****************************************************************
      *                                                               *
      *  Midas - Standing Data ILE Module                             *
      *                                                               *
      *  SDYRATDSP - Yield Rates Details Display                      *
      *                                                               *
      *  Function:  This module displays Yield Rates Details          *
      *             Maintenance screen                                *
      *                                                               *
      *  (c) Finastra International Limited 2001                      *
      *                                                               *
      *  Last Amend No. CSD102             Date 08Jan19               *
      *  Prev Amend No. MD046248           Date 27Oct17               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      *                 CRE026             Date 24May06               *
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CSD031             Date 10Apr06               *
      *                 228390             Date 14Jul04               *
      *                 CAS008             Date 16Jun04               *
      *                 224743             Date 15Mar04               *
      *                 220004             Date 24Jul03               *
      *                 CAS006             Date 21Jan03               *
      *                 CAS005             Date 16Dec02               *
      *                 CAS004             Date 26Jun02               *
      * Midas Release 4.01 -------------------------------------------*
      *                 CAS001  *CREATE    Date 23Nov01               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CSD102 - Password Length Extension (Recompile)               *
      *  MD046248 - Finastra Rebranding                               *
      *  CRE026 - Consumer Banking (Recompile)                        *
      *  CSD031 - Enhanced Centralised Static Data (Recompile)        *
      *  228390 - Introduce a new yield curve type 'S' (for swap      *
      *           rates) which will apply the formula currently being *
      *           used by curve type 'Z' and a new formula for type   *
      *           'Z' is to be introduced.                            *
      *  CAS008 - IAS 39 Enhancements                                 *
      *  224743 - If CIR004 is installed, system should               *
      *           allow interest calculation method '7'.              *
      *  220004 - Change call to AOCURRR0 to use DSSDY not DSFDY.     *
      *  CAS006 - Hedge Accounting Phase B (Recompile)                *
      *  CAS005 - Enhancements to CAS001, CAS002 and CAS004           *
      *           (Recompile)                                         *
      *  CAS004 - Hedge Accounting Phase A                            *
      *  CAS001 - Net Present Value (NPV) Accounting                  *
      *                                                               *
      *****************************************************************
      *                                                               *
      *      FUNCTION OF INDICATORS                                   *
      *                                                               *
      *       20  Error on Action Code                                *
      *       21  Error on Yield Curve                                *
      *       22  Error on Currency                                   *
      *       23  Error on Interest Calculation Method                *
      *       24  Error on Compounding Frequency                      *
      *       25  Error on Period Year                                *
      *       26  Error on Period Month                               *
      *       27  Error on Period Days                                *
      *       28  Error on Rate/Discount Factor                       *
      *       69  Enable Action code and key fields                   *
      *       70  Display only                                        *
      *       71  Enable Function Key - F10                           *
      *       72  Enable Function Key - F7 and F8                     *
      *       73  Position cursor on first field                      *
      *       74  Enable Function Key - F15                           *
      *       75  When off, positions cursor to first subfile detail  *
      *           field in error                                      *
      *     80-89 Reference and Part./Non-Part. fields display        *
      *       96  Subfile End                                         *
      *       97  Subfile Clear                                       *
      *       98  Rollup                                              *
      *       99  Read error                                          *
      *       LR  End of Program                                      *
      *                                                               *
      *       KC  Function Key - F3  (Program Exit)                   *
      *       KG  Function Key - F7  (Display Previous Record)        *
      *       KH  Function Key - F8  (Display Next Record)            *
      *       KJ  Function Key - F10 (Delete Record)                  *
      *       KL  Function Key - F12 (Cancel)                         *
      *       KP  Function Key - F15 (Browse Records)                 *
      *                                                               *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *      SUBROUTINE INDEX                                         *
      *                                                               *
      *      *INZSR        - Program Initialisation                   *
      *      SrMAIN        - Main Subroutine                          *
      *      SrCLEAR       - Clear description fields                 *
      *      SrRTVTXT      - Retrieve text                            *
      *      SrDSPDES      - Display descriptions                     *
      *      SrUPDERRS     - Update Error Indicators                  *
      *      SrRATERRS     - Update Error Indicators for subfile      *
      *      SrBLDSFL      - Build Sub-File for Yield Rate Details    *
      *      SrSAVARR      - Saves Period dates/Rates in arrays       *
      *      SrMOVDET      - Move Yield Rates Details to subfile flds *
      *      SrSETFLD      - Move Subfile Fields to Screen Data Struc *
      *                      ture                                     *
      *      *PSSR         - Standard Error Subroutine                *
      *                                                               *
      *****************************************************************
 
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
 
     FSDYRATDDF CF   E             WORKSTN SFILE(SDYRATS0:W_RRN)
      ** Yield Rates Display file
 
     FZAFLDNPD  IT   F   15        DISK    INFSR(*PSSR)
      ** Table of field numbers and names
 
      *****************************************************************
      /EJECT
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ Automatically included D-specs       ¦
      ** ¦ ==============================       ¦
      ** +--------------------------------------+
      **
      **---------------------------------------------------------------
      ** The following /COPY line includes (among others) the LDA layout
      ** and the copyright array definition:
     D/COPY ZACPYSRC,STD_D_SPEC
      **---------------------------------------------------------------
 
      **---------------------------------------------------------------
      ** The following /COPY includes the MM standard declares:
     D/COPY ZACPYSRC,STDDECLARE
      **---------------------------------------------------------------
 
      **---------------------------------------------------------------
      ** The following /COPY line includes all the defined fields in the
      ** Program Status Data Structures.  They have meaningful
      ** names, prefixed by 'PS'.
     D/COPY ZACPYSRC,PSDS
      **---------------------------------------------------------------
 
      **---------------------------------------------------------------
      ** The following /COPY line includes the definitions for error and
      ** warning message arrays.
     D/COPY ZACPYSRC,ERR_ARRAYS
     D/COPY ZACPYSRC,ERR_ARR1
      **---------------------------------------------------------------
 
      **---------------------------------------------------------------
      ** The following /COPY line includes all the definitions of the error
      ** arrays, including the named constant giving the size of
      ** the arrays.  Note that it uses #MsgID and *MsgData, and so requires
      ** STD_D_SPEC.
     D/COPY ZACPYSRC,FVAL_ARRAY
      **---------------------------------------------------------------
 
      **--------------------------------------------------------------------------------------------
      ** The following /COPY line includes the definitions for error and
      ** warning message arrays.
     D/COPY ZACPYSRC,APICTLAR1
      **--------------------------------------------------------------------------------------------
 
      **---------------------------------------------------------------
      ** The following /COPY line includes the definitions for fields
      ** required by the message handler.
     D/COPY ZACPYSRC,MSGHNDDCL1
      **---------------------------------------------------------------
 
 
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
 
      ** Maturity Date
     D PMatAr          S              7    DIM(98)
 
      ** Maturity Date
     D PDFcAr          S             14    DIM(98)
 
      ** Array for error indicators
     D WEI             S              1    DIM(ArrayMax3)
     D WTempArr600     S              1    DIM(ArrayMax3)                                     CAS008
 
      ** Arrays for period dates
     D WAYear          S              2    DIM(98)
     D WAMnth          S              2    DIM(98)
     D WADays          S              2    DIM(98)
 
      ** Arrays for rate/discount factor
     D WARtDf          S             14    DIM(98)
 
      ** Arrays for maturity date (output only)
     D WAMDat          S              7    DIM(98)
 
      ** Arrays for discount factor(output only)
     D WADsFc          S             14    DIM(98)
 
     D WZ10            S              1    DIM(10) CTDATA PERRCD(8)
 
      ** Table for Error field sequence number and corresponding
      ** relative record number from subfile
     D TabErrNum       S              3  0 DIM(392) PERRCD(8)
     D                                     CTDATA
     D TabSRecNum      S              3  0 DIM(392) ALT(TabErrNum)
 
      ** Yield Rates Details in screen format
     D NwYRScnFmt    E DS                  EXTNAME(SDYRATPD)
     D***WRateDet              12   1971                                                      CAS008
     D  WRateDet              14   1973                                                       CAS008
 
      ** Error indicators
     D OKYRScnFld    E DS                  EXTNAME(SDEYRATPD)
 
      ** External DS for Bank Details
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
 
      ** External DS for switchable features
     D SCSARD        E DS                  EXTNAME(SCSARDPD)
 
      ** External DS for yield curve file
     D SDYLDC        E DS                  EXTNAME(SDYLDCPD)
 
      ** External DS for currency
     D SDCURR        E DS                  EXTNAME(SDCURRPD)
 
      ** Short DS for access programs
     D DSFDY         E DS                  EXTNAME(DSFDY)
 
      ** Long DS for access programs
     D DSSDY         E DS                  EXTNAME(DSSDY)
 
      ** Data structure for period dates and rate/discount factor that
      ** reads each subfile record and write to screen data structure
     D WkRateDS        DS
     D  WkYear                 1      2
     D  WkMnth                 3      4
     D  WkDays                 5      6
     D  WkRtDf                 7     20
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
      ** Input Parameter (Enable F7, F8, F10, F15 in Command Narrative and Key Fields)
     D PEINKG          S              1A
     D PEINKH          S              1A
     D PEINKJ          S              1A
     D PEINKP          S              1A
     D PEKYFD          S              1A
 
      ** Output Parameter (Function Keys - 3,7,8,10,12 and 15)
     D PINKC           S              1A
     D PINKG           S              1A
     D PINKH           S              1A
     D PINKJ           S              1A
     D PINKL           S              1A
     D PINKP           S              1A
 
      ** General purpose index
     D Wx              S              4  0
     D Xx              S              4  0
     D Yx              S              4  0
     D Zx              S              4  0
 
      ** Exit loop indicator
     D WEXIT           S              1A
 
     D Wcaller         S              7A
 
     D PPYLDC          S              5
 
      ** Current subfile record number
     D WCRECNUM        S              3  0
 
      ** Previous subfile record number
     D WPRECNUM        S              3  0
 
      ** Previous period year/momth/day/yield rate error indicators
     D WPR25           S              1
     D WPR26           S              1
     D WPR27           S              1
     D WPR28           S              1
 
      ** work varibles to for retrieving text
     D WMSGDNB         S              7
     D WMSGNM          S             10
     D WMSGTXT         S             80
 
      ** Work varibles for CAS008                                                             CAS008
     D CAS008          S              1A                                                      CAS008
     D WSpotErFlg      S              1A                                                      CAS008
                                                                                              CAS008
      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
      *****************************************************************
      /EJECT
      *****************************************************************
      ** +--- Start of Main processing -----------------------------------+
      ** ¦                                                                ¦
      ** ¦ Initial processing is performed automatically: the             ¦
      ** ¦ executed at program activation.                                ¦
      ** ¦                                                                ¦
      ** +----------------------------------------------------------------+
 
     C                   IF        Wcaller = 'ENQUIRE'
     C                   EVAL      *IN75 = *ON
     C                   ENDIF
      ** Main processing
 
     C                   EXSR      SrMAIN
 
      ** F3, Terminate program
 
     C                   IF        *INKC = TRUE
     C                   EVAL      *INLR = TRUE
     C                   ENDIF
 
      ** Return to calling program
 
     C                   RETURN
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SrMAIN - Main Subroutine                                      *
      *                                                               *
      * Called By : Main                                              *
      *                                                               *
      * Calls : SrSAVARR, SrBLDSFL                                    *
      *                                                               *
      *****************************************************************
     C     SrMAIN        BEGSR
 
      ** Set up the transaction reference to be used by the message handler
 
     C                   EVAL      TranRef = #0YLDC+#0YCCY+#0YICM
     C                   EVAL      ActionCode = #0ACTN
     C                   EXSR      SrCLEAR
 
      **---------------------------------------------------------------
      ** The following /COPY line includes processing for the error and
      ** warning messages.
     C/COPY ZACPYSRC,MSGHNDDSP3
      **---------------------------------------------------------------
 
      ** Set cursor to action code field
 
     C                   IF        #0ACTN = *BLANKS
     C                   EVAL      *IN73 = TRUE
     C                   ENDIF
 
      ** Enable Action Code and Key fields
 
     C                   IF        PEKYFD ='Y'
     C                   EVAL      *IN69 = TRUE
     C                   ELSE
     C                   EVAL      *IN69 = FALSE
     C                   ENDIF
 
      ** WriteOnly is set to 'Y', protect detail fields
 
     C                   IF        WriteOnly = 'Y'
     C                   EVAL      *IN70 = TRUE
     C                   ELSE
     C                   EVAL      *IN70 = FALSE
     C                   ENDIF
 
      ** Enable Function Key - F10 Delete
 
     C                   IF        PEINKJ = 'Y'
     C                   EVAL      *IN71 = TRUE
     C                   ELSE
     C                   EVAL      *IN71 = FALSE
     C                   ENDIF
 
      ** Enable Function Key - F7 or F8 for prev/next record
 
     C                   IF        (PEINKG = 'Y') OR (PEINKH = 'Y')
     C                   EVAL      *IN72 = TRUE
     C                   ELSE
     C                   EVAL      *IN72 = FALSE
     C                   ENDIF
 
      ** Enable Function Key - F15 for Browse
 
     C                   IF        PEINKP = 'Y'
     C                   EVAL      *IN74 = TRUE
     C                   ELSE
     C                   EVAL      *IN74 = FALSE
     C                   ENDIF
 
      ** Save yield rates details from screen format to array.
 
     C                   EXSR      SrSAVARR
 
      ** Build Subfile
 
     C                   EXSR      SrBLDSFL
 
     C                   ENDSR
 
      **---------------------------------------------------------------
      ** The following /COPY line includes the ProcMsgs subroutine
      ** to process error and warning messages.
     D/COPY ZACPYSRC,MSGHNDDSP4
      **---------------------------------------------------------------
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SrCLEAR - Clear Description fields                            *
      *                                                               *
      * Called By : SrBLDSFL                                          *
      *                                                               *
      * Calls : None                                                  *
      *                                                               *
      *****************************************************************
     C     SrCLEAR       BEGSR
 
     C                   EVAL      #0YLDD = *BLANKS
     C                   EVAL      #0CCNM = *BLANKS
     C                   EVAL      #0INCN = *BLANKS
     C                   EVAL      #0NAR1 = *BLANKS
     C                   EVAL      #0YLDT = *BLANKS
     C                   EVAL      #0NAR2 = *BLANKS
     C                   EVAL      #0FRQN = *BLANKS
     C                   EVAL      #0NAR3 = *BLANKS
     C                   EVAL      #0INTP = *BLANKS
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SrRTVTXT - Retrieve text                                      *
      *                                                               *
      * Called By : SrDSPDES                                          *
      *                                                               *
      * Calls : None                                                  *
      *                                                               *
      *****************************************************************
     C     SrRTVTXT      BEGSR
 
     C                   CALL      'SDRTVTXT'
     C                   PARM                    WMSGDNB
     C                   PARM      #MSGFILE      WMSGNM
     C                   PARM      *BLANK        WMSGTXT
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SrDSPDES  - Display Descriptions                              *
      *                                                               *
      * Called By : SrBLDSFL                                          *
      *                                                               *
      * Calls : SrRTVTXT                                              *
      *                                                               *
      *****************************************************************
     C     SrDSPDES      BEGSR
 
      ** Set Up Yield Curve Description
 
     C                   CALL      'AOYLDCR0'
     C                   PARM      *BLANK        PRTCD
     C                   PARM      '*KEY   '     POPTN
     C                   PARM      #0YLDC        PPYLDC
     C     SDYLDC        PARM      SDYLDC        DSFDY
 
     C                   IF        PRTCD = *BLANKS
     C                   EVAL      #0YLDD = FSYLDD
     C                   EVAL      #0YLDT = FSYLDT
     C                   ENDIF
 
      ** Set Up Currency Description
 
     C                   CALL      'AOCURRR0'
     C                   PARM      *BLANK        PRTCD
     C                   PARM      '*KEY   '     POPTN
     C                   PARM      #0YCCY        PPYLDC
     C*****SDCURR        PARM      SDCURR        DSFDY                                        220004
     C     SDCURR        PARM      SDCURR        DSSDY                                        220004
 
     C                   IF        PRTCD = *BLANKS
     C                   EVAL      #0CCNM = A6CYNM
     C                   ENDIF
 
     C                   IF        #0YCCY = *BLANKS                                           CAS004
     C                   EVAL      #0CCNM = 'ALL CURRENCIES'                                  CAS004
     C                   ENDIF                                                                CAS004
                                                                                              CAS004
      ** Set Up Interest Calculation Method Description
 
     C                   SELECT
 
     C                   WHEN      #0YICM = '1'
     C                   EVAL      WMSGDNB = 'USR9255'
     C                   EXSR      SrRTVTXT
     C                   EVAL      #0INCN = WMSGTXT
 
     C                   WHEN      #0YICM = '2'
     C                   EVAL      WMSGDNB = 'USR9256'
     C                   EXSR      SrRTVTXT
     C                   EVAL      #0INCN = WMSGTXT
 
     C                   WHEN      #0YICM = '3'
     C                   EVAL      WMSGDNB = 'USR9257'
     C                   EXSR      SrRTVTXT
     C                   EVAL      #0INCN = WMSGTXT
 
     C                   WHEN      #0YICM = '4'
     C                   EVAL      WMSGDNB = 'USR9258'
     C                   EXSR      SrRTVTXT
     C                   EVAL      #0INCN = WMSGTXT
 
     C                   WHEN      #0YICM = '5'
     C                   EVAL      WMSGDNB = 'USR9259'
     C                   EXSR      SrRTVTXT
     C                   EVAL      #0INCN = WMSGTXT
 
     C                   WHEN      #0YICM = '6'
     C                   EVAL      WMSGDNB = 'USR9260'
     C                   EXSR      SrRTVTXT
     C                   EVAL      #0INCN = WMSGTXT
                                                                                              224743
     C                   WHEN      #0YICM = '7' AND CIR004 = 'Y'                              224743
     C                   EVAL      WMSGDNB = 'USR9299'                                        224743
     C                   EXSR      SrRTVTXT                                                   224743
     C                   EVAL      #0INCN = WMSGTXT                                           224743
 
     C                   ENDSL
 
      ** Set Up Compounding Frequency Description
 
     C                   SELECT
 
     C                   WHEN      #0YCFQ = 'D'
     C                   EVAL      WMSGDNB = 'USR9261'
     C                   EXSR      SrRTVTXT
     C                   EVAL      #0FRQN = WMSGTXT
 
     C                   WHEN      #0YCFQ = 'Q'
     C                   EVAL      WMSGDNB = 'USR9262'
     C                   EXSR      SrRTVTXT
     C                   EVAL      #0FRQN = WMSGTXT
 
     C                   WHEN      #0YCFQ = 'X'
     C                   EVAL      WMSGDNB = 'USR9263'
     C                   EXSR      SrRTVTXT
     C                   EVAL      #0FRQN = WMSGTXT
 
     C                   WHEN      #0YCFQ = 'Y'
     C                   EVAL      WMSGDNB = 'USR9264'
     C                   EXSR      SrRTVTXT
     C                   EVAL      #0FRQN = WMSGTXT
                                                                                              228390
     C                   WHEN      #0YCFQ = 'C'                                               228390
     C                   EVAL      WMSGDNB = 'USR9280'                                        228390
     C                   EXSR      SrRTVTXT                                                   228390
     C                   EVAL      #0FRQN = WMSGTXT                                           228390
 
     C                   ENDSL
      ** Set Up Yield Curve Type Description
 
     C                   EVAL      WMSGDNB = 'USR9251'
     C                   EXSR      SrRTVTXT
     C                   EVAL      #0NAR1 = WMSGTXT
 
     C                   SELECT
 
     C                   WHEN      FSYLDT = 'Z'
     C                   EVAL      WMSGDNB = 'USR9252'
     C                   EXSR      SrRTVTXT
     C                   EVAL      #0NAR2 = WMSGTXT
 
     C                   WHEN      FSYLDT = 'D'
     C                   EVAL      WMSGDNB = 'USR9253'
     C                   EXSR      SrRTVTXT
     C                   EVAL      #0NAR2 = WMSGTXT
                                                                                              228390
     C                   WHEN      FSYLDT = 'S'                                               228390
     C                   EVAL      WMSGDNB = 'USR9281'                                        228390
     C                   EXSR      SrRTVTXT                                                   228390
     C                   EVAL      #0NAR2 = WMSGTXT                                           228390
 
     C                   ENDSL
 
      ** Set Up Interpolation Method Description
 
     C                   EVAL      WMSGDNB = 'USR9254'
     C                   EXSR      SrRTVTXT
     C                   EVAL      #0NAR3 = WMSGTXT
     C                   EVAL      #0INTP = FSINTP
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SrUPDERRS - Update Error Indicators                           *
      *                                                               *
      * Called By : SrBLDSFL                                          *
      *                                                               *
      * Calls : SrRATERRS                                             *
      *                                                               *
      *****************************************************************
     C     SrUPDERRS     BEGSR
 
      ** Move 'OK' flags into array (for checking)
 
     C                   MOVEA     OkYRScnFld    WEI
 
      ** Reset error indicators
 
     C                   MOVEA     WZ10          *IN(20)
 
     C                   EVAL      WCRECNUM = *ZERO
                                                                                              CAS008
      ** Set error flag on Spot Days as 'no'                                                  CAS008
     C                   EVAL      WSpotErFlg = 'N'                                           CAS008
 
      ** Set screen error indicators according to status of 'OK' flags
 
     C                   Z-ADD     1             C                 3 0
 
     C                   DOW       C <= ArrayMax3 AND WEI(C) <> *BLANK
 
      ** Check if OKflag of the field is set to 'N'(error) or 'W'(warning)
 
     C                   IF        (WEI(C) = 'N') OR (WEI(C) = 'W' )
 
      ** Action Code
 
     C                   IF        C = 1
     C                   EVAL      *IN20 = TRUE
     C                   ENDIF
 
      ** Yield Curve Name
 
     C                   IF        C = 2
     C                   EVAL      *IN21 = TRUE
     C                   ENDIF
 
      ** Yield Currency
 
     C                   IF        C = 3
     C                   EVAL      *IN22 = TRUE
     C                   ENDIF
 
      ** Yield Interest Calculation Method
 
     C                   IF        C = 4
     C                   EVAL      *IN23 = TRUE
     C                   ENDIF
 
      ** Frequency
 
     C                   IF        C = 5
     C                   EVAL      *IN24 = TRUE
     C                   ENDIF
 
      ** Spot Days                                                                            CAS008
                                                                                              CAS008
      ** If index is on the sixth element, check if first iteration to 6                      CAS008
                                                                                              CAS008
     C                   IF        C = 6 AND WSpotErFlg = 'N'                                 CAS008
                                                                                              CAS008
     C                   IF        CAS008 = 'Y'                                               CAS008
     C                   EVAL      *IN29 = TRUE                                               CAS008
     C                   ENDIF                                                                CAS008
                                                                                              CAS008
      ** Shift array elements to the left so that no amendments would                         CAS008
      ** be nescessary for pre CAS008 processing                                              CAS008
                                                                                              CAS008
     C                   MOVEA(P)  WEI(2)        WTempArr600                                  CAS008
     C                   MOVEA     WTempArr600   WEI                                          CAS008
     C                   EVAL      WSpotErFlg = 'Y'                                           CAS008
     C                   ITER                                                                 CAS008
     C                   ENDIF                                                                CAS008
                                                                                              CAS008
     C                   IF        C > 6 AND WSpotErFlg = 'N'                                 CAS008
     C                   MOVEA(P)  WEI(2)        WTempArr600                                  CAS008
     C                   MOVEA     WTempArr600   WEI                                          CAS008
     C                   EVAL      C = C - 1                                                  CAS008
     C                   EVAL      WSpotErFlg = ' '                                           CAS008
     C                   ENDIF                                                                CAS008
                                                                                              CAS008
      ** Period Year/Month/Days and Rate/Discount factor
 
     C                   IF        (C > 5) OR (C < 398)
 
      ** Save Previous Subfile Record Number
 
     C                   Eval      WPRECNUM = WCRECNUM
     C     C             LOOKUP    TabErrNum     TabSRecNum               80
     C                   EXSR      SrRATERRS
     C                   ENDIF
 
     C                   ENDIF
 
     C                   EVAL      C = C + 1
     C                   ENDDO
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SrRATERRS - Update Error Indicators for Rates                 *
      *                                                               *
      * Called By : SrUPDERRS                                         *
      *                                                               *
      * Calls : SrSAVARR, SrBLDSFL                                    *
      *                                                               *
      *****************************************************************
     C     SrRATERRS     BEGSR
 
     C                   IF        *IN80 = TRUE
     C                   EVAL      WCRECNUM = TabSRecNum
 
      ** Setup subfile page against the first subfile record with error
 
     C                   IF        WPRECNUM = *ZERO
     C                   SELECT
     C                   WHEN      TabsRecNum < 11
     C                   Z-ADD     1             WSFLPAG
     C                   WHEN      TabsRecNum < 21 AND TabsRecNum > 10
     C                   Z-ADD     11            WSFLPAG
     C                   WHEN      TabsRecNum < 31 AND TabsRecNum > 20
     C                   Z-ADD     21            WSFLPAG
     C                   WHEN      TabsRecNum < 41 AND TabsRecNum > 30
     C                   Z-ADD     31            WSFLPAG
     C                   WHEN      TabsRecNum < 51 AND TabsRecNum > 40
     C                   Z-ADD     41            WSFLPAG
     C                   WHEN      TabsRecNum < 61 AND TabsRecNum > 50
     C                   Z-ADD     51            WSFLPAG
     C                   WHEN      TabsRecNum < 71 AND TabsRecNum > 60
     C                   Z-ADD     61            WSFLPAG
     C                   WHEN      TabsRecNum < 81 AND TabsRecNum > 70
     C                   Z-ADD     71            WSFLPAG
     C                   WHEN      TabsRecNum < 91 AND TabsRecNum > 80
     C                   Z-ADD     81            WSFLPAG
     C                   WHEN      TabsRecNum < 99 AND TabsRecNum > 90
     C                   Z-ADD     91            WSFLPAG
     C                   ENDSL
     C                   ENDIF
     C
     C     TabSRecNum    CHAIN     SDYRATS0                           99
     C                   IF        *IN99 = FALSE
 
     C                   EVAL      WREM = *ZERO
     C     C             DIV       4             WINT              2 0
     C                   MVR                     WREM              1 0
 
      ** Determine which field in the record has an error
 
     C                   SELECT
     C                   WHEN      WREM = 2
     C                   EVAL      *IN25 = *ON
     C                   EVAL      WPR25 = *IN25
     C                   WHEN      WREM = 3
     C                   EVAL      *IN26 = *ON
     C                   EVAL      WPR26 = *IN26
     C                   IF        WPRECNUM = WCRECNUM
     C                   EVAL      *IN25 = WPR25
     C                   ENDIF
     C                   WHEN      WREM = 0
     C                   EVAL      *IN27 = *ON
     C                   EVAL      WPR27 = *IN27
     C                   IF        WPRECNUM = WCRECNUM
     C                   EVAL      *IN25 = WPR25
     C                   EVAL      *IN26 = WPR26
     C                   ENDIF
     C                   WHEN      WREM = 1
     C                   EVAL      *IN28 = *ON
     C                   EVAL      WPR28 = *IN28
     C                   IF        WPRECNUM = WCRECNUM
     C                   EVAL      *IN25 = WPR25
     C                   EVAL      *IN26 = WPR26
     C                   EVAL      *IN27 = WPR27
     C                   ENDIF
     C                   ENDSL
 
      ** Update subfile record
 
     C
     C                   UPDATE    SDYRATS0
 
      ** Reset subfile field error indicators
 
     C                   EVAL      *IN25 = FALSE
     C                   EVAL      *IN26 = FALSE
     C                   EVAL      *IN27 = FALSE
     C                   EVAL      *IN28 = FALSE
     C                   ENDIF
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SrBLDSFL  - Build Sub-File for Yield Rate Details             *
      *                                                               *
      * Called By : SRMain                                            *
      *                                                               *
      * Calls : SrMOVDET, SrUPDERRS, SrCLEAR, SrDSPDES, SrSETFLD      *
      *                                                               *
      *****************************************************************
     C     SrBLDSFL      BEGSR
 
      ** Initialise subfile relative record number.
 
     C                   Z-ADD     0             W_RRN             5 0
     C                   Z-ADD     0             W_CNT             2 0
 
      ** Initialise subfile page
 
     C                   Z-ADD     1             WSFLPAG           2 0
 
      ** Clear subfile before refilling by writing control record
      ** with SFLCLR active.
 
     C                   EVAL      *IN97 = *ON
     C                   WRITE     SDYRATC0
     C                   EVAL      *IN97 = *OFF
 
      ** Write header and footer to the screen
 
     C                   WRITE     SDYRATF0
     C                   WRITE     SDYRATC1
 
      ** Set on ROLLUP indicator to drive initial loop.
 
     C                   EVAL      *IN98 = *ON
 
      ** Write records into the subfile until all pages have
      ** been filled.
 
     C                   DOW       *IN98 = TRUE
 
      ** Write to subfile until the subfile ends
 
     C                   DOW       W_CNT < 98
 
      ** Increment the subfile record no. and record counter
 
     C                   ADD       1             W_RRN
     C                   ADD       1             W_CNT
 
      ** Move details from the yield rates screen format to subfile.
 
     C                   EXSR      SrMOVDET
 
      ** Write the Yield rate details to the subfile
 
     C                   Z-ADD     W_RRN         #0RLRN
     C                   WRITE     SDYRATS0
 
      ** Enable subfile end
 
     C                   IF        W_RRN = 98
     C                   EVAL      *IN96 = TRUE
     C                   ELSE
     C                   EVAL      *IN96 = FALSE
     C                   ENDIF
 
     C                   ENDDO
 
      ** If there is any error, update error indicator
 
     C                   EXSR      SrUPDERRS
 
      ** Set subfile relative record number to subfile page workfield
 
     C                   Z-ADD     WSFLPAG       #0RLRN
 
     C                   IF        #0ACTN <> 'I' AND #0ACTN <> *BLANK AND
     C                             OKACTN <> 'N' AND OKYLDC <> 'N' AND
     C                             OKYCCY <> 'N' AND OKYICM <> 'N'
     C                   EXSR      SrCLEAR
     C                   EXSR      SrDSPDES
     C                   ENDIF
     C
      ** Write the subfile control record to the screen to display
      ** the subfile.
 
     C                   WRITE     SDYRATC0
 
      ** Read the subfile control record to determine whether records
      ** have been selected or whether ROLLUP is required.
 
     C                   READ      SDYRATC0                               99
 
     C                   SELECT
 
      ** If F3, bypass further processing.
 
     C                   WHEN      *INKC = TRUE
     C                   EVAL      PINKC = TRUE
 
      ** If F12, bypass further processing.
 
     C                   WHEN      *INKL = TRUE
     C                   EVAL      PINKL = TRUE
     C                   EXSR      SRClear
 
      ** If F8, Next record
 
     C                   WHEN      *INKH = TRUE
     C                   EVAL      PINKH = TRUE
 
      ** If F7, Prev record
 
     C                   WHEN      *INKG = TRUE
     C                   EVAL      PINKG = TRUE
 
      ** If F15, Select record
 
     C                   WHEN      *INKP = TRUE
     C                   EVAL      PINKP = TRUE
 
      ** If F10, Delete Record
 
     C                   WHEN      (*INKJ = TRUE) AND (PEINKJ = 'Y')
     C                   EVAL      PINKJ = TRUE
 
      ** Otherwise Rollup or Enter
 
     C                   OTHER
 
     C                   IF        *IN98 = TRUE
 
      ** Set subfile to next page
 
     C                   Z-ADD     11            WSFLPAG
     C                   ELSE
 
      ** Set move subfile fields to screen data structure, then return
 
     C                   EXSR      SrSETFLD
     C                   ENDIF
     C                   ENDSL
 
     C                   ENDDO
 
 
      ** Reset screen indicators
 
     C                   MOVEA     WZ10          *IN(20)
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SrSAVARR  - Saves Period dates and rate in arrays             *
      *                                                               *
      * Called By : SRMain                                            *
      *                                                               *
      * Calls : None                                                  *
      *                                                               *
      *****************************************************************
     C     SrSAVARR      BEGSR
 
      ** Reset counter
 
     C                   EVAL      Xx = *ZERO
     C                   EVAL      Yx = *ZERO
     C                   EVAL      Zx = *ZERO
 
      ** Get period years, months, days, rate/discount factor details
 
     C**********         EVAL      WRateDet = (%SUBST(NwYRScnFmt:12:1960))                    CAS008
     C                   EVAL      WRateDet = (%SUBST(NwYRScnFmt:14:1960))                    CAS008
 
      ** From detail screen format save to array
 
     C                   DOW       Xx < 98
     C                   EVAL      Xx = Xx + 1
     C                   EVAL      Yx = Zx + 1
     C                   EVAL      Zx = Zx + 2
     C                   EVAL      WAYear(Xx) = (%SUBST(WRateDet:Yx:2))
     C                   EVAL      Yx = Zx + 1
     C                   EVAL      Zx = Zx + 2
     C                   EVAL      WAMnth(Xx) = (%SUBST(WRateDet:Yx:2))
     C                   EVAL      Yx = Zx + 1
     C                   EVAL      Zx = Zx + 2
     C                   EVAL      WADays(Xx) = (%SUBST(WRateDet:Yx:2))
     C                   EVAL      Yx = Zx + 1
     C                   EVAL      Zx = Zx + 14
     C                   EVAL      WARtDf(Xx) = (%SUBST(WRateDet:Yx:14))
     C
     C                   EVAL      WAMDat(Xx) = PMatAr(Xx)
     C                   IF        #0ACTN = 'A' AND WARtDf(Xx) = *BLANK
     C                   EVAL      WADsFc(Xx) = *BLANK
     C                   ELSE
     C                   EVAL      WADsFc(Xx) = PDFcAr(Xx)
     C                   ENDIF
     C                   ENDDO
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SrMOVDET  - Move Yield Rates Details to Subfile fields        *
      *                                                               *
      * Called By : SrBLDSFL                                          *
      *                                                               *
      * Calls : None                                                  *
      *                                                               *
      *****************************************************************
     C     SrMOVDET      BEGSR
 
     C                   EVAL      Xx = W_RRN
 
     C                   EVAL      #0PDYR = WAYear(Xx)
     C                   EVAL      #0PDMN = WAMnth(Xx)
     C                   EVAL      #0PDDY = WADays(Xx)
     C                   EVAL      #0MDAT = WAMDat(Xx)
     C                   EVAL      #0YRAT = WARtDf(Xx)
     C                   EVAL      #0DSFC = WADsFc(Xx)
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SrSETFLD  - Move Subfile Fields to Screen Data Structure      *
      *                                                               *
      * Called By : SrBLDSFL                                          *
      *                                                               *
      * Calls : None                                                  *
      *                                                               *
      *****************************************************************
     C     SrSETFLD      BEGSR
 
     C                   EVAL      Wx = 1
     C     1             DO        98            Xx
     C     Xx            CHAIN     SDYRATS0                           99
     C                   EVAL      WkYear = #0PDYR
     C                   EVAL      WkMnth = #0PDMN
     C                   EVAL      WkDays = #0PDDY
     C                   EVAL      WkRtDf = #0YRAT
     C                   EVAL      %SUBST(WRateDet:Wx:20)=WkRateDS
     C                   EVAL      Wx = Wx+20
     C                   ENDDO
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * *INZSR - Program Initialisation                               *
      *        - This subroutine runs automatically for program       *
      *          initialisation.                                      *
      *                                                               *
      * Called By : Main Processing                                   *
      *                                                               *
      * Calls : AOBANKR0                                              *
      *                                                               *
      *                                                               *
      *****************************************************************
     C     *INZSR        BEGSR
 
      ** Parameters
 
     C     *ENTRY        PLIST
 
      ** Return Code
 
     C                   PARM                    RetCodeIn
 
      ** New yield rate detail screen format
 
     C                   PARM                    NwYRScnFmt
 
      ** Formatted maturity date array
 
     C                   PARM                    PMatAr
 
      ** Discount factor array
 
     C                   PARM                    PDFcAr
 
      ** Field Name in error array
 
     C                   PARM                    FldNameAr2
 
      ** Message Id error array
 
     C                   PARM                    MsgIdAr2
 
      ** Message data error array
 
     C                   PARM                    MsgDtaAr2
 
      ** Warning field name array
 
     C                   PARM                    WFldNamAr2
 
      ** Warning message id array
 
     C                   PARM                    WMsgIdAr2
 
      ** Warning message data array
 
     C                   PARM                    WMsgDtaAr2
 
      ** OK flag
 
     C                   PARM                    OkYRScnFld
 
      ** Enable Key fields and action code
 
     C                   PARM                    PEKYFD
 
      ** Write only
 
     C                   PARM                    Writeonly
 
      ** F7 - enable read previous record
 
     C                   PARM                    PEINKG
 
      ** F8 - enable read next record
 
     C                   PARM                    PEINKH
 
      ** F10 - enable confirm delete
 
     C                   PARM                    PEINKJ
 
      ** F15 - enable display browse
 
     C                   PARM                    PEINKP
 
      ** F3 - Exit
 
     C                   PARM                    PINKC
 
      ** F7 - Read previous record
 
     C                   PARM                    PINKG
 
      ** F8 - Read next record
 
     C                   PARM                    PINKH
 
      ** F10 - Confirm delete
 
     C                   PARM                    PINKJ
 
      ** F3 - Confirm delete
 
     C                   PARM                    PINKL
 
      ** F15 - display browse screen
 
     C                   PARM                    PINKP
 
      **--------------------------------------------------------------------------------------------
      ** The following /COPY sets the values of program, module and
      ** procedure names for database error processing.
     C/COPY ZACPYSRC,DBFIELDS
      **--------------------------------------------------------------------------------------------
 
      ** Move user and workstation ID to screen fields.
 
     C                   MOVEL     PsUser        #0USER
     C                   MOVEL     PsJobName     #0WSID
 
     C                   MOVEL     '*'           #1PGMQ
     C                   EVAL      Wcaller = RetCodeIn
     C                   EVAL      RetCodeIn = *BLANKS
 
      ** Access Bank Details
 
     C                   CALLB     'AOBANKR0'
     C                   PARM      '*DBERR '     PRTCD             7
     C                   PARM      '*FIRST '     POPTN             7
     C     SDBANK        PARM      SDBANK        DSFDY
 
      ** Database error
 
     C                   IF        PRTCD <> *BLANKS
     C                   MOVEL     'SDBANKPD'    DBFILE
     C                   Z-ADD     1             DBASE
     C                   MOVEL     POPTN         DBKEY
     C                   EXSR      *PSSR
     C                   ENDIF
      *                                                                                       224743
      ** Check if switchable feature CIR004 is switched on                                    224743
      *                                                                                       224743
     C                   CALLB     'AOSARDR0'                                                 224743
     C                   PARM      *BLANKS       @RTCD             7                          224743
     C                   PARM      '*VERIFY '    @OPTN             7                          224743
     C                   PARM      'CIR004'      @SARD             6                          224743
     C     SCSARD        PARM      SCSARD        DSFDY                                        224743
                                                                                              224743
     C     @RTCD         IFEQ      *BLANKS                                                    224743
     C                   MOVE      'Y'           CIR004            1                          224743
     C                   ELSE                                                                 224743
     C                   MOVE      'N'           CIR004                                       224743
     C                   ENDIF                                                                224743
      *                                                                                       CAS008
      ** Check if switchable feature CAS008 is switched on                                    CAS008
      *                                                                                       CAS008
     C                   CALLB     'AOSARDR0'                                                 CAS008
     C                   PARM      *BLANKS       @RTCD                                        CAS008
     C                   PARM      '*VERIFY '    @OPTN                                        CAS008
     C                   PARM      'CAS008'      @SARD                                        CAS008
     C     SCSARD        PARM      SCSARD        DSFDY                                        CAS008
                                                                                              CAS008
     C                   EVAL      CAS008 = 'N'                                               CAS008
     C                   IF        @RTCD <> *BLANKS AND                                       CAS008
     C                             @RTCD <> '*NRF'                                            CAS008
     C     *LOCK         IN        LDA                                                        CAS008
     C                   EVAL      DBKEY = 'CAS008'                                           CAS008
     C                   EVAL      DBFILE = 'SCSARDPD'                                        CAS008
     C                   EVAL      DBASE = 2                                                  CAS008
     C                   OUT       LDA                                                        CAS008
     C                   EXSR      *PSSR                                                      CAS008
     C                   ELSE                                                                 CAS008
     C                   IF        @RTCD = *BLANKS                                            CAS008
     C                   EVAL      CAS008 = 'Y'                                               CAS008
     C                   EVAL      *IN30 = TRUE                                               CAS008
     C                   ENDIF                                                                CAS008
     C                   ENDIF                                                                CAS008
 
      **---------------------------------------------------------------
      ** The following /COPY line sets up the fixed data for SD *DSP
      ** functions for the message handler, ZAMSGHNDLE.
     D/COPY SDCPYSRC,MSGHNDDATA
      **---------------------------------------------------------------
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      ** Program, module and procedure names for database error processing.
      ** ==============================================================
      ** The following /COPY sets these values, and also defines LDA as
      ** an external data area
      *****************************************************************
     C/COPY ZACPYSRC,PSSR_ILE
      *****************************************************************
**  CPY@
(c) Finastra International Limited 2001
** WZ10
0000000000
** TabErrNum/TabSRecNum - Table for Error Field Sequence/Subfile Record Number
006001007001008001009001010002011002012002013002
014003015003016003017003018004019004020004021004
022005023005024005025005026006027006028006029006
030007031007032007033007034008035008036008037008
038009039009040009041009042010043010044010045010
046011047011048011049011050012051012052012053012
054013055013056013057013058014059014060014061014
062015063015064015065015066016067016068016069016
070017071017072017073017074018075018076018077018
078019079019080019081019082020083020084020085020
086021087021088021089021090022091022092022093022
094023095023096023097023098024099024100024101024
102025103025104025105025106026107026108026109026
110027111027112027113027114028115028116028117028
118029119029120029121029122030123030124030125030
126031127031128031129031130032131032132032133032
134033135033136033137033138034139034140034141034
142035143035144035145035146036147036148036149036
150037151037152037153037154038155038156038157038
158039159039160039161039162040163040164040165040
166041167041168041169041170042171042172042173042
174043175043176043177043178044179044180044181044
182045183045184045185045186046187046188046189046
190047191047192047193047194048195048196048197048
198049199049200049201049202050203050204050205050
206051207051208051209051210052211252212052213052
214053215053216053217053218054219454220054221054
222055223055224055225055226056227656228056229056
230057231057232057233057234058235858236058237058
238059239059240059241059242060243060244060245060
246061247061248061249061250062251262252062253062
254063255063256063257063258064259464260064261064
262065263065264065265065266066267666268066269066
270067271067272067273067274068275068276068277068
278069279069280069281069282070283070284070285070
286071287071288071289071290072291072292072293072
294073295073296073297073298074299074300074301074
302075303075304075305075306076307876308076309076
310077311077312077313077314078315078316078317078
318079319079320079321079322080323280324080325080
326081327081328081329081330082331482332082333082
334083335083336083337083338084339684340084341084
342085343085344085345085346086347086348086349086
350087351087352087353087354088355088356088357088
358089359089360089361089362090363090364090365090
366091367091368091369091370092371092372092373092
374093375093376093377093378094379694380094381094
382095383095384095385095386096387096388096389096
390097391097392097393097394098395098396098397098
