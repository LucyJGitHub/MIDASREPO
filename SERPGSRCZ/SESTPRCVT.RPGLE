     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2003')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas SE Statmts Prod. Requests - Cvt File to Scrn')
      *****************************************************************
      *                                                               *
      *  Midas - Securities Trading Module                            *
      *                                                               *
      *  RPGLE/SESTPRCVT - Statement Production Requests              *
      *                  - File to Screen                             *
      *                                                               *
      *  Function:  This module converts the fields of a Statement    *
      *             Production Request Detail from file to screen.    *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2003            *
      *                                                               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *  Last Amend No. CSD031             Date 10Apr06               *
      *  Prev Amend No. CSD027             Date 09Dec05               *
      *                 CSE071             Date 19Jul05               *
      *                 CSW037A            Date 02May05               *
      *                 CSD025             Date 11Jan05               *
      *                 CSW037             Date 15Dec04               *
      *                 CSW036             Date 15Dec04               *
      *                 CLE025             Date 20Oct03               *
      *                 CSE040   *CREATE   Date 19Mar03               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CSD031 - Enhanced Centralised Static Data (Recompile)        *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CSE071 - Multiple Holidays Re Securities (recompile)         *
      *  CSW037A- Additional Field extended to 40 chars (recompile)   *
      *  CSD025 - Customer De-Activation                              *
      *  CSW037 - Additional Field Data on MT300/MT320                *
      *  CSW036 - Dual SWIFT BIC held on Client Details               *
      *  CLE025 - Credit Lines (Recompile)                            *
      *  CSE040 - Securities Statement Processing                     *
      *                                                               *
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
 
     FSECTY     IF   E           K DISK    INFSR(*PSSR) PREFIX(F1)
      ** Securities
 
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
 
     D SESTPR        E DS                  EXTNAME(SESTPRPD)
      ** Statement Production Request record layout
 
     D StPRScnIFld   E DS                  EXTNAME(SESTPR1PD)
      ** SESTPR Transaction Details in screen format
 
     D StPRScnOFld   E DS                  EXTNAME(SESTPR2PD)
      ** SESTPR Output only Screen Fields
 
     D SDCUST        E DS                  EXTNAME(SDCUSTPD)
      ** External DS for Customer Details
 
     D MEBICD        E DS                  EXTNAME(MEBICDPD)
      ** External DS for Midas BIC Directory Details
 
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
      ** External DS for Bank Details
 
     D DSFDY         E DS                  EXTNAME(DSFDY)
      ** Short DS for access programs
 
     D DSSDY         E DS                  EXTNAME(DSSDY)
      ** Long DS for access programs
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
      *****************************************************************
      /EJECT
      *****************************************************************
      *
      ** Initialization
      *
     C                   EXSR      INIT
      *
      ** Set screen fields
      *
     C                   EXSR      SCREEN
      *
      ** Return
      *
     C                   RETURN
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      * SCREEN - Set screen fields
      *****************************************************************
     C     SCREEN        BEGSR
      *
      ** INPUT/OUTPUT FIELDS
      ** Request Date - not on screen
      *
     C                   IF        SPDATE <> 0
     C                   EVAL      ZDAYNO = SPDATE
     C                   EXSR      ZDATE2
     C                   MOVEL     ZDATE         DDDATE
     C                   ENDIF
      *
      ** Request Sequence - not on screen
      *
     C                   MOVE      SPRSEQ        DDRSEQ
      *
      ** Priority
      *
     C                   EVAL      DDPRTY = SPPRTY
      *
      ** Delivery Notification
      *
     C                   EVAL      DDNOTF = SPNOTF
      *
      ** Sending Branch
      *
     C                   EVAL      DDSNDR = SPSNDR
      *
      ** Originating Branch
      *
     C                   EVAL      DDORIG = SPORIG
      *
      ** Safekeeping Customer
      *
     C                   EVAL      DDCUST = SPCUST
      *
      ** Statement Type
      *
     C                   EVAL      DDTYPE = SPTYPE
      *
      ** Frequency
      *
     C                   EVAL      DDFREQ = SPFREQ
      *
      ** Recipient
      *
     C                   EVAL      DDRECP = SPRECP
      *
      ** Midas Start Date
      *
     C                   IF        SPMSTD <> 0
     C                   EVAL      ZDAYNO = SPMSTD
     C                   EXSR      ZDATE2
     C                   MOVEL     ZDATE         DDMSTD
     C                   ENDIF
      *
      ** Start Time
      *
     C                   IF        SPSTTM <> 0
     C                   MOVE      SPSTTM        DDSTTM
     C                   ENDIF
      *
      ** Day in Month
      *
     C                   IF        SPDAYM <> 0
     C                   MOVE      SPDAYM        DDDAYM
     C                   ENDIF
      *
      ** Midas End Date
      *
     C                   IF        SPMETD <> 0
     C                   EVAL      ZDAYNO = SPMETD
     C                   EXSR      ZDATE2
     C                   MOVEL     ZDATE         DDMETD
     C                   ENDIF
      *
      ** End Time
      *
     C                   IF        SPENTM <> 0
     C                   MOVE      SPENTM        DDENTM
     C                   ENDIF
      *
      ** Correct display of Start/End Time
      *
 B1  C                   IF        DDSTTM <> *Blanks OR DDENTM <> *Blanks
      *
 B2  C                   IF        DDSTTM = *Blanks
     C                   EVAL      DDSTTM = *All'0'
 E2  C                   ENDIF
      *
 B2  C                   IF        DDENTM = *Blanks AND DDMETD <> *Blanks
     C                   EVAL      DDENTM = *All'0'
 E2  C                   ENDIF
      *
 E1  C                   ENDIF
      *
      ** Next Statement Date
      *
     C                   IF        SPNSTD <> 0
     C                   EVAL      ZDAYNO = SPNSTD
     C                   EXSR      ZDATE2
     C                   MOVEL     ZDATE         DDNSTD
     C                   ENDIF
      *
      ** Next Statement Time
      *
     C                   IF        SPNSTT <> 0
     C                   MOVE      SPNSTT        DDNSTT
     C                   ENDIF
      *
      ** Security Shortname
      *
     C                   EVAL      DDSESN = SPSESN
      *
      ** Network
      *
     C                   EVAL      DDNWRK = SPNWRK
      *
      ** Related MT549 Message
      *
     C                   EVAL      DDR549 = SPR549
      *
      ** Message to Cancel
      *
     C                   EVAL      DDCANC = SPCANC
      *
      ** OUTPUT ONLY FIELDS
      ** Production Request Status
      *
     C                   SELECT
     C                   WHEN      SPCHTP = 'I'
     C                   EVAL      DDSTAT = 'Created'
      *
     C                   WHEN      SPCHTP = 'A'
     C                   EVAL      DDSTAT = 'Amended'
      *
     C                   WHEN      SPCHTP = 'D'
     C                   EVAL      DDSTAT = 'Deleted'
      *
     C                   WHEN      SPCHTP = 'X'
     C                   EVAL      DDSTAT = 'Authorized'
     C                   ENDSL
      *
      ** Customer Report Name
      *
     C                   CALLB     'AOCUSTR0'
     C                   PARM      *Blanks       @RtCd
     C                   PARM      '*KEY'        @Optn
     C                   PARM      DDCUST        @Key1            10
     C                   PARM      *Blanks       @Kyst             7
     C     SDCUST        PARM      SDCUST        DSSDY
      *
     C                   IF        @RtCd = *Blanks
     C                   EVAL      DDCRNM = BBCRNM
     C                   ENDIF
      *
      ** Statement Type Description
      *
     C                   CALL      'Y2RVCNR'
     C                   PARM      *Blanks       @RtCd
     C                   PARM      1215000       @Y2LS             7 0
     C                   PARM      DDTYPE        @INVL            20
     C                   PARM      *Blank        @VLMP             1
     C                   PARM                    @TEXT            50
      *
     C                   IF        @Rtcd = *Blanks
     C                   EVAL      DDSTNM = @TEXT
     C                   ENDIF
      *
      ** Frequency Description
      *
     C                   CALL      'Y2RVCNR'
     C                   PARM      *Blanks       @RtCd
     C                   PARM      1215001       @Y2LS
     C                   PARM      DDFREQ        @INVL
     C                   PARM      *Blank        @VLMP
     C                   PARM                    @TEXT
      *
     C                   IF        @Rtcd = *Blanks
     C                   EVAL      DDFRNM = @TEXT
     C                   ENDIF
      *
      ** Recipient Name (may be a BIC address)
      *
     C                   CALLB     'AOBICDV0'
     C                   PARM      *Blanks       RetCodeOut
     C                   PARM      DDRECP        @IdRef           18
     C                   PARM      *Blanks       @Type             7
     C                   PARM                    DSSDY
      *
     C                   SELECT
     C                   WHEN      @Type = '*NUMBER'
     C                   EVAL      SDCUST = DSSDY
     C                   EVAL      DDRCNM = BBCRNM
      *
     C                   WHEN      @Type = '*BIC'
     C                   EVAL      MEBICD = DSSDY
     C                   EVAL      DDRCNM = BDINS1
     C                   ENDSL
      *
      ** Security Report Name
      *
     C     DDSESN        CHAIN     SECTY
      *
     C                   IF        %Found(SECTY)
     C                   EVAL      DDSRPN = F1SRPN
     C                   ENDIF
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * ZDATE2 - Format a date for output
      *****************************************************************
     C     ZDATE2        BEGSR
      *
     C                   CALLB     'ZDATE2'
     C                   PARM                    ZDAYNO            5 0
     C                   PARM                    BJDFIN
     C                   PARM                    ZDATE             6 0
     C                   PARM                    ZADATE            7
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * INIT - INITIALIZATION
      *****************************************************************
     C     INIT          BEGSR
      *
      ** Blank outputs (EXCEPT FOR ACTION CODE)
      *
     C                   MOVEL     DDACTN        ##ACTN            1
     C                   CLEAR                   StPRScnIFld
     C                   CLEAR                   StPRScnOFld
     C                   MOVEL     ##ACTN        DDACTN
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * *INZSR - INITIAL PROCESSING
      *****************************************************************
     C     *INZSR        BEGSR
      *
      **  Program Parameters
      *
     C     *ENTRY        PLIST
      *
      ** INPUT PARAMETERS
      ** Return Code
     C                   PARM                    RetCodeIn
      ** Statement Production Request in file format
     C                   PARM                    SESTPR
      *
      ** OUTPUT PARAMETERS
      ** SESTPR Input/Output Fields in Screen Format
     C                   PARM                    StPRScnIFld
      ** SESTPR Output Only Fields in Screen Format
     C                   PARM                    StPRScnOFld
      *
      ** Program, module and procedure names for database error processing.
      *
     C                   EVAL      DBPgm  = PSProcPgm
     C                   EVAL      DBMod  = PSProcMod
     C                   EVAL      DBProc = PSProcName
      *
      ** Access Bank Details
      *
     C                   CALL      'AOBANKR0'
     C                   PARM      *BLANKS       @RtCd
     C                   PARM      '*FIRST  '    @Optn
     C     SDBANK        PARM      SDBANK        DSFDY
      *
      ** Database Error
      *
     C                   IF        @RtCd <> *BLANK
     C                   EVAL      DBKEY = @Optn
     C                   EVAL      DBFILE = 'SDBANKPD'
     C                   EVAL      DBASE = 900
     C                   EXSR      *PSSR
     C                   ENDIF
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      ** The following /COPY contains the standard program status
      ** subroutine, including a bound call to the DBERRCTL module.
      *****************************************************************
      /COPY ZACPYSRC,PSSR_ILE
      *****************************************************************
**CTDATA CPY@
(c) Misys International Banking Systems Ltd. 2003
