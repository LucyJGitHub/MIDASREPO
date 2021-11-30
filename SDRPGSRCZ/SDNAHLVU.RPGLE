     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2021')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas SD Non-Account Holder - Validate and Update')    *
      *****************************************************************
      *                                                               *
      *  Midas - Standing Data Module                                 *
      *                                                               *
      *  SDNAHLVU  - SD Non-A/C Holders Details Validate and update   *
      *                                                               *
      *  Function: This Program Validates SD Non-A/C Holder details   *
      *            for input into the Midas database.                 *
      *            Processes executed controlled by input Action Code *
      *            - For I (=Insert) or A (=Amend)                    *
      *              - Validate the Non-A/C Holder details fields     *
      *            - For A (=Amend) if it is valid, call a separate   *
      *              function to check whether it is a valid amendment*
      *            - For D (=Delete) call a separate function to      *
      *              process this Non-A/C Holder and bypass the rest  *
      *              of the validation                                *
      *            For all action codes, the decision to as to        *
      *            whether to write to the Valid or Invalid file and  *
      *            the call to the Message Handler will take place    *
      *            in this module                                     *
      *                                                               *
      *  (c) Finastra International Limited 2021                      *
      *                                                               *
      *  Last Amend No. MD059200           Date 04Nov21               *
      *  Prev Amend No. CAP240   *Create   Date 11Jun21               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD059200 - Missing parameter for SDFTNH5VL (introduced by    *
      *              MD052465)                                        *
      *  CAP240 - SD Non Account Holders JAVA conversion              *
      *                                                               *
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
      *****************************************************************

     FZAFLDNPD  IT   F   15        DISK    Infsr(*PSSR)
     FSDCTTXL2  IF   E           K Disk
     FSDNHTXL1  IF   E           K Disk
     FSDNHTXL4  IF   E           K Disk    INFSR(*PSSR)
     F                                     RENAME(SDNHTXD0:NHTX4)

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

      ** Program Status Data Structure
      ** =============================
      ** The following /COPY line includes all the defined fields in the
      ** PSDS.  They have meaningful names, prefixed by 'PS'.

     D/COPY ZACPYSRC,PSDS
      ** The following /COPY line includes definitions for the above fields
      ** as #ProcPgm, #ProcMod and #ProcName.  They are based on the
      ** corresponding fields in the PSDS /COPY member, so that member
      ** must be included where this one is used.

     D/COPY ZACPYSRC,PROCPARMS

      **--------------------------------------------------------------------------------------------
      ** The following /COPY line includes the definitions for error and
      ** warning message arrays.
     D/COPY ZACPYSRC,ERR_ARRAYS
      **--------------------------------------------------------------------------------------------

      **--------------------------------------------------------------------------------------------
      ** The following /COPY line includes the definitions for arrays
      ** specific to API *CTL modules.
     D/COPY ZACPYSRC,APICTLARR
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

     D Cr10ArrDS       DS
     D  Cr10Arr                     223A   DIM(10)


     D CT50ArrDS       DS
     D  CT50Arr                      55A   DIM(50)

     D CT50ArrDSD      DS
     D  CT50ArrD                     55A   DIM(50)

     D CT50ArrDSA      DS
     D  CT50ArrA                     55A   DIM(50)

      ** Incoming Header
     D HeadIn        E DS                  Extname(APHEADPD)

      ** Incoming Transaction
     D TranInNahl    E DS                  Extname(SDNAHLPD)
     D TranInFatca   E DS                  EXTNAME(SDFTNRPD)
     D TranInCRNS    E DS                  EXTNAME(SDCRNSPD)
     D TranInCR10    E DS                  EXTNAME(SDCR10PD)
     D TranInCt50    E DS                  EXTNAME(SDCT50PD)


     D TranInCR101   E DS                  EXTNAME (SDCR01PD)
     D                                     PREFIX(CR_)

     D TranInCT501   E DS                  EXTNAME (SDNATXPD)
     D                                     PREFIX(TX:2)

      ** Valid Non-A/C Holder layout
     D ValidNaho     E DS                  Extname(SDVNAHLPD)
     D                                     Prefix(V_)

      ** (Current) Non-A/C Holder record in file Format
     D CuNahoFlFm    E DS                  Extname(SDNAHOPD)

      ** (Current) Non-A/C Holder in Screen Format - Primary Details
     D CuNahlScFm    E DS                  Extname(SDNAHLPD)
     D                                     Prefix(@)

      ** Current Non-A/C Holder in File Format - CRS details
     D CuCrhFlFmt    E DS                  EXTNAME(SDCRNHPD)
     D                                     PREFIX(C_)
     D
      ** Current NOn-A/C Holder in Screen Format - CRS Details
     D CuCrhScFmt    E DS                  EXTNAME(SDCRNSPD)
     D                                     PREFIX(@_)

      ** Current Non-A/C Holder in File Format - FATCA details
     D CuFaFilFmt    E DS                  EXTNAME(SDFTNHPD)
     D                                     PREFIX(C_)

      ** Current Non-A/C Holder in Screen Format - FATCA Details
     D CuFaScFmt     E DS                  EXTNAME(SDFTNRPD)
     D                                     PREFIX(@)

      ** Current NATX Details in File Format
     D CuNatxFlFm    E DS                  Extname(SDNHTXPD)

      ** NATX Details in Screen Format
     D NwNatxScFm    E DS                  Extname(SDNATXPD)
     D                                     Prefix(NS)

      ** NATX Details in Screen Format (from file)
     D NatxScFmA     E DS                  Extname(SDNATXPD)
     D                                     Prefix(A)

      ** NATX Details in Screen Format (from default)
     D NatxScFmD     E DS                  Extname(SDNATXPD)
     D                                     Prefix(D)

      ** New Non-A/C Holder in File Format - FATCA Details
     D ValidFatca    E DS                  EXTNAME(SDVFTNHPD)
     D                                     PREFIX(V_)

      ** New Non-A/C Holder in File Format - CRS Details
     D ValidCRNH     E DS                  EXTNAME(SDVCRNHPD)
     D SDVCRSN       E DS                  EXTNAME(SDVCRSNPD)
     D ValidNatx     E DS                  Extname(SDVNATXPD)
     D                                     Prefix(NF)


      ** Error indicators
     D OKNaPrim      E DS                  Extname(SDENAHLPD)
     D OKFATCAdet    E DS                  EXTNAME(SDEFTNHPD)
     D OKCRNHDet     E DS                  EXTNAME(SDECRNHPD)
     D OKCRSCtry     E DS                  EXTNAME(SDECRSNPD)
     D OkNatx        E DS                  Extname(SDENATXPD)
     D  Nat_Okactn   E                     Extfld(Okactn)
     D  Nat_Oknaho   E                     Extfld(Oknaho)

      ** External DS for Bank Details
     D SDBANK        E DS                  Extname(SDBANKPD)

      ** External DS for API ICD
     D SDAPI         E DS                  Extname(SDAPIPD)

      ** External DS for SAR Details
     D SCSARD        E DS                  Extname(SCSARDPD)
     D  SCA_LCD      E                     Extfld(LCD)

      ** First DS for Access programs - short data structure
     D DSFDY         E DS                  Extname(DSFDY)

      ** Second DS for Access programs - long data structure
     D DSSDY         E DS                  Extname(DSSDY)

      ** External DS for CRS API Format Definition File - Detail                            MD059200
     D TranInCRDD    E DS                  EXTNAME(SDCRDDPD)                                MD059200
     D                                     PREFIX(CR)                                       MD059200

     D CrFoFilFmt      DS
     D  WCDESC                 1     50
     D  WPDESC                51    100
     D  WWBRTH               101    105
     D  WWCBTH               106    107
     D  WWBTHT               108    142
     D  WWCNCZ               143    144
     D  WWCDOM               145    146
     D  WWACCZ               147    148
     D  WWTINO               149    173

     D CurCuFOTH       DS
     D  WCDESC2                1     50
     D  WPDESC2               51    100
     D  WNBRTH2              101    106
     D  WWCBTH2              107    108
     D  WWBTHT2              109    143
     D  WWCNCZ2              144    145
     D  WWCDOM2              146    147
     D  WWACCZ2              148    149
     D  WWTINO2              150    174


     D PCRSDT          DS
     D  DDCTRY                 1      2
     D  DDPREP                 3      3
     D  DDREPTT                4      4
     D  DDREPU                 5     14
     D  DDREPD                15     20
     D  DDREPM                21     26
     D  DDREP1                27     90
     D  DDREP2                91    154
     D  DDEVE1               155    156
     D  DDEVS1               157    159
     D  DDEVE2               160    161
     D  DDEVS2               162    164
     D  DDEVE3               165    166
     D  DDEVS3               167    169
     D  DDEVE4               170    171
     D  DDEVS4               172    174
     D  DDEVE5               175    176
     D  DDEVS5               177    179
     D  DDTINN               180    204
     D  DDEFFD               205    210
     D  DDEXPD               211    216
     D  DDCODO               217    217
     D  DDJACM               218    218
     D  DDMAILT              219    219
     D  DDPHONT              220    220
     D  DDRPAY               221    221
     D  DDPEP1               222    285
     D  DDPEP2               286    349
     D  DDCRSA               350    350
     D  DDTINS               351    351

      ** 24X7 status data area
     D SC24X7        E DS                  EXTNAME(SC24X7) DTAARA(SC24X7)

      ** SD data area
     D SDSTAT        E DS                  EXTNAME(SDSTAT) DTAARA(SDSTAT)

      ** Override Database Table
     D ##OV1           S             50    DIM(1) CTDATA PERRCD(1)
     D ##OV2           S             50    DIM(1) CTDATA PERRCD(1)
     D ##OV3           S             50    DIM(1) CTDATA PERRCD(1)
     D ##OV4           S             50    DIM(1) CTDATA PERRCD(1)
     D VNatxArr        S             93A   DIM(50)

      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+

      ** Error message field(s)
     D ExtData         S            500


     D     Msg1        S                   LIKE(#MsgID)

      ** Index for arrays of error message ids etc
     D Idx             S              3P 0
     D Idy             S              3P 0

      ** Index for arrays of warning message ids etc
     D WIdx            S              3P 0

      *
     D Trans9999_1     S           9999A
     D Bfp             S              4S 0
     D NAHLLn          S              4S 0
     D FTNRLn          S              4S 0
     D CRNSLn          S              4S 0
     D CRNDLn          S              4S 0
     D CR10Ln          S              4S 0
     D CT50Ln          S              4S 0
     D RecordLen       S              5P 0
     D FileName        S             10A
     D FileLib         S             10A
     D PCrsdF          S            222A   DIM(30)
     D PCrsdS          S            351A   DIM(30)
     D PCrsdB          S            351A   DIM(30)
     D PCrsdZ          S            351A
     D WChar12         S             12A
     D WChar217        S            217A
     D WChar229        S            229A
     D ValidEINO       S             30A
     D OKEINO          S              1A
     D PTranID         S             10A
     D PReturn         S              7A
     D PSource         S              1A
     D PClass          S              5A
     D PRepType        S              1A
     D PMODE           S              1
     D WMsgLen         S             15P 5 INZ(50)
     D PActn           S              1

      ** Index for arrays of error message ids etc in Amend validation
     D AmIdx           S              3P 0

      ** Indicies for arrays used to set up corresponding sequence numbers
      **  for the fields that are in error
     D Ix              S              3P 0
     D Iy              S              3P 0

     D wCommitSkip     S              1A   INZ('N')
     D CSC011          S              1A
     D CSC022          S              1A
     D CGL133          S              1A
     D CGL031          S              1A
     D CER048          S              1A
     D CER076          S              1A
     D CGL032          S              1A
     D Retcd           S              7A
     D Option          S              7A

     D WNAHO           S                   LIKE(DDNAHO)

      ** Timestamp for the transaction
     D TimeStamp       S               Z

      ** Flags to indicate whether substitution is required in
      ** each of the various parts the transaction
     D RepPrim         S              1A   Inz('N')

      ** RTV parameter fields
     D ModeofOp        S              6
     D @in36           S              1

      ** 2VL parameter field
     D RespMode        S              1

      ** APDTASUBS parameter fields
     D IncData         S           2000
     D CurData         S           2000

      ** Keyfields used
     D KNaho           S             10

     D DDAUTH          S              1A
     D DDEINO          S             30A
     D TransDtl        S           5800A
     D PNahoNum        S             18A
     D PANahoNo        S             18A
     D PRtCd           S              7A
     D POptn           S              7A
     D PSard           S              6A
     D PAINSF          S              1A
     D WINKJ           S              1
     D PWarning        S              1A
     D CGL132          S              1A
     D CGL157          S              1A
     D PCountry        S              2A
     D X               S              2S 0
     D Y               S              5S 0
     D Z               S              5S 0
     D WIdx_WVAL       S              3P 0
     D WTRANS          S           7000A
     D WChar2          S              2A
     D Wtemp1          S              3A
     D Wtemp2          S            348A

      ** ZDATE1 and ZDATE2 parameters
     D PZDayNo         S              5  0
     D PZDate          S              6  0
     D PZadate         S              7
     D PZDatErr        S              1

     D DBerrUpd        C                   CONST('DB error in NAHL API update')


      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+

      ** +----------------------------------------+
      ** ¦ Hook for non-core D-specs (all types)  ¦
      ** ¦ also any I-specs (if necessary)        ¦
      ** ¦ =====================================  ¦
      ** +----------------------------------------+

      *****************************************************************
      /EJECT
      *****************************************************************
      ** +--- Start of Main processing -----------------------------------+
      ** ¦                                                                ¦
      ** ¦ Initial processing is performed automatically: the *INZSR is   ¦
      ** ¦ executed at program activation.                                ¦
      ** ¦                                                                ¦
      ** +----------------------------------------------------------------+

     C                   EXSR      Parse_NAHL

      ** Reset variables gradually updated

     C                   EXSR      SRResetCycle

      **  Validate Action Code

     C                   EXSR      SRValidateAc

      **  If error in validation of action code, fail this input

     C     Idx           IFNE      0
     C                   GOTO      INVALID
     C                   ENDIF

      **  Processing depends upon Action Code

     C                   SELECT

     C                   WHEN         DDACTN = 'I'

      **  Processing for Inserts

     C                   EXSR      SRValidateTr

     C                   WHEN         DDACTN = 'A'
     C                             OR DDACTN = 'D'

      **  Processing for Amends or Changes

      ** Check for the existence of the replacement character; if this is
      ** used, only the changed data has been sent, and all occurrences of
      ** the replacement character must be replaced with the corresponding
      ** character from the original transaction.

     C                   IF        DDACTN = 'A' AND GHSUBS <> *blank

     C     GHSUBS        SCAN      TranInNahl                             99
     C                   IF        *In99
     C                   EVAL      RepPrim = 'Y'
     C                   ENDIF

      ** If any of the flags set above is true, do the data
      ** substution subroutine.

     C                   IF        (RepPrim = 'Y')
     C                   EXSR      SRDtaSubs
     C                   ENDIF

     C                   ENDIF

     C                   EXSR      SRSetupAmd
     C                   EXSR      SRValidateTr

     C                   ENDSL

     C     INVALID       TAG

      *  Write to database

     C     UpdateYN      IFEQ      'Y'
     C     Idx           ANDEQ     0
     C                   EXSR      SrWriteToDB
     C                   ENDIF

     C                   SETON                                        LR

      ** If action is for Update, get the correct record information
      ** from file
     C**********         IF        UpdateYN = 'Y'       AND
     C**********                   Idx = 0              AND
     C**********                   DDACTN <> 'D'
     C**********         MOVE      DDNAHO        DDNAHO_In
     C**********         CALL      'SDNAHLR'
     C**********         PARM                    @AuthComp         1
     C**********         PARM                    @FwdBck           1
     C**********         PARM                    DDNAHO_In        10
     C**********         PARM                    Buffer
     C**********         PARM                    FldNameArr
     C**********         PARM                    MsgIDArr
     C**********         PARM                    MsgDtaArr
     C**********         PARM                    MsgFArray
     C**********         PARM                    APIRetC           1
     C**********         MOVEL     DDACTN        Buffer

     C**********         ELSE

     C                   Eval      X = 1
     C                   DOW       X < 11
     C                   Eval      TranInCr10 = *Blanks
     C                   Eval      TranInCr101 = *Blanks
     C                   Move      *Blanks       Cr10ArrDS
     C                   Eval      PCRSDT = *Blanks
     C                   Eval      PCRSDT = PCrsdS(X)
     C                   If        DDCTRY <> *Blanks
     C                   Eval      CR_DDCTR1 = DDCTRY
     C                   Eval      CR_DDREU1 = DDREPU
     C                   Eval      CR_DDRET1 = DDREPTT
     C                   Eval      CR_DDRED1 = DDREPD
     C                   Eval      CR_DDREM1 = DDREPM
     C                   Eval      CR_DDRE11 = DDREP1
     C                   Eval      CR_DDRE21 = DDREP2
     C                   Eval      CR_DDEE11 = DDEVE1
     C                   Eval      CR_DDES11 = DDEVS1
     C                   Eval      CR_DDEE21 = DDEVE2
     C                   Eval      CR_DDES21 = DDEVS2
     C                   Eval      CR_DDEE31 = DDEVE3
     C                   Eval      CR_DDES31 = DDEVS3
     C                   Eval      CR_DDEE41 = DDEVE4
     C                   Eval      CR_DDES41 = DDEVS4
     C                   Eval      CR_DDEE51 = DDEVE5
     C                   Eval      CR_DDES51 = DDEVS5
     C                   Eval      CR_DDTIN1 = DDTINN
     C                   Eval      CR_DDEFF1 = DDEFFD
     C                   Eval      CR_DDEXP1 = DDEXPD
     C                   Eval      CR_DDCOD1 = DDCODO
     C                   Eval      CR_DDJAC1 = DDJACM
     C                   Eval      CR_DDMAI1 = DDMAILT
     C                   Eval      CR_DDPHO1 = DDPHONT
     C                   Eval      CR_DDRPA1 = DDRPAY
     C                   Eval      CR_DDCRS1 = DDCRSA
     C                   Eval      CR_DDTNN1 = DDTINS
     C                   Eval      Cr10Arr(X) = TranInCr101
     C                   Endif
     C                   Eval      X = X + 1
     C                   ENDDO
     C                   EVAL      TranInCr10 = Cr10ArrDS

     C                   EVAL                    Buffer = TranInNahl
     C                                           + DDAUTH
     C                                           + TranInFatca
     C                                           + TranInCRNS
     C                                           + DDEINO
     C                                           + TranInCr10
     C                                           + TranInCt50
     C**********         ENDIF

     C                   RETURN

      *****************************************************************
      /EJECT
      *****************************************************************
      ** SRValidateAc - Routine to validate action code versus the    *
      **                Non a/c holder supplied                       *
      *****************************************************************

     C     SRValidateAc  BEGSR

      ** Set retrieve mode to '*FRONT' (Access using Front Office ID)
      **  if insert
      **  if not insert and Midas transaction ID is not present
      ** Otherwise
      **  Set retrieve mode to blank  (Access using Midas transaction ID).

     C                   IF        APFOTRANID <> *BLANKS AND
     C                             DDACTN = 'I'
     C                   MOVEL     '*FRONT'      ModeofOp
     C                   ELSE

     C*****DDNAHO        IFEQ      *BLANK
     C**********         MOVEL     '*FRONT'      ModeofOp
     C**********         ELSE
     C                   MOVEL     *Blanks       ModeofOp
     C**********         ENDIF

     C                   ENDIF

      ** Validate action code versus transaction IDs supplied
      ** The Customer in file format from the SD database is retrieved
      ** as well.

     C                   RESET                   ReturnCode

     C                   CALLB     'SDNAHLRTV'
      ** INPUTS :         ¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯
      ** Return code
      ** Mode = '*FRONT' (FRONT OFFICE TRANSACTION INTERFACE)
      ** Mode = '      ' (NOT FRONT OFFICE TRANSACTION INTERFACE)
      ** Response mode
      ** Action Code
      ** Front Office Transaction ID
      ** (Midas) Non-A/C Holder Number

     C                   PARM      *BLANK        ReturnCode
     C                   PARM                    ModeofOp
     C                   PARM      'S'           RespMode
     C                   PARM                    DDACTN
     C                   PARM                    APFOTranID
     C                   PARM                    DDNAHO
     C                   PARM                    @IN36

      ** OUTPUTS :
      ** (Current) Non-A/C Holder in file format
      ** OK - Action code
      ** OK - Non-A/C Holder Number
      ** Error fields/message IDs/message data (arrays) from/to caller
      ** Array index (3P0) from/to caller

     C                   PARM                    CuNahoFlFm
     C                   PARM                    CuFaFilFmt
     C                   PARM                    CrFoFilFmt
     C                   PARM                    CuCrhFlFmt
     C                   PARM                    PCrsdF
     C                   PARM                    OkActn            1
     C                   PARM                    OKNaho            1
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIdArr
     C                   PARM                    MsgDtaArr
     C                   PARM                    Idx

     C                   EVAL      PAINSF = DDACTN

     C                   ENDSR

      *****************************************************************
      /EJECT
      *****************************************************************
      ** SRSetUpAmd - Set up fields that are needed in the validation *
      **    of amendments and changes.                                *
      *****************************************************************

     C     SRSetupAmd    BEGSR

      ** For Amends, put the complete (pre-existing) Non-A/C Holder into the Valid
      **  file record - fields in this will be updated during processing

     C                   MOVE      CuNahoFlFm    ValidNaho

      ** For Amends, convert the Non-A/C Holder to screen format

     C                   CALLB     'SDNAHLCVT'
      ** INPUTS :         ¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯
      ** Return Code
      ** Non-A/C Holder - file formats

     C                   PARM                    RetCodeIn
     C                   PARM                    ValidNaho
     C                   PARM                    CuFaFilFmt
     C                   PARM                    CrFoFilFmt
     C                   PARM                    CuCrhFlFmt
     C                   PARM                    PCrsdF

      ** OUTPUTS :
      ** Non-A/C Holder Details - screen formats

     C                   PARM                    CuNahlScFm
     C                   PARM                    CuFaScFmt
     C                   PARM                    CurCuFOTH
     C                   PARM                    CuCrhScFmt
     C                   PARM                    PCrsdS

     C                   ENDSR

      *****************************************************************
      /EJECT
      ******************************************************************
      ** SRValidateTr - Routine to validate the main transaction details
      ******************************************************************

     C     SRValidateTr  BEGSR

      ** Validate Non-A/C Holder Primary details

     C                   EXSR      SRValdNaPrim

      **  If error in validation, fail this input

     C     Idx           IFNE      0
     C                   GOTO      EVALidTr
     C                   ENDIF

     C                   If        CGL031 = 'Y' and CGL032 = 'Y'
     C                             or CGL132 = 'Y'
     C                   Exsr      SRValdNATX
     C                   ENDIF

     C                   IF        CGL132 = 'Y'
     C                   EXSR      SRValdNaFatca
     C                   ENDIF

      **  If error in validation, fail this input

     C     Idx           IFNE      0
     C                   GOTO      EVALidTr
     C                   ENDIF

     C                   IF        CGL157 = 'Y'
     C                   EXSR      SRValdNaCRS
     C                   ENDIF

      **  If error in validation, fail this input

     C     Idx           IFNE      0
     C                   GOTO      EVALidTr
     C                   ENDIF

     C                   IF        CER076 = 'Y'
     C                   EXSR      SRValdCER076
     C                   ENDIF

     C**********         If        CGL031 = 'Y' and CGL032 = 'Y'
     C**********                   or CGL132 = 'Y'
     C**********         Exsr      SRValdNATX
     C**********         ENDIF

     C     EVALidTr      ENDSR

      *****************************************************************
      /EJECT
      *****************************************************************
      ** SRValdNaPrim - Validate Non-A/C Holder Primary details       *
      *****************************************************************

     C     SRValdNaPrim  BEGSR

     C                   CALLB     'SDNAHL2VL'
      ** INPUTS :        ¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯
      ** Response mode
      ** Non-A/C Holder Primary Details
      ** Non-A/C Holder Extra Data

     C                   PARM      'S'           RespMode
     C                   PARM                    TranInNahl
     C                   PARM                    ExtData

      ** OUTPUTS :
      ** Non-A/C Holder Primary Details OK inds
      ** Error fields/message IDs/message data (arrays) from/to caller
      ** Array index (3P0) from/to caller
      ** Warning fields/message IDs/message data (arrays) from/to caller
      ** Array index (3P0) from/to caller
      ** Valid Non-A/C Holder layout (DS) from/to caller

     C                   PARM                    OKNaPrim
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIDArr
     C                   PARM                    MsgDtaArr
     C                   PARM                    Idx
     C                   PARM                    WFldNamArr
     C                   PARM                    WMsgIDArr
     C                   PARM                    WMsgDtaArr
     C                   PARM                    WIdx
     C                   PARM                    ValidNaho

     C                   ENDSR


      *****************************************************************
      /EJECT
      *****************************************************************
      ** SRValdNaFatca- Validate Non-A/C Holder FATCA details         *
      *****************************************************************

     C     SRValdNaFatca BEGSR

      ** Validate FATCA details 1

     C                   CALLB     'SDFTNH5VL'

      ** INPUTS :
      ** Response mode
      ** FATCA customer details
      ** FATCA customer details (old)

     C                   PARM      'S'           RespMode
     C                   PARM                    TranInFatca
     C                   PARM                    CuFaScFmt
     C                   PARM                    CrFoFilFmt
     C                   PARM                    ValidNaho
     C                   PARM      DDCRDT        P_CRDT            8
     C                   PARM                    WCLAFlag          1
     C                   PARM                    PAINSF
     C                   PARM                    CuCrhScFmt
     C                   PARM                    TranInCRDD                                 MD059200

      ** OUTPUTS :
      ** FATCA Customer Details OK inds
      ** Error fields/message IDs/message data (arrays) from/to caller
      ** Warning fields/message IDs/message data (arrays) from/to caller
      ** Valid FATCA Customer layout (DS) from/to caller

     C                   PARM                    OkFATCAdet

      * Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIDArr
     C                   PARM                    MsgDtaArr

      ** Array index (3P0) from/to caller
     C                   PARM                    Idx

      ** Warning fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    WFldNamArr
     C                   PARM                    WMsgIDArr
     C                   PARM                    WMsgDtaArr

      ** Array index (3P0) from/to caller
     C                   PARM                    WIdx

      ** Valid FATCA file layout (DS) to/from caller
     C                   PARM                    ValidFatca

     C     Idx           IFNE      0
     C                   GOTO      ESRValdNaFatca
     C                   ENDIF

      ** Validate FATCA details 2

     C                   CALLB     'SDFTNH1VL'

      ** INPUTS :
      ** Response mode
      ** FATCA customer details
      ** FATCA customer details (old)

     C                   PARM      'S'           RespMode
     C                   PARM                    TranInFatca
     C                   PARM                    CuFaScFmt

      ** OUTPUTS :
      ** FATCA Customer Details OK inds
      ** Error fields/message IDs/message data (arrays) from/to caller
      ** Warning fields/message IDs/message data (arrays) from/to caller
      ** Valid FATCA Customer layout (DS) from/to caller

     C                   PARM                    OkFATCAdet

      * Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIDArr
     C                   PARM                    MsgDtaArr

      ** Array index (3P0) from/to caller
     C                   PARM                    Idx

      ** Warning fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    WFldNamArr
     C                   PARM                    WMsgIDArr
     C                   PARM                    WMsgDtaArr

      ** Array index (3P0) from/to caller
     C                   PARM                    WIdx

      ** Valid FATCA file layout (DS) to/from caller
     C                   PARM                    ValidFatca

     C     Idx           IFNE      0
     C                   GOTO      ESRValdNaFatca
     C                   ENDIF

      ** Validate FATCA details 3

     C                   CALLB     'SDFTNH2VL'

      ** INPUTS :
      ** Response mode
      ** FATCA customer details
      ** FATCA customer details (old)

     C                   PARM      'S'           RespMode
     C                   PARM                    TranInFatca
     C                   PARM                    CuFaScFmt

      ** OUTPUTS :
      ** FATCA Customer Details OK inds
      ** Error fields/message IDs/message data (arrays) from/to caller
      ** Warning fields/message IDs/message data (arrays) from/to caller
      ** Valid FATCA Customer layout (DS) from/to caller

     C                   PARM                    OkFATCAdet

      * Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIDArr
     C                   PARM                    MsgDtaArr

      ** Array index (3P0) from/to caller
     C                   PARM                    Idx

      ** Warning fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    WFldNamArr
     C                   PARM                    WMsgIDArr
     C                   PARM                    WMsgDtaArr

      ** Array index (3P0) from/to caller
     C                   PARM                    WIdx

      ** Valid FATCA file layout (DS) to/from caller
     C                   PARM                    ValidFatca

     C     Idx           IFNE      0
     C                   GOTO      ESRValdNaFatca
     C                   ENDIF

      ** Validate FATCA details 4

     C                   CALLB     'SDFTNH3VL'

      ** INPUTS :
      ** Response mode
      ** FATCA customer details
      ** FATCA customer details (old)

     C                   PARM      'S'           RespMode
     C                   PARM                    TranInFatca
     C                   PARM                    CuFaScFmt

      ** OUTPUTS :
      ** FATCA Customer Details OK inds
      ** Error fields/message IDs/message data (arrays) from/to caller
      ** Warning fields/message IDs/message data (arrays) from/to caller
      ** Valid FATCA Customer layout (DS) from/to caller

     C                   PARM                    OkFATCAdet

      * Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIDArr
     C                   PARM                    MsgDtaArr

      ** Array index (3P0) from/to caller
     C                   PARM                    Idx

      ** Warning fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    WFldNamArr
     C                   PARM                    WMsgIDArr
     C                   PARM                    WMsgDtaArr

      ** Array index (3P0) from/to caller
     C                   PARM                    WIdx

      ** Valid FATCA file layout (DS) to/from caller
     C                   PARM                    ValidFatca

     C     Idx           IFNE      0
     C                   GOTO      ESRValdNaFatca
     C                   ENDIF

      ** Validate US Indicia details 4

     C                   CALLB     'SDFTNH4VL'

      ** INPUTS :
      ** Response mode
      ** FATCA customer details
      ** FATCA customer details (old)

     C                   PARM      'S'           RespMode
     C                   PARM                    TranInFatca
     C                   PARM                    CuFaScFmt

      ** OUTPUTS :
      ** FATCA Customer Details OK inds
      ** Error fields/message IDs/message data (arrays) from/to caller
      ** Warning fields/message IDs/message data (arrays) from/to caller
      ** Valid FATCA Customer layout (DS) from/to caller

     C                   PARM                    OkFATCAdet

      * Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIDArr
     C                   PARM                    MsgDtaArr

      ** Array index (3P0) from/to caller
     C                   PARM                    Idx

      ** Warning fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    WFldNamArr
     C                   PARM                    WMsgIDArr
     C                   PARM                    WMsgDtaArr

      ** Array index (3P0) from/to caller
     C                   PARM                    WIdx

      ** Valid FATCA file layout (DS) to/from caller
     C                   PARM                    ValidFatca


     C     ESRValdNaFatcaENDSR

      *****************************************************************
      /EJECT
      *****************************************************************
      ** SRValdNaCRS - Validate Non-A/C Holder CRS details            *
      *****************************************************************

     C     SRValdNaCRS   BEGSR

     C                   EVAL      X = 1
     C                   EVAL      Y = 1
     C                   MOVEA     *BLANKS       PCrsdB(X)
     C                   MOVEA     *BLANKS       PCrsdF(X)
     C                   MOVEA     *BLANKS       PCrsdS(X)
     C**********         DOW       X < 31
     C                   DOW       X < 11
     C                   EVAL      Wtemp1 = %SUBST(TranInCr10:Y:2)
     C                   EVAL      Z = Y + 2
     C**********         EVAL      Wtemp2 = %SUBST(TranInCr10:Z:213)
     C                   EVAL      Wtemp2 = %SUBST(TranInCr10:Z:213)
     C                   EVAL      PCrsdB(X) = Wtemp1
     C                   MOVE      Wtemp2        PCrsdB(X)
     C                   EVAL      X = X + 1
     C**********         EVAL      Y = Y + 215
     C                   EVAL      Y = Y + 223
     C                   ENDDO

     C                   MOVEA     PCrsdB        PCrsdS
     C                   CALLB     'SDCRSNDFT'
     C                   PARM                    TranInNahl
     C                   PARM                    PCrsdS
     C                   PARM                    PCrsdF

     C                   EVAL      X = 1
     C**********         DOW       X < 31
     C                   DOW       X < 11
     C                   EVAL      PCountry = PCrsdF(X)

     C                   IF        PCountry <> *Blanks
     C                   CALLB     'SDCRSN3VL'

      ** Inputs
      ** Mode
     C                   PARM      'S'           RespMode
     C                   PARM                    DDNAHO

      ** CRS Country Transaction Details
     C                   PARM                    PCountry
     C                   PARM                    PCrsdS
     C                   PARM                    WINKJ
     C                   PARM                    PWarning

      ** Outputs
      ** Transaction Details OK inds
     C                   PARM                    OKCRSCtry

      ** Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIDArr
     C                   PARM                    MsgDtaArr

      ** Array index (3P0) from/to caller
     C                   PARM                    Idx

     C                   PARM                    WFldNamArr
     C                   PARM                    WMsgIDArr
     C                   PARM                    WMsgDtaArr
     C                   PARM                    WIdx_WVAL

      ** Valid Transaction details layout (DS) from/to caller
     C                   PARM                    PCrsdF

     C                   ENDIF

     C                   EVAL      X = X + 1
     C                   ENDDO

     C                   IF        Idx = 0
     C                   CALLB     'SDCRNH1VL'

      ** INPUTS :
      ** Response mode
      ** Non-A/C Holder Primary Details

     C                   PARM      'S'           RespMode
     C                   PARM                    TranInCRNS
     C                   PARM                    CuCrhScFmt
      **  New Non-A/C Holder in File Format
     C                   PARM                    ValidNaho
     C                   PARM                    ValidFatca
      ** CRS Country Transaction Details
     C                   PARM                    PCrsdS

      ** OUTPUTS :
      ** FATCA Customer Details OK inds
      ** Error fields/message IDs/message data (arrays) from/to caller
      ** Warning fields/message IDs/message data (arrays) from/to caller
      ** Valid FATCA Customer layout (DS) from/to caller

     C                   PARM                    OkCRNHdet

      * Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIDArr
     C                   PARM                    MsgDtaArr

      ** Array index (3P0) from/to caller
     C                   PARM                    Idx

      ** Warning fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    WFldNamArr
     C                   PARM                    WMsgIDArr
     C                   PARM                    WMsgDtaArr

      ** Array index (3P0) from/to caller
     C                   PARM                    WIdx_WVAL

      ** Valid CRS Non Account Holder
     C                   PARM                    ValidCRNH
     C                   ENDIF

     C                   ENDSR

      *****************************************************************
      /EJECT
      *****************************************************************
      ** SRValdCER076 - Validate Economic ID                          *
      *****************************************************************

     C     SRValdCER076  BEGSR

     C                   CALLB     'SDNAHL9VL'
      ** INPUTS :        ¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯
      ** Response mode
      ** Economic Id
      ** Non-A/C Holder Primary Details

     C                   PARM      'S'           RespMode
     C                   PARM                    DDEINO
     C                   PARM                    TranInNahl

      ** OUTPUTS :
      ** Economic Id OK ind
      ** Error fields/message IDs/message data (arrays) from/to caller
      ** Array index (3P0) from/to caller
      ** Warning fields/message IDs/message data (arrays) from/to caller
      ** Array index (3P0) from/to caller
      ** Valid Economic Id

     C                   PARM                    OKEINO
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIDArr
     C                   PARM                    MsgDtaArr
     C                   PARM                    Idx
     C                   PARM                    WFldNamArr
     C                   PARM                    WMsgIDArr
     C                   PARM                    WMsgDtaArr
     C                   PARM                    WIdx
     C                   PARM                    ValidEINO

     C                   ENDSR

      *****************************************************************
      /EJECT
      *****************************************************************
      ** SRValdNATX - Validate Country of Tax details                 *
      *****************************************************************

     C     SRValdNATX    BEGSR


     C                   MOVE      *BLANKS       Ct50ArrDSA
     C                   MOVE      *BLANKS       Ct50ArrDSD
     C                   MOVE      *BLANKS       DefaultNATX       1

s1   C**********         IF        DDACTN = 'I'
     C**********                   and D01CTTX = *Blanks
s1   C                   If        D01CTTX = *Blanks

s2   C                   IF        DDPIND = 'Y'
     C                   MOVE      'Y'           DefaultNATX

     C                   MOVE      *BLANKS       NwNatxScFm
     C                   MOVE      *BLANKS       Ct50ArrDS
     C                   EVAL      X = 0
     C     DDCOLC        SETLL     SDCTTXL2
     C     DDCOLC        READE     SDCTTXL2

s3   C                   DOW       NOT %EOF(SDCTTXL2)

     C                   EVAL      X = X + 1
     C                   EVAL      NSDDACTN = DDACTN
     C                   EVAL      NSDDNAHO = DDNAHO
     C                   EVAL      NSDDCTTX = EWCTRT
     C                   EVAL      NSDDETXS = EWTXS1
     C                   EVAL      NSDDCERF = *BLANKS
     C**********         EVAL      NSDDCEEX = *ZERO
     C                   EVAL      NSDDCEEX = *BLANKS
     C                   EVAL      NSDDNSTS = 'A'
     C
      *
      ** If CER048 is installed,supply certificate type,approval date
      ** and value date.
      *
 s4  C                   IF        CER048 = 'Y'
     C                   EVAL      NSDDCRTP = *BLANKS
     C**********         EVAL      NSDDCADT = *ZEROS
     C**********         EVAL      NSDDCVDT = *ZEROS
     C                   EVAL      NSDDCADT = *BLANKS
     C                   EVAL      NSDDCVDT = *BLANKS
 e4  C                   ENDIF

     C                   EVAL      Ct50Arr(X) = NwNatxScFm

     C     DDCOLC        READE     SDCTTXL2
 e3  C                   ENDDO

      ** Blank out country of residence

     C                   Move      *Blanks       Ct50Ctry          2
     C                   Move      *Blanks       BlkColc           2
     C                   EVAL      Z = X + 1
     C     BlkColc       SETLL     SDCTTXL2
     C     BlkColc       READE     SDCTTXL2

 s3  C                   DOW       NOT %EOF(SDCTTXL2)

     C                   EVAL      Y = 0
     C                   Move      *Blanks       Match             1
 s4  C                   If        Z > 1
 s5  C                   DOW       Y < Z
     C                   EVAL      Y = Y + 1
     C                   EVAL      Ct50Ctry = %SUBST(Ct50Arr(Y):12:2)
 s6  C                   If        EwCtrt = Ct50Ctry
     C                   EVAL      Match = 'Y'
 e6  C                   Endif
 e5  C                   Enddo
 e4  C                   Endif

 s4  C                   If        Z > 1
     C                             and Match <> 'Y'
     C                             or Z = 1
     C                   EVAL      X = X + 1
     C                   EVAL      NSDDACTN = DDACTN
     C                   EVAL      NSDDNAHO = DDNAHO
     C                   EVAL      NSDDCTTX = EWCTRT
     C                   EVAL      NSDDETXS = EWTXS1
     C                   EVAL      NSDDCERF = *BLANKS
     C**********         EVAL      NSDDCEEX = *ZERO
     C                   EVAL      NSDDCEEX = *BLANKS
     C                   EVAL      NSDDNSTS = 'A'
      *
     C                   IF        CER048 = 'Y'
     C                   EVAL      NSDDCRTP = *BLANKS
     C**********         EVAL      NSDDCADT = *ZEROS
     C**********         EVAL      NSDDCVDT = *ZEROS
     C                   EVAL      NSDDCADT = *BLANKS
     C                   EVAL      NSDDCVDT = *BLANKS
     C                   ENDIF

     C                   EVAL      Ct50Arr(X) = NwNatxScFm

 e4  C                   Endif

     C     BlkColc       READE     SDCTTXL2
 e3  C                   ENDDO

 e2  C                   ENDIF

      ** No defaulting needed

 x1  C                   Else

     C                   EVAL      X = 1
     C                   EVAL      Z = 1
     C                   MOVE      *BLANKS       Ct50ArrDS
 s2  C                   DOW       X < 51
     C                   EVAL      Ct50Arr(X) = %SUBST(TranInCt50:Z:55)
     C                   EVAL      X = X + 1
     C                   EVAL      Z = Z + 55
 e2  C                   ENDDO

     C**********         Exsr      SrRtvNatx
 e1  C                   Endif

     C                   Eval      TranInCt50 = Ct50ArrDS

     C                   Eval      NwNatxScFm = *Blanks
     C**********         Eval      NatxScFmA = *Blanks
     C**********         Eval      NatxScFmD = *Blanks

     C                   EVAL      X = 1
 s1  C                   DOW       X < 51

     C                   Eval      NwNatxScFm = Ct50Arr(X)
     C**********         Eval      NatxScFmA = Ct50ArrA(X)
     C**********         Eval      NatxScFmD = Ct50ArrD(X)

 s2  C**********         If        NwNatxScFm <> *Blanks
 s2  C                   If        NSDDCTTX <> *Blanks

      ***Validate*only*if*details*have*been*amended
      **********
 s3  C**********         If        DefaultNatx = *Blanks
     C**********                   and NwNatxScFm <> NatxScFmA
     C**********                   and NatxScFmA <> *Blanks
     C**********                   or DefaultNatx = *Blanks
     C**********                   and NwNatxScFm <> NatxScFmA
     C**********                   and NatxScFmA = *Blanks
     C**********                   and NwNatxScFm <> NatxScFmD
     C                   If        NSDDNAHO = *Blanks
     C                             and NSDDCTTX <> *Blanks
     C                   Eval      NSDDNAHO = DDNAHO
     C                   Endif

     C                   CALLB     'SDNATXVAL'
      *                  ¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯
      * Input Parameters :

      ** Return Code
      ** Mode = '*FRONT' (Front Office Transaction Interface)
      ** Mode = '      ' (Not Front Office Transaction Interface)
      ** Mode = '*RPR  ' (Repair function)
      ** Mode = '*SIN  ' (Screen Input function)
      ** Response mode (1A, from caller (A=Asynchronous, S=Synchronous))
      ** New Details in Screen Format
     C                   PARM      *Blanks       @Rtcd
     C                   PARM      '*NAHL'       ModeOfOp
     C                   PARM      'S'           RespMode
     C                   PARM                    NwNatxScFm

      * Output Parameters :

      ** Screen error indicators
      ** Error fields/message IDs/message data (arrays) from/to caller
      ** Array index (3P0) from/to caller
      ** New Details in File Format
     C                   PARM                    OkNatx
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIDArr
     C                   PARM                    MsgDtaArr
     C                   PARM                    Idx
     C                   PARM                    ValidNatx
     C                   PARM                    DDCOLC

     C                   Eval      Ct50Arr(X) = NwNatxScFm

     C                   Eval      NFNTNAHO = NSDDNAHO
     C                   Eval      NFNTCTTX = NSDDCTTX

     C                   EVAL      VNatxArr(X) = ValidNatx

 x3  C**********         else
      **********
     C**********         If        DefaultNatx = 'Y'
     C**********                   or DefaultNatx = *Blanks
     C**********                   and DDACTN = 'I'
     C**********         Eval      NFNTNAHO = NSDDNAHO
     C**********         Eval      NFNTCTTX = NSDDCTTX
     C**********         Eval      NFNTETXS = NSDDETXS
     C**********         Eval      NFNTCERF = NSDDCERF
     C**********         Eval      NFNTNSTS = NSDDNSTS
     C**********         Eval      NFNTCEEX = 0
     C**********         If        CER048 = 'Y'
     C**********         Eval      NFNTCRTP = NSDDCRTP
     C**********         Eval      NFNTCADT = 0
     C**********         Eval      NFNTCVDT = 0
     C**********         Endif
      **********
     C**********         EVAL      VNatxArr(X) = ValidNatx
     C**********         Endif
      **********
 e3  C**********         Endif
 e2  C                   Endif

     C                   EVAL      X = x + 1

 e1  C                   ENDDO

     C                   Eval      TranInCt50 = Ct50ArrDS

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRRtvNatx - Retrieve non-a/c holder Country of Tax details   *
      *                                                               *
      *****************************************************************
     C     SrRtvNatx     BEGSR

     C                   EVAL      Idy = 1
     C     DDNAHO        SETLL     SDNHTXL4
     C                   READ      SDNHTXL4
     C                   DOW       NOT %EOF(SDNHTXL4)
     C                             AND DDNAHO = NXNAHO
     C                   EVAL      TXACTN  = *BLANK
     C                   EVAL      TXNAHO  = NXNAHO
     C                   EVAL      TXCTTX  = NXCTTX
     C                   EVAL      TXETXS  = NXETXS
     C                   EVAL      TXCERF  = NXCERF
     C                   EVAL      TXNSTS  = NXNSTS
     C                   EVAL      TXCRTP  = NXCRTP

     C                   EVAL      TXCEEX  = *BLANK
     C                   IF        NXCEEX <> *ZERO
     C                   EVAL      PZDAYNO = NXCEEX
     C                   EXSR      SRZDATE2
     C                   MOVEL     PZDATE        TXCEEX
     C                   ENDIF

     C                   EVAL      TXCADT  = *BLANK
     C                   IF        NXCADT <> *ZERO
     C                   EVAL      PZDAYNO = NXCADT
     C                   EXSR      SRZDATE2
     C                   MOVEL     PZDATE        TXCADT
     C                   ENDIF

     C                   EVAL      TXCVDT  = *BLANK
     C                   IF        NXCVDT <> *ZERO
     C                   EVAL      PZDAYNO = NXCVDT
     C                   EXSR      SRZDATE2
     C                   MOVEL     PZDATE        TXCVDT
     C                   ENDIF

     C                   EVAL      CT50ArrA(Idy) = TranInCT501
     C                   EVAL      Idy =Idy + 1
     C                   READ      SDNHTXL4
     C                   ENDDO
      *
      ** If Insert, retrieve default details
      *
     C                   IF        DDACTN = 'I'

     C                   IF        DDPIND = 'Y'
     C                   MOVE      *BLANKS       NwNATXScFm
     C                   MOVE      *BLANKS       Ct50ArrDSD
     C                   EVAL      X = 0
     C     DDCOLC        SETLL     SDCTTXL2
     C     DDCOLC        READE     SDCTTXL2

     C                   DOW       NOT %EOF(SDCTTXL2)
     C                   EVAL      X = X + 1
     C                   EVAL      NSDDACTN = DDACTN
     C                   EVAL      NSDDNAHO = DDNAHO
     C                   EVAL      NSDDCTTX = EWCTRT
     C                   EVAL      NSDDETXS = EWTXS1
     C                   EVAL      NSDDCERF = *BLANKS
     C                   EVAL      NSDDCEEX = *BLANKS
     C                   EVAL      NSDDNSTS = 'A'
      *
      ** If CER048 is installed,supply certificate type,approval date
      ** and value date.
      *
     C                   IF        CER048 = 'Y'
     C                   EVAL      NSDDCRTP = *BLANKS
     C                   EVAL      NSDDCADT = *BLANKS
     C                   EVAL      NSDDCVDT = *BLANKS
     C                   ENDIF

     C                   EVAL      Ct50ArrD(X) = NwNatxScFm

     C     DDCOLC        READE     SDCTTXL2
     C                   ENDDO

      ** Blank out country of residence

     C                   Move      *Blanks       Ct50Ctry          2
     C                   Move      *Blanks       BlkColc           2
     C                   EVAL      Z = X + 1
     C     BlkColc       SETLL     SDCTTXL2
     C     BlkColc       READE     SDCTTXL2

     C                   DOW       NOT %EOF(SDCTTXL2)

     C                   EVAL      Y = 0
     C                   Move      *Blanks       Match             1
     C                   If        Z > 1
     C                   DOW       Y < Z
     C                   EVAL      Y = Y + 1
     C                   EVAL      Ct50Ctry = %SUBST(Ct50ArrD(Y):12:2)
     C                   If        EwCtrt = Ct50Ctry
     C                   EVAL      Match = 'Y'
     C                   Endif
     C                   Enddo
     C                   Endif

     C                   If        Z > 1
     C                             and Match <> 'Y'
     C                             or Z = 1
     C                   EVAL      X = X + 1
     C                   EVAL      NSDDACTN = DDACTN
     C                   EVAL      NSDDNAHO = DDNAHO
     C                   EVAL      NSDDCTTX = EWCTRT
     C                   EVAL      NSDDETXS = EWTXS1
     C                   EVAL      NSDDCERF = *BLANKS
     C                   EVAL      NSDDCEEX = *BLANKS
     C                   EVAL      NSDDNSTS = 'A'
      *
     C                   IF        CER048 = 'Y'
     C                   EVAL      NSDDCRTP = *BLANKS
     C                   EVAL      NSDDCADT = *BLANKS
     C                   EVAL      NSDDCVDT = *BLANKS
     C                   ENDIF

     C                   EVAL      Ct50ArrD(X) = NwNatxScFm

     C                   Endif

     C     BlkColc       READE     SDCTTXL2
     C                   Enddo

     C                   Endif
     C                   Endif

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
      ** SRWriteToDB   - Routine to control checking of error status and
      **    sending of messages/writing to the database
      *****************************************************************

     C     SRWritetoDb   BEGSR

     C                   IF        Idx = 0

     C                   EXSR      SRSetUpValid

     C                   IF        CGL132 = 'Y'
     C                   EVAL      V_FVUTIN = DDUTIN
     C                   ENDIF

     C                   IF        CGL157 = 'Y'
     C                   EVAL      NVLCDT = *ZERO
     C                   ENDIF

     C                   EXSR      UpdateDB


      * CER076 processing and check for SDVCRSND0 write - multiple writes

     C                   ENDIF

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      ** SRResetCYCLE - Reset error information that is gradually     *
      **              updated during each run of this program         *
      *****************************************************************

     C     SRResetCYCLE  BEGSR

     C                   RESET                   FldNameArr
     C                   RESET                   MsgIDArr
     C                   RESET                   MsgDtaArr
     C                   RESET                   Idx

     C                   RESET                   WFldNamArr
     C                   RESET                   WMsgIDArr
     C                   RESET                   WMsgDtaArr
     C                   RESET                   WIdx

     C                   RESET                   AmFldNamAr
     C                   RESET                   AmMsgIDArr
     C                   RESET                   AmMsgDtaAr
     C                   RESET                   AmIdx

     C                   RESET                   FldNoArr
     C                   CLEAR                   CuNahlScFm
     C                   CLEAR                   CuFaScFmt
     C                   CLEAR                   CuCrhScFmt
     C                   MOVEA     *BLANKS       PCrsdF
     C                   MOVEA     *BLANKS       PCrsdB
     C                   MOVE      *ALL'Y'       OKNaPrim
     C                   MOVE      *ALL'Y'       OKFatcaDet
     C                   MOVE      *ALL'Y'       OKCRNHDet
     C                   MOVE      *ALL'Y'       OKCRSCtry
     C                   MOVE      *ALL'Y'       OKNatx
     C                   CLEAR                   ValidNaho
     C                   CLEAR                   ValidFatca
     C                   CLEAR                   ValidCRNH
     C                   CLEAR                   SDVCRSN
     C                   CLEAR                   ValidNatx

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      ** SRSetUpValid - Set up additional fields that are needed on the
      **    Valid file record.
      *****************************************************************

     C     SRSetUpValid  BEGSR

      ** For Deletes put the complete (pre-existing) Non-A/C Holder
      **  into the Valid file record

     C                   IF           DDACTN = 'D'
     C                   MOVE      CuNahoFlFm    ValidNaho
     C                   ENDIF

      ** Set Valid file field(s) that are needed for all Action Codes

     C                   EVAL      V_NACHTP = DDACTN
     C                   EVAL      V_NANAHO = DDNAHO
     C                   EVAL      V_FVNAHO = DDNAHO
     C                   EVAL      V_NALUSR = DDLUSR

      ** Include Header fields that need to be o/p to the Valid file

     C                   EVAL      V_NAFRNT = APFOTranID
     C                   EVAL      V_NAREPA = APRprLocn
     C**********         EVAL      V_NATMST = TimeStamp
     C                   EVAL      V_FVFOID = APFOTranID
     C                   EVAL      V_FVREPA = APRprLocn
     C                   MOVE      TimeStamp     V_FVTMST

     C                   IF        CGL157 = 'Y'
     C                   EVAL      NVNAHR = DDNAHO
     C                   EVAL      NVFRNT = APFOTranID
     C                   EVAL      NVTMST = TimeStamp
     C                   EVAL      RVFRNT = APFOTranID
     C                   EVAL      RVTMST = TimeStamp
     C                   ENDIF

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * UPDATEDB - Update Database                                    *
      *                                                               *
      *****************************************************************

     C     UPDATEDB      BEGSR
      *
     C                   CALLB     'SDNAHLUPD'
     C                   PARM      *Blanks       @RTCD
     C                   PARM                    ValidNaho
     C                   PARM                    ValidFatca
     C                   PARM                    ValidCRNH
     C                   PARM                    PCrsdF


      ** Non-a/c Holder by Country of Tax updates.

     C                   If        CGL031 = 'Y' and CGL032 = 'Y'
     C                             or CGL132 = 'Y'

     C                   IF        @RTCD = *BLANKS AND
     C                             DDACTN = 'D'

     C                   EVAL      KNAHo = DDNAHO
     C     KNAHo         SETLL     SDNHTXL1
     C     KNAHo         READE     SDNHTXL1

     C                   DOW       NOT %EOF(SDNHTXL1)

     C                   CALLB     'SDNATXUPD'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM                    DDACTN
     C                   PARM                    CuNaTxFlFm

     C                   IF        @RTCD <> *BLANKS
     C                   EVAL      @RTCD = '*ERROR '
     C                   LEAVE
     C                   ENDIF

     C     KNAHo         READE     SDNHTXL1
     C                   ENDDO

     C                   ENDIF

     C                   IF        @RTCD = *BLANKS AND
     C                             DDACTN <> 'D'

      ** Delete all records prior to update/insert

     C                   Eval      PActn = 'D'

     C                   Eval      KNAHo = DDNAHO
     C     KNAHo         Setll     SDNHTXL1
     C     KNAHo         Reade     SDNHTXL1

     C                   Dow       NOT %EOF(SDNHTXL1)

     C                   CallB     'SDNATXUPD'
     C                   Parm      *BLANKS       @RTCD
     C                   Parm                    PActn
     C                   Parm                    CuNaTxFlFm

     C                   If        @Rtcd <> *BLANKS
     C                   Eval      @Rtcd = '*ERROR '
     C                   Leave
     C                   Endif

     C     KNAHo         Reade     SDNHTXL1
     C                   Enddo

     C                   EVAL      X = 1
     C                   DOW       X < 51

     C                   Eval      ValidNatx  = VNatxArr(X)

     C                   If        ValidNatx  <> *Blanks
     C                   CALLB     'SDNATXUPD'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM                    DDACTN
     C                   PARM                    ValidNatx
     C                   Endif

     C                   IF        @Rtcd <> *BLANKS
     C                   EVAL      @RTCD = '*ERROR '
     C                   LEAVE
     C                   ENDIF

     C                   Eval      X = X + 1

     C                   ENDDO

     C                   ENDIF
     C                   ENDIF

      ** Economic ID (CER076)
      *
     C                   If        CER076 = 'Y'

     C                   CALLB     'SDNAHL9UP'
     C                   PARM      *BLANKS       @Rtcd
     C                   PARM                    ValidNaho
     C                   PARM                    DDACTN
     C                   PARM                    ValidEino

     C                   Endif

      ** If there were any errors in the Update fucntions, Rollback any
      ** updates and end this program. otherwise, Commit the updates

     C     @RTCD         IFNE      *BLANK
     C                   ROLBK
     C                   EXSR      *PSSR
     C                   ELSE
     C                   Commit
     C                   ENDIF

     C                   IF        CGL132 = 'Y' AND
     C                             CGL133 = 'N'

     C                   CALL      'QCMDEXC'
     C                   PARM                    ##OV1
     C                   PARM                    WMsgLen

     C                   CALL      'QCMDEXC'
     C                   PARM                    ##OV3
     C                   PARM                    WMsgLen

     C                   CALL      'SD000732'
     C                   PARM      *BLANKS       PReturn
     C                   PARM      V_NANAHO      PTranID
     C                   PARM      'N'           PSource
     C                   PARM                    PClass
     C                   PARM                    PClass
     C                   PARM      ' '           PRepType
     C                   PARM      'A'           PMode

     C                   CALL      'QCMDEXC'
     C                   PARM                    ##OV2
     C                   PARM                    WMsgLen

     C                   CALL      'QCMDEXC'
     C                   PARM                    ##OV4
     C                   PARM                    WMsgLen

     C                   ENDIF

      ** If update not done due to record being updated by another
      *  workstation send message to screen.
     C
     C     @RTCD         IFEQ      '*RECUPD'
     C                   MOVEL     '*ANY'        FldNameArr(1)
     C                   MOVEL     DBerrUpd      MsgIdArr(1)
     C                   END
     C
     C                   ENDSR
      *****************************************************************
      /eject
      *****************************************************************
      ** SRDtaSubs - Data Substitution                                *
      *****************************************************************

     C     SRDtaSubs     BEGSR

      ** Convert file fields to screen format

     C                   RESET                   ReturnCode

     C                   CALLB     'SDNAHLCVT'
      ** Return Code     ¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯
      ** Non-A/C Holder - file formats
      ** Non-A/C Holder Details - screen formats

     C                   PARM                    ReturnCode
     C                   PARM                    CuNahoFlFm
     C                   PARM                    CuFaFilFmt
     C                   PARM                    CrFoFilFmt
     C                   PARM                    CuCrhFlFmt
     C                   PARM                    PCrsdF
     C                   PARM                    CuNahlScFm
     C                   PARM                    CuFaScFmt
     C                   PARM                    CurCuFOTH
     C                   PARM                    CuCrhScFmt
     C                   PARM                    PCrsdS

      ** Substitute the data for the various parts of the transaction,
      ** dependent on the flags that were set earlier.

     C                   IF        RepPrim = 'Y'

     C                   CLEAR                   IncData
     C                   CLEAR                   CurData
     C                   RESET                   ReturnCode

     C                   CALLB     'APDTASUBS'
      ** Return code     ¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯
      ** Substitution character
      ** Incoming Data
      ** Current Data

     C                   PARM                    ReturnCode
     C                   PARM                    GHSUBS
     C                   PARM      TranInNahl    IncData        2000
     C                   PARM      CuNahlScFm    CurData        2000

     C                   MOVEL     IncDATA       TranInNahl

     C                   IF        CGL132 = 'Y'
     C                   CLEAR                   IncData
     C                   CLEAR                   CurData
     C                   RESET                   ReturnCode

     C                   MOVE      TranInFATCA   IncData
     C                   MOVE      CuFaScFmt     CurData
     C                   CALLB     'APDTASUBS'
     C                   PARM                    ReturnCode
     C                   PARM                    GHSUBS
     C                   PARM                    IncData
     C                   PARM                    CurData

     C                   MOVEL     IncDATA       TranInFATCA
     C                   ENDIF

     C                   IF        CGL157 = 'Y'
     C                   CLEAR                   IncData
     C                   CLEAR                   CurData
     C                   RESET                   ReturnCode

     C                   MOVE      TranInCRNS    IncData
     C                   MOVE      CuCrhScFmt    CurData
     C                   CALLB     'APDTASUBS'
     C                   PARM                    ReturnCode
     C                   PARM                    GHSUBS
     C                   PARM                    IncData
     C                   PARM                    CurData

     C                   MOVEL     IncDATA       TranInCRNS

     C                   CLEAR                   IncData
     C                   CLEAR                   CurData
     C                   RESET                   ReturnCode

     C                   MOVE      TranInCR10    IncData
     C                   MOVEA     PCrsdS        CurData
     C                   CALLB     'APDTASUBS'
     C                   PARM                    ReturnCode
     C                   PARM                    GHSUBS
     C                   PARM                    IncData
     C                   PARM                    CurData

     C                   MOVEL     IncDATA       TranInCR10
     C                   ENDIF
     C                   ENDIF

     C                   ENDSR

      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * Parse_NAHL - Parse Non Account Holder Details                 *
      *                                                               *
      *****************************************************************
     C     Parse_NAHL    BEGSR

     C                   MOVEL     'SDNAHLPD'    FileName
     C                   EXSR      GETRCDLN
     C                   Z-ADD     RecordLen     NAHLLn

     C                   MOVEL     'SDFTNRPD'    FileName
     C                   EXSR      GETRCDLN
     C                   Z-ADD     RecordLen     FTNRLn

     C                   MOVEL     'SDCRNSPD'    FileName
     C                   EXSR      GETRCDLN
     C                   Z-ADD     RecordLen     CRNSLn

     C                   MOVEL     'SDCR10PD'    FileName
     C                   EXSR      GETRCDLN
     C                   Z-ADD     RecordLen     CR10Ln

     C                   MOVEL     'SDCT50PD'    FileName
     C                   EXSR      GETRCDLN
     C                   Z-ADD     RecordLen     CT50Ln

     C                   EVAL      Bfp = 1
     C                   EVAL      TranInNahl=%SUBST(Trans9999_1:Bfp:NAHLLn)
     C                   ADD       NAHLLn        Bfp
     C                   EVAL      DDAUTH = %SUBST(Trans9999_1:Bfp:1)
     C                   ADD       1             Bfp
     C                   EVAL      TranInFatca=%SUBST(Trans9999_1:Bfp:FTNRLn)
     C                   ADD       FTNRLn        Bfp
     C                   EVAL      TranInCRNS=%SUBST(Trans9999_1:Bfp:CRNSLn)
     C                   ADD       CRNSLn        Bfp
     C                   EVAL      DDEINO = %SUBST(Trans9999_1:Bfp:30)
     C                   ADD       30            Bfp
     C                   EVAL      TranInCr10=%SUBST(Trans9999_1:Bfp:Cr10Ln)
     C                   ADD       Cr10Ln        Bfp
     C                   EVAL      TranInCt50=%SUBST(Trans9999_1:Bfp:CT50Ln)
     C                   ADD       CT50Ln        Bfp

     C                   ENDSR

      ****************************************************************
      /EJECT
      ****************************************************************
      *                                                              *
      *  Get Record Lengths of Transaction Data Blocks               *
      *                                                              *
      ****************************************************************
     C     GETRCDLN      BEGSR

     C                   EVAL      RecordLen = 0
     C                   CALLB     'UTGETRCDLN'
      ** Return code
     C                   PARM                    ReturnCode
      ** Record length
     C                   PARM                    RecordLen
      ** File name
     C                   PARM                    FileName
      ** File library
     C                   PARM      '*LIBL     '  FileLib
      ** If file not found (or any other error) shut down the program
     C                   IF        ReturnCode <> *BLANKS
     C                   EXSR      *PSSR
     C                   ENDIF
      ** Clear the file name field to prevent it getting corrupted by
      ** later MOVELs.
     C                   CLEAR                   FileName

     C                   ENDSR
      *****************************************************************
      /EJECT
     C/COPY ZACPYSRC,PSSR_ILE
      ********************************************************************
      /EJECT
      *****************************************************************
      ** *INZSR - Program Initialisation routine                      *
      *****************************************************************

     C     *INZSR        BEGSR

     C     *Entry        PLIST

      ** Common header information (DS) from source system
      ** Transaction information
      ** Ultimate calling Program/Module/Procedure

     C                   PARM                    HeadIn
     C                   PARM                    Trans9999_1
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIDArr
     C                   PARM                    MsgDtaArr
     C                   PARM                    WFldNamArr
     C                   PARM                    WMsgIDArr
     C                   PARM                    WMsgDtaArr
     C                   PARM                    MsgFArray
     C                   PARM                    UpdateYN          1
     C                   PARM                    Buffer         9999
     C                   PARM                    APIRetc           1

      ** Set up the name of the primary and secondary message files from
      ** which the message handler will get the messages

     C                   EVAL      MsgFArray(1) = 'SDUSRMSG'
     C                   EVAL      MsgFArray(2) = 'DRSMM'
     C                   EVAL      MsgFArray(3) = 'Y2USRMSG'

      ** Access Bank details via access program
      ** (database error handling done in access program)

     C                   CALLB     'AOBANKR0'
     C                   PARM      '*DBERR '     Retcd
     C                   PARM      '*FIRST '     Option
     C     SDBANK        PARM      SDBANK        DSFDY

      ** Access API ICD via access program

     C                   CALLB     'AOAPIR0'
     C                   PARM      '*DBERR '     Retcd
     C                   PARM      '*FIRST '     Option
     C     SDAPI         PARM      SDAPI         DSFDY

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
     C                   EVAL      DBKEY = 'CSC011'
     C                   EVAL      DBFILE = 'SCSARDPD'
     C                   EVAL      DBASE = 001
     C                   EXSR      *PSSR
     C                   ENDIF

     C                   IF        PRtCd = *BLANKS
     C                   EVAL      CSC011 = 'Y'
     C                   IN        SDSTAT
     C                   IN        SC24X7
     C                   ENDIF

      ** Check whether CGL132 is available

     C                   CALL      'AOSARDR0'
     C                   PARM      *Blanks       Prtcd
     C                   PARM      '*VERIFY'     Poptn
     C                   PARM      'CGL132'      PSard
     C     SCSARD        PARM      SCSARD        DSFDY

     C                   IF        Prtcd <> *Blanks
     C                   IF        Prtcd <> '*NRF'
     C                   MOVEL     'SCSARDPD'    Dbfile
     C                   MOVEL     '904'         Dbase
     C                   MOVEL     PSard         Dbkey
     C                   EXSR      *PSSR
     C                   ENDIF
     C                   EVAL      CGL132 = 'N'
     C                   ELSE
     C                   EVAL      CGL132 = 'Y'
     C                   ENDIF

      ** Check whether CGL157 is available

     C                   CALL      'AOSARDR0'
     C                   PARM      *Blanks       Prtcd
     C                   PARM      '*VERIFY'     Poptn
     C                   PARM      'CGL157'      PSard
     C     SCSARD        PARM      SCSARD        DSFDY

     C                   IF        Prtcd <> *Blanks
     C                   IF        Prtcd <> '*NRF'
     C                   MOVEL     'SCSARDPD'    Dbfile
     C                   MOVEL     '905'         Dbase
     C                   MOVEL     PSard         Dbkey
     C                   EXSR      *PSSR
     C                   ENDIF
     C                   EVAL      CGL157 = 'N'
     C                   ELSE
     C                   EVAL      CGL157 = 'Y'
     C                   ENDIF

      ** Check if feature CER048 is enabled

     C                   CALL      'AOSARDR0'
     C                   PARM      *Blanks       Prtcd
     C                   PARM      '*VERIFY'     Poptn
     C                   PARM      'CER048'      PSard
     C     SCSARD        PARM      SCSARD        DSFDY

     C                   IF        Prtcd <> *Blanks
     C                   EVAL      CER048 = 'N'
     C                   ELSE
     C                   EVAL      CER048 = 'Y'
     C                   ENDIF

      ** Check if feature CER076 is enabled

     C                   CALL      'AOSARDR0'
     C                   PARM      *Blanks       Prtcd
     C                   PARM      '*VERIFY'     Poptn
     C                   PARM      'CER076'      PSard
     C     SCSARD        PARM      SCSARD        DSFDY

     C                   IF        Prtcd <> *Blanks
     C                   EVAL      CER076 = 'N'
     C                   ELSE
     C                   EVAL      CER076 = 'Y'
     C                   ENDIF

      ** Check if feature CGL031 is enabled

     C                   CALL      'AOSARDR0'
     C                   PARM      *Blanks       Prtcd
     C                   PARM      '*VERIFY'     Poptn
     C                   PARM      'CGL031'      PSard
     C     SCSARD        PARM      SCSARD        DSFDY

     C                   IF        Prtcd <> *Blanks
     C                   EVAL      CGL031 = 'N'
     C                   ELSE
     C                   EVAL      CGL031 = 'Y'
     C                   ENDIF

      ** Check if feature CGL133 is enabled

     C                   CALL      'AOSARDR0'
     C                   PARM      *Blanks       Prtcd
     C                   PARM      '*VERIFY'     Poptn
     C                   PARM      'CGL133'      PSard
     C     SCSARD        PARM      SCSARD        DSFDY

     C                   IF        Prtcd <> *Blanks
     C                   EVAL      CGL133 = 'N'
     C                   ELSE
     C                   EVAL      CGL133 = 'Y'
     C                   ENDIF

      ** Check if feature CSC022 is enabled

     C                   CALL      'AOSARDR0'
     C                   PARM      *Blanks       Prtcd
     C                   PARM      '*VERIFY'     Poptn
     C                   PARM      'CSC022'      PSard
     C     SCSARD        PARM      SCSARD        DSFDY

     C                   IF        Prtcd <> *Blanks
     C                   EVAL      CSC022 = 'N'
     C                   ELSE
     C                   EVAL      CSC022 = 'Y'
     C                   ENDIF

     C                   ENDSR
      *****************************************************************
**  CPY@
(c) Finastra International Limited 2021
** ##OV1
OVRDBF FILE(SDNAHOL0) TOFILE(SDNAHOL0) SHARE(*NO)
** ##OV2
DLTOVR FILE(SDNAHOL0)
** ##OV3
OVRDBF FILE(SDFTNHL0) TOFILE(SDFTNHL0) SHARE(*NO)
** ##OV4
DLTOVR FILE(SDFTNHL0)
