     H DEBUG FIXNBR(*INPUTPACKED)
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2001')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas LE Lending drip feed')                           *
      *****************************************************************
      *                                                               *
      *  Midas - Customer Lending Module                              *
      *                                                               *
      *  LE2016M - Lending PC Front-End Drip Feed                     *
      *                                                               *
      *  Function:To enable the transfer of Lending transactions and  *
      *           standing data from the back-office to the Lending   *
      *           PC front-end. A batch job will read journal         *
      *           entries throughout the input cycle, the image       *
      *           retrieved will be sent via MQ series communications.*
      *           It will end when it receives a specific user        *
      *           defined journal entry, sent to the journal receiver *
      *           in input cycle termination.                         *
      *                                                               *
      *                                                               *
      *  Called By:                                                   *
      *                                                               *
      *  LEC2016  - Lending PC Front-End Drip Feed Control Program    *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2001            *
      *                                                               *
      *  Last Amend No. MD041126           Date 27Nov19               *
      *  Prev Amend No. CLE164             Date 18Aug14               *
      *                 CSD095             Date 08Apr14               *
      *                 CLE134             Date 01Aug12               *
      *                 CLE148             Date 23Jul12               *
      *                 CCB020             Date 06Aug12               *
      *                 CRE075             Date 06Dec10               *
      *                 CLE064             Date 06Dec10               *
      *                 CER059             Date 19Jul10               *
      *                 CER047             Date 19May08               *
      *                 CER020             Date 19May08               *
      *                 CER043             Date 19May08               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      *                 CRE026             Date 24May06               *
      *                 CAS016             Date 28Feb06               *
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CSD031             Date 10Apr06               *
      *                 CSD027A            Date 10May06               *
      *                 CSD027             Date 09Dec05               *
      *                 CLE042             Date 06Sep05               *
      *                 228849             Date 06Aug04               *
      *                 227709             Date 26May04               *
      *                 225605             Date 01Apr04               *
      *                 CLE035             Date 22Sep03               *
      *                 CLE036             Date 22Sep03               *
      *                 CSW037A            Date 02May05               *
      *                 CSD025             Date 11Jan05               *
      *                 CSW037             Date 15Dec04               *
      *                 CSW036             Date 15Dec04               *
      *                 BUG3644            Date 12Jul04               *
      *                 CLE025             Date 20Oct03               *
      *                 TDA035             Date 02Apr04               *
      *                 CGL029             Date 01Sep03               *
      *                 CAP075            Date  08Aug02               *
      *                 CAP074            Date  08Aug02               *
      *                 CAP073             Date 08Aug02               *
      *                 CLE029             Date 04Sep02               *
      *                 CLE034             Date 05May03               *
      *                 CLE033             Date 01Apr03               *
      *                 CLE031             Date 10Feb03               *
      *                 211532             DATE 17Jan03               *
      *                 CAS005             Date 16Dec02               *
      *                 210796             DATE 27JAN03               *
      *                 CLE028             Date 27Jun02               *
      * Midas Release 4.01.03 ----------------------------------------*
      *                 211959             Date 09Jan03               *
      *                 191421             Date 06Jan03               *
      * Midas Release 4.01.02 ----------------------------------------*
      *                 203561             Date 21Jun02               *
      *                 204452             Date 02May02               *
      * Midas Release 4.01 -------------------------------------------*
      *                 CAP068             Date 25JUN02               *
      *                 CAP071             Date 19Mar02               *
      *                 CLE023             Date 19Nov01               *
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.05 -----------------------------------------------*
      *                 CLE011             Date 07Nov00               *
      *                 CPB003             DATE 04Dec00               *
      *                 189612             DATE 14Feb01               *
      *                 184695             Date 10Nov00
      * Midas DBA 3.04 -----------------------------------------------*
      *                 CRT004             DATE 04MAY00               *
      * Midas DBA 3.02 -----------------------------------------------*
      *                 172577             Date 20Dec99               *
      *                 167146             Date 15Sep99               *
      *                 166578             Date 10Sep99               *
      *                 CLE009             Date 26Apr99               *
      * Midas DBA 3.00 ---------------- Base -------------------------*
      *                 CEU030             Date 08Jun99               *
      *                 157286 (BT0888)    Date 17Mar99               *
      *                 157217 (BT1420)    Date 29Jan99               *
      *                 156466             Date 04Mar99               *
      *                 CLE008             Date 07Dec98               *
      *                 155432             Date 17Feb99               *
      *                 155429             Date 18Feb99               *
      *                 152695             Date 12Jan99               *
      *                 148756             Date 30Nov98               *
      *                 148708             Date 30Nov98               *
      *                 147261             Date 27Jan99               *
      *                 142401             Date 25Feb99               *
      *                 141453             Date 17Feb99               *
      *                 138354             Date 24Sep98               *
      *                 136318             Date 11Feb99               *
      *                 135072             Date 10Feb99               *
      *                 134965             Date 10Feb99               *
      *                 134495             Date 10Feb99               *
      *                 134493             Date 10Feb99               *
      *                 134078             Date 10Feb99               *
      *                 133384             Date 09Feb99               *
      *                 133237             Date 04Feb99               *
      *                 132273             Date 04Feb99               *
      *                 131254 +(BT0547)   Date 04Feb99               *
      *                 125697             Date 16Feb98               *
      *                 130237             Date 16Feb98               *
      *                 123857             Date 24Oct97               *
      *                 124055             Date 23Oct97               *
      *                 124061             Date 22Oct97               *
      *                 124001             Date 22Oct97               *
      *                 123335             Date 30Sep97               *
      *                 123330             Date 23Sep97               *
      *                 122809             Date 10Sep97               *
      *                 122378             Date 29Aug97               *
      *                 121991             Date 29AUG97               *
      *                 121991             Date 20AUG97               *
      *                 121783             Date 14AUG97               *
      *                 121055             Date 13AUG97               *
      *                 CLE005             Date 22May97               *
      *                 121052             Date 25JUL97               *
      *                 121025             Date 22JUL97               *
      *                 120469             Date 11JUL97               *
      *                 120274             Date 09JUL97               *
      *                 120001             Date 02JUL97               *
      *                 119882             Date 27JUN97               *
      *                 119555             Date 23JUN97               *
      *                 CLE004 *CREATE     Date 06MAY97               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD041126 - Certify WebSphere MQ 9 with Midas product line    *
      *           - Applied for MD054674.                             *
      *  CLE164 - CLE134 Enhancement F (Repayment Methodology)        *
      *           (Recompile)                                         *
      *  CSD095 - Allow Deal Sub-Type and Branch for MM and FX SSIs   *
      *           (Recompile)                                         *
      *  CLE134 - Past Due Call Loan Processing (Recompile)           *
      *  CLE148 - Alpha Loan Reference                                *
      *  CCB020 - COB Restructure - Secondary COB Infrastructure      *
      *  CRE075 - Effective Date for Retail Accounts (Recompile)      *
      *  CLE064 - Enhancement of Lending Frequencies (Recompile)      *
      *  CER059 - German Feature Upgrade to Delhi                     *
      *  CER047 - German Features LF037-00 Reporting §24c             *
      *           (Recompile)                                         *
      *  CER020 - Enhanced Rollover Window: Upgrade FGE089 to         *
      *           Midas Plus                                          *
      *  CER043 - German Features LF041-00 New Fields and Defaulting  *
      *           (Recompile)                                         *
      *  CRE026 - Consumer Banking                                    *
      *  CAS016 - IAS18 EIR Recalculation (Fee Amortisation Over      *
      *           Whole Period) -Recompile.                           *
      *  CSD031 - Enhanced Centralised Static Data (Recompile)        *
      *  CSD027A - Conversion Of Customer Number to Alpha             *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CLE042 - Extended Loan Sub Type (Recompile)                  *
      *  228849 - Last Rollover Date was being filled with incorrect  *
      *           data if it was zeros.                               *
      *  227709 - The receive settlement method should always be sent *
      *           regardless of it being zero on settlement allocation*
      *  225605 - Send Generate By Assignment flag on Facility        *
      *           Amendments                                          *
      *  CLE035 - Lending Enhancements for Nordea Phase 1 Priority 2: *
      *           Income Splits                                       *
      *  CLE036 - Lending Enhancements for Nordea Phase 1 Priority 2: *
      *           Allow specific base rates                           *
      *           Allow repayments in facility currency.              *
      *  CSW037A- Additional Field extended to 40 chars (recompile)   *
      *  CSD025 - Customer De-Activation                              *
      *  CSW037 - Additional Field Data on MT300/MT320                *
      *  CSW036 - Dual SWIFT BIC held on Client Details               *
      *  BUG3644 - Serious Error in Collateralised Lending (Recompile)*
      *  CLE025 - Credit Lines (Recompile)                            *
      *  TDA035 - RTS Signon changes for MidasPlus. (Recompile)       *
      *  CGL029 - Increase Account Code to 10 digits                  *
      *  CAP075 - Lending API enhancements - Loan Amendment.          *
      *           (amendment in common with CAP079)                   *
      *  CAP074 - Lending API enhancements - Loans input.             *
      *  CAP073 - Conversion of MN inputs into modular structure to   *
      *           use as APIs. Facility input Transaction Details     *
      *  CLE029 - Addition of Severity code and Limit ID to FCLTYFM   *
      *  CLE034 - Lending Enhancements for Phase 1 Priority 1A        *
      *  CLE033 - Settlement method 09                                *
      *  CLE031 - Lending Enhancements.                               *
      *  211532 - Download SWIFT financial institution as separate    *
      *           field (including backing out of 189612)             *
      *  CAS005 - Enhancements to CAS001, CAS002 and CAS004           *
      *           (Recompile)                                         *
      *  210796 - Extend Our a/c at Nostro field.                     *
      *  CLE028 - Flat Rate Personal Loans (Rule of 78s)              *
      *  211959 - LE2016M would only compile with QMQM in the library *
      *           list. Changed /copies to specify the library name.  *
      *  191421 - Loan Manager only picked up changes on Fee Code 01. *
      *  203561 - Control messages (e.g. CLND) are now sent via a new *
      *           program LEC2017.                                    *
      *  204452 - Recompiled due to changed PF/LEFEED.                *
      *  CAP068 - Recompiled for changes to FCLTYFM and FCLTYFN.      *
      *  CAP071 - Conversion of LE inputs into modular structure to   *
      *           use as APIs. (Recompile)                            *
      *  CLE023 - Lending Facility History Improvements.              *
      *  CLE011 - Rate Fixing Days for Lending Rollover Processing    *
      *  CPB003 - Portfolio Reference Changes in Loan Manager for PB  *
      *           Send Private Banking Module id and PB Customer      *
      *  189612 - Download Swift Financial Institution so that        *
      *           settlements processing in Loan Manager uses the     *
      *           same information to work out if a customer is a     *
      *           bank as Midas.                                      *
      *           Note as the only place Bank To Bank information     *
      *           field is used is in settlements so changing the     *
      *           download of this field to get the information from  *
      *           the Swift Financial Institution field.              *
      *           Note if later both the Bank To Bank information     *
      *           field and the Swift Financial Institution field     *
      *           is needed in Loan Manager then have to reverse this *
      *           change and do the fixes listed in the GEMS document.*
      *  184695 - The fseq no. of the primary facility is blanked out *
      *           during rollback.                                    *
      *  CRT004 - Cashier Midas TCP/IP interface.                     *
      *             Recompiled over SDBRCHPD Changes                  *
      *  172577 - The transmit queues are not being closed on exit.   *
      *           The transmit queues are being opened unnecessarily- *
      *           when there is no journal image in P#PARM1.          *
      *  167146 - Settlement instructions for a part sold entered in  *
      *           one branch are returned by Midas with wrong         *
      *           settlement branch.                                  *
      *  166578 - Midas returns wrong values for Rollover from Loan   *
      *           Manager.                                            *
      *  CLE009 - LE I/C Swift Message Generation for Fees            *
      *           Recompiled due to changes in LEFEED                 *
      *  CEU030 - EMU Loan Manager Enhancement                        *
      *  157286 - Add PC originating branch to fees drip feed.        *
      *  157217 - New "generated by assignment" flag on facility      *
      *           amendments                                          *
      *  156466 - Default blanks into funding spread/rate when        *
      *           value is blank instead of zeros                     *
      *  CLE008 - Switchable Feature For Loan Administrator Id        *
      *  155432 - Interest skim field not getting leading zeros       *
      *           blanked out. Also applies to other fields           *
      *  155429 - Add user default branch to User message             *
      *  152695 - Fee Settlement date not sent from Midas to LM       *
      *  148756 - Negative amounts wrong for fees. Also correct       *
      *           margin download when negative.                      *
      *  148708 - Negative amounts wrong for manual repayments.       *
      *  147261 - Add Assignment or Participation indicator           *
      *  142401 - Problem on loan extension record.                   *
      *  141453 - Recompiled due to changes in PF/LEFEED              *
      *  138354 - Drip feed process should advise Loan manager        *
      *           when Midas is about to start COB.                   *
      *  136318 - Extended settlement details for fees is not drip    *
      *           fed correctly.                                      *
      *  135072 - Fee amount needs to be sent as blanks when not      *
      *           entered.                                            *
      *  134965 - Set up the action field correctly for a reverse of  *
      *           'SD' files.                                         *
      *  134495 - POBN/POCN/ROBN/ROCN for Risk Participants need to be*
      *           sent as blanks when not entered.                    *
      *  134493 - Problems with rollback of Risk Participants, the    *
      *           action flag is set to 'D' with no rollback flag.    *
      *  134078 - For certain PP's the original borrower is not       *
      *           trickle fed down.                                   *
      *  133384 - Credit Agreement Exchange Rate field is not         *
      *           formatted correctly.                                *
      *  133237 - Add profit centre field to fees drip feed.          *
      *  132273 - The action flag is set to D when processing a       *
      *           journal type 'PT' and the syndicated loan has been  *
      *           reversed.                                           *
      *  131254 - Negative current principal is not handled correctly.*
      *  125697 - L1ORBO and L1SLNO should not both be filled for     *
      *           both Parts. Purchased and Sold - it should be one   *
      *           or the other                                        *
      *  130237 - Add Credit Agreement Exchange rate fields to        *
      *           download.                                           *
      *  123857 - Add field for Authorisation to Review All Screens   *
      *           for Lending ICD                                     *
      *  124055 - PCOB is not trickle fed on a roll back for          *
      *           FCLTYFM and CLOANCL.                                *
      *  124061 - Next calculation basis needs to be sent as blanks   *
      *           if zero.                                            *
      *  124001 - Set original loan number of an internal part purch  *
      *  123335 - Include new base currency exchange rate/indicator   *
      *  123330 - Facility amount is downloaded with leading zeros    *
      *  122809 - Certain numeric fields that are zero need to be set *
      *           to blanks, for lending files.                       *
      *  122378 - Change action code processing for rollback of a     *
      *           journal image.                                      *
      *  121991 - When rolling back a journal image a new field needs *
      *           to be set to inform the PC of this action.          *
      *  121783 - Call new access object AOBRCHR1 instead of AOBRCHR0 *
      *           (uses the long data structure DSSDY)                *
      *  CLE005 - Customer Lending Enhancements - Others (T3)         *
      *         - Changed to ILE module                               *
      *  121055 - PC Originatin Branch missing.                       *
      *           Use first 3 characters of x1fil1 in header.         *
      *  121052 - Late payment penalty spread/amount set up           *
      *           incorrectly                                         *
      *  121025 - Certain numeric fields that are zero need to be set *
      *           to blanks, for lending files.                       *
      *  120469 - Program crashes out when mapping entry field P#PARM1*
      *           to SDEXST. Length of SDEXSTPD has changed, change   *
      *           length of P#PARM1                                   *
      *  120274 - Don't perform databse error if record is not found  *
      *  120001 - Sign for margin field should be set to blank if +VE *
      *           and 'Y' if -VE                                      *
      *  119882 - Local Industry Code should be set to blanks if zero *
      *  119555 - Any date and certain numeric fields that are zero   *
      *           need to be set to blanks, for lending files.        *
      *  CLE004 - Created for Customer Lending Enhancements           *
      *                                                               *
      *****************************************************************
      *
     FLEDLLDPD  UF   E           K DISK    INFSR(*PSSR)
      *
     FFCLTY     IF   E           K DISK    INFSR(*PSSR)
     F                                     INCLUDE(FCLTYFMF:FCLTYFNF)
      *
     FCLOAN     IF   E           K DISK    INFSR(*PSSR)
     F                                     INCLUDE(CLOANCKF:CLOANCLF)
      *
     FLOAMS     IF   E           K DISK    INFSR(*PSSR)
     F                                     INCLUDE(LOAMSDKF)
      *
     FLEPARTPD  IF   E           K DISK    INFSR(*PSSR)
      *
     F/COPY WNCPYSRC,LE2016MF01
     FLE2016AU  O    E             PRINTER INFDS(SPOOLU)
     F                                     USROPN
      **********************************************************************
      *
      *  F U N C T I O N   O F  I N D I C A T O R S
      *
      *  30 - Control text 'Reason Code' on Printer File
      *  70 - Work indicator for chain on FCLTY & CLOAN files
      *  85 - Work indicator for TESTB op code
      *  88 - Work indicator for chain on LEDLLDPD file
      *
      *----------------------------------------------------------------
      *  U6 U7 U8 LR
      **********************************************************************
      *
      * Copyright
     D CPY@            S             80    DIM(1) CTDATA PERRCD(1)
      *
      * Subroutine Stack
     D STK             S             10    DIM(99)
      *
      * Ledrip Data Area
     D LEJNSQ          DS            10
     D   LDSEQ                 1     10  0
      *
      * Branch Code Array and related Drip Feed Message Queue
     D W#ABRCH         S                   DIM(999) LIKE(A8BRCD)
     D W#AMQDF         S                   DIM(999) LIKE(A8MQDF)
      * Drip Feed Message Queue Handles
     D W#AMQDH         S                   DIM(999) LIKE(P#HOBJ)
      *
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
      *
     D SDBRCH        E DS                  EXTNAME(SDBRCHPD)
      *
     D SDMMOD        E DS                  EXTNAME(SDMMODPD)
      *
     D SDGELR        E DS                  EXTNAME(SDGELRPD)
      *
     D SDRETL        E DS                  EXTNAME(SDRETLPD)
     D  QQACCD1      E                     EXTFLD(QQACCD)                                     CGL029
      *
     D SDCLND        E DS                  EXTNAME(SDCLNDPD)
      *
     D SDPORT        E DS                  EXTNAME(SDPORTPD)
      *
     D SDCUST        E DS                  EXTNAME(SDCUSTPD)
     D  QQDFAC1      E                     EXTFLD(QQDFAC)                                     CGL029
      *
     D SDALTN        E DS                  EXTNAME(SDALTNPD)
      *
     D SDFACT        E DS                  EXTNAME(SDFACTPD)
      *
     D SDCURR        E DS                  EXTNAME(SDCURRPD)
      *
     D SDCTRY        E DS                  EXTNAME(SDCTRYPD)
      *
     D SDFEEC        E DS                  EXTNAME(SDFEEPD)
      *
     D SDINDS        E DS                  EXTNAME(SDINDSPD)
      *
     D SDACOF        E DS                  EXTNAME(SDACOFPD)
      *
     D SDPRFC        E DS                  EXTNAME(SDPRFCPD)
      *
     D SDBOOK        E DS                  EXTNAME(SDBOOKPD)
      *
     D SDLOAN        E DS                  EXTNAME(SDLOANPD)
      *
     D SDBSRT        E DS                  EXTNAME(SDBSRTPD)
      *
     D SDNOST        E DS                  EXTNAME(SDNOSTPD)
     D  QQACCD2      E                     EXTFLD(QQACCD)                                     CGL029
      *
     D SDCNST        E DS                  EXTNAME(SDCNSTPD)
      *
     D ACCNT         E DS                  EXTNAME(ACCNTAB)
      *
     D SDEXST        E DS                  EXTNAME(SDEXSTPD)
      *
     D SDPORR        E DS                  EXTNAME(PMPORTPD)
      *
     D SDPLCS        E DS                  EXTNAME(SDPLCSPD)
      *
     D SDHOL         E DS                  EXTNAME(SDHOLPD)
      *
     D SDTRAD        E DS                  EXTNAME(SDTRADPD)
     D  QQACCD3      E                     EXTFLD(QQACCD)                                     CGL029
      *
     D SDCCSY        E DS                  EXTNAME(SDCCSYPD)
      *
     D SDPRFM        E DS                  EXTNAME(SDPRFMPD)
      *
     D SDCODE        E DS                  EXTNAME(SDCODEPD)
      *
     D SCSARD        E DS                  EXTNAME(SCSARDPD)
     D  SCLCD        E                     EXTFLD(LCD)
      *
     D SDBSHS        E DS                  EXTNAME(SDBSHSPD)
      *
     D SDPCAC        E DS                  EXTNAME(SDPCACPD)
      *
      ** Account Code Details                                                   CLE033
     D SDACOD        E DS                  EXTNAME(SDACODPD)                    CLE033
     D  QQACCD4      E                     EXTFLD(QQACCD)                                     CGL029
     D  QQFNIC4      E                     EXTFLD(QQFNIC)                                     CGL029
     D  QQFNAA4      E                     EXTFLD(QQFNAA)                                     CGL029
                                                                                CLE033
     D FCLTYN        E DS                  EXTNAME(FCLTYFN)
     D                                     PREFIX(F#N)
      *
     D FCLTYM        E DS                  EXTNAME(FCLTYFM)
     D                                     PREFIX(F#M)
      *
     D CLOANL        E DS                  EXTNAME(CLOANCL)
     D                                     PREFIX(F#L)
      *
     D CLOANK        E DS                  EXTNAME(CLOANCK)
     D                                     PREFIX(F#K)
      *
     D LOAMSD        E DS                  EXTNAME(LOAMSDK)
     D                                     PREFIX(F#D)
      *
     D LEPART        E DS                  EXTNAME(LEPARTPD)
     D                                     PREFIX(F#P)
      *
     D LEFCAM        E DS                  EXTNAME(LEFCAMPD)
     D                                     PREFIX(F#A)
      *
     D LEFEE         E DS                  EXTNAME(LEFEED)
     D                                     PREFIX(F#E)
      *
     D LEFEEA        E DS                  EXTNAME(LEFEEAD)
     D                                     PREFIX(F#S)
      *
     D MUSER         E DS                  EXTNAME(MUSERDD)
     D                                     PREFIX(F#U)
      *                                                                         CLE031
     D SDSVAL        E DS                  EXTNAME(SDSVALPD)                    CLE031
      *
      **  Facility Amendments Message Format
     D DWL4MF        E DS                  EXTNAME(LEL4MFPD)
     D  D4DTL                 91    190
      *
      **  Fees Message Format
     D DWL5MF        E DS                  EXTNAME(LEL5MFPD)
     D**D5DTL**********       91   1151                                                       133237
     D**D5DTL******           91   1155                                                133237 157286
     D**D5DTL******           91   1158                                                157286 148756
     D  D5DTL                 91   1159                                                       148756
      *
      **  Fee Settlements Message Format
     D DWL6MF        E DS                  EXTNAME(LEL6MFPD)
     D  QQPONS5      E                     EXTFLD(QQPONS)                                     CGL029
     D  QQRONS5      E                     EXTFLD(QQRONS)                                     CGL029
     D  D6DTL                 91    822
      *
      **  Midas User Message Format
     D DWSWMF        E DS                  EXTNAME(LESWMFPD)
     D**DUDTL*******          91    102                                                       155429
     D  DUDTL                 91    105                                                       155429
      *                                                                                       CLE034
     D DWSTAL        E DS                  EXTNAME(LESTALPD)                                  CLE034
     D                                     PREFIX(F#T)                                        CLE034
      *                                                                                       CLE034
      ** Midas LE PC Msg Format Settlement Allocation                                         CLE034
     D DWL8MF        E DS                  EXTNAME(LEL8MFPD)                                  CLE034
     D  QQPONS6      E                     EXTFLD(QQPONS)                                     CGL029
     D  QQRONS6      E                     EXTFLD(QQRONS)                                     CGL029
     D  D8DTL                 91    888                                                       CLE034
      *                                                                                       CLE035
      ** Midas LE PC Msg Format Transaction Income Splits                                     CLE035
     D DWL9MF        E DS                  EXTNAME(LEL9MFPD)                                  CLE035
     D  D9DTL                 91    161                                                       CLE035
      *                                                                                       CLE035
      ** Midas LE Transaction Income Split File                                               CLE035
     D LETISP        E DS                  EXTNAME(LETISPPD)                                  CLE035
     D                                     PREFIX(F#I)                                        CLE035
      *
     D/COPY WNCPYSRC,LE2016D001
      *
      **  Long Data Structure for Access programs.
     D DSSDY         E DS                  EXTNAME(DSSDY)
      *
      **  Short Data Structure for Access programs.
     D DSFDY         E DS                  EXTNAME(DSFDY)
      *
      **  Static Data Download Start/End Message Format
     D DWX1MF        E DS                  EXTNAME(LEX1MFPD)
      *
      **  Static Data Download Midas Modules Message Format
     D DWS1MF        E DS                  EXTNAME(LES1MFPD)
      *
      **  Static Data Download Bank Details Message Format
     D DWS2MF        E DS                  EXTNAME(LES2MFPD)
      *
      **  Static Data Download General Ledger ICD Message Format
     D DWS3MF        E DS                  EXTNAME(LES3MFPD)
      *
      **  Static Data Download Retail ICD Message Format
     D DWS4MF        E DS                  EXTNAME(LES4MFPD)
     D  QQACCD5      E                     EXTFLD(QQACCD)                                     CGL029
      *
      **  Static Data Download Customer Lending ICD Message Format
     D DWS5MF        E DS                  EXTNAME(LES5MFPD)
      *
      **  Static Data Download Portfolio Management ICD Message Format
     D DWS6MF        E DS                  EXTNAME(LES6MFPD)
      *
      **  Static Data Download Customer Details Message Format
     D DWS7MF        E DS                  EXTNAME(LES7MFPD)
      *
      **  Static Data Download Customer Alt Name & Address Message Format
     D DWS8MF        E DS                  EXTNAME(LES8MFPD)
      *
      **  Static Data Download Facility Types Message Format
     D DWS9MF        E DS                  EXTNAME(LES9MFPD)
      *
      **  Static Data Download Branch Codes Message Format
     D DWS0MF        E DS                  EXTNAME(LES0MFPD)
      *
      **  Static Data Download Currency Codes Message Format
     D DWSAMF        E DS                  EXTNAME(LESAMFPD)
      *
      **  Static Data Download Country Codes Message Format
     D DWSBMF        E DS                  EXTNAME(LESBMFPD)
      *
      **  Static Data Download Fee Codes Message Format
     D DWSXMF        E DS                  EXTNAME(LESXMFPD)
      *
      **  Static Data Download Industry Codes Message Format
     D DWSCMF        E DS                  EXTNAME(LESCMFPD)
      *
      **  Static Data Download Account Officers Codes Message Format
     D DWSDMF        E DS                  EXTNAME(LESDMFPD)
      *
      **  Static Data Download Profit Center Matrices Message Format
     D DWSEMF        E DS                  EXTNAME(LESEMFPD)
      *
      **  Static Data Download Profit Centre Codes Message Format
     D DWSFMF        E DS                  EXTNAME(LESFMFPD)
      *
      **  Static Data Download Book Codes Message Format
     D DWSGMF        E DS                  EXTNAME(LESGMFPD)
      *
      **  Static Data Download Loan Types/sub-types Message Format
     D DWSHMF        E DS                  EXTNAME(LESHMFPD)
      *
      **  Static Data Download Base Rate Codes Message Format
     D DWSIMF        E DS                  EXTNAME(LESIMFPD)
      *
      **  Static Data Download Base Rate History Message Format
     D DWSJMF        E DS                  EXTNAME(LESJMFPD)
      *
      **  Static Data Download Nostro Codes Message Format
     D DWSKMF        E DS                  EXTNAME(LESKMFPD)
     D  QQACCD6      E                     EXTFLD(QQACCD)                                     CGL029
      *
      **  Static Data Download Counterpart Nostro Codes Message Format
     D DWSLMF        E DS                  EXTNAME(LESLMFPD)
      *
      **  Static Data Download Accounts Message Format
     D DWSMMF        E DS                  EXTNAME(LESMMFPD)
      *
      **  Static Data Download Extended Settlements Message Format
     D DWSNMF        E DS                  EXTNAME(LESNMFPD)
     D  QQPONO1      E                     EXTFLD(QQPONO)                                     CGL029
     D  QQRONO1      E                     EXTFLD(QQRONO)                                     CGL029
      *
      **  Static Data Download Portfolio References Message Format
     D DWSOMF        E DS                  EXTNAME(LESOMFPD)
      *
      **  Static Data Download Portfolio Customers Message Format
     D DWSPMF        E DS                  EXTNAME(LESPMFPD)
      *
      **  Static Data Download Holidays Message Format
     D DWSQMF        E DS                  EXTNAME(LESQMFPD)
      *
      **  Static Data Download SWIFT Codewords Message Format
     D DWSRMF        E DS                  EXTNAME(LESRMFPD)
      *
      **  Static Data Download Switchable Features Message Format
     D DWSSMF        E DS                  EXTNAME(LESSMFPD)
      *
      **  Static Data Download Trading Data ICD Message Format
     D DWSTMF        E DS                  EXTNAME(LESTMFPD)
      *
      **  Static Data Download Currency Clearing System Message Format
     D DWSUMF        E DS                  EXTNAME(LESUMFPD)
      *
      **  Static Data Download Profit Centre Accounting ICD Message Format
     D DWSVMF        E DS                  EXTNAME(LESVMFPD)
      *
      **  Lending Download Facilities Message Format
     D DWL0MF        E DS                  EXTNAME(LEL0MFPD)
     D  QQPONS1      E                     EXTFLD(QQPONS)                                     CGL029
     D  QQRONS1      E                     EXTFLD(QQRONS)                                     CGL029
      *
      **  Lending Download Loans Message Format
     D DWL1MF        E DS                  EXTNAME(LEL1MFPD)
     D  QQPONS2      E                     EXTFLD(QQPONS)                                     CGL029
     D  QQRONS2      E                     EXTFLD(QQRONS)                                     CGL029
      *
      **  Lending Download Loan Amendments Message Format
     D DWL2MF        E DS                  EXTNAME(LEL2MFPD)
     D  QQPONS3      E                     EXTFLD(QQPONS)                                     CGL029
     D  QQRONS3      E                     EXTFLD(QQRONS)                                     CGL029
      *
      **  Lending Download Risk Participants/Assignments Message Format
     D DWL3MF        E DS                  EXTNAME(LEL3MFPD)
     D  QQPONS4      E                     EXTFLD(QQPONS)                                     CGL029
     D  QQRONS4      E                     EXTFLD(QQRONS)                                     CGL029
      *                                                                         CLE031
      **  Static Data Download System Values Message Format                     CLE031
     D DWSYMF        E DS                  EXTNAME(LESYMFPD)                    CLE031
      *
     D/COPY WNCPYSRC,LE2016D002
      *
      **  Message Format
     D W#MFMT          S                   LIKE(P#MFMT)
                                                                                              CLE034
      ** Working Variables for CLE034                                                         CLE034
     D PRtnCde         S              7                                                       CLE034
     D POption         S              7                                                       CLE034
     D WWSTAL          DS            33                                                       CLE034
     D  PType                         4                                                       CLE034
     D**PLoanRef                      6  0                                             CLE034 CLE148
     D  PLoanRef                      6                                                       CLE148
     D  PLAVD                         5  0                                                    CLE034
     D  PLoanSeq                      3  0                                                    CLE034
     D  PCust                         6  0                                                    CLE034
     D  PFclty                        5  0                                                    CLE034
     D  PFeeSeq                       2  0                                                    CLE034
     D PTMSP           S             26Z                                                      CLE034
     D PSeq            S              5                                                       CLE034
      *
      * Program Status Data Structure
     D PSDS           SDS
     D  W#PGM            *PROC
     D  W#WSID               244    253
     D  W#USER               254    263
      *
      * MQI structures
      *
      * MQI named constants
     **D/COPY**QRPGLESRC,CMQR****************                                                 211959
     D***/COPY*QMQM/QRPGLESRC,CMQR                                                   211959 MD041126
     D/COPY QMQM/QRPGLESRC,CMQG                                                             MD041126
      * Object Descriptor - source and reply
     D MQOD            DS
     **D/COPY**QRPGLESRC,CMQODR**************                                                 211959
     D***/COPY*QMQM/QRPGLESRC,CMQODR                                                 211959 MD041126
     D/COPY QMQM/QRPGLESRC,CMQODG                                                           MD041126
      * Message Descriptor
     D MQMD            DS
     **D/COPY**QRPGLESRC,CMQMDR**************                                                 211959
     D***/COPY*QMQM/QRPGLESRC,CMQMDR                                                 211959 MD041126
     D/COPY QMQM/QRPGLESRC,CMQMDG                                                           MD041126
      * Put message options
     D MQPMO           DS
     **D/COPY**QRPGLESRC,CMQPMOR*************                                                 211959
     D***/COPY*QMQM/QRPGLESRC,CMQPMOR                                                211959 MD041126
     D/COPY QMQM/QRPGLESRC,CMQPMOG                                                          MD041226
      *
      * Date formatting fields
     D W#EURDATE       S               D   DATFMT(*EUR)
     D W#USADATE       S               D   DATFMT(*USA)
      *
     D SPOOLU          DS
     D  SFILEU                83     92
     D  SFNUMU               123    124B 0
      *
      * Local data area for database error details
     D DBERR         E DS                  EXTNAME(LDA)
                                                                                              CLE034
     D LDA           E DS                  DTAARA(LDA)                                        CLE034
     D                                     PREFIX(S)                                          CLE034
      *
      *
      *     Data structure for Journal Entry
     D*P#PARM1*********DS          1420
     D P#PARM1         DS          4000
     D JRNSQ                   6     15  0
     D  JOENTT                17     18
     D  JFILE                 87     96
      *
      * Constant to be sent on QCMDEXEC command
     D SETSW6          C                   CONST('CHGJOB SWS(XXXXX1XX)')
      *
      * Message Header Filler field 9 long. Pos 1-3 contains PC orig
      * branch (121055). Pos 4 contains journal image Rollback flag.
      * 5-9 not used.
      *
     D FILLER          DS             6
     D    ROLLB                1      1
      *                                                                                       138354
      * Midas System Phase data area                                                          138354
     D***MPHAS*********E DS                  EXTNAME(MPHAS)                            138354 CCB020
     D***PHASE*******E                     EXTFLD(MPHAS)                               138354 CCB020
      *                                                                                       CLE028
     D CLE028          S              1A                                                      CLE028
                                                                                              CLE036
      ** Datastructure to hold input parameter for AOSVALR0.                                  CLE036
     DWPARMDS          DS                                                                     CLE036
     DWPARM0                   1     20                                                       CLE036
     DWPARM1                   1      5                                                       CLE036
     DWPARM2                   6     10                                                       CLE036
     DWPARM3                  11     15                                                       CLE036
     DWPARM4                  16     20                                                       CLE036
                                                                                              CLE036
      ** SAR Flags                                                                            CLE036
                                                                                              CLE036
     D CLE036          S              1A                                                      CLE036
     D W@LNRF          S              6A                                                      CLE148
                                                                                            MD041126
      ** MQ Parameters                                                                      MD041126
     D P#HCONN         S             10I 0                                                  MD041126
     D P#HOBJ          S             10I 0                                                  MD041126
     D P#MLEN          S             10I 0                                                  MD041126
     D P#MFMT          S          32767A                                                    MD041126
     D P#CCODE         S             10I 0                                                  MD041126
     D P#RSCOD         S              9P 0                                                  MD041126
     D P#REASON        S             10I 0                                                  MD041126
     D P#OPTS          S             10I 0                                                  MD041126
     D P#QMNAME        S             48A                                                    MD041126
      *                                                                                     MD041126
      **********************************************************************
      *
     C     *ENTRY        PLIST
     C                   PARM                    P#PARM1
     C                   PARM                    P#PARM2           1
      *
      * Initial Processing
     C***********        EXSR      INITIAL                                                    172577
      *
     C     P#PARM2       IFEQ      '1'
      *
     C                   EXSR      INITIAL                                                    172577
      *                                                                                       172577
      * Main Processing
      *
     C                   EXSR      SELECT
      * Update Ledrip dtaara
      *
     C                   EXSR      UPDRIP
      *
      * If still connected to the MQ Manager                                                  172577
     C     WKCLOS        IFNE      'Y'                                                        172577
     C                   EXSR      CLOSE                                                      172577
     C                   ENDIF                                                                172577
      *                                                                                       172577
     C                   ENDIF
      *
     C                   RETURN
      **********************************************************************
      * Determine which file image has been received. Call appropriate
      * subroutine to load details into message format
      **********************************************************************
     C     SELECT        BEGSR
      *
     C                   ADD       1             @Q
     C                   MOVEL     'SELECT  '    STK(@Q)
      *
     C                   MOVE      'N'           W#DBER                                       134493
      *                                                                                       134493
     C                   SELECT
      *
      * Close Down
     C     JOENTT        WHENEQ    'YE'
     C     JFILE         ANDEQ     'SDCLNDPD'
     C                   EXSR      FINAL
      *
      * Close Down
     C     JOENTT        WHENEQ    'YJ'
     C     JFILE         ANDEQ     'SDCLNDPD'
     C                   EXSR      FINAL
      *
      * Put Facility Types
     C     JFILE         WHENEQ    'FCLTYFM'
     C     JFILE         OREQ      'FCLTYFN'
     C                   MOVE      'DLFC'        X1MSGT
     C                   EXSR      P#DLFC
      *
     C     JFILE         WHENEQ    'CLOANCK'
     C     JFILE         OREQ      'CLOANCL'
     C                   MOVE      'DLLN'        X1MSGT
     C                   EXSR      P#DLLN
      *
      * Put Loan Types
     C     JFILE         WHENEQ    'LOAMSDK'
     C                   MOVE      'DLLA'        X1MSGT
     C                   EXSR      P#DLLA
      *
      * Put Accounts
     C     JFILE         WHENEQ    'ACCNTAB'
     C                   MOVE      'ACNT'        X1MSGT
     C                   EXSR      P#ACNT
      *
     C     JFILE         WHENEQ    'LEPARTPD'
     C                   MOVE      'DLRA'        X1MSGT
     C                   EXSR      P#DLRA
      *
      * Put Facility Amendments
     C     JFILE         WHENEQ    'LEFCAMPD'
     C                   EXSR      P#DLFA
      *
      * Put Fees
     C     JFILE         WHENEQ    'LEFEED'
     C                   EXSR      P#DLFE
      *
      * Put Fee Amendments
     C     JFILE         WHENEQ    'LEFEEAD'
     C                   EXSR      P#DLFS
      *
      * Put Midas Users
     C     JFILE         WHENEQ    'MUSERDD'
     C                   EXSR      P#USER
      *
      * Put Switchable Features
     C     JFILE         WHENEQ    'SCSARDPD'
     C                   MOVE      'SARD'        X1MSGT
     C                   EXSR      P#SARD
      *
      * Put Midas Module message
     C     JFILE         WHENEQ    'SDMMODPD'
     C                   MOVE      'MMOD'        X1MSGT
     C                   EXSR      P#MMOD
      *
      * Put Bank Details message
     C     JFILE         WHENEQ    'SDBANKPD'
     C                   MOVE      'BANK'        X1MSGT
     C                   EXSR      P#BANK
      *
      * Put General Ledger ICD message
     C     JFILE         WHENEQ    'SDGELRPD'
     C                   MOVE      'GELR'        X1MSGT
     C                   EXSR      P#GELR
      *
      * Put Retail ICD message
     C     JFILE         WHENEQ    'SDRETLPD'
     C                   MOVE      'RETL'        X1MSGT
     C                   EXSR      P#RETL
      *
      * Put Customer Lending ICD message
     C     JFILE         WHENEQ    'SDCLNDPD'
     C                   MOVE      'CLND'        X1MSGT
     C                   EXSR      P#CLND
      *
      * Put Portfolio Management ICD message
     C     JFILE         WHENEQ    'SDPORTPD'
     C                   MOVE      'PORT'        X1MSGT
     C                   EXSR      P#PORT
      *
      * Put Customer Details
     C     JFILE         WHENEQ    'SDCUSTPD'
     C                   MOVE      'CUST'        X1MSGT
     C                   EXSR      P#CUST
      *
      * Put Customer Alternative Names and Addresses
     C     JFILE         WHENEQ    'SDALTNPD'
     C                   MOVE      'ALTN'        X1MSGT
     C                   EXSR      P#ALTN
      *
      * Put Facility Types
     C     JFILE         WHENEQ    'SDFACTPD'
     C                   MOVE      'FACT'        X1MSGT
     C                   EXSR      P#FACT
      *
      * Put Branch Codes
     C     JFILE         WHENEQ    'SDBRCHPD'
     C                   MOVE      'BRCH'        X1MSGT
     C                   EXSR      P#BRCH
      *
      * Put Currency Codes
     C     JFILE         WHENEQ    'SDCURRPD'
     C                   MOVE      'CURR'        X1MSGT
     C                   EXSR      P#CURR
      *
      * Put Country Codes
     C     JFILE         WHENEQ    'SDCTRYPD'
     C                   MOVE      'CTRY'        X1MSGT
     C                   EXSR      P#CTRY
      *
      * Put Fee Codes
     C     JFILE         WHENEQ    'SDFEEPD'
     C                   MOVE      'FEEC'        X1MSGT
     C                   EXSR      P#FEEC
      *
      * Put Industry Codes
     C     JFILE         WHENEQ    'SDINDSPD'
     C                   MOVE      'INDS'        X1MSGT
     C                   EXSR      P#INDS
      *
      * Put Account Officer Codes
     C     JFILE         WHENEQ    'SDACOFPD'
     C                   MOVE      'ACOF'        X1MSGT
     C                   EXSR      P#ACOF
      *
      * Put Profit Centres
     C     JFILE         WHENEQ    'SDPRFCPD'
     C                   MOVE      'PRFC'        X1MSGT
     C                   EXSR      P#PRFC
      *
      * Put Profit Centre Matrix Details
     C     JFILE         WHENEQ    'SDPRFMPD'
     C                   MOVE      'PRFM'        X1MSGT
     C                   EXSR      P#PRFM
      *
      * Put Book Codes
     C     JFILE         WHENEQ    'SDBOOKPD'
     C                   MOVE      'BOOK'        X1MSGT
     C                   EXSR      P#BOOK
      *
      * Put Loan Types/Sub-types
     C     JFILE         WHENEQ    'SDLOANPD'
     C                   MOVE      'LTST'        X1MSGT
     C                   EXSR      P#LTST
      *
      * Put Base Rate Codes
     C     JFILE         WHENEQ    'SDBSRTPD'
     C                   MOVE      'BSRT'        X1MSGT
     C                   EXSR      P#BSRT
      *
      * Put Base Rate History
     C     JFILE         WHENEQ    'SDBSHSPD'
     C                   MOVE      'BSHS'        X1MSGT
     C                   EXSR      P#BSHS
      *
      * Put Nostro Codes
     C     JFILE         WHENEQ    'SDNOSTPD'
     C                   MOVE      'NOST'        X1MSGT
     C                   EXSR      P#NOST
      *
      * Put Counterparty Nostro Codes
     C     JFILE         WHENEQ    'SDCNSTPD'
     C                   MOVE      'CNST'        X1MSGT
     C                   EXSR      P#CNST
      *
      * Put Extended Settlements
     C     JFILE         WHENEQ    'SDEXSTPD'
     C                   MOVE      'EXST'        X1MSGT
     C                   EXSR      P#EXST
      *
      * Put Portfolio References
     C     JFILE         WHENEQ    'PMPORTPD'
     C                   MOVE      'PORR'        X1MSGT
     C                   EXSR      P#PORR
      *
      * Put Portfolio Customers
     C     JFILE         WHENEQ    'SDPLCSPD'
     C                   MOVE      'PLCS'        X1MSGT
     C                   EXSR      P#PLCS
      *
      * Put Holidays
     C     JFILE         WHENEQ    'SDHOLPD'
     C                   MOVE      'HOLS'        X1MSGT
     C                   EXSR      P#HOLS
      *
      * Put SWIFT Codewords
     C     JFILE         WHENEQ    'SDCODEPD'
     C                   MOVE      'CODE'        X1MSGT
     C                   EXSR      P#CODE
      *
      * Put Trading ICD message
     C     JFILE         WHENEQ    'SDTRADPD'
     C                   MOVE      'TRAD'        X1MSGT
     C                   EXSR      P#TRAD
      *
      * Put Currency Clearing System
     C     JFILE         WHENEQ    'SDCCSYPD'
     C                   MOVE      'CCSY'        X1MSGT
     C                   EXSR      P#CCSY
      *
      * Put Profit Centre Accounting ICD message
     C     JFILE         WHENEQ    'SDPCACPD'
     C                   MOVE      'PCAC'        X1MSGT
     C                   EXSR      P#PCAC
      *
      *                                                                         CLE031
      * Put System Values message                                               CLE031
     C     JFILE         WHENEQ    'SDSVALPD'                                   CLE031
     C                   MOVE      'SVAL'        X1MSGT                         CLE031
     C                   EXSR      P#SVAL                                       CLE031
      *
      * Put Settlement Allocations                                                            CLE034
     C     JFILE         WHENEQ    'LESTALPD'                                                 CLE034
     C                   MOVE      'DLSA'        X1MSGT                                       CLE034
     C                   EXSR      P#DLSA                                                     CLE034
      *                                                                                       CLE034
      * Put Income Splits                                                                     CLE035
     C                   WHEN      JFILE =  'LETISPPD'                                        CLE035
     C                   EXSR      P#DLIS                                                     CLE035
      *                                                                                       CLE035
     C/COPY WNCPYSRC,LE2016C001
      *
     C                   OTHER
      *
      * If a wrong file has been picked up by accident exit pgm
      *                  RETURN
      *
     C                   MOVE      *BLANKS       STK(@Q)
     C                   SUB       1             @Q
      *
     C                   ENDSL
      *
     C                   ENDSR
      **********************************************************************
      * Set up Transmitted Message Format for FCLTYFM/FCLTYFN
      **********************************************************************
     C     P#DLFC        BEGSR
      *
     C                   ADD       1             @Q
     C                   MOVEL     'P#DLFC'      STK(@Q)
      *
      * Downloaded msg is derived from 2 Midas files. Journal entry will
      * contain one of these records, need to access the other.
      *
     C     JFILE         IFEQ      'FCLTYFM'
      *
      * Retrieve the data from the file image and move into DS for FCLTYFM
      * start pos: 126, length: 1083
      *
     C                   EVAL      W#FSIZ=%SIZE(FCLTYM)
     C                   EVAL      FCLTYM=%SUBST(P#PARM1:126:W#FSIZ)
      *
     C                   MOVE      F#MCNUM       W@CNUM
     C                   MOVE      F#MFACT       W@FACT
     C                   MOVE      F#MFCNO       W@FCNO
      *
     C                   ELSE
      *
      * Retrieve the data from the file image and move into DS for FCLTYFN
      * start pos: 126, length: 256
      *
     C                   EVAL      W#FSIZ=%SIZE(FCLTYN)
     C                   EVAL      FCLTYN=%SUBST(P#PARM1:126:W#FSIZ)
      *
     C                   MOVE      F#NCNUM       W@CNUM
     C                   MOVE      F#NFACT       W@FACT
     C                   MOVE      F#NFCNO       W@FCNO
      *
     C                   ENDIF
      *  A record
      *
     C                   MOVE      'A'           W@RCTP
     C                   MOVE      'N'           W#DBER            1
      *
     C     @FCLTY        CHAIN     FCLTY                              70
     C     *IN70         IFEQ      *ON
     C*******************MOVEL     W@CNUM        DBKEY
     C*******************MOVEL     'FCLTY'       DBFILE
     C*******************Z-ADD     14            DBASE
     C*******************EXSR      *PSSR
     C                   MOVE      'Y'           W#DBER
     C                   ENDIF
      *  B record
      *
     C     W#DBER        IFNE      'Y'
     C                   MOVE      'B'           W@RCTP
      *
     C     @FCLTY        CHAIN     FCLTY                              70
     C     *IN70         IFEQ      *ON
     C*******************MOVEL     W@CNUM        DBKEY
     C*******************MOVEL     'FCLTY'       DBFILE
     C*******************Z-ADD     15            DBASE
     C*******************EXSR      *PSSR
     C                   MOVE      'Y'           W#DBER
     C                   ENDIF
     C                   ENDIF
      *
     C                   EXSR      MSGFRMT
      *
      * If the journal image has been rolled back setup flag
      *
     C     JOENTT        IFEQ      'DR'
     C     JOENTT        OREQ      'UR'
     C                   MOVE      'R'           ROLLB
     C                   ENDIF
      *
     C     W#DBER        IFNE      'Y'
      *
      * Format and populate data
      *
      *
     C                   MOVE      RECI          W#RECI
      *
      *
      * Access Currency Codes for decimal places
     C                   MOVE      FCCY          W#CCY
     C                   EXSR      GETNBDP
      *
     C                   MOVE      CNUM          L0CNUM
     C                   MOVE      FACT          L0FACT
     C                   MOVE      FCNO          L0FCNO
     C                   MOVE      BRCA          L0BRCA
     C                   MOVE      ORBR          L0ORBR
     C                   MOVE      FCTI          L0FCTI
     C                   MOVE      FCCY          L0FCCY
      *
      *   Facility Amount
     C***********        MOVE      FAMT          ZFIELD
     C                   MOVE(P)   FAMT          ZFIELD
     C                   Z-ADD     A6NBDP        ZADEC
     C                   EXSR      ZEDIT
     C                   MOVE      ZFIELD        L0FAMT
      *
      *   Overline Percentage
     C*****              MOVE      OVPC          ZFIELD
     C                   MOVE(P)   OVPC          ZFIELD
     C*****              Z-ADD     2             ZADEC
     C                   Z-ADD     3             ZADEC
     C                   EXSR      ZEDIT
     C                   MOVE      ZFIELD        L0OVPC
      *   Approved Date
     C                   Z-ADD     DTAP          W#ZDAYN
     C                   EXSR      ZZA0140
     C*****              MOVEL     W#ZDATE8      L0DTAP
     C                   MOVEL     W#DATE8       L0DTAP
      *
      *   Expiry Date
     C                   Z-ADD     DTEX          W#ZDAYN
     C                   EXSR      ZZA0140
     C*****              MOVEL     W#ZDATE8      L0DTEX
     C                   MOVEL     W#DATE8       L0DTEX
      *
     C                   MOVE      RVCR          L0RVCR
     C                   MOVE      SECI          L0SECI
     C                   MOVE      MCCY          L0MCCY
     C                   MOVE      MCSI          L0MCSI
     C                   MOVE      MBFC          L0MBFC
     C                   MOVE      NACD          L0NACD
     C                   MOVE      CRSK          L0CRSK
      *
      *   Convert Date of Last Financial Statement to DDMMYYYY or MMDDYYYY
     C                   Z-ADD     DLFS          W#ZDAYN
     C                   EXSR      ZZA0140
     C*****              MOVEL     W#ZDATE8      L0DLFS
     C                   MOVEL     W#DATE8       L0DLFS
      *
      *   Nominal Rate
     C***********        MOVE      NOMR          ZFIELD                                       155432
     C                   MOVE(P)   NOMR          ZFIELD                                       155432
     C                   Z-ADD     7             ZADEC
     C                   EXSR      ZEDIT
     C                   MOVE      ZFIELD        L0NOMR
      *
      *   Review Date
     C                   Z-ADD     RVDT          W#ZDAYN
     C                   EXSR      ZZA0140
     C*****              MOVEL     W#ZDATE8      L0RVDT
     C                   MOVEL     W#DATE8       L0RVDT
      *
     C                   MOVE      RVFR          L0RVFR
     C     RVDY          IFNE      *ZEROS
     C                   MOVE      RVDY          L0RVDY
     C                   ELSE
     C                   MOVE      *BLANKS       L0RVDY
     C                   ENDIF
      *
     C                   EVAL      L0NAR1=       NAR1 +
     C                                           NAR2 +
     C                                           NAR3 +
     C                                           NAR4
      *
     C                   MOVE      ACOF          L0ACOF
      *                                                                                       CLE008
      * Loan Administrator Id                                                                 CLE008
     C                   MOVE      LAID          L0LAID                                       CLE008
      *                                                                                       CLE008
      * Assignment/Participation Indicator                                                    147261
     C                   MOVE      PASI          L0PASI                                       147261
      *                                                                                       147261
     C                   MOVE      PRFC          L0PRFC
     C                   MOVE      BTIN          L0BTIN
      *
     C     BLDY          IFNE      *ZEROS
     C                   MOVE      BLDY          L0BLDY
     C                   ELSE
     C                   MOVE      *BLANKS       L0BLDY
     C                   ENDIF
      *
     C                   MOVE      SYIN          L0SYIN
      *
     C*****ANUM*         IFNE      *ZEROS                                                     CSD027
     C     ANUM          IFNE      *BLANKS                                                    CSD027
     C                   MOVE      ANUM          L0ANUM
     C                   ELSE
     C                   MOVE      *BLANKS       L0ANUM
     C                   ENDIF
      *
     C                   MOVE      DTPS          L0DTPS
      *                                                                                       CLE028
     C                   IF        CLE028 = 'Y'                                               CLE028
     C                   EVAL      L0DTPX = DTPX                                              CLE028
     C                   ENDIF                                                                CLE028
      *                                                                                       CLE028
     C                   MOVE      RTPS          L0RTPS
      *
     C     RLPD          IFNE      *ZEROS
     C                   MOVE      RLPD          L0RLPD
     C                   ELSE
     C                   MOVE      *BLANKS       L0RLPD
     C                   ENDIF
      *
     C                   MOVE      DICB          L0DICB
     C                   MOVE      CSEL          L0CSEL
     C                   MOVE      ALCY          L0ALCY
      *
      *   Date Committed
     C                   Z-ADD     COMD          W#ZDAYN
     C                   EXSR      ZZA0140
     C*****              MOVEL     W#ZDATE8      L0COMD
     C                   MOVEL     W#DATE8       L0COMD
      *
      *   Closing Date
     C                   Z-ADD     CDTE          W#ZDAYN
     C                   EXSR      ZZA0140
     C*****              MOVEL     W#ZDATE8      L0CDTE
     C                   MOVEL     W#DATE8       L0CDTE
      *
      *   Last Available Date
     C                   Z-ADD     AVLD          W#ZDAYN
     C                   EXSR      ZZA0140
     C*****              MOVEL     W#ZDATE8      L0AVLD
     C                   MOVEL     W#DATE8       L0AVLD
      *
     C                   MOVE      LPTP          L0LPTP
      *
     C     LPBR          IFNE      *ZEROS
     C                   MOVE      LPBR          L0LPBR
     C                   ELSE
     C                   MOVE      *BLANKS       L0LPBR
     C                   ENDIF
      *
      *   Late Payment Penalty Amount
     C                   MOVE(P)   LPAM          ZFIELD
     C     LPTP          IFEQ      'A'
     C                   Z-ADD     A6NBDP        ZADEC
     C                   ELSE
     C                   Z-ADD     7             ZADEC
     C                   ENDIF
     C                   EXSR      ZEDIT
     C                   MOVE      ZFIELD        L0LPAM
      *
     C                   MOVE      LPPS          L0LPPS
      *
     C                   MOVE      DFTP          L0DFTP
     C                   MOVE      DFST          L0DFST
     C                   MOVE      TRCA          L0TRCA
      *
     C*****CANM*         IFNE      *ZEROS                                                     CSD027
     C     CANM          IFNE      *BLANKS                                                    CSD027
     C                   MOVE      CANM          L0CANM
     C                   ELSE
     C                   MOVE      *BLANKS       L0CANM
     C                   ENDIF
      *
     C     CAFT          IFNE      *ZEROS
     C                   MOVE      CAFT          L0CAFT
     C                   ELSE
     C                   MOVE      *BLANKS       L0CAFT
     C                   ENDIF
      *
     C     CAFN          IFNE      *ZEROS
     C                   MOVE      CAFN          L0CAFN
     C                   ELSE
     C                   MOVE      *BLANKS       L0CAFN
     C                   ENDIF
      *
     C     ACSQ          IFNE      *ZEROS
     C                   MOVE      ACSQ          L0ACSQ
     C                   ELSE
     C                   MOVE      *BLANKS       L0ACSQ
     C                   ENDIF
      *
     C                   MOVE      IUSR          L0IUSR
     C                   MOVE      AUSR          L0AUSR
     C                   MOVE      XUSR          L0XUSR
     C                   MOVE      SYCP          L0SYCP
     C                   MOVE      PRTR          L0PRTR
      *
     C*****PMFC*         IFNE      *ZEROS                                                     CSD027
     C     PMFC          IFNE      *BLANKS                                                    CSD027
     C                   MOVE      PMFC          L0PMFC
     C                   ELSE
     C                   MOVE      *BLANKS       L0PMFC
     C                   ENDIF
      *
     C     PMFT          IFNE      *ZEROS
     C                   MOVE      PMFT          L0PMFT
     C                   ELSE
     C                   MOVE      *BLANKS       L0PMFT
     C                   ENDIF
      *
     C     PMFN          IFNE      *ZEROS
     C                   MOVE      PMFN          L0PMFN
     C                   ELSE
     C                   MOVE      *BLANKS       L0PMFN
     C                   ENDIF
      *
     C*****INUM*         IFNE      *ZEROS                                                     CSD027
     C     INUM          IFNE      *BLANKS                                                    CSD027
     C                   MOVE      INUM          L0INUM
     C                   ELSE
     C                   MOVE      *BLANKS       L0INUM
     C                   ENDIF
      *
      *   Joining Date
     C                   Z-ADD     JDTE          W#ZDAYN
     C                   EXSR      ZZA0140
     C*****              MOVEL     W#ZDATE8      L0JDTE
     C                   MOVEL     W#DATE8       L0JDTE
      *
      *   Value Date
     C                   Z-ADD     VDTC          W#ZDAYN
     C                   EXSR      ZZA0140
     C*****              MOVEL     W#ZDATE8      L0VDTC
     C                   MOVEL     W#DATE8       L0VDTC
      *
     C                   MOVE      SHTP          L0SHTP
      *
      *   Syndicate Share Percentage
     C***********        MOVE      SHPC          ZFIELD                                       155432
     C                   MOVE(P)   SHPC          ZFIELD                                       155432
     C                   Z-ADD     12            ZADEC
     C                   EXSR      ZEDIT
     C                   MOVE      ZFIELD        L0SHPC
      *
     C                   MOVE      RCSI          L0RCSI
     C                   MOVE      SKIS          L0SKIS
      *
      *   Interest Skim
     C***********        MOVE      SKIR          ZFIELD                                       155432
     C                   MOVE(P)   SKIR          ZFIELD                                       155432
     C                   Z-ADD     7             ZADEC
     C                   EXSR      ZEDIT
     C                   MOVE      ZFIELD        L0SKIR
      *
     C                   MOVE      SKFS          L0SKFS
      *
      *   Fees Skim
     C***********        MOVE      SKFR          ZFIELD                                       155432
     C                   MOVE(P)   SKFR          ZFIELD                                       155432
     C                   Z-ADD     7             ZADEC
     C                   EXSR      ZEDIT
     C                   MOVE      ZFIELD        L0SKFR
      *
     C     PSTM          IFNE      *ZEROS
     C                   MOVE      PSTM          L0PSTM
     C                   ELSE
     C                   MOVE      *BLANKS       L0PSTM
     C                   ENDIF
      *
      *   Pay Our Nostro
     C                   EVAL      L0PONS=       OMDB+PONS
      *
     C                   MOVE      RVNO          L0RVNO
     C                   MOVE      CVMR          L0CVMR
      *
     C*****POCN*         IFNE      *ZEROS                                                     CSD027
     C     POCN          IFNE      *BLANKS                                                    CSD027
     C                   MOVE      POCN          L0POCN
     C                   ELSE
     C                   MOVE      *BLANKS       L0POCN
     C                   ENDIF
      *
     C*****POBN*         IFNE      *ZEROS                                                     CSD027
     C     POBN          IFNE      *BLANKS                                                    CSD027
     C                   MOVE      POBN          L0POBN
     C                   ELSE
     C                   MOVE      *BLANKS       L0POBN
     C                   ENDIF
      *
     C                   MOVE      RCRN          L0RCRN
     C                   MOVE      RCRA          L0RCRA
     C                   MOVE      PIBN          L0PIBN
     C                   MOVE      PIBA          L0PIBA
     C                   MOVE      AWBN          L0AWBN
     C                   MOVE      AWBA          L0AWBA
     C                   MOVE      BENN          L0BENN
     C                   MOVE      BENA          L0BENA
      *
     C     RSTM          IFNE      *ZEROS
     C*****              Z-ADD     RSTM          L0RSTM
     C                   MOVE      RSTM          L0RSTM
     C                   ELSE
     C                   MOVE      *BLANKS       L0RSTM
     C                   ENDIF
      *
      *   Receive our Nostro
     C                   EVAL      L0RONS=       OSDB+RONS
      *
     C*****ROCN*         IFNE      *ZEROS                                                     CSD027
     C     ROCN          IFNE      *BLANKS                                                    CSD027
     C                   MOVE      ROCN          L0ROCN
     C                   ELSE
     C                   MOVE      *BLANKS       L0ROCN
     C                   ENDIF
      *
     C*****ROBN*         IFNE      *ZEROS                                                     CSD027
     C     ROBN          IFNE      *BLANKS                                                    CSD027
     C                   MOVE      ROBN          L0ROBN
     C                   ELSE
     C                   MOVE      *BLANKS       L0ROBN
     C                   ENDIF
      *
     C                   MOVE      RIBN          L0RIBN
     C                   MOVE      RIBA          L0RIBA
      *
     C                   EVAL      L0DTP1=       DTP1 +
     C                                           DTP2 +
     C                                           DTP3 +
     C                                           DTP4
      *
     C                   MOVE      DCHG          L0DCHG
      *
     C                   EVAL      L0BTB1=       BTB1 +
     C                                           BTB2 +
     C                                           BTB3 +
     C                                           BTB4 +
     C                                           BTB5 +
     C                                           BTB6
      *
     C                   MOVE      RECI          L0RECI
      *
      * Revolvind Credit Indicator Last Change Date
     C                   Z-ADD     RVCD          W#ZDAYN
     C                   EXSR      ZZA0140
     C*****              MOVEL     W#ZDATE8      L0RVCD
     C                   MOVEL     W#DATE8       L0RVCD
      *
      *   Total Amount Drawn
     C**********         MOVE      TOTD          ZFIELD                                       155432
     C                   MOVE(P)   TOTD          ZFIELD                                       155432
     C                   Z-ADD     A6NBDP        ZADEC
     C                   EXSR      ZEDIT
     C                   MOVE      ZFIELD        L0TOTD
      *
      *   Current Exposure
     C**********         MOVE      CAMD          ZFIELD                                       155432
     C                   MOVE(P)   CAMD          ZFIELD                                       155432
     C                   Z-ADD     A6NBDP        ZADEC
     C                   EXSR      ZEDIT
     C                   MOVE      ZFIELD        L0CAMD
      *
      *   Previous Exposure
     C**********         MOVE      PEXP          ZFIELD                                       155432
     C                   MOVE(P)   PEXP          ZFIELD                                       155432
     C                   Z-ADD     A6NBDP        ZADEC
     C                   EXSR      ZEDIT
     C                   MOVE      ZFIELD        L0PEXP
      *
      *   Drawn Amount Day 1
     C**********         MOVE      OAM1          ZFIELD                                       155432
     C                   MOVE(P)   OAM1          ZFIELD                                       155432
     C                   Z-ADD     A6NBDP        ZADEC
     C                   EXSR      ZEDIT
     C                   MOVE      ZFIELD        L0OAM1
      *
      *   Drawn Amount Day 2
     C**********         MOVE      OAM2          ZFIELD                                       155432
     C                   MOVE(P)   OAM2          ZFIELD                                       155432
     C                   Z-ADD     A6NBDP        ZADEC
     C                   EXSR      ZEDIT
     C                   MOVE      ZFIELD        L0OAM2
      *
      *   Drawn Amount Day 3
     C**********         MOVE      OAM3          ZFIELD                                       155432
     C                   MOVE(P)   OAM3          ZFIELD                                       155432
     C                   Z-ADD     A6NBDP        ZADEC
     C                   EXSR      ZEDIT
     C                   MOVE      ZFIELD        L0OAM3
      *
      *   Drawn Amount Day 4
     C**********         MOVE      OAM4          ZFIELD                                       155432
     C                   MOVE(P)   OAM4          ZFIELD                                       155432
     C                   Z-ADD     A6NBDP        ZADEC
     C                   EXSR      ZEDIT
     C                   MOVE      ZFIELD        L0OAM4
      *
      *   Drawn Amount Day 5
     C**********         MOVE      OAM5          ZFIELD                                       155432
     C                   MOVE(P)   OAM5          ZFIELD                                       155432
     C                   Z-ADD     A6NBDP        ZADEC
     C                   EXSR      ZEDIT
     C                   MOVE      ZFIELD        L0OAM5
      *
      *   Drawn Amount Day 6
     C**********         MOVE      OAM6          ZFIELD                                       155432
     C                   MOVE(P)   OAM6          ZFIELD                                       155432
     C                   Z-ADD     A6NBDP        ZADEC
     C                   EXSR      ZEDIT
     C                   MOVE      ZFIELD        L0OAM6
      *
      *   Drawn Amount Day 7
     C**********         MOVE      OAM7          ZFIELD                                       155432
     C                   MOVE(P)   OAM7          ZFIELD                                       155432
     C                   Z-ADD     A6NBDP        ZADEC
     C                   EXSR      ZEDIT
     C                   MOVE      ZFIELD        L0OAM7
      *
      *   Drawn Amount Day 8
     C**********         MOVE      OAM8          ZFIELD                                       155432
     C                   MOVE(P)   OAM8          ZFIELD                                       155432
     C                   Z-ADD     A6NBDP        ZADEC
     C                   EXSR      ZEDIT
     C                   MOVE      ZFIELD        L0OAM8
      *
      *   Drawn Amount Day 9
     C**********         MOVE      OAM9          ZFIELD                                       155432
     C                   MOVE(P)   OAM9          ZFIELD                                       155432
     C                   Z-ADD     A6NBDP        ZADEC
     C                   EXSR      ZEDIT
     C                   MOVE      ZFIELD        L0OAM9
      *
      *   Drawn Amount Day 10
     C**********         MOVE      OA10          ZFIELD                                       155432
     C                   MOVE(P)   OA10          ZFIELD                                       155432
     C                   Z-ADD     A6NBDP        ZADEC
     C                   EXSR      ZEDIT
     C                   MOVE      ZFIELD        L0OA10
      *
     C                   MOVE      FSTS          L0FSTS
     C                   MOVE      PCRF          L0PCRF
      *                                                                                       CEU030
      **  Settlement Currency and IN Currency in Fld 72                                       CEU030
     C     CEU004        IFEQ      'Y'                                                        CEU030
     C                   MOVE      SCCY          L0SCCY                                       CEU030
     C                   MOVE      ICCY          L0ICCY                                       CEU030
     C                   ENDIF                                                                CEU030
      *                                                                                       CEU030
     C***********        MOVEL     PCOB          X1FIL1
     C                   MOVEL     F#MPCOB       X1FIL1
     C                   MOVE      FILLER        X1FIL1
      *                                                                                       130237
     C                   MOVE      CMDI          L0CMDI                                       130237
      *                                                                                       130237
     C     CAXR          IFNE      *ZEROS                                                     130237
     C*****              MOVE      CAXR          L0CAXR                                 130237133384
     C                   MOVE(P)   CAXR          ZFIELD                                       133384
     C                   Z-ADD     8             ZADEC                                        133384
     C                   EXSR      ZEDIT                                                      133384
     C                   MOVE      ZFIELD        L0CAXR                                       133384
     C                   ELSE                                                                 130237
     C                   MOVE      *BLANKS       L0CAXR                                       130237
     C                   ENDIF                                                                130237
      *                                                                                       CLE023
      ** Format new field for Current exposure (CEXP) if CLE023 is on                         CLE023
      *                                                                                       CLE023
     C                   IF        CLE023  = 'Y'                                              CLE023
     C                   MOVE(P)   CEXP          ZFIELD                                       CLE023
     C                   Z-ADD     A6NBDP        ZADEC                                        CLE023
     C                   EXSR      ZEDIT                                                      CLE023
     C                   MOVE      ZFIELD        L0CEXP                                       CLE023
     C                   ENDIF                                                                CLE023
      *                                                                                       CLE031
     C                   IF        CLE031 = 'Y'                                               CLE031
      *                                                                                       CLE031
      * Co-Agent                                                                              CLE031
     C                   EVAL      L0COAG = COAG                                              CLE031
      *                                                                                       CLE031
      * Facility Agent                                                                        CLE031
     C                   EVAL      L0FCAG = FCAG                                              CLE031
      *                                                                                       CLE031
      * Paying/Handling agent                                                                 CLE031
     C                   EVAL      L0PHAG = PHAG                                              CLE031
      *                                                                                       CLE031
      * Security Agent                                                                        CLE031
     C                   EVAL      L0SCAG = SCAG                                              CLE031
      *                                                                                       CLE031
      * (Receive) Settlement Currency                                                         CLE031
     C                   EVAL      L0SCCY = SCCY                                              CLE031
      *                                                                                       CLE031
      * Receive Settlement Ccy. Exchange Rate                                                 CLE031
     C                   Z-ADD     8             ZADEC                                        CLE031
     C                   MOVE      *BLANKS       ZFIELD                                       CLE031
     C                   MOVE      REXR          ZFIELD                                       CLE031
     C                   EXSR      ZEDIT                                                      CLE031
     C                   MOVE      ZFIELD        L0REXR                                       CLE031
      *                                                                                       CLE031
      * Receive Settlement Ccy. Exchange Rate Indicator                                       CLE031
     C                   EVAL      L0REXI = REXI                                              CLE031
      *                                                                                       CLE031
      * Pay Settlement Currency                                                               CLE031
     C                   EVAL      L0PSCY = PSCY                                              CLE031
      *                                                                                       CLE031
      * Pay Settlement Ccy. Exchange Rate                                                     CLE031
     C                   Z-ADD     8             ZADEC                                        CLE031
     C                   MOVE      *BLANKS       ZFIELD                                       CLE031
     C                   MOVE      PEXR          ZFIELD                                       CLE031
     C                   EXSR      ZEDIT                                                      CLE031
     C                   MOVE      ZFIELD        L0PEXR                                       CLE031
      *                                                                                       CLE031
      * Pay Settlement Ccy. Exchange Rate Indicator                                           CLE031
     C                   EVAL      L0PEXI = PEXI                                              CLE031
     C                   ENDIF                                                                CLE031
      *                                                                                       CLE034
      ** Setup Overline Amount                                                                CLE034
      *                                                                                       CLE034
     C     CLE034        IFEQ      'Y'                                                        CLE034
     C                   MOVE(P)   OVAM          ZFIELD                                       CLE034
     C                   Z-ADD     A6NBDP        ZADEC                                        CLE034
     C                   EXSR      ZEDIT                                                      CLE034
     C                   MOVE      ZFIELD        L0OVAM                                       CLE034
     C                   ENDIF                                                                CLE034
      *
      *
      *
      * Move message format
     C                   MOVEL(P)  DWL0MF        W#MFMT
      *
     C                   ELSE
      *
     C                   MOVE      *BLANKS       DWL0MF
     C************       MOVE      CNUM          L0CNUM                                       132273
     C************       MOVE      FACT          L0FACT                                       132273
     C************       MOVE      FCNO          L0FCNO                                       132273
     C                   MOVE      W@CNUM        L0CNUM                                       132273
     C                   MOVE      W@FACT        L0FACT                                       132273
     C                   MOVE      W@FCNO        L0FCNO                                       132273
     C************       MOVE      CNUM          L0CNUM                                      184695
     C************       MOVE      FACT          L0FACT                                      184695
     C************       MOVE      FCNO          L0FCNO                                      184695
     C                   MOVE      FILLER        X1FIL1
     C                   MOVEL     F#MPCOB       X1FIL1
     C                   MOVEL(P)  DWL0MF        W#MFMT
      *
     C                   ENDIF
      *
      * Put Message
      *  Supress message for non-rollbacks (PT/UP etc)) of a rolled back                      132273
      *  unit of work                                                                         132273
      *                                                                                       132273
     C     *IN70         IFEQ      *ON                                                        132273
     C     ROLLB         ANDNE     'R'                                                        132273
     C                   ELSE                                                                 132273
     C                   EXSR      PMQPUT
     C                   ENDIF                                                                132273
      *
     C                   MOVE      *BLANKS       STK(@Q)
     C                   SUB       1             @Q
      *
     C                   ENDSR
      **********************************************************************
      * Set up Transmitted Message Format for CLOANCL/CLOANCK
      **********************************************************************
     C     P#DLLN        BEGSR
      *
     C                   ADD       1             @Q
     C                   MOVEL     'P#DLLN'      STK(@Q)
      *
      * Downloaded msg is derived from 2 Midas files. Journal entry will
      * contain one of these records, need to access the other.
      *
     C     JFILE         IFEQ      'CLOANCL'
      *
      * Retrieve the data from the file image and move into DS for CLOANCL
      * start pos: 126, length: 1187(A)
      *
     C                   EVAL      W#FSIZ=%SIZE(CLOANL)
     C                   EVAL      CLOANL=%SUBST(P#PARM1:126:W#FSIZ)
      *
     C                   MOVE      F#LLNRF       W@LNRF
      *
     C                   ELSE
      *
      * Retrieve the data from the file image and move into DS for CLOANCK
      * start pos: 126, length: 44
      *
     C                   EVAL      W#FSIZ=%SIZE(CLOANK)
     C                   EVAL      CLOANK=%SUBST(P#PARM1:126:W#FSIZ)
      *
     C                   MOVE      F#KLNRF       W@LNRF
      *
     C                   ENDIF
      *  A record
      *
     C                   MOVE      'A'           W@RCDT
     C                   MOVE      'N'           W#DBER
      *
     C     @CLOAN        CHAIN     CLOAN                              70
     C     *IN70         IFEQ      *ON
     C*******************MOVEL     F#LLNRF       DBKEY
     C*******************MOVEL     'CLOAN'       DBFILE
     C*******************Z-ADD     16            DBASE
     C*******************EXSR      *PSSR
     C                   MOVE      'Y'           W#DBER
     C                   ENDIF
      *  B record
      *
     C     W#DBER        IFNE      'Y'
     C                   MOVE      'B'           W@RCDT
      *
     C     @CLOAN        CHAIN     CLOAN                              70
     C     *IN70         IFEQ      *ON
     C*******************MOVEL     F#KLNRF       DBKEY
     C*******************MOVEL     'CLOAN'       DBFILE
     C*******************Z-ADD     17            DBASE
     C*******************EXSR      *PSSR
     C                   MOVE      'Y'           W#DBER
     C                   ENDIF
     C                   ENDIF
      *
     C                   EXSR      MSGFRMT
      *
      * If the journal image has been rolled back setup flag
      *
     C     JOENTT        IFEQ      'DR'
     C     JOENTT        OREQ      'UR'
     C                   MOVE      'R'           ROLLB
     C                   ENDIF
      *
     C     W#DBER        IFNE      'Y'
      *
      * Format and populate data
      *
     C                   MOVE      RECI          W#RECI
      *
      * Access Currency Codes for decimal places
     C                   MOVE      CCY           W#CCY
     C                   EXSR      GETNBDP
     C                   MOVE      A6NBDP        W#CCYDP
      *
      * Access Currency Codes for decimal places for Facility Currency
     C                   MOVE      FCCY          W#CCY
     C                   EXSR      GETNBDP
     C                   MOVE      A6NBDP        W#FCCYDP
      * New Currency?
      * Access Currency Codes for decimal places for New Currency
     C     NCCY          IFNE      *BLANKS
     C                   MOVE      NCCY          W#CCY
     C                   EXSR      GETNBDP
     C                   MOVE      A6NBDP        W#NCCYDP
     C                   ENDIF
      * Access Currency Codes for decimal places for Local Currency
     C                   MOVE      BJLCCY        W#CCY
     C                   EXSR      GETNBDP
     C                   MOVE      A6NBDP        W#LCCYDP
      *
     C                   MOVE      LNRF          L1LNRF
     C                   MOVE      CNUM          L1CNUM
     C                   MOVE      BRCA          L1BRCA
     C                   MOVE      ORBR          L1ORBR
     C                   MOVE      LTYP          L1LTYP
     C                   MOVE      SUTP          L1SUTP
      *   Deal Date
     C                   Z-ADD     DDAT          W#ZDAYN
     C                   EXSR      ZZA0140
     C*****              MOVEL     W#ZDATE8      L1DDAT
     C                   MOVEL     W#DATE8       L1DDAT
      *   Value Date
     C                   Z-ADD     VDAT          W#ZDAYN
     C                   EXSR      ZZA0140
     C*****              MOVEL     W#ZDATE8      L1VDAT
     C                   MOVEL     W#DATE8       L1VDAT
      *   Maturity Date
     C                   Z-ADD     MDAT          W#ZDAYN
     C                   EXSR      ZZA0140
     C*****              MOVEL     W#ZDATE8      L1MDAT
     C                   MOVEL     W#DATE8       L1MDAT
      *
     C                   MOVE      FCUS          L1FCUS
     C                   MOVE      FTYP          L1FTYP
     C                   MOVE      FSEQ          L1FSEQ
     C                   MOVE      CCY           L1CCY
      *   Loan Amount
     C                   MOVE(P)   CPAM          ZFIELD
     C                   Z-ADD     W#CCYDP       ZADEC
     C                   EXSR      ZEDIT
     C                   MOVE      ZFIELD        L1CPAM
      *
     C                   MOVE      AUTO          L1AUTO
     C                   MOVE      APMI          L1APMI
     C                   MOVE      BOKC          L1BOKC
     C                   MOVE      PTFR          L1PTFR
     C                   MOVE      PRFC          L1PRFC
     C                   MOVE      LASQ          L1LASQ
     C                   MOVE      INTC          L1INTC
     C                   MOVE      ADDI          L1ADDI
      *
     C     ICBS          IFNE      *ZEROS
     C                   MOVE      ICBS          L1ICBS
     C                   ELSE
     C                   MOVE      *BLANKS       L1ICBS
     C                   ENDIF
      *
     C     BRTT          IFNE      *ZEROS
     C                   MOVE      BRTT          L1BRTT
     C                   ELSE
     C                   MOVE      *BLANKS       L1BRTT
     C                   ENDIF
      *
      *   Rate/Spread
     C                   MOVE(P)   RTSP          ZFIELD
     C                   Z-ADD     7             ZADEC
     C                   EXSR      ZEDIT
     C                   MOVE      ZFIELD        L1RTSP
      *
     C                   MOVE      SPIN          L1SPIN
     C                   MOVE      CHIN          L1CHIN
      *   Margin
     C                   MOVE(P)   MARG          ZFIELD
     C                   Z-ADD     5             ZADEC
     C                   EXSR      ZEDIT
     C                   MOVE      ZFIELD        L1MARG
      *   Margin Sign
     C***********        MOVE      '+'           L1NMI
     C                   MOVE      ' '           L1NMI
     C     MARG          IFLT      *ZERO
     C***********        MOVE      '-'           L1NMI
     C                   MOVE      'Y'           L1NMI
     C                   MULT      -1            MARG                                         148756
     C                   MOVE(P)   MARG          ZFIELD                                       148756
     C                   Z-ADD     5             ZADEC                                        148756
     C                   EXSR      ZEDIT                                                      148756
     C                   MOVE      ZFIELD        L1MARG                                       148756
     C                   ENDIF
      *
     C                   MOVE      RDFC          L1RDFC
     C                   MOVE      WTIN          L1WTIN
      *
      *   Withholding Tax Rate
     C                   MOVE(P)   WTRT          ZFIELD
     C                   Z-ADD     7             ZADEC
     C                   EXSR      ZEDIT
     C                   MOVE      ZFIELD        L1WTRT
      *
     C                   MOVE      IPFR          L1IPFR
      *
     C     IFDY          IFNE      *ZEROS
     C                   MOVE      IFDY          L1IFDY
     C                   ELSE
     C                   MOVE      *BLANKS       L1IFDY
     C                   ENDIF
      *
      *
      *   Next Interest Payment Date
     C                   Z-ADD     NIDT          W#ZDAYN
     C                   EXSR      ZZA0140
     C*****              MOVEL     W#ZDATE8      L1NIDT
     C                   MOVEL     W#DATE8       L1NIDT
      *                                                                                       CLE028
      ** If CLE028 is on, format Add on interest, Add on charges, Charge amount,              CLE028
      ** Include charges in interest, Total flat interest, and First repayment date           CLE028
      *                                                                                       CLE028
     C                   IF        CLE028 = 'Y'                                               CLE028
     C                   EVAL      L1ADIF = ADIF                                              CLE028
     C                   EVAL      L1ADCF = ADCF                                              CLE028
     C                   EVAL      ZFIELD = *BLANKS                                           CLE028
     C                   Z-ADD     A6NBDP        ZADEC                                        CLE028
     C                   MOVE      CHGA          ZFIELD                                       CLE028
     C                   EXSR      ZEDIT                                                      CLE028
     C                   MOVE      ZFIELD        L1CHGA                                       CLE028
     C                   EVAL      L1ICIF = ICIF                                              CLE028
     C                   EVAL      ZFIELD = *BLANKS                                           CLE028
     C                   MOVE      FLTI          ZFIELD                                       CLE028
     C                   EXSR      ZEDIT                                                      CLE028
     C                   MOVE      ZFIELD        L1FLTI                                       CLE028
     C                   Z-ADD     FRPD          W#ZDAYN                                      CLE028
     C                   EXSR      ZZA0140                                                    CLE028
     C                   MOVEL     W#DATE8       L1FRPD                                       CLE028
     C                   ENDIF                                                                CLE028
     C                   Z-ADD     ORED          W#ZDAYN                                      CLE028
     C                   EXSR      ZZA0140                                                    CLE028
     C                   MOVEL     W#DATE8       L1ORED                                       CLE028
      *
     C     REPT          IFNE      *ZEROS
     C                   MOVE      REPT          L1REPT
     C                   ELSE
     C                   MOVE      *BLANKS       L1REPT
     C                   ENDIF
      *
      *   Loan Currency Repayment Amount
     C                   MOVE(P)   RAMT          ZFIELD
     C                   Z-ADD     W#CCYDP       ZADEC
     C                   EXSR      ZEDIT
     C                   MOVE      ZFIELD        L1RAMT
      *
     C                   MOVE      RFRQ          L1RFRQ
      *
     C     RDYN          IFNE      *ZEROS
     C                   MOVE      RDYN          L1RDYN
     C                   ELSE
     C                   MOVE      *BLANKS       L1RDYN
     C                   ENDIF
      *
      *   Next Repayment Date
     C                   Z-ADD     NRPD          W#ZDAYN
     C                   EXSR      ZZA0140
     C*****              MOVEL     W#ZDATE8      L1NRPD
     C                   MOVEL     W#DATE8       L1NRPD
      *
     C*****LIND*         IFNE      *ZEROS                                                     CER020
     C     LOIC          IFNE      *BLANKS                                                    CER020
     C**********         MOVE      LIND          L1LIND                                       CER020
     C                   MOVE      LOIC          L1LIND                                       CER020
     C                   ELSE
     C                   MOVE      *BLANKS       L1LIND
     C                   ENDIF
      *
     C     FRBC          IFNE      *ZEROS
     C                   MOVE      FRBC          L1FRBC
     C                   ELSE
     C                   MOVE      *BLANKS       L1FRBC
     C                   ENDIF
      *
     C                   MOVE      CRSK          L1CRSK
     C                   MOVE      ACOF          L1ACOF
     C                   MOVE      NACD          L1NACD
      *   Fees Indicator
     C                   TESTB     '2'           RELI                     85
     C                   MOVEL     'N'           L1FEEI
     C     *IN85         IFEQ      *ON
     C                   MOVEL     'Y'           L1FEEI
     C                   ENDIF
      *   Documents Indicator
     C                   TESTB     '1'           RELI                     85
     C                   MOVEL     'N'           L1DOCI
     C     *IN85         IFEQ      *ON
     C                   MOVEL     'Y'           L1DOCI
     C                   ENDIF
      *
      *   Secured Indicator
     C                   TESTB     '0'           RELI                     85
     C                   MOVEL     'N'           L1SECI
     C     *IN85         IFEQ      *ON
     C                   MOVEL     'Y'           L1SECI
     C                   ENDIF
      *
      *   Loan Description
     C                   EVAL      L1LDSC=       NAR1 +
     C                                           NAR2 +
     C                                           NAR3 +
     C                                           NAR4
      *
     C                   MOVE      BMDI          L1BMDI
      *
      *   Base Currency Exchange Rate
     C                   MOVE(P)   BCXR          ZFIELD
     C                   Z-ADD     8             ZADEC
     C                   EXSR      ZEDIT
     C                   MOVE      ZFIELD        L1BCXR
      *
     C                   MOVE      FMDI          L1FMDI
      *
      *   Facility Currency Exchange Rate
     C                   MOVE(P)   FCXR          ZFIELD
     C                   Z-ADD     8             ZADEC
     C                   EXSR      ZEDIT
     C                   MOVE      ZFIELD        L1FCXR
      *
     C*****RECE*         IFNE      *ZEROS                                                     CSD027
     C     RECE          IFNE      *BLANKS                                                    CSD027
     C                   MOVE      RECE          L1RECE
     C                   ELSE
     C                   MOVE      *BLANKS       L1RECE
     C                   ENDIF
      *
     C*****COCU*         IFNE      *ZEROS                                                     CSD027
     C     COCU          IFNE      *BLANKS                                                    CSD027
     C                   MOVE      COCU          L1COCU
     C                   ELSE
     C                   MOVE      *BLANKS       L1COCU
     C                   ENDIF
      *
      *   Original Maturity Date
     C                   Z-ADD     OMDT          W#ZDAYN
     C                   EXSR      ZZA0140
     C*****              MOVEL     W#ZDATE8      L1OMDT
     C                   MOVEL     W#DATE8       L1OMDT
      *
     C                   MOVE      RLFQ          L1RLFQ
      *
     C     RLDY          IFNE      *ZEROS
     C                   MOVE      RLDY          L1RLDY
     C                   ELSE
     C                   MOVE      *BLANKS       L1RLDY
     C                   ENDIF
      *
      *   Rollover Date
     C                   Z-ADD     RLDT          W#ZDAYN
     C                   EXSR      ZZA0140
     C*****              MOVEL     W#ZDATE8      L1RLDT
     C                   MOVEL     W#DATE8       L1RLDT
      *
     C                   MOVE      BTIN          L1BTIN
      *
     C     BLDY          IFNE      *ZEROS
     C                   MOVE      BLDY          L1BLDY
     C                   ELSE
     C                   MOVE      *BLANKS       L1BLDY
     C                   ENDIF
      *                                                                                       CLE011
      ** Rollover Fix Days                                                                    CLE011
      *                                                                                       CLE011
     C                   IF        CLE011 = 'Y'                                               CLE011
     C                   EVAL      L1RFDY = RFDY                                              CLE011
     C                   EVAL      L1RFRI = RFRI                                              CLE011
     C                   EVAL      L1RFAR = RFAR                                              CLE011
     C                   MOVE      *Blanks       ZField                                       CLE011
     C                   MOVE      RFRT          ZField                                       CLE011
     C                   Z-Add     7             ZADEC                                        CLE011
     C                   EXSR      ZEDIT                                                      CLE011
     C                   MOVE      ZField        L1RFRT                                       CLE011
     C                   ENDIF                                                                CLE011
      *
     C                   MOVE      RCSI          L1RCSI
     C                   MOVE      '000000'      L1ORBO                                       125697
     C                   MOVE      '000000'      L1SLNO                                       125697
      *                                                                                       125697
     C     PTYP          IFEQ      64                                                         125697
     C     PTYP          OREQ      65                                                         125697
     C     PTYP          OREQ      68                                                         134078
     C     PTYP          OREQ      71                                                         134078
     C                   MOVE      OLNO          L1ORBO
     C                   ELSE                                                                 125697
     C     PTYP          IFEQ      66                                                         125697
     C     PTYP          OREQ      67                                                         125697
     C     PTYP          OREQ      69                                                         134078
     C     PTYP          OREQ      72                                                         134078
     C                   MOVE      OLNO          L1SLNO
     C                   ENDIF                                                                125697
     C                   ENDIF                                                                125697
      *                                                                                       125697
     C     MLNR          IFNE      *ZEROS
     C                   MOVE      MLNR          L1SLNO
     C                   ENDIF
      *
      *   Funding Rate/Spread
     C     FSRP          IFNE      *ZEROS                                       156466
     C                   MOVE(P)   FSRP          ZFIELD
     C                   Z-ADD     7             ZADEC
     C                   EXSR      ZEDIT
     C                   MOVE      ZFIELD        L1FSRP
     C                   ELSE                                                   156466
     C                   MOVE      *BLANKS       L1FSRP                         156466
     C                   ENDIF                                                  156466
      *
     C                   MOVE      FSGN          L1FSGN
     C                   MOVE      FPRC          L1FPRC
     C                   EVAL      L1SPI1=       SPI1 +
     C                                           SPI2 +
     C                                           SPI3
      *
     C     PSTM          IFNE      *ZEROS
     C                   MOVE      PSTM          L1PSTM
     C                   ELSE
     C                   MOVE      *BLANKS       L1PSTM
     C                   ENDIF
      *   Pay Our Nostro
     C     PTYP          IFEQ      66                                                         167146
     C     PTYP          OREQ      67                                                         167146
     C     PTYP          OREQ      69                                                         167146
     C     PTYP          OREQ      72                                                         167146
     C                   EVAL      L1PONS=       OMDB+PONS                                    167146
     C                   ELSE                                                                 167146
     C                   EVAL      L1PONS=       OSDB+PONS
     C                   ENDIF                                                                167146
      *
     C                   MOVE      RVNO          L1RVNO
     C                   MOVE      CVMR          L1CVMR
      *
     C*****POCN*         IFNE      *ZEROS                                                     CSD027
     C     POCN          IFNE      *BLANKS                                                    CSD027
     C                   MOVE      POCN          L1POCN
     C                   ELSE
     C                   MOVE      *BLANKS       L1POCN
     C                   ENDIF
      *
     C*****POBN*         IFNE      *ZEROS                                                     CSD027
     C     POBN          IFNE      *BLANKS                                                    CSD027
     C                   MOVE      POBN          L1POBN
     C                   ELSE
     C                   MOVE      *BLANKS       L1POBN
     C                   ENDIF
      *
     C                   MOVE      RCRN          L1RCRN
     C                   MOVE      RCRA          L1RCRA
     C                   MOVE      PIBN          L1PIBN
     C                   MOVE      PIBA          L1PIBA
     C                   MOVE      AWBN          L1AWBN
     C                   MOVE      AWBA          L1AWBA
     C                   MOVE      BENN          L1BENN
     C                   MOVE      BENA          L1BENA
      *
     C     RSTM          IFNE      *ZEROS
     C                   MOVE      RSTM          L1RSTM
     C                   ELSE
     C                   MOVE      *BLANKS       L1RSTM
     C                   ENDIF
      *
      *   Receive Our Nostro
     C     PTYP          IFEQ      66                                                         167146
     C     PTYP          OREQ      67                                                         167146
     C     PTYP          OREQ      69                                                         167146
     C     PTYP          OREQ      72                                                         167146
     C                   EVAL      L1RONS=       OSDB+RONS                                    167146
     C                   ELSE                                                                 167146
     C                   EVAL      L1RONS=       OMDB+RONS
     C                   ENDIF                                                                167146
      *
     C*****ROCN*         IFNE      *ZEROS                                                     CSD027
     C     ROCN          IFNE      *BLANKS                                                    CSD027
     C                   MOVE      ROCN          L1ROCN
     C                   ELSE
     C                   MOVE      *BLANKS       L1ROCN
     C                   ENDIF
      *
     C*****ROBN*         IFNE      *ZEROS                                                     CSD027
     C     ROBN          IFNE      *BLANKS                                                    CSD027
     C                   MOVE      ROBN          L1ROBN
     C                   ELSE
     C                   MOVE      *BLANKS       L1ROBN
     C                   ENDIF
      *
     C                   MOVE      RIBN          L1RIBN
     C                   MOVE      RIBA          L1RIBA
      *
      *   Details of Payments
     C                   EVAL      L1DTP1=       DTP1 +
     C                                           DTP2 +
     C                                           DTP3 +
     C                                           DTP4
      *
     C                   MOVE      DCHG          L1DCHG
      *
      *   Bank to Bank Information
     C                   EVAL      L1BTB1=       BTB1 +
     C                                           BTB2 +
     C                                           BTB3 +
     C                                           BTB4 +
     C                                           BTB5 +
     C                                           BTB6
      *
     C                   MOVE      LNKS          L1LNKS
     C                   MOVE      GASS          L1GASS
     C                   MOVE      DFTP          L1DFTP
     C                   MOVE      DFST          L1DFST
     C                   MOVE      MCRA          L1MCRA
      *
      *   Facility Currency Repayment Amount
     C                   MOVE(P)   FCRA          ZFIELD
     C                   Z-ADD     W#FCCYDP      ZADEC
     C                   EXSR      ZEDIT
     C                   MOVE      ZFIELD        L1FCRA
      *
     C                   MOVE      PDDI          L1PDDI
     C                   MOVE      PTDI          L1PTDI
      *
     C     GDPR          IFNE      *ZEROS
     C                   MOVE      GDPR          L1GDPR
     C                   ELSE
     C                   MOVE      *BLANKS       L1GDPR
     C                   ENDIF
      *
     C     GDIN          IFNE      *ZEROS
     C                   MOVE      GDIN          L1GDIN
     C                   ELSE
     C                   MOVE      *BLANKS       L1GDIN
     C                   ENDIF
      *
     C                   MOVE      GPRT          L1GPRT
      *
     C     TOLN          IFNE      *ZEROS
     C                   MOVE      TOLN          L1TOLN
     C                   ELSE
     C                   MOVE      *BLANKS       L1TOLN
     C                   ENDIF
      *
     C                   MOVE      IUSR          L1IUSR
     C                   MOVE      AUSR          L1AUSR
     C                   MOVE      XUSR          L1XUSR
     C                   MOVE      RECI          L1RECI
     C                   MOVE      PTYP          L1PTYP
      *   Interest Rate
     C                   MOVE(P)   INTR          ZFIELD
     C                   Z-ADD     7             ZADEC
     C                   EXSR      ZEDIT
     C                   MOVE      ZFIELD        L1INTR
      *
      *   Current Base Rate
     C                   MOVE(P)   BRTE          ZFIELD
     C                   Z-ADD     7             ZADEC
     C                   EXSR      ZEDIT
     C                   MOVE      ZFIELD        L1BRTE
      *
     C                   MOVE      FCCY          L1FCCY
     C                   MOVE      FCLB          L1FCLB
      *
      *   Part Sold Amount
     C                   MOVE(P)   PSAM          ZFIELD
     C                   Z-ADD     W#CCYDP       ZADEC
     C                   EXSR      ZEDIT
     C                   MOVE      ZFIELD        L1PSAM
      *
     C                   MOVE      NOPS          L1NOPS
      *
      *   Accrued Withholding Tax Posted
     C                   MOVE(P)   AWTP          ZFIELD
     C                   Z-ADD     W#CCYDP       ZADEC
     C                   EXSR      ZEDIT
     C                   MOVE      ZFIELD        L1AWTP
      *
      *   Withholding Tax Received to Date
     C                   MOVE(P)   WTRD          ZFIELD
     C                   Z-ADD     W#CCYDP       ZADEC
     C                   EXSR      ZEDIT
     C                   MOVE      ZFIELD        L1WTRD
      *
      *   Withholding Tax Written Off to Date
     C                   MOVE(P)   WTWD          ZFIELD
     C                   Z-ADD     W#CCYDP       ZADEC
     C                   EXSR      ZEDIT
     C                   MOVE      ZFIELD        L1WTWD
      *
      *   Interest Written Off to Date
     C                   MOVE(P)   IWOD          ZFIELD
     C                   Z-ADD     W#CCYDP       ZADEC
     C                   EXSR      ZEDIT
     C                   MOVE      ZFIELD        L1IWOD
      *
      *   Principal Written Off to Date
     C                   MOVE(P)   PWOD          ZFIELD
     C                   Z-ADD     W#CCYDP       ZADEC
     C                   EXSR      ZEDIT
     C                   MOVE      ZFIELD        L1PWOD
      *
      *   Past Due Interest Amount
     C                   MOVE(P)   PDIN          ZFIELD
     C                   Z-ADD     W#CCYDP       ZADEC
     C                   EXSR      ZEDIT
     C                   MOVE      ZFIELD        L1PDIN
      *
      *   Total Interest
     C                   MOVE(P)   TOTI          ZFIELD
     C                   Z-ADD     W#CCYDP       ZADEC
     C                   EXSR      ZEDIT
     C                   MOVE      ZFIELD        L1TOTI
      *
      *   Start Date or Last Interest Date
     C                   Z-ADD     SLID          W#ZDAYN
     C                   EXSR      ZZA0140
     C*****              MOVEL     W#ZDATE8      L1SLID
     C                   MOVEL     W#DATE8       L1SLID
      *
      *   Accrued Interest Posted to Date
     C                   MOVE(P)   AIPD          ZFIELD
     C                   Z-ADD     W#CCYDP       ZADEC
     C                   EXSR      ZEDIT
     C                   MOVE      ZFIELD        L1AIPD
      *
      *   Date of Last Rate Change
     C                   Z-ADD     DLRC          W#ZDAYN
     C                   EXSR      ZZA0140
     C*****              MOVEL     W#ZDATE8      L1DLRC
     C                   MOVEL     W#DATE8       L1DLRC
      *
      *   Interest Accrual Control Date
     C                   Z-ADD     IACD          W#ZDAYN
     C                   EXSR      ZZA0140
     C*****              MOVEL     W#ZDATE8      L1IACD
     C                   MOVEL     W#DATE8       L1IACD
      *
      *   Accrued Interest to Control Date
     C                   MOVE(P)   AITC          ZFIELD
     C                   Z-ADD     W#CCYDP       ZADEC
     C                   EXSR      ZEDIT
     C                   MOVE      ZFIELD        L1AITC
      *
      *   Total Fees Paid
     C                   MOVE(P)   TFEP          ZFIELD
     C                   Z-ADD     W#CCYDP       ZADEC
     C                   EXSR      ZEDIT
     C                   MOVE      ZFIELD        L1TFEP
      *
      *   Accrued Interest Adjustment Posted
     C                   MOVE(P)   AIAP          ZFIELD
     C                   Z-ADD     W#CCYDP       ZADEC
     C                   EXSR      ZEDIT
     C                   MOVE      ZFIELD        L1AIAP
      *
      *   Interest Paid/Received to Date
     C                   IF        CLE028 = 'N'                                               CLE028
     C                             OR CLE028 = 'Y' AND PTYP <> 80                             CLE028
     C                             OR CLE028='Y' AND PTYP = 80 AND ADIF <> 'Y'                CLE028
     C                   MOVE(P)   IPRD          ZFIELD
     C                   ELSE                                                                 CLE028
     C                   MOVE      *BLANKS       ZFIELD                                       CLE028
     C                   ENDIF                                                                CLE028
     C                   Z-ADD     W#CCYDP       ZADEC
     C                   EXSR      ZEDIT
     C                   MOVE      ZFIELD        L1IPRD
      *
      *   Interest Paid/Received This Month
     C                   MOVE(P)   IPRM          ZFIELD
     C                   Z-ADD     W#CCYDP       ZADEC
     C                   EXSR      ZEDIT
     C                   MOVE      ZFIELD        L1IPRM
      *
      *   Interest Capitalised to Date
     C                   MOVE(P)   ICTD          ZFIELD
     C                   Z-ADD     W#CCYDP       ZADEC
     C                   EXSR      ZEDIT
     C                   MOVE      ZFIELD        L1ICTD
      *
      *   Accrued Interest Manual Adjustment Posted
     C                   MOVE(P)   AIMN          ZFIELD
     C                   Z-ADD     W#CCYDP       ZADEC
     C                   EXSR      ZEDIT
     C                   MOVE      ZFIELD        L1AIMN
      *
      *   Loan Special Instruction Indicator
     C                   TESTB     '0'           LONI                     85
     C                   MOVEL     'N'           L1LSII
     C     *IN85         IFEQ      *ON
     C                   MOVEL     'Y'           L1LSII
     C                   ENDIF
      *
      *   Loan Total Interest Override Indicator
     C                   TESTB     '2'           LONI                     85
     C                   MOVEL     'N'           L1LTIO
     C     *IN85         IFEQ      *ON
     C                   MOVEL     'Y'           L1LTIO
     C                   ENDIF
      *
      *   Loan Stop Accruals Indicator
     C                   TESTB     '3'           LONI                     85
     C                   MOVEL     'N'           L1LSAI
     C     *IN85         IFEQ      *ON
     C                   MOVEL     'Y'           L1LSAI
     C                   ENDIF
      *
      *   Loan Interest Date Control Indicator
     C                   TESTB     '5'           LONI                     85
     C                   MOVEL     'N'           L1LIDC
     C     *IN85         IFEQ      *ON
     C                   MOVEL     'Y'           L1LIDC
     C                   ENDIF
      *
      *   Confirmation Deal Date Indicator
     C                   TESTB     '0'           CNFI                     85
     C                   MOVEL     'N'           L1CDDI
     C     *IN85         IFEQ      *ON
     C                   MOVEL     'Y'           L1CDDI
     C                   ENDIF
      *
      *   Confirmation Control Indicator
     C                   TESTB     '1'           CNFI                     85
     C                   MOVEL     'N'           L1CCI
     C     *IN85         IFEQ      *ON
     C                   MOVEL     'Y'           L1CCI
     C                   ENDIF
      *
      *   Confirmation Produce in COB Indicator
     C                   TESTB     '5'           CNFI                     85
     C                   MOVEL     'N'           L1CPCI
     C     *IN85         IFEQ      *ON
     C                   MOVEL     'Y'           L1CPCI
     C                   ENDIF
      *
      *   Confirmation Duplicate Required Indicator
     C                   TESTB     '6'           CNFI                     85
     C                   MOVEL     'N'           L1CDRI
     C     *IN85         IFEQ      *ON
     C                   MOVEL     'Y'           L1CDRI
     C                   ENDIF
      *
      *   Confirmation Already Printed Indicator
     C                   TESTB     '7'           CNFI                     85
     C                   MOVEL     'N'           L1CAPI
     C     *IN85         IFEQ      *ON
     C                   MOVEL     'Y'           L1CAPI
     C                   ENDIF
      *
      *   Accounting Deal Date Indicator
     C                   TESTB     '0'           ACEI                     85
     C                   MOVEL     'N'           L1ADIN
     C     *IN85         IFEQ      *ON
     C                   MOVEL     'Y'           L1ADIN
     C                   ENDIF
      *
      *   Accounting Start Date Indicator
     C                   TESTB     '1'           ACEI                     85
     C                   MOVEL     'N'           L1ASDI
     C     *IN85         IFEQ      *ON
     C                   MOVEL     'Y'           L1ASDI
     C                   ENDIF
      *
      *   Accounting Maturity Date Indicator
     C                   TESTB     '2'           ACEI                     85
     C                   MOVEL     'N'           L1AMDI
     C     *IN85         IFEQ      *ON
     C                   MOVEL     'Y'           L1AMDI
     C                   ENDIF
      *
      *   Telex Start Date Indicator
     C                   TESTB     '0'           TLXI                     85
     C                   MOVEL     'N'           L1TSDI
     C     *IN85         IFEQ      *ON
     C                   MOVEL     'Y'           L1TSDI
     C                   ENDIF
      *
      *   Telex Maturity Date Indicator
     C                   TESTB     '1'           TLXI                     85
     C                   MOVEL     'N'           L1TMDI
     C     *IN85         IFEQ      *ON
     C                   MOVEL     'Y'           L1TMDI
     C                   ENDIF
      *
      *   Telex Interest Date Indicator
     C                   TESTB     '2'           TLXI                     85
     C                   MOVEL     'N'           L1TIDI
     C     *IN85         IFEQ      *ON
     C                   MOVEL     'Y'           L1TIDI
     C                   ENDIF
      *
      *   Telex Repayment Date Indicator
     C                   TESTB     '3'           TLXI                     85
     C                   MOVEL     'N'           L1TRDI
     C     *IN85         IFEQ      *ON
     C                   MOVEL     'Y'           L1TRDI
     C                   ENDIF
      *
      *   Customer Bills Interest Payment Indicator
     C                   TESTB     '0'           CBLI                     85
     C                   MOVEL     'N'           L1CBIP
     C     *IN85         IFEQ      *ON
     C                   MOVEL     'Y'           L1CBIP
     C                   ENDIF
      *
      *   Customer Bills Interest Payment Bill to Resend
     C                   TESTB     '1'           CBLI                     85
     C                   MOVEL     'N'           L1CBPR
     C     *IN85         IFEQ      *ON
     C                   MOVEL     'Y'           L1CBPR
     C                   ENDIF
      *
      *   Customer Bills Repayment Bill Indicator
     C                   TESTB     '2'           CBLI                     85
     C                   MOVEL     'N'           L1CBRB
     C     *IN85         IFEQ      *ON
     C                   MOVEL     'Y'           L1CBRB
     C                   ENDIF
      *
      *   Customer Bills Repayment Bill to Resend
     C                   TESTB     '3'           CBLI                     85
     C                   MOVEL     'N'           L1CBRR
     C     *IN85         IFEQ      *ON
     C                   MOVEL     'Y'           L1CBRR
     C                   ENDIF
      *
      *   Customer Bills Maturity Bill  Indicator
     C                   TESTB     '4'           CBLI                     85
     C                   MOVEL     'N'           L1CBMB
     C     *IN85         IFEQ      *ON
     C                   MOVEL     'Y'           L1CBMB
     C                   ENDIF
      *
      *   Customer Bills Maturity Bill to Resend
     C                   TESTB     '5'           CBLI                     85
     C                   MOVEL     'N'           L1CBMR
     C     *IN85         IFEQ      *ON
     C                   MOVEL     'Y'           L1CBMR
     C                   ENDIF
      *
      *   Original Interest Amount
     C                   MOVE(P)   ORTI          ZFIELD
     C                   Z-ADD     W#CCYDP       ZADEC
     C                   EXSR      ZEDIT
     C                   MOVE      ZFIELD        L1ORTI
      *
      *   Total Cost of Funds
     C                   MOVE(P)   TCOF          ZFIELD
     C                   Z-ADD     W#CCYDP       ZADEC
     C                   EXSR      ZEDIT
     C                   MOVE      ZFIELD        L1TCOF
      *
      *   Accrued COF posted to date
     C                   MOVE(P)   ACPD          ZFIELD
     C                   Z-ADD     W#CCYDP       ZADEC
     C                   EXSR      ZEDIT
     C                   MOVE      ZFIELD        L1ACPD
      *
      *   Accrued COF to Control Date
     C                   MOVE(P)   ACDA          ZFIELD
     C                   Z-ADD     W#CCYDP       ZADEC
     C                   EXSR      ZEDIT
     C                   MOVE      ZFIELD        L1ACDA
      *
      *   Accrued COF Manual Adjustment
     C                   MOVE(P)   ACAJ          ZFIELD
     C                   Z-ADD     W#CCYDP       ZADEC
     C                   EXSR      ZEDIT
     C                   MOVE      ZFIELD        L1ACAJ
      *
      *   Accrued COF Adjustment Posted
     C                   MOVE(P)   ACAP          ZFIELD
     C                   Z-ADD     W#CCYDP       ZADEC
     C                   EXSR      ZEDIT
     C                   MOVE      ZFIELD        L1ACAP
      *
      *   COF Paid/Received to Date
     C                   MOVE(P)   COFD          ZFIELD
     C                   Z-ADD     W#CCYDP       ZADEC
     C                   EXSR      ZEDIT
     C                   MOVE      ZFIELD        L1COFD
      *
      *   COF Paid/Received this Month
     C                   MOVE(P)   COFM          ZFIELD
     C                   Z-ADD     W#CCYDP       ZADEC
     C                   EXSR      ZEDIT
     C                   MOVE      ZFIELD        L1COFM
      *
      *   COF Capitalised to Date
     C                   MOVE(P)   CFCD          ZFIELD
     C                   Z-ADD     W#CCYDP       ZADEC
     C                   EXSR      ZEDIT
     C                   MOVE      ZFIELD        L1CFCD
      *
      *   Past Due Cost of Funds
     C                   MOVE(P)   PDCF          ZFIELD
     C                   Z-ADD     W#CCYDP       ZADEC
     C                   EXSR      ZEDIT
     C                   MOVE      ZFIELD        L1PDCF
      *
      *   COF Accrual Control Date
     C                   Z-ADD     FCTD          W#ZDAYN
     C                   EXSR      ZZA0140
     C*****              MOVEL     W#ZDATE8      L1FCTD
     C                   MOVEL     W#DATE8       L1FCTD
      *
      *   COF Written Off to Date
     C                   MOVE(P)   FWOD          ZFIELD
     C                   Z-ADD     W#CCYDP       ZADEC
     C                   EXSR      ZEDIT
     C                   MOVE      ZFIELD        L1FWOD
      *
      *   Original Principal Amount
     C                   MOVE(P)   OPAM          ZFIELD
     C                   Z-ADD     W#CCYDP       ZADEC
     C                   EXSR      ZEDIT
     C                   MOVE      ZFIELD        L1OPAM
      *
      *   YTD Interest Paid Loan Currency
     C                   MOVE(P)   YPLN          ZFIELD
     C                   Z-ADD     W#CCYDP       ZADEC
     C                   EXSR      ZEDIT
     C                   MOVE      ZFIELD        L1YPLN
      *
      *   YTD Fees Paid Loan Currency
     C                   MOVE(P)   YFLN          ZFIELD
     C                   Z-ADD     W#CCYDP       ZADEC
     C                   EXSR      ZEDIT
     C                   MOVE      ZFIELD        L1YFLN
      *
      *   YTD Withholding Tax Paid Loan Currency
     C                   MOVE(P)   YWLN          ZFIELD
     C                   Z-ADD     W#CCYDP       ZADEC
     C                   EXSR      ZEDIT
     C                   MOVE      ZFIELD        L1YWLN
      *
      *   YTD Aggregate Balance Loan Currency
     C                   MOVE(P)   ABLN          ZFIELD
     C                   Z-ADD     W#CCYDP       ZADEC
     C                   EXSR      ZEDIT
     C                   MOVE      ZFIELD        L1ABLN
      *
      *   YTD Interest Paid Local Currency
     C                   MOVE(P)   YPLC          ZFIELD
     C                   Z-ADD     W#LCCYDP      ZADEC
     C                   EXSR      ZEDIT
     C                   MOVE      ZFIELD        L1YPLC
      *
      *   YTD Fees Paid Local Currency
     C                   MOVE(P)   YFLC          ZFIELD
     C                   Z-ADD     W#LCCYDP      ZADEC
     C                   EXSR      ZEDIT
     C                   MOVE      ZFIELD        L1YFLC
      *
      *   YTD Withholding Tax Paid Local Currency
     C                   MOVE(P)   YWLC          ZFIELD
     C                   Z-ADD     W#LCCYDP      ZADEC
     C                   EXSR      ZEDIT
     C                   MOVE      ZFIELD        L1YWLC
      *
      *   YTD Aggregate Balance Local Currency
     C                   MOVE(P)   ABLC          ZFIELD
     C                   Z-ADD     W#LCCYDP      ZADEC
     C                   EXSR      ZEDIT
     C                   MOVE      ZFIELD        L1ABLC
      *
      *   YTD Withholding Tax Written Off Loan Currency
     C                   MOVE(P)   WWLN          ZFIELD
     C                   Z-ADD     W#CCYDP       ZADEC
     C                   EXSR      ZEDIT
     C                   MOVE      ZFIELD        L1WWLN
      *
      *   YTD Interest Written Off
     C                   MOVE(P)   IWLN          ZFIELD
     C                   Z-ADD     W#CCYDP       ZADEC
     C                   EXSR      ZEDIT
     C                   MOVE      ZFIELD        L1IWLN
      *
      *   YTD Principal Written Off
     C                   MOVE(P)   PWLN          ZFIELD
     C                   Z-ADD     W#CCYDP       ZADEC
     C                   EXSR      ZEDIT
     C                   MOVE      ZFIELD        L1PWLN
      *
     C                   MOVE      LSTS          L1LSTS
     C                   MOVE      PCRF          L1PCRF
      *                                                                                       CEU030
      **  Sett Ccy, IN Ccy in Fld 72, Roll Rec Sett Ccy                                       CEU030
      **  Roll Pay Sett Ccy, Roll IN Ccy in Fld 72                                            CEU030
     C     CEU004        IFEQ      'Y'                                                        CEU030
     C                   MOVE      SCCY          L1SCCY                                       CEU030
     C                   MOVE      ICCY          L1ICCY                                       CEU030
     C                   MOVE      RRSC          L1RRSC                                       CEU030
     C                   MOVE      RPSC          L1RPSC                                       CEU030
     C                   MOVE      RICY          L1RICY                                       CEU030
     C                   MOVE      ECIN          L1ECIN                                       CEU030
     C                   ENDIF                                                                CEU030
      *                                                                                       CEU030
     C***********        MOVEL     PCOB          X1FIL1
     C                   MOVEL     F#LPCOB       X1FIL1
     C                   MOVE      MNSG          L1MNSG
     C                   MOVE      RATF          L1RATF
     C                   MOVE      CNCF          L1CNCF
     C                   MOVE      LPFI          L1LPFI
      *
     C*****PTFC*         IFNE      *ZEROS                                                     CSD027
     C     PTFC          IFNE      *BLANKS                                                    CSD027
     C                   MOVE      PTFC          L1PTFC
     C                   ELSE
     C                   MOVE      *BLANKS       L1PTFC
     C                   ENDIF
      *
     C     PTFT          IFNE      *ZEROS
     C                   MOVE      PTFT          L1PTFT
     C                   ELSE
     C                   MOVE      *BLANKS       L1PTFT
     C                   ENDIF
      *
     C     PTFN          IFNE      *ZEROS
     C                   MOVE      PTFN          L1PTFN
     C                   ELSE
     C                   MOVE      *BLANKS       L1PTFN
     C                   ENDIF
      *
      *   Next Rollover Date
     C                   Z-ADD     NROD          W#ZDAYN
     C                   EXSR      ZZA0140
     C*****              MOVEL     W#ZDATE8      L1NROD
     C                   MOVEL     W#DATE8       L1NROD
      *
     C     NCAS          IFNE      *ZEROS
     C                   MOVE      NCAS          L1NCAS
     C                   ELSE
     C                   MOVE      *BLANKS       L1NCAS
     C                   ENDIF
      *
     C     NBRA          IFNE      *ZEROS
     C                   MOVE      NBRA          L1NBRA
     C                   ELSE
     C                   MOVE      *BLANKS       L1NBRA
     C                   ENDIF
      *
      *
      *   Next Rate/Spread
     C                   MOVE(P)   NRTS          ZFIELD
     C                   Z-ADD     7             ZADEC
     C                   EXSR      ZEDIT
     C                   MOVE      ZFIELD        L1NRTS
      *
     C                   MOVE      NSIN          L1NSIN
     C                   MOVE      NCHI          L1NCHI
      *
      *   New Principal Amount
     C                   MOVE(P)   NPRAM         ZFIELD
     C                   Z-ADD     W#CCYDP       ZADEC
     C                   EXSR      ZEDIT
     C                   MOVE      ZFIELD        L1NPAM
      *
      *   New Discount Amount
     C                   MOVE(P)   NDAM          ZFIELD
     C                   Z-ADD     W#CCYDP       ZADEC
     C                   EXSR      ZEDIT
     C                   MOVE      ZFIELD        L1NDAM
      *
      *   New Interest Payment Date
     C                   Z-ADD     NIPD          W#ZDAYN
     C                   EXSR      ZZA0140
     C*****              MOVEL     W#ZDATE8      L1NIPD
     C                   MOVEL     W#DATE8       L1NIPD
      *
      *   New Maturity Date
     C                   Z-ADD     NMDT          W#ZDAYN
     C                   EXSR      ZZA0140
     C*****              MOVEL     W#ZDATE8      L1NMDT
     C                   MOVEL     W#DATE8       L1NMDT
      *
      *   New Funding Spread/Rate
     C                   MOVE(P)   NFRS          ZFIELD
     C                   Z-ADD     7             ZADEC
     C                   EXSR      ZEDIT
     C                   MOVE      ZFIELD        L1NFRS
      *
     C                   MOVE      NFSN          L1NFSN
     C                   MOVE      NFPC          L1NFPC
     C                   MOVE      RPST          L1RPST
      *
      *   Pay Rollover Our Nostro
     C                   EVAL      L1RPON=       RLSB+RPON
      *
     C                   MOVE      RRVN          L1RRVN
     C                   MOVE      RCVM          L1RCVM
      *                                                                                       166578
     C*****RPOC*         IFNE      *ZEROS                                              166578 CSD027
     C     RPOC          IFNE      *BLANKS                                                    CSD027
     C                   MOVE      RPOC          L1RPOC
     C                   ELSE                                                                 166578
     C                   MOVE      *BLANKS       L1RPOC                                       166578
     C                   ENDIF                                                                166578
      *                                                                                       166578
     C*****RPOB*         IFNE      *ZEROS                                              166578 CSD027
     C     RPOB          IFNE      *BLANKS                                                    CSD027
     C                   MOVE      RPOB          L1RPOB
     C                   ELSE                                                                 166578
     C                   MOVE      *BLANKS       L1RPOB                                       166578
     C                   ENDIF                                                                166578
      *                                                                                       166578
     C                   MOVE      RRCR          L1RRCR
     C                   MOVE      RRCA          L1RRCA
     C                   MOVE      RPIB          L1RPIB
     C                   MOVE      RPBA          L1RPBA
     C                   MOVE      RAWB          L1RAWB
     C                   MOVE      RAWA          L1RAWA
     C                   MOVE      RBEN          L1RBEN
     C                   MOVE      RBNA          L1RBNA
     C                   MOVE      RRST          L1RRST
      *
      *   Receive Rollover Our Nostro
     C                   EVAL      L1RRON=       RLBR+RRON
      *
     C*****RROC*         IFNE      *ZEROS                                              166578 CSD027
     C     RROC          IFNE      *BLANKS                                                    CSD027
     C                   MOVE      RROC          L1RROC
     C                   ELSE                                                                 166578
     C                   MOVE      *BLANKS       L1RROC                                       166578
     C                   ENDIF                                                                166578
      *                                                                                       166578
     C*****RROB*         IFNE      *ZEROS                                              166578 CSD027
     C     RROB          IFNE      *BLANKS                                                    CSD027
     C                   MOVE      RROB          L1RROB
     C                   ELSE                                                                 166578
     C                   MOVE      *BLANKS       L1RROB                                       166578
     C                   ENDIF                                                                166578
      *                                                                                       166578
     C                   MOVE      RRIB          L1RRIB
     C                   MOVE      RRBA          L1RRBA
      *
      *   Rollover Details of Payments
     C                   EVAL      L1RDP1=       RDP1 +
     C                                           RDP2 +
     C                                           RDP3 +
     C                                           RDP4
      *
     C                   MOVE      RDCH          L1RDCH
      *
      *   Bank to Bank Information
     C                   EVAL      L1RBB1=       RBB1 +
     C                                           RBB2 +
     C                                           RBB3 +
     C                                           RBB4 +
     C                                           RBB5 +
     C                                           RBB6
      *
     C                   MOVE      NCCY          L1NCCY
      *
      *   New Currency Principal Amount
     C                   MOVE(P)   NCPA          ZFIELD
     C                   Z-ADD     W#NCCYDP      ZADEC
     C                   EXSR      ZEDIT
     C                   MOVE      ZFIELD        L1NCPA
      *
     C                   MOVE      NFMD          L1NFMD
      *
      *   New Facility Currency Exchange Rate
     C                   MOVE(P)   NFCE          ZFIELD
     C                   Z-ADD     8             ZADEC
     C                   EXSR      ZEDIT
     C                   MOVE      ZFIELD        L1NFCE
      *
      *   New Loan Currency Repayment Amount
     C                   MOVE(P)   NLRA          ZFIELD
     C                   Z-ADD     W#NCCYDP      ZADEC
     C                   EXSR      ZEDIT
     C                   MOVE      ZFIELD        L1NLRA
      *
     C                   MOVE      RIUS          L1RIUS
     C                   MOVE      RAUS          L1RAUS
     C                   MOVE      RXUS          L1RXUS
     C                   MOVE      RSTS          L1RSTS
     C                   MOVE      RPCR          L1RPCR
      *
      *   Last Rollover Date
     C                   Z-ADD     LRLD          W#ZDAYN
     C                   EXSR      ZZA0140
     C**********         MOVEL     W#ZDATE8      L1LRLD                                       228849
     C                   MOVEL     W#DATE8       L1LRLD                                       228849
      *
      *   Last Multi-Ccy Rollover Date
     C                   Z-ADD     LMCD          W#ZDAYN
     C                   EXSR      ZZA0140
     C*****              MOVEL     W#ZDATE8      L1LMCD
     C                   MOVEL     W#DATE8       L1LMCD
      *
     C                   MOVE      NBMD          L1NBMD
      *  New Base Currency Exchange Rate
     C                   MOVE(P)   NBCE          ZFIELD
     C                   Z-ADD     8             ZADEC
     C                   EXSR      ZEDIT
     C                   MOVE      ZFIELD        L1NBCE
      *                                                                                       131254
      *   Current Principal Amount Sign                                                       131254
     C                   MOVE      '+'           L1CPAS                                       131254
     C     CPAM          IFLT      *ZERO                                                      131254
     C                   MOVE      '-'           L1CPAS                                       131254
     C                   MULT      -1            CPAM                                         131254
     C                   MOVE(P)   CPAM          ZFIELD                                       131254
     C                   Z-ADD     W#CCYDP       ZADEC                                        131254
     C                   EXSR      ZEDIT                                                      131254
     C                   MOVE      ZFIELD        L1CPAM                                       131254
     C                   ENDIF                                                                131254
      *                                                                                       CLE031
     C                   IF        CLE031 = 'Y'                                               CLE031
      *                                                                                       CLE031
      * Facility Currency principal Amount                                                    CLE031
     C                   Z-ADD     W#FCCYDP      ZADEC                                        CLE031
     C                   MOVE      *BLANKS       ZFIELD                                       CLE031
     C                   MOVE      FPAM          ZFIELD                                       CLE031
     C                   EXSR      ZEDIT                                                      CLE031
     C                   MOVE      ZFIELD        L1FPAM                                       CLE031
      *                                                                                       CLE031
      * (Receive) Settlement Currency                                                         CLE031
     C                   EVAL      L1SCCY = SCCY                                              CLE031
      *                                                                                       CLE031
      * Receive Settlement Ccy. Exchange Rate                                                 CLE031
     C                   Z-ADD     8             ZADEC                                        CLE031
     C                   MOVE      *BLANKS       ZFIELD                                       CLE031
     C                   MOVE      REXR          ZFIELD                                       CLE031
     C                   EXSR      ZEDIT                                                      CLE031
     C                   MOVE      ZFIELD        L1REXR                                       CLE031
      *                                                                                       CLE031
      * Receive Settlement Ccy. Exchange Rate Indicator                                       CLE031
     C                   EVAL      L1REXI = REXI                                              CLE031
      *                                                                                       CLE031
      * Pay Settlement Currency                                                               CLE031
     C                   EVAL      L1PSCY = PSCY                                              CLE031
      *                                                                                       CLE031
      * Pay Settlement Ccy. Exchange Rate                                                     CLE031
     C                   Z-ADD     8             ZADEC                                        CLE031
     C                   MOVE      *BLANKS       ZFIELD                                       CLE031
     C                   MOVE      PEXR          ZFIELD                                       CLE031
     C                   EXSR      ZEDIT                                                      CLE031
     C                   MOVE      ZFIELD        L1PEXR                                       CLE031
      *                                                                                       CLE031
      * Pay Settlement Ccy. Exchange Rate Indicator                                           CLE031
     C                   EVAL      L1PEXI = PEXI                                              CLE031
      *                                                                                       CLE031
      * Roll Receive Settlement Currency                                                      CLE031
     C                   EVAL      L1RRSC = RRSC                                              CLE031
      *                                                                                       CLE031
      * Roll Receive Settlement Currency Exchange Rate                                        CLE031
     C                   Z-ADD     8             ZADEC                                        CLE031
     C                   MOVE      *BLANKS       ZFIELD                                       CLE031
     C                   MOVE      RRSR          ZFIELD                                       CLE031
     C                   EXSR      ZEDIT                                                      CLE031
     C                   MOVE      ZFIELD        L1RRSR                                       CLE031
      *                                                                                       CLE031
      * Roll Receive Settlement Currency Exchange Rate Indicator                              CLE031
     C                   EVAL      L1RRSI = RRSI                                              CLE031
      *                                                                                       CLE031
      * Roll Pay Settlement Currency                                                          CLE031
     C                   EVAL      L1RPSC = RPSC                                              CLE031
      *                                                                                       CLE031
      * Roll Pay Settlement Currency Exchange Rate                                            CLE031
     C                   Z-ADD     8             ZADEC                                        CLE031
     C                   MOVE      *BLANKS       ZFIELD                                       CLE031
     C                   MOVE      RPSR          ZFIELD                                       CLE031
     C                   EXSR      ZEDIT                                                      CLE031
     C                   MOVE      ZFIELD        L1RPSR                                       CLE031
      *                                                                                       CLE031
      * Roll Pay Settlement Currency Exchange Rate Indicator                                  CLE031
     C                   EVAL      L1RPSI = RPSI                                              CLE031
     C                   ENDIF                                                                CLE031
      *                                                                                       CLE034
      ** Setup Settlement Allocation Indicator and Rollover Settlement                        CLE034
      ** Allocation Indicator when CLE034 is installed                                        CLE034
      *                                                                                       CLE034
     C                   IF        CLE034 = 'Y'                                               CLE034
     C                   EVAL      L1STAL = F#LSTAL                                           CLE034
     C                   EVAL      L1RSTA = F#KRSTA                                           CLE034
     C                   ENDIF                                                                CLE034
      *
     C                   IF        CLE036 = 'Y'                                               CLE036
      *                                                                                       CLE036
     C                   Z-ADD     7             ZADEC                                        CLE036
     C                   MOVE      *BLANKS       ZFIELD                                       CLE036
     C                   MOVE      BASR          ZFIELD                                       CLE036
     C                   EXSR      ZEDIT                                                      CLE036
     C                   MOVE      ZFIELD        L1BASR                                       CLE036
      *                                                                                       CLE036
     C                   Z-ADD     7             ZADEC                                        CLE036
     C                   MOVE      *BLANKS       ZFIELD                                       CLE036
     C                   MOVE      NBSR          ZFIELD                                       CLE036
     C                   EXSR      ZEDIT                                                      CLE036
     C                   MOVE      ZFIELD        L1NBSR                                       CLE036
      *                                                                                       CLE036
     C                   ENDIF                                                                CLE036
      *                                                                                       CLE036
     C                   MOVE      FILLER        X1FIL1
      *
      * Move message format
     C                   MOVEL(P)  DWL1MF        W#MFMT
      *
     C                   ELSE
      *
     C                   MOVE      *BLANKS       DWL1MF
     C************       MOVE      LNRF          L1LNRF                                       132273
     C                   MOVE      W@LNRF        L1LNRF                                       132273
     C                   MOVE      FILLER        X1FIL1
     C                   MOVEL     F#LPCOB       X1FIL1
     C                   MOVEL(P)  DWL1MF        W#MFMT
      *
     C                   ENDIF
      *
      * Put Message
      *  Supress message for non-rollbacks (PT/UP etc)) of a rolled back                      132273
      *  unit of work                                                                         132273
      *                                                                                       132273
     C     *IN70         IFEQ      *ON                                                        132273
     C     ROLLB         ANDNE     'R'                                                        132273
     C                   ELSE                                                                 132273
     C                   EXSR      PMQPUT
     C                   ENDIF                                                                132273
      *
     C                   MOVE      *BLANKS       STK(@Q)
     C                   SUB       1             @Q
      *
     C                   ENDSR
      *
      **********************************************************************
      * Set up Transmitted Message Format for LOAMSDK
      **********************************************************************
     C     P#DLLA        BEGSR
      *
     C                   ADD       1             @Q
     C                   MOVEL     'P#DLLA'      STK(@Q)
      *
      * Retrieve the data from the file image and move into DS for LOAMSDK
      * start pos: 126, length: 1057
      *
     C                   EVAL      W#FSIZ=%SIZE(LOAMSD)
     C                   EVAL      LOAMSD=%SUBST(P#PARM1:126:W#FSIZ)
      *
     C                   EXSR      MSGFRMT
      *
      * If the journal image has been rolled back setup flag
      *
     C     JOENTT        IFEQ      'DR'
     C     JOENTT        OREQ      'UR'
     C                   MOVE      'R'           ROLLB
     C                   ENDIF
      *
      * Format and populate data
      *
      * Access Currency Codes for decimal places for
      *  Loan Amendment Currency
      *
     C                   MOVE      F#DCCY        W#CCY
     C                   EXSR      GETNBDP
      *
     C                   MOVE      F#DLNRF       L2LNRF
      *   Value Date
     C                   Z-ADD     F#DVDAT       W#ZDAYN
     C                   EXSR      ZZA0140
     C*****              MOVEL     W#ZDATE8      L2VDAT
     C                   MOVEL     W#DATE8       L2VDAT
      *
     C                   MOVE      F#DLASN       L2LASN
     C                   MOVE      F#DCNUM       L2CNUM
     C                   MOVE      F#DCCY        L2CCY
      *
     C     F#DBRTT       IFNE      *ZEROS
     C                   MOVE      F#DBRTT       L2BRTT
     C                   ELSE
     C                   MOVE      *BLANKS       L2BRTT
     C                   ENDIF
      *
      *   Rate/Spread
     C                   MOVE(P)   F#DRTSP       ZFIELD
     C                   Z-ADD     7             ZADEC
     C                   EXSR      ZEDIT
     C                   MOVE      ZFIELD        L2RTSP
      *
     C                   MOVE      F#DSTAI       L2STAI
      *   Maturity Date
     C                   Z-ADD     F#DLSMD       W#ZDAYN
     C                   EXSR      ZZA0140
     C*****              MOVEL     W#ZDATE8      L2LSMD
     C                   MOVEL     W#DATE8       L2LSMD
      *
     C                   MOVE      F#DLTYP       L2LTYP
     C                   MOVE      F#DSUTP       L2SUTP
      *
      *   Funding Rate/Spread
     C                   MOVE(P)   F#DFSRP       ZFIELD
     C                   Z-ADD     7             ZADEC
     C                   EXSR      ZEDIT
     C                   MOVE      ZFIELD        L2FSRP
      *
      *   Special Instructions
     C                   EVAL      L2SPI1=       F#DSPI1 +
     C                                           F#DSPI2 +
     C                                           F#DSPI3
      *
     C     F#DPSTM       IFNE      *ZEROS
     C                   MOVE      F#DPSTM       L2PSTM
     C                   ELSE
     C                   MOVE      *BLANKS       L2PSTM
     C                   ENDIF
      *
     C                   EVAL      L2PONS=       F#DOSBR + F#DPONS
     C                   MOVE      F#DRVNO       L2RVNO
     C                   MOVE      F#DCVMR       L2CVMR
      *
     C*****F#DPOCN       IFNE      *ZEROS                                                     CSD027
     C     F#DPOCN       IFNE      *BLANKS                                                    CSD027
     C                   MOVE      F#DPOCN       L2POCN
     C                   ELSE
     C                   MOVE      *BLANKS       L2POCN
     C                   ENDIF
      *
     C*****F#DPOBN       IFNE      *ZEROS                                                     CSD027
     C     F#DPOBN       IFNE      *BLANKS                                                    CSD027
     C                   MOVE      F#DPOBN       L2POBN
     C                   ELSE
     C                   MOVE      *BLANKS       L2POBN
     C                   ENDIF
      *
     C                   MOVE      F#DRCRN       L2RCRN
     C                   MOVE      F#DRCRA       L2RCRA
     C                   MOVE      F#DPIBN       L2PIBN
     C                   MOVE      F#DPIBA       L2PIBA
     C                   MOVE      F#DAWBN       L2AWBN
     C                   MOVE      F#DAWBA       L2AWBA
     C                   MOVE      F#DBENN       L2BENN
     C                   MOVE      F#DBENA       L2BENA
      *
     C     F#DRSTM       IFNE      *ZEROS
     C                   MOVE      F#DRSTM       L2RSTM
     C                   ELSE
     C                   MOVE      *BLANKS       L2RSTM
     C                   ENDIF
      *
     C                   EVAL      L2RONS=       F#DOSBR + F#DRONS
      *
     C*****F#DROCN       IFNE      *ZEROS                                                     CSD027
     C     F#DROCN       IFNE      *BLANKS                                                    CSD027
     C                   MOVE      F#DROCN       L2ROCN
     C                   ELSE
     C                   MOVE      *BLANKS       L2ROCN
     C                   ENDIF
      *
     C*****F#DROBN       IFNE      *ZEROS                                                     CSD027
     C     F#DROBN       IFNE      *BLANKS                                                    CSD027
     C                   MOVE      F#DROBN       L2ROBN
     C                   ELSE
     C                   MOVE      *BLANKS       L2ROBN
     C                   ENDIF
      *
     C                   MOVE      F#DRIBN       L2RIBN
     C                   MOVE      F#DRIBA       L2RIBA
      *
      *   Details of Payments
     C                   EVAL      L2DTP1=       F#DDTP1 +
     C                                           F#DDTP2 +
     C                                           F#DDTP3 +
     C                                           F#DDTP4
      *
     C                   MOVE      F#DDCHG       L2DCHG
      *
      *   Bank to Bank Information
     C                   EVAL      L2BTB1=       F#DBTB1 +
     C                                           F#DBTB2 +
     C                                           F#DBTB3 +
     C                                           F#DBTB4 +
     C                                           F#DBTB5 +
     C                                           F#DBTB6
      *
     C                   MOVE      F#DDFTP       L2DFTP
     C                   MOVE      F#DDFST       L2DFST
     C                   MOVE      F#DNRLI       L2NRLI
      *
     C     F#DROLN       IFNE      *ZEROS
     C                   MOVE      F#DROLN       L2ROLN
     C                   ELSE
     C                   MOVE      *BLANKS       L2ROLN
     C                   ENDIF
      *
     C     F#DROSN       IFNE      *ZEROS
     C                   MOVE      F#DROSN       L2ROSN
     C                   ELSE
     C                   MOVE      *BLANKS       L2ROSN
     C                   ENDIF
      *
     C                   MOVE      F#DROBR       L2ROBR
      *
     C*****F#DRORC       IFNE      *ZEROS                                                     CSD027
     C     F#DRORC       IFNE      *BLANKS                                                    CSD027
     C                   MOVE      F#DRORC       L2RORC
     C                   ELSE
     C                   MOVE      *BLANKS       L2RORC
     C                   ENDIF
      *
     C                   MOVE      F#DIUSR       L2IUSR
     C                   MOVE      F#DAUSR       L2AUSR
     C                   MOVE      F#DXUSR       L2XUSR
     C                   MOVE      F#DAUTO       L2AUTO
      *   X-ref Loan Repayment Value Date
     C                   Z-ADD     F#DXAVD       W#ZDAYN
     C                   EXSR      ZZA0140
     C*****              MOVEL     W#ZDATE8      L2XAVD
     C                   MOVEL     W#DATE8       L2XAVD
      *
     C     F#DXASQ       IFNE      *ZEROS
     C                   MOVE      F#DXASQ       L2XASQ
     C                   ELSE
     C                   MOVE      *BLANKS       L2XASQ
     C                   ENDIF
      *
      *   Principal Repayment Amount
     C                   MOVE(P)   F#DPRAM       ZFIELD
     C                   Z-ADD     A6NBDP        ZADEC
     C                   EXSR      ZEDIT
     C                   MOVE      ZFIELD        L2PRAM
      *
      *   Principal Repayment Amount Sign
     C                   MOVE      '+'           L2PRAS
     C     F#DPRAM       IFLT      *ZERO
     C                   MOVE      '-'           L2PRAS
     C                   MULT      -1            F#DPRAM                                      148708
     C                   MOVE(P)   F#DPRAM       ZFIELD                                       148708
     C                   Z-ADD     A6NBDP        ZADEC                                        148708
     C                   EXSR      ZEDIT                                                      148708
     C                   MOVE      ZFIELD        L2PRAM                                       148708
     C                   ENDIF
      *
      *   Interest Payment Amount
     C                   MOVE(P)   F#DINTA       ZFIELD
     C                   Z-ADD     A6NBDP        ZADEC
     C                   EXSR      ZEDIT
     C                   MOVE      ZFIELD        L2INTA
      *
      *   Interest Payment Amount Sign
     C                   MOVE      '+'           L2INTS
     C     F#DINTA       IFLT      *ZERO
     C                   MOVE      '-'           L2INTS
     C                   MULT      -1            F#DINTA                                      148708
     C                   MOVE(P)   F#DINTA       ZFIELD                                       148708
     C                   Z-ADD     A6NBDP        ZADEC                                        148708
     C                   EXSR      ZEDIT                                                      148708
     C                   MOVE      ZFIELD        L2INTA                                       148708
     C                   ENDIF
      *
      *   Total Repayment Amount
     C                   MOVE(P)   F#DTAMT       ZFIELD
     C                   Z-ADD     A6NBDP        ZADEC
     C                   EXSR      ZEDIT
     C                   MOVE      ZFIELD        L2TAMT
      *
      *   Total Repayment Amount Sign
     C                   MOVE      '+'           L2TAMS
     C     F#DTAMT       IFLT      *ZERO
     C                   MOVE      '-'           L2TAMS
     C                   MULT      -1            F#DTAMT                                      148708
     C                   MOVE(P)   F#DTAMT       ZFIELD                                       148708
     C                   Z-ADD     A6NBDP        ZADEC                                        148708
     C                   EXSR      ZEDIT                                                      148708
     C                   MOVE      ZFIELD        L2TAMT                                       148708
     C                   ENDIF
      *
     C                   MOVE      F#DLWOI       L2LWOI
     C                   MOVE      F#DPAST       L2PAST
      *
      *   Penalty Payment Amount
     C                   MOVE(P)   F#DPNAM       ZFIELD
     C                   Z-ADD     A6NBDP        ZADEC
     C                   EXSR      ZEDIT
     C                   MOVE      ZFIELD        L2PNAM
      *
      *   Penalty Payment Amount Sign
     C                   MOVE      '+'           L2PNAS
     C     F#DPNAM       IFLT      *ZERO
     C                   MOVE      '-'           L2PNAS
     C                   MULT      -1            F#DPNAM                                      148708
     C                   MOVE(P)   F#DPNAM       ZFIELD                                       148708
     C                   Z-ADD     A6NBDP        ZADEC                                        148708
     C                   EXSR      ZEDIT                                                      148708
     C                   MOVE      ZFIELD        L2PNAM                                       148708
     C                   ENDIF
      *
     C                   MOVE      F#DRECI       L2RECI
     C                   MOVE      F#DPTYP       L2PTYP
     C                   MOVE      F#DAMTP       L2AMTP
     C                   MOVE      F#DBRCA       L2BRCA
      *
      *   Withholding Tax Amount
     C                   MOVE(P)   F#DWTXA       ZFIELD
     C                   Z-ADD     A6NBDP        ZADEC
     C                   EXSR      ZEDIT
     C                   MOVE      ZFIELD        L2WTXA
      *
      *   Withholding Tax Amount Sign
     C                   MOVE      '+'           L2WTXS
     C     F#DWTXA       IFLT      *ZERO
     C                   MOVE      '-'           L2WTXS
     C                   MULT      -1            F#DWTXA                                      148708
     C                   MOVE(P)   F#DWTXA       ZFIELD                                       148708
     C                   Z-ADD     A6NBDP        ZADEC                                        148708
     C                   EXSR      ZEDIT                                                      148708
     C                   MOVE      ZFIELD        L2WTXA                                       148708
     C                   ENDIF
      *   Fee Amount
     C                   MOVE(P)   F#DFEAM       ZFIELD
     C                   Z-ADD     A6NBDP        ZADEC
     C                   EXSR      ZEDIT
     C                   MOVE      ZFIELD        L2FEAM
      *
      *   Fee Amount Sign
     C                   MOVE      '+'           L2FEAS
     C     F#DFEAM       IFLT      *ZERO
     C                   MOVE      '-'           L2FEAS
     C                   MULT      -1            F#DFEAM                                      148708
     C                   MOVE(P)   F#DFEAM       ZFIELD                                       148708
     C                   Z-ADD     A6NBDP        ZADEC                                        148708
     C                   EXSR      ZEDIT                                                      148708
     C                   MOVE      ZFIELD        L2FEAM                                       148708
     C                   ENDIF
      *
     C                   MOVE      F#DREPT       L2REPT
      *
      *   Loan Amendment Actioned Indicator
     C                   TESTB     '0'           F#DLAIN                  85
     C                   MOVEL     'N'           L2LAIA
     C     *IN85         IFEQ      *ON
     C                   MOVEL     'Y'           L2LAIA
     C                   ENDIF
      *
      *   Loan Amendment Telex Sent Indicator
     C                   TESTB     '1'           F#DLAIN                  85
     C                   MOVEL     'N'           L2LAIT
     C     *IN85         IFEQ      *ON
     C                   MOVEL     'Y'           L2LAIT
     C                   ENDIF
      *
      *   Loan Amendment Confirmation Sent Indicator
     C                   TESTB     '2'           F#DLAIN                  85
     C                   MOVEL     'N'           L2LAIC
     C     *IN85         IFEQ      *ON
     C                   MOVEL     'Y'           L2LAIC
     C                   ENDIF
      *
      *   Loan Amendment Cust. Bill Sent Indicator
     C                   TESTB     '4'           F#DLAIN                  85
     C                   MOVEL     'N'           L2LAIB
     C     *IN85         IFEQ      *ON
     C                   MOVEL     'Y'           L2LAIB
     C                   ENDIF
      *
      *   Loan Amendment Resend Bill Indicator
     C                   TESTB     '5'           F#DLAIN                  85
     C                   MOVEL     'N'           L2LAIR
     C     *IN85         IFEQ      *ON
     C                   MOVEL     'Y'           L2LAIR
     C                   ENDIF
      *
      *   Loan Amendment Conf. Control Indicator
     C                   TESTB     '7'           F#DLAIN                  85
     C                   MOVEL     'N'           L2CLAI
     C     *IN85         IFEQ      *ON
     C                   MOVEL     'Y'           L2CLAI
     C                   ENDIF
      *
      *   Current Base Rate
     C                   MOVE(P)   F#DBRTE       ZFIELD
     C                   Z-ADD     7             ZADEC
     C                   EXSR      ZEDIT
     C                   MOVE      ZFIELD        L2BRTE
      *
     C                   MOVE      F#DSPIN       L2SPIN
     C                   MOVE      F#DCALC       L2CALC
     C                   MOVE      F#DWTIN       L2WTIN
     C                   MOVE      F#DFCUS       L2FCUS
     C                   MOVE      F#DFTYP       L2FTYP
     C                   MOVE      F#DFSEQ       L2FSEQ
      *
     C     F#DRLON       IFNE      *ZEROS
     C                   MOVE      F#DRLON       L2RLON
     C                   ELSE
     C                   MOVE      *BLANKS       L2RLON
     C                   ENDIF
      *
     C     F#DFECD       IFNE      *ZEROS
     C                   MOVE      F#DFECD       L2FECD
     C                   ELSE
     C                   MOVE      *BLANKS       L2FECD
     C                   ENDIF
      *
      *
      *   Past Due Notice 1
     C                   TESTB     '0'           F#DPONI                  85
     C                   MOVEL     'N'           L2PDN1
     C     *IN85         IFEQ      *ON
     C                   MOVEL     'Y'           L2PDN1
     C                   ENDIF
      *
      *   Past Due Notice 2
     C                   TESTB     '1'           F#DPONI                  85
     C                   MOVEL     'N'           L2PDN2
     C     *IN85         IFEQ      *ON
     C                   MOVEL     'Y'           L2PDN2
     C                   ENDIF
      *
      *   Past Due Notice 3
     C                   TESTB     '2'           F#DPONI                  85
     C                   MOVEL     'N'           L2PDN3
     C     *IN85         IFEQ      *ON
     C                   MOVEL     'Y'           L2PDN3
     C                   ENDIF
      *
      *   Past Due Notice 4
     C                   TESTB     '3'           F#DPONI                  85
     C                   MOVEL     'N'           L2PDN4
     C     *IN85         IFEQ      *ON
     C                   MOVEL     'Y'           L2PDN4
     C                   ENDIF
      *
      *   Past Due Notice 5
     C                   TESTB     '4'           F#DPONI                  85
     C                   MOVEL     'N'           L2PDN5
     C     *IN85         IFEQ      *ON
     C                   MOVEL     'Y'           L2PDN5
     C                   ENDIF
      *
      *   Past Due Notice 6
     C                   TESTB     '5'           F#DPONI                  85
     C                   MOVEL     'N'           L2PDN6
     C     *IN85         IFEQ      *ON
     C                   MOVEL     'Y'           L2PDN6
     C                   ENDIF
      *
      *   Past Due Notice 7
     C                   TESTB     '6'           F#DPONI                  85
     C                   MOVEL     'N'           L2PDN7
     C     *IN85         IFEQ      *ON
     C                   MOVEL     'Y'           L2PDN7
     C                   ENDIF
      *
      *   Past Due Notice 8
     C                   TESTB     '7'           F#DPONI                  85
     C                   MOVEL     'N'           L2PDN8
     C     *IN85         IFEQ      *ON
     C                   MOVEL     'Y'           L2PDN8
     C                   ENDIF
      *
     C                   MOVE      F#DACTI       L2ACTI
     C                   MOVE      F#DCNFY       L2CNFY
     C                   MOVE      F#DTLXY       L2TLXY
     C                   MOVE      F#DCBLY       L2CBLY
     C                   MOVE      F#DINTC       L2INTC
     C                   MOVE      F#DNACD       L2NACD
     C                   MOVE      F#DACBI       L2ACBI
     C                   MOVE      F#DFCLB       L2FCLB
      *   Rebate
     C                   MOVE(P)   F#DREBT       ZFIELD
     C                   Z-ADD     A6NBDP        ZADEC
     C                   EXSR      ZEDIT
     C                   MOVE      ZFIELD        L2REBT
      *
     C                   MOVE      F#DFSGN       L2FSGN
     C                   MOVE      F#DFPRC       L2FPRC
      *
      *   Cost of Funds Amount
     C                   MOVE(P)   F#DCOFA       ZFIELD
     C                   Z-ADD     A6NBDP        ZADEC
     C                   EXSR      ZEDIT
     C                   MOVE      ZFIELD        L2COFA
      *
     C                   MOVE      F#DIRCF       L2IRCF
     C                   MOVE      F#DFRCF       L2FRCF
     C                   MOVE      F#DASTS       L2ASTS
     C                   MOVE      F#DPCRF       L2PCRF
      *                                                                                       CEU030
      **  Settlement Currency and IN Currency in Fld 72                                       CEU030
     C     CEU004        IFEQ      'Y'                                                        CEU030
     C                   MOVE      F#DSCCY       L2SCCY                                       CEU030
     C                   MOVE      F#DICCY       L2ICCY                                       CEU030
     C                   ENDIF                                                                CEU030
      *                                                                                       CEU030
     C                   MOVEL     F#DPCOB       X1FIL1
     C                   MOVE      F#DMNSG       L2MNSG
     C                   MOVE      F#DGASS       L2GASS
     C                   MOVE      F#DGPRT       L2GPRT
     C                   MOVE      F#DPDGN       L2PDGN
     C                   MOVE      F#DGRIN       L2GRIN
     C                   MOVE      F#DRLCY       L2RLCY
     C                   MOVE      FILLER        X1FIL1
      *                                                                                       CLE031
     C                   IF        CLE031 = 'Y'                                               CLE031
      *                                                                                       CLE031
      * (Receive) Settlement Currency                                                         CLE031
     C                   EVAL      L2SCCY = F#DSCCY                                           CLE031
      *                                                                                       CLE031
      * Receive Settlement Currency Exchange Rate                                             CLE031
     C                   Z-ADD     8             ZADEC                                        CLE031
     C                   MOVE      *BLANKS       ZFIELD                                       CLE031
     C                   MOVE      F#DREXR       ZFIELD                                       CLE031
     C                   EXSR      ZEDIT                                                      CLE031
     C                   MOVE      ZFIELD        L2REXR                                       CLE031
      *                                                                                       CLE031
      * Receive Settlement Currency Exchange Rate Indicator                                   CLE031
     C                   EVAL      L2REXI = F#DREXI                                           CLE031
      *                                                                                       CLE031
      * Pay Settlement Currency                                                               CLE031
     C                   EVAL      L2PSCY = F#DPSCY                                           CLE031
      *                                                                                       CLE031
      * Pay Settlement Currency Exchange Rate                                                 CLE031
     C                   Z-ADD     8             ZADEC                                        CLE031
     C                   MOVE      *BLANKS       ZFIELD                                       CLE031
     C                   MOVE      F#DPEXR       ZFIELD                                       CLE031
     C                   EXSR      ZEDIT                                                      CLE031
     C                   MOVE      ZFIELD        L2PEXR                                       CLE031
      *                                                                                       CLE031
      * Pay Settlement Currency Exchange Rate Indicator                                       CLE031
     C                   EVAL      L2PEXI = F#DPEXI                                           CLE031
     C                   ENDIF                                                                CLE031
                                                                                              CLE034
      ** Setup Settlement Allocation Indicator when CLE034 is installed                       CLE034
                                                                                              CLE034
     C                   IF        CLE034 = 'Y'                                               CLE034
     C                   EVAL      L2STAL = F#DSTAL                                           CLE034
     C                   ENDIF                                                                CLE034
                                                                                              CLE036
      ** Setup Facility Repayment Details                                                     CLE036
                                                                                              CLE036
     C                   MOVE      *BLANKS       L2FRCY                                       CLE036
     C                   MOVE      *BLANKS       L2FRAM                                       CLE036
     C                   MOVE      *BLANKS       L2FRAS                                       CLE036
     C                   MOVE      *BLANKS       L2FINT                                       CLE036
     C                   MOVE      *BLANKS       L2FINS                                       CLE036
     C                   MOVE      *BLANKS       L2FTXA                                       CLE036
     C                   MOVE      *BLANKS       L2FTXS                                       CLE036
     C                   MOVE      *BLANKS       L2FTOT                                       CLE036
     C                   MOVE      *BLANKS       L2FTOS                                       CLE036
     C                   MOVE      *BLANKS       L2FPEN                                       CLE036
     C                   MOVE      *BLANKS       L2FPES                                       CLE036
                                                                                              CLE036
     C                   IF        F#DAMTP = 'MR' OR F#DAMTP = 'RE'                           CLE036
     C                             OR F#DAMTP = 'PD'                                          CLE036
                                                                                              CLE036
      ** Get Number of Decimal Places for Facility Currency                                   CLE036
                                                                                              CLE036
     C                   IF        F#DFRCY <> *BLANKS AND                                     CLE036
     C                             FREPAY = 'Y'                                               CLE036
     C                   EVAL      L2FRCY = F#DFRCY                                           CLE036
     C                   EVAL      W#CCY = F#DFRCY                                            CLE036
     C                   EXSR      GETNBDP                                                    CLE036
                                                                                              CLE036
      ** Setup Facility Principal Repayment Sign and Amount                                   CLE036
                                                                                              CLE036
     C                   IF        F#DFRAM < *ZERO                                            CLE036
     C                   EVAL      L2FRAS = '-'                                               CLE036
     C                   EVAL      F#DFRAM = F#DFRAM * -1                                     CLE036
     C                   ELSE                                                                 CLE036
     C                   EVAL      L2FRAS = '+'                                               CLE036
     C                   ENDIF                                                                CLE036
                                                                                              CLE036
     C                   EVAL      ZFIELD = *BLANKS                                           CLE036
     C                   MOVE(P)   F#DFRAM       ZFIELD                                       CLE036
     C                   EVAL      ZADEC = A6NBDP                                             CLE036
     C                   EXSR      ZEDIT                                                      CLE036
     C                   MOVE      ZFIELD        L2FRAM                                       CLE036
                                                                                              CLE036
      ** Setup Facility Interest Sign and Amount                                              CLE036
                                                                                              CLE036
     C                   IF        F#DFINT < *ZERO                                            CLE036
     C                   EVAL      L2FINS = '-'                                               CLE036
     C                   EVAL      F#DFINT = F#DFINT * -1                                     CLE036
     C                   ELSE                                                                 CLE036
     C                   EVAL      L2FINS = '+'                                               CLE036
     C                   ENDIF                                                                CLE036
                                                                                              CLE036
     C                   EVAL      ZFIELD = *BLANKS                                           CLE036
     C                   MOVE(P)   F#DFINT       ZFIELD                                       CLE036
     C                   EVAL      ZADEC = A6NBDP                                             CLE036
     C                   EXSR      ZEDIT                                                      CLE036
     C                   MOVE      ZFIELD        L2FINT                                       CLE036
                                                                                              CLE036
      ** Setup Facility Total Sign and Amount                                                 CLE036
                                                                                              CLE036
     C                   IF        F#DFTOT < *ZERO                                            CLE036
     C                   EVAL      L2FTOS = '-'                                               CLE036
     C                   EVAL      F#DFTOT = F#DFTOT * -1                                     CLE036
     C                   ELSE                                                                 CLE036
     C                   EVAL      L2FTOS = '+'                                               CLE036
     C                   ENDIF                                                                CLE036
                                                                                              CLE036
     C                   EVAL      ZFIELD = *BLANKS                                           CLE036
     C                   MOVE(P)   F#DFTOT       ZFIELD                                       CLE036
     C                   EVAL      ZADEC = A6NBDP                                             CLE036
     C                   EXSR      ZEDIT                                                      CLE036
     C                   MOVE      ZFIELD        L2FTOT                                       CLE036
                                                                                              CLE036
      ** Setup Facility Penalty Sign and Amount                                               CLE036
                                                                                              CLE036
     C                   IF        F#DFPEN < *ZERO                                            CLE036
     C                   EVAL      L2FPES = '-'                                               CLE036
     C                   EVAL      F#DFPEN = F#DFPEN * -1                                     CLE036
     C                   ELSE                                                                 CLE036
     C                   EVAL      L2FPES = '+'                                               CLE036
     C                   ENDIF                                                                CLE036
                                                                                              CLE036
     C                   EVAL      ZFIELD = *BLANKS                                           CLE036
     C                   MOVE(P)   F#DFPEN       ZFIELD                                       CLE036
     C                   EVAL      ZADEC = A6NBDP                                             CLE036
     C                   EXSR      ZEDIT                                                      CLE036
     C                   MOVE      ZFIELD        L2FPEN                                       CLE036
                                                                                              CLE036
      ** Setup Facility Tax Sign and Amount                                                   CLE036
                                                                                              CLE036
     C                   IF        F#DFTXA < *ZERO                                            CLE036
     C                   EVAL      L2FTXS = '-'                                               CLE036
     C                   EVAL      F#DFTXA = F#DFTXA * -1                                     CLE036
     C                   ELSE                                                                 CLE036
     C                   EVAL      L2FTXS = '+'                                               CLE036
     C                   ENDIF                                                                CLE036
                                                                                              CLE036
     C                   EVAL      ZFIELD = *BLANKS                                           CLE036
     C                   MOVE(P)   F#DFTXA       ZFIELD                                       CLE036
     C                   EVAL      ZADEC = A6NBDP                                             CLE036
     C                   EXSR      ZEDIT                                                      CLE036
     C                   MOVE      ZFIELD        L2FTXA                                       CLE036
                                                                                              CLE036
     C                   ENDIF                                                                CLE036
     C                   ENDIF                                                                CLE036
      *
      * Move message format
     C                   MOVEL(P)  DWL2MF        W#MFMT
      *
      * Put Message
     C                   EXSR      PMQPUT
      *
     C                   MOVE      *BLANKS       STK(@Q)
     C                   SUB       1             @Q
      *
     C                   ENDSR
      **********************************************************************
      * Set up Transmitted Message Format for LEPARTPD
      **********************************************************************
     C     P#DLRA        BEGSR
      *
     C                   ADD       1             @Q
     C                   MOVEL     'P#DLRA'      STK(@Q)
      *
      * Retrieve the data from the file image and move into DS for LEPARTPD
      * start pos: 126, length: 701
      *
     C                   EVAL      W#FSIZ=%SIZE(LEPART)
     C                   EVAL      LEPART=%SUBST(P#PARM1:126:W#FSIZ)
      *
     C                   EXSR      MSGFRMT
      *
      * If the journal image has been rolled back setup flag
      *
     C     JOENTT        IFEQ      'DR'
     C     JOENTT        OREQ      'UR'
     C                   MOVE      'R'           ROLLB
     C                   ENDIF
      *
      * Format and populate data
      *
      * Access Currency Codes for decimal places for
      *  Participant/Assignment Currency
     C                   MOVE      F#PCCY        W#CCY
     C                   EXSR      GETNBDP
      *
     C                   MOVE      F#PCNUM       L3CNUM
     C                   MOVE      F#PFACT       L3FACT
     C                   MOVE      F#PFCNO       L3FCNO
     C                   MOVE      F#PMNUM       L3MNUM
     C                   MOVE      F#PINUM       L3INUM
      *   Joining Date
     C                   Z-ADD     F#PJDTE       W#ZDAYN
     C                   EXSR      ZZA0140
     C*****              MOVEL     W#ZDATE8      L3JDTE
     C                   MOVEL     W#DATE8       L3JDTE
      *   Value Date
     C                   Z-ADD     F#PVDTC       W#ZDAYN
     C                   EXSR      ZZA0140
     C*****              MOVEL     W#ZDATE8      L3VDTC
     C                   MOVEL     W#DATE8       L3VDTC
      *
     C                   MOVE      F#PSHTP       L3SHTP
      *   Syndicate or Assigned Share Percentage
     C                   MOVE(P)   F#PSHPC       ZFIELD
     C                   Z-ADD     12            ZADEC
     C                   EXSR      ZEDIT
     C                   MOVE      ZFIELD        L3SHPC
      *   Syndicate or Assigned Share Amount
     C                   MOVE(P)   F#PSHAM       ZFIELD
     C                   Z-ADD     A6NBDP        ZADEC
     C                   EXSR      ZEDIT
     C                   MOVE      ZFIELD        L3SHAM
      *
     C     F#PFEBR       IFNE      *ZEROS
     C                   MOVE      F#PFEBR       L3FEBR
     C                   ELSE
     C                   MOVE      *BLANKS       L3FEBR
     C                   ENDIF
      *
     C                   MOVE      F#PFERS       L3FERS
      *   Fee Rate/Spread
     C                   MOVE(P)   F#PFERA       ZFIELD
     C                   Z-ADD     7             ZADEC
     C                   EXSR      ZEDIT
     C                   MOVE      ZFIELD        L3FERA
      *
     C                   MOVE      F#PDRTP       L3DRTP
     C                   MOVE      F#PDRST       L3DRST
     C                   MOVE      F#PPSTM       L3PSTM
      *   Pay Our Nostro
     C                   EVAL      L3PONS=       F#POMDB + F#PPONS
      *
     C                   MOVE      F#PRVNO       L3RVNO
     C                   MOVE      F#PCVMR       L3CVMR
      *                                                                                       134495
     C*****F#PPOCN       IFNE      *ZEROS                                              134495 CSD027
     C     F#PPOCN       IFNE      *BLANKS                                                    CSD027
     C                   MOVE      F#PPOCN       L3POCN
     C                   ELSE                                                                 134495
     C                   MOVE      *BLANKS       L3POCN                                       134495
     C                   ENDIF                                                                134495
      *                                                                                       134495
     C*****F#PPOBN       IFNE      *ZEROS                                              134495 CSD027
     C     F#PPOBN       IFNE      *BLANKS                                                    CSD027
     C                   MOVE      F#PPOBN       L3POBN
     C                   ELSE                                                                 134495
     C                   MOVE      *BLANKS       L3POBN                                       134495
     C                   ENDIF                                                                134495
      *                                                                                       134495
     C                   MOVE      F#PRCRN       L3RCRN
     C                   MOVE      F#PRCRA       L3RCRA
     C                   MOVE      F#PPIBN       L3PIBN
     C                   MOVE      F#PPIBA       L3PIBA
     C                   MOVE      F#PAWBN       L3AWBN
     C                   MOVE      F#PAWBA       L3AWBA
     C                   MOVE      F#PBENN       L3BENN
     C                   MOVE      F#PBENA       L3BENA
     C                   MOVE      F#PRSTM       L3RSTM
      *   Receipt Our Nostro
     C                   EVAL      L3RONS=       F#POSDB + F#PRONS
      *
     C*****F#PROCN       IFNE      *ZEROS                                              134495 CSD027
     C     F#PROCN       IFNE      *BLANKS                                                    CSD027
     C                   MOVE      F#PROCN       L3ROCN
     C                   ELSE                                                                 134495
     C                   MOVE      *BLANKS       L3ROCN                                       134495
     C                   ENDIF                                                                134495
      *                                                                                       134495
     C*****F#PROBN       IFNE      *ZEROS                                              134495 CSD027
     C     F#PROBN       IFNE      *BLANKS                                                    CSD027
     C                   MOVE      F#PROBN       L3ROBN
     C                   ELSE                                                                 134495
     C                   MOVE      *BLANKS       L3ROBN                                       134495
     C                   ENDIF                                                                134495
      *                                                                                       134495
     C                   MOVE      F#PRIBN       L3RIBN
     C                   MOVE      F#PRIBA       L3RIBA
      *   Details of Payments
     C                   EVAL      L3DTP1=       F#PDTP1 +
     C                                           F#PDTP2 +
     C                                           F#PDTP3 +
     C                                           F#PDTP4
      *
     C                   MOVE      F#PDCHG       L3DCHG
      *   Bank to Bank Information
     C                   EVAL      L3BTB1=       F#PBTB1 +
     C                                           F#PBTB2 +
     C                                           F#PBTB3 +
     C                                           F#PBTB4 +
     C                                           F#PBTB5 +
     C                                           F#PBTB6
      *
     C                   MOVE      F#PPTAI       L3PTAI
     C                   MOVE      F#PBRCA       L3BRCA
     C                   MOVE      F#PCCY        L3CCY
     C                   MOVE      F#PPCRF       L3PCRF
      *                                                                                       CEU030
      **  Settlement Currency and IN Currency in Fld 72                                       CEU030
     C     CEU004        IFEQ      'Y'                                                        CEU030
     C                   MOVE      F#PSCCY       L3SCCY                                       CEU030
     C                   MOVE      F#PICCY       L3ICCY                                       CEU030
     C                   ENDIF                                                                CEU030
      *                                                                                       CEU030
     C                   MOVEL     F#PPCOB       X1FIL1
     C                   MOVE      FILLER        X1FIL1
      *                                                                                       CLE031
     C                   IF        CLE031 = 'Y'                                               CLE031
      *                                                                                       CLE031
      * (Receive) Settlement Currency                                                         CLE031
     C                   EVAL      L3SCCY = F#PSCCY                                           CLE031
      *                                                                                       CLE031
      * Receive Settlement Currency Exchange Rate                                             CLE031
     C                   Z-ADD     8             ZADEC                                        CLE031
     C                   MOVE      *BLANKS       ZFIELD                                       CLE031
     C                   MOVE      F#PREXR       ZFIELD                                       CLE031
     C                   EXSR      ZEDIT                                                      CLE031
     C                   MOVE      ZFIELD        L3REXR                                       CLE031
      *                                                                                       CLE031
      * Receive Settlement Currency Exchange Rate Indicator                                   CLE031
     C                   EVAL      L3REXI = F#PREXI                                           CLE031
      *                                                                                       CLE031
      * Pay Settlement Currency                                                               CLE031
     C                   EVAL      L3PSCY = F#PPSCY                                           CLE031
      *                                                                                       CLE031
      * Pay Settlement Currency Exchange Rate                                                 CLE031
     C                   Z-ADD     8             ZADEC                                        CLE031
     C                   MOVE      *BLANKS       ZFIELD                                       CLE031
     C                   MOVE      F#PPEXR       ZFIELD                                       CLE031
     C                   EXSR      ZEDIT                                                      CLE031
     C                   MOVE      ZFIELD        L3PEXR                                       CLE031
      *                                                                                       CLE031
      * Pay Settlement Currency Exchange Rate Indicator                                       CLE031
     C                   EVAL      L3PEXI = F#PPEXI                                           CLE031
     C                   ENDIF                                                                CLE031
      * Move message format
     C                   MOVEL(P)  DWL3MF        W#MFMT
      *
      * Put Message
     C                   EXSR      PMQPUT
      *
     C                   MOVE      *BLANKS       STK(@Q)
     C                   SUB       1             @Q
      *
     C                   ENDSR
      *
      **********************************************************************
      * Set up Transmitted Message Format for LEFCAMPD
      **********************************************************************
     C     P#DLFA        BEGSR
      *
     C                   ADD       1             @Q
     C                   MOVEL     'P#DLFA'      STK(@Q)
      *
      * Retrieve the data from the file image and move into DS for
      * LEFCAMPD start pos: 126, length: 90
      *
     C                   EVAL      W#FSIZ=%SIZE(LEFCAM)
     C                   EVAL      LEFCAM=%SUBST(P#PARM1:126:W#FSIZ)
      *
      * Get message attributes.
      *
     C                   MOVE      'DLFA'        X1MSGT
     C                   EXSR      MSGFRMT
     C                   MOVEL     F#APCOB       X1FIL1
      *
      * If the journal image has been rolled back setup flag
      *
     C     JOENTT        IFEQ      'DR'
     C     JOENTT        OREQ      'UR'
     C                   MOVE      'R'           ROLLB
     C                   ENDIF
      *
      * Clear all detail fields.
      *
     C                   CLEAR                   D4DTL
      *
      * Format and populate data
      *
      * Value Date
      *
     C                   Z-ADD     F#AVLDT       W#ZDAYN
     C                   EXSR      ZZA0140
     C                   MOVEL     W#DATE8       L4VLDT
      *
      * Next Expiry Date
      *
     C                   Z-ADD     F#ANDEX       W#ZDAYN
     C                   EXSR      ZZA0140
     C                   MOVEL     W#DATE8       L4NDEX
      *
      * Get number of decimal places
      *
     C                   MOVE      F#AACCY       W#CCY
     C                   EXSR      GETNBDP
     C                   Z-ADD     A6NBDP        ZADEC
      *
      * Facility Amendment amount
      *
     C                   MOVE      *BLANKS       ZFIELD
     C                   MOVE      F#AAAMT       ZFIELD
     C                   EXSR      ZEDIT
     C                   MOVE      ZFIELD        L4AAMT
      *
      * Move remaining fields to message format
      *
     C*****F#ACNUM       IFNE      0                                                          CSD027
     C     F#ACNUM       IFNE      *BLANKS                                                    CSD027
     C                   MOVE      F#ACNUM       L4CNUM
     C                   ENDIF
     C     F#AFACT       IFNE      0
     C                   MOVE      F#AFACT       L4FACT
     C                   ENDIF
     C     F#AFCNO       IFNE      0
     C                   MOVE      F#AFCNO       L4FCNO
     C                   ENDIF
     C     F#ASQNO       IFNE      0
     C                   MOVE      F#ASQNO       L4SQNO
     C                   ENDIF
      *
     C                   MOVE      F#AACCY       L4ACCY
     C                   MOVE      F#ARVCR       L4RVCR
     C                   MOVE      F#AIUSR       L4IUSR
     C                   MOVE      F#AAUSR       L4AUSR
     C                   MOVE      F#AXUSR       L4XUSR
     C                   MOVE      F#ARECI       L4RECI
     C                   MOVE      F#ABRCA       L4BRCA
     C                   MOVE      F#AFATP       L4FATP
     C                   MOVE      F#AASTS       L4ASTS
     C                   MOVE      F#APCRF       L4PCRF
     C                   MOVE      F#AGASSA      L4GASS                                       225605
      *
     C                   MOVE      FILLER        X1FIL1
      *
      * Move message format
      *
     C                   MOVEL(P)  DWL4MF        W#MFMT
      *
      * Put Message
      *
     C                   EXSR      PMQPUT
      *
     C                   MOVE      *BLANKS       STK(@Q)
     C                   SUB       1             @Q
      *
     C                   ENDSR
      *
      **********************************************************************
      * Set up Transmitted Message Format for LEFEED
      **********************************************************************
     C     P#DLFE        BEGSR
      *
     C                   ADD       1             @Q
     C                   MOVEL     'P#DLFE'      STK(@Q)
      *
      * Retrieve the data from the file image and move into DS for
      * LEFEED start pos: 126, length: 937
      *
     C                   EVAL      W#FSIZ=%SIZE(LEFEE)
     C                   EVAL      LEFEE=%SUBST(P#PARM1:126:W#FSIZ)
      *
      * Get message attributes.
      *
     C                   MOVE      'DLFE'        X1MSGT
     C                   EXSR      MSGFRMT
      *                                                                                       CEU030
      **  Settlement Currency and IN Currency in Fld 72                                       CEU030
     C     CEU004        IFEQ      'Y'                                                        CEU030
     C                   MOVE      F#EFESCCY     L5SCCY                                       CEU030
     C                   MOVE      F#EFEICCY     L5ICCY                                       CEU030
     C                   ENDIF                                                                CEU030
      *                                                                                       CEU030
     C                   MOVEL     F#EPCOB       X1FIL1
      *
      * If the journal image has been rolled back setup flag
      *
     C     JOENTT        IFEQ      'DR'
     C     JOENTT        OREQ      'UR'
     C                   MOVE      'R'           ROLLB
     C                   ENDIF
      *
      * Clear all detail fields.
      *
     C                   CLEAR                   D5DTL
      *
      * Format and populate data
      *
      * Fee period Start Date
      *
     C                   Z-ADD     F#EFEPSTD     W#ZDAYN
     C                   EXSR      ZZA0140
     C                   MOVEL     W#DATE8       L5PSTD
      *
      * Fee Period End Date
      *
     C                   Z-ADD     F#EFEPEND     W#ZDAYN
     C                   EXSR      ZZA0140
     C                   MOVEL     W#DATE8       L5PEND
      *
      * Next Fee Payment Date
      *
     C                   Z-ADD     F#EFENPYD     W#ZDAYN
     C                   EXSR      ZZA0140
     C                   MOVEL     W#DATE8       L5NPYD
      *
      * Fee Settled Date
      *
     C                   Z-ADD     F#EFESDAT     W#ZDAYN
     C                   EXSR      ZZA0140
     C                   MOVEL     W#DATE8       L5SDAT
      *
      * Last Payment Date
      *
     C                   Z-ADD     F#EFELPDT     W#ZDAYN
     C                   EXSR      ZZA0140
     C                   MOVEL     W#DATE8       L5LPDT
      *
      * Last Accrual Date
      *
     C                   Z-ADD     F#EFELADT     W#ZDAYN
     C                   EXSR      ZZA0140
     C                   MOVEL     W#DATE8       L5LADT
      *
      * Past Due Date
      *
     C                   Z-ADD     F#EFEDDAT     W#ZDAYN
     C                   EXSR      ZZA0140
     C                   MOVEL     W#DATE8       L5DDAT
      *
      * Previous Last Payment Date
      *
     C                   Z-ADD     F#EFEPLPD     W#ZDAYN
     C                   EXSR      ZZA0140
     C                   MOVEL     W#DATE8       L5PLPD
      *
      * Get number of decimal places
      *
     C                   MOVE      F#EFEFCCY     W#CCY
     C                   EXSR      GETNBDP
     C                   Z-ADD     A6NBDP        ZADEC
      *
      * Flat Fees Amount
      *
     C     F#EFEFAMT     IFGE      0
     C                   Z-ADD     F#EFEFAMT     W#DFAMT          13 0
     C                   ELSE
     C                   Z-SUB     F#EFEFAMT     W#DFAMT
     C                   ENDIF
      *
     C                   MOVE      *BLANKS       ZFIELD
     C                   MOVE      W#DFAMT       ZFIELD
     C                   EXSR      ZEDIT
     C     F#EFEFAMT     IFNE      *ZEROS                                                     135072
     C                   MOVE      ZFIELD        L5FAMT
     C                   ELSE                                                                 135072
     C                   MOVE      *BLANKS       L5FAMT                                       135072
     C                   ENDIF                                                                135072
      *
      * Fee Amount Past Due
      *
     C                   MOVE      *BLANKS       ZFIELD
     C                   MOVE      '+'           L5FAPI                                       148756
     C     F#EFEAMTP     IFLT      *ZERO                                                      148756
     C                   MOVE      '-'           L5FAPI                                       148756
     C                   MULT      -1            F#EFEAMTP                                    148756
     C                   ENDIF                                                                148756
     C                   MOVE      F#EFEAMTP     ZFIELD
     C                   EXSR      ZEDIT
     C                   MOVE      ZFIELD        L5AMTP
      *
      * Fee Adjustment Amount
      *
     C                   MOVE      *BLANKS       ZFIELD
     C                   MOVE      F#EFEAMTA     ZFIELD
     C                   EXSR      ZEDIT
     C                   MOVE      ZFIELD        L5AMTA
      *
      * Fee Settled Amount
      *
     C                   MOVE      *BLANKS       ZFIELD
     C                   MOVE      F#EFEAMTS     ZFIELD
     C                   EXSR      ZEDIT
     C                   MOVE      ZFIELD        L5AMTS
      *
      * Total Fees Accrued to Date
      *
     C                   MOVE      *BLANKS       ZFIELD
     C                   MOVE      F#EFEADAT     ZFIELD
     C                   EXSR      ZEDIT
     C                   MOVE      ZFIELD        L5ADAT
      *
      * Outstanding Fee Amount
      *
     C                   MOVE      *BLANKS       ZFIELD
     C                   MOVE      F#EFEAMTO     ZFIELD
     C                   EXSR      ZEDIT
     C                   MOVE      ZFIELD        L5AMTO
      *
      * Last Payment Fee Amount
      *
     C                   MOVE      *BLANKS       ZFIELD
     C                   MOVE      F#EFELPAM     ZFIELD
     C                   EXSR      ZEDIT
     C                   MOVE      ZFIELD        L5LPAM
      *
      * Last Payment Fees Accrued to Date
      *
     C                   MOVE      *BLANKS       ZFIELD
     C                   MOVE      F#EFEADBP     ZFIELD
     C                   EXSR      ZEDIT
     C                   MOVE      ZFIELD        L5ADBP
      *
      * Last Payment Fee Settled Amount
      *
     C                   MOVE      *BLANKS       ZFIELD
     C                   MOVE      F#EFEPAMS     ZFIELD
     C                   EXSR      ZEDIT
     C                   MOVE      ZFIELD        L5PAMS
      *
      * Last Payment Fee Amount Past Due
      *
     C                   MOVE      *BLANKS       ZFIELD
     C                   MOVE      F#EFEPAMP     ZFIELD
     C                   EXSR      ZEDIT
     C                   MOVE      ZFIELD        L5PAMP
      *
      * Fee Rate - Tiers 1 to 5
      *
     C                   Z-ADD     5             ZADEC
      *
     C                   MOVE      *BLANKS       ZFIELD
     C                   MOVE      F#EFEFRT1     ZFIELD
     C                   EXSR      ZEDIT
     C                   MOVE      ZFIELD        L5FRT1
      *
     C                   MOVE      *BLANKS       ZFIELD
     C                   MOVE      F#EFEFRT2     ZFIELD
     C                   EXSR      ZEDIT
     C                   MOVE      ZFIELD        L5FRT2
      *
     C                   MOVE      *BLANKS       ZFIELD
     C                   MOVE      F#EFEFRT3     ZFIELD
     C                   EXSR      ZEDIT
     C                   MOVE      ZFIELD        L5FRT3
      *
     C                   MOVE      *BLANKS       ZFIELD
     C                   MOVE      F#EFEFRT4     ZFIELD
     C                   EXSR      ZEDIT
     C                   MOVE      ZFIELD        L5FRT4
      *
     C                   MOVE      *BLANKS       ZFIELD
     C                   MOVE      F#EFEFRT5     ZFIELD
     C                   EXSR      ZEDIT
     C                   MOVE      ZFIELD        L5FRT5
      *
      * Format Fee Amounts - Tiers 1 to 5 according to the number of   .
      * decimal places.
      *
     C     F#EFEPIND     IFEQ      'A'
     C                   Z-ADD     0             ZADEC
     C                   ELSE
     C                   Z-ADD     3             ZADEC
     C                   ENDIF
      *
      * Tiers 1 to 5
      *
     C                   MOVE      *BLANKS       ZFIELD
     C                   MOVE      F#EFEAMT1     ZFIELD
     C                   EXSR      ZEDIT
     C                   MOVE      ZFIELD        L5AMT1
      *
     C                   MOVE      *BLANKS       ZFIELD
     C                   MOVE      F#EFEAMT2     ZFIELD
     C                   EXSR      ZEDIT
     C                   MOVE      ZFIELD        L5AMT2
      *
     C                   MOVE      *BLANKS       ZFIELD
     C                   MOVE      F#EFEAMT3     ZFIELD
     C                   EXSR      ZEDIT
     C                   MOVE      ZFIELD        L5AMT3
      *
     C                   MOVE      *BLANKS       ZFIELD
     C                   MOVE      F#EFEAMT4     ZFIELD
     C                   EXSR      ZEDIT
     C                   MOVE      ZFIELD        L5AMT4
      *
     C                   MOVE      *BLANKS       ZFIELD
     C                   MOVE      F#EFEAMT5     ZFIELD
     C                   EXSR      ZEDIT
     C                   MOVE      ZFIELD        L5AMT5
      *
      * Facility Currency Exchange Rate
      *
     C                   Z-ADD     8             ZADEC
     C                   MOVE      *BLANKS       ZFIELD
     C                   MOVE      F#EFEERAT     ZFIELD
     C                   EXSR      ZEDIT
     C                   MOVE      ZFIELD        L5ERAT
      *
      * Details of Payment 1 - 4
      *
     C                   EVAL      L5DTPN=       F#EDTP1 +
     C                                           F#EDTP2 +
     C                                           F#EDTP3 +
     C                                           F#EDTP4
      *
      * Bank to Bank Info 1 - 6
      *
     C                   EVAL      L5BTBN=       F#EBTB1 +
     C                                           F#EBTB2 +
     C                                           F#EBTB3 +
     C                                           F#EBTB4 +
     C                                           F#EBTB5 +
     C                                           F#EBTB6
      *
      * Format remaining fields.
      *
     C*****F#EFECNUM     IFNE      0                                                          CSD027
     C     F#EFECNUM     IFNE      *BLANKS                                                    CSD027
     C                   MOVE      F#EFECNUM     L5CNUM
     C                   ENDIF
      *
     C     F#EFEFACL     DIV       100           W5FACT
     C     W5FACT        IFNE      0
     C                   MOVE      W5FACT        L5FACT
     C                   ENDIF
      *
     C                   Z-ADD     F#EFEFACL     W5FCNO
     C     W5FCNO        IFNE      0
     C                   MOVE      W5FCNO        L5FCNO
     C                   ENDIF
      *
     C*****F#EFELOAN     IFNE      0                                                          CLE148
     C     F#EFELOAN     IFNE      *BLANKS                                                    CLE148
     C                   MOVE      F#EFELOAN     L5LOAN
     C                   ENDIF
      *
     C     F#EFEFSEQ     IFNE      0
     C                   MOVE      F#EFEFSEQ     L5FSEQ
     C                   ENDIF
      *
     C     F#EFEFCOD     IFNE      0
     C                   MOVE      F#EFEFCOD     L5FCOD
     C                   ENDIF
      *
     C     F#EFECALC     IFNE      0
     C                   MOVE      F#EFECALC     L5CALC
     C                   ENDIF
      *
     C     F#EFEDYIM     IFNE      0
     C                   MOVE      F#EFEDYIM     L5DYIM
     C                   ENDIF
      *
     C     F#EPSTM       IFNE      0
     C                   MOVE      F#EPSTM       L5PSTM
     C                   ENDIF
      *
     C*****F#EPOCN       IFNE      0                                                          CSD027
     C     F#EPOCN       IFNE      *BLANKS                                                    CSD027
     C                   MOVE      F#EPOCN       L5POCN
     C                   ENDIF
      *
     C*****F#EPOBN       IFNE      0                                                          CSD027
     C     F#EPOBN       IFNE      *BLANKS                                                    CSD027
     C                   MOVE      F#EPOBN       L5POBN
     C                   ENDIF
      *
     C     F#ERSTM       IFNE      0
     C                   MOVE      F#ERSTM       L5RSTM
     C                   ENDIF
      *
     C*****F#EROCN       IFNE      0                                                          CSD027
     C     F#EROCN       IFNE      *BLANKS                                                    CSD027
     C                   MOVE      F#EROCN       L5ROCN
     C                   ENDIF
      *
     C*****F#EROBN       IFNE      0                                                          CSD027
     C     F#EROBN       IFNE      *BLANKS                                                    CSD027
     C                   MOVE      F#EROBN       L5ROBN
     C                   ENDIF
      *
     C*****F#ESMAC       IFNE      0                                                          CSD027
     C     F#ESMAC       IFNE      *BLANKS                                                    CSD027
     C                   MOVE      F#ESMAC       L5SMAC
     C                   ENDIF
      *
     C     F#EFEFAMT     IFGE      0
     C                   MOVE      '+'           L5FAMI
     C                   ELSE
     C                   MOVE      '-'           L5FAMI
     C                   ENDIF
      *
      * Move remaining fields.
      *
     C                   MOVE      F#EPTFI       L5PTFI
     C                   MOVE      F#EPTAI       L5PTAI
     C                   MOVE      F#EFEPIND     L5PIND
     C                   MOVE      F#EFEFCCY     L5FCCY
     C                   MOVE      F#EFEPYON     L5PYON
     C                   MOVE      F#EFEAUTO     L5AUTO
     C                   MOVE      F#EFECALT     L5CALT
     C                   MOVE      F#EFEFREQ     L5FREQ
     C                   MOVE      F#EFEMDIN     L5MDIN
     C*****              MOVEL     F#EPONS       L5PONS                                       136318
      *                                                                                       136318
      *   Pay Our Nostro                                                                      136318
     C                   EVAL      L5PONS=       F#EOMDB+F#EPONS                              136318
      *                                                                                       136318
     C                   MOVE      F#ERVNO       L5RVNO
     C                   MOVE      F#ECVMR       L5CVMR
     C                   MOVE      F#ERCRN       L5RCRN
     C                   MOVE      F#ERCRA       L5RCRA
     C                   MOVE      F#EPIBN       L5PIBN
     C                   MOVE      F#EPIBA       L5PIBA
     C                   MOVE      F#EAWBN       L5AWBN
     C                   MOVE      F#EAWBA       L5AWBA
     C                   MOVE      F#EBENN       L5BENN
     C                   MOVE      F#EBENA       L5BENA
     C*****              MOVEL     F#ERONS       L5RONS                                       136318
      *                                                                                       136318
      *   Receive Our Nostro                                                                  136318
     C                   EVAL      L5RONS=       F#EOSDB+F#ERONS                              136318
      *                                                                                       136318
     C                   MOVE      F#ERIBN       L5RIBN
     C                   MOVE      F#ERIBA       L5RIBA
     C                   MOVE      F#EDCHG       L5DCHG
     C                   MOVE      F#ESHFI       L5SHFI
     C                   MOVE      F#EGFPT       L5GFPT
     C                   MOVE      F#EIUSR       L5IUSR
     C                   MOVE      F#EAUSR       L5AUSR
     C                   MOVE      F#EXUSR       L5XUSR
     C                   MOVE      F#EFERECI     L5RECI
     C                   MOVE      F#EFEBRCA     L5BRCA
     C                   MOVE      F#EFEACOF     L5ACOF
     C                   MOVE      F#EFEDIND     L5DIND
     C                   MOVE      F#EFELTYP     L5LTYP
     C                   MOVE      F#EFESUTP     L5SUTP
     C                   MOVE      F#EFESPTI     L5SPTI
     C                   MOVE      F#EFEPPTI     L5PPTI
     C                   MOVE      F#EFEEPTI     L5EPTI
     C                   MOVE      F#EFESBTI     L5SBTI
     C                   MOVE      F#EFEPBTI     L5PBTI
     C                   MOVE      F#EFEEBTI     L5EBTI
     C                   MOVE      F#EFSTS       L5FSTS
     C                   MOVE      F#EPCRF       L5PCRF
     C                   MOVE      F#EFEPRFC     L5PRFC                                       133237
     C                   MOVE      F#EPCOB       L5PCOB                                       157286
      *
     C                   MOVE      FILLER        X1FIL1
      *                                                                                       CLE031
     C                   IF        CLE031 = 'Y'                                               CLE031
      *                                                                                       CLE031
      * (Receive) Settlement Currency                                                         CLE031
     C                   EVAL      L5SCCY = F#EFESCCY                                         CLE031
      *                                                                                       CLE031
      * Receive Settlement Currency Exchange Rate                                             CLE031
     C                   Z-ADD     8             ZADEC                                        CLE031
     C                   MOVE      *BLANKS       ZFIELD                                       CLE031
     C                   MOVE      F#EFEREXR     ZFIELD                                       CLE031
     C                   EXSR      ZEDIT                                                      CLE031
     C                   MOVE      ZFIELD        L5REXR                                       CLE031
      *                                                                                       CLE031
      * Receive Settlement Currency Exchange Rate Indicator                                   CLE031
     C                   EVAL      L5REXI = F#EFEREXI                                         CLE031
      *                                                                                       CLE031
      * Pay Settlement Currency                                                               CLE031
     C                   EVAL      L5PSCY = F#EFEPSCY                                         CLE031
      *                                                                                       CLE031
      * Pay Settlement Currency Exchange Rate                                                 CLE031
     C                   Z-ADD     8             ZADEC                                        CLE031
     C                   MOVE      *BLANKS       ZFIELD                                       CLE031
     C                   MOVE      F#EFEPEXR     ZFIELD                                       CLE031
     C                   EXSR      ZEDIT                                                      CLE031
     C                   MOVE      ZFIELD        L5PEXR                                       CLE031
      *                                                                                       CLE031
      * Pay Settlement Currency Exchange Rate Indicator                                       CLE031
     C                   EVAL      L5PEXI = F#EFEPEXI                                         CLE031
     C                   ENDIF                                                                CLE031
                                                                                              CLE034
      ** Setup Settlement Allocation indicator when CLE034 is installed                       CLE034
                                                                                              CLE034
     C                   IF        CLE034 = 'Y'                                               CLE034
     C                   EVAL      L5STAL = F#EFESTAL                                         CLE034
     C                   ENDIF                                                                CLE034
      *
      * Move message format
      *
     C                   MOVEL(P)  DWL5MF        W#MFMT
      *
      * Put Message
      *
     C                   EXSR      PMQPUT
      *
     C                   MOVE      *BLANKS       STK(@Q)
     C                   SUB       1             @Q
      *
     C                   ENDSR
      *
      **********************************************************************
      * Set up Transmitted Message Format for LEFEEAD
      **********************************************************************
     C     P#DLFS        BEGSR
      *
     C                   ADD       1             @Q
     C                   MOVEL     'P#DLFS'      STK(@Q)
      *
      * Retrieve the data from the file image and move into DS for
      * LEFEEAD start pos: 126, length: 762
      *
     C                   EVAL      W#FSIZ=%SIZE(LEFEEA)
     C                   EVAL      LEFEEA=%SUBST(P#PARM1:126:W#FSIZ)
      *
      * Get message attributes.
      *
     C                   MOVE      'DLFS'        X1MSGT
     C                   EXSR      MSGFRMT
      *                                                                                       CEU030
      **  Settlement Currency and IN Currency in Fld 72                                       CEU030
     C     CEU004        IFEQ      'Y'                                                        CEU030
     C                   MOVE      F#SFASCCY     L6SCCY                                       CEU030
     C                   MOVE      F#SFAICCY     L6ICCY                                       CEU030
     C                   ENDIF                                                                CEU030
      *                                                                                       CEU030
     C                   MOVEL     F#SPCOB       X1FIL1
      *
      * If the journal image has been rolled back setup flag
      *
     C     JOENTT        IFEQ      'DR'
     C     JOENTT        OREQ      'UR'
     C                   MOVE      'R'           ROLLB
     C                   ENDIF
      *
      * Clear all detail fields.
      *
     C                   CLEAR                   D6DTL
      *
      * Format and populate data
      *
      * Settlement Due Date.
      *
     C*****              Z-ADD     F#SFASADD     W#ZDAYN                                      152695
     C                   Z-ADD     F#SFAVDAT     W#ZDAYN                                      152695
     C                   EXSR      ZZA0140
     C                   MOVEL     W#DATE8       L6SADD
     C                   MOVE      F#SFARECI     W#RECI                                       CLE034
      *
      * Get number of decimal places
      *
     C                   MOVE      F#SFAFCCY     W#CCY
     C                   EXSR      GETNBDP
     C                   Z-ADD     A6NBDP        ZADEC
      *
      * Fee Settlement Amount
      *
     C                   MOVE      *BLANKS       ZFIELD
     C                   MOVE      F#SFASADJ     ZFIELD
     C                   EXSR      ZEDIT
     C                   MOVE      ZFIELD        L6SADJ
      *
      * Details of Payment 1 - 4
      *
     C                   EVAL      L6DTPN=       F#SDTP1 +
     C                                           F#SDTP2 +
     C                                           F#SDTP3 +
     C                                           F#SDTP4
      *
      * Bank to Bank Info 1 - 6
      *
     C                   EVAL      L6BTBN=       F#SBTB1 +
     C                                           F#SBTB2 +
     C                                           F#SBTB3 +
     C                                           F#SBTB4 +
     C                                           F#SBTB5 +
     C                                           F#SBTB6
      *
      * Format other details.
      *
     C*****F#SFACNUM     IFNE      0                                                          CSD027
     C     F#SFACNUM     IFNE      *BLANKS                                                    CSD027
     C                   MOVE      F#SFACNUM     L6CNUM
     C                   ENDIF
      *
     C     F#SFAFACL     DIV       100           W6FACT
     C     W6FACT        IFNE      0
     C                   MOVE      W6FACT        L6FACT
     C                   ENDIF
      *
     C                   Z-ADD     F#SFAFACL     W6FCNO
     C     W6FCNO        IFNE      0
     C                   MOVE      W6FCNO        L6FCNO
     C                   ENDIF
      *
     C     F#SFAFSEQ     IFNE      0
     C                   MOVE      F#SFAFSEQ     L6FSEQ
     C                   ENDIF
      *
     C     F#SPSTM       IFNE      0
     C                   MOVE      F#SPSTM       L6PSTM
     C                   ENDIF
      *
     C*****F#SPOCN       IFNE      0                                                          CSD027
     C     F#SPOCN       IFNE      *BLANKS                                                    CSD027
     C                   MOVE      F#SPOCN       L6POCN
     C                   ENDIF
      *
     C*****F#SPOBN       IFNE      0                                                          CSD027
     C     F#SPOBN       IFNE      *BLANKS                                                    CSD027
     C                   MOVE      F#SPOBN       L6POBN
     C                   ENDIF
      *
     C     F#SRSTM       IFNE      0
     C                   MOVE      F#SRSTM       L6RSTM
     C                   ENDIF
      *
     C*****F#SROCN       IFNE      0                                                          CSD027
     C     F#SROCN       IFNE      *BLANKS                                                    CSD027
     C                   MOVE      F#SROCN       L6ROCN
     C                   ENDIF
      *
     C*****F#SROBN       IFNE      0                                                          CSD027
     C     F#SROBN       IFNE      *BLANKS                                                    CSD027
     C                   MOVE      F#SROBN       L6ROBN
     C                   ENDIF
      *
     C*****F#SFALOAN     IFNE      0                                                          CLE148
     C     F#SFALOAN     IFNE      *BLANKS                                                    CLE148
     C                   MOVE      F#SFALOAN     L6LOAN
     C                   ENDIF
      *
      * Move other details.
      *
     C                   MOVE      F#SFASIGN     L6SIGN
     C                   MOVE      F#SFATYPE     L6TYPE
     C****               MOVEL     F#SPONS       L6PONS
      *                                                                                       136318
      *   Pay Our Nostro                                                                      136318
     C                   EVAL      L6PONS=       F#SOMDB+F#SPONS                              136318
      *                                                                                       136318
     C                   MOVE      F#SRVNO       L6RVNO
     C                   MOVE      F#SCVMR       L6CVMR
     C                   MOVE      F#SRCRN       L6RCRN
     C                   MOVE      F#SRCRA       L6RCRA
     C                   MOVE      F#SPIBN       L6PIBN
     C                   MOVE      F#SPIBA       L6PIBA
     C                   MOVE      F#SAWBN       L6AWBN
     C                   MOVE      F#SAWBA       L6AWBA
     C                   MOVE      F#SBENN       L6BENN
     C                   MOVE      F#SBENA       L6BENA
     C****               MOVEL     F#SRONS       L6RONS
      *                                                                                       136318
      *   Receive Our Nostro                                                                  136318
     C                   EVAL      L6RONS=       F#SOSDB+F#SRONS                              136318
      *                                                                                       136318
     C                   MOVE      F#SRIBN       L6RIBN
     C                   MOVE      F#SRIBA       L6RIBA
     C                   MOVE      F#SDCHG       L6DCHG
     C                   MOVE      F#SIUSR       L6IUSR
     C                   MOVE      F#SAUSR       L6AUSR
     C                   MOVE      F#SXUSR       L6XUSR
     C                   MOVE      F#SFARECI     L6RECI
     C                   MOVE      F#SFABRCA     L6BRCA
     C                   MOVE      F#SFAFCCY     L6FCCY
     C                   MOVE      F#SSSTS       L6SSTS
     C                   MOVE      F#SPCRF       L6PCRF
     C                   MOVE      F#SPTFI       L6PTFI
      *
     C                   MOVE      FILLER        X1FIL1
      *                                                                                       CLE031
     C                   IF        CLE031 = 'Y'                                               CLE031
      *                                                                                       CLE031
      * (Receive) Settlement Currency                                                         CLE031
     C                   EVAL      L6SCCY = F#SFASCCY                                         CLE031
      *                                                                                       CLE031
      * Receive Settlement Currency Exchange Rate                                             CLE031
     C                   Z-ADD     8             ZADEC                                        CLE031
     C                   MOVE      *BLANKS       ZFIELD                                       CLE031
     C                   MOVE      F#SFAREXR     ZFIELD                                       CLE031
     C                   EXSR      ZEDIT                                                      CLE031
     C                   MOVE      ZFIELD        L6REXR                                       CLE031
      *                                                                                       CLE031
      * Receive Settlement Currency Exchange Rate Indicator                                   CLE031
     C                   EVAL      L6REXI = F#SFAREXI                                         CLE031
      *                                                                                       CLE031
      * Pay Settlement Currency                                                               CLE031
     C                   EVAL      L6PSCY = F#SFAPSCY                                         CLE031
      *                                                                                       CLE031
      * Pay Settlement Currency Exchange Rate                                                 CLE031
     C                   Z-ADD     8             ZADEC                                        CLE031
     C                   MOVE      *BLANKS       ZFIELD                                       CLE031
     C                   MOVE      F#SFAPEXR     ZFIELD                                       CLE031
     C                   EXSR      ZEDIT                                                      CLE031
     C                   MOVE      ZFIELD        L6PEXR                                       CLE031
      *                                                                                       CLE031
      * Pay Settlement Currency Exchange Rate Indicator                                       CLE031
     C                   EVAL      L6PEXI = F#SFAPEXI                                         CLE031
     C                   ENDIF                                                                CLE031
                                                                                              CLE034
      ** Setup Settlement Allocation Indicator when CLE034 is installed                       CLE034
                                                                                              CLE034
     C                   IF        CLE034 = 'Y'                                               CLE034
     C                   EVAL      L6STAL = F#SFASTAL                                         CLE034
     C                   ENDIF                                                                CLE034
      *
      * Move message format
      *
     C                   MOVEL(P)  DWL6MF        W#MFMT
      *
      * Put Message
      *
     C                   EXSR      PMQPUT
      *
     C                   MOVE      *BLANKS       STK(@Q)
     C                   SUB       1             @Q
      *
     C                   ENDSR
      *
      **********************************************************************
      * Set up Transmitted Message Format for MUSERDD
      **********************************************************************
     C     P#USER        BEGSR
      *
     C                   ADD       1             @Q
     C                   MOVEL     'P#USER'      STK(@Q)
      *
      * Retrieve the data from the file image and move into DS for
      * MUSERDD start pos: 126, length: 211
      *
     C                   EVAL      W#FSIZ=%SIZE(MUSER)
     C                   EVAL      MUSER=%SUBST(P#PARM1:126:W#FSIZ)
      *
      * Get message attributes.
      *
     C                   MOVE      'USER'        X1MSGT
     C                   EXSR      MSGFRMT
     C                   MOVEL     F#UDBRN       X1FIL1
      *
      * If the journal image has been rolled back setup flag
      *
     C     JOENTT        IFEQ      'DR'
     C     JOENTT        OREQ      'UR'
     C                   MOVE      'R'           ROLLB
     C                   ENDIF
      *
      * Clear all detail fields.
      *
     C                   CLEAR                   DUDTL
      *
      * Move User ID and Language Code.
      *
     C                   MOVEL     F#UUSRP       LUUSID
     C                   MOVEL     F#UMULT       LUMULT
     C*                                                                                       155429
     C** Move User Default Branch.                                                            155429
     C*                                                                                       155429
     C                   MOVEL     F#UDBRN       LUDBRN                                       155429
      *
     C                   MOVE      FILLER        X1FIL1
      *
      * Move message format
      *
     C                   MOVEL(P)  DWSWMF        W#MFMT
      *
      * Put Message
      *
     C                   EXSR      PMQPUT
      *
     C                   MOVE      *BLANKS       STK(@Q)
     C                   SUB       1             @Q
      *
     C                   ENDSR
      *
      **********************************************************************
      * Set up Transmitted Message Format for SCSARDPD
      **********************************************************************
     C     P#SARD        BEGSR
      *
     C                   ADD       1             @Q
     C                   MOVEL     'P#SARD'      STK(@Q)
      *
      * Retrieve the data from the file image and move into DS for SARD
      * start pos: 126, length: 60
      *
     C                   EVAL      W#FSIZ=%SIZE(SCSARD)
     C                   EVAL      SCSARD=%SUBST(P#PARM1:126:W#FSIZ)
      *
     C                   EXSR      MSGFRMT
      *
      * Format and populate data
     C                   MOVE      SARN          SSSARN
     C                   MOVE      SARD          SSSARD
      *
      * Move message format
     C                   MOVEL(P)  DWSSMF        W#MFMT
      *
      * Put Message
     C                   EXSR      PMQPUT
      *
     C                   MOVE      *BLANKS       STK(@Q)
     C                   SUB       1             @Q
      *
     C                   ENDSR
      **********************************************************************
      * Set up Transmitted Message Format for SDMMODPD
      **********************************************************************
     C     P#MMOD        BEGSR
      *
     C                   ADD       1             @Q
     C                   MOVEL     'P#MMOD'      STK(@Q)
      *
      * Retrieve the data from the file image and move into DS for MMOD
      * start pos: 126, length: 256
      *
     C                   EVAL      W#FSIZ=%SIZE(SDMMOD)
     C                   EVAL      SDMMOD=%SUBST(P#PARM1:126:W#FSIZ)
      *
     C                   EXSR      MSGFRMT
      *
      * Format and populate data
     C                   MOVE      BGMTCL        S1MTCL
     C                   MOVE      BGSWCL        S1SWCL
     C                   MOVE      BGRTBN        S1RTBN
     C                   MOVE      BGPFMG        S1PFMG
     C                   MOVE      BGCHIP        S1CHIP
     C                   MOVE      BGMBIN        S1MBIN
     C                   MOVE      BGN0ST        S1N0ST
     C*                                                                                       CPB003
     C** Always send this information to ensure the length of the                             CPB003
     C** message is the expected length. Note in Loan Manager will only                       CPB003
     C** populate tables with this information if the feature is on                           CPB003
     C*                                                                                       CPB003
     C                   MOVE      BGN4ST        S1N4ST                                       CPB003
      *
      * Move message format
     C                   MOVEL(P)  DWS1MF        W#MFMT
      *
      * Put Message
     C                   EXSR      PMQPUT
      *
     C                   MOVE      *BLANKS       STK(@Q)
     C                   SUB       1             @Q
      *
     C                   ENDSR
      **********************************************************************
      * Set up Transmitted Message Format for SDBANKPD
      **********************************************************************
     C     P#BANK        BEGSR
      *
     C                   ADD       1             @Q
     C                   MOVEL     'P#BANK'      STK(@Q)
      *
      * Retrieve the data from the file image and move into DS for BANK
      * start pos: 126, length: 118
      *
     C                   EVAL      W#FSIZ=%SIZE(SDBANK)
     C                   EVAL      SDBANK=%SUBST(P#PARM1:126:W#FSIZ)
      *
     C                   EXSR      MSGFRMT
      *
      * Format and populate data
     C                   MOVE      BJCNCD        S2CNCD
     C                   MOVE      BJCYCD        S2CYCD
     C                   MOVE      BJHOCY        S2HOCY
     C                   MOVE      BJLCCY        S2LCCY
     C                   MOVE      BJSBRC        S2SBRC
     C                   MOVE      BJCUST        S2CUST
     C                   MOVE      BJSLCD        S2SLCD
     C                   MOVE      BJDFIN        S2DFIN
     C                   MOVE      W#SYSDAT      S2SYDT
     C                   MOVE      W#DNWD        S2DNWD
     C                   MOVE      BJURPT        S2URPT
     C                   MOVE      W#EYD         S2EYD
     C                   MOVE      W#PEYD        S2PEYD
     C                   Z-ADD     BJBVPD        S2BVPD
      *
      * Move message format
     C                   MOVEL(P)  DWS2MF        W#MFMT
      *
      * Put Message
     C                   EXSR      PMQPUT
      *
     C                   MOVE      *BLANKS       STK(@Q)
     C                   SUB       1             @Q
      *
     C                   ENDSR
      **********************************************************************
      * Set up Transmitted Message Format for SDGELRPD
      **********************************************************************
     C     P#GELR        BEGSR
      *
     C                   ADD       1             @Q
     C                   MOVEL     'P#GELR'      STK(@Q)
      *
      * Retrieve the data from the file image and move into DS for GELR
      * start pos: 126, length: 77
      *
     C                   EVAL      W#FSIZ=%SIZE(SDGELR)
     C                   EVAL      SDGELR=%SUBST(P#PARM1:126:W#FSIZ)
      *
     C                   EXSR      MSGFRMT
      *
      * Format and populate data
      *   Convert Accruals Profit Date to DDMMYYYY or MMDDYYYY
     C                   Z-ADD     BKAPDT        W#ZDAYN
     C                   EXSR      ZZA0140
     C**********         MOVEL     W#ZDATE8      S3APDT                                       228849
     C                   MOVEL     W#DATE8       S3APDT                                       228849
      *
     C                   MOVE      BKAPFQ        S3APFQ
     C                   MOVE      BKAPFD        S3APFD
     C                   MOVE      BKALDI        S3ALDI
     C                   MOVE      BKANWD        S3ANWD
     C                   MOVE      BKPRCU        S3PRCU
     C                   MOVE      BKPRCA        S3PRCA
     C                   MOVE      BKPCDU        S3PCDU
     C                   MOVE      BKPMBK        S3PMBK
     C                   MOVE      BKPMTT        S3PMTT
     C                   MOVE      BKPMST        S3PMST
     C                   MOVE      BKPMDT        S3PMDT
     C                   MOVE      BKPMUR        S3PMUR
     C                   MOVE      BKPMAO        S3PMAO
     C                   MOVE      BKPMCU        S3PMCU
     C                   MOVE      BKPMBH        S3PMBH
     C                   MOVE      BKOBRU        S3OBRU
     C                   MOVE      BKOBUV        S3OBUV
     C     CEU004        IFEQ      'Y'                                                        CEU030
     C                   MOVE      BKEURO        S3EURO                                       CEU030
     C                   MOVE      BKEUCP        S3EUCP                                       CEU030
     C                   ENDIF                                                                CEU030
      *
      * Move message format
     C                   MOVEL(P)  DWS3MF        W#MFMT
      *
      * Put Message
     C                   EXSR      PMQPUT
      *
     C                   MOVE      *BLANKS       STK(@Q)
     C                   SUB       1             @Q
      *
     C                   ENDSR
      **********************************************************************
      * Set up Transmitted Message Format for SDRETLPD
      **********************************************************************
     C     P#RETL        BEGSR
      *
     C                   ADD       1             @Q
     C                   MOVEL     'P#RETL'      STK(@Q)
      *
      * Retrieve the data from the file image and move into DS for RETL
      * start pos: 126, length: 27
      *
     C                   EVAL      W#FSIZ=%SIZE(SDRETL)
     C                   EVAL      SDRETL=%SUBST(P#PARM1:126:W#FSIZ)
      *
     C                   EXSR      MSGFRMT
      *
      * Format and populate data
     C                   MOVE      BMACCD        S4ACCD
     C                   MOVE      BMRANR        S4RANR
      *
      * Move message format
     C                   MOVEL(P)  DWS4MF        W#MFMT
      *
      * Put Message
     C                   EXSR      PMQPUT
      *
     C                   MOVE      *BLANKS       STK(@Q)
     C                   SUB       1             @Q
      *
     C                   ENDSR
      **********************************************************************
      * Set up Transmitted Message Format for SDCLNDPD
      **********************************************************************
     C     P#CLND        BEGSR
      *
     C                   ADD       1             @Q
     C                   MOVEL     'P#CLND'      STK(@Q)
      *
      * Retrieve the data from the file image and move into DS for CLND
      * start pos: 126, length: 72
      *
     C                   EVAL      W#FSIZ=%SIZE(SDCLND)
     C                   EVAL      SDCLND=%SUBST(P#PARM1:126:W#FSIZ)
      *
     C                   EXSR      MSGFRMT
      *
      * Format and populate data
     C                   MOVE      BPBRCF        S5BRCF
     C                   MOVE      BPGEEB        S5GEEB
     C                   MOVE      BPBTIN        S5BTIN
     C                   Z-ADD     BPDBDY        S5DBDY
     C                   MOVE      BPDBKC        S5DBKC
     C                   MOVE      BPDASI        S5DASI
     C                   MOVE      BPGIAV        S5GIAV
     C                   MOVE      BPFAAU        S5FAAU
     C                   MOVE      BPFAAM        S5FAAM
     C                   MOVE      BPFAUT        S5FAUT
     C                   MOVE      BPLOAU        S5LOAU
     C                   MOVE      BPPPAU        S5PPAU
     C                   MOVE      BPPSAU        S5PSAU
     C                   MOVE      BPROAU        S5ROAU
     C                   MOVE      BPLMAU        S5LMAU
     C                   MOVE      BPMRAU        S5MRAU
     C                   MOVE      BPREAU        S5REAU
     C                   MOVE      BPTPAU        S5TPAU
     C                   MOVE      BPFEAU        S5FEAU
     C                   MOVE      BPFSAU        S5FSAU
     C                   MOVE      BPGUAU        S5GUAU
     C                   MOVE      BPCAAU        S5CAAU
     C                   MOVE      BPGRPR        S5GRPR
     C                   MOVE      BPGRIR        S5GRIR
     C                   MOVE      BPCONR        S5CONR
     C                   MOVE      BPAURV        S5AURV
     C                   MOVE      *BLANKS       S5COBS                                       138354
     C                   MOVE      BPDRTS        S5DRTS                                       CLE023
      *
      * Move message format
     C                   MOVEL(P)  DWS5MF        W#MFMT
      *
      * Put Message
     C                   EXSR      PMQPUT
      *
     C                   MOVE      *BLANKS       STK(@Q)
     C                   SUB       1             @Q
      *
     C                   ENDSR
      **********************************************************************
      * Set up Transmitted Message Format for SDPORTPD
      **********************************************************************
     C     P#PORT        BEGSR
      *
     C                   ADD       1             @Q
     C                   MOVEL     'P#PORT'      STK(@Q)
      *
      * Retrieve the data from the file image and move into DS for PORT
      * start pos: 126, length: 118
      *
     C                   EVAL      W#FSIZ=%SIZE(SDPORT)
     C                   EVAL      SDPORT=%SUBST(P#PARM1:126:W#FSIZ)
      *
     C                   EXSR      MSGFRMT
      *
      * Format and populate data
     C                   MOVE      FCR997        S6R997
     C                   MOVE      FCN997        S6N997
     C                   MOVE      FCR998        S6R998
     C                   MOVE      FCN998        S6N998
     C                   MOVE      FCR999        S6R999
     C                   MOVE      FCN999        S6N999
     C                   MOVE      FCPORS        S6PORS
      *
      * Move message format
     C                   MOVEL(P)  DWS6MF        W#MFMT
      *
      * Put Message
     C                   EXSR      PMQPUT
      *
     C                   MOVE      *BLANKS       STK(@Q)
     C                   SUB       1             @Q
      *
     C                   ENDSR
      **********************************************************************
      * Set up Transmitted Message Format for SDCUSTPD
      **********************************************************************
     C     P#CUST        BEGSR
      *
     C                   ADD       1             @Q
     C                   MOVEL     'P#CUST'      STK(@Q)
      *
      * Retrieve the data from the file image and move into DS for CUST
      * start pos: 126, length: 554
      *
     C                   EVAL      W#FSIZ=%SIZE(SDCUST)
     C                   EVAL      SDCUST=%SUBST(P#PARM1:126:W#FSIZ)
      *
     C                   EXSR      MSGFRMT
     C/COPY WNCPYSRC,LE2016MC03
      *
      * Format and populate data
     C                   MOVE      BBCUST        S7CUST
     C                   MOVE      BBCSSN        S7CSSN
     C                   MOVE      BBCNA1        S7CNA1
     C                   MOVE      BBCNA2        S7CNA2
     C                   MOVE      BBCNA3        S7CNA3
     C                   MOVE      BBCNA4        S7CNA4
     C                   MOVE      BBCRTN        S7CRTN
     C                   MOVE      BBCRNM        S7CRNM
     C                   MOVE      BBPAIN        S7PAIN
     C                   MOVE      BBLCCD        S7LCCD
     C                   MOVE      BBACOC        S7ACOC
     C                   MOVE      BBCNCZ        S7CNCZ
     C                   MOVE      BBCOLC        S7COLC
     C                   MOVE      BBCASC        S7CASC
     C                   MOVE      BBBRCD        S7BRCD
     C************       MOVE      BBBNBI        S7BNBI                                       189612
     C************       MOVE      BBSWFI        S7BNBI                                189612 211532
     C                   MOVE      BBBNBI        S7BNBI                                       211532
     C                   MOVE      BBSWFI        S7SWFI                                       211532
     C                   MOVE      BBLINC        S7LINC
     C                   MOVE      BBLICD        S7LICD
     C                   MOVE      BBCTNB        S7CTNB
     C                   MOVE      BBTAIN        S7TAIN
     C                   MOVE      BBREID        S7REID
     C                   MOVE      BBCSID        S7CSID
     C                   MOVE      BBPSWC        S7PSWC
     C                   MOVE      BBSTAD        S7STAD
     C                   MOVE      BBTXA1        S7TXA1
     C                   MOVE      BBTXA2        S7TXA2
     C                   MOVE      BBTXA3        S7TXA3
     C                   MOVE      BBTXA4        S7TXA4
     C                   MOVE      BBTXA5        S7TXA5
     C                   Z-ADD     BBCHID        S7CHID
     C                   Z-ADD     BBCHSC        S7CHSC
     C                   Z-ADD     BBCABA        S7CABA
     C                   Z-ADD     BBABA2        S7ABA2
     C                   MOVE      BBBFIC        S7BFIC
     C                   MOVE      BBBLCD        S7BLCD
     C                   Z-ADD     BBFWCD        S7FWCD
     C                   MOVE      BBLETI        S7LETI
     C                   MOVE      BBCMTI        S7CMTI
     C                   MOVE      BBGSFM        S7GSFM
     C                   MOVE      BBSTFG        S7STFG
     C                   MOVE      BBRWCD        S7RWCD
     C                   MOVE      BBMGTP        S7MGTP
     C*                                                                                       CPB003
     C** Always send this information to ensure the length of the                             CPB003
     C** message is the expected length. Note in Loan Manager will only                       CPB003
     C** populate tables with this information if the feature is on                           CPB003
     C*                                                                                       CPB003
     C                   MOVE      BBPRBA        S7PRBA                                       CPB003
      *
      * Move message format
     C                   MOVEL(P)  DWS7MF        W#MFMT
      *
      * Put Message
     C                   EXSR      PMQPUT
      *
     C                   MOVE      *BLANKS       STK(@Q)
     C                   SUB       1             @Q
      *
     C                   ENDSR
      **********************************************************************
      * Set up Transmitted Message Format for SDALTNPD
      **********************************************************************
     C     P#ALTN        BEGSR
      *
     C                   ADD       1             @Q
     C                   MOVEL     'P#ALTN'      STK(@Q)
      *
      * Retrieve the data from the file image and move into DS for ALTN
      * start pos: 126, length: 187
      *
     C                   EVAL      W#FSIZ=%SIZE(SDALTN)
     C                   EVAL      SDALTN=%SUBST(P#PARM1:126:W#FSIZ)
      *
     C                   EXSR      MSGFRMT
      *
      * Format and populate data
     C                   MOVE      BCCUST        S8CUST
     C                   MOVE      BCADCD        S8ADCD
     C                   MOVE      BCCNA1        S8CNA1
     C                   MOVE      BCCNA2        S8CNA2
     C                   MOVE      BCCNA3        S8CNA3
     C                   MOVE      BCCNA4        S8CNA4
     C                   MOVE      BCCRTN        S8CRTN
     C                   MOVE      BCCTNB        S8CTNB
     C                   MOVE      BCTXNB        S8TXNB
     C                   MOVE      BCCNCD        S8CNCD
      *
      * Move message format
     C                   MOVEL(P)  DWS8MF        W#MFMT
      *
      * Put Message
     C                   EXSR      PMQPUT
      *
     C                   MOVE      *BLANKS       STK(@Q)
     C                   SUB       1             @Q
      *
     C                   ENDSR
      **********************************************************************
      * Set up Transmitted Message Format for SDFACTPD
      **********************************************************************
     C     P#FACT        BEGSR
      *
     C                   ADD       1             @Q
     C                   MOVEL     'P#FACT'      STK(@Q)
      *
      * Retrieve the data from the file image and move into DS for FACT
      * start pos: 126, length: 37
      *
     C                   EVAL      W#FSIZ=%SIZE(SDFACT)
     C                   EVAL      SDFACT=%SUBST(P#PARM1:126:W#FSIZ)
      *
     C                   EXSR      MSGFRMT
      *
      * Format and populate data
     C                   MOVE      AMFCTY        S9FCTY
     C                   MOVE      AMFCNM        S9FCNM
      *
      * Move message format
     C                   MOVEL(P)  DWS9MF        W#MFMT
      *
      * Put Message
     C                   EXSR      PMQPUT
      *
     C                   MOVE      *BLANKS       STK(@Q)
     C                   SUB       1             @Q
      *
     C                   ENDSR
      **********************************************************************
      * Set up Transmitted Message Format for SDBRCHPD
      **********************************************************************
     C     P#BRCH        BEGSR
      *
     C                   ADD       1             @Q
     C                   MOVEL     'P#BRCH'      STK(@Q)
      *
      * Retrieve the data from the file image and move into DS for BRCH
      * start pos: 126, length: 221
      *
     C                   EVAL      W#FSIZ=%SIZE(SDBRCH)
     C                   EVAL      SDBRCH=%SUBST(P#PARM1:126:W#FSIZ)
      *
     C                   EXSR      MSGFRMT
      *
      * Format and populate data
     C                   MOVE      A8BRCD        S0BRCD
     C                   MOVE      A8BRNM        S0BRNM
     C                   MOVE      A8BTWN        S0BTWN
     C                   MOVE      A8CMCD        S0CMCD
     C                   MOVE      A8LCCD        S0LCCD
     C                   MOVE      A8BICN        S0BICN
     C**********         Z-ADD     A8SYCU        S0SYCU                                       CSD027
     C                   EVAL      S0SYCU = A8SYCU                                            CSD027
     C                   MOVE      A8BTID        S0BTID
     C                   MOVE      A8STCD        S0STCD
     C                   MOVE      A8RDFC        S0RDFC
      *
      * Move message format
     C                   MOVEL(P)  DWS0MF        W#MFMT
      *
      * Put Message
     C                   EXSR      PMQPUT
      *
     C                   MOVE      *BLANKS       STK(@Q)
     C                   SUB       1             @Q
      *
     C                   ENDSR
      **********************************************************************
      * Set up Transmitted Message Format for SDCURRPD
      **********************************************************************
     C     P#CURR        BEGSR
      *
     C                   ADD       1             @Q
     C                   MOVEL     'P#CURR'      STK(@Q)
      *
      * Retrieve the data from the file image and move into DS for CURR
      * start pos: 126, length: 237
      *
     C                   EVAL      W#FSIZ=%SIZE(SDCURR)
     C                   EVAL      SDCURR=%SUBST(P#PARM1:126:W#FSIZ)
      *
     C                   EXSR      MSGFRMT
      *
      * Format and populate data
     C                   MOVE      A6CYCD        SACYCD
     C                   MOVE      A6CYNM        SACYNM
     C                   MOVE      A6SWCY        SASWCY
     C                   MOVE      A6NBDP        SANBDP
     C                   MOVE      A6DLCI        SADLCI
      *   Spot Rate
     C**********         MOVE      A6SPRT        ZFIELD                                       155432
     C                   MOVE(P)   A6SPRT        ZFIELD                                       155432
     C                   Z-ADD     8             ZADEC
     C                   EXSR      ZEDIT
     C                   MOVE      ZFIELD        SASPRT
      *
     C                   MOVE      A6MDIN        SAMDIN
     C                   MOVE      A6DICB        SADICB
     C                   MOVE      A6TXND        SATXND
     C                   MOVE      A6RDFC        SARDFC
     C     CEU004        IFEQ      'Y'                                                        CEU030
     C                   MOVE      A6INCY        SAINCY                                       CEU030
      *   Euro Rate                                                                           CEU030
     C                   MOVE(P)   A6EUER        ZFIELD                                       CEU030
     C                   Z-ADD     8             ZADEC                                        CEU030
     C                   EXSR      ZEDIT                                                      CEU030
     C                   MOVE      ZFIELD        SAEUER                                       CEU030
     C                   MOVE      A6EUMD        SAEUMD                                       CEU030
      * Euro Transition Period Start Date                                                     CEU030
     C                   Z-ADD     A6TPSD        W#ZDAYN                                      CEU030
     C                   EXSR      ZZA0140                                                    CEU030
     C**********         MOVEL     W#ZDATE8      SATPSD                                CEU030 228849
     C                   MOVEL     W#DATE8       SATPSD                                       228849
      * Euro Transition Period End Date                                                       CEU030
     C                   Z-ADD     A6TPED        W#ZDAYN                                      CEU030
     C                   EXSR      ZZA0140                                                    CEU030
     C**********         MOVEL     W#ZDATE8      SATPED                                CEU030 228849
     C                   MOVEL     W#DATE8       SATPED                                       228849
     C                   ENDIF                                                                CEU030
      *
      * Move message format
     C                   MOVEL(P)  DWSAMF        W#MFMT
      *
      * Put Message
     C                   EXSR      PMQPUT
      *
     C                   MOVE      *BLANKS       STK(@Q)
     C                   SUB       1             @Q
      *
     C                   ENDSR
      **********************************************************************
      * Set up Transmitted Message Format for SDCTRYPD
      **********************************************************************
     C     P#CTRY        BEGSR
      *
     C                   ADD       1             @Q
     C                   MOVEL     'P#CTRY'      STK(@Q)
      *
      * Retrieve the data from the file image and move into DS for CTRY
      * start pos: 126, length: 50
      *
     C                   EVAL      W#FSIZ=%SIZE(SDCTRY)
     C                   EVAL      SDCTRY=%SUBST(P#PARM1:126:W#FSIZ)
      *
     C                   EXSR      MSGFRMT
      *
      * Format and populate data
     C                   MOVE      A4CNCD        SBCNCD
     C                   MOVE      A4CNNM        SBCNNM
     C                   MOVE      A4ISOC        SBISOC
     C                   MOVE      A4RGCD        SBRGCD
      *
      * Move message format
     C                   MOVEL(P)  DWSBMF        W#MFMT
      *
      * Put Message
     C                   EXSR      PMQPUT
      *
     C                   MOVE      *BLANKS       STK(@Q)
     C                   SUB       1             @Q
      *
     C                   ENDSR
      **********************************************************************
      * Set up Transmitted Message Format for SDFEEPD
      **********************************************************************
     C     P#FEEC        BEGSR
      *
     C                   ADD       1             @Q
     C                   MOVEL     'P#FEEC'      STK(@Q)
      *
      * Retrieve the data from the file image and move into DS for FEEC
      * start pos: 126, length: 26
      *
     C                   EVAL      W#FSIZ=%SIZE(SDFEEC)
     C                   EVAL      SDFEEC=%SUBST(P#PARM1:126:W#FSIZ)
      *
     C                   EXSR      MSGFRMT
      *
      * Format and populate data
     C**********         SELECT                                                               191421
     C*****AUFECD        WHENEQ    '01'                                                       191421
     C                   MOVE      AUFECD        SXCD01
     C                   MOVE      AUFENV        SXNV01
     C*****AUFECD        WHENEQ    '02'                                                       191421
     C**********         MOVE      AUFECD        SXCD02                                       191421
     C**********         MOVE      AUFENV        SXNV02                                       191421
     C*****AUFECD        WHENEQ    '03'                                                       191421
     C**********         MOVE      AUFECD        SXCD03                                       191421
     C**********         MOVE      AUFENV        SXNV03                                       191421
     C*****AUFECD        WHENEQ    '04'                                                       191421
     C**********         MOVE      AUFECD        SXCD04                                       191421
     C**********         MOVE      AUFENV        SXNV04                                       191421
     C*****AUFECD        WHENEQ    '05'                                                       191421
     C**********         MOVE      AUFECD        SXCD05                                       191421
     C**********         MOVE      AUFENV        SXNV05                                       191421
     C*****AUFECD        WHENEQ    '06'                                                       191421
     C**********         MOVE      AUFECD        SXCD06                                       191421
     C**********         MOVE      AUFENV        SXNV06                                       191421
     C*****AUFECD        WHENEQ    '07'                                                       191421
     C**********         MOVE      AUFECD        SXCD07                                       191421
     C**********         MOVE      AUFENV        SXNV07                                       191421
     C*****AUFECD        WHENEQ    '08'                                                       191421
     C**********         MOVE      AUFECD        SXCD08                                       191421
     C**********         MOVE      AUFENV        SXNV08                                       191421
     C*****AUFECD        WHENEQ    '09'                                                       191421
     C**********         MOVE      AUFECD        SXCD09                                       191421
     C**********         MOVE      AUFENV        SXNV09                                       191421
     C*****AUFECD        WHENEQ    '10'                                                       191421
     C**********         MOVE      AUFECD        SXCD10                                       191421
     C**********         MOVE      AUFENV        SXNV10                                       191421
     C**********         ENDSL                                                                191421
      *
      * Move message format
     C                   MOVEL(P)  DWSXMF        W#MFMT
      *
      * Put Message
     C                   EXSR      PMQPUT
      *
     C                   MOVE      *BLANKS       STK(@Q)
     C                   SUB       1             @Q
      *
     C                   ENDSR
      **********************************************************************
      * Set up Transmitted Message Format for SDINDSPD
      **********************************************************************
     C     P#INDS        BEGSR
      *
     C                   ADD       1             @Q
     C                   MOVEL     'P#INDS'      STK(@Q)
      *
      * Retrieve the data from the file image and move into DS for INDS
      * start pos: 126, length: 47
      *
     C                   EVAL      W#FSIZ=%SIZE(SDINDS)
     C                   EVAL      SDINDS=%SUBST(P#PARM1:126:W#FSIZ)
      *
     C                   EXSR      MSGFRMT
      *
      * Format and populate data
     C                   MOVE      AOLICD        SCLICD
     C                   MOVE      AOLINA        SCLINA
      *
      * Move message format
     C                   MOVEL(P)  DWSCMF        W#MFMT
      *
      * Put Message
     C                   EXSR      PMQPUT
      *
     C                   MOVE      *BLANKS       STK(@Q)
     C                   SUB       1             @Q
      *
     C                   ENDSR
      **********************************************************************
      * Set up Transmitted Message Format for SDACOFPD
      **********************************************************************
     C     P#ACOF        BEGSR
      *
     C                   ADD       1             @Q
     C                   MOVEL     'P#ACOF'      STK(@Q)
      *
      * Retrieve the data from the file image and move into DS for ACOF
      * start pos: 126, length: 69
      *
     C                   EVAL      W#FSIZ=%SIZE(SDACOF)
     C                   EVAL      SDACOF=%SUBST(P#PARM1:126:W#FSIZ)
      *
     C                   EXSR      MSGFRMT
      *
      * Format and populate data
     C                   MOVE      AZACOC        SDACOC
     C                   MOVE      AZACON        SDACON
     C                   MOVE      AZDPCD        SDDPCD
     C                   MOVE      AZAPHN        SDAPHN
     C                   MOVE      AZAEXT        SDAEXT
      *
      * Move message format
     C                   MOVEL(P)  DWSDMF        W#MFMT
      *
      * Put Message
     C                   EXSR      PMQPUT
      *
     C                   MOVE      *BLANKS       STK(@Q)
     C                   SUB       1             @Q
      *
     C                   ENDSR
      **********************************************************************
      * Set up Transmitted Message Format for SDPRFMPD
      **********************************************************************
     C     P#PRFM        BEGSR
      *
     C                   ADD       1             @Q
     C                   MOVEL     'P#PRFM'      STK(@Q)
      *
      * Retrieve the data from the file image and move into DS for PRFM
      * start pos: 126, length: 41
      *
     C                   EVAL      W#FSIZ=%SIZE(SDPRFM)
     C                   EVAL      SDPRFM=%SUBST(P#PARM1:126:W#FSIZ)
      *
     C                   EXSR      MSGFRMT
      *
      * Format and populate data
     C                   MOVE      DWPCCD        SEPCCD
     C                   MOVE      DWBKCD        SEBKCD
     C                   MOVE      DWPCTT        SEPCTT
     C                   MOVE      DWSBTY        SESBTY
     C                   MOVE      DWBRCD        SEBRCD
     C                   MOVE      DWDPCD        SEDPCD
     C                   MOVE      DWUSID        SEUSID
     C                   MOVE      DWACOC        SEACOC
     C                   MOVE      DWCUST        SECUST
      *
      * Move message format
     C                   MOVEL(P)  DWSEMF        W#MFMT
      *
      * Put Message
     C                   EXSR      PMQPUT
      *
     C                   MOVE      *BLANKS       STK(@Q)
     C                   SUB       1             @Q
      *
     C                   ENDSR
      **********************************************************************
      * Set up Transmitted Message Format for SDPRFCPD
      **********************************************************************
     C     P#PRFC        BEGSR
      *
     C                   ADD       1             @Q
     C                   MOVEL     'P#PRFC'      STK(@Q)
      *
      * Retrieve the data from the file image and move into DS for PRFC
      * start pos: 126, length: 52
      *
     C                   EVAL      W#FSIZ=%SIZE(SDPRFC)
     C                   EVAL      SDPRFC=%SUBST(P#PARM1:126:W#FSIZ)
      *
     C                   EXSR      MSGFRMT
      *
      * Format and populate data
     C                   MOVE      DSPCCD        SFPCCD
     C                   MOVE      DSPCDS        SFPCDS
     C                   MOVE      DSDFPR        SFDFPR
     C                   MOVE      DSLFPC        SFLFPC
     C                   MOVE      DSFFPC        SFFFPC
      *
      * Move message format
     C                   MOVEL(P)  DWSFMF        W#MFMT
      *
      * Put Message
     C                   EXSR      PMQPUT
      *
     C                   MOVE      *BLANKS       STK(@Q)
     C                   SUB       1             @Q
      *
     C                   ENDSR
      **********************************************************************
      * Set up Transmitted Message Format for SDBOOKPD
      **********************************************************************
     C     P#BOOK        BEGSR
      *
     C                   ADD       1             @Q
     C                   MOVEL     'P#BOOK'      STK(@Q)
      *
      * Retrieve the data from the file image and move into DS for BOOK
      * start pos: 126, length: 48
      *
     C                   EVAL      W#FSIZ=%SIZE(SDBOOK)
     C                   EVAL      SDBOOK=%SUBST(P#PARM1:126:W#FSIZ)
      *
     C                   EXSR      MSGFRMT
      *
      * Format and populate data
     C                   MOVE      BDBKCD        SGBKCD
     C                   MOVE      BDBKD         SGBKD
     C                   MOVE      BDASPR        SGASPR
      *
      * Move message format
     C                   MOVEL(P)  DWSGMF        W#MFMT
      *
      * Put Message
     C                   EXSR      PMQPUT
      *
     C                   MOVE      *BLANKS       STK(@Q)
     C                   SUB       1             @Q
      *
     C                   ENDSR
      **********************************************************************
      * Set up Transmitted Message Format for SDLOANPD
      **********************************************************************
     C     P#LTST        BEGSR
      *
     C                   ADD       1             @Q
     C                   MOVEL     'P#LTST'      STK(@Q)
      *
      * Retrieve the data from the file image and move into DS for LOAN
      * start pos: 126, length: 60
      *
     C                   EVAL      W#FSIZ=%SIZE(SDLOAN)
     C                   EVAL      SDLOAN=%SUBST(P#PARM1:126:W#FSIZ)
      *
     C                   EXSR      MSGFRMT
      *
      * Format and populate data
     C                   MOVE      AYLNTY        SHLNTY
     C                   MOVE      AYLNST        SHLNST
     C                   MOVE      AYLNTD        SHLNTD
     C                   MOVE      AYLNPT        SHLNPT
     C                   MOVE      AYILTY        SHILTY
     C                   MOVE      AYILST        SHILST
      *
      * Move message format
     C                   MOVEL(P)  DWSHMF        W#MFMT
      *
      * Put Message
     C                   EXSR      PMQPUT
      *
     C                   MOVE      *BLANKS       STK(@Q)
     C                   SUB       1             @Q
      *
     C                   ENDSR
      **********************************************************************
      * Set up Transmitted Message Format for SDBSRTPD
      **********************************************************************
     C     P#BSRT        BEGSR
      *
     C                   ADD       1             @Q
     C                   MOVEL     'P#BSRT'      STK(@Q)
      *
      * Retrieve the data from the file image and move into DS for BSRT
      * start pos: 126, length: 72
      *
     C                   EVAL      W#FSIZ=%SIZE(SDBSRT)
     C                   EVAL      SDBSRT=%SUBST(P#PARM1:126:W#FSIZ)
      *
     C                   EXSR      MSGFRMT
      *
      * Format and populate data
     C                   MOVE      BACYCD        SICYCD
     C                   MOVE      BABSRC        SIBSRC
     C                   MOVE      BABSRN        SIBSRN
      *   Current Base Rate
     C**********         MOVE      BACBSR        ZFIELD                                       155432
     C                   MOVE(P)   BACBSR        ZFIELD                                       155432
     C                   Z-ADD     7             ZADEC
     C                   EXSR      ZEDIT
     C                   MOVE      ZFIELD        SICBSR
      *   Value Date of Rate Change
     C                   Z-ADD     BAVDRC        W#ZDAYN
     C                   EXSR      ZZA0140
     C**********         MOVEL     W#ZDATE8      SIVDRC                                       228849
     C                   MOVEL     W#DATE8       SIVDRC                                       228849
      *   New Base Rate
     C**********         MOVE      BANBRT        ZFIELD                                       155432
     C                   MOVE(P)   BANBRT        ZFIELD                                       155432
     C                   Z-ADD     7             ZADEC
     C                   EXSR      ZEDIT
     C                   MOVE      ZFIELD        SINBRT
      *   Value Date for New Rate
     C                   Z-ADD     BAVDNR        W#ZDAYN
     C                   EXSR      ZZA0140
     C**********         MOVEL     W#ZDATE8      SIVDNR                                       228849
     C                   MOVEL     W#DATE8       SIVDNR                                       228849
      *
      * Move message format
     C                   MOVEL(P)  DWSIMF        W#MFMT
      *
      * Put Message
     C                   EXSR      PMQPUT
      *
     C                   MOVE      *BLANKS       STK(@Q)
     C                   SUB       1             @Q
      *
     C                   ENDSR
      **********************************************************************
      * Set up Transmitted Message Format for SDBSHSPD
      **********************************************************************
     C     P#BSHS        BEGSR
      *
     C                   ADD       1             @Q
     C                   MOVEL     'P#BSHS'      STK(@Q)
      *
      * Retrieve the data from the file image and move into DS for BSHS
      * start pos: 126, length: 14
      *
     C                   EVAL      W#FSIZ=%SIZE(SDBSHS)
     C                   EVAL      SDBSHS=%SUBST(P#PARM1:126:W#FSIZ)
      *
     C                   EXSR      MSGFRMT
      *
      * Format and populate data
     C                   MOVE      G0CYCD        SJCYCD
     C                   Z-ADD     G0BSRC        SJBSRC
      *   History Date
     C                   Z-ADD     G0HIDT        W#ZDAYN
     C                   EXSR      ZZA0140
     C**********         MOVEL     W#ZDATE8      SJHIDT                                       228849
     C                   MOVEL     W#DATE8       SJHIDT                                       228849
      *   Base Rate
     C**********         MOVE      G0CBSR        ZFIELD                                       155432
     C                   MOVE(P)   G0CBSR        ZFIELD                                       155432
     C                   Z-ADD     7             ZADEC
     C                   EXSR      ZEDIT
     C                   MOVE      ZFIELD        SJCBSR
      *
      * Move message format
     C                   MOVEL(P)  DWSJMF        W#MFMT
      *
      * Put Message
     C                   EXSR      PMQPUT
      *
     C                   MOVE      *BLANKS       STK(@Q)
     C                   SUB       1             @Q
      *
     C                   ENDSR
      **********************************************************************
      * Set up Transmitted Message Format for SDNOSTPD
      **********************************************************************
     C     P#NOST        BEGSR
      *
     C                   ADD       1             @Q
     C                   MOVEL     'P#NOST'      STK(@Q)
      *
      * Retrieve the data from the file image and move into DS for NOST
      * start pos: 126, length: 84
      *
     C                   EVAL      W#FSIZ=%SIZE(SDNOST)
     C                   EVAL      SDNOST=%SUBST(P#PARM1:126:W#FSIZ)
      *
     C                   EXSR      MSGFRMT
      *
      * Format and populate data
     C                   MOVE      A7CYCD        SKCYCD
     C                   MOVE      A7NONB        SKNONB
     C                   MOVE      A7NOSN        SKNOSN
     C                   MOVE      A7BRCD        SKBRCD
     C                   MOVE      A7CUST        SKCUST
     C                   MOVE      A7ACCD        SKACCD
     C                   MOVE      A7ACSN        SKACSN
     C                   MOVE      A7PNOI        SKPNOI
     C*****              MOVE      A7OANN        SKOANN                                       210796
     C                   MOVE      A7OACN        SKOANN                                       210796
     C                   MOVE      A7ORAC        SKORAC
      *
      * Move message format
     C                   MOVEL(P)  DWSKMF        W#MFMT
      *
      * Put Message
     C                   EXSR      PMQPUT
      *
     C                   MOVE      *BLANKS       STK(@Q)
     C                   SUB       1             @Q
      *
     C                   ENDSR
      **********************************************************************
      * Set up Transmitted Message Format for SDCNSTPD
      **********************************************************************
     C     P#CNST        BEGSR
      *
     C                   ADD       1             @Q
     C                   MOVEL     'P#CNST'      STK(@Q)
      *
      * Retrieve the data from the file image and move into DS for CNST
      * start pos: 126, length: 148
      *
     C                   EVAL      W#FSIZ=%SIZE(SDCNST)
     C                   EVAL      SDCNST=%SUBST(P#PARM1:126:W#FSIZ)
      *
     C                   EXSR      MSGFRMT
      *
      * Format and populate data
     C                   MOVE      AWCPNC        SLCPNC
     C                   MOVE      AWCPNM        SLCPNM
     C                   MOVE      AWCNTN        SLCNTN
      *   Customer Shortname
     C                   MOVEL     AWCSN1        SLCSN1
     C                   MOVE      AWCSN2        SLCSN1
      *
     C                   Z-ADD     AWCABA        SLCABA
     C                   MOVE      AWSWID        SLSWID
     C                   Z-ADD     AWCUID        SLCUID
     C                   Z-ADD     AWCHSC        SLCHSC
     C                   MOVE      AWBOJC        SLBOJC
     C                   MOVE      AWBACD        SLBACD
     C                   Z-ADD     AWFWCD        SLFWCD
     C                   MOVE      AWTXA1        SLTXA1
     C                   MOVE      AWSTAD        SLSTAD
      *
      * Move message format
     C                   MOVEL(P)  DWSLMF        W#MFMT
      *
      * Put Message
     C                   EXSR      PMQPUT
      *
     C                   MOVE      *BLANKS       STK(@Q)
     C                   SUB       1             @Q
      *
     C                   ENDSR
      **********************************************************************
      * Set up Transmitted Message Format for SDACNTPD
      **********************************************************************
     C     P#ACNT        BEGSR
      *
     C                   ADD       1             @Q
     C                   MOVEL     'P#ACNT'      STK(@Q)
      *
      * Retrieve the data from the file image and move into DS for ACNT
      * start pos: 126, length: 437
      *
     C                   EVAL      W#FSIZ=%SIZE(ACCNT)
     C                   EVAL      ACCNT=%SUBST(P#PARM1:126:W#FSIZ)
      *
     C                   EXSR      MSGFRMT
      *
      * Format and populate data
     C                   MOVE      BRCA          SMBRCA
     C                   MOVE      CNUM          SMCNUM
     C                   MOVE      CCY           SMCCY
     C                   MOVE      ACOD          SMACOD
     C                   MOVE      ACSQ          SMACSQ
     C                   MOVE      ANAM          SMANAM
     C                   Z-ADD     ACNO          SMACNO
     C                   MOVE      RECI          SMRECI
     C                   MOVE      ATYP          SMATYP
     C                   MOVE      ACST          SMACST
      *   History Date
     C                   Z-ADD     DACO          W#ZDAYN
     C                   EXSR      ZZA0140
     C**********         MOVEL     W#ZDATE8      SMDACO                                       228849
     C                   MOVEL     W#DATE8       SMDACO                                       228849
      *   Blocked Debit Indicator
     C                   TESTB     '2'           RETB                     85
     C     *IN85         IFEQ      *ON
     C                   MOVEL     'Y'           SMBLDI
     C                   ELSE
     C                   MOVEL     'N'           SMBLDI
     C                   ENDIF
     C*   Blocked Credit Indicator
     C                   TESTB     '3'           RETB                     85
     C     *IN85         IFEQ      *ON
     C                   MOVEL     'Y'           SMBLCI
     C                   ELSE
     C                   MOVEL     'N'           SMBLCI
     C                   ENDIF
      *
      * Move message format
     C                   MOVEL(P)  DWSMMF        W#MFMT
      *
      * Put Message
     C                   EXSR      PMQPUT
      *
     C                   MOVE      *BLANKS       STK(@Q)
     C                   SUB       1             @Q
      *
     C                   ENDSR
      **********************************************************************
      * Set up Transmitted Message Format for SDEXSTPD
      **********************************************************************
     C     P#EXST        BEGSR
      *
     C                   ADD       1             @Q
     C                   MOVEL     'P#EXST'      STK(@Q)
      *
      * Retrieve the data from the file image and move into DS for EXST
      * start pos: 126, length: 650
      *
     C                   EVAL      W#FSIZ=%SIZE(SDEXST)
     C                   EVAL      SDEXST=%SUBST(P#PARM1:126:W#FSIZ)
      *
     C                   EXSR      MSGFRMT
      *
      * Format and populate data
     C                   MOVE      BYCYCD        SNCYCD
     C                   MOVE      BYCUST        SNCUST
     C                   MOVE      BYTRTY        SNTRTY
     C                   MOVE      BYPSTY        SNPSTY
      *   Pay-Our Nostro
     C                   EVAL      SNPONO=       BYOPBR+BYPONO
     C                   MOVE      BYRCNB        SNRCNB
     C                   MOVE      BYCVMR        SNCVMR
     C                   MOVE      BYPOCS        SNPOCS
     C                   MOVE      BYPOBN        SNPOBN
     C                   MOVE      BYRCNO        SNRCNO
     C                   MOVE      BYRCAL        SNRCAL
     C                   MOVE      BYPIBN        SNPIBN
     C                   MOVE      BYPIBA        SNPIBA
     C                   MOVE      BYACBN        SNACBN
     C                   MOVE      BYACBL        SNACBL
     C                   MOVE      BYBYNB        SNBYNB
     C                   MOVE      BYBACL        SNBACL
     C                   MOVE      BYRSTY        SNRSTY
      *   Receipt-Our Nostro
     C                   EVAL      SNRONO=       BYORBR+BYRONO
     C                   MOVE      BYROCS        SNROCS
     C                   MOVE      BYROBN        SNROBN
     C                   MOVE      BYRIBN        SNRIBN
     C                   MOVE      BYRIBL        SNRIBL
     C                   EVAL      SNDPY1=       BYDPY1 +
     C                                           BYDPY2 +
     C                                           BYDPY3 +
     C                                           BYDPY4
     C                   MOVE      BYDECG        SNDECG
     C                   EVAL      SNBBI1=       BYBBI1 +
     C                                           BYBBI2 +
     C                                           BYBBI3 +
     C                                           BYBBI4 +
     C                                           BYBBI5 +
     C                                           BYBBI6
     C     CEU004        IFEQ      'Y'                                                        CEU030
     C                   MOVE      BYSTCY        SNSTCY                                       CEU030
     C                   MOVE      BYIERI        SNIERI                                       CEU030
     C                   ENDIF                                                                CEU030
      *
      * Move message format
     C                   MOVEL(P)  DWSNMF        W#MFMT
      *
      * Put Message
     C                   EXSR      PMQPUT
      *
     C                   MOVE      *BLANKS       STK(@Q)
     C                   SUB       1             @Q
      *
     C                   ENDSR
      **********************************************************************
      * Set up Transmitted Message Format for PMPORTPD
      **********************************************************************
     C     P#PORR        BEGSR
      *
     C                   ADD       1             @Q
     C                   MOVEL     'P#PORR'      STK(@Q)
      *
      * Retrieve the data from the file image and move into DS for PMPORTPD
      * start pos: 126, length: 143
      *
     C                   EVAL      W#FSIZ=%SIZE(SDPORR)
     C                   EVAL      SDPORR=%SUBST(P#PARM1:126:W#FSIZ)
      *
     C                   EXSR      MSGFRMT
      *
      * Format and populate data
      *
     C                   MOVE      PNCNUM        SOCNUM
     C                   MOVE      PNPTFR        SOPTFR
     C                   MOVE      PNPTFN        SOPTFN
      *
      *   Portfolio closed?
     C                   MOVE      PNRECI        SORECI
     C     PNDPCL        IFGT      *ZERO
     C                   MOVE      'C'           SORECI
     C                   ENDIF
      *
      *   Date Portfolio Opened
     C                   Z-ADD     PNDPOP        W#ZDAYN
     C                   EXSR      ZZA0140
     C**********         MOVEL     W#ZDATE8      SODPOP                                       228849
     C                   MOVEL     W#DATE8       SODPOP                                       228849
      *
      * Move message format
     C                   MOVEL(P)  DWSOMF        W#MFMT
      *
      * Put Message
     C                   EXSR      PMQPUT
      *
     C                   MOVE      *BLANKS       STK(@Q)
     C                   SUB       1             @Q
      *
     C                   ENDSR
      **********************************************************************
      * Set up Transmitted Message Format for SDPLCSPD
      **********************************************************************
     C     P#PLCS        BEGSR
      *
     C                   ADD       1             @Q
     C                   MOVEL     'P#PLCS'      STK(@Q)
      *
      * Retrieve the data from the file image and move into DS for PLCS
      * start pos: 126, length: 94
      *
     C                   EVAL      W#FSIZ=%SIZE(SDPLCS)
     C                   EVAL      SDPLCS=%SUBST(P#PARM1:126:W#FSIZ)
      *
     C                   EXSR      MSGFRMT
      *
      * Format and populate data
     C                   MOVE      QBCUST        SPCUST
     C                   MOVE      QBDFPO        SPDFPO
     C                   MOVE      QBRECI        SPRECI
      *
      * Move message format
     C                   MOVEL(P)  DWSPMF        W#MFMT
      *
      * Put Message
     C                   EXSR      PMQPUT
      *
     C                   MOVE      *BLANKS       STK(@Q)
     C                   SUB       1             @Q
      *
     C                   ENDSR
      **********************************************************************
      * Set up Transmitted Message Format for SDHOLPD
      **********************************************************************
     C     P#HOLS        BEGSR
      *
     C                   ADD       1             @Q
     C                   MOVEL     'P#HOLS'      STK(@Q)
      *
      * Retrieve the data from the file image and move into DS for HOLS
      * start pos: 126, length: 386
      *
     C                   EVAL      W#FSIZ=%SIZE(SDHOL)
     C                   EVAL      SDHOL=%SUBST(P#PARM1:126:W#FSIZ)
      *
     C                   EXSR      MSGFRMT
      *
      * Format and populate data
     C                   MOVE      DGCYCD        SQCYCD
     C                   MOVE      DGLCCD        SQLCCD
     C                   MOVE      DGYRNB        SQYRNB
      *   Holiday Indicators
     C                   EVAL      SQHOLD=%SUBST(SDHOL:17:366)
      *
      * Move message format
     C                   MOVEL(P)  DWSQMF        W#MFMT
      *
      * Put Message
     C                   EXSR      PMQPUT
      *
     C                   MOVE      *BLANKS       STK(@Q)
     C                   SUB       1             @Q
      *
     C                   ENDSR
      **********************************************************************
      * Set up Transmitted Message Format for SDCODEPD
      **********************************************************************
     C     P#CODE        BEGSR
      *
     C                   ADD       1             @Q
     C                   MOVEL     'P#CODE'      STK(@Q)
      *
      * Retrieve the data from the file image and move into DS for CODE
      * start pos: 126, length: 115
      *
     C                   EVAL      W#FSIZ=%SIZE(SDCODE)
     C                   EVAL      SDCODE=%SUBST(P#PARM1:126:W#FSIZ)
      *
     C                   EXSR      MSGFRMT
      *
      * Format and populate data
      *
     C                   MOVE      FYSWCD        SRSWCD
     C                   MOVE      FYCDES        SRCDES
     C                   MOVE      FYMMID        SRMMID
     C                   MOVE      FYSMTP        SRSMTP
     C                   MOVE      FYDCUS        SRDCUS
      *
      * Move message format
     C                   MOVEL(P)  DWSRMF        W#MFMT
      *
      * Put Message
     C                   EXSR      PMQPUT
      *
     C                   MOVE      *BLANKS       STK(@Q)
     C                   SUB       1             @Q
      *
     C                   ENDSR
      **********************************************************************
      * Set up Transmitted Message Format for SDTRADPD
      **********************************************************************
     C     P#TRAD        BEGSR
      *
     C                   ADD       1             @Q
     C                   MOVEL     'P#TRAD'      STK(@Q)
      *
      * Retrieve the data from the file image and move into DS for TRAD
      * start pos: 126, length: 53
      *
     C                   EVAL      W#FSIZ=%SIZE(SDTRAD)
     C                   EVAL      SDTRAD=%SUBST(P#PARM1:126:W#FSIZ)
      *
     C                   EXSR      MSGFRMT
      *
      * Format and populate data
     C                   MOVE      BLUSCY        STUSCY
      *
      * Move message format
     C                   MOVEL(P)  DWSTMF        W#MFMT
      *
      * Put Message
     C                   EXSR      PMQPUT
      *
     C                   MOVE      *BLANKS       STK(@Q)
     C                   SUB       1             @Q
      *
     C                   ENDSR
      **********************************************************************
      * Set up Transmitted Message Format for SDCCSYPD
      **********************************************************************
     C     P#CCSY        BEGSR
      *
     C                   ADD       1             @Q
     C                   MOVEL     'P#CCSY'      STK(@Q)
      *
      * Retrieve the data from the file image and move into DS for CCSY
      * start pos: 126, length: 19
      *
     C                   EVAL      W#FSIZ=%SIZE(SDCCSY)
     C                   EVAL      SDCCSY=%SUBST(P#PARM1:126:W#FSIZ)
      *
     C                   EXSR      MSGFRMT
      *
      * Format and populate data
     C                   MOVE      DPCYCD        SUCYCD
     C                   MOVE      DPCLSY        SUCLSY
      *
      * Move message format
     C                   MOVEL(P)  DWSUMF        W#MFMT
      *
      * Put Message
     C                   EXSR      PMQPUT
      *
     C                   MOVE      *BLANKS       STK(@Q)
     C                   SUB       1             @Q
      *
     C                   ENDSR
      **********************************************************************
      * Set up Transmitted Message Format for SDPCACPD
      **********************************************************************
     C     P#PCAC        BEGSR
      *
     C                   ADD       1             @Q
     C                   MOVEL     'P#PCAC'      STK(@Q)
      *
      * Retrieve the data from the file image and move into DS for PCAC
      * start pos: 126, length: 53
      *
     C                   EVAL      W#FSIZ=%SIZE(SDPCAC)
     C                   EVAL      SDPCAC=%SUBST(P#PARM1:126:W#FSIZ)
      *
     C                   EXSR      MSGFRMT
      *
      * Format and populate data
      *
     C                   MOVE      FTTFRT        SVTFRT
      *
      * Move message format
     C                   MOVEL(P)  DWSVMF        W#MFMT
      *
      * Put Message
     C                   EXSR      PMQPUT
      *
     C                   MOVE      *BLANKS       STK(@Q)
     C                   SUB       1             @Q
      *
     C                   ENDSR
      **********************************************************************    CLE031
      * Set up Transmitted Message Format for SDSVALPD                          CLE031
      **********************************************************************    CLE031
     C     P#SVAL        BEGSR                                                  CLE031
      *                                                                         CLE031
     C                   ADD       1             @Q                             CLE031
     C                   MOVEL     'P#SVAL'      STK(@Q)                        CLE031
      *                                                                         CLE031
      * Retrieve the data from the file image and move into DS for SDSVALPD     CLE031
      * start pos: 126, length: 220                                             CLE031
      *                                                                         CLE031
     C                   EVAL      W#FSIZ=%SIZE(SDSVAL)                         CLE031
     C                   EVAL      SDSVAL=%SUBST(P#PARM1:126:W#FSIZ)            CLE031
      *                                                                         CLE031
     C                   EXSR      MSGFRMT                                      CLE031
      *                                                                         CLE031
      * Format and populate data                                                CLE031
      *                                                                         CLE031
     C                   MOVE      GISVAL        SYSVAL                         CLE031
     C                   MOVE      GIVAL         SYCSET                         CLE031
      *                                                                         CLE033
      * If CLE033 is on and system value = 'Settlement09AccCode',               CLE033
      * check whether the current setting is a retail account code or           CLE033
      * GL account code                                                         CLE033
     C                   IF        CLE033 = 'Y'                                 CLE033
     C                             AND SYSVAL = 'Settlement09AccCode'           CLE033
     C                   EVAL      @ACOD = SYCSET                               CLE033
      *                                                                         CLE033
      * Access Account Code details                                             CLE033
     C                   CALLB     'AOACODR0'                                   CLE033
     C                   PARM      *BLANKS       @RTCD             7            CLE033
     C                   PARM      '*KEY   '     @OPTN             7            CLE033
     C                   PARM                    @ACOD             4            CLE033
     C     SDACOD        PARM      SDACOD        DSFDY                          CLE033
      *                                                                         CLE033
      * Not Found Error                                                         CLE033
     C     @RTCD         IFNE      *BLANKS                                      CLE033
     C                   MOVEL     @ACOD         DBKEY                          CLE033
     C                   MOVEL     'SDACODPD'    DBFILE                         CLE033
     C                   Z-ADD     23            DBASE                          CLE033
     C                   EXSR      *PSSR                                        CLE033
     C                   ENDIF                                                  CLE033
      *                                                                         CLE033
      * Put account type at the end of account code in the current              CLE033
      * setting field                                                           CLE033
     C                   EVAL      %SUBST(SYCSET:5:1)=A5ACTY                    CLE033
     C                   ENDIF                                                  CLE033
      *                                                                         CLE031
      * Move message format                                                     CLE031
     C                   MOVEL(P)  DWSYMF        W#MFMT                         CLE031
      *                                                                         CLE031
      * Put Message                                                             CLE031
     C                   EXSR      PMQPUT                                       CLE031
      *                                                                         CLE031
     C                   MOVE      *BLANKS       STK(@Q)                        CLE031
     C                   SUB       1             @Q                             CLE031
      *                                                                         CLE031
     C                   ENDSR                                                  CLE031
      *****************************************************************                       CLE034
      *                                                               *                       CLE034
      *  P#DLSA - Setup Trasmnitted Message Format to LEL8MFPD        *                       CLE034
      *                                                               *                       CLE034
      *****************************************************************                       CLE034
     C     P#DLSA        BEGSR                                                                CLE034
                                                                                              CLE034
     C                   ADD       1             @Q                                           CLE034
     C                   MOVEL     'P#DLSA'      STK(@Q)                                      CLE034
                                                                                              CLE034
     C                   EXSR      MSGFRMT                                                    CLE034
                                                                                              CLE034
     C                   CLEAR                   D8DTL                                        CLE034
      * Retrieve the data from the file image and move into DS for                            CLE034
      * LESTALPD, with start pos: 126, length: 765 (A)                                        CLE034
      *                                                                                       CLE034
     C                   EVAL      W#FSIZ=%SIZE(DWSTAL)                                       CLE034
     C                   EVAL      DWSTAL=%SUBST(P#PARM1:126:W#FSIZ)                          CLE034
      *                                                                                       CLE034
      *                                                                                       CLE034
      * If the journal image has been rolled back setup flag                                  CLE034
      *                                                                                       CLE034
     C     JOENTT        IFEQ      'DR'                                                       CLE034
     C     JOENTT        OREQ      'UR'                                                       CLE034
     C                   MOVE      'R'           ROLLB                                        CLE034
     C                   ENDIF                                                                CLE034
      *                                                                                       CLE034
     C     W#DBER        IFNE      'Y'                                                        CLE034
                                                                                              CLE034
      ** Format the fields                                                                    CLE034
                                                                                              CLE034
     C                   EVAL      L8TYPE = F#TTYPE                                           CLE034
     C                   EVAL      L8TMST = F#TTMST                                           CLE034
     C                   EVAL      L8PCRF = F#TPCRF                                           CLE034
     C                   EVAL      L8SEQ = F#TSEQ                                             CLE034
     C**********         IF        F#TLNRF <> *ZERO                                    CLE034 CLE148
     C                   IF        F#TLNRF <> *BLANKS                                         CLE148
     C                   EVAL      L8LNRF = F#TLNRF                                           CLE034
     C                   ENDIF                                                                CLE034
     C                   IF        F#TVDAT <> *ZERO                                           CLE034
     C                   Z-ADD     F#TVDAT       W#ZDAYN                                      CLE034
     C                   EXSR      ZZA0140                                                    CLE034
     C                   MOVEL     W#DATE8       L8VDAT                                       CLE034
     C                   ENDIF                                                                CLE034
     C                   IF        F#TLASQ <> *ZERO                                           CLE034
     C                   EVAL      L8LASQ = F#TLASQ                                           CLE034
     C                   ENDIF                                                                CLE034
     C**********         IF        F#TCNUM <> *ZERO                                    CLE034 CSD027
     C                   IF        F#TCNUM <> *BLANKS                                         CSD027
     C                   EVAL      L8CNUM = F#TCNUM                                           CLE034
     C                   ENDIF                                                                CLE034
     C                   IF        F#TFACL <> *ZERO                                           CLE034
     C                   EVAL      L8FACL = F#TFACL                                           CLE034
     C                   ENDIF                                                                CLE034
     C                   IF        F#TFESQ <> *ZERO                                           CLE034
     C                   EVAL      L8FESQ = F#TFESQ                                           CLE034
     C                   ENDIF                                                                CLE034
     C                   MOVE(P)   F#TRCPC       ZFIELD                                       CLE034
     C                   Z-ADD     9             ZADEC                                        CLE034
     C                   EXSR      ZEDIT                                                      CLE034
     C                   MOVE      ZFIELD        L8RCPC                                       CLE034
     C**********         IF        F#TRSTM <> *ZERO                                    CLE034 227709
     C                   EVAL      L8RSTM = F#TRSTM                                           CLE034
     C**********         ENDIF                                                         CLE034 227709
     C                   EVAL      L8RONS = F#TROBR + F#TRONS                                 CLE034
     C                   EVAL      L8RIBN = F#TRIBN                                           CLE034
     C                   EVAL      L8RIBA = F#TRIBA                                           CLE034
     C**********         IF        F#TROBN <> *ZERO                                    CLE034 CSD027
     C                   IF        F#TROBN <> *BLANKS                                         CSD027
     C                   EVAL      L8ROBN = F#TROBN                                           CLE034
     C                   ENDIF                                                                CLE034
     C**********         IF        F#TROCN <> *ZERO                                    CLE034 CSD027
     C                   IF        F#TROCN <> *BLANKS                                         CSD027
     C                   EVAL      L8ROCN = F#TROCN                                           CLE034
     C                   ENDIF                                                                CLE034
     C                   EVAL      L8RSCY = F#TRSCY                                           CLE034
     C                   MOVE(P)   F#TREXR       ZFIELD                                       CLE034
     C                   Z-ADD     8             ZADEC                                        CLE034
     C                   EXSR      ZEDIT                                                      CLE034
     C                   MOVE      ZFIELD        L8REXR                                       CLE034
     C                   EVAL      L8REXI = F#TREXI                                           CLE034
     C                   MOVE(P)   F#TPYPC       ZFIELD                                       CLE034
     C                   Z-ADD     9             ZADEC                                        CLE034
     C                   EXSR      ZEDIT                                                      CLE034
     C                   MOVE      ZFIELD        L8PYPC                                       CLE034
     C                   EVAL      L8PSTM = F#TPSTM                                           CLE034
     C                   EVAL      L8PONS = F#TPOBR + F#TPONS                                 CLE034
     C                   EVAL      L8PIBN = F#TPIBN                                           CLE034
     C                   EVAL      L8PIBA = F#TPIBA                                           CLE034
     C**********         IF        F#TPOBN <> *ZERO                                    CLE034 CSD027
     C                   IF        F#TPOBN <> *BLANKS                                         CSD027
     C                   EVAL      L8POBN = F#TPOBN                                           CLE034
     C                   ENDIF                                                                CLE034
     C**********         IF        F#TPOCN <> *ZERO                                    CLE034 CSD027
     C                   IF        F#TPOCN <> *BLANKS                                         CSD027
     C                   EVAL      L8POCN = F#TPOCN                                           CLE034
     C                   ENDIF                                                                CLE034
     C                   EVAL      L8RCRN = F#TRCRN                                           CLE034
     C                   EVAL      L8RCRA = F#TRCRA                                           CLE034
     C                   EVAL      L8RVNO = F#TRVNO                                           CLE034
     C                   EVAL      L8AWBN = F#TAWBN                                           CLE034
     C                   EVAL      L8AWBA = F#TAWBA                                           CLE034
     C                   EVAL      L8BENN = F#TBENN                                           CLE034
     C                   EVAL      L8BENA = F#TBENA                                           CLE034
     C                   EVAL      L8DTP1 = F#TDTP1                                           CLE034
     C                   EVAL      L8DTP2 = F#TDTP2                                           CLE034
     C                   EVAL      L8DTP3 = F#TDTP3                                           CLE034
     C                   EVAL      L8DTP4 = F#TDTP4                                           CLE034
     C                   EVAL      L8DCHG = F#TDCHG                                           CLE034
     C                   EVAL      L8BTB1 = F#TBTB1                                           CLE034
     C                   EVAL      L8BTB2 = F#TBTB2                                           CLE034
     C                   EVAL      L8BTB3 = F#TBTB3                                           CLE034
     C                   EVAL      L8BTB4 = F#TBTB4                                           CLE034
     C                   EVAL      L8BTB5 = F#TBTB5                                           CLE034
     C                   EVAL      L8BTB6 = F#TBTB6                                           CLE034
     C                   EVAL      L8CVMR = F#TCVMR                                           CLE034
     C                   EVAL      L8PSCY = F#TPSCY                                           CLE034
     C                   EVAL      L8IC72 = F#TIC72                                           CLE034
     C                   MOVE(P)   F#TPEXR       ZFIELD                                       CLE034
     C                   Z-ADD     8             ZADEC                                        CLE034
     C                   EXSR      ZEDIT                                                      CLE034
     C                   MOVE      ZFIELD        L8PEXR                                       CLE034
     C                   EVAL      L8PEXI = F#TPEXI                                           CLE034
     C                   EVAL      L8PTRF = F#TPTRF                                           CLE034
     C                   EVAL      L8RECI = F#TRECI                                           CLE034
     C                   MOVE      FILLER        X1FIL1                                       CLE034
                                                                                              CLE034
      ** Move message format                                                                  CLE034
                                                                                              CLE034
     C                   MOVEL(P)  DWL8MF        W#MFMT                                       CLE034
     C                   ELSE                                                                 CLE034
      *                                                                                       CLE034
     C                   CLEAR                   D8DTL                                        CLE034
     C                   EVAL      L8TYPE = F#TTYPE                                           CLE034
     C                   EVAL      L8TMST = F#TTMST                                           CLE034
     C                   EVAL      L8PCRF = F#TPCRF                                           CLE034
     C                   EVAL      L8SEQ = F#TSEQ                                             CLE034
     C**********         IF        F#TLNRF <> *ZERO                                    CLE034 CLE148
     C                   IF        F#TLNRF <> *BLANKS                                         CLE148
     C                   EVAL      L8LNRF = F#TLNRF                                           CLE034
     C                   ENDIF                                                                CLE034
     C                   IF        F#TVDAT <> *ZERO                                           CLE034
     C                   Z-ADD     F#TVDAT       W#ZDAYN                                      CLE034
     C                   EXSR      ZZA0140                                                    CLE034
     C                   MOVEL     W#DATE8       L8VDAT                                       CLE034
     C                   ENDIF                                                                CLE034
     C                   IF        F#TLASQ <> *ZERO                                           CLE034
     C                   EVAL      L8LASQ = F#TLASQ                                           CLE034
     C                   ENDIF                                                                CLE034
     C**********         IF        F#TCNUM <> *ZERO                                    CLE034 CSD027
     C                   IF        F#TCNUM <> *BLANKS                                         CSD027
     C                   EVAL      L8CNUM = F#TCNUM                                           CLE034
     C                   ENDIF                                                                CLE034
     C                   IF        F#TFACL <> *ZERO                                           CLE034
     C                   EVAL      L8FACL = F#TFACL                                           CLE034
     C                   ENDIF                                                                CLE034
     C                   IF        F#TFESQ <> *ZERO                                           CLE034
     C                   EVAL      L8FESQ = F#TFESQ                                           CLE034
     C                   ENDIF                                                                CLE034
     C                   MOVE      FILLER        X1FIL1                                       CLE034
     C                   MOVEL(P)  DWL8MF        W#MFMT                                       CLE034
      *                                                                                       CLE034
     C                   ENDIF                                                                CLE034
                                                                                              CLE034
      *                                                                                       CLE034
      *  Supress message for non-rollbacks (PT/UP etc)) of a rolled back                      CLE034
      *  unit of work                                                                         CLE034
      *                                                                                       CLE034
     C     *IN70         IFEQ      *ON                                                        CLE034
     C     ROLLB         ANDNE     'R'                                                        CLE034
     C                   ELSE                                                                 CLE034
     C                   EXSR      PMQPUT                                                     CLE034
     C                   ENDIF                                                                CLE034
                                                                                              CLE034
     C                   MOVE      *BLANKS       STK(@Q)                                      CLE034
     C                   SUB       1             @Q                                           CLE034
                                                                                              CLE034
     C                   ENDSR                                                                CLE034
      *****************************************************************                       CLE034
      /EJECT
      *****************************************************************                       CLE035
      *                                                               *                       CLE035
      *  P#DLIS - Setup Transmitted Message Format to LEL9MFPD        *                       CLE035
      *                                                               *                       CLE035
      *****************************************************************                       CLE035
     C     P#DLIS        BEGSR                                                                CLE035
                                                                                              CLE035
     C                   ADD       1             @Q                                           CLE035
     C                   MOVEL     'P#DLIS'      STK(@Q)                                      CLE035
                                                                                              CLE035
      ** Retrieve the data from the file image and move into DS                               CLE035
                                                                                              CLE035
     C                   EVAL      W#FSIZ = %SIZE(LETISP)                                     CLE035
     C                   EVAL      LETISP = %SUBST(P#PARM1:126:W#FSIZ)                        CLE035
                                                                                              CLE035
     C                   EXSR      MSGFRMT                                                    CLE035
                                                                                              CLE035
     C                   CLEAR                   D9DTL                                        CLE035
                                                                                              CLE035
      ** If the journal image has been rolled back setup flag                                 CLE035
                                                                                              CLE035
     C                   IF        JOENTT = 'DR' OR JOENTT = 'UR'                             CLE035
     C                   EVAL      ROLLB = 'R'                                                CLE035
     C                   ENDIF                                                                CLE035
     C                   MOVE      FILLER        X1FIL1                                       CLE035
                                                                                              CLE035
     C                   EVAL      X1MSGT = 'DLIS'                                            CLE035
                                                                                              CLE035
      ** Format the fields                                                                    CLE035
                                                                                              CLE035
      ** Record ID                                                                            CLE035
     C                   MOVE      F#IRECI       L9RECI                                       CLE035
                                                                                              CLE035
      ** Loan Reference                                                                       CLE035
     C**********         IF        F#ILNRF <> *ZERO                                    CLE035 CLE148
     C                   IF        F#ILNRF <> *BLANKS                                         CLE148
     C                   MOVE      F#ILNRF       L9LNRF                                       CLE035
     C                   ENDIF                                                                CLE035
                                                                                              CLE035
      ** Loan Reference                                                                       CLE035
     C**********         IF        F#ICNUM <> *ZERO                                   CLE035 CSD027A
     C                   IF        F#ICNUM <> *Blanks                                        CSD027A
     C                   MOVE      F#ICNUM       L9CNUM                                       CLE035
     C                   ENDIF                                                                CLE035
                                                                                              CLE035
      ** Facility                                                                             CLE035
     C                   IF        F#IFACL <> *ZERO                                           CLE035
     C                   MOVE      F#IFACL       L9FACL                                       CLE035
     C                   ENDIF                                                                CLE035
                                                                                              CLE035
      ** Fee Sequence                                                                         CLE035
     C                   IF        F#IFESQ <> *ZERO                                           CLE035
     C                   MOVE      F#IFESQ       L9FESQ                                       CLE035
     C                   ENDIF                                                                CLE035
                                                                                              CLE035
      ** Income Split Customer                                                                CLE035
     C                   MOVE      F#IISCN       L9ISCN                                       CLE035
                                                                                              CLE035
      ** Income Percentage Allocation                                                         CLE035
     C                   MOVE(P)   F#IIPAL       ZFIELD                                       CLE035
     C                   Z-ADD     9             ZADEC                                        CLE035
     C                   EXSR      ZEDIT                                                      CLE035
     C                   MOVE      ZFIELD        L9IPAL                                       CLE035
                                                                                              CLE035
      ** PC Reference                                                                         CLE035
     C                   EVAL      L9PCRF = F#IPCRF                                           CLE035
                                                                                              CLE035
      ** Parent PC Reference                                                                  CLE035
     C                   EVAL      L9PPCR = F#IPPCR                                           CLE035
                                                                                              CLE035
      ** Move message format                                                                  CLE035
     C                   EVAL      W#MFMT = DWL9MF                                            CLE035
      *                                                                                       CLE035
     C                   EXSR      PMQPUT                                                     CLE035
                                                                                              CLE035
     C                   MOVE      *BLANKS       STK(@Q)                                      CLE035
     C                   SUB       1             @Q                                           CLE035
                                                                                              CLE035
     C                   ENDSR                                                                CLE035
      *****************************************************************                       CLE035
      /EJECT                                                                                  CLE035
     C/COPY WNCPYSRC,LE2016C002
      /EJECT
      **********************************************************************
      *   Get Number of Decimal Places
      **********************************************************************
     C     GETNBDP       BEGSR
      *
     C                   ADD       1             @Q
     C                   MOVEL     'GETNBDP '    STK(@Q)
      *
      *
      * Access Currency Codes for decimal places
     C                   CALL      'AOCURRR0'
     C                   PARM      '*MSG'        WWRTCD            7
     C                   PARM      '*KEY'        WWOPTN            7
     C                   PARM      W#CCY         WWKY3             3
     C     SDCURR        PARM      SDCURR        DSSDY
      *   Error?
     C     WWRTCD        IFNE      *BLANKS
     C                   MOVEL     W#CCY         DBKEY
     C                   MOVEL     'SDCURRPD'    DBFILE
     C                   Z-ADD     7             DBASE
     C                   EXSR      *PSSR
     C                   ENDIF
      *
      *
     C                   MOVE      *BLANKS       STK(@Q)
     C                   SUB       1             @Q
      *
     C                   ENDSR
      **********************************************************************
      *   Set Up Message Format
      **********************************************************************
     C     MSGFRMT       BEGSR
      *
     C                   ADD       1             @Q
     C                   MOVEL     'MSGFRMT'     STK(@Q)
      *
      *     Message Header
      *
      *   User
      *   Work Station
      *   System Date
      *   Time Stamp
      *   Continuation Flag
      *   Filler
      *   No. of Entries
      *
      *
     C                   MOVEL     W#USER        X1TRUS
     C                   MOVEL     W#WSID        X1TRWS
     C                   MOVE      W#SYSDAT      X1TRDS
     C                   MOVE      W#X1TRTS      X1TRTS
     C                   MOVE      *BLANKS       X1CONT
     C                   MOVE      *BLANKS       X1FIL1
      * Clear rollback flag
     C                   MOVE      *BLANKS       ROLLB
      *
     C                   MOVE      *BLANKS       STK(@Q)
     C                   SUB       1             @Q
      *
     C                   ENDSR
      **********************************************************************
      *   Put Message Processing
      **********************************************************************
     C     PMQPUT        BEGSR
      *
     C                   ADD       1             @Q
     C                   MOVEL     'PMQPUT  '    STK(@Q)
      *
      *
     C     X1MSGT        CHAIN     LEDLLDPD                           88
     C     *IN88         IFEQ      *ON
     C                   MOVEL     X1MSGT        DBKEY
     C                   MOVEL     'LEDLLDPD'    DBFILE
     C                   Z-ADD     12            DBASE
     C                   EXSR      *PSSR
     C                   ENDIF
      *
      * GetMessage length
     C                   Z-ADD     BTML          W#MLEN
     C                   ADD       90            W#MLEN
      *
     C* Put Download message onto MQ message queue for each queue
     C                   Z-ADD     1             X
     C     W#AMQDF(X)    DOWNE     *BLANK
      *
      *
      *   Message Header reference and sequence no
     C                   MOVEL     W#BTTR        W1BTTR           12
     C                   EVAL      X1TNRF=       W#ABRCH(X) + W1BTTR
     C                   MOVE      W1BTTR        X1TRSN
      *
      *
      *   Update Transaction Action
     C                   SELECT
      *
     C     W#DBER        WHENEQ    'Y'
     C                   MOVE      'D'           X1ACTN
      *
     C     JOENTT        WHENEQ    'PT'
     C     JOENTT        OREQ      'DR'
     C     JFILE         ANDEQ     'FCLTYFM'
     C     JOENTT        OREQ      'DR'
     C     JFILE         ANDEQ     'FCLTYFN'
     C     JOENTT        OREQ      'DR'
     C     JFILE         ANDEQ     'CLOANCL'
     C     JOENTT        OREQ      'DR'
     C     JFILE         ANDEQ     'CLOANCK'
     C     JOENTT        OREQ      'DR'
     C     JFILE         ANDEQ     'LOAMSDK'
     C     JOENTT        OREQ      'DR'
     C     JFILE         ANDEQ     'LEPARTPD'
     C     JOENTT        OREQ      'DR'                                                       142401
     C     JFILE         ANDEQ     'LEFCAMPD'                                                 142401
     C     JOENTT        OREQ      'DR'                                                       142401
     C     JFILE         ANDEQ     'LEFEED'                                                   142401
     C     JOENTT        OREQ      'DR'                                                       142401
     C     JFILE         ANDEQ     'LEFEEAD'                                                  142401
      *                                                                                       142401
     C/COPY WNCPYSRC,LE2016C003                                                               142401
      *                                                                                       142401
     C                   MOVE      'I'           X1ACTN
      *
      * For FCLTYFM/FN & CLOANCL/CK files need to check RECI field
      * If R then need to set Action to D else set to A
      *
     C     JOENTT        WHENEQ    'UP'
     C     W#RECI        ANDNE     'R'
     C                   MOVE      'A'           X1ACTN
      *
     C     JOENTT        WHENEQ    'UP'
     C     W#RECI        ANDEQ     'R'
     C                   MOVE      'D'           X1ACTN
      *                                                                                       CLE034
     C     JOENTT        WHENEQ    'UP'                                                       CLE034
     C     W#RECI        ANDEQ     '*'                                                        CLE034
     C                   MOVE      'D'           X1ACTN                                       CLE034
      *
     C     JOENTT        WHENEQ    'UR'
     C                   MOVE      'A'           X1ACTN
      *
     C     JOENTT        WHENEQ    'DL'
     C     JOENTT        OREQ      'DR'
     C     JFILE         ANDNE     'FCLTYFM'
     C*****JOENTT        OREQ      'DR'                                                       134965
     C     JFILE         ANDNE     'FCLTYFN'
     C*****JOENTT        OREQ      'DR'                                                       134965
     C     JFILE         ANDNE     'CLOANCL'
     C*****JOENTT        OREQ      'DR'                                                       134965
     C     JFILE         ANDNE     'CLOANCK'
     C*****JOENTT        OREQ      'DR'                                                       134965
     C     JFILE         ANDNE     'LOAMSDK'
     C*****JOENTT        OREQ      'DR'                                                       134965
     C     JFILE         ANDNE     'LEPARTPD'
     C                   MOVE      'D'           X1ACTN
      *
     C                   ENDSL
      *
      *   Specify that Format name consists entirely of characters
      *
     C                   MOVEL     FMSTR         MDFMT
      *
      *   Message Header
     C                   MOVEL     DWX1MF        W#MFMT
      *
      *
      * Put message
     C**********         CALL      'QMQM'                                                   MD041126
      * I: Call Id: Put message
      * I: Connection handle
      * I: Object handle
      * I: Message Descriptor:
      *      Report Options: no reports required
      *      Message Type: message not requiring a reply
      *      Message Priority: default priority
      *      Message Persistence: message is persistent
      * I: Put message options: use default values supplied
      * I: Length of the Message
      * I: Message Data
      * O: Completion code
      * O: Reason code
     C**********         PARM      MQPUT         P#CID             9 0                      MD041126
     C**********         PARM      W#HCONN       P#HCONN           9 0                      MD041126
     C**********         PARM      W#AMQDH(X)    P#HOBJ            9 0                      MD041126
     C**********         PARM                    MQMD                                       MD041126
     C**********         PARM                    MQPMO                                      MD041126
     C**********         PARM      W#MLEN        P#MLEN            9 0                      MD041126
     C**********         PARM      W#MFMT        P#MFMT        32767                        MD041126
     C**********         PARM      *ZERO         P#CCODE           9 0                      MD041126
     C**********         PARM      *ZERO         P#RSCOD           9 0                      MD041126
                                                                                            MD041126
     C                   Z-ADD     W#HCONN       P#HCONN                                    MD041126
     C                   Z-ADD     W#AMQDH(X)    P#HOBJ                                     MD041126
     C                   Z-ADD     W#MLEN        P#MLEN                                     MD041126
     C                   EVAL      P#MFMT = W#MFMT                                          MD041126
     C                   Z-ADD     *ZERO         P#CCODE                                    MD041126
     C                   Z-ADD     *ZERO         P#REASON                                   MD041126
                                                                                            MD041126
     C                   CALLP     MQPUT( P#HCONN : P#HOBJ :                                MD041126
     C                                    MQMD : MQPMO : P#MLEN :                           MD041126
     C                                    %ADDR(P#MFMT) : P#CCODE :                         MD041126
     C                                    P#REASON )                                        MD041126
                                                                                            MD041126
     C                   Z-ADD     P#REASON      P#RSCOD                                    MD041126
                                                                                            MD041126
      *   MQPUT failed?
     C     P#CCODE       IFNE      CCOK
     C                   MOVEL     'MQPUT'       DBKEY
     C                   MOVEL     'QMQM'        DBFILE
     C                   Z-ADD     8             DBASE
     C                   MOVE      *ON           *IN30
     C                   EXSR      *PSSR
     C                   ENDIF
      *
      * Update next available transaction reference
     C                   ADD       1             W#BTTR
      * Next queue
     C                   ADD       1             X
     C                   ENDDO
      *
     C                   MOVE      *BLANKS       STK(@Q)
     C                   SUB       1             @Q
      *
     C                   ENDSR
      **********************************************************************
      * Update Ledrip with Journal Sequence No. + update transaction ref No.
      **********************************************************************
     C     UPDRIP        BEGSR
      *
     C                   ADD       1             @Q
     C                   MOVEL     'UPDRIP  '    STK(@Q)
      *
     C     *DTAARA       DEFINE                  LEJNSQ
     C     *LOCK         IN        LEJNSQ
     C                   Z-ADD     JRNSQ         LDSEQ
     C                   OUT       LEJNSQ
      *
      * Set next available transaction reference and update
      *  Drip Feed Control file
      *
     C     JOENTT        IFNE      'YJ'
     C     JOENTT        ANDNE     'YE'
      *
     C     '#DRP'        CHAIN     LEDLLDPD                           88
     C     *IN88         IFEQ      *ON
     C                   MOVEL     '#DRP'        DBKEY
     C                   MOVEL     'LEDLLDPD'    DBFILE
     C                   Z-ADD     11            DBASE
     C                   EXSR      *PSSR
     C                   ENDIF
      *
     C                   Z-ADD     W#BTTR        BTTR
     C                   UPDATE    LEDLLDD0
     C                   ENDIF
      *
     C                   MOVE      *BLANKS       STK(@Q)
     C                   SUB       1             @Q
      *
     C                   ENDSR
      **********************************************************************
      *   Final Processing
      **********************************************************************
     C     FINAL         BEGSR
      *
     C                   ADD       1             @Q
     C                   MOVEL     'FINAL   '    STK(@Q)
      *
     C     JOENTT        IFEQ      'YJ'
     C                   MOVE      '9'           P#PARM2
      *
      * Set on job switch 6 to notify LEC2016 that journal receivers are
      * about to change.
      *
     C                   CALL      'QCMDEXC'
     C                   PARM      SETSW6        QCMD             20
     C                   PARM      20            LENGTH           15 5
      *
      * Update the Journal sequence number only
      *
     C                   EXSR      UPDRIP
      *
     C                   RETURN
     C                   ENDIF
      *
     C     JOENTT        IFEQ      'YE'
      *
      ***If*MPHAS*=*B*(i/c*termination),*send*message*to*advise*Loan**                 138354 CCB020
      ***Manager*-*COB*about*to*start.********************************                 138354 CCB020
      *                                                                                       138354
     C******DTAARA       DEFINE                  MPHAS                                 138354 CCB020
     C******LOCK         IN        MPHAS                                               138354 CCB020
     C**********         MOVE      PHASE         W#MPHAS           1                   138354 CCB020
     C**********         OUT       MPHAS                                               138354 CCB020
      *                                                                                       138354
     C*****W#MPHAS       IFEQ      'B'                                                 138354 203561
     C***********        MOVE      'CLND'        X1MSGT                                138354 203561
      ***********                                                                      138354 203561
     C***********        CALL      'AOCLNDR0'                                          138354 203561
     C***********        PARM      *BLANKS       WWRTCD                                138354 203561
     C***********        PARM      '*FIRST '     WWOPTN                                138354 203561
     C*****SDCLND        PARM      SDCLND        DSFDY                                 138354 203561
      ****Error?*                                                                      138354 203561
     C*****WWRTCD        IFNE      *BLANKS                                             138354 203561
     C***********        MOVEL     '*FIRST'      DBKEY                                 138354 203561
     C***********        MOVEL     'SDCLNDPD'    DBFILE                                138354 203561
     C***********        Z-ADD     18            DBASE                                 138354 203561
     C***********        EXSR      *PSSR                                               138354 203561
     C***********        ENDIF                                                         138354 203561
      ***********                                                                      138354 203561
     C***********        EXSR      MSGFRMT                                             138354 203561
      ***********                                                                      138354 203561
      **Format*and*populate*data*                                                      138354 203561
     C***********        MOVE      BPBRCF        S5BRCF                                138354 203561
     C***********        MOVE      BPGEEB        S5GEEB                                138354 203561
     C***********        MOVE      BPBTIN        S5BTIN                                138354 203561
     C***********        Z-ADD     BPDBDY        S5DBDY                                138354 203561
     C***********        MOVE      BPDBKC        S5DBKC                                138354 203561
     C***********        MOVE      BPDASI        S5DASI                                138354 203561
     C***********        MOVE      BPGIAV        S5GIAV                                138354 203561
     C***********        MOVE      BPFAAU        S5FAAU                                138354 203561
     C***********        MOVE      BPFAAM        S5FAAM                                138354 203561
     C***********        MOVE      BPFAUT        S5FAUT                                138354 203561
     C***********        MOVE      BPLOAU        S5LOAU                                138354 203561
     C***********        MOVE      BPPPAU        S5PPAU                                138354 203561
     C***********        MOVE      BPPSAU        S5PSAU                                138354 203561
     C***********        MOVE      BPROAU        S5ROAU                                138354 203561
     C***********        MOVE      BPLMAU        S5LMAU                                138354 203561
     C***********        MOVE      BPMRAU        S5MRAU                                138354 203561
     C***********        MOVE      BPREAU        S5REAU                                138354 203561
     C***********        MOVE      BPTPAU        S5TPAU                                138354 203561
     C***********        MOVE      BPFEAU        S5FEAU                                138354 203561
     C***********        MOVE      BPFSAU        S5FSAU                                138354 203561
     C***********        MOVE      BPGUAU        S5GUAU                                138354 203561
     C***********        MOVE      BPCAAU        S5CAAU                                138354 203561
     C***********        MOVE      BPGRPR        S5GRPR                                138354 203561
     C***********        MOVE      BPGRIR        S5GRIR                                138354 203561
     C***********        MOVE      BPCONR        S5CONR                                138354 203561
     C***********        MOVE      BPAURV        S5AURV                                138354 203561
     C***********        MOVE      'Y'           S5COBS                                138354 203561
      ***********                                                                      138354 203561
      **Move*message*format*                                                           138354 203561
     C***********        MOVEL(P)  DWS5MF        W#MFMT                                138354 203561
      ***********                                                                      138354 203561
      **Put*Message*                                                                   138354 203561
     C***********        EXSR      PMQPUT                                              138354 203561
     C***********        ENDIF                                                         138354 203561
      ***********                                                                      138354 203561
     C                   EXSR      CLOSE
      *
     C                   EXSR      UPDRIP
      *
     C                   MOVE      *BLANKS       STK(@Q)
     C                   SUB       1             @Q
      *
      * Close and exit
     C                   MOVE      '9'           P#PARM2
     C                   MOVE      *ON           *INLR
     C                   RETURN
      *
     C                   ENDIF
      *
     C                   ENDSR
      **********************************************************************
      *   Close QMQM Queues
      **********************************************************************
     C     CLOSE         BEGSR
      *
     C                   ADD       1             @Q
     C                   MOVEL     'CLOSE   '    STK(@Q)
      *
     C                   MOVE      'Y'           WKCLOS            1                          172577
      *
      * Close the MQ Drip Feed queue for each branch
     C                   Z-ADD     1             X
     C     W#AMQDF(X)    DOWNE     *BLANK
      *
      *
      * Close object
     C**********         CALL      'QMQM'                                                   MD041126
      * I: Call Id: Close object
      * I: Connection handle
      * I: Object handle
      * I: Close options: No optional close processing
      * O: Completion code
      * O: Reason code
     C**********         PARM      MQCLOS        P#CID             9 0                      MD041126
     C**********         PARM      W#HCONN       P#HCONN           9 0                      MD041126
     C**********         PARM      W#AMQDH(X)    P#HOBJ            9 0                      MD041126
     C**********         PARM      CONONE        P#OPTS            9 0                      MD041126
     C**********         PARM      *ZERO         P#CCODE           9 0                      MD041126
     C**********         PARM      *ZERO         P#RSCOD           9 0                      MD041126
                                                                                            MD041126
     C                   Z-ADD     W#HCONN       P#HCONN                                    MD041126
     C                   Z-ADD     W#AMQDH(X)    P#HOBJ                                     MD041126
     C                   Z-ADD     CONONE        P#OPTS                                     MD041126
     C                   Z-ADD     *ZERO         P#CCODE                                    MD041126
     C                   Z-ADD     *ZERO         P#REASON                                   MD041126
                                                                                            MD041126
     C                   CALLP     MQCLOSE( P#HCONN : P#HOBJ : P#OPTS :                     MD041126
     C                                      P#CCODE : P#REASON )                            MD041126
                                                                                            MD041126
     C                   Z-ADD     P#REASON      P#RSCOD                                    MD041126
                                                                                            MD041126
      *   MQCLOSE failed?
     C     P#CCODE       IFEQ      CCFAIL
     C                   MOVEL     'MQCLOS'      DBKEY
     C                   MOVEL     'QMQM'        DBFILE
     C                   Z-ADD     9             DBASE
     C                   MOVE      *ON           *IN30
     C                   EXSR      *PSSR
     C                   ENDIF
      *
      * Next queue
     C                   ADD       1             X
     C                   ENDDO
      *
      *
      * Disconnect queue manager
     C**********         CALL      'QMQM'                                                   MD041126
      * I: Call Id: Disconnect queue manager
      * I: Connection handle
      * O: Completion code
      * O: Reason code
     C**********         PARM      MQDISC        P#CID             9 0                      MD041126
     C**********         PARM      W#HCONN       P#HCONN           9 0                      MD041126
     C**********         PARM      *ZERO         P#CCODE           9 0                      MD041126
     C**********         PARM      *ZERO         P#RSCOD           9 0                      MD041126
                                                                                            MD041126
     C                   Z-ADD     W#HCONN       P#HCONN                                    MD041126
     C                   Z-ADD     *ZERO         P#CCODE                                    MD041126
     C                   Z-ADD     *ZERO         P#REASON                                   MD041126
                                                                                            MD041126
     C                   CALLP     MQDISC( P#HCONN : P#CCODE :                              MD041126
     C                                     P#REASON )                                       MD041126
                                                                                            MD041126
     C                   Z-ADD     P#REASON      P#RSCOD                                    MD041126
                                                                                            MD041126
      *   MQDISC failed?
     C     P#CCODE       IFEQ      CCFAIL
     C                   MOVEL     'MQDISC'      DBKEY
     C                   MOVEL     'QMQM'        DBFILE
     C                   Z-ADD     10            DBASE
     C                   MOVE      '9'           P#PARM2
     C                   MOVE      *ON           *IN30
     C                   EXSR      *PSSR
     C                   ENDIF
      *
     C                   MOVE      ' '           W#FTIME
     C                   MOVE      *BLANKS       STK(@Q)
     C                   SUB       1             @Q
      *
     C                   ENDSR
      **********************************************************************
      *  Initialisation
      **********************************************************************
     C     INITIAL       BEGSR
      *
     C                   Z-ADD     1             @Q                3 0
     C                   MOVEL     'INITIAL   '  STK(@Q)
      *
      *
     C     *LIKE         DEFINE    A8BRCD        WWBRCD
     C     *LIKE         DEFINE    RECI          W#RECI
     C     *LIKE         DEFINE    X             XSV
     C     *LIKE         DEFINE    P#HCONN       W#HCONN
     C     *LIKE         DEFINE    P#HOBJ        W#HOBJ
     C     *LIKE         DEFINE    X1TRDS        W#SYSDAT
     C     *LIKE         DEFINE    W#SYSDAT      W#DNWD
     C     *LIKE         DEFINE    W#SYSDAT      W#EYD
     C     *LIKE         DEFINE    W#SYSDAT      W#PEYD
     C     *LIKE         DEFINE    X1TRTS        W#X1TRTS
     C     *LIKE         DEFINE    P#MLEN        W#MLEN
     C     *LIKE         DEFINE    BTNM          W#NOREC
     C     *LIKE         DEFINE    BTNM          W#BTNM
     C     *LIKE         DEFINE    BTML          W#BTML
     C     *LIKE         DEFINE    BTTR          W#BTTR
     C     *LIKE         DEFINE    BJCYCD        W#CCY
     C     *LIKE         DEFINE    A6NBDP        W#CCYDP
     C     *LIKE         DEFINE    A6NBDP        W#FCCYDP
     C     *LIKE         DEFINE    A6NBDP        W#NCCYDP
     C     *LIKE         DEFINE    A6NBDP        W#LCCYDP
     C     *LIKE         DEFINE    DBKEY         W#DBKEY
      *
      * Initialise the DS length field and RECI
      *
     C                   Z-ADD     *ZERO         W#FSIZ            5 0
     C                   MOVE      *BLANKS       W#RECI
      *
      * Set up copyright parameter
     C                   MOVEA     CPY@          MKI@             80
      *
      * Set up Database Error Details.
     C                   MOVEL     W#PGM         DBPGM
     C                   CLEAR                   DBFILE
     C                   CLEAR                   DBKEY
     C                   CLEAR                   DBASE
     C                   CLEAR                   @DUMP
      *
      * Key List for FCLTYFN/M
     C     @FCLTY        KLIST
     C**********         KFLD                    W@CNUM            6 0                        CSD027
     C                   KFLD                    W@CNUM            6                          CSD027
     C                   KFLD                    W@FACT            3 0
     C                   KFLD                    W@FCNO            2 0
     C                   KFLD                    W@RCTP            1
      *
      * Key List for CLOANCL/K
     C     @CLOAN        KLIST
     C**********         KFLD                    W@LNRF            6 0                        CLE148
     C                   KFLD                    W@LNRF                                       CLE148
     C                   KFLD                    W@RCDT            1
      *
     C/COPY WNCPYSRC,LE2016MC01
     C                   CALL      'AOSARDR0'                                                 CEU030
     C                   PARM      *BLANKS       WWRTCD            7                          CEU030
     C                   PARM      '*VERIFY'     WWOPTN            7                          CEU030
     C                   PARM      'CEU004'      WWSARD            6                          CEU030
     C     SCSARD        PARM      SCSARD        DSFDY                                        CEU030
      *   Error?                                                                              CEU030
     C     WWRTCD        IFEQ      *BLANKS                                                    CEU030
     C                   MOVE      'Y'           CEU004            1                          CEU030
     C                   ELSE                                                                 CEU030
     C                   MOVE      'N'           CEU004                                       CEU030
     C     WWRTCD        IFNE      '*NRF   '                                                  CEU030
     C                   MOVEL     'CEU004'      DBKEY                                        CEU030
     C                   MOVEL     'SCSARDPD'    DBFILE                                       CEU030
     C                   Z-ADD     14            DBASE                                        CEU030
     C                   EXSR      *PSSR                                                      CEU030
     C                   ENDIF                                                                CEU030
     C                   ENDIF                                                                CEU030
      *                                                                                       CLE011
      ** Check if Rollover Rate Fixng Day Enhancement (CLE011) is installed                   CLE011
      *                                                                                       CLE011
     C                   CALL      'AOSARDR0'                                                 CLE011
     C                   PARM      *BLANKS       WWRTCD                                       CLE011
     C                   PARM      '*KEY   '     WWOPTN                                       CLE011
     C                   PARM      'CLE011'      WWSARD                                       CLE011
     C     SCSARD        PARM      SCSARD        DSFDY                                        CLE011
      *                                                                                       CLE011
     C                   IF        WWRTCD = *BLANKS                                           CLE011
     C                   MOVE      'Y'           CLE011            1                          CLE011
     C                   ELSE                                                                 CLE011
     C                   MOVE      'N'           CLE011                                       CLE011
     C                   IF        WWRTCD <> '*NRF   '                                        CLE011
     C                   MOVEL     'CLE011'      DBKEY                                        CLE011
     C                   MOVEL     'SCSARDPD'    DBFILE                                       CLE011
     C                   Z-ADD     19            DBASE                                        CLE011
     C                   EXSR      *PSSR                                                      CLE011
     C                   ENDIF                                                                CLE011
     C                   ENDIF                                                                CLE011
      *                                                                                       CLE023
      ** Access SAR details to see if CLE023 - Lending Facility History                       CLE023
      ** Improvements is installed                                                            CLE023
      *                                                                                       CLE023
     C                   CALL      'AOSARDR0'                                                 CLE023
     C                   PARM      *BLANKS       WWRTCD                                       CLE023
     C                   PARM      '*KEY   '     WWOPTN                                       CLE023
     C                   PARM      'CLE023'      WWSARD                                       CLE023
     C     SCSARD        PARM      SCSARD        DSFDY                                        CLE023
      *                                                                                       CLE023
     C                   IF        WWRTCD = *BLANKS                                           CLE023
     C                   MOVE      'Y'           CLE023            1                          CLE023
     C                   ELSE                                                                 CLE023
     C                   MOVE      'N'           CLE023                                       CLE023
     C                   IF        WWRTCD <> '*NRF   '                                        CLE023
     C                   MOVEL     'CLE023'      DBKEY                                        CLE023
     C                   MOVEL     'SCSARDPD'    DBFILE                                       CLE023
     C                   Z-ADD     20            DBASE                                        CLE023
     C                   EXSR      *PSSR                                                      CLE023
     C                   ENDIF                                                                CLE023
     C                   ENDIF                                                                CLE023
      *                                                                                       CLE023
      ** Determine if Flat Rate Personal Loan (CLE028) is installed                           CLE028
      *                                                                                       CLE028
     C                   EVAL      CLE028 = 'N'                                               CLE028
     C                   CALL      'AOSARDR0'                                                 CLE028
     C                   PARM      *BLANKS       WWRTCD                                       CLE028
     C                   PARM      '*VERIFY'     WWOPTN                                       CLE028
     C                   PARM      'CLE028'      WWSARD                                       CLE028
     C     SCSARD        PARM      SCSARD        DSFDY                                        CLE028
      *                                                                                       CLE028
     C                   IF        WWRTCD = *BLANKS                                           CLE028
     C                   EVAL      CLE028 = 'Y'                                               CLE028
     C                   ELSE                                                                 CLE028
     C                   IF        WWRTCD <> '*NRF   '                                        CLE028
     C                   EVAL      DBKEY = 'CLE028'                                           CLE028
     C                   EVAL      DBFILE = 'SCSARDPD'                                        CLE028
     C                   EVAL      DBASE = 21                                                 CLE028
     C                   EXSR      *PSSR                                                      CLE028
     C                   ENDIF                                                                CLE028
     C                   ENDIF                                                                CLE028
      *                                                                                       CLE028
      *                                                                                       CLE031
      ** Access SAR details to see if CLE031 - Lending Facility History                       CLE031
      ** Improvements is installed                                                            CLE031
      *                                                                                       CLE031
     C                   EVAL      WWRTCD = *BLANKS                                           CLE031
      *                                                                                       CLE031
     C                   CALL      'AOSARDR0'                                                 CLE031
     C                   PARM      *BLANKS       WWRTCD                                       CLE031
     C                   PARM      '*KEY   '     WWOPTN                                       CLE031
     C                   PARM      'CLE031'      WWSARD                                       CLE031
     C     SCSARD        PARM      SCSARD        DSFDY                                        CLE031
      *                                                                                       CLE031
     C                   IF        WWRTCD = *BLANKS                                           CLE031
     C                   MOVE      'Y'           CLE031            1                          CLE031
     C                   ELSE                                                                 CLE031
     C                   MOVE      'N'           CLE031                                       CLE031
     C                   IF        WWRTCD <> '*NRF   '                                        CLE031
     C                   MOVEL     'CLE031'      DBKEY                                        CLE031
     C                   MOVEL     'SCSARDPD'    DBFILE                                       CLE031
     C                   Z-ADD     21            DBASE                                        CLE031
     C                   EXSR      *PSSR                                                      CLE031
     C                   ENDIF                                                                CLE031
     C                   ENDIF                                                                CLE031
      *                                                                         CLE033
      ** Access SAR details to see if CLE033 - Settlement method 9 is           CLE033
      ** installed                                                              CLE033
      *                                                                         CLE033
     C                   EVAL      WWRTCD = *BLANKS                             CLE033
      *                                                                         CLE033
     C                   CALL      'AOSARDR0'                                   CLE033
     C                   PARM      *BLANKS       WWRTCD                         CLE033
     C                   PARM      '*KEY   '     WWOPTN                         CLE033
     C                   PARM      'CLE033'      WWSARD                         CLE033
     C     SCSARD        PARM      SCSARD        DSFDY                          CLE033
      *                                                                         CLE033
     C                   IF        WWRTCD = *BLANKS                             CLE033
     C                   MOVE      'Y'           CLE033            1            CLE033
     C                   ELSE                                                   CLE033
     C                   MOVE      'N'           CLE033                         CLE033
     C                   IF        WWRTCD <> '*NRF   '                          CLE033
     C                   MOVEL     'CLE033'      DBKEY                          CLE033
     C                   MOVEL     'SCSARDPD'    DBFILE                         CLE033
     C                   Z-ADD     22            DBASE                          CLE033
     C                   EXSR      *PSSR                                        CLE033
     C                   ENDIF                                                  CLE033
     C                   ENDIF                                                  CLE033
      *                                                                                       CLE034
      ** Access SAR details to see if CLE034 enhancement is                                   CLE034
      ** installed                                                                            CLE034
      *                                                                                       CLE034
     C                   EVAL      WWRTCD = *BLANKS                                           CLE034
      *                                                                                       CLE034
     C                   CALL      'AOSARDR0'                                                 CLE034
     C                   PARM      *BLANKS       WWRTCD                                       CLE034
     C                   PARM      '*KEY   '     WWOPTN                                       CLE034
     C                   PARM      'CLE034'      WWSARD                                       CLE034
     C     SCSARD        PARM      SCSARD        DSFDY                                        CLE034
      *                                                                                       CLE034
     C                   IF        WWRTCD = *BLANKS                                           CLE034
     C                   MOVE      'Y'           CLE034            1                          CLE034
     C                   ELSE                                                                 CLE034
     C                   MOVE      'N'           CLE034                                       CLE034
     C                   IF        WWRTCD <> '*NRF   '                                        CLE034
     C                   MOVEL     'CLE034'      DBKEY                                        CLE034
     C                   MOVEL     'SCSARDPD'    DBFILE                                       CLE034
     C                   Z-ADD     24            DBASE                                        CLE034
     C                   EXSR      *PSSR                                                      CLE034
     C                   ENDIF                                                                CLE034
     C                   ENDIF                                                                CLE034
                                                                                              CLE034
      *                                                                                       CLE036
      ** Access SAR details to see if CLE036 enhancement is                                   CLE036
      ** installed                                                                            CLE036
      *                                                                                       CLE036
     C                   EVAL      WWRTCD = *BLANKS                                           CLE036
      *                                                                                       CLE036
     C                   CALL      'AOSARDR0'                                                 CLE036
     C                   PARM      *BLANKS       WWRTCD                                       CLE036
     C                   PARM      '*KEY   '     WWOPTN                                       CLE036
     C                   PARM      'CLE036'      WWSARD                                       CLE036
     C     SCSARD        PARM      SCSARD        DSFDY                                        CLE036
      *                                                                                       CLE036
     C                   IF        WWRTCD = *BLANKS                                           CLE036
     C                   MOVE      'Y'           CLE036                                       CLE036
     C                   ELSE                                                                 CLE036
     C                   MOVE      'N'           CLE036                                       CLE036
     C                   IF        WWRTCD <> '*NRF   '                                        CLE036
     C                   MOVEL     'CLE036'      DBKEY                                        CLE036
     C                   MOVEL     'SCSARDPD'    DBFILE                                       CLE036
     C                   Z-ADD     25            DBASE                                        CLE036
     C                   EXSR      *PSSR                                                      CLE036
     C                   ENDIF                                                                CLE036
     C                   ENDIF                                                                CLE036
      *                                                                                       CLE036
      * Check System Value FacilityCcyRepayment                                               CLE036
      ** Set up parameter so access object checks FacilityCcyRepayment                        CLE036
     C                   MOVE      *BLANKS       WPARM0                                       CLE036
     C                   MOVEL     'Facil'       WPARM1                                       CLE036
     C                   MOVEL     'ityCc'       WPARM2                                       CLE036
     C                   MOVEL     'yRepa'       WPARM3                                       CLE036
     C                   MOVEL     'yment'       WPARM4                                       CLE036
     C                   MOVEL     WPARM0        SVALK1                                       CLE036
      * Call Access object:                                                                   CLE036
     C                   CALL      'AOSVALR0'                                                 CLE036
     C                   PARM                    RTNCDE            7                          CLE036
     C                   PARM                    SVALK1           20                          CLE036
     C                   PARM                    SVAL1           200                          CLE036
     C                   PARM                    SVALK2           20                          CLE036
     C                   PARM                    SVAL2           200                          CLE036
     C                   PARM                    SVALK3           20                          CLE036
     C                   PARM                    SVAL3           200                          CLE036
     C                   PARM                    SVALK4           20                          CLE036
     C                   PARM                    SVAL4           200                          CLE036
     C                   PARM                    SVALK5           20                          CLE036
     C                   PARM                    SVAL5           200                          CLE036
     C                   PARM                    SVALK6           20                          CLE036
     C                   PARM                    SVAL6           200                          CLE036
     C                   PARM                    SVALK7           20                          CLE036
     C                   PARM                    SVAL7           200                          CLE036
     C                   PARM                    SVALK8           20                          CLE036
     C                   PARM                    SVAL8           200                          CLE036
     C                   PARM                    SVALK9           20                          CLE036
     C                   PARM                    SVAL9           200                          CLE036
     C                   PARM                    SVALK0           20                          CLE036
     C                   PARM                    SVAL10          200                          CLE036
      * If the system value is not found then issue a database error                          CLE036
     C     RTNCDE        IFNE      '      '                                                   CLE036
     C                   MOVEL     'SDSVALPD'    DBFILE                                       CLE036
     C                   Z-ADD     95            DBASE                                        CLE036
     C                   MOVEL     'SVALK1'      DBKEY                                        CLE036
     C                   EXSR      *PSSR                                                      CLE036
     C                   ELSE                                                                 CLE036
      * Isolate the first character of SVAL2 which = 'Y' or 'N'.                              CLE036
     C                   MOVEL     SVAL1         WRK01             1                          CLE036
     C     WRK01         IFEQ      'Y'                                                        CLE036
     C                   MOVE      'Y'           FREPAY            1                          CLE036
     C                   ELSE                                                                 CLE036
     C                   MOVE      'N'           FREPAY                                       CLE036
     C                   ENDIF                                                                CLE036
     C                   ENDIF                                                                CLE036
                                                                                              CLE036
     C/COPY WNCPYSRC,LE2016MC02
      *
      * Retrieve Date Details
     C                   CALL      'AOBANKR0'
     C                   PARM      '*MSG'        WWRTCD            7
     C                   PARM      '*FIRST'      WWOPTN            7
     C     SDBANK        PARM      SDBANK        DSFDY
      *   Error?
     C     WWRTCD        IFNE      *BLANKS
     C                   MOVEL     '*FIRST'      DBKEY
     C                   MOVEL     'SDBANKPD'    DBFILE
     C                   Z-ADD     1             DBASE
     C                   EXSR      *PSSR
     C                   ENDIF
      *
      * Set System Date
      *   Convert Midas system date to DDMMYYYY or MMDDYYYY
     C                   Z-ADD     BJRDNB        W#ZDAYN
     C                   EXSR      ZZA0140
     C**********         MOVEL     W#ZDATE8      W#SYSDAT                                     228849
     C                   MOVEL     W#DATE8       W#SYSDAT                                     228849
      *
      *     Date of Next Working Day
     C                   Z-ADD     BJDNWD        W#ZDAYN
     C                   EXSR      ZZA0140
     C**********         MOVEL     W#ZDATE8      W#DNWD                                       228849
     C                   MOVEL     W#DATE8       W#DNWD                                       228849
      *
      *     End of Year Date
     C                   Z-ADD     BJEYD         W#ZDAYN
     C                   EXSR      ZZA0140
     C**********         MOVEL     W#ZDATE8      W#EYD                                        228849
     C                   MOVEL     W#DATE8       W#EYD                                        228849
      *
      *     Previous End of Year Date
     C                   Z-ADD     BJPEYD        W#ZDAYN
     C                   EXSR      ZZA0140
     C**********         MOVEL     W#ZDATE8      W#PEYD                                       228849
     C                   MOVEL     W#DATE8       W#PEYD                                       228849
      *
     C     W#FTIME       IFEQ      ' '
      *
      * Set up Arrays for new file
     C                   CLEAR                   W#AMQDF
     C                   CLEAR                   W#ABRCH
      *
     C                   MOVE      'N'           W#FTIME           1
     C                   Z-ADD     *ZERO         X                 2 0
      *
      * Retrieve first Drip Feed Queue name
      *
     C*****              CALL      'AOBRCHR0'
     C                   CALL      'AOBRCHR1'
     C                   PARM      *BLANKS       WWRTCD
     C                   PARM      '*FIRST'      WWOPTN
     C                   PARM      *BLANKS       WWBRCD
     C     SDBRCH        PARM      SDBRCH        DSSDY
      *   Error?
     C     WWRTCD        IFNE      *BLANKS
     C                   MOVEL     '*FIRST'      DBKEY
     C                   MOVEL     'SDBRCHPD'    DBFILE
     C                   Z-ADD     2             DBASE
     C                   EXSR      *PSSR
     C                   ENDIF
      *
      * Load all non-duplicate Drip Feed Queue names and the branches into
      * the respective arrays
     C     WWRTCD        DOWEQ     *BLANKS
     C     A8MQDF        IFNE      *BLANKS
     C     A8MQDF        LOOKUP    W#AMQDF                                80
     C     *IN80         IFEQ      *OFF
     C                   ADD       1             X                 2 0
     C                   MOVEL     A8MQDF        W#AMQDF(X)
     C                   MOVEL     A8BRCD        W#ABRCH(X)
     C                   ENDIF
     C                   ENDIF
      *
      * Retrieve next Branch and Queue name
     C*****              CALL      'AOBRCHR0'
     C                   CALL      'AOBRCHR1'
     C                   PARM      *BLANKS       WWRTCD
     C                   PARM      '*NEXT '      WWOPTN
     C                   PARM      *BLANKS       WWBRCD
     C     SDBRCH        PARM      SDBRCH        DSSDY
      *   Error?
     C     WWRTCD        IFNE      *BLANKS
     C     WWRTCD        ANDNE     '*EOF'
     C                   MOVEL     '*NEXT '      DBKEY
     C                   MOVEL     'SDBRCHPD'    DBFILE
     C                   Z-ADD     3             DBASE
     C                   EXSR      *PSSR
     C                   ENDIF
      *
     C                   ENDDO
      *
      * If X=0 No Drip Feed Q-names have been picked up - Problem
      *
     C     X             IFEQ      0
     C                   EVAL      W#DBKEY= 'No Drip Feed Q-names on file'
     C                   MOVEL     W#DBKEY       DBKEY
     C                   MOVEL     'SDBRCHPD'    DBFILE
     C                   Z-ADD     13            DBASE
     C                   EXSR      *PSSR
     C                   ENDIF
      *
      * Save value of last queue in array
     C                   Z-ADD     X             XSV
      *
      *
      *
      * Connect to MQ Manager explicitly
     C**********         CALL      'QMQM'                                                   MD041126
      * I: Call Id: Connect queue manager
      * I: Queue manager cleared to get the default queue manager
      * O: Connection handle
      * O: Completion code
      * O: Reason code
     C**********         PARM      MQCONN        P#CID             9 0                      MD041126
     C**********         PARM      *BLANKS       P#QMNAME         48                        MD041126
     C*****W#HCONN       PARM      *ZERO         P#HCONN           9 0                      MD041126
     C**********         PARM      *ZERO         P#CCODE           9 0                      MD041126
     C**********         PARM      *ZERO         P#RSCOD           9 0                      MD041126
                                                                                            MD041126
     C                   EVAL      P#QMNAME = *BLANKS                                       MD041126
     C                   Z-ADD     *ZERO         P#HCONN                                    MD041126
     C                   Z-ADD     *ZERO         P#CCODE                                    MD041126
     C                   Z-ADD     *ZERO         P#REASON                                   MD041126
                                                                                            MD041126
     C                   CALLP     MQCONN( P#QMNAME : P#HCONN :                             MD041126
     C                                     P#CCODE : P#REASON )                             MD041126
                                                                                            MD041126
     C                   Z-ADD     P#HCONN       W#HCONN                                    MD041126
     C                   Z-ADD     P#REASON      P#RSCOD                                    MD041126
                                                                                            MD041126
      *   MQConnect failed?
     C     P#CCODE       IFEQ      CCFAIL
     C                   MOVEL     'MQCONN'      DBKEY
     C                   MOVEL     'QMQM'        DBFILE
     C                   Z-ADD     4             DBASE
     C                   MOVE      *ON           *IN30
     C                   EXSR      *PSSR
     C                   ENDIF
      *
      *
     C* Open MQ Drip Feed queue for each Drip Feed Queue name
     C                   Z-ADD     1             X
     C                   DO        XSV           X
      *
      *
      * Object Name: MQ Drip Feed Queue Name
     C                   MOVEL     W#AMQDF(X)    ODON
      *
      * Object queue manager name: *blank denotes queue manager to
      *                            which the application is connected
     C                   CLEAR                   ODMN
      *
      * Open object
     C**********         CALL      'QMQM'                                                   MD041126
      * I: Call Id: Open object
      * I: Connection handle
      * I: Object Descriptor:
      *      Object Name: MQ Drip Feed Queue Name
      *      Object queue manager name: *blank
      * I: MQOPEN Options: Open to put messages
      * O: Object handle
      * O: Completion code
      * O: Reason code
     C**********         PARM      MQOPEN        P#CID             9 0                      MD041126
     C**********         PARM      W#HCONN       P#HCONN           9 0                      MD041126
     C**********         PARM                    MQOD                                       MD041126
     C**********         PARM      OOOUT         P#OPTS            9 0                      MD041126
     C*****W#AMQDH(X)    PARM      *ZERO         P#HOBJ            9 0                      MD041126
     C**********         PARM      *ZERO         P#CCODE           9 0                      MD041126
     C**********         PARM      *ZERO         P#RSCOD           9 0                      MD041126
                                                                                            MD041126
     C                   Z-ADD     W#HCONN       P#HCONN                                    MD041126
     C                   Z-ADD     OOOUT         P#OPTS                                     MD041126
     C                   Z-ADD     *ZERO         P#HOBJ                                     MD041126
     C                   Z-ADD     *ZERO         P#CCODE                                    MD041126
     C                   Z-ADD     *ZERO         P#REASON                                   MD041126
                                                                                            MD041126
     C                   CALLP     MQOPEN( P#HCONN : MQOD :                                 MD041126
     C                                     P#OPTS  : P#HOBJ :                               MD041126
     C                                     P#CCODE : P#REASON )                             MD041126
                                                                                            MD041126
     C                   Z-ADD     P#HOBJ        W#AMQDH(X)                                 MD041126
     C                   Z-ADD     P#REASON      P#RSCOD                                    MD041126
                                                                                            MD041126
      *   MQOPEN failed?
     C     P#RSCOD       IFNE      RCNONE
     C                   MOVEL     'MQOPEN'      DBKEY
     C                   MOVEL     'QMQM'        DBFILE
     C                   Z-ADD     5             DBASE
     C                   MOVE      *ON           *IN30
     C                   EXSR      *PSSR
     C                   ENDIF
      *
     C                   ENDDO
      *
     C                   ENDIF
      *
      * Set Transaction Action
     C                   CLEAR                   X1ACTN
      *
      *
      * Set Timestamp
     C                   MOVE      '00000000'    W#X1TRTS
     C                   TIME                    W#TIME            6 0
     C                   MOVEL     W#TIME        W#X1TRTS
      *
      * Get Drip Feed Control Details
     C     '#DRP'        CHAIN     LEDLLDPD                           88
     C     *IN88         IFEQ      *ON
     C                   MOVEL     '#DRP'        DBKEY
     C                   MOVEL     'LEDLLDPD'    DBFILE
     C                   Z-ADD     6             DBASE
     C                   EXSR      *PSSR
     C                   ENDIF
      *
      * Set next available transaction reference
     C                   Z-ADD     BTTR          W#BTTR
      *
     C                   Z-ADD     0             W5FACT            3 0
     C                   Z-ADD     0             W5FCNO            2 0
     C                   Z-ADD     0             W6FACT            3 0
     C                   Z-ADD     0             W6FCNO            2 0
      *
     C                   MOVE      *BLANK        WKCLOS                                       172577
      *                                                                                       172577
     C                   MOVE      *BLANKS       STK(@Q)
     C                   SUB       1             @Q
      *
     C/COPY WNCPYSRC,LE2016MC04
     C                   ENDSR
      **********************************************************************
      *  ZZA0140   - Convert dayno to DDMMYYYY or MMDDYYYY
      *
      * I: Run Day Number in W#ZDAYN  5N 0
      * I: Date Format in BJDFIN from BANK ICD
      * O: Date in W#ZDATE8           8A
      **********************************************************************
     C     ZZA0140       BEGSR
      *
     C                   ADD       1             @Q
     C                   MOVEL     'ZZA0140   '  STK(@Q)
      *
      * Convert Midas dayno
      *
     C     W#ZDAYN       IFGT      *ZERO
      *
     C                   CALLB     'ZA0140M'
      * O: Return Code
      * I: Midas Day Number
      * I: Midas Date Format  D or M
      * O: Date DDMMYY or MMDDYY
      * O: Date DDMMMYY
      * O: Date YYYYMMDD
      * O: Date DDMMYYYY or MMDDYYYY
      *
     C                   PARM      *BLANK        P#ZRTN            1
     C                   PARM      W#ZDAYN       P#ZDAYN           5 0
     C                   PARM      BJDFIN        P#ZDFMT           1
     C                   PARM      *ZERO         P#ZDATE           6 0
     C                   PARM      *BLANK        P#ZDATA           7
     C                   PARM      *ZERO         P#ZDAT8           8 0
     C     W#ZDATE8      PARM      *ZERO         P#ZDAT8F          8 0
      *
     C                   MOVEL     W#ZDATE8      W#DATE8
      *
     C                   ELSE
     C*****              MOVE      *ALL'0'       W#ZDATE8
     C                   MOVEL     *BLANKS       W#DATE8           8
     C                   ENDIF
      *
     C     *LIKE         DEFINE    P#ZDAYN       W#ZDAYN
     C     *LIKE         DEFINE    P#ZDAT8       W#ZDATE8
      *
     C                   MOVE      *BLANKS       STK(@Q)
     C                   SUB       1             @Q
      *
     C                   ENDSR
      **********************************************************************
      *  ZEDIT     - Insert decimal point and zeros for numeric
      * I: Numeric field  16A
      * I: Decimal Places  2,0
      * O: Alphanumeric field 16A
      **********************************************************************
     C     ZEDIT         BEGSR
      *
     C                   ADD       1             @Q
     C                   MOVEL     'ZEDIT     '  STK(@Q)
      *
      * Convert number to Alpha
     C                   CALLB     'ZAEDITM'
      *
      * I/O: Number in ZFIELD 16A
      * I:   Number of Decimal Places
      *
     C     ZFIELD        PARM      ZFIELD        P#ZFIELD         16
     C                   PARM      ZADEC         P#ZADEC           2 0
     C     *LIKE         DEFINE    P#ZFIELD      ZFIELD
     C     *LIKE         DEFINE    P#ZADEC       ZADEC
      *
     C                   MOVE      *BLANKS       STK(@Q)
     C                   SUB       1             @Q
      *
     C                   ENDSR
      *****************************************************************
      *   Audit File Processing
      *****************************************************************
     C     AUDIT         BEGSR
      *
     C                   ADD       1             @Q
     C                   MOVEL     'AUDIT   '    STK(@Q)
      *
     C                   OPEN      LE2016AU
      * Log audit report to RCF
     C                   Z-ADD     SFNUMU        ZSNUM             6 0
     C                   CALL      'ZSFILE'
     C                   PARM      *BLANKS       SEQ               5
     C                   PARM      *BLANKS       WPARM             3
     C                   PARM                    SFILEU
     C                   PARM                    ZSNUM
     C                   PARM                    ZSERR             1
      *
     C     ZSERR         IFEQ      'Y'
     C                   MOVE      '9'           P#PARM2
     C                   SETON                                        U7U8LR
     C                   RETURN
     C                   ENDIF
      *
      * Print Header for Audit Report
     C                   WRITE     HEADAU
      * Print Database Error Details
     C                   WRITE     DBERROR
      *
     C                   MOVE      *BLANKS       STK(@Q)
     C                   SUB       1             @Q
      *
     C                   ENDSR
      *****************************************************************
      *
      *  *PSSR - Exception error processing
      *      Calls - NONE
      *
      *****************************************************************
     C     *PSSR         BEGSR
      *
      *   If an error has occurred within this program, update LDA, set
      *   error switches, dump program and return to calling program.
      *
     C     @DUMP         IFEQ      *BLANK
     C                   DUMP
      *
      * Audit report required?
     C     DBFILE        IFNE      *BLANKS
     C                   EXSR      AUDIT
     C                   ENDIF
      *
      * If there is an error other than a failure with QMQM accessing close
      * down all queues.
      *
     C     P#CCODE       IFEQ      CCOK
     C     STK(@Q)       ANDNE     'INITIAL'
     C                   EXSR      CLOSE
     C                   ENDIF
      *
     C                   MOVE      'Y'           @DUMP             1
     C                   MOVE      ' '           W#FTIME
     C     *DTAARA       DEFINE    LDA           @LDA            256
     C     *LOCK         IN        @LDA
     C                   MOVE      '9'           P#PARM2
     C                   MOVE      DBERR         @LDA
     C                   OUT       @LDA
     C                   ENDIF
      *
     C                   SETON                                        U7U8LR
     C                   RETURN
      *
     C                   ENDSR
      *****************************************************************
**  CPY@ - Copyright Statement
(c) Misys International Banking Systems Ltd. 2001
