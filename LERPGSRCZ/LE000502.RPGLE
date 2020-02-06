     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2013')
      *****************************************************************
/*OVR *  OVRDBF FILE(LEMQHELD) TOFILE(LEMQLGLA) SHARE(*NO)            *
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('Midas LE Resend XML Transactions in Held Status')      *
      *****************************************************************
      *                                                               *
      *  Midas - Customer Lending Module                              *
      *                                                               *
      *  LE000502 - Midas LE Resend XML Transactions in Held Status   *
      *                                                               *
      *  (c) Finastra International Limited 2013                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      *  Prev Amend No. MD022807E          Date 17Oct13               *
      *                 MD022807           Date 10Oct13               *
      *                 MD021423E          Date 12Sep13               *
      *                 MD020534 *CREATE   Date 23May13               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  MD022807E - Default PSTM and PONS to '00' and blanks         *
      *  MD022807  - Update currency and other loans details based    *
      *              on the value of the new PDCL created             *
      *  MD021423E - Deal date should be the deal date of the OL      *
      *              Pay instruction should be defaulted from receipt *
      *              instruction of the OL                            *
      *  MD020534 - System did not generate PDCL for the unpaid       *
      *             balance of interest after COB                     *
      *                                                               *
      *****************************************************************
     FLEMQHELD  UF   E           K DISK    INFSR(*PSSR)
      ** PDP Transaction Log File sent to MQ
 
     FLEPDUFL7  IF   E           K DISK    INFSR(*PSSR)
      ** PDCL Fee Link file
 
     FLEPDUEL7  IF   E           K DISK    INFSR(*PSSR)
      ** PDCL Loan Link file
                                                                                           MD021423E
     FLEPDUFLD  UF   E           K DISK    INFSR(*PSSR)                                    MD021423E
     F                                     RENAME(LEPDUFD0:LEPDUFDX)                       MD021423E
     F                                     PREFIX(F_)                                      MD021423E
      ** PDCL Fee Link file                                                                MD021423E
                                                                                           MD021423E
     FLEPDUELD  UF   E           K DISK    INFSR(*PSSR)                                    MD021423E
     F                                     RENAME(LEPDUED0:LEPDUEDX)                       MD021423E
     F                                     PREFIX(L_)                                      MD021423E
      ** PDCL Loan Link file                                                               MD021423E
     FCLOAN     IF   E           K DISK    INFSR(*PSSR)                                     MD022807
      ** LE Loans File C                                                                    MD022807
     F                                     IGNORE(CLOANHHF)                                 MD022807
     F                                     IGNORE(CLOANCKF)                                 MD022807
     F                                     IGNORE(CLOANZ1F)                                 MD022807
     F                                     PREFIX(C_)                                       MD022807
     FCLOANC    IF   E           K DISK    INFSR(*PSSR)                                     MD022807
      ** LE Loans File K                                                                    MD022807
     F                                     IGNORE(CLOANHHF)                                 MD022807
     F                                     IGNORE(CLOANCLF)                                 MD022807
     F                                     IGNORE(CLOANZ1F)                                 MD022807
     F                                     PREFIX(K_)                                       MD022807
      *                                                                                     MD022807
      ** Midas SD Currency Codes file                                                       MD022807
     FSDCURRL1  IF   E           K DISK                                                     MD022807
      *                                                                                     MD022807
      ** Data structure for AO objects                                                      MD022807
     D DSSDY         E DS                  EXTNAME(DSSDY   )                                MD022807
      *                                                                                     MD022807
      ** Short data structure for access objects                                            MD022807
     D DSFDY         E DS                  EXTNAME(DSFDY)                                   MD022807
      *                                                                                     MD022807
      ** Data structure for Currency Details                                                MD022807
     D SDCURR        E DS                  EXTNAME(SDCURRPD)                                MD022807
 
      **------------------------------------------------------------------
      ** The following /COPY line includes all the defined fields in the
      ** Program Status Data Structures.  They have meaningful
      ** names, prefixed by 'PS'.
     D/COPY ZACPYSRC,PSDS
     D/COPY ZACPYSRC,STD_D_SPEC
      **------------------------------------------------------------------
      ** +--------------------------------------+
      **   Manually included D-specs            +
      **   =========================            +
      ** +--------------------------------------+
     D PWipQueue       S             48A
     D PRetCode        S              7A
     D PErrMsg         S             30A
     D PRequest        S             10A
     D PQueueNm        S             48A
     D PMQMgr          S             48A
     D PMsgBuf         S          32000A
     D WkRespQ         S             20A
     D WkMQMgr         S             48A
     D WkUser          S             10A
     D P@Key           S              4A
     D PLoan           S              6A
     D PLoc            S              5  0
     D PLoc1           S              5  0                                                  MD022807
     D PLoc2           S              5  0                                                  MD022807
 
      ** System Value Parameter
     D POP01           S             20A
     D PVL01           S            200A
     D POP02           S             20A
     D PVL02           S            200A
     D POP03           S             20A
     D PVL03           S            200A
     D POP04           S             20A
     D PVL04           S            200A
     D POP05           S             20A
     D PVL05           S            200A
     D POP06           S             20A
     D PVL06           S            200A
     D POP07           S             20A
     D PVL07           S            200A
     D POP08           S             20A
     D PVL08           S            200A
     D POP09           S             20A
     D PVL09           S            200A
     D POP10           S             20A
     D PVL10           S            200A
     D CurrKey         S                   LIKE (A6CYCD)                                    MD022807
     D CurrIdx         S              3  0 INZ(1)                                           MD022807
     D TrailIdx        S              3  0 INZ(1)                                           MD022807
     D CurrCache       S                   INZ LIKE(A6CYCD)                                 MD022807
     D                                     DIM(250) ASCEND                                  MD022807
      *                                                                                     MD022807
      ** Key for Currency Details (Full Cache)                                              MD022807
     D DSCurr        E DS                  INZ EXTNAME(SDCURRPD)                            MD022807
     D                                     DIM(250) QUALIFIED                               MD022807
      *                                                                                     MD022807
     ** Storage for Currency Details (Full Cache)                                           MD022807
                                                                                            MD022807
     DPartsSold        C                   CONST('1')                                       MD022807
     DPartsPurchase    C                   CONST('2')                                       MD022807
                                                                                            MD022807
     D ProcessingType  S              1A                                                    MD022807
 
      ** +--- Start of Main processing -----------------------------------+
      ** ¦                                                                ¦
      ** ¦ Initial processing is performed automatically: the *INZSR is   ¦
      ** ¦ executed at program activation.                                ¦
      ** ¦                                                                ¦
      ** +----------------------------------------------------------------+
      *
      ** Read records in LEMQLGPD whose status is 'H'
      ** and program name equal to calling program
      *
     C                   READ      LEMQLGPF                               50
      *
     C                   DOW       *IN50 = *OFF
      *
      ** Retrieve Loan number
      *
     C                   EXSR      SrRtvLoan
      *
      ** Resend XML data
      *
     C                   EXSR      SrSendXML
      *
     C                   READ      LEMQLGPF                               50
      *
     C                   ENDDO
      *
     C                   EVAL      *INLR = *ON
     C                   RETURN
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SrRtvLoan - Retrieves the generated PDCL reference            *
      *                                                               *
      * Called by: Main Processing                                    *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
     C     SrRtvLoan     BEGSR
      *
     C                   EVAL      PLoan = *BLANKS
      *
      ** Use LEPDUFPD for LEC000131 and LEC000138
      *
     C                   IF        LGPGNM = 'LEC000131' OR
     C                             LGPGNM = 'LEC000138'
      *
     C     KLEPDUF       CHAIN     LEPDUFL7                           51
     C  N51              EVAL      PLoan = YPLON
      *
     C                   EXSR      SrUpdateLEPDUF                                          MD021423E
     C                   ENDIF
      *
      ** Use LEPDUEPD for LEC000456
      *
     C                   IF        LGPGNM = 'LEC000456'
      *
     C     KLEPDUE       CHAIN     LEPDUEL7                           51
     C  N51              EVAL      PLoan = YPLON
      *                                                                                    MD021423E
     C                   EXSR      SrUpdateLEPDUE                                          MD021423E
     C                   ENDIF
      *
      ** Update XML
      *
     C     Ploan         CHAIN (N) CLOAN                                                    MD022807
     C     Ploan         CHAIN (N) CLOANC                                                   MD022807
      *                                                                                     MD022807
      ** Loan reference                                                                     MD022807
     C     '<DDLOAN>'    SCAN      LGXMLF        PLoc1                                      MD022807
     C     '</DDLOAN>'   SCAN      LGXMLF        PLoc2                                      MD022807
     C                   EVAL      LGXMLF = %SUBST(LGXMLF:1:PLoc1 + 7)  +  ' ' +            MD022807
     C                                      %SUBST(LGXMLF:  PLoc2)                          MD022807
     C     '</DDLOAN>'   SCAN      LGXMLF        PLoc
     C                   IF        PLoc <> 0
     C                   EVAL      LGXMLF = %SUBST(LGXMLF:1:PLoc-2) +
     C                                      PLoan +
     C                                      %SUBST(LGXMLF:PLoc)
     C                   ENDIF                                                              MD022807
      *                                                                                     MD022807
      ** Customer number                                                                    MD022807
     C     '<DDCNUM>'    SCAN      LGXMLF        PLoc1                                      MD022807
     C     '</DDCNUM>'   SCAN      LGXMLF        PLoc2                                      MD022807
     C                   EVAL      LGXMLF = %SUBST(LGXMLF:1:PLoc1 + 7)  +  ' ' +            MD022807
     C                                      %SUBST(LGXMLF:  PLoc2)                          MD022807
     C     '</DDCNUM>'   SCAN      LGXMLF        PLoc                                       MD022807
     C                   IF        PLoc <> 0                                                MD022807
     C                   EVAL      LGXMLF = %SUBST(LGXMLF:1:PLoc-2) +                       MD022807
     C                                      C_CNUM +                                        MD022807
     C                                      %SUBST(LGXMLF:PLoc)                             MD022807
     C                   ENDIF                                                              MD022807
      *                                                                                     MD022807
      ** Currency                                                                           MD022807
     C     '<DDCURR>'    SCAN      LGXMLF        PLoc1                                      MD022807
     C     '</DDCURR>'   SCAN      LGXMLF        PLoc2                                      MD022807
     C                   EVAL      LGXMLF = %SUBST(LGXMLF:1:PLoc1 + 7)  +  ' ' +            MD022807
     C                                      %SUBST(LGXMLF:  PLoc2)                          MD022807
     C     '</DDCURR>'   SCAN      LGXMLF        PLoc                                       MD022807
     C                   IF        PLoc <> 0                                                MD022807
     C                   EVAL      LGXMLF = %SUBST(LGXMLF:1:PLoc-2) +                       MD022807
     C                                      C_CCY  +                                        MD022807
     C                                      %SUBST(LGXMLF:PLoc)                             MD022807
     C                   ENDIF                                                              MD022807
      *                                                                                     MD022807
      ** Loan Type                                                                          MD022807
     C     '<DDLTYP>'    SCAN      LGXMLF        PLoc1                                      MD022807
     C     '</DDLTYP>'   SCAN      LGXMLF        PLoc2                                      MD022807
     C                   EVAL      LGXMLF = %SUBST(LGXMLF:1:PLoc1 + 7)  +  ' ' +            MD022807
     C                                      %SUBST(LGXMLF:  PLoc2)                          MD022807
     C     '</DDLTYP>'   SCAN      LGXMLF        PLoc                                       MD022807
     C                   IF        PLoc <> 0                                                MD022807
     C                   EVAL      LGXMLF = %SUBST(LGXMLF:1:PLoc-2) +                       MD022807
     C                                      C_LTYP +                                        MD022807
     C                                      %SUBST(LGXMLF:PLoc)                             MD022807
     C                   ENDIF                                                              MD022807
      *                                                                                     MD022807
      ** Loan SubType                                                                       MD022807
     C     '<DDSTYP>'    SCAN      LGXMLF        PLoc1                                      MD022807
     C     '</DDSTYP>'   SCAN      LGXMLF        PLoc2                                      MD022807
     C                   EVAL      LGXMLF = %SUBST(LGXMLF:1:PLoc1 + 7)  +  ' ' +            MD022807
     C                                      %SUBST(LGXMLF:  PLoc2)                          MD022807
     C     '</DDSTYP>'   SCAN      LGXMLF        PLoc                                       MD022807
     C                   IF        PLoc <> 0                                                MD022807
     C                   EVAL      LGXMLF = %SUBST(LGXMLF:1:PLoc-2) +                       MD022807
     C                                      C_SUTP +                                        MD022807
     C                                      %SUBST(LGXMLF:PLoc)                             MD022807
     C                   ENDIF                                                              MD022807
      *                                                                                     MD022807
      ** Loan Class                                                                         MD022807
     C     '<DDCLAS>'    SCAN      LGXMLF        PLoc1                                      MD022807
     C     '</DDCLAS>'   SCAN      LGXMLF        PLoc2                                      MD022807
     C                   EVAL      LGXMLF = %SUBST(LGXMLF:1:PLoc1 + 7)  +  ' ' +            MD022807
     C                                      %SUBST(LGXMLF:  PLoc2)                          MD022807
     C     '</DDCLAS>'   SCAN      LGXMLF        PLoc                                       MD022807
     C                   IF        PLoc <> 0                                                MD022807
     C                   EVAL      LGXMLF = %SUBST(LGXMLF:1:PLoc-2) +                       MD022807
     C                                      C_CLAS +                                        MD022807
     C                                      %SUBST(LGXMLF:PLoc)                             MD022807
     C                   ENDIF                                                              MD022807
      *                                                                                     MD022807
      ** Amount                                                                             MD022807
     C                   EVAL      @CURR = C_CCY                                            MD022807
     C                   IF        @CURR <> *BLANKS                                         MD022807
     C                   EXSR      SrChkCurr                                                MD022807
     C                   ENDIF                                                              MD022807
     C                   MOVE      LGAMNT        ZFLD15                                     MD022807
     C                   EXSR      SrConvAmt                                                MD022807
      *                                                                                     MD022807
     C     '<DDAMNT>'    SCAN      LGXMLF        PLoc1                                      MD022807
     C     '</DDAMNT>'   SCAN      LGXMLF        PLoc2                                      MD022807
     C                   EVAL      LGXMLF = %SUBST(LGXMLF:1:PLoc1 + 7)  +  ' ' +            MD022807
     C                                      %SUBST(LGXMLF:  PLoc2)                          MD022807
     C     '</DDAMNT>'   SCAN      LGXMLF        PLoc                                       MD022807
     C                   IF        PLoc <> 0                                                MD022807
     C                   EVAL      LGXMLF = %SUBST(LGXMLF:1:PLoc-2) +                       MD022807
     C                                      %TRIM(ZOUT21) +                                 MD022807
     C                                      %SUBST(LGXMLF:PLoc)                             MD022807
     C                   ENDIF                                                              MD022807
      *                                                                                     MD022807
     C                   IF        C_PTYP = 64 OR                                           MD022807
     C                             C_PTYP = 65 OR                                           MD022807
     C                             C_PTYP = 68 OR                                           MD022807
     C                             C_PTYP = 71                                              MD022807
     C                   EVAL      ProcessingType = PartsPurchase                           MD022807
     C                   ELSEIF    C_PTYP = 66 OR                                           MD022807
     C                             C_PTYP = 72                                              MD022807
     C                   EVAL      ProcessingType = PartsSold                               MD022807
     C                   ENDIF                                                              MD022807
      *                                                                                     MD022807
     C                   IF        C_RSTM = 05                                              MD022807
     C                   SELECT                                                             MD022807
     C                   WHEN      ProcessingType = PartsSold                               MD022807
     C                   EVAL      PFldData = %TRIM(C_OSDB) + %TRIM(C_RONS)                 MD022807
     C                   OTHER                                                              MD022807
     C                   EVAL      PFldData = %TRIM(C_OMDB) + %TRIM(C_RONS)                 MD022807
     C                   ENDSL                                                              MD022807
     C                   ELSE                                                               MD022807
     C                   MOVEL     C_RONS        PFldData         21                        MD022807
     C                   ENDIF                                                              MD022807
      *                                                                                     MD022807
      ** Receipt Settlement (RSTM)                                                          MD022807
     C     '<DDRSTM>'    SCAN      LGXMLF        PLoc1                                      MD022807
     C     '</DDRSTM>'   SCAN      LGXMLF        PLoc2                                      MD022807
     C                   EVAL      LGXMLF = %SUBST(LGXMLF:1:PLoc1 + 7)  +  ' ' +            MD022807
     C                                      %SUBST(LGXMLF:  PLoc2)                          MD022807
     C                   MOVEL     C_RSTM        RSTMX             2                        MD022807
     C     '</DDRSTM>'   SCAN      LGXMLF        PLoc                                       MD022807
     C                   IF        PLoc <> 0                                                MD022807
     C                   EVAL      LGXMLF = %SUBST(LGXMLF:1:PLoc-2) +                       MD022807
     C                                      RSTMX  +                                        MD022807
     C                                      %SUBST(LGXMLF:PLoc)                             MD022807
     C                   ENDIF                                                              MD022807
      *                                                                                     MD022807
      ** RONS                                                                               MD022807
     C     '<DDRONX>'    SCAN      LGXMLF        PLoc1                                      MD022807
     C     '</DDRONX>'   SCAN      LGXMLF        PLoc2                                      MD022807
     C                   EVAL      LGXMLF = %SUBST(LGXMLF:1:PLoc1 + 7)  +  ' ' +            MD022807
     C                                      %SUBST(LGXMLF:  PLoc2)                          MD022807
     C     '</DDRONX>'   SCAN      LGXMLF        PLoc                                       MD022807
     C                   IF        PLoc <> 0                                                MD022807
     C                   EVAL      LGXMLF = %SUBST(LGXMLF:1:PLoc-2) +                       MD022807
     C                                      PFldData +                                      MD022807
     C                                      %SUBST(LGXMLF:PLoc)                             MD022807
     C                   ENDIF                                                              MD022807
      *                                                                                     MD022807
     C                   IF        C_PSTM = 05                                              MD022807
     C                   SELECT                                                             MD022807
     C                   WHEN      ProcessingType = PartsSold                               MD022807
     C                   EVAL      PFldData = %TRIM(C_OSDB) + %TRIM(C_PONS)                 MD022807
     C                   OTHER                                                              MD022807
     C                   EVAL      PFldData = %TRIM(C_OMDB) + %TRIM(C_PONS)                 MD022807
     C                   ENDSL                                                              MD022807
     C                   ELSE                                                               MD022807
     C                   MOVEL     C_PONS        PFldData         21                        MD022807
     C                   ENDIF                                                              MD022807
      *                                                                                     MD022807
      ** Pay Settlement (PSTM)                                                              MD022807
     C     '<DDPSTM>'    SCAN      LGXMLF        PLoc1                                      MD022807
     C     '</DDPSTM>'   SCAN      LGXMLF        PLoc2                                      MD022807
     C                   EVAL      LGXMLF = %SUBST(LGXMLF:1:PLoc1 + 7)  +  ' ' +            MD022807
     C                                      %SUBST(LGXMLF:  PLoc2)                          MD022807
     C                   MOVEL     C_PSTM        PSTMX             2                        MD022807
     C     '</DDPSTM>'   SCAN      LGXMLF        PLoc                                       MD022807
     C                   IF        PLoc <> 0                                                MD022807
     C                   EVAL      LGXMLF = %SUBST(LGXMLF:1:PLoc-2) +                       MD022807
     C**********                            PSTMX  +                              MD022807 MD022807E
     C                                      '00'+                                          MD022807E
     C                                      %SUBST(LGXMLF:PLoc)                             MD022807
     C                   ENDIF                                                              MD022807
      *                                                                                     MD022807
      ** PONS                                                                               MD022807
     C     '<DDPONX>'    SCAN      LGXMLF        PLoc1                                      MD022807
     C     '</DDPONX>'   SCAN      LGXMLF        PLoc2                                      MD022807
     C                   EVAL      LGXMLF = %SUBST(LGXMLF:1:PLoc1 + 7)  +  ' ' +            MD022807
     C                                      %SUBST(LGXMLF:  PLoc2)                          MD022807
     C*****'</DDPONX>'   SCAN      LGXMLF        PLoc                             MD022807 MD022807E
     C**********         IF        PLoc <> 0                                      MD022807 MD022807E
     C**********         EVAL      LGXMLF = %SUBST(LGXMLF:1:PLoc-2) +             MD022807 MD022807E
     C**********                            PFldData +                            MD022807 MD022807E
     C**********                            %SUBST(LGXMLF:PLoc)                   MD022807 MD022807E
     C**********         ENDIF                                                    MD022807 MD022807E
      *
     C                   EVAL      LGLOAN = YPLON
     C                   EVAL      LGSTAT = 'S'
      *
     C                   UPDATE    LEMQLGPF
     C**********         ENDIF                                                              MD022807
      *
     C                   ENDSR
      *****************************************************************                    MD021423E
      /EJECT                                                                               MD021423E
      *****************************************************************                    MD021423E
      *                                                               *                    MD021423E
      * SrUpdateLEPDUE - Update LEPDUEPD with PDCL Loans              *                    MD021423E
      *                                                               *                    MD021423E
      * Called by: SRRtvLoan                                          *                    MD021423E
      *                                                               *                    MD021423E
      * Calls: None                                                   *                    MD021423E
      *                                                               *                    MD021423E
      *****************************************************************                    MD021423E
     C     SrUpdateLEPDUEBEGSR                                                             MD021423E
                                                                                           MD021423E
     C                   SETOFF                                       85                   MD021423E
     C     LGFRNT        SETLL     LEPDUEDX                                                MD021423E
     C     *IN85         DOWEQ     *OFF                                                    MD021423E
     C     LGFRNT        READE     LEPDUEDX                               85               MD021423E
     C     *IN85         IFEQ      *OFF                                                    MD021423E
     C                   EVAL      L_YPLON = YPLON                                         MD021423E
     C                   UPDATE    LEPDUEDX                                                MD021423E
     C                   ENDIF                                                             MD021423E
     C                   ENDDO                                                             MD021423E
                                                                                           MD021423E
     C                   ENDSR                                                             MD021423E
      *****************************************************************                    MD021423E
      /EJECT                                                                               MD021423E
      *****************************************************************                    MD021423E
      *                                                               *                    MD021423E
      * SrUpdateLEPDUF - Update LEPDUFPD with PDCL Loans              *                    MD021423E
      *                                                               *                    MD021423E
      * Called by: SRRtvLoan                                          *                    MD021423E
      *                                                               *                    MD021423E
      * Calls: None                                                   *                    MD021423E
      *                                                               *                    MD021423E
      *****************************************************************                    MD021423E
     C     SrUpdateLEPDUFBEGSR                                                             MD021423E
                                                                                           MD021423E
     C                   SETOFF                                       85                   MD021423E
     C     LGFRNT        SETLL     LEPDUFDX                                                MD021423E
     C     *IN85         DOWEQ     *OFF                                                    MD021423E
     C     LGFRNT        READE     LEPDUFDX                               85               MD021423E
     C     *IN85         IFEQ      *OFF                                                    MD021423E
     C                   EVAL      F_YPLON = YPLON                                         MD021423E
     C                   UPDATE    LEPDUFDX                                                MD021423E
     C                   ENDIF                                                             MD021423E
     C                   ENDDO                                                             MD021423E
                                                                                           MD021423E
     C                   ENDSR                                                             MD021423E
      * ***************************************************************                    MD021423E
      /EJECT
      *****************************************************************
      *                                                               *
      * SrSendXML - Send XML Transaction to Message Queue             *
      *                                                               *
      * Called by: Main Processing                                    *
      *                                                               *
      * Calls: GPMQMIO                                                *
      *                                                               *
      *****************************************************************
     C     SrSendXML     BEGSR
      *
      ** Send message to MQ series queue
      *
     C                   EVAL      PRequest = '*OPEN_PUT'
     C                   EXSR      SRPutMQIO
      *
     C                   EVAL      PRequest = '*PUT'
     C                   EXSR      SRPutMQIO
      *
     C                   EVAL      PRequest = '*CLOSE'
     C                   EXSR      SRPutMQIO
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRPutMQIO - Put message to MQ Series queue                   *
      *                                                               *
      * Called by: SRPDCLIN, SRPDCLIN                                 *
      *                                                               *
      * Calls: GPMQMIO                                                *
      *                                                               *
      *****************************************************************
     C     SRPutMQIO     BEGSR
      *
     C                   CALL      'GPMQMIO'
     C                   PARM      *BLANKS       PRetCode
     C                   PARM                    PErrMsg
     C                   PARM                    PRequest
     C                   PARM      PWIPQueue     PQueueNm
     C                   PARM      LGXMLF        PMsgBuf
     C                   PARM                    P@Key
     C                   PARM      WkMQMgr       PMQMgr
      *
     C                   IF        (PRetCode <> *BLANKS) OR
     C                             (PErrMsg <> *BLANKS)
     C                   EXSR      *PSSR
     C                   ENDIF
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * *INZSR - Program Initialisation routine                       *
      *                                                               *
      * Called by: Main processing                                    *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
     C     *INZSR        BEGSR
      *
     C     KLEPDUF       KLIST
     C                   KFLD                    LGCNUM
     C                   KFLD                    LGFACL
     C                   KFLD                    LGORG
     C                   KFLD                    LGSEQ
     C                   KFLD                    LGRECI
      *
     C     KLEPDUE       KLIST
     C                   KFLD                    LGRECI
     C                   KFLD                    LGORG
     C                   KFLD                    LGDCT
      *
     C                   EVAL      POP01 = 'MQTransSdrQueueCOB'
     C                   EVAL      POP02 = 'MQJMSRespQueueCOB'
     C                   EVAL      POP03 = 'MQQueueMgrCOB'
     C                   EVAL      POP04 = 'MQPDPUserIDCOB'
      *
     C                   CALL      'AOSVALR0'
     C                   PARM      *BLANKS       PRetCode
     C                   PARM                    POP01
     C                   PARM      *BLANKS       PVL01
     C                   PARM                    POP02
     C                   PARM      *BLANKS       PVL02
     C                   PARM                    POP03
     C                   PARM      *BLANKS       PVL03
     C                   PARM                    POP04
     C                   PARM      *BLANKS       PVL04
     C                   PARM                    POP05
     C                   PARM      *BLANKS       PVL05
     C                   PARM      *BLANKS       POP06
     C                   PARM      *BLANKS       PVL06
     C                   PARM      *BLANKS       POP07
     C                   PARM      *BLANKS       PVL07
     C                   PARM      *BLANKS       POP08
     C                   PARM      *BLANKS       PVL08
     C                   PARM      *BLANKS       POP09
     C                   PARM      *BLANKS       PVL09
     C                   PARM      *BLANKS       POP10
     C                   PARM      *BLANKS       PVL10
      *
     C                   IF        PRetCode <>  *BLANKS
     C                   MOVEL     'SDSVALPD'    DBFILE
     C                   Z-ADD     1             DBASE                U7U8
     C                   MOVEL     POP01         DBKEY
     C                   EXSR      *PSSR
     C                   ENDIF
      *
     C                   EVAL      PWIPQueue = PVL01
     C                   EVAL      WkRespQ   = PVL02
     C                   EVAL      WkMQMgr   = PVL03
     C                   EVAL      WkUser    = %TRIM(PVL04)
      *                                                                                     MD022807
      ** Full cache SDCURRPD                                                                MD022807
      *                                                                                     MD022807
     C     *LOVAL        SETLL     SDCURRL1                                                 MD022807
     C                   READ      SDCURRL1                                                 MD022807
     C                   DOW       NOT %EOF AND CurrIdx <= %ELEM(CurrCache)                 MD022807
     C                   EVAL      CurrCache(CurrIdx) = A6CYCD                              MD022807
     C                   EVAL      DSCurr(CurrIdx) = SDCURR                                 MD022807
     C                   EVAL      CurrIdx = CurrIdx + 1                                    MD022807
     C                   READ      SDCURRL1                                                 MD022807
     C                   ENDDO                                                              MD022807
     C                   EVAL      TrailIdx = CurrIdx - 1                                   MD022807
      *
     C                   ENDSR
      *****************************************************************                     MD022807
     C/EJECT                                                                                MD022807
      *****************************************************************                     MD022807
      *                                                               *                     MD022807
      * SrChkCurr - Check currency code                               *                     MD022807
      *                                                               *                     MD022807
      * Called by: callPDCL, callLOAMPI                               *                     MD022807
      *                                                               *                     MD022807
      * Calls: AOCURRR0                                               *                     MD022807
      *                                                               *                     MD022807
      *****************************************************************                     MD022807
     C     SrChkCurr     BEGSR                                                              MD022807
      *                                                                                     MD022807
      ** Use details from the array if currency in the cache,                               MD022807
      ** otherwise, retrieve details from Access Object program                             MD022807
      *                                                                                     MD022807
     C                   EVAL      CurrKey = @CURR                                          MD022807
     C                   EVAL      CurrIdx = %LOOKUP( CurrKey :                             MD022807
     C                                                CurrCache :                           MD022807
     C                                                1 : TrailIdx )                        MD022807
     C                   IF        CurrIdx > 0                                              MD022807
     C                   EVAL      SDCURR = DSCurr(CurrIdx)                                 MD022807
     C                   ELSE                                                               MD022807
     C                   CALL      'AOCURRR0'                                               MD022807
     C                   PARM      *BLANK        @RTCD             7                        MD022807
     C                   PARM      '*KEY   '     @OPTN             7                        MD022807
     C                   PARM                    @CURR             3                        MD022807
     C     SDCURR        PARM      SDCURR        DSSDY                                      MD022807
      *                                                                                     MD022807
     C     @RTCD         IFNE      *BLANKS                                                  MD022807
     C                   MOVEL     @CURR         DBKEY                                      MD022807
     C                   MOVEL     'SDCURRPD'    DBFILE                                     MD022807
     C                   MOVEL     '011'         DBASE                                      MD022807
     C                   EXSR      *PSSR                                                    MD022807
     C                   ENDIF                                                              MD022807
     C                   ENDIF                                                              MD022807
      *                                                                                     MD022807
     C                   Z-ADD     A6NBDP        ZDECS                                      MD022807
      *                                                                                     MD022807
     C                   ENDSR                                                              MD022807
      *****************************************************************                     MD022807
     C/EJECT                                                                                MD022807
      *****************************************************************                     MD022807
      *                                                               *                     MD022807
      * SrConvAmt - Convert Amount to Alphanumeric                    *                     MD022807
      *                                                               *                     MD022807
      * Called by: callPDCL, callLOAMPI                               *                     MD022807
      *                                                               *                     MD022807
      * Calls: ZSEDIT                                                 *                     MD022807
      *                                                               *                     MD022807
      *****************************************************************                     MD022807
     C     SrConvAmt     BEGSR                                                              MD022807
     C                   CALL      'ZSEDIT'                                                 MD022807
     C                   PARM                    ZFLD15           15 0                      MD022807
     C                   PARM                    ZDECS             1 0                      MD022807
     C                   PARM      *BLANKS       ZECODE            1                        MD022807
     C                   PARM                    ZOUT21           21                        MD022807
      *                                                                                     MD022807
     C                   ENDSR                                                              MD022807
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * *PSSR  - Program exception error routine                      *
      *          Called automatically if a program error occurs,      *
      *          or directly by the program code using EXSR.          *
      *          This subroutine DUMPs the program just once.         *
      *                                                               *
      * Called by: None                                               *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
     C     *PSSR         BEGSR
      *
     C     @RUN          IFEQ      *BLANK
     C                   MOVE      'Y'           @RUN              1
     C                   DUMP
     C                   CALL      'DBERRCTL'
     C                   END
      *
     C                   SETON                                        U7U8LR
     C                   RETURN
      *
     C                   ENDSR
      ********************************************************************
      /EJECT
      ********************************************************************
