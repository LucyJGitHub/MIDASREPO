     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2015')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas SD Validate CRS Information Complete')           *
      *****************************************************************
      *                                                               *
      *  Midas - Standing Data Module                                 *
      *                                                               *
      *  SDVCRIC - Validate CRS Information Complete                  *
      *                                                               *
      *  (c) Finastra International Limited 2015                      *
      *                                                               *
      *  Last Amend No. MD055079           Date 29Jan20               *
      *  Prev Amend No. MD051393           Date 29Jun18               *
      *                 MD050622           Date 03May18               *
      *                 MD040876           Date 13Sep16               *
      *                 CGL177             Date 11Jan16               *
      *                 CGL157   *CREATE   Date 17Aug15               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD055079 - CRS issue: Customer/Non-account Holders          *
      *             Mailing country/Phone country                     *
      *  MD051393 - Info complete flag                                *
      *  MD050622 - CRS Info complete flag 'Y' cannot be set due to   *
      *             subj to rept is blank error                       *
      *  MD040876 - CRS MQ (Recompile)                                *
      *  CGL177 - CRS Reporting Phase 2                               *
      *  CGL157 - CRS Reporting                                       *
      *                                                               *
      *****************************************************************

      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+

     FSDJACCL1  IF   E           K DISK    INFSR(*PSSR)
      ** Midas SD Joint A/c Member Details by Joint A/c No./Customer No.

     FSDCRSHL1  IF   E           K DISK    INFSR(*PSSR)
      ** Midas SD CRS Customer Details File - Header

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

      ** Transaction Details in screen format
     D CurCrsdDets   E DS                  EXTNAME(SDCRSSPD)
     D PrvCrsdDets   E DS                  EXTNAME(SDCRSSPD)
     D                                     PREFIX(P_)

      ** SDCRDDPD CRS Transaction Details in Screen Format
     D CrsdDet       E DS                  EXTNAME(SDCRDDPD)

      ** CRS Valid Customer Details Screen 1
     D SDVCRCS1      E DS                  EXTNAME(SDVCRSHPD)
     D                                     PREFIX(H_)

      ** CRS Valid Customer Details Screen 2
     D SDVCRCS2      E DS                  EXTNAME(SDVCRSDPD)
     D***                                  PREFIX(D_)

      ** CRS Customer Details File - Detail
     D SDCRSDS1      E DS                  EXTNAME(SDCRSDPD)

      ** SD Valid Additional Customer Details
     D SDVACUD1      E DS                  EXTNAME(SDVCUADPD)

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
     D**DDPREP                 3      3                                                     MD050622
     D**DDREPT                 4      4                                                     MD050622
     D**DDREPU                 5     14                                                     MD050622
     D**DDREPD                15     20                                                     MD050622
     D**DDREPM                21     26                                                     MD050622
     D**DDREP1                27     90                                                     MD050622
     D**DDREP2                91    154                                                     MD050622
     D**DDEVD1               155    156                                                     MD050622
     D**DDEVS1               157    159                                                     MD050622
     D**DDEVD2               160    161                                                     MD050622
     D**DDEVS2               162    164                                                     MD050622
     D**DDEVD3               165    166                                                     MD050622
     D**DDEVS3               167    169                                                     MD050622
     D**DDEVD4               170    171                                                     MD050622
     D**DDEVS4               172    174                                                     MD050622
     D**DDEVD5               175    176                                                     MD050622
     D**DDEVS5               177    179                                                     MD050622
     D**DDTINN               180    204                                                     MD050622
     D**DDEFFD               205    210                                                     MD050622
     D**DDEXPD               211    216                                                     MD050622
     D**DDCODOC              217    217                                                     MD050622
     D**DDJACMC              218    218                                                     MD050622
     D**DDMAILC              219    219                                                     MD050622
     D**DDPHONC              220    220                                                     MD050622
     D**DDRPAYC              221    221                                                     MD050622
     D**DDPEP1               222    285                                                     MD050622
     D**DDPEP2               286    349                                                     MD050622
     D**DDCRSA               350    350                                                     MD050622
     D**DDTINS               351    351                                              CGL177 MD050622
     D  DDREPT                 3      3                                                     MD050622
     D  DDREPU                 4     13                                                     MD050622
     D  DDREPD                14     19                                                     MD050622
     D  DDREPM                20     25                                                     MD050622
     D  DDREP1                26     89                                                     MD050622
     D  DDREP2                90    153                                                     MD050622
     D  DDEVD1               154    155                                                     MD050622
     D  DDEVS1               156    158                                                     MD050622
     D  DDEVD2               159    160                                                     MD050622
     D  DDEVS2               161    163                                                     MD050622
     D  DDEVD3               164    165                                                     MD050622
     D  DDEVS3               166    168                                                     MD050622
     D  DDEVD4               169    170                                                     MD050622
     D  DDEVS4               171    173                                                     MD050622
     D  DDEVD5               174    175                                                     MD050622
     D  DDEVS5               176    178                                                     MD050622
     D  DDTINN               179    203                                                     MD050622
     D  DDEFFD               204    209                                                     MD050622
     D  DDEXPD               210    215                                                     MD050622
     D  DDCODOC              216    216                                                     MD050622
     D  DDJACMC              217    217                                                     MD050622
     D  DDMAILC              218    218                                                     MD050622
     D  DDPHONC              219    219                                                     MD050622
     D  DDRPAYC              220    220                                                     MD050622
     D  DDCRSA               221    221                                                     MD050622
     D  DDTINS               222    222                                                     MD050622
     D  DDAUHO               223    223                                                     MD050622

     D WHasInfoCmp     S              1A
     D*PCrsdS***       S            350A   DIM(30)                                            CGL177
     D*PCrsdS***       S            351A   DIM(30)                                   CGL177 MD050622
     D PCrsdS          S            223A   DIM(30)                                          MD050622
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
     C                   IF        (DDINFO = 'A' AND                                        MD051393
     C                             DDINFOO <> 'A'                                           MD051393
     C                             ) or DDINFO <> 'A'                                       MD051393
     C                   MOVE      'N'           DDINFOOK
     C                   ADD       1             Idx
     C                   MOVEL     'DDINFO'      FldNamXAr(Idx)
     C                   MOVEL     'USS0589'     MsgIdXAr(Idx)
     C                   ENDIF                                                              MD051393
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
      ** and System Value Mailing Country Mandatory = 'Y'                                   MD055079
     C                   IF        ADCTR1 = *BLANKS
     C                             AND WMailMndtry = 'Y'                                    MD055079

     C                   MOVE      'N'           DDINFOOK
     C                   ADD       1             Idx
     C                   MOVEL     'DDINFO'      FldNamXAr(Idx)
     C                   MOVEL     'USS0622'     MsgIdXAr(Idx)

     C                   ENDIF

      ** CRS Phone Country is BLANK (check the first Phone Country)
      ** and System Value Phone Number Country Mandatory = 'Y'                              MD055079
     C                   IF        ADPHN1 = *BLANKS
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

      ** CRS Customer Type is BLANK
     C                   IF        DDTYPE = *BLANKS

     C                   MOVE      'N'           DDINFOOK
     C                   ADD       1             Idx

     C                   IF        CUSTID = 'C'
     C                   MOVEL     'DDINFO'      FldNamXAr(Idx)
     C                   MOVEL     'USS0627'     MsgIdXAr(Idx)

      ** CRS Non-Account Holder Type is BLANK
     C                   ELSE
     C                   MOVEL     'DDINFO'      FldNamXAr(Idx)
     C                   MOVEL     'USS0627'     MsgIdXAr(Idx)

     C                   ENDIF

     C                   ENDIF

      ** CRS Customer Sub-type is 'UN' (Unknown)
     C                   IF        DDTYPE = 'N' AND
     C                             DDSTYP = 'UN'

     C                   MOVE      'N'           DDINFOOK
     C                   ADD       1             Idx

     C                   IF        CUSTID = 'C'
     C                   MOVEL     'DDINFO'      FldNamXAr(Idx)
     C                   MOVEL     'USS0628'     MsgIdXAr(Idx)

      ** CRS Non-Account Holder Sub-type is 'UN' (Unknown)
     C                   ELSE
     C                   MOVEL     'DDINFO'      FldNamXAr(Idx)
     C                   MOVEL     'USS0628'     MsgIdXAr(Idx)

     C                   ENDIF

     C                   ENDIF

      ** CRS Customer Type Joint Account
     C                   IF        CUSTID = 'C' AND
     C                             DDTYPE = 'J'

     C                   EVAL      WHasInfoCmp = *BLANKS

      ** Read through Joint account members of the Customer
     C     DDCUSN        SETLL     SDJACCD0
     C     DDCUSN        READE     SDJACCD0

     C                   DOW       NOT %EOF (SDJACCL1)
     C                             AND WHasInfoCmp <> 'N'

      ** Check Customer Member
     C                   IF        JCCUST <> *BLANKS
     C     JCCUST        CHAIN     SDCRSHL1

     C                   IF        %FOUND(SDCRSHL1) AND CRINFO <> 'Y'

     C                   EVAL      WHasInfoCmp = 'N'
     C                   MOVE      'N'           DDINFOOK
     C                   ADD       1             Idx
     C                   MOVEL     'DDINFO'      FldNamXAr(Idx)
     C                   MOVEL     'USS0629'     MsgIdXAr(Idx)

     C                   ENDIF
     C                   ENDIF

     C     DDCUSN        READE     SDJACCD0
     C                   ENDDO

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
     C                   PARM                    CurCrsdDets
     C                   PARM                    PCrsdS
     C                   PARM                    SDVCRCS2
     C                   PARM                    SDVACUD1
     C                   PARM                    CUSTID            1
     C                   PARM                    DDINFOI           1
     C                   PARM                    DDINFOO           1                        MD051393

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
OVRDBF FILE(SDCRSHL1) TOFILE(SDCRSHL1) SHARE(*NO)
** ##OV2
DLTOVR FILE(SDCRSHL1)
