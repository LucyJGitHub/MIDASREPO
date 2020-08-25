     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2003')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas IR FRA validate and update')                     *
      *****************************************************************
      *                                                               *
      *  Midas - Module name ILE Module                               *
      *                                                               *
      *  IRFRAVU  -  Fwd Rate Agreement validate and update           *
      *                                                               *
      *  Function: This program validates FRA transactions for        *
      *            input into the Midas database.                     *
      *            The action code determines which processes are     *
      *            executed as follows:                               *
      *            - For I (=Insert) or A (=Amend)                    *
      *              - Validate the transaction details fields        *
      *            - For A (=AMEND),                                  *
      *              - if transaction is a partial amendment, call a  *
      *                separate function to complete the transaction  *
      *                details.                                       *
      *              - if transaction is valid, call a separate       *
      *                function to check whether it is a valid        *
      *                amendment.                                     *
      *            - For D (=DELETE), call a separate function to     *
      *              process the transaction and bypass the rest of   *
      *              the validation.                                  *
      *                                                               *
      *            For all action codes, the decision to as to        *
      *            whether to write to the valid or invalid file and  *
      *            the call to the message handler will take place    *
      *            in this module                                     *
      *                                                               *
      *  (c) Finastra International Limited 2003                      *
      *                                                               *
      *  Last Amend No. CSD103             Date 10Aug20               *
      *  Prev Amend No. CSD102             Date 08Jan19               *
      *                 MD046248           Date 27Oct17               *
      *                 MD044506           Date 28Mar17               *
      *                 CSD095CC1          Date 13Sep16               *
      *                 MD040199           Date 05Aug16               *
      *                 CSW216             Date 14Mar16               *
      *                 MD033870           Date 17Apr15               *
      *                 MD030858           Date 25Nov14               *
      *                 MD030830           Date 25Nov14               *
      *                 MD029165           Date 25Nov14               *
      *                 CSW214             Date 25Nov14               *
      *                 CDL094             Date 11Jun14               *
      *                 CSD095             Date 08Apr14               *
      *                 MD023734           Date 30Nov13               *
      *                 CSW213             Date 03Jun13               *
      *                 CSF011A            Date 28Nov11               *
      *                 CER059             Date 19Jul10               *
      *                 BUG22478           Date 27Jan09               *
      *                 BUG27851           Date 27May10               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      *                 BUG25485           Date 13Aug09               *
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      *                 BUG18701           Date 12May08               *
      * Midas Plus 1.4 Base ------------------------------------------*
      *                 244254             Date 14Dec06               *
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CSD027             Date 09Dec05               *
      *                 CLE031             Date 26Apr05               *
      *                 CDL038             Date 10May05               *
      *                 BUG5871            Date 22May05               *
      *                 BUG6512            Date 28Apr05               *
      *                 BUG7166            Date 12May05               *
      *                 CDL028             Date 07Feb05               *
      *                 BUG6377            Date 11Apr05               *
      *                 BUG5674            Date 03Feb05               *
      *                 BUG4744            Date 01Feb05               *
      *                 BUG4469            Date 06Oct04               *
      *                 BUG4482            Date 29Sep04               *
      *                 BUG2959            Date 07Jun04               *
      *                 CDL018             Date 03Feb04               *
      *                 TDA011 (Reopen)    Date 02Apr04               *
      *                 TDA011             Date 31Mar04               *
      *                 CSC022             Date 24Feb04               *
      *                 225362             Date 24Mar04               *
      *                 222727             Date 05Nov03               *
      *                 CAP084  *Create    Date 20Aug03               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CSD103 - LIBOR Deregulation - Common Layer/Standing Data     *
      *  CSD102 - Password Length Extension (Recompile)               *
      *  MD046248 - Finastra Rebranding                               *
      *  MD044506 - MT300 98D trade execution date can not be before  *
      *             value date.                                       *
      *  CSD095CC1 - Allow Deal Sub-Type and Branch for IRS, FRA and  *
      *              CCF SSIs (Recompiled)                            *
      *  MD040199 - ISDA Agreement Version reflected incorrectly in   *
      *             MT reports and deals enquiry. Map the ISDA        *
      *             Agreement Version fields correctly from screen to *
      *             file format.                                      *
      *  CSW216 - SWIFT Changes 2016 (Recompile)                      *
      *  MD033870 - ISDA fields are reset to blank after defaulting.  *
      *             Move original value if blank after defaulting.    *
      *  MD030858 - Execution timestamp (Date) is not generated when  *
      *             the RPIF fields were populated via Interface      *
      *  MD030830 - Inserted autoauthorized FRA transaction has       *
      *             COMPLETE status instead of AUTHORIZE              *
      *  MD029165 - Manually defined values in field 72 of Settlement *
      *             Confirmation tab are being overwritten            *
      *  CSW214 - SWIFT Changes 2014                                  *
      *  CDL094 - Enhance Receive Settlement Instructions             *
      *           (Recompile)                                         *
      *  CSD095 - Allow Deal Sub-Type and Branch for MM and FX SSIs   *
      *  MD023734 - Clearing Threshold Indicator not defaulted.       *
      *  CSW213 - SWIFT Changes 2013                                  *
      *  CSF011A - CCR015: Display Order in Confirmation Pages        *
      *  CER059 - German Feature Upgrade to Delhi                     *
      *  BUG22478 - Field error during authorization. (Recompile)     *
      *  BUG27851 - Error message not found upon authorisation        *
      *  BUG25485 - Correct PONS and RONS mapping                     *
      *  BUG18701 - Implement Auto Authorisation                      *
      *  244254 - Retrieve ISDA details from customer's default       *
      *           settlement details even if the pay/recv details     *
      *           are manually input on the screen.                   *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CLE031 - Lending Enhancements - Settlement Currency Recompile*
      *  CDL038 - Extended Deal Sub Type                              *
      *  BUG5871 - Send deal status to midasplus                      *
      *  BUG6512 - Retrieve TRAM details                              *
      *  BUG7166- Valid file does not match DEALSDG (Recompile)       *
      *  CDL028 - Automatic Rate Interpolations (Recompile)           *
      *  BUG6377 - Need Fixing Dates (Ours and Theirs) ADDED to       *
      *            the confirmation screens                           *
      *  BUG5674- FRA settlement information not being defaulted      *
      *           from SSI, even SSI has been set up.                 *
      *  BUG4744 - To ensure information output to Buffer is a true   *
      *            picture of the update.                             *
      *  BUG4469- Stopping changes being overwritten by other user    *
      *           when try to amend the record at the same time by    *
      *           passing the Timestamp out to API.                   *
      *  BUG4482 - Authorise should call Validate to show all the     *
      *            warning errors.                                    *
      *  BUG2959 - Settlement Confirmation Fields not being shown.    *
      *  CDL018 - Multiple Settlement Accounts on Loans/Deposits      *
      *           (Recompile)                                         *
      *  TDA011 (Reopen) - Rate Fix Ccy writes to the wrong field     *
      *  TDA011 - Rate Fix Ccy writes to the wrong field (Recompile)  *
      *  CSC022 - Commitment Control Changes for MidasPlus            *
      *  225362 - Amend the position of field FRARFCy (Currency Rate  *
      *           Fixing Convention) to align with the new position   *
      *           of fields in file IRVFRAPD.                         *
      *  222727 - Release 5.0 errors  (Recompile)                     *
      *  CAP084 - API Wrapper project                                 *
      *                                                               *
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
      *****************************************************************

     FZAFLDNPD  IT   F   15        DISK    INFSR(*PSSR)
                                                                                              244254
     FSDEXSTL1  IF   E           K DISK                                                       244254

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

      **-----------------------------------------------------------------------
      ** The following /COPY line includes the definitions for error and
      ** warning message arrays.
     D/COPY ZACPYSRC,ERR_ARRAYS
      **-----------------------------------------------------------------------

      **-----------------------------------------------------------------------
      ** The following /COPY line includes the definitions for arrays
      ** specific to API CTL & VU modules.
     D/COPY ZACPYSRC,APICTLARR
      **-----------------------------------------------------------------------

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
     D CIR008          S              1A
     D CAP056          S              1A
     D CAP051          S              1A                                                    MD030830

      ** +--------------------------------------+
      ** ¦ Named constants                      ¦
      ** ¦ ===============                      ¦
      ** +--------------------------------------+

      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+

      * Incoming header
     D HeadIn        E DS                  EXTNAME(APHEADPD)

      * Incoming transaction in screen format
     D TranInFra     E DS                  EXTNAME(IRFRAPD)

      * Valid Fwd Rate Agreement layout
     D ValidFRA      E DS                  EXTNAME(IRVFRAPD)
     D                                     PREFIX(V_)
     D  FRADet1                2    715
     D  FRARecIns            716    784
     D  FRAPayIns            785   1343
     D  FRAFraIns           1345   1992
     D**FRARFCy*            2063   2092                                                       225362
     D  FRARFCy             2097   2126                                                       225362

      * Current transaction record in file format
     D FRAFilFmt     E DS                  EXTNAME(DEALSDG)
     D DGDet1                  2    715
     D DGRecIns              716    784
     D DGPayIns              785   1343
     D DGFraIns             1345   1992
     D DGFRFCy              2097   2126

      * Current transaction in screen format
     D CurTrFRA      E DS                  EXTNAME(IRFRAPD)
     D                                     PREFIX(@)

      * Pay settlement instructions in screen format
     D InPaySttmt    E DS                  EXTNAME(SDESSPPD)

      * Receive settlement instructions in screen format
     D InRecSttmt    E DS                  EXTNAME(SDESSRPD)

      * FRA/IRS settlement instructions in screen format
     D InFRASttmt    E DS                  EXTNAME(SDESSFPD)

      * Pay settlement instructions - current
     D CrPaySttmt    E DS                  EXTNAME(SDESSPPD) PREFIX(@)

      * Receive settlement instructions - current
     D CrRecSttmt    E DS                  EXTNAME(SDESSRPD) PREFIX(@)

      * FRA/IRS settlement instructions - current
     D CrFRASttmt    E DS                  EXTNAME(SDESSFPD) PREFIX(@)

      * Error indicators
     D OKTrFRA       E DS                  EXTNAME(IREFRAPD)


      * External DS for bank details
     D SDBANK        E DS                  EXTNAME(SDBANKPD)

      * External DS for API ICD
     D SDAPI         E DS                  EXTNAME(SDAPIPD)

     D DBPaySttmt    E DS                  EXTNAME(SDESFPPD)
      * Pay Settlement Instructions - File (D/B) format

     D DBRecSttmt    E DS                  EXTNAME(SDESFRPD)
      * Receive Settlement Instructions - File (D/B) format

     D DBFRASttmt    E DS                  EXTNAME(SDESFFPD)
      * FRA/IRS Settlement Instructions - File (D/B) format
      * External DS for SAR details
     D SCSARD        E DS                  EXTNAME(SCSARDPD)
     D SCA_LCD       E                     EXTFLD(LCD)

      ** FRA/IRS Interface Non-Screen Data
     D InfData       E DS                  EXTNAME(IRFRIFPD)

     D ExtData       E DS                  EXTNAME(IRFREXPD)
      * IR FRA Extra Data - File (D/B) format

      * First DS for access programs - short data structure
     D DSFDY         E DS                  EXTNAME(DSFDY)

      * Second DS for access programs - long data structure
     D DSSDY         E DS                  EXTNAME(DSSDY)

     D SC24X7        E DS                  EXTNAME(SC24X7) DTAARA(SC24X7)
      ** 24X7 status dataarea

     D SDSTAT        E DS                  EXTNAME(SDSTAT) DTAARA(SDSTAT)
      ** SD data area
                                                                                              CSC022
      ** Jobs Handling Commitment Control                                                     CSC022
     D SCCMTJOB      E DS           256    EXTNAME(SCCMTJOB) DTAARA(SCCMTJOB)                 CSC022
     D  COMITARR               4    103                                                       CSC022
                                                                                              CSC022
      ** Array of Commitment Job Names                                                        CSC022
     D COMITJOB        S             10A   DIM(10)                                            CSC022

      **ISDA settlement fields                                                                244254
     D WWAGVV          DS             4                                                       244254
     D WDAGVC                  1      2                                                       244254
     D WDAGVV                  3      4                                                       244254
                                                                                              244254
      *                                                                                       CSW213
      ** Define data structure for InSwift2013                                                CSW213
      *                                                                                       CSW213
     D InSwift2013     DS                                                                     CSW213
     D  DLRPIFS1In                         LIKE(DLRPIFScn1Fmt)                                CSW213
     D  DLRPIFS2In                         LIKE(DLRPIFScn2Fmt)                                CSW213
     D  DLRPIFS3In                         LIKE(DLRPIFScn3Fmt)                                CSW213
     D  DLRPIFS4In                         LIKE(DLRPIFScn4Fmt)                                CSW214
      *                                                                                       CSW213
      ** Define data structure for OutSwift2013                                               CSW213
     D OutSwift2013    DS                                                                     CSW213
     D  DLRPIFS1Out                        LIKE(DLRPIFScn1Fmt)                                CSW213
     D  DLRPIFS2Out                        LIKE(DLRPIFScn2Fmt)                                CSW213
     D  DLRPIFS3Out                        LIKE(DLRPIFScn3Fmt)                                CSW213
     D  DLRPIFS4Out                        LIKE(DLRPIFScn4Fmt)                                CSW214
      *                                                                                       CSW213
      ** Midas DL Dealing Reporting Information file                                          CSW213
      *                                                                                       CSW213
     D DLRPIFScn1Fmt E DS                  EXTNAME(DLRIS1PD)                                  CSW213
     D DLRPIFScn2Fmt E DS                  EXTNAME(DLRIS2PD)                                  CSW213
     D DLRPIFScn3Fmt E DS                  EXTNAME(DLRIS3PD)                                  CSW213
     D DLRPIFScn4Fmt E DS                  EXTNAME(DLRIS4PD)                                  CSW214
     D DLRPIFFileFmt E DS                  EXTNAME(DLRPIFPD)                                  CSW213
     D DLRILKPDIn    E DS                  EXTNAME(DLRILKPD)                                  CSW213
     D DLVRPIFileFmt E DS                  EXTNAME(DLVRPIPD)                                  CSW213
     D DLRIS1PDOut   E DS                  EXTNAME(DLRIS1PD)                                  CSW213
     D                                     PREFIX(OUT)                                        CSW213
     D DLRIS2PDOut   E DS                  EXTNAME(DLRIS2PD)                                  CSW213
     D                                     PREFIX(OUT)                                        CSW213
     D DLRIS3PDOut   E DS                  EXTNAME(DLRIS3PD)                                  CSW213
     D                                     PREFIX(OUT)                                        CSW213
     D DLRIS4PDOut   E DS                  EXTNAME(DLRIS4PD)                                  CSW214
     D                                     PREFIX(OUT)                                        CSW214
      *                                                                                       CSW213
      * RPIF Error File - Screen 1                                                            CSW213
     D DLError1      E DS                  EXTNAME(DLERI1PD)                                  CSW213
      *                                                                                       CSW213
      * RPIF Error File - Screen 2                                                            CSW213
     D DLError2      E DS                  EXTNAME(DLERI2PD)                                  CSW213
      *                                                                                       CSW213
      * RPIF Error File - Screen 3                                                            CSW213
     D DLError3      E DS                  EXTNAME(DLERI3PD)                                  CSW213
      *                                                                                       CSW214
      ** RPIF Error File - Screen 3                                                           CSW214
     D DLError4      E DS                  EXTNAME(DLERI4PD)                                  CSW214

      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+

      * Error message field(s)
     D     Msg1        S                   LIKE(#MsgID)

      * Index for arrays of error message ids etc
     D Idx             S              3P 0 INZ(0)

      * Index for arrays of warning message ids etc
     D WIdx            S              3P 0 INZ(0)

      * Fields (500A) to receive the incoming transaction
     D Trans5001       S            500A

      * Field (500A) to receive the incoming Extra Data
     D InfData500      S            500A

      * Field (500A) to receive the incoming Extra Data
     D ExtData500      S            500A

      * Index for arrays of error message ids etc in Amend validation
     D AmIdx           S              3P 0

      * Indices for arrays used to set up corresponding
      * sequence numbers for the fields that are in error
     D Ix              S              3P 0
     D Iy              S              3P 0

RGC   ** Array message for RPIF                                                               CSW213
RGC  D DFldNameArr     S             10A   DIM(ArrayMax)                                      CSW213
RGC  D DMsgIDArr       S              7A   DIM(ArrayMax)                                      CSW213
RGC  D DMsgDtaArr      S             45A   DIM(ArrayMax)                                      CSW213
RGC  D DWFldNamArr     S             10A   DIM(ArrayMax)                                      CSW213
RGC  D DWMsgIDArr      S              7A   DIM(ArrayMax)                                      CSW213
RGC  D DWMsgDtaArr     S             45A   DIM(ArrayMax)                                      CSW213
                                                                                              CSW213
      ** Work Variables for DLRPIFR                                                           CSW213
     D ValScrnNo       S              1  0                                                    CSW213
     D PRetCode        S             10                                                       CSW213
     D PModeOp         S              6                                                       CSW213
     D PTranRefOK      S              1                                                       CSW213
     D DFOfcrIDOK      S              1                                                       CSW213
     D WNoRepFlag      S              1                                                       CSW213
     D CSW213          S              1                                                       CSW213
     D CtrX            S              3S 0                                                    CSW213
     D RIdx            S              3P 0                                                    CSW213
     D WRIdx           S              3P 0                                                    CSW213
     D DUpdateYN       S              1A                                                      CSW213

      ** Flags to indicate whether transaction fields are valid
      ** These have been declared for all DL1601 fields, some may not
      **  actually be needed if the field is not used/not validated
     D OKFlagsDS       DS
     D  SAccdOK                       1A   INZ('Y')
     D  SDlnoOK                       1A   INZ('Y')
     D  SDTypOK                       1A   INZ('Y')
     D  SDlstOK                       1A   INZ('Y')
     D  SDDatOK                       1A   INZ('Y')
     D  SBrcaOK                       1A   INZ('Y')
     D  SBrkcOK                       1A   INZ('Y')
     D  SBageOK                       1A   INZ('Y')
     D  SLnkDnOK                      1A   INZ('Y')
     D  SCnumOK                       1A   INZ('Y')
     D  SVDatOK                       1A   INZ('Y')
     D  SMDatOK                       1A   INZ('Y')
     D  SCdasOK                       1A   INZ('Y')
     D  SUCucyOK                      1A   INZ('Y')
     D  SUPamtOK                      1A   INZ('Y')
     D  SUFfiOK                       1A   INZ('Y')
     D  SUBcxrOK                      1A   INZ('Y')
     D  SBokCOK                       1A   INZ('Y')
     D  SUIcbsOK                      1A   INZ('Y')
     D  STaxiOK                       1A   INZ('Y')
     D  SUFrfdOK                      1A   INZ('Y')
     D  SPrfCOK                       1A   INZ('Y')
     D  SOrBrOK                       1A   INZ('Y')
     D  SBySlOK                       1A   INZ('Y')
     D  SSetFOK                       1A   INZ('Y')
     D  SRfRteOK                      1A   INZ('Y')
     D  SCRteOK                       1A   INZ('Y')
     D  SCAInOK                       1A   INZ('Y')                                           CDL038
     D  SCYr1OK                       1A   INZ('Y')
     D  SCYr2OK                       1A   INZ('Y')
     D  SCYr3OK                       1A   INZ('Y')
     D  SCYr4OK                       1A   INZ('Y')
     D  SCYr5OK                       1A   INZ('Y')
     D  SCYr6OK                       1A   INZ('Y')
     D  SCYr7OK                       1A   INZ('Y')
     D  SCYr8OK                       1A   INZ('Y')
     D  SCYr9OK                       1A   INZ('Y')
     D  SCYr0OK                       1A   INZ('Y')
     D  SRKVLOK                       1A   INZ('Y')                                           CDL038
     D  SRKSNOK                       1A   INZ('Y')                                           CDL038
     D  SCLasOK                       1A   INZ('Y')                                           CDL038
     D**SRSetMOK**********************1A   INZ('Y')                                           CDL038
     D**SPSetMOK**********************1A   INZ('Y')                                           CDL038
     D**SURAccOK**********************1A   INZ('Y')                                           CDL038
     D**SROBrOK***********************1A   INZ('Y')                                           CDL038
     D**SORAccOK**********************1A   INZ('Y')                                           CDL038
     D**SUPAccOK**********************1A   INZ('Y')                                           CDL038
     D**SPOBrOK***********************1A   INZ('Y')                                           CDL038
     D**SOPAccOK**********************1A   INZ('Y')                                           CDL038
     D**SCpPBkOK**********************1A   INZ('Y')                                           CDL038
     D**SCpRBkOK**********************1A   INZ('Y')                                           CDL038
     D**SFAcOOK***********************1A   INZ('Y')                                           CDL038
     D**SSPiOK************************1A   INZ('Y')                                           CDL038
      ** Flag(s) to indicate if combinations of transaction fields are valid
     D  DDDltStpOK                    1A   INZ('Y')

      ** Flags to indicate whether Pay Settlement instruction fields
      **  are valid
     D OKPayInsDS      DS
     D  DDPscyOK                      1A   INZ('Y')
     D  DDPstmOK                      1A   INZ('Y')
     D  DDPonxOK                      1A   INZ('Y')
     D  DDRvnoOK                      1A   INZ('Y')
     D  DDCvmrOK                      1A   INZ('Y')
     D  DDPocnOK                      1A   INZ('Y')
     D  DDPobnOK                      1A   INZ('Y')
     D  DDRcrnOK                      1A   INZ('Y')
     D  DDRcraOK                      1A   INZ('Y')
     D  DDPibnOK                      1A   INZ('Y')
     D  DDPibaOK                      1A   INZ('Y')
     D  DDAwbnOK                      1A   INZ('Y')
     D  DDAwbaOK                      1A   INZ('Y')
     D  DDBennOK                      1A   INZ('Y')
     D  DDBenaOK                      1A   INZ('Y')
     D  DDDtp1OK                      1A   INZ('Y')
     D  DDDtp2OK                      1A   INZ('Y')
     D  DDDtp3OK                      1A   INZ('Y')
     D  DDDtp4OK                      1A   INZ('Y')
     D  DDDchgOK                      1A   INZ('Y')
     D  DDIc72OK                      1A   INZ('Y')
     D  DDBtb1OK                      1A   INZ('Y')
     D  DDBtb2OK                      1A   INZ('Y')
     D  DDBtb3OK                      1A   INZ('Y')
     D  DDBtb4OK                      1A   INZ('Y')
     D  DDBtb5OK                      1A   INZ('Y')
     D  DDBtb6OK                      1A   INZ('Y')

      ** Flags to indicate whether Receive Settlement instruction fields
      **  are valid
     D OKRecInsDS      DS
     D  DDRscyOK                      1A   INZ('Y')
     D  DDRstmOK                      1A   INZ('Y')
     D  DDRonxOK                      1A   INZ('Y')
     D  DDRocnOK                      1A   INZ('Y')
     D  DDRobnOK                      1A   INZ('Y')
     D  DDRibnOK                      1A   INZ('Y')
     D  DDRibaOK                      1A   INZ('Y')

      ** Flags to indicate whether FRA/IRS instruction fields are valid
     D OKFRAInsDS      DS
     D  DDDsr1OK                      1A   INZ('Y')
     D  DDDsr2OK                      1A   INZ('Y')
     D  DDDsr3OK                      1A   INZ('Y')
     D  DDDsr4OK                      1A   INZ('Y')
     D  DDDsr5OK                      1A   INZ('Y')
     D  DDDsr6OK                      1A   INZ('Y')
     D  DDSsr1OK                      1A   INZ('Y')
     D  DDSsr2OK                      1A   INZ('Y')
     D  DDSsr3OK                      1A   INZ('Y')
     D  DDSsr4OK                      1A   INZ('Y')
     D  DDSsr5OK                      1A   INZ('Y')
     D  DDSsr6OK                      1A   INZ('Y')
     D  DDCnd1OK                      1A   INZ('Y')
     D  DDCnd2OK                      1A   INZ('Y')
     D  DDCnd3OK                      1A   INZ('Y')
     D  DDCnd4OK                      1A   INZ('Y')
     D  DDCnd5OK                      1A   INZ('Y')
     D  DDCnd6OK                      1A   INZ('Y')
     D  DDIsdaOK                      1A   INZ('Y')
     D  DDAgtyOK                      1A   INZ('Y')
     D  DDAgdtOK                      1A   INZ('Y')
     D  DDAgvvOK                      1A   INZ('Y')

      ** Module ID, to be passed to the Message Handler
     D ModuleID        S              2A

      ** Numeric version of spread/rate
     D @SPRD           S             11P 7

      ** A code to indicate the calling function to the lower level modules
     D FRA             S              4A   INZ('FRA ')

      ** Payment & Receipt dates, passed to Settlements Validation routine.
      ** spaces in parameter list not used by this function
     D PayDat          S              5P 0 INZ(99999)
     D RecDat          S              5P 0 INZ(99999)

      * Timestamp for the transaction
     D TimeStamp       S               Z

      ** Receive / Pay Settlement Method & Nostro
     D RecSetCcy       S              3A
     D RecSetMeth      S              2S 0
     D RecNostro       S             18A                                                      CDL038
     D*RecNostro*******S             12A                                                      CDL038
     D PaySetCcy       S              3A
     D PaySetMeth      S              2S 0
     D PayNostro       S             18A                                                      CDL038
     D*PayNostro*******S             12A                                                      CDL038

     D Object          S             10A   INZ('IRFRAUPC')
     D Lib             S             10A   INZ('*LIBL')
     D ObjType         S              7A
     D LockState       S              7A   INZ('*SHRRD')
     D Member          S             10A
     D WaitTime        S              6A   INZ('0     ')
     D Dlcobj          S              1A   INZ('Y')
     D Return          S              7A

      ** Dummy message ID and message file fields for use on the calls to
      ** ZAMSGTOOPR
     D DummyMsgID      S                   LIKE(#MsgID)
     D DummyMsgF       S             10A

     D CSC011          S              1A   INZ('N')
     D TRANSDTL        S           5800A
     D PDealNo         S             18A
     D PADealNo        S             18A
     D PRTCD           S              7A
     D POPTN           S              7A
     D PSARD           S              6A

     D SUINFD          S              6A                                                     BUG6377
     D STINFD          S              6A                                                     BUG6377
                                                                                             BUG6377
      ** Whether or not to clear the program message queue (this is not
      ** actually used, but is required by the message handler's parameter
      ** list.
     D ClrPgmMsgQ      S              1A   INZ('Y')

      ** Flags to indicate whether substitution is required in
      ** each of the various parts the transaction
     D RepFRA          S              1A   INZ('N')
     D CSC022          S              1A   INZ('N')                                           CSC022
     D CNT             S              3  0                                                    CSC022
     D COMITSKIP       S              1A                                                      CSC022
     D InRCCY          S              3A                                                     CSF011A
     D InPCCY          S              3A                                                     CSF011A

                                                                                             BUG4744
      ***** Data used by IRFRAR ******                                                       BUG4744
      ** Array of Fields in error.                                                           BUG4744
     D @FldNameArr     S             10A   DIM(ArrayMax)                                     BUG4744
                                                                                             BUG4744
      ** Array of error message IDs                                                          BUG4744
     D @MsgIDArr       S                   DIM(ArrayMax)                                     BUG4744
     D                                     LIKE(#MsgID)                                      BUG4744
                                                                                             BUG4744
      ** Array of error message data.                                                        BUG4744
     D @MsgDtaArr      S                   DIM(ArrayMax)                                     BUG4744
     D                                     LIKE(#MsgData)                                    BUG4744
                                                                                             BUG4744
      ** Array of message files to check                                                     BUG4744
     D @MsgFArray      S             10A   DIM(MsgFArrMax)                                   BUG4744
                                                                                             BUG4744
     D BlankSTYP       S              2A                                                      CSD095
     D BlankBRCA       S              3A                                                      CSD095
                                                                                              CSD095
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
      ** +--- Start of main processing -----------------------------------+
      ** ¦                                                                ¦
      ** ¦ Initial processing is performed automatically: the *INZSR is   ¦
      ** ¦ executed at program activation.                                ¦
      ** ¦                                                                ¦
      ** +----------------------------------------------------------------+

      * Incoming transaction is broken into 500A fields, so that a common CL
      * can be used between this module and the one that read the MQ queue.
      * This module needs to break these 500A fields by loading them into
      * the appropriate (externally described) data structure.
     C                   MOVEL     Trans5001     TranInFra
     C                   MOVEL     InfData500    InfData                                    BUG18701
     C**********         EVAL      SUINFD=%SUBST(Buffer:263)                         BUG6377 BUG5871
     C**********         EVAL      STINFD=%SUBST(Buffer:269)                         BUG6377 BUG5871
     C*******************EVAL      SUINFD=%SUBST(Buffer:269)                          BUG5871 CDL038
     C*******************EVAL      STINFD=%SUBST(Buffer:275)                          BUG5871 CDL038
     C*******************EVAL      DDSTS=%SUBST(Buffer:300)                           BUG5871 CDL038
     C                   EVAL      SUINFD=%SUBST(Buffer:273)                                  CDL038
     C                   EVAL      STINFD=%SUBST(Buffer:279)                                  CDL038
     C                   EVAL      DDSTS=%SUBST(Buffer:285)                                   CDL038
                                                                                              CSW213
     C                   EVAL      DLRPIFScn1Fmt = DLRPIFS1In                                 CSW213
     C                   EVAL      DLRPIFScn2Fmt = DLRPIFS2In                                 CSW213
     C                   EVAL      DLRPIFScn3Fmt = DLRPIFS3In                                 CSW213
     C                   EVAL      DLRPIFScn4Fmt = DLRPIFS4In                                 CSW214

      ** Generate a timestamp for this transaction
     C                   CALLB     'ZAGENTMSTM'
     C                   PARM                    TimeStamp

      * Reset variables gradually updated
     C                   EXSR      RESETCYCLE

      * Validate action code
     C                   EXSR      ValidateAc
      *
      * If error in validation of action code, fail this input
     C                   IF        Idx <> 0
     C                   GOTO      INVALID
     C                   ENDIF
                                                                                             BUG6512
      *                                                                                      BUG6512
      * Retrieve TRAM details                                                                BUG6512
      *                                                                                      BUG6512
     C                   EXSR      ZACFFEERTV                                                BUG6512

      * Processing depends upon action code
     C                   SELECT

      * Processing for inserts
     C                   WHEN         SACCD  = 'I'
     C                   EXSR      DftSettmts
     C                   EXSR      ValidateTr
     C                   IF        Idx <> 0
     C                   GOTO      INVALID
     C                   ENDIF
     C                   EXSR      ValidateSt

      * Processing for amends or changes
     C                   WHEN         SACCD  = 'A'
     C                   EXSR      SetupAmd
     C                   EXSR      ValdateAmd
     C                   EXSR      ValidateTr
     C                   EXSR      ValidateSt
                                                                                             BUG4482
     C                   WHEN      SACCD  = 'X'                                              BUG4482
      *  Processing for Authorises                                                           BUG4482
     C                   EXSR      ValidateTr                                                BUG4482
     C                   EXSR      ValidateSt                                                BUG4482

     C                   ENDSL
      *
     C     INVALID       TAG
      *                                                                                       CSW213
     C                   IF        CSW213 = 'Y' AND                                           CSW213
     C                             UPDateYN <> 'Y'                                            CSW213
     C                   EXSR      SRRPIFVU                                                   CSW213
     C                   ENDIF                                                                CSW213

      * Write to database
     C     UpdateYN      IFEQ      'Y'
     C     Idx           ANDEQ     0
     C     Idx           IFEQ      0
     C                   EXSR      SETUPDEALN
     C                   EXSR      SETUPVALID
     C                   EXSR      UpdateDB
     C                   ENDIF
     C                   ENDIF

     C                   SETON                                        LR
      ** If action is for Update, get the correct record information                         BUG4744
      ** from file                                                                           BUG4744
     C                   IF        UpdateYN = 'Y'                                            BUG4744
     C                   MOVE      V_FRDLNO      DDDLNO_IN                                   BUG4744
     C                   CALL      'IRFRAR'                                                  BUG4744
     C                   PARM                    @AuthComp         1                         BUG4744
     C                   PARM                    @FwdBck           1                         BUG4744
     C                   PARM                    DDDLNO_IN         6                         BUG4744
     C                   PARM                    Buffer                                      BUG4744
     C                   PARM                    @FldNameArr                                 BUG4744
     C                   PARM                    @MsgIDArr                                   BUG4744
     C                   PARM                    @MsgDtaArr                                  BUG4744
     C                   PARM                    @MsgFArray                                  BUG4744
     C                   PARM                    @APIRetC          1                         BUG5230
     C                   MOVEL     SACCD         Buffer                                      BUG4744
     C                   ELSE                                                                BUG4744

      * Remerge buffer with all relevant data structures
     C****************   EVAL                    Buffer = TranInFRA + InRecSttmt             BUG4469
     C                   EVAL                    Buffer = TranInFRA                          BUG4469
     C                                           + CPST     + DSPCP                          BUG6512
     C                                           + BKST     + DSPBK                          BUG6512
     C                                           + @TimeStamp + @TNLU                        BUG4469
     C                                           + SUINFD + STINFD                           BUG6377
     C                                           + DDSTS                                     BUG5871
     C                                           + InRecSttmt                                BUG4469
     C                                           + InPaySttmt + InFRASttmt
     C                                           + InfData                                  BUG18701
     C                                           + OutSwift2013                               CSW213
     C                   ENDIF                                                               BUG4744

     C                   RETURN

      ********************************************************************
      /EJECT                                                                                  CSW213
      *****************************************************************                       CSW213
      * SRRPIFVU - Call DLRPIFVU - Reporting Information Validate     *                       CSW213
      *            and Update                                         *                       CSW213
      *****************************************************************                       CSW213
     C     SRRPIFVU      BEGSR                                                                CSW213
                                                                                              CSW213
     C                   IF        SACCD = 'R'                                                CSW213
     C                   EVAL      RLACTN = 'D'                                               CSW213
     C                   ELSE                                                                 CSW213
     C                   EVAL      RLACTN = SACCD                                             CSW213
     C                   ENDIF                                                                CSW213
                                                                                              CSW213
     C                   EVAL      RLAPID = 'FRA '                                            CSW213
     C                   EVAL      RLDTYP = SDTYP                                             CSW213
     C                   EVAL      RLDLST = SDLST                                             CSW213
      *                                                                                     MD044506
      ** Change RLVALD from Value Date to Deal Date                                         MD044506
      *                                                                                     MD044506
     C**********         EVAL      RLVALD = SVDAT                                    CSW213 MD044506
     C                   EVAL      RLVALD = SDDAT                                           MD044506
      *                                                                                     MD044506
     C                   EVAL      RLTRRF = SDLNO                                             CSW213
     C                   EVAL      RLLTRF = SLNKDN                                            CSW213
     C**********         EVAL      RLFOID  = FOTRID                                  CSW213 MD030858
     C                   EVAL      RLFOID = APFOTranID                                      MD030858
     C                   EVAL      RLBRCA  = SBRCA                                            CSW213
     C                   EVAL      RLBCCY = SUCUCY                                            CSW213
     C                   EVAL      RLSCCY = SUCUCY                                            CSW213
     C                   EVAL      RLCNUM = SCNUM                                             CSW213
                                                                                              CSW213
     C                   EVAL      ValScrnNo = 0                                              CSW213
                                                                                              CSW213
     C                   CALL      'DLRPIFVU'                                                 CSW213
     C                   PARM                    DLRILKPDIn                                   CSW213
     C                   PARM                    DLRPIFScn1Fmt                                CSW213
     C                   PARM                    DLRPIFScn2Fmt                                CSW213
     C                   PARM                    DLRPIFScn3Fmt                                CSW213
     C                   PARM                    DLRPIFScn4Fmt                                CSW214
     C                   PARM      *BLANKS       DFldNameArr                                  CSW213
     C                   PARM      *BLANKS       DMsgIDArr                                    CSW213
     C                   PARM      *BLANKS       DMsgDtaArr                                   CSW213
     C                   PARM      *ZERO         RIdx                                         CSW213
     C                   PARM      *BLANKS       DWFldNamArr                                  CSW213
     C                   PARM      *BLANKS       DWMsgIDArr                                   CSW213
     C                   PARM      *BLANKS       DWMsgDtaArr                                  CSW213
     C                   PARM      *ZERO         WRIdx                                        CSW213
     C                   PARM                    MsgFArray                                    CSW213
     C                   PARM                    DLRIS1PDOut                                  CSW213
     C                   PARM                    DLRIS2PDOut                                  CSW213
     C                   PARM                    DLRIS3PDOut                                  CSW213
     C                   PARM                    DLRIS4PDOut                                  CSW214
     C                   PARM      UpdateYN      DUpdateYN                                    CSW213
     C                   PARM                    APIRetc                                      CSW213
     C                   PARM                    ValScrnNo                                    CSW213
     C                   PARM                    DLVRPIFileFmt                                CSW213
     C                   PARM                    DLError1                                     CSW213
     C                   PARM                    DLError2                                     CSW213
     C                   PARM                    DLError3                                     CSW213
     C                   PARM                    DLError4                                     CSW214
     C                   PARM                    SUPAMT                                     MD023734
      *                                                                                       CSW213
      ** Set-up Error Messages from DLRPIFVU                                                  CSW213
      *                                                                                       CSW213
RGC  C                   EVAL      CtrX = 1                                                   CSW213
     C                   IF        RIdx <> 0                                                  CSW213
     C                                                                                        CSW213
RGC  C                   DOW       RIdx >= CtrX                                               CSW213
     C                   EVAL      Idx = Idx + 1                                              CSW213
     C                   EVAL      MsgIDArr(Idx) = DMsgIDArr(CtrX)                            CSW213
     C                   EVAL      FldNameArr(Idx) = DFldNameArr(CtrX)                        CSW213
     C                   EVAL      MsgDtaArr(Idx) = DMsgDtaArr(CtrX)                          CSW213
RGC  C                   EVAL      CtrX = CtrX + 1                                            CSW213
RGC  C                   ENDDO                                                                CSW213
RGC  C                                                                                        CSW213
     C                   ENDIF                                                                CSW213
      *                                                                                       CSW213
      ** Set-up Warning Message from DLRPIFVU                                                 CSW213
      *                                                                                       CSW213
RGC  C                   EVAL      CtrX = 1                                                   CSW213
     C                   IF        WRIdx <> 0                                                 CSW213
     C                                                                                        CSW213
RGC  C                   DOW       WRIdx >= CtrX                                              CSW213
     C                   EVAL      WIdx = WIdx + 1                                            CSW213
     C                   EVAL      WMsgIDArr(WIdx) = DWMsgIDArr(CtrX)                         CSW213
     C                   EVAL      WFldNamArr(WIdx) = DWFldNamArr(CtrX)                       CSW213
     C                   EVAL      WMsgDtaArr(WIdx) = DWMsgDtaArr(CtrX)                       CSW213
RGC  C                   EVAL      CtrX = CtrX + 1                                            CSW213
RGC  C                   ENDDO                                                                CSW213
RGC  C                                                                                        CSW213
     C                   ENDIF                                                                CSW213
     C                                                                                        CSW213
     C                   EVAL      DLRPIFS1Out = DLRIS1PDOut                                  CSW213
     C                   EVAL      DLRPIFS2Out = DLRIS2PDOut                                  CSW213
     C                   EVAL      DLRPIFS3Out = DLRIS3PDOut                                  CSW213
     C                   EVAL      DLRPIFS4Out = DLRIS4PDOut                                  CSW214
      *                                                                                       CSW213
     C                   ENDSR                                                                CSW213
      *****************************************************************                       CSW213
      /EJECT
      *****************************************************************
      *                                                               *
      * *INZSR - Program Initialisation routine                       *
      *                                                               *
      *****************************************************************
     C     *INZSR        BEGSR

     C     *ENTRY        PLIST

      * Common header information (DS) from source system
     C                   PARM                    HeadIn

      * Transaction information
     C                   PARM                    Trans5001
     C                   PARM                    InPaySttmt
     C                   PARM                    InRecSttmt
     C                   PARM                    InFRASttmt
     C                   PARM                    InfData500                                 BUG18701
     C                   PARM                    ReservID         10
     C                   PARM                    ExtData500
RGC  C                   PARM                    InSwift2013                                  CSW213
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIDArr
     C                   PARM                    MsgDtaArr
     C                   PARM                    WFldNamArr
     C                   PARM                    WMsgIDArr
     C                   PARM                    WMsgDtaArr
     C                   PARM                    MsgFArray
     C                   PARM                    UpdateYN          1
     C                   PARM                    Buffer         6000
     C                   PARM                    APIRetc           1
     C                   PARM                    @TimeStamp       26                         BUG4469
     C                   PARM                    @TNLU             5                         BUG4469

      * Set up the name of the primary and secondary message files from
      * which the message handler will get the messages
     C                   EVAL      MsgFArray(1) = 'LERMSGF'                                 BUG27851
     C**********         EVAL      MsgFArray(1) = 'DRSMM'                                   BUG27851
     C                   EVAL      MsgFArray(2) = 'DRSMM'                                   BUG27851

      *  Hook to enable non-core message files to be included
     C/COPY WNCPYSRC,IRFRAM01
      *
      * Access bank details via access program
      * (database error handling done in access program)
     C                   CALLB     'AOBANKR0'
     C                   PARM      '*DBERR '     @RTCD             7
     C                   PARM      '*FIRST '     @OPTN             7
     C     SDBANK        PARM      SDBANK        DSFDY

      * Access API ICD via access program
     C                   CALLB     'AOAPIR0'
     C                   PARM      '*DBERR '     @RTCD
     C                   PARM      '*FIRST '     @OPTN
     C     SDAPI         PARM      SDAPI         DSFDY
      *
      **  Access SAR details file to determine if Bus. Day Convention is on.
      *
     C                   CALL      'AOSARDR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*VERIFY'     @OPTN
     C                   PARM      'CIR005'      @SARD
     C     SCSARD        PARM      SCSARD        DSFDY
      *
     C     @RTCD         IFNE      *BLANKS
     C     @RTCD         ANDNE     '*NRF   '
     C     *LOCK         IN        LDA
     C                   MOVEL     'SCSARDPD'    DBFILE
     C                   Z-ADD     900           DBASE
     C                   MOVEL     'CIR005'      DBKEY
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
      *
     C     @RTCD         IFEQ      *BLANKS
     C                   MOVEL     'Y'           CIR005            1
     C                   ELSE
     C                   MOVEL     'N'           CIR005
     C                   ENDIF

      **  Access SAR details file to determine if CIR008 is installed

     C                   CALL      'AOSARDR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*VERIFY'     @OPTN
     C                   PARM      'CIR008'      @SARD
     C     SCSARD        PARM      SCSARD        DSFDY

     C                   IF        @RTCD <> *BLANKS and @RTCD <> '*NRF   '
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE = 'SCSARDPD'
     C                   EVAL      DBASE = 901
     C                   EVAL      DBKEY = 'CIR008'
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF

     C                   IF        @RTCD = *BLANKS
     C                   EVAL      CIR008 = 'Y'
     C                   ELSE
     C                   EVAL      CIR008 = 'N'
     C                   ENDIF

      **  Access SAR details file to determine if CAP056 is installed

     C                   CALL      'AOSARDR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*VERIFY'     @OPTN
     C                   PARM      'CAP056'      @SARD
     C     SCSARD        PARM      SCSARD        DSFDY

     C                   IF        @RTCD <> *BLANKS and @RTCD <> '*NRF   '
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE = 'SCSARDPD'
     C                   EVAL      DBASE = 902
     C                   EVAL      DBKEY = 'CAP056'
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF

     C                   IF        @RTCD = *BLANKS
     C                   EVAL      CAP056 = 'Y'
     C                   ELSE
     C                   EVAL      CAP056 = 'N'
     C                   ENDIF
                                                                                            MD030830
      **  Access SAR details file to determine if CAP051 is installed                       MD030830
                                                                                            MD030830
     C                   CALL      'AOSARDR0'                                               MD030830
     C                   PARM      *BLANKS       PRTCD                                      MD030830
     C                   PARM      '*VERIFY'     POPTN                                      MD030830
     C                   PARM      'CAP051'      PSARD                                      MD030830
     C     SCSARD        PARM      SCSARD        DSFDY                                      MD030830
                                                                                            MD030830
     C                   If        PRTCD <> *BLANKS AND PRTCD <> '*NRF   '                  MD030830
     C     *LOCK         IN        LDA                                                      MD030830
     C                   EVAL      DBFILE = 'SCSARDPD'                                      MD030830
     C                   EVAL      DBASE = 903                                              MD030830
     C                   EVAL      DBKEY = 'CAP051'                                         MD030830
     C                   OUT       LDA                                                      MD030830
     C                   EXSR      *PSSR                                                    MD030830
     C                   ENDIF                                                              MD030830
                                                                                            MD030830
     C                   IF        PRTCD = *BLANKS                                          MD030830
     C                   EVAL      CAP051 = 'Y'                                             MD030830
     C                   ELSE                                                               MD030830
     C                   EVAL      CAP051 = 'N'                                             MD030830
     C                   ENDIF                                                              MD030830
      *                                                                                       CSC022
      ** Access SAR details file to determine if CSC022 switchable feature                    CSC022
      *  is switched on                                                                       CSC022
     C                   CALLB     'AOSARDR0'                                                 CSC022
     C                   PARM      *BLANKS       @RtCd                                        CSC022
     C                   PARM      '*VERIFY'     @Optn                                        CSC022
     C                   PARM      'CSC022'      @SARD                                        CSC022
     C     SCSARD        PARM      SCSARD        DSFDY                                        CSC022
                                                                                              CSC022
     C                   IF        @RtCd = *Blanks                                            CSC022
                                                                                              CSC022
     C                   EVAL      CSC022 = 'Y'                                               CSC022
     C                   IN        SCCMTJOB                                                   CSC022
     C                   Z-ADD     1             CNT                                          CSC022
     C                   MOVEL     *BLANKS       COMITSKIP                                    CSC022
     C                   MOVEA     COMITARR      COMITJOB                                     CSC022
     C     COMITNUM      IFGT      0                                                          CSC022
     C     CNT           DOWLE     COMITNUM                                                   CSC022
     C     PSJOBNAME     IFEQ      COMITJOB(CNT)                                              CSC022
     C                   MOVEL     'Y'           COMITSKIP                                    CSC022
     C                   ENDIF                                                                CSC022
     C                   ADD       1             CNT                                          CSC022
     C                   ENDDO                                                                CSC022
     C                   ENDIF                                                                CSC022
                                                                                              CSC022
     C                   ELSE                                                                 CSC022
      ** Database error                                                                       CSC022
                                                                                              CSC022
     C                   IF        @RtCd <> '*NRF'                                            CSC022
     C     *LOCK         IN        LDA                                                        CSC022
     C                   EVAL      DBKEY = 'CSC022'                                           CSC022
     C                   EVAL      DBFILE = 'SCSARDPD'                                        CSC022
     C                   EVAL      DBASE = 009                                                CSC022
     C                   OUT       LDA                                                        CSC022
     C                   EXSR      *PSSR                                                      CSC022
     C                   ENDIF                                                                CSC022
                                                                                              CSC022
     C                   ENDIF                                                                CSC022
      *                                                                                       CSW213
      ** Check if SWIFT 2013  is on                                                           CSW213
      *                                                                                       CSW213
     C                   EVAL      CSW213 = *BLANKS                                           CSW213
     C                   CALL      'SWIF2013'                                                 CSW213
     C                   PARM      *BLANKS       @RTCD                                        CSW213
      *                                                                                       CSW213
     C                   IF        @RTCD = 'CSW2013'                                          CSW213
                                                                                              CSW213
     C                   EVAL      CSW213 = 'Y'                                               CSW213
     C                   ELSE                                                                 CSW213
     C                   EVAL      CSW213 = 'N'                                               CSW213
      *                                                                                       CSW213
     C                   ENDIF                                                                CSW213
      *                                                                                       CSW213

      * Key lists

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * ValidateAc - Routine to validate action code versus the       *
      *              transaction number supplied                      *
      *                                                               *
      *****************************************************************
     C     ValidateAc    BEGSR
      *
      * Validate action code versus transaction IDs supplied
      * The Transaction in file format from the database is retrieved
      * as well.
     C                   RESET                   ReturnCode

     C                   CALLB     'IRFRARTV'

      * INPUTS
      * Return code
     C                   PARM                    RetCodeIn
      * Mode = '*FRONT' (FRONT OFFICE TRANSACTION INTERFACE)
      * Mode = '      ' (NOT FRONT OFFICE TRANSACTION INTERFACE)
     C                   PARM                    ModeofOp          6
      * Response mode
     C                   PARM      'S'           RespMode          1
      * Action Code
     C                   PARM                    SACCD             1
      * Front Office Transaction ID
     C                   PARM                    FOTRID           20
      * Front Office Associated Transaction Id
     C                   PARM                    FOASID           20
      * (Midas) Deal Number
     C                   PARM                    SDLNO             6
      * (Midas) Associated Deal Number
     C                   PARM                    SLNKDN            6
      * Booking branch
     C                   PARM                    SBRCA             3
      *  Switchable feature CIR008
     C                   PARM                    CIR008

      * OUTPUTS
      * (Current) deal in file format
     C                   PARM                    FRAFilFmt
      * OK - Action code
     C                   PARM                    OKACTN            1
      * OK - Deal Number
     C                   PARM                    OKDLNO            1
      * OK - Booking branch
     C                   PARM                    OKBRCA            1
      * Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIdArr
     C                   PARM                    MsgDtaArr
      * Array index (3P0) from/to caller
     C                   PARM                    Idx               3 0
      * Insert correct parameters for this RTV function

     C                   ENDSR

      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * Dftsettmts - Routine to apply default settlement instructions *
      *    if none have been supplied                                 *
      *                                                               *
      *****************************************************************

     C     DftSettmts    BEGSR

      * If ANY of the Settlements fields have been entered, bypass this
      *  routine.
      * Otherwise, use modules which will use Standard Settlement
      *  Instructions to apply defaults.

     C                   IF            (InRecSttmt = *blank)
     C                             AND (InPaySttmt = *blank)

     C                   CALLB     'ZASETINDFT'

      ** Output
      ** Calling function type
     C                   PARM                    FRA               4
      * Payment currency
     C                   PARM                    SuCucy            3
      * Receive currency
     C                   PARM                    Blank3            3
      ** Customer (shortname or number)
     C                   PARM                    SCNum            10
      * Transaction Type
     C                   PARM                    SDTyp             2
      ** Federal Funds Ind.
     C                   PARM      *BLANK        SuFFI             1
      ** ISDA Rules for FRA/IRS deals only
      ** Version of ISDA Rules govern
     C                   PARM                    BQISDA            4
      ** Type of ISDA agreement
     C                   PARM                    BQAGTY            6
      ** Date of ISDA Agreement
     C                   PARM                    BQAGDT            6
      ** Version of ISDA Agreement
     C                   PARM                    BQAGVV            2
      ** Version of ISDA Agreement century
     C                   PARM                    BQAGVC            2
                                                                                              CSD095
      ** Deal Subtype                                                                         CSD095
     C******             PARM      *BLANK        BlankSTYP                          CSD095 CSD095CC1
     C                   PARM      SDLST         BlankSTYP                                 CSD095CC1
                                                                                              CSD095
      ** Branch                                                                               CSD095
     C******             PARM      *BLANK        BlankBRCA                          CSD095 CSD095CC1
     C                   PARM      SBRCA         BlankBRCA                                 CSD095CC1
      *
      ** Return
      ** Defaulted Payment Settlement Instruction in file format
     C                   PARM                    DBPaySttmt
      ** Defaulted Receipt Settlement Instruction in file format
     C                   PARM                    DBRecSttmt
      ** Defaulted FRA/IRS Settlement Instruction in file format
     C                   PARM                    DBFRASttmt

     C                   IF        DBFRASttmt = *BLANKS                                     MD033870
     C                             and InFRASttmt <> *BLANKS                                MD033870
     C                   EVAL      DBFRASttmt = InFRASttmt                                  MD033870
     C                   MOVEL     DDAGVV        FLAGVC                                     MD040199
     C                   MOVE      DDAGVV        FLAGVV                                     MD040199
     C                   ENDIF                                                              MD033870
      *  The defaulted instructions are in file format, but the
      *   Settlements validation requires that they are in the input format.
      *  Therefore run them through a conversion module.

     C                   CALLB     'ZASETINCVT'
      ** Defaulted Settlement Instructions in file format
     C                   PARM                    DBPaySttmt
     C                   PARM                    DBRecSttmt
     C**********         PARM      *BLANK        DBFRASttmt                                  BUG5674
     C                   PARM                    DBFRASttmt                                  BUG5674

      ** Defaulted Settlement Instruction in input format
     C**********         PARM                    InPaySttmt                                  BUG5674
     C**********         PARM                    InRecSttmt                                  BUG5674
     C**********         PARM                    InFRASttmt                                  BUG5674
     C                   PARM      *BLANKS       InPaySttmt                                  BUG5674
     C                   PARM      *BLANKS       InRecSttmt                                  BUG5674
     C                   PARM      *BLANKS       InFRASttmt                                  BUG5674
     C                   PARM      SUCUCY        InRCCY                                      CSF011A
     C                   PARM      SUCUCY        InPCCY                                      CSF011A
                                                                                              244254
      ** else, if pay/rec details are manually entered on the screen,                         244254
      ** try to retrieve and default the ISDA details.                                        244254
     C                   ELSE                                                                 244254
     C                   EXSR      DefISDA                                                    244254

     C                   ENDIF

     C                   ENDSR
      /EJECT
      *****************************************************************
      *                                                               *
      * SETUPAMD - Set up fields that are needed in the validation    *
      *            of amendments.                                     *
      *                                                               *
      *****************************************************************
     C     SetupAmd      BEGSR

      * For amends, put the complete (pre-existing) transaction into the valid
      * file record - fields in this will be updated during processing

     C                   Eval      FRADet1    =  DGDet1
     C                   Eval      FRARecIns  =  DGRecIns
     C                   Eval      FRAPayIns  =  DGPayIns
     C                   Eval      FRAFraIns  =  DGFraIns
     C                   Eval      V_FRRONS = RONS                                          BUG25485
     C                   Eval      V_FRPONS = PONS                                          BUG25485
     C     CIR005        IFEQ      'Y'
     C                   MOVEL     DGFRFCy       FRARFCy
     C                   ENDIF

     C**********         EVAL      DBRecSttmt = FRARecIns + V_FRROBR                          TDA011
     C                   EVAL      %SUBST(DBRecSttmt:1:2)                                     TDA011
     C                                        = %SUBST(FRARecIns:1:2)                         TDA011
     C                   EVAL      FLRONS     = V_FRRONS                                      TDA011
     C                   EVAL      %SUBST(DBRecSttmt:21:55)                                   TDA011
     C                                        = %SUBST(FRARecIns:15:55)                       TDA011
     C                   EVAL      FLROBR     = V_FRROBR                                      TDA011
     C                   EVAL      FLRSCY     = V_FRRSCY
     C**********         EVAL      DBPaySttmt = FRAPayIns + V_FRPOBR +                        TDA011
     C**********                                V_FRCVMR                                      TDA011
     C                   EVAL      %SUBST(DBPaySttmt:1:2)                                     TDA011
     C                                        = %SUBST(FRAPayIns:1:2)                         TDA011
     C                   EVAL      FLPONS     = V_FRPONS                                      TDA011
     C                   EVAL      %SUBST(DBPaySttmt:21:545)                                  TDA011
     C                                        = %SUBST(FRAPayIns:15:545)                      TDA011
     C                   EVAL      FLPOBR     = V_FRPOBR                                      TDA011
     C                   EVAL      FLCVMR     = V_FRCVMR                                      TDA011
     C                   EVAL      FLPSCY     = V_FRPSCY
     C                   EVAL      FLIC72     = V_FRIC72
     C                   EVAL      DBFraSttmt = FRAFraIns
     C                   MOVE      V_FRAGVC      FLAGVC

      *  .... and then convert these to the screen format
     C                   CALLB     'ZASETINCVT'

      ** Defaulted Settlement Instructions in file format
     C                   PARM                    DBPaySttmt
     C                   PARM                    DBRecSttmt
     C                   PARM                    DBFRASttmt

      ** Current Settlement Instruction in input format
     C                   PARM                    CrPaySttmt
     C                   PARM                    CrRecSttmt
     C                   PARM                    CrFRASttmt
     C                   PARM      SUCUCY        InRCCY                                      CSF011A
     C                   PARM      SUCUCY        InPCCY                                      CSF011A

      *  If no Payment or Receive instructions have been supplied
      *  Default them to those currently on the deal.

     C                   IF            (InPaySttmt = *blank)
     C                   EVAL      InPaySttmt = CrPaySttmt
     C                   ENDIF

     C                   IF            (InRecSttmt = *blank)
     C                   EVAL      InRecSttmt = CrRecSttmt
     C                   ENDIF

     C                   IF            (InFRASttmt = *blank)
     C                   EVAL      InFRASttmt = CrFRASttmt
     C                   ENDIF

      * Do data substitution for Settlement Instructions

     C     GHSUBS        IFNE      *blank
     C     GHSUBS        SCAN      InPaySttmt                             99
     C  N99GHSUBS        SCAN      InRecSttmt                             99
     C  N99GHSUBS        SCAN      InFRASttmt                             99
     C     *IN99         IFEQ      *ON
     C                   EXSR      SDtDtaSubs
     C                   ENDIF
     C                   ENDIF

     C                   ENDSR
      *****************************************************************
      /EJECT
      ******************************************************************
      *                                                                *
      * ValidateTr - Routine to validate the main transaction details  *
      *                                                                *
      ******************************************************************
     C     ValidateTr    BEGSR

      * Validate transaction details
     C                   RESET                   ReturnCode

     C                   CALLB     'IRFRAVAL'

      * Response mode (1A), from source system common header
     C                   PARM      'S'           RespMode
      * Transaction information (DS) from source system
     C                   PARM                    TranInFRA
      * Receive Settlement Ccy, Method & Nostro and  Pay Settlement Ccy,
      * Method & Nostro, from default or valid deal
     C                   PARM                    RecSetCcy
     C                   PARM                    RecSetMeth
     C                   PARM                    RecNostro
     C                   PARM                    PaySetCcy
     C                   PARM                    PaySetMeth
     C                   PARM                    PayNostro
     C                   PARM                    ExtData
      * Field OK flags (DS) from/to caller
     C                   PARM                    OKFlagsDS
      * Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIDArr
     C                   PARM                    MsgDtaArr
      * Array index (3P0) from/to caller
     C                   PARM                    Idx
      * Warning fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    WFldNamArr
     C                   PARM                    WMsgIDArr
     C                   PARM                    WMsgDtaArr
      * Array index (3P0) from/to caller
     C                   PARM                    WIdx
      * Valid Deals layout (DS) from/to caller
     C                   PARM                    ValidFRA
      * Insert correct parameters for this VAL function
      *
      *  If error in validation, fail this input
     C     Idx           IFNE      0
     C                   GOTO      EValidTr
     C                   EndIf

     C     EValidTr      ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * ValidateSt - Routine to validate the settlement instructions  *
      *                                                               *
      *****************************************************************

     C     ValidateSt    BEGSR

      * The called module requires that the customer number/name is valid,
      *  if it is not, exit from this subroutine.
     C                   IF        NOT (SCNumOK = 'Y')
     C                   GOTO      ValSetExit
     C                   ENDIF

      *
      * Set pay and receive dates to run date
     C                   EVAL      PayDat = BJRDNB
     C                   EVAL      RecDat = BJRDNB

     C                   RESET                   ReturnCode
     C                   CALLB     'ZASETINVAL'

      ** Return Code
     C                   PARM                    ReturnCode
      ** Following parameters are output to called module
      ** Calling function type
     C                   PARM                    FRA
      ** Transaction Fields
      ** Payment currency (or deal currency if only one currency on deal)
     C                   PARM                    SUCUCY
      ** Receive currency (or deal currency if only one currency on deal)
     C                   PARM                    SUCUCY
      ** Customer (shortname or number)
     C                   PARM                    SCNUM
      ** Deal type
     C                   PARM                    SDTYP
      ** Federal Funds Ind.
     C                   PARM                    SUFFI
      ** Booking Branch
     C                   PARM                    SBRCA
      ** Receipt Date (Value Date for FRAs)
     C                   PARM                    RecDat
      ** Payment Date (Value Date for FRAs)
     C                   PARM                    Paydat
      ** Input (or Defaulted) Receipt/Payment/FRA/IRS Settlement Instruction
     C                   PARM                    InPaySttmt
     C                   PARM                    InRecSttmt
     C                   PARM                    InFRASttmt

     C                   PARM                    SACCD
      * Protect Payment Field
     C                   PARM                    ##PPAY            1
      * Protect Receipt Field
     C                   PARM                    ##PREC            1


      ** Following parameters are returned by called module
      ** Payment Instruction OK flag
     C                   PARM                    OKPayInsDS
      ** Receive Instruction OK flag
     C                   PARM                    OKRecInsDS
      ** FRA/IRS Instruction OK flag
     C                   PARM                    OKFRAInsDS
      * Error fields/message IDs (arrays) from/to caller
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIDArr
      * Array index (3P0) from/to caller
     C                   PARM                    Idx
      ** Warning fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    WFldNamArr
     C                   PARM                    WMsgIDArr
     C                   PARM                    WMsgDtaArr
      ** Array index (3P0) from/to caller
     C                   PARM                    WIdx
      ** File (D/B) Receipt/Payment/FRA/IRS Settlement Instruction
     C                   PARM                    DBPaySttmt
     C                   PARM                    DBRecSttmt
     C                   PARM                    DBFRASttmt
      ** Extra Input
      ** Action Code used
     C                   PARM      SACCD         ##ACTN            1
      ** Validation Iteration
     C                   PARM      '1ST'         ##ValIter         3

     C     ValSetExit    TAG

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * TDtDtaSubs - Transaction Details Data Substitution            *
      *                                                               *
      *****************************************************************

     C     TDtDtaSubs    BEGSR

      ** CONVERSION OF FILE FIELDS TO SCREEN FORMAT

     C                   RESET                   ReturnCode
     C                   CALLB     'IRFRACVT'

      * INPUTS
      * Return Code
     C                   PARM                    ReturnCode
      * (Current) Deal in file format
     C                   PARM                    FRAFilFmt
      ** FRA/IRS Deals Authorisation
     C                   PARM                    CIR008

      * OUTPUTS
      * (Current) Deal in screen format
     C                   PARM                    TranInFra
      * Deal Status
     C                   PARM                    DDSTS

      ** DATA SUBSTITUTION

     C                   RESET                   ReturnCode
     C                   CALLB     'APDTASUBS'

      * Return Code
     C                   PARM                    ReturnCode       10
      * Substitution character
     C                   PARM      GHSUBS        SubsChar          1
      * Incoming Data
     C                   PARM      TranInFRA     IncDATA        2000
      * Current Data
     C                   PARM      TranInFRA     CurDATA        2000

     C                   MOVEL     IncDATA       TranInFRA

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SDtDtaSubs - Settlement Details Data Substitution             *
      *                                                               *
      *****************************************************************

     C     SDtDtaSubs    BEGSR

      ** PAYMENT INSTRUCTIONS
     C                   RESET                   ReturnCode
     C                   CALLB     'APDTASUBS'

      * Return Code
     C                   PARM                    ReturnCode
      * Substitution character
     C                   PARM      GHSUBS        SubsChar
      * Incoming Data
     C                   PARM      InPaySttmt    IncDATA
      * Current Data
     C                   PARM      CrPaySttmt    CurDATA

     C                   MOVEL     IncDATA       InPaySttmt

      ** RECEIPT INSTRUCTIONS
     C                   RESET                   ReturnCode
     C                   CALLB     'APDTASUBS'

      * Return Code
     C                   PARM                    ReturnCode
      * Substitution character
     C                   PARM      GHSUBS        SubsChar
      * Incoming Data
     C                   PARM      InRecSttmt    IncDATA
      * Current Data
     C                   PARM      CrRecSttmt    CurDATA

     C                   MOVEL     IncDATA       InRecSttmt

      ** FRA/IRS INSTRUCTIONS
     C                   RESET                   ReturnCode
     C                   CALLB     'APDTASUBS'

      * Return Code
     C                   PARM                    ReturnCode
      * Substitution character
     C                   PARM      GHSUBS        SubsChar
      * Incoming Data
     C                   PARM      InFRASttmt    IncDATA
      * Current Data
     C                   PARM      CrFRASttmt    CurDATA

     C                   MOVEL     IncDATA       InFRASttmt

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * ValdateAmd - Routine to check whether the fields amended      *
      *              are amendable.                                   *
      *                                                               *
      *****************************************************************

     C     ValdateAmd    BEGSR

      * This subroutine calls a procedure which checks whether it
      * was valid to amend any of the fields which have been
      * changed.  Some are never amendable and some depend upon ICD
      * settings as to whether they are amendable.

      * To determine what fields have changed, the current fields
      * on file must be converted to a 'screen' format.

      * These fields are then compared with the fields on the input
      * transaction.

      * Any errors detected by the called procedure take precedence
      * over any errors found during the validation of the complete
      * transaction.  The errors from the called procedure are kept
      * separately and, if any are found, these errors will REPLACE
      * the normal validation errors.

      * Convert file format to screen format

     C                   RESET                   ReturnCode
     C                   CALLB     'IRFRACVT'

      * INPUTS
      * Return Code
     C                   PARM                    ReturnCode
      * (Current) Deal in file format
     C                   PARM                    FRAFilFmt

      ** Switchable feature CIR008
     C                   PARM                    CIR008
      * OUTPUTS
      * (Current) Deal in screen format
     C                   PARM                    CurTrFra
      * Deal Status
     C                   PARM                    DDSTS            24

      ** AMEND CHECKING
     C                   RESET                   ReturnCode
     C                   CALLB     'IRFRAAMD'

      * INPUTS
      * Return Code
     C                   PARM                    ReturnCode
      * New Deal in Screen Format (Incoming Transaction)
     C                   PARM                    TranInFRA
      * (Current) Deal in Screen Format
     C                   PARM                    CurTrFRA
      * (Current) Deal in file format
     C                   PARM                    FRAFilFmt

      * OUTPUTS
      * Field OK flags (DS) from/to caller
     C                   PARM                    OKFlagsDS
      * Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    AmFldNamAr
     C                   PARM                    AmMsgIdArr
     C                   PARM                    AmMsgDtaAr
      * Array index (3P0) from/to caller
     C                   PARM                    AmIdx
      * Amendments OK
     C                   PARM                    AmendOk           1
      * Reset of Fields in Error Required (Y/N)
     C*******************PARM      'N'           ResetErrs         1                          CDL038
     C                   PARM      'Y'           ResetErrs         1                          CDL038


      * If any errors overwrite previous error information
     C                   IF        AmIdx <> 0
     C                   MOVEA     AmMsgIdArr    MsgidArr
     C                   MOVEA     AmFldNamAr    FldNameArr
     C                   MOVEA     AmMsgDtaAr    MsgDtaArr
     C                   Z-ADD     AmIdx         Idx
     C                   ENDIF

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * RESETCYCLE- Reset error information that is gradually         *
      *             updated during each run of this program           *
      *                                                               *
      *****************************************************************
     C     RESETCYCLE    BEGSR

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

     C                   CLEAR                   CurTrFRA

     C                   MOVE      *ALL'Y'       OKTrFRA

     C                   CLEAR                   ValidFRA
      ** Have to clear the packed numeric fields separately.
     C                   CLEAR                   V_FRDDAT
     C                   CLEAR                   V_FRVDAT
     C                   CLEAR                   V_FRMDAT
     C                   CLEAR                   V_FRBAGE
     C                   CLEAR                   V_FRUPAMT
     C                   CLEAR                   V_FRUSTRT
     C                   CLEAR                   V_FRUBRTE
     C                   CLEAR                   V_FRURTSP
     C                   CLEAR                   V_FRUEINR
     C                   CLEAR                   V_FRUINFD
     C                   CLEAR                   V_FRUSLIP
     C                   CLEAR                   V_FRUNICD
     C                   CLEAR                   V_FRUICBD
     C                   CLEAR                   V_FRUNIPD
     C                   CLEAR                   V_FRUIPBD
     C                   CLEAR                   V_FRUBCXR
     C                   CLEAR                   V_FRUIACD
     C                   CLEAR                   V_FRUIALC
     C                   CLEAR                   V_FRUAITC
     C                   CLEAR                   V_FRUAIPD
     C                   CLEAR                   V_FRUAIAN
     C                   CLEAR                   V_FRUAIAP
     C                   CLEAR                   V_FRUIPRD
     C                   CLEAR                   V_FRUIPRM
     C                   CLEAR                   V_FRUNSAM
     C                   CLEAR                   V_FRUTAXD
     C                   CLEAR                   V_FRUTAXM
     C                   CLEAR                   V_FRTPAMT
     C                   CLEAR                   V_FRTSTRT
     C                   CLEAR                   V_FRTBRTE
     C                   CLEAR                   V_FRTRTSP
     C                   CLEAR                   V_FRTEINR
     C                   CLEAR                   V_FRTINFD
     C                   CLEAR                   V_FRTSLIP
     C                   CLEAR                   V_FRTNICD
     C                   CLEAR                   V_FRTICBD
     C                   CLEAR                   V_FRTNIPD
     C                   CLEAR                   V_FRTIPBD
     C                   CLEAR                   V_FRTBCXR
     C                   CLEAR                   V_FRTIACD
     C                   CLEAR                   V_FRTIALC
     C                   CLEAR                   V_FRTAITC
     C                   CLEAR                   V_FRTAIPD
     C                   CLEAR                   V_FRTAIAN
     C                   CLEAR                   V_FRTAIAP
     C                   CLEAR                   V_FRTIPRD
     C                   CLEAR                   V_FRTIPRM
     C                   CLEAR                   V_FRTNSAM
     C                   CLEAR                   V_FRTTAXD
     C                   CLEAR                   V_FRTTAXM
     C                   CLEAR                   V_FRCLRAT
     C                   CLEAR                   V_FRFLRAT
     C                   CLEAR                   V_FRAVPER
     C                   CLEAR                   V_FRTIRAT
     C                   CLEAR                   V_FRAACRT
     C                   CLEAR                   V_FRSDCAR
     C                   CLEAR                   V_FRULPCD
     C                   CLEAR                   V_FRTLPCD
     C                   CLEAR                   V_FRUAEXA
     C                   CLEAR                   V_FRTAEXA
     C                   CLEAR                   V_FRUNRL
     C                   CLEAR                   V_FRUNRLP
     C                   CLEAR                   V_FRLSWC
     C                   CLEAR                   V_FRLSWS
     C                   CLEAR                   V_FRORED
     C                   CLEAR                   V_FRLCD
     C                   CLEAR                   V_FRTNLU
     C                   CLEAR                   V_FRUNPCD
     C                   CLEAR                   V_FRTNPCD
     C                   CLEAR                   V_FRUPVD
     C                   CLEAR                   V_FRUPFE
     C                   CLEAR                   V_FRUPAD
     C                   CLEAR                   V_FRBODD
     C                   CLEAR                   V_FRBOVD
     C                   CLEAR                   V_FRBOAM
     C                   CLEAR                   V_FROUSI
     C                   CLEAR                   V_FROUSA
     C                   CLEAR                   V_FRTUSI
     C                   CLEAR                   V_FRTUSA
     C                   CLEAR                   V_FRUOBRT
     C                   CLEAR                   V_FRTOBRT
     C                   CLEAR                   V_FRUOPAM
     C                   CLEAR                   V_FRTOPAM
      ** Have to clear the settlement data structure, or the packed numeric
      ** fields are not initialised correctly.
     C                   CLEAR                   DBPaySttmt
     C                   CLEAR                   DBRecSttmt
     C                   CLEAR                   DBFRASttmt


     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SETUPDEALN - Set up Deal Number for Inserts                   *
      *                                                               *
      *****************************************************************

     C     SETUPDEALN    BEGSR

     C     SDLNO         IFEQ      *BLANKS
     C     SDLNO         OREQ      *ZEROS

     C                   RESET                   ReturnCode
     C                   CALLB     'CAGETNXTDL'
     C                   PARM                    ReturnCode
     C                   PARM                    MSG1
     C                   PARM                    SDLNO
     C                   PARM      *ZEROS        V_FRDLNO

     C     MSG1          IFNE      *BLANK
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'SDLNO'
     C                   EVAL      MsgIDArr(Idx) = MSG1
     C                   ENDIF

      ** Use the return code's value to set the field's OK flag
     C                   CALLB     'ZASETOKFLG'
     C                   PARM                    SDlnoOK
     C                   PARM                    ReturnCode
     C                   PARM                    WarnGlobal

     C                   ELSE
     C                   MOVE      SDLNO         V_FRDLNO

     C                   ENDIF

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SETUPVALID - Set up additional fields that are needed on the  *
      *              valid file record.                               *
      *                                                               *
      *****************************************************************

     C     SETUPVALID    BEGSR

      * For Inserts and Amends, put the Settlement Instructions (input or
      *  defaulted) into the Valid file record.
      * Two DSs (one Pay, one Receive) contain the Settlement Instructions
      *  in contiguous areas, which must be placed into the correct parts
      *  of the Valid file record

     C                   IF        SACCD = 'I'
     C                             OR (SACCD = 'A')
     C**********         MOVEL     DBPaySttmt    FRAPayIns                                    TDA011
     C**********         MOVEL     DBRecSttmt    FRARecIns                                    TDA011
     C                   EVAL      %SUBST(FRAPayIns:1:2)                                      TDA011
     C                                        = %SUBST(DBPaySttmt:1:2)                        TDA011
     C                   EVAL      V_FRPONS  = FLPONS                                         TDA011
     C                   EVAL      %SUBST(FRAPayIns:15:545)                                   TDA011
     C                                        = %SUBST(DBPaySttmt:21:545)                     TDA011
      *                                                                                       TDA011
     C                   EVAL      %SUBST(FRARecIns:1:2)                                      TDA011
     C                                        = %SUBST(DBRecSttmt:1:2)                        TDA011
     C                   EVAL      V_FRRONS  = FLRONS                                         TDA011
     C                   EVAL      %SUBST(FRARecIns:15:55)                                    TDA011
     C                                        = %SUBST(DBRecSttmt:21:55)                      TDA011
      *                                                                                       TDA011
     C                   MOVE      FLPOBR        V_FRPOBR
     C                   MOVE      FLROBR        V_FRROBR
     C                   MOVE      FLCVMR        V_FRCVMR
     C                   MOVE      FLPSCY        V_FRPSCY
     C                   MOVE      FLRSCY        V_FRRSCY
     C                   MOVE      FLIC72        V_FRIC72
     C                   MOVEL     DBFraSttmt    FRAFraIns
     C                   MOVE      FLAGVC        V_FRAGVC                                    BUG2959

      ** Ensure numeric fields are zero if not entered.
     C     FLISDA        IFEQ      *BLANKS
     C                   Z-ADD     *ZEROS        V_FRISDA
     C                   END

     C     FLAGDT        IFEQ      *BLANKS
     C                   Z-ADD     *ZEROS        V_FRAGDT
     C                   END

     C     FLAGVV        IFEQ      *BLANKS
     C                   Z-ADD     *ZEROS        V_FRAGVV
     C                   END

     C     FLAGVC        IFEQ      *BLANKS
     C                   Z-ADD     *ZEROS        V_FRAGVC
     C                   END
     C                   ENDIF


      ** For Deletes & Authorises, put the complete (pre-existing) deal
      ** into the Valid file record

     C                   IF           SACCD = 'R'
     C                             OR CIR008 = 'Y' AND SACCD = 'X'
     C                   MOVEL     FRAFilFMT     ValidFRA
     C     CIR005        IFEQ      'Y'
     C                   MOVEL     DGFRFCy       FRARFCy
     C                   ENDIF
     C                   ENDIF

      * Set Valid file field(s) that are needed for all Action Codes
     C                   EVAL      V_FRCHTP = SACCD

      * Include Header fields that need to be o/p to the Valid file
     C                   EVAL      V_FRFRNT = APFOTranID
     C                   EVAL      V_FRREPA = APRprLocn
     C                   EVAL      V_FRTMESTMP = TimeStamp

      ** Setup the Valid file with 'Automatic Authorisation' from
      ** Interface file IRFRIFPD

     C                   IF        CAP056 = 'Y'
     C                             OR CAP051 = 'Y' AND AUTH = 'Y'                           MD030830
     C                   EVAL      V_FRAUTH = AUTH
     C                   ENDIF
                                                                                             BUG4469
      * Restore Timestamp from the original record                                           BUG4469
     C                   IF        SACCD <> 'I'                                              BUG4469
     C                             and @TimeStamp <> *BLANK                                  BUG4469
     C                             and @TNLU <> *BLANK                                       BUG4469
     C                   MOVEL     @TimeStamp    V_FRTMESTMP                                 BUG4469
     C                   MOVE      @TNLU         WnTNLU            5 0                       BUG4469
     C                   EVAL      V_FRTNLU = WnTNLU                                         BUG4469
     C                   ENDIF                                                               BUG4469

      /COPY WNCPYSRC,IRFRACT018

     C                   ENDSR

      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * UPDATEDB - Update database                                    *
      *                                                               *
      *****************************************************************

     C     UPDATEDB      BEGSR
      *
      * Update
     C                   RESET                   @@RTCD

     C                   CALLB     'IRFRAUPD'
     C                   PARM                    @@RTCD            7
     C                   PARM                    ModeofOp
     C                   PARM                    ValidFRA
     C                   PARM                    CIR008
     C                   PARM                    CAP056

      *                                                                                       CSW213
      ** Call DLRPIFVU - Midas DL Reporting Information Validate and Update                   CSW213
      *                                                                                       CSW213
     C                   IF        CSW213 = 'Y'                                               CSW213
     C                   EXSR      SRRPIFVU                                                   CSW213
     C                   ENDIF                                                                CSW213
      *
      * If there were any errors in the update functions, rollback any
      * updates (done in *PSSR) and end this program. Otherwise commit.
     C     @@RTCD        IFNE      *BLANK
     C     @@RTCD        ANDNE     '*RECUPD'
     C                   MOVEL     '0'           APIRetc
     C                   EXSR      *PSSR
     C                   ELSE
     C     CSC022        IFEQ      'N'                                                        CSC022
     C                   COMMIT
     C                   ELSE                                                                 CSC022
     C     COMITSKIP     IFNE      'Y'                                                        CSC022
     C                   COMMIT                                                               CSC022
     C                   ENDIF                                                                CSC022
     C                   ENDIF                                                                CSC022
     C                   EndIf
      *
      * If update not done due to record being updated by another
      * workstation send message to screen.

     C     @@RTCD        IFEQ      '*RECUPD'
     C                   MOVEL     '*ANY'        FldNameArr(1)

     C                   MOVEL     'LEP0026'     MsgIdArr(1)

     C                   EndIf

     C                   ENDSR
      **********************************************************************                 BUG6512
     C     ZACFFEERTV    BEGSR                                                               BUG6512
                                                                                             BUG6512
     C                   CALLB     'ZACFFEERTV'                                              BUG6512
      *                                                                                      BUG6512
      * INPUTS                                                                               BUG6512
      *                                                                                      BUG6512
      * Return code                                                                          BUG6512
     C                   PARM      *BLANK        RetCodeIn        10                         BUG6512
      *                                                                                      BUG6512
      * Action Code                                                                          BUG6512
     C                   PARM                    SACCD             1                         BUG6512
      *                                                                                      BUG6512
      * (Midas) Deal Number                                                                  BUG6512
     C                   PARM                    SDLNO             6                         BUG6512
      *                                                                                      BUG6512
      * Broker                                                                               BUG6512
     C                   PARM                    SBRKC             4                         BUG6512
      *                                                                                      BUG6512
      * OUTPUTS                                                                              BUG6512
      *                                                                                      BUG6512
      * OK - Action code                                                                     BUG6512
     C                   PARM      'Y'           DDActnOK          1                         BUG6512
      *                                                                                      BUG6512
      * Counterparty Status                                                                  BUG6512
     C                   PARM                    CPST              2                         BUG6512
     C                   PARM                    DSPCP             1                         BUG6512
      *                                                                                      BUG6512
      * Broker Status                                                                        BUG6512
     C                   PARM                    BKST              2                         BUG6512
     C                   PARM                    DSPBK             1                         BUG6512
      *                                                                                      BUG6512
      * Error fields/message IDs/message data (arrays) from/to caller                        BUG6512
     C                   PARM                    FldNameArr                                  BUG6512
     C                   PARM                    MsgIdArr                                    BUG6512
     C                   PARM                    MsgDtaArr                                   BUG6512
      *                                                                                      BUG6512
      * Array index (3P0) from/to caller                                                     BUG6512
     C                   PARM                    Idx                                         BUG6512
                                                                                             BUG6512
      ** Warning error fields/message IDs/message data (arrays) from/to caller               BUG6512
                                                                                             BUG6512
     C                   PARM      *BLANKS       WFldNamArr                                  BUG6512
     C                   PARM      *BLANKS       WMsgIdArr                                   BUG6512
     C                   PARM      *BLANKS       WMsgDtaArr                                  BUG6512
                                                                                             BUG6512
      ** Warning array index (3P0) from/to caller                                            BUG6512
                                                                                             BUG6512
     C                   PARM      *ZEROS        WIdx                                        BUG6512
                                                                                             BUG6512
     C                   ENDSR                                                               BUG6512
      **********************************************************************                 BUG6512
      /EJECT                                                                                  244254
      *****************************************************************                       244254
      * DefISDA - Retrieve and default ISDA details for the customer  *                       244254
      *****************************************************************                       244254
     C     DefISDA       BEGSR                                                                244254
                                                                                              244254
      ** To allow user override - only default FRA/IRS details                                244254
      ***if*DDISDA*is*blank*and*not*already*entered*by*the*user.                     244254 MD029165
      ** if all of the fields in Settlement Confirmation is blank                           MD029165
      ** and not already entered by the user                                                MD029165
      *                                                                                     MD029165
     C**********         IF        DDISDA = *BLANK                                   244254 MD029165
     C                   IF        InFRASttmt = *BLANK                                      MD029165
                                                                                              244254
      ** Set up key for chain to default settlements file                                     244254
     C     KeySett       KLIST                                                                244254
     C                   KFLD                    KYCYCD            3                          244254
     C                   KFLD                    KYCUST            6                          244254
     C                   KFLD                    KYTRTY            2                          244254
                                                                                              244254
     C                   MOVEL     SUCUCY        KYCYCD                                       244254
     C                   MOVEL     SCNUM         KYCUST                                       244254
     C                   MOVEL     SDTYP         KYTRTY                                       244254
                                                                                              244254
      ** Chain to default extended settlements file                                           244254
                                                                                              244254
     C     KeySett       CHAIN     SDEXSTL1                           90                      244254
                                                                                              244254
     C                   IF        *IN90 = *OFF                                               244254
      ** ISDA details                                                                         244254
     C                   EVAL      DDISDA = BYISDA                                            244254
     C                   EVAL      DDAGTY = BYAGTY                                            244254
     C                   EVAL      DDAGDT = BYAGDT                                            244254
     C                   EVAL      WDAGVC = BYAGVC                                            244254
     C                   EVAL      WDAGVV = BYAGVV                                            244254
     C                   EVAL      DDAGVV = WWAGVV                                            244254
      ** Definition Confirmation Sender to Receiver Info                                      244254
     C                   EVAL      DDDSR1 = BYDSR1                                            244254
     C                   EVAL      DDDSR2 = BYDSR2                                            244254
     C                   EVAL      DDDSR3 = BYDSR3                                            244254
     C                   EVAL      DDDSR4 = BYDSR4                                            244254
     C                   EVAL      DDDSR5 = BYDSR5                                            244254
     C                   EVAL      DDDSR6 = BYDSR6                                            244254
      ** Settlement / reset Confirmation                                                      244254
     C                   EVAL      DDSSR1 = BYSSR1                                            244254
     C                   EVAL      DDSSR2 = BYSSR2                                            244254
     C                   EVAL      DDSSR3 = BYSSR3                                            244254
     C                   EVAL      DDSSR4 = BYSSR4                                            244254
     C                   EVAL      DDSSR5 = BYSSR5                                            244254
     C                   EVAL      DDSSR6 = BYSSR6                                            244254
      ** Settlement / reset Confirmation                                                      244254
     C                   EVAL      DDCND1 = BYCND1                                            244254
     C                   EVAL      DDCND2 = BYCND2                                            244254
     C                   EVAL      DDCND3 = BYCND3                                            244254
     C                   EVAL      DDCND4 = BYCND4                                            244254
     C                   EVAL      DDCND5 = BYCND5                                            244254
     C                   EVAL      DDCND6 = BYCND6                                            244254
     C                   ENDIF                                                                244254
                                                                                              244254
     C                   ENDIF                                                                244254
                                                                                              244254
     C                   ENDSR                                                                244254
      *****************************************************************                       244254
      *****************************************************************
      /EJECT
      *****************************************************************
      * The following /COPY contains the standard program status
      * subroutine, including a bound call to the DBERRCTL module.
      *****************************************************************
     C/COPY ZACPYSRC,PSSR_ILE
      *****************************************************************
      /EJECT
      *****************************************************************
**  CPY@
(c) Finastra International Limited 2003
