     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas FT Validate pay delivery currency/amt')          *
      *****************************************************************
      *                                                               *
      *  Midas - Standard subprograms                                 *
      *                                                               *
      *  FTVPYCY  -  Validate Pay Delivery Currency/Amount            *
      *                                                               *
      *    This source is centrally supported and must ONLY be        *
      *    amended by Core Development Personnel                      *
      *                                                               *
      *    /COPY, Client or Country amendments must not be            *
      *    applied to this source.                                    *
      *                                                               *
      *  (c) Finastra International Limited 2001                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      *  Prev Amend No. AR905067           Date 05Nov14               *
      *                 CFT120             Date 28Sep12               *
      *                 CSF011A            Date 28Nov11               *
      *                 CRE067             Date 05Oct10               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      *                 256564             Date 17Sep08               *
      *                 255711             Date 31Jul08               *
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CSD031             Date 10Apr06               *
      *                 CDL049             Date 06Jul06               *
      *                 CGL014             Date 20Oct03               *
      *                 CGL029             Date 01Sep03               *
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.05 -----------------------------------------------*
      *                 CFT009             Date 13Nov00               *
      * Midas DBA 3.04 -----------------------------------------------*
      *                 CFT014             Date 25May00               *
      * Midas DBA 3.03 -----------------------------------------------*
      *                 175479             Date 23May00               *
      *                 CFT007             Date 23Dec99               *
      * Midas DBA 3.02 -----------------------------------------------*
      *                 CFT004             Date 01Dec99               *
      *                 CAP031  *CREATE    Date 07Apr99               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  AR905067 - Regular payment receives NegativelyAcked message. *
      *             Allow instructed currency/amount for RP.          *
      *             (Child: AR905068)                                 *
      *  CFT120 - FT IN/OP - Charges to DR of Account Currency        *
      *           (Recompile)                                         *
      *  CSF011A - CCR015: Display Order in Confirmation Pages        *
      *            (Recompile)                                        *
      *  CRE067 - Midas Plus/Teller Interface via Bankfusion          *
      *           (Recompile)                                         *
      *  256564 - Recompile due to PF changes done by fix 256330      *
      *  255711 - Field Ref rate does not record rate. (Recompile)    *
      *  CSD031 - Enhanced Centralised Static Data (Recompile)        *
      *  CDL049 - Addition of a Reference Rate field (recompile)      *
      *  CGL014 - Collaterals Processing (Recompile)                  *
      *  CGL029 - Increase Account Code to 10 digits                  *
      *  CFT009 - Funds Transfer Fees and Charges - recompile         *
      *  CFT014 - Straight-through Processing Phase 2 MT103           *
      *           Messages Generation for FT.                         *
      *  175479 - Recompile over changes in outgoing payment file     *
      *  CFT007 - Recompiled for BIC Database Plus Integration        *
      *  CFT004 - Recompiled for IBAN (International Bank A/C No.)    *
      *  CAP031 - Conversion of FT inputs into modular structure to   *
      *           use as APIs.                                        *
      *                                                               *
      *****************************************************************
 
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
 
      ** The maximum size of the appended error arrays
     D XArrayMax       C                   CONST(20)
 
      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
 
      ** Array of Fields in error.
     D FldNamXAr       S             10A   DIM(XArrayMax)
 
      ** Array of error message IDs
     D MsgIDXAr        S                   DIM(XArrayMax) LIKE(#MsgId)
 
      ** Array of error message data.
     D MsgDtaXAr       S                   DIM(XArrayMax) LIKE(#MsgData)
 
      * Incoming Transaction
     D TranInPrim    E DS                  EXTNAME(FTOPY1PD)
 
      * Flags to indicate whether transaction fields are valid
     D OKFlagsDS     E DS                  EXTNAME(FTEOPY1PD)
 
      * Validation Work Fields
     D Val@Fields    E DS                  EXTNAME(FTV@OPAYPD)
 
      * External DS for General Ledger details
     D SDGELR        E DS                  EXTNAME(SDGELRPD)
 
      ** External data structure for currency codes
     D SDCURR        E DS                  EXTNAME(SDCURRPD)
 
      * First DS for access programs, short data structure
     D DSFDY         E DS                  EXTNAME(DSFDY)
 
      ** External data structure for access programs (short)
     D DSSDY         E DS                  EXTNAME(DSSDY)
 
      ** +--------------------------------------+
      ** ¦ Named constants                      ¦
      ** ¦ ===============                      ¦
      ** +--------------------------------------+
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
      ** Index for arrays of error message ids etc
     D Idx             S              3P 0
 
     D #CDP            S                   LIKE(A6NBDP)
     D ZalignOK        S              1
     D ZFIELD          S             16
     D ZADEC           S              1  0
     D ZADIG           S              2  0
 
      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
      *****************************************************************
      /EJECT
      *****************************************************************
     C
      ** +--- Start of Main processing -----------------------------------+
      ** ¦                                                                ¦
      ** ¦ Initial processing is performed automatically: the *INZSR is   ¦
      ** ¦ executed at program activation.                                ¦
      ** ¦                                                                ¦
      ** +----------------------------------------------------------------+
 
      ** Initialization
      *
     C                   Eval      RetCodeIn = *Blanks
     C                   Eval      FldNamXAr = *Blanks
     C                   Eval      MsgIDXAr  = *Blanks
     C                   Eval      MsgDtaXAr = *Blanks
     C                   Eval      Idx = 0
 
      * Pay Delivery currency validation
      *
     C                   EXSR      VPYDLCY
 
      * Pay Delivery amount validation
      *
     C                   If        OKPdcy = 'Y'
     C                   EXSR      VPYDLAM
     C                   End
 
      ** If an error was found, set the return code appropriately
      *
     C                   If        OKPdcy = 'N' or
     C                             OKPdam = 'N'
     C                   Eval      RetCodeIn = 'Error'
     C                   End
 
      * RETURN
      *
     C                   RETURN
      *****************************************************************
      /EJECT
      ************************************************************
      * VPYDLCY - PAY DELIVERY CURRENCY VALIDATION
      *           OPTIONAL - MUST BE EUROS OR 'IN' CURRENCY
      ************************************************************
      *
     C     VPYDLCY       BEGSR
      *
     C                   Eval      @PINEU =*Blanks
     C                   Eval      @PTPSD = 0
     C                   Eval      @PDNDP = 0                                   CFT014
      *
     C                   If        SPDCY <> *Blanks
      *
     C**********         If        SPYTP = 'RP'                                             AR905067
      **Send*error*to*screen*******************************************                     AR905067
     C**********         Move      'N'           OKPdcy                                     AR905067
     C**********         Add       1             Idx                                        AR905067
     C**********         Movel     'SPDCY'       FldNamXAr(Idx)                             AR905067
     C***********        Movel     'MMA0918'     MsgIdXAr(Idx)                  CFT014
     C**********         Movel     'FTM3247'     MsgIdXAr(Idx)                       CFT014 AR905067
     C**********         Else                                                               AR905067
      *
      ** access currency file
      *
     C                   CALL      'AOCURRR0'
     C                   Parm      *Blanks       @RETC             7
     C                   Parm      '*KEY   '     @OPTN
     C                   Parm      SPDCY         @CURR             3
     C     SDCURR        Parm      SDCURR        DSSDY
 
     C                   Move      @CURR         SPDCY
      *
     C                   If        @CFT014 <> 'Y'                               CFT014
     C                   If        @RETC <> *Blanks or
     C                             A6INCY <> 'Y'    and
     C                             SPDCY <> BKEURO
      * Send error to screen
     C                   Move      'N'           OKPdcy
     C                   Add       1             Idx
     C                   Movel     'SPDCY'       FldNamXAr(Idx)
     C                   Movel     'MMA0919'     MsgIdXAr(Idx)
 
     C                   Else
     C                   Eval      #CDP = A6NBDP
     C                   Eval      @PDNDP = A6NBDP                              CFT014
 
     C                   If        A6INCY = 'Y'
     C                   Eval      @PINEU = 'I'
     C                   Eval      @PTPSD = A6TPSD
 
     C                   Else
     C                   Eval      @PINEU = 'E'
     C                   End
 
     C                   End
                                                                                CFT014
      ** CFT014 is active                                                       CFT014
                                                                                CFT014
     C                   Else                                                   CFT014
                                                                                CFT014
      ** Entry is not a valid currency code.                                    CFT014
                                                                                CFT014
     C                   If        @RETC <> *Blank                              CFT014
     C                   Move      'N'           OKPdcy                         CFT014
     C                   Add       1             Idx                            CFT014
     C                   Movel     'SPDCY'       FldNamXAr(Idx)                 CFT014
     C                   Movel     'FTM3101'     MsgIdXAr(Idx)                  CFT014
     C                   Else                                                   CFT014
     C                   Z-Add     A6NBDP        #CDP                           CFT014
     C                   Eval      @PDNDP = A6NBDP                              CFT014
                                                                                CFT014
      ** Currency is an 'In' currency.                                          CFT014
                                                                                CFT014
     C                   If        (@CEU006 = 'Y') And (A6INCY = 'Y')           CFT014
     C                   Eval      @PINEU = 'I'                                 CFT014
     C                   Z-Add     A6TPSD        @PTPSD                         CFT014
                                                                                CFT014
      ** Currency is a Euro currency                                            CFT014
                                                                                CFT014
     C                   Else                                                   CFT014
     C                   If        (@CEU006 = 'Y') And (SPDCY = BKEURO)         CFT014
     C                   Eval      @PINEU = 'E'                                 CFT014
                                                                                CFT014
      ** Otherwise, an 'Out' currency                                           CFT014
                                                                                CFT014
     C                   Else                                                   CFT014
     C                   Eval      @PINEU = 'O'                                 CFT014
     C                   EndIf                                                  CFT014
     C                   EndIf                                                  CFT014
     C                   EndIf                                                  CFT014
     C                   EndIf                                                  CFT014
     C**********         End                                                                AR905067
     C                   End
 
     C                   ENDSR
      ************************************************************
      * END OF PAY DELIVERY CURRENCY VALIDATION
      ************************************************************
     C/EJECT
      ************************************************************
      * VPYDLAM - VALIDATION OF PAY DELIVERY AMOUNT
      ************************************************************
      *
     C     VPYDLAM       BEGSR
      *
     C                   Select
      *
     C                   When      SPDAM = *BLANK
     C                   Eval      @PDAM = 0
 
     C                   When      SPDCY = *BLANK
      * Send error to screen
     C                   Move      'N'           OKPdam
     C                   Add       1             Idx
     C                   Movel     'SPDAM'       FldNamXAr(Idx)
     C***********        Movel     'MMA0920'     MsgIdXAr(Idx)                  CFT014
     C                   Movel     'FTM3250'     MsgIdXAr(Idx)                  CFT014
 
     C                   Other
     C                   Move      *BLANK        ZFIELD
     C                   Move      SPDAM         ZFIELD
     C                   Eval      ZADIG = 13 - #CDP
     C                   Eval      ZADEC = #CDP
 
      * Validate amount as numeric with correct d.p.
     C                   CALLB     'ZALIGN'
     C                   Parm                    ZalignOK          1
     C                   Parm                    ZFIELD           16
     C                   Parm                    ZADEC             1 0
     C                   Parm                    ZADIG             2 0
      *
     C                   If        ZalignOK = 'N'
      * Send error to screen
     C                   Move      'N'           OKPdam
     C                   Add       1             Idx
     C                   Movel     'SPDAM'       FldNamXAr(Idx)
     C***********        Movel     'MMA1104'     MsgIdXAr(Idx)                  CFT014
     C                   Movel     'FTM3251'     MsgIdXAr(Idx)                  CFT014
 
     C                   Else
     C                   Move      ZFIELD        @PDAM
     C                   Move      'R'           @FAIN
     C                   End
 
     C                   End
 
     C                   ENDSR
     C************************************************************
     C* END OF PAY DELIVERY AMOUNT VALIDATION
     C************************************************************
     C/EJECT
      *****************************************************************
      * *INZSR - Program Initialisation routine                       *
      *****************************************************************
     C     *INZSR        BEGSR
 
     C     *ENTRY        PLIST
 
      * INPUTS
      *  Return Code
     C                   Parm                    RetCodeIn
 
      *  Screen fields
     C                   Parm                    TranInPrim
 
      * OUTPUTS
      * Error fields/message IDs/message data (arrays) from/to caller
     C                   Parm                    FldNamXAr
     C                   Parm                    MsgIDXAr
     C                   Parm                    MsgDtaXAr
 
      *  OK Flags
     C                   Parm                    OKFlagsDS
 
      *  Validation Work Fields
     C                   Parm                    Val@Fields
 
      ** ACCESS GENERAL LEDGER DETAILS
      *
     C**********         CALL      'AOGELRR0'                                                 CGL029
     C                   CALL      'AOGELRR1'                                                 CGL029
     C                   PARM      *BLANKS       @RTCD             7
     C                   PARM      '*FIRST '     @OPTN             7
     C*****SDGELR        PARM      SDGELR        DSFDY                                        CGL029
     C     SDGELR        PARM      SDGELR        DSSDY                                        CGL029
      *
      * DATABASE ERROR
      *
     C     @RTCD         IFNE      *BLANKS
     C                   MOVEL     'SDGELRPD'    DBFILE
     C                   MOVEL     '902'         DBASE
     C                   MOVEL     @OPTN         DBKEY
     C                   EXSR      *PSSR
     C                   END
      *
      ** =================================================================
      ** Program, module and procedure names for database error processing.
      ** =================================================================
      ** The following /COPY sets these values, and also defines LDA as
      ** an external data area
 
     C/COPY ZACPYSRC,DBFIELDS
 
     C                   ENDSR                                                  *** InzEnd ***
      *****************************************************************
      /EJECT
      ********************************************************************
     C/COPY ZACPYSRC,PSSR_ILE
      ********************************************************************
**  CPY@
(c) Finastra International Limited 2001
