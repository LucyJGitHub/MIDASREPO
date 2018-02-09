     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2015')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas SD Validate FATCA Information Complete')         *
      *****************************************************************
      *                                                               *
      *  Midas - Standing Data Module                                 *
      *                                                               *
      *  SDVINDI - Validate FATCA Indicia                             *
      *                                                               *
      *  (c) Finastra International Limited 2015                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      *  Prev Amend No. MD043147           Date 03Jan17               *
      *                 MD036489           Date 11Nov15               *
      *                 MD036460           Date 05Nov15               *
      *                 MD036356 *CREATE   Date 20Oct15               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  MD043147 - US account authority holder indicia is not        *
      *             updated from insert like other US Indicia         *
      *             system values                                     *
      *  MD036489 - FATCA Info complete not saved during insert       *
      *  MD036460 - FATCA US Indicia update enhancements              *
      *  MD036356 - Multiple NAHO FATCA fields does not default values*
      *             from Main NAHO/CRS Details                        *
      *                                                               *
      *****************************************************************
 
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
 
     FSDCTRYL5  IF   E           K DISK    INFSR(*PSSR)
 
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
     DArrayMax         C                   CONST(999)
     D***IndiciaCount     C                   CONST(11)                                     MD043147
     DIndiciaCount     C                   CONST(12)                                        MD043147
 
      ** Run-time Array for Country Codes with FATCA Flag
     DCtryCodeArr      S              2    DIM(ArrayMax)
 
      ** Data Structure for AOSVALR0 string
     DSVAL1            DS           200
     DSVAL11                   1      1
 
      ** External data structure for ACUS
     D CuNAHOVald    E DS                  EXTNAME(SDVNAHLPD)
 
      ** External data structure for SARD
     D SCSARD        E DS                  EXTNAME(SCSARDPD)
 
      ** External data structure for FTNH
     D CuFTNHScrn    E DS                  EXTNAME(SDFTNRPD)
 
      ** Data Structure for non-acct holder Indicia with Overrides
     DNahoIndOverDS    DS
     D  FNCISV                             LIKE(DDCISV)
     D  FNTXSV                             LIKE(DDCISV)
     D  FNCDSV                             LIKE(DDCISV)
     D  FNTESV                             LIKE(DDCISV)
     D  FNGCSV                             LIKE(DDCISV)
     D  FNCBSV                             LIKE(DDCISV)
     D  FNJASV                             LIKE(DDCISV)
     D  FNMCSV                             LIKE(DDCISV)
     D  FNRPSV                             LIKE(DDCISV)
     D  FNIDSV                             LIKE(DDCISV)
     D  FNHMSV                             LIKE(DDCISV)
     D  FNAUSV                             LIKE(DDCISV)                                     MD043147
     D  FNCIOV                             LIKE(DDCISV)
     D  FNTXOV                             LIKE(DDCISV)
     D  FNCDOV                             LIKE(DDCISV)
     D  FNTEOV                             LIKE(DDCISV)
     D  FNGCOV                             LIKE(DDCISV)
     D  FNCBOV                             LIKE(DDCISV)
     D  FNJAOV                             LIKE(DDCISV)
     D  FNMCOV                             LIKE(DDCISV)
     D  FNRPOV                             LIKE(DDCISV)
     D  FNIDOV                             LIKE(DDCISV)
     D  FNHMOV                             LIKE(DDCISV)
     D  FNAUOV                             LIKE(DDCISV)                                     MD043147
     D***NahoIndiciaDS                  11A   OVERLAY(NahoIndOverDS)                        MD043147
     D***NahoOverideDS                  11A   OVERLAY(NahoIndOverDS:12)                     MD043147
     DNahoIndiciaDS                  12A   OVERLAY(NahoIndOverDS)                           MD043147
     DNahoOverideDS                  12A   OVERLAY(NahoIndOverDS:13)                        MD043147
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
      ** Index for arrays of error message ids etc
     D Idx             S              3P 0
     D WIx             S              3P 0
     D KNAHO           S              6A
     D WSysOff         S              2S 0
     D WOvrOff         S              2S 0
     D Index           S              3S 0 INZ(1)
 
     D PHasIndicia     S              1A
     D PAINSF          S              1A                                                    MD036460
 
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
 
     C                   EVAL      FNCISV = DDCISV
     C                   EVAL      FNTXSV = DDTXSV
     C                   EVAL      FNCDSV = DDCDSV
     C                   EVAL      FNTESV = DDTESV
     C                   EVAL      FNGCSV = DDGCSV
     C                   EVAL      FNCBSV = DDCBSV
     C                   EVAL      FNJASV = DDJASV
     C                   EVAL      FNMCSV = DDMCSV
     C                   EVAL      FNRPSV = DDRPSV
     C                   EVAL      FNIDSV = DDIDSV
     C                   EVAL      FNHMSV = DDHMSV
     C                   EVAL      FNAUSV = DDAUSV                                          MD043147
     C                   EVAL      FNCIOV = DDCIOV
     C                   EVAL      FNTXOV = DDTXOV
     C                   EVAL      FNCDOV = DDCDOV
     C                   EVAL      FNTEOV = DDTEOV
     C                   EVAL      FNGCOV = DDGCOV
     C                   EVAL      FNCBOV = DDCBOV
     C                   EVAL      FNJAOV = DDJAOV
     C                   EVAL      FNMCOV = DDMCOV
     C                   EVAL      FNRPOV = DDRPOV
     C                   EVAL      FNIDOV = DDIDOV
     C                   EVAL      FNHMOV = DDHMOV
     C                   EVAL      FNAUOV = DDAUOV                                          MD043147
 
     C                   EVAL      PHasIndicia = 'N'
     C                   EVAL      KNAHO = NANAHO
 
      ** Do an initial check on the Indicia and Override
      ** Applicable for Amended non-account holder
     C**********         IF        DDACTI <> 'I'                                            MD036460
     C                   IF        PAINSF <> 'I'                                            MD036460
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
     C                             OR DDAUSV = 'Y'                                          MD043147
     C                   EVAL      PHasIndicia = 'Y'                                        MD036489
     C                   ENDIF                                                              MD036489
     C                   ENDIF
 
      ** Country of Domicile
     C                   IF        %LOOKUP(NACOLC:CtryCodeArr) <> 0
     C                             AND NACOLC <> *BLANKS
     C                             AND DDCDSV <> 'Y'
     C                   EVAL      PHasIndicia = 'Y'
     C                   EVAL      DDCDSV = 'Y'
     C                   ENDIF
 
     C                   IF        DDCDSV = ' '
     C                   EVAL      DDCDSV = 'N'
     C                   ENDIF
 
      ** This will allow the change of Indicia Values from 'Y' to 'N' during Insert
     C                   IF        %LOOKUP(NACOLC:CtryCodeArr) = 0
     C                             AND NACOLC <> *BLANKS
     C                             AND DDCDSV = 'Y'
     C**********                   AND DDACTI = 'I'                                         MD036460
     C                             AND PAINSF = 'I'                                         MD036460
     C                   EVAL      DDCDSV = 'N'
     C                   ENDIF
 
      ** Check Country of Citizenship
     C                   IF        %LOOKUP(NACOCZ:CtryCodeArr) <> 0
     C                             AND NACOCZ <> *BLANKS
     C                             AND DDCISV <> 'Y'
     C                             OR %LOOKUP(NAACCZ:CtryCodeArr) <> 0
     C                             AND NAACCZ <> *BLANKS
     C                             AND DDCISV <> 'Y'
     C                   EVAL      PHasIndicia = 'Y'
     C                   EVAL      DDCISV = 'Y'
     C                   ENDIF
 
     C                   IF        DDCISV =  ' '
     C                   EVAL      DDCISV = 'N'
     C                   ENDIF
 
      ** This will allow the change of Indicia Values from 'Y' to 'N' during Insert
     C                   IF        %LOOKUP(NACOCZ:CtryCodeArr) = 0
     C                             AND NACOCZ <> *BLANKS
     C**********                   AND DDCISV = 'Y'                                         MD036460
     C**********                   AND DDACTI = 'I'                                         MD036460
     C**********                   OR %LOOKUP(NAACCZ:CtryCodeArr) = 0                       MD036460
     C                             AND %LOOKUP(NAACCZ:CtryCodeArr) = 0                      MD036460
     C                             AND NAACCZ <> *BLANKS
     C                             AND DDCISV = 'Y'
     C                             AND PAINSF = 'I'                                         MD036460
     C**********                   AND DDACTI = 'I'                                         MD036460
     C                             OR %LOOKUP(NACOCZ:CtryCodeArr) = 0                       MD036460
     C                             AND NACOCZ <> *BLANKS                                    MD036460
     C                             AND NAACCZ = *BLANKS                                     MD036460
     C                             AND DDCISV = 'Y'                                         MD036460
     C                             AND PAINSF = 'I'                                         MD036460
     C                   EVAL      DDCISV = 'N'
     C                   ENDIF
 
      ** Check Country of Birth
     C                   IF        %LOOKUP(NABTHC:CtryCodeArr) <> 0
     C                             AND NABTHC <> *BLANKS
     C                             AND DDCBSV <> 'Y'
     C                   EVAL      PHasIndicia = 'Y'
     C                   EVAL      DDCBSV = 'Y'
     C                   ENDIF
 
     C                   IF        DDCBSV =  ' '
     C                   EVAL      DDCBSV = 'N'
     C                   ENDIF
 
      ** This will allow the change of Indicia Values from 'Y' to 'N' during Insert
     C                   IF        %LOOKUP(NABTHC:CtryCodeArr) = 0
     C                             AND NABTHC <> *BLANKS
     C                             AND DDCBSV = 'Y'
     C                             AND PAINSF = 'I'                                         MD036460
     C**********                   AND DDACTI = 'I'                                         MD036460
     C                             OR  NABTHC = *BLANKS                                     MD036460
     C                             AND DDCBSV = 'Y'                                         MD036460
     C                             AND PAINSF = 'I'                                         MD036460
     C                   EVAL      DDCBSV = 'N'
     C                   ENDIF
 
      ** Check Identity Documents Issue
     C                   IF        %LOOKUP(NAISCT:CtryCodeArr) <> 0
     C                             AND NAISCT <> *BLANKS
     C                             AND DDIDSV <> 'Y'
     C                   EVAL      PHasIndicia = 'Y'
     C                   EVAL      DDIDSV = 'Y'
     C                   ENDIF
 
     C                   IF        DDIDSV =  ' '
     C                   EVAL      DDIDSV = 'N'
     C                   ENDIF
 
      ** This will allow the change of Indicia Values from 'Y' to 'N' during Insert
     C                   IF        %LOOKUP(NAISCT:CtryCodeArr) = 0
     C                             AND NAISCT <> *BLANKS
     C                             AND DDIDSV = 'Y'
     C                             AND PAINSF = 'I'                                         MD036460
     C**********                   AND DDACTI = 'I'                                         MD036460
     C                             OR  NAISCT = *BLANKS                                     MD036460
     C                             AND DDIDSV = 'Y'                                         MD036460
     C                             AND PAINSF = 'I'                                         MD036460
     C                   EVAL      DDIDSV = 'N'
     C                   ENDIF
 
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
 
      ** This will allow the change of Indicia Values from 'Y' to 'N' during Insert
     C                   IF        %LOOKUP(DDMAIL:CtryCodeArr) = 0
     C                             AND DDMAIL <> *BLANKS
     C                             AND DDMCSV = 'Y'
     C                             AND PAINSF = 'I'                                         MD036460
     C**********                   AND DDACTI = 'I'                                         MD036460
     C                             OR  DDMAIL = *BLANKS                                     MD036460
     C                             AND DDMCSV = 'Y'                                         MD036460
     C                             AND PAINSF = 'I'                                         MD036460
     C                   EVAL      DDMCSV = 'N'
     C                   ENDIF
 
      ** Check Green Card
     C                   IF        DDGREC = 'Y'
     C                             AND DDGCSV <> 'Y'
     C                   EVAL      PHasIndicia = 'Y'
     C                   EVAL      DDGCSV = 'Y'
     C                   ENDIF
 
     C                   IF        DDGCSV =  ' '
     C                   EVAL      DDGCSV = 'N'
     C                   ENDIF
 
      ** This will allow the change of Indicia Values from 'Y' to 'N' during Insert
     C                   IF        DDGREC <> 'Y'
     C                             AND DDGCSV = 'Y'
     C                             AND PAINSF = 'I'                                         MD036460
     C**********                   AND DDACTI = 'I'                                         MD036460
     C                   EVAL      DDGCSV = 'N'
     C                   ENDIF
 
      ** Check Telephone Number
     C                   IF        DDPHNE = 'Y'
     C                             AND DDTESV <> 'Y'
     C                   EVAL      PHasIndicia = 'Y'
     C                   EVAL      DDTESV = 'Y'
     C                   ENDIF
 
     C                   IF        DDTESV =  ' '
     C                   EVAL      DDTESV = 'N'
     C                   ENDIF
 
      ** This will allow the change of Indicia Values from 'Y' to 'N' during Insert
     C                   IF        DDPHNE <> 'Y'
     C                             AND DDTESV = 'Y'
     C                             AND PAINSF = 'I'                                         MD036460
     C**********                   AND DDACTI = 'I'                                         MD036460
     C                   EVAL      DDTESV = 'N'
     C                   ENDIF
 
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
                                                                                            MD043147
     C                   IF        DDAUSV = ' '                                             MD043147
     C                   EVAL      DDAUSV = 'N'                                             MD043147
     C                   ENDIF                                                              MD043147
 
     C                   IF        DDHMSV = ' '
     C                   EVAL      DDHMSV = 'N'
     C                   ENDIF
 
     C                   IF        DDRPSV = ' '
     C                   EVAL      DDRPSV = 'N'
     C                   ENDIF
 
     C                   IF        DDTXSV = 'Y'
     C                             AND DDUTIN = *BLANKS
     C                             AND PAINSF = 'I'                                         MD036460
     C**********                   AND DDACTI = 'I'                                         MD036460
     C                   EVAL      PHasIndicia = 'N'
     C                   EVAL      DDTXSV = 'N'
     C                   ENDIF
 
      ** RETURN
 
     C                   RETURN
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SrChkNahoInd - Check Non-acct holder Indicia (SYS and OVR)    *
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
     C                   IF        %SCAN('Y':NahoOverideDS) = 0
 
     C                   DOU       WOvrOff > IndiciaCount
     C                             OR  WOvrOff = 0
 
      ** Check any override as 'N' possibly invalidating
      ** system value Indicia
     C                   EVAL      WOvrOff =
     C                               %SCAN('Y':NahoIndiciaDS:WOvrOff)
     C                   EVAL      WSysOff = WOvrOff
     C                   IF        WOvrOff <> 0
     C                   EVAL      WSysOff =
     C                               %SCAN('N':NahoOverideDS:WSysOff)
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
 
     C                   PARM                    CuNAHOVald
     C                   PARM                    CuFTNHScrn
      ** Insert Flag                                                                        MD036460
     C                   PARM                    PAINSF                                     MD036460
 
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
 
     C/COPY ZACPYSRC,DBFIELDS
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      /COPY ZACPYSRC,PSSR_ILE
      *****************************************************************
**  CPY@
(c) Finastra International Limited 2015
