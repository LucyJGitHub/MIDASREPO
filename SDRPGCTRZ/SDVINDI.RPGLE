     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2015')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas SD Validate FATCA Information Complete')         *
      *****************************************************************
      *                                                               *
      *  Midas - Standing Data Module                                 *
      *                                                               *
      *  SDVINDI - Validate FATCA Indicia                             *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2015            *
      *                                                               *
      *  Last Amend No. MD044440           Date 01Mar17               *
      *  Prev Amend No. MD042966           Date 20Dec16               *
      *                 MD036489           Date 11Nov15               *
      *                 MD036460           Date 05Nov15               *
      *                 MD036356           Date 02Nov15               *
      *                 MD035388 *CREATE   Date 20Oct15               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD044440 - Authority Holder System Value not updated upon    *
      *             Customer Insert                                   *
      *  MD042966 - FATCA US Indicia are not updated upon             *
      *             complete                                          *
      *  MD036489 - FATCA Info complete not saved during insert       *
      *  MD036460 - FATCA US Indicia update enhancements              *
      *  MD036356 - Multiple NAHO FATCA fields does not default values*
      *            from Main NAHO/CRS Details                         *
      *  MD035388 - OCBC FATCA - error not prompted when discrepancy  *
      *             between joint account holders. Apply fix MD-27140 *
      *                                                               *
      *****************************************************************
 
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
 
     FSDCTRYL5  IF   E           K DISK    INFSR(*PSSR)
 
     FSDCUSTL1  IF   E           K DISK    INFSR(*PSSR)
 
     FSDCUSXL1  IF   E           K DISK    INFSR(*PSSR)
 
     FSDALTNL1  IF   E           K DISK    INFSR(*PSSR)
 
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
     D***SVAL01*          C                   CONST('FATCAUsTinBirthRqd')                   MD042966
     D***SVAL02*          C                   CONST('FATCADftCLsTakeon')                    MD042966
     D***SVAL03*          C                   CONST('FATCADftCLsNewCustNH')                 MD042966
     D SysVal1         C                   'FATCACountryofTax'                              MD042966
 
     DArrayMax         C                   CONST(999)
     D***IndiciaCount     C                   CONST(11)                                     MD044440
     DIndiciaCount     C                   CONST(12)                                        MD044440
 
      ** Run-time Array for Country Codes with FATCA Flag
     DCtryCodeArr      S              2    DIM(ArrayMax)
 
      ** Data Structure for AOSVALR0 string
     DSVAL1            DS           200
     D***SVAL11*                   1      1                                                 MD042966
 
      ** External data structure for ACUS
     D SDCUXC        E DS                  EXTNAME(SDCUSTXC)
 
      ** External data structure for ACUS
     D***CuACUSScrn    E DS                  EXTNAME(SDACUDPD)                              MD042966
     D**********                           PREFIX(E5:2)                                     MD042966
     D CuACUSScrn    E DS                  EXTNAME(SDCUADPD)                                MD042966
     D                                     PREFIX(E5:2)                                     MD042966
 
 
      ** External data structure for ALTN
     D SDALTN        E DS                  EXTNAME(SDALTNPD)
 
      ** External data structure for SARD
     D SCSARD        E DS                  EXTNAME(SCSARDPD)
 
      ** External data structure for FTNH
     D CuFTCSScrn    E DS                  EXTNAME(SDFTCRPD)
 
      ** Data Structure for Customer Indicia with Overrides
     DCustIndOverDS    DS
     D  FACISV                             LIKE(DDCISV)
     D  FATXSV                             LIKE(DDCISV)
     D  FACDSV                             LIKE(DDCISV)
     D  FATESV                             LIKE(DDCISV)
     D  FAGCSV                             LIKE(DDCISV)
     D  FACBSV                             LIKE(DDCISV)
     D  FAJASV                             LIKE(DDCISV)
     D  FAMCSV                             LIKE(DDCISV)
     D  FARPSV                             LIKE(DDCISV)
     D  FAIDSV                             LIKE(DDCISV)
     D  FAHMSV                             LIKE(DDCISV)
     D  FAAUSV                             LIKE(DDCISV)                                     MD044440
     D  FACIOV                             LIKE(DDCISV)
     D  FATXOV                             LIKE(DDCISV)
     D  FACDOV                             LIKE(DDCISV)
     D  FATEOV                             LIKE(DDCISV)
     D  FAGCOV                             LIKE(DDCISV)
     D  FACBOV                             LIKE(DDCISV)
     D  FAJAOV                             LIKE(DDCISV)
     D  FAMCOV                             LIKE(DDCISV)
     D  FARPOV                             LIKE(DDCISV)
     D  FAIDOV                             LIKE(DDCISV)
     D  FAHMOV                             LIKE(DDCISV)
     D  FAAUOV                             LIKE(DDCISV)                                     MD044440
     D***CustIndiciaDS                  11A   OVERLAY(CustIndOverDS)                        MD044440
     D***CustOverideDS                  11A   OVERLAY(CustIndOverDS:12)                     MD044440
     DCustIndiciaDS                  12A   OVERLAY(CustIndOverDS)                           MD044440
     DCustOverideDS                  12A   OVERLAY(CustIndOverDS:13)                        MD044440
 
     D PAPARM          DS           100                                                     MD036356
     D  PAMODE                 1      1                                                     MD036356
     D  PADOMC                 2      3                                                     MD036356
     D  PACNCZ                 4      5                                                     MD036356
     D  PACSSN                 6     15                                                     MD036356
     D  PACRNM                16     35                                                     MD036356
     D  PACRTN                36     45                                                     MD036356
     D  PAACCZ                46     47                                                     MD036356
     D  PAINSF                48     48                                                     MD036356
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
      ** Parameter variables for AOSVALR0 string                                            MD042966
     D PRtcd           S              7                                                     MD042966
     D SValK1          S             20                                                     MD042966
     D SValK2          S             20                                                     MD042966
     D SVal2           S            200                                                     MD042966
     D SValK3          S             20                                                     MD042966
     D SVal3           S            200                                                     MD042966
     D SValK4          S             20                                                     MD042966
     D SVal4           S            200                                                     MD042966
     D SValK5          S             20                                                     MD042966
     D SVal5           S            200                                                     MD042966
     D SValK6          S             20                                                     MD042966
     D SVal6           S            200                                                     MD042966
     D SValK7          S             20                                                     MD042966
     D SVal7           S            200                                                     MD042966
     D SValK8          S             20                                                     MD042966
     D SVal8           S            200                                                     MD042966
     D SValK9          S             20                                                     MD042966
     D SVal9           S            200                                                     MD042966
     D SValK0          S             20                                                     MD042966
     D SVal10          S            200                                                     MD042966
                                                                                            MD042966
      ** Index for arrays of error message ids etc
     D Idx             S              3P 0
     D WIx             S              3P 0
     D KCUST           S              6A
     D WSysOff         S              2S 0
     D WOvrOff         S              2S 0
     D Index           S              3S 0 INZ(1)
     D KCNUM           S              6A
     D WWCOLC          S              2A                                                    MD042966
     D WWCNCZ          S              2A                                                    MD042966
     D WCTAX           S              2A                                                    MD042966
 
     D PHasIndicia     S              1A
 
      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
      *****************************************************************
      /EJECT
      *****************************************************************
 
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
 
     C                   EVAL      FACISV = DDCISV
     C                   EVAL      FATXSV = DDTXSV
     C                   EVAL      FACDSV = DDCDSV
     C                   EVAL      FATESV = DDTESV
     C                   EVAL      FAGCSV = DDGCSV
     C                   EVAL      FACBSV = DDCBSV
     C                   EVAL      FAJASV = DDJASV
     C                   EVAL      FAMCSV = DDMCSV
     C                   EVAL      FARPSV = DDRPSV
     C                   EVAL      FAIDSV = DDIDSV
     C                   EVAL      FAHMSV = DDHMSV
     C                   EVAL      FAAUSV = DDAUSV                                          MD044440
     C                   EVAL      FACIOV = DDCIOV
     C                   EVAL      FATXOV = DDTXOV
     C                   EVAL      FACDOV = DDCDOV
     C                   EVAL      FATEOV = DDTEOV
     C                   EVAL      FAGCOV = DDGCOV
     C                   EVAL      FACBOV = DDCBOV
     C                   EVAL      FAJAOV = DDJAOV
     C                   EVAL      FAMCOV = DDMCOV
     C                   EVAL      FARPOV = DDRPOV
     C                   EVAL      FAIDOV = DDIDOV
     C                   EVAL      FAHMOV = DDHMOV
     C                   EVAL      FAAUOV = DDAUOV                                          MD044440
 
     C                   EVAL      PHasIndicia = 'N'
     C**********         EVAL      KCNUM = E5CUST                                           MD042966
     C                   EVAL      KCNUM = DDCUST                                           MD042966
 
     C     KCNUM         CHAIN     SDCUSTL1
     C                   IF        NOT %FOUND(SDCUSTL1)                                     MD042966
     C                   EVAL      BBCOLC = PADOMC                                          MD042966
     C                   EVAL      BBCNCZ = PACNCZ                                          MD042966
     C                   ENDIF                                                              MD042966
 
     C     KCNUM         CHAIN     SDCUSXL1
     C                   IF        NOT %FOUND(SDCUSXL1)
     C                   EVAL      SDCUXC = *BLANKS
     C                   ENDIF
 
     C                   EVAL      SDALTN = *BLANKS
 
      ** Do an initial check on the Indicia and Override
      ** Applicable for Amended Customers
     C                   IF        PAINSF <> 'Y'                                            MD036356
     C                   EXSR      SRChkIndicia
     C                   ELSE                                                               MD036489
     C                   IF        DDCISV = 'Y'                                             MD036489
     C                             OR DDTXSV = 'Y'                                          MD036489
     C                             OR DDCDSV = 'Y'                                          MD036489
     C                             OR DDTESV = 'Y'                                          MD036489
     C                             OR DDGCSV = 'Y'                                          MD036489
     C                             OR DDCBSV = 'Y'                                          MD036489
     C                             OR DDJASV = 'Y'                                          MD036489
     C                             OR DDMCSV = 'Y'                                          MD036489
     C                             OR DDRPSV = 'Y'                                          MD036489
     C                             OR DDIDSV = 'Y'                                          MD036489
     C                             OR DDHMSV = 'Y'                                          MD036489
     C                             OR DDAUSV = 'Y'                                          MD044440
     C                   EVAL      PHasIndicia = 'Y'                                        MD036489
     C                   ENDIF                                                              MD036489
     C                   ENDIF                                                              MD036356
 
     C     KCNUM         SETLL     SDALTNL1
     C     KCNUM         READE(N)  SDALTNL1
 
     C                   DOW       NOT %EOF(SDALTNL1)
     C                             OR %LOOKUP(BBCOLC:CtryCodeArr) <> 0
     C                             AND BBCOLC <> *BLANKS
     C                             AND DDCDSV <> 'Y'
 
      ** Check Country of Location/Domicile
     C                   IF        %LOOKUP(BBCOLC:CtryCodeArr) <> 0
     C                             AND BBCOLC <> *BLANKS
     C                             AND DDCDSV <> 'Y'
     C                             OR %LOOKUP(BCCNCD:CtryCodeArr) <> 0
     C                             AND BCCNCD <> *BLANKS
     C                             AND DDCDSV <> 'Y'
     C                   EVAL      PHasIndicia = 'Y'
     C                   EVAL      DDCDSV = 'Y'
 
     C                   ELSE
 
      ** This will allow the change of Indicia Values from 'Y' to 'N' during InsertMD036356 MD042966
     C**********         IF        %LOOKUP(BBCOLC:CtryCodeArr) = 0                 MD036356 MD042966
     C**********                   AND BBCOLC <> *BLANKS                           MD036356 MD042966
     C**********                   AND DDCDSV = 'Y'                                MD036356 MD042966
     C**********                   AND PAINSF = 'Y'                                MD036356 MD042966
     C**********                   OR %LOOKUP(BCCNCD:CtryCodeArr) = 0              MD036356 MD042966
     C**********                   AND BCCNCD <> *BLANKS                           MD036356 MD042966
     C**********                   AND DDCDSV = 'Y'                                MD036356 MD042966
     C**********                   AND PAINSF = 'Y'                                MD036356 MD042966
     C**********         EVAL      DDCDSV = 'N'                                    MD036356 MD042966
     C**********         ENDIF                                                     MD036356 MD042966
                                                                                   MD036356 MD042966
     C     KCNUM         READE(N)  SDALTNL1
 
     C                   ENDIF
 
     C                   ENDDO
 
     C                   IF        DDCDSV =  ' '
     C                   EVAL      DDCDSV = 'N'
     C                   ENDIF
 
      ** This will allow the change of Indicia Values from 'Y' to 'N' during Insert         MD042966
     C                   IF        %LOOKUP(BBCOLC:CtryCodeArr) = 0                          MD042966
     C                             AND BBCOLC <> *BLANKS                                    MD042966
     C                             AND DDCDSV = 'Y'                                         MD042966
     C                             AND PAINSF = 'Y'                                         MD042966
     C                             OR %LOOKUP(BCCNCD:CtryCodeArr) = 0                       MD042966
     C                             AND BCCNCD <> *BLANKS                                    MD042966
     C                             AND DDCDSV = 'Y'                                         MD042966
     C                             AND PAINSF = 'Y'                                         MD042966
     C                   EVAL      DDCDSV = 'N'                                             MD042966
     C                   ENDIF                                                              MD042966
                                                                                            MD042966
      ** Check Country of Citizenship
     C                   IF        %LOOKUP(BBCNCZ:CtryCodeArr) <> 0
     C                             AND BBCNCZ <> *BLANKS
     C                             AND DDCISV <> 'Y'
     C                             OR %LOOKUP(XCACCZ:CtryCodeArr) <> 0
     C                             AND XCACCZ <> *BLANKS
     C                             AND DDCISV <> 'Y'
     C                   EVAL      PHasIndicia = 'Y'
     C                   EVAL      DDCISV = 'Y'
     C                   ENDIF
 
     C                   IF        DDCISV =  ' '
     C                   EVAL      DDCISV = 'N'
     C                   ENDIF
 
      ** This will allow the change of Indicia Values from 'Y' to 'N' during Insert         MD036356
     C                   IF        %LOOKUP(BBCNCZ:CtryCodeArr) = 0                          MD036356
     C                             AND BBCNCZ <> *BLANKS                                    MD036356
     C**********                   AND DDCISV = 'Y'                                MD036356 MD036460
     C**********                   AND PAINSF = 'Y'                                MD036356 MD036460
     C**********                   OR %LOOKUP(XCACCZ:CtryCodeArr) = 0              MD036356 MD036460
     C                             AND %LOOKUP(XCACCZ:CtryCodeArr) = 0                      MD036460
     C                             AND XCACCZ <> *BLANKS                                    MD036356
     C                             AND DDCISV = 'Y'                                         MD036356
     C                             AND PAINSF = 'Y'                                         MD036356
     C                             OR  %LOOKUP(BBCNCZ:CtryCodeArr) = 0                      MD036460
     C                             AND BBCNCZ <> *BLANKS                                    MD036460
     C                             AND XCACCZ = *BLANKS                                     MD036460
     C                             AND DDCISV = 'Y'                                         MD036460
     C                             AND PAINSF = 'Y'                                         MD036460
     C                   EVAL      DDCISV = 'N'                                             MD036356
     C                   ENDIF                                                              MD036356
                                                                                            MD036356
      ** Check Country of Birth
     C                   IF        %LOOKUP(E5BTHC:CtryCodeArr) <> 0
     C                             AND E5BTHC <> *BLANKS
     C                             AND DDCBSV <> 'Y'
     C                   EVAL      PHasIndicia = 'Y'
     C                   EVAL      DDCBSV = 'Y'
     C                   ENDIF
 
     C                   IF        DDCBSV =  ' '
     C                   EVAL      DDCBSV = 'N'
     C                   ENDIF
 
      ** This will allow the change of Indicia Values from 'Y' to 'N' during Insert         MD036356
     C                   IF        %LOOKUP(E5BTHC:CtryCodeArr) = 0                          MD036356
     C                             AND E5BTHC <> *BLANKS                                    MD036356
     C                             AND DDCBSV = 'Y'                                         MD036356
     C                             AND PAINSF = 'Y'                                         MD036356
     C                             OR  E5BTHC = *BLANKS                                     MD036460
     C                             AND DDCBSV = 'Y'                                         MD036460
     C                             AND PAINSF = 'Y'                                         MD036460
     C                   EVAL      DDCBSV = 'N'                                             MD036356
     C                   ENDIF                                                              MD036356
                                                                                            MD036356
      ** Check Identity Documents Issue
     C                   IF        %LOOKUP(E5ISCT:CtryCodeArr) <> 0
     C                             AND E5ISCT <> *BLANKS
     C                             AND DDIDSV <> 'Y'
     C                   EVAL      PHasIndicia = 'Y'
     C                   EVAL      DDIDSV = 'Y'
     C                   ENDIF
 
     C                   IF        DDIDSV =  ' '
     C                   EVAL      DDIDSV = 'N'
     C                   ENDIF
 
      ** This will allow the change of Indicia Values from 'Y' to 'N' during Insert         MD036356
     C                   IF        %LOOKUP(E5ISCT:CtryCodeArr) = 0                          MD036356
     C                             AND E5ISCT <> *BLANKS                                    MD036356
     C                             AND DDIDSV = 'Y'                                         MD036356
     C                             AND PAINSF = 'Y'                                         MD036356
     C                             OR  E5ISCT = *BLANKS                                     MD036460
     C                             AND DDIDSV = 'Y'                                         MD036460
     C                             AND PAINSF = 'Y'                                         MD036460
     C                   EVAL      DDIDSV = 'N'                                             MD036356
     C                   ENDIF                                                              MD036356
                                                                                            MD036356
      ** FATCA Details
 
     C                   IF        %LOOKUP(DDMAIL:CtryCodeArr) <> 0
     C                             AND DDMAIL <> *BLANKS
     C                             AND DDMCSV <> 'Y'
     C                   EVAL      PHasIndicia = 'Y'
     C                   EVAL      DDMCSV = 'Y'
     C                   ENDIF
 
     C                   IF        DDMCSV =  ' '
     C                   EVAL      DDMCSV = 'N'
     C                   ENDIF
 
      ** This will allow the change of Indicia Values from 'Y' to 'N' during Insert         MD036356
     C                   IF        %LOOKUP(DDMAIL:CtryCodeArr) = 0                          MD036356
     C                             AND DDMAIL <> *BLANKS                                    MD036356
     C                             AND DDMCSV = 'Y'                                         MD036356
     C                             AND PAINSF = 'Y'                                         MD036356
     C                             OR  DDMAIL = *BLANKS                                     MD036460
     C                             AND DDMCSV = 'Y'                                         MD036460
     C                             AND PAINSF = 'Y'                                         MD036460
     C                   EVAL      DDMCSV = 'N'                                             MD036356
     C                   ENDIF                                                              MD036356
                                                                                            MD036356
      ** Check Green Card
     C                   IF        DDGREC = 'Y'
     C                             AND DDGCSV <> 'Y'
     C                   EVAL      PHasIndicia = 'Y'
     C                   EVAL      DDGCSV = 'Y'
     C                   ENDIF
 
     C                   IF        DDGCSV =  ' '
     C                   EVAL      DDGCSV = 'N'
     C                   ENDIF
 
      ** This will allow the change of Indicia Values from 'Y' to 'N' during Insert         MD036356
     C                   IF        DDGREC <> 'Y'                                            MD036356
     C                             AND DDGCSV = 'Y'                                         MD036356
     C                             AND PAINSF = 'Y'                                         MD036356
     C                   EVAL      DDGCSV = 'N'                                             MD036356
     C                   ENDIF                                                              MD036356
                                                                                            MD036356
      ** Check Telephone Number
     C                   IF        DDPHON = 'Y'
     C                             AND DDTESV <> 'Y'
     C                   EVAL      PHasIndicia = 'Y'
     C                   EVAL      DDTESV = 'Y'
     C                   ENDIF
 
     C                   IF        DDTESV =  ' '
     C                   EVAL      DDTESV = 'N'
     C                   ENDIF
 
      ** This will allow the change of Indicia Values from 'Y' to 'N' during Insert         MD036356
     C                   IF        DDPHON <> 'Y'                                            MD036356
     C                             AND DDTESV = 'Y'                                         MD036356
     C                             AND PAINSF = 'Y'                                         MD036356
     C                   EVAL      DDTESV = 'N'                                             MD036356
     C                   ENDIF                                                              MD036356
                                                                                            MD036356
     C                   EVAL      WCTAX = SVal1                                            MD042966
     C                   MOVE      *BLANKS       DDUTIN                                     MD042966
     C                   IF        E5TNC5 = WCTAX                                           MD042966
     C                   MOVE      *BLANKS       DDUTIN                                     MD042966
     C                   MOVEL     E5TIN5        DDUTIN                                     MD042966
     C                   ENDIF                                                              MD042966
     C                   IF        E5TNC4 = WCTAX                                           MD042966
     C                   MOVE      *BLANKS       DDUTIN                                     MD042966
     C                   MOVEL     E5TIN4        DDUTIN                                     MD042966
     C                   ENDIF                                                              MD042966
     C                   IF        E5TNC3 = WCTAX                                           MD042966
     C                   MOVE      *BLANKS       DDUTIN                                     MD042966
     C                   MOVEL     E5TIN3        DDUTIN                                     MD042966
     C                   ENDIF                                                              MD042966
     C                   IF        E5TNC2 = WCTAX                                           MD042966
     C                   MOVE      *BLANKS       DDUTIN                                     MD042966
     C                   MOVEL     E5TIN2        DDUTIN                                     MD042966
     C                   ENDIF                                                              MD042966
     C                   IF        BBCOLC = WCTAX                                           MD042966
     C                   MOVE      *BLANKS       DDUTIN                                     MD042966
     C                   MOVEL     E5TINO        DDUTIN                                     MD042966
     C                   ENDIF                                                              MD042966
 
     C                   IF        DDTXSV <> 'Y'
     C                             AND DDUTIN <> *BLANKS
     C                   EVAL      PHasIndicia = 'Y'
     C                   EVAL      DDTXSV = 'Y'
     C                   ENDIF
 
     C                   IF        DDTXSV = ' '
     C                   EVAL      DDTXSV = 'N'
     C                   ENDIF
 
     C                   IF        DDJASV = ' '
     C                   EVAL      DDJASV = 'N'
     C                   ENDIF
                                                                                            MD044440
     C                   IF        DDAUSV = ' '                                             MD044440
     C                   EVAL      DDAUSV = 'N'                                             MD044440
     C                   ENDIF                                                              MD044440
 
     C                   IF        DDHMSV = ' '
     C                   EVAL      DDHMSV = 'N'
     C                   ENDIF
 
     C                   IF        DDRPSV = ' '
     C                   EVAL      DDRPSV = 'N'
     C                   ENDIF
 
     C                   IF        DDTXSV = 'Y'                                             MD036356
     C                             AND DDUTIN = *BLANKS                                     MD036356
     C                             AND PAINSF = 'Y'                                         MD036356
     C                   EVAL      PHasIndicia = 'N'                                        MD036356
     C                   EVAL      DDTXSV = 'N'                                             MD036356
     C                   ENDIF                                                              MD036356
                                                                                            MD036356
      ** RETURN
 
     C                   RETURN
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SrChkCustInd - Check Customer Indicia (SYS and OVR)           *
      *                                                               *
      * Called by: Main                                               *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
 
     C     SrChkIndicia  BEGSR
 
     C                   EVAL      WOvrOff = 1
      ** Check if any override flag has been set on
      ** If any has been set, this needs to get flagged as having indicia
     C                   IF        %SCAN('Y':CustOverideDS) = 0
 
     C                   DOU       WOvrOff > IndiciaCount
     C                             OR  WOvrOff = 0
 
      ** Check any override as 'N' possibly invalidating
      ** system value Indicia
     C                   EVAL      WOvrOff =
     C                               %SCAN('Y':CustIndiciaDS:WOvrOff)
     C                   EVAL      WSysOff = WOvrOff
     C                   IF        WOvrOff <> 0
     C                   EVAL      WSysOff =
     C                               %SCAN('N':CustOverideDS:WSysOff)
     C                   ENDIF
     C
      ** If offsets match, system value has been overriden
     C                   IF        WSysOff <> WOvrOff
     C                             AND WOvrOff <> 0
     C                   EVAL      PHasIndicia = 'Y'
     C                   RETURN
     C                   ENDIF
     C                   IF        WOvrOff <> 0
     C                   EVAL      WOvrOff = WOvrOff + 1
     C                   ENDIF
 
     C                   ENDDO
 
     C                   ELSE
     C                   EVAL      PHasIndicia = 'Y'
     C                   RETURN
     C                   ENDIF
 
     C                   ENDSR
 
      **********************************************************************
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
 
     C                   PARM                    CuACUSScrn
     C                   PARM                    CuFTCSScrn
 
      ** Additional Further Details                                                         MD036356
     C                   PARM                    PAPARM                                     MD036356
 
      ** Output - Indicia Flag
     C                   PARM                    PHasIndicia
 
      ** Build FATCA Country Code array
     C     *LOVAL        SETLL     SDCTRYL5
     C                   READ      SDCTRYL5
 
     C                   DOW       NOT %EOF(SDCTRYL5)
     C                   EVAL      CtryCodeArr(Index) = A4CNCD
     C                   EVAL      Index = Index + 1
     C                   READ      SDCTRYL5
     C                   ENDDO
 
     C                   CALL      'AOSVALR0'                                               MD042966
     C                   PARM      *BLANKS       PRtcd                                      MD042966
     C                   PARM      SysVal1       SValK1                                     MD042966
     C                   PARM                    SVal1                                      MD042966
     C                   PARM                    SValK2                                     MD042966
     C                   PARM                    SVal2                                      MD042966
     C                   PARM                    SValK3                                     MD042966
     C                   PARM                    SVal3                                      MD042966
     C                   PARM                    SValK4                                     MD042966
     C                   PARM                    SVal4                                      MD042966
     C                   PARM                    SValK5                                     MD042966
     C                   PARM                    SVal5                                      MD042966
     C                   PARM                    SValK6                                     MD042966
     C                   PARM                    SVal6                                      MD042966
     C                   PARM                    SValK7                                     MD042966
     C                   PARM                    SVal7                                      MD042966
     C                   PARM                    SValK8                                     MD042966
     C                   PARM                    SVal8                                      MD042966
     C                   PARM                    SValK9                                     MD042966
     C                   PARM                    SVal9                                      MD042966
     C                   PARM                    SValK0                                     MD042966
     C                   PARM                    SVal10                                     MD042966
                                                                                            MD042966
     C                   IF        PRtcd <> *Blanks  AND                                    MD042966
     C                             PRtcd <> '*NRF   '                                       MD042966
     C                   EVAL      DBFILE = 'SDSVALPD'                                      MD042966
     C                   EVAL      DBKEY = SValK1                                           MD042966
     C                   EVAL      DBASE = 902                                              MD042966
     C                   EVAL      DBPGM = 'SDVINDI'                                        MD042966
     C                   EXSR      *PSSR                                                    MD042966
     C                   ENDIF                                                              MD042966
                                                                                            MD042966
     C/COPY ZACPYSRC,DBFIELDS
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      /COPY ZACPYSRC,PSSR_ILE
      *****************************************************************
**  CPY@
(c) Misys International Banking Systems Ltd. 2015
