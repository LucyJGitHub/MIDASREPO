     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2015')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas SD Validate CRS Information Complete NAHL')      *
      *****************************************************************
      *                                                               *
      *  Midas - Standing Data Module                                 *
      *                                                               *
      *  SDVCRIN - Validate CRS Information Complete (NAHL)           *
      *                                                               *
      *  (c) Finastra International Limited 2015                      *
      *                                                               *
      *  Last Amend No. MD055079           Date 29Jan20               *
      *  Prev Amend No. MD040876           Date 13Sep16               *
      *                 CGL177             Date 11Jan16               *
      *                 CGL157   *CREATE   Date 17Aug15               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD055079 - CRS issue: Customer/Non-account Holders          *
      *             Mailing country/Phone country                     *
      *   MD040876 - CRS MQ (Recompile)                               *
      *   CGL177 - CRS Reporting Phase 2                              *
      *   CGL157 - CRS Reporting                                      *
      *                                                               *
      *****************************************************************

      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+

     FSDJACCL1  IF   E           K DISK    INFSR(*PSSR)
      ** Midas SD Joint A/c Member Details by Joint A/c No./Customer No.

     FSDCRNHL1  IF   E           K DISK    INFSR(*PSSR)
      ** Midas SD CRS Non-Account Details File - Header

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

      ** Transaction Details in screen format - NAHL
     D CurCrnhDets   E DS                  EXTNAME(SDCRNSPD)
     D PrvCrnhDets   E DS                  EXTNAME(SDCRNSPD)
     D                                     PREFIX(P_)

      ** SDCRDDPD CRS Transaction Details in Screen Format - NAHL
     D CrsdDet       E DS                  EXTNAME(SDCRDDPD)

      ** CRS Valid - NAHL Details Screen 1
     D SDVCRNS1      E DS                  EXTNAME(SDVCRNHPD)
     D                                     PREFIX(H_)

      ** CRS Valid - NAHL Details Screen 2
     D SDVCRNS2      E DS                  EXTNAME(SDVCRSNPD)

      ** CRS Customer Details File - Detail
     D SDCRSDS1      E DS                  EXTNAME(SDCRSDPD)

      ** SD Valid Non-Account Holder Details
     D NwNaFilFmt    E DS                  EXTNAME(SDVNAHLPD)

      ** External DS for Bank Details
     D SDBANK        E DS                  EXTNAME(SDBANKPD)

      ** First DS for Access Programs, short Data Structure
     D DSFDY         E DS                  EXTNAME(DSFDY)

      ** Access the System Value
     D SVAL01          C                   CONST('CRSForTINMandatory')
     D SVAL02          C                   CONST('CRSLocalTINMandatory')
     D SVAL03          C                   CONST('CRSInfoCompMailCtry')                     MD055079
     D SVAL04          C                   CONST('CRSInfoCompPhoneCtry')                    MD055079

      ** Data Structure for AOSVALR0 string
     DSVAL1            DS           200
     DSVAL11                   1      1

      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+

      ** Override Database Table
     D ##OV1           S             50    DIM(1) CTDATA PERRCD(1)
     D ##OV2           S             50    DIM(1) CTDATA PERRCD(1)
     D WMsgLen         S             15P 5 INZ(50)

      ** Index for arrays of error message ids etc
     D Idx             S              3P 0
     D WIx             S              3P 0
     D WUSRQ           S              1A
     D WMailMndtry     S              1A                                                    MD055079
     D WPhneMndtry     S              1A                                                    MD055079

     D PCRSDT          DS
     D  DDCTRY                 1      2
     D  DDPREP                 3      3
     D  DDREPT                 4      4
     D  DDREPU                 5     14
     D  DDREPD                15     20
     D  DDREPM                21     26
     D  DDREP1                27     90
     D  DDREP2                91    154
     D  DDEVD1               155    156
     D  DDEVS1               157    159
     D  DDEVD2               160    161
     D  DDEVS2               162    164
     D  DDEVD3               165    166
     D  DDEVS3               167    169
     D  DDEVD4               170    171
     D  DDEVS4               172    174
     D  DDEVD5               175    176
     D  DDEVS5               177    179
     D  DDTINN               180    204
     D  DDEFFD               205    210
     D  DDEXPD               211    216
     D  DDCODOC              217    217
     D  DDJACMC              218    218
     D  DDMAILC              219    219
     D  DDPHONC              220    220
     D  DDRPAYC              221    221
     D  DDPEP1               222    285
     D  DDPEP2               286    349
     D  DDCRSA               350    350
     D  DDTINS               351    351                                                       CGL177

     D WHasInfoCmp     S              1A
     D PCrsdS          S            351A   DIM(30)                                            CGL177
     D X               S              2S 0

      ** Parameter for Access Object
     D PRtcd           S              7A
     D POptn           S              7A

      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
      *****************************************************************
      /EJECT
      *****************************************************************

      ** Initialization

     C                   CALL      'QCMDEXC'
     C                   PARM                    ##OV1
     C                   PARM                    WMsgLen

     C                   MOVE      *BLANK        ReturnCode
     C                   MOVE      *BLANK        FldNamXAr
     C                   MOVE      *BLANK        MsgIDXAr
     C                   MOVE      *BLANK        MsgDtaXAr
     C                   MOVE      *BLANK        WFldNmXAr
     C                   MOVE      *BLANK        WMsgIdXAr
     C                   MOVE      *BLANK        WMsgDtXAr
     C                   Z-ADD     0             Idx
     C                   Z-ADD     0             WIx
     C                   MOVE      'Y'           DDINFOOK
     C                   MOVE      DDINFO        DFINFC

      ** Allowed values are Y (Yes) or N (No) and BLANKS
     C                   IF        DDINFO <> 'Y' AND
     C                             DDINFO <> 'N' AND
     C                             DDINFO <> *BLANKS
     C                   MOVE      'N'           DDINFOOK
     C                   ADD       1             Idx
     C                   MOVEL     'DDINFO'      FldNamXAr(Idx)
     C                   MOVEL     'USS0589'     MsgIdXAr(Idx)
     C                   ENDIF

      ** Do NOT Validate CRS Info Complete flag only if the CRS Customer type is 'F' (FI)
      ** and CRS Exempt is equal to 'Y' (Yes)
     C                   IF        DDTYPE = 'F'
     C                             OR DDEXMP = 'Y'
     C                   EVAL      DFINFC = DDINFO
     C                   RETURN
     C                   ENDIF

     C                   IF        DDINFO = 'Y'

      ** Retrieve the data set per PCrsdS record (max 30) for the next DDINFO
     C                   EVAL      X = 1

     C                   DOW       X < 31

     C                   EVAL      PCRSDT = PCrsdS(X)

     C                   IF        DDCTRY <> *Blanks

      ** CRS Country is Subject to Reporting and no TIN is defined and the country
      ** has a CRS agreement if required for the system value setting
     C                   IF        (DDREPT = 'Y'
     C                             AND DDTINN = *BLANKS)

      ** If CRS Country is Local Country
     C                   IF        BJCNCD = DDCTRY
     C                   IF        (DDCRSA = 'Y'
     C                             OR SVAL2 = 'Y')

     C                   MOVE      'N'           DDINFOOK
     C                   ADD       1             Idx
     C                   MOVEL     'DDINFO'      FldNamXAr(Idx)
     C                   MOVEL     'USS0620'     MsgIdXAr(Idx)
     C                   LEAVE

     C                   ENDIF

      ** If CRS Country is Foreign Country
     C                   ELSE

     C                   IF        (DDCRSA = 'Y'
     C                             OR SVAL1 = 'Y')

     C                   MOVE      'N'           DDINFOOK
     C                   ADD       1             Idx
     C                   MOVEL     'DDINFO'      FldNamXAr(Idx)
     C                   MOVEL     'USS0620'     MsgIdXAr(Idx)
     C                   LEAVE

     C                   ENDIF
     C                   ENDIF
     C                   ENDIF

      ** CRS Subject to CRS Reporting is BLANK
     C                   IF        DDREPT = *BLANKS

     C                   MOVE      'N'           DDINFOOK
     C                   ADD       1             Idx
     C                   MOVEL     'DDINFO'      FldNamXAr(Idx)
     C                   MOVEL     'USS0625'     MsgIdXAr(Idx)
     C                   LEAVE

     C                   ENDIF

     C                   ENDIF

     C                   EVAL      X = X + 1

     C                   ENDDO

      ** CRS Exempt Flag is BLANK
     C                   IF        DDEXMP = *BLANKS

     C                   MOVE      'N'           DDINFOOK
     C                   ADD       1             Idx
     C                   MOVEL     'DDINFO'      FldNamXAr(Idx)
     C                   MOVEL     'USS0621'     MsgIdXAr(Idx)

     C                   ENDIF

      ** CRS Mailing Country is BLANK (check the first Mailing Country)
      ** to replace NACTIN2 of the official field for 1st phone country
      ** and System Value Mailing Country Mandatory = 'Y'                                   MD055079
     C                   IF        NAMCT1 = *BLANKS
     C                             AND WMailMndtry = 'Y'                                    MD055079

     C                   MOVE      'N'           DDINFOOK
     C                   ADD       1             Idx
     C                   MOVEL     'DDINFO'      FldNamXAr(Idx)
     C                   MOVEL     'USS0622'     MsgIdXAr(Idx)

     C                   ENDIF

      ** CRS Phone Country is BLANK (check the first Phone Country)
      ** to replace NACTIN3 of the official field for 1st phone country
      ** and System Value Phone Number Country Mandatory = 'Y'                              MD055079
     C                   IF        NAPCT1 = *BLANKS
     C                             AND WPhneMndtry = 'Y'                                    MD055079

     C                   MOVE      'N'           DDINFOOK
     C                   ADD       1             Idx
     C                   MOVEL     'DDINFO'      FldNamXAr(Idx)
     C                   MOVEL     'USS0623'     MsgIdXAr(Idx)

     C                   ENDIF

      ** CRS High Value Account is BLANK
     C                   IF        DDHVAL = *BLANKS

     C                   MOVE      'N'           DDINFOOK
     C                   ADD       1             Idx
     C                   MOVEL     'DDINFO'      FldNamXAr(Idx)
     C                   MOVEL     'USS0624'     MsgIdXAr(Idx)

     C                   ENDIF

      ** CRS Type is BLANK
     C                   IF        DDTYPE = *BLANKS

     C                   MOVE      'N'           DDINFOOK
     C                   ADD       1             Idx

     C                   IF        NAHLID = 'N'
     C                   MOVEL     'DDINFO'      FldNamXAr(Idx)
     C                   MOVEL     'USS0627'     MsgIdXAr(Idx)

     C                   ENDIF

     C                   ENDIF

      ** CRS Customer Sub-type is 'UN' (Unknown)
     C                   IF        DDTYPE = 'N' AND
     C                             DDSTYP = 'UN'

     C                   MOVE      'N'           DDINFOOK
     C                   ADD       1             Idx

     C                   IF        NAHLID = 'N'
     C                   MOVEL     'DDINFO'      FldNamXAr(Idx)
     C                   MOVEL     'USS0628'     MsgIdXAr(Idx)

     C                   ENDIF

     C                   ENDIF

      ** CRS Customer Type Joint Account
     C                   IF        NAHLID = 'C' AND
     C                             DDTYPE = 'J'

     C                   EVAL      WHasInfoCmp = *BLANKS

     C                   ENDIF

     C                   ENDIF

     C                   IF        Idx = 0
     C                   EVAL      DFINFC = DDINFO
     C                   ENDIF

      ** RETURN

     C                   CALL      'QCMDEXC'
     C                   PARM                    ##OV2
     C                   PARM                    WMsgLen

     C                   RETURN

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

      ** CRS Transaction Details in screen format
     C                   PARM                    CurCrnhDets
     C                   PARM                    PCrsdS
     C                   PARM                    SDVCRNS2
     C                   PARM                    NwNaFilFmt
     C                   PARM                    NAHLID            1
     C                   PARM                    DDINFOI           1

      ** Output
      ** Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr

      ** Warning fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    WFldNmXAr
     C                   PARM                    WMsgIdXAr
     C                   PARM                    WMsgDtXAr

      ** CRS Information complete - OK
     C                   PARM                    DDINFOOK          1
     C                   PARM                    DFINFC            1

     C                   CALL      'AOSVALR0'
     C                   PARM                    @RTCD
     C                   PARM      SVAL01        SVALK1           20
     C                   PARM                    SVAL1           200
     C                   PARM      SVAL02        SVALK2           20
     C                   PARM                    SVAL2           200
     C**********         PARM                    SVALK3           20                        MD055079
     C                   PARM      SVAL03        SVALK3           20                        MD055079
     C                   PARM                    SVAL3           200
     C**********         PARM                    SVALK4           20                        MD055079
     C                   PARM      SVAL04        SVALK4           20                        MD055079
     C                   PARM                    SVAL4           200
     C                   PARM                    SVALK5           20
     C                   PARM                    SVAL5           200
     C                   PARM                    SVALK6           20
     C                   PARM                    SVAL6           200
     C                   PARM                    SVALK7           20
     C                   PARM                    SVAL7           200
     C                   PARM                    SVALK8           20
     C                   PARM                    SVAL8           200
     C                   PARM                    SVALK9           20
     C                   PARM                    SVAL9           200
     C                   PARM                    SVALK10          20
     C                   PARM                    SVAL10          200

      ** If the system value is not found then issue a database error
     C                   IF        @RTCD <> '*NRF' AND
     C                             @RTCD <> *BLANKS

     C     *LOCK         IN        LDA
     C                   EVAL      DBFile = 'SDSVALPD'
     C                   EVAL      DBase = 001
     C                   EVAL      DBKey = SVALK1

     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ELSE                                                               MD055079
     C                   EVAL      WMailMndtry = SVAL3                                      MD055079
     C                   EVAL      WPhneMndtry = SVAL4                                      MD055079
     C                   ENDIF

      ** Access Bank Details

     C                   CALL      'AOBANKR0'
     C                   PARM      *BLANKS       PRtcd
     C                   PARM      '*FIRST  '    POptn
     C     SDBANK        PARM      SDBANK        DSFDY

      ** Database Error

     C                   IF        PRtcd <> *BLANK
     C                   EVAL      DBKEY = POptn
     C                   EVAL      DBFILE = 'SDBANKPD'
     C                   EVAL      DBASE = 900
     C                   EXSR      *PSSR
     C                   ENDIF

     C/COPY ZACPYSRC,DBFIELDS

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      /COPY ZACPYSRC,PSSR_ILE
      *****************************************************************
**  CPY@
(c) Finastra International Limited 2015
** ##OV1
OVRDBF FILE(SDCRNHL1) TOFILE(SDCRNHL1) SHARE(*NO)
** ##OV2
DLTOVR FILE(SDCRNHL1)
