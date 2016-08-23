     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas SD Cash Management ICD Maintenance')
      *****************************************************************
      *                                                               *
      *  Midas  - Standing Data                                       *
      *                                                               *
      *  SD9452 - Cash Management ICD Maintenance                     *
      *                                                               *
      *  Function: This module validates and updates Cash Management  *
      *            ICD Data                                           *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2002            *
      *                                                               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      *  Last Amend No. 245963             Date 08Mar07               *
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *  Prev Amend No. CSD031             Date 10Apr06               *
      *                 CGL029             Date 01Sep03               *
      *                 221277             Date 18Sep03               *
      *                 CRE008  *CREATE    Date 19Feb02               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  245963 - Account code from AOACODR0 not saved due to use of  *
      *           short data structure DSFDY. Use DSSDY instead.      *
      *  CSD031 - Enhanced Centralised Static Data (Recompile)        *
      *  CGL029 - Increase Account Code to 10 digits                  *
      *  221277 - Legal text should not be absolutely necessary       *
      *  CRE008 - Cash Management                                     *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  Use of indicators.                                           *
      *                                                               *
      *    11         Protect Indicator for Enquiry Mode              *
      *    20         Error in Zero Balancing/Sweeping Heirarchies    *
      *    21         Error in Group Account Heirarchies              *
      *    22         Error in Top On Balance Sheet                   *
      *    23         Error in A/C for Shadow Contra Entries          *
      *    24         Error in Level for Shadow Control Entries       *
      *    25         Error in A/C for Contra Entries                 *
      *    26         Error in Level for Contra Entries               *
      *    27         Error in Text for Group A/c OFF                 *
      *    28         Error in Text for Zero Bal OFF                  *
      *    29         Error in LOCAL Forward Value Sweeping           *
      *    30         Error in LOCAL Forward Value Days               *
      *    31         Error in LOCAL Back Value Days                  *
      *    32         Error in EXTERNAL Forward Value Sweeping        *
      *    33         Error in EXTERNAL Forward Value Days            *
      *    34         Error in EXTERNAL Back Value Days               *
      *    35         Error in External Interface for MT103/MT101     *
      *    36         Error in MT103 Default Status                   *
      *    37         Error in MT101 Default Status                   *
      *    38         Error in Sweeping in Input Cycle                *
      *    39-50      Error in Input Cycle Sweeping Frequency         *
      *    51         Error in Group A/c Transaction Type             *
      *    52         Error in Charge Income A/c Code                 *
      *    53         Error in Charge Income Profit Centre            *
      *    60-62      Used for Test Numeric Indicators                *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  S U B R O U T I N E  I N D E X                               *
      *                                                               *
      * SRProcess - Process initial screen                            *
      * SRMove    - Move file fields to screen fields                 *
      * SRDisplay - Display Screen                                    *
      * SRValid   - Validate Screen Details                           *
      * SRUpdate  - Write/Update Record in file SDCMANL0              *
      * SRSDCntrl - Update Standing Data Controls                     *
      * SRSndErr  - Send Error Message                                *
      * *PSSR     - Error processing                                  *
      * *INZSR    - Initialise                                        *
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
 
     FSD9452DF  CF   E             WORKSTN INFSR(*PSSR)
      ** Midas RE Cash Management ICD Maintenance Screen
 
     FSDCMANL0  UF A E           K DISK    INFSR(*PSSR)
     F                                     COMMIT
      ** Midas RE Cash Management ICD Update Index
 
     FSDFCTLL0  UF   E           K DISK    INFSR(*PSSR)
     F                                     COMMIT
      ** Standing Data Controls Update index
 
      *****************************************************************
      **
      ** +--------------------------------------+
      ** ¦ Automatically included D-specs       ¦
      ** ¦ ==============================       ¦
      ** +--------------------------------------+
      **
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
 
      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
 
      ** External data structure for Bank Details
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
      ** External data structure for General Ledger Details
     D SDGELR        E DS                  EXTNAME(SDGELRPD)
      ** Retail Transaction Type Details
     D SDRETR        E DS                  EXTNAME(SDRETRPD)
      ** Account Code Details
     D SDACOD        E DS                  EXTNAME(SDACODPD)
     D #AACCD        E                     EXTFLD(QQACCD)                                     CGL029
      ** Profit Centre Details
     D SDPRFC        E DS                  EXTNAME(SDPRFCPD)
      ** First DS for access programs
     D DSFDY         E DS                  EXTNAME(DSFDY)
      ** Second DS for Access Programs, Long Data Structure
     D DSSDY         E DS                  EXTNAME(DSSDY)
 
 
      ** Cash Management ICD File
     D WDSFDBRC      E DS                  EXTNAME(SDCMANPD)
 
      ** Data Structure for Screen Fields
     D WDSSDBRC        DS           600
 
      ** Data Structure for Text for Group Acc Off
     D WDSTXTG         DS
     D  WTXTG1                 1     54
     D  WTXTG2                55    127
     D  WTXTG3               128    200
 
      ** Data Structure for Text for Zero Bal Off
     D WDSTXTZ         DS
     D  WTXTZ1                 1     54
     D  WTXTZ2                55    127
     D  WTXTZ3               128    200
 
      ** Data Structure for No. of Forward Value Days
     D WDSFVD          DS
     D  WAFVDN                 1      2
     D  WAFVDA                 3      3
 
      ** Data Structure for No. of Back Value Days
     D WDSBVD          DS
     D  WABVDN                 1      2
     D  WABVDA                 3      3
 
      ** Data Structure for Input Cycle Sweeping Frequency
     D WDSICSF         DS
     D  #1ICSFA                1      4
     D  WHOURA                 1      2
     D  WMINA                  3      4
     D  #1ICSFB                5      8
     D  WHOURB                 5      6
     D  WMINB                  7      8
     D  #1ICSFC                9     12
     D  WHOURC                 9     10
     D  WMINC                 11     12
     D  #1ICSFD               13     16
     D  WHOURD                13     14
     D  WMIND                 15     16
     D  #1ICSFE               17     20
     D  WHOURE                17     18
     D  WMINE                 19     20
     D  #1ICSFF               21     24
     D  WHOURF                21     22
     D  WMINF                 23     24
     D  #1ICSFG               25     28
     D  WHOURG                25     26
     D  WMING                 27     28
     D  #1ICSFH               29     32
     D  WHOURH                29     30
     D  WMINH                 31     32
     D  #1ICSFI               33     36
     D  WHOURI                33     34
     D  WMINI                 35     36
     D  #1ICSFJ               37     40
     D  WHOURJ                37     38
     D  WMINJ                 39     40
     D  #1ICSFK               41     44
     D  WHOURK                41     42
     D  WMINK                 43     44
     D  #1ICSFL               45     48
     D  WHOURL                45     46
     D  WMINL                 47     48
 
      ** Data Structure of Valid Time
     D WDSVTime        DS
     D  WHOURN                 1      2  0
     D  WMINN                  3      4  0
 
      ** Array of Inputted Time
     D WTime           S              4A   DIM(12)
 
      ** Array of Valid Time
     D WVTime          S              4  0 DIM(12)
 
      ** Work Array 1
     D WArray1         S              1A   DIM(3)
 
      ** Work Array 2
     D WArray2         S              1A   DIM(3)
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
     D WError          S              1A
     D WFVDN           S              2  0
     D WBVDN           S              2  0
     D WEICSFA         S              1A
     D WRun            S              1A
     D WNumRec         S              5  0
     D WNumIns         S              5  0
     D WNumAmd         S              5  0
     D WNumDel         S              5  0
     D PRetCodeIn      S              7A
     D POption         S              7A
     D PKey            S             10A
     D PMode           S              1A
     D PMsgFile        S             10A   INZ('GBREUSRMSG')
     D PMsgID          S             10A
     D X               S              2  0
     D Y               S              2  0
 
      *****************************************************************
      /EJECT
      *****************************************************************
 
      ** +--- Start of Main processing -----------------------------------+
      ** ¦                                                                ¦
      ** ¦ Initial processing is performed automatically: the *INZSR is   ¦
      ** ¦ executed at program activation.                                ¦
      ** ¦                                                                ¦
      ** +----------------------------------------------------------------+
 
      *****************************************************************
 
     C                   EXSR      SRProcess
 
     C                   DOU       *INKC = *ON OR WError = 'N'
 
     C                   EXSR      SRDisplay
 
     C                   IF        PMode <> 'E' AND *INKC <> *ON
     C                   EXSR      SRValid
     C                   IF        WError <> 'Y'
     C                   EXSR      SRUpdate
     C                   ENDIF
     C                   ENDIF
 
     C                   ENDDO
 
      ** Terminate program
 
     C                   IF        WError = 'Y'
     C                   ROLBK
     C                   ELSE
     C                   COMMIT
     C                   ENDIF
 
     C                   EVAL      *INLR = *ON
 
     C                   RETURN
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRPocess - Process Initial Screen                            *
      *                                                               *
      *  Called by: Main Processing                                   *
      *                                                               *
      *  Calls    : SRMove, SRSndErr                                  *
      *                                                               *
      *****************************************************************
 
     C     SRProcess     BEGSR
 
      ** Check for existing record
 
     C     PKey          CHAIN     SDCMANL0
 
      ** Record does not exist
 
     C                   IF        NOT %FOUND(SDCMANL0)
     C                   EVAL      WError = 'Y'
 
      ** Send message 'Cash Management ICD Not Found'
 
     C                   IF        PMode = 'E'
     C                   EVAL      PMsgID = 'RE74001'
     C                   ELSE
     C                   EVAL      PMsgID = 'RE74002'
     C                   ENDIF
     C                   EXSR      SRSndErr
     C                   ELSE
     C                   EXSR      SRMove
     C                   ENDIF
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRMove - Move File Fields to Screen Fields                   *
      *                                                               *
      *  Called by: SR/SRProcess                                      *
      *                                                               *
      *  Calls    : None                                              *
      *                                                               *
      *****************************************************************
 
     C     SRMOVE        BEGSR
 
     C                   EVAL      #1ZBSH = CMZBSH
     C                   EVAL      #1GACH = CMGACH
     C                   EVAL      #1TOPB = CMTOPB
     C                   IF        CMACSC = *ZERO
     C                   MOVE      *BLANKS       #1ACSC
     C                   ELSE
     C                   MOVE      CMACSC        #1ACSC
     C                   ENDIF
     C                   EVAL      #1LVSC = CMLVSC
     C                   IF        CMACCE = *ZERO
     C                   MOVE      *BLANKS       #1ACCE
     C                   ELSE
     C                   MOVE      CMACCE        #1ACCE
     C                   ENDIF
     C                   EVAL      #1LVCE = CMLVCE
     C                   MOVE      CMTXTG        WDSTXTG
     C                   EVAL      #1TXTG1 = WTXTG1
     C                   EVAL      #1TXTG2 = WTXTG2
     C                   EVAL      #1TXTG3 = WTXTG3
     C                   MOVE      CMTXTZ        WDSTXTZ
     C                   EVAL      #1TXTZ1 = WTXTZ1
     C                   EVAL      #1TXTZ2 = WTXTZ2
     C                   EVAL      #1TXTZ3 = WTXTZ3
     C                   EVAL      #1LFVS = CMLFVS
     C                   EVAL      #1LFVD = CMLFVD
     C                   EVAL      #1LBVD = CMLBVD
     C                   EVAL      #1EFVS = CMEFVS
     C                   EVAL      #1EFVD = CMEFVD
     C                   EVAL      #1EBVD = CMEBVD
     C                   EVAL      #1INTF = CMINTF
     C                   EVAL      #1103S = CM103S
     C                   EVAL      #1101S = CM101S
     C                   EVAL      #1SWIC = CMSWIC
     C                   MOVE      CMICSF        WDSICSF
     C                   EVAL      #1GATT = CMGATT
     C                   IF        CMCHAC = *ZERO
     C                   MOVE      *BLANKS       #1CHAC
     C                   ELSE
     C                   MOVE      CMCHAC        #1CHAC
     C                   ENDIF
     C                   EVAL      #1CHPC = CMCHPC
 
      * Hold existing record image
 
     C                   EVAL      WDSSDBRC = WDSFDBRC
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRDisplay - Display and process detail screen                *
      *                                                               *
      *  Called by: Main Processing                                   *
      *                                                               *
      *  Calls    : None                                              *
      *                                                               *
      *****************************************************************
 
     C     SRDisplay     BEGSR
 
     C                   WRITE     SD9452C0
     C                   EXFMT     SD9452H0
 
      ** Clear messages from program message queue
 
     C                   IF        PMode <> 'E'
     C                   CALL      'ZA0250'
     C                   EVAL      *IN20 = *OFF
     C                   EVAL      *IN21 = *OFF
     C                   EVAL      *IN22 = *OFF
     C                   EVAL      *IN23 = *OFF
     C                   EVAL      *IN24 = *OFF
     C                   EVAL      *IN25 = *OFF
     C                   EVAL      *IN26 = *OFF
     C                   EVAL      *IN27 = *OFF
     C                   EVAL      *IN28 = *OFF
     C                   EVAL      *IN29 = *OFF
     C                   EVAL      *IN30 = *OFF
     C                   EVAL      *IN31 = *OFF
     C                   EVAL      *IN32 = *OFF
     C                   EVAL      *IN33 = *OFF
     C                   EVAL      *IN34 = *OFF
     C                   EVAL      *IN35 = *OFF
     C                   EVAL      *IN36 = *OFF
     C                   EVAL      *IN37 = *OFF
     C                   EVAL      *IN38 = *OFF
     C                   EVAL      *IN39 = *OFF
     C                   EVAL      *IN40 = *OFF
     C                   EVAL      *IN41 = *OFF
     C                   EVAL      *IN42 = *OFF
     C                   EVAL      *IN43 = *OFF
     C                   EVAL      *IN44 = *OFF
     C                   EVAL      *IN45 = *OFF
     C                   EVAL      *IN46 = *OFF
     C                   EVAL      *IN47 = *OFF
     C                   EVAL      *IN48 = *OFF
     C                   EVAL      *IN49 = *OFF
     C                   EVAL      *IN50 = *OFF
     C                   EVAL      *IN51 = *OFF
     C                   EVAL      *IN52 = *OFF
     C                   EVAL      *IN53 = *OFF
     C                   ENDIF
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRValid - Validate Details                                   *
      *                                                               *
      *  Called by: Main Processing                                   *
      *                                                               *
      *  Calls    : SRSndErr                                          *
      *                                                               *
      *****************************************************************
 
     C     SRValid       BEGSR
 
     C                   EVAL      WError = 'N'
 
      ** Validate Zero Balancing/Sweeping Heirarchies
 
     C                   IF        #1ZBSH <> 'N' AND
     C                             #1ZBSH <> 'Y'
     C                   EVAL      PMsgID = 'RE74003'
     C                   EVAL      WError = 'Y'
     C                   EVAL      *IN20 = *ON
     C                   EXSR      SRSndErr
     C                   ENDIF
 
      ** Validate Group Account Heirarchies
 
     C                   IF        #1GACH <> 'N' AND
     C                             #1GACH <> 'Y'
     C                   EVAL      PMsgID = 'RE74004'
     C                   EVAL      WError = 'Y'
     C                   EVAL      *IN21 = *ON
     C                   EXSR      SRSndErr
     C                   ENDIF
 
      ** Validate Top On Balance Sheet
 
     C                   IF        #1GACH = 'Y' AND
     C                             #1TOPB = *BLANKS OR
     C                             #1GACH = 'Y' AND
     C                             #1TOPB <> 'N' AND
     C                             #1TOPB <> 'Y'
     C                   EVAL      PMsgID = 'RE74005'
     C                   EVAL      WError = 'Y'
     C                   EVAL      *IN22 = *ON
     C                   EXSR      SRSndErr
     C                   ENDIF
 
     C                   IF        #1GACH = 'N' AND
     C                             #1TOPB <> *BLANKS
     C                   EVAL      PMsgID = 'RE74006'
     C                   EVAL      WError = 'Y'
     C                   EVAL      *IN22 = *ON
     C                   EXSR      SRSndErr
     C                   ENDIF
 
      ** Validate Account Code for Shadow Contra Entries
 
     C                   IF        #1ZBSH = 'Y'
 
     C                   IF        #1ACSC = *BLANKS
     C                   EVAL      PMsgID = 'RE74007'
     C                   EVAL      WError = 'Y'
     C                   EVAL      *IN23 = *ON
     C                   EXSR      SRSndErr
     C                   ELSE
 
     C                   CALL      'AOACODR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*KEY   '     @OPTN
     C**********         PARM      #1ACSC        @ACOD             4                          CGL029
     C                   PARM      #1ACSC        @ACOD            10
     C*****SDACOD        PARM      SDACOD        DSFDY                                        245963
     C     SDACOD        PARM      SDACOD        DSSDY                                        245963
 
     C     @RTCD         IFNE      *BLANK
     C                   EVAL      PMsgID = 'RE74008'
     C                   EVAL      WError = 'Y'
     C                   EVAL      *IN23 = *ON
     C                   EXSR      SRSndErr
     C                   ELSE
     C                   MOVEL     A5ACCD        #1ACSC
     C                   IF        A5ACTY = 'R' OR
     C                             A5TOIN = 'Y'
     C                   EVAL      PMsgID = 'RE74009'
     C                   EVAL      WError = 'Y'
     C                   EVAL      *IN23 = *ON
     C                   EXSR      SRSndErr
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
 
     C                   ENDIF
 
     C                   IF        #1ZBSH = 'N' AND
     C                             #1ACSC <> *BLANKS
     C                   EVAL      PMsgID = 'RE74010'
     C                   EVAL      WError = 'Y'
     C                   EVAL      *IN23 = *ON
     C                   EXSR      SRSndErr
     C                   ENDIF
 
      ** Validate Level for Shadow Control Entries
 
     C                   IF        #1ZBSH = 'Y' AND
     C                             #1LVSC = *BLANKS OR
     C                             #1ZBSH = 'Y' AND
     C                             #1LVSC <> 'N' AND
     C                             #1LVSC <> 'H' AND
     C                             #1LVSC <> 'S'
     C                   EVAL      PMsgID = 'RE74011'
     C                   EVAL      WError = 'Y'
     C                   EVAL      *IN24 = *ON
     C                   EXSR      SRSndErr
     C                   ENDIF
 
     C                   IF        #1ZBSH = 'N' AND
     C                             #1LVSC <> *BLANKS
     C                   EVAL      PMsgID = 'RE74012'
     C                   EVAL      WError = 'Y'
     C                   EVAL      *IN24 = *ON
     C                   EXSR      SRSndErr
     C                   ENDIF
 
      ** Validate Account Code for Contra Entries
 
     C                   IF        #1GACH = 'Y'
 
     C                   IF        #1ACCE = *BLANKS
     C                   EVAL      PMsgID = 'RE74013'
     C                   EVAL      WError = 'Y'
     C                   EVAL      *IN25 = *ON
     C                   EXSR      SRSndErr
     C                   ELSE
 
     C                   CALL      'AOACODR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*KEY   '     @OPTN
     C                   PARM      #1ACCE        @ACOD
     C*****SDACOD        PARM      SDACOD        DSFDY                                        245963
     C     SDACOD        PARM      SDACOD        DSSDY                                        245963
 
     C     @RTCD         IFNE      *BLANK
     C                   EVAL      PMsgID = 'RE74008'
     C                   EVAL      WError = 'Y'
     C                   EVAL      *IN25 = *ON
     C                   EXSR      SRSndErr
     C                   ELSE
     C                   MOVEL     A5ACCD        #1ACCE
     C                   IF        A5ACTY = 'R' OR
     C                             A5TOIN = 'Y'
     C                   EVAL      PMsgID = 'RE74009'
     C                   EVAL      WError = 'Y'
     C                   EVAL      *IN25 = *ON
     C                   EXSR      SRSndErr
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
 
     C                   ENDIF
 
     C                   IF        #1GACH = 'N' AND
     C                             #1ACCE <> *BLANKS
     C                   EVAL      PMsgID = 'RE74014'
     C                   EVAL      WError = 'Y'
     C                   EVAL      *IN25 = *ON
     C                   EXSR      SRSndErr
     C                   ENDIF
 
      ** Validate Level for Contra Entries
 
     C                   IF        #1GACH = 'Y' AND
     C                             #1LVCE = *BLANKS OR
     C                             #1GACH = 'Y' AND
     C                             #1LVCE <> 'N' AND
     C                             #1LVCE <> 'H' AND
     C                             #1LVCE <> 'S'
     C                   EVAL      PMsgID = 'RE74015'
     C                   EVAL      WError = 'Y'
     C                   EVAL      *IN26 = *ON
     C                   EXSR      SRSndErr
     C                   ENDIF
 
     C                   IF        #1GACH = 'N' AND
     C                             #1LVCE <> *BLANKS
     C                   EVAL      PMsgID = 'RE74016'
     C                   EVAL      WError = 'Y'
     C                   EVAL      *IN26 = *ON
     C                   EXSR      SRSndErr
     C                   ENDIF
 
      ** Validate Text For Group A/c Off
 
     C*******************IF        #1GACH = 'Y' AND                                           221277
     C*******************          #1TXTG1 = *BLANKS AND                                      221277
     C*******************          #1TXTG2 = *BLANKS AND                                      221277
     C*******************          #1TXTG3 = *BLANKS                                          221277
     C*******************EVAL      PMsgID = 'RE74017'                                         221277
     C*******************EVAL      WError = 'Y'                                               221277
     C*******************EVAL      *IN27 = *ON                                                221277
     C*******************EXSR      SRSndErr                                                   221277
     C*******************ENDIF                                                                221277
 
     C                   IF        #1GACH = 'N'
     C                   IF        #1TXTG1 <> *BLANKS OR
     C                             #1TXTG2 <> *BLANKS OR
     C                             #1TXTG3 <> *BLANKS
     C                   EVAL      PMsgID = 'RE74018'
     C                   EVAL      WError = 'Y'
     C                   EVAL      *IN27 = *ON
     C                   EXSR      SRSndErr
     C                   ENDIF
     C                   ENDIF
 
      ** Validate Text For Zero Bal Off
 
     C*******************IF        #1ZBSH = 'Y' AND                                           221277
     C*******************          #1TXTZ1 = *BLANKS AND                                      221277
     C*******************          #1TXTZ2 = *BLANKS AND                                      221277
     C*******************          #1TXTZ3 = *BLANKS                                          221277
     C*******************EVAL      PMsgID = 'RE74019'                                         221277
     C*******************EVAL      WError = 'Y'                                               221277
     C*******************EVAL      *IN28 = *ON                                                221277
     C*******************EXSR      SRSndErr                                                   221277
     C*******************ENDIF                                                                221277
 
     C                   IF        #1ZBSH = 'N'
     C                   IF        #1TXTZ1 <> *BLANKS OR
     C                             #1TXTZ2 <> *BLANKS OR
     C                             #1TXTZ3 <> *BLANKS
     C                   EVAL      PMsgID = 'RE74020'
     C                   EVAL      WError = 'Y'
     C                   EVAL      *IN28 = *ON
     C                   EXSR      SRSndErr
     C                   ENDIF
     C                   ENDIF
 
      ** Validate LOCAL Forward Value Sweeping
 
     C                   IF        #1ZBSH = 'Y' AND
     C                             #1LFVS = *BLANKS OR
     C                             #1ZBSH = 'Y' AND
     C                             #1LFVS <> 'N' AND
     C                             #1LFVS <> 'Y'
     C                   EVAL      PMsgID = 'RE74021'
     C                   EVAL      WError = 'Y'
     C                   EVAL      *IN29 = *ON
     C                   EXSR      SRSndErr
     C                   ENDIF
 
     C                   IF        #1ZBSH = 'N' AND
     C                             #1LFVS <> *BLANKS
     C                   EVAL      PMsgID = 'RE74022'
     C                   EVAL      WError = 'Y'
     C                   EVAL      *IN29 = *ON
     C                   EXSR      SRSndErr
     C                   ENDIF
 
      ** Validate LOCAL Forward Value Days
 
     C                   IF        #1LFVS = 'Y'
 
     C                   IF        #1LFVD = *BLANKS
     C                   EVAL      PMsgID = 'RE74023'
     C                   EVAL      WError = 'Y'
     C                   EVAL      *IN30 = *ON
     C                   EXSR      SRSndErr
     C                   ELSE
 
     C                   MOVEA     *BLANKS       WArray1
     C                   MOVEA     *BLANKS       WArray2
     C                   MOVEA     #1LFVD        WArray1
 
     C                   EVAL      X = 3
     C                   EVAL      Y = 3
     C                   DO        3
     C                   IF        WArray1(X) <> *BLANKS
     C                   MOVE      WArray1(X)    WArray2(Y)
     C                   EVAL      Y = Y - 1
     C                   ENDIF
     C                   EVAL      X = X - 1
     C                   ENDDO
 
     C                   MOVEA     WArray2       #1LFVD
     C                   MOVEA     WArray2       WDSFVD
 
     C                   TESTN                   WAFVDN               6061
     C                   IF        *IN60 <> *ON AND
     C                             *IN61 <> *ON
     C                   EVAL      PMsgID = 'RE74023'
     C                   EVAL      WError = 'Y'
     C                   EVAL      *IN30 = *ON
     C                   EXSR      SRSndErr
     C                   ELSE
     C                   IF        *IN61 = *ON
     C                   MOVEL     '0'           #1LFVD
     C                   ENDIF
     C                   MOVE      WAFVDN        WFVDN
     C                   IF        WFVDN  < 1 OR
     C                             WFVDN  > 99
     C                   EVAL      PMsgID = 'RE74023'
     C                   EVAL      WError = 'Y'
     C                   EVAL      *IN30 = *ON
     C                   EXSR      SRSndErr
     C                   ENDIF
     C                   ENDIF
 
     C                   IF        WAFVDA  <> 'C' AND
     C                             WAFVDA  <> 'B'
     C                   EVAL      PMsgID = 'RE74023'
     C                   EVAL      WError = 'Y'
     C                   EVAL      *IN30 = *ON
     C                   EXSR      SRSndErr
     C                   ENDIF
 
     C                   ENDIF
 
     C                   ENDIF
 
     C                   IF        #1LFVS = 'N' AND
     C                             #1LFVD <> *BLANKS OR
     C                             #1LFVS = ' ' AND
     C                             #1LFVD <> *BLANKS
     C                   EVAL      PMsgID = 'RE74024'
     C                   EVAL      WError = 'Y'
     C                   EVAL      *IN30 = *ON
     C                   EXSR      SRSndErr
     C                   ENDIF
 
      ** Validate LOCAL Back Value Days
 
     C                   IF        #1ZBSH = 'Y'
 
     C                   IF        #1LBVD = *BLANKS
     C                   EVAL      PMsgID = 'RE74025'
     C                   EVAL      WError = 'Y'
     C                   EVAL      *IN31 = *ON
     C                   EXSR      SRSndErr
     C                   ELSE
 
     C                   MOVEA     *BLANKS       WArray1
     C                   MOVEA     *BLANKS       WArray2
     C                   MOVEA     #1LBVD        WArray1
 
     C                   EVAL      X = 3
     C                   EVAL      Y = 3
     C                   DO        3
     C                   IF        WArray1(X) <> *BLANKS
     C                   MOVE      WArray1(X)    WArray2(Y)
     C                   EVAL      Y = Y - 1
     C                   ENDIF
     C                   EVAL      X = X - 1
     C                   ENDDO
 
     C                   MOVEA     WArray2       #1LBVD
     C                   MOVEA     WArray2       WDSBVD
 
     C                   TESTN                   WABVDN               6061
     C                   IF        *IN60 <> *ON AND
     C                             *IN61 <> *ON
     C                   EVAL      PMsgID = 'RE74025'
     C                   EVAL      WError = 'Y'
     C                   EVAL      *IN31 = *ON
     C                   EXSR      SRSndErr
     C                   ELSE
     C                   IF        *IN61 = *ON
     C                   MOVEL     '0'           #1LBVD
     C                   ENDIF
     C                   MOVE      WABVDN        WBVDN
     C                   IF        WBVDN  < 0 OR
     C                             WBVDN  > 99
     C                   EVAL      PMsgID = 'RE74025'
     C                   EVAL      WError = 'Y'
     C                   EVAL      *IN31 = *ON
     C                   EXSR      SRSndErr
     C                   ENDIF
     C                   ENDIF
 
     C                   IF        WABVDA  <> 'C' AND
     C                             WABVDA  <> 'M' AND
     C                             WABVDA  <> 'B'
     C                   EVAL      PMsgID = 'RE74025'
     C                   EVAL      WError = 'Y'
     C                   EVAL      *IN31 = *ON
     C                   EXSR      SRSndErr
     C                   ENDIF
 
     C                   ENDIF
 
     C                   ENDIF
 
     C                   IF        #1ZBSH = 'N' AND
     C                             #1LBVD <> *BLANKS
     C                   EVAL      PMsgID = 'RE74026'
     C                   EVAL      WError = 'Y'
     C                   EVAL      *IN31 = *ON
     C                   EXSR      SRSndErr
     C                   ENDIF
 
      ** Validate EXTERNAL Forward Value Sweeping
 
     C                   IF        #1ZBSH = 'Y' AND
     C                             #1EFVS = *BLANKS OR
     C                             #1ZBSH = 'Y' AND
     C                             #1EFVS <> 'N' AND
     C                             #1EFVS <> 'Y'
     C                   EVAL      PMsgID = 'RE74021'
     C                   EVAL      WError = 'Y'
     C                   EVAL      *IN32 = *ON
     C                   EXSR      SRSndErr
     C                   ENDIF
 
     C                   IF        #1ZBSH = 'N' AND
     C                             #1EFVS <> *BLANKS
     C                   EVAL      PMsgID = 'RE74022'
     C                   EVAL      WError = 'Y'
     C                   EVAL      *IN32 = *ON
     C                   EXSR      SRSndErr
     C                   ENDIF
 
      ** Validate EXTERNAL Forward Value Days
 
     C                   IF        #1EFVS = 'Y'
 
     C                   IF        #1EFVD = *BLANKS
     C                   EVAL      PMsgID = 'RE74023'
     C                   EVAL      WError = 'Y'
     C                   EVAL      *IN33 = *ON
     C                   EXSR      SRSndErr
     C                   ELSE
 
     C                   MOVEA     *BLANKS       WArray1
     C                   MOVEA     *BLANKS       WArray2
     C                   MOVEA     #1EFVD        WArray1
 
     C                   EVAL      X = 3
     C                   EVAL      Y = 3
     C                   DO        3
     C                   IF        WArray1(X) <> *BLANKS
     C                   MOVE      WArray1(X)    WArray2(Y)
     C                   EVAL      Y = Y - 1
     C                   ENDIF
     C                   EVAL      X = X - 1
     C                   ENDDO
 
     C                   MOVEA     WArray2       #1EFVD
     C                   MOVEA     WArray2       WDSFVD
 
     C                   TESTN                   WAFVDN               6061
     C                   IF        *IN60 <> *ON AND
     C                             *IN61 <> *ON
     C                   EVAL      PMsgID = 'RE74023'
     C                   EVAL      WError = 'Y'
     C                   EVAL      *IN33 = *ON
     C                   EXSR      SRSndErr
     C                   ELSE
     C                   IF        *IN61 = *ON
     C                   MOVEL     '0'           #1EFVD
     C                   ENDIF
     C                   MOVE      WAFVDN        WFVDN
     C                   IF        WFVDN  < 1 OR
     C                             WFVDN  > 99
     C                   EVAL      PMsgID = 'RE74023'
     C                   EVAL      WError = 'Y'
     C                   EVAL      *IN33 = *ON
     C                   EXSR      SRSndErr
     C                   ENDIF
     C                   ENDIF
 
     C                   IF        WAFVDA  <> 'C' AND
     C                             WAFVDA  <> 'B'
     C                   EVAL      PMsgID = 'RE74023'
     C                   EVAL      WError = 'Y'
     C                   EVAL      *IN33 = *ON
     C                   EXSR      SRSndErr
     C                   ENDIF
 
     C                   ENDIF
 
     C                   ENDIF
 
     C                   IF        #1EFVS = 'N' AND
     C                             #1EFVD <> *BLANKS OR
     C                             #1EFVS = ' ' AND
     C                             #1EFVD <> *BLANKS
     C                   EVAL      PMsgID = 'RE74024'
     C                   EVAL      WError = 'Y'
     C                   EVAL      *IN33 = *ON
     C                   EXSR      SRSndErr
     C                   ENDIF
 
      ** Validate EXTERNAL Back Value Days
 
     C                   IF        #1ZBSH = 'Y'
 
     C                   IF        #1EBVD <> *BLANKS
 
     C                   MOVEA     *BLANKS       WArray1
     C                   MOVEA     *BLANKS       WArray2
     C                   MOVEA     #1EBVD        WArray1
 
     C                   EVAL      X = 3
     C                   EVAL      Y = 3
     C                   DO        3
     C                   IF        WArray1(X) <> *BLANKS
     C                   MOVE      WArray1(X)    WArray2(Y)
     C                   EVAL      Y = Y - 1
     C                   ENDIF
     C                   EVAL      X = X - 1
     C                   ENDDO
 
     C                   MOVEA     WArray2       #1EBVD
     C                   MOVEA     WArray2       WDSBVD
 
     C                   TESTN                   WABVDN               6061
     C                   IF        *IN60 <> *ON AND
     C                             *IN61 <> *ON
     C                   EVAL      PMsgID = 'RE74025'
     C                   EVAL      WError = 'Y'
     C                   EVAL      *IN34 = *ON
     C                   EXSR      SRSndErr
     C                   ELSE
     C                   IF        *IN61 = *ON
     C                   MOVEL     '0'           #1EBVD
     C                   ENDIF
     C                   MOVE      WABVDN        WBVDN
     C                   IF        WBVDN  < 0 OR
     C                             WBVDN  > 99
     C                   EVAL      PMsgID = 'RE74025'
     C                   EVAL      WError = 'Y'
     C                   EVAL      *IN34 = *ON
     C                   EXSR      SRSndErr
     C                   ENDIF
     C                   ENDIF
 
     C                   IF        WABVDA  <> 'C' AND
     C                             WABVDA  <> 'M' AND
     C                             WABVDA  <> 'B'
     C                   EVAL      PMsgID = 'RE74025'
     C                   EVAL      WError = 'Y'
     C                   EVAL      *IN34 = *ON
     C                   EXSR      SRSndErr
     C                   ENDIF
 
     C                   ENDIF
 
     C                   ENDIF
 
     C                   IF        #1ZBSH = 'N' AND
     C                             #1EBVD <> *BLANKS
     C                   EVAL      PMsgID = 'RE74026'
     C                   EVAL      WError = 'Y'
     C                   EVAL      *IN34 = *ON
     C                   EXSR      SRSndErr
     C                   ENDIF
 
      ** Validate External Interface for MT103/MT101
 
     C                   IF        #1ZBSH = 'Y' AND
     C                             #1INTF = *BLANKS OR
     C                             #1ZBSH = 'Y' AND
     C                             #1INTF <> 'N' AND
     C                             #1INTF <> 'Y'
     C                   EVAL      PMsgID = 'RE74027'
     C                   EVAL      WError = 'Y'
     C                   EVAL      *IN35 = *ON
     C                   EXSR      SRSndErr
     C                   ENDIF
 
     C                   IF        #1ZBSH = 'N' AND
     C                             #1INTF <> *BLANKS
     C                   EVAL      PMsgID = 'RE74028'
     C                   EVAL      WError = 'Y'
     C                   EVAL      *IN35 = *ON
     C                   EXSR      SRSndErr
     C                   ENDIF
 
      ** Validate MT103 Default Status
 
     C                   IF        #1ZBSH = 'Y' AND
     C                             #1103S = *BLANKS OR
     C                             #1ZBSH = 'Y' AND
     C                             #1103S <> 'CRTD' AND
     C                             #1103S <> 'RSND'
     C                   EVAL      PMsgID = 'RE74029'
     C                   EVAL      WError = 'Y'
     C                   EVAL      *IN36 = *ON
     C                   EXSR      SRSndErr
     C                   ENDIF
 
     C                   IF        #1ZBSH = 'N' AND
     C                             #1103S <> *BLANKS
     C                   EVAL      PMsgID = 'RE74030'
     C                   EVAL      WError = 'Y'
     C                   EVAL      *IN36 = *ON
     C                   EXSR      SRSndErr
     C                   ENDIF
 
      ** Validate MT101 Default Status
 
     C                   IF        #1ZBSH = 'Y' AND
     C                             #1101S = *BLANKS OR
     C                             #1ZBSH = 'Y' AND
     C                             #1101S <> 'CRTD' AND
     C                             #1101S <> 'RSND'
     C                   EVAL      PMsgID = 'RE74031'
     C                   EVAL      WError = 'Y'
     C                   EVAL      *IN37 = *ON
     C                   EXSR      SRSndErr
     C                   ENDIF
 
     C                   IF        #1ZBSH = 'N' AND
     C                             #1101S <> *BLANKS
     C                   EVAL      PMsgID = 'RE74032'
     C                   EVAL      WError = 'Y'
     C                   EVAL      *IN37 = *ON
     C                   EXSR      SRSndErr
     C                   ENDIF
 
      ** Validate Sweeping in Input Cycle
 
     C                   IF        #1ZBSH = 'Y' AND
     C                             #1SWIC = *BLANKS OR
     C                             #1ZBSH = 'Y' AND
     C                             #1SWIC <> 'N' AND
     C                             #1SWIC <> 'Y'
     C                   EVAL      PMsgID = 'RE74033'
     C                   EVAL      WError = 'Y'
     C                   EVAL      *IN38 = *ON
     C                   EXSR      SRSndErr
     C                   ENDIF
 
     C                   IF        #1ZBSH = 'N' AND
     C                             #1SWIC <> *BLANKS
     C                   EVAL      PMsgID = 'RE74034'
     C                   EVAL      WError = 'Y'
     C                   EVAL      *IN38 = *ON
     C                   EXSR      SRSndErr
     C                   ENDIF
 
      ** Validate Input Cycle Sweeping Frequency
 
     C                   EVAL      WEICSFA = 'N'
 
     C                   IF        #1ZBSH = 'Y'
 
     C                   IF        #1SWIC = 'Y' AND
     C                             WDSICSF = *BLANKS
     C                   EVAL      PMsgID = 'RE74035'
     C                   EVAL      WError = 'Y'
     C                   EVAL      WEICSFA = 'Y'
     C                   EVAL      *IN39 = *ON
     C                   EXSR      SRSndErr
     C                   ELSE
 
      ** Check for any embedded lines
 
     C                   MOVEA     WDSICSF       WTIME
     C                   Z-ADD     12            X
 
     C                   DOW       X <> 0
 
     C                   IF        WTIME(X) <> *BLANKS
     C                   EVAL      Y = X - 1
     C                   DOW       Y <> 0
     C                   IF        WTIME(Y) = *BLANKS
     C                   EVAL      PMsgID = 'RE74036'
     C                   EVAL      WError = 'Y'
     C                   EVAL      WEICSFA = 'Y'
     C                   EVAL      *IN39 = *ON
     C                   EVAL      *IN40 = *ON
     C                   EVAL      *IN41 = *ON
     C                   EVAL      *IN42 = *ON
     C                   EVAL      *IN43 = *ON
     C                   EVAL      *IN44 = *ON
     C                   EVAL      *IN45 = *ON
     C                   EVAL      *IN46 = *ON
     C                   EVAL      *IN47 = *ON
     C                   EVAL      *IN48 = *ON
     C                   EVAL      *IN49 = *ON
     C                   EVAL      *IN50 = *ON
     C                   EXSR      SRSndErr
     C                   LEAVE
     C                   ENDIF
     C                   EVAL      Y = Y - 1
     C                   ENDDO
     C                   ENDIF
 
     C                   EVAL      X = X - 1
 
     C                   ENDDO
 
      ** Check time to be in 2400 hour format
 
     C                   IF        #1ICSFA <> *BLANKS
     C                   TESTN                   WHOURA               6061
     C                   TESTN                   WMINA                62
     C                   IF        *IN60 <> *ON AND
     C                             *IN61 <> *ON OR
     C                             *IN62 <> *ON
     C                   EVAL      PMsgID = 'RE74037'
     C                   EVAL      WError = 'Y'
     C                   EVAL      WEICSFA = 'Y'
     C                   EVAL      *IN39 = *ON
     C                   EXSR      SRSndErr
     C                   ELSE
     C                   IF        *IN61 = *ON
     C                   MOVEL     '0'           WHOURA
     C                   ENDIF
     C                   MOVE      WHOURA        WHOURN
     C                   MOVE      WMINA         WMINN
     C                   IF        WHOURN > 23 OR
     C                             WMINN  > 59
     C                   EVAL      PMsgID = 'RE74037'
     C                   EVAL      WError = 'Y'
     C                   EVAL      WEICSFA = 'Y'
     C                   EVAL      *IN39 = *ON
     C                   EXSR      SRSndErr
     C                   ELSE
     C                   MOVE      WDSVTIME      WVTIME(1)
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
 
     C                   IF        #1ICSFB <> *BLANKS
     C                   TESTN                   WHOURB               6061
     C                   TESTN                   WMINB                62
     C                   IF        *IN60 <> *ON AND
     C                             *IN61 <> *ON OR
     C                             *IN62 <> *ON
     C                   EVAL      PMsgID = 'RE74037'
     C                   EVAL      WError = 'Y'
     C                   EVAL      WEICSFA = 'Y'
     C                   EVAL      *IN40 = *ON
     C                   EXSR      SRSndErr
     C                   ELSE
     C                   IF        *IN61 = *ON
     C                   MOVEL     '0'           WHOURB
     C                   ENDIF
     C                   MOVE      WHOURB        WHOURN
     C                   MOVE      WMINB         WMINN
     C                   IF        WHOURN > 23 OR
     C                             WMINN  > 59
     C                   EVAL      PMsgID = 'RE74037'
     C                   EVAL      WError = 'Y'
     C                   EVAL      WEICSFA = 'Y'
     C                   EVAL      *IN40 = *ON
     C                   EXSR      SRSndErr
     C                   ELSE
     C                   MOVE      WDSVTIME      WVTIME(2)
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
 
     C                   IF        #1ICSFC <> *BLANKS
     C                   TESTN                   WHOURC               6061
     C                   TESTN                   WMINC                62
     C                   IF        *IN60 <> *ON AND
     C                             *IN61 <> *ON OR
     C                             *IN62 <> *ON
     C                   EVAL      PMsgID = 'RE74037'
     C                   EVAL      WError = 'Y'
     C                   EVAL      WEICSFA = 'Y'
     C                   EVAL      *IN41 = *ON
     C                   EXSR      SRSndErr
     C                   ELSE
     C                   IF        *IN61 = *ON
     C                   MOVEL     '0'           WHOURC
     C                   ENDIF
     C                   MOVE      WHOURC        WHOURN
     C                   MOVE      WMINC         WMINN
     C                   IF        WHOURN > 23 OR
     C                             WMINN  > 59
     C                   EVAL      PMsgID = 'RE74037'
     C                   EVAL      WError = 'Y'
     C                   EVAL      WEICSFA = 'Y'
     C                   EVAL      *IN41 = *ON
     C                   EXSR      SRSndErr
     C                   ELSE
     C                   MOVE      WDSVTIME      WVTIME(3)
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
 
     C                   IF        #1ICSFD <> *BLANKS
     C                   TESTN                   WHOURD               6061
     C                   TESTN                   WMIND                62
     C                   IF        *IN60 <> *ON AND
     C                             *IN61 <> *ON OR
     C                             *IN62 <> *ON
     C                   EVAL      PMsgID = 'RE74037'
     C                   EVAL      WError = 'Y'
     C                   EVAL      WEICSFA = 'Y'
     C                   EVAL      *IN42 = *ON
     C                   EXSR      SRSndErr
     C                   ELSE
     C                   IF        *IN61 = *ON
     C                   MOVEL     '0'           WHOURD
     C                   ENDIF
     C                   MOVE      WHOURD        WHOURN
     C                   MOVE      WMIND         WMINN
     C                   IF        WHOURN > 23 OR
     C                             WMINN  > 59
     C                   EVAL      PMsgID = 'RE74037'
     C                   EVAL      WError = 'Y'
     C                   EVAL      WEICSFA = 'Y'
     C                   EVAL      *IN42 = *ON
     C                   EXSR      SRSndErr
     C                   ELSE
     C                   MOVE      WDSVTIME      WVTIME(4)
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
 
     C                   IF        #1ICSFE <> *BLANKS
     C                   TESTN                   WHOURE               6061
     C                   TESTN                   WMINE                62
     C                   IF        *IN60 <> *ON AND
     C                             *IN61 <> *ON OR
     C                             *IN62 <> *ON
     C                   EVAL      PMsgID = 'RE74037'
     C                   EVAL      WError = 'Y'
     C                   EVAL      WEICSFA = 'Y'
     C                   EVAL      *IN43 = *ON
     C                   EXSR      SRSndErr
     C                   ELSE
     C                   IF        *IN61 = *ON
     C                   MOVEL     '0'           WHOURE
     C                   ENDIF
     C                   MOVE      WHOURE        WHOURN
     C                   MOVE      WMINE         WMINN
     C                   IF        WHOURN > 23 OR
     C                             WMINN  > 59
     C                   EVAL      PMsgID = 'RE74037'
     C                   EVAL      WError = 'Y'
     C                   EVAL      WEICSFA = 'Y'
     C                   EVAL      *IN43 = *ON
     C                   EXSR      SRSndErr
     C                   ELSE
     C                   MOVE      WDSVTIME      WVTIME(5)
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
 
     C                   IF        #1ICSFF <> *BLANKS
     C                   TESTN                   WHOURF               6061
     C                   TESTN                   WMINF                62
     C                   IF        *IN60 <> *ON AND
     C                             *IN61 <> *ON OR
     C                             *IN62 <> *ON
     C                   EVAL      PMsgID = 'RE74037'
     C                   EVAL      WError = 'Y'
     C                   EVAL      WEICSFA = 'Y'
     C                   EVAL      *IN44 = *ON
     C                   EXSR      SRSndErr
     C                   ELSE
     C                   IF        *IN61 = *ON
     C                   MOVEL     '0'           WHOURF
     C                   ENDIF
     C                   MOVE      WHOURF        WHOURN
     C                   MOVE      WMINF         WMINN
     C                   IF        WHOURN > 23 OR
     C                             WMINN  > 59
     C                   EVAL      PMsgID = 'RE74037'
     C                   EVAL      WError = 'Y'
     C                   EVAL      WEICSFA = 'Y'
     C                   EVAL      *IN44 = *ON
     C                   EXSR      SRSndErr
     C                   ELSE
     C                   MOVE      WDSVTIME      WVTIME(6)
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
 
     C                   IF        #1ICSFG <> *BLANKS
     C                   TESTN                   WHOURG               6061
     C                   TESTN                   WMING                62
     C                   IF        *IN60 <> *ON AND
     C                             *IN61 <> *ON OR
     C                             *IN62 <> *ON
     C                   EVAL      PMsgID = 'RE74037'
     C                   EVAL      WError = 'Y'
     C                   EVAL      WEICSFA = 'Y'
     C                   EVAL      *IN45 = *ON
     C                   EXSR      SRSndErr
     C                   ELSE
     C                   IF        *IN61 = *ON
     C                   MOVEL     '0'           WHOURG
     C                   ENDIF
     C                   MOVE      WHOURG        WHOURN
     C                   MOVE      WMING         WMINN
     C                   IF        WHOURN > 23 OR
     C                             WMINN  > 59
     C                   EVAL      PMsgID = 'RE74037'
     C                   EVAL      WError = 'Y'
     C                   EVAL      WEICSFA = 'Y'
     C                   EVAL      *IN45 = *ON
     C                   EXSR      SRSndErr
     C                   ELSE
     C                   MOVE      WDSVTIME      WVTIME(7)
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
 
     C                   IF        #1ICSFH <> *BLANKS
     C                   TESTN                   WHOURH               6061
     C                   TESTN                   WMINH                62
     C                   IF        *IN60 <> *ON AND
     C                             *IN61 <> *ON OR
     C                             *IN62 <> *ON
     C                   EVAL      PMsgID = 'RE74037'
     C                   EVAL      WError = 'Y'
     C                   EVAL      WEICSFA = 'Y'
     C                   EVAL      *IN46 = *ON
     C                   EXSR      SRSndErr
     C                   ELSE
     C                   IF        *IN61 = *ON
     C                   MOVEL     '0'           WHOURH
     C                   ENDIF
     C                   MOVE      WHOURH        WHOURN
     C                   MOVE      WMINH         WMINN
     C                   IF        WHOURN > 23 OR
     C                             WMINN  > 59
     C                   EVAL      PMsgID = 'RE74037'
     C                   EVAL      WError = 'Y'
     C                   EVAL      WEICSFA = 'Y'
     C                   EVAL      *IN46 = *ON
     C                   EXSR      SRSndErr
     C                   ELSE
     C                   MOVE      WDSVTIME      WVTIME(8)
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
 
     C                   IF        #1ICSFI <> *BLANKS
     C                   TESTN                   WHOURI               6061
     C                   TESTN                   WMINI                62
     C                   IF        *IN60 <> *ON AND
     C                             *IN61 <> *ON OR
     C                             *IN62 <> *ON
     C                   EVAL      PMsgID = 'RE74037'
     C                   EVAL      WError = 'Y'
     C                   EVAL      WEICSFA = 'Y'
     C                   EVAL      *IN47 = *ON
     C                   EXSR      SRSndErr
     C                   ELSE
     C                   IF        *IN61 = *ON
     C                   MOVEL     '0'           WHOURI
     C                   ENDIF
     C                   MOVE      WHOURI        WHOURN
     C                   MOVE      WMINI         WMINN
     C                   IF        WHOURN > 23 OR
     C                             WMINN  > 59
     C                   EVAL      PMsgID = 'RE74037'
     C                   EVAL      WError = 'Y'
     C                   EVAL      WEICSFA = 'Y'
     C                   EVAL      *IN47 = *ON
     C                   EXSR      SRSndErr
     C                   ELSE
     C                   MOVE      WDSVTIME      WVTIME(9)
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
 
     C                   IF        #1ICSFJ <> *BLANKS
     C                   TESTN                   WHOURJ               6061
     C                   TESTN                   WMINJ                62
     C                   IF        *IN60 <> *ON AND
     C                             *IN61 <> *ON OR
     C                             *IN62 <> *ON
     C                   EVAL      PMsgID = 'RE74037'
     C                   EVAL      WError = 'Y'
     C                   EVAL      WEICSFA = 'Y'
     C                   EVAL      *IN48 = *ON
     C                   EXSR      SRSndErr
     C                   ELSE
     C                   IF        *IN61 = *ON
     C                   MOVEL     '0'           WHOURJ
     C                   ENDIF
     C                   MOVE      WHOURJ        WHOURN
     C                   MOVE      WMINJ         WMINN
     C                   IF        WHOURN > 23 OR
     C                             WMINN  > 59
     C                   EVAL      PMsgID = 'RE74037'
     C                   EVAL      WError = 'Y'
     C                   EVAL      WEICSFA = 'Y'
     C                   EVAL      *IN48 = *ON
     C                   EXSR      SRSndErr
     C                   ELSE
     C                   MOVE      WDSVTIME      WVTIME(10)
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
 
     C                   IF        #1ICSFK <> *BLANKS
     C                   TESTN                   WHOURK               6061
     C                   TESTN                   WMINK                62
     C                   IF        *IN60 <> *ON AND
     C                             *IN61 <> *ON OR
     C                             *IN62 <> *ON
     C                   EVAL      PMsgID = 'RE74037'
     C                   EVAL      WError = 'Y'
     C                   EVAL      WEICSFA = 'Y'
     C                   EVAL      *IN49 = *ON
     C                   EXSR      SRSndErr
     C                   ELSE
     C                   IF        *IN61 = *ON
     C                   MOVEL     '0'           WHOURK
     C                   ENDIF
     C                   MOVE      WHOURK        WHOURN
     C                   MOVE      WMINK         WMINN
     C                   IF        WHOURN > 23 OR
     C                             WMINN  > 59
     C                   EVAL      PMsgID = 'RE74037'
     C                   EVAL      WError = 'Y'
     C                   EVAL      WEICSFA = 'Y'
     C                   EVAL      *IN49 = *ON
     C                   EXSR      SRSndErr
     C                   ELSE
     C                   MOVE      WDSVTIME      WVTIME(11)
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
 
     C                   IF        #1ICSFL <> *BLANKS
     C                   TESTN                   WHOURL               6061
     C                   TESTN                   WMINL                62
     C                   IF        *IN60 <> *ON AND
     C                             *IN61 <> *ON OR
     C                             *IN62 <> *ON
     C                   EVAL      PMsgID = 'RE74037'
     C                   EVAL      WError = 'Y'
     C                   EVAL      WEICSFA = 'Y'
     C                   EVAL      *IN50 = *ON
     C                   EXSR      SRSndErr
     C                   ELSE
     C                   IF        *IN61 = *ON
     C                   MOVEL     '0'           WHOURL
     C                   ENDIF
     C                   MOVE      WHOURL        WHOURN
     C                   MOVE      WMINL         WMINN
     C                   IF        WHOURN > 23 OR
     C                             WMINN  > 59
     C                   EVAL      PMsgID = 'RE74037'
     C                   EVAL      WError = 'Y'
     C                   EVAL      WEICSFA = 'Y'
     C                   EVAL      *IN50 = *ON
     C                   EXSR      SRSndErr
     C                   ELSE
     C                   MOVE      WDSVTIME      WVTIME(12)
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
 
     C                   ENDIF
 
      ** Time entered must be on ascending sequence
 
     C                   IF        WEICSFA = 'N'
 
     C                   Z-ADD     12            X
 
     C                   DOW       X <> 0
     C                   IF        WTIME(X) <> *BLANKS AND
     C                             X > 1
     C                   EVAL      Y = X - 1
     C                   IF        WVTIME(Y) >= WVTIME(X)
     C                   EVAL      PMsgID = 'RE74038'
     C                   EVAL      WError = 'Y'
     C                   EVAL      *IN39 = *ON
     C                   EVAL      *IN40 = *ON
     C                   EVAL      *IN41 = *ON
     C                   EVAL      *IN42 = *ON
     C                   EVAL      *IN43 = *ON
     C                   EVAL      *IN44 = *ON
     C                   EVAL      *IN45 = *ON
     C                   EVAL      *IN46 = *ON
     C                   EVAL      *IN47 = *ON
     C                   EVAL      *IN48 = *ON
     C                   EVAL      *IN49 = *ON
     C                   EVAL      *IN50 = *ON
     C                   EXSR      SRSndErr
     C                   LEAVE
     C                   ENDIF
     C                   ENDIF
     C                   EVAL      X = X - 1
     C                   ENDDO
 
     C                   ENDIF
 
     C                   ENDIF
 
     C                   IF        #1ZBSH = 'N' AND
     C                             WDSICSF <> *BLANKS
     C                   EVAL      PMsgID = 'RE74039'
     C                   EVAL      WError = 'Y'
     C                   EVAL      *IN36 = *ON
     C                   EVAL      *IN37 = *ON
     C                   EVAL      *IN38 = *ON
     C                   EVAL      *IN39 = *ON
     C                   EVAL      *IN40 = *ON
     C                   EVAL      *IN41 = *ON
     C                   EVAL      *IN42 = *ON
     C                   EVAL      *IN43 = *ON
     C                   EVAL      *IN44 = *ON
     C                   EVAL      *IN45 = *ON
     C                   EVAL      *IN46 = *ON
     C                   EVAL      *IN47 = *ON
     C                   EVAL      *IN48 = *ON
     C                   EVAL      *IN49 = *ON
     C                   EVAL      *IN50 = *ON
     C                   EXSR      SRSndErr
     C                   ENDIF
 
      ** Group A/c Transaction type must be a valid transaction type
 
     C     #1GACH        IFEQ      'Y'
     C                   CALL      'AORETRR0'
     C                   PARM      *BLANKS       @RTCD             7
     C                   PARM      '*KEY   '     @OPTN             7
     C                   PARM      #1GATT        @TRATT            5
     C     SDRETR        PARM      SDRETR        DSFDY
 
     C     @RTCD         IFNE      *BLANK
     C                   EVAL      PMsgID = 'RE74064'
     C                   EVAL      WError = 'Y'
     C                   EVAL      *IN51 = *ON
     C                   EXSR      SRSndErr
     C                   ELSE
     C                   MOVE      A1RTTY        #1GATT
     C                   ENDIF
     C                   ELSE
     C     #1GATT        IFNE      *BLANK
     C                   EVAL      PMsgID = 'RE74064'
     C                   EVAL      WError = 'Y'
     C                   EVAL      *IN51 = *ON
     C                   EXSR      SRSndErr
     C                   ENDIF
     C                   ENDIF
 
      ** Charge Income Account code must be a valid account code
 
     C                   CALL      'AOACODR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*KEY   '     @OPTN
     C**********         PARM      #1CHAC        @ACOD             4                          CGL029
     C                   PARM      #1CHAC        @ACOD                                        CGL029
     C*****SDACOD        PARM      SDACOD        DSFDY                                        245963
     C     SDACOD        PARM      SDACOD        DSSDY                                        245963
 
     C     @RTCD         IFNE      *BLANK
     C                   EVAL      PMsgID = 'RE74065'
     C                   EVAL      WError = 'Y'
     C                   EVAL      *IN52 = *ON
     C                   EXSR      SRSndErr
     C                   ELSE
     C                   MOVEL     A5ACCD        #1CHAC
     C                   IF        A5ACTY = 'R' OR
     C                             A5TOIN = 'Y'
     C                   EVAL      PMsgID = 'RE74065'
     C                   EVAL      WError = 'Y'
     C                   EVAL      *IN52 = *ON
     C                   EXSR      SRSndErr
     C                   ENDIF
     C                   ENDIF
 
      ** Charge Income Proft Centre must be a valid profit centre
 
     C     BKPRCU        IFEQ      'Y'
     C                   CALL      'AOPRFCR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*KEY   '     @OPTN
     C                   PARM      #1CHPC        @PRFC             4
     C     SDPRFC        PARM      SDPRFC        DSFDY
 
     C     @RTCD         IFNE      *BLANK
     C                   EVAL      PMsgID = 'RE74066'
     C                   EVAL      WError = 'Y'
     C                   EVAL      *IN53 = *ON
     C                   EXSR      SRSndErr
     C                   ELSE
     C                   MOVEL     DSPCCD        #1CHPC
     C                   ENDIF
     C                   ELSE
     C                   MOVE      *BLANK        #1CHPC
     C                   ENDIF
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRUpdate - Update Record in PF/SDCMANPD                      *
      *                                                               *
      *  Called by: Main Processing                                   *
      *                                                               *
      *  Calls    : SRSndErr                                          *
      *                                                               *
      *****************************************************************
 
     C     SRUpdate      BEGSR
 
     C     PKey          CHAIN     SDCMANL0
 
      ** Write new ICD record
 
     C                   IF        NOT %FOUND(SDCMANL0)
 
     C                   EVAL      CMDMKY = PKey
     C                   EVAL      CMZBSH = #1ZBSH
     C                   EVAL      CMGACH = #1GACH
     C                   EVAL      CMTOPB = #1TOPB
     C                   MOVE      #1ACSC        CMACSC
     C                   EVAL      CMLVSC = #1LVSC
     C                   MOVE      #1ACCE        CMACCE
     C                   EVAL      CMLVCE = #1LVCE
     C                   EVAL      CMTXTG = #1TXTG1 + #1TXTG2 + #1TXTG3
     C                   EVAL      CMTXTZ = #1TXTZ1 + #1TXTZ2 + #1TXTZ3
     C                   EVAL      CMLFVS = #1LFVS
     C                   EVAL      CMLFVD = #1LFVD
     C                   EVAL      CMLBVD = #1LBVD
     C                   EVAL      CMEFVS = #1EFVS
     C                   EVAL      CMEFVD = #1EFVD
     C                   EVAL      CMEBVD = #1EBVD
     C                   EVAL      CMINTF = #1INTF
     C                   EVAL      CM103S = #1103S
     C                   EVAL      CM101S = #1101S
     C                   EVAL      CMSWIC = #1SWIC
     C                   EVAL      CMICSF = WDSICSF
     C                   EVAL      CMGATT = #1GATT
     C                   MOVE      #1CHAC        CMCHAC
     C                   EVAL      CMCHPC = #1CHPC
 
     C                   WRITE     SDCMAND0
 
      ** Update saved record image
 
     C                   EVAL      WDSSDBRC = WDSFDBRC
 
      ** Change Standing Data Controls
 
     C                   Z-ADD     *ZERO         WNumRec
     C                   Z-ADD     1             WNumIns
     C                   Z-ADD     *ZERO         WNumDel
     C                   Z-ADD     *ZERO         WNumAmd
 
     C                   EXSR      SRSDCntrl
 
     C                   ENDIF
 
      ** Update SDCMANL0
 
     C                   IF        %FOUND(SDCMANL0)
 
      ** Check for changed record
 
     C                   IF        WDSSDBRC <> WDSFDBRC
     C                   EVAL      WError = 'Y'
     C                   EVAL      PMsgID = 'RE74040'
     C                   EXSR      SRSndErr
     C                   UNLOCK    SDCMANL0
 
     C                   ELSE
 
      ** Update File
 
     C                   EVAL      CMZBSH = #1ZBSH
     C                   EVAL      CMGACH = #1GACH
     C                   EVAL      CMTOPB = #1TOPB
     C                   MOVE      #1ACSC        CMACSC
     C                   EVAL      CMLVSC = #1LVSC
     C                   MOVE      #1ACCE        CMACCE
     C                   EVAL      CMLVCE = #1LVCE
     C                   EVAL      CMTXTG = #1TXTG1 + #1TXTG2 + #1TXTG3
     C                   EVAL      CMTXTZ = #1TXTZ1 + #1TXTZ2 + #1TXTZ3
     C                   EVAL      CMLFVS = #1LFVS
     C                   EVAL      CMLFVD = #1LFVD
     C                   EVAL      CMLBVD = #1LBVD
     C                   EVAL      CMEFVS = #1EFVS
     C                   EVAL      CMEFVD = #1EFVD
     C                   EVAL      CMEBVD = #1EBVD
     C                   EVAL      CMINTF = #1INTF
     C                   EVAL      CM103S = #1103S
     C                   EVAL      CM101S = #1101S
     C                   EVAL      CMSWIC = #1SWIC
     C                   EVAL      CMICSF = WDSICSF
     C                   EVAL      CMGATT = #1GATT
     C                   MOVE      #1CHAC        CMCHAC
     C                   EVAL      CMCHPC = #1CHPC
 
     C                   UPDATE    SDCMAND0
 
     C                   Z-ADD     *ZERO         WNumRec
     C                   Z-ADD     *ZERO         WNumIns
     C                   Z-ADD     *ZERO         WNumDel
     C                   Z-ADD     1             WNumAmd
 
     C                   EXSR      SRSDCntrl
 
     C                   ENDIF
 
     C                   ENDIF
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRSDCntrl - Update Standing Data Controls                    *
      *                                                               *
      *  Called by: SR/SRProcess                                      *
      *                                                               *
      *  Calls    : SRWRITE, SRRASC                                   *
      *                                                               *
      *****************************************************************
 
     C     SRSDCntrl     BEGSR
 
      ** Move key fields to @AHREAU
 
     C                   EVAL      AHFLNM = *BLANKS
     C                   EVAL      AHFLNM = 'SDICDRPD'
 
     C     AHFLNM        CHAIN     SDFCTLL0
 
      ** If not found, DB Error
 
     C                   IF        NOT %FOUND(SDFCTLL0)
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE = 'SDFCTLPA'
     C                   EVAL      DBKEY = 'SDICDRPD'
     C                   EVAL      DBASE = 001
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ELSE
 
      ** USER: Processing after DBF read
 
     C                   ADD       AHNORC        WNumRec
     C                   ADD       AHNOIN        WNumIns
     C                   ADD       AHNOAM        WNumAmd
     C                   ADD       AHNODL        WNumDel
 
      ** Move non-key fields to @AHREAU
 
     C                   Z-ADD     WNumRec       AHNORC
     C                   Z-ADD     WNumIns       AHNOIN
     C                   Z-ADD     WNumAmd       AHNOAM
     C                   Z-ADD     WNumDel       AHNODL
 
     C                   UPDATE    @AHREAU
     C                   ENDIF
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRSndErr - Send Error Message                                *
      *                                                               *
      *  Called by: SRProcess, SRValid, SRUpdate                      *
      *                                                               *
      *  Calls    : None                                              *
      *                                                               *
      *****************************************************************
 
     C     SRSndErr      BEGSR
 
     C                   CALL      'ZA0340'
     C                   PARM                    PMsgFile
     C                   PARM                    PMsgID
 
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
 
     C     *ENTRY        PLIST
     C                   PARM                    PRetCodeIn
     C                   PARM                    PKey
     C                   PARM                    PMode
 
      ** The following /COPY sets the program, module and procedure
      ** names for database error processing.
 
     C/COPY ZACPYSRC,DBFIELDS
 
      ** Access bank details
 
     C                   CALL      'AOBANKR0'
     C                   PARM      *BLANKS       PRetCodeIn
     C                   PARM      '*FIRST '     POption
     C     SDBANK        PARM      SDBANK        DSSDY
 
      ** Database error
 
     C     PRetCodeIn    IFNE      *BLANKS
     C     *LOCK         IN        LDA
     C                   EVAL      DBASE = 002
     C                   EVAL      DBFile = 'SDBANKPD'
     C                   EVAL      DBKEY = '*FIRST'
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
 
      ** Access general ledger details
 
     C**********         CALL      'AOGELRR0'                                                 CGL029
     C                   CALL      'AOGELRR1'                                                 CGL029
     C                   PARM      *BLANKS       PRetCodeIn
     C                   PARM      '*FIRST '     POption
     C     SDGELR        PARM      SDGELR        DSSDY
 
      ** Database error
 
     C     PRetCodeIn    IFNE      *BLANKS
     C     *LOCK         IN        LDA
     C                   EVAL      DBASE = 003
     C                   EVAL      DBFile = 'SDGELRPD'
     C                   EVAL      DBKEY = '*FIRST'
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
     C     BKPRCU        COMP      'Y'                                6565
 
      ** Move Workstation ID to screen field
 
     C                   EVAL      #0RUNA = BJMRDT
     C                   EVAL      #0USER = PSUser
     C                   EVAL      #0WSID = PSJobName
     C                   EVAL      #0PGMQ = PSProcMod
 
      ** Initialise Work Fields
 
     C                   EVAL      WError = 'Y'
     C                   EVAL      WNumRec = *ZEROS
     C                   EVAL      WNumIns = *ZEROS
     C                   EVAL      WNumDel = *ZEROS
     C                   EVAL      WNumAMd = *ZEROS
 
     C                   IF        PMode = 'E'
     C                   EVAL      *IN11 = *ON
     C                   ELSE
     C                   EVAL      *IN11 = *OFF
     C                   ENDIF
 
     C                   EVAL      *IN20 = *OFF
     C                   EVAL      *IN21 = *OFF
     C                   EVAL      *IN22 = *OFF
     C                   EVAL      *IN23 = *OFF
     C                   EVAL      *IN24 = *OFF
     C                   EVAL      *IN25 = *OFF
     C                   EVAL      *IN26 = *OFF
     C                   EVAL      *IN27 = *OFF
     C                   EVAL      *IN28 = *OFF
     C                   EVAL      *IN29 = *OFF
     C                   EVAL      *IN30 = *OFF
     C                   EVAL      *IN31 = *OFF
     C                   EVAL      *IN32 = *OFF
     C                   EVAL      *IN33 = *OFF
     C                   EVAL      *IN34 = *OFF
     C                   EVAL      *IN35 = *OFF
     C                   EVAL      *IN36 = *OFF
     C                   EVAL      *IN37 = *OFF
     C                   EVAL      *IN38 = *OFF
     C                   EVAL      *IN39 = *OFF
     C                   EVAL      *IN40 = *OFF
     C                   EVAL      *IN41 = *OFF
     C                   EVAL      *IN42 = *OFF
     C                   EVAL      *IN43 = *OFF
     C                   EVAL      *IN44 = *OFF
     C                   EVAL      *IN45 = *OFF
     C                   EVAL      *IN46 = *OFF
     C                   EVAL      *IN47 = *OFF
     C                   EVAL      *IN48 = *OFF
     C                   EVAL      *IN49 = *OFF
     C                   EVAL      *IN50 = *OFF
     C                   EVAL      *IN51 = *OFF
     C                   EVAL      *IN52 = *OFF
     C                   EVAL      *IN53 = *OFF
 
      ** Initialise detail screen
 
     C                   MOVE      *BLANKS       #1ZBSH
     C                   MOVE      *BLANKS       #1GACH
     C                   MOVE      *BLANKS       #1TOPB
     C                   MOVE      *BLANKS       #1ACSC
     C                   MOVE      *BLANKS       #1LVSC
     C                   MOVE      *BLANKS       #1ACCE
     C                   MOVE      *BLANKS       #1LVCE
     C                   MOVE      *BLANKS       #1TXTG1
     C                   MOVE      *BLANKS       #1TXTG2
     C                   MOVE      *BLANKS       #1TXTG3
     C                   MOVE      *BLANKS       #1TXTZ1
     C                   MOVE      *BLANKS       #1TXTZ2
     C                   MOVE      *BLANKS       #1TXTZ3
     C                   MOVE      *BLANKS       #1LFVS
     C                   MOVE      *BLANKS       #1LFVD
     C                   MOVE      *BLANKS       #1LBVD
     C                   MOVE      *BLANKS       #1EFVS
     C                   MOVE      *BLANKS       #1EFVD
     C                   MOVE      *BLANKS       #1EBVD
     C                   MOVE      *BLANKS       #1INTF
     C                   MOVE      *BLANKS       #1103S
     C                   MOVE      *BLANKS       #1101S
     C                   MOVE      *BLANKS       #1SWIC
     C                   MOVE      *BLANKS       #1ICSFA
     C                   MOVE      *BLANKS       #1ICSFB
     C                   MOVE      *BLANKS       #1ICSFC
     C                   MOVE      *BLANKS       #1ICSFD
     C                   MOVE      *BLANKS       #1ICSFE
     C                   MOVE      *BLANKS       #1ICSFF
     C                   MOVE      *BLANKS       #1ICSFG
     C                   MOVE      *BLANKS       #1ICSFH
     C                   MOVE      *BLANKS       #1ICSFI
     C                   MOVE      *BLANKS       #1ICSFJ
     C                   MOVE      *BLANKS       #1ICSFK
     C                   MOVE      *BLANKS       #1ICSFL
     C                   MOVE      *BLANKS       #1GATT
     C                   MOVE      *BLANKS       #1CHAC
     C                   MOVE      *BLANKS       #1CHPC
 
     C                   ENDSR
 
      **********************************************************************
      /COPY ZACPYSRC,RECMPSSR
