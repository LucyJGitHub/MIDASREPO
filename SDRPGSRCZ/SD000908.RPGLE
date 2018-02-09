     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2010')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas SD Compliance Watch List API Program')           *
      *****************************************************************
      *                                                               *
      *  Midas - Standing Data Module                                 *
      *                                                               *
      *  SD000908 - Midas SD Compliance Watch List API Program        *
      *                                                               *
      *  Function:  This program will perform Compliance Watch List   *
      *             checking                                          *
      *                                                               *
      *  (c) Finastra International Limited 2010                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      *  Prev Amend No. MD039470           Date 28Jun16               *
      *                 CGL165             Date 15Feb17               *
      *                 CDL096             Date 22Sep14               *
      *                 CDL094             Date 11Jun14               *
      *                 CLE148             Date 23Jul12               *
      *                 AR895153           Date 31Jan12               *
      *                 CSD083  *CREATE    Date 27May10               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  MD039470 - Serious Midas Error encountered on OPAY using     *
      *             invalid SWIFT ID.                                 *
      *  CGL165 - Dual Withholding Tax (Recompile)                    *
      *  CDL096 - Business Day Conventions on MM Deals                *
      *           (Recompile)                                         *
      *  CDL094 - Enhance  Receive Settlement Instructions            *
      *           (Recompiled)                                        *
      *  CLE148 - Alpha Loan Reference                                *
      *  AR895153 - STOPPED CHEQUE warning message is displaying      *
      *             only letter W                                     *
      *  CSD083 - Watch List Compliance Upgrade                       *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  Use of indicators.                                           *
      *                                                               *
      *    25         EOF Indicator                                   *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  S U B R O U T I N E  I N D E X                               *
      *                                                               *
      *  *PSSR - Error processing                                     *
      *  *INZSR - Initialise                                          *
      *  SrBuildXML - Build XML String                                *
      *  SrCheckWLC - Check SDCWHTPD file if there is a HIT/TRUEPOSIT *
      *               messages                                        *
      *  SrChkMonWLC - Check if function code is to be monitored      *
      *  SrConvertAmt - Converts an amount into a Floating Point Data *
      *  SrConvertDate - Convert dates to be used for Watch Engine    *
      *  SrDeleteWLC - Delete SDCWHTPD record if action is Cancel     *
      *  SrEdtMessage - Edit the Messages for output                  *
      *  SrFieldInit - Initialise FldLstArr                           *
      *  SrFormat - Extract Customer Name and Addresses               *
      *  SrGet1stParm - Get first parameter                           *
      *  SrGetSQ - Get Sequence number                                *
      *  SrPopulate - Populate SDCWFCPD file with information passed  *
      *               from Java UI                                    *
      *  SrSendWLC - Send XML Data to FIRCOSOFT for processing        *
      *  SrW4CNUM - Get Customer Number                               *
      *  SrW4CTRN - Get Counterparty Type and Counterparty Name       *
      *  SrGetTransID - Get the transaction's identifier              *
      *  SrRejectWLC - Perform reject action on WLC record            *
      *                                                               *
      *****************************************************************
 
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
 
      ** Midas SD Compliance Watch List Field Config File
     FSDCWFCL0  IF   E           K DISK    INFSR(*PSSR)
 
      ** Midas SD Compliance Watch List Module Definition
     FSDCWMOL0  IF   E           K DISK    INFSR(*PSSR)
     F                                     RENAME(SDCWMOD0:SDCWMOD1)
 
      ** Compliance Watch Hit List by Function Type/Identifier/Branch
     FSDCWHTL0  UF A E           K DISK    INFSR(*PSSR)
     F                                     PREFIX(UP_)
 
      ** Compliance Watch Hit List by Function Type/Identifier/Branch
     FSDCWHTL1  IF   E           K DISK    INFSR(*PSSR)
     F                                     RENAME(SDCWHTD0:SDCWHTD1)
 
      ** Midas SD Check Transaction Data File
     FSDCWDFL1  UF   E           K DISK    INFSR(*PSSR)
 
      ** Midas LE Loans details file
     FCLOAN     IF   E           K DISK    INFSR(*PSSR)
     F                                     INCLUDE(CLOANCLF:CLOANCKF)
      ** Midas MM Deals file
     FMMDEALLL  IF   E           K DISK    INFSR(*PSSR)
     F                                     INCLUDE(MMDELDP0: MMDENBP0)
 
      ** Midas SE Securities file
     FSECTY     IF   E           K DISK    INFSR(*PSSR)
 
      *****************************************************************
      /EJECT
      *****************************************************************
 
      ** +--------------------------------------+
      ** ¦ Automatically included D-specs       ¦
      ** ¦ ==============================       ¦
      ** +--------------------------------------+
 
      **---------------------------------------------------------------
      ** The following /COPY line includes (among others) the LDA layout
      ** and the copyright array definition:
     D/COPY ZACPYSRC,STD_D_SPEC
      **---------------------------------------------------------------
 
      **---------------------------------------------------------------
      ** The following /COPY line includes all the defined fields in the
      ** Program Status Data Structures.  They have meaningful
      ** names, prefixed by 'PS'.
     D/COPY ZACPYSRC,PSDS
      **---------------------------------------------------------------
 
      **---------------------------------------------------------------
      ** The following /COPY line includes all the definitions of the
      ** error arrays, including the named constant giving the size of
      ** the arrays.
     D/COPY ZACPYSRC,FVAL_ARRAY
      **---------------------------------------------------------------
 
      ** +--------------------------------------+
      ** ¦ End of automatically included D-specs¦
      ** ¦ =====================================¦
      ** +--------------------------------------+
 
      ** +--------------------------------------+
      ** ¦ Named constants                      ¦
      ** ¦ ===============                      ¦
      ** +--------------------------------------+
 
      ** Maximum number of Watch List Fields an API will send to WLC
     D FieldMax        C                   CONST(75)
 
      ** The maximum size of the error arrays
     D ArrayMax        C                   CONST(75)
 
      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
 
      ** Data Structure for Accessing SDCUSTPD
     D SDCUST        E DS                  EXTNAME(SDCUSTPD)
 
      ** Data Structure for Watch List Checking Details
     D SDWLCC        E DS                  EXTNAME(SDWLCCPD)
 
      ** First DS for Access programs - short data structure
     D DSFDY         E DS                  EXTNAME(DSFDY)
 
      ** DS for access programs - Second data structure
     D DSSDY         E DS                  EXTNAME(DSSDY)
 
      ** External DS for SAR Details
     D SCSARD        E DS                  EXTNAME(SCSARDPD)
 
      ** External DS for SDBANKPD Details
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
 
      ** External DS for SDCURRPD Details
     D SDCURR        E DS                  EXTNAME(SDCURRPD)
 
      ** 24X7 Data Structure
     D SC24X7        E DS                  EXTNAME(SC24X7)
 
      ** SDSTAT Data Structure
     D SDSTAT        E DS                  EXTNAME(SDSTAT)
 
      ** Watch List Transaction details file
     D SDWLTD        E DS                  EXTNAME(SDWLTDPD)
 
      ** External DS for Compliance Watch Configuration Data File
     D SDCWCD        E DS                  EXTNAME(SDCWCDPD)
 
      ** External DS for Compliance Watch List Transaction Header File
     D SDHEADER      E DS                  EXTNAME(SDHEADPD)
 
      **  Data structure to update last transaction number DTARA.
     D DNATN           DS            10
     D  FNATN                  1     10  0
 
      ** Data structure for Ordering Bank
     D                 DS
     D  OrderingBank           1     18
     D     ORBKNostro          1      2
     D     ORBKRetail          1     10
 
      ** Array of Fields in error
     D FldNameArr      S             10A   DIM(ArrayMax)
 
      ** Array of error message IDs
     D MsgIDArr        S                   DIM(ArrayMax)
     D                                     LIKE(#MsgID)
 
      ** Array of error message data
     D MsgDtaArr       S                   DIM(ArrayMax)
     D                                     LIKE(#MsgData)
 
      ** Array of Fields with warnings
     D WFldNamArr      S             10A   DIM(ArrayMax)
 
      ** Array of warning message IDs
     D WMsgIDArr       S                   DIM(ArrayMax)
     D                                     LIKE(#MsgID)
 
      ** Array of warning message data
     D WMsgDtaArr      S                   DIM(ArrayMax)
     D                                     LIKE(#MsgData)
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
      ** *ENTRY Parameters
     D P_W4IDEN        S             40A
     D P_APICODE       S              4A
     D P_ACTION        S              1A
     D P_MESSG         S           9999A   VARYING
     D P_RETU          S              1A
     D P_HEADER        S            200A
     D P_BUFFER        S          10000A
 
      ** ZACVTAMT Parameters
     D PZARTCD         S             10A
     D PZACCY          S              3A
     D PZAAMT          S             15A
     D PZOUTAMT        S             18  3
     D PZCVTAMT        S             16A
 
      ** ZALIGN Parameters
     D ZALIGNOK        S              1A
     D ZFIELD          S             16A
     D ZADEC           S              1  0
     D ZADIG           S              2  0
     D ZCCY            S              3A
     D ZFLD            S             15A
 
      ** ZACVTDATE Parameters
     D PZADAYNO        S              5
     D PZADDT          S               D
     D PZACVTDT        S             10
     D PDAYNO          S              5  0
 
      ** AOSARDR0 Parameters
     D POPTN           S              7A
     D PRTCD           S              7A
     D PSARD           S              6A
     D PKEYST          S              7A
     D PFNCOD          S              8A
     D CSD083          S              1A
     D CSD015          S              1A
     D CSC011          S              1A
     D CCF001          S              1A
 
      ** SDCWLFMT Parameters
     D PDAT            S            216A
     D PCCY            S              3A
     D PCUS            S              6A
     D PKEY1           S             10A
 
      ** Work Variables
     D TRANS_ID        S             40A
     D ErrorExist      S              1A
     D WOTOPMSGR       S              8S 0
     D WORBT           S              1A
     D WORBK           S             18A
     D WRecCor         S              6A
     D WDateStr        S              6A
     D FunctionCode    S              8A
     D Ix              S              3S 0 INZ(*ZEROS)
     D Iy              S              3S 0 INZ(*ZEROS)
     D Iz              S              3S 0 INZ(*ZEROS)
     D Jx              S              3S 0 INZ(*ZEROS)
     D Tx              S              3S 0 INZ(*ZEROS)
     D Ty              S              3S 0 INZ(*ZEROS)
     D LastSQ          S             10  0
     D T_MESSG         S           9999A
 
     D BeginXML        S            100A   DIM(FieldMax)
     D EndXML          S            100A   DIM(FieldMax)
 
     D FldLstArr       S             70A   DIM(9)
     D FldLstTrd       S             35A   DIM(9)
     D FldFmtArr       S             10A   DIM(FieldMax)
 
     D FldKeyArr       S             10A   DIM(FieldMax)
     D FldValArr       S             70A   DIM(FieldMax)
     D FldGrpArr       S              2S 0 DIM(FieldMax)
 
      ** Compliance Engine Free Format String Parameter
     D PFreeFmtStr     S          30000A   INZ(*BLANKS)
     D WXMLPacket      S            310A   INZ(*BLANKS)
     D FieldStr        S           3000A   INZ(*BLANKS)
 
     D WDType          S              2A
     D WPType          S              2A
     D WMMType         S              2A
     D WDpmv           S              2A
     D WLType          S              2A
     D WDEAL           S              6S 0
 
     D  @RUN           S              1A   INZ(*BLANKS)
 
     D GenRefOK        S              1N
 
      ** FldKeyArr Variables
     D W6ACOD          S             10A
     D W6ACSQ          S              2A
     D W6ADDR          S              1A
     D W6BRCA          S              3A
     D W6CCYD          S              3A
     D W6DS38          S              3A
     D W6FACT          S              3A
     D W6FCNO          S              2A
     D W6FSEQ          S              2A
     D W6LASN          S              3A
     D W6PREF          S             15A
     D W6SECT          S             10A
     D W6TREF          S              6A
     D W6VDAT          S              6A
     D W6AMSQ          S              3A
 
     D W4IDENX         S             40A
     D*WLNRF****       S              6  0                                                  CLE148
     D WLNRF           S              6A                                                    CLE148
     D WRCDT           S              1A
     D REFERENCE       S             40A
     D APIName         S             20    INZ(*BLANKS)                                     AR895153
 
      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
 
      ** +--- Start of Main processing -----------------------------------+
      ** ¦                                                                ¦
      ** ¦ Initial processing is performed automatically: the *INZSR is   ¦
      ** ¦ executed at program activation.                                ¦
      ** ¦                                                                ¦
      ** +----------------------------------------------------------------+
 
     C                   EVAL      ErrorExist = 'N'
 
      ** Based on the API Code, check if it is flagged for WLC Check
 
     C                   EXSR      SrChkMonWLC
 
     C                   IF        (W1EWLC = 'Y') AND
     C                             (CSC011 = 'N' OR
     C                             (CSC011 = 'Y' AND
     C                             LIBR = S1MAIN))
 
     C                   SELECT
 
      ** Action is 'S' - Send
 
     C                   WHEN      P_ACTION = 'S'
     C                   EXSR      SrSendWLC
 
      ** Action is 'C' - Check
 
     C                   WHEN      P_ACTION = 'C'
     C                   EXSR      SrCheckWLC
 
      ** Action is 'D' - Delete
 
     C                   WHEN      P_ACTION = 'D'
     C                   EXSR      SrRejectWLC
 
     C                   ENDSL
 
     C                   ENDIF
 
     C                   EXSR      SrEdtMessage
 
     C                   EVAL      *INLR = *ON
     C                   RETURN
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SrSendWLC - Send XML Data to FIRCOSOFT for processing         *
      *                                                               *
      * Called by: Main processing                                    *
      *                                                               *
      * Calls: SrPopulate, SrGet1stParm, SrBuildXML, SrGetTransID,    *
      *        SDCWLCHK                                               *
      *                                                               *
      *****************************************************************
     C     SrSendWLC     BEGSR
 
     C                   EVAL      GenRefOk = '1'
     C                   IF        P_APICODE = 'ACMN' OR
     C                             P_APICODE = 'AMAD' OR
     C                             P_APICODE = 'ALNA'
     C                   EVAL      GenRefOk = '0'
     C                   ENDIF
 
     C                   EXSR      SrPopulate
     C                   EXSR      SrGetTransID
     C                   EXSR      SrGet1stParm
 
      ** Delete occurence of record with temporary transaction id then write a new
      ** record with correct reference
 
     C                   IF        (P_W4IDEN <> *BLANKS) AND
     C                             (TRANS_ID <> *BLANKS)
     C                   EVAL      W4IDENX = P_W4IDEN
     C                   EXSR      SrDeleteWLC
     C                   EVAL      W4IDEN = TRANS_ID
     C                   ENDIF
 
     C                   EXSR      SrBuildXML
 
     C                   IF        PFreeFmtStr <> *BLANKS
 
     C                   IF        (P_W4IDEN = *BLANKS AND GenRefOK)
     C                             AND (TRANS_ID = *BLANKS)
     C                   EXSR      SrGetSQ
     C                   MOVEL     LastSQ        P_W4IDEN
     C                   EVAL      W4IDEN = P_W4IDEN
     C                   ENDIF
 
     C                   ENDIF
 
     C                   CALL      'SDCWLCHK'
     C                   PARM                    SDWLTD
     C                   PARM                    PFreeFmtStr
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SrCheckWLC - Check SDCWHTPD file if there is a HIT/TRUEPOSITV *
      *              messages                                         *
      *                                                               *
      * Called by: Main processing                                    *
      *                                                               *
      * Calls: SrPopulate, SrGetTransID, SrGet1stParm                 *
      *                                                               *
      *****************************************************************
     C     SrCheckWLC    BEGSR
 
     C                   EXSR      SrPopulate
     C                   EXSR      SrGetTransID
     C                   EXSR      SrGet1stParm
 
      ** Using temporary reference number, check if it exist in SDCWHTPD. If one
      ** is found, throw an error "Item Under Review by a Compliance Officer"
 
     C                   IF        P_W4IDEN <> *BLANKS
     C                   EVAL      W4IDENX = P_W4IDEN
     C     KeyWLC        CHAIN     SDCWHTL1
     C                   IF        %FOUND(SDCWHTL1) AND
     C                             (W3TREL <> 'Y')
     C                   EVAL      Iz = Iz + 1
     C                   MOVEL     '*ANY'        FldNameArr(Iz)
     C                   EVAL      MsgIdArr(Iz) = 'USR9270'
     C                   EVAL      ErrorExist = 'Y'
     C                   ENDIF
     C                   ENDIF
 
      ** Using transaction reference number, check if it exist in SDCWHTPD. If one
      ** is found, throw an error "Item Under Review by a Compliance Officer"
 
     C                   IF        ErrorExist = 'N'
     C                   EVAL      W4IDENX = TRANS_ID
     C     KeyWLC        CHAIN     SDCWHTL1
     C                   IF        %FOUND(SDCWHTL1) AND
     C                             (W3TREL <> 'Y')
     C                   EVAL      Iz = Iz + 1
     C                   MOVEL     '*ANY'        FldNameArr(Iz)
     C                   EVAL      MsgIdArr(Iz) = 'USR9270'
     C                   EVAL      ErrorExist = 'Y'
     C                   ENDIF
     C                   ENDIF
 
      ** No errors found, check if temporary file exist in SDCWHTPD. If one
      ** is found, then update record with the correct reference number
 
     C                   IF        (P_W4IDEN <> *BLANKS) AND
     C                             (TRANS_ID <> *BLANKS) AND
     C                             (ErrorExist = 'N')
 
      ** Recreate record in Compliance Watch Hit List File
 
     C                   EVAL      W4IDENX = P_W4IDEN
 
     C     KeyWLC        CHAIN     SDCWHTL0
     C                   IF        %FOUND(SDCWHTL0)
     C                   EVAL      UP_W3IDEN = TRANS_ID
     C                   UPDATE    SDCWHTD0
     C                   ENDIF
 
      ** No errors found, check if temporary file exist in SDCWDFPD. If one
      ** is found, then update record with the correct reference number
 
     C                   EVAL      W4IDENX = P_W4IDEN
 
     C     KeyWLC        CHAIN     SDCWDFL1
 
     C                   IF        %FOUND(SDCWDFL1)
     C                   EVAL      WIIDEN = TRANS_ID
     C                   UPDATE    SDCWDFD0
     C                   ENDIF
 
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SrRejectWLC - Perform reject action for WLC record            *
      *                                                               *
      * Called by: Main processing                                    *
      *                                                               *
      * Calls: SrPopulate, SrGet1stParm, SrGetTransID, SrDeleteWLC    *
      *                                                               *
      *                                                               *
      *****************************************************************
     C     SrRejectWLC   BEGSR
 
     C                   EXSR      SrPopulate
     C                   EXSR      SrGetTransID
     C                   EXSR      SrGet1stParm
 
     C                   IF        P_W4IDEN <> *BLANKS
     C                   EVAL      W4IDENX = P_W4IDEN
     C                   EXSR      SrDeleteWLC
     C                   ENDIF
 
     C                   IF        TRANS_ID <> *BLANKS
     C                   EVAL      W4IDENX = TRANS_ID
     C                   EXSR      SrDeleteWLC
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SrFieldInit - Initialise FldLstArr                            *
      *                                                               *
      * Called by:  SrBuildXML, SrW4CNUM                              *
      *                                                               *
      * Calls: *None                                                  *
      *                                                               *
      *****************************************************************
     C     SrFieldInit   BEGSR
 
     C                   FOR       Ty = 1 to 9
     C                   EVAL      FldLstArr(Ty) = *BLANKS
     C                   ENDFOR
 
     C                   EVAL      Ty = 0
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SrBuildXML - Build XML String                                 *
      *                                                               *
      * Called by: SrSendWLC                                          *
      *                                                               *
      * Calls: SrFormat                                               *
      *                                                               *
      *****************************************************************
     C     SrBuildXML    BEGSR
 
     C                   EVAL      WXMLPacket  = *BLANKS
     C                   EVAL      PFreeFmtStr = *BLANKS
     C                   EVAL      FldLstArr   = *BLANKS
 
     C                   EVAL      Ix = 1
     C                   EVAL      Iy = 1
 
      ** Build XML for all fields
 
     C                   DOW       FldKeyArr(Iy) <> *BLANKS
 
      ** Setup SDCWLFMT parameter
 
     C                   EVAL      FldLstArr(Ix) = FldValArr(Iy)
     C                   EVAL      Ix = Ix + 1
 
      ** Check next field, Build XML if not same group
 
     C                   IF        FldGrpArr(Iy) <> FldGrpArr(Iy+1)
 
     C                   IF        FldFmtArr(Iy)  = '*EXTRACT'
 
      ** For Trades Input API
 
     C                   IF        P_APICODE = 'TRAD'
 
     C                   EVAL      FieldStr = *BLANKS
     C                   EVAL      FldLstTrd = *BLANKS
     C                   EVAL      FldLstTrd = FldLstArr
     C                   EVAL      FldLstArr = *BLANKS
 
     C                   FOR       Tx = 1 to 9
 
     C                   IF        FldLstTrd(Tx) <> *BLANKS
     C                   EVAL      FldLstArr(1) = FldLstTrd(Tx)
     C                   EXSR      SrFormat
 
     C                   IF        PDAT  <> *BLANKS
     C                   EVAL      FieldStr = %TRIM(FieldStr) +
     C                             ' ' + %TRIM(PDAT)
     C                   ENDIF
     C                   ENDIF
 
     C                   ENDFOR
 
     C                   IF        FieldStr <> *BLANKS
     C                   EVAL      WXMLPacket = %TRIM(BeginXML(Iy)) +
     C                             %TRIM(FieldStr) +
     C                             %TRIM(EndXML(Iy))
     C                   ENDIF
 
     C                   ELSE
 
     C                   EXSR      SrFormat
 
     C                   IF        PDAT  <> *BLANKS
     C                   EVAL      WXMLPacket = %TRIM(WXmlPacket) +
     C                             %TRIM(BeginXML(Iy))
     C                   EVAL      WXMLPacket = %TRIM(WXmlPacket) +
     C                             %TRIM(PDAT)
 
      ** Additional Fields
 
     C                   IF        (FldKeyArr(Iy) = 'W6RIBA'
     C                             OR FldKeyArr(Iy) = 'W6PIBA')
     C                             AND FldValArr(Iy) <> *BLANKS
     C                   EVAL      WXMLPacket = %TRIM(WXMLPacket) +
     C                             %TRIM(FldValArr(Iy))
     C                   ENDIF
     C
     C                   EVAL      WXMLPacket = %TRIM(WXmlPacket) +
     C                             %TRIM(EndXML(Iy))
     C                   ENDIF
 
     C                   ENDIF
 
     C                   ELSE
 
     C                   EVAL      FieldStr = *BLANKS
     C                   FOR       Jx = 1 to 6
     C                   IF        FldLstArr(Jx) <> *BLANKS
     C                   EVAL      FieldStr = %TRIM(FieldStr) + ' ' +
     C                             %TRIM(FldLstArr(Jx)) + ' '
     C                   ENDIF
     C                   ENDFOR
 
     C                   IF        FieldStr <> *BLANKS
     C                             AND BeginXML(Iy) <> *BLANKS
     C                             AND EndXML(Iy) <> *BLANKS
     C                   EVAL      WXMLPacket = %TRIM(BeginXML(Iy)) +
     C                             %TRIM(FieldStr) +
     C                             %TRIM(EndXML(Iy))
     C                   ENDIF
     C                   ENDIF
 
      ** Reset SDCWLFMT parameter
 
     C                   EVAL      FldLstArr = *BLANKS
     C                   EVAL      Ix = 1
     C                   ENDIF
 
     C                   IF        WXMLPacket <> *BLANKS
     C                   EVAL      PFreeFmtStr = %TRIM(PFreeFmtStr) +
     C                                           %TRIM(WXMLPacket)
     C                   EVAL      WXMLPacket  = *BLANKS
     C                   ENDIF
 
     C                   EVAL      Iy = Iy + 1
     C                   ENDDO
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SrGet1stParm - Get first parameter                            *
      *                                                               *
      * Called by: SrSendWLC, SrCheckWLC, SrDeleteWLC                 *
      *                                                               *
      * Calls: SrW4CNUM, SrW4CTRN, SrConvertDate, SrConvertAmt        *
      *                                                               *
      *****************************************************************
     C     SrGet1stParm  BEGSR
 
     C                   IF        TRANS_ID <> *BLANKS
     C                   EVAL      W4IDEN = TRANS_ID
     C                   ENDIF
 
     C                   IF        P_W4IDEN <> *BLANKS
     C                   EVAL      W4IDEN = P_W4IDEN
     C                   ENDIF
 
      ** Determine W4FUNT (Function Type) and W4ITEM (Item Type Code)
 
     C                   EVAL      W4FUNT = WMFUNT
 
     C                   SELECT
 
     C                   WHEN      P_APICODE = 'CACF'
     C                   EVAL      Iy = %LOOKUP('W6DTYP':FldKeyArr)
     C                   EVAL      WDType  = FldValArr(Iy)
     C                   EVAL      W4ITEM = 'IR' + WDType
 
     C                   WHEN      P_APICODE = 'CLIP'
     C                   EVAL      Iy = %LOOKUP('W6PTYP':FldKeyArr)
     C                   EVAL      WPType  = FldValArr(Iy)
     C                   EVAL      W4ITEM = 'LE' + WPType
 
     C                   WHEN      P_APICODE = 'DEAM'
     C                   EVAL      Iy = %LOOKUP('W6MTYP':FldKeyArr)
     C                   EVAL      WMMType  = FldValArr(Iy)
     C                   EVAL      W4ITEM = 'MM' + WMMType
 
     C                   WHEN      P_APICODE = 'DPMV'  OR
     C                             P_APICODE = 'DPWI'  OR
     C                             P_APICODE = 'DPWO'
 
     C                   IF        P_APICODE = 'DPMV'
     C                   EVAL      Iy = %LOOKUP('W6DPMV':FldKeyArr)
     C                   EVAL      WDpmv   = FldValArr(Iy)
     C                   ENDIF
 
     C                   IF        WDpmv   = 'WI' OR
     C                             P_APICODE = 'DPWI'
     C                   EVAL      W4ITEM  = 'SEWKIN'
     C                   ELSEIF    WDpmv   = 'WO' OR
     C                             P_APICODE = 'DPWO'
     C                   EVAL      W4ITEM  = 'SEWKOT'
     C                   ELSE
     C                   EVAL      W4ITEM  = 'SEDPMV'
     C                   ENDIF
 
     C                   EVAL      Iy = %LOOKUP('W6SECT':FldKeyArr)
     C                   MOVEL     FldValArr(Iy) W6SECT
     C     W6SECT        CHAIN     SECTYDF
 
     C                   IF        %FOUND
     C                   EVAL      HDDEN1   = NMCY
     C                   ENDIF
 
     C                   WHEN      P_APICODE = 'NASP' OR
     C                             P_APICODE = 'NASS'
     C                   EVAL      Iy = %LOOKUP('W6LTYPE':FldKeyArr)
     C                   EVAL      WLType  = FldValArr(Iy)
     C                   EVAL      W4ITEM = 'MM' + WLType
 
     C                   OTHER
     C                   EVAL      W4ITEM = WMITEM
     C                   ENDSL
 
      ** Determine W4BRCH (Branch Code)
 
     C                   SELECT
     C                   WHEN      P_APICODE = 'MAPY' OR
     C                             P_APICODE = 'RPSC'
     C                   MOVEL     FldValArr(1)  WLNRF
     C                   EVAL      WRCDT = 'A'
     C     WKLOAN        CHAIN     CLOAN
 
     C                   IF        %FOUND
     C                   EVAL      W4BRCH = BRCA
     C                   ENDIF
 
     C                   WHEN      P_APICODE = 'DEAM'
     C                   MOVEL     FldValArr(1)  WDEAL
     C     WDEAL         CHAIN     MMDEALLL
 
     C                   IF        %FOUND
     C                   EVAL      W4BRCH = HKBRCA
     C                   ENDIF
 
     C                   WHEN      P_APICODE = 'ALNA'
 
     C                   EVAL      Iy = %LOOKUP('W6CUSL':FldKeyArr)
     C                   MOVEL     FldValArr(Iy) W6TREF
 
     C                   CALL      'AOCUSTR0'
     C                   PARM      *BLANKS       PRTCD
     C                   PARM      '*KEY   '     POPTN
     C                   PARM      W6TREF        PKEY1
     C                   PARM      *BLANKS       PKEYST
     C     SDCUST        PARM      SDCUST        DSSDY
 
     C                   EVAL      W4BRCH = BBBRCD
 
     C                   OTHER
     C                   EVAL      W4BRCH = HDBRCH
     C                   ENDSL
 
      ** Determine W4SYSM (System)
 
     C                   IF        CSC011 = 'Y'
     C                   EVAL      W4SYSM = S1MAIN
     C                   ELSE
     C                   EVAL      W4SYSM = LIBR
     C                   ENDIF
 
      ** Determine W4CNUM (Counterparty Number)
 
     C                   IF        (P_APICODE = 'IPAY') or
     C                             (P_APICODE = 'OPAY')
     C                   EXSR      SrW4CNUM
     C                   ELSE
     C                   EVAL      W4CNUM = HDCNUM
     C                   ENDIF
 
      ** Determine W4CTYP (Counterparty Type) and W4CUST (Counterparty Name)
 
     C                   EXSR      SrW4CTRN
 
      ** Determine W4DDAT (Deal Date)
 
     C                   EVAL      WDateStr = HDDLDT
     C                   EXSR      SrConvertDate
     C                   EVAL      W4DDAT = PZADDT
 
      ** Determine W4VDAT (Value Date)
 
     C                   EVAL      WDateStr = HDVADT
     C                   EXSR      SrConvertDate
     C                   EVAL      W4VDAT = PZADDT
 
      ** Determine W4MDAT (Maturity Date)
 
     C                   EVAL      WDateStr = HDMADT
     C                   EXSR      SrConvertDate
     C                   EVAL      W4MDAT = PZADDT
 
      ** Determine W4DEN1 (Denomination 1)
      ** Determine W4DEN2 (Denomination 2)
 
     C                   IF        P_APICODE = 'LERI'
     C                   MOVEL     FldValArr(1)  WLNRF
     C                   EVAL      WRCDT = 'B'
 
      ** Check if New Currency is available
 
     C     WKLOAN        CHAIN     CLOANCKF
 
      ** Otherwise, use the Original Loan Currency
 
     C                   EVAL      WRCDT = 'A'
     C     WKLOAN        CHAIN     CLOANCLF
 
     C                   IF        NCCY <> *BLANKS
     C                   EVAL      HDDEN1 = NCCY
     C                   MOVE      NCPA          HDAMT1
 
     C                   ELSE
     C                   EVAL      HDDEN1 = CCY
 
     C                   IF        PTYP = 63 OR
     C                             PTYP = 65 OR
     C                             PTYP = 67
     C                   MOVE      NPRAM         HDAMT1
     C                   ENDIF
 
     C                   ENDIF
     C                   ENDIF
 
     C                   EVAL      W4DEN1   = HDDEN1
     C                   EVAL      W4DEN2   = HDDEN2
 
      ** Determine W4AMT1 (Amount 1)
 
     C                   EVAL      W4AMT1 = *ZEROS
     C                   EVAL      ZFIELD   = HDAMT1
     C                   EVAL      ZCCY     = HDDEN1
     C                   EXSR      SrConvertAmt
     C                   EVAL      W4AMT1 = PZOUTAMT
 
      ** Determine W4AMT2 (Amount 2)
 
     C                   EVAL      W4AMT2 = *ZEROS
     C                   EVAL      ZFIELD   = HDAMT2
     C                   EVAL      ZCCY     = HDDEN2
     C                   EXSR      SrConvertAmt
     C                   EVAL      W4AMT2 = PZOUTAMT
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SrW4CTRN - Get Counterparty Type and Counterparty Name        *
      *                                                               *
      * Called by: SrGet1stParm                                       *
      *                                                               *
      * Calls: AOCUSTR0                                               *
      *                                                               *
      *****************************************************************
     C     SrW4CTRN      BEGSR
 
     C                   CALL      'AOCUSTR0'
     C                   PARM      *BLANKS       PRTCD
     C                   PARM      '*KEY   '     POPTN
     C                   PARM      W4CNUM        PKEY1
     C                   PARM      *BLANKS       PKEYST
     C     SDCUST        PARM      SDCUST        DSSDY
 
     C                   EVAL      W4CUST = BBCRNM + BBCRTN
 
     C                   IF        CCF001 = 'Y'
 
     C                   IF        BBCRPC = 'Y'
     C                   EVAL      W4CTYP = 'C'
     C                   ELSE
     C                   EVAL      W4CTYP = 'I'
     C                   ENDIF
 
     C                   ELSE
 
     C                   IF        (BBLICD <> *BLANKS) AND
     C                             (BBLICD <> W1IND1)  AND
     C                             (BBLICD <> W1IND2)  AND
     C                             (BBLICD <> W1IND3)  AND
     C                             (BBLICD <> W1IND4)  AND
     C                             (BBLICD <> W1IND5)
     C                   EVAL      W4CTYP = 'C'
     C                   ELSE
     C                   EVAL      W4CTYP = 'I'
     C                   ENDIF
 
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SrW4CNUM - Get Counterparty Number                            *
      *                                                               *
      * Called by: SrGet1stParm                                       *
      *                                                               *
      * Calls: SrFieldInit, SrFormat                                  *
      *                                                               *
      *****************************************************************
     C     SrW4CNUM      BEGSR
 
      ** Get Counterparty Number for Incoming Payment
 
     C                   SELECT
     C                   WHEN      P_APICODE = 'IPAY'
     C                   EXSR      SrFieldInit
 
     C                   EVAL      Iy = %LOOKUP('W6RCCO':FldKeyArr)
     C                   EVAL      WRecCor  = FldValArr(Iy)
 
     C                   EVAL      Iy = %LOOKUP('W6SND1':FldKeyArr)
     C                   EVAL      FldLstArr(1) = FldValArr(Iy)
 
     C                   EVAL      Iy = %LOOKUP('W6SND2':FldKeyArr)
     C                   EVAL      FldLstArr(2) = FldValArr(Iy)
 
     C                   EVAL      Iy = %LOOKUP('W6SND3':FldKeyArr)
     C                   EVAL      FldLstArr(3) = FldValArr(Iy)
 
     C                   EVAL      Iy = %LOOKUP('W6SND4':FldKeyArr)
     C                   EVAL      FldLstArr(4) = FldValArr(Iy)
 
     C                   IF        (FldLstArr(1) <> *BLANKS) OR
     C                             (FldLstArr(2) <> *BLANKS) OR
     C                             (FldLstArr(3) <> *BLANKS) OR
     C                             (FldLstArr(4) <> *BLANKS)
     C                   EXSR      SrFormat
     C                   ENDIF
 
     C                   IF        (PCUS = '*FREE') OR (PCUS = '*CPART') OR
     C                             (FldLstArr(1)  = *BLANKS  AND
     C                              FldLstArr(2)  = *BLANKS  AND
     C                              FldLstArr(3)  = *BLANKS  AND
     C                              FldLstArr(4)  = *BLANKS)
     C                   EXSR      SrFieldInit
     C                   EVAL      FldLstArr(1) = WRecCor
     C                   EXSR      SrFormat
     C                   ENDIF
 
     C                   IF        (PCUS = '*FREE') OR (PCUS = '*CPART') OR
     C                             (FldLstArr(1) = *BLANKS  AND
     C                              FldLstArr(2) = *BLANKS  AND
     C                              FldLstArr(3) = *BLANKS  AND
     C                              FldLstArr(4) = *BLANKS)
     C                   EXSR      SrFieldInit
     C                   EVAL      Iy = %LOOKUP('W6TRI1':FldKeyArr)
     C                   EVAL      FldLstArr(1) = FldValArr(Iy)
     C                   EXSR      SrFormat
     C                   ENDIF
 
     C                   IF        (PCUS <> '*FREE') and (PCUS <> '*CPART')
     C                   EVAL      W4CNUM = PCUS
     C                   ENDIF
 
      ** Get Counterparty Number for Outgoing Payment
 
     C                   WHEN      P_APICODE = 'OPAY'
 
     C                   EXSR      SrFieldInit
     C                   EVAL      Iy = %LOOKUP('W6ODMT':FldKeyArr)
     C                   EVAL      FldLstArr(1) = FldValArr(Iy)
 
     C                   IF        FldLstArr(1) <> *BLANKS
     C                   EXSR      SrFormat
     C                   ELSE
     C                   EXSR      SrFieldInit
     C                   EVAL      Iy = %LOOKUP('W6ORC1':FldKeyArr)
     C                   EVAL      FldLstArr(1) = FldValArr(Iy)
     C                   EVAL      Iy = %LOOKUP('W6ORC2':FldKeyArr)
     C                   EVAL      FldLstArr(2) = FldValArr(Iy)
     C                   EVAL      Iy = %LOOKUP('W6ORC3':FldKeyArr)
     C                   EVAL      FldLstArr(3) = FldValArr(Iy)
     C                   EVAL      Iy = %LOOKUP('W6ORC4':FldKeyArr)
     C                   EVAL      FldLstArr(4) = FldValArr(Iy)
 
     C                   IF        (FldLstArr(1) <> *BLANKS) OR
     C                             (FldLstArr(2) <> *BLANKS) OR
     C                             (FldLstArr(3) <> *BLANKS) OR
     C                             (FldLstArr(4) <> *BLANKS)
     C                   EXSR      SrFormat
     C                   ENDIF
 
     C                   IF        (PCUS = '*FREE' OR PCUS = '*CPART') OR
     C                             (FldLstArr(1) = *BLANKS  AND
     C                              FldLstArr(2) = *BLANKS  AND
     C                              FldLstArr(3) = *BLANKS  AND
     C                              FldLstArr(4) = *BLANKS)
 
     C**********         EVAL      Iy = %LOOKUP('W6MSGR':FldKeyArr)                         MD039470
     C                   EVAL      Iy = %LOOKUP('W6PMSGR':FldKeyArr)                        MD039470
     C                   MOVEL     FldValArr(Iy) WOTOPMSGR
 
     C                   IF        WOTOPMSGR > 0
     C                   EXSR      SrFieldInit
     C                   EVAL      Iy = %LOOKUP('W6ORB1':FldKeyArr)
     C                   EVAL      FldLstArr(1) = FldValArr(Iy)
     C                   EVAL      Iy = %LOOKUP('W6ORB2':FldKeyArr)
     C                   EVAL      FldLstArr(2) = FldValArr(Iy)
     C                   EVAL      Iy = %LOOKUP('W6ORB3':FldKeyArr)
     C                   EVAL      FldLstArr(3) = FldValArr(Iy)
     C                   EVAL      Iy = %LOOKUP('W6ORB4':FldKeyArr)
     C                   EVAL      FldLstArr(4) = FldValArr(Iy)
     C                   EVAL      Iy = %LOOKUP('W6ORB5':FldKeyArr)
     C                   EVAL      FldLstArr(5) = FldValArr(Iy)
     C                   EXSR      SrFormat
     C                   ENDIF
     C                   ENDIF
     C                   IF        (PCUS = '*FREE' OR PCUS = '*CPART') OR
     C                             (FldLstArr(1) = *BLANKS  and
     C                              FldLstArr(2) = *BLANKS  and
     C                              FldLstArr(3) = *BLANKS  and
     C                              FldLstArr(4) = *BLANKS  and
     C                              WOTOPMSGR    = 0)
     C                   EXSR      SrFieldInit
     C                   EVAL      Iy = %LOOKUP('W6ORBT':FldKeyArr)
     C                   EVAL      WORBT  = FldValArr(Iy)
 
     C                   EVAL      OrderingBank = *BLANKS
 
     C                   SELECT
     C                   WHEN      WORBT = 'N'
     C                   EVAL      Iy = %LOOKUP('W6ORBK':FldKeyArr)
     C                   EVAL      WORBK  = FldValArr(Iy)
     C                   MOVEL     WORBK         ORBKNostro
     C                   MOVEL     OrderingBank  FldLstArr(1)
     C
     C                   WHEN      WORBT = 'R'
     C                   EVAL      Iy = %LOOKUP('W6ORBK':FldKeyArr)
     C                   EVAL      WORBK  = FldValArr(Iy)
     C                   MOVEL     WORBK         ORBKRetail
     C                   MOVEL     OrderingBank  FldLstArr(1)
     C                   OTHER
     C                   EVAL      Iy = %LOOKUP('W6ORBK':FldKeyArr)
     C                   EVAL      WORBK  = FldValArr(Iy)
     C                   MOVEL     WORBK         FldLstArr(1)
     C                   ENDSL
     C                   EXSR      SrFormat
     C                   ENDIF
     C                   ENDIF
 
     C                   EVAL      W4CNUM = PCUS
 
     C                   ENDSL
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SrFormat - Format Messages                                    *
      *                                                               *
      * Called by: SrBuildXML, SrW4CNUM                               *
      *                                                               *
      * Calls: SDCWLFMT                                               *
      *                                                               *
      *****************************************************************
     C     SrFormat      BEGSR
 
     C                   CALL      'SDCWLFMT'
     C                   PARM      *BLANKS       PRTCD
     C                   PARM                    FldLstArr(1)
     C                   PARM                    FldLstArr(2)
     C                   PARM                    FldLstArr(3)
     C                   PARM                    FldLstArr(4)
     C                   PARM                    FldLstArr(5)
     C                   PARM                    FldLstArr(6)
     C                   PARM      HDDEN1        PCCY
     C                   PARM      *BLANKS       PDAT
     C                   PARM      *BLANKS       PCUS
 
     C                   IF        (PRTCD <> *BLANKS) AND
     C                             (PRTCD <> '*NRF   ')
     C     *LOCK         IN        LDA
     C                   EVAL      DBKEY = FldLstArr(1)
     C                   EVAL      DBFILE = 'SDCWLFMT'
     C                   EVAL      DBASE = 003
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SrDeleteWLC - Delete SDCWHTPD record if action is Reject      *
      *               or Delete                                       *
      *                                                               *
      * Called by: Main processing                                    *
      *                                                               *
      * Calls: SrGet1stParm                                           *
      *                                                               *
      *****************************************************************
     C     SrDeleteWLC   BEGSR
 
      ** Remove record from SDCWDFPD
 
     C     KeyWLC        CHAIN     SDCWDFL1
     C                   IF        %FOUND(SDCWDFL1)
     C                   DELETE    SDCWDFD0
     C                   ENDIF
 
      ** Remove record from SDCWHTPD
 
     C     KeyWLC        CHAIN     SDCWHTL0
     C                   IF        %FOUND(SDCWHTL0)
     C                   DELETE    SDCWHTD0
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SrGetSQ - Get next sequence number                            *
      *                                                               *
      * Called by: SrPopulate                                         *
      *                                                               *
      * Calls: *None                                                  *
      *                                                               *
      *****************************************************************
     C     SrGetSQ       BEGSR
 
     C     *DTAARA       DEFINE    SDWLNSQ       DNATN
     C     *LOCK         IN        DNATN
     C                   MOVE      FNATN         LastSQ
     C                   EVAL      LastSQ = LastSQ + 1
     C                   MOVE      LastSQ        FNATN
     C                   OUT       DNATN
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SrPopulate - Populate SDCWFCPD file with information passed   *
      *              from Java UI                                     *
      *                                                               *
      * Called by: SrSendWLC                                          *
      *                                                               *
      * Calls: SrGetSQ                                                *
      *                                                               *
      *****************************************************************
     C     SrPopulate    BEGSR
 
     C                   EVAL      Ix    = 1
     C                   EVAL      FldKeyArr  = *BLANKS
     C                   EVAL      FldValArr  = *BLANKS
     C                   EVAL      FldGrpArr  = *ZEROS
     C                   EVAL      FldFmtArr  = *BLANKS
     C                   EVAL      BeginXML   = *BLANKS
     C                   EVAL      EndXML     = *BLANKS
 
     C                   SETOFF                                       25
     C     KeyAPI        SETLL     SDCWFCD0
     C     *IN25         DOWEQ     *OFF
     C     KeyAPI        READE     SDCWFCD0                               25
 
     C                   IF        *IN25 = *OFF
     C                   EVAL      FldKeyArr(Ix)  = WFFLDN
     C                   EVAL      FldGrpArr(Ix)  = WFGROP
     C                   EVAL      FldFmtArr(Ix)  = WFFRMC
     C                   EVAL      BeginXML(Ix)   = WFBXML
     C                   EVAL      EndXML(Ix)     = WFEXML
     C                   EVAL      FldValArr(Ix) = %SUBST(P_BUFFER: +
     C                             WFSTRT:WFFLDB)
     C                   EVAL      Ix = Ix + 1
     C                   ENDIF
 
     C                   ENDDO
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SrChkMonWLC - Check if function code is to be monitored       *
      *               by WLC                                          *
      *                                                               *
      * Called by: Main processing                                    *
      *                                                               *
      * Calls: AOWLCCR0                                               *
      *                                                               *
      *****************************************************************
     C     SrChkMonWLC   BEGSR
 
     C     P_APICODE     CHAIN     SDCWMOL0
     C                   IF        %FOUND(SDCWMOL0)
     C                   EVAL      FunctionCode = WMPFNC
     C                   ENDIF
 
     C                   CALL      'AOWLCCR0'
     C                   PARM      *BLANKS       PRTCD
     C                   PARM      '*KEY   '     POPTN
     C                   PARM      FunctionCode  PFNCOD
     C     SDWLCC        PARM      SDWLCC        DSFDY
 
      ** Database error
 
     C                   IF        (PRTCD <> *BLANKS)
     C                             AND (PRTCD <> '*NRF')
     C     *LOCK         IN        LDA
     C                   EVAL      DBKEY = 'SDCUSD'
     C                   EVAL      DBFILE = 'SDWLCCPD'
     C                   EVAL      DBASE = 004
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SrEdtMessage - Edit Message for Output                        *
      *                                                               *
      * Called by: Main processing                                    *
      *                                                               *
      * Calls: APEDTMSGS                                              *
      *                                                               *
      ****************************************************************
     C     SrEdtMessage  BEGSR
 
     C                   IF        ErrorExist = 'Y'
 
     C                   IF        (TRANS_ID = *BLANKS) AND
     C                             (P_W4IDEN <> *BLANKS)
     C                   MOVE      P_W4IDEN      REFERENCE
     C                   ELSE
     C                   MOVE      TRANS_ID      REFERENCE
     C                   ENDIF
 
     C                   CALLB     'APEDTMSGS'
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIDArr
     C                   PARM                    MsgDtaArr
     C                   PARM                    WFldNamArr
     C                   PARM                    WMsgIDArr
     C                   PARM                    WMsgDtaArr
     C                   PARM                    MsgFArray
     C                   PARM                    T_MESSG
     C                   PARM                    APIName                                    AR895153
     C                   EVAL      P_MESSG = %TRIM(T_MESSG) +
     C                             '*ANY:REFERENCE:E:'+
     C                             %TRIM(REFERENCE)+ '.:'
 
     C                   ELSE
     C                   EVAL      P_MESSG = *BLANKS
 
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT                                                          *
      *****************************************************************
      *                                                               *
      * SrConvertDate - Converts date to be used by Watch List        *
      *                 Engine Program                                *
      *                                                               *
      * Called by: SrGet1stParm                                       *
      *                                                               *
      * Calls: ZACVTDATE, ZAVDATE                                     *
      *                                                               *
      *****************************************************************
     C     SrConvertDate BEGSR
 
     C                   CALLB     'ZAVDATE'
     C                   PARM      *BLANKS       PRTCD
     C                   PARM                    WDateStr
     C                   PARM                    BJDFIN
     C                   PARM      *ZEROS        PDAYNO
 
     C                   IF        PRTCD = *BLANKS
     C                   MOVE      PDAYNO        PZADAYNO
     C                   CALLB     'ZACVTDATE'
     C                   PARM      *BLANKS       PRTCD
     C                   PARM                    PZADAYNO
     C                   PARM                    PZADDT
     C                   PARM      *BLANKS       PZACVTDT
     C                   ELSE
     C                   CLEAR                   PZADDT
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT                                                          *
      *****************************************************************
      *                                                               *
      * SrConvertAmt - Converts an amount into a Floating Point Data  *
      *                                                               *
      * Called by: SrGet1stParm                                       *
      *                                                               *
      * Calls: ZACVTAMT, ZALIGN, AOCURRR0                             *
      *                                                               *
      *****************************************************************
     C     SrConvertAmt  BEGSR
 
     C                   CALL      'AOCURRR0'
     C                   PARM      *BLANKS       PRTCD
     C                   PARM      '*KEY   '     POPTN
     C                   PARM      ZCCY          PCCY
     C     SDCURR        PARM      SDCURR        DSSDY
 
     C                   IF        PRTCD = *BLANKS
     C                   EVAL      ZADEC = A6NBDP
     C                   EVAL      ZADIG = 13 - ZADEC
 
     C                   CALLB     'ZALIGN'
     C                   PARM      *BLANKS       ZALIGNOK
     C                   PARM                    ZFIELD
     C                   PARM                    ZADEC
     C                   PARM                    ZADIG
 
     C                   IF        ZALIGNOK = 'Y'
 
     C                   MOVE      ZFIELD        ZFLD
     C                   CALL      'ZACVTAMT'
     C                   PARM      *BLANKS       PZARTCD
     C                   PARM      ZCCY          PZACCY
     C                   PARM      ZFLD          PZAAMT
     C                   PARM      *ZEROS        PZOUTAMT
     C                   PARM      *BLANKS       PZCVTAMT
     C                   ELSE
     C                   EVAL      PZOUTAMT = *ZEROS
     C                   ENDIF
 
     C                   ELSE
     C                   EVAL      PZOUTAMT = *ZEROS
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SrGetTransID - Get the transaction's identifier               *
      *                                                               *
      * Called by: Main Processing                                    *
      *                                                               *
      * Calls: *none                                                  *
      *                                                               *
      *****************************************************************
     C     SrGetTransID  BEGSR
 
     C                   EVAL      TRANS_ID = *BLANKS
 
     C                   SELECT
     C                   WHEN      P_APICODE = 'ACMN' OR
     C                             P_APICODE = 'AMAD'
 
     C                   EVAL      Iy = %LOOKUP('W6BRCA':FldKeyArr)
     C                   MOVEL     FldValArr(Iy) W6BRCA
     C                   EVAL      Iy = %LOOKUP('W6CNUM':FldKeyArr)
     C                   MOVEL     FldValArr(Iy) W6TREF
     C                   EVAL      Iy = %LOOKUP('W6CCYD':FldKeyArr)
     C                   MOVEL     FldValArr(Iy) W6CCYD
     C                   EVAL      Iy = %LOOKUP('W6ACOD':FldKeyArr)
     C                   MOVEL     FldValArr(Iy) W6ACOD
     C                   EVAL      Iy = %LOOKUP('W6ACSQ':FldKeyArr)
     C                   MOVEL     FldValArr(Iy) W6ACSQ
 
     C                   IF        (W6BRCA <> *BLANKS) AND
     C                             (W6TREF <> *BLANKS) AND
     C                             (W6CCYD <> *BLANKS) AND
     C                             (W6ACOD <> *BLANKS) AND
     C                             (W6ACSQ <> *BLANKS)
     C                   EVAL      TRANS_ID = W6BRCA + W6TREF + W6CCYD +
     C                                        W6ACOD + W6ACSQ
     C                   ENDIF
 
     C                   WHEN      P_APICODE = 'ALNA'
 
     C                   EVAL      Iy = %LOOKUP('W6CUSL':FldKeyArr)
     C                   MOVEL     FldValArr(Iy) W6TREF
     C                   EVAL      Iy = %LOOKUP('W6ADDR':FldKeyArr)
     C                   MOVEL     FldValArr(Iy) W6ADDR
 
     C                   IF        (W6TREF <> *BLANKS) AND
     C                             (W6ADDR <> *BLANKS)
     C                   EVAL      TRANS_ID = W6TREF + W6ADDR
     C                   ENDIF
 
     C                   WHEN      P_APICODE = 'CACF' OR
     C                             P_APICODE = 'CIRS' OR
     C                             P_APICODE = 'FRA'  OR
     C                             P_APICODE = 'SIRS'
 
     C                   EVAL      Iy = %LOOKUP('W6DLNO':FldKeyArr)
     C                   MOVEL     FldValArr(Iy) W6TREF
 
     C                   IF        (W6TREF <> *BLANKS)
     C                   EVAL      TRANS_ID = W6TREF
     C                   ENDIF
 
     C                   WHEN      P_APICODE = 'CLIP' OR
     C                             P_APICODE = 'LERI'
 
     C                   EVAL      Iy = %LOOKUP('W6LNRF':FldKeyArr)
     C                   MOVEL     FldValArr(Iy) W6TREF
 
     C                   IF        (W6TREF <> *BLANKS)
     C                   EVAL      TRANS_ID = W6TREF
     C                   ENDIF
 
     C                   WHEN      P_APICODE = 'CUSD'
 
     C                   EVAL      Iy = %LOOKUP('W6CSTN':FldKeyArr)
     C                   MOVEL     FldValArr(Iy) W6TREF
 
     C                   IF        (W6TREF <> *BLANKS)
     C                   EVAL      TRANS_ID = W6TREF
     C                   ENDIF
 
     C                   WHEN      P_APICODE = 'DEAM'
 
     C                   EVAL      Iy = %LOOKUP('W6DA38':FldKeyArr)
     C                   MOVEL     FldValArr(Iy) W6TREF
     C                   EVAL      Iy = %LOOKUP('W6VDAT':FldKeyArr)
     C                   MOVEL     FldValArr(Iy) W6VDAT
     C                   EVAL      Iy = %LOOKUP('W6DS38':FldKeyArr)
     C                   MOVEL     FldValArr(Iy) W6DS38
 
     C                   IF        (W6TREF <> '000000') AND
     C                             (W6VDAT <> '000000') AND
     C                             (W6DS38 <> '000')
     C                   EVAL      TRANS_ID = W6TREF + W6VDAT + W6DS38
     C                   ENDIF
 
     C                   WHEN      P_APICODE = 'DPMV' OR
     C                             P_APICODE = 'DPWI' OR
     C                             P_APICODE = 'DPWO'
 
     C                   EVAL      Iy = %LOOKUP('W6DPRN':FldKeyArr)
     C                   MOVEL     FldValArr(Iy) W6TREF
 
     C                   IF        (W6TREF <> *BLANKS)
     C                   EVAL      TRANS_ID = W6TREF
     C                   ENDIF
 
     C                   WHEN      P_APICODE = 'EXTR' OR
     C                             P_APICODE = 'OTCO' OR
     C                             P_APICODE = 'OTCC'
 
     C                   EVAL      Iy = %LOOKUP('W6TNBR':FldKeyArr)
     C                   MOVEL     FldValArr(Iy) W6TREF
 
     C                   IF        (W6TREF <> *BLANKS)
     C                   EVAL      TRANS_ID = W6TREF
     C                   ENDIF
 
     C                   WHEN      P_APICODE = 'FCIP'
 
     C                   EVAL      Iy = %LOOKUP('W6FCNO':FldKeyArr)
     C                   MOVEL     FldValArr(Iy) W6FCNO
     C                   EVAL      Iy = %LOOKUP('W6FACT':FldKeyArr)
     C                   MOVEL     FldValArr(Iy) W6FACT
     C                   EVAL      Iy = %LOOKUP('W6CUST':FldKeyArr)
     C                   MOVEL     FldValArr(Iy) W6TREF
 
     C                   IF        (W6FCNO <> *BLANKS) AND
     C                             (W6FACT <> *BLANKS) AND
     C                             (W6TREF <> *BLANKS)
     C                   EVAL      TRANS_ID = W6FCNO + '/' + W6FACT +
     C                             W6TREF
     C                   ENDIF
 
     C                   WHEN      P_APICODE = 'FAMD'
 
     C                   EVAL      Iy = %LOOKUP('W6FCNO':FldKeyArr)
     C                   MOVEL     FldValArr(Iy) W6FCNO
     C                   EVAL      Iy = %LOOKUP('W6FACT':FldKeyArr)
     C                   MOVEL     FldValArr(Iy) W6FACT
     C                   EVAL      Iy = %LOOKUP('W6CUST':FldKeyArr)
     C                   MOVEL     FldValArr(Iy) W6TREF
     C                   EVAL      Iy = %LOOKUP('W6AMSQ':FldKeyArr)
     C                   MOVEL     FldValArr(Iy) W6AMSQ
 
     C                   IF        (W6FCNO <> *BLANKS) AND
     C                             (W6FACT <> *BLANKS) AND
     C                             (W6TREF <> *BLANKS) AND
     C                             (W6AMSQ <> *BLANKS) AND
     C                             (HDVADT <> *BLANKS)
     C                   EVAL      TRANS_ID = W6FCNO + '/' + W6FACT +
     C                             W6TREF + W6AMSQ + HDVADT
     C                   ENDIF
 
     C                   WHEN      P_APICODE = 'FEEM' OR
     C                             P_APICODE = 'FEST'
 
     C                   EVAL      Iy = %LOOKUP('W6FCNUM':FldKeyArr)
     C                   MOVEL     FldValArr(Iy) W6TREF
     C                   EVAL      Iy = %LOOKUP('W6FACT':FldKeyArr)
     C                   MOVEL     FldValArr(Iy) W6FACT
     C                   EVAL      Iy = %LOOKUP('W6FCNO':FldKeyArr)
     C                   MOVEL     FldValArr(Iy) W6FCNO
     C                   EVAL      Iy = %LOOKUP('W6FFSEQ':FldKeyArr)
     C                   MOVEL     FldValArr(Iy) W6FSEQ
 
     C                   IF        (W6TREF <> *BLANKS)  AND
     C                             (W6FACT <> *BLANKS)  AND
     C                             (W6FCNO <> *BLANKS)  AND
     C                             (W6FSEQ<> *BLANKS)
     C                   EVAL      TRANS_ID = W6TREF + W6FACT + W6FCNO +
     C                                        W6FSEQ
     C                   ENDIF
 
     C                   WHEN      P_APICODE = 'FXDL' OR
     C                             P_APICODE = 'NASP' OR
     C                             P_APICODE = 'NASS' OR
     C                             P_APICODE = 'LDNI'
 
     C                   EVAL      Iy = %LOOKUP('W6DN38':FldKeyArr)
     C                   MOVEL     FldValArr(Iy) W6TREF
 
     C                   IF        (W6TREF <> *BLANKS)
     C                   EVAL      TRANS_ID = W6TREF
     C                   ENDIF
     C
     C                   WHEN      P_APICODE = 'IPAY' OR
     C                             P_APICODE = 'OPAY'
 
     C                   EVAL      Iy = %LOOKUP('W6PREF':FldKeyArr)
     C                   MOVEL     FldValArr(Iy) W6PREF
 
     C                   IF        (W6PREF<> *BLANKS)
     C                   EVAL      TRANS_ID = W6PREF
     C                   ENDIF
 
     C                   WHEN      P_APICODE = 'LOAM' OR
     C                             P_APICODE = 'MAPY' OR
     C                             P_APICODE = 'RPSC'
 
     C                   EVAL      Iy = %LOOKUP('W6LNRF':FldKeyArr)
     C                   MOVEL     FldValArr(Iy) W6TREF
     C                   EVAL      Iy = %LOOKUP('W6VDAT':FldKeyArr)
     C                   MOVEL     FldValArr(Iy) W6VDAT
     C                   EVAL      Iy = %LOOKUP('W6LASN':FldKeyArr)
     C                   MOVEL     FldValArr(Iy) W6LASN
 
     C                   IF        (W6TREF <> *BLANKS) AND
     C                             (W6VDAT <> *BLANKS) AND
     C                             (W6LASN <> *BLANKS)
     C                   EVAL      TRANS_ID = W6TREF + W6VDAT + W6LASN
     C                   ENDIF
 
     C                   WHEN      P_APICODE = 'TRAD'
     C
     C                   EVAL      Iy = %LOOKUP('W6TDRF':FldKeyArr)
     C                   MOVEL     FldValArr(Iy) W6TREF
 
     C                   IF        (W6TREF <> *BLANKS)
     C                   EVAL      TRANS_ID = W6TREF
     C                   ENDIF
     C
     C                   ENDSL
 
     C                   ENDSR
      *****************************************************************
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
     C                   PARM                    P_APICODE
     C                   PARM                    P_ACTION
     C                   PARM                    P_HEADER
     C                   PARM                    P_BUFFER
     C                   PARM                    P_W4IDEN
     C                   PARM                    P_MESSG
     C                   PARM                    P_RETU
 
     C     *DTAARA       DEFINE                  SDSTAT
     C     *DTAARA       DEFINE                  SC24X7
 
     C     KeyWLC        KLIST
     C                   KFLD                    W4FUNT
     C                   KFLD                    W4IDENX
     C                   KFLD                    W4BRCH
 
     C     KeyAPI        KLIST
     C                   KFLD                    P_APICODE
 
     C     WKLOAN        KLIST
     C                   KFLD                    WLNRF
     C                   KFLD                    WRCDT
 
      ** Access Bank Details
 
     C                   CALL      'AOBANKR0'
     C                   PARM      *BLANKS       PRTCD
     C                   PARM      '*FIRST'      POPTN
     C     SDBANK        PARM      SDBANK        DSFDY
 
     C                   IF        PRTCD <> *BLANKS
     C     *LOCK         IN        LDA
     C                   EVAL      DBKEY = POPTN
     C                   EVAL      DBFILE = 'SDBANKPD'
     C                   EVAL      DBASE = 001
     C                   EXSR      *PSSR
     C                   ENDIF
 
      ** Access SAR details file to determine if CSC011 is installed
 
     C                   CALL      'AOSARDR0'
     C                   PARM      *BLANKS       PRTCD
     C                   PARM      '*VERIFY'     POPTN
     C                   PARM      'CSC011'      PSARD
     C     SCSARD        PARM      SCSARD        DSFDY
 
     C                   IF        PRTCD = *BLANKS
     C                   EVAL      CSC011 = 'Y'
     C                   IN        SC24X7
     C                   ELSE
     C                   EVAL      CSC011 = 'N'
     C                   ENDIF
 
      ** Access SAR details file to determine if CCF001 is installed
 
     C                   CALL      'AOSARDR0'
     C                   PARM      *BLANKS       PRTCD
     C                   PARM      '*VERIFY'     POPTN
     C                   PARM      'CCF001'      PSARD
     C     SCSARD        PARM      SCSARD        DSFDY
 
     C                   IF        PRTCD = *BLANKS
     C                   EVAL      CCF001 = 'Y'
     C                   ELSE
     C                   EVAL      CCF001 = 'N'
     C                   ENDIF
 
      **  Access Compliance Watch Configuration Data if necessary.
 
     C                   CALL      'AOCWCDR0'
     C                   PARM      *BLANKS       PRTCD
     C                   PARM      '*FIRST'      POPTN
     C     SDCWCD        PARM      SDCWCD        DSSDY
 
     C                   IF        PRTCD <> *BLANKS
     C     *LOCK         IN        LDA
     C                   EVAL      DBKEY = POPTN
     C                   EVAL      DBFILE = 'SDCWCDPD'
     C                   EVAL      DBASE = 002
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   IN        SDSTAT
 
      ** Set up the name of the primary and secondary message files from
      ** which the message handler will get the messages
 
     C                   EVAL      MsgFArray(1) = 'SDUSRMSG'
 
     C                   EVAL      P_MESSG = *BLANKS
     C                   EVAL      T_MESSG = *BLANKS
     C                   EVAL      SDHEADER = P_HEADER
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * *PSSR  - Program exception error routine                      *
      *          Called automatically if a program error occurs,      *
      *          or directly by the program code using EXSR.          *
      *          This subroutine DUMPs the program just once.         *
      *                                                               *
      * Called by: (**Calling Routines**)                             *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
     C     *PSSR         BEGSR
 
     C                   IF        @RUN = *BLANK
     C                   EVAL      @RUN = 'Y'
     C                   CALL      'DBERRCTL'
     C                   ENDIF
 
     C                   EVAL      P_RETU = '0'
     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   EVAL      *INLR = *ON
     C                   RETURN
 
     C                   ENDSR
      ********************************************************************
      /EJECT
      ********************************************************************
**  CPY@
(c) Finastra International Limited 2010
