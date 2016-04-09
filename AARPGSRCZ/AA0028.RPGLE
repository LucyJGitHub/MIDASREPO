     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2001')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas AA Initialise profit centres for FF')
      *****************************************************************
      *                                                               *
      *  Midas - (module name) Module                                 *
      *                                                               *
      *  AA0028 - Update Future and Options module Files with PRFC    *
      *                                                               *
      *  Function:  This program uses the Profit Centre Default       *
      *             Matrix (PCDM) to fill the empty profit centre     *
      *             on each of the files.  If it is not possible to   *
      *             default from the PCDM it defaults the PRFC        *
      *                                                               *
      *             NOTE: This program DOES NOT pass Department and   *
      *             User to the PCDM (it passes Blanks) As these are  *
      *             generally unavailable from the transaction file.  *
      *                                                               *
      *  Called By: AAC0028 - F&O file PRFC Update                    *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2001            *
      *                                                               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *  Last Amend No. CSD031             Date 10Apr06               *
      *  Prev Amend No. CSD027             Date 09Dec05               *
      *                 CSW037A            Date 02May05               *
      *                 CSD025             Date 11Jan05               *
      *                 CSW037             Date 15Dec04               *
      *                 CSW036             Date 15Dec04               *
      *                 CLE025             Date 20Oct03               *
      *                 CGL029             Date 01Sep03               *
      * Midas Release 4.01 -------------------------------------------*
      *                 CAS002             Date 14Jan02               *
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.04 -----------------------------------------------*
      *                 184967  *CREATE    Date 12Sep00               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CSD031 - Enhanced Centralised Static Data (Recompile)        *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CSW037A- Additional Field extended to 40 chars (recompile)   *
      *  CSD025 - Customer De-Activation                              *
      *  CSW037 - Additional Field Data on MT300/MT320                *
      *  CSW036 - Dual SWIFT BIC held on Client Details               *
      *  CLE025 - Credit Lines (Recompile)                            *
      *  CGL029 - Increase Account Code to 10 digits                  *
      *  CAS002 - Hedge Strategy/Linkage (Recompile)                  *
      *  184967 - Partial Replacement of AA0008                       *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  Use of indicators.                                           *
      *                                                               *
      *    40         End of File                                     *
      *    50         Update Flag                                     *
      *    98         Date Format                                     *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  S U B R O U T I N E  I N D E X                               *
      *                                                               *
      * *PSSR - Error processing                                      *
      * *INZSR - Initialise                                           *
      * FOTRAN - use if Futures and Options Module is On              *
      * ACOfficer - Retrieve Account Officer                          *
      * PCDM    - Call the Profit Centre Default matrix               *
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
 
     FTRANSD    UF   E             DISK
 
      *****************************************************************
      /EJECT
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ D-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
      **--------------------------------------------------------------------------------------------
      ** The following /COPY line includes (among others) the LDA layout
      ** and the copyright array definition:
     D/COPY ZACPYSRC,STD_D_SPEC
      **--------------------------------------------------------------------------------------------
 
      **--------------------------------------------------------------------------------------------
      ** The following /COPY line includes all the defined fields in the
      ** Program Status Data Structure.  They have meaningful
      ** names, prefixed by 'PS'.
     D/COPY ZACPYSRC,PSDS
      **--------------------------------------------------------------------------------------------
 
      **--------------------------------------------------------------------------------------------
      ** The following /COPY line includes all the definitions of the error
      ** arrays, including the named constant giving the size of
      ** the arrays.  Note that it uses #MsgID and *MsgData, and so requires
      ** STD_D_SPEC.
     D/COPY ZACPYSRC,FVAL_ARRAY
      **--------------------------------------------------------------------------------------------
 
      **--------------------------------------------------------------------------------------------
      ** The following /COPY line includes the definitions for error and
      ** warning message arrays.
     D/COPY ZACPYSRC,ERR_ARRAYS
      **--------------------------------------------------------------------------------------------
 
      **--------------------------------------------------------------------------------------------
      ** The following /COPY line includes the definitions for FF-specific
      ** variables.
     D/COPY FFCPYSRC,DECLAREVAR
      **--------------------------------------------------------------------------------------------
 
     D RUNDAT        E DS                  EXTNAME(RUNDAT)
      *
      ** Data Area giving Installation Control Details
 
 
     D AADTA         E DS                  EXTNAME(AADTA)
      **  AA Data Area
 
     D SDGELR        E DS                  EXTNAME(SDGELRPD)
      ** General Ledger ICD
 
     D SDPCAC        E DS                  EXTNAME(SDPCACPD)
      ** PCA ICD
 
     D CustomerDS    E DS                  EXTNAME(SDCUSTPD)
      ** Customer record format
 
     D DSFDY         E DS                  EXTNAME(DSFDY)
      ** Short data structure for Access Programs
 
     D DSSDY         E DS                  EXTNAME(DSSDY)                                     CGL029
      ** Long data structure for Access Programs                                              CGL029
                                                                                              CGL029
     D SDMMOD        E DS                  EXTNAME(SDMMODPD)
      ** Midas modules flags
 
     D SDFODA        E DS                  EXTNAME(SDFODAPD)
      ** Futures and Options ICD
     D  QQACD1       E                     EXTFLD(QQACCD)                                     CGL029
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
      **
 
 
     D @RUN            S              1
     D PCDMBookC       S              2
     D Instrument      S              5
     D PCDMSubType     S              2
     D PCDMBranch      S              3
     D*Customer*       S              6S 0                                                    CSD027
     D*Broker***       S              6S 0                                                    CSD027
     D Customer        S              6A                                                      CSD027
     D Broker          S              6A                                                      CSD027
     D PCDMCustPC      S              4
     D PCDMBookPC      S              4
     D Department      S              3
     D UserID          S             10
     D OKBPRC          S              1
     D OKTPRC          S              1
     D RtnCode         S              7
     D Option          S              7
 
      ** Error array index
     D Idx             S              3P 0
 
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
      *
      ** Read in Installation Data
      *
     C     *DTAARA       DEFINE                  RUNDAT
     C     *DTAARA       DEFINE                  AADTA
     C                   IN        RUNDAT
     C                   IN        AADTA
      *
      ** Set Date Format Indicator *IN98  on if date format is MMDDYY
      *
     C                   IF        AGDFF = 'M'
     C                   EVAL      *IN98 = *ON
     C                   END
 
      *
      *IF Futures And Options is switched ON EXSR to populate PRFC
     C                   IF        BGFUOP = 'Y'
     C                   EXSR      FOTRAN
     C                   ENDIF
 
     C                   EVAL      *INLR = *ON
     C                   RETURN
 
      **********************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * FOTRAN - Subroutine to use if Futures and Options Module is On*
      *                                                               *
      * Called by: Main                                               *
      *                                                               *
      * Calls: ACOfficer, PCDM                                        *
      *                                                               *
      *****************************************************************
 
     C     FOTRAN        BEGSR
 
      * If the values on the AADTA are not blank then process the transactions
     C                   IF        AAFFBP <> *BLANKS AND
     C                             AAFFTP <> *BLANKS
 
      ** Reset the fields specific to the VAL function
      ** ---------------------------------------------
     C                   CLEAR                   FldNameArr
     C                   CLEAR                   MsgIDArr
     C                   CLEAR                   MsgDtaArr
     C                   EXSR      ResetErrs
 
     C                   READ      TRANSD                                 40
      *
      * Do While not EOF
     C                   DOW       *IN40 = '0'
      *
      * If either profit centre is blank then process
     C                   IF        BPRC = *Blank OR
     C                             TPRC = *Blank
      *
      **  Initialise update flag
     C                   EVAL      *IN50 = '0'
      *
     C                   EVAL      PCDMBookC = BOKC
     C                   EVAL      PCDMBranch = BRCA
     C                   EVAL      Instrument = ISTT
     C                   EVAL      PCDMBookPC = BPRC
     C                   EVAL      PCDMCustPC = TPRC
     C**********         Z-ADD     CUSC          Customer                                     CSD027
     C**********         Z-ADD     BOCO          Broker                                       CSD027
     C                   EVAL      CUSC = Customer                                            CSD027
     C                   EVAL      BOCO = Broker                                              CSD027
     C                   EVAL      Department = *Blanks
     C                   EVAL      UserID = *Blanks
     C                   EVAL      OKTPRC = *Blanks
     C                   EVAL      OKBPRC = *Blanks
      * Call FFVPCAPRFC to allocate the profit centre
     C                   EXSR      PCDM
      *
      * Update the record with the Profit Centre
      * Compare these values with the Unallocated ICD value
     C                   IF        PCDMBookPC = FTUAPC OR
     C                             PCDMBookPC = *Blanks
     C                   EVAL      BPRC = AAFFBP
     C                   ELSE
     C                   EVAL      BPRC = PCDMBookPC
     C                   ENDIF
      *
     C                   IF        PCDMCustPC = FTUAPC OR
     C                             PCDMCustPC = *Blanks
     C                   EVAL      TPRC = AAFFTP
     C                   ELSE
     C                   EVAL      TPRC = PCDMCustPC
     C                   ENDIF
     C                   UPDATE    TRANSDF
      * EndIf Blank BPRC or TPRC
     C                   ENDIF
      * Read next record
     C                   READ      TRANSD                                 40
     C                   ENDDO
     C                   ENDIF
 
     C                   ENDSR
 
      **********************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * PCDM - Retrieve Account Officer                               *
      *                                                               *
      * Called by: FOTRAN                                             *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
 
     C     PCDM          BEGSR
      **  Call the program FFVPCAPRFC - which is used to validate the Profit Centre
      **  of the transaction
      *
     C                   CALLB     'FFVPCAPRFC'
      ** Outputs from called procedure
      ** -----------------------------
      ** Return code (10A, returned to caller)
     C                   PARM                    ReturnCode
      ** Field name array (<ErrArrMax> x 10A, returned to caller)
     C                   PARM                    FldNamXArr
      ** Error message ID array (<ErrArrMax> x 7A, returned to caller)
     C                   PARM                    MsgIDXArr
      ** Error message data array (<ErrArrMax> x 45A, returned to caller)
     C                   PARM                    MsgDtaXArr
      ** OK flags for book and transaction positions profit centres
     C                   PARM                    OKBPRC
     C                   PARM                    OKTPRC
      ** Inputs to called procedure
      ** --------------------------
      ** Book positions profit centre
     C                   PARM                    PCDMBookPC
      ** Transaction positions profit centre
     C                   PARM                    PCDMCustPC
      ** Book code
     C                   PARM                    PCDMBookC
      ** Branch codes
     C                   PARM                    PCDMBranch
      ** Instrument Type
     C                   PARM                    Instrument
      ** Transaction broker
     C                   PARM                    Broker
      ** Transaction customer
     C                   PARM                    Customer
      ** Department (Blanked)
     C                   PARM                    Department
      ** User (Blanked)
     C                   PARM                    UserID
      ** ICD
      ** Profit centres defaults used
     C                   PARM                    BKPCDU
      ** Reconcile trade/book position profit centre
     C                   PARM                    BXTBRC
 
      ** Do the return code and error details handling.  The two OK flags
      ** are set in the called module, so don't need to do SR/HandlRet;
      ** just append the error codes if necessary.
      ** If errors or warnings found, append error and warning details
      ** from this module to the overall error and warning arrays.
     C                   IF        ReturnCode <> *blanks
     C                   EXSR      AppendArrs
     C                   ENDIF
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * ResetErrs - Reset or clear all error-related fields           *
      *                                                               *
      *****************************************************************
 
     C     ResetErrs     BEGSR
 
      **--------------------------------------------------------------------------------------------
      ** The following /COPY line resets the fields related to error
      ** handling: ReturnCode, ErrorFound, FldNamXArr, MsgIDXArr,
      ** MsgDtaXArr, XIdx; and to warning message handling: WarnFound,
      ** FldNamWArr, MsgIDWArr, MsgDtaWArr, WIdx.
      ** It therefore requires FVAL_ARRAY and STD_D_SPEC.
     D/COPY ZACPYSRC,FVAL_RESET
      **--------------------------------------------------------------------------------------------
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * AppendArrs - Append one field's error and warning details to  *
      *              the general error and warning arrays.            *
      *                                                               *
      *****************************************************************
 
     C     AppendArrs    BEGSR
 
     C                   CALLB     'APAPNDARRS'
      ** Outputs from called procedure
      ** -----------------------------
      ** Return code (10A, returned to caller)
     C                   PARM                    ReturnCode
      ** Error array index (3,0P)
     C                   PARM                    Idx
      ** Field names with errors array (<ArrayMax> x 10A)
     C                   PARM                    FldNameArr
      ** Error message ID array (<ArrayMax> x 7A)
     C                   PARM                    MsgIDArr
      ** Error message data array (<ArrayMax> x 45A)
     C                   PARM                    MsgDtaArr
      ** Warning array index (3,0P)
     C                   PARM                    WIdx
      ** Field names with warnings array (<ArrayMax> x 10A)
     C                   PARM                    WFldNamArr
      ** Warning message ID array (<ArrayMax> x 7A)
     C                   PARM                    WMsgIDArr
      ** Warning message data array (<ArrayMax> x 45A)
     C                   PARM                    WMsgDtaArr
 
      ** Inputs to called procedure
      ** --------------------------
      ** Field name array (<ErrArrMax> x 10A)
     C                   PARM                    FldNamXArr
      ** Error message ID array (<ErrArrMax> x 7A)
     C                   PARM                    MsgIDXArr
      ** Error message data array (<ErrArrMax> x 45A)
     C                   PARM                    MsgDtaXArr
      ** Field name array (<WArrMax> x 10A)
     C                   PARM                    FldNamWArr
      ** Warning message ID array (<WArrMax> x 7A)
     C                   PARM                    MsgIDWArr
      ** Warning message data array (<WArrMax> x 45A)
     C                   PARM                    MsgDtaWArr
 
     C                   ENDSR
 
      **********************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * *INZSR - Program Initialisation routine                       *
      *                                                               *
      * Called by: Implicitly on program activation                   *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
 
     C     *INZSR        BEGSR
 
      *
      ** GET MODULE DETAILS
      *
     C                   CALL      'AOMMODR0'
     C                   PARM      *BLANKS       RtnCode
     C                   PARM      '*FIRST'      Option
     C     SDMMOD        PARM      SDMMOD        DSFDY
      *
      ** DATABASE ERROR
      *
     C                   IF        RtnCode <> *BLANKS
      ** Data base error in file (file)
      *
     C     *LOCK         IN        LDA
     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   EVAL      DBFILE =  'SDMMODPD'
     C                   EVAL      DBKEY  =  'KEY'
     C                   EVAL      DBPGM  =  PSProcPgm
     C                   EVAL      DBASE  =  001
     C                   EVAL      DBMOD  =  PSProcMod
     C                   EVAL      DBPROC =  'SR/*INZSR'
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   END
 
      *
      ** GET General Ledger Details
      *
     C**********         CALL      'AOGELRR0'                                                 CGL029
     C                   CALL      'AOGELRR1'                                                 CGL029
     C                   PARM      *BLANKS       RtnCode
     C                   PARM      '*FIRST'      Option
     C*****SDGELR        PARM      SDGELR        DSFDY                                        CGL029
     C     SDGELR        PARM      SDGELR        DSSDY                                        CGL029
      *
      ** DATABASE ERROR
      *
     C                   IF        RtnCode <> *BLANKS
      ** Data base error in file (file)
      *
     C     *LOCK         IN        LDA
     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   EVAL      DBFILE =  'SDGELRPD'
     C                   EVAL      DBKEY  =  'KEY'
     C                   EVAL      DBPGM  =  PSProcPgm
     C                   EVAL      DBASE  =  001
     C                   EVAL      DBMOD  =  PSProcMod
     C                   EVAL      DBPROC =  'SR/*INZSR'
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   END
 
      * If Futures and Options is on
     C                   IF        BGFUOP = 'Y'
      ** Futures and Options ICD
     C                   CALL      'AOFODAR0'
     C                   PARM      '*DBERR '     RtnCode
     C                   PARM      '*FIRST '     OPtion
     C     SDFODA        PARM      SDFODA        DSFDY
      *
      ** DATABASE ERROR
      *
     C                   IF        RtnCode <> *BLANKS
      ** Data base error in file (file)
      *
     C     *LOCK         IN        LDA
     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   EVAL      DBFILE =  'SDFODAPD'
     C                   EVAL      DBKEY  =  'KEY'
     C                   EVAL      DBPGM  =  PSProcPgm
     C                   EVAL      DBASE  =  001
     C                   EVAL      DBMOD  =  PSProcMod
     C                   EVAL      DBPROC =  'SR/*INZSR'
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   END
     C                   ENDIF
 
      *
      ** GET PCA ICD
      *
     C                   CALL      'AOPCACR0'
     C                   PARM      *BLANKS       RtnCode
     C                   PARM      '*FIRST'      Option
     C     SDPCAC        PARM      SDPCAC        DSFDY
      *
      ** DATABASE ERROR
      *
     C                   IF        RtnCode <> *BLANKS
      ** Data base error in file (file)
      *
     C     *LOCK         IN        LDA
     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   EVAL      DBFILE =  'SDPCACPD'
     C                   EVAL      DBKEY  =  'KEY'
     C                   EVAL      DBPGM  =  PSProcPgm
     C                   EVAL      DBASE  =  001
     C                   EVAL      DBMOD  =  PSProcMod
     C                   EVAL      DBPROC =  'SR/*INZSR'
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   END
 
 
     C                   ENDSR
      *
      /EJECT
      *****************************************************************
      *                                                               *
      * *PSSR  - Program exception error routine                      *
      *          Called automatically if a program error occurs,      *
      *          or directly by the program code using EXSR.          *
      *          This subroutine DUMPs the program just once.         *
      *                                                               *
      * Called by: (**calling routines**)                             *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
      *
     C     *PSSR         BEGSR
      *
     C                   IF        @RUN = *BLANK
     C                   EVAL      @RUN = 'Y'
     C                   DUMP
      *
     C                   ENDIF
      *
     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   EVAL      *INLR = *ON
     C                   RETURN
      *
     C                   ENDSR
      *
      ********************************************************************
      /EJECT
      ********************************************************************
**  CPY@
(c) Misys International Banking Systems Ltd. 2001
