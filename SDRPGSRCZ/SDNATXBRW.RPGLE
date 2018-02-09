     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2004')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas SD Non-A/c Holder by Country of Tax Browse')     *
      *****************************************************************
      *                                                               *
      *  Midas - Standing Data Module                                 *
      *                                                               *
      *  SDNATXBRW - Non-account Holders by Country of Tax Browse     *
      *                                                               *
      *  Function:  This module runs in two modes:                    *
      *             One display a list of non-account holders         *
      *             for selection, the other picks off the            *
      *             selection made.                                   *
      *                                                               *
      *  (c) Finastra International Limited 2004                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      *  Prev Amend No. CER059             Date 19Jul10               *
      *                 BUG24029           Date 20May09               *
      *                 CER054             Date 07Apr09               *
      *                 BUG22580           Date 02Feb09               *
      *                 CER048             Date 19May08               *
      *                 CER047             Date 19May08               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 BUG10403           Date 06Feb06               *
      *                 236137             Date 21Sep05               *
      *                 233004             Date 13Apr05               *
      *                 232543             Date 14Mar05               *
      * Midas Release 4.04 -------------------------------------------*
      *                 CGL032  *Create    Date 05Jul04               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CER059 - German Feature Upgrade to Delhi                     *
      *  BUG24029 - COB Error RE3662 Database Error                   *
      *  CER054 - German Features - Church Tax (Recompile)            *
      *  BUG22580 - Fields incorrectly labeled and lengths (Recompile)*
      *  CER048 - German Features - Taxes                             *
      *  CER047 - German Features LF037-00 Reporting §24c KWG         *
      *           (Recompile)                                         *
      *  BUG10403 - Certificate of Expiry Date Error                  *
      *  236137 - Change Control for CGL031                           *
      *  233004 - Addtl Cust and Non-a/c Holder by Country of Tax     *
      *  232543 - Fix to CGL032                                       *
      *  CGL032 - Automatic Exchange of Information.                  *
      *                                                               *
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
     FSDNATXBDF CF   E             WORKSTN
     F                                     SFILE(SDNATXS0:@@RRN)
 
      ** Non-A/C Holders file by Country of Tax - Retrieve Idx
     FSDNHTXL1  IF   E           K DISK    INFSR(*PSSR)
     F                                     RENAME(SDNHTXD0:NHTXREF)
 
      ** Country of Tax Codes by Ctry of Residence
     FSDCTTXL2  IF   E           K DISK    INFSR(*PSSR)
 
      ** Non-A/C Holders file by Country of Tax - Update Idx
     FSDNHTXL0  UF A E           K DISK    INFSR(*PSSR)
     F                                     COMMIT
     F                                     USROPN                                           BUG10403
 
      ** Table of field numbers and names
     FZAFLDNPD  IT   F   15        DISK    INFSR(*PSSR)
 
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ Automatically included D-specs       ¦
      ** ¦ ==============================       ¦
      ** +--------------------------------------+
      **
      **--------------------------------------------------------------------------------------------
      ** The following /COPY line includes (among others) the LDA layout
      ** and the copyright array definition:
     D/COPY ZACPYSRC,STD_D_SPEC
      **--------------------------------------------------------------------------------------------
 
      **--------------------------------------------------------------------------------------------
      ** The following /COPY includes the MM standard declares:
     D/COPY ZACPYSRC,STDDECLARE
      **--------------------------------------------------------------------------------------------
 
      **--------------------------------------------------------------------------------------------
      ** The following /COPY line includes all the defined fields in the
      ** Program Status Data Structures.  They have meaningful
      ** names, prefixed by 'PS'.
     D/COPY ZACPYSRC,PSDS
      **--------------------------------------------------------------------------------------------
      *
      **--------------------------------------------------------------------------------------------
      ** The following /COPY line includes the definitions for error and
      ** warning message arrays.
     D/COPY ZACPYSRC,ERR_ARRAYS
      **--------------------------------------------------------------------------------------------
 
      **--------------------------------------------------------------------------------------------
      ** The following /COPY line includes all the definitions of the error
      ** arrays, including the named constant giving the size of
      ** the arrays.  Note that it uses #MsgID and *MsgData, and so requires
      ** STD_D_SPEC.
     D/COPY ZACPYSRC,FVAL_ARRAY
      **--------------------------------------------------------------------------------------------
 
      **--------------------------------------------------------------------------------------------
      ** The following /COPY line includes the definitions for error and
      ** warning message arrays.
     D/COPY ZACPYSRC,APICTLARR
      **--------------------------------------------------------------------------------------------
 
      **--------------------------------------------------------------------------------------------
      ** The following /COPY line includes the definitions for fields
      ** required by the message handler.
     D/COPY ZACPYSRC,MSGHNDDCL
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
 
      ** External DS for Bank Details
     D SDBANK        E DS                  Extname(SDBANKPD)
 
      ** Externally described DS for Country Details
     D SDCTRY        E DS                  Extname(SDCTRYPD)
 
      ** Data Structure for SAR Details
     D SCSARD        E DS                  EXTNAME(SCSARDPD)
 
      ** Externally described DS for Non-account Holders
     D SDNAHO        E DS                  Extname(SDNAHOPD)
 
      ** Current Subfile Record Details
     D NwSflFmt      E DS                  Extname(SDNATXPD)
     D                                     Prefix(@)
 
      ** First DS for Access Programs, Short Data Structure
     D DSFDY         E DS                  Extname(DSFDY)
 
      ** Long DS for access programs
     D DSSDY         E DS                  Extname(DSSDY)
                                                                                            BUG24029
      ** Long Access Object Data Structure                                                  BUG24029
     D DSLDY         E DS                  EXTNAME(DSLDY)                                   BUG24029
 
      ** Error Indicators
     D OkFlags       E DS                  Extname(SDENATXPD)
 
      ** Indicator Array
     D Indicators      DS                  Based(IndicatorP)
     D  WRepairMode           80     80
     D  SFLNXTCHG             90     90                                                       233004
     D  WSflProtect           93     93
     D  WMsgSflEnd            95     95
     D  WNHTXeof              96     96
     D  WSflClr               97     97
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
     D @@NAHO          S             10
     D @@RRN           S              5  0
 
      ** Access Object parameters
     D PRtcd           S              7
     D POptn           S              7
     D PCncd           S              2
     D PCustNo         S             10A
     D PSard           S              6A
 
      ** ZDATE1 and ZDATE2 parameters
     D PZDayNo         S              5  0
     D PZDate          S              6  0
     D PZadate         S              7
     D PZDatErr        S              1
 
      ** QCLSCAN parameters
     D WLength1        S              3  0
     D WStart          S              3  0
     D WLength2        S              3  0
     D WTranslate      S              1
     D WTrim           S              1
     D WWild           S              1
     D WResult         S              3  0
 
      ** Parameters
     D @BDSFL          S              1
     D @RDSFL          S              1
     D @UPSFL          S              1
     D PRepair         S              1
     D PProtect        S              1
     D @INKC           S              1
     D @INKE           S              1
     D @INKL           S              1
     D @RdNxBr         S              1
 
     D WCount          S              3  0
     D WDate           S              6
     D WLastCTTX       S              2
     D KyCTTX          S              2
     D WLoop           S              1
     D I               S              1  0
     D CSC011          S              1A
 
      ** Pointer for the indicator Array
     D IndicatorP      S               *   INZ(%Addr(*IN))
      *                                                                                       CER048
     D CER048          S              1A                                                      CER048
     D PReturnCd       S              6A                                                      CER048
 
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
 
      ** Initialization
 
     C                   EXSR      INIT
                                                                                              232543
     C                   IF        PProtect <> 'Y'                                            232543
     C                   EXSR      SRChkRec
     C                   ENDIF                                                                232543
 
     C                   SELECT
 
      ** Build Sub-file
 
     C                   WHEN      @BDSFL = 'Y'
     C                   EXSR      SRClrSfl
     C                   EXSR      SRBldSfl
 
      ** Read Subfile Record
 
     C                   WHEN      @RDSFL = 'Y'
     C                   EXSR      SRRdSflr
 
      ** Reverse Image/Reset Subfile Record Display
 
     C                   WHEN      @UPSFL = 'Y'
     C                   EXSR      SRRISflr
     C                   EXSR      SRUpdSfl
 
      ** Continue browsing without rebuilding subfile
 
     C                   OTHER
     C                   EXSR      SRBldSfl
     C                   ENDSL
 
     C                   RETURN
 
      *****************************************************************
      /EJECT
      *****************************************************************
      * SRBldSfl - Build Subfile                                      *
      *****************************************************************
     C     SRBldSfl      BEGSR
 
      ** If subfile is to be built Read a Valid Non-account Holder then
      ** Seton ROLLUP indicator to drive initial loop.
 
     C                   IF        @BDSFL = 'Y'
 
     C                   EVAL      KyCTTX = *Blanks
     C     KNHTX         SETLL     SDNHTXL1
     C                   EVAL      SECTTX = *Blanks
     C                   EVAL      SEDESC = *Blanks
     C                   EVAL      SEETXS = *Blanks
     C                   EVAL      SECERF = *Blanks
     C                   EVAL      SECEEX = *Blanks
     C                   EVAL      SECSTS = *Blanks                                           236137
     C                   EVAL      SECRTP = *BLANKS                                           CER048
     C                   EVAL      SECADT = *BLANKS                                           CER048
     C                   EVAL      SECVDT = *BLANKS                                           CER048
     C                   EVAL      *IN98 = *ON
 
      ** If repair mode, do different kind of processing
     C                   IF        WRepairMode = *ON
     C                   EXSR      SRRepair
     C                   ENDIF
 
      ** else just continue browsing subfile...
      ** if PageDown was pressed, read the next record from file.
 
     C                   ELSE
     C                   EXSR      SRProcMsg
     C                   EXFMT     SDNATXC0
     C                   EXSR      SRChkKey
     C                   ENDIF
 
      ** Read records from the file into the subfile until a page has
      ** been filled or there are no more records.
      ** Repeat the process until either the end of file, ROLLUP
      ** has not been entered or F3 or F12 is input.
 
     C                   DOW       *IN98 = *ON
 
      ** Initialise count of records written to subfile page.
 
     C                   EVAL      WCount = 0
 
     C                   IF        WRepairMode = *OFF
     C                   EXSR      SRRdNATX
     C                   ENDIF
 
      ** For each record read, write it to the subfile.
      ** Do this until end of file or the subfile page is full.
 
     C                   DOW       WNHTXeof = *OFF
     C                             And wCount < 11
     C                             And WRepairMode = *OFF
 
      ** Increment the subfile record no. and records written fields.
 
     C                   EVAL      @@RRN = @@RRN + 1
     C                   EVAL      WCount = WCount + 1
 
      ** Protect Fields if necessary (like in Enquire mode)
 
     C                   IF        PProtect = 'Y'
     C                   EVAL      WSflProtect = *ON
     C                   ENDIF
 
      ** Format Non-A/C Holder fields for output
 
     C                   EXSR      SRFmtDsp
 
      ** Write the Non-account holder to the subfile.
 
     C                   EVAL      DDSFRN = @@RRN
     C                   WRITE     SDNATXS0
 
      ** Keep track of last Country of Tax displayed.
 
     C                   EVAL      WLastCTTX = DDCTTX
 
      ** Continue reading a valid Non-account holder
 
     C                   EXSR      SRRdNATX
 
     C                   ENDDO
 
      ** If there is no data to display
 
     C                   IF        @@RRN = *Zeros
     C                   EVAL      WSflProtect = *ON
     C                   EXSR      SRClrSfl
     C                   EVAL      @@RRN = 1
     C                   EVAL      DDSFRN = @@RRN
     C                   WRITE     SDNATXS0
 
     C                   EVAL      FldNameArr(1) = 'DDCTTX'
     C                   EVAL      MsgIdArr(1) = 'ASM0001'
     C                   ENDIF
 
     C                   EXSR      SRProcMsg
 
      ** If subfile is built and its fields are protected but module is
      ** not in repair mode, use footer for Enquiry mode.
 
     C                   IF        @BDSFL = 'Y'
     C                             And PProtect = 'Y'
     C                             And PRepair <> 'Y'
     C                   WRITE     SDNATXF1
     C                   ELSE
     C                   WRITE     SDNATXF0
     C                   ENDIF
 
      ** Read the subfile control record to determine whether records
      ** have been selected or whether ROLLUP is required.
 
     C                   EXFMT     SDNATXC0
 
      ** Check key pressed
 
     C                   EXSR      SRChkKey
 
     C                   ENDDO
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * SRChkKey - Check Key Pressed                                  *
      *****************************************************************
     C     SRChkKey      BEGSR
 
      ** Reset subfile empty indicator
 
     C                   EVAL      WSflProtect = *OFF
 
      ** Clear message subfile
 
     C                   CALL      'ZA0250'
 
      ** Clear any messages before processing user input
 
     C                   EVAL      FldNameArr = *Blanks
     C                   EVAL      MsgIdArr = *Blanks
     C                   EVAL      MsgDtaArr = *Blanks
 
      ** Check key pressed
 
     C                   SELECT
     C                   WHEN      *INKC = *ON
     C                   EVAL      @INKC = '1'
     C                   EVAL      *INLR = *ON
 
     C                   WHEN      *INKL = *ON
     C                   EVAL      @INKL = '1'
     C                   EVAL      *INLR = *ON
 
     C                   WHEN      *INKE = *ON
     C                   EVAL      @INKE = '1'
 
     C                   WHEN      *IN98 = *ON
     C                   EVAL      KyCTTX = WLastCTTX
     C     KNHTX         SETGT     SDNHTXL1
 
      ** If Enter was pressed, check if SEARCH strings are blanks
      ** if so go to validation, otherwise rebuild base on search
 
     C                   WHEN      SECTTX <> *Blanks
     C                             Or SEDESC <> *Blanks
     C                             Or SEETXS <> *Blanks
     C                             Or SECERF <> *Blanks
     C                             Or SECEEX <> *Blanks
     C                             Or SECSTS <> *Blanks                                       236137
     C                             Or SECRTP <> *BLANKS                                       CER048
     C                             Or SECADT <> *BLANKS                                       CER048
     C                             Or SECVDT <> *BLANKS                                       CER048
     C                   EXSR      SRClrSfl
     C                   EVAL      KyCTTX = *Blanks
     C                   EVAL      WLastCTTX = *Blanks
     C     KNHTX         SETLL     SDNHTXL1
     C                   EVAL      *IN98 = *ON
 
     C                   OTHER
     C                   EVAL      @RdNxBr = 'Y'
     C                   ENDSL
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * SRClrSfl - Clear the subfile to rebuild from scratch          *
      *****************************************************************
     C     SRClrSfl      BEGSR
 
      **  Initialise subfile relative record number.
 
     C                   EVAL      @@RRN = *Zeros
 
      **  Clear all fields
 
     C                   EVAL      DDCTTX = *Blanks
     C                   EVAL      DDDESC = *Blanks
     C                   EVAL      DDETXS = *Blanks
     C                   EVAL      DDCERF = *Blanks
     C                   EVAL      DDCEEX = *Blanks
     C                   EVAL      DDCSTS = *BLANKS                                           236137
     C                   EVAL      DDCRTP = *BLANKS                                           CER048
     C                   EVAL      DDCADT = *BLANKS                                           CER048
     C                   EVAL      DDCVDT = *BLANKS                                           CER048
 
      **  Clear subfile before refilling by writing control record
      **  with SFLCLR active.
 
     C                   EVAL      WSflClr = *ON
     C                   WRITE     SDNATXC0
     C                   EVAL      WSflClr = *OFF
 
      **  Set file pointer to first record of Non-a/c holder
 
     C     *Loval        SETLL     NHTXREF
 
      * Clear program message queue
 
     C                   CALL      'ZA0250'
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * SRFmtDsp - Format Non-account Holder for Output               *
      *****************************************************************
     C     SRFmtDsp      BEGSR
 
      ** Non-account Holder Reference
 
     C                   EVAL      DDCTTX = NXCTTX
     C                   EVAL      DDETXS = NXETXS
     C                   EVAL      DDCERF = NXCERF
     C                   EVAL      DDCEEX = *Blanks                                         BUG10403
 
     C                   IF        NXCEEX <> *ZEROS
     C                   EVAL      PZDayNo = NXCEEX
     C                   EXSR      SRZDATE2
     C**********         EVAL      DDCEEX = *Blanks                                         BUG10403
     C                   MOVE      PZDate        DDCEEX
     C                   ENDIF
 
      ** Retrieve Country Description from SDCTRYPD
 
     C                   EXSR      SRRtvCNm
     C                   EVAL      DDDESC = A4CNNM
     C                   EVAL      DDCSTS = NXNSTS                                            236137
      *                                                                                       CER048
     C                   IF        CER048 = 'Y'                                               CER048
      *                                                                                       CER048
     C                   EVAL      DDCRTP = NXCRTP                                            CER048
      *                                                                                       CER048
     C                   IF        NXCADT <> *ZEROS                                           CER048
     C                   EVAL      PZDAyNo = NXCADT                                           CER048
     C                   EXSR      SRZDATE2                                                   CER048
     C                   MOVE      PZDATE        DDCADT                                       CER048
     C                   ENDIF                                                                CER048
      *                                                                                       CER048
     C                   IF        NXCVDT <> *ZEROS                                           CER048
     C                   EVAL      PZDAyNo = NXCVDT                                           CER048
     C                   EXSR      SRZDATE2                                                   CER048
     C                   MOVE      PZDATE        DDCVDT                                       CER048
     C                   ENDIF                                                                CER048
      *                                                                                       CER048
     C                   ENDIF                                                                CER048
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * SRRtvCNm - Retrieve Country Name                              *
      *****************************************************************
     C     SRRtvCNm      BEGSR
 
     C                   CALL      'AOCTRYR0'
     C                   PARM      *Blanks       PRtcd
     C                   PARM      '*KEY   '     POptn
     C                   PARM      NXCTTX        PCncd
     C     SDCTRY        PARM      SDCTRY        DSFDY
 
     C                   IF        PRtcd <> *Blanks
     C     *Lock         IN        LDA
     C                   EVAL      DBFILE = 'SDCTRYPD'
     C                   EVAL      DBKEY  = PCncd
     C                   EVAL      DBPGM  = 'SDNATXBRW'
     C                   EVAL      DBASE  = 2
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C**********         ELSE                                                                 233004
     C**********         EVAL      A4CNNM = *Blanks                                           233004
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * SRRdNATX - Read a Non-account Holder                          *
      *****************************************************************
     C     SRRdNATX      BEGSR
 
      **  Read until a valid record is found or until no more
      **  records exist.
 
     C                   IF        SECTTX <> *Blanks
     C                   EVAL      KyCTTX = SECTTX
     C     KNHTX         SETLL     NHTXREF
     C                   EVAL      SECTTX = *Blanks
     C                   ENDIF
 
     C                   EVAL      WLoop = 'Y'
     C                   READ      NHTXREF                                96
 
     C                   DOW       WNHTXeof = *OFF
     C                             And WLoop = 'Y'
 
     C                   EVAL      WLoop = 'N'
 
      ** Select according to Country Description
 
     C                   IF        SEDESC <> *Blanks
     C                   EXSR      SRRtvCNm
     C                   CALL      'QCLSCAN'
     C                   PARM                    A4CNNM
     C                   PARM      30            WLength1
     C                   PARM      1             WStart
     C                   PARM                    SEDESC
     C                   PARM      30            WLength2
     C                   PARM      '1'           WTranslate
     C                   PARM      '1'           WTrim
     C                   PARM      '?'           WWild
     C                   PARM                    WResult
 
     C                   IF        WResult < 1
     C                   EVAL      WLoop = 'Y'
     C                   ENDIF
     C                   ENDIF
 
      ** Select according to EU Tax Status
 
     C                   IF        SEETXS <> *Blanks
     C                             And SEETXS <> NXETXS
     C                   EVAL      WLoop = 'Y'
     C                   ENDIF
 
      ** Select according to Certificate Reference
 
     C                   IF        SECERF <> *Blanks
     C                   CALL      'QCLSCAN'
     C                   PARM                    NXCERF
     C                   PARM      20            WLength1
     C                   PARM      1             WStart
     C                   PARM                    SECERF
     C                   PARM      20            WLength2
     C                   PARM      '1'           WTranslate
     C                   PARM      '1'           WTrim
     C                   PARM      '?'           WWild
     C                   PARM                    WResult
 
     C                   IF        WResult < 1
     C                   EVAL      WLoop = 'Y'
     C                   ENDIF
     C                   ENDIF
 
      ** Select according to Certificate Expiry Date
      ** if valid date is entered.
 
     C                   IF        SECEEX <> *Blanks
     C                   EVAL      Wdate = SECEEX
     C                   EXSR      SRZDATE1
 
     C                   IF        PZDatErr <> 'Y'
     C                   EVAL      PZDayNo = NXCEEX
     C                   EXSR      SRZDATE2
     C                   EVAL      WDate = *Blanks
     C                   MOVE      PZDate        WDate
     C                   IF        SECEEX <> WDate
     C                   EVAL      NXCTTX = *Blanks
     C                   EVAL      WLoop = 'Y'
     C                   ENDIF
 
     C                   ELSE
     C                   EVAL      WLoop = 'Y'
     C                   ENDIF
     C                   ENDIF
 
     C                   IF        SECSTS <> *BLANKS  AND                                     236137
     C                             SECSTS <> NXNSTS                                           236137
     C                   EVAL      NXNSTS = *Blanks                                           236137
     C                   EVAL      WLoop = 'Y'                                                236137
     C                   ENDIF                                                                236137
      *                                                                                       CER048
     C                   IF        CER048 = 'Y'                                               CER048
      *                                                                                       CER048
      ** Select according to certificate type                                                 CER048
      *                                                                                       CER048
     C                   IF        SECRTP <> *BLANKS                                          CER048
     C                   CALL      'QCLSCAN'                                                  CER048
     C                   PARM                    NXCRTP                                       CER048
     C                   PARM      2             WLength1                                     CER048
     C                   PARM      1             WStart                                       CER048
     C                   PARM                    SECRTP                                       CER048
     C                   PARM      2             WLength2                                     CER048
     C                   PARM      '1'           WTranslate                                   CER048
     C                   PARM      '1'           WTrim                                        CER048
     C                   PARM      '?'           WWild                                        CER048
     C                   PARM                    WResult                                      CER048
      *                                                                                       CER048
     C                   IF        WResult < 1                                                CER048
     C                   EVAL      WLoop = 'Y'                                                CER048
     C                   ENDIF                                                                CER048
     C                   ENDIF                                                                CER048
      *                                                                                       CER048
      ** Select according to certificate approval date                                        CER048
      *                                                                                       CER048
     C                   IF        SECADT <> *BLANKS                                          CER048
     C                   EVAL      Wdate = SECADT                                             CER048
     C                   EXSR      SRZDATE1                                                   CER048
      *                                                                                       CER048
     C                   IF        PZDatErr <> 'Y'                                            CER048
     C                   EVAL      PZDayNo = NXCADT                                           CER048
     C                   EXSR      SRZDATE2                                                   CER048
     C                   EVAL      WDate = *BLANKS                                            CER048
     C                   MOVE      PZDATE        WDate                                        CER048
      *                                                                                       CER048
     C                   IF        SECADT <> WDate                                            CER048
     C                   EVAL      NXCADT = *ZEROS                                            CER048
     C                   EVAL      WLoop = 'Y'                                                CER048
     C                   ENDIF                                                                CER048
      *                                                                                       CER048
     C                   ELSE                                                                 CER048
     C                   EVAL      WLoop = 'Y'                                                CER048
     C                   ENDIF                                                                CER048
      *                                                                                       CER048
     C                   ENDIF                                                                CER048
      *                                                                                       CER048
      ** Select according to certificate Value date                                           CER048
      *                                                                                       CER048
     C                   IF        SECVDT <> *BLANKS                                          CER048
     C                   EVAL      Wdate = SECVDT                                             CER048
     C                   EXSR      SRZDATE1                                                   CER048
      *                                                                                       CER048
     C                   IF        PZDatErr <> 'Y'                                            CER048
     C                   EVAL      PZDayNo = NXCVDT                                           CER048
     C                   EXSR      SRZDATE2                                                   CER048
     C                   EVAL      WDate = *BLANKS                                            CER048
     C                   MOVE      PZDATE        WDate                                        CER048
      *                                                                                       CER048
     C                   IF        SECVDT <> WDate                                            CER048
     C                   EVAL      NXCVDT = *ZEROS                                            CER048
     C                   EVAL      WLoop = 'Y'                                                CER048
     C                   ENDIF                                                                CER048
      *                                                                                       CER048
     C                   ELSE                                                                 CER048
     C                   EVAL      WLoop = 'Y'                                                CER048
     C                   ENDIF                                                                CER048
      *                                                                                       CER048
     C                   ENDIF                                                                CER048
      *                                                                                       CER048
     C                   ENDIF                                                                CER048
 
     C                   IF        WLoop = 'Y'
     C                   READ      NHTXREF                                96
     C                   ENDIF
 
      ** If Non-a/c holder is no longer the same, flag EOF
 
     C                   IF        DDNAHO <> NXNAHO
     C                   EVAL      WNHTXeof = *ON
     C                   ENDIF
 
     C                   ENDDO
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * SRRdSflr - Read a Subfile Record                              *
      *****************************************************************
     C     SRRdSflr      BEGSR
 
     C                   EVAL      *IN99 = *OFF
 
      ** Read the subfile for selected records
      ** Only process those for which the option field is blank.
 
     C                   READC     SDNATXS0                               99
 
      ** If end of subfile hasn't been reached yet continue
      ** checking for changes in subfile records and pass
      ** the details for validation.
 
     C                   IF        *IN99 = *ON
     C                   EVAL      @RdNxBr = 'N'
 
     C                   ELSE
     C                   EVAL      @RdNxBr = 'Y'
     C                   EVAL      @DDNAHO = DDNAHO
     C                   EVAL      @DDCTTX = DDCTTX
     C                   EVAL      @DDETXS = DDETXS
     C                   EVAL      @DDCERF = DDCERF
     C                   EVAL      @DDCEEX = DDCEEX
     C                   EVAL      @DDNSTS = DDCSTS                                           236137
     C                   IF        CER048 = 'Y'                                               CER048
     C                   EVAL      @DDCRTP = DDCRTP                                           CER048
     C                   EVAL      @DDCADT = DDCADT                                           CER048
     C                   EVAL      @DDCVDT = DDCVDT                                           CER048
     C                   ENDIF                                                                CER048
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * SRRISflr - Set current subfile record's field in error        *
      *            to Reverse Image                                   *
      *****************************************************************
     C     SRRISflr      BEGSR
 
     C                   EVAL      *IN32 = *OFF
     C                   EVAL      *IN33 = *OFF
     C                   EVAL      *IN34 = *OFF
     C                   EVAL      *IN35 = *OFF                                               236137
     C                   EVAL      *IN83 = *OFF                                               CER048
     C                   EVAL      *IN84 = *OFF                                               CER048
     C                   EVAL      *IN85 = *OFF                                               CER048
 
     C                   IF        OKETXS = 'N'
     C                   EVAL      *IN32 = *ON
     C                   ENDIF
 
     C                   IF        OKCERF = 'N'
     C                   EVAL      *IN33 = *ON
     C                   ENDIF
 
     C                   IF        OKCEEX = 'N'
     C                   EVAL      *IN34 = *ON
     C                   ENDIF
 
     C                   IF        OKNSTS = 'N'                                               236137
     C                   EVAL      *IN35 = *ON                                                236137
     C                   ENDIF                                                                236137
      *                                                                                       CER048
     C                   IF        CER048 = 'Y'                                               CER048
      *                                                                                       CER048
     C                   IF        OKCRTP = 'N'                                               CER048
     C                   EVAL      *IN83 = *ON                                                CER048
     C                   ENDIF                                                                CER048
      *                                                                                       CER048
     C                   IF        OKCADT = 'N'                                               CER048
     C                   EVAL      *IN84 = *ON                                                CER048
     C                   ENDIF                                                                CER048
      *                                                                                       CER048
     C                   IF        OKCVDT = 'N'                                               CER048
     C                   EVAL      *IN85 = *ON                                                CER048
     C                   ENDIF                                                                CER048
      *                                                                                       CER048
     C                   ENDIF                                                                CER048
                                                                                              236137
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * SRUpdSfl - Update subfile for changes in indicators           *
      *****************************************************************
     C     SRUpdSfl      BEGSR
 
     C                   EVAL      DDETXS = @DDETXS
     C                   EVAL      DDCERF = @DDCERF
     C                   EVAL      DDCEEX = @DDCEEX
     C                   EVAL      DDCSTS = @DDNSTS                                           236137
     C                   IF        CER048 = 'Y'                                               CER048
     C                   EVAL      DDCRTP = @DDCRTP                                           CER048
     C                   EVAL      DDCADT = @DDCADT                                           CER048
     C                   EVAL      DDCVDT = @DDCVDT                                           CER048
     C                   ENDIF                                                                CER048
 
     C                   EVAL      SFLNXTCHG = *ON                                            233004
     C                   UPDATE    SDNATXS0
     C**********         WRITE     SDNATXC0                                                   233004
     C                   MOVEA     '000'         *IN(32)
     C                   MOVEA     '000'         *IN(83)                                      CER048
     C                   MOVE      *ALL'Y'       OkFlags
 
     C                   ENDSR
      *****************************************************************
      * SRRepair - Process record details to repair                   *
      *****************************************************************
     C     SRRepair      BEGSR
 
      ** Update display fields with values from invalids file
 
     C                   EVAL      DDCTTX = @DDCTTX
     C                   EVAL      DDETXS = @DDETXS
     C                   EVAL      DDCERF = @DDCERF
     C                   EVAL      DDCEEX = @DDCEEX
     C                   EVAL      DDCSTS = @DDNSTS                                           236137
      *                                                                                       CER048
     C                   IF        CER048 = 'Y'                                               CER048
     C                   EVAL      DDCRTP = @DDCRTP                                           CER048
     C                   EVAL      DDCADT = @DDCADT                                           CER048
     C                   EVAL      DDCVDT = @DDCVDT                                           CER048
     C                   ENDIF                                                                CER048
 
      ** Retrieve Country Description from SDCTRYPD
 
     C                   EVAL      NXCTTX = DDCTTX
     C                   EXSR      SRRtvCNm
     C                   EVAL      DDDESC = A4CNNM
 
     C                   EVAL      @@RRN = 1
     C                   EVAL      DDSFRN = @@RRN
     C                   EVAL      WNHTXeof = *ON
 
     C                   EXSR      SRRISflr
 
     C                   IF        PProtect = 'Y'
     C                   EVAL      WSflProtect = *ON
     C                   ENDIF
 
     C                   WRITE     SDNATXS0
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * SRProcMsg - Process error messages                            *
      *****************************************************************
     C     SRProcMsg     BEGSR
 
      **--------------------------------------------------------------------------------------------
      ** The following /COPY line includes processing for the error and
      ** warning messages.
     C/COPY ZACPYSRC,MSGHNDDSP1
      **--------------------------------------------------------------------------------------------
 
     C                   WRITE     SDNATXMC
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * INIT - Initialisation
      *****************************************************************
     C     INIT          BEGSR
 
      ** Set up the Non-A/C Holder Reference to be used by the message handler
 
     C                   EVAL      TranRef = DDNAHO
 
     C                   EVAL      @INKC = '0'
     C                   EVAL      @INKL = '0'
     C                   EVAL      @@NAHO = DDNAHO
 
     C                   IF        PRepair = 'Y'
     C                   EVAL      WRepairMode = *ON
     C                   ELSE
     C                   EVAL      WRepairMode = *OFF
     C                   ENDIF
 
     C                   COMMIT                                                               232543
                                                                                              232543
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRChkRec - Check if record already exist on file              *
      *                                                               *
      *****************************************************************
     C     SRChkRec      BEGSR
 
      ** If no records exist, write new ones before building subfile
 
     C                   EXSR      SRChkCust
 
     C                   IF        NHPIND = 'Y'
     C                   OPEN      SDNHTXL0                                                 BUG10403
 
     C     NHCOLC        SETLL     SDCTTXL2
     C     NHCOLC        READE     SDCTTXL2
 
     C                   DOW       NOT %EOF(SDCTTXL2)
     C     KeyChk        CHAIN     SDNHTXL0
     C                   IF        NOT %FOUND(SDNHTXL0)
     C                   EXSR      SRWrite
     C                   ENDIF
     C     NHCOLC        READE     SDCTTXL2
     C                   ENDDO
 
      ** Blank out country of residence
 
     C                   EVAL      NHCOLC = *Blanks
     C     NHCOLC        SETLL     SDCTTXL2
     C     NHCOLC        READE     SDCTTXL2
 
     C                   DOW       NOT %EOF(SDCTTXL2)
     C     KeyChk        CHAIN     SDNHTXL0
     C                   IF        NOT %FOUND(SDNHTXL0)
     C                   EXSR      SRWrite
     C                   ENDIF
     C     NHCOLC        READE     SDCTTXL2
     C                   ENDDO
     C                   CLOSE     SDNHTXL0                                                 BUG10403
 
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      ****************************************************************
      *                                                              *
      * SRChkCust - Check if Customer is valid                       *
      *                                                              *
      ****************************************************************
     C     SRChkCust     BEGSR
 
     C                   CALL      'AONAHOR0'
     C                   PARM      *BLANKS       PRtcd
     C                   PARM      '*KEY   '     POptn
     C                   PARM      DDNAHO        PCustNo
     C*****SDNAHO        PARM      SDNAHO        DSSDY                                      BUG24029
     C     SDNAHO        PARM      SDNAHO        DSLDY                                      BUG24029
 
     C                   IF        PRtcd <> *Blanks
     C     *LOCK         IN        LDA
     C                   EVAL      DBKey = PCustNo
     C                   EVAL      DBFIle= 'SDNAHOPD'
     C                   EVAL      DBase = 3
     C                   OUT       LDA
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      ****************************************************************
      *                                                              *
      * SRWrite  - Write details                                     *
      *                                                              *
      ****************************************************************
     C     SRWrite       BEGSR
 
      ** Write record to SDACTXPD
 
     C                   EVAL      NXNAHO = DDNAHO
     C                   EVAL      NXCTTX = EWCTRT
     C                   EVAL      NXETXS = EWTXS1
     C                   EVAL      NXCERF = *BLANKS
     C                   EVAL      NXCEEX = *ZERO
     C                   EVAL      NXREPI = *BLANKS
     C                   EVAL      NXFRNT = *BLANKS
     C                   EVAL      NXREPA = *BLANKS
     C                   EVAL      NXNSTS = 'A'                                               236137
     C
      ** If CSC011 is installed, supply a Front Office ID for the
      ** transaction even if it originated from SIN module.
 
     C                   IF        CSC011 = 'Y'
     C                   IF        NXFRNT = *BLANKS
     C                   EVAL      NXFRNT = 'MD' + NXNAHO + NXCTTX
     C                   ENDIF
     C                   ENDIF
      *                                                                                       CER048
      ** If CER048 is installed,supply certificate type,approval date                         CER048
      ** and value date.                                                                      CER048
      *                                                                                       CER048
     C                   IF        CER048 = 'Y'                                               CER048
     C                   EVAL      NXCRTP = *BLANKS                                           CER048
     C                   EVAL      NXCADT = *ZEROS                                            CER048
     C                   EVAL      NXCVDT = *ZEROS                                            CER048
     C                   ENDIF                                                                CER048
 
     C                   CALLB     'ZAGENTMSTM'
     C                   PARM                    TimeStamp
 
     C                   MOVE      TimeStamp     NXTMST
 
     C                   WRITE     SDNHTXD0
 
     C                   ENDSR
      ****************************************************************
      /EJECT
      *****************************************************************
      * ZDATE1 - Format a date for input                              *
      *          This serves as checking if search date is valid      *
      *****************************************************************
     C     SRZDATE1      BEGSR
 
     C                   CALLB     'ZDATE1'
     C                   PARM                    WDate
     C                   PARM                    PZDayNo
     C                   PARM                    BJDFIN
     C                   PARM                    PZDatErr
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * ZDATE2 - Format a date for output                             *
      *****************************************************************
     C     SRZDATE2      BEGSR
 
     C                   CALLB     'ZDATE2'
     C                   PARM                    PZDayNo
     C                   PARM                    BJDFIN
     C                   PARM                    PZDate
     C                   PARM                    PZaDate
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * *INZSR - Initial Processing
      *****************************************************************
     C     *INZSR        BEGSR
 
     C     *Entry        PLIST
 
      * Input Parameters :
 
      ** Return Code
      ** Non-a/c Holder
      ** Build Subfile
      ** Read Subfile Record
      ** Update Subfile Record Display
      ** Repair Mode
      ** Protect Fields
      ** Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    RetCodeIn
     C                   PARM                    DDNAHO
     C                   PARM                    @BDSFL
     C                   PARM                    @RDSFL
     C                   PARM                    @UPSFL
     C                   PARM                    PRepair
     C                   PARM                    PProtect
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIdArr
     C                   PARM                    MsgDtaArr
 
      * Output Parameters :
 
      ** New Subfile Record Details
      ** Error Flags
      ** Readnext Subfile Record Flag
      ** Last Country of Tax displayed
      ** Command Keys
     C                   PARM                    NwSflFmt
     C                   PARM                    OkFlags
     C                   PARM                    @RdNxBr
     C                   PARM                    WLastCTTX
     C                   PARM                    @INKC
     C                   PARM                    @INKE
     C                   PARM                    @INKL
 
      ** Move workstation ID to screen field.
 
     C                   EVAL      DDWSID = PsJobName
     C                   EVAL      DDUSER = PsUser
 
     C                   EVAL      *IN94 = *ON
     C                   EVAL      WMsgSflEnd = *ON
     C                   MoveL     '*'           DDPGMQ
 
      ** Access Bank Details
 
     C                   CALL      'AOBANKR0'
     C                   PARM      '*DBERR '     PRtcd
     C                   PARM      '*FIRST '     POptn
     C     SDBANK        PARM      SDBANK        DSFDY
 
      ** Database Error
 
     C                   IF        PRtcd <> *Blanks
     C     *Lock         IN        LDA
     C                   EVAL      DBFILE = 'SDBANKPD'
     C                   EVAL      DBASE = 1
     C                   EVAL      DBKEY = POptn
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
 
      ** Check if CSC011 is installed
 
     C                   EVAL      CSC011 = 'N'
 
     C                   CALLB     'AOSARDR0'
     C                   PARM      *BLANKS       PRtCd
     C                   PARM      '*VERIFY'     POptn
     C                   PARM      'CSC011'      PSard
     C     SCSARD        PARM      SCSARD        DSFDY
 
      ** Database error
 
     C                   IF        (PRtCd <> *BLANKS) and
     C                             (PRtCd <> '*NRF   ')
     C     *Lock         IN        LDA
     C                   EVAL      DBKEY = 'CSC011'
     C                   EVAL      DBFILE = 'SCSARDPD'
     C                   EVAL      DBASE = 4
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   IF        PRtCd = *BLANKS
     C                   EVAL      CSC011 = 'Y'
     C                   ENDIF
 
     C     KNHTX         KLIST
     C                   KFLD                    DDNAHO
     C                   KFLD                    KyCTTX
 
     C     KeyChk        KLIST
     C                   KFLD                    DDNAHO
     C                   KFLD                    EWCTRT
      *                                                                                       CER048
      ** Check if CER048 is installed                                                         CER048
      *                                                                                       CER048
     C                   CALL      'AOSARDR0'                                                 CER048
     C                   PARM      *BLANKS       PRtCd                                        CER048
     C                   PARM      '*VERIFY'     POptn                                        CER048
     C                   PARM      'CER048'      PSard                                        CER048
     C     SCSARD        PARM      SCSARD        DSFDY                                        CER048
      *                                                                                       CER048
     C                   IF        PRtCd = *BLANKS                                            CER048
     C                   EVAL      CER048 = 'Y'                                               CER048
     C                   EVAL      *IN81 = *OFF                                               CER048
     C                   ELSE                                                                 CER048
     C                   EVAL      CER048 = 'N'                                               CER048
     C                   EVAL      *IN81 = *ON                                                CER048
     C                   ENDIF                                                                CER048
 
      **--------------------------------------------------------------------------------------------
      ** The following /COPY line sets up the fixed data for SD *DSP
      ** functions for the message handler, ZAMSGHNDLE.
     D/COPY SDCPYSRC,MSGHNDDATA
      **--------------------------------------------------------------------------------------------
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      ** The following /COPY line includes the ProcMsgs subroutine
      ** to process error and warning messages.
     D/COPY ZACPYSRC,MSGHNDDSP2
      **--------------------------------------------------------------------------------------------
 
      *****************************************************************
      ** Program, module and procedure names for database error processing.
      ** =================================================================
      ** The following /COPY sets these values, and also defines LDA as
      ** an external data area
      *****************************************************************
     C/COPY ZACPYSRC,PSSR_ILE
      *****************************************************************
**  CPY@
(c) Finastra International Limited 2004
