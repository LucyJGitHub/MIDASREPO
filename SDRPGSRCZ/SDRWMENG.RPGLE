     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2003')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas SD Compliance watch list message engine fdr')
      *****************************************************************
      *                                                               *
      *  Midas - Standing Data Module                                 *
      *                                                               *
      *  SDRWMENG - Compliance Watch List Message Engine Feeder       *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2003            *
      *                                                               *
      *  Last Amend No. CSD083             Date 27May10               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *  Prev Amend No. CSD031             Date 10Apr06               *
      *                 CSW037A            Date 02May05               *
      *                 BUG6198            Date 04Apr05               *
      *                 CSD025             Date 11Jan05               *
      *                 CSW037             Date 15Dec04               *
      *                 CSW036             Date 15Dec04               *
      *                 BUG3641            Date 07Jul04               *
      *                 CLE025             Date 20Oct03               *
      *                 CGL029             Date 01Sep03               *
      *                 222005             Date 08Oct03               *
      *                 221249             Date 10Sep03               *
      *                 CSD015  *CREATE    Date 14Oct02               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CSD083 - Watch List Compliance Upgrade                       *
      *  CSD031 - Enhanced Centralised Static Data (Recompile)        *
      *  CSW037A- Additional Field extended to 40 chars (recompile)   *
      *  BUG6198- Cannot save new Details for CUSD (Recompile)        *
      *  CSD025 - Customer De-Activation                              *
      *  CSW037 - Additional Field Data on MT300/MT320                *
      *  CSW036 - Dual SWIFT BIC held on Client Details               *
      *  BUG3641- Globalg MMM/Compliance Interface                    *
      *  CLE025 - Credit Lines (Recompile)                            *
      *  CGL029 - Increase Account Code to 10 digits                  *
      *  222005 - Expand Account details in Tag 25 for MT940/MT950    *
      *  221249 - Comp Watch jobs not ending                          *
      *  CSD015 - Midas Compliance Watch - Watch List Checking        *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  S U B R O U T I N E  I N D E X                               *
      *                                                               *
      *  SRProc    - Main Processing                                  *
      *  SRMFormat - Format the Details for Watch List Checking       *
      *  SRChkRtcd - Process details based on the Return Code         *
      *  SRCvtDate - Convert dates to be used for Watch Engine Pgm    *
      *  *INZSR    - Initialise                                       *
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
 
     FMGOMSGLA  IF   E           K DISK    INFSR(*PSSR)
      ** Midas MG outgoing single & header messages
 
     FSDCUSTL7  IF   E           K DISK    INFSR(*PSSR)
      ** Midas SD Customers by unique SWIFT ID
 
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ Automatically included D-specs       ¦
      ** ¦ ==============================       ¦
      ** +--------------------------------------+
      **
      ** Standard D-specs
      ** ================
      **
      ** The following /COPY line includes the LDA layout,
      ** the copyright array definition,
      ** and the following named constants:
      **    True       logical = *on (for indcator processing)
      **    False      logical = *off (for indcator processing)
      **    DBErrCtl   10A     = 'DBERRCTL' (the name of the database error
      **                                    handler)
      ** and the following variables:
      **    RunBefore  1A (for the PSSR)
 
     D/COPY ZACPYSRC,STD_D_SPEC
 
      **---------------------------------------------------------------
      ** The following /COPY includes the MM standard declares:
     D/COPY ZACPYSRC,STDDECLARE
      **---------------------------------------------------------------
 
      ** Program Status Data Structure
      ** =============================
      ** The following /COPY line includes all the defined fields in the
      ** PSDS.  They have meaningful names, prefixed by 'PS'.
 
     D/COPY ZACPYSRC,PSDS
 
      ** +--------------------------------------+
      ** ¦ End of automatically included D-specs¦
      ** ¦ =====================================¦
      ** +--------------------------------------+
 
      *****************************************************************
      /EJECT
      *****************************************************************
 
      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
 
      ** DS for Midas Watch List Message Details Queue
     D SDWLMEDS      E DS                  EXTNAME(SDWLMEPD)
 
      ** DS for Check transaction data file                                                   CSD083
     D PONwTranDtl   E DS                  EXTNAME(SDCWDFPD)                                  CSD083
                                                                                              CSD083
      ** DS Midas Watch List Details Queue
     D SDWLSTDS      E DS                  EXTNAME(SDWLSTPD)
 
      ** DS Midas Watch List Message Status Queue
     D SDWLMSDS      E DS                  EXTNAME(SDWLMSPD)
 
      ** DS for Midas SD Functions for Watch List Checking Details
     D SDWLCC        E DS                  EXTNAME(SDWLCCPD)
 
      ** DS for Midas SD Watch List Configuration Data File
     D SDCWCD        E DS                  EXTNAME(SDCWCDPD)
 
      ** DS for Midas SD Customer Details File
     D SDCUST        E DS                  EXTNAME(SDCUSTPD)
 
      ** DS for Midas Switchable features descriptions File
     D SCSARD        E DS                  EXTNAME(SCSARDPD)
 
      ** DS for Midas SD Data area
     D SDSTAT        E DS                  EXTNAME(SDSTAT) DTAARA(SDSTAT)
 
      ** DS for access programs, short data structure
     D DSFDY         E DS                  EXTNAME(DSFDY)
 
      ** DS for access programs, long data structure
     D DSSDY         E DS                  EXTNAME(DSSDY)
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
     D CCF001          S              1A
     D CSW025          S              1A
     D CSW034          S              1A                                                      JOJTIF
     D MReturnCode     S              7A
     D PAMDate         S               D
     D PDlcobj         S              1A
     D PDtqMsg         S            100A
     D PDtqLen         S              5  0
     D PDtqLib         S             10A
     D PDtqWait        S              5  0
     D PDtqNam         S             10A
     D PFuncCode       S              8A
     D PInDate         S              5A
     D PInput1         S             35                                                       222005
     D PInput2         S             35                                                       222005
     D PInput3         S             35                                                       222005
     D PInput4         S             35                                                       222005
     D PInput5         S             35                                                       222005
     D PInput6         S             35                                                       222005
     D PInCcy          S              3                                                       222005
     D PKey            S             10A
     D PLib            S             10A
     D PLockState      S              7A
     D PMember         S             10A
     D PMessage        S          31000A
     D PMFLD           S             50A
     D PMTYP           S              3A
     D PMTAG           S              5A
     D PNoOfMsg        S              9P 0
     D PObject         S             10A
     D PObjType        S              7A
     D POption         S              7A
     D POutDate        S             10A
     D POutput1        S            216                                                       222005
     D POutput2        S              6                                                       222005
     D PRetCde         S              7A
     D PReturn         S              7A
     D PSARD           S              6A
     D PStatus         S              1A
     D PString         S          30000A
     D PWaitTime       S              6A
     D WAccnt          DS                                                                     222005
     D  WBrch                         3                                                       222005
     D  WCust                         6                                                       222005
     D  WCurr                         3                                                       222005
     D***WACod**                       4                                               222005 CGL029
     D  WACod                        10                                                       222005
     D  WASeq                         2                                                       222005
     D WEnd            S              5  0
     D WETag           S              5  0
     D WIden           S             40A
     D WLastPos        S              1A
     D WMEnd           S              5  0
     D WMsgLen         S              5  0
     D WPos            S              5  0
     D WReturnCode     S              7A
     D WSav1Tag        S              7A
     D WSav2Tag        S              8A
     D WSrchString     S          30000A
     D WStr            S              5  0
     D WTag            S              5  0
     D WTEnd           S              5  0
     D WMTAG           S              5A
     D WrkAmt          S             18S 3
 
     D WRUN            S              1A
     D KTRNO           S             16A
     D @END            S              3A                                        221249
     D CSD083          S              1A                                                      CSD083
 
      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
      *****************************************************************
      /EJECT
      *****************************************************************
 
      *****************************************************************
      *  MAIN PROCEDURE                                               *
      *****************************************************************
 
      ** While Dataqueue data is not 'END'
 
     C*******************DOW       W7IDEN  <> 'END'                             221249
     C                   DOW       @END    <> 'END'                             221249
 
     C                   EVAL      PDtqLen = 31000
 
     C                   CALL      'QRCVDTAQ'
     C                   PARM      'SDCWMDTQ'    PDtqNam
     C                   PARM      '*LIBL'       PDtqLib
     C                   PARM                    PDtqLen
     C                   PARM                    PMessage
     C                   PARM                    PDtqWait
     C                   MOVEL     PMessage      SDWLMEDS
     C                   MOVEL     W7IDEN        @END                           221249
 
     C*******************IF        W7IDEN <> 'END'                              221249
     C                   IF        @END   <> 'END'                              221249
 
      ** Perform initialisations
 
     C                   EXSR      SRInit
 
      ** Perform message formatting
 
     C                   EXSR      SRMFormat
 
      ** Process details based on the Return Code
 
     C                   EXSR      SRChkRtcd
 
     C                   ENDIF
 
     C                   ENDDO
 
      ** End of program
 
     C                   EVAL      *INLR = *ON
     C                   RETURN
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRInit - Perform initialisations                             *
      *                                                               *
      *****************************************************************
     C     SRInit        BEGSR
 
      ** Initialise Working Valriables for Formatting Message Tags
 
     C                   MOVEL     W7IDEN        KTRNO
     C                   EVAL      PString = W7SSTR
 
     C                   EVAL      MReturnCode = *BLANKS
     C                   EVAL      WLastPos = 'N'
     C                   EVAL      WPos = 1
     C                   EVAL      WStr = 0
     C                   EVAL      WETag = 0
     C                   EVAL      WMEnd = 0
     C                   EVAL      WMsgLen = 0
     C                   EVAL      WTag = 0
     C                   EVAL      WTEnd = 0
     C                   EVAL      WMTAG = *BLANKS
     C                   EVAL      WSav1Tag = *BLANKS
     C                   EVAL      WSav2Tag = *BLANKS
     C                   EVAL      WSrchString = *BLANKS
     C                   EVAL      WEnd = 0
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRMFormat - Format the Details for Watch List Checking       *
      *                                                               *
      *****************************************************************
     C     SRMFormat     BEGSR
 
      ** If Return Code is not blanks
 
     C                   IF        WReturnCode <> *BLANKS
     C                   GOTO      MFMTEND
     C                   ENDIF
 
      ** Determine if Message Type needs to be checked by Compliance Watch
 
     C                   CALL      'AOWLMTR0'
     C                   PARM      *BLANKS       PRetCde
     C                   PARM      '*MTYP  '     POption
     C                   PARM      W7ITEM        PMTYP
     C                   PARM      *BLANKS       PMTAG
 
     C                   IF        PRetCde <> *BLANKS
     C                   EVAL      MReturnCode = '*NOCHK'
     C                   GOTO      MFMTEND
     C                   ENDIF
 
      ** If Midas Messenger not installed then format XML string
 
     C                   IF        CSW025 = 'N'
 
     C     KTRNO         SETLL     MGOMSGLA
     C     KTRNO         READE     MGOMSGLA
 
     C                   DOW       NOT %EOF(MGOMSGLA)
                                                                                              222005
      ** Extract Customer Name and Address from Account for TAG 25                            222005
                                                                                              222005
     C                   IF        MTAG = ':25:'                                              222005
                                                                                              222005
     C                   MOVEL     MFLD          WAccnt                                       222005
     C                   EVAL      PInput1 = WCust                                            222005
                                                                                              222005
     C                   CALL      'SDCWLFMT'                                                 222005
     C                   PARM      *BLANKS       PRetCde                                      222005
     C                   PARM                    PInput1                                      222005
     C                   PARM                    PInput2                                      222005
     C                   PARM                    PInput3                                      222005
     C                   PARM                    PInput4                                      222005
     C                   PARM                    PInput5                                      222005
     C                   PARM                    PInput6                                      222005
     C                   PARM                    PInCcy                                       222005
     C                   PARM                    POutput1                                     222005
     C                   PARM                    POutput2                                     222005
                                                                                              222005
     C                   EVAL      PMFLD = POutput1                                           222005
     C                   ELSE                                                                 222005
     C                   EVAL      PMFLD = MFLD
     C                   ENDIF
 
 
      ** Perform concatenation of the string by calling AOWLMCR0
 
     C                   CALL      'AOWLMCR0'
     C                   PARM      *BLANKS       PRetCde
     C                   PARM      *BLANKS       POption
     C                   PARM      MTAG          PMTAG
     C**********         PARM      MFLD          PMFLD                                        222005
     C                   PARM                    PMFLD                                        222005
     C                   PARM                    PString
 
     C     KTRNO         READE     MGOMSGLA
 
     C                   ENDDO
 
     C                   ENDIF
 
      ** Trim the Search String of tags not supposed to be checked by Compliance Watch
 
     C                   DOW       WLastPos = 'N'
     C     '<'           SCAN      PString:WPos  WStr                     21
     C                   IF        *IN21 = *ON
     C                   EVAL      WTag = WStr + 1
     C                   EVAL      WETag = WStr + 4
     C                   IF        %SUBST(PString:WETag:1) = ':'
     C                   EVAL      WMTAG = %SUBST(PString:WTag:4)
     C                   EVAL      WTEnd = WETag + 1
     C                   EVAL      WSav1Tag = '</' + %TRIM(WMTAG) + '>'
     C     WSav1Tag      SCAN      PString:WTEnd WEnd
     C                   ELSE
     C                   EVAL      WMTAG = %SUBST(PString:WTag:5)
     C                   EVAL      WTEnd = WETag + 2
     C                   EVAL      WSav2Tag = '</' + %TRIM(WMTAG) + '>'
     C     WSav2Tag      SCAN      PString:WTEnd WEnd
     C                   ENDIF
 
      ** Save the current Message Tag, Length and Position
 
 
     C     '>'           SCAN      PString:WEnd  WMEnd
     C                   EVAL      WMsgLen = WMEnd - WStr + 1
 
      ** Check if tag is included in the watch list by calling AOWLMTR0
 
     C                   CALL      'AOWLMTR0'
     C                   PARM      *BLANKS       PRetCde
     C                   PARM      '*MTAG  '     POption
     C                   PARM      *BLANKS       PMTYP
     C                   PARM      WMTAG         PMTAG
 
      ** If Message tag is in the checklist
 
     C                   IF        PRetCde = *BLANKS
     C                   EVAL      WSrchString =  %TRIM(WSrchString) +
     C                             %TRIM(%SUBST(PString:WStr:WMsgLen))
     C                   ENDIF
 
     C                   EVAL      WPos = WMEnd
     C                   EVAL      WMTAG = *BLANKS
     C                   EVAL      WSav1Tag = *BLANKS
     C                   EVAL      WSav2Tag = *BLANKS
     C                   EVAL      WMsgLen = *ZEROS
 
     C                   ENDIF
 
      ** End Loop if End of String or Scan search has no output
 
     C                   IF        WPos > 30000 or *IN21 = *OFF
     C                   EVAL      WLastPos = 'Y'
     C                   ENDIF
 
     C                   ENDDO
 
      ** Copy the valid Message Tags to the Search String
 
     C                   EVAL      PString = WSrchString
 
      ** Search String = Blanks
 
     C                   IF        PString = *Blanks
     C                   EVAL      MReturnCode = '*NOCHK'
     C                   ENDIF
 
     C     MFMTEND       ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRChkRtcd - Process details based on the Return Code         *
      *                                                               *
      *****************************************************************
     C     SRChkRtcd     BEGSR
 
     C                   IF        MReturnCode = *BLANKS
     C                             AND WReturnCode = *BLANKS
 
      ** Initialise data structure SDWLSTDS
 
     C                   CLEAR                   SDWLSTDS
     C                   EVAL      WrkAmt = 0
     C                   MOVE      WrkAmt        W5AMT1
     C                   MOVE      WrkAmt        W5AMT2
 
      ** Extract customer from Destination Customer
 
     C                   EVAL      PKey = *BLANKS
     C                   CALL      'AOCUSTR0'
     C                   PARM      *BLANKS       PRetCde
     C                   PARM      '*KEY    '    POption
     C                   PARM      W7CNUM        PKey
     C                   PARM      *BLANKS       PStatus
     C     SDCUST        PARM      SDCUST        DSSDY
 
      ** If Record Found
 
     C                   IF        PRetCde = *BLANKS
     C                   EVAL      W5CNUM = BBCUST
     C                   ELSE
 
      ** Check if it is a BIC customer when Midas Message
      ** Manager is installed
 
     C                   IF        CSW025 = 'Y'
     C     W7CNUM        CHAIN     SDCUSTL7
     C                   IF        %FOUND(SDCUSTL7)
     C                   EVAL      W5CNUM = BBCUST
     C                   ENDIF
     C                   ENDIF
 
     C                   ENDIF
 
      ** Determine Counterparty Type
 
     C                   IF        W5CNUM <> *BLANKS
 
      ** If Concord Interface Development is installed
 
     C                   IF        CCF001 = 'Y'
     C                   IF        BBCRPC = 'Y'
     C                   EVAL      W5CTYP = 'C'
     C                   ELSE
     C                   EVAL      W5CTYP = 'I'
     C                   ENDIF
     C                   ELSE
     C                   IF        BBLICD <> *BLANKS AND W1IND1 <> BBLICD
     C                             AND W1IND2 <> BBLICD AND W1IND3 <> BBLICD
     C                             AND W1IND4 <> BBLICD AND W1IND5 <> BBLICD
     C                   EVAL      W5CTYP = 'C'
     C                   ELSE
     C                   EVAL      W5CTYP = 'I'
     C                   ENDIF
     C                   ENDIF
 
     C                   EVAL      W5CUST = BBCRNM
 
     C                   ENDIF
 
      ** Setup other header details
 
     C                   EVAL      W5IDEN = W7IDEN
     C                   EVAL      W5ITEM = W7ITEM
     C                   EVAL      W5BRCH = W7BRCH
     C                   EVAL      W5SYSM = LIBR
     C                   EVAL      W5FUNT = 'MGOREF'
     C                   EVAL      W5DDAT = W7DDAT
 
     C                   MOVE      *ZEROS        PInDate
     C                   EXSR      SrCvtDate
     C                   MOVE      PAMDate       W5VDAT
     C                   MOVE      PAMDate       W5MDAT
 
     C                   EVAL      W5ARLS = W7ARLS
     C                   EVAL      W5SSTR = PString
 
      ** Write record to Checker Dataq
 
     C                   IF        CSD083 = 'Y'                                               CSD083
     C                   MOVE      SDWLSTDS      PONwTranDtl                                  CSD083
                                                                                              CSD083
     C                   CALL      'SD000902'                                                 CSD083
     C                   PARM      *BLANKS       PRetCde                                      CSD083
     C                   PARM                    PONwTranDtl                                  CSD083
                                                                                              CSD083
     C                   IF        PRetCde = '*ERROR'                                         CSD083
     C                   EXSR      *PSSR                                                      CSD083
     C                   ENDIF                                                                CSD083
                                                                                              CSD083
     C                   ELSE                                                                 CSD083
                                                                                              CSD083
     C                   MOVEL     SDWLSTDS      PMessage
     C                   EVAL      PDtqLen = 31000
 
     C                   CALL      'QSNDDTAQ'
     C                   PARM      'SDCWEDTQ'    PDtqNam
     C                   PARM      '*LIBL'       PDtqLib
     C                   PARM                    PDtqLen
     C                   PARM                    PMessage
 
     C                   ENDIF                                                                CSD083
 
     C                   ELSE
 
      ** Send details to Message Status Update
 
     C                   CLEAR                   SDWLMSDS
 
      ** Set up details for Watch List Message details Queue file
 
     C                   EVAL      W8RTCD = MReturnCode
     C                   IF        WReturnCode <> *BLANKS
     C                   EVAL      W8RTCD = WReturnCode
     C                   ENDIF
 
     C                   EVAL      W8IDEN = W7IDEN
     C                   EVAL      W8ITEM = W7ITEM
     C                   EVAL      W8BRCH = W7BRCH
     C                   EVAL      W8ARLS = W7ARLS
 
      ** Write record to Status Dataq
 
     C                   MOVEL     SDWLMSDS      PDtqMsg
     C                   If        CSW034 = 'N'                                              BUG3641
                                                                                             BUG3641
     C                   EVAL      PDtqLen = 100
 
     C                   CALL      'QSNDDTAQ'
     C                   PARM      'SDCWSDTQ'    PDtqNam
     C                   PARM      '*LIBL'       PDtqLib
     C                   PARM                    PDtqLen
     C                   PARM                    PDtqMsg
                                                                                             BUG3641
     C                   else                                                                BUG3641
                                                                                             BUG3641
      ** If Global Processing for MidasPlus write to Global keyed DataQ                      BUG3641
     C                   CALL      'SDFRMCMP'                                                BUG3641
     C                   PARM                    PDtqMsg                                     BUG3641
                                                                                             BUG3641
     C                   EndIf                                                               BUG3641
 
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT                                                          *
      *****************************************************************
      *                                                               *
      *  SrCvtDate - Convert dates to be used for Watch Engine Pgm    *
      *                                                               *
      *****************************************************************
     C     SrCvtDate     BEGSR
 
     C                   CALL      'ZACVTDATE'
     C                   PARM      *BLANKS       PRetCde
     C                   PARM                    PInDate
     C                   PARM                    PAMDate
     C                   PARM                    POutDate
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  *INZSR - Program Initialisation routine                      *
      *                                                               *
      *****************************************************************
     C     *INZSR        BEGSR
 
      ** Retrieve details of data area SDSTAT
 
     C                   IN        SDSTAT
 
      ** Check if CSW025 Midas Message Manager enhancement is installed
 
     C                   CALL      'AOSARDR0'
     C                   PARM      *BLANKS       PRetCde
     C                   PARM      '*VERIFY'     POption
     C                   PARM      'CSW025'      PSard
     C     SCSARD        PARM      SCSARD        DSFDY
 
     C                   IF        PretCde <> *BLANKS AND PRetCde <> '*NRF   '
     C     *LOCK         IN        LDA
     C                   EVAL      DBKEY = 'CSW025'
     C                   EVAL      DBFILE = 'SCSARDPD'
     C                   EVAL      DBASE = 1
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   IF        PRetCde = *BLANKS
     C                   EVAL      CSW025 = 'Y'
     C                   ELSE
     C                   EVAL      CSW025 = 'N'
     C                   ENDIF
 
      ** Check if CCF001 Concord Interface Development is installed
 
     C                   CALL      'AOSARDR0'
     C                   PARM      *BLANKS       PRetCde
     C                   PARM      '*VERIFY'     POption
     C                   PARM      'CCF001'      PSard
     C     SCSARD        PARM      SCSARD        DSFDY
 
     C                   IF        PretCde <> *BLANKS AND PRetCde <> '*NRF   '
     C     *LOCK         IN        LDA
     C                   EVAL      DBKEY = 'CCF001'
     C                   EVAL      DBFILE = 'SCSARDPD'
     C                   EVAL      DBASE = 2
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   IF        PRetCde = *BLANKS
     C                   EVAL      CCF001 = 'Y'
     C                   ELSE
     C                   EVAL      CCF001 = 'N'
     C                   ENDIF
                                                                                              BG3641
      ** Check for CSW034 Midas Message Manager Global Processing                             BG3641
                                                                                              BG3641
     C                   CALL      'AOSARDR0'                                                 BG3641
     C                   PARM      *BLANKS       PRetCde                                      BG3641
     C                   PARM      '*VERIFY'     POption                                      BG3641
     C                   PARM      'CSW034'      PSard                                        BG3641
     C     SCSARD        PARM      SCSARD        DSFDY                                        BG3641
                                                                                              BG3641
     C                   IF        PretCde <> *BLANKS AND PRetCde <> '*NRF   '                BG3641
     C     *LOCK         IN        LDA                                                        BG3641
     C                   EVAL      DBKEY = 'CSW034'                                           BG3641
     C                   EVAL      DBFILE = 'SCSARDPD'                                        BG3641
     C                   EVAL      DBASE = 3                                                  BG3641
     C                   OUT       LDA                                                        BG3641
     C                   EXSR      *PSSR                                                      BG3641
     C                   ENDIF                                                                BG3641
                                                                                              BG3641
     C                   IF        PRetCde = *BLANKS                                          BG3641
     C                   EVAL      CSW034 = 'Y'                                               BG3641
     C                   ELSE                                                                 BG3641
     C                   EVAL      CSW034 = 'N'                                               BG3641
     C                   ENDIF                                                                BG3641
 
      ** Check if function code 'MESSGENT' is being monitored
 
     C                   CALLB     'AOWLCCR0'
     C                   PARM      *BLANKS       PRetCde
     C                   PARM      '*KEY'        POption
     C                   PARM      'MESSGENT'    PFuncCode
     C     SDWLCC        PARM      SDWLCC        DSFDY
 
     C                   IF        PretCde <> *BLANKS AND PRetCde <> '*NRF   '
     C     *LOCK         IN        LDA
     C                   EVAL      DBKEY = PFuncCode
     C                   EVAL      DBFILE = 'SDWLCCPD'
     C                   EVAL      DBASE = 3
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
 
      ** Access Compliance Watch Configuration file
      ** to get the Private Customer Industry
 
     C                   CALL      'AOCWCDR0'
     C                   PARM      *BLANKS       PRetCde
     C                   PARM      '*FIRST'      POption
     C     SDCWCD        PARM      SDCWCD        DSSDY
 
     C                   IF        PretCde <> *BLANKS AND PRetCde <> '*NRF   '
     C     *LOCK         IN        LDA
     C                   EVAL      DBKEY = '*FIRST'
     C                   EVAL      DBFILE = 'SDCWCDPD'
     C                   EVAL      DBASE = 4
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
 
      ** If Enable Watch List Checking flag is not set to 'Y'
 
     C                   EVAL      WReturnCode = *BLANKS
     C                   IF        W1EWLC <> 'Y'
     C                   EVAL      WReturnCode = '*NOCHK'
     C                   ENDIF
 
      *                                                                                       CSD083
      ** Check if CSD083 is installed                                                         CSD083
      *                                                                                       CSD083
     C                   CALL      'AOSARDR0'                                                 CSD083
     C                   PARM      *BLANKS       PRetCde                                      CSD083
     C                   PARM      '*VERIFY'     POption                                      CSD083
     C                   PARM      'CSD083'      PSARD                                        CSD083
     C     SCSARD        PARM      SCSARD        DSFDY                                        CSD083
                                                                                              CSD083
     C                   IF        PRetCde <> *BLANKS AND PRetCde <> '*NRF   '                CSD083
     C     *LOCK         IN        LDA                                                        CSD083
     C                   EVAL      DBKEY = '*FIRST'                                           CSD083
     C                   EVAL      DBFILE = 'SCSARDPD'                                        CSD083
     C                   EVAL      DBASE = 5                                                  CSD083
     C                   OUT       LDA                                                        CSD083
     C                   EXSR      *PSSR                                                      CSD083
     C                   ENDIF                                                                CSD083
                                                                                              CSD083
     C                   IF        PRetCde = *BLANKS                                          CSD083
     C                   EVAL      CSD083 = 'Y'                                               CSD083
     C                   ELSE                                                                 CSD083
     C                   EVAL      CSD083 = 'N'                                               CSD083
     C                   ENDIF                                                                CSD083
                                                                                              CSD083
      ** Initialise Data queue parameters
 
     C                   EVAL      PDtqWait = -1
 
      *********************************************************************
      ** Program, module and procedure names for database error
      ** processing.
      ** ==============================================================
      ** The following /COPY sets these values, and also defines LDA as
      ** an external data area
     C/COPY ZACPYSRC,DBFIELDS
 
     C                   ENDSR
      *********************************************************************
      /EJECT
      *********************************************************************
      *                                                                   *
      *  *PSSR  - Program exception error routine                         *
      *           Called automatically if a program error occurs,         *
      *           or directly by the program code using EXSR.             *
      *           This subroutine DUMPs the program just once.            *
      *                                                                   *
      *********************************************************************
     C     *PSSR         BEGSR
 
     C                   DUMP
 
     C                   IF        WRUN = *BLANK
     C                   EVAL      WRUN = 'Y'
     C                   CALLB     'DBERRCTL'
     C                   ENDIF
 
     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   EVAL      *INLR = *ON
     C                   RETURN
 
     C                   ENDSR
      *****************************************************************
**  CPY@
(c) Misys International Banking Systems Ltd. 2003
