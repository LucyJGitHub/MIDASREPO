     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2006')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas SD Customer Details Acceptance')                 *
      *****************************************************************
      *                                                               *
      *  Midas - Standing Data ILE Module                             *
      *                                                               *
      *  SDCUSTACP - SD Customer Details Acceptance                   *
      *                                                               *
      *  Function:  This program updates the zonal file and the       *
      *             acceptance file based on the data sent by the     *
      *             background job SDC000060 or SD000061              *
      *                                                               *
      *  Called By: SDC000060 - SD Central Data Acceptance BG Job     *
      *             SD000061 -  SD Central Data Acceptance on         *
      *                         Effective Date                        *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2006            *
      *                                                               *
      *  Last Amend No. CER071             Date 01Aug16               *
      *  Prev Amend No. CER070             Date 24Nov14               *
      *                 MD030956           Date 09Oct14               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 BUG12690           Date 16Nov06               *
      *                 BUG12362           Date 04Nov06               *
      *                 BUG12282           Date 22Oct06               *
      *                 BUG11935           Date 22Aug06               *
      *                 BUG11946           Date 21Aug06               *
      *                 BUG11886           Date 17Aug06               *
      *                 BUG11864           Date 10Aug06               *
      *                 CSD031  *CREATE    Date 10Apr06               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CER071 - BAIS - Legal Form field (Recompile)                 *
      *  CER070 - BuBa Reporting / BAIS V.1.16.0 (Recompile)          *
      *  MD030956 - Additional changes to BFM-TI enhancement          *
      *  BUG12690 - Customer basic rate tax details is not being      *
      *             populated when new customer is automatically      *
      *             accepted to zone                                  *
      *  BUG12362 - Customer Details does not cascade to zones        *
      *  BUG12282 - Branch Code is required when accepting entries    *
      *  BUG11935 - Record in zonal not updated when amendment was    *
      *             globally                                          *
      *  BUG11946 - Two records where saved in acceptance list in     *
      *             another zone                                      *
      *  BUG11886 - Record inserted in Singapore Global not found     *
      *             in England Zone                                   *
      *  BUG11864 - Record not reflected in zonal list view if accept *
      *             to zone is Y                                      *
      *  CSD031 - Enhanced Centralised Static Data                    *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  Use of indicators.                                           *
      *                                                               *
      *    XX         Function of Indicator                           *
      *    98         Date Format                                     *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  S U B R O U T I N E  I N D E X                               *
      *                                                               *
      *  SRCUSTDETL - Customer Details Update Routine                 *
      *  SRRETRIEVE - Retrieve Customer Details                       *
      *  SRUPDATER  - Update Customer Details                         *
      *  SRACCP     - Acceptance File Update Routine                  *
      *  SRDELAY    - Delay Job for 1 Second                          *
      * *PSSR       - Error processing                                *
      * *INZSR      - Initialise                                      *
      *                                                               *
      *    The *INZSR subroutine will only get called automatically   *
      *    on entry to the module the first time it is run            *
      *    (unless you end the program with LR on).  Similarly        *
      *    D-spec initialisation only happens the first time.  Use    *
      *    RESET for subsequent passes.                               *
      *                                                               *
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+

      ** Account Keys Logical File
     FSDCUSTL1  IF   E           K DISK    INFSR(*PSSR)

      ** Account Keys Logical File                                                          BUG12282
     F***SDCUSTL0  IF   E           K DISK    INFSR(*PSSR) Prefix(AF_)             BUG12282 BUG12362
     FSDCUSTL5  IF   E           K DISK    INFSR(*PSSR) Prefix(AF_)                         BUG12362
                                                                                            BUG12282
      ** Account Keys Acceptance File
     FSDACSTL0  UF A E           K DISK    INFSR(*PSSR)
     F                                     COMMIT

      *****************************************************************
      /EJECT
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ Automatically included D-specs       ¦
      ** ¦ ==============================       ¦
      ** +--------------------------------------+

      ** The following /COPY line includes (among others) the LDA layout
      ** and the copyright array definition:
     D/COPY ZACPYSRC,STD_D_SPEC

      ** +--------------------------------------+
      ** ¦ D-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+

      ** The following /COPY line includes all the defined fields in the
      ** PSDS.  They have meaningful names, prefixed by 'PS'.

     D/COPY ZACPYSRC,PSDS

      ** Program Status Data Structure

      ** +-----------------------------------------------------------------+
      ** D specs of the following types should be inserted after the
      ** relevant box.  *** Remove this text afterwards. ***
      ** +-----------------------------------------------------------------+
      ** The following /COPY line includes the definitions for error and
      ** warning message arrays.
     D/COPY ZACPYSRC,ERR_ARRAYS
      **--------------------------------------------------------------------------------------------

      ** +--------------------------------------+
      ** ¦ Named constants                      ¦
      ** ¦ ===============                      ¦
      ** +--------------------------------------+

      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+

      ** Override Commands Array
     D OVRC            S             50A   DIM(4) CTDATA

      ** External DS for SAR Details
     D SCSARD        E DS                  EXTNAME(SCSARDPD)

      ** Customer Details File
     D Ds_Customer   E DS                  ExtName(SDCUSTPD)
     D                                     PREFIX(SD_)

      ** Customer Details File - Zoned Numeric Definition
     D Input_CustomerE DS                  ExtName(SDZCUSTPD)

      ** Current Customer in File Format (Base Rate Tax Details)
     D CBrtFilFmt    E DS                  EXTNAME(SDCBRTPD)
     D                                     PREFIX(CB_)

      ** Current Customer in File Format (Private Banking Details)
     D CPrbFilFmt    E DS                  EXTNAME(SDPBDSPD)
     D                                     PREFIX(CP_)

      ** TI Customer Details in File Format
     D CuTIFilFmt    E DS                  EXTNAME(SDTICSPD)
     D                                     PREFIX(Z_)

      ** Current Global Customer X-Reference in File Format
     D CGCuFilFmt    E DS                  EXTNAME(GPCUSTXPD)
     D                                     PREFIX(CG_)

      ** External DS for Midas Modules Details
     D SDMMOD        E DS                  EXTNAME(SDMMODPD)

      ** External DS for Midas Bank Details
     D SDBANK        E DS                  EXTNAME(SDBANKPD)

      ** External DS for General Ledger Details
     D SDGELR        E DS                  EXTNAME(SDGELRPD)

      ** First DS for Access Programs, Short Data Structure
     D DSFDY         E DS                  EXTNAME(DSFDY)

      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+

     D @@MODE          S              6A
     D @@RSMD          S              1A
     D ACTN            S              1A
     D FOTRID          S             20A
     D AUTHRQ          S              1A
     D AUTHMD          S              1A
     D DDCUSNOK        S              1A
     D DDACTNOK        S              1A
     D PAccMde         S              1A
     D PUpdYN          S              1A
     D @RUN            S              1A
     D DFound          S              1A
     D DSuccess        S              1A
     D S01383          S              1A
     D CGP001          S              1A
     D CSW024          S              1A
     D CLE025          S              1A
     D CFX001          S              1A
     D MidasTrNum      S              6A
     D Idx             S              3P 0

      ** Entry Parameters
     D PDATA           S           4000A
     D PPROGRAM        S             10A
     D PRETCODE        S              7A

      ** Parameter List
     D PCmd            S             13A   Inz('DLYJOB DLY(1)')
     D PCmdA           S             80A
     D PCmd_Len        S             15  5
     D PZreturn        S              1
     D PZfield         S             16
     D PZdecimals      S              1P 0
     D PZdigits        S              2P 0

      ** Key Fields
     D KCustCode       S                   Like(BBCUST)

      ** Working Variables
     D WIdx            S              2P 0
     D WCust           S              6A

     D Upper           C                   CONST('ABCDEFGHIJKLMNOPQRSTUVWXYZ')              BUG11946
     D Lower           C                   CONST('abcdefghijklmnopqrstuvwxyz')              BUG11946
      *****************************************************************
      /EJECT
      *****************************************************************
      *
      ** +--- Start of Main processing -----------------------------------+
      ** ¦                                                                ¦
      ** ¦ Initial processing is performed automatically: the *INZSR is   ¦
      ** ¦ executed at program activation.                                ¦
      ** ¦                                                                ¦
      ** +----------------------------------------------------------------+

      *********************************************************************
      * MAIN PROCEDURE                                                    *
      *********************************************************************

     C                   EVAL      Input_Customer = PDATA

      ** Do overrides.

     C                   FOR       WIdx = 1 TO %ELEM(OVRC)

     C                   EVAL      PCmdA = OVRC(WIdx)
     C                   EVAL      PCmd_Len = %Len(PCmdA)
     C                   CALL      'QCMDEXC'
     C                   PARM                    PCmdA
     C                   PARM                    PCmd_Len

     C                   ENDFOR

      ** Convert fields with incompatible definitions

     C                   EXSR      SrConvert

      ** Default fields.

     C                   EXSR      SRDefault

     C                   IF        BBAACC   = 'Y'   OR
     C                             PPROGRAM = 'SDC000061'
     C                   EXSR      SrCustDetl
     C                   ELSE
     C                   EXSR      SrAccp
     C                   ENDIF

      ** Commit changes if there are no errors, otherwise rollback

     C                   IF        PRETCODE   = *Blanks
     C                   COMMIT
     C                   ELSE
     C                   ROLBK
     C                   ENDIF

     C                   EVAL      *INLR = *ON
     C                   RETURN

      /EJECT
      *****************************************************************
      *                                                               *
      *  SrCustDetl - Customer Details update routine                 *
      *               Write/Update to Zonal files                     *
      *                                                               *
      *****************************************************************

     C     SrCustDetl    BEGSR

     C                   EVAL      KCustCode = BBCUST

     C     KCUSD         SETLL     SDCUSTL1

     C                   IF        %EQUAL(SDCUSTL1)

     C                   EXSR      SrRetrieve

      ** Customer exists, update only central fields

     C                   EXSR      SrCentral

     C                   EVAL      SD_BBTYLC = 'A'
     C                   EVAL      SD_BBLCD  = BJRDNB
     C                   EVAL      SD_BBEACC = BJRDNB
     C                   EVAL      DACTN     = 'A'                                          BUG12690
     C                   EVAL      CB_XCHTP  = 'A'                                          BUG12690
     C                   EVAL      CB_XLCD   = BJRDNB                                       BUG12690

     C                   EXSR      SrUpdater

     C                   ELSE

      ** Customer does not exist, add new customer details

     C                   EXSR      SrNewCustomer

     C                   EVAL      SD_BBTYLC = 'I'
     C                   EVAL      SD_BBLCD  = BJRDNB
     C                   EVAL      SD_BBEACC = BJRDNB
     C                   EVAL      DACTN     = 'I'                                          BUG12690
     C                   EVAL      CB_XCHTP  = 'I'                                          BUG12690
     C                   EVAL      CB_XLCD   = BJRDNB                                       BUG12690

     C                   EXSR      SrUpdater

     C                   ENDIF

     C                   ENDSR

      /EJECT
      *****************************************************************
      *                                                               *
      *  SrRetrieve - Retrieve Customer Detail Record                 *
      *                                                               *
      *****************************************************************

     C     SrRetrieve    BEGSR

     C                   CALLB     'SDCUSDRTV'
      ** Input
     C                   PARM      *BLANK        RetCodeOut
     C                   PARM      *blanks       @@MODE
     C                   PARM      'S'           @@RSMD
     C                   PARM      'E'           ACTN
     C                   PARM      BBCUST        FOTRID
     C                   PARM      BBCUST        MidasTrNum
     C                   PARM      'N'           AUTHRQ
     C                   PARM      *blank        AUTHMD
     C                   PARM                    S01383
     C                   PARM                    BGN4ST
     C                   PARM                    CGP001
     C                   PARM                    PTransType                                 BUG11935
     C**********         PARM      'A'           PAccMde                                    BUG11935
      ** PAccMde 'J' indicates job update                                                   BUG11935
     C                   PARM      'J'           PAccMde                                    BUG11935
     C                   PARM                    PUpdYN
      ** Output
     C                   PARM                    Ds_Customer
     C                   PARM                    CBrtFilFmt
     C                   PARM                    CPrbFilFmt
     C                   PARM                    CuTIFilFMt
     C                   PARM                    CGCuFilFmt
     C                   PARM      'Y'           DDACTNOK
     C                   PARM      'Y'           DDCUSNOK
     C                   PARM      *BLANK        FldNameArr
     C                   PARM      *BLANK        MsgIdArr
     C                   PARM      *BLANK        MsgDtaArr
     C                   PARM      *ZERO         Idx

      ** Error in retrieving customer details

     C                   IF        Idx <> 0
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE =  'SDCUSTPD'
     C                   EVAL      DBKEY  =  KCustCode
     C                   EVAL      DBPGM  =  PSProcPgm
     C                   EVAL      DBASE  =  001
     C                   EVAL      DBMOD  =  PSProcMod
     C                   EVAL      DBPROC =  'SR/SrRetrieve'
     C                   OUT       LDA
     C                   EVAL      PRETCODE   = '*ERROR'
     C                   EXSR      *PSSR
     C                   ENDIF

     C                   ENDSR

      /EJECT
      *****************************************************************
      *                                                               *
      *  SrUpdater - Update Customer Details Records                  *
      *                                                               *
      *****************************************************************

     C     SrUpdater     BEGSR

      ** Use Customer Number as Front Office ID

     C                   EVAL      SD_BBFRNT   = SD_BBCUST

     C                   DO        100

     C                   CALLB     'SDCUSDUPD'
     C                   PARM      *blanks       @RTCD
     C                   PARM                    Ds_Customer
     C                   PARM                    CBrtFilFmt
     C                   PARM                    CPrbFilFmt
     C                   PARM                    CuTIFilFmt
      * Base Rate Auth req
     C                   PARM      'N'           AUTHRQ
      * Authorisation Mode
     C                   PARM      *blank        AUTHMD
     C                   PARM      *blanks       V_DDGCUS         10
     C                   PARM                    S01383
     C                   PARM                    CSW024
     C                   PARM                    CGP001
     C                   PARM                    CLE025
     C                   PARM                    CFX001
     C                   PARM                    PTransType        4                        BUG11864
     C                   PARM                    DACTN             1                        BUG11864
     C                   PARM                    CTI006            1                        MD030956
     C**********         PARM      'A'           PAccMde                                    BUG11935
      ** PAccMde 'J' indicates job update                                                   BUG11935
     C                   PARM      'J'           PAccMde                                    BUG11935
     C                   PARM                    PUpdYN

      ** If error encountered in update, retry until 100 attempts

     C                   IF        @RTCD = '*ERROR'
     C                   EXSR      SrDelay
     C                   ELSE
     C                   LEAVE
     C                   ENDIF

     C                   ENDDO

      ** Error in updating customer details

     C                   IF        @RTCD = '*ERROR'
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE =  'SDCUSTPD'
     C                   EVAL      DBKEY  =  KCustCode
     C                   EVAL      DBPGM  =  PSProcPgm
     C                   EVAL      DBASE  =  002
     C                   EVAL      DBMOD  =  PSProcMod
     C                   EVAL      DBPROC =  'SR/SrUpdater'
     C                   OUT       LDA
     C                   EVAL      PRETCODE   = '*ERROR'
     C                   EXSR      *PSSR
     C                   ENDIF

     C                   ENDSR

      /EJECT
      *****************************************************************
      *                                                               *
      *  SrNewCustomer - Moves Fields to Customer Data Structure      *
      *                                                               *
      *****************************************************************

     C     SrNewCustomer BEGSR

     C                   CLEAR                   Ds_Customer

     C                   EVAL      SD_BBCUST =   BBCUST
     C                   EVAL      SD_BBCSSN =   BBCSSN
     C                   EVAL      SD_BBCNA1 =   BBCNA1
     C                   EVAL      SD_BBCNA2 =   BBCNA2
     C                   EVAL      SD_BBCNA3 =   BBCNA3
     C                   EVAL      SD_BBCNA4 =   BBCNA4
     C                   EVAL      SD_BBCRNM =   BBCRNM
     C                   EVAL      SD_BBCRTN =   BBCRTN
     C                   EVAL      SD_BBACOC =   BBACOC
     C                   EVAL      SD_BBCNCZ =   BBCNCZ
     C                   EVAL      SD_BBCOLC =   BBCOLC
     C                   EVAL      SD_BBBNBI =   BBBNBI
     C                   EVAL      SD_BBLICD =   BBLICD
     C                   EVAL      SD_BBCTNB =   BBCTNB
     C                   EVAL      SD_BBREID =   BBREID
     C                   EVAL      SD_BBBSIN =   BBBSIN
     C                   EVAL      SD_BBCSTY =   BBCSTY
     C                   EVAL      SD_BBCSID =   BBCSID
     C                   EVAL      SD_BBSTAD =   BBSTAD
     C                   EVAL      SD_BBTXA1 =   BBTXA1
     C                   EVAL      SD_BBTXA2 =   BBTXA2
     C                   EVAL      SD_BBTXA3 =   BBTXA3
     C                   EVAL      SD_BBTXA4 =   BBTXA4
     C                   EVAL      SD_BBTXA5 =   BBTXA5
     C                   EVAL      SD_BBBFIC =   BBBFIC
     C                   EVAL      SD_BBBLCD =   BBBLCD
     C                   EVAL      SD_BBRWCD =   BBRWCD
     C                   EVAL      SD_BBSWFI =   BBSWFI
     C                   EVAL      SD_BBCORP =   BBCORP
     C                   EVAL      SD_BBCBEI =   BBCBEI
     C                   EVAL      SD_BBTYLC =   BBTYLC
     C                   EVAL      SD_BBAUSR =   BBAUSR
     C                   EVAL      SD_BBDEAC =   BBDEAC
     C                   EVAL      SD_BBPAIN =   BBPAIN
     C                   EVAL      SD_BBPCNB =   BBPCNB
     C                   EVAL      SD_BBCGRP =   BBCGRP
     C                   EVAL      SD_BBCASC =   BBCASC
     C                   EVAL      SD_BBTAIN =   BBTAIN
     C                   EVAL      SD_BBCDEL =   BBCDEL
     C                   EVAL      SD_BBMCAC =   BBMCAC
     C                   EVAL      SD_BBFCMF =   BBFCMF
     C                   EVAL      SD_BBINOF =   BBINOF
     C                   EVAL      SD_BBIOPC =   BBIOPC
     C                   EVAL      SD_BBIUSR =   BBIUSR
     C                   EVAL      SD_BBXUSR =   BBXUSR
     C                   EVAL      SD_BBAACC =   BBAACC
     C                   EVAL      SD_BBGPDT =   BBGPDT

     C                   EVAL      SD_BBCHID =   BBCHID
     C                   EVAL      SD_BBCHSC =   BBCHSC
     C                   EVAL      SD_BBCABA =   BBCABA
     C                   EVAL      SD_BBABA2 =   BBABA2
     C                   EVAL      SD_BBFWCD =   BBFWCD
     C                   EVAL      SD_BBDOIC =   BBDOIC
     C                   EVAL      SD_BBSSDT =   BBSSDT
     C                   EVAL      SD_BBDTDL =   BBDTDL
     C                   EVAL      SD_BBLCD  =   BBLCD
     C                   EVAL      SD_BBDEDT =   BBDEDT
     C                   EVAL      SD_BBMGTP =   BBMGTP
     C                   EVAL      SD_BBEACC =   BBEACC
     C                   EVAL      SD_BBBRCD =   BKMABR
                                                                                            BUG12690
      ** Setup customer basic rate tax default during insert                                BUG12690
                                                                                            BUG12690
     C                   EVAL      CB_ACHLRT = BBTAIN                                       BUG12690

     C                   ENDSR

      /EJECT
      *****************************************************************
      *                                                               *
      *  SrCentral - Moves Central Fields                             *
      *                                                               *
      *****************************************************************

     C     SrCentral     BEGSR

      ** Shortname
     C                   EVAL      SD_BBCSSN = BBCSSN
      ** Name & address
     C                   EVAL      SD_BBCNA1 = BBCNA1
     C                   EVAL      SD_BBCNA2 = BBCNA2
     C                   EVAL      SD_BBCNA3 = BBCNA3
     C                   EVAL      SD_BBCNA4 = BBCNA4
      ** Status
     C                   EVAL      SD_BBDEAC = BBDEAC
     C                   EVAL      SD_BBDEDT = BBDEDT
     C                   EVAL      SD_BBDTDL = BBDTDL
     C                   EVAL      SD_BBCLST = BBCLST
     C                   EVAL      SD_BBCLDT = BBCLDT
      ** Report name
     C                   EVAL      SD_BBCRNM = BBCRNM
      ** Report town
     C                   EVAL      SD_BBCRTN = BBCRTN
      ** Account officer
     C                   EVAL      SD_BBACOC = BBACOC
      ** Retail customer group
     C                   EVAL      SD_BBCGRP = BBCGRP
      ** Branch code
     C***                EVAL      SD_BBBRCD = BBBRCD
      ** Country of citizenship
     C                   EVAL      SD_BBCNCZ = BBCNCZ
      ** Country of location
     C                   EVAL      SD_BBCOLC = BBCOLC
      ** Parent customer
     C                   EVAL      SD_BBPCNB = BBPCNB
      ** Location code
     C                   EVAL      SD_BBLCCD = BBLCCD
      ** Designated In currency
     C                   EVAL      SD_BBDINC = BBDINC

     C                   ENDSR

      /EJECT
      *****************************************************************
      *                                                               *
      *  SrConvert - Moves Zoned Numeric to Packed Fields             *
      *                                                               *
      *****************************************************************

     C     SrConvert     BEGSR
      *                                                                                     BUG11946
      ** Convert Lower Case to Upper Case                                                   BUG11946
      *                                                                                     BUG11946
     C                   Eval      WCust = %XLATE(Lower:Upper:CUGCUS)                       BUG11946
     C                   Eval      CUGCUS = WCust                                           BUG11946

      ** Non-numeric, not compatible in length

     C                   MOVEL     CUGCUS        BBCUST
     C                   MOVEL     CUGACO        BBACOC
     C                   MOVEL     CUGICD        BBLICD

      ** Numeric fields

     C                   IF        CUCHID = *Blanks
     C                   EVAL      BBCHID = *Zeros
     C                   ELSE
     C                   MOVE      CUCHID        BBCHID
     C                   ENDIF

     C                   IF        CUCHSC = *Blanks
     C                   EVAL      BBCHSC = *Zeros
     C                   ELSE
     C                   MOVE      CUCHSC        BBCHSC
     C                   ENDIF

     C                   IF        CUCABA = *Blanks
     C                   EVAL      BBCABA = *Zeros
     C                   ELSE
     C                   MOVE      CUCABA        BBCABA
     C                   ENDIF

     C                   IF        CUABA2 = *Blanks
     C                   EVAL      BBABA2 = *Zeros
     C                   ELSE
     C                   MOVE      CUABA2        BBABA2
     C                   ENDIF

     C                   IF        CUFWCD = *Blanks
     C                   EVAL      BBFWCD = *Zeros
     C                   ELSE
     C                   MOVE      CUFWCD        BBFWCD
     C                   ENDIF

     C                   IF        CUDOIC = *Blanks
     C                   EVAL      BBDOIC = *Zeros
     C                   ELSE
     C                   MOVE      CUDOIC        BBDOIC
     C                   ENDIF

     C                   IF        CUSSDT = *Blanks
     C                   EVAL      BBSSDT = *Zeros
     C                   ELSE
     C                   MOVE      CUSSDT        BBSSDT
     C                   ENDIF

     C                   IF        CUDTDL = *Blanks
     C                   EVAL      BBDTDL = *Zeros
     C                   ELSE
     C                   MOVE      CUDTDL        BBDTDL
     C                   ENDIF

     C                   IF        CULCD  = *Blanks
     C                   EVAL      BBLCD  = *Zeros
     C                   ELSE
     C                   MOVE      CULCD         BBLCD
     C                   ENDIF

     C                   IF        CUDEDT = *Blanks
     C                   EVAL      BBDEDT = *Zeros
     C                   ELSE
     C                   MOVE      CUDEDT        BBDEDT
     C                   ENDIF

     C                   IF        CUMGTP = *Blanks
     C                   EVAL      BBMGTP = *Zeros
     C                   ELSE
     C                   MOVE      CUMGTP        BBMGTP
     C                   ENDIF

     C                   IF        CUEACC = *Blanks
     C                   EVAL      BBEACC = *Zeros
     C                   ELSE
     C                   MOVE      CUEACC        BBEACC
     C                   ENDIF

     C                   ENDSR

      /EJECT
      *****************************************************************
      *                                                               *
      *  SrDefault - Default fields.                                  *
      *                                                               *
      *****************************************************************
     C     SrDefault     BEGSR

     C                   CLEAR                   CBrtFilFmt
     C                   MOVE      'D'           CB_XRECI
     C                   MOVE      BBCUST        CB_XCNUM
     C                   CLEAR                   CPrbFilFmt
     C                   MOVE      'D'           CP_PBRECI
     C                   MOVE      BBCUST        CP_PBCNUM
     C                   CLEAR                   CuTIFilFMt
     C                   MOVE      BBCUST        Z_TCCUST
     C                   CLEAR                   CGCuFilFmt

     C                   ENDSR

      /EJECT
      *****************************************************************
      *                                                               *
      *  SrAlign - Align Numeric Data                                 *
      *                                                               *
      *****************************************************************

     C     SrAlign       BEGSR

     C                   CALLB     'ZALIGN'
     C                   PARM                    PZreturn
     C                   PARM                    PZfield
     C                   PARM                    PZdecimals
     C                   PARM                    PZdigits

     C                   ENDSR

      /EJECT
      *****************************************************************
      *                                                               *
      *  SrAccp - Acceptance File Update Routine                      *
      *                                                               *
      *****************************************************************

     C     SrAccp        BEGSR

     C                   EVAL      KCustCode = BBCUST

     C                   DO        100

     C     KCUSD         CHAIN(E)  SDACSTL0

      ** If record is locked to another job, retry after 1 second

     C                   IF        %ERROR()
     C                   EXSR      SrDelay
     C                   ITER

     C                   ELSE
     C                   IF        %FOUND(SDACSTL0)

      ** Reload input data before updating acceptance file

     C                   EVAL      Input_Customer = PDATA
     C                   EXSR      SrConvert

      *                                                                                     BUG11886
      ** If Accept to zone is N, set branch code to blanks                                  BUG11886
      *                                                                                     BUG11886
     C                   IF        BBTYLC = 'A'                                             BUG12282
     C*****KCUSD         CHAIN     SDCUSTL0                                        BUG12282 BUG12362
     C     KCUSD         CHAIN     SDCUSTL5                                                 BUG12362
     C**********         IF        %FOUND(SDCUSTL0)                                BUG12282 BUG12362
     C                   IF        %FOUND(SDCUSTL5)                                         BUG12362
     C                   EVAL      BBBRCD = AF_BBBRCD                                       BUG12282
     C                   ELSE                                                               BUG12282
     C                   EVAL      BBBRCD = *BLANKS                                         BUG12282
     C                   ENDIF                                                              BUG12282
     C                   ELSE                                                               BUG12282
     C                   Eval      BBBRCD = *Blanks                                         BUG11886
     C                   ENDIF                                                              BUG12282
     C                   UPDATE    SDCUSTD0
     C                   ELSE

      *                                                                                     BUG11886
      ** If Accept to zone is N, set branch code to blanks                                  BUG11886
      *                                                                                     BUG11886
     C                   IF        BBTYLC = 'A'                                             BUG12282
     C*****KCUSD         CHAIN     SDCUSTL0                                        BUG12282 BUG12362
     C     KCUSD         CHAIN     SDCUSTL5                                                 BUG12362
     C**********         IF        %FOUND(SDCUSTL0)                                BUG12282 BUG12362
     C                   IF        %FOUND(SDCUSTL5)                                         BUG12362
     C                   EVAL      BBBRCD = AF_BBBRCD                                       BUG12282
     C                   ELSE                                                               BUG12282
     C                   EVAL      BBBRCD = *BLANKS                                         BUG12282
     C                   ENDIF                                                              BUG12282
     C                   ELSE                                                               BUG12282
     C                   Eval      BBBRCD = *Blanks                                         BUG11886
     C                   ENDIF                                                              BUG12282
     C                   WRITE     SDCUSTD0
     C                   ENDIF
     C                   LEAVE
     C                   ENDIF

     C                   ENDDO

     C                   IF        %ERROR
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE =  'SDACSTL0'
     C                   EVAL      DBKEY  =  KCustCode
     C                   EVAL      DBPGM  =  PSProcPgm
     C                   EVAL      DBASE  =  003
     C                   EVAL      DBMOD  =  PSProcMod
     C                   EVAL      DBPROC =  'SR/SrAccp'
     C                   OUT       LDA
     C                   EVAL      PRETCODE   = '*ERROR'
     C                   EXSR      *PSSR
     C                   ENDIF

     C                   ENDSR

      /EJECT
      *****************************************************************
      *                                                               *
      *  SrDelay - Delay Job for 1 second                             *
      *                                                               *
      *****************************************************************

     C     SrDelay       BEGSR

     C                   EVAL      PCmd_Len = %Len(PCmd)
     C                   CALL      'QCMDEXC'
     C                   PARM                    PCmd
     C                   PARM                    PCmd_Len

     C                   ENDSR

      /EJECT
      *****************************************************************
      *                                                               *
      * *INZSR - Program Initialisation routine                       *
      *                                                               *
      *****************************************************************

     C     *INZSR        BEGSR

     C     *ENTRY        PLIST
     C                   PARM                    PDATA
     C                   PARM                    PRETCODE
     C                   PARM                    PPROGRAM

     C     KCUSD         KLIST
     C                   KFLD                    KCustCode

      ** Access Midas module details

     C                   CALLB     'AOMMODR0'
     C                   PARM      '*DBERR  '    @RTCD
     C                   PARM      '*FIRST  '    @OPTN
     C     SDMMOD        PARM      SDMMOD        DSFDY

      ** Database error

     C                   IF        @RTCD <> *blank
     C     *LOCK         IN        LDA
     C                   EVAL      DBKEY  =  @OPTN
     C                   EVAL      DBFILE = 'SDMMODPD'
     C                   EVAL      DBASE  = 004
     C                   EVAL      PRETCODE   = '*ERROR '
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF

      ** Check if S01383 (Base Rate Tax) is switched on

     C                   CALLB     'AOSARDR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*VERIFY'     @OPTN
     C                   PARM      'S01383'      @SARD
     C     SCSARD        PARM      SCSARD        DSFDY

     C                   IF        @RTCD <> *BLANKS  AND  @RTCD <> '*NRF   '
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE = 'SCSARDPD'
     C                   EVAL      DBKEY  = 'S01383'
     C                   EVAL      DBASE  = 005
     C                   EVAL      PRETCODE   = '*ERROR '
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF

     C                   IF        @RTCD = *BLANKS
     C                   EVAL      S01383 = 'Y'
     C                   ELSE
     C                   EVAL      S01383 = 'N'
     C                   ENDIF

      ** Check if CGP001 is installed

     C                   CALLB     'AOSARDR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*VERIFY'     @OPTN
     C                   PARM      'CGP001'      @SARD
     C     SCSARD        PARM      SCSARD        DSFDY

      ** Database error

     C                   IF        (@RTCD <> *blanks) and
     C                             (@RTCD <> '*NRF   ')
     C     *LOCK         IN        LDA
     C                   EVAL      DBKEY = 'CGP001'
     C                   EVAL      DBFILE = 'SCSARDPD'
     C                   EVAL      DBASE = 006
     C                   EVAL      PRETCODE   = '*ERROR '
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF

     C                   IF        @RTCD = *BLANKS
     C                   EVAL      CGP001 = 'Y'
     C                   ELSE
     C                   EVAL      CGP001 = 'N'
     C                   ENDIF

      ** Check if CSW024 is installed

     C                   CALLB     'AOSARDR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*VERIFY'     @OPTN
     C                   PARM      'CSW024'      @SARD
     C     SCSARD        PARM      SCSARD        DSFDY

      ** Database error

     C                   IF        (@RTCD <> *blanks) and
     C                             (@RTCD <> '*NRF   ')
     C     *LOCK         IN        LDA
     C                   EVAL      DBKEY = 'CSW024'
     C                   EVAL      DBFILE = 'SCSARDPD'
     C                   EVAL      DBASE = 007
     C                   EVAL      PRETCODE   = '*ERROR '
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF

     C                   IF        @RTCD = *BLANKS
     C                   EVAL      CSW024 = 'Y'
     C                   ELSE
     C                   EVAL      CSW024 = 'N'
     C                   ENDIF

      ** Check if CLE025 is installed

     C                   CALLB     'AOSARDR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*VERIFY'     @OPTN
     C                   PARM      'CLE025'      @SARD
     C     SCSARD        PARM      SCSARD        DSFDY

      ** Database error

     C                   IF        (@RTCD <> *blanks) and
     C                             (@RTCD <> '*NRF   ')
     C     *LOCK         IN        LDA
     C                   EVAL      DBKEY = 'CLE025'
     C                   EVAL      DBFILE = 'SCSARDPD'
     C                   EVAL      DBASE = 008
     C                   EVAL      PRETCODE   = '*ERROR '
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF

     C                   IF        @RTCD = *BLANKS
     C                   EVAL      CLE025 = 'Y'
     C                   ELSE
     C                   EVAL      CLE025 = 'N'
     C                   ENDIF

      ** Check if CFX001 is installed

     C                   CALLB     'AOSARDR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*VERIFY'     @OPTN
     C                   PARM      'CFX001'      @SARD
     C     SCSARD        PARM      SCSARD        DSFDY

      ** Database error

     C                   IF        (@RTCD <> *blanks) and
     C                             (@RTCD <> '*NRF   ')
     C     *LOCK         IN        LDA
     C                   EVAL      DBKEY = 'CFX001'
     C                   EVAL      DBFILE = 'SCSARDPD'
     C                   EVAL      DBASE = 009
     C                   EVAL      PRETCODE   = '*ERROR '
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF

     C                   IF        @RTCD = *BLANKS
     C                   EVAL      CFX001 = 'Y'
     C                   ELSE
     C                   EVAL      CFX001 = 'N'
     C                   ENDIF

      ** Access Bank Details

     C                   CALL      'AOBANKR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*FIRST '     @OPTN
     C     SDBANK        PARM      SDBANK        DSFDY

      ** Datebase error

     C     @RTCD         IFNE      *BLANKS
     C     *LOCK         IN        LDA
     C                   EVAL      DBKEY = '*FIRST'
     C                   EVAL      DBFILE = 'SDBANKPD'
     C                   EVAL      DBASE = 010
     C                   EVAL      PRETCODE   = '*ERROR '
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF

      ** Access General Ledger Details

     C                   CALL      'AOGELRR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*FIRST'      @OPTN
     C     SDGELR        PARM      SDGELR        DSFDY

     C     @RTCD         IFNE      *BLANKS
     C     *LOCK         IN        LDA
     C                   EVAL      DBKEY = '*IFRST'
     C                   EVAL      DBFILE = 'SDGELRPD'
     C                   EVAL      DBASE  = 011
     C                   EVAL      PRETCODE = '*ERROR'
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   OUT       LDA
     C                   ENDIF

     C                   CLEAR                   CBrtFilFmt
     C                   CLEAR                   CPrbFilFmt
     C                   CLEAR                   CuTIFilFMt
     C                   CLEAR                   CGCuFilFmt

     C                   ENDSR

      /EJECT
      *****************************************************************
      *                                                               *
      * *PSSR  - Program exception error routine                      *
      *          Called automatically if a program error occurs,      *
      *          or directly by the program code using EXSR.          *
      *          This subroutine DUMPs the program just once.         *
      *                                                               *
      *****************************************************************

     C     *PSSR         BEGSR

     C                   IF        @RUN = *BLANK
     C                   EVAL      @RUN = 'Y'
     C                   DUMP

     C                   CALL      'DBERRCTL'

     C                   ENDIF

     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   EVAL      *INLR = *ON
     C                   RETURN

     C                   ENDSR
      *****************************************************************
** CPY@
(c) Misys International Banking Systems Ltd. 2006
** OVRC
OVRDBF FILE(SDCUSTLR) TOFILE(SDCUSTL0) SHARE(*NO)
OVRDBF FILE(SDCBRTLR) TOFILE(SDCBRTL1) SHARE(*NO)
OVRDBF FILE(SDPBDSLR) TOFILE(SDPBDSL0) SHARE(*NO)
OVRDBF FILE(SDTICSLR) TOFILE(SDTICSL0) SHARE(*NO)
