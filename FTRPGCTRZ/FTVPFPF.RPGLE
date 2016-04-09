     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2001')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas FT Validate profit centre')                      *
      *****************************************************************
      *                                                               *
      *  Midas - Standard subprograms                                 *
      *                                                               *
      *  FTVPFPF  - Validate Profit Centre.                           *
      *                                                               *
      *    This source is centrally supported and must ONLY be        *
      *    amended by Core Development Personnel                      *
      *                                                               *
      *    /COPY, Client or Country amendments must not be            *
      *    applied to this source.                                    *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2001            *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  Last Amend No. CFT120             Date 28Sep12               *
      *  Prev Amend No. CSF011A            Date 28Nov11               *
      *                 CRE067             Date 05Oct10               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      *                 256564             Date 17Sep08               *
      *                 255711             Date 31Jul08               *
      *                 250600             Date 07Oct07               *
      *                 BUG14716A          Date 04Sep07               *
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CFT032             Date 11Sep06               *
      *                 CSD031             Date 10Apr06               *
      *                 CDL049             Date 06Jul06               *
      *                 CSD027             Date 09Dec05               *
      *                 CSW037A            Date 02May05               *
      *                 CSD025             Date 11Jan05               *
      *                 CSW037             Date 15Dec04               *
      *                 CSW036             Date 15Dec04               *
      *                 CLE025             Date 20Oct03               *
      *                 CGL029             Date 01Sep03               *
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.05 -----------------------------------------------*
      *                 CFT009             Date 13Nov00               *
      * Midas DBA 3.04 -----------------------------------------------*
      *                 CSD009             Date 10Oct00               *
      *                 CFT014             Date 25May00               *
      * Midas DBA 3.03 -----------------------------------------------*
      *                 175479             Date 23May00               *
      *                 179732             Date 06Jun00               *
      *                 CFT007             Date 23Dec99               *
      * Midas DBA 3.02 -----------------------------------------------*
      *                 CFT004             Date 01Dec99               *
      *                 CAP031  *CREATE    Date 19Apr99               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CFT120 - FT IN/OP - Charges to DR of Account Currency        *
      *           (Recompile)                                         *
      *  CSF011A - CCR015: Display Order in Confirmation Pages        *
      *            (Recompile)                                        *
      *  CRE067 - Midas Plus/Teller Interface via Bankfusion          *
      *           (Recompile)                                         *
      *  256564 - Recompile due to PF changes done by fix 256330      *
      *  255711 - Field Ref rate does not record rate. (Recompile)    *
      *  250600 - Recompiled for change in FTV@OPAYPD                 *
      *           to fix CFT032/CSW207 errors                         *
      *  BUG14716A - CFT032 pre-req missing CFT018 OPSI Outgoing      *
      *              Payments Template (Recompile)                    *
      *  CFT032 - Account line in field 50X in MT103                  *
      *  CSD031 - Enhanced Centralised Static Data (Recompile)        *
      *  CDL049 - Addition of a Reference Rate field (recompile)      *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CSW037A- Additional Field extended to 40 chars (recompile)   *
      *  CSD025 - Customer De-Activation                              *
      *  CSW037 - Additional Field Data on MT300/MT320                *
      *  CSW036 - Dual SWIFT BIC held on Client Details               *
      *  CLE025 - Credit Lines (Recompile)                            *
      *  CGL029 - Increase Account Code to 10 digits                  *
      *  CFT009 - Funds Transfer Fees and Charges - recompile         *
      *  CSD009 - Profit Centre Accounting Default Matrix Enhancement *
      *           Re-compiled due to changes in module AOPRFMR0.      *
      *  CFT014 - Straight-through Processing Phase 2 MT103           *
      *           Messages Generation for FT. (Recompiled)            *
      *  175479 - Recompile over changes in outgoing payment file     *
      *  179732 - Addition of fix 176510 from the OPM equivalent      *
      *           FT0040.  Default Profit Centre only when 'Ordering  *
      *           Customer' and 'Ordering Bank' is valid              *
      *           Only process 'Ord Bank' defaulting if the 'Ord Cust'*
      *           field is not equal to 'MT202' (to retieve an Acof). *
      *           Customer No. and Account Officer are now used in    *
      *           the Call to AOPRFMR0.                               *
      *  CFT007 - Recompiled for BIC Database Plus Integration        *
      *  CFT004 - Recompiled for IBAN (International Bank A/C No.)    *
      *  CAP031 - Conversion of FT inputs into modular structure to   *
      *           use as APIs.                                        *
      *                                                               *
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
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
 
      ** Flags to indicate whether transaction fields are valid
     D OKFlagsDS     E DS                  EXTNAME(FTEOPY1PD)
 
      * Validation Work Fields
     D Val@Fields    E DS                  EXTNAME(FTV@OPAYPD)
 
      * External DS for Midas modules details
     D SDMMOD        E DS                  EXTNAME(SDMMODPD)
 
      * External DS for General Ledger details
     D SDGELR        E DS                  EXTNAME(SDGELRPD)
 
      ** Midas Profit Centre details
     D SDPRFC        E DS                  EXTNAME(SDPRFCPD)
 
      ** Midas Profit Centre details                                                          179732
     D SDCUST        E DS                  EXTNAME(SDCUSTPD)                                  179732
                                                                                              179732
      ** External data structure for access programs (short)
     D DSFDY         E DS                  EXTNAME(DSFDY)
                                                                                              179732
     D DSSDY         E DS                  EXTNAME(DSSDY)                                     179732
                                                                                              179732
      *  Full account definition for Ordering Customer                                        179732
     D*#ORCDS***       DS            18                                                179732 CGL029
     D #ORCDS          DS                                                                     CGL029
     D*IMCNUM***               1      6  0                                             179732 CSD027
     D IMCNUM                  1      6                                                       CSD027
     D IMCYY                   7      9                                                       179732
     D IMACOD                 10     19  0                                                    CGL029
     D IMACSQ                 20     21  0                                                    CGL029
     D IMBRCA                 22     24                                                       CGL029
     D*IMACOD***              10     13  0                                             179732 CGL029
     D*IMACSQ***              14     15  0                                             179732 CGL029
     D*IMBRCA***              16     18                                                179732 CGL029
                                                                                              179732
      *  Full account definition for Ordering Bank                                            179732
     D*#ORBDS***       DS            18                                                179732 CGL029
     D #ORBDS          DS                                                                     CGL029
     D**OBCNUM**               1      6  0                                             179732 CSD027
     D  OBCNUM                 1      6                                                       CSD027
     D  OBCYY                  7      9                                                       179732
     D  OBACOD                10     19  0                                                    CGL029
     D  OBACSQ                20     21  0                                                    CGL029
     D  OBBRCA                22     24                                                       CGL029
     D**OBACOD**              10     13  0                                             179732 CGL029
     D**OBACSQ**              14     15  0                                             179732 CGL029
     D**OBBRCA**              16     18                                                179732 CGL029
      *                                                                                       179732
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
 
     D C#BOKC          S              2A
     D C#BRCA          S              3A
     D C#DEPT          S              3A
     D C#OPTN          S              7A
     D C#RTCD          S              7A
     D C#RTN1          S              1A
     D C#SUTP          S              2A
     D C#TRTP          S              5A
     D C#USER          S             10A
     D C#ACOF          S              2A
     D C#CUST          S              6A
     D C#PRFC          S              4A
                                                                                              179732
     D @Key1           S             10                                                       179732
     D @Key2           S             10                                                       179732
     D C#KYST          S              7                                                       179732
      *Field for the account officer retrieved from the customer file used for the PCDM       179732
     D BBACOZ          S              2                                                       179732
      *                                                                                       179732
     D Acof            S              2                                                       179732
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
 
     C                   Eval      RetCodeIn = *Blanks
     C                   Eval      FldNamXAr = *Blanks
     C                   Eval      MsgIDXAr  = *Blanks
     C                   Eval      MsgDtaXAr = *Blanks
     C                   Eval      Idx = 0
 
      * PCTR - Profit Centre Validation if Type / Sub-Type and Book Code
      *        valid
      *        And Ordering Customer and Ordering Bank are valid.                             179732
     C                   If        OKPytp = 'Y' and
     C                             OKPyst = 'Y' and
     C********************         OKBokc = 'Y'                                               179732
     C                             OKBokc = 'Y' and                                           179732
     C                             OKOrc1 = 'Y' and                                           179732
     C                             OKOrbk = 'Y'                                               179732
     C                   EXSR      VPRFCTR
     C                   End
 
      * If an error was found, set the return code appropriately
     C                   If        OKPrfc = 'N'
     C                   Eval      RetCodeIn = 'Error'
     C                   End
 
      * RETURN
 
     C                   RETURN
      *****************************************************************
      /EJECT
      *****************************************************************
      * VPRFCTR - PROFIT CENTRE VALIDATION
      *****************************************************************
     C     VPRFCTR       BEGSR
      *
      *  Profit Centre is Optional input.
      *
      *  If the profit centre field is blank set to a default only if
      *  the Profit Centre Defaults Used flag is set to 'Y'.
      *  This could only happen on an Insert.
     C                   If        SACTION = 'I' and
     C                             SPRFC = *Blanks and
     C                             BKPCDU = 'Y'
 
      * Retrieve the Ordering Customer details.                                               179732
     C                   Movel     *Blanks       BBACOZ                                       179732
     C                   Movel     *Blanks       @Key1                                        179732
     C                   Movel     *Blanks       Cust                                         179732
      * If Customer account, then use SORC1 customer no.                                      179732
     C                   If        @ORCT = 'C'                                                179732
     C                   Movel     SORC1         @Key1                                        179732
     C                   Movel     SORC1         Cust              6                          179732
     C                   Endif                                                                179732
      * If Retail or a Partial account                                                        179732
     C                   If        @ORCT = 'R' Or                                             179732
     C**********                   @ORCT = 'P'                                         179732 CFT032
     C                             @ORCT = 'P' Or                                             CFT032
     C                             @ORCT = 'I'                                                CFT032
     C                   Movel     IMCNUM        Cust                                         179732
     C                   Movel     IMCNUM        @Key1                                        179732
     C                   Endif                                                                179732
      *                                                                                       179732
      * Validate for Ordering Customer Number and shortname                                   179732
     C                   CALLB     'AOCUSTR0'                                                 179732
     C                   Parm      *Blanks       C#RTCD                                       179732
     C                   Parm      '*KEY   '     C#OPTN                                       179732
     C                   Parm                    @Key1                                        179732
     C                   Parm      *Blanks       C#KYST                                       179732
     C     SDCUST        Parm      *Blanks       DSSDY                                        179732
      *                                                                                       179732
     C                   If        C#RTCD = *Blanks                                           179732
     C                   Movel     BBACOC        BBACOZ                                       179732
     C                   Endif                                                                179732
      *                                                                                       179732
     C* If Ordering customer has not been set up with a default                               179732
     C* Account Officer, determine the default from the 'Ordering                             179732
     C* Bank' entry.                                                                          179732
     C* Only process 'Ord Bank' if 'Ord Cust' is Not 'MT202'.                                 179732
      *                                                                                       179732
     C                   If        BBACOZ = *Blanks                                           179732
      *                                                                                       179732
     C                   Move      *Blanks       MTtest           35                          179732
     C                   Move      'MT202'       MTtest           35                          179732
      *                                                                                       179732
     C                   If        (SORBK <> *Blanks) And                                     179732
     C                             (SORC1 <> MTtest)                                          179732
      *                                                                                       179732
     C                   Eval      #ORBDS = @ORBDS                                            179732
     C                   Movel     OBCNUM        @Key2                                        179732
      *                                                                                       179732
     C                   CALLB     'AOCUSTR0'                                                 179732
     C                   Parm      *Blanks       C#RTCD                                       179732
     C                   Parm      '*KEY   '     C#OPTN                                       179732
     C                   Parm                    @Key2                                        179732
     C                   Parm      *Blanks       C#KYST                                       179732
     C     SDCUST        Parm      *Blanks       DSSDY                                        179732
      *                                                                                       179732
     C                   If        C#RTCD = *Blanks                                           179732
     C                   Movel     BBACOC        BBACOZ                                       179732
     C                   Endif                                                                179732
      *                                                                                       179732
     C                   Endif                                                                179732
     C                   Endif                                                                179732
      *                                                                                       179732
      *  Determine parameters to be passed
     C                   Movel     SPYTP         C#TRTP
     C                   Movel     BBACOZ        Acof                                         179732
 
      *  Get default profit centre
      *
     C                   CALLB     'AOPRFMR0'                           90
     C                   Parm      *Blanks       C#RTN1
     C                   Parm      SBOKC         C#BOKC
     C                   Parm                    C#TRTP
     C                   Parm      SPYST         C#SUTP
     C                   Parm      SBRCA         C#BRCA
     C                   Parm      @DPPT         C#DEPT
     C                   Parm      @USRID        C#USER
     C****************** Parm      *Blanks       C#ACOF                                       179732
     C****************** Parm      *Blanks       C#CUST                                       179732
     C                   Parm      Acof          C#ACOF                                       179732
     C                   Parm      Cust          C#CUST                                       179732
     C     SPRFC         Parm      *Blanks       C#PRFC
 
      *  If error on CALL - process as database error
     C                   If        *IN90 = '1'
     C                   Exsr      *PSSR
     C                   End
      *
      * If return code is not blank - process for an error
      * If no error then the screen field is filled by passed parameter
      *
     C                   If        C#RTN1 = '2'
     C                   Move      'N'           OKPrfc
     C                   Add       1             Idx
     C                   Movel     'SPRFC'       FldNamXAr(Idx)
     C                   Movel     'MMA0991'     MsgIdXAr(Idx)
     C                   End
     C                   End
 
     C                   If        OKPrfc = 'Y'
      *  Validate Profit Centre
     C                   If        SACTION = 'I'      and
     C                             SPRFC <> *Blanks or
     C                             SACTION = 'A'      and
     C                             SPRFC <> *Blanks or
     C                             SACTION = 'I'      and
     C                             BGN0ST = 'Y'      or
     C                             SACTION = 'A'      and
     C                             BGN0ST = 'Y'
 
     C                   CALLB     'AOPRFCR0'                           90
     C                   Parm      *BLANKS       C#RTCD
     C                   Parm      '*KEY'        C#OPTN
     C                   Parm      SPRFC         C#PRFC
     C     SDPRFC        Parm      SDPRFC        DSFDY
 
      *  If error on CALL - process as database error
     C                   If        *IN90 = '1'
     C                   Exsr      *PSSR
     C                   End
 
      * If return code is not blank - process for an error
     C                   If        C#RTCD <> *Blanks
     C                   Move      'N'           OKPrfc
     C                   Add       1             Idx
     C                   Movel     'SPRFC'       FldNamXAr(Idx)
     C                   Movel     'MMA0992'     MsgIdXAr(Idx)
 
     C                   Else
     C                   Eval      SPRFC = DSPCCD
     C                   End
 
     C                   End
     C                   End
 
     C                   ENDSR
      *****************************************************************
      /EJECT
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
      *  Error fields/message IDs/message data (arrays) from/to caller
     C                   Parm                    FldNamXAr
     C                   Parm                    MsgIDXAr
     C                   Parm                    MsgDtaXAr
 
      ** OK Flags
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
      ** Access Module Details
      *
     C                   CALL      'AOMMODR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*FIRST '     @OPTN
     C     SDMMOD        PARM      SDMMOD        DSFDY
      *
      * DATABASE ERROR
      *
     C     @RTCD         IFNE      *BLANKS
     C                   MOVEL     'SDMMODPD'    DBFILE
     C                   MOVEL     '904'         DBASE
     C                   MOVEL     @OPTN         DBKEY
     C                   EXSR      *PSSR
     C                   END
      *
     C                   Eval      #ORCDS = @ORCDS                                            179732
      ** =================================================================
      ** Program, module and procedure names for database error processing.
      ** =================================================================
      ** The following /COPY sets these values, and also defines LDA as
      ** an external data area
 
     C/COPY ZACPYSRC,DBFIELDS
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      ********************************************************************
     C/COPY ZACPYSRC,PSSR_ILE
      ********************************************************************
**  CPY@
(c) Misys International Banking Systems Ltd. 2001
