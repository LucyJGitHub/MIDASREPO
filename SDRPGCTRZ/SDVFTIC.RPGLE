     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2013')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas SD Validate FATCA Information Complete')         *
      *****************************************************************
      *                                                               *
      *  Midas - Standing Data Module                                 *
      *                                                               *
      *  SDVFTIC - Validate FATCA Information Complete                *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2013            *
      *                                                               *
      *  Last Amend No. MD042805           Date 05Jun17               *
      *  Prev Amend No. MD036356           Date 20Oct15               *
      *                 MD035388           Date 20Oct15               *
      *                 MD029837A          Date 22Aug14               *
      *                 MD029837           Date 22Aug14               *
      *                 MD027560           Date 19Jun14               *
      *                 MD026997           Date 29May14               *
      *                 MD026753A          Date 29May14               *
      *                 MD026693A          Date 22May14               *
      *                 MD026693           Date 22May14               *
      *                 MD026554B          Date 22May14               *
      *                 MD026554A          Date 22May14               *
      *                 MD026554           Date 22May14               *
      *                 MD026550           Date 22May14               *
      *                 MD026539           Date 12May14               *
      *                 CGL132   *CREATE   Date 01May13               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD042805  - FBM2.1SP10-FATCA US TIN mandatory - should be    *
      *              optional depending on FATCA customer type        *
      *  MD036356 - Multiple NAHO FATCA fields does not default values*
      *             from Main NAHO/CRS Details                        *
      *  MD035388 - FATCA Screen order rework                         *
      *  MD029837A - OCBC FATCA - cannot set FATCA complete to "Y"    *
      *              during creation of new customer                  *
      *  MD029837 - OCBC FATCA - cannot set FATCA complete to "Y"     *
      *             during creation of new customer                   *
      *           - Apply fix MD027454                                *
      *  MD027560 - Authority Holder Indicia Not Included as valida-  *
      *             tion to FATCA Info Complete Flag                  *
      *  MD026997 - Assume 0 If Creation Date Input is Blank          *
      *  MD026753A - US TIN derived on every validation pass          *
      *  MD026693A - FATCA Info complete flag error                   *
      *  MD026693 - FATCA Info complete flag error                    *
      *  MD026554B - Incorrect Error message and Missing Error Message*
      *              when FATCA Customer Type is J                    *
      *            - Apply fix MD025225 (Reopen)                      *
      *  MD026554A - Incorrect Error message and Missing Error Message*
      *              when FATCA Customer Type is J                    *
      *            - Apply fix MD025225 (Reopen)                      *
      *  MD026554 - Incorrect Error message and Missing Error Message *
      *             when FATCA Customer Type is J                     *
      *           - Apply fix MD025225                                *
      *  MD026550 - Require US TIN when Subject to Reporting is 'Y'   *
      *             for all new FATCA Customers/Non-Account Holders   *
      *  MD026539 - FATCA Information Complete Flag accepts any Value *
      *           - Apply fix MD025270                                *
      *  CGL132 - FATCA Phase 1 - Customers' Identification and       *
      *           Classification - Master                             *
      *                                                               *
      *****************************************************************

      ** +--------------------------------------+                                           MD026554
      ** ¦ F-specs                              ¦                                           MD026554
      ** ¦ =======                              ¦                                           MD026554
      ** +--------------------------------------+                                           MD026554
                                                                                            MD026554
     FSDJACCL1  IF   E           K DISK    INFSR(*PSSR)                                     MD026554
      ** Midas SD Joint A/c Member Details by Joint A/c No./Customer No.                    MD026554
                                                                                            MD026554
     FSDFTCSL1  IF   E           K DISK    INFSR(*PSSR)                                     MD026554
      ** Midas SD FATCA Customer Details retrieval index                                    MD026554
                                                                                            MD026554
     FSDFTNHL1  IF   E           K DISK    INFSR(*PSSR)                                     MD026554
      ** Midas SD FATCA NAHO Details retrieval index                                        MD026554
                                                                                            MD042805
      ** +--------------------------------------+                                           MD042805
      ** ¦ Program Prototypes                   ¦                                           MD042805
      ** ¦ ==================                   ¦                                           MD042805
      ** +--------------------------------------+                                           MD042805
                                                                                            MD042805
     D IsValidate      PR              N                                                    MD042805
                                                                                            MD042805

      *****************************************************************
      ** +--------------------------------------+
      ** ¦ Automatically included D-specs       ¦
      ** ¦ ==============================       ¦
      ** +--------------------------------------+
      **
     D/COPY ZACPYSRC,STD_D_SPEC

      ** The following /COPY includes the MM standard declares:
     D/COPY ZACPYSRC,STDDECLARE

     D/COPY ZACPYSRC,PSDS

     D/COPY ZACPYSRC,ERR_XARRYS

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

      ** Access the System Value
     D SVAL01          C                   CONST('FATCAUsTinBirthRqd')
     D SVAL02          C                   CONST('FATCADftCLsTakeon')
     D SVAL03          C                   CONST('FATCADftCLsNewCustNH')
     D SVAL04          C                   CONST('FATCAEffectStartDate')                    MD026550
     D SVAL05          C                   CONST('FATCACountryofTax')                       MD026693

      ** Data Structure for AOSVALR0 string
     DSVAL1            DS           200
     DSVAL11                   1      1

      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+

      ** Index for arrays of error message ids etc
     D Idx             S              3P 0
     D WIx             S              3P 0
     D WUSRQ           S              1A
     D WFUTIN          S              1A                                                   MD026693A
                                                                                            MD026554
     D WHasInfoCmp     S              1A                                                    MD026554

     D Format          S              1                                                     MD026550
     D WDateDD         S              2A                                                    MD026550
     D WDateMM         S              2A                                                    MD026550
     D WDateYY         S              2A                                                    MD026550
     D WDateYYYY       S              4A                                                    MD026550
     D ErrorFlag       S              1A                                                    MD026550
     D WKCRDT          S              5P 0                                                  MD026550
     D PPCOLC          S              2A                                                    MD026693
     D PPTIN1          S             25A                                                    MD026693
     D PPTNC2          S              2A                                                    MD026693
     D PPTIN2          S             25A                                                    MD026693
     D PPTNC3          S              2A                                                    MD026693
     D PPTIN3          S             25A                                                    MD026693
     D PPTNC4          S              2A                                                    MD026693
     D PPTIN4          S             25A                                                    MD026693
     D PPTNC5          S              2A                                                    MD026693
     D PPTIN5          S             25A                                                    MD026693
     D WCTAX           S              2A                                                    MD026693
      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
      *****************************************************************
      /EJECT
      *****************************************************************
                                                                                           MD026693A
     C                   CALL      'AOSVALR0'                                              MD026693A
     C                   PARM                    @RTCD                                     MD026693A
     C                   PARM      SVAL01        SVALK1           20                       MD026693A
     C                   PARM                    SVAL1           200                       MD026693A
     C                   PARM      SVAL02        SVALK2           20                       MD026693A
     C                   PARM                    SVAL2           200                       MD026693A
     C                   PARM      SVAL03        SVALK3           20                       MD026693A
     C                   PARM                    SVAL3           200                       MD026693A
     C                   PARM      SVAL04        SVALK4           20                       MD026693A
     C                   PARM                    SVAL4           200                       MD026693A
     C                   PARM      SVAL05        SVALK5           20                       MD026693A
     C                   PARM                    SVAL5           200                       MD026693A
     C                   PARM                    SVALK6           20                       MD026693A
     C                   PARM                    SVAL6           200                       MD026693A
     C                   PARM                    SVALK7           20                       MD026693A
     C                   PARM                    SVAL7           200                       MD026693A
     C                   PARM                    SVALK8           20                       MD026693A
     C                   PARM                    SVAL8           200                       MD026693A
     C                   PARM                    SVALK9           20                       MD026693A
     C                   PARM                    SVAL9           200                       MD026693A
     C                   PARM                    SVALK10          20                       MD026693A
     C                   PARM                    SVAL10          200                       MD026693A
                                                                                           MD026693A
      ** If the system value is not found then issue a database error                      MD026693A
     C                   IF        @RTCD <> '*NRF' AND                                     MD026693A
     C                             @RTCD <> *BLANKS                                        MD026693A
                                                                                           MD026693A
     C     *LOCK         IN        LDA                                                     MD026693A
     C                   EVAL      DBFile = 'SDSVALPD'                                     MD026693A
     C                   EVAL      DBase = 001                                             MD026693A
     C                   EVAL      DBKey = SVALK1                                          MD026693A
     C                   OUT       LDA                                                     MD026693A
     C                   EXSR      *PSSR                                                   MD026693A
     C                   ENDIF                                                             MD026693A

      ** Initialization

     C                   MOVE      *BLANK        ReturnCode
     C                   MOVE      *BLANK        FldNamXAr
     C                   MOVE      *BLANK        MsgIDXAr
     C                   MOVE      *BLANK        MsgDtaXAr
     C                   MOVE      *BLANK        WFldNmXAr
     C                   MOVE      *BLANK        WMsgIdXAr
     C                   MOVE      *BLANK        WMsgDtXAr
     C                   Z-ADD     0             Idx
     C                   Z-ADD     0             WIx
     C                   MOVE      'Y'           DDINFCOK
     C                   EVAL      WUSRQ = SVAL11

     C                   IF        DDINFC <> 'Y' AND
     C                             DDINFC <> 'N' AND
     C                             DDINFC <> ' '
     C**********         IF        DDINFC = 'A' AND                                         MD026539
     C                   IF        ( DDINFC = 'A' AND                                       MD026539
     C                             DDINFCO <> 'A'
     C                             ) or DDINFC <> 'A'                                       MD026539
     C                   MOVE      'N'           DDINFCOK
     C                   ADD       1             Idx
     C                   MOVEL     'DDINFC'      FldNamXAr(Idx)
     C                   MOVEL     'USS0188'     MsgIdXAr(Idx)
     C                   ENDIF
     C                   ENDIF
     C                   IF        PHasIndicia = 'N'                                        MD035388
     C                             AND DDREPT <> 'Y'                                        MD035388
     C**********                   AND POrigin = 'C'                               MD035388 MD036356
     C                             AND (POrigin = 'C'                                       MD036356
     C                             OR POrigin = 'N')                                        MD036356
     C                   RETURN                                                             MD035388
     C                   ENDIF                                                              MD035388
                                                                                           MD026753A
     C                   IF        CUSTID = 'C'                                            MD026753A
     C                   EVAL      DDUTIN = *BLANKS                                        MD026753A
     C                   EVAL      WCTAX = SVal5                                           MD026753A
     C                   IF        PPTNC5 = WCTAX                                          MD026753A
     C                   MOVEL     PPTIN5        DDUTIN                                    MD026753A
     C                   ENDIF                                                             MD026753A
     C                   IF        PPTNC4 = WCTAX                                          MD026753A
     C                   MOVEL     PPTIN4        DDUTIN                                    MD026753A
     C                   ENDIF                                                             MD026753A
     C                   IF        PPTNC3 = WCTAX                                          MD026753A
     C                   MOVEL     PPTIN3        DDUTIN                                    MD026753A
     C                   ENDIF                                                             MD026753A
     C                   IF        PPTNC2 = WCTAX                                          MD026753A
     C                   MOVEL     PPTIN2        DDUTIN                                    MD026753A
     C                   ENDIF                                                             MD026753A
     C                   IF        PPCOLC = WCTAX                                          MD026753A
     C                   MOVEL     PPTIN1        DDUTIN                                    MD026753A
     C                   ENDIF                                                             MD026753A
     C                   ENDIF                                                             MD026753A

     C**********         IF        DDINFC = 'Y' AND                                         MD026997
     C**********                   DDINFCO = ' ' OR                                         MD026997
     C**********                   DDINFC = 'Y' AND                                         MD026997
     C**********                   DDINFCO = 'N'
      *                                                                                     MD026997
      ** Validate only when set to 'Y'                                                      MD026997
     C                   IF        DDINFC = 'Y'                                             MD026997

     C                   IF        DDCLAC = *BLANKS

     C                   MOVE      'N'           DDINFCOK
     C                   ADD       1             Idx
     C                   MOVEL     'DDINFC'      FldNamXAr(Idx)
     C**********         MOVEL     'USS0189'     MsgIdXAr(Idx)                              MD026693
     C                   MOVEL     'USS0174'     MsgIdXAr(Idx)                              MD026693

     C                   ENDIF

     C                   IF        DDCLAC = SVAL2 OR
     C                             DDCLAC = SVAL3

     C                   MOVE      'N'           DDINFCOK
     C                   ADD       1             Idx
     C                   MOVEL     'DDINFC'      FldNamXAr(Idx)
     C**********         MOVEL     'USS0189'     MsgIdXAr(Idx)                              MD026693
     C                   MOVEL     'USS0174'     MsgIdXAr(Idx)                              MD026693

     C                   ENDIF

     C                   IF        DDCSTP = ' '

     C                   MOVE      'N'           DDINFCOK
     C                   ADD       1             Idx

     C                   IF        CUSTID = 'C'
     C                   MOVEL     'DDINFC'      FldNamXAr(Idx)
     C                   MOVEL     'USS0180'     MsgIdXAr(Idx)

     C                   ELSE
     C                   MOVEL     'DDINFC'      FldNamXAr(Idx)
     C                   MOVEL     'USS0168'     MsgIdXAr(Idx)

     C                   ENDIF

     C                   ENDIF

     C                   IF        DDCSST = ' ' AND
     C                             DDCSTP <> 'O' AND
     C                             DDCSTP <> 'J' AND                                        MD026554
     C                             DDCSTP <> 'P'

     C                   MOVE      'N'           DDINFCOK
     C                   ADD       1             Idx

     C                   IF        CUSTID = 'C'
     C                   MOVEL     'DDINFC'      FldNamXAr(Idx)
     C                   MOVEL     'USS0181'     MsgIdXAr(Idx)

     C                   ELSE
     C                   MOVEL     'DDINFC'      FldNamXAr(Idx)
     C                   MOVEL     'USS0169'     MsgIdXAr(Idx)

     C                   ENDIF

     C                   ENDIF
                                                                                            MD026554
     C**********         IF        CUSTID = 'C'                                  MD026554A MD026554B
     C                   IF        CUSTID = 'C' AND                                        MD026554B
     C                             DDCSTP = 'J'                                            MD026554B
                                                                                           MD026554A
     C                   EVAL      WHasInfoCmp = *BLANKS                                   MD026554B
                                                                                           MD026554B
      ** Read through Joint account members of the Customer                                 MD026554
     C     DDCUST        SETLL     SDJACCD0                                                 MD026554
     C     DDCUST        READE     SDJACCD0                                                 MD026554
                                                                                            MD026554
     C                   DOW       NOT %EOF (SDJACCL1)                                      MD026554
     C                             AND WHasInfoCmp <> 'N'                                   MD026554
                                                                                            MD026554
      ** Customer Member                                                                    MD026554
     C                   IF        JCCUST <> *BLANKS                                        MD026554
     C     JCCUST        CHAIN     SDFTCSL1                                                 MD026554
                                                                                            MD026554
     C                   IF        %FOUND(SDFTCSL1) AND FAINFC = 'N'                        MD026554
     C                             OR %FOUND(SDFTCSL1)                                     MD026554A
     C                             AND FAINFC = *BLANKS                                    MD026554A
                                                                                            MD026554
     C                   EVAL      WHasInfoCmp = 'N'                                        MD026554
     C                   MOVE      'N'           DDINFCOK                                   MD026554
     C                   ADD       1             Idx                                        MD026554
     C                   MOVEL     'DDINFC'      FldNamXAr(Idx)                             MD026554
     C                   MOVEL     'USS0494'     MsgIdXAr(Idx)                              MD026554
                                                                                            MD026554
     C                   ENDIF                                                              MD026554
     C                   ENDIF                                                              MD026554
                                                                                            MD026554
      ** NAHO Member                                                                        MD026554
     C                   IF        JCNAHO <> *BLANKS                                        MD026554
     C     JCNAHO        CHAIN     SDFTNHL1                                                 MD026554
                                                                                            MD026554
     C                   IF        %FOUND(SDFTNHL1) AND FNINFC = 'N'                        MD026554
     C                             OR %FOUND(SDFTNHL1)                                     MD026554A
     C                             AND FNINFC = *BLANKS                                    MD026554A
                                                                                            MD026554
     C                   EVAL      WHasInfoCmp = 'N'                                        MD026554
     C                   MOVE      'N'           DDINFCOK                                   MD026554
     C                   ADD       1             Idx                                        MD026554
     C                   MOVEL     'DDINFC'      FldNamXAr(Idx)                             MD026554
     C                   MOVEL     'USS0494'     MsgIdXAr(Idx)                              MD026554
                                                                                            MD026554
     C                   ENDIF                                                              MD026554
     C                   ENDIF                                                              MD026554
                                                                                            MD026554
     C     DDCUST        READE     SDJACCD0                                                 MD026554
     C                   ENDDO                                                              MD026554
                                                                                           MD026554A
     C                   ENDIF                                                             MD026554A

     C                   IF        DDCSTP = 'F' AND
     C                             DDCSST = 'UN' OR
     C                             DDCSTP = 'N' AND
     C                             DDCSST = 'UN'

     C                   MOVE      'N'           DDINFCOK
     C                   ADD       1             Idx

     C                   IF        CUSTID = 'C'
     C                   MOVEL     'DDINFC'      FldNamXAr(Idx)
     C                   MOVEL     'USS0395'     MsgIdXAr(Idx)

     C                   ELSE
     C                   MOVEL     'DDINFC'      FldNamXAr(Idx)
     C                   MOVEL     'USS0170'     MsgIdXAr(Idx)

     C                   ENDIF

     C                   ENDIF

     C                   IF        DDAUSV = '  '                                            MD027560
     C                             AND PIsNew = 'N'                                        MD029837A
                                                                                            MD027560
     C                   MOVE      'N'           DDINFCOK                                   MD027560
     C                   ADD       1             Idx                                        MD027560
     C                   MOVEL     'DDINFC'      FldNamXAr(Idx)                             MD027560
     C                   MOVEL     'USS0504'     MsgIdXAr(Idx)                              MD027560
                                                                                            MD027560
     C                   ENDIF                                                              MD027560
                                                                                            MD027560
     C                   IF        DDMAIL = '  '

     C                   MOVE      'N'           DDINFCOK
     C                   ADD       1             Idx
     C                   MOVEL     'DDINFC'      FldNamXAr(Idx)
     C                   MOVEL     'USS0183'     MsgIdXAr(Idx)

     C                   ENDIF

     C                   IF        DDPHON = ' '

     C                   MOVE      'N'           DDINFCOK
     C                   ADD       1             Idx
     C                   MOVEL     'DDINFC'      FldNamXAr(Idx)
     C                   MOVEL     'USS0184'     MsgIdXAr(Idx)

     C                   ENDIF

     C                   IF        DDGREC = ' '

     C                   MOVE      'N'           DDINFCOK
     C                   ADD       1             Idx
     C                   MOVEL     'DDINFC'      FldNamXAr(Idx)
     C                   MOVEL     'USS0182'     MsgIdXAr(Idx)

     C                   ENDIF

     C                   IF        DDCISV = ' '
     C                             AND PIsNew = 'N'                                         MD027454

     C                   MOVE      'N'           DDINFCOK
     C                   ADD       1             Idx
     C                   MOVEL     'DDINFC'      FldNamXAr(Idx)
     C                   MOVEL     'USS0186'     MsgIdXAr(Idx)

     C                   ENDIF

     C                   IF        DDTXSV = ' '
     C                             AND PIsNew = 'N'                                         MD027454

     C                   MOVE      'N'           DDINFCOK
     C                   ADD       1             Idx
     C                   MOVEL     'DDINFC'      FldNamXAr(Idx)
     C                   MOVEL     'USS0187'     MsgIdXAr(Idx)

     C                   ENDIF

     C                   IF        DDCDSV = ' '
     C                             AND PIsNew = 'N'                                         MD027454

     C                   MOVE      'N'           DDINFCOK
     C                   ADD       1             Idx
     C                   MOVEL     'DDINFC'      FldNamXAr(Idx)
     C                   MOVEL     'USS0159'     MsgIdXAr(Idx)

     C                   ENDIF

     C                   IF        DDTESV = ' '
     C                             AND PIsNew = 'N'                                         MD027454

     C                   MOVE      'N'           DDINFCOK
     C                   ADD       1             Idx
     C                   MOVEL     'DDINFC'      FldNamXAr(Idx)
     C                   MOVEL     'USS0160'     MsgIdXAr(Idx)

     C                   ENDIF

     C                   IF        DDGCSV = ' '
     C                             AND PIsNew = 'N'                                         MD027454

     C                   MOVE      'N'           DDINFCOK
     C                   ADD       1             Idx
     C                   MOVEL     'DDINFC'      FldNamXAr(Idx)
     C                   MOVEL     'USS0161'     MsgIdXAr(Idx)

     C                   ENDIF

     C                   IF        DDCBSV = ' '
     C                             AND PIsNew = 'N'                                         MD027454

     C                   MOVE      'N'           DDINFCOK
     C                   ADD       1             Idx
     C                   MOVEL     'DDINFC'      FldNamXAr(Idx)
     C                   MOVEL     'USS0162'     MsgIdXAr(Idx)

     C                   ENDIF

     C                   IF        DDJASV = ' '
     C                             AND PIsNew = 'N'                                         MD027454

     C                   MOVE      'N'           DDINFCOK
     C                   ADD       1             Idx
     C                   MOVEL     'DDINFC'      FldNamXAr(Idx)
     C                   MOVEL     'USS0163'     MsgIdXAr(Idx)

     C                   ENDIF

     C                   IF        DDHMSV = ' '
     C                             AND PIsNew = 'N'                                         MD027454

     C                   MOVE      'N'           DDINFCOK
     C                   ADD       1             Idx
     C                   MOVEL     'DDINFC'      FldNamXAr(Idx)
     C                   MOVEL     'USS0164'     MsgIdXAr(Idx)

     C                   ENDIF

     C                   IF        DDRPSV = ' '
     C                             AND PIsNew = 'N'                                         MD027454

     C                   MOVE      'N'           DDINFCOK
     C                   ADD       1             Idx
     C                   MOVEL     'DDINFC'      FldNamXAr(Idx)
     C                   MOVEL     'USS0165'     MsgIdXAr(Idx)

     C                   ENDIF

     C                   IF        DDMCSV = ' '
     C                             AND PIsNew = 'N'                                         MD027454

     C                   MOVE      'N'           DDINFCOK
     C                   ADD       1             Idx
     C                   MOVEL     'DDINFC'      FldNamXAr(Idx)
     C                   MOVEL     'USS0166'     MsgIdXAr(Idx)

     C                   ENDIF

     C                   IF        DDIDSV = ' '
     C                             AND PIsNew = 'N'                                         MD027454

     C                   MOVE      'N'           DDINFCOK
     C                   ADD       1             Idx
     C                   MOVEL     'DDINFC'      FldNamXAr(Idx)
     C                   MOVEL     'USS0167'     MsgIdXAr(Idx)

     C                   ENDIF

     C                   IF        DDEXEM = ' '
     C                             AND PIsNew = 'N'                                         MD027454

     C                   MOVE      'N'           DDINFCOK
     C                   ADD       1             Idx
     C                   MOVEL     'DDINFC'      FldNamXAr(Idx)
     C                   MOVEL     'USS0175'     MsgIdXAr(Idx)

     C                   ENDIF

     C                   IF        DDHVAC = ' '

     C                   MOVE      'N'           DDINFCOK
     C                   ADD       1             Idx
     C                   MOVEL     'DDINFC'      FldNamXAr(Idx)
     C                   MOVEL     'USS0176'     MsgIdXAr(Idx)

     C                   ENDIF

     C                   IF        DDREPT = ' '

     C                   MOVE      'N'           DDINFCOK
     C                   ADD       1             Idx
     C                   MOVEL     'DDINFC'      FldNamXAr(Idx)
     C                   MOVEL     'USS0394'     MsgIdXAr(Idx)

     C                   ENDIF
      **********                                                                  MD026693 MD026753A
     C**********         IF        CUSTID = 'C'                                   MD026693 MD026753A
     C**********         EVAL      DDUTIN = *BLANKS                               MD026693 MD026753A
     C**********         EVAL      WCTAX = SVal5                                  MD026693 MD026753A
     C**********         IF        PPTNC5 = WCTAX                                 MD026693 MD026753A
     C**********         MOVEL     PPTIN5        DDUTIN                           MD026693 MD026753A
     C**********         ENDIF                                                    MD026693 MD026753A
     C**********         IF        PPTNC4 = WCTAX                                 MD026693 MD026753A
     C**********         MOVEL     PPTIN4        DDUTIN                           MD026693 MD026753A
     C**********         ENDIF                                                    MD026693 MD026753A
     C**********         IF        PPTNC3 = WCTAX                                 MD026693 MD026753A
     C**********         MOVEL     PPTIN3        DDUTIN                           MD026693 MD026753A
     C**********         ENDIF                                                    MD026693 MD026753A
     C**********         IF        PPTNC2 = WCTAX                                 MD026693 MD026753A
     C**********         MOVEL     PPTIN2        DDUTIN                           MD026693 MD026753A
     C**********         ENDIF                                                    MD026693 MD026753A
     C**********         IF        PPCOLC = WCTAX                                 MD026693 MD026753A
     C**********         MOVEL     PPTIN1        DDUTIN                           MD026693 MD026753A
     C**********         ENDIF                                                    MD026693 MD026753A
     C**********         ENDIF                                                    MD026693 MD026753A
      *                                                                                     MD026693
      ** If Creation Date is past FATCA Effective Date, US TIN is required                  MD026693
      ** when Subject to Reporting is 'Y'                                                   MD026693
      *                                                                                     MD026693
      *                                                                                     MD042805
      ** Call a subroutine that would check if further validation to TIN and                MD042805
      ** or Date/Town of Birth is needed                                                    MD042805
      *                                                                                     MD042805
     C                   IF        IsValidate                                               MD042805
      ** Convert FATCA Effective Date to day number                                         MD026693
     C                   MOVEL     SVAL4         PDate             6                        MD026693
     C                   Z-ADD     0             PDayNo            5 0                      MD026693
     C                   EVAL      ZDATEA = PDate                                           MD026693
     C                   EXSR      ZDATE1                                                   MD026693
     C                   EVAL      PDayNo = ZDAYNO                                          MD026693
                                                                                            MD026693
      ** Convert Creation Date to day number                                                MD026693
     C                   EXSR      TODYNO                                                   MD026693
     C                   EVAL      WKCRDT = ZDAYNO                                          MD026693
     C                                                                                      MD026693
     C                   EVAL      WFUTIN = ' '                                            MD026693A
     C                   IF        WKCRDT >= PDayNo                                         MD026693
     C                             and DDREPT = 'Y'                                         MD026693
     C                             and DDUTIN = *BLANKS                                     MD026693
     C                   EVAL      WFUTIN = 'Y'                                            MD026693A
     C                   MOVE      'N'           DDINFCOK                                   MD026693
     C                   ADD       1             Idx                                        MD026693
     C                   MOVEL     'DDINFC'      FldNamXAr(Idx)                             MD026693
     C                   MOVEL     'USS0177'     MsgIdXAr(Idx)                              MD026693
     C                   ENDIF                                                              MD026693

     C                   IF        WUSRQ <> *BLANK

     C                   IF        WUSRQ = 'B' AND
     C**********                   DDCBTH = *BLANK                                          MD026693
     C                             DDDBTH = *BLANK                                          MD026693
     C
     C                   MOVE      'N'           DDINFCOK
     C                   ADD       1             Idx
     C                   MOVEL     'DDINFC'      FldNamXAr(Idx)
     C                   MOVEL     'USS0178'     MsgIdXAr(Idx)
     C                   ENDIF

     C                   IF        WUSRQ = 'B' AND
     C                             DDBTHT = *BLANK
     C
     C                   MOVE      'N'           DDINFCOK
     C                   ADD       1             Idx
     C                   MOVEL     'DDINFC'      FldNamXAr(Idx)
     C                   MOVEL     'USS0179'     MsgIdXAr(Idx)
     C                   ENDIF

     C                   IF        WUSRQ = 'U' AND
     C                             WFUTIN = ' ' AND                                        MD026693A
     C                             DDUTIN = *BLANK
     C                   MOVE      'N'           DDINFCOK
     C                   ADD       1             Idx
     C                   MOVEL     'DDINFC'      FldNamXAr(Idx)
     C                   MOVEL     'USS0177'     MsgIdXAr(Idx)
     C                   ENDIF

     C                   IF        WUSRQ = 'Y' AND
     C                             WFUTIN = ' ' AND                                        MD026693A
     C                             DDUTIN = *BLANK
     C                   MOVE      'N'           DDINFCOK
     C                   ADD       1             Idx
     C                   MOVEL     'DDINFC'      FldNamXAr(Idx)
     C                   MOVEL     'USS0177'     MsgIdXAr(Idx)
     C                   ENDIF

     C                   IF        WUSRQ = 'Y' AND
     C**********                   DDCBTH = *BLANK                                          MD026693
     C                             DDDBTH = *BLANK                                          MD026693
     C                   MOVE      'N'           DDINFCOK
     C                   ADD       1             Idx
     C                   MOVEL     'DDINFC'      FldNamXAr(Idx)
     C                   MOVEL     'USS0178'     MsgIdXAr(Idx)
     C                   ENDIF

     C                   IF        WUSRQ = 'Y' AND
     C                             DDBTHT = *BLANK
     C                   MOVE      'N'           DDINFCOK
     C                   ADD       1             Idx
     C                   MOVEL     'DDINFC'      FldNamXAr(Idx)
     C                   MOVEL     'USS0179'     MsgIdXAr(Idx)
     C                   ENDIF

     C                   IF        DDRPTT = 'U'
     C                   MOVE      'N'           DDINFCOK
     C                   ADD       1             Idx
     C                   MOVEL     'DDINFC'      FldNamXAr(Idx)
     C                   MOVEL     'USS0185'     MsgIdXAr(Idx)
     C                   ENDIF

      *                                                                                     MD026550
      ** If Creation Date is past FATCA Effective Date, US TIN is required                  MD026550
      ** when Subject to Reporting is 'Y'                                                   MD026550
      *                                                                                     MD026550
      ** Convert FATCA Effective Date to day number                                         MD026550
     C**********         MOVEL     SVAL4         PDate             6               MD026550 MD026693
     C**********         Z-ADD     0             PDayNo            5 0             MD026550 MD026693
     C**********         EVAL      ZDATEA = PDate                                  MD026550 MD026693
     C**********         EXSR      ZDATE1                                          MD026550 MD026693
     C**********         EVAL      PDayNo = ZDAYNO                                 MD026550 MD026693
                                                                                            MD026550
      ** Convert Creation Date to day number                                                MD026550
     C**********         EXSR      TODYNO                                          MD026550 MD026693
     C**********         EVAL      WKCRDT = ZDAYNO                                 MD026550 MD026693
     C                                                                                      MD026550
     C**********         IF        WKCRDT >= PDayNo                                MD026550 MD026693
     C**********                   and DDREPT = 'Y'                                MD026550 MD026693
     C**********                   and DDUTIN = *BLANKS                            MD026550 MD026693
     C**********         MOVE      'N'           DDINFCOK                          MD026550 MD026693
     C**********         ADD       1             Idx                               MD026550 MD026693
     C**********         MOVEL     'DDINFC'      FldNamXAr(Idx)                    MD026550 MD026693
     C**********         MOVEL     'USS0177'     MsgIdXAr(Idx)                     MD026550 MD026693
     C**********         ENDIF                                                     MD026550 MD026693
     C                                                                                      MD026550
     C                   ENDIF
     C
     C                   ENDIF                                                              MD042805
     C                   ENDIF

     C                   IF        Idx = 0
     C                   EVAL      DFINFC = DDINFC
     C                   ENDIF

      ** RETURN

     C                   RETURN

      *****************************************************************                     MD026550
      /EJECT                                                                                MD026550
      *****************************************************************                     MD026550
      *                                                               *                     MD026550
      * TODYNO - Convert character date to Run Day Number             *                     MD026550
      *                                                               *                     MD026550
      *****************************************************************                     MD026550
                                                                                            MD026550
     C     TODYNO        BEGSR                                                              MD026550
      ** Check if date contains all numeric characters                                      MD026550
     C                   TESTN                   DDCRDT               25  26                MD026550
                                                                                            MD026550
     C                   IF        %len(%trim(DDCRDT)) > 6                                  MD026997
      ** If creation date contains all numeric characters                                   MD026550
     C                   IF        *IN25 = *ON                                              MD026550
                                                                                            MD026550
     C**********         IF        %len(%trim(DDCRDT)) > 6                         MD026550 MD026997
      ** Convert creation date to 6 long date                                               MD026550
     C                   EVAL      WDateYY = %SubSt(DDCRDT:7:2)                             MD026550
     C                   EVAL      WDateYYYY = %SubSt(DDCRDT:5:4)                           MD026550
                                                                                            MD026550
     C                   IF        Format = 'D'                                             MD026550
     C                   EVAL      WDateDD = %SubSt(DDCRDT:1:2)                             MD026550
     C                   EVAL      WDateMM = %SubSt(DDCRDT:3:2)                             MD026550
     C                   EVAL      ZDATEA  = WDateDD + WDateMM + WDateYY                    MD026550
     C                   ELSE                                                               MD026550
     C                   EVAL      WDateMM = %SubSt(DDCRDT:1:2)                             MD026550
     C                   EVAL      WDateDD = %SubSt(DDCRDT:3:2)                             MD026550
     C                   EVAL      ZDATEA  = WDateMM + WDateDD + WDateYY                    MD026550
     C                   ENDIF                                                              MD026550
     C                   ENDIF                                                              MD026997
     C                   ELSE                                                               MD026550
     C                   EVAL      ZDATEA  = DDCRDT                                         MD026550
     C                   ENDIF                                                              MD026550
                                                                                            MD026550
      ** Convert 6 long date to Midas day number                                            MD026550
     C                   EXSR      ZDATE1                                                   MD026550
                                                                                            MD026550
     C**********         ENDIF                                                     MD026550 MD026997
      ** If Blank, assume 0                                                                 MD026997
     C                   IF        %trim(DDCRDT) = *BLANKS                                  MD026997
     C                   EVAL      ZDAYNO = 0                                               MD026997
     C                   ENDIF                                                              MD026997
     C                   ENDSR                                                              MD026550
      *****************************************************************                     MD026550
      /EJECT                                                                                MD026550
      *****************************************************************                     MD026550
      *                                                               *                     MD026550
      *  ZDATE1 - Validate & convert date to a day number             *                     MD026550
      *                                                               *                     MD026550
      *****************************************************************                     MD026550
     C     ZDATE1        BEGSR                                                              MD026550
                                                                                            MD026550
     C                   CALLB     'ZDATE1'                                                 MD026550
     C                   PARM                    ZDATEA            6                        MD026550
     C                   PARM                    ZDAYNO            5 0                      MD026550
     C                   PARM                    Format            1                        MD026550
     C                   PARM                    ErrorFlag         1                        MD026550
                                                                                            MD026550
     C                   ENDSR                                                              MD026550
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * *INZSR - Program Initialisation routine                       *
      *                                                               *
      *****************************************************************

     C     *INZSR        BEGSR

     C     *ENTRY        PLIST

      ** Return Code
     C                   PARM                    ReturnCode

     C                   PARM                    DDINFC            1
     C                   PARM                    DDINFCO           1
     C                   PARM                    DDGREC            1
     C                   PARM                    DDMAIL            2
     C                   PARM                    DDPHON            1
     C                   PARM                    DDCLAC            5
     C                   PARM                    DDCSTP            1
     C                   PARM                    DDCSST            2
     C                   PARM                    DDCISV            1
     C                   PARM                    DDCIOV            1
     C                   PARM                    DDTXSV            1
     C                   PARM                    DDTXOV            1
     C                   PARM                    DDCDSV            1
     C                   PARM                    DDCDOV            1
     C                   PARM                    DDTESV            1
     C                   PARM                    DDTEOV            1
     C                   PARM                    DDGCSV            1
     C                   PARM                    DDGCOV            1
     C                   PARM                    DDCBSV            1
     C                   PARM                    DDCBOV            1
     C                   PARM                    DDJASV            1
     C                   PARM                    DDJAOV            1
     C                   PARM                    DDHMSV            1
     C                   PARM                    DDHMOV            1
     C                   PARM                    DDRPSV            1
     C                   PARM                    DDRPOV            1
     C                   PARM                    DDIDSV            1
     C                   PARM                    DDIDOV            1
     C                   PARM                    DDMCSV            1
     C                   PARM                    DDMCOV            1
     C                   PARM                    DDEXEM            1
     C                   PARM                    DDHVAC            1
     C                   PARM                    DDUTIN           25
     C**********         PARM                    DDCBTH            2                        MD026693
     C                   PARM                    DDDBTH            8                        MD026693
     C                   PARM                    DDBTHT           35
     C                   PARM                    DDREPT            1
     C                   PARM                    DDRPTT            1
     C                   PARM                    CUSTID            1
     C                   PARM                    DDCRDT            8                        MD026550
     C                   PARM                    Format            1                        MD026550
     C                   PARM                    DDCUST            6                        MD026554
     C                   PARM                    PPCOLC                                     MD026693
     C                   PARM                    PPTIN1                                     MD026693
     C                   PARM                    PPTNC2                                     MD026693
     C                   PARM                    PPTIN2                                     MD026693
     C                   PARM                    PPTNC3                                     MD026693
     C                   PARM                    PPTIN3                                     MD026693
     C                   PARM                    PPTNC4                                     MD026693
     C                   PARM                    PPTIN4                                     MD026693
     C                   PARM                    PPTNC5                                     MD026693
     C                   PARM                    PPTIN5                                     MD026693
     C                   PARM                    DDAUSV            1                        MD027560
     C                   PARM                    PHasIndicia       1                        MD035388
     C                   PARM                    POrigin           1                        MD035388

      ** Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr

      ** Warning fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    WFldNmXAr
     C                   PARM                    WMsgIdXAr
     C                   PARM                    WMsgDtXAr

      ** FATCA Information complete - OK
     C                   PARM                    DDINFCOK          1
     C                   PARM                    DFINFC            1
                                                                                            MD027454
      ** Flag to say if this is an insert of a customer                                     MD027454
      ** after FATCA effective date                                                         MD027454
     C                   PARM                    PIsNew            1                        MD027454

     C**********         CALL      'AOSVALR0'                                              MD026693A
     C**********         PARM                    @RTCD                                     MD026693A
     C**********         PARM      SVAL01        SVALK1           20                       MD026693A
     C**********         PARM                    SVAL1           200                       MD026693A
     C**********         PARM      SVAL02        SVALK2           20                       MD026693A
     C**********         PARM                    SVAL2           200                       MD026693A
     C**********         PARM      SVAL03        SVALK3           20                       MD026693A
     C**********         PARM                    SVAL3           200                       MD026693A
     C**********         PARM                    SVALK4           20                        MD026550
     C**********         PARM      SVAL04        SVALK4           20                        MD026550
     C**********         PARM                    SVAL4           200                       MD026693A
     C**********         PARM                    SVALK5           20                        MD026693
     C**********         PARM      SVAL05        SVALK5           20                        MD026693
     C**********         PARM                    SVAL5           200                       MD026693A
     C**********         PARM                    SVALK6           20                       MD026693A
     C**********         PARM                    SVAL6           200                       MD026693A
     C**********         PARM                    SVALK7           20                       MD026693A
     C**********         PARM                    SVAL7           200                       MD026693A
     C**********         PARM                    SVALK8           20                       MD026693A
     C**********         PARM                    SVAL8           200                       MD026693A
     C**********         PARM                    SVALK9           20                       MD026693A
     C**********         PARM                    SVAL9           200                       MD026693A
     C**********         PARM                    SVALK10          20                       MD026693A
     C**********         PARM                    SVAL10          200                       MD026693A

      ** If the system value is not found then issue a database error
     C**********         IF        @RTCD <> '*NRF' AND                                     MD026693A
     C**********                   @RTCD <> *BLANKS                                        MD026693A

     C******LOCK         IN        LDA                                                     MD026693A
     C**********         EVAL      DBFile = 'SDSVALPD'                                     MD026693A
     C**********         EVAL      DBase = 001                                             MD026693A
     C**********         EVAL      DBKey = SVALK1                                          MD026693A

     C**********         OUT       LDA                                                     MD026693A
     C**********         EXSR      *PSSR                                                   MD026693A
     C**********         ENDIF                                                             MD026693A

     C/COPY ZACPYSRC,DBFIELDS

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      /COPY ZACPYSRC,PSSR_ILE
      *****************************************************************
      *****************************************************************                     MD042805
      /EJECT                                                                                MD042805
      *****************************************************************                     MD042805
      *                                                               *                     MD042805
      *  CheckValidate - Check if a particular customer needs valida- *                     MD042805
      *                  tion of TIN and Date/Town of Birth           *                     MD042805
      *                                                               *                     MD042805
      *****************************************************************                     MD042805
     P  IsValidate     B                                                                    MD042805
     D  IsValidate     PI              N                                                    MD042805
      /free                                                                                 MD042805
                  if  (PHasIndicia = 'Y' or DDREPT = 'Y') and
                      (not( DDEXEM = 'Y' ) and not( DDCSTP = 'F' )
                      or (not( DDEXEM = 'Y' ) and (DDCSTP = 'F' )
                      and not(DDCSST='PO' or DDCSST = 'PW' or
                      DDCSST = 'PS')));
                      Return *On;
                  else;
                      Return *Off;
                  endif;
      /end-free                                                                             MD042805
     P  IsValidate     E                                                                    MD042805
      *****************************************************************                     MD042805
      /EJECT                                                                                MD042805
      *****************************************************************                     MD042805
**  CPY@
(c) Misys International Banking Systems Ltd. 2013
