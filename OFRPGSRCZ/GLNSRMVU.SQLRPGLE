     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2014')
      *****************************************************************
/*STD *  RPGSQLMOD                                                    *
/*EXI *  TEXT('Midas OF Nostro Sweeping Rules Validation')
      *****************************************************************
      *                                                               *
      *  Midas - Application Program Interface Module                 *
      *                                                               *
      *  GLNSRMVU - Midas OF Nostro Sweeping Rules Validation         *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2014            *
      *                                                               *
      *  Last Amend No. MD034621           Date 16Jun15               *
      *  Prev Amend No. MD033486           Date 27Feb15               *
      *                 MD031768           Date 06Jan15               *
      *                 CGL158   *CREATE   Date 16Sep14               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD034621 - Telefonica Enhancement upgrade to SP9
      *  MD033486 - Add new Beneficiary Account field                 *
      *  MD031768 - External party fields not updated                 *
      *  CGL158 - Nostro Sweeping Rules Maintenance                   *
      *                                                               *
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
      *****************************************************************
      *
     FZAFLDNPD  IT   F   15        DISK    INFSR(*PSSR)
      *
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
      **    True       logical = *on (for indicator processing)
      **    False      logical = *off (for indicator processing)
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

      ** The maximum size of the appended error arrays
     D XArrayMax       C                   CONST(20)

      * Array of Fields in error.
     D FldNamXAr       S             10A   DIM(XArrayMax)

      * Array of error message IDs
     D MsgIDXAr        S                   DIM(XArrayMax) LIKE(#MsgId)

      ** Array of error message data.
     D MsgDtaXAr       S                   DIM(XArrayMax) LIKE(#MsgData)

      ** Array of Fields with warnings.
     D WFldNmXAr       S             10A   DIM(XArrayMax)

      ** Array of warning message IDs
     D WMsgIDXAr       S                   DIM(XArrayMax) LIKE(#MsgId)

      ** Array of warning message data.
     D WMsgDtaXAr      S                   DIM(XArrayMax) LIKE(#MsgData)


      ** Incoming header
     D HeadIn        E DS                  EXTNAME(APHEADPD)
      *
      ** Incoming Transaction
     D TranIn        E DS                  EXTNAME(GLNSRMTD)
     D***EXTERNAL             156    227                                                   MD031768
     D  EXTERNAL             142    213                                                    MD031768
     D***ORDERING             539    610                                                   MD031768
     D  ORDERING             383    454                                                    MD031768
     D***INTERMED             786    857                                                   MD031768
     D  INTERMED             630    701                                                    MD031768
     D***INTRFLD              751    997                                                   MD031768
     D  INTRFLD              595    841                                                    MD031768
     D***BANKFLD              998   1137                                                   MD031768
     D  BANKFLD              842    981                                                    MD031768
      *
      ** Outgoing Payment
     D TranInPrim    E DS                  EXTNAME(FTOPY1PD)
     D TranInSecA    E DS                  EXTNAME(FTOPY2PD)
     D TranInSecB    E DS                  EXTNAME(FTOPY3PD)

      ** Payment Extension Details layout
     D TranInPrmB    E DS                  EXTNAME(FTOPY1APD)

      * Flags to indicate whether transaction fields are valid
     D OKFlagsDS1    E DS                  EXTNAME(FTEOPY1PD)

      * Validation Work Fields
     D Val@Fields    E DS                  EXTNAME(FTV@OPAYPD)

      * Flags to indicate whether transaction fields are valid
     D OKFlagsDS2    E DS                  EXTNAME(FTEOPY2PD)

      ** Transfer Details in screen format
     D TrnDets       E DS                  EXTNAME(FTFTNTPD)
     D  InterBanks            63    237
     D  BanktoBankInf        238    377

      ** Transfer Details OK indicators
     D OKTrnDets     E DS                  EXTNAME(FTEFTNTPD)
     D  QOKBOKC      E                     EXTFLD(OKBOKC)
     D  QOKPRFC      E                     EXTFLD(OKPRFC)
     D  QOKINB1      E                     EXTFLD(OKINB1)
     D  QOKINB2      E                     EXTFLD(OKINB2)
     D  QOKINB3      E                     EXTFLD(OKINB3)
     D  QOKINB4      E                     EXTFLD(OKINB4)
     D  QOKINB5      E                     EXTFLD(OKINB5)

      ** Valid Transfer Details layout
     D ValidNoTr     E DS                  EXTNAME(FTVFTNTPD)

      * External DS for Funds Transfer details
     D SDFTFR        E DS                  EXTNAME(SDFTFRPD)

      * External DS for Branch details
     D SDBRCH        E DS                  EXTNAME(SDBRCHPD)

      * External DS for Nostro details
     D SDNOST        E DS                  EXTNAME(SDNOSTPD)

      * External DS for Customer details
     D SDCUST        E DS                  EXTNAME(SDCUSTPD)
     D  QQDFA1       E                     EXTFLD(QQDFAC)

      ** Midas Switchable features file accessed via access program
     D SCSARD        E DS                  EXTNAME(SCSARDPD)

      * First DS for Access programs - short data structure
     D DSFDY         E DS                  EXTNAME(DSFDY)

      * Second DS for Access programs - long data structure
     D DSSDY         E DS                  EXTNAME(DSSDY)

      * Data structure to retrieve multi branch indicator
     D TABTB         E DS                  EXTNAME(TABTB11)
     D  LCD1         E                     EXTFLD(LCD)

      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
      *
      ** ME1730 Parameter
     D PSNBRC          S              3A
     D PSBICA          S             11A
     D PSWIFT          S             11A
     D PORDBK          S            256A
     D PBBINF          S            256A
     D PSNCOR          S            256A
     D PRCCOR          S            256A
     D PORTCD          S              7A
      *
      ** Input parameter - Program to submit
     D NSRMParm        S           2000A
      *
      ** Program message queue
     D WPrgQ           S             10A
      *
      ** Index for arrays of error message ids, etc.
     D Idx             S              3  0
     D WIdx            S              3  0
     D WRun            S              1A   Inz
     D I               S              3S 0
      *
      ** Working variables
     D BUFFER          S           2000A
     D PRTCD           S              7A
     D POPTN           S              7A
     D PSARD           S              6A
     D PCNUM           S             10A
     D PKYST           S              7A
      *
     D WCNUM           S             10A
     D @KYST           S              7A
     D @KEY1           S             10A
     D WKEY            S              5A
     D WSWIFT          S             11A
     D @CUST           S              6A
     D @CYCD           S              3A
     D @ACSN           S              2A
     D @NONB           S              2A
     D @BRCD           S              3A
     D @CSSN           S             10A
     D @PNOI           S              1A
     D PACCD           S             10A

     D CFT148          S              1A
     D CFT014          S              1A
     D CFT004          S              1A
     D CSW203          S              1A
     D MT103           S              1A
     D GenFromIPay     S              1A                                                    MD034621
      *
      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
      *
      ** +----------------------------------------+
      ** ¦ Hook for non-core D-specs (all types)  ¦
      ** ¦ also any I-specs (if necessary)        ¦
      ** ¦ =====================================  ¦
      ** +----------------------------------------+
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      ** +--- Start of main processing -----------------------------------+
      ** ¦                                                                ¦
      ** ¦ Initial processing is performed automatically: the *INZSR is   ¦
      ** ¦ executed at program activation.                                ¦
      ** ¦                                                                ¦
      ** +----------------------------------------------------------------+
      *
     C                   MOVEL     NSRMParm      TranIn
      *
     C                   EXSR      MT103RTN
      *
      ** Other Nostro Code is blank
      *
     C                   IF        NRONOC = *BLANKS
      *
      ** Validate External Party 1 - 5
     C                   EXSR      VEXTERN
      *
      ** Validate Account with Bank/Ordering Bank 1- 5
     C                   EXSR      VACTBNK
      *
     C                   ENDIF
      *                                                                                     MD033486
      ** Validate Beneficiary Account                                                       MD033486
     C                   IF        NREXP1 <> *BLANKS AND                                    MD033486
     C                             NRBACT <> *BLANKS                                        MD033486
     C                   EXSR      VBENACT                                                  MD033486
     C                   ENDIF                                                              MD033486
      *
      ** Validate Intermediary 1 - 5
     C                   IF        INTRFLD <> *BLANKS
     C                   EXSR      VINTERM
     C                   ENDIF
      *
      ** Validate Bank to Bank Information 1- 5
     C                   IF        BANKFLD <> *BLANKS
     C                   EXSR      VBANKIN
     C                   ENDIF


     C                   SETON                                        LR
      *
      ** Remerge buffer with all relevant data structures
      *
     C                   EVAL      Buffer = TranIn
      *
     C                   RETURN
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * *INZSR - Program Initialisation routine                       *
      *                                                               *
      *****************************************************************
     C     *INZSR        BEGSR
      *
     C     *ENTRY        PLIST
      *
      ** Common header information (DS) from source system
      *
     C                   PARM                    HeadIn
      *
      ** Transaction information
      *
     C                   PARM                    NSRMParm
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIDArr
     C                   PARM                    MsgDtaArr
     C                   PARM                    WFldNamArr
     C                   PARM                    WMsgIDArr
     C                   PARM                    WMsgDtaArr
     C                   PARM                    MsgFArray
     C                   PARM                    Buffer

      ** Get Multi Branch Indicator

     C/EXEC SQL
     C+ Select * into :TABTB from TABTB11
     C/END-EXEC

      *
      ** Check if CFT148 is installed
      *
     C                   EVAL      CFT148 = 'N'
      *
     C                   CALL      'AOSARDR0'
     C                   PARM      *BLANKS       PRTCD
     C                   PARM      '*VERIFY'     POPTN
     C                   PARM      'CFT148'      PSARD
     C     SCSARD        PARM      SCSARD        DSFDY
      *
     C                   IF        PRTCD = *BLANKS
     C                   EVAL      CFT148 = 'Y'
     C                   ENDIF
      *
      ** Check if CFT014 is installed
      *
     C                   EVAL      CFT014 = 'N'
      *
     C                   CALL      'AOSARDR0'
     C                   PARM      *BLANKS       PRTCD
     C                   PARM      '*VERIFY'     POPTN
     C                   PARM      'CFT014'      PSARD
     C     SCSARD        PARM      SCSARD        DSFDY
      *
     C                   IF        PRTCD = *BLANKS
     C                   EVAL      CFT014 = 'Y'
     C                   ENDIF
      *
      ** Check if CFT004 is installed
      *
     C                   EVAL      CFT004 = 'N'
      *
     C                   CALL      'AOSARDR0'
     C                   PARM      *BLANKS       PRTCD
     C                   PARM      '*VERIFY'     POPTN
     C                   PARM      'CFT004'      PSARD
     C     SCSARD        PARM      SCSARD        DSFDY
      *
     C                   IF        PRTCD = *BLANKS
     C                   EVAL      CFT004 = 'Y'
     C                   ENDIF
      *
      ** Check if CSW203 is installed
      *
     C                   EVAL      CSW203 = 'N'
      *
     C                   CALL      'SWIF2003'
     C                   PARM      *BLANKS       PRTCD
      *
     C                   IF        PRTCD = 'CSW2003'
     C                   EVAL      CSW203 = 'Y'
     C                   ENDIF
      *
      *
      ** Set up the name of the primary and secondary message files from
      ** which the message handler will get the messages
      *
     C                   EVAL      MsgFArray(1) = 'MIDAS'
      *
     C                   ENDSR

      ******************************************************************
      /EJECT
      ******************************************************************
      *                                                                *
      * VEXTERN - Validate External Party 1 - 5                        *
      *                                                                *
      ******************************************************************
     C     VEXTERN       BEGSR
      *
      * Reset variables updated by each module
     C                   Exsr      RESETCYCLE
      *
      ** Move fields
     C                   CLEAR                   TranInPrim
     C                   CLEAR                   EXTERNAL
     C                   EVAL      SBRCA   =  NRBNBR
     C                   EVAL      SSTTP   =  NRSTTP
     C                   EVAL      SDST1   =  NRCCY + NRBNOC
     C                   EVAL      SSMCY   =  NRCCY
     C                   EVAL      SPCCY   =  NRCCY
     C                   EVAL      SPRFC   =  NRPRFC
     C                   EVAL      SORC1   =  NREXP1
     C**********         EVAL      SORC2   =  NREXP2                                        MD031768
     C**********         EVAL      SORC3   =  NREXP3                                        MD031768
     C**********         EVAL      SORC4   =  NREXP4                                        MD031768
     C**********         EVAL      SORC5   =  NREXP5                                        MD031768
     C                   EVAL      @CFT014 =  CFT014
     C                   EVAL      @CFT004 =  CFT004
     C                   EVAL      @CCY    =  NRCCY
     C                   EVAL      @MBIN   =  MBIN
     C                   EVAL      @DSTT   =  'F'
      *
      ** Validate
     C                   CALLB     'FTVODCS'
      * INPUTS
      *  Return Code
     C                   Parm                    RetCodeOut

      *  Screen fields
     C                   Parm                    TranInPrim
     C                   Parm                    TranInPrmB
     C                   Parm                    GenFromIPAY                                MD034621

     C                   Parm                    CFT148

      * OUTPUTS
      *  Error fields/message IDs/message data (arrays) from/to caller
     C                   Parm                    FldNamXAr
     C                   Parm                    MsgIDXAr
     C                   Parm                    MsgDtaXAr

     C                   Parm                    WFldNmXAr
     C                   Parm                    WMsgIDXAr
     C                   Parm                    WMsgDtaXAr

      *  OK Flags
     C                   Parm                    OKFlagsDS1

      *  Validation Work Fields
     C                   Parm                    Val@Fields

      *  Funds Transfer Details
     C                   Parm                    SDFTFR


     C                   IF        FldNamXAr(1)  = *BLANKS

     C                   EVAL      NREXP1  =  SORC1
     C**********         EVAL      NREXP2  =  SORC2                                         MD031768
     C**********         EVAL      NREXP3  =  SORC3                                         MD031768
     C**********         EVAL      NREXP4  =  SORC4                                         MD031768
     C**********         EVAL      NREXP5  =  SORC5                                         MD031768
      *
      ** Populate customer details
     C                   EVAL      PCNUM = NREXP1
      *
     C                   CALL      'AOCUSTR0'
     C                   PARM      *BLANKS       PRTCD
     C                   PARM      '*KEY   '     POPTN
     C                   PARM                    PCNUM
     C                   PARM      *BLANKS       PKYST
     C     SDCUST        PARM      *BLANKS       DSSDY

     C**********         IF        PRTCD <> *BLANKS                                         MD031768
      *
     C**********         EVAL      PCNUM = NREXP2                                           MD031768
      *
     C**********         CALL      'AOCUSTR0'                                               MD031768
     C**********         PARM      *BLANKS       PRTCD                                      MD031768
     C**********         PARM      '*KEY   '     POPTN                                      MD031768
     C**********         PARM                    PCNUM                                      MD031768
     C**********         PARM      *BLANKS       PKYST                                      MD031768
     C*****SDCUST        PARM      *BLANKS       DSSDY                                      MD031768
     C**********         ENDIF                                                              MD031768
      *
     C                   IF        PRTCD = *BLANKS
     C                   EVAL      NSEXSN = BBCSSN
     C                   EVAL      NSEXNM = BBCRNM
     C                   EVAL      NSEXTN = BBCRTN
     C                   EVAL      NSEXSI = BBCSID
     C                   ENDIF

     C                   ENDIF


     C                   IF        FldNamXAr(1) <> *Blanks
     C                   CLEAR                   FldNamXAr
     C                   EVAL      FldNamXAr(1) = 'NSEXP1'
     C                   ENDIF

     C                   IF        WFldNmXAr(1) <> *Blanks
     C                   CLEAR                   WFldNmXAr
     C                   EVAL      WFldNmXAr(1) = 'NSEXP1'
     C                   ENDIF

      * Update error info with that returned from the validation module
     C                   Exsr      UPDATERRS

     C                   ENDSR

      ******************************************************************
      /EJECT
      ******************************************************************
      *                                                                *
      * VACTBNK - Validate Account with Bank/Ordering Bank 1- 5        *
      *                                                                *
      ******************************************************************
     C     VACTBNK       BEGSR
      *
      * Reset variables updated by each module
     C                   Exsr      RESETCYCLE
      *
      ** Move fields
     C                   CLEAR                   TranInPrim
     C                   CLEAR                   ORDERING
     C                   EVAL      SSMCY   =  NRCCY
     C                   EVAL      SPCCY   =  NRCCY
     C                   EVAL      SBOCD   =  'CRED'
     C                   EVAL      SACB1   =  NRORC1
     C                   EVAL      SACB2   =  NRORC2
     C                   EVAL      SACB3   =  NRORC3
     C                   EVAL      SACB4   =  NRORC4
     C                   EVAL      SACB5   =  NRORC5
     C                   MOVEL     NRSTTP        @STMT
     C                   EVAL      @CFT014 =  CFT014
     C                   EVAL      @CFT004 =  CFT004
     C                   EVAL      @MT103  =  MT103
      *
      ** Validate
     C                   CALLB     'FTVACBA'
      * INPUTS
      *  Return Code
     C                   Parm                    RetCodeOut

      *  Screen fields
     C                   Parm                    TranInPrim
     C                   Parm                    TranInSecA
     C                   Parm                    TranInSecB
     C                   Parm      'GLNSRMVU'    WPrgQ

      * OUTPUTS
      *  Error fields/message IDs/message data (arrays) from/to caller
     C                   Parm                    FldNamXAr
     C                   Parm                    MsgIDXAr
     C                   Parm                    MsgDtaXAr

     C                   Parm                    WFldNmXAr
     C                   Parm                    WMsgIDXAr
     C                   Parm                    WMsgDtaXAr

      *  OK Flags
     C                   Parm                    OKFlagsDS2

      *  Validation Work Fields
     C                   Parm                    Val@Fields


     C                   IF        FldNamXAr(1)  = *BLANKS

     C                   EVAL      NRORC1  =  SACB1
     C                   EVAL      NRORC2  =  SACB2
     C                   EVAL      NRORC3  =  SACB3
     C                   EVAL      NRORC4  =  SACB4
     C                   EVAL      NRORC5  =  SACB5
      *
      ** Populate customer details
     C                   EVAL      PCNUM = NRORC1
      *
     C                   CALL      'AOCUSTR0'
     C                   PARM      *BLANKS       PRTCD
     C                   PARM      '*KEY   '     POPTN
     C                   PARM                    PCNUM
     C                   PARM      *BLANKS       PKYST
     C     SDCUST        PARM      *BLANKS       DSSDY

     C                   IF        PRTCD <> *BLANKS
      *
     C                   EVAL      PCNUM = NRORC2
      *
     C                   CALL      'AOCUSTR0'
     C                   PARM      *BLANKS       PRTCD
     C                   PARM      '*KEY   '     POPTN
     C                   PARM                    PCNUM
     C                   PARM      *BLANKS       PKYST
     C     SDCUST        PARM      *BLANKS       DSSDY
     C                   ENDIF
      *
     C                   IF        PRTCD = *BLANKS
     C                   EVAL      NRACSN = BBCSSN
     C                   EVAL      NRACNM = BBCRNM
     C                   EVAL      NRACTN = BBCRTN
     C                   EVAL      NRACID = BBCSID
     C                   ENDIF

     C                   ENDIF


     C                   IF        FldNamXAr(1) <> *Blanks
     C                   CLEAR                   FldNamXAr
     C                   EVAL      FldNamXAr(1) = 'NSORC1'
     C                   ENDIF

     C                   IF        WFldNmXAr(1) <> *Blanks
     C                   CLEAR                   WFldNmXAr
     C                   EVAL      WFldNmXAr(1) = 'NSORC1'
     C                   ENDIF

      * Update error info with that returned from the validation module
     C                   Exsr      UPDATERRS

     C                   ENDSR
                                                                                            MD033486
      ******************************************************************                    MD033486
      /EJECT                                                                                MD033486
      ******************************************************************                    MD033486
      *                                                                *                    MD033486
      * VBENACT - Validate Beneficiary Account                         *                    MD033486
      *                                                                *                    MD033486
      ******************************************************************                    MD033486
     C     VBENACT       BEGSR                                                              MD033486
      *                                                                                     MD033486
      * Reset variables updated by each module                                              MD033486
     C                   Exsr      RESETCYCLE                                               MD033486
      *                                                                                     MD033486
      ** Check Beneficiary Acct field                                                       MD033486
     C                   CLEAR                   TranInPrim                                 MD033486
                                                                                            MD033486
     C                   IF        %SUBST(NRBACT:1:1) <> '/'                                MD033486
                                                                                            MD033486
     C                   CLEAR                   FldNamXAr                                  MD033486
     C                   CLEAR                   MsgIdXAr                                   MD033486
     C                   EVAL      MsgIdXAr(1)  = '5047553'                                 MD033486
     C                   EVAL      FldNamXAr(1) = 'NSBACT'                                  MD033486
                                                                                            MD033486
     C                   ELSE                                                               MD033486
                                                                                            MD033486
     C                   EVAL      SBNC1   =  NRBACT                                        MD033486
     C                   EVAL      SBNC2   =  NRORC1                                        MD033486
      *                                                                                     MD033486
      ** Validate                                                                           MD033486
     C                   CALLB     'FTVBEBE'                                                MD033486
      * INPUTS                                                                              MD033486
      *  Return Code                                                                        MD033486
     C                   Parm                    RetCodeOut                                 MD033486
                                                                                            MD033486
      *  Screen fields                                                                      MD033486
     C                   Parm                    TranInSecA                                 MD033486
     C                   Parm                    TranInSecB                                 MD033486
     C                   Parm                    TranInPrim                                 MD033486
                                                                                            MD033486
      * OUTPUTS                                                                             MD033486
      *  Error fields/message IDs/message data (arrays) from/to caller                      MD033486
     C                   Parm                    FldNamXAr                                  MD033486
     C                   Parm                    MsgIDXAr                                   MD033486
     C                   Parm                    MsgDtaXAr                                  MD033486
                                                                                            MD033486
     C                   Parm                    WFldNmXAr                                  MD033486
     C                   Parm                    WMsgIDXAr                                  MD033486
     C                   Parm                    WMsgDtaXAr                                 MD033486
                                                                                            MD033486
      *  OK Flags                                                                           MD033486
     C                   Parm                    OKFlagsDS2                                 MD033486
                                                                                            MD033486
      *  Validation Work Fields                                                             MD033486
     C                   Parm                    Val@Fields                                 MD033486
                                                                                            MD033486
                                                                                            MD033486
     C                   IF        FldNamXAr(1)  = *BLANKS                                  MD033486
     C                   EVAL      NRBACT  =   SBNC1                                        MD033486
     C                   ENDIF                                                              MD033486
                                                                                            MD033486
     C                   IF        FldNamXAr(1) <> *Blanks                                  MD033486
     C                   CLEAR                   FldNamXAr                                  MD033486
     C                   EVAL      FldNamXAr(1) = 'NSBACT'                                  MD033486
     C                   ENDIF                                                              MD033486
                                                                                            MD033486
     C                   IF        WFldNmXAr(1) <> *Blanks                                  MD033486
     C                   CLEAR                   WFldNmXAr                                  MD033486
     C                   EVAL      WFldNmXAr(1) = 'NSBACT'                                  MD033486
     C                   ENDIF                                                              MD033486
                                                                                            MD033486
     C                   ENDIF                                                              MD033486
                                                                                            MD033486
      * Update error info with that returned from the validation module                     MD033486
     C                   Exsr      UPDATERRS                                                MD033486
                                                                                            MD033486
     C                   ENDSR                                                              MD033486

      ******************************************************************
      /EJECT
      ******************************************************************
      *                                                                *
      * VINTERM - Validate Intermediary 1 - 5                          *
      *                                                                *
      ******************************************************************
     C     VINTERM       BEGSR
      *
      * Reset variables updated by each module
     C                   Exsr      RESETCYCLE
      *
      ** Move fields
     C                   CLEAR                   TrnDets
     C                   CLEAR                   INTERMED
     C                   EVAL      NTINT1  =  NRCIB1
     C                   EVAL      NTINT2  =  NRCIB2
     C                   EVAL      NTINT3  =  NRCIB3
     C                   EVAL      NTINT4  =  NRCIB4
     C                   EVAL      NTINT5  =  NRCIB5
      *
      ** Validate Intermediary Bank

     C                   CALLB     'FTVINTB'
      *
      * Return Code
     C                   PARM                    RetCodeOut
      *
      ** Screen Fields
     C                   PARM                    TrnDets
      *
      * Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
      *
      * Warning fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    WFldNmXAr
     C                   PARM                    WMsgIDXAr
     C                   PARM                    WMsgDtaXAr
      *
      ** OK Flags
     C                   PARM                    OKTrnDets
      *
      ** Validation Fields
     C                   PARM                    ValidNoTr


     C                   IF        FldNamXAr(1)  = *BLANKS

     C                   EVAL      NRCIB1  =  NTINT1
     C                   EVAL      NRCIB2  =  NTINT2
     C                   EVAL      NRCIB3  =  NTINT3
     C                   EVAL      NRCIB4  =  NTINT4
     C                   EVAL      NRCIB5  =  NTINT5
      *
      ** Populate customer details
     C                   EVAL      PCNUM = NRCIB1
      *
     C                   CALL      'AOCUSTR0'
     C                   PARM      *BLANKS       PRTCD
     C                   PARM      '*KEY   '     POPTN
     C                   PARM                    PCNUM
     C                   PARM      *BLANKS       PKYST
     C     SDCUST        PARM      *BLANKS       DSSDY
      *
     C                   IF        PRTCD <> *BLANKS
      *
     C                   EVAL      PCNUM = NRCIB2
      *
     C                   CALL      'AOCUSTR0'
     C                   PARM      *BLANKS       PRTCD
     C                   PARM      '*KEY   '     POPTN
     C                   PARM                    PCNUM
     C                   PARM      *BLANKS       PKYST
     C     SDCUST        PARM      *BLANKS       DSSDY
     C                   ENDIF
      *
     C                   IF        PRTCD = *BLANKS
     C                   EVAL      NRIBSN = BBCSSN
     C                   EVAL      NRIBNM = BBCRNM
     C                   EVAL      NRIBTN = BBCRTN
     C                   EVAL      NRIBID = BBCSID
     C                   ENDIF

     C                   ENDIF

     C                   IF        FldNamXAr(1) <> *Blanks
     C                   CLEAR                   FldNamXAr
     C                   EVAL      FldNamXAr(1) = 'NSCIB1'
     C                   ENDIF

     C                   IF        WFldNmXAr(1) <> *Blanks
     C                   CLEAR                   WFldNmXAr
     C                   EVAL      WFldNmXAr(1) = 'NSCIB1'
     C                   ENDIF

      * Update error info with that returned from the validation module
     C                   Exsr      UPDATERRS

     C                   ENDSR

      ******************************************************************
      /EJECT
      ******************************************************************
      *                                                                *
      * VBANKIN - Validate Bank to Bank Information 1- 5               *
      *                                                                *
      ******************************************************************
     C     VBANKIN       BEGSR

      * Reset variables updated by validation

     C                   EXSR      RESETCYCLE
      *
      ** Move fields
     C                   CLEAR                   TrnDets
     C                   EVAL      NTBBI1  =  NRBBI1
     C                   EVAL      NTBBI2  =  NRBBI2
     C                   EVAL      NTBBI3  =  NRBBI3
     C                   EVAL      NTBBI4  =  NRBBI4

      ** Validate Bank to Bank Info

     C                   CALLB     'FTVBTBI'
      *
      * Return Code
     C                   PARM                    RetCodeOut
      *
      ** Screen Fields
     C                   PARM                    TrnDets
      *
      * Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
      *
      * Warning fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    WFldNmXAr
     C                   PARM                    WMsgIDXAr
     C                   PARM                    WMsgDtaXAr
      *
      ** OK Flags
     C                   PARM                    OKTrnDets
      *
      ** Validation Fields
     C                   PARM                    ValidNoTr


     C                   IF        FldNamXAr(1)  = *BLANKS
     C                   EVAL      NRBBI1  =  NTBBI1
     C                   EVAL      NRBBI2  =  NTBBI2
     C                   EVAL      NRBBI3  =  NTBBI3
     C                   EVAL      NRBBI4  =  NTBBI4
     C                   ENDIF


     C                   IF        FldNamXAr(1) <> *Blanks
     C                   CLEAR                   FldNamXAr
     C                   EVAL      FldNamXAr(1) = 'NSBBI1'
     C                   ENDIF

     C                   IF        WFldNmXAr(1) <> *Blanks
     C                   CLEAR                   WFldNmXAr
     C                   EVAL      WFldNmXAr(1) = 'NSBBI1'
     C                   ENDIF


      * Update error info with that returned from the validation module
     C                   Exsr      UPDATERRS

     C                   ENDSR


      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * RESETCYCLE - Reset error information that is gradually        *
      *              updated during each run of this program          *
      *                                                               *
      *****************************************************************
     C     RESETCYCLE    BEGSR

     C                   EVAL      RetCodeOut = *Blanks
      *
      * Reset error & warning fields/message IDs/message data (arrays)
     C                   MOVEL     *BLANK        FldNamXAr
     C                   MOVEL     *BLANK        MsgIDXAr
     C                   MOVEL     *BLANK        MsgDtaXAr
     C                   MOVEL     *BLANK        WFldNmXAr
     C                   MOVEL     *BLANK        WMsgIDXAr
     C                   MOVEL     *BLANK        WMsgDtaXAr

     C                   Eval      OKFlagsDS1 = (*ALL'Y')
     C                   Eval      OKFlagsDS2 = (*ALL'Y')
     C                   Eval      OKTrnDets  = (*ALL'Y')

     C                   ENDSR

      *****************************************************************
      /EJECT
      *****************************************************************
      * UPDATERRS - Update error information with that received back  *
      *    from each validation module.                               *
      *****************************************************************

     C     UPDATERRS     BEGSR
      *
      * Update error fields/message IDs/message data (arrays)
      *
     C                   Z-ADD     1             I
     C     *BLANK        LOOKUP    FldNameArr(I)                          99
     C     *IN99         IFEQ      '1'
     C                   MOVEA     FldNamXAr     FlDNameArr(I)
     C                   MOVEA     MsgIDXAr      MsgIdArr(I)
     C                   MOVEA     MsgDtaXAr     MsgDtaArr(I)
     C                   END
      *
      * Set Error Index
     C                   Z-ADD     1             I
     C     *BLANK        LOOKUP    FldNameArr(I)                          99
     C     I             SUB       1             Idx
      *
      * Update warning fields/message IDs/message data (arrays)
      *
     C                   Z-ADD     1             I
     C     *BLANK        LOOKUP    WFldNamArr(I)                          99
     C     *IN99         IFEQ      '1'
     C                   MOVEA     WFldNmXAr     WFldNamArr(I)
     C                   MOVEA     WMsgIDXAr     WMsgIDArr(I)
     C                   MOVEA     WMsgDtaXAr    WMsgDtaArr(I)
     C                   END
      *
      * Set Warning Index
     C                   Z-ADD     1             I
     C     *BLANK        LOOKUP    WFldNamArr(I)                          99
     C     I             SUB       1             WIdx
      *
     C                   ENDSR
      ******************************************************************
      /EJECT
      ******************************************************************
      *                                                                *
      * MT103RTN - Check for @MT103 Routine                            *
      *                                                                *
      ******************************************************************
     C     MT103RTN      BEGSR

     C                   IF        CFT014 = 'Y'
      *
     C                   Eval      MT103 =  *Blank
      *
     C                   Eval      PSNBRC = *Blank
     C                   Eval      PSBICA = *Blank
     C                   Eval      PSWIFT = *Blank
     C                   Eval      PORDBK = *Blank
     C                   Eval      PORTCD = *Blank
     C                   Eval      WSWIFT = *Blank
     C                   Eval      WCNUM = *Blank
      *
      ** Get SWIFT-BIC of destination
      *
     C                   If        @DSTT = 'S'
     C     11            SubSt     SDST1:1       WSWIFT
     C                   EndIf
      *
      ** Destination type is a full nostro 'F', customer number 'C'
      ** retail account 'R' or GL account 'G', get SWIFT ID through
      ** customer number
      *
     C                   If        (@DSTT = 'F') Or (@DSTT = 'C') Or
     C                             (@DSTT = 'R') Or (@DSTT = 'G')
      *
     C                   Select
     C                   When      @DSTT = 'F'
     C     3             SubSt     SDST1:1       @CYCD
     C     2             SubSt     SDST1:4       @NONB
     C                   Call      'AONOSTR0'
     C                   Parm      *Blanks       @RTCD
     C                   Parm      '*KEY   '     @OPTN
     C                   Parm      *Blanks       @CUST
     C                   Parm                    @CYCD
     C                   PARM      *BLANKS       PACCD
     C                   Parm      *Blanks       @ACSN
     C                   Parm                    @NONB
     C                   Parm      *Blanks       @BRCD
     C                   Parm      *Blanks       @CSSN
     C                   Parm      *Blanks       @PNOI
     C     SDNOST        Parm      SDNOST        DSFDY
      *
      ** Error on call
      *
     C                   If        @RTCD <> *Blanks
     C                   Movel     'SDNOSTPD'    DBFILE
     C                   Movel     '081'         DBASE
     C                   Movel     @CYCD         WKEY
     C                   Move      @NONB         WKEY
     C                   Movel     WKEY          DBKEY
     C                   Exsr      *PSSR
     C                   EndIf
     C                   Movel     A7CUST        WCNUM
      *
     C                   When      @DSTT = 'C'
     C     10            SubSt     SDST1:1       WCNUM
      *
     C                   Other
     C     6             SubSt     SDST1:1       WCNUM
     C                   EndSl
      *
      ** Access customer's file to get SWIFT id
      *
     C                   Call      'AOCUSTR0'
     C                   Parm      *Blanks       @RTCD
     C                   Parm      '*KEY   '     @OPTN
     C                   Parm      WCNUM         @KEY1
     C                   Parm      *Blanks       @KYST
     C     SDCUST        Parm      SDCUST        DSSDY
      *
     C                   If        @RTCD = *Blank
     C                   If        BBCSID <> *Blank
     C                   Movel     BBCSID        WSWIFT
     C                   EndIf
     C                   Else
     C                   Movel     'SDCUSTPD'    DBFILE
     C                   Movel     '082'         DBASE
     C                   Movel     WCNUM         DBKEY
     C                   Exsr      *PSSR
     C                   EndIf
     C                   EndIf
      *
      ** If CSW203 is installed, ME1730 will not be called. Default
      ** MT103 TO 'Y'
      *
     C                   IF        CSW203 = 'Y'
     C                   EVAL      MT103  = 'Y'
     C                   ELSE
      *
      ** Setup parameter to ME1730
      *
     C                   If        WSWIFT <> *Blank
     C                   Movel     SBRCA         PSNBRC
     C                   CALL      'AOBRCHR1'
     C                   Parm      *Blanks       @RTCD
     C                   Parm      '*KEY   '     @OPTN
     C                   Parm      SBRCA         @BRCD
     C     SDBRCH        PARM      SDBRCH        DSSDY
      *
     C                   If        @RTCD <> *Blank
     C                   Movel     'SDBRCHPD'    DBFILE
     C                   Movel     '083'         DBASE
     C                   Movel     SBRCA         DBKEY
     C                   Exsr      *PSSR
     C                   EndIf
     C                   Movel     A8BTID        PSBICA
     C                   Movel     WSWIFT        PSWIFT
     C                   Movel     SORBK         PORDBK
      *
      ** Call ME1730
      *
     C                   Call      'ME1730'
     C                   Parm                    PSNBRC
     C                   Parm                    PSBICA
     C                   Parm                    PSWIFT
     C                   Parm                    PORDBK
     C                   Parm                    PBBINF
     C                   Parm                    PSNCOR
     C                   Parm                    PRCCOR
     C                   Parm                    PORTCD
      *
     C                   If        PORTCD = '*ERROR '
     C                   Movel     'ME1730'      DBFILE
     C                   Movel     '084'         DBASE
     C                   Movel     '*CALL   '    DBKEY
     C                   Exsr      *PSSR
     C                   Else
     C                   If        PORTCD = '*CRT103'
     C                   Move      'Y'           MT103
     C                   EndIf
     C                   EndIf
     C                   EndIf
      *
     C                   ENDIF
     C                   ENDIF
      *
     C                   ENDSR

      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  *PSSR  - Program exception error routine                     *
      *           Called automatically if a program error occurs,     *
      *           or directly by the program code using EXSR.         *
      *           This subroutine DUMPs the program just once.        *
      *                                                               *
      *****************************************************************

     C     *PSSR         BEGSR

     C                   IF        WRun = *BLANK
     C                   EVAL      WRun = 'Y'
     C                   DUMP
     C                   CALL      'DBERRCTL'
     C                   ENDIF

     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   EVAL      *INLR = *ON

     C                   RETURN

     C                   ENDSR

