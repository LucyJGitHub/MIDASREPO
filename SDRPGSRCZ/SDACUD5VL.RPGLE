     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2013')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas SD Additional Customer ext scr 5 validn')        *
      *****************************************************************
      *                                                               *
      *  Midas - Standing Data ILE Module                             *
      *                                                               *
      *  SDACUD5VL - Transactions Details 5 Validation                *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2013            *
      *                                                               *
      *  Last Amend No. MD026629           Date 09May14               *
      *  Last Amend No. MD026540           Date 12May14               *
      *  Prev Amend No. CGL132  *CREATE    Date 01May13               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD026629 - Unusual behavior of Withholding tax and           *
      *             Additional TIN for Customers                      *
      *  MD026540 - Validate Country of TIN againsts Country of       *
      *             Domicile passed                                   *
      *  CGL132 - FATCA Phase 1 - Customers' Identification and       *
      *           Classification - Master                             *
      *                                                               *
      *****************************************************************
 
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
     FSDCUSTL0  IF   E           K DISK    INFSR(*PSSR)
 
      ** Hook to enable non-core files to be included
 
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ Automatically included D-specs       ¦
      ** ¦ ==============================       ¦
      ** +--------------------------------------+
 
      ** The following /COPY line includes (among others) the LDA layout
      ** and the copyright array definition:
      /COPY ZACPYSRC,STD_D_SPEC
 
      ** The following /COPY includes the MM standard declares:
      /COPY ZACPYSRC,STDDECLARE
 
      ** The following /COPY line includes all the defined fields in the
      ** Program Status Data Structures.  They have meaningful
      ** names, prefixed by 'PS'.
      /COPY ZACPYSRC,PSDS
 
      ** The following /COPY line includes the definitions for error and
      ** warning message arrays.
      /COPY ZACPYSRC,ERR_ARRAYS
 
      ** The following /COPY line includes all the definitions of the
      ** appended error arrays, including the named constant giving the size
      ** of the arrays.
      /COPY ZACPYSRC,ERR_XARRYS
 
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
     D TrnDets       E DS                  EXTNAME(SDCUADPD)
     D                                     PREFIX(A)
     D TrnDets5      E DS                  EXTNAME(SDACU5DPD)
 
     D TranWrk         DS
     D  TranWFill                  1316
     D  TranWDets5                         LIKE(TrnDets5)
 
      ** Transaction Details OK indicators
     D OKTrnDets5    E DS                  EXTNAME(SDEACU5PD)
     D                                     PREFIX(DD)
 
      ** Valid Transaction Details layout
     D ValidCust     E DS                  EXTNAME(SDVCUADPD)
 
      ** External DS for Bank Details
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
 
      ** External DS for Country Details
     D SDCUST        E DS                  EXTNAME(SDCUSTPD)
 
      **  Short DS for access programs
     D DSFDY         E DS                  EXTNAME(DSFDY)
 
      **  Long DS for access programs
     D DSSDY         E DS                  EXTNAME(DSSDY)
 
      ** Midas SD Midas modules Data Structure
     D SDMMOD        E DS                  EXTNAME(SDMMODPD)
 
     D ZMUSER          DS            17
     D  USRBCH                11     13
 
     D ValPair         DS                  QUALIFIED DIM(4)
     D  DDATIN                       25A
     D  DDATNC                        2A
 
     D ArrCnt          S              1  0 INZ(1)
     D ArrCntIn        S              1  0 INZ(1)
     D ArrCntRsq       S              1  0 INZ(1)
     D WTINSetIn       S             27A   DIM(4) INZ(*blanks)
     D WTINSetRsq      S             27A   DIM(4) INZ(*blanks)
     D WTINFld         S             10A   INZ(*blanks)
     D WOKDetArr       S              2A   DIM(4) INZ(*blanks)
     D WDATINOK        S              1A   INZ(*blanks)
     D WDATNCOK        S              1A   INZ(*blanks)
     D WDATIN          S             25A   INZ(*blanks)
     D WDATNC          S              2A   INZ(*blanks)
     D WDupTC          S              1  0 INZ(0)
     D WDCnt           S              1  0 INZ(0)
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
      ** Parameter for *Entry
     D RespMode        S              1A
 
      ** Customer Numbder
     D DDCUST          S              6A
      ** Country of Domicile (Location) from buffer                                         MD026540
     D DDCOLC          S              2A                                                    MD026540
 
      ** Parameter for Access Object
     D PRtcd           S              7A
     D POptn           S              7A
     D PSard           S              6A
     D CGL032          S              1A
 
      ** Work fields for bank data
     D WKDFIN          S                   LIKE(BJDFIN)
     D WKRDNB          S                   LIKE(BJRDNB)
     D WKCYCD          S                   LIKE(BJCYCD)
     D PDate           S              8A
 
      ** Index for arrays of of error message ids etc
     D Idx             S              3P 0
 
      ** Index for arrays of of warning message ids etc
     D WIdx            S              3P 0
 
      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
 
      ** +----------------------------------------+
      ** ¦ Hook for non-core D-specs (all types)  ¦
      ** ¦ also any I-specs (if necessary)        ¦
      ** ¦ =====================================  ¦
      ** +----------------------------------------+
     I
      *****************************************************************
      /EJECT
      *****************************************************************
 
      ** +--- Start of Main processing -----------------------------------+
      ** ¦                                                                ¦
      ** ¦ Initial processing is performed automatically: the *inzsr is   ¦
      ** ¦ executed at program activation.                                ¦
      ** ¦                                                                ¦
      ** +----------------------------------------------------------------+
 
     C                   EVAL      TranWrk = TrnDets
     C                   EVAL      TrnDets5 = TranWDets5
 
     C                   EXSR      SRRTVCUS
     C                   EXSR      SRVMGGAP
     C
     C                   EVAL      OKTrnDets5 = *blanks
     C                   EVAL      WOKDetArr = *blanks
     C                   EVAL      ValPair = WTINSetRsq
     C                   EVAL      ArrCnt = 1
 
     C                   DO        4             ArrCnt
      ** Setup Work Var for SR
     C                   EVAL      WDATINOK = *Blanks
     C                   EVAL      WDATNCOK = *Blanks
     C                   EVAL      WDATIN = ValPair(ArrCnt).DDATIN
     C                   EVAL      WDATNC = ValPair(ArrCnt).DDATNC
      ** Validate Inputs
     C                   IF        WDATIN <> *blanks OR WDATNC <> *blanks
     C                   EXSR      SRVCTINO
     C                   EXSR      SRVCATNC
     C                   ENDIF
      ** Keep Validation Flags
     C                   EVAL      WOKDetArr(ArrCnt) = WDATINOK + WDATNCOK
 
     C                   ENDDO
 
      ** Move Validation Flags Set for Output
     C                   MOVEA     WOKDetArr     OKTrnDets5
 
     C                   EVAL      TranWDets5 = TrnDets5
     C                   EVAL      TrnDets = TranWrk
 
      ** Return to Caller
     C                   RETURN
      *****************************************************************
      /EJECT
      *****************************************************************
      * SRMngGap - Manage Gaps in Fields                              *
      *****************************************************************
     C     SRVMGGAP      BEGSR
     C
     C                   MOVEA     TrnDets5      WTINSetIn
     C                   EVAL      ArrCntIn = 1
     C                   EVAL      ArrCntRsq = 1
     C                   EVAL      WTINSetRsq = *blanks
 
      ** Resequence items to prevent gaps
     C                   DO        4             ArrCntIn
     C                   IF        WTINSetIn(ArrCntIn) <> *blanks
     C                   EVAL      WTINSetRsq(ArrCntRsq) = WTINSetIn(ArrCntIn)
     C                   EVAL      ArrCntRsq += 1
     C                   ENDIF
     C                   ENDDO
 
      ** Move the gapless set back to the display format
     C                   MOVEA     WTINSetRsq    TrnDets5
 
      ** Move the details to file format
     C                   EVAL      ADTIN2 = DDTIN2
     C                   EVAL      ADTNC2 = DDTNC2
     C                   EVAL      ADTIN3 = DDTIN3
     C                   EVAL      ADTNC3 = DDTNC3
     C                   EVAL      ADTIN4 = DDTIN4
     C                   EVAL      ADTNC4 = DDTNC4
     C                   EVAL      ADTIN5 = DDTIN5
     C                   EVAL      ADTNC5 = DDTNC5
     C
     C     SRVMGGAPE     ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * SRVCTINO - Validate Tax Identification Number                 *
      *****************************************************************
     C     SRVCTINO      BEGSR
 
      ** Reset variables updated by each module
     C                   EXSR      SRRESETERRS
     C**********         EVAL      WTINFld = 'DDTIN' + %char(ArrCnt+1)                      MD026629
     C                   EVAL      WTINFld = 'DDTNN' + %char(ArrCnt+1)                      MD026629
 
      ** Tax Identification Number cannot be blank when country is specified
     C                   IF        WDATIN = *blanks and WDATNC <> *blanks
     C                   MOVE      'N'           WDATINOK
     C                   ADD       1             Idx
     C                   MOVEL     WTINFld       FldNamXAr(Idx)
     C                   MOVEL     'USS0453'     MsgIdXAr(Idx)
     C                   ENDIF
     C                   EVAL      WTINFld = ''
 
      ** No further validation needed as the field is free format
 
      ** Update error info with that returned from the validation module
     C                   EXSR      SRUPDATERRS
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * SRVCATNC - Validate Tax Country                               *
      *****************************************************************
     C     SRVCATNC      BEGSR
 
 
      ** Reset variables updated by each module
     C                   EXSR      SRRESETERRS
     C                   EVAL      WDupTC = 0
     C                   EVAL      WDCnt = 1
     C                   EVAL      WTINFld = 'DDTNC' + %char(ArrCnt+1)
      ** Country of TIN must be a valid Midas Country
     C                   EXSR      SRVCHKTC
 
      ** Country of Tax required to pair with TIN input
     C                   IF        WDATNC = *blanks and WDATIN <> *blanks
     C                   MOVE      'N'           WDATNCOK
     C                   ADD       1             Idx
     C                   MOVEL     WTINFld       FldNamXAr(Idx)
     C                   MOVEL     'USS0451'     MsgIdXAr(Idx)
     C                   ENDIF
 
      ** Check if TIN for this country is already specified for the customer
     C                   DOW       ArrCnt > 1 and WDCnt < ArrCnt
     C                   IF        ValPair(WDCnt).DDATNC = WDATNC
     C                   EVAL      WDupTC += 1
     C                   ENDIF
     C                   EVAL      WDCnt += 1
     C                   ENDDO
 
      ** Check if TIN Country is already the Main TIN's Country
      **   using Country of Domicile instead of Issuing Country
     C**********         IF        WDATNC = BBCOLC                                          MD026540
     C                   IF        WDATNC = DDCOLC                                          MD026540
     C                             OR WDupTC <> 0
     C                   MOVE      'N'           WDATNCOK
     C                   ADD       1             Idx
     C                   MOVEL     WTINFld       FldNamXAr(Idx)
     C                   MOVEL     'USS0452'     MsgIdXAr(Idx)
     C                   ENDIF
 
     C                   EXSR      SRUPDATERRS
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * SRVCHKTC - Valid If Country Is A Valid Midas Country          *
      *****************************************************************
     C     SRVCHKTC      BEGSR
 
      ** Reset variables updated by each module
     C                   EXSR      SRRESETERRS
      ** Validate TIN Country
     C                   CALLB     'SDVATNC'
      *
      * INPUTS
      *
      ** Return Code
     C                   PARM                    RetCodeOut
      *
      ** TIN Country to Validate (2A)
     C                   PARM                    WDATNC
      ** TIN Country Field Name (10A)
     C                   PARM                    WTINFld
      *
      * OUTPUTS
      *
      * Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
      *
      ** TIN Country - OK
     C                   PARM                    WDATNCOK
 
     C
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * SRRESETERRS - Reset error information that is received back   *
      *    from each validation module.                               *
      *****************************************************************
     C     SRRESETERRS   BEGSR
 
     C                   EVAL      RetCodeOut = *Blanks
 
      ** Reset error & warning fields/message IDs/message data (arrays)
     C                   EVAL      FldNamXAr = *Blanks
     C                   EVAL      MsgIDXAr  = *Blanks
     C                   EVAL      MsgDtaXAr = *Blanks
     C                   EVAL      WFldNmXAr = *Blanks
     C                   EVAL      WMsgIDXAr = *Blanks
     C                   EVAL      WMsgDtXAr = *Blanks
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * SRUPDATERRS - Update error information with that received back*
      *    from each validation module.                               *
      *****************************************************************
     C     SRUPDATERRS   BEGSR
 
      ** Update error fields/message IDs/message data (arrays)
 
     C                   Z-ADD     1             I                 3 0
     C     *Blanks       LOOKUP    FldNameArr(I)                          99
     C                   IF        *IN99 = *ON
     C                   MOVEA     FldNamXAr     FlDNameArr(I)
     C                   MOVEA     MsgIDXAr      MsgIdArr(I)
     C                   MOVEA     MsgDtaXAr     MsgDtaArr(I)
     C                   ENDIF
 
      ** Set Error Index
     C                   Z-ADD     1             I
     C     *Blanks       LOOKUP    FldNameArr(I)                          99
     C     I             SUB       1             Idx
 
      ** Update warning fields/message IDs/message data (arrays)
 
     C                   Z-ADD     1             I
     C     *Blanks       LOOKUP    WFldNamArr(I)                          99
     C                   IF        *IN99 = *ON
     C                   MOVEA     WFldNmXAr     WFldNamArr(I)
     C                   MOVEA     WMsgIDXAr     WMsgIDArr(I)
     C                   MOVEA     WMsgDtXAr     WMsgDtaArr(I)
     C                   ENDIF
 
      ** Set Warning Index
     C                   Z-ADD     1             I
     C     *Blanks       LOOKUP    WFldNamArr(I)                          99
     C     I             SUB       1             WIdx
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRRTVCUS - Retrieve Main Customer Details for the Country of  *
      *                        Domicile                               *
      *                                                               *
      *****************************************************************
     C     SRRTVCUS      BEGSR
 
     C     DDCUST        CHAIN     @BBREBG
     C     SRRTVCUSE     ENDSR
      /EJECT
      *****************************************************************
      *                                                               *
      * *inzsr - Program Initialisation routine                       *
      *                                                               *
      *****************************************************************
     C     *INZSR        BEGSR
 
     C     *ENTRY        PLIST
 
      ** Inputs
      ** Response mode
     C                   PARM                    RespMode
 
      ** Transaction Details
     C                   PARM                    TrnDets
 
      ** Customer Number
     C                   PARM                    DDCUST
     C                   PARM                    DDCOLC                                     MD026540
 
      ** Outputs
      ** Transaction Details OK inds
     C                   PARM                    OKTrnDets5
 
      ** Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIDArr
     C                   PARM                    MsgDtaArr
 
      ** Array index (3P0) from/to caller
     C                   PARM                    Idx
 
      ** Valid Transaction details layout (DS) from/to caller
     C                   PARM                    ValidCust
 
      ** Access Bank Details
 
     C                   CALL      'AOBANKR0'
     C                   PARM      *BLANKS       PRtcd
     C                   PARM      '*FIRST '     POptn
     C     SDBANK        PARM      SDBANK        DSFDY
 
      ** Database Error
 
     C                   IF        PRtcd <> *BLANKS
     C                   EVAL      DBFILE = 'SDBANKPD'
     C                   EVAL      DBASE  =  900
     C                   EVAL      DBKEY  = POptn
     C                   EXSR      *PSSR
     C                   ELSE
     C                   EVAL      WKDFIN = BJDFIN
     C                   EVAL      WKRDNB = BJRDNB
     C                   EVAL      WKCYCD = BJCYCD
     C                   ENDIF
 
      ** The following /COPY sets the values of program, module and
      ** procedure names for database error processing.
      /COPY ZACPYSRC,DBFIELDS
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRERR - EXCEPTION ERRORS                                      *
      *                                                               *
      *****************************************************************
     C     SRERR         BEGSR
 
     C                   EVAL      DBPGM = 'SDACUD5VL'
     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   EVAL      *INLR = *ON
     C                   DUMP
 
      **  Terminate the program
 
     C                   RETURN
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
 
      ** The following /COPY contains the standard program status
      ** subroutine, including a bound call to the DBERRCTL module.
      /COPY ZACPYSRC,PSSR_ILE
 
      *****************************************************************
** CTDATA CPY@
(c) Misys International Banking Systems Ltd. 2013
