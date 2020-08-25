     H DEBUG
      *****************************************************************
/*S*D****RPGBASEMOD****************************************************                       CRE101
/*STD *  RPGSQLMOD                                                    *                       CRE101
/*EXI *  TEXT('Midas GL Account database update')                     *
      *****************************************************************
      *                                                               *
      *  Midas - General Ledger Module                                *
      *                                                               *
      *  GLAMADUPD - Accounts Database Update                         *
      *                                                               *
      *  (c) Finastra International Limited 2001                      *
      *                                                               *
      *  Last Amend No. CSD103             Date 10Aug20               *
      *  Prev Amend No. AR891357A          Date 12Mar20               *
      *                 AR891357           Date 12Mar20               *
      *                 CER050             Date 16Jun19               *
      *                 MD053470           Date 13Aug19               *
      *                 MD053978           Date 25Jul19               *
      *                 CSD101             Date 07Dec18               *
      *                 CSD102             Date 08Jan19               *
      *                 AR1021393          Date 13Nov18               *
      *                 224697             Date 13Nov18               *
      *                 MD046248           Date 27Oct17               *
      *                 MD034366           Date 09Sep15               *
      *                 MD042832           Date 23Nov16               *
      *                 MD034725           Date 27Jul16               *
      *                 MD035554           Date 25May16               *
      *                 MD033852           Date 20Aug15               *
      *                 CRE101             Date 27Aug14               *
      *                 CGL165             Date 23Feb15               *
      *                 MD027195           Date 19Aug14               *
      *                 233901             Date 13May14               *
      *                 229520             Date 13May14               *
      *                 MD029681           Date 12Aug14               *
      *                 MD026269           Date 12May14               *
      *                 MD024398           Date 11May14               *
      *                 AR1073268          Date 28Apr14               *
      *                 AR900144           Date 03Dec12               *
      *                 AR947093A          Date 04May12               *
      *                 AR883751           Date 22Dec11               *
      *                 AR871763           Date 16Dec11               *
      *                 CRE072             Date 30Jun11               *
      *                 AR818450           Date 23Aug11               *
      *                 CER049             Date 06Dec10               *
      *                 CRE073             Date 06Dec10               *
      *                 CER055             Date 06Dec10               *
      *                 CRE075             Date 06Dec10               *
      *                 CER059             Date 19Jul10               *
      *                 262398             Date 03Nov09               *
      *                 CER047             Date 19May08               *
      *                 BUG22973           Date 27May10               *
      *                 CSD083             Date 27May10               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      *                 CRE015             Date 18Dec09               *
      *                 CRE005             Date 18Jan10               *
      *                 260323             Date 19May09               *
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      *                 256564             Date 17Sep08               *
      *                 244106             Date 16Jul07               *
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 231128             Date 16Oct06               *
      *                 242488             Date 27Sep06               *
      *                 240296             Date 07Jul06               *
      *                 220677             Date 06Jun06               *
      *                 216905             Date 06Jun06               *
      *                 239720             Date 11May06               *
      *                 238839             Date 29Mar06               *
      *                 237346 (Reopen)    Date 08Mar06               *
      *                 238639             Date 27Feb06               *
      *                 CSD031             Date 10Apr06               *
      *                 237346             Date 13Feb06               *
      *                 236046             Date 13Dec05               *
      *                 CSD027             Date 09Dec05               *
      *                 236976             Date 30Nov05               *
      *                 BUG8947            Date 23Nov05               *
      *                 BUG8210            Date 02Sep05               *
      *                 CRE023             Date 29Jul05               *
      *                 CAP086             Date 08Jun05               *
      *                 BUG7194            Date 17May05               *
      *                 CSW037A            Date 02May05               *
      *                 BUG6389            Date 31Mar05               *
      *                 208437             Date 14Aug02               *
      *                 205318             Date 29Apr02               *
      *                 205308             Date 29Apr02               *
      *                 204942             Date 29Apr02               *
      *                 204105             Date 21Mar02               *
      *                 202009             Date 15Apr02               *
      *                 CSD025             Date 11Jan05               *
      *                 CSW037             Date 15Dec04               *
      *                 CSW036             Date 15Dec04               *
      *                 BUG4684            Date 29Oct04               *
      *                 BUG3365            Date 01Jul04               *
      *                 CTI005             Date 12Apr04               *
      *                 CTI004             Date 12Apr04               *
      *                 CLE025             Date 20Oct03               *
      *                 BUG2807            Date 25May04               *
      *                 TDA084             Date 16Apr04               *
      *                 TDA033             Date 18Mar04               *
      *                 225539             Date 10Mar04               *
      *                 CGL029             Date 27Mar04               *
      *                 CDE005             Date 19Aug03               *
      *                 215208             Date 13Mar03               *
      *                 218554             Date 20Feb03               *
      *                 208921             Date 20Feb03               *
      *                 CSD015             Date 14Oct02               *
      *                 215952             Date 17Mar03               *
      *                 CSD012             Date 15Oct02               *
      *                 208221             Date 11Dec02               *
      * Midas Release 4.01.03 ----------------------------------------*
      *                 211648             Date 09Jan03               *
      *                 211254             Date 29Nov02               *
      *                 211635             Date 27Nov02               *
      * Midas Release 4.01.02 ----------------------------------------*
      *                 208006             Date 07Aug02               *
      *                 201704             Date 05Jul02               *
      *                 203214             Date 28May02               *
      *                 203282             Date 28May02               *
      *                 194431             Date 22May02               *
      *                 198865             Date 25Mar02               *
      * Midas Release 4.01 -------------------------------------------*
      *                 CSC011             Date 18Sep01               *
      *                 190343             Date 28Nov01               *
      *                 193883             Date 21Nov01               *
      * Midas Release 4 --------------- Base -------------------------*
      *                 CDE002             Date 02Feb00               *
      * Midas DBA 3.05 -----------------------------------------------*
      *                 185230             Date 29Dec00               *
      *                 CPB002             Date 25Aug00               *
      * Midas DBA 3.03 -----------------------------------------------*
      *                 CDE001             Date 12Apr00               *
      * Midas DBA 3.02 -----------------------------------------------*
      *                 CPB001             Date 23Aug99               *
      *                 CAP013             Date 19Nov99               *
      *                 CFT004             Date 05Nov99               *
      *                 CAP035  *CREATE    Date 10May99               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CSD103 - LIBOR Deregulation - Common Layer/Standing Data     *
      *  AR891357A - RUNDT field is not existing on the module.       *
      *              Change LACD (Last Activity date) should be set to*
      *              rundate (BJRDNB field not RUNDT).                *
      *              (Child: AR891358)                                *
      *  AR891357 - Inactive Retail Accounts set to 'Active' by a     *
      *           User are reset during CoB to 'Inactive'.            *
      *           Account/s changed from 'Inactive' to 'Active'       *
      *           status should have their Last change date updated   *
      *           equal to the rundate. (Child: AR891358)             *
      *  CER050 - Annualised Percentage Rate                          *
      *  MD053470 - When Additional Overdraft Rate was changed to zero*
      *             with an OD Rate Value Date but without a DR change*
      *             value date, the value date in STRAN is not updated*
      *  MD053978 - Cannot amend TI account flag from Y to N.         *
      *           - Missing codes by MD034725.                        *
      *  CSD101 - Password Encryption                                 *
      *  CSD102 - Password Length Extension (Recompile)               *
      *  AR1021393 - Wrong balances on account statement. Use balance *
      *              from GLACBTPD only if a/c not opened on rundate. *
      *              (Child: AR1021396)                               *
      *            - Applied for MD052264.                            *
      *  224697 - Wrong balances on account statement. If change      *
      *           frequency is from non-'E' to 'E', ECFB should be the*
      *           start-of-day LDBL (taken from file GLACBTL0), and   *
      *           EPNO with LSTP. If change frequency is from 'E' to  *
      *           non-'E', CFSB should be updated with ECFB, LSTP with*
      *           EPNO and LSTD with LMVD.                            *
      *         - Applied for AR1021393 (Child: AR1021396)            *
      *         - Applied for MD052264.                               *
      *  MD046248 - Finastra Rebranding                               *
      *  MD034366 - CRE005 failuers in COB. Added timestamp field to  *
      *             ensure that latest rate change record is used.    *
      *  MD042832 - Serious Midas Error upon authorization due to     *
      *             incorrect of indicator.                           *
      *  MD034725 - Single CCY + Branch available in BFM and TI Plus  *
      *  MD035554 - 2o'clock/ABC compatibility (Recompile)            *
      *  MD033852 - Wrong balance when statement frequency is         *
      *             changed from non 'E' to 'E'.                      *
      *  CRE101 - Interim Interest Statements on a Frequency          *
      *           Pgm type changed to be SQLRPGLE                     *
      *           Added hooks: CRE101_006, CRE101_008, CRE101_021,    *
      *                        CRE101_026, CRE101_029, CRE101_030,    *
      *                        CRE101_031                             *
      *  CGL165 - Dual Withholding Tax                                *
      *  MD027195 - Turnover statements for GL and RE accounts wrong  *
      *             opening balance.                                  *
      *           - Set ECFB = start of day ledger balance if STFQ is *
      *             set = 'E' during amend mode.                      *
      *  233901 - Similar with fix 229520. While, 229520 corrects the *
      *           TIME being written in PF/STRAN this fix will correct*
      *           the time being written to PF/RERCH2PD & PF/RERCH3PD *
      *           as CRE005 in *ON in the client's system.            *
      *         - Applied for MD026269A.                              *
      *  229520 - For amendments in interest rate, make sure that     *
      *           sequences 2 and 3 will have the same time of input  *
      *           as sequence 1 to avoid problem in determining the   *
      *           most recent changes.  Upgrade of fix 168703.        *
      *         - Applied for MD026269A.                              *
      *  MD029681 - Serious Midas Error occurred due to *LDA lock     *
      *             being not granted                                 *
      *  MD026269 - Make sure that TRNO in STRAN is incrementing by 1 *
      *             in every record.                                  *
      *  MD024398 - API Performance Optimisation                      *
      *  AR1073268 - Transaction number written in STRAN is always 1. *
      *              Set next transaction number to TRNO +1.          *
      *              (Child: AR1073269)                               *
      *            - Applied for MD023799.                            *
      *  AR900144 - STRAN Limitation.                                 *
      *             Need to modify programs updating STRAN header and *
      *             detail records, from update to write record to    *
      *             STRAN.                                            *
      *             Remove Update of header record in STRAN and       *
      *             change Update of detail to Write of detail record *
      *             in STRAN. (Child: AR900145)                       *
      *             Applied for AR1005423. (Child: AR1005425)         *
      *  AR947093A - Base Rate amendment resulted to 0 interest rate  *
      *  AR883751 -  Cannot authorize term and notice account         *
      *  AR871763 - No stamp tax was generated due to no debit        *
      *             interest computed                                 *
      *  CRE072 - BankFusion Midas Teller Related Changes             *
      *  AR818450 - A Serious Midas Error was encountered upon        *
      *             account authorisation                             *
      *  CER049 - Stamp Tax (Recompile)                               *
      *  CRE073 - Interest Rate Rounding                              *
      *  CER055 - Penalty Interest on Exceeding Overdraft Limit       *
      *  CRE075 - Effective Date for Retails Accounts                 *
      *  CER059 - German Feature Upgrade to Delhi                     *
      *  262398 - Database error during authorization. Applied core   *
      *           fix 256533.                                         *
      *  256533 - Initialise RC_NOIS to zero to prevent data decimal  *
      *           error.                                              *
      *  CER047 - German Features LF037-00 Reporting §24c KWG         *
      *  BUG22973 - No TimeStamp in Transaction Confirmation during   *
      *             Completion and Authorisation                      *
      *  CSD083 - Watch List Compliance Upgrade                       *
      *  CRE015 - Retail Term and Notice Accounts                     *
      *  CRE005 - Changes to STRAN                                    *
      *  260323 - Serious Midas error while amending Account - users  *
      *           are not able to activate the account. Speed up      *
      *           access to ACCNTAC.                                  *
      *  256564 - Recompile due to PF changes done by fix 256330      *
      *  244106 - MEC103 failed due to FCOOB in ACDETAC. Accounts     *
      *           inserted and deleted on the same day must not       *
      *           lessen number of accounts opened. Also, to avoid    *
      *           FCOOB in REC74 in ACCNTAC, records inserted and     *
      *           deleted on the same day should not affect number    *
      *           of records. Applied fixes 228425 and 229528.        *
      *  231128 - Same fix 242488.                                    *
      *  242488 - During amend, amendment not registered in ACCNTBXC. *
      *           Apply 206489 + 213313 + remove part of 208437       *
      *           + ensure record is written in ACCNTBXC in ALL cases *
      *         - Apply fix 239720/238639.                            *
      *  240296 - Account not authorised when timestamps are different*
      *  220677 - Ensure alternate account is accesed properly when   *
      *           amending alternate-to accounts.                     *
      *         - Applied fix 220598.                                 *
      *         - Fix applied by 237346.                              *
      *  216905 - Rate details on STRAN are only updated for the base *
      *           rate entered against the account but not for the    *
      *           base rate on the interest type/subtype.             *
      *  239720 - During amend, amendment not registered in ACCNTBXC. *
      *           Apply 206489 + 213313 + remove part of 208437       *
      *           + ensure record is written in ACCNTBXC in ALL cases *
      *         - Applied 238639.                                     *
      *  238839 - Pass parameter AMIBAN to GLAMADRTV.                 *
      *  237346 - ACNUMA file is only used for input, no need to      *
      *  (Reopen) define with COMMIT keyword.                         *
      *  238639 - During amend, amendment not registered in ACCNTBXC. *
      *           Apply 206489 + 213313 + remove part of 208437       *
      *           + ensure record is written in ACCNTBXC in ALL cases *
      *         - Applied 231128                                      *
      *  CSD031 - Enhanced Centralised Static Data (Recompile)        *
      *  237346  - It is posible to close Retail account which is     *
      *            defined as an alternate account for other account. *
      *            Patterned after 230815/229100                      *
      *  236046 - Complete fix 215208. Patterned after 224950 from    *
      *           their release 4 source.                             *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  236976 - DBU_AMAD calculates incorrect values for RERCH2PD.  *
      *  BUG8947- Interest accruals not using correct tiers.          *
      *           Apply fixes 234846, 233874 & 232481.                *
      *         - 3rd Rate Record contains first rates, not last.     *
      *         - Amend part of 205308 to make sure debit interest    *
      *           type/subtype is output to PF/STRAN correctly.       *
      *         - PF/STRAN is not updated after changes to interest   *
      *           type/sub-type.                                      *
      *  BUG8210 - GLC3571 failed due to DBERR in ACCNTBXC (empty)    *
      *            Need to change condition to read/write on ACCNTBXC *
      *            simply for all retail accounts.                    *
      *  CRE023 - 2 O'clock Flag Upgrade to MidasPlus                 *
      *  CAP086 - Introduce Auto Authorisation to the API's           *
      *           without it.                                         *
      *  BUG7194 - ACCNTBXC is never updated if CRE001 and CDE002     *
      *            are switched off.                                  *
      *  CSW037A- Additional Field extended to 40 chars (recompile)   *
      *  BUG6389 - In Standing Data Authorization, the amending       *
      *            user is sometimes reflected wrongly                *
      *  208437 - Remove 203214.  Block all DR/CR and Refer all CR/DR *
      *           can now be setup (input and amend) in Tof (3.04).   *
      *  205318 - When an account has credit interest type-subtype    *
      *           condition and this condition has more than six      *
      *           lines the lines after the sixth has not been taken  *
      *           in account.                                         *
      *  205308 - Credit conditions are wrong when interest type-     *
      *           subtype is applied to debit condition.              *
      *  204942 - Stop writing duplicate record on ACCNTBXC.          *
      *  204105   If change frequency is from non-'E' to 'E', ECFB    *
      *           should be the start-of-day LDBL.                    *
      *  202009 - Overdraft rates are not applied to the account.     *
      *  CSD025 - Customer De-Activation                              *
      *  CSW037 - Additional Field Data on MT300/MT320                *
      *  CSW036 - Dual SWIFT BIC held on Client Details               *
      *  BUG4684 - Rename WCOA to COLA same as ACCNTAB. (Recompile)   *
      *  BUG3365 - Set TI branch when amending an account to be a     *
      *            TI account.                                        *
      *  CTI005 - Midas Plus-TI Integration Enhancements              *
      *           Automatic Account Opening                           *
      *  CTI004 - MidasPlus TI Integration Enhancements               *
      *           Accounts Integration                                *
      *  CLE025 - Credit Lines                                        *
      *  BUG2807- Close an account and the user is QUSER on           *
      *           standing data authorisation                         *
      *  TDA084 - "Alternative A/C to post DR/CR Interest" fields     *
      *           contains incorrect values due to improper passing   *
      *           of fields from GLVAMRI to REVIASH.  Corrected this  *
      *           by moving the fields of GLVAMRI to matching fields  *
      *           of REVIASH.                                         *
      *  TDA033 - Missing fields in GLBXSHPD                          *
      *           Error in STHead Data Structure                      *
      *  225539 - Debit rate change date and Credit rate change date  *
      *           showed as zero during authorisation, after          *
      *           amendment of rate details.                          *
      *  CGL029 - Increase Account Code to 10 digits                  *
      *  CDE005 - Data Export - Reservation ID                        *
      *  215208 - Completed the update of the fields of PF/STRAN.     *
      *           Amended program to update the change value date.    *
      *  218554 - Credit calc basis change only not updating REHISPD. *
      *  208921 - Only call AORETLR0 if Retail is on.                 *
      *  CSD015 - Midas Compliance Watch - Watch List Checking        *
      *  215952 - Initialise field RC_NOIP and TRC_NOIP to stop       *
      *           decimal data error.                                 *
      *  CSD012 - Standing Data Authorisation.                        *
      *  208221 - Default Margin from Rate/Spread changes             *
      *  211648 - Base rate code not taken into consideration when    *
      *           interest type subtype used.                         *
      *  211254 - Incorrect consideration BMLDAI.                     *
      *  211635 - When opening an account initialise HISTORICAL bal   *
      *           to 0.                                               *
      *  208006 - Insert correct branch field for key RetKeyDS.       *
      *  201704 - Avoid DBU_AMAD error on RECOMD file                 *
      *  203214 - Cannot Amend an account via from TOF as block C/D   *
      *          is not correct in TOF.                               *
      *  203282 - All retails files are not updated if retail number  *
      *           is not used.                                        *
      *  194431 - Change parameter list to match changes in GLAMADRTV *
      *           Also, default DRCD, CRCD, OLDR and OLCR of file     *
      *           ACCNTAB into DACO.  Reset all fields of GLBT and    *
      *           set BIT2 'ON' if PTAD is 'Y'.                       *
      *  198865 - Added INFSR to RECOM so it dumps. Also fix DBASE    *
      *           '031' by using CC_CCY for REINT key field           *
      *           Add DUMP to debug '*RECUPD' returned to GLAMADRPR   *
      *  CSC011 - 24x7 Midas Availability                             *
      *  190343 - Update STRAN with the correct value date for credit *
      *           rate changes.                                       *
      *  193883 - To avoid DBerr set-up Front ID correctly.           *
      *  CDE002 - CCRM Revenue Analysis - Addition of Margin Int. Flds*
      *  185230 - Update STRAN with correct effective interest rate - *
      *           ensure that spread rate is added to the base rate.  *
      *  CPB002 - Meridian DBA Middleware Replication Customisation.  *
      *           Recompiled                                          *
      *  CDE001 - Data Export - CCRM Limits                           *
      *  CPB001 - Meridian DBA Middleware Replication Customisation.  *
      *           Reset REPI flag.                                    *
      *  CAP013 - Allow access by Midas transaction ID if not insert  *
      *  CFT004 - Straight Through Processing Phase 2                 *
      *         - International Bank Account Numbers                  *
      *  CAP035 - Midas API Conversion for ToF                        *
      *                                                               *
      *****************************************************************

     FMEMOSL2   IF A E           K DISK    COMMIT
     F                                     PREFIX(M_)

     FACCNTAC   UF   E             DISK    COMMIT
     F                                     RENAME(ACCNTACF:ACCNTCXF)
     F                                     PREFIX(C_)

     FREIAC     UF A E           K DISK    COMMIT
     F                                     PREFIX(RE_)

     FREHISBL   UF A E           K DISK    COMMIT
     F                                     PREFIX(RH_)

     FRECOM     UF A E           K DISK    COMMIT
     F                                     PREFIX(RC_)
     F                                     INFSR(SRERR)                                       198865

     FREACR     UF A E           K DISK    COMMIT
     F                                     IGNORE(REACRZF)
     F                                     PREFIX(RA_)

     FREACRZ    UF   E             DISK    COMMIT
     F                                     PREFIX(RZ_)

     FACCNTBXC  UF A E           K DISK    COMMIT
     F                                     PREFIX(AX_)

     FREODHSL0  UF A E           K DISK    COMMIT
     F                                     PREFIX(RO_)

     F***REAPWDL0  UF A E           K DISK    COMMIT                                          CSD101
     F**********                              PREFIX(RW_)                                     CSD101

     F***STRAN**   UF   E             DISK    COMMIT                                        AR900144
     FSTRAN     UF A E             DISK    COMMIT                                           AR900144
     F                                     PREFIX(ST_)

      ** Rate Change files                                                                    CRE005
     FRERCHHPA  UF   E             DISK    COMMIT                                             CRE005
     F                                     PREFIX(IH_)                                        CRE005
     FRERCH1PD  UF A E             DISK    COMMIT                                             CRE005
     F                                     PREFIX(I1)                                         CRE005
     FRERCH2PD  UF A E             DISK    COMMIT                                             CRE005
     F                                     PREFIX(I2)                                         CRE005
     FRERCH3PD  UF A E             DISK    COMMIT                                             CRE005
     F                                     PREFIX(I3)                                         CRE005
                                                                                              CRE005
     FREINT     IF   E           K DISK    PREFIX(RT_)

     FACCBR     UF A E           K DISK    COMMIT
     F                                     PREFIX(AC_)

     F/COPY WNCPYSRC,GLH00573
      ** FT Retail Account File                                                               237346
     F**ACNUMA****IF   E           K DISK    COMMIT                                    237346 237346
     FACNUMA    IF   E           K DISK                                                       237346
     F                                     RENAME(ACCNTABF:ACNTABF)                           237346
     F                                     PREFIX(AN_)                                        237346
                                                                                              237346
     FREHISLS   UF   E           K DISK    COMMIT
     F                                     PREFIX(RL_)
      ** Retail III Table file
     FTABTBRE   IF   E             DISK    INFSR(SRERR)
     F                                     PREFIX(R_)
                                                                                            MD027195
     FGLACBTL0  IF   E           K DISK                                                     MD027195
     F                                     PREFIX(GL_)                                      MD027195
                                                                                              CSD012
     FSDAULGL0  UF A E           K DISK    COMMIT                                             CSD012
      * RTV : Authorisation Log - by Key                                                      CSD012
                                                                                              CSD012
     FGLACSHL0  UF A E           K DISK    COMMIT                                             CSD012
     F                                     RENAME(ACCNTABF:GLACSHD0)                          CSD012
     F                                     PREFIX(TAC_)                                       CSD012
      * UPD : GL Accnt Details Shadow File  by key                                            CSD012
                                                                                              CSD012
     FGLBXSHL0  UF A E           K DISK    COMMIT                                             CSD012
     F                                     PREFIX(TAX_)                                       CSD012
      * UPD : GL Accnt details extension shadow file by key                                   CSD012
                                                                                              CSD012
     FREIASHL0  UF A E           K DISK    COMMIT                                             CSD012
     F                                     PREFIX(TRE_)                                       CSD012
      * UPD : RE Retail Int & Charges shadow file by key                                      CSD012
                                                                                              CSD012
     FRECMSHL0  UF A E           K DISK    COMMIT                                             CSD012
     F                                     PREFIX(TRC_)                                       CSD012
      * UPD : RE Retail Commission shadow file by key                                         CSD012
                                                                                              CSD012
     F***REPWSHL0  UF A E           K DISK    COMMIT                                   CSD012 CSD101
     F***                                     PREFIX(TRW_)                             CSD012 CSD101
      **UPD*:*RE*Retail*accnt*Password*Shadow*file*by*key**************                CSD012 CSD101

      ** Compliance Watch Hit List                                                            CSD015
     FSDCWHTL1  IF   E           K DISK                                                       CSD015
                                                                                              CSD015
      ** SD Branch Codes                                                                      CTI004
     FSDBRCHL5  IF   E           K DISK                                                       CTI004
                                                                                              CTI004
     F/COPY WNCPYSRC,GLAMADDF01
      *                                                                                       CRE023
      ** Outward Clearing Balance File                                                        CRE023
      *                                                                                       CRE023
     FREMEMLL0  O    E           K DISK    COMMIT                                             CRE023
     F                                     USROPN                                             CRE023
                                                                                              CRE015
      ** Period and penalty details                                                           CRE015
                                                                                              CRE015
     FREPRPNL4  UF A E           K DISK    INFSR(*PSSR)                                       CRE015
     F                                     COMMIT                                             CRE015
                                                                                              CRE015
      ** Period and penalty details shadow file                                               CRE015
                                                                                              CRE015
     FREPRSHL0  UF A E           K DISK    INFSR(*PSSR)                                       CRE015
     F                                     PREFIX(TRP_)                                       CRE015
     F                                     COMMIT                                             CRE015
                                                                                              CRE015
      ** Account code extension file                                                          CRE015
                                                                                              CRE015
     FSDACD1L0  IF   E           K DISK    INFSR(*PSSR)                                       CRE015
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ Automatically included D-specs       ¦
      ** ¦ ==============================       ¦
      ** +--------------------------------------+
      **
      **--------------------------------------------------------------------------------------------
      ** The following /COPY line includes (among others) the LDA layout
      ** and the copyright array definition:
     D/COPY ZACPYSRC,STD_D_SPEC
      **--------------------------------------------------------------------------------------------

      **--------------------------------------------------------------------------------------------
      ** The following /COPY includes the MM standard declares:
     D/COPY ZACPYSRC,STDDECLARE
      **--------------------------------------------------------------------------------------------

      **--------------------------------------------------------------------------------------------
      ** The following /COPY line includes all the defined fields in the
      ** Program Status Data Structures.  They have meaningful
      ** names, prefixed by 'PS'.
     D/COPY ZACPYSRC,PSDS
      **--------------------------------------------------------------------------------------------
      ** The following /COPY line includes the definitions for error and
      ** warning message arrays.
     D/COPY ZACPYSRC,ERR_ARRAYS
      **--------------------------------------------------------------------------------------------


      ** +--------------------------------------+
      ** ¦ End of automatically included D-specs¦
      ** ¦ =====================================¦
      ** +--------------------------------------+

      *****************************************************************
      ** Timestamp for the transaction
     D TimeStamp       S               Z

     D ChkAccnFmt    E DS                  EXTNAME(ACCNTAB)
      ** Rename fields for Timestamp checking
     D                                     PREFIX(CH)
      * Current Account in File Format (Extension File)
     D CABXFilFmt    E DS                  EXTNAME(ACCNTBXC)
     D                                     PREFIX(CA_)
      * Current Account in File Format (Extension File)
     D CARIFilFmt    E DS                  EXTNAME(REIACD)
     D                                     PREFIX(CB_)
      * Current Account in File Format (Extension File)
     D CACOFilFmt    E DS                  EXTNAME(RECOMD)
     D                                     PREFIX(CC_)
      **Current*Account*in*File*Format*(Extension File)****************                       CSD101
     D***CAPWFilFmt    E DS                  EXTNAME(REAPWDPD)                                CSD101
     D CAPWFilFmt    E DS                  EXTNAME(GLVAMPWPD)                                 CSD101
     D                                     PREFIX(CD_)
                                                                                              CRE015
     D CAPPFilFmt    E DS                  EXTNAME(REPENAPD)                                  CRE015
     D                                     PREFIX(CE_)                                        CRE015

     D/COPY OFCPYSRCZ,CRE101_029                                                              CRE101
     D GLEAMAD       E DS                  EXTNAME(GLEAMADPD)
      * Error indicators


      **  EXTERNALLY DESCRIBED DATA STRUCTURE FOR VALID ACCOUNT
     D GLVAMAD       E DS                  EXTNAME(GLVAMADPD)
     D GLVAMBX       E DS                  EXTNAME(GLVAMBXPD)
     D GLBXACOD      E                     EXTFLD(QQACOD)                                     CGL029
     D GLVAMRI       E DS                  EXTNAME(GLVAMRIPD)
     D GLRIACOD      E                     EXTFLD(QQACOD)                                     CGL029
     D GLVAMRIsh               1    145                                                       CSD012
     D GLVAMRIEX             212    284                                                       CGL029
     D GLVAMRImn               1    144                                                       TDA084
     D GLVAMCO       E DS                  EXTNAME(GLVAMCOPD)
     D GLCOACOD      E                     EXTFLD(QQACOD)                                     CGL029
     D GLVAMCOsh               1    286                                                       CSD012
     D GLVAMPW       E DS                  EXTNAME(GLVAMPWPD)
     D GLPWACOD      E                     EXTFLD(QQACOD)                                     CGL029
     D***GLVAMPWsh               1     33                                              CSD012 CSD101
     D GLVAMPP       E DS                  EXTNAME(GLVAMPPPD)                                 CRE015
     D**GLVAMPPsh              1   6968                                                CRE015 CRE073
     D  GLVAMPPsh              1   7904                                                       CRE073
     D/COPY OFCPYSRCZ,CRE101_006                                                              CRE101

      **  Externally described Data Structure for Valid Shadow Account                        CSD012
     D GLVACSH       E DS                  EXTNAME(GLACSHPD)                                  CSD012
     D                                     PREFIX(TAC_)                                       CSD012
     D GLVBXSH       E DS                  EXTNAME(GLBXSHPD)                                  CSD012
     D                                     PREFIX(TAX_)                                       CSD012
     D REVIASH       E DS                  EXTNAME(REIASHPD)                                  CSD012
     D                                     PREFIX(TRE_)                                       CSD012
     D REVCMSH       E DS                  EXTNAME(RECMSHPD)                                  CSD012
     D                                     PREFIX(TRC_)                                       CSD012
     D***REVPWSH       E DS                  EXTNAME(REPWSHPD)                         CSD012 CSD101
     D***                                     PREFIX(TRW_)                             CSD012 CSD101
     D REVPENA       E DS                  EXTNAME(REPRSHPD)                                  CRE015
     D                                     PREFIX(TRP_)                                       CRE015

      **  Externally described Data Structure for 'BEFORE UPDATE' Account
     D B_ACCNT       E DS                  EXTNAME(ACCNTAB)
     D                                     PREFIX(BA_)

      **  Externally described Data Structure for Account by Branch
     D ACCNTBR       E DS                  EXTNAME(ACCNTAB)
     D                                     PREFIX(AC_)

      **  Externally described Data Structure for 'BEFORE UPDATE'
      **  Account Extension
     D B_ACCNTX      E DS                  EXTNAME(ACCNTBXC)
     D                                     PREFIX(BX_)

      **  Externally described Data Structure for Account Extension
     D ACCNTX        E DS                  EXTNAME(ACCNTBXC)
     D                                     PREFIX(AX_)

      **  Externally described Data Structure for 'BEFORE UPDATE' Retail
     D B_REIAD       E DS                  EXTNAME(REIACD)
     D                                     PREFIX(BR_)

      **  Externally described Data Structure for Retail
     D REIAD         E DS                  EXTNAME(REIACD)
     D                                     PREFIX(RE_)
     D REIADEX               146    218                                                       CGL029
                                                                                              CSD012
      **  Externally described Data Structure for Retail Commisssion                          CSD012
     D RECOMDATA     E DS                  EXTNAME(RECOMD)                                    CSD012
     D                                     PREFIX(RC_)                                        CSD012
                                                                                              CSD012
      **  Externally described Data Structure for Retail                               CSD012 CSD101
     D***REAPWDATA     E DS                  EXTNAME(REAPWDPD)                         CSD012 CSD101
     D**********                             PREFIX(RW_)                               CSD012 CSD101
                                                                                              CSD012
     D REPRPN        E DS                  EXTNAME(REPRPNPD)                                  CRE015
     D ArrFilBuf       S                   DIM(26) LIKE(REPRPN)                               CRE015
                                                                                              CRE015
      ** REPENAPD is equal to 26 occurrence of REPRPNPD                                       CRE015
                                                                                              CRE015
     D REPENA        E DS                  EXTNAME(REPENAPD)                                  CRE015
     D                                     PREFIX(X_)                                         CRE015
                                                                                              CRE015
      ** EXTERNAL DS FOR BRANCH DETAILS                                                       CTI004
     D SDBRCH        E DS                  EXTNAME(SDBRCHPD)                                  CTI004
     D                                     PREFIX(DS_)                                        CTI004

     D                 DS                                                       CDE001
     D*W#ACID***               1     18                                                CDE001 CGL029
     D W#ACID                  1     24                                                       CGL029
     D**W#CNUM**               1      6S 0                                             CDE001 CSD027
     D  W#CNUM                 1      6A                                                      CSD027
     D  W#CCY                  7      9A                                        CDE001
     D**W#ACOD**              10     13S 0                                             CDE001 CGL029
     D**W#ACSQ**              14     15S 0                                             CDE001 CGL029
     D**W#BRCA**              16     18A                                               CDE001 CGL029
     D  W#ACOD                10     19S 0                                                    CGL029
     D  W#ACSQ                20     21S 0                                                    CGL029
     D  W#BRCA                22     24A                                                      CGL029
                                                                                CDE001
      * DATA STRUCTURES FOR USE WITH ACCESS PROGRAMS

     D SDBANK        E DS                  EXTNAME(SDBANKPD)
      * DATA STRUCTURE FOR BANK DETAILS

     D SDGELR        E DS                  EXTNAME(SDGELRPD)
      * DATA STRUCTURE FOR BANK DETAILS

     D SDMMOD        E DS                  EXTNAME(SDMMODPD)
      * DATA STRUCTURE FOR BANK DETAILS

     D/COPY WNCPYSRC,GLAMADDD01
     D SDBSRT        E DS                  EXTNAME(SDBSRTPD)
      * DATA STRUCTURE FOR Base Rate DETAILS

     D SDRETL        E DS                  EXTNAME(SDRETLPD)
     D SDRETLACCD    E                     EXTFLD(QQACCD)                                     CGL029
      * DATA STRUCTURE FOR RETAIL DETAILS

     D DSFDY         E DS                  EXTNAME(DSFDY)
      * FIRST DS FOR ACCESS PROGRAMS, SHORT DATA STRUCTURE

     D DSSDY         E DS                  EXTNAME(DSSDY)
      * SECOND DS FOR ACCESS PROGRAMS, LONG DATA STRUCTURE

     D SC24X7        E DS                  EXTNAME(SC24X7) DTAARA(SC24X7)                     CSC011
      ** 24X7 status data area                                                                CSC011
                                                                                              CSC011
     D APHEAD        E DS                  EXTNAME(APHEADPD)                                  CSC011
      ** Midas API Message Header Format Definition                                           CSC011
                                                                                              CSC011
      ** Switchable Features Description                                                      CSC011
     D SCSARD        E DS                  EXTNAME(SCSARDPD)                                  CSC011
     D  SCLCD        E                     EXTFLD(LCD)                                        CSC011
                                                                                              CSC011
      ** SD data area                                                                         CSC011
     D SDSTAT        E DS                  EXTNAME(SDSTAT) DTAARA(SDSTAT)                     CSC011
                                                                                              CSC011
      ** Data Structure for Accessing SDCUSTPD                                                CSD015
     D SDCUST        E DS                  EXTNAME(SDCUSTPD)                                  CSD015
                                                                                              CSD015
      ** Data Structure for Watch List Checking Details                                       CSD015
     D SDWLCC        E DS                  EXTNAME(SDWLCCPD)                                  CSD015
                                                                                              CSD015
      ** Data Structure used as parameters for the Compliance Engine                          CSD015
     D PDSWLTD       E DS                  EXTNAME(SDWLTDPD)                                  CSD015
                                                                                              CSD015
      ** Data structure for Compliance Watch Configuration Data                               CSD015
     D SDCWCD        E DS                  EXTNAME(SDCWCDPD)                                  CSD015
                                                                                              CSD015
     D PDSXML          DS         30000                                                       CSD015
                                                                                              CSD015
      ** Fields defined for Enhancement CSD012 used for SDAULGL0                              CSD012
     D*@AULG****       DS            20                                                CSD012 CGL029
     D @AULG           DS            26                                                       CGL029
     D @DDBRCA                 1      3                                                       CSD012
     D @DDCNUM                 4      9                                                       CSD012
     D @DDCCY                 10     12                                                       CSD012
     D*@DDACOD**              13     16                                                CSD012 CGL029
     D*@DDACSQ**              17     18                                                CSD012 CGL029
     D @DDACOD                13     22                                                       CGL029
     D @DDACSQ                23     24                                                       CGL029
     D FUNCD           C                   CONST('ACCOUNT DETAILS')                           CSD012
                                                                                              CSD012
      ** Override SDCDSHL0, SDCBSHL0 & SDPBSHL0.                                              CSD012
     D CMD1            S              1    DIM(50) CTDATA PERRCD(50)                          CSD012
     D CMD2            S              1    DIM(50) CTDATA PERRCD(50)                          CSD012
     D CMD3            S              1    DIM(50) CTDATA PERRCD(50)                          CSD012
     D CMD4            S              1    DIM(50) CTDATA PERRCD(50)                          CSD012
     D***CMD5            S              1    DIM(50) CTDATA PERRCD(50)                 CSD012 CSD101
                                                                                              CSD012
      ** Dummy message ID and message file fields for use on the calls to
      ** ZAMSGTOOPR
     D DummyMsgID      S                   LIKE(#MsgID)
     D DummyMsgF       S             10A

      ** Defined variables for BUG6389                                                       BUG6389
     D USER            S                   LIKE(PSUser)                                      BUG6389
                                                                                             BUG6389
      * Like Field Definitions
     D Date            S                   LIKE(BXOLVD)
     D WWNATN          S                   LIKE(NATN)
     D WWTRNO          S                   LIKE(TRNO)
     D WWDBRT          S                   LIKE(BANBRT)
     D WWCBRT          S                   LIKE(BANBRT)
     D W#DBRT          S                   LIKE(BANBRT)                                       216905
     D W#CBRT          S                   LIKE(BANBRT)                                       216905
     D WWLCD           S                   LIKE(AMLCD)
     D WWCHTP          S                   LIKE(AMCHTP)
     D*FOTRID***       S                   LIKE(AMFRNT)                                       CGL029
     D FOTRID          S             40A                                                      CGL029

     D*  Data Structure for REINT Key
     D ReintKey        DS            12
     D Blank                   1      1
     D IntTyp                  2      3  0
     D IntSubTyp               4      8  0
     D Curr                    9     11
     D RecD                   12     12

     D***STHead*         DS                                                                   TDA033
     D STHead          DS           210                                                       TDA033
      *  Data Structure for STRAN Header
     D  TRNO                   2      6  0
     D  NORC                  12     14P 0
     D  SATN                 198    200P 0

     D ST1Rat          DS
      *  Data Structure for STRAN Rate 1
      *  Offset by 1 as excludes RECI i.e. CNUM is posn 2-7 on STRAN                          185230
     D**S1CNUM**               1      6  0                                                    CSD027
     D  S1CNUM                 1      6A                                                      CSD027
     D  S1CCY                  7      9
     D**S1ACOD**              10     13  0                                                    CGL029
     D  S1ACODQQ              10     13  0                                                    CGL029
     D  S1ACSQ                14     15  0
     D  S1ONE                 16     16
     D  S1X                   17     17
     D  S1ACNO                22     31  0
     D  S1RUND                32     34P 0
     D  S1WOLD                35     37P 0
     D  S1NARR                38     53
     D  S1INTT                73     74  0
     D  S1INTS                75     79  0
     D  S1DRCR                80     80
     D  S1TIME                81     86  0
     D  S1RECO                95     99
     D  S1SPTA               102    104
     D  S1ATYP               123    123
     D  S1RVLD               124    126P 0
     D  S1BITF               127    127
     D  S1OLDR               137    139P 0
     D  S1INRT               146    151P 7
     D***S1BRIS               152    153  0                                                   CSD103
     D  S1BRIS               152    153                                                       CSD103
     D  S1WRIS               154    159P 7
     D  S1AODR               160    165P 7
     D  S1WRUN               191    193P 0
     D  S1TRNO               194    196P 0
     D  S1NATN               197    199P 0
     D  S1ACOD               200    209  0                                                    CGL029

     D ST2RAT          DS
      *  Data Structure for STRAN Rate 2
     D**S2CNUM**               1      6  0                                                    CSD027
     D  S2CNUM                 1      6A                                                      CSD027
     D  S2CCY                  7      9
     D**S2ACOD**              10     13  0                                                    CGL029
     D  S2ACODQQ              10     13  0                                                    CGL029
     D  S2ACSQ                14     15  0
     D  S2TWO                 16     16
     D  S2X                   17     17
     D  S2INTH                18     25P 0
     D  S2WOLD                35     37P 0
     D  RAT1                  38     73
     D  RAT1A                 38     43P 7
     D  RAT1B                 44     49P 7
     D  RAT1C                 50     55P 7
     D  RAT1D                 56     61P 7
     D  RAT1E                 62     67P 7
     D  RAT1F                 68     73P 7
     D  S2DRCR                80     80
     D  S2TIME                81     86  0
     D  S2SPTA               102    104
     D  BAL1                 105    152
     D  BAL1A                105    112P 0
     D  BAL1B                113    120P 0
     D  BAL1C                121    128P 0
     D  BAL1D                129    136P 0
     D  BAL1E                137    144P 0
     D  BAL1F                145    152P 0
     D  S2TRNO               194    196P 0
     D  S2NATN               197    199P 0
     D  S2ACOD               200    209  0                                                    CGL029

     D ST3RAT          DS
      *  Data Structure for STRAN Rate 3
     D**S3CNUM**               1      6  0                                                    CSD027
     D  S3CNUM                 1      6A                                                      CSD027
     D  S3CCY                  7      9
     D**S3ACOD**              10     13  0                                                    CGL029
     D  S3ACODQQ              10     13  0                                                    CGL029
     D  S3ACSQ                14     15  0
     D  S3THRE                16     16
     D  S3WOLD                35     37P 0
     D  RAT3                  38     67
     D  RAT3A                 38     43P 7
     D  RAT3B                 44     49P 7
     D  RAT3C                 50     55P 7
     D  RAT3D                 56     61P 7
     D  RAT3E                 62     67P 7
     D  S3DRCR                80     80
     D  S3TIME                81     86  0
     D  S3SPTA               102    104
     D  BAL3                 105    144
     D  BAL3A                105    112P 0
     D  BAL3B                113    120P 0
     D  BAL3C                121    128P 0
     D  BAL3D                129    136P 0
     D  BAL3E                137    144P 0
     D  S3TRNO               194    196P 0
     D  S3NATN               197    199P 0
     D  S3ACOD               200    209  0                                                    CGL029
                                                                                              CRE005
     D IC2RAT          DS                                                                     CRE005
      *  Data Structure for RERCH2                                                            CRE005
     D  I2RAT1                 1     36                                                       CRE005
     D  IRAT1A                 1      6P 7                                                    CRE005
     D  IRAT1B                 7     12P 7                                                    CRE005
     D  IRAT1C                13     18P 7                                                    CRE005
     D  IRAT1D                19     24P 7                                                    CRE005
     D  IRAT1E                25     30P 7                                                    CRE005
     D  IRAT1F                31     36P 7                                                    CRE005
                                                                                              CRE005
     D IC2BAL          DS                                                                     CRE005
      *  Data Structure for RERCH2                                                            CRE005
     D  I2BAL1                 1     48                                                       CRE005
     D  IBAL1A                 1      8P 0                                                    CRE005
     D  IBAL1B                 9     16P 0                                                    CRE005
     D  IBAL1C                17     24P 0                                                    CRE005
     D  IBAL1D                25     32P 0                                                    CRE005
     D  IBAL1E                33     40P 0                                                    CRE005
     D  IBAL1F                41     48P 0                                                    CRE005
                                                                                              CRE005
     D IC3RAT          DS                                                                     CRE005
      *  Data Structure for RERCH3                                                            CRE005
     D**I3RAT3**               1     36                                              CRE005 MD034366
     D  I3RAT3                 1     30                                                     MD034366
     D  IRAT3A                 1      6P 7                                                    CRE005
     D  IRAT3B                 7     12P 7                                                    CRE005
     D  IRAT3C                13     18P 7                                                    CRE005
     D  IRAT3D                19     24P 7                                                    CRE005
     D  IRAT3E                25     30P 7                                                    CRE005
     D**IRAT3F**              31     36P 7                                           CRE005 MD034366
                                                                                              CRE005
     D IC3BAL          DS                                                                     CRE005
      *  Data Structure for RERCH3                                                            CRE005
     D**I3BAL3**               1     48                                              CRE005 MD034366
     D  I3BAL3                 1     40                                                     MD034366
     D  IBAL3A                 1      8P 0                                                    CRE005
     D  IBAL3B                 9     16P 0                                                    CRE005
     D  IBAL3C                17     24P 0                                                    CRE005
     D  IBAL3D                25     32P 0                                                    CRE005
     D  IBAL3E                33     40P 0                                                    CRE005
     D**IBAL3F**              41     48P 0                                           CRE005 MD034366
                                                                                              CRE005

     D** DATA STRUCTURE FOR ACCOUNT KEY NUMBER
     D*  ALTERNATE ACCOUNT KEY
     D***RetKeyDS        DS            18                                                     CGL029
     D RetKeyDS        DS            24                                                       CGL029
     D*CustNum1*               1      6  0                                                    CSD027
     D CustNum1                1      6A                                                      CSD027
     D Currency1               7      9
     D***AccCode1               10     13  0                                                  CGL029
     D***AccSeq1                14     15  0                                                  CGL029
     D***Branch1                16     18                                                     CGL029
     D AccCode1               10     19  0                                                    CGL029
     D AccSeq1                20     21  0                                                    CGL029
     D Branch1                22     24                                                       CGL029
     D RetKK1                  1     10  0                                                    237346
     D AccKyk1                11     21                                                       237346

     D***DBerrKey        DS            18                                                     CGL029
     D DBerrKey        DS            24                                                       CGL029
     D*Custnum**               1      6  0                                                    CSD027
     D Custnum                 1      6A                                                      CSD027
     D Currency                7      9
     D***AccCode                10     13  0                                                  CGL029
     D***AccSeq*                14     15  0                                                  CGL029
     D***Branch*                16     18                                                     CGL029
     D AccCode                10     19  0                                                    CGL029
     D AccSeq                 20     21  0                                                    CGL029
     D Branch                 22     24                                                       CGL029
     D** Data Structure For Account Key Database Error

     D CHKACC2         DS            24                                                       CSD101
     D KCNUM2                  1      6                                                       CSD101
     D KCCY2                   7      9                                                       CSD101
     D KACOD2                 10     19                                                       CSD101
     D KACSQ2                 20     21                                                       CSD101
     D KBRCA2                 22     24                                                       CSD101
                                                                                              CSD101
      ** Array for enhancement CSD015                                                         CSD015
     D ARRTAG          S             15    DIM(2) CTDATA                                      CSD015
     D ArrEvnt         S              1    DIM(26) CTDATA PERRCD(26)                          CRE015
     D CustNumb        S              6
     D Curren          S              3
     D***AcCode*         S              4                                                     CGL029
     D AcCode          S             10                                                       CGL029
     D AcSeq           S              2
     D Brch            S              3
     D ReNum           S             10
     D Action          S              1
     D CNUMOK          S              1
     D CCYOK           S              1
     D ACODOK          S              1
     D ACSQOK          S              1
     D BRCAOK          S              1
     D ACNOOK          S              1
     D ActionOK        S              1
     D K#ACOD          S                   LIKE(A5ACCD)                                       CRE015
     D*  Standalone Data Fields
     D Idx             S              3P 0
     D X               S              3  0                                                    CRE015
      ** Index for arrays of of error message ids etc
                                                                                              CSC011
     D/COPY WNCPYSRC,GLAMADDD02
     D CSC011          S              1A                                                      CSC011
     D CAP086          S              1A                                                      CAP086
     D TRANSDTL        S           5800A                                                      CSC011
     D WTimestamp      S             26A                                                      CSC011
     D PRtCd           S              7A                                                      CSC011
     D POptn           S              7A                                                      CSC011
     D PSard           S              6A                                                      CSC011
     D***PAcctNum        S             18A                                             CSC011 CGL029
     D***PADealNo        S             18A                                             CSC011 CGL029
     D PAcctNum        S             24A                                                      CGL029
     D PADealNo        S             24A                                                      CGL029
     D WCust           S              6A                                                      CSC011
     D***WAcod**         S              4A                                             CSC011 CGL029
     D WAcod           S             10A                                                      CGL029
     D WAcsq           S              2A                                                      CSC011
                                                                                              CSC011
     D CLE025          S              1                                                       CLE025
     D CGL165          S              1                                                       CGL165
                                                                                              CLE025
      ** Fields defined for Enhancement CSD015                                                CSD015
     D W_Anam          S             20A                                                      CSD015
     D PFncCd          S              8A                                                      CSD015
     D WDDT            S               D                                                      CSD015
     D CCF001          S              1A                                                      CSD015
     D CSD015          S              1A                                                      CSD015
                                                                                              CSD015
      ** Key fields for hitlist file                                                          CSD015
     D WFuncType       S              8A                                                      CSD015
     D WIdntifier      S             40A                                                      CSD015
     D WBranch         S              3A                                                      CSD015
                                                                                              CSD015
      ** Parameter for AOCUSTR0                                                               CSD015
     D PCUST           S             10A                                                      CSD015
     D PSTKEY          S              7A                                                      CSD015
                                                                                              CSD015
      ** ZACVTDATE Parameters                                                                 CSD015
     D PZARtCd         S              7                                                       CSD015
     D PZADayNo        S              5                                                       CSD015
     D PZADDT          S               D                                                      CSD015
     D PZACvtDt        S             10                                                       CSD015
                                                                                              CSD015
      ** ZACVTAMT  Parameters                                                                 CSD015
     D PCcy            S              3                                                       CSD015
     D PAmnt           S             15                                                       CSD015
     D PConvertdAmt    S             18P 3                                                    CSD015
     D PDummy16        S             16                                                       CSD015
      *                                                                                       CRE023
     D CRE023          S              1                                                       CRE023
     D CRE015          S              1                                                       CRE015
      ** 2 o'clock flag                                                                       CRE023
      *                                                                                       CRE023
     D CER047          S              1A                                                      CER047
     D CRE075          S              1A                                                      CRE075
     D CER055          S              1A                                                      CER055
     D CRE073          S              1A                                                      CRE073
     D/COPY WNCPYSRC,GLH00574
     D CRE072          S              1A                                                      CRE072
     D CTI006          S              1A                                                    MD034725
     D CER050          S              1A                                                      CER050
                                                                                              CSD101
     D PReturnCode     S              7A                                                      CSD101
     D PAction         S              1A                                                      CSD101
     D PValidList      S             10A   INZ('SDINTFVL')                                    CSD101
     D PLibrary        S             10A                                                      CSD101
     D PIDName         S            100A                                                      CSD101
     D PPass1          S            128A                                                      CSD101
     D PDescr          S           1000A                                                      CSD101
     I**
     I** RENAME REACR FIELDS
     I**
     IREACRAF
     I              RECI                        RAARECI
     I              CUST                        RAAPNP8
     I              ACCY                        RAAACCY
     I              ACOD                        RAAACOD
     I              ASEQ                        RAAASEQ
     I              BRCA                        RAABRCA
     I              ZZ109                       RAAZ109
      /EJECT
     C*****************************************************************
     C*                                                               *
     C* MAIN - MAIN BODY                                              *
     C*                                                               *
     C*****************************************************************
      ** Call the Initialisation Subroutine.
     C                   EXSR      INITIAL

      ** Ensure transaction has not been updated by another workstation
      ** - if so, bypass updating and return to calling program.
     C                   EXSR      CHKOTHUPD
      *                                                                                      BUG6389
      ** Check whether user is a web browser user, if so overwrite                           BUG6389
      *                                                                                      BUG6389
     C                   CALL      'SFC000026'                                               BUG6389
     C                   PARM      *BLANKS       USER                                        BUG6389
      *                                                                                      BUG6389
     C                   IF        USER <> *BLANKS                                           BUG6389
     C                   MOVEL     USER          PSUSER                                      BUG6389
     C                   ENDIF                                                               BUG6389

     C     @@RTCD        IFNE      *BLANKS
     C                   GOTO      EXIT
     C                   END
      *Start---------------------1-------------------------------------                       CSD012
      * Auth Req is ON and Auth Mode is not 'X' .                                             CSD012
     C     AUTHRQ        IFEQ      'Y'                                                        CSD012
     C     AUTHMD        ANDNE     'X'                                                        CSD012
      *                                                                                       CSD012
     C                   MOVEL     'N'           YESUPDAT          1                          CSD012
     C                   MOVEL     AMCHTP        WorkCHTP          1                          CSD012
     C                   Z-ADD     AMLCD         WorkLCD           5 0                        CSD012
     C                   MOVEL     *BLANK        AMCHTP                                       CSD012
     C                   Z-ADD     *ZERO         AMLCD                                        CSD012
      *                                                                                       CSD012
     C     Rehiskey      CHAIN     ACCBR                              80                      CSD012
      *                                                                                       CSD012
     C     *IN80         IFEQ      *OFF                                                       CSD012
      *                                                                                       CSD012
     C     AC_CHTP       IFEQ      'I'                                                        CSD012
     C**********         Z-ADD     *ZERO         AC_DRCD                               CSD012 225539
     C**********         Z-ADD     *ZERO         AC_CRCD                               CSD012 225539
     C                   Z-ADD     AMDRCD        WorkDRCD          5 0                        CSD012
     C                   Z-ADD     AMCRCD        WorkCRCD          5 0                        CSD012
     C                   Z-ADD     *ZERO         AMDRCD                                       CSD012
     C                   Z-ADD     *ZERO         AMCRCD                                       CSD012
     C                   ENDIF                                                                CSD012
      *                                                                                       CSD012
     C**********         MOVEL     *BLANK        AC_CHTP                               CSD012 225539
     C**********         Z-ADD     *ZERO         AC_LCD                                CSD012 225539
     C     ACCNTBR       IFEQ      GLVAMAD                                                    CSD012
     C     WorkCHTP      ANDEQ     'A'                                                        CSD012
     C                   MOVEL     'N'           YESUPDAT                                     CSD012
     C                   ELSE                                                                 CSD012
     C                   MOVEL     'Y'           YESUPDAT                                     CSD012
     C                   ENDIF                                                                CSD012
     C                   ELSE                                                                 CSD012
     C                   MOVEL     'Y'           YESUPDAT                                     CSD012
     C                   ENDIF                                                                CSD012
      *                                                                                       CSD012
     C     AC_CHTP       IFEQ      'I'                                                        CSD012
     C                   Z-ADD     WorkDRCD      AMDRCD                                       CSD012
     C                   Z-ADD     WorkCRCD      AMCRCD                                       CSD012
     C                   ENDIF                                                                CSD012
     C                   MOVEL     WorkCHTP      AMCHTP                                       CSD012
     C                   Z-ADD     WorkLCD       AMLCD                                        CSD012
      *                                                                                       CSD012
     C     BGWDPR        IFEQ      'Y'                                                        CSD012
     C     BGSWRT        ANDEQ     'Y'                                                        CSD012
     C     AMATYP        ANDEQ     'R'                                                        CSD012
      *                                                                                       CSD012
     C     BGWDPR        OREQ      'Y'                                                        CSD012
     C     BGNTST        ANDEQ     'Y'                                                        CSD012
     C     AMATYP        ANDEQ     'R'                                                        CSD012
     C     BGWDPR        OREQ      'Y'                                                        CSD012
     C     FACH          ANDEQ     'Y'                                                        CSD012
     C     AMATYP        ANDEQ     'R'                                                        CSD012
     C     BGWDPR        OREQ      'Y'                                                        CSD012
     C     TSTMC         ANDEQ     'Y'                                                        CSD012
     C     AMATYP        ANDEQ     'R'                                                        CSD012
      *                                                                                       CSD012
     C     Accntkey      CHAIN     ACCNTBXC                           80                      CSD012
      *                                                                                       CSD012
     C     *IN80         IFEQ      *OFF                                                       CSD012
     C     ACCNTX        ANDEQ     GLVAMBX                                                    CSD012
     C     AMCHTP        ANDEQ     'A'                                                        CSD012
     C                   ELSE                                                                 CSD012
     C                   MOVEL     'Y'           YESUPDAT                                     CSD012
     C                   ENDIF                                                                CSD012
     C                   ENDIF                                                                CSD012
      *                                                                                       CSD012
     C     BGNXST        IFEQ      'Y'                                                        CSD012
     C     BGNYST        OREQ      'Y'                                                        CSD012
     C                   IF        AMATYP = 'R'                                               CSD012
      *                                                                                       CSD012
     C     Accntkey      CHAIN     REIAC                              80                      CSD012
     C     *IN80         IFEQ      *OFF                                                       CSD012
     C     REIAD         ANDEQ     GLVAMRIsh                                                  CSD012
                                                                                              CGL029
      ** Compare extended account codes as well                                               CGL029
     C     REIADEX       ANDEQ     GLVAMRIEX                                                  CGL029
     C     AMCHTP        ANDEQ     'A'                                                        CSD012
     C                   ELSE                                                                 CSD012
     C                   MOVEL     'Y'           YESUPDAT                                     CSD012
     C                   ENDIF                                                                CSD012
      *                                                                                       CSD012
     C     Rehiskey      CHAIN     RECOM                              80                      CSD012
     C     *IN80         IFEQ      *OFF                                                       CSD012
     C     RECOMDATA     ANDEQ     GLVAMCOsh                                                  CSD012
                                                                                              CGL029
      ** Compare extended account code as well                                                CGL029
     C     RC_ACOD       ANDEQ     COACOD                                                     CGL029
     C     AMCHTP        ANDEQ     'A'                                                        CSD012
     C                   ELSE                                                                 CSD012
     C                   MOVEL     'Y'           YESUPDAT                                     CSD012
     C                   ENDIF                                                                CSD012
      *                                                                                       CSD012
     C                   ENDIF                                                                CSD012
     C                   ENDIF                                                                CSD012
      *                                                                                       CSD012
      ** If CRT101 (Password on Retail Accounts) is installed and                             CSD012
      ** CRT001 (Retail Teller System) is on                                                  CSD012
      *                                                                                       CSD012
     C                   IF        CRT101='Y' and CRT001='Y' and                              CSD012
     C                             AMATYP='R' and AMSTYP='S'                                  CSD012
      *                                                                                       CSD012
     C*****Accntkey      CHAIN     REAPWDL0                           80               CSD012 CSD101
     C******IN80         IFEQ      *OFF                                                CSD012 CSD101
     C*****REAPWDATA     ANDEQ     GLVAMPWsh                                           CSD012 CSD101
                                                                                              CGL029
      ** Compare extended account code as well                                                CGL029
     C*****RW_ACOD       ANDEQ     PWACOD                                              CGL029 CSD101
     C*****AMCHTP        ANDEQ     'A'                                                 CSD012 CSD101
     C     AMCHTP        IFEQ      'A'                                                        CSD101
     C                   ELSE                                                                 CSD012
     C                   MOVEL     'Y'           YESUPDAT                                     CSD012
     C                   ENDIF                                                                CSD012
      *                                                                                       CSD012
     C                   ENDIF                                                                CSD012
     C                   IF        CRE015 = 'Y'                                               CRE015
     C                             AND A5ATTY = 'P'                                           CRE015
     C                             AND YESUPDAT <> 'Y'                                        CRE015
                                                                                              CRE015
     C                   EVAL      X = 0                                                      CRE015
     C     RehisKey      SETLL     REPRPNL4                                                   CRE015
     C     RehisKey      READE(N)  REPRPNL4                                                   CRE015
     C                   DOW       NOT %EOF(REPRPNL4)                                         CRE015
                                                                                              CRE015
     C                   EVAL      X = X + 1                                                  CRE015
     C                   EVAL      ArrFilBuf(X) = REPRPN                                      CRE015
                                                                                              CRE015
     C     RehisKey      READE(N)  REPRPNL4                                                   CRE015
     C                   ENDDO                                                                CRE015
                                                                                              CRE015
     C                   MOVEA     ArrFilBuf     REPENA                                       CRE015
     C                   IF        X > 0                                                      CRE015
     C                             AND AMCHTP = 'A'                                           CRE015
     C                             AND GLVAMPPsh = REPENA                                     CRE015
     C                   ELSE                                                                 CRE015
     C                   EVAL      YESUPDAT = 'Y'                                             CRE015
     C                   ENDIF                                                                CRE015
     C                   ENDIF                                                                CRE015
      *Start---------------------2-------------------------------------                       CSD012
     C     YESUPDAT      IFEQ      'Y'                                                        CSD012
      *Start---------------------3-------------------------------------                       CSD012
      *                                                                                       CSD012
     C     Rehiskey      CHAIN     GLACSHL0                           90                      CSD012
      * If record does not exist write details to customer shadow file                        CSD012
     C     *IN90         IFEQ      *ON                                                        CSD012
      *                                                                                       CSD012
     C                   MOVEL     GLVAMAD       GLVACSH                                      CSD012
      *                                                                                       CSD012
     C     AMCHTP        IFEQ      'I'                                                        CSD012
      *                                                                                       CSD012
     C                   CLEAR                   GLACSHD0                                     CRE101
     C                   EVAL      TAC_RECI='D'                                               CSD012
     C                   EVAL      TAC_ORED=BJRDNB                                            CSD012
     C                   EVAL      TAC_LCD=BJRDNB                                             CSD012
     C                   EVAL      TAC_CHTP='I'                                               CSD012
      *                                                                                       CSD012
      ** If CSC011 is installed, supply a Front Office ID for the                             CSD012
      ** transaction even if it originated from SIN module.                                   CSD012
      *                                                                                       CSD012
     C                   IF        CSC011 = 'Y'                                               CSD012
     C                   IF        TAC_FRNT = *BLANKS                                         CSD012
     C                   MOVE      TAC_CNUM      WCust                                        CSD012
     C                   MOVE      TAC_ACOD      WAcod                                        CSD012
     C                   MOVE      TAC_ACSQ      WAcsq                                        CSD012
                                                                                              CGL029
      ** Set front office id to 'MD' + branch + customer + currency + 1st 6                   CGL029
      ** characters of the account code                                                       CGL029
                                                                                              CGL029
     C**********         EVAL      TAC_FRNT = 'MD' + TAC_BRCA + WCust +                CSD012 CGL029
     C**********                           TAC_CCY +  WAcod + WAcsq                    CSD012 CGL029
     C                   EVAL      TAC_FRNT = 'MD' + TAC_BRCA + WCust +                       CGL029
     C                                     TAC_CCY +  %SUBST(WAcod:1:6)                       CGL029
                                                                                              CGL029
      ** Set associated front office id to the last 4 characters of the account               CGL029
      ** code and account sequence                                                            CGL029
                                                                                              CGL029
     C                   EVAL      TAC_AFRT = %SUBST(WAcod:7:4) + WAcsq                       CGL029
     C                   ENDIF                                                                CSD012
     C                   ENDIF                                                                CSD012
      *                                                                                       CSD012
     C                   ENDIF                                                                CSD012
      *                                                                                       CSD012
     C                   IF        AMCHTP = 'A'                                               CSD012
      *                                                                                       CSD012
     C************       EVAL      TAC_DRCD=AC_DRCD                                    CSD012 225539
     C************       EVAL      TAC_CRCD=AC_CRCD                                    CSD012 225539
      *                                                                                       CTI005
     C     TAC_NACSG     IFEQ      'T'                                                        CTI005
     C     TAC_LCD       ANDNE     BJRDNB                                                     CTI005
     C                   EVAL      TAC_NACSG = ' '                                            CTI005
     C                   ENDIF                                                                CTI005
      *                                                                                       CTI005
     C                   IF        AMDRCD<>0                                                  225539
     C                   EVAL      TAC_DRCD=AMDRCD                                            225539
     C                   ELSE                                                                 225539
     C                   EVAL      TAC_DRCD=AC_DRCD                                           225539
     C                   ENDIF                                                                225539
     C                   IF        AMCRCD<>0                                                  225539
     C                   EVAL      TAC_CRCD=AMCRCD                                            225539
     C                   ELSE                                                                 225539
     C                   EVAL      TAC_CRCD=AC_CRCD                                           225539
     C                   ENDIF                                                                225539
     C                   Z-ADD     TAC_LCD       WWLCD                                        CSD012
     C                   Z-ADD     BJRDNB        TAC_LCD                                      CSD012
      ** If Amend over Insert the same day then keep as Insert today                          CSD012
     C                   IF        WWLCD=BJRDNB and TAC_CHTP='I'                              CSD012
     C                             and AMCHTP='A'                                             CSD012
     C                   EVAL      TAC_CHTP='I'                                               CSD012
     C                   ELSE                                                                 CSD012
     C                   EVAL      TAC_CHTP='A'                                               CSD012
     C                   ENDIF                                                                CSD012
      ** Reset Replication flag                                                               CSD012
     C                   EVAL      TAC_REPI = ' '                                             CSD012
      *                                                                                       CSD012
     C                   ENDIF                                                                CSD012
      *                                                                                       CSD012
     C                   IF        AMCHTP = 'D'                                               CSD012
      ** Save LCD and CHTP                                                                    CSD012
     C                   EVAL      WWLCD=TAC_LCD                                              CSD012
     C                   EVAL      WWCHTP=TAC_CHTP                                            CSD012
     C                   EVAL      TAC_ACST='C'                                               CSD012
     C                   EVAL      TAC_LCD=BJRDNB                                             CSD012
     C                   EVAL      TAC_DACC=BJRDNB                                            CSD012
     C                   EVAL      TAC_CHTP='C'                                               CSD012
      ** Reset Replication flag                                                               CSD012
     C                   EVAL      TAC_REPI = ' '                                             CSD012
      *                                                                                       CSD012
     C                   ENDIF                                                                CSD012
      *                                                                                       CSD012
      ** If a Front Office transaction set timestamp to that of                               CSD012
      ** original record's to prevent timestamp problems when authorising.                    CSD012
     C     @Type         IFEQ      '0'                                                        CSD012
     C     AMCHTP        ANDNE     'I'                                                        CSD012
     C                   MOVEL     CHTMST        TAC_TMST                                     CSD012
     C                   ENDIF                                                                CSD012
     C                   WRITE     GLACSHD0                                                   CSD012
      *                                                                                       CSD012
     C                   ENDIF                                                                CSD012
      *End-----------------------3-------------------------------------                       CSD012
      *Start---------------------4-------------------------------------                       CSD012
      ** Check if Account Retail                                                              CSD012
      *                                                                                       CSD012
     C     BGWDPR        IFEQ      'Y'                                                        CSD012
     C     BGSWRT        ANDEQ     'Y'                                                        CSD012
     C     AMATYP        ANDEQ     'R'                                                        CSD012
      *                                                                                       CSD012
     C     BGWDPR        OREQ      'Y'                                                        CSD012
     C     BGNTST        ANDEQ     'Y'                                                        CSD012
     C     AMATYP        ANDEQ     'R'                                                        CSD012
     C     BGWDPR        OREQ      'Y'                                                        CSD012
     C     FACH          ANDEQ     'Y'                                                        CSD012
     C     AMATYP        ANDEQ     'R'                                                        CSD012
     C     BGWDPR        OREQ      'Y'                                                        CSD012
     C     TSTMC         ANDEQ     'Y'                                                        CSD012
     C     AMATYP        ANDEQ     'R'                                                        CSD012
      *                                                                                       CSD012
     C     Accntkey      CHAIN     GLBXSHL0                           91                      CSD012
      * If record does not exist write details to customer shadow file                        CSD012
     C     *IN91         IFEQ      *ON                                                        CSD012
      *                                                                                       CSD012
     C                   MOVEL     GLVAMBX       GLVBXSH                                      CSD012
      *                                                                                       CSD012
     C                   IF        AMCHTP = 'I'                                               CSD012
     C                   EVAL      TAX_ATAODR=*ZEROS                                          CSD012
     C                   EVAL      TAX_ATORTC=*ZEROS                                          CSD012
     C                   EVAL      TAX_ATOLVD=*ZEROS                                          CSD012
     C                   EVAL      TAX_ATITRD=*ZEROS                                          CSD012
     C                   EVAL      TAX_ATPOLE=*ZEROS                                          CSD012
     C                   EVAL      TAX_ATPOLC=*ZEROS                                          CSD012
      ** Initialise margin interest fields                                                    CSD012
     C                   EVAL      TAX_ATOVRD = *BLANKS                                       CSD012
     C                   EVAL      TAX_ATOVRC = *BLANKS                                       CSD012
     C                   EVAL      TAX_ATDRMG = 0                                             CSD012
     C                   EVAL      TAX_ATCRMG = 0                                             CSD012
     C                   EVAL      TAX_ATDRMD = 0                                             CSD012
     C                   EVAL      TAX_ATCRMD = 0                                             CSD012
                                                                                              CSD012
      ** If CSC011 is installed, supply a Front Office ID for the                             CSD012
      ** transaction even if it originated from SIN module.                                   CSD012
                                                                                              CSD012
     C                   IF        CSC011 = 'Y'                                               CSD012
     C                   IF        TAX_ATFRNT = *BLANKS                                       CSD012
     C                   MOVE      TAX_ATCNUM    WCust                                        CSD012
     C                   MOVE      TAX_ATACOD    WAcod                                        CSD012
     C                   MOVE      TAX_ATACSQ    WAcsq                                        CSD012
                                                                                              CGL029
      ** Set front office id to 'MD' + branch + customer + currency + 1st 6                   CGL029
      ** characters of the account code                                                       CGL029
     C**********         EVAL      TAX_ATFRNT = 'MD' + TAX_ATBRCA +                    CSD012 CGL029
     C**********                   WCust + TAX_ATCCY + WAcod + WAcsq                   CSD012 CGL029
     C                   EVAL      TAX_ATFRNT = 'MD' + TAX_ATBRCA +                           CGL029
     C                             WCust + TAX_ATCCY + %SUBST(WAcod:1:6)                      CGL029
                                                                                              CGL029
      ** Set associated front office id to the last 4 characters of the account               CGL029
      ** code                                                                                 CGL029
     C                   EVAL      TAX_ATAFRT = %SUBST(WAcod:7:4) + WAcsq                     CGL029
     C                   ENDIF                                                                CSD012
     C                   ENDIF                                                                CSD012
      ** If CRE001 (Overdraft Interest Calculations) is installed and                         CSD012
      ** Account is Retail                                                                    CSD012
      ** OR CDE002 is installed and Account is Retail                                         CSD012
      *                                                                                       CSD012
     C                   IF        CRE001='Y' and AMATYP='R'                                  CSD012
     C                             or (CDE002='Y' and AMATYP='R')                             CSD012
     C                   EVAL      TAX_ATPOLE=*ZEROS                                          CSD012
      * If Overdraft Line Change Value Date is <= Value Date                                  CSD012
     C                   IF        BXOLVD<=BJRDNB                                             CSD012
     C                   Z-ADD     BXOLVD        TAX_ATPOLC                                   CSD012
     C                   ENDIF                                                                CSD012
      ** If Debit Margin Override is 'Y' Change Date is run date                              CSD012
      *                                                                                       CSD012
     C                   IF        BXOVRD = 'Y'                                               CSD012
     C                   EVAL      TAX_ATDRMD = BJRDNB                                        CSD012
     C                   ELSE                                                                 CSD012
     C                   EVAL      TAX_ATDRMD = 0                                             CSD012
     C                   ENDIF                                                                CSD012
      ** If Credit Margin Override is 'Y' Change Date is run date                             CSD012
      *                                                                                       CSD012
     C                   IF        BXOVRC = 'Y'                                               CSD012
     C                   EVAL      TAX_ATCRMD = BJRDNB                                        CSD012
     C                   ELSE                                                                 CSD012
     C                   EVAL      TAX_ATCRMD = 0                                             CSD012
     C                   ENDIF                                                                CSD012
     C                   ENDIF                                                                CSD012
      *                                                                                       CSD012
     C                   ENDIF                                                                CSD012
      *                                                                                       CSD012
     C                   IF        AMCHTP = 'A'                                               CSD012
      ** If CRE001 (Overdraft Interest Calculations) is installed and                         CSD012
      ** Account is Retail                                                                    CSD012
      ** or CDE002 is installed and Account is Retail                                         CSD012
      *                                                                                       CSD012
     C                   IF        CRE001='Y' or CDE002 = 'Y'                                 CSD012
     C                   EVAL      TAX_ATPOLE=*ZEROS                                          CSD012
      * If Overdraft Line Change Value Date is <= Value Date  or =Rundate                     CSD012
     C                   IF        BXOLVD<=BJRDNB and BXOLVD<>*ZERO                           CSD012
     C                   Z-ADD     BXOLVD        TAX_ATPOLC                                   CSD012
     C                   ENDIF                                                                CSD012
      * If Overdraft Expiry Date has changed                                                  CSD012
     C                   IF        AMODED<>BA_ODED                                            CSD012
     C                   Z-ADD     AMODED        TAX_ATPOLE                                   CSD012
     C                   ENDIF                                                                CSD012
      ** If CDE002 is present update Dr/Cr Margin fields                                      CSD012
     C                   IF        CDE002 = 'Y'                                               CSD012
                                                                                              CSD012
      ** If Debit Margin Override or Debit Margin have changed                                CSD012
                                                                                              CSD012
     C                   IF        BXOVRD <> TAX_ATOVRD or                                    CSD012
     C                             BXDRMG <> TAX_ATDRMG                                       CSD012
     C                   EVAL      TAX_ATDRMD = BJRDNB                                        CSD012
     C                   ENDIF                                                                CSD012
                                                                                              CSD012
      ** If Credit Margin Override or Credit Margin have changed                              CSD012
                                                                                              CSD012
     C                   IF        BXOVRC <> TAX_ATOVRC or                                    CSD012
     C                             BXCRMG <> TAX_ATCRMG                                       CSD012
     C                   EVAL      TAX_ATCRMD = BJRDNB                                        CSD012
     C                   ENDIF                                                                CSD012
                                                                                              CSD012
     C                   ENDIF                                                                CSD012
                                                                                              CSD012
     C                   ENDIF                                                                CSD012
     C                   ENDIF                                                                CSD012
      *                                                                                       CSD012
      *                                                                                       CSD012
     C                   WRITE     GLBXSHD0                                                   CSD012
     C                   ENDIF                                                                CSD012
      *                                                                                       CSD012
     C                   ENDIF                                                                CSD012
      *End-----------------------4-------------------------------------                       CSD012
      *Start---------------------5-------------------------------------                       CSD012
     C     BGNXST        IFEQ      'Y'                                                        CSD012
     C     BGNYST        OREQ      'Y'                                                        CSD012
      *                                                                                       CSD012
     C                   IF        AMATYP = 'R'                                               CSD012
      *                                                                                       CSD012
     C     Rehiskey      CHAIN     REIASHL0                           92                      CSD012
      * If record does not exist write details to customer shadow file                        CSD012
     C     *IN92         IFEQ      *ON                                                        CSD012
     C                   CLEAR                   REIASHD0                                     CRE101
      *                                                                                       CSD012
     C**********         MOVEL     GLVAMRI       REVIASH                               CSD012 TDA084
     C                   MOVEL     GLVAMRImn     REVIASH                                      TDA084
     C                   EVAL      TRE_ACOD=RIACOD                                            TDA084
     C                   EVAL      TRE_DACP=RIDACP                                            TDA084
     C                   EVAL      TRE_CACP=RICACP                                            TDA084
     C                   EVAL      TRE_CHAC=RICHAC                                            TDA084
      *                                                                                       CSD012
     C                   EVAL      TRE_BRCA=AMBRCA                                            CSD012
     C                   EVAL      TRE_CNUM=AMCNUM                                            CSD012
     C                   EVAL      TRE_ACOD=AMACOD                                            CSD012
     C                   EVAL      TRE_ACSQ=AMACSQ                                            CSD012
     C                   EVAL      TRE_CCY =AMCCY                                             CSD012
      *                                                                                       CSD012
     C                   IF        AMCHTP = 'I'                                               CSD012
     C                   EVAL      TRE_RECI='D'                                               CSD012
     C                   EVAL      TRE_DICP=*BLANKS                                           CSD012
     C                   EVAL      TRE_CICP=*BLANKS                                           CSD012
     C                   EVAL      TRE_NRCA=*ZERO                                             CSD012
     C                   EVAL      TRE_RCA=*ZERO                                              CSD012
     C                   EVAL      TRE_MCLB=*ZERO                                             CSD012
     C                   EVAL      TRE_ZZ015=*BLANKS                                          CSD012
     C                   EVAL      TRE_NOALT=*ZERO                                            CSD012
     C                   ENDIF                                                                CSD012
      *                                                                                       CSD012
     C                   IF        AMCHTP = 'A'                                               CSD012
     C                   EVAL      TRE_CICP=*BLANKS                                           CSD012
     C                   ENDIF                                                                CSD012
      *                                                                                       CSD012
     C                   WRITE     REIASHD0                                                   CSD012
      *                                                                                       CSD012
     C                   ENDIF                                                                CSD012
      *                                                                                       CSD012
     C                   ENDIF                                                                CSD012
      *                                                                                       CSD012
     C                   ENDIF                                                                CSD012
      *End-----------------------5-------------------------------------                       CSD012
      *Start---------------------6-------------------------------------                       CSD012
      *                                                                                       CSD012
     C     BGNXST        IFEQ      'Y'                                                        CSD012
     C     BGNYST        OREQ      'Y'                                                        CSD012
      *                                                                                       CSD012
     C                   IF        AMATYP = 'R'                                               CSD012
      *                                                                                       CSD012
     C     Rehiskey      CHAIN     RECMSHL0                           93                      CSD012
      * If record does not exist write details to customer shadow file                        CSD012
     C     *IN93         IFEQ      *ON                                                        CSD012
      *                                                                                       CSD012
     C                   CLEAR                   RECMSHD0                                     CRE101
     C                   MOVEL     GLVAMCO       REVCMSH                                      CSD012
      *                                                                                       CSD012
     C                   EVAL      TRC_BRCA=AMBRCA                                            CSD012
     C                   EVAL      TRC_CNUM=AMCNUM                                            CSD012
     C                   EVAL      TRC_ACOD=AMACOD                                            CSD012
     C                   EVAL      TRC_ACSQ=AMACSQ                                            CSD012
     C                   EVAL      TRC_CCY =AMCCY                                             CSD012
      *                                                                                       CSD012
     C                   IF        AMCHTP = 'I'                                               CSD012
     C                   EVAL      TRC_RECI='D'                                               CSD012
     C                   EVAL      TRC_FXDC=*ZERO                                             CSD012
     C                   EVAL      TRC_ACCEA=*ZERO                                            CSD012
     C                   EVAL      TRC_ACCC=*ZERO                                             CSD012
     C                   EVAL      TRC_GVDPE=*ZERO                                            CSD012
     C                   EVAL      TRC_GVDPC=*ZERO                                            CSD012
     C                   EVAL      TRC_ACCRA=*ZERO                                            CSD012
     C                   EVAL      TRC_MMACC=*BLANKS                                          CSD012
     C                   EVAL      TRC_CACCC=*ZEROS                                           CSD012
     C                   EVAL      TRC_CDIE=*ZEROS                                            CSD012
     C                   EVAL      TRC_CDICA=*ZEROS                                           CSD012
     C                   EVAL      TRC_CDRR=*ZEROS                                            CSD012
     C                   EVAL      TRC_MMCDI=*BLANKS                                          CSD012
     C                   EVAL      TRC_CCDIC=*ZEROS                                           CSD012
     C                   EVAL      TRC_IACE=*ZEROS                                            CSD012
     C                   EVAL      TRC_IACCC=*ZEROS                                           CSD012
     C                   EVAL      TRC_CIACC=*ZEROS                                           CSD012
     C                   EVAL      TRC_CMBE=*ZEROS                                            CSD012
     C                   EVAL      TRC_CMBC=*ZEROS                                            CSD012
     C                   EVAL      TRC_ACCB=*ZEROS                                            CSD012
     C                   EVAL      TRC_CCMBC=*ZEROS                                           CSD012
     C                   EVAL      TRC_CHDBE=*ZEROS                                           CSD012
     C                   EVAL      TRC_CHDBC=*ZEROS                                           CSD012
     C                   EVAL      TRC_HDRB=*ZEROS                                            CSD012
     C                   EVAL      TRC_CHDBR=*ZEROS                                           CSD012
     C                   EVAL      TRC_MMCHDB=*BLANKS                                         CSD012
     C                   EVAL      TRC_CCHDBC=*ZEROS                                          CSD012
     C                   EVAL      TRC_CACDC=*BLANKS                                          CSD012
     C                   EVAL      TRC_CCINST=*ZEROS                                          CSD012
     C                   EVAL      TRC_TEGRT=*ZEROS                                           CSD012
     C                   EVAL      TRC_VATAM=*ZEROS                                           CSD012
     C                   IF        COCEXA=*BLANKS                                             CSD012
     C                   EVAL      TRC_CHDBE=*ZEROS                                           CSD012
     C                   EVAL      TRC_CHDBC=*ZEROS                                           CSD012
     C                   EVAL      TRC_HDRB=*ZEROS                                            CSD012
     C                   EVAL      TRC_CHDBR=*ZEROS                                           CSD012
     C                   EVAL      TRC_CCHDBC=*ZEROS                                          CSD012
     C                   ENDIF                                                                CSD012
     C                   IF        COCEXB=*BLANKS                                             CSD012
     C                   EVAL      TRC_ACCEA=*ZEROS                                           CSD012
     C                   EVAL      TRC_ACCC=*ZEROS                                            CSD012
     C                   EVAL      TRC_GVDPE=*ZEROS                                           CSD012
     C                   EVAL      TRC_GVDPC=*ZEROS                                           CSD012
     C                   EVAL      TRC_ACCRA=*ZEROS                                           CSD012
     C                   EVAL      TRC_CACCC=*ZEROS                                           CSD012
     C                   ENDIF                                                                CSD012
     C                   IF        COCEXC=*BLANKS                                             CSD012
     C                   EVAL      TRC_CDIE=*ZEROS                                            CSD012
     C                   EVAL      TRC_CDICA=*ZEROS                                           CSD012
     C                   EVAL      TRC_CDRR=*ZEROS                                            CSD012
     C                   EVAL      TRC_CCDIC=*ZEROS                                           CSD012
     C                   ENDIF                                                                CSD012
     C                   IF        COCEXD=*BLANKS                                             CSD012
     C                   EVAL      TRC_IACE=*ZEROS                                            CSD012
     C                   EVAL      TRC_IACCC=*ZEROS                                           CSD012
     C                   EVAL      TRC_CIACC=*ZEROS                                           CSD012
     C                   ENDIF                                                                CSD012
     C                   IF        COCEXE=*BLANKS                                             CSD012
     C                   EVAL      TRC_CMBE=*ZEROS                                            CSD012
     C                   EVAL      TRC_CMBC=*ZEROS                                            CSD012
     C                   EVAL      TRC_ACCB=*ZEROS                                            CSD012
     C                   EVAL      TRC_CCMBC=*ZEROS                                           CSD012
     C                   ENDIF                                                                CSD012
     C                   IF        COCEXF=*BLANKS                                             CSD012
     C                   EVAL      TRC_CCINST=*ZEROS                                          CSD012
     C                   EVAL      TRC_NOIS=*ZEROS                                            CSD012
     C                   EVAL      TRC_NOCC=*ZEROS                                            CSD012
     C                   EVAL      TRC_PESP=*ZEROS                                            CSD012
     C                   EVAL      TRC_NOIP=*ZEROS                                            215952
     C                   ENDIF                                                                CSD012
     C                   IF        COCEXG=*BLANKS                                             CSD012
     C                   EVAL      TRC_FXDC=*ZEROS                                            CSD012
     C                   ENDIF                                                                CSD012
     C                   Z-ADD     CONOCC        TRC_NOCC                                     CSD012
     C                   EVAL      TRC_PESP=*ZERO                                             CSD012
      *                                                                                       CSD012
     C                   ENDIF                                                                CSD012
      *                                                                                       CSD012
     C                   IF        AMCHTP = 'A'                                               CSD012
      *                                                                                       CSD012
     C                   IF        COCEXA='E'                                                 CSD012
     C                   EVAL      TRC_CHDBE=*ZEROS                                           CSD012
     C                   EVAL      TRC_CHDBC=*ZEROS                                           CSD012
     C                   EVAL      TRC_HDRB=*ZEROS                                            CSD012
     C                   EVAL      TRC_CHDBR=*ZEROS                                           CSD012
     C                   EVAL      TRC_CCHDBC=*ZEROS                                          CSD012
     C                   ENDIF                                                                CSD012
     C                   IF        COCEXB='E'                                                 CSD012
     C                   EVAL      TRC_ACCEA=*ZEROS                                           CSD012
     C                   EVAL      TRC_ACCC=*ZEROS                                            CSD012
     C                   EVAL      TRC_GVDPE=*ZEROS                                           CSD012
     C                   EVAL      TRC_GVDPC=*ZEROS                                           CSD012
     C                   EVAL      TRC_ACCRA=*ZEROS                                           CSD012
     C                   EVAL      TRC_CACCC=*ZEROS                                           CSD012
     C                   ENDIF                                                                CSD012
     C                   IF        COCEXC='E'                                                 CSD012
     C                   EVAL      TRC_CDIE=*ZEROS                                            CSD012
     C                   EVAL      TRC_CDICA=*ZEROS                                           CSD012
     C                   EVAL      TRC_CDRR=*ZEROS                                            CSD012
     C                   EVAL      TRC_CCDIC=*ZEROS                                           CSD012
     C                   ENDIF                                                                CSD012
     C                   IF        COCEXD='E'                                                 CSD012
     C                   EVAL      TRC_IACE=*ZEROS                                            CSD012
     C                   EVAL      TRC_IACCC=*ZEROS                                           CSD012
     C                   EVAL      TRC_CIACC=*ZEROS                                           CSD012
     C                   ENDIF                                                                CSD012
     C                   IF        COCEXE='E'                                                 CSD012
     C                   EVAL      TRC_CMBE=*ZEROS                                            CSD012
     C                   EVAL      TRC_CMBC=*ZEROS                                            CSD012
     C                   EVAL      TRC_ACCB=*ZEROS                                            CSD012
     C                   EVAL      TRC_CCMBC=*ZEROS                                           CSD012
     C                   ENDIF                                                                CSD012
     C                   IF        COCEXF='E'                                                 CSD012
     C                   EVAL      TRC_CCINST=*ZEROS                                          CSD012
     C                   EVAL      TRC_NOIS=*ZEROS                                            CSD012
     C                   EVAL      TRC_NOCC=*ZEROS                                            CSD012
     C                   EVAL      TRC_PESP=*ZEROS                                            CSD012
     C                   ENDIF                                                                CSD012
     C                   IF        COCEXG='E'                                                 CSD012
     C                   EVAL      TRC_FXDC=*ZEROS                                            CSD012
     C                   ENDIF                                                                CSD012
      *                                                                                       CSD012
     C                   ENDIF                                                                CSD012
      *                                                                                       CSD012
     C                   WRITE     RECMSHD0                                                   CSD012
      *                                                                                       CSD012
     C                   ENDIF                                                                CSD012
      *                                                                                       CSD012
     C                   ENDIF                                                                CSD012
      *                                                                                       CSD012
     C                   ENDIF                                                                CSD012
      *End-----------------------6-------------------------------------                       CSD012
      *Start---------------------7-------------------------------------                       CSD012
      *                                                                                       CSD012
      ** If CRT101 (Password on Retail Accounts) is installed and                             CSD012
      ** CRT001 (Retail Teller System) is on                                                  CSD012
      *                                                                                       CSD012
     C                   IF        CRT101='Y' and CRT001='Y' and                              CSD012
     C                             AMATYP='R' and AMSTYP='S'                                  CSD012
      *                                                                                       CSD012
     C*****Accntkey      CHAIN     REPWSHL0                           94               CSD012 CSD101
      * If record does not exist write details to customer shadow file                 CSD012 CSD101
     C******IN94         IFEQ      *ON                                                 CSD012 CSD101
      *                                                                                       CSD012
     C**********         CLEAR                   REPWSHD0                              CRE101 CSD101
     C**********         MOVEL     GLVAMPW       REVPWSH                               CSD012 CSD101
      *                                                                                       CSD012
     C**********         WRITE     REPWSHD0                                            CSD012 CSD101
     C**********         ENDIF                                                         CSD012 CSD101
      *                                                                                       CSD012
     C                   ENDIF                                                                CSD012
      *End-----------------------7-------------------------------------                       CSD012
      *Start---------------------8-------------------------------------                       CRE015
                                                                                              CRE015
     C                   IF        CRE015 = 'Y'                                               CRE015
     C                             AND A5ATTY = 'P'                                           CRE015
                                                                                              CRE015
     C     RehisKey      SETLL     REPRSHL0                                                   CRE015
     C                   IF        NOT %EQUAL(REPRSHL0)                                       CRE015
                                                                                              CRE015
     C                   MOVEA     GLVAMPP       ArrFilBuf                                    CRE015
     C                   DO        26            X                                            CRE015
     C                   EVAL      REVPENA = ArrFilBuf(X)                                     CRE015
                                                                                              CRE015
      ** Write if the record is not blanks                                                    CRE015
                                                                                              CRE015
     C                   IF        TRP_E2BRCA <> *BLANKS                                      CRE015
                                                                                              CRE015
      ** Resequence events except event Z                                                     CRE015
                                                                                              CRE015
     C                   IF        TRP_E2EVNT <> 'Z'                                          CRE015
     C                   EVAL      TRP_E2EVNT = ArrEvnt(X)                                    CRE015
     C                   ENDIF                                                                CRE015
                                                                                              CRE015
     C                   WRITE     REPRSHD0                                                   CRE015
     C                   ENDIF                                                                CRE015
     C                   ENDDO                                                                CRE015
                                                                                              CRE015
     C                   ENDIF                                                                CRE015
                                                                                              CRE015
     C                   ENDIF                                                                CRE015
      *End-----------------------8-------------------------------------                       CRE015
     C                   MOVEL     Branch        @DDBRCA                                      CSD012
     C                   MOVEL     CustNum       @DDCNUM                                      CSD012
     C                   MOVEL     Currency      @DDCCY                                       CSD012
     C                   MOVEL     AccCode       @DDACOD                                      CSD012
     C                   MOVEL     AccSeq        @DDACSQ                                      CSD012
                                                                                              CSD015
      ** If CSD015 = 'Y' and watch list checking applied                                      CSD015
                                                                                              CSD015
     C                   IF        CSD015 = 'Y'                                               CSD015
     C                             AND W1EWLC = 'Y'                                           CSD015
                                                                                              CSD015
      ** If user is in the main system                                                        CSD015
                                                                                              CSD015
     C                   IF        CSC011 <> 'Y'                                              CSD015
     C                             OR CSC011 = 'Y' AND S1MAIN = LIBR                          CSD015
                                                                                              CSD015
     C                   IF        AMCHTP = 'A'                                               CSD015
                                                                                              CSD015
      ** Access SDCWHTPD using fucntion type 'GLAMAD', identifier                             CSD015
      ** PIdentifier, branch AC_BRCA to verify Hit Unconfirmed Flag                           CSD015
                                                                                              CSD015
     C                   EVAL      WFuncType = 'ACCNTAB'                                      CSD015
     C                   MOVE      TAC_CNUM      WCust                                        CSD015
     C                   MOVE      TAC_ACOD      WAcod                                        CSD015
     C                   MOVE      TAC_ACSQ      WAcsq                                        CSD015
     C                   EVAL      WIdntifier = TAC_BRCA + WCust +                            CSD015
     C                             TAC_CCY + WAcod + WAcsq                                    CSD015
     C                   EVAL      WBranch = TAC_BRCA                                         CSD015
                                                                                              CSD015
      ** Access logical file based on SDCWHTPD to verify Hit Status.                          CSD015
      ** Move blanks to hit status if record is not found.                                    CSD015
                                                                                              CSD015
     C     KCwFld        CHAIN     SDCWHTL1                                                   CSD015
                                                                                              CSD015
     C                   ENDIF                                                                CSD015
                                                                                              CSD015
      ** If any of the watch list fields has been entered                                     CSD015
                                                                                              CSD015
     C                   IF        TAC_ANAM <> *BLANKS OR                                     CSD015
     C                             AMCHTP = 'A' AND                                           CSD015
     C                             %FOUND(SDCWHTL1) AND W3UNCF = 'Y' OR                       CSD015
     C                             AMCHTP = 'A' AND  AMANAM <> TAC_ANAM                       CSD015
                                                                                              CSD015
     C                   EXSR      SRXWTCH                                                    CSD015
     C                   ENDIF                                                                CSD015
     C                   ENDIF                                                                CSD015
     C                   ENDIF                                                                CSD015
      *                                                                                       CSD012
      * If Authorisation check is on,                                                         CSD012
      * check if unathorised record exists on Authorisation Log.                              CSD012
     C     @AULG         CHAIN     SDAULGL0                           96                      CSD012
      *                                                                                       CSD012
      * If record does not exist write details to Authoristion Log                            CSD012
     C     *IN96         IFEQ      *ON                                                        CSD012
     C                   MOVEL     @AULG         ALKEY                                        CSD012
     C                   MOVEL     FUNCD         ALFUNC                                       CSD012
     C                   MOVE      AMCHTP        ALACTN                                       CSD012
     C                   MOVE      PSUser        ALUSER                                       CSD012
     C                   WRITE     SDAULGD0                                                   CSD012
     C                   ENDIF                                                                CSD012
      *                                                                                       CSD012
     C                   RETURN                                                               CSD012
     C                   ENDIF                                                                CSD012
      *End-----------------------2-------------------------------------                       CSD012
     C                   ENDIF                                                                CSD012
      *End-----------------------1-------------------------------------                       CSD012

      *
      ** INSERT, AMEND or DELETE The Account
      *
     C     AMCHTP        CASEQ     'I'           INSERT
     C     AMCHTP        CASEQ     'A'           AMEND
     C     AMCHTP        CASEQ     'D'           DELETE
     C                   END
     C/COPY WNCPYSRC,GLAMADDC01

      ** If 24x7 Midas Availability is installed                                              CSC011
      ** and Support System is active                                                         CSC011
                                                                                              CSC011
     C                   IF        (CSC011 = 'Y') AND (S1SUPP = LIBR)                         CSC011
                                                                                              CSC011
     C                   CALLB     'GLAMADLOG'                                                CSC011
     C                   PARM      *BLANKS       RetCodeOut                                   CSC011
     C                   PARM                    GLVAMAD                                      CSC011
     C                   PARM                    GLVAMBX                                      CSC011
     C                   PARM                    GLVAMRI                                      CSC011
     C                   PARM                    GLVAMCO                                      CSC011
     C                   PARM                    GLVAMPW                                      CSC011
     C                   PARM                    GLVAMPP                                      CRE015
     C/COPY OFCPYSRCZ,CRE101_021                                                              CRE101
     C                   PARM                    CDE002                                       CSC011
     C                   PARM                    TRANSDTL                                     CSC011
                                                                                              CSC011
      ** If there is no error, write the log file                                             CSC011
                                                                                              CSC011
     C                   IF        RetCodeOut = *BLANKS                                       CSC011
                                                                                              CSC011
     C                   EVAL      APTGTTYPE = 'GLAMAD'                                       CSC011
     C                   EVAL      APFOTRANID = AMFRNT                                        CSC011
     C                   EVAL      APFOASOCID = AMAFRT                                        CGL029
     C                   EVAL      APRPRLOCN  = AMREPA                                        CSC011
     C                   EVAL      APUSERID   = PSUser                                        CSC011
     C                   EVAL      APMIDUSR   = PSUser                                        CSC011
                                                                                              CSC011
     C                   EVAL      PAcctNum = Brch + CustNumb + Curren +                      CSC011
     C                                        AcCode + AcSeq                                  CSC011
                                                                                              CSC011
     C                   CALLB     'APLOGTRAN'                                                CSC011
     C                   PARM      *BLANKS       RetCodeOut                                   CSC011
     C                   PARM                    APHEAD                                       CSC011
     C                   PARM                    TRANSDTL                                     CSC011
     C                   PARM      *BLANKS       WTimestamp                                   CSC011
     C                   PARM                    PAcctNum                                     CSC011
     C                   PARM      *BLANKS       PADealNo                                     CSC011
                                                                                              CSC011
     C                   ENDIF                                                                CSC011
                                                                                              CSC011
      ** If there is an error in either log file, end program                                 CSC011
                                                                                              CSC011
     C                   IF        RetCodeOut <> *Blanks                                      CSC011
     C                   EVAL      @@RTCD = '*ERROR'                                          CSC011
     C                   ENDIF                                                                CSC011
                                                                                              CSC011
     C                   ENDIF                                                                CSC011
                                                                                              CSC011
      * EXIT FROM PROGRAM
     C     EXIT          TAG

     C                   RETURN
     C****************************************************************
      /EJECT
     C*****************************************************************
     C*                                                               *
     C* CHKOTHUPD - Check for update by another workstation           *
     C*                                                               *
     C*****************************************************************
     C     CHKOTHUPD     BEGSR

      ** Retrieve current Account details

     C                   MOVE      AMCNUM        CustNumb
     C                   MOVE      AMCCY         Curren
     C                   MOVE      AMACOD        AcCode
     C                   MOVE      AMACSQ        AcSeq
     C                   MOVE      AMBRCA        Brch
     C                   MOVE      *BLANKS       ReNum
     C     AMACNO        IFGT      0
     C                   MOVE      AMACNO        ReNum
     C                   ENDIF

      ** Determine whether program is running interactively or in batch
      **  ( 0 = batch   1 = interactive)
      *
     C                   CALLB     'ZARTVJOBA'
     C                   PARM                    @Return           6
     C                   PARM                    @type             1
      *                                                                         CAP013
      * Set retrieve mode to '*FRONT' (Access using Front Office ID)            CAP013
      *  if insert                                                              CAP013
      * Otherwise                                                               CAP013
      *  Set retrieve mode to blank  (Access using Midas transaction ID).       CAP013
      *                                                                         CAP013
     C*****AMCHTP        IFne      'I'                                    CAP013193883
     C**********         MOVEL     '1'           @TYPE                    CAP013193883
     C**********         ENDIF                                            CAP013193883
      *                                                                         193883
     C     @Type         IFEQ      '1'                                          193883
     C     AMCHTP        ANDEQ     'I'                                          193883
     C     AMFRNT        ANDNE     *BLANKS                                      193883
     C                   MOVE      '*FRONT'      @@MODE                         193883
     C                   ELSE                                                   193883
      *                                                                         193883
      * Otherwise, if running in batch use Front-Office ID (if insert)          193883
      * else, use Midas Deal Number                                             193883
      *
     C     @Type         IFEQ      '0'
     C     AMCHTP        ANDEQ     'I'                                          193883
     C                   MOVE      '*FRONT'      @@MODE
     C**********         EVAL      FOTRID = AMFRNT                              193883
     C                   ELSE
     C                   MOVE      *BLANKS       @@MODE
     C**********         EVAL      FOTRID = *blanks                             193883
     C                   END
     C                   END                                                    193883

      ** Before call to retrieve module, set FOTRID parameter as a concatenated               CGL029
      ** front office id and associated front office id                                       CGL029
                                                                                              CGL029
     C                   EVAL      FOTRID = AMFRNT + AMAFRT                                   CGL029
      *
      * Retrieve Account
      *
     C                   CALLB     'GLAMADRTV'
      *                  ¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯
      * INPUTS :
      * Return code
     C                   PARM      *BLANK        RetCodeOut
      * Mode = '*FRONT' (FRONT OFFICE TRANSACTION INTERFACE)
      * MODE = '      ' (NOT FRONT OFFICE TRANSACTION INTERFACE)
     C                   PARM                    @@MODE            6
      * Response mode
     C                   PARM                    RespMode
      * Action Code
     C                   PARM      AMCHTP        Action
      * Front Office Transaction ID
     C**********         PARM                    FOTRID                         193883
     C**********         PARM      AMFRNT        FOTRID                                193883 CGL029
     C                   PARM                    FOTRID                                       CGL029
      * (Midas) Account Reference
     C                   PARM                    CustNumb
     C                   PARM                    Curren
     C                   PARM                    AcCode
     C                   PARM                    AcSeq
     C                   PARM                    Brch
     C                   PARM                    ReNum
      * Commissions
     C                   PARM                    CommDisp
      * IBAN                                                                    CFT004
     C                   PARM                    CFT004                         CFT004
     C                   PARM                    AMIBAN                                       238839
     C                   PARM                    CRE015                                       CRE015
     C/COPY OFCPYSRCZ,CRE101_008                                                              CRE101
      *                                                                                       194431
      ** New Accounts Currency                                                                194431
      *                                                                                       194431
     C                   PARM                    WDCCY             3                          194431
      * OUTPUTS :
      * (Current) Account in file format
     C                   PARM                    ChkAccnFmt
     C                   PARM                    CABXFilFmt
     C                   PARM                    CARIFilFmt
     C                   PARM                    CACOFilFmt
     C                   PARM                    CAPWFilFmt
     C                   PARM                    DDPSWD          128                          CSD101
     C                   PARM                    CAPPFilFmt                                   CRE015
     C/COPY OFCPYSRCZ,CRE101_026                                                              CRE101
      * OK - Action code
     C                   PARM      *BLANK        ActionOK
      * OK - Account Reference
     C                   PARM                    CNUMOK
     C                   PARM                    CCYOK
     C                   PARM                    ACODOK
     C                   PARM                    ACSQOK
     C                   PARM                    BRCAOK
     C                   PARM                    ACNOOK
      * Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIdArr
     C                   PARM                    MsgDtaArr
      * Array index (3P0) from/to caller
     C                   PARM      *ZERO         Idx
      * Base Rate Auth req                                                                    CSD012
     C                   PARM                    AUTHRQ            1                          CSD012
      * Authorisation Mode                                                                    CSD012
     C                   PARM                    AUTHMD            1                          CSD012
      *
      ** Error if Timestamp is not the same (record has been changed
      **  by another workstation)

      ** Processing varies according to mode program is running in.
      ** In interacive mode simply check whether the timestamp field
      ** has been updated since the original Trade was fetched by this
      ** program.
      ** In batch (API input) check return parameters from Retrieve
      ** module for errors, and send message to system operator.

      ** Interactive mode:

     C     @TYPE         IFEQ      '1'

     C     CHTMST        IFNE      AMTMST
     C     AUTHMD        ANDNE     'X'                                                        240296
     C                   MOVEL     '*RECUPD'     @@RTCD
     C                   DUMP                                               198865
     C                   END

      ** Batch mode:
     C                   ELSE
     C     ActionOK      IFEQ      'N'
     C     CCYOK         OREQ      'N'
     C     ACODOK        OREQ      'N'
     C     ACSQOK        OREQ      'N'
     C     ACNOOK        OREQ      'N'
     C     BRCAOK        OREQ      'N'
     C                   MOVEL     '*RECUPD'     @@RTCD
     C                   DUMP                                               198865
     C                   Z-ADD     1             C                 2 0

     C     C             DOWLE     ArrayMax
     C     FldNameArr(C) ANDNE     *BLANKS
     C                   MOVEL     *BLANKS       DBError          28
     C                   MOVEL     MsgIDArr(C)   DBError
     C                   CALLB     'ZAMSGTOOPR'
     C                   PARM                    MsgSndRtn        10
     C                   PARM                    DBError
     C                   PARM                    DummyMsgID
     C                   PARM                    DummyMsgF
     C                   ADD       1             C
     C                   END

     C                   END

     C                   END

     C                   ENDSR
     C****************************************************************
      /EJECT
     C****************************************************************
     C*                                                              *
     C* INSERT - Insert an Account                                   *
     C*                                                              *
     C****************************************************************
     C     INSERT        BEGSR

      *
      ** Write MEMOS for Retail Accounts
      *
     C                   IF        BGNXST='Y' or BGNYST='Y'
     C**********         IF        AMACNO<>*ZERO                                              203282
     C                   IF        AMATYP = 'R'                                               203282
     C                   IF        AMACNO<>*ZERO                                              203282
      *                                                                                       203282
      *
     C     AMACNO        CHAIN     MEMOSL2                            80

      ** DATABASE ERROR

     C     *IN80         IFEQ      '0'
     C                   MOVEL     AMACNO        DBKEY
     C                   MOVEL     'MEMOSL2'     DBFILE                         ************
     C                   MOVEL     '001'         DBASE                          * DBERR 001*
     C                   EXSR      SRERR                                        ************
     C                   END
      *                                                                                       203282
     C                   END                                                                  203282
     C                   CLEAR                   MEMOSMDF                                     CRE101
      *
     C                   EVAL      M_RECI='D'
     C                   EVAL      M_CNUM=AMCNUM
     C                   EVAL      M_CCY=AMCCY
     C                   EVAL      M_ACOD=AMACOD
     C                   EVAL      M_ACSQ=AMACSQ
     C                   EVAL      M_BRCA=AMBRCA
     C                   EVAL      M_ACNO=AMACNO
     C                   EVAL      M_LDBLN=*ZERO
     C                   EVAL      M_CLBLN=*ZERO
     C                   EVAL      M_ZZ005=*BLANKS
     C                   EVAL      M_INLU=*ZERO
     C                   EVAL      M_BNLU=*ZERO
     C                   WRITE     MEMOSMDF
     C/COPY WNCPYSRC,GLAMADDC02
      *                                                                                       CRE023
      ** If 2 O'clock SAR switch is on                                                        CRE023
      *                                                                                       CRE023
     C                   IF        CRE023 = 'Y'                                               CRE023
     C                   EVAL      GRECI  = 'L'                                               CRE023
     C                   EVAL      GACNO  = AMACNO                                            CRE023
     C                   EVAL      GPAMT  = *ZEROS                                            CRE023
     C                   EVAL      GTAMT  = *ZEROS                                            CRE023
     C                   EVAL      GZD01  = *BLANKS                                           CRE023
     C                   WRITE     REMEMLD0                                                   CRE023
     C                   ENDIF                                                                CRE023
     C                   ENDIF
     C                   ENDIF
      *
      ** Obtain the next available transaction number
      *
     C                   CALLB     'ZTNLU1'
     C                   PARM      *BLANK        Retrn            10
     C                   PARM                    NATN
      ** Database Error if ReturnCode not blank
      *
     C     Retrn         IFNE      *BLANK
     C                   MOVEL     NATN          DBKEY
     C                   MOVEL     'MNATN  '     DBFILE                         ************
     C                   MOVEL     '002'         DBASE                          * DBERR 002*
     C                   EXSR      SRERR                                        ************
     C                   END
      *
      ** Insert Account record
      *
     C     RehisKey      CHAIN     ACCBR                              80

      ** DATABASE ERROR

     C     *IN80         IFEQ      '0'
     C                   MOVEL     DBerrKey      DBKEY
     C                   MOVEL     'ACCNTAB'     DBFILE                         ************
     C                   MOVEL     '003'         DBASE                          * DBERR 003*
     C                   EXSR      SRERR                                        ************
     C                   END

     C                   CLEAR                   ACCNTABF                                     CRE101
     C                   EVAL      AC_RECI='D'
     C                   EVAL      AC_CNUM=AMCNUM
     C                   EVAL      AC_CCY=AMCCY
     C                   EVAL      AC_ACOD=AMACOD
     C                   EVAL      AC_ACSQ=AMACSQ
     C                   EVAL      AC_LTAB=AMLTAB
     C                   EVAL      AC_LTAS=AMLTAS
     C                   EVAL      AC_BRCA=AMBRCA
     C                   EVAL      AC_ATYP=AMATYP
     C                   EVAL      AC_STYP=AMSTYP
     C                   EVAL      AC_MFFQ=AMMFFQ
     C                   EVAL      AC_ACST=AMACST
     C                   EVAL      AC_DACO=AMDACO
     C                   EVAL      AC_DACC=AMDACC
     C                   EVAL      AC_ANAM=AMANAM
     C                   EVAL      AC_LDBL=AMLDBL
     C                   EVAL      AC_CLBL=AMCLBL
     C                   EVAL      AC_STFQ=AMSTFQ
     C                   EVAL      AC_STDY=AMSTDY
     C                   EVAL      AC_LSTD=AMDACO
     C                   EVAL      AC_NSTD=AMNSTD
     C                   EVAL      AC_LSTP=AMLSTP
     C                   EVAL      AC_CFSB=AMCFSB
     C                   EVAL      AC_LMVD=AMLMVD
     C                   EVAL      AC_EPLB=AMEPLB
     C                   EVAL      AC_EPCB=AMEPCB
     C                   EVAL      AC_YTDB=AMYTDB
     C                   EVAL      AC_GLBT=AMGLBT
     C                   EVAL      AC_ADREF1=AMADREF1
     C                   EVAL      AC_LTAC=AMLTAC
     C                   EVAL      AC_ORED=BJRDNB
     C                   EVAL      AC_DLIM=AMDLIM
     C                   EVAL      AC_LRCR=AMLRCR
     C                   EVAL      AC_RTCB=AMRTCB
     C                   EVAL      AC_RTLB=AMRTLB
     C                   EVAL      AC_DITM=AMDITM
     C                   EVAL      AC_CITM=AMCITM
     C                   EVAL      AC_ADREF2=AMADREF2
     C                   EVAL      AC_ZZ002=AMZZ002
     C                   EVAL      AC_CDIR=AMCDIR
     C                   EVAL      AC_CCIR=AMCCIR
     C                   EVAL      AC_ACNO=AMACNO
     C                   EVAL      AC_RETB=AMRETB
     C                   EVAL      AC_ODSC=AMODSC
     C                   EVAL      AC_ODLN=AMODLN
     C                   EVAL      AC_ODED=AMODED
     C                   EVAL      AC_DIOD=AMDIOD
     C                   EVAL      AC_FACT=AMFACT
     C                   EVAL      AC_FCNO=AMFCNO
     C                   EVAL      AC_EFAC=AMEFAC
     C                   EVAL      AC_HELD=AMHELD
     C                   EVAL      AC_MINB=AMMINB
     C                   EVAL      AC_LACD=AMDACO
     C                   EVAL      AC_LISP=AMLISP
     C                   EVAL      AC_RRNM=AMRRNM
     C                   EVAL      AC_DRIB=AMDRIB
     C                   EVAL      AC_DRIS=AMDRIS
     C**********         EVAL      AC_OLDR=AMOLDR                                             194431
     C                   EVAL      AC_OLDR=AMDACO                                             194431
     C                   EVAL      AC_DRIC=AMDRIC
     C                   EVAL      AC_DRIF=AMDRIF
     C                   EVAL      AC_DRDY=AMDRDY
     C                   EVAL      AC_NDID=AMNDID
     C                   EVAL      AC_LDID=AMDACO
     C                   EVAL      AC_LDIA=AMLDIA
     C                   EVAL      AC_SDAP=AMSDAP
     C                   EVAL      AC_LPAR=AMLPAR
     C                   EVAL      AC_DIIE=AMDIIE
     C                   EVAL      AC_DAIC=AMDAIC
     C                   EVAL      AC_MADI=AMMADI
     C                   EVAL      AC_GADI=AMGADI
     C                   EVAL      AC_DDIS=AMDDIS
     C                   EVAL      AC_DDIA=AMDACO
     C**********         EVAL      AC_CRCD=AMCRCD                                             194431
     C                   EVAL      AC_CRCD=AMDACO                                             194431
     C**********         EVAL      AC_DRCD=AMDRCD                                             194431
     C                   EVAL      AC_DRCD=AMDACO                                             194431
     C                   EVAL      AC_OLDB=AMOLDB
     C                   EVAL      AC_OLDS=AMOLDS
     C                   EVAL      AC_CRIB=AMCRIB
     C                   EVAL      AC_CRIS=AMCRIS
     C**********         EVAL      AC_OLCR=AMOLCR                                             194431
     C                   EVAL      AC_CRIC=AMCRIC
     C                   EVAL      AC_CRIF=AMCRIF
     C                   EVAL      AC_CRDY=AMCRDY
     C                   EVAL      AC_NCID=AMNCID
     C                   EVAL      AC_LCID=AMDACO
     C                   EVAL      AC_LCIA=AMLCIA
     C                   EVAL      AC_SCAP=AMSCAP
     C                   EVAL      AC_LPAP=AMDACO
     C                   EVAL      AC_CIIE=AMCIIE
     C                   EVAL      AC_CAIC=AMCAIC
     C                   EVAL      AC_MACI=AMMACI
     C                   EVAL      AC_GACI=AMGACI
     C                   EVAL      AC_CDIS=AMCDIS
     C                   EVAL      AC_DCIA=AMDACO
     C**********         EVAL      AC_OLCR=AMOLCR                                             194431
     C                   EVAL      AC_OLCR=AMDACO                                             194431
     C                   EVAL      AC_OLCB=AMOLCB
     C                   EVAL      AC_OLCS=AMOLCS
     C                   EVAL      AC_LCD=BJRDNB
     C                   EVAL      AC_CHTP='I'
     C                   EVAL      AC_TNLU=AMTNLU
     C                   EVAL      AC_ENOC=AMENOC
     C                   EVAL      AC_PRFC=AMPRFC
     C                   EVAL      AC_BRTCA=AMBRTCA
     C                   EVAL      AC_PTFR=AMPTFR
     C                   EVAL      AC_EPNO=AMEPNO
     C                   EVAL      AC_ECFB=AMECFB
     C                   EVAL      AC_HCFB=AMHCFB
      *                                                                                       CER047
      ** Subject to KWG §24c reporting                                                        CER047
      *                                                                                       CER047
     C                   IF        CER047 = 'Y'                                               CER047
     C                   EVAL      AC_K24C=AMK24C                                             CER047
     C                   ENDIF                                                                CER047
      *                                                                                       194431
      ** Effective date for Retail Accounts                                                   CRE075
      *                                                                                       CRE075
     C                   IF        CRE075 = 'Y'                                               CRE075
     C                   EVAL      AC_ACEFDT = AMEFDT                                         CRE075
     C                   ELSE                                                               AR818450
     C                   EVAL      AC_ACEFDT = *ZEROS                                       AR818450
     C                   ENDIF                                                                CRE075
      *                                                                                       CRE075
      ** CRE073 related fields                                                                CRE073
      *                                                                                       CRE073
     C                   IF        CRE073 = 'Y'                                               CRE073
     C                   EVAL      AC_DCSP = AMDCSP                                           CRE073
     C                   EVAL      AC_DCSG = AMDCSG                                           CRE073
     C                   EVAL      AC_DRMT = AMDRMT                                           CRE073
     C                   EVAL      AC_DRFD = AMDRFD                                           CRE073
     C                   EVAL      AC_CCSP = AMCCSP                                           CRE073
     C                   EVAL      AC_CCSG = AMCCSG                                           CRE073
     C                   EVAL      AC_CRMT = AMCRMT                                           CRE073
     C                   EVAL      AC_CRFD = AMCRFD                                           CRE073
     C                   ELSE                                                                 CRE073
     C                   EVAL      AC_DCSP = *ZEROS                                           CRE073
     C                   EVAL      AC_CCSP = *ZEROS                                           CRE073
     C                   ENDIF                                                                CRE073
      *                                                                                       CRE073
      ** Reset fields in AC_GLBT before update.                                               194431
      *                                                                                       194431
     C                   BITOFF    '01234567'    AC_GLBT                                      194431
     C                   TESTB     '2'           AMGLBT                   30                  194431
     C                   IF        *IN30                                                      194431
     C                   BITON     '2'           AC_GLBT                                      194431
     C                   ELSE                                                                 194431
     C                   BITOFF    '2'           AC_GLBT                                      194431
     C                   ENDIF                                                                194431
      *
      ** If Midas/Trade Innovation is on then move TI fields in.
     C                   IF        BGN3ST = 'Y'
     C                   EVAL      AC_A5TIAC=AMA5TIAC
     C                   EVAL      AC_A5TIAN=AMA5TIAN
     C                   EVAL      AC_A5TIAS=AMA5TIAS
     C                   ENDIF
      *                                                                                     MD034725
      ** If CTI006 is on, save TI field                                                     MD034725
      *                                                                                     MD034725
     C                   IF        CTI006 = 'Y'                                             MD034725
     C                   EVAL      AC_A5TIAC = AMA5TIAC                                     MD034725
     C                   ENDIF                                                              MD034725
      *
      ** If EMU Account Postings Narrative is on, move fields in.
     C                   IF        CEU013='Y'
     C                   EVAL      AC_EUSB=AMEUSB
     C                   ENDIF
      *                                                                         CFT004
      ** If International Banking Account Numer is on (CFT004)                  CFT004
      ** move field in.                                                         CFT004
     C                   IF        CFT004='Y'                                   CFT004
     C                   EVAL      AC_IBAN=AMIBAN                               CFT004
     C                   EVAL      AC_IBSEQN=AMIBSEQN                           CFT004
     C                   ENDIF                                                  CFT004
      ** Front Office ID
     C                   EVAL      AC_FRNT=AMFRNT
      ** Associated Front Office ID
     C                   EVAL      AC_AFRT=AMAFRT
      ** Repair Location
     C                   EVAL      AC_REPA=AMREPA
      ** Timestamp
     C                   CALLB     'ZAGENTMSTM'
     C                   PARM                    TimeStamp

     C                   EVAL      AC_TMST  = TimeStamp
      *                                                                         CDE001
      ** Data export for CCRM - Limits                                          CDE001
     C                   IF        CDE001 = 'Y'                                 CDE001
     C                   EVAL      W#CNUM = AMCNUM                              CDE001
     C                   EVAL      W#CCY  = AMCCY                               CDE001
     C                   EVAL      W#ACOD = AMACOD                              CDE001
     C                   EVAL      W#ACSQ = AMACSQ                              CDE001
     C                   EVAL      W#BRCA = AMBRCA                              CDE001
     C                   MOVEL     W#ACID        T#TREF                         CDE001
     C                   CALLB     'DEWRTTRIG'                                  CDE001
     C**********         PARM                    T#TREF           20                   CDE001 CGL029
     C                   PARM                    T#TREF           26                          CGL029
     C                   PARM      'ACCT'        T#TCAT            4            CDE001
     C                   PARM      *BLANKS       T#RSRV           10            CDE005
     C                   ENDIF                                                  CDE001
                                                                                              CSC011
      ** If CSC011 is installed, supply a Front Office ID for the                             CSC011
      ** transaction even if it originated from SIN module.                                   CSC011
                                                                                              CSC011
     C                   IF        CSC011 = 'Y'                                               CSC011
     C                   IF        AC_FRNT = *BLANKS                                          CSC011
     C                   MOVE      AC_CNUM       WCust                                        CSC011
     C                   MOVE      AC_ACOD       WAcod                                        CSC011
     C                   MOVE      AC_ACSQ       WAcsq                                        CSC011
                                                                                              CGL029
      ** Set front office id to 'MD' + branch + customer + currency + 1st 6                   CGL029
      ** characters of the account code                                                       CGL029
     C**********         EVAL      AC_FRNT = 'MD' + AC_BRCA + WCust +                  CSC011 CGL029
     C**********                           AC_CCY +  WAcod + WAcsq                     CSC011 CGL029
     C                   EVAL      AC_FRNT = 'MD' + AC_BRCA + WCust +                         CGL029
     C                                     AC_CCY +  %SUBST(WAcod:1:6)                        CGL029
                                                                                              CGL029
      ** Set associated front office id to the last 4 characters of the account               CGL029
      ** code                                                                                 CGL029
     C                   EVAL      AC_AFRT = %SUBST(WAcod:7:4) + WAcsq                        CGL029
     C                   ENDIF                                                                CSC011
     C                   ENDIF                                                                CSC011
                                                                                              CSD015
      ** If CSD015 = 'Y' and watch list checking applied                                      CSD015
                                                                                              CSD015
     C                   IF        CSD015 = 'Y'                                               CSD015
     C                             AND W1EWLC = 'Y'                                           CSD015
                                                                                              CSD015
      ** If user is in the main system                                                        CSD015
                                                                                              CSD015
     C                   IF        CSC011 <> 'Y'                                              CSD015
     C                             OR CSC011 = 'Y' AND S1MAIN = LIBR                          CSD015
                                                                                              CSD015
      ** If any of the watch list fields has been entered                                     CSD015
                                                                                              CSD015
     C                   IF        AC_ANAM <> *BLANKS                                         CSD015
                                                                                              CSD015
     C                   EXSR      SRWTCH                                                     CSD015
     C                   ENDIF                                                                CSD015
     C                   ENDIF                                                                CSD015
     C                   ENDIF                                                                CSD015
                                                                                              CLE025
     C                   EVAL      AC_COLF = *BLANK                                           CLE025
     C                   EVAL      AC_BCOA = *ZERO                                            CLE025
     C                   EVAL      AC_COLA = *ZERO                                            CLE025
     C**********         EVAL      AC_PFCU = *ZERO                                     CLE025 CSD027
     C                   EVAL      AC_PFCU = *BLANKS                                          CSD027
     C                   EVAL      AC_PFTP = *ZERO                                            CLE025
     C                   EVAL      AC_PFSQ = *ZERO                                            CLE025
                                                                                              CLE025
      ** If CLE025 is on, set Facility Customer field                                         CLE025
                                                                                              CLE025
     C                   IF        CLE025 = 'Y'                                               CLE025
                                                                                              CLE025
     C**********         IF        AMFCCU <> *ZERO                                     CLE025 CSD027
     C                   IF        AMFCCU <> *BLANKS                                          CSD027
     C                   EVAL      AC_FCCU = AMFCCU                                           CLE025
     C                   ELSE                                                                 CLE025
                                                                                              CLE025
     C                   IF        AMFACT <> *ZERO  AND  AMFCNO <> *ZERO                      CLE025
     C                   EVAL      AC_FCCU = AMCNUM                                           CLE025
     C                   ELSE                                                                 CLE025
     C**********         EVAL      AC_FCCU = *ZERO                                     CLE025 CSD027
     C                   EVAL      AC_FCCU = *BLANKS                                          CSD027
     C                   ENDIF                                                                CLE025
                                                                                              CLE025
     C                   ENDIF                                                                CLE025
     C                   ENDIF                                                                CLE025
      *                                                                                       CTI004
      ** Format SCOLDA Account Key                                                            CTI004
     C                   MOVE(P)   AC_CNUM       WCust                                        CTI004
     C                   MOVE(P)   AC_ACOD       WAcod                                        CTI004
     C                   MOVE(P)   AC_ACSQ       WAcsq                                        CTI004
                                                                                              CTI004
     C                   EVAL      AC_A5ACKY = AC_BRCA + WCust + AC_CCY                       CTI004
     C                                         + WAcod + WAcsq                                CTI004
      *                                                                                       CTI004
      ** Setup Internal Flag                                                                  CTI004
     C                   EVAL      AC_A5INTL = 'N'                                            CTI004
                                                                                              CTI004
     C     WCust         CHAIN     SDBRCHL5                           83                      CTI004
      *                                                                                       CTI004
      ** Record found                                                                         CTI004
     C                   IF        *IN83 = *OFF                                               CTI004
     C                   EVAL      AC_A5INTL = 'Y'                                            CTI004
     C                   ENDIF                                                                CTI004
      *                                                                                       CTI004
      ** Setup TI Branch Number                                                               CTI004
     C                   CLEAR                   AC_A5TIAB                                    CTI004
      *                                                                                       CTI004
     C                   CALL      'AOBRCHR1'                                                 CTI004
     C                   PARM      *BLANKS       @RTCD                                        CTI004
     C                   PARM      '*KEY   '     @OPTN                                        CTI004
     C                   PARM      AC_BRCA       @BRCH             3                          CTI004
     C     SDBRCH        PARM      SDBRCH        DSSDY                                        CTI004
      *                                                                                       CTI004
      ** Record found                                                                         CTI004
     C                   IF        @RTCD = *BLANKS                                            CTI004
     C                   EVAL      AC_A5TIAB = DS_A8TIBR                                      CTI004
     C                   ENDIF                                                                CTI004
                                                                                              CAP086
      ** Automatic Authorisation flag                                                         CAP086
                                                                                              CAP086
     C                   IF        CAP086 = 'Y'                                               CAP086
     C                   EVAL      AC_AUTH = AMAUTH                                           CAP086
     C                   ENDIF                                                                CAP086
      *
      ** WRITE new Account
     C                   WRITE     ACCNTABF
     C/COPY WNCPYSRC,GLH00701
                                                                                            BUG22973
      ** Return the timestamp                                                               BUG22973
                                                                                            BUG22973
     C                   EVAL      AMTMST = Timestamp                                       BUG22973
      *
      *
      ** WRITE Account trailer record
      *
     C*****1****         SETLL     ACCNTAC                                                    260323
     C**********         READ      ACCNTAC                                80                  260323
     C     1             CHAIN     ACCNTAC                            80                      260323

      ** DATABASE ERROR

     C     *IN80         IFEQ      '1'
     C                   EVAL      DBKEY='1'
     C                   MOVEL     'ACCNTAC'     DBFILE                         ************
     C                   MOVEL     '004'         DBASE                          * DBERR 004*
     C                   EXSR      SRERR                                        ************
     C                   END

     C                   ADD       1             C_NINU
     C                   ADD       1             C_NOAU
     C**********         IF        AC_ACNO<>*ZERO                                             203282
     C                   IF        AC_ATYP = 'R'                                              203282
     C                   ADD       1             C_NRET
     C                   ENDIF
     C                   EVAL      C_LCD=BJRDNB
      ** Obtain the next available transaction number
     C                   CALLB     'ZTNLU1'
     C                   PARM      *BLANK        Retrn
     C                   PARM                    NATN
      ** Database Error if ReturnCode not blank
     C     Retrn         IFNE      *BLANK
     C                   MOVEL     NATN          DBKEY
     C                   MOVEL     'MNATN  '     DBFILE                         ************
     C                   MOVEL     '005'         DBASE                          * DBERR 005*
     C                   EXSR      SRERR                                        ************
     C                   END
     C                   EVAL      C_TNLU=NATN
     C                   UPDATE    ACCNTCXF
      *
      ***Check*if*Account*Retail***************************************                       208437
      ***If*CRE001*(Overdraft Interest Calculations) is installed and                  208437 231128
      ***Account*is Retail                                                             208437 231128
      ***********                                                                      208437 231128
     C**********         IF        CRE001='Y'                                         208437 BUG8210
      *                                                                                      BUG8210
      ** Allow adding account extensions if account type is retail                           BUG8210
      *                                                                                      BUG8210
     C                   IF        AMATYP='R'                                                BUG8210
      *
     C*****BGWDPR        IFEQ      'Y'                                                        239720
     C*****BGSWRT        ANDEQ     'Y'                                                        239720
     C*****AMATYP        ANDEQ     'R'                                                        239720
      ***********                                                                             239720
     C*****BGWDPR        OREQ      'Y'                                                        239720
     C*****BGNTST        ANDEQ     'Y'                                                        239720
     C*****AMATYP        ANDEQ     'R'                                                        239720
     C*****BGWDPR        OREQ      'Y'                                                        239720
     C*****FACH**        ANDEQ     'Y'                                                        239720
     C*****AMATYP        ANDEQ     'R'                                                        239720
     C*****BGWDPR        OREQ      'Y'                                                        239720
     C*****TSTMC*        ANDEQ     'Y'                                                        239720
     C*****AMATYP        ANDEQ     'R'                                                        239720
     C*
      *
      ** Insert Account record Extension File
      *
     C     AccntKey      CHAIN     ACCNTBXC                           8081

      ** DATABASE ERROR

     C     *IN80         IFEQ      '0'
     C     *IN81         OREQ      '1'
     C                   MOVEL     DBerrKey      DBKEY
     C                   MOVEL     'ACCNTBCX'    DBFILE                         ************
     C                   MOVEL     '073'         DBASE                          * DBERR 073*
     C                   EXSR      SRERR                                        ************
     C                   END

     C                   CLEAR                   ACCNTBD0                                     CRE101
     C                   EVAL      AX_ATCNUM=BXCNUM
     C                   EVAL      AX_ATCCY=BXCCY
     C                   EVAL      AX_ATACOD=BXACOD
     C                   EVAL      AX_ATACSQ=BXACSQ
     C                   EVAL      AX_ATCRST=BXCRST
     C                   EVAL      AX_ATSUBO=BXSUBO
     C                   EVAL      AX_ATITAX=BXITAX
     C                   IF        CGL165 = 'Y'                                               CGL165
     C                   EVAL      AX_ATTXC1=BXTXC1                                           CGL165
     C                   EVAL      AX_ATTXC2=BXTXC2                                           CGL165
     C                   ENDIF                                                                CGL165
     C                   EVAL      AX_ATSTCI=BXSTCI
     C                   EVAL      AX_ATCHIN=BXCHIN
     C                   EVAL      AX_ATCHAM=BXCHAM
     C                   EVAL      AX_ZZ100=BXZZ100
     C                   EVAL      AX_ATBRCA=BXBRCA
     C                   EVAL      AX_ATFRNT=BXFRNT
     C                   EVAL      AX_ATAFRT=BXAFRT
     C                   EVAL      AX_ATREPA=BXREPA
     C                   EVAL      AX_ATAODR=*ZEROS
     C                   EVAL      AX_ATORTC=*ZEROS
     C                   EVAL      AX_ATOLVD=*ZEROS
     C                   EVAL      AX_ATITRD=*ZEROS
     C                   IF        CER055 = 'Y'                                               CER055
     C                   MOVE      BXPOLC        AX_ATPOLC                                    CER055
     C                   MOVE      BXPOLE        AX_ATPOLE                                    CER055
     C                   EVAL      AX_ATPOLA = BXPOLA                                         CER055
     C                   ELSE                                                                 CER055
      *                                                                                       CER055
     C                   EVAL      AX_ATPOLE=*ZEROS
     C                   EVAL      AX_ATPOLC=*ZEROS
     C                   ENDIF                                                                CER055
      ** Front Office ID
     C                   EVAL      AX_ATFRNT=BXFRNT
      ** Associated Front Office ID
     C                   EVAL      AX_ATAFRT=BXAFRT
      ** Repair Location
     C                   EVAL      AX_ATREPA=BXREPA
      ** Timestamp
     C                   EVAL      AX_ATTMST=BXTMES
      *
      ** If insert, initialise margin interest fields                           CDE002
     C                   IF        AMCHTP = 'I'                                 CDE002
     C                   EVAL      AX_ATOVRD = *BLANKS                          CDE002
     C                   EVAL      AX_ATOVRC = *BLANKS                          CDE002
     C                   EVAL      AX_ATDRMG = 0                                CDE002
     C                   EVAL      AX_ATCRMG = 0                                CDE002
     C                   EVAL      AX_ATDRMD = 0                                CDE002
     C                   EVAL      AX_ATCRMD = 0                                CDE002
     C                   EVAL      AX_ATDMBR = *BLANKS                          208221
     C                   EVAL      AX_ATCMBR = *BLANKS                          208221
     C                   EVAL      AX_ATACNO = 0                                              204942
      ** Initialise Overdraft fields                                                          CER055
     C                   EVAL      AX_ATDOBE = 0                                              CER055
     C                   EVAL      AX_ATNDYE = 0                                              CER055
     C                   EVAL      AX_ATNDYO = 0                                              CER055
     C                   EVAL      AX_ATPOLA = 0                                              CER055
     C                   ENDIF                                                  CDE002
                                                                                CDE002
      ** If CSC011 is installed, supply a Front Office ID for the                             CSC011
      ** transaction even if it originated from SIN module.                                   CSC011
                                                                                              CSC011
     C                   IF        CSC011 = 'Y'                                               CSC011
     C                   IF        AX_ATFRNT = *BLANKS                                        CSC011
     C                   MOVE      AX_ATCNUM     WCust                                        CSC011
     C                   MOVE      AX_ATACOD     WAcod                                        CSC011
     C                   MOVE      AX_ATACSQ     WAcsq                                        CSC011
                                                                                              CGL029
      ** Set front office id to 'MD' + branch + customer + currency + 1st 6                   CGL029
      ** characters of the account code                                                       CGL029
     C**********         EVAL      AX_ATFRNT = 'MD' + AX_ATBRCA +                      CSC011 CGL029
     C**********                   WCust + AX_ATCCY + WAcod + WAcsq                    CSC011 CGL029
     C                   EVAL      AX_ATFRNT = 'MD' + AX_ATBRCA +                             CGL029
     C                             WCust + AX_ATCCY + %SUBST(WAcod:1:6)                       CGL029
                                                                                              CGL029
      ** Set associated front office id to the last 4 characters of the account               CGL029
      ** code                                                                                 CGL029
     C                   EVAL      AX_ATAFRT = %SUBST(WAcod:7:4) + WAcsq                      CGL029
     C                   ENDIF                                                                CSC011
     C                   ENDIF                                                                CSC011
                                                                                              CSC011
      ** WRITE new Account Extension File
     C**********         IF        CRE001='Y' and AMATYP='R'                          204942 BUG8210
     C**********                   or (CDE002='Y' and AMATYP='R')                     204942 BUG8210
      *                                                                                      BUG8210
      ** Allow adding account extensions if account type is retail                           BUG8210
      *                                                                                      BUG8210
     C***********        IF        AMATYP='R'                                         BUG8210 239720
      *                                                                                       CER050
     C                   If        CER050 = 'Y'                                               CER050
     C                   Eval      AX_ATAPRC = BXAPRC                                         CER050
     C                   Endif                                                                CER050
      *                                                                                       CER050
     C                   WRITE     ACCNTBD0                                                  BUG8210
      *
     C***********        ENDIF                                                         204942 239720
     C                   ENDIF
     C**********         ENDIF                                                         208437 239720
      *
      ***WRITE*STRAN*with*Rate*Change**********************************                      CRE005
      ** WRITE STRAN or RERCH... files with Rate Change                                      CRE005
      *
     C**********         IF        AC_ACNO<>*ZERO                                             203282
     C                   IF        AC_ATYP = 'R'                                              203282
     C                   EVAL      BR_DICT=*ZEROS
     C                   EVAL      BR_DCST=*ZEROS
     C                   EVAL      BR_CICT=*ZEROS
     C                   EVAL      BR_CCST=*ZEROS
     C                   EVAL      BX_ATAODR=*ZEROS
     C                   EVAL      BA_DRIB=*ZEROS
     C                   EVAL      BA_DRIS=*ZEROS
     C                   EVAL      BA_CRIB=*ZEROS
     C                   EVAL      BA_CRIS=*ZEROS
      *                                                                                      CRE005
      *                                                                                      CRE005
     C     CRE005        IFEQ      'Y'                                                       CRE005
     C                   EXSR      UpdRERCH                                                  CRE005
     C                   ELSE                                                                CRE005
     C                   EXSR      UpdSTRAN
     C                   ENDIF                                                               CRE005
      *                                                                                      CRE005
     C                   ENDIF
      *
      ** WRITE and Update Retail records
      *
     C**********         IF        AC_ACNO<>*ZERO                                             203282
     C                   IF        AC_ATYP = 'R'                                              203282
     C                   EXSR      WriteRet
      *                                                                                       CRE072
      ** Write Account to Passbook Update Control Detail                                      CRE072
      *                                                                                       CRE072
     C                   IF        CRE072 = 'Y'                                               CRE072
     C                             AND AC_STYP = 'S'                                          CRE072
     C                   EXSR      WritePBDtl                                                 CRE072
     C                   ENDIF                                                                CRE072
      *                                                                                       CRE072
     C                   ENDIF
     C/COPY WNCPYSRC,GLH00575

     C                   ENDSR
     C****************************************************************
      /EJECT
     C****************************************************************
     C*                                                              *
     C* AMEND  - Amend an Account                                    *
     C*                                                              *
     C****************************************************************
     C     AMEND         BEGSR
      *
      ** Check Account record
      *
     C     RehisKey      CHAIN     ACCBR                              8081
     C                   EVAL      *IN82 = '1'

      ** DATABASE ERROR

     C     *IN80         IFEQ      '1'
     C     *IN81         OREQ      '1'
     C                   MOVEL     DBerrKey      DBKEY
     C                   MOVEL     'ACCBR  '     DBFILE                         ************
     C                   MOVEL     '038'         DBASE                          * DBERR 038*
     C                   EXSR      SRERR                                        ************
     C                   END
     C                   IF        AC_TNLU<>AMTNLU
     C                   MOVEL     NATN          DBKEY
     C                   MOVEL     'MNATN  '     DBFILE                         ************
     C                   MOVEL     '039'         DBASE                          * DBERR 039*
     C                   EXSR      SRERR
     C                   END
      ** Store Old fields for comparisons
     C                   MOVEL(P)  ACCNTBR       B_ACCNT
      *
      ** Check (If need to) that the Retail details exist
      *
     C**********         IF        not *IN80 and AMACNO<>*zero                                203282
     C                   IF        not *IN80 and AMATYP = 'R'                                 203282
     C                   IF        BGNXST='Y' or BGNYST='Y'
     C     AccntKey      CHAIN     REIACDF                            8281
      ** DATABASE ERROR
     C     *IN82         IFEQ      '1'
     C     *IN81         OREQ      '1'
     C                   MOVEL     DBerrKey      DBKEY
     C                   MOVEL     'REIACD '     DBFILE                         ************
     C                   MOVEL     '040'         DBASE                          * DBERR 040*
     C                   EXSR      SRERR
     C                   END
     C                   IF        AC_TNLU<>AMTNLU
     C                   MOVEL     NATN          DBKEY
     C                   MOVEL     'MNATN  '     DBFILE                         ************
     C                   MOVEL     '041'         DBASE                          * DBERR 041*
     C                   EXSR      SRERR
     C                   END
      ** Store Old fields for comparisons
     C                   MOVEL(P)  REIAD         B_REIAD
     C                   ENDIF
     C                   ENDIF
      *
     C                   IF        not *IN82 and BGNXST='Y' or
     C                             not *IN82 and BGNYST='Y'
     C     RehisKey      CHAIN     RECOM                              8281
      ** DATABASE ERROR
     C     *IN82         IFEQ      '1'
     C     *IN81         OREQ      '1'
     C                   MOVEL     DBerrKey      DBKEY
     C                   MOVEL     'RECOMD '     DBFILE                         ************
     C                   MOVEL     '042'         DBASE                          * DBERR 042*
     C                   EXSR      SRERR
     C                   ENDIF
     C                   ENDIF

     C                   IF        not *IN82 and BGNXST='Y' or
     C                             not *IN82 and BGNYST='Y'
     C     AccntKey      CHAIN     REACRDF                            8281
      ** DATABASE ERROR
     C     *IN82         IFEQ      '1'
     C     *IN81         OREQ      '1'
     C                   MOVEL     DBerrKey      DBKEY
     C                   MOVEL     'REACRDF'     DBFILE                         ************
     C                   MOVEL     '043'         DBASE                          * DBERR 043*
     C                   EXSR      SRERR
     C                   ENDIF
     C                   ENDIF
      *
     C                   IF        not *IN82 and BGNXST='Y' or
     C                             not *IN82 and BGNYST='Y'
     C     RehisKey      CHAIN     REHISBL                            8281
      ** DATABASE ERROR
     C     *IN82         IFEQ      '1'
     C     *IN81         OREQ      '1'
     C                   MOVEL     DBerrKey      DBKEY
     C                   MOVEL     'REHISBL'     DBFILE                         ************
     C                   MOVEL     '044'         DBASE                          * DBERR 044*
     C                   EXSR      SRERR
     C                   ENDIF
     C                   ENDIF
      *
      ** Obtain the next available transaction number
      *
     C                   CALLB     'ZTNLU1'
     C                   PARM      *BLANK        Retrn
     C                   PARM                    NATN
      ** Database Error if ReturnCode not blank
      *
     C     Retrn         IFNE      *BLANK
     C                   MOVEL     NATN          DBKEY
     C                   MOVEL     'MNATN  '     DBFILE                         ************
     C                   MOVEL     '045'         DBASE                          * DBERR 045*
     C                   EXSR      SRERR
     C                   END
      *
      ** Update Account record
      *
MAH  C     Rehiskey      CHAIN     ACCBR                              80

      ** DATABASE ERROR

     C     *IN80         IFEQ      '1'
     C                   MOVEL     DBerrKey      DBKEY
     C                   MOVEL     'ACCNTAB'     DBFILE                         ************
     C                   MOVEL     '046'         DBASE                          * DBERR 046*
     C                   EXSR      SRERR
     C                   END
      ** Store Old fields for comparisons
     C*                  MOVEL(P)  ACCNTBR       B_ACCNT

     C                   EVAL      W_ANAM = AC_ANAM                                           CSD015
                                                                                              CSD015
     C                   EVAL      AC_MFFQ=AMMFFQ
     C                   EVAL      AC_ANAM=AMANAM
     C**********         EVAL      AC_STFQ=AMSTFQ                                             204105
     C                   EVAL      AC_ECFB=AMECFB
      *                                                                                       224697
      ** If Change of Frequency with new frequency 'E': extra carried
      ** forward balance equal to Ledger balance
      *                                                                                       224697
     C                   IF        AC_STFQ<>*BLANK
     C**********         IF        AC_STFQ<>'E' and AMSTFQ='E'                              MD027195
     C                   IF        BA_STFQ<>'E' and AMSTFQ='E'                              MD027195
     C                             and AC_ORED<>BJRDNB                                     AR1021393
     C/COPY WNCPYSRC,GLH00798
     C**********         Z-ADD     AC_LDBL       AC_ECFB                                    MD027195
     C     AccntKey      CHAIN     GLACBTL0                           31                    MD027195
     C                   EVAL      AC_ECFB=0                                                MD027195
     C                   IF        *IN31 = '0'                                              MD027195
     C                   Z-ADD     GL_LDBL       AC_ECFB                                    MD027195
     C                   ENDIF                                                              MD027195
      * If no statement has been produced yet, ECFB must be zero                            MD033852
     C                   IF        BA_LSTD = BA_DACO                                        MD033852
     C                   Z-ADD     0             AC_ECFB                                    MD033852
     C                   ENDIF                                                              MD033852
                                                                                            MD033852
     C                   Z-ADD     AC_LSTP       AC_EPNO                                      224697
     C                   ENDIF
      *                                                                                       224697
      ** If change of Frequency with new frequency NOT 'E':                                   224697
      ** C/f Stmt balance should be taken from Extras S/f Stmt bal                            224697
      ** and Last Statement Page no. from Extra Stat Page no.                                 224697
      *                                                                                       224697
     C                   IF        AC_STFQ='E' and AMSTFQ<>'E'                                224697
     C                   Z-ADD     AC_ECFB       AC_CFSB                                      224697
     C                   Z-ADD     AC_EPNO       AC_LSTP                                      224697
     C                   Z-ADD     AC_LMVD       AC_LSTD                                      224697
     C                   ENDIF                                                                224697
     C                   ENDIF
      *                                                                                       CTI005
     C     AC_NACSG      IFEQ      'T'                                                        CTI005
     C     AC_LCD        ANDNE     BJRDNB                                                     CTI005
     C                   EVAL      AC_NACSG = ' '                                             CTI005
     C                   END                                                                  CTI005
      *                                                                                       CTI005
     C                   EVAL      AC_STFQ=AMSTFQ                                             204105
     C                   EVAL      AC_NSTD=AMNSTD
     C                   EVAL      AC_STDY=AMSTDY
     C                   EVAL      AC_GLBT=AMGLBT
     C                   EVAL      AC_ADREF1=AMADREF1
     C                   EVAL      AC_ADREF2=AMADREF2
     C*****@Type         IFEQ      '1'                                                 203214 208437
     C                   TESTB     '4'           AMRETB                   31                AR891357
     C                   TESTB     '4'           AC_RETB                  32                AR891357
     C                   IF        *IN31 = *OFF AND                                         AR891357
     C                             *IN32 = *ON                                              AR891357
     C**********         EVAL      AC_LACD=RUNDT                                  AR891357 AR891357A
     C                   EVAL      AC_LACD=BJRDNB                                          AR891357A
     C                   END                                                                AR891357
     C                   EVAL      AC_RETB=AMRETB
     C**********         END                                                           203214 208437
     C                   EVAL      AC_PRFC=AMPRFC
     C                   EVAL      AC_ODSC=AMODSC
     C                   EVAL      AC_ODLN=AMODLN
     C                   EVAL      AC_ODED=AMODED
     C                   EVAL      AC_DLIM=AMDLIM
     C                   EVAL      AC_FACT=AMFACT
     C                   EVAL      AC_FCNO=AMFCNO
     C                   EVAL      AC_EFAC=AMEFAC
     C                   EVAL      AC_MINB=AMMINB
     C                   EVAL      AC_DRIB=AMDRIB
     C                   EVAL      AC_DRIS=AMDRIS
     C**********         EVAL      AC_OLDR=AMOLDR                                             215208
     C                   IF        AMDRCD <> 0                                                215208
     C                   EVAL      AC_OLDR=AMDRCD                                             215208
     C                   ENDIF                                                                215208
     C                   EVAL      AC_DRIC=AMDRIC
     C                   EVAL      AC_DRIF=AMDRIF
     C                   EVAL      AC_DRDY=AMDRDY
     C                   EVAL      AC_NDID=AMNDID
     C                   EVAL      AC_CRIB=AMCRIB
     C                   EVAL      AC_CRIS=AMCRIS
     C**********         EVAL      AC_OLCR=AMOLCR                                             215208
     C                   IF        AMCRCD <> 0                                                215208
     C                   EVAL      AC_OLCR=AMCRCD                                             215208
     C                   ENDIF                                                                215208
     C                   EVAL      AC_CRIC=AMCRIC
     C                   EVAL      AC_CRIF=AMCRIF
     C                   EVAL      AC_CRDY=AMCRDY
     C                   EVAL      AC_NCID=AMNCID
     C                   EVAL      AC_BRTCA=AMBRTCA
      ** If EMU Account Postings Narrative is on, move fields in.
     C                   IF        CEU013='Y'
     C                   EVAL      AC_EUSB=AMEUSB
     C                   ENDIF
      ** Save previous Change
     C                   Z-ADD     AC_LCD        WWLCD
     C                   Z-ADD     BJRDNB        AC_LCD
      ** If Amend over Insert the same day then keep as Insert today
     C                   IF        WWLCD=BJRDNB and AC_CHTP='I'
     C                             and AMCHTP='A'
     C                   EVAL      AC_CHTP='I'
     C                   ELSE
     C                   EVAL      AC_CHTP='A'
     C                   ENDIF
     C                   EVAL      AC_TNLU=AMTNLU
     C                   EVAL      AC_ENOC=AMENOC
     C                   EVAL      AC_PRFC=AMPRFC
     C                   EVAL      AC_PTFR=AMPTFR
      *
      ** If Midas/Trade Innovation is on then move TI fields in.
     C                   IF        BGN3ST = 'Y'
     C                   EVAL      AC_A5TIAC=AMA5TIAC
     C                   EVAL      AC_A5TIAN=AMA5TIAN
     C                   EVAL      AC_A5TIAS=AMA5TIAS
     C                   ENDIF
      *                                                                                     MD053978
      ** If CTI006 is on, save TI field                                                     MD053978
      *                                                                                     MD053978
     C                   IF        CTI006 = 'Y'                                             MD053978
     C                   EVAL      AC_A5TIAC = AMA5TIAC                                     MD053978
     C                   ENDIF                                                              MD053978
      *                                                                                     MD053978
      ** If International Banking Account Numer is on (CFT004)                  CFT004
      ** move field in.                                                         CFT004
     C                   IF        CFT004='Y'                                   CFT004
     C                   EVAL      AC_IBAN=AMIBAN                               CFT004
     C                   EVAL      AC_IBSEQN=AMIBSEQN                           CFT004
     C                   ENDIF                                                  CFT004
      ** Front Office ID
     C                   EVAL      AC_FRNT=AMFRNT
      ** Associated Front Office ID
     C                   EVAL      AC_AFRT=AMAFRT
      ** Repair Location
     C                   EVAL      AC_REPA=AMREPA
      ** Timestamp
     C                   CALLB     'ZAGENTMSTM'
     C                   PARM                    TimeStamp

     C                   EVAL      AC_TMST = TimeStamp
      *                                                                         CPB001
      ** Reset Replication flag                                                 CPB001
     C                   EVAL      AC_REPI = ' '                                CPB001
                                                                                              CSD015
      ** If CSD015 = 'Y' and Watch List Checking is Applied                                   CSD015
                                                                                              CSD015
     C                   IF        CSD015 = 'Y'                                               CSD015
     C                             AND W1EWLC = 'Y'                                           CSD015
                                                                                              CSD015
      ** If user is in the main system                                                        CSD015
                                                                                              CSD015
     C                   IF        CSC011 <> 'Y'                                              CSD015
     C                             OR CSC011 = 'Y' AND S1MAIN = LIBR                          CSD015
                                                                                              CSD015
      ** Access SDCWHTPD using fucntion type 'GLAMAD', identifier                             CSD015
      ** PIdentifier, branch AC_BRCA to verify Hit Unconfirmed Flag                           CSD015
                                                                                              CSD015
     C                   EVAL      WFuncType = 'ACCNTAB'                                      CSD015
     C                   MOVE      AC_CNUM       WCust                                        CSD015
     C                   MOVE      AC_ACOD       WAcod                                        CSD015
     C                   MOVE      AC_ACSQ       WAcsq                                        CSD015
     C                   EVAL      WIdntifier = AC_BRCA + WCust +                             CSD015
     C                             AC_CCY + WAcod + WAcsq                                     CSD015
     C                   EVAL      WBranch = AC_BRCA                                          CSD015
                                                                                              CSD015
      ** Access logical file based on SDCWHTPD to verify Hit Status.                          CSD015
      ** Move blanks to hit status if record is not found.                                    CSD015
                                                                                              CSD015
     C     KCwFld        CHAIN     SDCWHTL1                                                   CSD015
                                                                                              CSD015
      ** Execute SRWTCH if there is a change in the account name                              CSD015
      ** or Hit Status is 'UNCONFRMED'                                                        CSD015
                                                                                              CSD015
     C                   IF        %FOUND(SDCWHTL1) and W3UNCF = 'Y'                          CSD015
     C                             or W_ANAM <> AC_ANAM                                       CSD015
     C                   EXSR      SRWTCH                                                     CSD015
     C                   ENDIF                                                                CSD015
                                                                                              CSD015
     C                   ENDIF                                                                CSD015
     C                   ENDIF                                                                CSD015
                                                                                              CLE025
      ** If CLE025 is on, set Facility Customer field                                         CLE025
                                                                                              CLE025
     C                   IF        CLE025 = 'Y'                                               CLE025
                                                                                              CLE025
     C**********         IF        AMFCCU <> *ZERO                                     CLE025 CSD027
     C                   IF        AMFCCU <> *BLANKS                                          CSD027
     C                   EVAL      AC_FCCU = AMFCCU                                           CLE025
     C                   ELSE                                                                 CLE025
                                                                                              CLE025
     C                   IF        AMFACT <> *ZERO  AND  AMFCNO <> *ZERO                      CLE025
     C                   EVAL      AC_FCCU = AMCNUM                                           CLE025
     C                   ELSE                                                                 CLE025
     C**********         EVAL      AC_FCCU = *ZERO                                     CLE025 CSD027
     C                   EVAL      AC_FCCU = *BLANKS                                          CSD027
     C                   ENDIF                                                                CLE025
                                                                                              CLE025
     C                   ENDIF                                                                CLE025
     C                   ENDIF                                                                CLE025
      *                                                                                      BUG3365
      ** Setup TI Branch Number                                                              BUG3365
     C                   IF        AC_A5TIAC = 'Y'                                           BUG3365
      *                                                                                      BUG3365
     C                   CALL      'AOBRCHR1'                                                BUG3365
     C                   PARM      *BLANKS       @RTCD                                       BUG3365
     C                   PARM      '*KEY   '     @OPTN                                       BUG3365
     C                   PARM      AC_BRCA       @BRCH             3                         BUG3365
     C     SDBRCH        PARM      SDBRCH        DSSDY                                       BUG3365
      *                                                                                      BUG3365
      ** Record found                                                                        BUG3365
     C                   IF        @RTCD = *BLANKS                                           BUG3365
     C                   EVAL      AC_A5TIAB = DS_A8TIBR                                     BUG3365
     C                   ENDIF                                                               BUG3365
     C                   ELSE                                                                BUG3365
     C                   EVAL      AC_A5TIAB = *BLANKS                                       BUG3365
     C                   ENDIF                                                               BUG3365
      *
      ** Automatic Authorisation flag                                                         CAP086
                                                                                              CAP086
     C                   IF        CAP086 = 'Y'                                               CAP086
     C                   EVAL      AC_AUTH = AMAUTH                                           CAP086
     C                   ENDIF                                                                CAP086
                                                                                              CAP086
      *                                                                                       CER047
      ** Subject to KWG §24c reporting                                                        CER047
      *                                                                                       CER047
     C                   IF        CER047 = 'Y'                                               CER047
     C                   EVAL      AC_K24C=AMK24C                                             CER047
     C                   ENDIF                                                                CER047
      *                                                                                       CER047
      ** Effective date for Retail Accounts                                                   CRE075
      *                                                                                       CRE075
     C                   IF        CRE075 = 'Y'                                               CRE075
     C                   EVAL      AC_ACEFDT = AMEFDT                                         CRE075
     C                   ELSE                                                               AR818450
     C                   EVAL      AC_ACEFDT = *ZEROS                                       AR818450
     C                   ENDIF                                                                CRE075
      *                                                                                       CRE075
      ** CRE073 related fields                                                                CRE073
      *                                                                                       CRE073
     C                   IF        CRE073 = 'Y'                                               CRE073
     C                   EVAL      AC_DCSP = AMDCSP                                           CRE073
     C                   EVAL      AC_DCSG = AMDCSG                                           CRE073
     C                   EVAL      AC_DRMT = AMDRMT                                           CRE073
     C                   EVAL      AC_DRFD = AMDRFD                                           CRE073
     C                   EVAL      AC_CCSP = AMCCSP                                           CRE073
     C                   EVAL      AC_CCSG = AMCCSG                                           CRE073
     C                   EVAL      AC_CRMT = AMCRMT                                           CRE073
     C                   EVAL      AC_CRFD = AMCRFD                                           CRE073
     C                   ELSE                                                                 CRE073
     C                   EVAL      AC_DCSP = *ZEROS                                           CRE073
     C                   EVAL      AC_CCSP = *ZEROS                                           CRE073
     C                   ENDIF                                                                CRE073
      *                                                                                       CRE073
      ** UPDATE Account
     C                   UPDATE    ACCNTABF
                                                                                            BUG22973
      ** Return the timestamp                                                               BUG22973
                                                                                            BUG22973
     C                   EVAL      AMTMST = Timestamp                                       BUG22973
      *
      ** Update Retail Fields
      *
     C                   EXSR      UpdateRet
      *                                                                                       CRE072
      ** Write Account to Passbook Update Control Detail                                      CRE072
      *                                                                                       CRE072
     C                   IF        CRE072 = 'Y' AND                                           CRE072
     C                             AC_ATYP = 'R' AND                                          CRE072
     C                             AC_STYP = 'S'                                              CRE072
     C                   EXSR      WritePBDtl                                                 CRE072
     C                   ENDIF                                                                CRE072

     C                   ENDSR
     C****************************************************************
      /EJECT
     C****************************************************************                        CRE072
     C*                                                              *                        CRE072
     C* WritePBDtl                                                   *                        CRE072
     C*                                                              *                        CRE072
     C****************************************************************                        CRE072
     C     WritePBDtl    BEGSR                                                                CRE072
      *                                                                                       CRE072
     C                   CALL      'RE004248'                                                 CRE072
     C                   PARM      '*NEW   '     POptn                                        CRE072
     C                   PARM                    CustNum                                      CRE072
     C                   PARM                    Currency                                     CRE072
     C                   PARM                    AccCode                                      CRE072
     C                   PARM                    AccSeq                                       CRE072
     C                   PARM                    Branch                                       CRE072
     C                   PARM      *BLANKS       PRtCd                                        CRE072
      *                                                                                       CRE072
     C                   IF        PRtCd <> *BLANKS                                           CRE072
     C     *LOCK         IN        LDA                                                        CRE072
     C                   EVAL      DBFILE =  'RE004248'                                       CRE072
     C                   EVAL      DBKEY  =  DBerrKey                                         CRE072
     C                   EVAL      DBASE  =  6                                                CRE072
     C                   OUT       LDA                                                        CRE072
     C                   EXSR      *PSSR                                                      CRE072
     C                   ENDIF                                                                CRE072
      *                                                                                       CRE072
     C                   ENDSR                                                                CRE072
     C****************************************************************                        CRE072
      /EJECT                                                                                  CRE072
     C****************************************************************
     C*                                                              *
     C* DELETE - Delete an Account                                   *
     C*                                                              *
     C****************************************************************
     C     DELETE        BEGSR

      *
      ** Check Account record
      *
     C     RehisKey      CHAIN     ACCBR                              8081

      ** DATABASE ERROR

     C     *IN80         IFEQ      '1'
     C     *IN81         OREQ      '1'
     C                   MOVEL     DBerrKey      DBKEY
     C                   MOVEL     'ACCBR  '     DBFILE                         ************
     C                   MOVEL     '070'         DBASE                          * DBERR 070*
     C                   EXSR      SRERR                                        ************
     C                   ELSE
      ** Save LCD and CHTP
     C                   EVAL      WWLCD=AC_LCD
     C                   EVAL      WWCHTP=AC_CHTP
      *
     C                   EVAL      AC_ACST='C'
     C                   EVAL      AC_LCD=BJRDNB
     C                   EVAL      AC_DACC=BJRDNB
     C                   EVAL      AC_CHTP='C'
      ** Obtain the next available transaction number in TNLU
      *
     C                   EVAL      NATN=*ZERO
     C                   CALLB     'ZTNLU1'
     C                   PARM      *BLANK        Retrn
     C                   PARM                    NATN
      ** Database Error if ReturnCode not blank
      *
     C     Retrn         IFNE      *BLANK
     C                   MOVEL     NATN          DBKEY
     C                   MOVEL     'MNATN  '     DBFILE                         ************
     C                   MOVEL     '071'         DBASE                          * DBERR 071*
     C                   EXSR      SRERR                                        ************
     C                   END
     C                   EVAL      AC_TNLU=NATN
      ** Timestamp
     C                   CALLB     'ZAGENTMSTM'
     C                   PARM                    TimeStamp

     C                   EVAL      AC_TMST = TimeStamp
      ** Front Office ID                                                        CAP013
     C                   EVAL      AC_FRNT=AMFRNT                               CAP013
      ** Associated Front Office ID                                             CAP013
     C                   EVAL      AC_AFRT=AMAFRT                               CAP013
      *                                                                         CPB001
      ** Reset Replication flag                                                 CPB001
     C                   EVAL      AC_REPI = ' '                                CPB001

     C                   UPDATE    ACCNTABF
                                                                                            BUG22973
      ** Return the timestamp                                                               BUG22973
                                                                                            BUG22973
     C                   EVAL      AMTMST = Timestamp                                       BUG22973
     C                   ENDIF
     C/COPY WNCPYSRC,GLH00576
      *
      ** WRITE Account trailer record
      *
     C*****1****         SETLL     ACCNTAC                                                    260323
     C**********         READ      ACCNTAC                              8180                  260323
     C                   MOVE      '0'           *IN81                                        260323
     C     1             CHAIN     ACCNTAC                            80                      260323

      ** DATABASE ERROR

     C     *IN81         IFEQ      '1'
     C     *IN80         OREQ      '1'
     C                   EVAL      DBKEY='1'
     C                   MOVEL     'ACCNTAC'     DBFILE                         ************
     C                   MOVEL     '072'         DBASE                          * DBERR 072*
     C                   EXSR      SRERR                                        ************
     C                   ENDIF

     C     *IN80         IFEQ      '0'
     C                   ADD       1             C_NOCL
     C                   SUB       1             C_NOAU
     C**********         IF        WWLCD=BJRDNB and WWCHTP='I'                                244106
     C**********         ADD       1             C_NORE                                       244106
     C**********         SUB       1             C_NINU                                       244106
     C**********         ENDIF                                                                244106

     C                   IF        WWLCD=BJRDNB and WWCHTP='A'
     C                   SUB       1             C_NOAM
     C                   ENDIF
      ** Force Rundate in LCD
     C                   EVAL      C_LCD=BJRDNB
     C                   EVAL      C_TNLU=NATN
     C                   UPDATE    ACCNTCXF
     C                   ENDIF

     C                   ENDSR
     C****************************************************************
      /EJECT
     C****************************************************************
     C*                                                              *
     C* WriteRet - WRITE Retail details for Insert                   *
     C*                                                              *
     C****************************************************************
     C     WriteRet      BEGSR
      *
      ** If Account is Retail and/or Interest on Accounts 3 is ON
      *
     C                   IF        BGNYST = 'Y' or BGNXST ='Y'
      *
      ** Insert Retail record
      *
     C     AccntKey      CHAIN     REIACDF                            80

      ** DATABASE ERROR
     C     *IN80         IFEQ      '0'
     C                   MOVEL     DBerrKey      DBKEY
     C                   MOVEL     'REIACD '     DBFILE                         ************
     C                   MOVEL     '006'         DBASE                          * DBERR 006*
     C                   EXSR      SRERR                                        ************
     C                   END
      ** Store Old fields for comparisons
     C                   MOVEL(P)  REIAD         B_REIAD

     C                   CLEAR                   REIACDF                                      CRE101
     C                   EVAL      RE_RECI='D'
     C                   EVAL      RE_CNUM=AMCNUM
     C                   EVAL      RE_CCY=AMCCY
     C                   EVAL      RE_ACOD=AMACOD
     C                   EVAL      RE_ACSQ=AMACSQ
     C                   EVAL      RE_BRCA=AMBRCA
     C                   EVAL      RE_DICT=RIDICT
     C                   EVAL      RE_DCST=RIDCST
     C                   EVAL      RE_DACP=RIDACP
     C                   EVAL      RE_DICP=*BLANKS
     C                   EVAL      RE_CICT=RICICT
     C                   EVAL      RE_CCST=RICCST
     C                   EVAL      RE_CACP=RICACP
     C                   EVAL      RE_CICP=*BLANKS
     C                   EVAL      RE_CHGT=RICHGT
     C                   EVAL      RE_CHST=RICHST
     C                   EVAL      RE_CHAC=RICHAC
     C                   EVAL      RE_PTRA=RIPTRA
     C                   EVAL      RE_PRCH=RIPRCH
      ** If Retail Teller Or Retail Branch Access is on
     C                   IF        CRT001='Y' or CRT002='Y'
     C                   EVAL      RE_PBKU=RIPBKU
     C                   ENDIF
     C                   EVAL      RE_NRCA=*ZERO
     C                   EVAL      RE_RCA=*ZERO
     C                   EVAL      RE_MCLB=*ZERO
     C                   EVAL      RE_ZZ015=*BLANKS
     C                   EVAL      RE_NOALT=*ZERO
     C                   EVAL      RE_TCHO=RITCHO
     C                   EVAL      RE_DRBR=RIDRBR
     C                   EVAL      RE_CRBR=RICRBR
     C                   EVAL      RE_CHBR=RICHBR
     C                   EVAL      RE_TRCH = *ZEROS                                         AR818450
     C                   EVAL      RE_STCC = *ZEROS                                         AR818450
     C                   EVAL      RE_STPF1 = *BLANKS                                       AR818450
     C                   WRITE     REIACDF
      *
      ** Update Retail record for Alternate Accounts
      *
     C                   IF        RIDACP<>*BLANKS
     C                   CLEAR                   RetKeyDS
     C                   MOVEL     RIDACP        RetKeyDS
     C                   MOVEL     RIDRBR        Branch1                                      208006
      *                                                                                       237346
     C     AccKyk1       IFEQ      *BLANK                                                     237346
     C                   Z-ADD     RetKK1        WKEY             10 0                        237346
      *                                                                                       237346
     C     WKEY          CHAIN     ACNUMA                             80                      237346
     C     *IN80         IFEQ      '0'                                                        237346
     C                   MOVE      AN_CNUM       CustNum1                                     237346
     C                   MOVE      AN_CCY        Currency1                                    237346
     C                   MOVE      AN_ACOD       AccCode1                                     237346
     C                   MOVE      AN_ACSQ       AccSeq1                                      237346
     C                   MOVE      AN_BRCA       Branch1                                      237346
     C                   END                                                                  237346
      *                                                                                       237346
     C                   END                                                                  237346
      *                                                                                       237346
     C     RetKey        CHAIN     REIACDF                            8081

      ** DATABASE ERROR
     C     *IN81         IFEQ      '1'
     C                   MOVEL     RetKeyDS      DBKEY
     C                   MOVEL     'REIACD '     DBFILE                         ************
     C                   MOVEL     '007'         DBASE                          * DBERR 007*
     C                   EXSR      SRERR                                        ************
     C                   END

     C     *IN80         IFEQ      '0'
     C                   ADD       1             RE_NOALT
     C                   UPDATE    REIACDF
      ** Update ALTI on B Record
     C     RE_NOALT      IFEQ      1
     C*****RehisKey      CHAIN     REHISBL                            8081                    237346
     C     RehisAlt      CHAIN     REHISBL                            8081                    237346
      ** DATABASE ERROR
     C     *IN81         IFEQ      '1'
     C                   MOVEL     DBerrKey      DBKEY
     C                   MOVEL     'REHISBL'     DBFILE                         ************
     C                   MOVEL     '008'         DBASE                          * DBERR 008*
     C                   EXSR      SRERR                                        ************
     C                   ENDIF
     C     *IN80         IFEQ      '0'
     C                   EVAL      RH_ALTI='Y'
     C                   UPDATE    REHISPPF
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
      *
      ** Update Retail record for Alternate Accounts
      *
     C                   IF        RICACP<>*BLANKS
     C                   CLEAR                   RetKeyDS
     C                   MOVEL     RICACP        RetKeyDS
     C                   MOVEL     RICRBR        Branch1                                      208006
      *                                                                                       237346
     C     AccKyk1       IFEQ      *BLANK                                                     237346
     C                   Z-ADD     RetKK1        WKEY             10 0                        237346
      *                                                                                       237346
     C     WKEY          CHAIN     ACNUMA                             80                      237346
     C     *IN80         IFEQ      '0'                                                        237346
     C                   MOVE      AN_CNUM       CustNum1                                     237346
     C                   MOVE      AN_CCY        Currency1                                    237346
     C                   MOVE      AN_ACOD       AccCode1                                     237346
     C                   MOVE      AN_ACSQ       AccSeq1                                      237346
     C                   MOVE      AN_BRCA       Branch1                                      237346
     C                   END                                                                  237346
      *                                                                                       237346
     C                   END                                                                  237346
      *                                                                                       237346
     C     RetKey        CHAIN     REIACDF                            8081

      ** DATABASE ERROR
     C     *IN81         IFEQ      '1'
     C                   MOVEL     RetKeyDS      DBKEY
     C                   MOVEL     'REIACD '     DBFILE                         ************
     C                   MOVEL     '009'         DBASE                          * DBERR 009*
     C                   EXSR      SRERR                                        ************
     C                   END

     C     *IN80         IFEQ      '0'
     C                   ADD       1             RE_NOALT
     C                   UPDATE    REIACDF
      ** Update ALTI on B Record
     C     RE_NOALT      IFEQ      1
     C*****RehisKey      CHAIN     REHISBL                            8081                    237346
     C     RehisAlt      CHAIN     REHISBL                            8081                    237346
      ** DATABASE ERROR
     C     *IN81         IFEQ      '1'
     C                   MOVEL     DBerrKey      DBKEY
     C                   MOVEL     'REHISBL'     DBFILE                         ************
     C                   MOVEL     '010'         DBASE                          * DBERR 010*
     C                   EXSR      SRERR                                        ************
     C                   ENDIF
     C     *IN80         IFEQ      '0'
     C                   EVAL      RH_ALTI='Y'
     C                   UPDATE    REHISPPF
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
      *
      ** Update Retail record for Alternate Accounts
      *
     C                   IF        RICHAC<>*BLANKS
     C                   CLEAR                   RetKeyDS
     C                   MOVEL     RICHAC        RetKeyDS
     C                   MOVEL     RICHBR        Branch1                                      208006
      *                                                                                       237346
     C     AccKyk1       IFEQ      *BLANK                                                     237346
     C                   Z-ADD     RetKK1        WKEY             10 0                        237346
      *                                                                                       237346
     C     WKEY          CHAIN     ACNUMA                             80                      237346
     C     *IN80         IFEQ      '0'                                                        237346
     C                   MOVE      AN_CNUM       CustNum1                                     237346
     C                   MOVE      AN_CCY        Currency1                                    237346
     C                   MOVE      AN_ACOD       AccCode1                                     237346
     C                   MOVE      AN_ACSQ       AccSeq1                                      237346
     C                   MOVE      AN_BRCA       Branch1                                      237346
     C                   END                                                                  237346
      *                                                                                       237346
     C                   END                                                                  237346
      *                                                                                       237346
     C     RetKey        CHAIN     REIACDF                            8081

      ** DATABASE ERROR
     C     *IN81         IFEQ      '1'
     C                   MOVEL     RetKeyDS      DBKEY
     C                   MOVEL     'REIACD '     DBFILE                         ************
     C                   MOVEL     '011'         DBASE                          * DBERR 011*
     C                   EXSR      SRERR                                        ************
     C                   END

     C     *IN80         IFEQ      '0'
     C                   ADD       1             RE_NOALT
     C                   UPDATE    REIACDF
      ** Update ALTI on B Record
     C     RE_NOALT      IFEQ      1
     C*****RehisKey      CHAIN     REHISBL                            8081                    237346
     C     RehisAlt      CHAIN     REHISBL                            8081                    237346
      ** DATABASE ERROR
     C     *IN81         IFEQ      '1'
     C                   MOVEL     DBerrKey      DBKEY
     C                   MOVEL     'REHISBL'     DBFILE                         ************
     C                   MOVEL     '012'         DBASE                          * DBERR 012*
     C                   EXSR      SRERR                                        ************
     C                   ENDIF
     C     *IN80         IFEQ      '0'
     C                   EVAL      RH_ALTI='Y'
     C                   UPDATE    REHISPPF
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
      *
      ** Write Retail Commissions file
      *
     C     RehisKey      CHAIN     RECOM                              8081
      ** DATABASE ERROR
     C     *IN80         IFEQ      '0'
     C     *IN81         OREQ      '1'
     C                   MOVEL     DBerrKey      DBKEY
     C                   MOVEL     'RECOMD '     DBFILE                         ************
     C                   MOVEL     '013'         DBASE                          * DBERR 013*
     C                   EXSR      SRERR                                        ************
     C                   ENDIF
     C                   CLEAR                   RECOMDF                                      CRE101
     C                   EVAL      RC_RECI='D'
     C                   EVAL      RC_CNUM=RICNUM
     C                   EVAL      RC_CCY=RICCY
     C                   EVAL      RC_ACOD=RIACOD
     C                   EVAL      RC_ACSQ=RIACSQ
     C                   EVAL      RC_ACSQ=RIACSQ
     C                   EVAL      RC_BRCA=RIBRCA
     C                   EVAL      RC_FXDC=*ZERO
     C                   EVAL      RC_ACCEA=*ZERO
     C                   EVAL      RC_ACCC=*ZERO
     C                   EVAL      RC_GVDPE=*ZERO
     C                   EVAL      RC_GVDPC=*ZERO
     C                   EVAL      RC_ACCRA=*ZERO
     C                   EVAL      RC_MMACC=*BLANKS
     C                   EVAL      RC_CACCC=*ZEROS
     C                   EVAL      RC_CDIE=*ZEROS
     C                   EVAL      RC_CDICA=*ZEROS
     C                   EVAL      RC_CDRR=*ZEROS
     C                   EVAL      RC_MMCDI=*BLANKS
     C                   EVAL      RC_CCDIC=*ZEROS
     C                   EVAL      RC_IACE=*ZEROS
     C                   EVAL      RC_IACCC=*ZEROS
     C                   EVAL      RC_CIACC=*ZEROS
     C                   EVAL      RC_CMBE=*ZEROS
     C                   EVAL      RC_CMBC=*ZEROS
     C                   EVAL      RC_ACCB=*ZEROS
     C                   EVAL      RC_CCMBC=*ZEROS
     C                   EVAL      RC_CHDBE=*ZEROS
     C                   EVAL      RC_CHDBC=*ZEROS
     C                   EVAL      RC_HDRB=*ZEROS
     C                   EVAL      RC_CHDBR=*ZEROS
     C                   EVAL      RC_MMCHDB=*BLANKS
     C                   EVAL      RC_CCHDBC=*ZEROS
     C                   EVAL      RC_CACDC=*BLANKS
     C                   EVAL      RC_CCINST=*ZEROS
     C                   EVAL      RC_TEGRT=*ZEROS
     C                   EVAL      RC_VATAM=*ZEROS
     C                   IF        COCEXA=*BLANKS
     C                   EVAL      RC_CEXA=*BLANKS
     C                   EVAL      RC_CHDBE=*ZEROS
     C                   EVAL      RC_CHDBC=*ZEROS
     C                   EVAL      RC_HDRB=*ZEROS
     C                   EVAL      RC_CHDBR=*ZEROS
     C                   EVAL      RC_CCHDBC=*ZEROS
     C                   ELSE
     C                   EVAL      RC_CEXA=COCEXA
     C                   ENDIF
     C                   IF        COCEXB=*BLANKS
     C                   EVAL      RC_CEXB=*BLANKS
     C                   EVAL      RC_ACCEA=*ZEROS
     C                   EVAL      RC_ACCC=*ZEROS
     C                   EVAL      RC_GVDPE=*ZEROS
     C                   EVAL      RC_GVDPC=*ZEROS
     C                   EVAL      RC_ACCRA=*ZEROS
     C                   EVAL      RC_CACCC=*ZEROS
     C                   ELSE
     C                   EVAL      RC_CEXB=COCEXB
     C                   ENDIF
     C                   IF        COCEXC=*BLANKS
     C                   EVAL      RC_CEXC=*BLANKS
     C                   EVAL      RC_CDIE=*ZEROS
     C                   EVAL      RC_CDICA=*ZEROS
     C                   EVAL      RC_CDRR=*ZEROS
     C                   EVAL      RC_CCDIC=*ZEROS
     C                   ELSE
     C                   EVAL      RC_CEXC=COCEXC
     C                   ENDIF
     C                   IF        COCEXD=*BLANKS
     C                   EVAL      RC_CEXD=*BLANKS
     C                   EVAL      RC_IACE=*ZEROS
     C                   EVAL      RC_IACCC=*ZEROS
     C                   EVAL      RC_CIACC=*ZEROS
     C                   ELSE
     C                   EVAL      RC_CEXD=COCEXD
     C                   ENDIF
     C                   IF        COCEXE=*BLANKS
     C                   EVAL      RC_CEXE=*BLANKS
     C                   EVAL      RC_CMBE=*ZEROS
     C                   EVAL      RC_CMBC=*ZEROS
     C                   EVAL      RC_ACCB=*ZEROS
     C                   EVAL      RC_CCMBC=*ZEROS
     C                   ELSE
     C                   EVAL      RC_CEXE=COCEXE
     C                   ENDIF
     C                   IF        COCEXF=*BLANKS
     C                   EVAL      RC_CEXF=*BLANKS
     C                   EVAL      RC_CCINST=*ZEROS
     C                   EVAL      RC_NOIS=*ZEROS
     C                   EVAL      RC_NOCC=*ZEROS
     C                   EVAL      RC_PESP=*ZEROS
     C                   ELSE
     C                   EVAL      RC_CEXF=COCEXF
     C                   ENDIF
     C                   IF        COCEXG=*BLANKS
     C                   EVAL      RC_CEXG=*BLANKS
     C                   EVAL      RC_FXDC=*ZEROS
     C                   ELSE
     C                   EVAL      RC_CEXG=COCEXG
     C                   ENDIF
     C                   Z-ADD     CONOCC        RC_NOCC
     C                   EVAL      RC_PESP=*ZERO
     C                   EVAL      RC_NOIP=*ZEROS                                             215952
     C                   EVAL      RC_NOIS=*ZEROS                                             256533
     C                   EVAL      RC_CHCO = *ZEROS                                         AR818450
     C                   EVAL      RC_STPF2 = *BLANKS                                       AR818450
     C                   WRITE     RECOMDF
      *
     C                   ENDIF
      ** Write Retail Accrued Interest File
      *
     C     AccntKey      CHAIN     REACRDF                            8081
      ** DATABASE ERROR
     C     *IN80         IFEQ      '0'
     C     *IN81         OREQ      '1'
     C                   MOVEL     DBerrKey      DBKEY
     C                   MOVEL     'REACRD '     DBFILE                         ************
     C                   MOVEL     '014'         DBASE                          * DBERR 014*
     C                   EXSR      SRERR                                        ************
     C                   ENDIF
     C                   CLEAR                   REACRDF                                      CRE101
     C                   EVAL      RA_RECI='D'
     C                   EVAL      RA_CUST=AMCNUM
     C                   EVAL      RA_ACCY=AMCCY
     C                   EVAL      RA_ACOD=AMACOD
     C                   EVAL      RA_ASEQ=AMACSQ
     C                   EVAL      RA_BRCA=AMBRCA
     C                   EVAL      RA_ZZ011=*BLANKS
     C                   EVAL      RA_ZZ022=*BLANKS
     C                   EVAL      RA_MNBL=*ZEROS
     C                   EVAL      RA_TNLU=NATN
     C                   EVAL      RA_ORED=BJRDNB
     C                   EVAL      RA_LCD=BJRDNB
     C                   EVAL      RA_CHTP='I'
     C                   EVAL      RA_DAIC1=*ZEROS
     C                   EVAL      RA_MADI=*ZEROS
     C                   EVAL      RA_GADI=*ZEROS
     C                   EVAL      RA_CAIC1=*ZEROS
     C                   EVAL      RA_MACI=*ZEROS
     C                   EVAL      RA_GACI=*ZEROS
     C                   EVAL      RA_HISB=*ZEROS
     C                   EVAL      RA_BFDR=*ZEROS
     C                   EVAL      RA_BFCR=*ZEROS
     C                   EVAL      RA_TDINT=*ZEROS
     C                   EVAL      RA_TCINT=*ZEROS
     C                   EVAL      RA_TEGLIS=*ZEROS
     C                   EVAL      RA_POSTI=*BLANKS
     C                   WRITE     REACRDF
      *
      ** Update Retail Accrued Interest Trailer File
      *
     C     1             SETLL     REACRZ
     C                   READ      REACRZ                               8180
      ** DATABASE ERROR
     C     *IN80         IFEQ      '1'
     C     *IN81         OREQ      '1'
     C                   EVAL      DBKEY='1'
     C                   MOVEL     'REACRZ '     DBFILE                         ************
     C                   MOVEL     '015'         DBASE                          * DBERR 015*
     C                   EXSR      SRERR                                        ************
     C                   ENDIF
     C                   ADD       1             RZ_NORE
     C                   Z-ADD     NATN          RZ_TNLU
     C                   UPDATE    REACRZF
      *
      ** If CRE001 (Overdraft Interest Calculations) is installed and
      ** Account is Retail
      ** OR CDE002 is installed and Account is Retail                           CDE002
      *
     C**********         IF        CRE001='Y' and AMATYP='R'                                  239720
     C**********                   or (CDE002='Y' and AMATYP='R')               CDE002        239720
      *
      ** Update Account Master Extension File
      *
     C     AccntKey      CHAIN     ACCNTBXC                           8081
      ** DATABASE ERROR
     C     *IN80         IFEQ      '1'
     C     *IN81         OREQ      '1'
     C                   MOVEL     DBerrKey      DBKEY
     C                   MOVEL     'ACCNTBXC'    DBFILE                         ************
     C                   MOVEL     '016'         DBASE                          * DBERR 016*
     C                   EXSR      SRERR                                        ************
     C                   ENDIF
      ** Store Old fields for comparisons
     C                   MOVEL(P)  ACCNTX        B_ACCNTX

     C                   EVAL      AX_ATAODR=BXAODR
     C                   EVAL      AX_ATORTC=BXORTC
     C                   EVAL      AX_ATOLVD=BXOLVD
     C                   EVAL      AX_ATITRD=BXITRD
     C                   EVAL      AX_ATPOLE=*ZEROS
      * If Overdraft Line Change Value Date is <= Value Date
     C                   IF        BXOLVD<=BJRDNB
     C                   Z-ADD     BXOLVD        AX_ATPOLC
     C                   ENDIF
      ** Front Office ID                                                        CAP013
     C                   EVAL      AX_ATFRNT=BXFRNT                             CAP013
      ** Associated Front Office ID                                             CAP013
     C                   EVAL      AX_ATAFRT=BXAFRT                             CAP013
      ** Timestamp                                                              CAP013
     C                   EVAL      AX_ATTMST=BXTMES                             CAP013
      *                                                                         CDE002
      ** If CDE002 is present update Cr/Dr Margin fields                        CDE002
      *                                                                         CDE002
     C                   IF        CDE002 = 'Y'                                 CDE002
      *                                                                         CDE002
     C                   EVAL      AX_ATACNO = AMACNO                           CDE002
     C                   EVAL      AX_ATOVRD = BXOVRD                           CDE002
     C                   EVAL      AX_ATOVRC = BXOVRC                           CDE002
     C                   EVAL      AX_ATDRMG = BXDRMG                           CDE002
     C                   EVAL      AX_ATCRMG = BXCRMG                           CDE002
     C                   EVAL      AX_ATDMBR = BXDMBR                           208221
     C                   EVAL      AX_ATCMBR = BXCMBR                           208221
      *                                                                         CDE002
      ** If Debit Margin Override is 'Y' Change Date is run date                CDE002
      *                                                                         CDE002
     C                   IF        BXOVRD = 'Y'                                 CDE002
     C                   EVAL      AX_ATDRMD = BJRDNB                           CDE002
     C                   ELSE                                                   CDE002
     C                   EVAL      AX_ATDRMD = 0                                CDE002
     C                   ENDIF                                                  CDE002
     C                                                                          CDE002
      ** If Credit Margin Override is 'Y' Change Date is run date               CDE002
      *                                                                         CDE002
     C                   IF        BXOVRC = 'Y'                                 CDE002
     C                   EVAL      AX_ATCRMD = BJRDNB                           CDE002
     C                   ELSE                                                   CDE002
     C                   EVAL      AX_ATCRMD = 0                                CDE002
     C                   ENDIF                                                  CDE002
                                                                                CDE002
     C                   ENDIF                                                  CDE002
                                                                                CDE002
      *                                                                                       CER050
     C                   If        CER050 = 'Y'                                               CER050
     C                   Eval      AX_ATAPRC = BXAPRC                                         CER050
     C                   Endif                                                                CER050
      *                                                                                       CER050
     C                   UPDATE    ACCNTBD0
      *                                                                                       239720
     C                   IF        CRE001='Y' and AMATYP='R'                                  239720
     C                             or (CDE002='Y' and AMATYP='R')                             239720
      *
      ** If Overdraft present (Expiry Date Entered) write REODHSPD
      *
     C     AMODED        IFNE      *ZERO
     C     REODHKey      CHAIN     REODHSL0                           8081
      ** DATABASE ERROR
     C     *IN80         IFEQ      '0'
     C     *IN81         OREQ      '1'
     C                   MOVEL     DBerrKey      DBKEY
     C                   MOVEL     'REODHSL0'    DBFILE                         ************
     C                   MOVEL     '017'         DBASE                          * DBERR 017*
     C                   EXSR      SRERR                                        ************
     C                   ENDIF
     C                   CLEAR                   REODHSD0                                     CRE101
     C                   EVAL      RO_BRCA=BXBRCA
     C                   EVAL      RO_CNUM=BXCNUM
     C                   EVAL      RO_CCY =BXCCY
     C                   EVAL      RO_ACOD=BXACOD
     C                   EVAL      RO_ACSQ=BXACSQ
     C                   EVAL      RO_ACNO=AMACNO
     C                   EVAL      RO_HISD=BXOLVD
     C                   EVAL      RO_ODLN=AMODLN
     C                   EVAL      RO_ODED=AMODED
     C                   WRITE     REODHSD0
     C                   ENDIF
     C                   ENDIF
      *
      ** Write Retail History File Header and Position Records
      *
     C     RehisKey      CHAIN     REHISBL                            8081
      ** DATABASE ERROR
     C     *IN80         IFEQ      '0'
     C     *IN81         OREQ      '1'
     C                   MOVEL     DBerrKey      DBKEY
     C                   MOVEL     'REHISBL'     DBFILE                         ************
     C                   MOVEL     '018'         DBASE                          * DBERR 018*
     C                   EXSR      SRERR                                        ************
     C                   END
     C                   CLEAR                   REHISPPF                                     CRE101
     C                   EVAL      RH_RECI='B'
     C                   EVAL      RH_ZZ001=*BLANKS
     C                   EVAL      RH_BRCA=AMBRCA
     C                   EVAL      RH_CNUM=AMCNUM
     C                   EVAL      RH_CCY =AMCCY
     C                   EVAL      RH_ACOD=AMACOD
     C                   EVAL      RH_ACSQ=AMACSQ
     C                   EVAL      RH_HISD=AMDACO
     C                   EVAL      RH_HISB=*ZERO                                              211635
     C                   EVAL      RH_MNBL=*ZERO
     C                   EVAL      RH_CHGAR=*ZERO
     C                   EVAL      RH_TCHGAR=*ZERO
     C                   EVAL      RH_CHGAN=*ZERO
     C                   EVAL      RH_TCHGAN=*ZERO
     C                   EVAL      RH_DMVT=*ZERO
     C                   EVAL      RH_DICT=*ZERO
     C                   EVAL      RH_DRCB=AMDRIC
     C                   EVAL      RH_DRIR=*ZERO
     C                   EVAL      RH_DRCD=AMDRCD
     C                   EVAL      RH_DAID=*ZERO
     C                   EVAL      RH_MADI=*ZERO
     C                   EVAL      RH_TMADI=*ZERO
     C                   EVAL      RH_PDID=AMDACO
     C                   EVAL      RH_DMINT=*ZERO
     C                   EVAL      RH_CMVT=*ZERO
     C                   EVAL      RH_CICT=*ZERO
     C                   EVAL      RH_CRCB=AMCRIC
     C                   EVAL      RH_CRIR=*ZERO
     C                   EVAL      RH_CAID=*ZERO
     C                   EVAL      RH_MACI=*ZERO
     C                   EVAL      RH_TMACI=*ZERO
     C                   EVAL      RH_PCID=AMDACO
     C                   EVAL      RH_CMINT=*ZERO
     C                   EVAL      RH_DICI=*BLANKS
     C                   EVAL      RH_CICI=*BLANKS
     C                   EVAL      RH_DRCI=*BLANKS
     C                   EVAL      RH_CRCI=*BLANKS
     C                   EVAL      RH_VDTC=AMDACO
     C                   EVAL      RH_ADTY=*BLANKS
     C                   EVAL      RH_ALTI=*BLANKS
     C                   EVAL      RH_MNBCP=*ZERO
     C                   EVAL      RH_VALL=*ZERO
     C                   WRITE     REHISPPF
      *
      ** If CRT101 (Password on Retail Accounts) is installed and
      ** CRT001 (Retail Teller System) is on
      *
     C                   IF        CRT101='Y' and CRT001='Y' and
     C                             AMATYP='R' and AMSTYP='S'
      *
      ***Write*Password*to*file*REAPWDPD*******************************                       CSD101
      *
     C*****AccntKey      CHAIN     REAPWDL0                           8081                    CSD101
      ** DATABASE ERROR
     C******IN80         IFEQ      '0'                                                        CSD101
     C******IN81         OREQ      '1'                                                        CSD101
     C**********         MOVEL     DBerrKey      DBKEY                                        CSD101
     C**********         MOVEL     'REAPWDPD'    DBFILE                         ************  CSD101
     C**********         MOVEL     '019'         DBASE                          * DBERR 019*  CSD101
     C**********         EXSR      SRERR                                        ************  CSD101
     C**********         ENDIF                                                                CSD101
     C**********         CLEAR                   REAPWDD0                              CRE101 CSD101
     C**********         EVAL      RW_CNUM=PWCNUM                                             CSD101
     C**********         EVAL      RW_CCY =PWCCY                                              CSD101
     C**********         EVAL      RW_ACOD=PWACOD                                             CSD101
     C**********         EVAL      RW_ACSQ=PWACSQ                                             CSD101
     C**********         EVAL      RW_BRCA=PWBRCA                                             CSD101
     C**********         EVAL      RW_PSWD=PWPSWD                                             CSD101
     C**********         WRITE     REAPWDD0                                                   CSD101
     C**********         ENDIF                                                                CSD101
     C                   IF        PWPSWD <> *BLANKS                                          CSD101
     C                   EVAL      KCNUM2 = AMCNUM                                            CSD101
     C                   EVAL      KCCY2  = AMCCY                                             CSD101
     C                   MOVE      AMACOD        KACOD2                                       CSD101
     C                   MOVE      AMACSQ        KACSQ2                                       CSD101
     C                   EVAL      KBRCA2 = AMBRCA                                            CSD101
     C                   EVAL      PLibrary = LIBR + 'DMLIB'                                  CSD101
     C                   EVAL      PIDName = 'ACCOUNTPASSWORD_'   + CHKACC2                   CSD101
                                                                                              CSD101
     C                   CALL      'SD000404'                                                 CSD101
     C                   PARM      *Blanks       PReturnCode                                  CSD101
     C                   PARM      'F'           PAction                                      CSD101
     C                   PARM                    PValidList                                   CSD101
     C                   PARM                    PLibrary                                     CSD101
     C                   PARM                    PIDName                                      CSD101
     C                   PARM      *Blanks       PPass1                                       CSD101
     C                   PARM      *Blanks       PDescr                                       CSD101
                                                                                              CSD101
     C                   IF        PReturnCode <> *Blanks                                     CSD101
     C                   EVAL      PPass1 = PWPSWD                                            CSD101
     C                   EVAL      PDescr = *BLANKS                                           CSD101
     C                   CALL      'SD000404'                                                 CSD101
     C                   PARM      *Blanks       PReturnCode                                  CSD101
     C                   PARM      'A'           PAction                                      CSD101
     C                   PARM                    PValidList                                   CSD101
     C                   PARM                    PLibrary                                     CSD101
     C                   PARM                    PIDName                                      CSD101
     C                   PARM                    PPass1                                       CSD101
     C                   PARM                    PDescr                                       CSD101
     C                   ENDIF                                                                CSD101
                                                                                              CSD101
     C                   ENDIF                                                                CSD101
     C                   ENDIF                                                                CSD101
                                                                                              CRE015
      ** Period and penalty details                                                           CRE015
                                                                                              CRE015
     C                   IF        CRE015 = 'Y'                                               CRE015
     C                             AND A5ATTY = 'P'                                           CRE015
                                                                                              CRE015
     C     RehisKey      SETLL     REPRPNL4                                                   CRE015
     C                   IF        %EQUAL(REPRPNL4)                                           CRE015
     C                   MOVEL     DBerrKey      DBKEY                                        CRE015
     C                   MOVEL     'REPRPNPD'    DBFILE                                       CRE015
     C                   MOVEL     '102'         DBASE                                        CRE015
     C                   EXSR      SRERR                                                      CRE015
     C                   ENDIF                                                                CRE015
                                                                                              CRE015
     C                   MOVEA     GLVAMPP       ArrFilBuf                                    CRE015
     C                   DO        26            X                                            CRE015
     C                   EVAL      REPRPN = ArrFilBuf(X)                                      CRE015
                                                                                              CRE015
      ** Write a record if not blanks                                                         CRE015
                                                                                              CRE015
     C                   IF        E2BRCA <> *BLANKS                                          CRE015
                                                                                              CRE015
      ** Resequence events except event Z                                                     CRE015
                                                                                              CRE015
     C                   IF        E2EVNT <> 'Z'                                              CRE015
     C                   EVAL      E2EVNT = ArrEvnt(X)                                        CRE015
     C                   ENDIF                                                                CRE015
                                                                                              CRE015
      ** Do interest notification                                                             CRE015
                                                                                              CRE015
     C                   IF        E2EVNT = 'Z'                                               CRE015
     C                   EXSR      SRNotify                                                   CRE015
     C                   ENDIF                                                                CRE015
                                                                                              CRE015
     C                   WRITE     REPRPND0                                                   CRE015
     C                   ENDIF                                                                CRE015
     C                   ENDDO                                                                CRE015
                                                                                              CRE015
     C                   ENDIF                                                                CRE015
     C/COPY OFCPYSRCZ,CRE101_030                                                              CRE101
     C
     C                   ENDSR
     C****************************************************************
      /EJECT
     C****************************************************************
     C*                                                              *
     C* UpdSTRAN - To Update STRAN with Rate Change                  *
     C*                                                              *
     C****************************************************************
     C     UpdSTRAN      BEGSR
      *
      ** DEBIT RATE CHANGE
      *
      *
      ** Output only if no Flat Rate
      *
     C                   IF        AMDRIB=*ZEROS and AMDRIS=*ZEROS
     C                   IF        RIDICT<>BR_DICT or RIDCST<>BR_DCST
     C/COPY WNCPYSRC,GLAMADDC04
      *
      ** Get next available transaction number
      *
     C                   Z-ADD     *ZERO         NATN
     C                   CALLB     'ZTNLU1'
     C                   PARM      *BLANK        Retrn
     C                   PARM                    NATN
      ** Database Error if ReturnCode not blank
      *
     C     Retrn         IFNE      *BLANK
     C                   MOVEL     NATN          DBKEY
     C                   MOVEL     'MNATN  '     DBFILE                         ************
     C                   MOVEL     '020'         DBASE                          * DBERR 020*
     C                   EXSR      SRERR                                        ************
     C                   END
     C                   EVAL      WWNATN=NATN
      *
      ** Update STRAN header
      *
     C*****1****         CHAIN     STRAN                              80                    AR900144

      ** DATABASE ERROR
     C******IN80         IFEQ      '1'                                                      AR900144
     C**********         EVAL      DBKEY='1'                                                AR900144
     C**********         MOVEL     'STRAN  '     DBFILE                         ************AR900144
     C**********         MOVEL     '021'         DBASE                          * DBERR 021*AR900144
     C**********         EXSR      SRERR                                        ************AR900144
     C**********         END                                                                AR900144

     C**********         MOVEL     ST_RECI       STHEAD                              TDA033 AR900144
     C**********         MOVE      ST_ZZ199      STHEAD                                     AR900144
     C**********         Z-ADD     TRNO          WWTRNO                                     AR900144
     C**********         ADD       3             TRNO                                       AR900144
     C**********         Z-ADD     WWNATN        SATN                                       AR900144
     C**********         ADD       1             NORC                                       AR900144
     C**********         MOVE      STHEAD        ST_ZZ199                                   AR900144
     C**********         UPDATE    STRANF                                                   AR900144
     C     *HIVAL        SETGT     STRANF                                                   AR900144
     C                   READP     STRANF                                 60                AR900144
     C                   IF        *IN60 = *OFF                                             AR900144
     C                   MOVE      ST_ZZ199      ST1RAT                                     AR900144
     C                   EVAL      WWTRNO = S1TRNO                                          AR900144
     C**********         EVAL      WWTRNO = +1                                    AR900144 AR1073268
     C                   EVAL      WWTRNO += 1                                             AR1073268
     C                   ELSE                                                               AR900144
     C                   Z-ADD     1             WWTRNO                                     AR900144
     C                   ENDIF                                                              AR900144
     C                   CLEAR                   ST1RAT                                     AR900144
      *
      ** Access Interest Type/Sub Type only if not zero
     C/COPY WNCPYSRC,GLAMADDC05
      *
     C**********         EVAL      S1BRIS=*ZERO                                               CSD103
     C                   EVAL      S1BRIS=*BLANKS                                             CSD103
     C                   IF        RIDICT<>*ZERO or RIDCST<>*ZERO
     C                   EVAL      IntTyp=RIDICT
     C                   EVAL      IntSubTyp=RIDCST
     C                   EVAL      Curr=RICCY
     C                   EVAL      RecD='D'
     C     ReintKey      CHAIN     REINT                              80

      ** DATABASE ERROR
     C     *IN80         IFEQ      '1'
     C                   MOVEL     ReintKey      DBKEY
     C                   MOVEL     'REINT  '     DBFILE                         ************
     C                   MOVEL     '022'         DBASE                          * DBERR 022*
     C                   EXSR      SRERR                                        ************
     C                   END
     C                   ENDIF                                                               BUG8947

     C                   EVAL      S1BRIS = RT_BRT
     C                   EVAL      WWDBRT = 0                                                BUG8947
      *                                                                                       211648
      ** Access Midas Base Rate details DEBIT                                                 211648
      *                                                                                       211648
     C*****RT_BRT        IFNE      *ZEROS                                              211648 CSD103
     C     RT_BRT        IFNE      *BLANKS                                                    CSD103
      *                                                                                       211648
     C                   MOVEL(P)  RT_BRT        @BSRC                                        211648
     C                   CALLB     'AOBSRTR0'                                                 211648
     C                   PARM      '*MSG    '    @RTCD                                        211648
     C                   PARM      '*KEY    '    @OPTN                                        211648
     C                   PARM      RICCY         @CYCD                                        211648
     C                   PARM                    @BSRC                                        211648
     C     SDBSRT        PARM      SDBSRT        DSSDY                                        211648
      *                                                                                       211648
      * DATABASE ERROR                                                                        211648
      *                                                                                       211648
     C     @RTCD         IFNE      *BLANK                                                     211648
     C                   MOVEL     RT_BRT        DBKEY                                        211648
     C                   MOVEL     'SDBSRTPD'    DBFILE                                       211648
     C                   MOVEL     '803'         DBASE                                        211648
     C                   EXSR      SRERR                                                      211648
     C                   END                                                                  211648
     C                   EVAL      WWDBRT = BANBRT                                            211648
     C                   ENDIF                                                                211648
      *
      ** Update STRAN details
      *
     C*****WWTRNO        CHAIN     STRAN                              80                    AR900144

      ** DATABASE ERROR
     C******IN80         IFEQ      '1'                                                      AR900144
     C**********         MOVEL     WWTRNO        DBKEY                                      AR900144
     C**********         MOVEL     'STRAN  '     DBFILE                         ************AR900144
     C**********         MOVEL     '022'         DBASE                          **DBERR*022* BUG7194
     C**********         MOVEL     '027'         DBASE                          **DBERR*027*AR900144
     C**********         EXSR      SRERR                                        ************AR900144
     C**********         END                                                                AR900144

     C                   EVAL      S1CNUM = AMCNUM
     C                   EVAL      S1CCY  = AMCCY
     C                   EVAL      S1ACOD = AMACOD
     C                   EVAL      S1ACSQ = AMACSQ
     C                   EVAL      S1ONE  = '1'
     C                   EVAL      S1X    = 'X'
     C                   EVAL      S1ACNO = AMACNO
     C                   EVAL      S1RUND = BJRDNB
     C                   EVAL      S1WOLD = AMDRCD
     C                   EVAL      S1NARR = '9010 RATE CHANGE'
     C*****              EVAL      S1INTT = RIDICT                                            205308
     C*****              EVAL      S1INTS = RIDCST                                            205308
     C**********         EVAL      S1INTT = RICICT                                    205308 BUG8947
     C**********         EVAL      S1INTS = RICCST                                    205308 BUG8947
     C                   EVAL      S1INTT = RIDICT                                           BUG8947
     C                   EVAL      S1INTS = RIDCST                                           BUG8947
     C                   EVAL      S1DRCR = '0'
     C                   IF        CRE001 ='Y'
     C                   EVAL      S1AODR = BXAODR
     C                   IF        BXAODR<>BX_ATAODR
     C                             and BXORTC <> 0                                         AR947093A
     C                   Z-ADD     BXORTC        S1WOLD
     C                   ENDIF
     C                   ENDIF
     C                   TIME                    S1TIME
     C                   EVAL      S1RECO = 'GE/RC'
     C                   EVAL      S1SPTA = AMBRCA
     C                   EVAL      S1ATYP = 'R'
     C                   EVAL      S1RVLD = *ZEROS
     C                   BITOFF    '01234567'    S1BITF
     C                   EVAL      S1OLDR = AMDRCD
     C                   EVAL      S1INRT = *ZEROS
     C                   EVAL      S1WRIS = *ZEROS
     C                   EVAL      S1WRUN = BJRDNB
     C                   EVAL      S1TRNO = WWTRNO
     C                   EVAL      S1NATN = WWNATN
     C                   EVAL      ST_RECI = 'R'
     C                   MOVE      ST1RAT        ST_ZZ199
     C**********         UPDATE    STRANF                                                   AR900144
     C                   WRITE     STRANF                                                   AR900144
      *
     C                   ADD       1             WWTRNO
     C*****WWTRNO        CHAIN     STRAN                              80                    AR900144

      ** DATABASE ERROR
     C******IN80         IFEQ      '1'                                                      AR900144
     C**********         MOVEL     WWTRNO        DBKEY                                      AR900144
     C**********         MOVEL     'STRAN  '     DBFILE                         ************AR900144
     C**********         MOVEL     '023'         DBASE                          * DBERR 023*AR900144
     C**********         EXSR      SRERR                                        ************AR900144
     C**********         END                                                                AR900144

     C                   EVAL      S2CNUM = AMCNUM
     C                   EVAL      S2CCY  = AMCCY
     C                   EVAL      S2ACOD = AMACOD
     C                   EVAL      S2ACSQ = AMACSQ
     C                   EVAL      S2TWO  = '2'
     C                   EVAL      S2X    = 'X'
     C                   EVAL      S2INTH = RT_INTH
     C                   EVAL      S2WOLD = AMDRCD
     C                   EVAL      S2DRCR = '0'
     C**********         TIME                    S2TIME                                       229520
     C                   EVAL      S2TIME = S1TIME                                            229520
     C                   EVAL      S2SPTA = AMBRCA
     C                   EVAL      BAL1   = RT_BAL2
     C                   EVAL      RAT1   = RT_RAT2
     C                   EVAL      S2TRNO = WWTRNO
     C                   EVAL      S2NATN = WWNATN
     C                   EVAL      ST_RECI = 'R'
     C* Initial Threshhold, balance and Rate Spread set to zero in
     C* STRAN rate 2 if Debit interest type is blank
     C                   IF        RIDICT=*ZERO
     C                   Z-ADD     *ZERO         S2INTH
     C                   EVAL      BAL1A  = *ZERO
     C                   EVAL      BAL1B  = *ZERO
     C                   EVAL      BAL1C  = *ZERO
     C                   EVAL      BAL1D  = *ZERO
     C                   EVAL      BAL1E  = *ZERO
     C                   EVAL      BAL1F  = *ZERO
     C                   EVAL      RAT1A  = *ZERO
     C                   EVAL      RAT1B  = *ZERO
     C                   EVAL      RAT1C  = *ZERO
     C                   EVAL      RAT1D  = *ZERO
     C                   EVAL      RAT1E  = *ZERO
     C                   EVAL      RAT1F  = *ZERO
     C                   ENDIF
     C* Add new Base Rate with Rate Spread in STRAN Rate 2 if Debit
     C* interest type is equal to 2
     C                   IF        RIDICT>*ZERO
     C* Use new Debit Base Rate
     C                   ADD       WWDBRT        RAT1A
     C*
     C* Must now use balance not rate to determine when the end of the
     C* tiers/threshs has been reached and so omit the base rate.
     C*
     C                   IF        BAL1B<>*ZERO
     C                   ADD       WWDBRT        RAT1B
     C                   ENDIF
     C                   IF        BAL1C<>*ZERO
     C                   ADD       WWDBRT        RAT1C
     C                   ENDIF
     C                   IF        BAL1D<>*ZERO
     C                   ADD       WWDBRT        RAT1D
     C                   ENDIF
     C                   IF        BAL1E<>*ZERO
     C                   ADD       WWDBRT        RAT1E
     C                   ENDIF
     C                   IF        BAL1F<>*ZERO
     C                   ADD       WWDBRT        RAT1F
     C                   ENDIF
     C                   ENDIF
     C/COPY WNCPYSRC,GLAMADDC06
     C                   MOVE      ST2RAT        ST_ZZ199
     C**********         UPDATE    STRANF                                                   AR900144
     C                   WRITE     STRANF                                                   AR900144
      *
     C                   ADD       1             WWTRNO
     C*****WWTRNO        CHAIN     STRAN                              80                    AR900144

      ** DATABASE ERROR
     C******IN80         IFEQ      '1'                                                      AR900144
     C**********         MOVEL     WWTRNO        DBKEY                                      AR900144
     C**********         MOVEL     'STRAN  '     DBFILE                         ************AR900144
     C**********         MOVEL     '024'         DBASE                          * DBERR 024*AR900144
     C**********         EXSR      SRERR                                        ************AR900144
     C**********         END                                                                AR900144

     C                   EVAL      S3CNUM = AMCNUM
     C                   EVAL      S3CCY  = AMCCY
     C                   EVAL      S3ACOD = AMACOD
     C                   EVAL      S3ACSQ = AMACSQ
     C                   EVAL      S3THRE = '3'
     C                   EVAL      S3WOLD = AMDRCD
     C                   EVAL      S3DRCR = '0'
     C**********         TIME                    S3TIME                                       229520
     C                   EVAL      S3TIME = S1TIME                                            229520
     C                   EVAL      S3SPTA = AMBRCA
     C**********         EVAL      BAL3   = RT_BAL2                                          BUG8947
     C**********         EVAL      RAT3   = RT_RAT2                                          BUG8947
     C                   EVALR     BAL3   = RT_BAL2                                          BUG8947
     C                   EVALR     RAT3   = RT_RAT2                                          BUG8947
     C                   EVAL      S3TRNO = WWTRNO
     C                   EVAL      S3NATN = WWNATN
     C                   EVAL      ST_RECI = 'R'
     C* Initial Threshhold, balance and Rate Spread set to zero in
     C* STRAN rate 3 if Debit interest type is blank
     C                   IF        RIDICT=*ZERO
     C                   EVAL      BAL3A  = *ZERO
     C                   EVAL      BAL3B  = *ZERO
     C                   EVAL      BAL3C  = *ZERO
     C                   EVAL      BAL3D  = *ZERO
     C                   EVAL      BAL3E  = *ZERO
     C                   EVAL      RAT3A  = *ZERO
     C                   EVAL      RAT3B  = *ZERO
     C                   EVAL      RAT3C  = *ZERO
     C                   EVAL      RAT3D  = *ZERO
     C                   EVAL      RAT3E  = *ZERO
     C                   ENDIF
     C* Add new Base Rate with Rate Spread in STRAN Rate 3 if Debit
     C* interest type is not 0
     C                   IF        RIDICT>*ZERO
     C                   IF        BAL3A<>*ZERO
     C                   ADD       WWDBRT        RAT3A
     C                   ENDIF
     C* Must now use balance not rate to determine when the end of
     C* the Tiers/Thresh has been reached and so omit the base rate
     C                   IF        BAL3B<>*ZERO
     C                   ADD       WWDBRT        RAT3B
     C                   ENDIF
     C                   IF        BAL3C<>*ZERO
     C                   ADD       WWDBRT        RAT3C
     C                   ENDIF
     C                   IF        BAL3D<>*ZERO
     C                   ADD       WWDBRT        RAT3D
     C                   ENDIF
     C                   IF        BAL3E<>*ZERO
     C                   ADD       WWDBRT        RAT3E
     C                   ENDIF
     C                   ENDIF
     C                   MOVE      ST3RAT        ST_ZZ199
     C**********         UPDATE    STRANF                                                   AR900144
     C                   WRITE     STRANF                                                   AR900144
     C**********         ENDIF                                                               BUG8947
      *                                                                                       236046
     C                   IF        RIDICT=*ZEROS and RIDCST=*ZEROS                            236046
      *                                                                                       236046
      ** Update STRAN details                                                                 236046
      *                                                                                       236046
     C*****WWTRNO        CHAIN     STRAN                              80             236046 AR900144
      *                                                                                       236046
      ** DATABASE ERROR                                                                       236046
      *                                                                                       236046
     C******IN80         IFEQ      '1'                                               236046 AR900144
     C**********         MOVEL     WWTRNO        DBKEY                               236046 AR900144
     C**********         MOVEL     'STRAN  '     DBFILE                ************  236046 AR900144
     C**********         MOVEL     '101'         DBASE                 * DBERR 101*  236046 AR900144
     C**********         EXSR      SRERR                               ************  236046 AR900144
     C**********         END                                                         236046 AR900144
      *                                                                                     MD026269
     C     *HIVAL        SETGT     STRANF                                                   MD026269
     C                   READP     STRANF                                 60                MD026269
     C                   IF        *IN60 = *OFF                                             MD026269
     C                   MOVE      ST_ZZ199      ST1RAT                                     MD026269
     C                   EVAL      WWTRNO = S1TRNO                                          MD026269
     C                   EVAL      WWTRNO += 1                                              MD026269
     C                   ELSE                                                               MD026269
     C                   Z-ADD     1             WWTRNO                                     MD026269
     C                   ENDIF                                                              MD026269
     C                   CLEAR                   ST1RAT                                     MD026269
      *                                                                                       236046
     C                   EVAL      S1CNUM = AMCNUM                                            236046
     C                   EVAL      S1CCY  = AMCCY                                             236046
     C                   EVAL      S1ACOD = AMACOD                                            236046
     C                   EVAL      S1ACSQ = AMACSQ                                            236046
     C                   EVAL      S1ONE  = '1'                                               236046
     C                   EVAL      S1X    = *BLANKS                                           236046
     C                   EVAL      S1ACNO = AMACNO                                            236046
     C                   EVAL      S1RUND = BJRDNB                                            236046
     C                   EVAL      S1WOLD = AMDRCD                                            236046
     C                   EVAL      S1NARR = '9010 RATE CHANGE'                                236046
     C                   EVAL      S1INTT = RIDICT                                            236046
     C                   EVAL      S1INTS = RIDCST                                            236046
     C                   EVAL      S1DRCR = '0'                                               236046
     C                   IF        CRE001 ='Y'                                                236046
     C                   EVAL      S1AODR = BXAODR                                            236046
     C**********         IF        BXAODR<>BX_ATAODR and BXAODR<>*ZERO               236046 MD053470
     C**********                   and BXORTC <> 0                                AR947093A MD053470
     C                   IF        (BXAODR<>BX_ATAODR and BXAODR<>*ZERO                     MD053470
     C                             and BXORTC <> 0) or                                      MD053470
     C                             (BXAODR<>BX_ATAODR and BXAODR=*ZERO                      MD053470
     C                             and AMCHTP = 'A' and BXORTC <> 0)                        MD053470
     C                   Z-ADD     BXORTC        S1WOLD                                       236046
     C                   ENDIF                                                                236046
     C                   ENDIF                                                                236046
     C                   TIME                    S1TIME                                       236046
     C                   EVAL      S1RECO = 'GE/RC'                                           236046
     C                   EVAL      S1SPTA = AMBRCA                                            236046
     C                   EVAL      S1ATYP = 'R'                                               236046
     C                   EVAL      S1RVLD = *ZEROS                                            236046
     C                   BITOFF    '01234567'    S1BITF                                       236046
     C                   EVAL      S1OLDR = AMDRCD                                            236046
     C                   EVAL      S1INRT = *ZEROS                                            236046
     C                   EVAL      S1WRIS = *ZEROS                                            236046
     C                   EVAL      S1WRUN = BJRDNB                                            236046
     C                   EVAL      S1TRNO = WWTRNO                                            236046
     C                   EVAL      S1NATN = WWNATN                                            236046
     C                   EVAL      ST_RECI = 'R'                                              236046
     C                   MOVE      ST1RAT        ST_ZZ199                                     236046
     C**********         UPDATE    STRANF                                            236046 AR900144
     C                   WRITE     STRANF                                                   AR900144
     C                   ENDIF                                                                236046
      *                                                                                       236046
     C                   ENDIF
     C                   ENDIF
      *
     C                   IF        RIDICT=*ZEROS
     C                   IF        AMDRIB<>BA_DRIB or AMDRIS<>BA_DRIS
     C*****                        or BXAODR<>BX_ATAODR and CRE001<>'Y'                       202009
     C                             or BXAODR<>BX_ATAODR and CRE001='Y'                        202009
      *
      ** Get next available transaction number
      *
     C                   Z-ADD     *ZERO         NATN
     C                   CALLB     'ZTNLU1'
     C                   PARM      *BLANK        Retrn
     C                   PARM                    NATN
      ** Database Error if ReturnCode not blank
      *
     C     Retrn         IFNE      *BLANK
     C                   MOVEL     NATN          DBKEY
     C                   MOVEL     'MNATN  '     DBFILE                         ************
     C                   MOVEL     '025'         DBASE                          * DBERR 025*
     C                   EXSR      SRERR                                        ************
     C                   END
     C                   EVAL      WWNATN=NATN
      *
      ** Update STRAN header
      *
     C*****1****         CHAIN     STRAN                              80                    AR900144

      ** DATABASE ERROR
     C******IN80         IFEQ      '1'                                                      AR900144
     C**********         EVAL      DBKEY='1'                                                AR900144
     C**********         MOVEL     'STRAN  '     DBFILE                        ************ AR900144
     C**********         MOVEL     '026'         DBASE                         * DBERR 026* AR900144
     C**********         EXSR      SRERR                                       ************ AR900144
     C**********         END                                                                AR900144

     C**********         MOVEL     ST_RECI       STHEAD                              TDA033 AR900144
     C**********         MOVE      ST_ZZ199      STHEAD                                     AR900144
     C**********         Z-ADD     TRNO          WWTRNO                                     AR900144
     C**********         ADD       1             TRNO                                       AR900144
     C**********         Z-ADD     WWNATN        SATN                                       AR900144
     C**********         ADD       1             NORC                                       AR900144
     C**********         MOVE      STHEAD        ST_ZZ199                                   AR900144
     C**********         UPDATE    STRANF                                                   AR900144

      *
      ** Update STRAN details
      *
     C*****WWTRNO        CHAIN     STRAN                              80                    AR900144

      ** DATABASE ERROR
     C******IN80         IFEQ      '1'                                                      AR900144
     C**********         MOVEL     WWTRNO        DBKEY                                      AR900144
     C**********         MOVEL     'STRAN  '     DBFILE                         ************AR900144
     C**********         MOVEL     '028'         DBASE                          **DBERR*022* BUG7194
     C**********         MOVEL     '028'         DBASE                          **DBERR*028*AR900144
     C**********         EXSR      SRERR                                        ************AR900144
     C**********         END                                                                AR900144
     C     *HIVAL        SETGT     STRANF                                                   AR900144
     C                   READP     STRANF                                 60                AR900144
     C                   IF        *IN60 = *OFF                                             AR900144
     C                   MOVE      ST_ZZ199      ST1RAT                                     AR900144
     C                   EVAL      WWTRNO = S1TRNO                                          AR900144
     C**********         EVAL      WWTRNO = +1                                    AR900144 AR1073268
     C                   EVAL      WWTRNO += 1                                             AR1073268
     C                   ELSE                                                               AR900144
     C                   Z-ADD     1             WWTRNO                                     AR900144
     C                   ENDIF                                                              AR900144
     C                   CLEAR                   ST1RAT                                     AR900144

     C                   EVAL      S1CNUM = AMCNUM
     C                   EVAL      S1CCY  = AMCCY
     C                   EVAL      S1ACOD = AMACOD
     C                   EVAL      S1ACSQ = AMACSQ
     C                   EVAL      S1ONE  = '1'
     C                   EVAL      S1X    = *BLANKS
     C                   EVAL      S1ACNO = AMACNO
     C                   EVAL      S1RUND = BJRDNB
     C                   EVAL      S1WOLD = AMDRCD
     C                   EVAL      S1NARR = '9010 RATE CHANGE'
     C                   EVAL      S1INTT = RIDICT
     C                   EVAL      S1INTS = RIDCST
     C                   EVAL      S1DRCR = '0'
     C                   IF        CRE001 ='Y'
     C                   EVAL      S1AODR = BXAODR
     C**********         IF        BXAODR<>BX_ATAODR and BXAODR<>*ZERO                      MD053470
     C**********                   and BXORTC <> 0                                AR947093A MD053470
     C                   IF        (BXAODR<>BX_ATAODR and BXAODR<>*ZERO                     MD053470
     C                             and BXORTC <> 0) or                                      MD053470
     C                             (BXAODR<>BX_ATAODR and BXAODR=*ZERO                      MD053470
     C                             and AMCHTP = 'A' and BXORTC <> 0)                        MD053470
     C                   Z-ADD     BXORTC        S1WOLD
     C                   ENDIF
     C                   ENDIF
     C                   TIME                    S1TIME
     C                   EVAL      S1RECO = 'GE/RC'
     C                   EVAL      S1SPTA = AMBRCA
     C                   EVAL      S1ATYP = 'R'
     C                   EVAL      S1RVLD = *ZEROS
     C                   BITOFF    '01234567'    S1BITF
     C                   EVAL      S1OLDR = AMDRCD
     C                   EVAL      S1INRT = *ZEROS
     C                   EVAL      S1WRIS = *ZEROS
     C                   EVAL      S1WRUN = BJRDNB
     C                   EVAL      S1TRNO = WWTRNO
     C                   EVAL      S1NATN = WWNATN
     C                   EVAL      ST_RECI = 'R'
     C                   EVAL      S1WRIS = AMDRIS
     C                   EVAL      S1INRT = AMDRIS
     C**********         IF        AMDRIB = *ZEROS                                            CSD103
     C                   IF        AMDRIB = *BLANKS                                           CSD103
     C**********         EVAL      S1BRIS = *ZERO
     C                   EVAL      S1BRIS = *BLANKS
     C                   ELSE
     C                   EVAL      S1BRIS = AMDRIB
     C**********         EVAL      S1INRT = WWDBRT + AMDRIS                            185230 216905
     C                   EVAL      S1INRT = W#DBRT + AMDRIS                                   216905
     C**********         EVAL      S1INRT = WWDBRT                                            185230
     C                   ENDIF
     C                   MOVE      ST1RAT        ST_ZZ199
     C**********         UPDATE    STRANF                                                   AR900144
     C                   WRITE     STRANF                                                   AR900144
     C                   ENDIF
     C                   ENDIF
      *
      ** CREDIT RATE CHANGE
      *
      ** Output only if no Flat Rate
      *
     C                   IF        AMCRIB=*ZEROS and AMCRIS=*ZEROS
     C                   IF        RICICT<>BR_CICT or RICCST<>BR_CCST
      *
      ** Get next available transaction number
      *
     C                   Z-ADD     *ZERO         NATN
     C                   CALLB     'ZTNLU1'
     C                   PARM      *BLANK        Retrn
     C                   PARM                    NATN
      ** Database Error if ReturnCode not blank
      *
     C     Retrn         IFNE      *BLANK
     C                   MOVEL     NATN          DBKEY
     C                   MOVEL     'MNATN  '     DBFILE                         ************
     C                   MOVEL     '029'         DBASE                          * DBERR 029*
     C                   EXSR      SRERR                                        ************
     C                   END
     C                   EVAL      WWNATN=NATN
      *
      ** Update STRAN header
      *
     C*****1****         CHAIN     STRAN                              80                    AR900144

      ** DATABASE ERROR
     C******IN80         IFEQ      '1'                                                      AR900144
     C**********         EVAL      DBKEY='1'                                                AR900144
     C**********         MOVEL     'STRAN  '     DBFILE                         ************AR900144
     C**********         MOVEL     '030'         DBASE                          * DBERR 030*AR900144
     C**********         EXSR      SRERR                                        ************AR900144
     C**********         END                                                                AR900144

     C**********         MOVEL     ST_RECI       STHEAD                              TDA033 AR900144
     C**********         MOVE      ST_ZZ199      STHEAD                                     AR900144
     C**********         Z-ADD     TRNO          WWTRNO                                     AR900144
     C**********         ADD       3             TRNO                                       AR900144
     C**********         Z-ADD     WWNATN        SATN                                       AR900144
     C**********         ADD       1             NORC                                       AR900144
     C**********         MOVE      STHEAD        ST_ZZ199                                   AR900144
     C**********         UPDATE    STRANF                                                   AR900144
     C     *HIVAL        SETGT     STRANF                                                   AR900144
     C                   READP     STRANF                                 60                AR900144
     C                   IF        *IN60 = *OFF                                             AR900144
     C                   MOVE      ST_ZZ199      ST1RAT                                     AR900144
     C                   EVAL      WWTRNO = S1TRNO                                          AR900144
     C**********         EVAL      WWTRNO = +1                                    AR900144 AR1073268
     C                   EVAL      WWTRNO += 1                                             AR1073268
     C                   ELSE                                                               AR900144
     C                   Z-ADD     1             WWTRNO                                     AR900144
     C                   ENDIF                                                              AR900144
     C                   CLEAR                   ST1RAT                                     AR900144
      *
      ** Access Interest Type/Sub Type only if not zero
      *
     C**********         EVAL      S1BRIS=*ZERO                                               CSD103
     C                   EVAL      S1BRIS=*BLANKS                                             CSD103
     C                   IF        RICICT<>*ZERO or RICCST<>*ZERO
     C                   EVAL      IntTyp=RICICT
     C                   EVAL      IntSubTyp=RICCST
     C**********         EVAL      Curr=RICCY                                   198865
     C     CC_CCY        IFNE      *BLANKS                                      198865
     C                   EVAL      Curr=CC_CCY                                  198865
     C                   ELSE                                                   198865
     C                   EVAL      Curr=RICCY                                   198865
     C                   ENDIF                                                  198865
     C                   EVAL      RecD='D'
     C     ReintKey      CHAIN     REINT                              80

      ** DATABASE ERROR
     C     *IN80         IFEQ      '1'
     C                   EVAL      DBKEY=ReintKey
     C                   MOVEL     'REINT  '     DBFILE                         ************
     C                   MOVEL     '031'         DBASE                          * DBERR 031*
     C                   EXSR      SRERR                                        ************
     C                   END
     C                   ENDIF                                                               BUG8947

     C                   EVAL      S1BRIS = RT_BRT
     C                   EVAL      WWCBRT = 0                                                BUG8947
      *                                                                                       211648
      ** Access Midas Base Rate details CREDIT                                                211648
      *                                                                                       211648
     C*****RT_BRT        IFNE      *ZEROS                                              211648 CSD103
     C     RT_BRT        IFNE      *BLANKS                                                    CSD103
      *                                                                                       211648
     C                   MOVEL(P)  RT_BRT        @BSRC                                        211648
     C                   CALLB     'AOBSRTR0'                                                 211648
     C                   PARM      '*MSG    '    @RTCD                                        211648
     C                   PARM      '*KEY    '    @OPTN                                        211648
     C                   PARM      RICCY         @CYCD                                        211648
     C                   PARM                    @BSRC                                        211648
     C     SDBSRT        PARM      SDBSRT        DSSDY                                        211648
      *                                                                                       211648
      * DATABASE ERROR                                                                        211648
      *                                                                                       211648
     C     @RTCD         IFNE      *BLANK                                                     211648
     C                   MOVEL     RT_BRT        DBKEY                                        211648
     C                   MOVEL     'SDBSRTPD'    DBFILE                                       211648
     C                   MOVEL     '804'         DBASE                                        211648
     C                   EXSR      SRERR                                                      211648
     C                   END                                                                  211648
     C                   EVAL      WWCBRT = BANBRT                                            211648
     C                   ENDIF                                                                211648
      *
      ** Update STRAN details
      *
     C*****WWTRNO        CHAIN     STRAN                              80                    AR900144

      ** DATABASE ERROR
     C******IN80         IFEQ      '1'                                                      AR900144
     C**********         MOVEL     WWTRNO        DBKEY                                      AR900144
     C**********         MOVEL     'STRAN  '     DBFILE                        ************ AR900144
     C**********         MOVEL     '032'         DBASE                         * DBERR 032* AR900144
     C**********         EXSR      SRERR                                       ************ AR900144
     C**********         END                                                                AR900144

     C                   EVAL      S1CNUM = AMCNUM
     C                   EVAL      S1CCY  = AMCCY
     C                   EVAL      S1ACOD = AMACOD
     C                   EVAL      S1ACSQ = AMACSQ
     C                   EVAL      S1ONE  = '1'
     C                   EVAL      S1X    = 'X'
     C                   EVAL      S1ACNO = AMACNO
     C                   EVAL      S1RUND = BJRDNB
     C**********         EVAL      S1WOLD = AMDRCD                                            190343
     C                   EVAL      S1WOLD = AMCRCD                                            190343
     C                   EVAL      S1NARR = '9010 RATE CHANGE'
     C                   EVAL      S1INTT = RICICT
     C                   EVAL      S1INTS = RICCST
     C                   EVAL      S1DRCR = '1'
     C                   IF        CRE001 ='Y'
     C                   EVAL      S1AODR = *ZERO
     C                   ENDIF
     C                   TIME                    S1TIME
     C                   EVAL      S1RECO = 'GE/RC'
     C                   EVAL      S1SPTA = AMBRCA
     C                   EVAL      S1ATYP = 'R'
     C                   EVAL      S1RVLD = *ZEROS
     C                   BITOFF    '01234567'    S1BITF
     C**********         EVAL      S1OLDR = AMDRCD                                            190343
     C                   EVAL      S1OLDR = AMCRCD                                            190343
     C                   EVAL      S1INRT = *ZEROS
     C                   EVAL      S1WRIS = *ZEROS
     C                   EVAL      S1WRUN = BJRDNB
     C                   EVAL      S1TRNO = WWTRNO
     C                   EVAL      S1NATN = WWNATN
     C                   EVAL      ST_RECI = 'R'
     C                   MOVE      ST1RAT        ST_ZZ199
     C**********         UPDATE    STRANF
     C                   WRITE     STRANF                                                   AR900144
      *
     C                   ADD       1             WWTRNO
     C*****WWTRNO        CHAIN     STRAN                              80                    AR900144

      ** DATABASE ERROR
     C******IN80         IFEQ      '1'                                                      AR900144
     C**********         MOVEL     WWTRNO        DBKEY                                      AR900144
     C**********         MOVEL     'STRAN  '     DBFILE                        ************ AR900144
     C**********         MOVEL     '033'         DBASE                         * DBERR 033* AR900144
     C**********         EXSR      SRERR                                       ************ AR900144
     C**********         END                                                                AR900144

     C                   EVAL      S2CNUM = AMCNUM
     C                   EVAL      S2CCY  = AMCCY
     C                   EVAL      S2ACOD = AMACOD
     C                   EVAL      S2ACSQ = AMACSQ
     C                   EVAL      S2TWO  = '2'
     C                   EVAL      S2X    = 'X'
     C                   EVAL      S2INTH = RT_INTH
     C**********         EVAL      S2WOLD = AMDRCD                                            190343
     C                   EVAL      S2WOLD = AMCRCD                                            190343
     C                   EVAL      S2DRCR = '1'
     C**********         TIME                    S2TIME                                       229520
     C                   EVAL      S2TIME = S1TIME                                            229520
     C                   EVAL      S2SPTA = AMBRCA
     C                   EVAL      BAL1   = RT_BAL2
     C                   EVAL      RAT1   = RT_RAT2
     C                   EVAL      S2TRNO = WWTRNO
     C                   EVAL      S2NATN = WWNATN
     C                   EVAL      ST_RECI = 'R'
     C                   MOVE      ST2RAT        ST_ZZ199

     C* Initial Threshhold, balance and Rate Spread set to zero in
     C* STRAN rate 2 if Credit interest type is blank
     C                   IF        RICICT=*ZERO
     C                   Z-ADD     *ZERO         S2INTH
     C                   EVAL      BAL1A  = *ZERO
     C                   EVAL      BAL1B  = *ZERO
     C                   EVAL      BAL1C  = *ZERO
     C                   EVAL      BAL1D  = *ZERO
     C                   EVAL      BAL1E  = *ZERO
     C                   EVAL      BAL1F  = *ZERO
     C                   EVAL      RAT1A  = *ZERO
     C                   EVAL      RAT1B  = *ZERO
     C                   EVAL      RAT1C  = *ZERO
     C                   EVAL      RAT1D  = *ZERO
     C                   EVAL      RAT1E  = *ZERO
     C                   EVAL      RAT1F  = *ZERO
     C                   ENDIF
     C* Add new Base Rate with Rate Spread in STRAN Rate 2 if Credit
     C* interest type is equal to 2
     C                   IF        RICICT>*ZERO
     C* Use new Credit Base Rate
     C                   ADD       WWCBRT        RAT1A
     C* Must now use balance not rate to determine when the end of
     C* the Tiers/Thresh has been reached and so omit the base rate
     C                   IF        BAL1B<>*ZERO
     C                   ADD       WWCBRT        RAT1B
     C                   ENDIF
     C                   IF        BAL1C<>*ZERO
     C                   ADD       WWCBRT        RAT1C
     C                   ENDIF
     C                   IF        BAL1D<>*ZERO
     C                   ADD       WWCBRT        RAT1D
     C                   ENDIF
     C                   IF        BAL1E<>*ZERO
     C                   ADD       WWCBRT        RAT1E
     C                   ENDIF
     C                   IF        BAL1F<>*ZERO
     C                   ADD       WWCBRT        RAT1F
     C                   ENDIF
     C                   ENDIF
     C/COPY WNCPYSRC,GLAMADDC07
     C                   MOVE      ST2RAT        ST_ZZ199
     C**********         UPDATE    STRANF                                                   AR900144
     C                   WRITE     STRANF                                                   AR900144
      *
     C                   ADD       1             WWTRNO
     C*****WWTRNO        CHAIN     STRAN                              80                    AR900144

      ** DATABASE ERROR
     C******IN80         IFEQ      '1'                                                      AR900144
     C**********         MOVEL     WWTRNO        DBKEY                                      AR900144
     C**********         MOVEL     'STRAN  '     DBFILE                        ************ AR900144
     C**********         MOVEL     '034'         DBASE                         * DBERR 034* AR900144
     C**********         EXSR      SRERR                                       ************ AR900144
     C**********         END                                                                AR900144

     C                   EVAL      S3CNUM = AMCNUM
     C                   EVAL      S3CCY  = AMCCY
     C                   EVAL      S3ACOD = AMACOD
     C                   EVAL      S3ACSQ = AMACSQ
     C                   EVAL      S3THRE = '3'
     C**********         EVAL      S3WOLD = AMDRCD                                            190343
     C                   EVAL      S3WOLD = AMCRCD                                            190343
     C                   EVAL      S3DRCR = '1'
     C**********         TIME                    S3TIME                                       229520
     C                   EVAL      S3TIME = S1TIME                                            229520
     C                   EVAL      S3SPTA = AMBRCA
     C**********         EVAL      BAL3   = RT_BAL2                                          BUG8947
     C**********         EVAL      RAT3   = RT_RAT2                                          BUG8947
     C                   EVALR     BAL3   = RT_BAL2                                          BUG8947
     C                   EVALR     RAT3   = RT_RAT2                                          BUG8947
     C                   EVAL      S3TRNO = WWTRNO
     C                   EVAL      S3NATN = WWNATN
     C                   EVAL      ST_RECI = 'R'
     C* Initial Threshhold, balance and Rate Spread set to zero in
     C* STRAN rate 3 if Credit interest type is blank
     C**********         IF        RIDICT=*ZERO                                               205318
     C                   IF        RICICT=*ZERO                                               205318
     C                   EVAL      BAL3A  = *ZERO
     C                   EVAL      BAL3B  = *ZERO
     C                   EVAL      BAL3C  = *ZERO
     C                   EVAL      BAL3D  = *ZERO
     C                   EVAL      BAL3E  = *ZERO
     C                   EVAL      RAT3A  = *ZERO
     C                   EVAL      RAT3B  = *ZERO
     C                   EVAL      RAT3C  = *ZERO
     C                   EVAL      RAT3D  = *ZERO
     C                   EVAL      RAT3E  = *ZERO
     C                   ENDIF
     C* Add new Base Rate with Rate Spread in STRAN Rate 3 if Credit
     C* interest type is not 0
     C                   IF        RICICT>*ZERO
     C                   IF        BAL3A<>*ZERO
     C                   ADD       WWCBRT        RAT3A
     C                   ENDIF
     C* Must not use balance not rate to determine when the end of
     C* the Tiers/Thresh has been reached and so omit the base rate
     C                   IF        BAL3B<>*ZERO
     C                   ADD       WWCBRT        RAT3B
     C                   ENDIF
     C                   IF        BAL3C<>*ZERO
     C                   ADD       WWCBRT        RAT3C
     C                   ENDIF
     C                   IF        BAL3D<>*ZERO
     C                   ADD       WWCBRT        RAT3D
     C                   ENDIF
     C                   IF        BAL3E<>*ZERO
     C                   ADD       WWCBRT        RAT3E
     C                   ENDIF
     C                   ENDIF
     C                   MOVE      ST3RAT        ST_ZZ199
     C**********         UPDATE    STRANF                                                   AR900144
     C                   WRITE     STRANF                                                   AR900144
     C**********         ENDIF                                                               BUG8947
     C                   ENDIF
     C                   ENDIF
      *
     C                   IF        RICICT=*ZEROS
     C                   IF        AMCRIB<>BA_CRIB or AMCRIS<>BA_CRIS
      *
      ** Get next available transaction number
      *
     C                   Z-ADD     *ZERO         NATN
     C                   CALLB     'ZTNLU1'
     C                   PARM      *BLANK        Retrn
     C                   PARM                    NATN
      ** Database Error if ReturnCode not blank
      *
     C     Retrn         IFNE      *BLANK
     C                   MOVEL     NATN          DBKEY
     C                   MOVEL     'MNATN  '     DBFILE                         ************
     C                   MOVEL     '035'         DBASE                          * DBERR 035*
     C                   EXSR      SRERR                                        ************
     C                   END
     C                   EVAL      WWNATN=NATN
      *
      ** Update STRAN header
      *
     C*****1****         CHAIN     STRAN                              80                    AR900144

      ** DATABASE ERROR
     C******IN80         IFEQ      '1'                                                      AR900144
     C**********         EVAL      DBKEY='1'                                                AR900144
     C**********         MOVEL     'STRAN  '     DBFILE                        ************ AR900144
     C**********         MOVEL     '036'         DBASE                         * DBERR 036* AR900144
     C**********         EXSR      SRERR                                       ************ AR900144
     C**********         END                                                                AR900144

     C**********         MOVEL     ST_RECI       STHEAD                              TDA033 AR900144
     C**********         MOVE      ST_ZZ199      STHEAD                                     AR900144
     C**********         Z-ADD     TRNO          WWTRNO                                     AR900144
     C**********         ADD       1             TRNO                                       AR900144
     C**********         Z-ADD     WWNATN        SATN                                       AR900144
     C**********         ADD       1             NORC                                       AR900144
     C**********         MOVE      STHEAD        ST_ZZ199                                   AR900144
     C**********         UPDATE    STRANF                                                   AR900144
     C     *HIVAL        SETGT     STRANF                                                   AR900144
     C                   READP     STRANF                                 60                AR900144
     C                   IF        *IN60 = *OFF                                             AR900144
     C                   MOVE      ST_ZZ199      ST1RAT                                     AR900144
     C                   EVAL      WWTRNO = S1TRNO                                          AR900144
     C**********         EVAL      WWTRNO = +1                                    AR900144 AR1073268
     C                   EVAL      WWTRNO += 1                                             AR1073268
     C                   ELSE                                                               AR900144
     C                   Z-ADD     1             WWTRNO                                     AR900144
     C                   ENDIF                                                              AR900144
     C                   CLEAR                   ST1RAT                                     AR900144

      *
      ** Update STRAN details
      *
     C*****WWTRNO        CHAIN     STRAN                              80                    AR900144

      ** DATABASE ERROR
     C******IN80         IFEQ      '1'                                                      AR900144
     C**********         MOVEL     WWTRNO        DBKEY                                      AR900144
     C**********         MOVEL     'STRAN  '     DBFILE                        ************ AR900144
     C**********         MOVEL     '037'         DBASE                         * DBERR 037* AR900144
     C**********         EXSR      SRERR                                       ************ AR900144
     C**********         END                                                                AR900144

     C                   EVAL      S1CNUM = AMCNUM
     C                   EVAL      S1CCY  = AMCCY
     C                   EVAL      S1ACOD = AMACOD
     C                   EVAL      S1ACSQ = AMACSQ
     C                   EVAL      S1ONE  = '1'
     C                   EVAL      S1X    = *BLANKS
     C                   EVAL      S1ACNO = AMACNO
     C                   EVAL      S1RUND = BJRDNB
     C**********         EVAL      S1WOLD = AMDRCD                                            190343
     C                   EVAL      S1WOLD = AMCRCD                                            190343
     C                   EVAL      S1NARR = '9010 RATE CHANGE'
     C*******************EVAL      S1INTT = RIDICT                              205308
     C*******************EVAL      S1INTS = RIDCST                              205308
     C                   EVAL      S1INTT = RICICT                              205308
     C                   EVAL      S1INTS = RICCST                              205308
     C                   EVAL      S1DRCR = '1'
     C                   IF        CRE001 ='Y'
     C                   EVAL      S1AODR = *ZERO
     C                   ENDIF
     C                   TIME                    S1TIME
     C                   EVAL      S1RECO = 'GE/RC'
     C                   EVAL      S1SPTA = AMBRCA
     C                   EVAL      S1ATYP = 'R'
     C                   EVAL      S1RVLD = *ZEROS
     C                   BITOFF    '01234567'    S1BITF
     C**********         EVAL      S1OLDR = AMDRCD                                            190343
     C                   EVAL      S1OLDR = AMCRCD                                            190343
     C                   EVAL      S1INRT = *ZEROS
     C                   EVAL      S1WRUN = BJRDNB
     C                   EVAL      S1TRNO = WWTRNO
     C                   EVAL      S1NATN = WWNATN
     C                   EVAL      ST_RECI = 'R'
     C                   EVAL      S1WRIS = AMCRIS
     C                   EVAL      S1INRT = AMCRIS
     C                   IF        AMCRIB = *ZEROS
     C**********         EVAL      S1BRIS = *ZERO                                             CSD103
     C                   EVAL      S1BRIS = *BLANKS                                           CSD103
     C                   ELSE
     C                   EVAL      S1BRIS = AMCRIB
     C**********         EVAL      S1INRT = WWCBRT + AMCRIS                            185230 216905
     C                   EVAL      S1INRT = W#CBRT + AMCRIS                                   216905
     C**********         EVAL      S1INRT = WWCBRT                                            185230
     C                   ENDIF
     C                   MOVE      ST1RAT        ST_ZZ199
     C**********         UPDATE    STRANF                                                   AR900144
     C                   WRITE     STRANF                                                   AR900144
     C                   ENDIF
     C                   ENDIF
      *
     C                   ENDSR
     C****************************************************************
      /EJECT
     C****************************************************************                        CRE005
     C*                                                              *                        CRE005
     C* UpdRERCH - To Update RERCH files with Rate Change            *                        CRE005
     C*                                                              *                        CRE005
     C****************************************************************                        CRE005
     C     UpdRERCH      BEGSR                                                                CRE005
      *                                                                                       CRE005
      ** Processing updates header file RERCHHPA only                                         CRE005
      ** Records written to RERCH1PD, RERCH2PD, RERCH3PD instead of STRAN                     CRE005
      *                                                                                       CRE005
      ** Setup work field for number records written                                          CRE005
     C                   Z-ADD     0             WNORS             2 0                        CRE005
      *                                                                                       CRE005
      ** DEBIT RATE CHANGE                                                                    CRE005
      *                                                                                       CRE005
      *                                                                                       CRE005
      ** Output only if no Flat Rate                                                          CRE005
      *                                                                                       CRE005
     C                   IF        AMDRIB=*ZEROS and AMDRIS=*ZEROS                            CRE005
     C                   IF        RIDICT<>BR_DICT or RIDCST<>BR_DCST                         CRE005
      *                                                                                       CRE005
      *                                                                                       CRE005
      ** Get next available transaction number                                                CRE005
      *                                                                                       CRE005
     C                   Z-ADD     *ZERO         NATN                                         CRE005
     C                   CALLB     'ZTNLU1'                                                   CRE005
     C                   PARM      *BLANK        Retrn                                        CRE005
     C                   PARM                    NATN                                         CRE005
      ** Database Error if ReturnCode not blank                                               CRE005
      *                                                                                       CRE005
     C     Retrn         IFNE      *BLANK                                                     CRE005
     C                   MOVEL     NATN          DBKEY                                        CRE005
     C                   MOVEL     'MNATN  '     DBFILE                                       CRE005
     C                   MOVEL     '020'         DBASE                                        CRE005
     C                   EXSR      SRERR                                                      CRE005
     C                   END                                                                  CRE005
     C                   EVAL      WWNATN=NATN                                                CRE005
                                                                                              CRE005
      *                                                                                       CRE005
      *                                                                                       CRE005
      ** Access Interest Type/Sub Type only if not zero                                       CRE005
      *                                                                                       CRE005
     C**********         EVAL      I1BRT =*ZERO                                        CRE005 CSD103
     C                   EVAL      I1BRT =*BLANKS                                             CSD103
     C                   IF        RIDICT<>*ZERO or RIDCST<>*ZERO                             CRE005
     C                   EVAL      IntTyp=RIDICT                                              CRE005
     C                   EVAL      IntSubTyp=RIDCST                                           CRE005
     C                   EVAL      Curr=RICCY                                                 CRE005
     C                   EVAL      RecD='D'                                                   CRE005
     C     ReintKey      CHAIN     REINT                              80                      CRE005
                                                                                              CRE005
      ** DATABASE ERROR                                                                       CRE005
     C     *IN80         IFEQ      '1'                                                        CRE005
     C                   MOVEL     ReintKey      DBKEY                                        CRE005
     C                   MOVEL     'REINT  '     DBFILE                                       CRE005
     C                   MOVEL     '022'         DBASE                                        CRE005
     C                   EXSR      SRERR                                                      CRE005
     C                   END                                                                  CRE005
                                                                                              CRE005
     C                   EVAL      I1BRT  = RT_BRT                                            CRE005
     C                   EVAL      WWDBRT = 0                                                 236976
      *                                                                                       236976
      ** Access Midas Base Rate details DEBIT                                                 236976
      *                                                                                       236976
     C*****RT_BRT        IFNE      *ZEROS                                              236976 CSD103
     C     RT_BRT        IFNE      *BLANKS                                                    CSD103
      *                                                                                       236976
     C                   MOVEL(P)  RT_BRT        @BSRC                                        236976
     C                   CALLB     'AOBSRTR0'                                                 236976
     C                   PARM      '*MSG    '    @RTCD                                        236976
     C                   PARM      '*KEY    '    @OPTN                                        236976
     C                   PARM      RICCY         @CYCD                                        236976
     C                   PARM                    @BSRC                                        236976
     C     SDBSRT        PARM      SDBSRT        DSSDY                                        236976
      *                                                                                       236976
      * DATABASE ERROR                                                                        236976
      *                                                                                       236976
     C     @RTCD         IFNE      *BLANK                                                     236976
     C                   MOVEL     RT_BRT        DBKEY                                        236976
     C                   MOVEL     'SDBSRTPD'    DBFILE                                       236976
     C                   MOVEL     '803'         DBASE                                        236976
     C                   EXSR      SRERR                                                      236976
     C                   END                                                                  236976
     C                   EVAL      WWDBRT = BANBRT                                            236976
     C                   ENDIF                                                                236976
     C                   ENDIF                                                                236976
                                                                                              CRE005
     C                   EVAL      I1CNUM = AMCNUM                                            CRE005
     C                   EVAL      I1CCY  = AMCCY                                             CRE005
     C                   EVAL      I1ACOD = AMACOD                                            CRE005
     C                   EVAL      I1ACSQ = AMACSQ                                            CRE005
     C                   EVAL      I1RSEQ = '1'                                               CRE005
     C                   EVAL      I1CONI = 'X'                                               CRE005
     C                   EVAL      I1ACNO = AMACNO                                            CRE005
     C                   EVAL      I1PSTD = BJRDNB                                            CRE005
     C                   EVAL      I1VALD = AMDRCD                                            CRE005
     C                   EVAL      I1PNAR = '9010 RATE CHANGE'                                CRE005
     C                   EVAL      I1INTP = RIDICT                                            CRE005
     C                   EVAL      I1INST = RIDCST                                            CRE005
     C                   EVAL      I1DRCR = 0                                                 CRE005
     C                   IF        CRE001 ='Y'                                                CRE005
     C                   MOVE      I1AODR        I1AODR           11 7                        CRE005
     C                   EVAL      I1AODR = BXAODR                                            CRE005
     C                   IF        BXAODR<>BX_ATAODR                                          CRE005
     C                   Z-ADD     BXORTC        I1VALD                                       CRE005
     C                   ENDIF                                                                CRE005
     C                   ENDIF                                                                CRE005
     C                   TIME                    I1TIME                                       CRE005
     C                   EVAL      I1SPOS = 'GE/RC'                                           CRE005
      ** Timestamp                                                                          MD034366
     C                   CALLB     'ZAGENTMSTM'                                             MD034366
     C                   PARM                    TimeStamp                                  MD034366
     C                   EVAL      I1TSTMP = TimeStamp                                      MD034366
     C                   EVAL      I1BRCA = AMBRCA                                            CRE005
     C                   EVAL      I1ZZ001 = 'R'                                              CRE005
     C                   EVAL      I1RVLD = *ZEROS                                            CRE005
     C                   BITOFF    '01234567'    I1PRIN                                       CRE005
     C                   EVAL      I1LRCD = AMDRCD                                            CRE005
     C                   EVAL      I1INRT = *ZEROS                                            CRE005
     C                   EVAL      I1RTSP = *ZEROS                                            CRE005
     C********           EVAL      I1WRUN = BJRDNB                                            CRE005
     C********           EVAL      I1TRNO = WWTRNO                                            CRE005
     C********           EVAL      I1NATN = WWNATN                                            CRE005
     C                   EVAL      I1RECI = 'R'                                               CRE005
     C                   WRITE     RERCH1D0                                                   CRE005
      *                                                                                       CRE005
      ** Add 1 to header record field                                                         CRE005
     C                   ADD       1             WNORS                                        CRE005
                                                                                              CRE005
     C                   EVAL      I2CNUM = AMCNUM                                            CRE005
     C                   EVAL      I2CCY  = AMCCY                                             CRE005
     C                   EVAL      I2ACOD = AMACOD                                            CRE005
     C                   EVAL      I2ACSQ = AMACSQ                                            CRE005
     C                   EVAL      I2RSEQ = '2'                                               CRE005
     C                   EVAL      I2CONI = 'X'                                               CRE005
     C                   EVAL      I2INTH = RT_INTH                                           CRE005
     C                   EVAL      I2VALD = AMDRCD                                            CRE005
     C                   EVAL      I2DRCR = 0                                                 CRE005
     C**********         TIME                    I2TIME                                CRE005 233901
     C                   EVAL      I2TIME = I1TIME                                            233901
     C                   EVAL      I2TSTMP = I1TSTMP                                        MD034366
     C                   EVAL      I2BRCA = AMBRCA                                            CRE005
     C                   EVAL      I2BAL1   = RT_BAL2                                         CRE005
     C                   EVAL      I2RAT1   = RT_RAT2                                         CRE005
     C***********        EVAL      I2TRNO = WWTRNO                                            CRE005
     C***********        EVAL      I2NATN = WWNATN                                            CRE005
     C                   EVAL      I2RECI = 'R'                                               CRE005
     C* Initial Threshhold, balance and Rate Spread set to zero in                            CRE005
     C* RERCH2PD if Debit interest type is blank                                              CRE005
     C                   IF        RIDICT=*ZERO                                               CRE005
     C                   Z-ADD     *ZERO         S2INTH                                       CRE005
     C                   EVAL      IBAL1A  = *ZERO                                            CRE005
     C                   EVAL      IBAL1B  = *ZERO                                            CRE005
     C                   EVAL      IBAL1C  = *ZERO                                            CRE005
     C                   EVAL      IBAL1D  = *ZERO                                            CRE005
     C                   EVAL      IBAL1E  = *ZERO                                            CRE005
     C                   EVAL      IBAL1F  = *ZERO                                            CRE005
     C                   EVAL      IRAT1A  = *ZERO                                            CRE005
     C                   EVAL      IRAT1B  = *ZERO                                            CRE005
     C                   EVAL      IRAT1C  = *ZERO                                            CRE005
     C                   EVAL      IRAT1D  = *ZERO                                            CRE005
     C                   EVAL      IRAT1E  = *ZERO                                            CRE005
     C                   EVAL      IRAT1F  = *ZERO                                            CRE005
     C                   ENDIF                                                                CRE005
     C* Add new Base Rate with Rate Spread in RERCH2PD if Debit                               CRE005
     C* interest type is equal to 2                                                           CRE005
     C                   IF        RIDICT>*ZERO                                               CRE005
     C* Use new Debit Base Rate                                                               CRE005
     C                   ADD       WWDBRT        IRAT1A                                       CRE005
     C*                                                                                       CRE005
     C* Must now use balance not rate to determine when the end of the                        CRE005
     C* tiers/threshs has been reached and so omit the base rate.                             CRE005
     C*                                                                                       CRE005
     C                   IF        IBAL1B<>*ZERO                                              CRE005
     C                   ADD       WWDBRT        IRAT1B                                       CRE005
     C                   ENDIF                                                                CRE005
     C                   IF        IBAL1C<>*ZERO                                              CRE005
     C                   ADD       WWDBRT        IRAT1C                                       CRE005
     C                   ENDIF                                                                CRE005
     C                   IF        IBAL1D<>*ZERO                                              CRE005
     C                   ADD       WWDBRT        IRAT1D                                       CRE005
     C                   ENDIF                                                                CRE005
     C                   IF        IBAL1E<>*ZERO                                              CRE005
     C                   ADD       WWDBRT        IRAT1E                                       CRE005
     C                   ENDIF                                                                CRE005
     C                   IF        IBAL1F<>*ZERO                                              CRE005
     C                   ADD       WWDBRT        IRAT1F                                       CRE005
     C                   ENDIF                                                                CRE005
     C                   ENDIF                                                                CRE005
     C                   WRITE     RERCH2D0                                                   CRE005
                                                                                              CRE005
      ** Add 1 to header record field                                                         CRE005
     C                   ADD       1             WNORS                                        CRE005
                                                                                              CRE005
     C                   EVAL      I3CNUM = AMCNUM                                            CRE005
     C                   EVAL      I3CCY  = AMCCY                                             CRE005
     C                   EVAL      I3ACOD = AMACOD                                            CRE005
     C                   EVAL      I3ACSQ = AMACSQ                                            CRE005
     C                   EVAL      I3RSEQ = '3'                                               CRE005
     C                   EVAL      I3VALD = AMDRCD                                            CRE005
     C                   EVAL      I3DRCR = 0                                                 CRE005
     C**********         TIME                    I3TIME                                CRE005 233901
     C                   EVAL      I3TIME = I1TIME                                            233901
     C                   EVAL      I3TSTMP = I1TSTMP                                        MD034366
     C                   EVAL      I3BRCA = AMBRCA                                            CRE005
     C**********         EVAL      I3BAL3   = RT_BAL2                                  CRE005 236976
     C**********         EVAL      I3RAT3   = RT_RAT2                                  CRE005 236976
     C                   MOVE      RT_BAL2       I3BAL3                                       236976
     C                   MOVE      RT_RAT2       I3RAT3                                       236976
     C**********         EVAL      I3TRNO = WWTRNO                                            CRE005
     C**********         EVAL      I3NATN = WWNATN                                            CRE005
     C                   EVAL      I3RECI = 'R'                                               CRE005
     C* Initial Threshhold, balance and Rate Spread set to zero in                            CRE005
     C* RERCH3PD if Debit interest type is blank                                              CRE005
     C                   IF        RIDICT=*ZERO                                               CRE005
     C                   EVAL      IBAL3A  = *ZERO                                            CRE005
     C                   EVAL      IBAL3B  = *ZERO                                            CRE005
     C                   EVAL      IBAL3C  = *ZERO                                            CRE005
     C                   EVAL      IBAL3D  = *ZERO                                            CRE005
     C                   EVAL      IBAL3E  = *ZERO                                            CRE005
     C                   EVAL      IRAT3A  = *ZERO                                            CRE005
     C                   EVAL      IRAT3B  = *ZERO                                            CRE005
     C                   EVAL      IRAT3C  = *ZERO                                            CRE005
     C                   EVAL      IRAT3D  = *ZERO                                            CRE005
     C                   EVAL      IRAT3E  = *ZERO                                            CRE005
     C                   ENDIF                                                                CRE005
     C* Add new Base Rate with Rate Spread in RERCH3PD if Debit                               CRE005
     C* interest type is not 0                                                                CRE005
     C                   IF        RIDICT>*ZERO                                               CRE005
     C                   IF        IBAL3A<>*ZERO                                              CRE005
     C                   ADD       WWDBRT        IRAT3A                                       CRE005
     C                   ENDIF                                                                CRE005
     C* Must now use balance not rate to determine when the end of                            CRE005
     C* the Tiers/Thresh has been reached and so omit the base rate                           CRE005
     C                   IF        IBAL3B<>*ZERO                                              CRE005
     C                   ADD       WWDBRT        IRAT3B                                       CRE005
     C                   ENDIF                                                                CRE005
     C                   IF        IBAL3C<>*ZERO                                              CRE005
     C                   ADD       WWDBRT        IRAT3C                                       CRE005
     C                   ENDIF                                                                CRE005
     C                   IF        IBAL3D<>*ZERO                                              CRE005
     C                   ADD       WWDBRT        IRAT3D                                       CRE005
     C                   ENDIF                                                                CRE005
     C                   IF        IBAL3E<>*ZERO                                              CRE005
     C                   ADD       WWDBRT        IRAT3E                                       CRE005
     C                   ENDIF                                                                CRE005
     C                   ENDIF                                                                CRE005
     C                   MOVEL     I3BAL3        I3BAL1                                     MD034366
     C                   MOVEL     I3RAT3        I3RAT1                                     MD034366
     C                   WRITE     RERCH3D0                                                   CRE005
                                                                                              CRE005
      ** Add 1 to header record field                                                         CRE005
     C                   ADD       1             WNORS                                        CRE005
                                                                                              CRE005
     C                   ENDIF                                                                CRE005
     C**********         ENDIF                                                         CRE005 236976
     C                   ENDIF                                                                CRE005
      *                                                                                       CRE005
     C                   IF        RIDICT=*ZEROS                                              CRE005
     C                   IF        AMDRIB<>BA_DRIB or AMDRIS<>BA_DRIS                         CRE005
     C                             or BXAODR<>BX_ATAODR and CRE001<>'Y'                       CRE005
      *                                                                                       CRE005
      ** Get next available transaction number                                                CRE005
      *                                                                                       CRE005
     C                   Z-ADD     *ZERO         NATN                                         CRE005
     C                   CALLB     'ZTNLU1'                                                   CRE005
     C                   PARM      *BLANK        Retrn                                        CRE005
     C                   PARM                    NATN                                         CRE005
      ** Database Error if ReturnCode not blank                                               CRE005
      *                                                                                       CRE005
     C     Retrn         IFNE      *BLANK                                                     CRE005
     C                   MOVEL     NATN          DBKEY                                        CRE005
     C                   MOVEL     'MNATN  '     DBFILE                                       CRE005
     C                   MOVEL     '025'         DBASE                                        CRE005
     C                   EXSR      SRERR                                                      CRE005
     C                   END                                                                  CRE005
     C                   EVAL      WWNATN=NATN                                                CRE005
                                                                                              CRE005
     C                   MOVEL     'D'           DRCR              1                        AR871763
     C                   EXSR      SRGETBR                                                  AR871763
     C                   EVAL      I1CNUM = AMCNUM                                            CRE005
     C                   EVAL      I1CCY  = AMCCY                                             CRE005
     C                   EVAL      I1ACOD = AMACOD                                            CRE005
     C                   EVAL      I1ACSQ = AMACSQ                                            CRE005
     C                   EVAL      I1RSEQ = '1'                                               CRE005
     C                   EVAL      I1CONI = *BLANKS                                           CRE005
     C                   EVAL      I1ACNO = AMACNO                                            CRE005
     C                   EVAL      I1PSTD = BJRDNB                                            CRE005
     C                   EVAL      I1VALD = AMDRCD                                            CRE005
     C                   EVAL      I1PNAR = '9010 RATE CHANGE'                                CRE005
     C                   EVAL      I1INTP = RIDICT                                            CRE005
     C                   EVAL      I1INST = RIDCST                                            CRE005
     C                   EVAL      I1DRCR = 0                                                 CRE005
     C                   IF        CRE001 ='Y'                                                CRE005
     C                   EVAL      I1AODR = BXAODR                                            CRE005
     C                   IF        BXAODR<>BX_ATAODR and BXAODR<>*ZERO                        CRE005
     C                   Z-ADD     BXORTC        I1VALD                                       CRE005
     C                   ENDIF                                                                CRE005
     C                   ENDIF                                                                CRE005
     C                   TIME                    I1TIME                                       CRE005
     C                   EVAL      I1SPOS = 'GE/RC'                                           CRE005
      ** Timestamp                                                                          MD034366
     C                   CALLB     'ZAGENTMSTM'                                             MD034366
     C                   PARM                    TimeStamp                                  MD034366
     C                   EVAL      I1TSTMP = TimeStamp                                      MD034366
     C                   EVAL      I1BRCA = AMBRCA                                            CRE005
     C                   EVAL      I1ZZ001 = 'R'                                              CRE005
     C                   EVAL      I1RVLD = *ZEROS                                            CRE005
     C                   BITOFF    '01234567'    I1PRIN                                       CRE005
     C                   EVAL      I1LRCD = AMDRCD                                            CRE005
     C                   EVAL      I1INRT = *ZEROS                                            CRE005
     C                   EVAL      I1RTSP = *ZEROS                                            CRE005
     C**********         EVAL      I1WRUN = BJRDNB                                            CRE005
     C**********         EVAL      I1TRNO = WWTRNO                                            CRE005
     C**********         EVAL      I1NATN = WWNATN                                            CRE005
     C                   EVAL      I1RECI = 'R'                                               CRE005
     C                   EVAL      I1RTSP = AMDRIS                                            CRE005
     C                   EVAL      I1INRT = AMDRIS                                            CRE005
     C                   IF        AMDRIB = *ZEROS                                            CRE005
     C**********         EVAL      I1BRT  = *ZERO                                      CRE005 CSD103
     C                   EVAL      I1BRT  = *BLANKS                                           CSD103
     C                   ELSE                                                                 CRE005
     C                   EVAL      I1BRT  = AMDRIB                                            CRE005
     C                   EVAL      I1INRT = WWDBRT + AMDRIS                                   CRE005
     C**********         EVAL      I1INRT = WWDBRT                                            CRE005
     C                   ENDIF                                                                CRE005
     C                   WRITE     RERCH1D0                                                   CRE005
      *                                                                                       CRE005
      ** Add 1 to header record field                                                         CRE005
     C                   ADD       1             WNORS                                        CRE005
     C*                                                                                       CRE005
     C                   ENDIF                                                                CRE005
     C                   ENDIF                                                                CRE005
      *                                                                                       CRE005
      ** CREDIT RATE CHANGE                                                                   CRE005
      *                                                                                       CRE005
      ** Output only if no Flat Rate                                                          CRE005
      *                                                                                       CRE005
     C                   IF        AMCRIB=*ZEROS and AMCRIS=*ZEROS                            CRE005
     C                   IF        RICICT<>BR_CICT or RICCST<>BR_CCST                         CRE005
      *                                                                                       CRE005
      ** Get next available transaction number                                                CRE005
      *                                                                                       CRE005
     C                   Z-ADD     *ZERO         NATN                                         CRE005
     C                   CALLB     'ZTNLU1'                                                   CRE005
     C                   PARM      *BLANK        Retrn                                        CRE005
     C                   PARM                    NATN                                         CRE005
      ** Database Error if ReturnCode not blank                                               CRE005
      *                                                                                       CRE005
     C     Retrn         IFNE      *BLANK                                                     CRE005
     C                   MOVEL     NATN          DBKEY                                        CRE005
     C                   MOVEL     'MNATN  '     DBFILE                                       CRE005
     C                   MOVEL     '029'         DBASE                                        CRE005
     C                   EXSR      SRERR                                                      CRE005
     C                   END                                                                  CRE005
     C                   EVAL      WWNATN=NATN                                                CRE005
      *                                                                                       CRE005
      ** Access Interest Type/Sub Type only if not zero                                       CRE005
      *                                                                                       CRE005
     C**********         EVAL      I1BRT =*ZERO                                        CRE005 CSD103
     C                   EVAL      I1BRT =*BLANKS                                             CSD103
     C                   IF        RICICT<>*ZERO or RICCST<>*ZERO                             CRE005
     C                   EVAL      IntTyp=RICICT                                              CRE005
     C                   EVAL      IntSubTyp=RICCST                                           CRE005
     C                   EVAL      Curr=RICCY                                                 CRE005
     C                   EVAL      RecD='D'                                                   CRE005
     C     ReintKey      CHAIN     REINT                              80                      CRE005
                                                                                              CRE005
      ** DATABASE ERROR                                                                       CRE005
     C     *IN80         IFEQ      '1'                                                        CRE005
     C                   EVAL      DBKEY=ReintKey                                             CRE005
     C                   MOVEL     'REINT  '     DBFILE                                       CRE005
     C                   MOVEL     '031'         DBASE                                        CRE005
     C                   EXSR      SRERR                                                      CRE005
     C                   END                                                                  CRE005
                                                                                              CRE005
     C                   EVAL      I1BRT  = RT_BRT                                            CRE005
     C                   EVAL      WWCBRT = 0                                                 236976
      *                                                                                       236976
      ** Access Midas Base Rate details CREDIT                                                236976
      *                                                                                       236976
     C*****RT_BRT        IFNE      *ZEROS                                              236976 CSD103
     C     RT_BRT        IFNE      *BLANKS                                                    CSD103
      *                                                                                       236976
     C                   MOVEL(P)  RT_BRT        @BSRC                                        236976
     C                   CALLB     'AOBSRTR0'                                                 236976
     C                   PARM      '*MSG    '    @RTCD                                        236976
     C                   PARM      '*KEY    '    @OPTN                                        236976
     C                   PARM      RICCY         @CYCD                                        236976
     C                   PARM                    @BSRC                                        236976
     C     SDBSRT        PARM      SDBSRT        DSSDY                                        236976
      *                                                                                       236976
      * DATABASE ERROR                                                                        236976
      *                                                                                       236976
     C     @RTCD         IFNE      *BLANK                                                     236976
     C                   MOVEL     RT_BRT        DBKEY                                        236976
     C                   MOVEL     'SDBSRTPD'    DBFILE                                       236976
     C                   MOVEL     '804'         DBASE                                        236976
     C                   EXSR      SRERR                                                      236976
     C                   END                                                                  236976
     C                   EVAL      WWCBRT = BANBRT                                            236976
     C                   ENDIF                                                                236976
     C                   ENDIF                                                                236976
      *                                                                                       CRE005
     C                   EVAL      I1CNUM = AMCNUM                                            CRE005
     C                   EVAL      I1CCY  = AMCCY                                             CRE005
     C                   EVAL      I1ACOD = AMACOD                                            CRE005
     C                   EVAL      I1ACSQ = AMACSQ                                            CRE005
     C                   EVAL      I1RSEQ = '1'                                               CRE005
     C                   EVAL      I1CONI = 'X'                                               CRE005
     C                   EVAL      I1ACNO = AMACNO                                            CRE005
     C                   EVAL      I1PSTD = BJRDNB                                            CRE005
     C**********         EVAL      I1VALD = AMDRCD                                            CRE005
     C                   EVAL      I1VALD = AMCRCD                                            CRE005
     C                   EVAL      I1PNAR = '9010 RATE CHANGE'                                CRE005
     C                   EVAL      I1INTP = RICICT                                            CRE005
     C                   EVAL      I1INST = RICCST                                            CRE005
     C                   EVAL      I1DRCR = 1                                                 CRE005
     C                   IF        CRE001 ='Y'                                                CRE005
     C                   EVAL      I1AODR = *ZERO                                             CRE005
     C                   ENDIF                                                                CRE005
     C                   TIME                    I1TIME                                       CRE005
     C                   EVAL      I1SPOS = 'GE/RC'                                           CRE005
      ** Timestamp                                                                          MD034366
     C                   CALLB     'ZAGENTMSTM'                                             MD034366
     C                   PARM                    TimeStamp                                  MD034366
     C                   EVAL      I1TSTMP = TimeStamp                                      MD034366
     C                   EVAL      I1BRCA = AMBRCA                                            CRE005
     C                   EVAL      I1ZZ001 = 'R'                                              CRE005
     C                   EVAL      I1RVLD = *ZEROS                                            CRE005
     C                   BITOFF    '01234567'    I1PRIN                                       CRE005
     C**********         EVAL      I1LRCD = AMDRCD                                            CRE005
     C                   EVAL      I1LRCD = AMCRCD                                            CRE005
     C                   EVAL      I1INRT = *ZEROS                                            CRE005
     C                   EVAL      I1RTSP = *ZEROS                                            CRE005
     C**********         EVAL      I1WRUN = BJRDNB                                            CRE005
     C**********         EVAL      I1TRNO = WWTRNO                                            CRE005
     C**********         EVAL      I1NATN = WWNATN                                            CRE005
     C                   EVAL      I1RECI = 'R'                                               CRE005
     C                   WRITE     RERCH1D0                                                   CRE005
      *                                                                                       CRE005
      ** Add 1 to header record field                                                         CRE005
     C                   ADD       1             WNORS                                        CRE005
                                                                                              CRE005
     C                   EVAL      I2CNUM = AMCNUM                                            CRE005
     C                   EVAL      I2CCY  = AMCCY                                             CRE005
     C                   EVAL      I2ACOD = AMACOD                                            CRE005
     C                   EVAL      I2ACSQ = AMACSQ                                            CRE005
     C                   EVAL      I2RSEQ = '2'                                               CRE005
     C                   EVAL      I2CONI = 'X'                                               CRE005
     C                   EVAL      I2INTH = RT_INTH                                           CRE005
     C**********         EVAL      I2VALD = AMDRCD                                            CRE005
     C                   EVAL      I2VALD = AMCRCD                                            CRE005
     C                   EVAL      I2DRCR = 1                                                 CRE005
     C**********         TIME                    I2TIME                                CRE005 233901
     C                   EVAL      I2TIME = I1TIME                                            233901
     C                   EVAL      I2TSTMP = I1TSTMP                                        MD034366
     C                   EVAL      I2BRCA = AMBRCA                                            CRE005
     C                   EVAL      I2BAL1   = RT_BAL2                                         CRE005
     C                   EVAL      I2RAT1   = RT_RAT2                                         CRE005
     C**********         EVAL      I2TRNO = WWTRNO                                            CRE005
     C**********         EVAL      I2NATN = WWNATN                                            CRE005
     C                   EVAL      I2RECI = 'R'                                               CRE005
                                                                                              CRE005
     C* Initial Threshhold, balance and Rate Spread set to zero in                            CRE005
     C* RERCH2PD if Credit interest type is blank                                             CRE005
     C                   IF        RICICT=*ZERO                                               CRE005
     C                   Z-ADD     *ZERO         I2INTH                                       CRE005
     C                   EVAL      IBAL1A  = *ZERO                                            CRE005
     C                   EVAL      IBAL1B  = *ZERO                                            CRE005
     C                   EVAL      IBAL1C  = *ZERO                                            CRE005
     C                   EVAL      IBAL1D  = *ZERO                                            CRE005
     C                   EVAL      IBAL1E  = *ZERO                                            CRE005
     C                   EVAL      IBAL1F  = *ZERO                                            CRE005
     C                   EVAL      IRAT1A  = *ZERO                                            CRE005
     C                   EVAL      IRAT1B  = *ZERO                                            CRE005
     C                   EVAL      IRAT1C  = *ZERO                                            CRE005
     C                   EVAL      IRAT1D  = *ZERO                                            CRE005
     C                   EVAL      IRAT1E  = *ZERO                                            CRE005
     C                   EVAL      IRAT1F  = *ZERO                                            CRE005
     C                   ENDIF                                                                CRE005
     C* Add new Base Rate with Rate Spread in RERCH2PD if Credit                              CRE005
     C* interest type is equal to 2                                                           CRE005
     C                   IF        RICICT>*ZERO                                               CRE005
     C* Use new Credit Base Rate                                                              CRE005
     C                   ADD       WWCBRT        IRAT1A                                       CRE005
     C* Must now use balance not rate to determine when the end of                            CRE005
     C* the Tiers/Thresh has been reached and so omit the base rate                           CRE005
     C                   IF        IBAL1B<>*ZERO                                              CRE005
     C                   ADD       WWCBRT        IRAT1B                                       CRE005
     C                   ENDIF                                                                CRE005
     C                   IF        IBAL1C<>*ZERO                                              CRE005
     C                   ADD       WWCBRT        IRAT1C                                       CRE005
     C                   ENDIF                                                                CRE005
     C                   IF        IBAL1D<>*ZERO                                              CRE005
     C                   ADD       WWCBRT        IRAT1D                                       CRE005
     C                   ENDIF                                                                CRE005
     C                   IF        IBAL1E<>*ZERO                                              CRE005
     C                   ADD       WWCBRT        IRAT1E                                       CRE005
     C                   ENDIF                                                                CRE005
     C                   IF        IBAL1F<>*ZERO                                              CRE005
     C                   ADD       WWCBRT        IRAT1F                                       CRE005
     C                   ENDIF                                                                CRE005
     C                   ENDIF                                                                CRE005
     C                   WRITE     RERCH2D0                                                   CRE005
      *                                                                                       CRE005
      ** Add 1 to header record field                                                         CRE005
     C                   ADD       1             WNORS                                        CRE005
                                                                                              CRE005
     C                   EVAL      I3CNUM = AMCNUM                                            CRE005
     C                   EVAL      I3CCY  = AMCCY                                             CRE005
     C                   EVAL      I3ACOD = AMACOD                                            CRE005
     C                   EVAL      I3ACSQ = AMACSQ                                            CRE005
     C                   EVAL      I3RSEQ = '3'                                               CRE005
     C**********         EVAL      I3VALD = AMDRCD                                            CRE005
     C                   EVAL      I3VALD = AMCRCD                                            CRE005
     C                   EVAL      I3DRCR = 1                                                 CRE005
     C**********         TIME                    I3TIME                                CRE005 233901
     C                   EVAL      I3TIME = I1TIME                                            233901
     C                   EVAL      I3TSTMP = I1TSTMP                                        MD034366
     C                   EVAL      I3BRCA = AMBRCA                                            CRE005
     C**********         EVAL      I3BAL3   = RT_BAL2                                  CRE005 236976
     C**********         EVAL      I3RAT3   = RT_RAT2                                  CRE005 236976
     C                   MOVE      RT_BAL2       I3BAL3                                       236976
     C                   MOVE      RT_RAT2       I3RAT3                                       236976
     C*********          EVAL      I3TRNO = WWTRNO                                            CRE005
     C*********          EVAL      I3NATN = WWNATN                                            CRE005
     C                   EVAL      I3RECI = 'R'                                               CRE005
     C* Initial Threshhold, balance and Rate Spread set to zero in                            CRE005
     C* RERCH3PD if Credit interest type is blank                                             CRE005
     C**********         IF        RIDICT=*ZERO                                        CRE005 236976
     C                   IF        RICICT=*ZERO                                               236976
     C                   EVAL      IBAL3A  = *ZERO                                            CRE005
     C                   EVAL      IBAL3B  = *ZERO                                            CRE005
     C                   EVAL      IBAL3C  = *ZERO                                            CRE005
     C                   EVAL      IBAL3D  = *ZERO                                            CRE005
     C                   EVAL      IBAL3E  = *ZERO                                            CRE005
     C                   EVAL      IRAT3A  = *ZERO                                            CRE005
     C                   EVAL      IRAT3B  = *ZERO                                            CRE005
     C                   EVAL      IRAT3C  = *ZERO                                            CRE005
     C                   EVAL      IRAT3D  = *ZERO                                            CRE005
     C                   EVAL      IRAT3E  = *ZERO                                            CRE005
     C                   ENDIF                                                                CRE005
     C* Add new Base Rate with Rate Spread in RERCH3PD if Credit                              CRE005
     C* interest type is not 0                                                                CRE005
     C                   IF        RICICT>*ZERO                                               CRE005
     C                   IF        IBAL3A<>*ZERO                                              CRE005
     C                   ADD       WWCBRT        IRAT3A                                       CRE005
     C                   ENDIF                                                                CRE005
     C* Must not use balance not rate to determine when the end of                            CRE005
     C* the Tiers/Thresh has been reached and so omit the base rate                           CRE005
     C                   IF        IBAL3B<>*ZERO                                              CRE005
     C                   ADD       WWCBRT        IRAT3B                                       CRE005
     C                   ENDIF                                                                CRE005
     C                   IF        IBAL3C<>*ZERO                                              CRE005
     C                   ADD       WWCBRT        IRAT3C                                       CRE005
     C                   ENDIF                                                                CRE005
     C                   IF        IBAL3D<>*ZERO                                              CRE005
     C                   ADD       WWCBRT        IRAT3D                                       CRE005
     C                   ENDIF                                                                CRE005
     C                   IF        IBAL3E<>*ZERO                                              CRE005
     C                   ADD       WWCBRT        IRAT3E                                       CRE005
     C                   ENDIF                                                                CRE005
     C                   ENDIF                                                                CRE005
     C                   MOVEL     I3BAL3        I3BAL1                                     MD034366
     C                   MOVEL     I3RAT3        I3RAT1                                     MD034366
     C                   WRITE     RERCH3D0                                                   CRE005
                                                                                              CRE005
      ** Add 1 to header record field                                                         CRE005
     C                   ADD       1             WNORS                                        CRE005
                                                                                              CRE005
     C                   ENDIF                                                                CRE005
     C**********         ENDIF                                                         CRE005 236976
     C                   ENDIF                                                                CRE005
      *                                                                                       CRE005
     C                   IF        RICICT=*ZEROS                                              CRE005
     C                   IF        AMCRIB<>BA_CRIB or AMCRIS<>BA_CRIS                         CRE005
      *                                                                                       CRE005
      ** Get next available transaction number                                                CRE005
      *                                                                                       CRE005
     C                   Z-ADD     *ZERO         NATN                                         CRE005
     C                   CALLB     'ZTNLU1'                                                   CRE005
     C                   PARM      *BLANK        Retrn                                        CRE005
     C                   PARM                    NATN                                         CRE005
      ** Database Error if ReturnCode not blank                                               CRE005
      *                                                                                       CRE005
     C     Retrn         IFNE      *BLANK                                                     CRE005
     C                   MOVEL     NATN          DBKEY                                        CRE005
     C                   MOVEL     'MNATN  '     DBFILE                                       CRE005
     C                   MOVEL     '035'         DBASE                                        CRE005
     C                   EXSR      SRERR                                                      CRE005
     C                   END                                                                  CRE005
     C                   EVAL      WWNATN=NATN                                                CRE005
                                                                                              CRE005
     C                   MOVEL     'C'           DRCR              1                        AR871763
     C                   EXSR      SRGETBR                                                  AR871763
     C                   EVAL      I1CNUM = AMCNUM                                            CRE005
     C                   EVAL      I1CCY  = AMCCY                                             CRE005
     C                   EVAL      I1ACOD = AMACOD                                            CRE005
     C                   EVAL      I1ACSQ = AMACSQ                                            CRE005
     C                   EVAL      I1RSEQ = '1'                                               CRE005
     C                   EVAL      I1CONI = *BLANKS                                           CRE005
     C                   EVAL      I1ACNO = AMACNO                                            CRE005
     C                   EVAL      I1PSTD = BJRDNB                                            CRE005
     C**********         EVAL      I1VALD = AMDRCD                                            CRE005
     C                   EVAL      I1VALD = AMCRCD                                            CRE005
     C                   EVAL      I1PNAR = '9010 RATE CHANGE'                                CRE005
     C                   EVAL      I1INTP = RICICT                                            CRE005
     C                   EVAL      I1INST = RICCST                                            CRE005
     C                   EVAL      I1DRCR = 1                                                 CRE005
     C                   IF        CRE001 ='Y'                                                CRE005
     C                   EVAL      I1AODR = *ZERO                                             CRE005
     C                   ENDIF                                                                CRE005
     C                   TIME                    I1TIME                                       CRE005
     C                   EVAL      I1SPOS = 'GE/RC'                                           CRE005
      ** Timestamp                                                                          MD034366
     C                   CALLB     'ZAGENTMSTM'                                             MD034366
     C                   PARM                    TimeStamp                                  MD034366
     C                   EVAL      I1TSTMP = TimeStamp                                      MD034366
     C                   EVAL      I1BRCA = AMBRCA                                            CRE005
     C                   EVAL      I1ZZ001 = 'R'                                              CRE005
     C                   EVAL      I1RVLD = *ZEROS                                            CRE005
     C                   BITOFF    '01234567'    I1PRIN                                       CRE005
     C**********         EVAL      I1OLDR = AMDRCD                                            CRE005
     C                   EVAL      I1LRCD = AMCRCD                                            CRE005
     C                   EVAL      I1INRT = *ZEROS                                            CRE005
     C**********         EVAL      I1WRUN = BJRDNB                                            CRE005
     C**********         EVAL      I1TRNO = WWTRNO                                            CRE005
     C**********         EVAL      I1NATN = WWNATN                                            CRE005
     C                   EVAL      I1RECI = 'R'                                               CRE005
     C                   EVAL      I1RTSP = AMCRIS                                            CRE005
     C                   EVAL      I1INRT = AMCRIS                                            CRE005
     C                   IF        AMCRIB = *ZEROS                                            CRE005
     C**********         EVAL      I1BRT  = *ZERO                                      CRE005 CSD103
     C                   EVAL      I1BRT  = *BLANKS                                           CSD103
     C                   ELSE                                                                 CRE005
     C                   EVAL      I1BRT  = AMCRIB                                            CRE005
     C                   EVAL      I1INRT = WWCBRT + AMCRIS                                   CRE005
     C**********         EVAL      I1INRT = WWCBRT                                            CRE005
     C                   ENDIF                                                                CRE005
     C                   WRITE     RERCH1D0                                                   CRE005
      *                                                                                       CRE005
      ** Add 1 to header record field                                                         CRE005
     C                   ADD       1             WNORS                                        CRE005
                                                                                              CRE005
     C                   ENDIF                                                                CRE005
     C                   ENDIF                                                                CRE005
                                                                                              CRE005
      ** Read header record before update                                                     CRE005
     C     1             SETLL     RERCHHA0                                                   CRE005
     C                   READ      RERCHHA0                               80                  CRE005
                                                                                              CRE005
      ** DATABASE ERROR                                                                       CRE005
     C     *IN80         IFEQ      '1'                                                        CRE005
     C                   EVAL      DBKEY='1'                                                  CRE005
     C                   MOVEL     'RERCHHPA'    DBFILE                                       CRE005
     C                   MOVEL     '121'         DBASE                                        CRE005
     C                   EXSR      SRERR                                                      CRE005
     C                   END                                                                  CRE005
                                                                                              CRE005
      ** Update header record in Header file                                                  CRE005
     C     WNORS         ADD       IH_NOREC      IH_NOREC                                     CRE005
     C                   UPDATE    RERCHHA0                                                   CRE005
      *                                                                                       CRE005
     C                   ENDSR                                                                CRE005
      ****************************************************************                      AR871763
      /EJECT                                                                                AR871763
      ****************************************************************                      AR871763
      *                                                              *                      AR871763
      * SRGETBR - Get base rate from SDBRCHPD                        *                      AR871763
      *                                                              *                      AR871763
      ****************************************************************                      AR871763
     C     SRGETBR       BEGSR                                                              AR871763
      *                                                                                     AR871763
     C     DRCR          IFEQ      'D'                                                      AR871763
     C                   MOVEL(P)  AMDRIB        @BSRC                                      AR871763
     C                   ELSE                                                               AR871763
     C                   MOVEL(P)  AMCRIB        @BSRC                                      AR871763
     C                   ENDIF                                                              AR871763
     C                   IF        @BSRC <> '00'                                            AR883751
     C                   CALLB     'AOBSRTR0'                                               AR871763
     C                   PARM      '*MSG    '    @RTCD                                      AR871763
     C                   PARM      '*KEY    '    @OPTN                                      AR871763
     C                   PARM      AMCCY         @CYCD                                      AR871763
     C                   PARM                    @BSRC                                      AR871763
     C     SDBSRT        PARM      SDBSRT        DSSDY                                      AR871763
      *                                                                                     AR871763
      * DATABASE ERROR                                                                      AR871763
      *                                                                                     AR871763
     C     @RTCD         IFNE      *BLANK                                                   AR871763
     C                   MOVEL     @BSRC         DBKEY                                      AR871763
     C                   MOVEL     'SDBSRTPD'    DBFILE                                     AR871763
     C                   MOVEL     '808'         DBASE                                      AR871763
     C                   EXSR      SRERR                                                    AR871763
     C                   END                                                                AR871763
     C     DRCR          IFEQ      'D'                                                      AR871763
     C                   EVAL      WWDBRT = BANBRT                                          AR871763
     C                   ELSE                                                               AR871763
     C                   EVAL      WWCBRT = BANBRT                                          AR871763
     C                   ENDIF                                                              AR871763
     C                   ENDIF                                                              AR883751
     C                   ENDSR                                                              AR871763
     C****************************************************************                        CRE005
      /EJECT                                                                                  CRE005
                                                                                              CRE005
     C****************************************************************
     C*                                                              *
     C**UpdateRet****-*Update*Retail*details*for*Insert*             *                       BUG7194
     C* UpdateRet    - Update Retail details for Amend               *                       BUG7194
     C*                                                              *
     C****************************************************************
     C     UpdateRet     BEGSR
      *
      ***If*CRE001 (Overdraft Interest Calculations) is installed and                         231128
      ***Account*is Retail                                                                    231128
      ***or*CDE002 is installed and Account is Retail                                  CDE002 231128
      ***********                                                                             231128
     C**********         IF        CRE001='Y'                                                BUG7194
     C**********                   or CDE002 = 'Y'                                    CDE002 BUG7194
     C/COPY WNCPYSRC,GLAMADDC12
     C*****BGWDPR        IFEQ      'Y'                                                        239720
     C*****BGSWRT        ANDEQ     'Y'                                                        239720
     C*****AMATYP        ANDEQ     'R'                                                        239720
      ***********                                                                             239720
     C*****BGWDPR        OREQ      'Y'                                                        239720
     C*****BGNTST        ANDEQ     'Y'                                                        239720
     C*****AMATYP        ANDEQ     'R'                                                        239720
     C*****BGWDPR        OREQ      'Y'                                                        239720
     C*****FACH**        ANDEQ     'Y'                                                        239720
     C*****AMATYP        ANDEQ     'R'                                                        239720
     C*****BGWDPR        OREQ      'Y'                                                        239720
     C*****TSTMC*        ANDEQ     'Y'                                                        239720
     C*****AMATYP        ANDEQ     'R'                                                        239720
      *                                                                                       239720
      *  Check if Account Retail                                                              239720
     C     AMATYP        IFEQ      'R'                                                        239720
      *
      ** Update Account Master Extension File
      *
     C     AccntKey      CHAIN     ACCNTBXC                           8081
      ** DATABASE ERROR
     C     *IN80         IFEQ      '1'
     C     *IN81         OREQ      '1'
     C                   MOVEL     DBerrKey      DBKEY
     C                   MOVEL     'ACCNTBXC'    DBFILE                         ************
     C                   MOVEL     '047'         DBASE                          * DBERR 047*
     C                   EXSR      SRERR                                        ************
     C                   ENDIF
      ** Store Old fields for comparisons
     C                   MOVEL(P)  ACCNTX        B_ACCNTX

     C                   EVAL      AX_ATCNUM=BXCNUM
     C                   EVAL      AX_ATCCY=BXCCY
     C                   EVAL      AX_ATACOD=BXACOD
     C                   EVAL      AX_ATACSQ=BXACSQ
     C                   EVAL      AX_ATCRST=BXCRST
     C                   EVAL      AX_ATSUBO=BXSUBO
     C                   EVAL      AX_ATITAX=BXITAX
     C                   IF        CGL165 = 'Y'                                               CGL165
     C                   EVAL      AX_ATTXC1=BXTXC1                                           CGL165
     C                   EVAL      AX_ATTXC2=BXTXC2                                           CGL165
     C                   ENDIF                                                                CGL165
     C                   EVAL      AX_ATSTCI=BXSTCI
     C                   EVAL      AX_ATCHIN=BXCHIN
     C                   EVAL      AX_ATCHAM=BXCHAM
     C                   EVAL      AX_ZZ100=BXZZ100
     C                   EVAL      AX_ATBRCA=BXBRCA
     C                   EVAL      AX_ATFRNT=BXFRNT
     C                   EVAL      AX_ATAFRT=BXAFRT
     C                   EVAL      AX_ATREPA=BXREPA
     C                   EVAL      AX_ATAODR=BXAODR
     C                   EVAL      AX_ATORTC=BXORTC
     C                   EVAL      AX_ATOLVD=BXOLVD
     C                   EVAL      AX_ATITRD=BXITRD
     C                   EVAL      AX_ATPOLE=*ZEROS
      *                                                                                       CER055
     C                   IF        CER055 = 'Y'                                               CER055
     C                   MOVE      BXPOLC        AX_ATPOLC                                    CER055
     C                   MOVE      BXPOLE        AX_ATPOLE                                    CER055
     C                   EVAL      AX_ATPOLA = BXPOLA                                         CER055
      *                                                                                       CER055
     C                   ELSE                                                                 CER055
      * If Overdraft Line Change Value Date is <= Value Date  or =Rundate
     C                   IF        BXOLVD<=BJRDNB and BXOLVD<>*ZERO
     C                   Z-ADD     BXOLVD        AX_ATPOLC
     C                   ENDIF
      * If Overdraft Expiry Date has changed
     C                   IF        AMODED<>BA_ODED
     C                   Z-ADD     AMODED        AX_ATPOLE
     C                   ENDIF
                                                                                CAP013
     C                   ENDIF                                                                CER055
      ** Front Office ID                                                        CAP013
     C                   EVAL      AX_ATFRNT=BXFRNT                             CAP013
      ** Associated Front Office ID                                             CAP013
     C                   EVAL      AX_ATAFRT=BXAFRT                             CAP013
      ** Timestamp                                                              CAP013
     C                   EVAL      AX_ATTMST=BXTMES                             CAP013
                                                                                CDE002
      ** If CDE002 is present update Dr/Cr Margin fields                        CDE002
     C                                                                          CDE002
     C                   IF        CDE002 = 'Y'                                 CDE002
                                                                                CDE002
      ** If Debit Margin Override or Debit Margin have changed                  CDE002
                                                                                CDE002
     C                   IF        BXOVRD <> AX_ATOVRD or                       CDE002
     C**********                   BXDRMG <> AX_ATDRMG                    CDE002208221
     C                             BXDRMG <> AX_ATDRMG or                       208221
     C                             BXDMBR <> AX_ATDMBR                          208221
     C                   EVAL      AX_ATDRMD = BJRDNB                           CDE002
     C                   ENDIF                                                  CDE002
                                                                                CDE002
      ** If Credit Margin Override or Credit Margin have changed                CDE002
                                                                                CDE002
     C                   IF        BXOVRC <> AX_ATOVRC or                       CDE002
     C**********                   BXCRMG <> AX_ATCRMG                    CDE002208221
     C                             BXCRMG <> AX_ATCRMG or                       208221
     C                             BXCMBR <> AX_ATCMBR                          208221
     C                   EVAL      AX_ATCRMD = BJRDNB                           CDE002
     C                   ENDIF                                                  CDE002
                                                                                CDE002
     C                   EVAL      AX_ATACNO = AMACNO                           CDE002
     C                   EVAL      AX_ATOVRD = BXOVRD                           CDE002
     C                   EVAL      AX_ATOVRC = BXOVRC                           CDE002
     C                   EVAL      AX_ATDRMG = BXDRMG                           CDE002
     C                   EVAL      AX_ATCRMG = BXCRMG                           CDE002
     C                   EVAL      AX_ATDMBR = BXDMBR                           208221
     C                   EVAL      AX_ATCMBR = BXCMBR                           208221
                                                                                CDE002
     C                   ENDIF                                                  CDE002
                                                                                CDE002
      *                                                                                       CER050
     C                   If        CER050 = 'Y'                                               CER050
     C                   Eval      AX_ATAPRC = BXAPRC                                         CER050
     C                   Endif                                                                CER050
      *                                                                                       CER050
     C                   UPDATE    ACCNTBD0
     C                   ENDIF
     C**********         ENDIF                                                               BUG7194
      *
      ** If Overdraft present (Expiry Date Entered or Changed) REODHSPD
      *
     C                   IF        BA_ODLN<>AMODLN or BA_ODED<>AMODED
     C/COPY WNCPYSRC,GLAMADDC08
     C                   EVAL      Date=BXOLVD
     C     REODHKey      CHAIN     REODHSL0                           8081
      ** DATABASE ERROR
     C     *IN81         IFEQ      '1'
     C                   MOVEL     DBerrKey      DBKEY
     C                   MOVEL     'REODHSL0'    DBFILE                         ************
     C**********         MOVEL     '048'         DBASE                          **DBERR*017* BUG7194
     C                   MOVEL     '048'         DBASE                          * DBERR 048* BUG7194
     C                   EXSR      SRERR                                        ************
     C                   ENDIF
     C     *IN80         IFEQ      '1'
     C                   CLEAR                   REODHSD0
     C                   EVAL      RO_BRCA=BXBRCA
     C                   EVAL      RO_CNUM=BXCNUM
     C                   EVAL      RO_CCY =BXCCY
     C                   EVAL      RO_ACOD=BXACOD
     C                   EVAL      RO_ACSQ=BXACSQ
     C                   EVAL      RO_ACNO=AMACNO
     C                   EVAL      RO_HISD=BXOLVD
     C                   EVAL      RO_ODLN=AMODLN
     C                   EVAL      RO_ODED=AMODED
     C                   WRITE     REODHSD0
     C                   ELSE
     C                   EVAL      RO_PODL=BA_ODLN
     C                   EVAL      RO_POLE=BA_ODED
     C                   EVAL      RO_ODLN=AMODLN
     C                   EVAL      RO_ODED=AMODED
     C                   UPDATE    REODHSD0
     C                   ENDIF
     C                   ENDIF
      *
      ** If Calculation Basis changed then Update Retail History
      *
     C                   IF        BGNXST='Y' or BGNYST='Y'
     C**********         IF        AMACNO<>*ZERO                                              203282
     C                   IF        AMATYP = 'R'                                               203282
     C                   IF        BA_DRIC<>AMDRIC
      ** Check if there is a Capitalisation
     C                   IF        AMLDID=AMDACO
      *
     C     RehisKey      CHAIN     REHISBL                            8081
      ** DATABASE ERROR
     C     *IN80         IFEQ      '1'
     C     *IN81         OREQ      '1'
     C                   MOVEL     DBerrKey      DBKEY
     C                   MOVEL     'REHISBL'     DBFILE                         ************
     C                   MOVEL     '049'         DBASE                          * DBERR 049*
     C                   EXSR      SRERR                                        ************
     C                   END
     C     *IN81         IFEQ      '0'
     C                   EVAL      RH_DRCB=AMDRIC
     C                   EVAL      RH_ADTY='Y'
     C                   Z-ADD     RH_HISD       RH_VDTC
     C                   UPDATE    REHISPPF
     C                   END
     C                   ELSE
      *
      ** Access last Capitalisation S record
      *
     C                   EVAL      Date=AMLDID
     C**********         IF        BMLDAI='Y'                                                 211254
     C                   IF        BMLDAI<>'Y'                                                211254
     C                   ADD       1             Date
     C                   ENDIF
     C     REODHKey      CHAIN     REHISLS                            8081
      ** DATABASE ERROR
     C     *IN80         IFEQ      '1'
     C     *IN81         OREQ      '1'
     C                   MOVEL     DBerrKey      DBKEY
     C                   MOVE      Date          DBKEY
     C                   MOVEL     'REHISLS '    DBFILE                         ************
     C                   MOVEL     '050'         DBASE                          * DBERR 050*
     C                   EXSR      SRERR                                        ************
     C                   ENDIF
     C                   Z-ADD     AMDRIC        RL_DRCB                        ************
     C                   UPDATE    REHISPSF
      *
      ** Access B record to force recalculation of interest since
      ** last capitalisation
      *
     C     RehisKey      CHAIN     REHISBL                            8081
      ** DATABASE ERROR
     C     *IN80         IFEQ      '1'
     C     *IN81         OREQ      '1'
     C                   MOVEL     DBerrKey      DBKEY
     C                   MOVEL     'REHISBL'     DBFILE                         ************
     C**********         MOVEL     '051'         DBASE                          **DBERR*049* BUG7194
     C                   MOVEL     '051'         DBASE                          * DBERR 051* BUG7194
     C                   EXSR      SRERR                                        ************
     C                   END
     C     *IN81         IFEQ      '0'
     C                   EVAL      RH_ADTY='Y'
     C                   IF        RH_VDTC>RL_HISD
     C                   Z-ADD     RL_HISD       RH_VDTC
     C                   UPDATE    REHISPPF
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF                                                                218554
     C
     C                   IF        BA_CRIC<>AMCRIC
      ** Check if there is a Capitalisation
     C                   IF        AMLCID=AMDACO
      *
     C     RehisKey      CHAIN     REHISBL                            8081
      ** DATABASE ERROR
     C     *IN80         IFEQ      '1'
     C     *IN81         OREQ      '1'
     C                   MOVEL     DBerrKey      DBKEY
     C                   MOVEL     'REHISBL'     DBFILE                         ************
     C**********         MOVEL     '052'         DBASE                          **DBERR*049* BUG7194
     C                   MOVEL     '052'         DBASE                          * DBERR 052* BUG7194
     C                   EXSR      SRERR                                        ************
     C                   END
     C     *IN81         IFEQ      '0'
     C                   EVAL      RH_CRCB=AMCRIC
     C                   EVAL      RH_ADTY='Y'
     C                   Z-ADD     RH_HISD       RH_VDTC
     C                   UPDATE    REHISPPF
     C                   END
     C                   ELSE
      *
      ** Access last Capitalisation S record
      *
     C                   EVAL      Date=AMLCID
     C**********         IF        BMLDAI='Y'                                                 211254
     C                   IF        BMLDAI<>'Y'                                                211254
     C                   ADD       1             Date
     C                   ENDIF
     C     REODHKey      CHAIN     REHISLS                            8081
      ** DATABASE ERROR
     C     *IN80         IFEQ      '1'
     C     *IN81         OREQ      '1'
     C                   MOVEL     DBerrKey      DBKEY
     C                   MOVE      Date          DBKEY
     C                   MOVEL     'REHISLS '    DBFILE                         ************
     C**********         MOVEL     '053'         DBASE                          **DBERR*050* BUG7194
     C                   MOVEL     '053'         DBASE                          * DBERR 053* BUG7194
     C                   EXSR      SRERR                                        ************
     C                   ENDIF
     C                   Z-ADD     AMCRIC        RL_CRCB                        ************
     C                   UPDATE    REHISPSF
      *
      ** Access B record to force recalculation of interest since
      ** last capitalisation
      *
     C     RehisKey      CHAIN     REHISBL                            8081
      ** DATABASE ERROR
     C     *IN80         IFEQ      '1'
     C     *IN81         OREQ      '1'
     C                   MOVEL     DBerrKey      DBKEY
     C                   MOVEL     'REHISBL'     DBFILE                         ************
     C**********         MOVEL     '054'         DBASE                          **DBERR*049* BUG7194
     C                   MOVEL     '054'         DBASE                          * DBERR 054* BUG7194
     C                   EXSR      SRERR                                        ************
     C                   END
     C     *IN81         IFEQ      '0'
     C                   EVAL      RH_ADTY='Y'
     C                   IF        RH_VDTC>RL_HISD
     C                   Z-ADD     RL_HISD       RH_VDTC
     C                   UPDATE    REHISPPF
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
     C**********         END                                                                  218554
      *
      ** Update Retail record
      *
     C                   IF        BGNXST='Y' or BGNYST='Y'
     C**********         IF        AMACNO<>*ZERO                                              203282
     C                   IF        AMATYP = 'R'                                               203282
     C     AccntKey      CHAIN     REIACDF                            80

      ** DATABASE ERROR
     C     *IN80         IFEQ      '1'
     C                   MOVEL     DBerrKey      DBKEY
     C                   MOVEL     'REIACD '     DBFILE                         ************
     C                   MOVEL     '055'         DBASE                          * DBERR 055*
     C                   EXSR      SRERR                                        ************
     C                   END
      ** Store Old fields for comparisons
     C                   MOVEL(P)  REIAD         B_REIAD

     C                   EVAL      RE_DICT=RIDICT
     C                   EVAL      RE_DCST=RIDCST
     C                   EVAL      RE_DACP=RIDACP
     C                   EVAL      RE_CICT=RICICT
     C                   EVAL      RE_CCST=RICCST
     C                   EVAL      RE_CACP=RICACP
     C                   EVAL      RE_CICP=*BLANKS
     C                   EVAL      RE_CHGT=RICHGT
     C                   EVAL      RE_CHST=RICHST
     C                   EVAL      RE_CHAC=RICHAC
     C                   EVAL      RE_PTRA=RIPTRA
     C                   EVAL      RE_PRCH=RIPRCH
      ** If Retail Teller Or Retail Branch Access is on
     C                   IF        CRT001='Y' or CRT002='Y'
     C                   EVAL      RE_PBKU=RIPBKU
     C                   ENDIF
     C                   EVAL      RE_TCHO=RITCHO
     C                   EVAL      RE_DRBR=RIDRBR
     C                   EVAL      RE_CRBR=RICRBR
     C                   EVAL      RE_CHBR=RICHBR
     C                   UPDATE    REIACDF
      *
      ** Update Retail record for Alternate Accounts
      *
     C                   IF        RIDACP<>*BLANKS
     C                   IF        RIDACP<>BR_DACP or RIDRBR<>BR_DRBR
     C                   CLEAR                   RetKeyDS
     C                   MOVEL     RIDACP        RetKeyDS
     C                   MOVEL     RIDRBR        Branch1                                      208006
      *                                                                                       237346
     C     AccKyk1       IFEQ      *BLANK                                                     237346
     C                   Z-ADD     RetKK1        WKEY             10 0                        237346
      *                                                                                       237346
     C     WKEY          CHAIN     ACNUMA                             80                      237346
     C     *IN80         IFEQ      '0'                                                        237346
     C                   MOVE      AN_CNUM       CustNum1                                     237346
     C                   MOVE      AN_CCY        Currency1                                    237346
     C                   MOVE      AN_ACOD       AccCode1                                     237346
     C                   MOVE      AN_ACSQ       AccSeq1                                      237346
     C                   MOVE      AN_BRCA       Branch1                                      237346
     C                   END                                                                  237346
      *                                                                                       237346
     C                   END                                                                  237346
      *                                                                                       237346
     C     RetKey        CHAIN     REIACDF                            8081

      ** DATABASE ERROR
     C     *IN81         IFEQ      '1'
     C                   MOVEL     RetKeyDS      DBKEY
     C                   MOVEL     'REIACD '     DBFILE                         ************
     C                   MOVEL     '056'         DBASE                          * DBERR 056*
     C                   EXSR      SRERR                                        ************
     C                   END

     C     *IN80         IFEQ      '0'
     C                   ADD       1             RE_NOALT
     C                   UPDATE    REIACDF
      ** Update ALTI on B Record
     C     RE_NOALT      IFEQ      1
     C*****RehisKey      CHAIN     REHISBL                            8081                    237346
     C     RehisAlt      CHAIN     REHISBL                            8081                    237346
      ** DATABASE ERROR
     C     *IN81         IFEQ      '1'
     C                   MOVEL     DBerrKey      DBKEY
     C                   MOVEL     'REHISBL'     DBFILE                         ************
     C                   MOVEL     '057'         DBASE                          * DBERR 057*
     C                   EXSR      SRERR                                        ************
     C                   END
     C     *IN80         IFEQ      '0'
     C                   EVAL      RH_ALTI='Y'
     C                   UPDATE    REHISPPF
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
      *
      **If previous Alternate is a Retail, decrement nuber of alternate
      *
     C                   IF        BR_DACP<>*BLANKS
     C                   IF        RIDACP<>BR_DACP or RIDRBR<>BR_DRBR
     C                   CLEAR                   RetKeyDS
     C                   MOVEL     BR_DACP       RetKeyDS
     C                   MOVEL     BR_DRBR       Branch1                                      208006
      *                                                                                       237346
     C     AccKyk1       IFEQ      *BLANK                                                     237346
     C                   Z-ADD     RetKK1        WKEY             10 0                        237346
      *                                                                                       237346
     C     WKEY          CHAIN     ACNUMA                             80                      237346
     C     *IN80         IFEQ      '0'                                                        237346
     C                   MOVE      AN_CNUM       CustNum1                                     237346
     C                   MOVE      AN_CCY        Currency1                                    237346
     C                   MOVE      AN_ACOD       AccCode1                                     237346
     C                   MOVE      AN_ACSQ       AccSeq1                                      237346
     C                   MOVE      AN_BRCA       Branch1                                      237346
     C                   END                                                                  237346
      *                                                                                       237346
     C                   END                                                                  237346
      *                                                                                       237346
     C     RetKey        CHAIN     REIACDF                            8081

      ** DATABASE ERROR
     C     *IN81         IFEQ      '1'
     C                   MOVEL     RetKeyDS      DBKEY
     C                   MOVEL     'REIACD '     DBFILE                         ************
     C**********         MOVEL     '056'         DBASE                          **DBERR*056* BUG7194
     C                   MOVEL     '076'         DBASE                          * DBERR 076* BUG7194
     C                   EXSR      SRERR                                        ************
     C                   END

     C     *IN80         IFEQ      '0'
     C                   SUB       1             RE_NOALT
     C                   UPDATE    REIACDF
      ** Update ALTI on B Record
     C     RE_NOALT      IFEQ      *ZERO
     C*****RehisKey      CHAIN     REHISBL                            8081                    237346
     C     RehisAlt      CHAIN     REHISBL                            8081                    237346
      ** DATABASE ERROR
     C     *IN81         IFEQ      '1'
     C                   MOVEL     DBerrKey      DBKEY
     C                   MOVEL     'REHISBL'     DBFILE                         ************
     C**********         MOVEL     '057'         DBASE                          **DBERR*057* BUG7194
     C                   MOVEL     '077'         DBASE                          * DBERR 077* BUG7194
     C                   EXSR      SRERR                                        ************
     C                   END
     C     *IN80         IFEQ      '0'
     C                   EVAL      RH_ALTI=*BLANKS
     C                   UPDATE    REHISPPF
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
      *
      **If Alternate is a Retail, increment number of alternate
      *
     C                   IF        RICACP<>*BLANKS
     C                   IF        RICACP<>BR_CACP or RICRBR<>BR_CRBR
     C                   CLEAR                   RetKeyDS
     C                   MOVEL     RICACP        RetKeyDS
     C                   MOVEL     RICRBR        Branch1                                      208006
      *                                                                                       237346
     C     AccKyk1       IFEQ      *BLANK                                                     237346
     C                   Z-ADD     RetKK1        WKEY             10 0                        237346
      *                                                                                       237346
     C     WKEY          CHAIN     ACNUMA                             80                      237346
     C     *IN80         IFEQ      '0'                                                        237346
     C                   MOVE      AN_CNUM       CustNum1                                     237346
     C                   MOVE      AN_CCY        Currency1                                    237346
     C                   MOVE      AN_ACOD       AccCode1                                     237346
     C                   MOVE      AN_ACSQ       AccSeq1                                      237346
     C                   MOVE      AN_BRCA       Branch1                                      237346
     C                   END                                                                  237346
      *                                                                                       237346
     C                   END                                                                  237346
      *                                                                                       237346
     C     RetKey        CHAIN     REIACDF                            8081

      ** DATABASE ERROR
     C     *IN81         IFEQ      '1'
     C                   MOVEL     RetKeyDS      DBKEY
     C                   MOVEL     'REIACD '     DBFILE                         ************
     C                   MOVEL     '058'         DBASE                          * DBERR 058*
     C                   EXSR      SRERR                                        ************
     C                   END

     C     *IN80         IFEQ      '0'
     C                   ADD       1             RE_NOALT
     C                   UPDATE    REIACDF
      ** Update ALTI on B Record
     C     RE_NOALT      IFEQ      1
     C*****RehisKey      CHAIN     REHISBL                            8081                    237346
     C     RehisAlt      CHAIN     REHISBL                            8081                    237346
      ** DATABASE ERROR
     C     *IN81         IFEQ      '1'
     C                   MOVEL     DBerrKey      DBKEY
     C                   MOVEL     'REHISBL'     DBFILE                         ************
     C                   MOVEL     '059'         DBASE                          * DBERR 059*
     C                   EXSR      SRERR                                        ************
     C                   ENDIF
     C     *IN80         IFEQ      '0'
     C                   EVAL      RH_ALTI='Y'
     C                   UPDATE    REHISPPF
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
      *
      **If previous Alternate is a Retail, decrement nuber of alternate
      *
     C                   IF        BR_CACP<>*BLANKS
     C                   IF        RICACP<>BR_CACP or RICRBR<>BR_CRBR
     C                   CLEAR                   RetKeyDS
     C                   MOVEL     BR_CACP       RetKeyDS
     C                   MOVEL     BR_CRBR       Branch1                                      208006
      *                                                                                       237346
     C     AccKyk1       IFEQ      *BLANK                                                     237346
     C                   Z-ADD     RetKK1        WKEY             10 0                        237346
      *                                                                                       237346
     C     WKEY          CHAIN     ACNUMA                             80                      237346
     C     *IN80         IFEQ      '0'                                                        237346
     C                   MOVE      AN_CNUM       CustNum1                                     237346
     C                   MOVE      AN_CCY        Currency1                                    237346
     C                   MOVE      AN_ACOD       AccCode1                                     237346
     C                   MOVE      AN_ACSQ       AccSeq1                                      237346
     C                   MOVE      AN_BRCA       Branch1                                      237346
     C                   END                                                                  237346
      *                                                                                       237346
     C                   END                                                                  237346
      *                                                                                       237346
     C     RetKey        CHAIN     REIACDF                            8081

      ** DATABASE ERROR
     C     *IN81         IFEQ      '1'
     C                   MOVEL     RetKeyDS      DBKEY
     C                   MOVEL     'REIACD '     DBFILE                         ************
     C                   MOVEL     '060'         DBASE                          * DBERR 060*
     C                   EXSR      SRERR                                        ************
     C                   END

     C     *IN80         IFEQ      '0'
     C                   SUB       1             RE_NOALT
     C                   UPDATE    REIACDF
      ** Update ALTI on B Record
     C     RE_NOALT      IFEQ      *ZERO
     C*****RehisKey      CHAIN     REHISBL                            8081                    237346
     C     RehisAlt      CHAIN     REHISBL                            8081                    237346
      ** DATABASE ERROR
     C     *IN81         IFEQ      '1'
     C                   MOVEL     DBerrKey      DBKEY
     C                   MOVEL     'REHISBL'     DBFILE                         ************
     C                   MOVEL     '061'         DBASE                          * DBERR 061*
     C                   EXSR      SRERR                                        ************
     C                   END
     C     *IN80         IFEQ      '0'
     C                   EVAL      RH_ALTI=*BLANKS
     C                   UPDATE    REHISPPF
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
      *
      **If Alternate is a Retail, increment number of alternate
      *
     C                   IF        RICHAC<>*BLANKS
     C                   IF        RICHAC<>BR_CHAC or RICHBR<>BR_CHBR
     C                   CLEAR                   RetKeyDS
     C                   MOVEL     RICHAC        RetKeyDS
     C                   MOVEL     RICHBR        Branch1                                      208006
      *                                                                                       237346
     C     AccKyk1       IFEQ      *BLANK                                                     237346
     C                   Z-ADD     RetKK1        WKEY             10 0                        237346
      *                                                                                       237346
     C     WKEY          CHAIN     ACNUMA                             80                      237346
     C     *IN80         IFEQ      '0'                                                        237346
     C                   MOVE      AN_CNUM       CustNum1                                     237346
     C                   MOVE      AN_CCY        Currency1                                    237346
     C                   MOVE      AN_ACOD       AccCode1                                     237346
     C                   MOVE      AN_ACSQ       AccSeq1                                      237346
     C                   MOVE      AN_BRCA       Branch1                                      237346
     C                   END                                                                  237346
      *                                                                                       237346
     C                   END                                                                  237346
      *                                                                                       237346
     C     RetKey        CHAIN     REIACDF                            8081

      ** DATABASE ERROR
     C     *IN81         IFEQ      '1'
     C                   MOVEL     RetKeyDS      DBKEY
     C                   MOVEL     'REIACD '     DBFILE                         ************
     C                   MOVEL     '062'         DBASE                          * DBERR 062*
     C                   EXSR      SRERR                                        ************
     C                   END

     C     *IN80         IFEQ      '0'
     C                   ADD       1             RE_NOALT
     C                   UPDATE    REIACDF
      ** Update ALTI on B Record
     C     RE_NOALT      IFEQ      1
     C*****RehisKey      CHAIN     REHISBL                            8081                    237346
     C     RehisAlt      CHAIN     REHISBL                            8081                    237346
      ** DATABASE ERROR
     C     *IN81         IFEQ      '1'
     C                   MOVEL     DBerrKey      DBKEY
     C                   MOVEL     'REHISBL'     DBFILE                         ************
     C                   MOVEL     '063'         DBASE                          * DBERR 063*
     C                   EXSR      SRERR                                        ************
     C                   ENDIF
     C     *IN80         IFEQ      '0'
     C                   EVAL      RH_ALTI='Y'
     C                   UPDATE    REHISPPF
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
      *
      **If previous Alternate is a Retail,decrement number of alternate
      *
     C                   IF        BR_CHAC<>*BLANKS
     C                   IF        RICHAC<>BR_CHAC or RICHBR<>BR_CHBR
     C                   CLEAR                   RetKeyDS
     C                   MOVEL     BR_CHAC       RetKeyDS
     C                   MOVEL     BR_CHBR       Branch1                                      208006
      *                                                                                       237346
     C     AccKyk1       IFEQ      *BLANK                                                     237346
     C                   Z-ADD     RetKK1        WKEY             10 0                        237346
      *                                                                                       237346
     C     WKEY          CHAIN     ACNUMA                             80                      237346
     C     *IN80         IFEQ      '0'                                                        237346
     C                   MOVE      AN_CNUM       CustNum1                                     237346
     C                   MOVE      AN_CCY        Currency1                                    237346
     C                   MOVE      AN_ACOD       AccCode1                                     237346
     C                   MOVE      AN_ACSQ       AccSeq1                                      237346
     C                   MOVE      AN_BRCA       Branch1                                      237346
     C                   END                                                                  237346
      *                                                                                       237346
     C                   END                                                                  237346
      *                                                                                       237346
     C     RetKey        CHAIN     REIACDF                            8081

      ** DATABASE ERROR
     C     *IN81         IFEQ      '1'
     C                   MOVEL     RetKeyDS      DBKEY
     C                   MOVEL     'REIACD '     DBFILE                         ************
     C                   MOVEL     '064'         DBASE                          * DBERR 064*
     C                   EXSR      SRERR                                        ************
     C                   END

     C     *IN80         IFEQ      '0'
     C                   SUB       1             RE_NOALT
     C                   UPDATE    REIACDF
      ** Update ALTI on B Record
     C     RE_NOALT      IFEQ      *ZERO
     C*****RehisKey      CHAIN     REHISBL                            8081                    237346
     C     RehisAlt      CHAIN     REHISBL                            8081                    237346
      ** DATABASE ERROR
     C     *IN81         IFEQ      '1'
     C                   MOVEL     DBerrKey      DBKEY
     C                   MOVEL     'REHISBL'     DBFILE                         ************
     C                   MOVEL     '065'         DBASE                          * DBERR 065*
     C                   EXSR      SRERR                                        ************
     C                   END
     C     *IN80         IFEQ      '0'
     C                   EVAL      RH_ALTI=*BLANKS
     C                   UPDATE    REHISPPF
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
      *
      ** Update Retail Commissions file
     C     CommDisp      IFEQ      'Y'                                          201704
      *
     C     RehisKey      CHAIN     RECOM                              8081
      ** DATABASE ERROR
     C     *IN81         IFEQ      '1'
     C                   MOVEL     DBerrKey      DBKEY
     C                   MOVEL     'RECOMD '     DBFILE                         ************
     C                   MOVEL     '066'         DBASE                          * DBERR 066*
     C                   EXSR      SRERR                                        ************
     C                   ENDIF
     C                   IF        COCEXA='E'
     C                   EVAL      RC_CHDBE=*ZEROS
     C                   EVAL      RC_CHDBC=*ZEROS
     C                   EVAL      RC_HDRB=*ZEROS
     C                   EVAL      RC_CHDBR=*ZEROS
     C                   EVAL      RC_CCHDBC=*ZEROS
     C                   ENDIF
     C                   IF        COCEXB='E'
     C                   EVAL      RC_ACCEA=*ZEROS
     C                   EVAL      RC_ACCC=*ZEROS
     C                   EVAL      RC_GVDPE=*ZEROS
     C                   EVAL      RC_GVDPC=*ZEROS
     C                   EVAL      RC_ACCRA=*ZEROS
     C                   EVAL      RC_CACCC=*ZEROS
     C                   ENDIF
     C                   IF        COCEXC='E'
     C                   EVAL      RC_CDIE=*ZEROS
     C                   EVAL      RC_CDICA=*ZEROS
     C                   EVAL      RC_CDRR=*ZEROS
     C                   EVAL      RC_CCDIC=*ZEROS
     C                   ENDIF
     C                   IF        COCEXD='E'
     C                   EVAL      RC_IACE=*ZEROS
     C                   EVAL      RC_IACCC=*ZEROS
     C                   EVAL      RC_CIACC=*ZEROS
     C                   ENDIF
     C                   IF        COCEXE='E'
     C                   EVAL      RC_CMBE=*ZEROS
     C                   EVAL      RC_CMBC=*ZEROS
     C                   EVAL      RC_ACCB=*ZEROS
     C                   EVAL      RC_CCMBC=*ZEROS
     C                   ENDIF
     C                   IF        COCEXF='E'
     C                   EVAL      RC_CCINST=*ZEROS
     C                   EVAL      RC_NOIS=*ZEROS
     C                   EVAL      RC_NOCC=*ZEROS
     C                   EVAL      RC_PESP=*ZEROS
     C                   ENDIF
     C                   IF        COCEXG='E'
     C                   EVAL      RC_FXDC=*ZEROS
     C                   ENDIF
     C                   EVAL      RC_CEXA=COCEXA
     C                   EVAL      RC_CEXB=COCEXB
     C                   EVAL      RC_CEXC=COCEXC
     C                   EVAL      RC_CEXD=COCEXD
     C                   EVAL      RC_CEXE=COCEXE
     C                   EVAL      RC_CEXF=COCEXF
     C                   EVAL      RC_CEXG=COCEXG
     C                   Z-ADD     CONOCC        RC_NOCC
     C**********         Z-ADD     COCNUM        RC_CNUM                                      CSD027
     C                   EVAL      RC_CNUM = COCNUM                                           CSD027
     C                   MOVEL(P)  COCCY         RC_CCY
     C                   Z-ADD     COACOD        RC_ACOD
     C                   Z-ADD     COACSQ        RC_ACSQ
     C                   MOVEL(P)  COBRCA        RC_BRCA
     C                   UPDATE    RECOMDF
     C                   ENDIF                                                  201704
     C                   ENDIF
     C                   ENDIF
      *
      ** Update Account trailer record
      *
     C*****1****         SETLL     ACCNTAC                                                    260323
     C**********         READ      ACCNTAC                                80                  260323
     C     1             CHAIN     ACCNTAC                            80                      260323

      ** DATABASE ERROR

     C     *IN80         IFEQ      '1'
     C                   EVAL      DBKEY='1'
     C                   MOVEL     'ACCNTAC'     DBFILE                         ************
     C                   MOVEL     '067'         DBASE                          * DBERR 067*
     C                   EXSR      SRERR                                        ************
     C                   END
      ** Increment Counter only if first amend not insert today
     C                   IF        AMLCD<>BJRDNB
     C                   ADD       1             C_NOAM
     C                   ENDIF
     C                   EVAL      C_LCD=BJRDNB
      ** Obtain the next available transaction number
     C                   Z-ADD     *ZERO         NATN
     C                   CALLB     'ZTNLU1'
     C                   PARM      *BLANK        Retrn
     C                   PARM                    NATN
      ** Database Error if ReturnCode not blank
     C     Retrn         IFNE      *BLANK
     C                   MOVEL     NATN          DBKEY
     C                   MOVEL     'MNATN  '     DBFILE                         ************
     C                   MOVEL     '068'         DBASE                          * DBERR 068*
     C                   EXSR      SRERR                                        ************
     C                   END
     C                   EVAL      C_TNLU=NATN
     C                   UPDATE    ACCNTCXF
      *
      ***WRITE*STRAN*with*Rate*Change**********************************                       CRE005
      ** WRITE STRAN or RERCH... files with Rate Change                                       CRE005
      *
     C**********         IF        AC_ACNO<>*ZERO                                             203282
     C                   IF        AC_ATYP = 'R'                                              203282
      *                                                                                       CRE005
      *                                                                                       CRE005
     C     CRE005        IFEQ      'Y'                                                        CRE005
     C                   EXSR      UpdRERCH                                                   CRE005
     C                   ELSE                                                                 CRE005
     C                   EXSR      UpdSTRAN
      *                                                                                       CRE005
     C                   ENDIF                                                                CRE005
     C                   ENDIF
      *
     C
      ** If CRT101 (Password on Retail Accounts) is installed and
      ** CRT001 (Retail Teller System) is on
      *
     C                   IF        CRT101='Y' and CRT001='Y' and
     C                             AMATYP='R' and AMSTYP='S'
      *
      ***Write*Password*to*file*REAPWDPD*******************************                       CSD101
      *
     C*****AccntKey      CHAIN     REAPWDL0                           8081                    CSD101
      ** DATABASE ERROR
     C******IN80         IFEQ      '1'                                                      MD042832
     C******IN81         IFEQ      '1'                                               MD042832 CSD101
     C**********         MOVEL     DBerrKey      DBKEY                                        CSD101
     C**********         MOVEL     'REAPWDPD'    DBFILE                         ************  CSD101
     C**********         MOVEL     '069'         DBASE                          * DBERR 069*  CSD101
     C**********         EXSR      SRERR                                        ************  CSD101
     C**********         ENDIF                                                                CSD101
     C******IN81         IFEQ      '0'                                                      MD042832
     C******IN80         IFEQ      '0'                                               MD042832 CSD101
     C**********         EVAL      RW_PSWD=PWPSWD                                             CSD101
     C**********         UPDATE    REAPWDD0                                                   CSD101
     C**********         ENDIF                                                                CSD101
     C                   IF        PWPSWD <> *BLANKS                                          CSD101
     C                   EVAL      KCNUM2 = AMCNUM                                            CSD101
     C                   EVAL      KCCY2  = AMCCY                                             CSD101
     C                   MOVE      AMACOD        KACOD2                                       CSD101
     C                   MOVE      AMACSQ        KACSQ2                                       CSD101
     C                   EVAL      KBRCA2 = AMBRCA                                            CSD101
     C                   EVAL      PLibrary = LIBR + 'DMLIB'                                  CSD101
     C                   EVAL      PIDName = 'ACCOUNTPASSWORD_'   + CHKACC2                   CSD101
                                                                                              CSD101
     C                   CALL      'SD000404'                                                 CSD101
     C                   PARM      *Blanks       PReturnCode                                  CSD101
     C                   PARM      'F'           PAction                                      CSD101
     C                   PARM                    PValidList                                   CSD101
     C                   PARM                    PLibrary                                     CSD101
     C                   PARM                    PIDName                                      CSD101
     C                   PARM      *Blanks       PPass1                                       CSD101
     C                   PARM      *Blanks       PDescr                                       CSD101
                                                                                              CSD101
     C                   IF        PReturnCode = *BLANKS                                      CSD101
     C                   EVAL      PPass1 = PWPSWD                                            CSD101
     C                   EVAL      PDescr = *BLANKS                                           CSD101
     C                   CALL      'SD000404'                                                 CSD101
     C                   PARM      *Blanks       PReturnCode                                  CSD101
     C                   PARM      'M'           PAction                                      CSD101
     C                   PARM                    PValidList                                   CSD101
     C                   PARM                    PLibrary                                     CSD101
     C                   PARM                    PIDName                                      CSD101
     C                   PARM                    PPass1                                       CSD101
     C                   PARM                    PDescr                                       CSD101
     C                   ELSE                                                                 CSD101
     C                   EVAL      PPass1 = PWPSWD                                            CSD101
     C                   EVAL      PDescr = *BLANKS                                           CSD101
     C                   CALL      'SD000404'                                                 CSD101
     C                   PARM      *Blanks       PReturnCode                                  CSD101
     C                   PARM      'A'           PAction                                      CSD101
     C                   PARM                    PValidList                                   CSD101
     C                   PARM                    PLibrary                                     CSD101
     C                   PARM                    PIDName                                      CSD101
     C                   PARM                    PPass1                                       CSD101
     C                   PARM                    PDescr                                       CSD101
     C                   ENDIF                                                                CSD101
     C                   ENDIF                                                                CSD101
      * If Entered password is blank and a record is in Validation List, delete the           CSD101
      * record                                                                                CSD101
     C                   IF        PWPSWD  = *BLANKS                                          CSD101
     C                   EVAL      KCNUM2 = AMCNUM                                            CSD101
     C                   EVAL      KCCY2  = AMCCY                                             CSD101
     C                   MOVE      AMACOD        KACOD2                                       CSD101
     C                   MOVE      AMACSQ        KACSQ2                                       CSD101
     C                   EVAL      KBRCA2 = AMBRCA                                            CSD101
     C                   EVAL      PLibrary = LIBR + 'DMLIB'                                  CSD101
     C                   EVAL      PIDName = 'ACCOUNTPASSWORD_'   + CHKACC2                   CSD101
                                                                                              CSD101
     C                   CALL      'SD000404'                                                 CSD101
     C                   PARM      *Blanks       PReturnCode                                  CSD101
     C                   PARM      'F'           PAction                                      CSD101
     C                   PARM                    PValidList                                   CSD101
     C                   PARM                    PLibrary                                     CSD101
     C                   PARM                    PIDName                                      CSD101
     C                   PARM      *Blanks       PPass1                                       CSD101
     C                   PARM      *Blanks       PDescr                                       CSD101
     C                   IF        PReturnCode = *BLANKS                                      CSD101
     C                   CALL      'SD000404'                                                 CSD101
     C                   PARM      *Blanks       PReturnCode                                  CSD101
     C                   PARM      'D'           PAction                                      CSD101
     C                   PARM                    PValidList                                   CSD101
     C                   PARM                    PLibrary                                     CSD101
     C                   PARM                    PIDName                                      CSD101
     C                   PARM                    PPass1                                       CSD101
     C                   PARM                    PDescr                                       CSD101
     C                   ENDIF                                                                CSD101
     C                   ENDIF                                                                CSD101
                                                                                              CSD101
     C                   ENDIF
      *                                                                                       CTI005
     C     Rehiskey      CHAIN     GLACSHL0                           90                      CTI005
      *                                                                                       CTI005
     C     *IN90         IFEQ      '0'                                                        CTI005
     C     TAC_NACSG     IFEQ      'T'                                                        CTI005
     C     TAC_LCD       ANDNE     BJRDNB                                                     CTI005
     C                   EVAL      TAC_NACSG = ' '                                            CTI005
     C                   ENDIF                                                                CTI005
      *                                                                                       CTI005
     C                   Z-ADD     TAC_LCD       WWLCD                                        CTI005
     C                   Z-ADD     BJRDNB        TAC_LCD                                      CTI005
      *                                                                                       CTI005
      ** If Amend over Insert the same day then keep as Insert today                          CTI005
      *                                                                                       CTI005
     C                   IF        WWLCD=BJRDNB and TAC_CHTP='I'                              CTI005
     C                             and AMCHTP='A'                                             CTI005
     C                   EVAL      TAC_CHTP='I'                                               CTI005
     C                   ELSE                                                                 CTI005
     C                   EVAL      TAC_CHTP='A'                                               CTI005
     C                   ENDIF                                                                CTI005
      *                                                                                       CTI005
     C                   UPDATE    GLACSHD0                                                   CTI005
     C                   ENDIF                                                                CTI005
      *                                                                                       CTI005
     C                   IF        CRE015 = 'Y'                                               CRE015
     C                             AND A5ATTY = 'P'                                           CRE015
                                                                                              CRE015
      ** Delete existing records and rebuild from the valid input                             CRE015
                                                                                              CRE015
     C     RehisKey      SETLL     REPRPNL4                                                   CRE015
     C     RehisKey      READE     REPRPNL4                                                   CRE015
     C                   DOW       NOT %EOF(REPRPNL4)                                         CRE015
     C                   DELETE    REPRPND0                                                   CRE015
     C     RehisKey      READE     REPRPNL4                                                   CRE015
     C                   ENDDO                                                                CRE015
                                                                                              CRE015
      ** Write details from input and resequence events                                       CRE015
                                                                                              CRE015
     C                   MOVEA     GLVAMPP       ArrFilBuf                                    CRE015
     C                   DO        26            X                                            CRE015
     C                   EVAL      REPRPN = ArrFilBuf(X)                                      CRE015
                                                                                              CRE015
      ** Write a record if not blanks                                                         CRE015
                                                                                              CRE015
     C                   IF        E2BRCA <> *BLANKS                                          CRE015
                                                                                              CRE015
      ** Resequence events except event Z                                                     CRE015
                                                                                              CRE015
     C                   IF        E2EVNT <> 'Z'                                              CRE015
     C                   EVAL      E2EVNT = ArrEvnt(X)                                        CRE015
     C                   ENDIF                                                                CRE015
                                                                                              CRE015
      ** Do interest notification                                                             CRE015
                                                                                              CRE015
     C                   IF        E2EVNT = 'Z'                                               CRE015
     C                   EXSR      SRNotify                                                   CRE015
     C                   ENDIF                                                                CRE015
                                                                                              CRE015
     C                   WRITE     REPRPND0                                                   CRE015
     C                   ENDIF                                                                CRE015
                                                                                              CRE015
     C                   ENDDO                                                                CRE015
     C                   ENDIF                                                                CRE015
                                                                                              CRE015
     C/COPY OFCPYSRCZ,CRE101_031                                                              CRE101
     C                   ENDSR
      *****************************************************************                       CRE015
      /EJECT                                                                                  CRE015
      *****************************************************************                       CRE015
      *                                                               *                       CRE015
      *  SRNotify - Termination and Interest Notification             *                       CRE015
      *                                                               *                       CRE015
      *****************************************************************                       CRE015
     C     SRNotify      BEGSR                                                                CRE015
                                                                                              CRE015
      ** A change in termination period start date or interest notification                   CRE015
      ** type requires a change in period and penalty notifications                           CRE015
                                                                                              CRE015
      ** Update termination notification                                                      CRE015
                                                                                              CRE015
     C                   CALL      'RE4012'                                                   CRE015
     C                   PARM      '*TERMIN'     PWMODE            7                          CRE015
     C                   PARM      E2KEY1        PKEY1            24                          CRE015
     C                   PARM      *BLANKS       PTRR1             8                          CRE015
     C                   PARM      -1            PREAM            15 0                        CRE015
     C                   PARM      *BLANKS       PDC01             1                          CRE015
     C                   PARM      -1            PCAVL            15 0                        CRE015
     C                   PARM      *BLANKS       PDC02             1                          CRE015
     C                   PARM      E2VDAT        PDEFF             5 0                        CRE015
     C                   PARM      BJRDNB        PRECD             5 0                        CRE015
     C                   PARM      -1            PHISB            15 0                        CRE015
     C                   PARM      *BLANKS       PDC03             1                          CRE015
     C                   PARM      -2            PRTDE             2 0                        CRE015
                                                                                              CRE015
      ** Update interest notification                                                         CRE015
                                                                                              CRE015
     C                   IF        E2IRLI = 'F'                                               CRE015
     C                   CALL      'RE4012'                                                   CRE015
     C                   PARM      '*RMVINT'     PWMODE                                       CRE015
     C                   PARM      E2KEY1        PKEY1                                        CRE015
     C                   PARM      *BLANKS       PTRR1                                        CRE015
     C                   PARM      -1            PREAM                                        CRE015
     C                   PARM      *BLANKS       PDC01                                        CRE015
     C                   PARM      -1            PCAVL                                        CRE015
     C                   PARM      *BLANKS       PDC02                                        CRE015
     C                   PARM      0             PDEFF                                        CRE015
     C                   PARM      0             PRECD                                        CRE015
     C                   PARM      -1            PHISB                                        CRE015
     C                   PARM      *BLANKS       PDC03                                        CRE015
     C                   PARM      -2            PRTDE                                        CRE015
     C                   END                                                                  CRE015
                                                                                              CRE015
     C                   IF        E2IRLI = 'P'                                               CRE015
     C                   CALL      'RE4012'                                                   CRE015
     C                   PARM      '*ADDINT'     PWMODE                                       CRE015
     C                   PARM      E2KEY1        PKEY1                                        CRE015
     C                   PARM      *BLANKS       PTRR1                                        CRE015
     C                   PARM      0             PREAM                                        CRE015
     C                   PARM      'D'           PDC01                                        CRE015
     C                   PARM      0             PCAVL                                        CRE015
     C                   PARM      'D'           PDC02                                        CRE015
     C                   PARM      0             PDEFF                                        CRE015
     C                   PARM      0             PRECD                                        CRE015
     C                   PARM      0             PHISB                                        CRE015
     C                   PARM      'D'           PDC03                                        CRE015
     C                   PARM      -2            PRTDE                                        CRE015
     C                   END                                                                  CRE015
                                                                                              CRE015
     C                   ENDSR                                                                CRE015
     C****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * *INZSR - Program Initialisation routine                       *
      *                                                               *
      * Called by: Start processing                                   *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
     C     *INZSR        BEGSR
      *                                                                                       CSD012
      * Override GLACSHL0                                                                     CSD012
     C                   Z-ADD     50            CMDLEN           15 5                        CSD012
     C                   CALL      'QCMDEXC'                                                  CSD012
     C                   PARM                    CMD1                                         CSD012
     C                   PARM                    CMDLEN                                       CSD012
      * Override GLBXSHL0                                                                     CSD012
     C                   CALL      'QCMDEXC'                                                  CSD012
     C                   PARM                    CMD2                                         CSD012
     C                   PARM                    CMDLEN                                       CSD012
      * Override REIASHL0                                                                     CSD012
     C                   CALL      'QCMDEXC'                                                  CSD012
     C                   PARM                    CMD3                                         CSD012
     C                   PARM                    CMDLEN                                       CSD012
      * Override RECMSHL0                                                                     CSD012
     C                   CALL      'QCMDEXC'                                                  CSD012
     C                   PARM                    CMD4                                         CSD012
     C                   PARM                    CMDLEN                                       CSD012
      * Override REPWSHL0                                                                     CSD012
     C**********         CALL      'QCMDEXC'                                           CSD012 CSD101
     C**********         PARM                    CMD5                                  CSD012 CSD101
     C**********         PARM                    CMDLEN                                CSD012 CSD101
      *
      **  PROGRAM PARAMETERS
      *
     C     *ENTRY        PLIST
     C                   PARM                    @@RTCD            7
     C                   PARM                    RespMode          1
     C                   PARM                    GLVAMAD
     C                   PARM                    GLVAMBX
     C                   PARM                    GLVAMRI
     C                   PARM                    GLVAMCO
     C                   PARM                    GLVAMPW
     C                   PARM                    GLVAMPP                                      CRE015
     C/COPY OFCPYSRCZ,CRE101_021                                                              CRE101
     C                   PARM                    CEU013            1
     C                   PARM                    CRT001            1
     C                   PARM                    CRT002            1
     C                   PARM                    CRE001            1
     C                   PARM                    CRT101            1
     C                   PARM                    CFT004            1            CFT004
     C                   PARM                    CDE002            1            CDE002
     C/COPY OFCPYSRCZ,CRE101_008                                                              CRE101
     C                   PARM                    FACH              1
     C                   PARM                    TSTMC             1
      * Base Rate Auth req                                                                    CSD012
     C                   PARM                    AUTHRQ            1                          CSD012
      * Authorisation Mode                                                                    CSD012
     C                   PARM                    AUTHMD            1                          CSD012
      *
      ** ACCESS BANK DETAILS
      *
     C                   CALLB     'AOBANKR0'
     C                   PARM      '*MSG    '    @RTCD             7
     C                   PARM      '*FIRST  '    @OPTN             7
     C     SDBANK        PARM      SDBANK        DSFDY
      *
      * DATABASE ERROR
      *
     C     @RTCD         IFNE      *BLANK
     C                   MOVEL     @OPTN         DBKEY
     C                   MOVEL     'SDBANKPD'    DBFILE                         *************
     C                   MOVEL     '900'         DBASE                          * DBERR 900 *
     C                   EXSR      SRERR                                        *************
     C                   END
      *
      ** ACCESS GENERAL LEDGER DETAILS
      *
     C**********         CALLB     'AOGELRR0'                                                 CGL029
     C                   CALLB     'AOGELRR1'                                                 CGL029
     C                   PARM      '*MSG    '    @RTCD
     C                   PARM      '*FIRST  '    @OPTN
     C*****SDGELR        PARM      SDGELR        DSFDY                                        CGL029
     C     SDGELR        PARM      SDGELR        DSSDY                                        CGL029
      *
      * DATABASE ERROR
      *
     C     @RTCD         IFNE      *BLANK
     C                   MOVEL     @OPTN         DBKEY
     C                   MOVEL     'SDGELRPD'    DBFILE                         *************
     C                   MOVEL     '901'         DBASE                          * DBERR 901 *
     C                   EXSR      SRERR                                        *************
     C                   END
      *
      ** ACCESS MIDAS MODULE DETAILS
      *
     C                   CALLB     'AOMMODR0'
     C                   PARM      '*MSG    '    @RTCD
     C                   PARM      '*FIRST  '    @OPTN
     C     SDMMOD        PARM      SDMMOD        DSSDY
      *
      * DATABASE ERROR
      *
     C     @RTCD         IFNE      *BLANK
     C                   MOVEL     @OPTN         DBKEY
     C                   MOVEL     'SDMMODPD'    DBFILE                         *************
     C                   MOVEL     '902'         DBASE                          * DBERR 902 *
     C                   EXSR      SRERR                                        *************
     C                   END
      *
      ** ACCESS MIDAS RETAIL
      *
     C     BGRTBN        IFEQ      'Y'                                                        208921
     C                   CALLB     'AORETLR0'
     C                   PARM      '*MSG    '    @RTCD
     C                   PARM      '*FIRST  '    @OPTN
     C     SDRETL        PARM      SDRETL        DSFDY
      *
      * DATABASE ERROR
      *
     C     @RTCD         IFNE      *BLANK
     C                   MOVEL     @OPTN         DBKEY
     C                   MOVEL     'SDRETLPD'    DBFILE                         *************
     C                   MOVEL     '905'         DBASE                          * DBERR 905 *
     C                   EXSR      SRERR                                        *************
     C                   END
      *
      ** Access Retail III Table file
     C     BGNXST        IFEQ      'Y'
     C     BGNYST        OREQ      'Y'

      ** Reset the file cursor before reading, as the file is also read
      ** in higher modules
     C     1             setll     TABTBRE
     C                   READ      TABTBRE                                80
     C     *IN80         IfEq      '1'
     C     R_RECI        OrNE      'D'
     C     *LOCK         IN        LDA
     C                   MOVEL     'TABTBRE '    DBFILE
     C                   MOVEL     '906'         DBASE
     C                   MOVEL     *Blanks       DBKEY
     C                   OUT       LDA
     C                   SETON                                        U7U8LR
     C                   EXSR      SRERR
     C                   ENDIF
     C                   ENDIF
      *
      ** Check commissions if present.
     C     R_CDTO        IFEQ      'Y'
     C     R_CHOV        OREQ      'Y'
     C     R_FXAC        OREQ      'Y'
     C     R_CNDS        OREQ      'Y'
     C     R_CDRI        OREQ      'Y'
     C     R_CMBL        OREQ      'Y'
     C     R_CINA        OREQ      'Y'
     C                   MOVE      'Y'           CommDisp          1
     C                   ELSE
     C                   MOVE      'N'           CommDisp
     C                   ENDIF
     C                   ENDIF                                                                208921
      *                                                                         CDE001
      ** Determine if Data Export for CCRM Limits is active                     CDE001
     C                   CALL      'AOSARDR0'                                   CDE001
     C                   PARM      *BLANKS       @RTCD                          CDE001
     C                   PARM      '*VERIFY'     @OPTN                          CDE001
     C                   PARM      'CDE001'      @SARD             6            CDE001
      *                                                                         CDE001
     C     @RTCD         IFEQ      *BLANK                                       CDE001
     C                   MOVEL     'Y'           CDE001            1            CDE001
     C                   ENDIF                                                  CDE001
      *
      ** Check if CSC011 is installed                                                         CSC011
                                                                                              CSC011
      ** CSC011 is a redundant feature. No need to check                                    MD024398
                                                                                            MD024398
     C**********         CALLB     'AOSARDR0'                                        CSC011 MD024398
     C**********         PARM      *BLANKS       PRtCd                               CSC011 MD024398
     C**********         PARM      '*VERIFY'     POptn                               CSC011 MD024398
     C**********         PARM      'CSC011'      PSard                               CSC011 MD024398
     C*****SCSARD        PARM      SCSARD        DSFDY                               CSC011 MD024398
      **********                                                                     CSC011 MD024398
     C**********         IF        PRtCd = *Blanks                                   CSC011 MD024398
     C**********         EVAL      CSC011 = 'Y'                                      CSC011 MD024398
     C**********         IN        SC24X7                                            CSC011 MD024398
     C**********         IN        SDSTAT                                              CSC011 CSD015
     C**********         ELSE                                                        CSC011 MD024398
     C                   EVAL      CSC011 = 'N'                                               CSC011
      **********                                                                     CSC011 MD024398
     C**********         IF        PRtCd <> '*NRF'                                   CSC011 MD024398
     C******LOCK         IN        LDA                                             MD024398 MD029681
     C**********         EVAL      DBKEY = 'CSC011'                                  CSC011 MD024398
     C**********         EVAL      DBFILE = 'SCSARDPD'                               CSC011 MD024398
     C**********         EVAL      DBASE = 907                                       CSC011 MD024398
     C**********         OUT       LDA                                               CSC011 MD024398
     C**********         EXSR      SRERR                                             CSC011 MD024398
     C**********         ENDIF                                                       CSC011 MD024398
      **********                                                                     CSC011 MD024398
     C**********         ENDIF                                                       CSC011 MD024398
                                                                                              CSD015
     C                   IN        SDSTAT                                                     CSD015
                                                                                              CSD015
      ** Check if CSD015 is installed                                                         CSD015
                                                                                              CSD015
     C                   CALLB     'AOSARDR0'                                                 CSD015
     C                   PARM      *BLANKS       PRtCd                                        CSD015
     C                   PARM      '*VERIFY'     POptn                                        CSD015
     C                   PARM      'CSD015'      PSard                                        CSD015
     C     SCSARD        PARM      SCSARD        DSFDY                                        CSD015
                                                                                              CSD015
      ** Database error                                                                       CSD015
                                                                                              CSD015
     C                   IF        (PRtCd <> *BLANKS) and                                     CSD015
     C                             (PRtCd <> '*NRF   ')                                       CSD015
     C                   EVAL      DBKEY = 'CSD015'                                           CSD015
     C                   EVAL      DBFILE = 'SCSARDPD'                                        CSD015
     C                   EVAL      DBASE = 74                                                 CSD015
     C                   EXSR      SRERR                                                      CSD015
     C                   ENDIF                                                                CSD015
                                                                                              CSD015
      ** If Enhancement CSD015 is installed, access SDWLCCPD to                               CSD015
      ** see if 'GLAMAD' fucntion code is available.                                          CSD015
                                                                                              CSD015
     C                   IF        PRtCd = *BLANKS                                            CSD015
     C                   EVAL      CSD015 = 'Y'                                               CSD015
     C                   ELSE                                                                 CSD015
     C                   EVAL      CSD015 = 'N'                                               CSD015
     C                   ENDIF                                                                CSD015
                                                                                              CSD015
     C                   IF        CSD015 = 'Y'                                               CSD015
     C                                                                                        CSD015
     C                   CALLB     'AOWLCCR0'                                                 CSD015
     C                   PARM      *BLANKS       PRtCd                                        CSD015
     C                   PARM      '*KEY   '     POptn                                        CSD015
     C                   PARM      'GLAMAD'      PFncCd                                       CSD015
     C     SDWLCC        PARM      SDWLCC        DSFDY                                        CSD015
                                                                                              CSD015
      ** Database error                                                                       CSD015
                                                                                              CSD015
     C                   IF        (PRtCd <> *BLANKS)                                         CSD015
     C                             AND (PRtCd <> '*NRF')                                      CSD015
     C                   EVAL      DBKEY = 'GLAMAD'                                           CSD015
     C                   EVAL      DBFILE = 'SDWLCCPD'                                        CSD015
     C                   EVAL      DBASE = 75                                                 CSD015
     C                   EXSR      SRERR                                                      CSD015
     C                   ENDIF                                                                CSD015
                                                                                              CSD015
      ** Access SDCWCDPD to get the 5 Private Customer Industry Code                          CSD015
                                                                                              CSD015
     C                   CALLB     'AOCWCDR0'                                                 CSD015
     C                   PARM      *BLANKS       PRTCD                                        CSD015
     C                   PARM      '*FIRST '     POPTN                                        CSD015
     C     SDCWCD        PARM      SDCWCD        DSSDY                                        CSD015
                                                                                              CSD015
      ** Database error                                                                       CSD015
                                                                                              CSD015
     C                   IF        (PRtCd <> *BLANKS)                                         CSD015
     C                   EVAL      DBKEY = POPTN                                              CSD015
     C                   EVAL      DBFILE = 'SDCWCDPD'                                        CSD015
     C                   EVAL      DBASE = 76                                                 CSD015
     C                   EXSR      SRERR                                                      CSD015
     C                   ENDIF                                                                CSD015
                                                                                              CSD015
     C                   ENDIF                                                                CSD015
                                                                                              CSD015
      ** Check if CCF001 is installed                                                         CSD015
                                                                                              CSD015
     C                   EVAL      CCF001 = 'N'                                               CSD015
     C                   CALLB     'AOSARDR0'                                                 CSD015
     C                   PARM      *BLANKS       PRtCd                                        CSD015
     C                   PARM      '*VERIFY'     POptn                                        CSD015
     C                   PARM      'CCF001'      PSard                                        CSD015
     C     SCSARD        PARM      SCSARD        DSFDY                                        CSD015
                                                                                              CSD015
      ** Database error                                                                       CSD015
                                                                                              CSD015
     C                   IF        (PRtCd <> *BLANKS) and                                     CSD015
     C                             (PRtCd <> '*NRF   ')                                       CSD015
     C                   EVAL      DBKEY = 'CCF001'                                           CSD015
     C                   EVAL      DBFILE = 'SCSARDPD'                                        CSD015
     C                   EVAL      DBASE = 77                                                 CSD015
     C                   EXSR      SRERR                                                      CSD015
     C                   ENDIF                                                                CSD015
                                                                                              CSD015
     C                   IF        PRtCd = *BLANKS                                            CSD015
     C                   EVAL      CCF001 = 'Y'                                               CSD015
     C                   ENDIF                                                                CSD015
      ***Check*whether*user*is*a*web*browser*user,*if*so*overwrite*****              BUG2807 BUG6389
     C**********         CALL      'SFC000026'                                       BUG2807 BUG6389
     C**********         PARM      *BLANKS       USER             10                 BUG2807 BUG6389
      *                                                                                      BUG2807
     C**********         IF        USER <> *BLANKS                                   BUG2807 BUG6389
     C**********         MOVEL     USER          PSUSER                              BUG2807 BUG6389
     C**********         ENDIF                                                       BUG2807 BUG6389
      *                                                                                      BUG2807
                                                                                              CLE025
      ** Check if enhancement CLE025 (Multi-Option Facilities) is on                          CLE025
                                                                                              CLE025
     C                   CALLB     'AOSARDR0'                                                 CLE025
     C                   PARM      *BLANKS       PRTCD                                        CLE025
     C                   PARM      '*VERIFY'     POPTN                                        CLE025
     C                   PARM      'CLE025'      PSARD                                        CLE025
     C     SCSARD        PARM      SCSARD        DSFDY                                        CLE025
                                                                                              CLE025
     C                   IF        PRTCD <> *BLANKS  AND  PRTCD <> '*NRF   '                  CLE025
     C                   EVAL      DBFILE = 'SCSARDPD'                                        CLE025
     C                   EVAL      DBKEY = 'CLE025'                                           CLE025
     C                   EVAL      DBASE = 908                                                CLE025
     C                   EXSR      *PSSR                                                      CLE025
     C                   ENDIF                                                                CLE025
                                                                                              CLE025
     C                   IF        PRTCD = *BLANKS                                            CLE025
     C                   EVAL      CLE025 = 'Y'                                               CLE025
     C                   ELSE                                                                 CLE025
     C                   EVAL      CLE025 = 'N'                                               CLE025
     C                   ENDIF                                                                CLE025
                                                                                              CAP086
      ** Access SAR details file to determine if                                              CAP086
      ** Automatic Authorisation is installed                                                 CAP086
                                                                                              CAP086
     C                   EVAL      CAP086 = 'N'                                               CAP086
     C                   CALL      'AOSARDR0'                                                 CAP086
     C                   PARM      *BLANKS       @RTCD                                        CAP086
     C                   PARM      '*VERIFY'     @OPTN                                        CAP086
     C                   PARM      'CAP086'      @SARD                                        CAP086
     C     SCSARD        PARM      SCSARD        DSFDY                                        CAP086
                                                                                              CAP086
     C                   IF        @RTCD <> *BLANKS AND                                       CAP086
     C                             @RTCD <> '*NRF'                                            CAP086
     C     *LOCK         IN        LDA                                                        CAP086
     C                   EVAL      DBPGM = 'GLAMADUPD'                                        CAP086
     C                   EVAL      DBKEY = 'CAP086'                                           CAP086
     C                   EVAL      DBFILE ='SCSARDPD'                                         CAP086
     C                   EVAL      DBASE  = 909                                               CAP086
     C                   OUT       LDA                                                        CAP086
     C                   EXSR      *PSSR                                                      CAP086
     C                   ENDIF                                                                CAP086
                                                                                              CAP086
     C                   IF        @RTCD = *BLANK                                             CAP086
     C                   EVAL      CAP086 = 'Y'                                               CAP086
     C                   ENDIF                                                                CAP086
                                                                                              CSD015
     C     KCwFld        KLIST                                                                CSD015
     C                   KFLD                    WFuncType                                    CSD015
     C                   KFLD                    WIdntifier                                   CSD015
     C                   KFLD                    WBranch                                      CSD015
                                                                                              CSD015
     C*
     C/COPY WNCPYSRC,GLAMADDC03
      *                                                                                       CRE023
      ** Access SAR details file to determine if 2'O Clock Flag SAR                           CRE023
      ** processing is switched ON                                                            CRE023
      *                                                                                       CRE023
     C                   CALL      'AOSARDR0'                                                 CRE023
     C                   PARM      *BLANKS       @RTCD                                        CRE023
     C                   PARM      '*VERIFY'     @OPTN                                        CRE023
     C                   PARM      'CRE023'      @SARD                                        CRE023
     C                   PARM      *BLANKS       DSFDY                                        CRE023
      *                                                                                       CRE023
     C                   SELECT                                                               CRE023
     C                   WHEN      @RTCD = *BLANKS                                            CRE023
     C                   EVAL      CRE023 = 'Y'                                               CRE023
     C                   OPEN      REMEMLL0                                                   CRE023
     C                   WHEN      @RTCD = '*NRF   '                                          CRE023
     C                   EVAL      CRE023 = 'N'                                               CRE023
     C                   OTHER                                                                CRE023
     C     *LOCK         IN        LDA                                                        CRE023
     C                   EVAL      DBKEY = @SARD                                              CRE023
     C                   EVAL      DBFILE = 'SCSARDPD'                                        CRE023
     C                   EVAL      DBASE = 910                                                CRE023
     C                   OUT       LDA                                                        CRE023
     C                   EXSR      SRERR                                                      CRE023
     C                   ENDSL                                                                CRE023
      *                                                                                       CRE023
                                                                                              CRE005
      ** Access SAR file to determine if CRE005 is present.                                   CRE005
     C                   CALLB     'AOSARDR0'                                                 CRE005
     C                   PARM      *BLANKS       @RTCD                                        CRE005
     C                   PARM      '*VERIFY'     @OPTN                                        CRE005
     C                   PARM      'CRE005'      @SARD                                        CRE005
     C     SCSARD        PARM      SCSARD        DSFDY                                        CRE005
     C     @RTCD         IFNE      *BLANKS                                                    CRE005
     C     @RTCD         ANDNE     '*NRF   '                                                  CRE005
     C     *LOCK         IN        LDA                                                        CRE005
     C                   MOVEL     'SCSARDPD'    DBFILE                                       CRE005
     C                   Z-ADD     1             DBASE                                        CRE005
     C                   MOVEL     'CRE005'      DBKEY                                        CRE005
     C                   OUT       LDA                                                        CRE005
     C                   SETON                                        U7U8LR                  CRE005
     C                   EXSR      *PSSR                                                      CRE005
     C                   ENDIF                                                                CRE005
     C                   MOVEL     'N'           CRE005            1                          CRE005
     C     @RTCD         IFEQ      *BLANK                                                     CRE005
     C                   MOVEL     'Y'           CRE005                                       CRE005
     C                   ENDIF                                                                CRE005
      *                                                                                       CRE005
      ** Dummy read to allow files to be specified as UPDATE in F-spec                        CRE005
     C                   EVAL      *IN02 = *OFF                                               CRE005
     C     *IN02         IFEQ      *ON                                                        CRE005
     C                   READ      RERCH1PD                               80                  CRE005
     C                   READ      RERCH2PD                               80                  CRE005
     C                   READ      RERCH3PD                               80                  CRE005
     C                   ENDIF                                                                CRE005
      *                                                                                       CRE005
      ** Check if term and notice account feature is installed                                CRE015
      *                                                                                       CRE015
     C                   EVAL      CRE015 = 'N'                                               CRE015
     C                   CALL      'AOSARDR0'                                                 CRE015
     C                   PARM      *BLANKS       @RTCD                                        CRE015
     C                   PARM      '*VERIFY'     @OPTN                                        CRE015
     C                   PARM      'CRE015'      @SARD                                        CRE015
     C     SCSARD        PARM      SCSARD        DSFDY                                        CRE015
                                                                                              CRE015
     C                   IF        @RTCD <> *BLANKS AND                                       CRE015
     C                             @RTCD <> '*NRF'                                            CRE015
     C     *LOCK         IN        LDA                                                        CRE015
     C                   EVAL      DBKEY = 'CRE015'                                           CRE015
     C                   EVAL      DBFILE ='SCSARDPD'                                         CRE015
     C                   EVAL      DBASE  = 903                                               CRE015
     C                   OUT       LDA                                                        CRE015
     C                   EXSR      *PSSR                                                      CRE015
     C                   ENDIF                                                                CRE015
                                                                                              CRE015
     C                   IF        @RTCD = *BLANKS                                            CRE015
     C                   EVAL      CRE015 = 'Y'                                               CRE015
     C                   ENDIF                                                                CRE015
      ** Check if enhancement CER047 is on                                                    CER047
      *                                                                                       CER047
     C                   CALLB     'AOSARDR0'                                                 CER047
     C                   PARM      *BLANKS       PRTCD                                        CER047
     C                   PARM      '*VERIFY'     POPTN                                        CER047
     C                   PARM      'CER047'      PSARD                                        CER047
     C     SCSARD        PARM      SCSARD        DSFDY                                        CER047
                                                                                              CER047
     C                   IF        PRTCD = *BLANKS                                            CER047
     C                   EVAL      CER047 = 'Y'                                               CER047
     C                   ELSE                                                                 CER047
     C                   EVAL      CER047 = 'N'                                               CER047
     C                   ENDIF                                                                CER047
                                                                                              CER047
     C                   IF        PRTCD <> *BLANKS  AND  PRTCD <> '*NRF   '                  CER047
     C     *LOCK         IN        LDA                                                        CER047
     C                   EVAL      DBFILE = 'SCSARDPD'                                        CER047
     C                   EVAL      DBKEY = 'CER047'                                           CER047
     C                   EVAL      DBASE = 74                                                 CER047
     C                   OUT       LDA                                                        CER047
     C                   EXSR      *PSSR                                                      CER047
     C                   ENDIF                                                                CER047
      *                                                                                       CER047
      ** Check if enhancement CRE075 is ON                                                    CRE075
      *                                                                                       CRE075
     C                   CALLB     'AOSARDR0'                                                 CRE075
     C                   PARM      *BLANKS       PRTCD                                        CRE075
     C                   PARM      '*VERIFY'     POPTN                                        CRE075
     C                   PARM      'CRE075'      PSARD                                        CRE075
     C     SCSARD        PARM      SCSARD        DSFDY                                        CRE075
                                                                                              CRE075
     C                   IF        PRTCD = *BLANKS                                            CRE075
     C                   EVAL      CRE075 = 'Y'                                               CRE075
     C                   ELSE                                                                 CRE075
     C                   EVAL      CRE075 = 'N'                                               CRE075
     C                   ENDIF                                                                CRE075
                                                                                              CRE075
     C                   IF        PRTCD <> *BLANKS  AND  PRTCD <> '*NRF   '                  CRE075
     C     *LOCK         IN        LDA                                                        CRE075
     C                   EVAL      DBFILE = 'SCSARDPD'                                        CRE075
     C                   EVAL      DBKEY = 'CRE075'                                           CRE075
     C                   EVAL      DBASE = 78                                                 CRE075
     C                   OUT       LDA                                                        CRE075
     C                   EXSR      *PSSR                                                      CRE075
     C                   ENDIF                                                                CRE075
      *                                                                                       CRE075
      ** Check if enhancement CER055 is ON                                                    CER055
      *                                                                                       CER055
     C                   CALLB     'AOSARDR0'                                                 CER055
     C                   PARM      *BLANKS       PRTCD                                        CER055
     C                   PARM      '*VERIFY'     POPTN                                        CER055
     C                   PARM      'CER055'      PSARD                                        CER055
     C     SCSARD        PARM      SCSARD        DSFDY                                        CER055
                                                                                              CER055
     C                   IF        PRTCD = *BLANKS                                            CER055
     C                   EVAL      CER055 = 'Y'                                               CER055
     C                   ELSE                                                                 CER055
     C                   EVAL      CER055 = 'N'                                               CER055
     C                   ENDIF                                                                CER055
                                                                                              CER055
     C                   IF        PRTCD <> *BLANKS  AND  PRTCD <> '*NRF   '                  CER055
     C     *LOCK         IN        LDA                                                        CER055
     C                   EVAL      DBFILE = 'SCSARDPD'                                        CER055
     C                   EVAL      DBKEY = 'CER055'                                           CER055
     C                   EVAL      DBASE = 79                                                 CER055
     C                   OUT       LDA                                                        CER055
     C                   EXSR      *PSSR                                                      CER055
     C                   ENDIF                                                                CER055
      *                                                                                       CER055
      ** Check if enhancement CRE073 is ON                                                    CRE073
      *                                                                                       CRE073
     C                   CALLB     'AOSARDR0'                                                 CRE073
     C                   PARM      *BLANKS       PRTCD                                        CRE073
     C                   PARM      '*VERIFY'     POPTN                                        CRE073
     C                   PARM      'CRE073'      PSARD                                        CRE073
     C     SCSARD        PARM      SCSARD        DSFDY                                        CRE073
                                                                                              CRE073
     C                   IF        PRTCD = *BLANKS                                            CRE073
     C                   EVAL      CRE073 = 'Y'                                               CRE073
     C                   ELSE                                                                 CRE073
     C                   EVAL      CRE073 = 'N'                                               CRE073
     C                   ENDIF                                                                CRE073
                                                                                              CRE073
     C                   IF        PRTCD <> *BLANKS  AND  PRTCD <> '*NRF   '                  CRE073
     C     *LOCK         IN        LDA                                                        CRE073
     C                   EVAL      DBFILE = 'SCSARDPD'                                        CRE073
     C                   EVAL      DBKEY = 'CRE073'                                           CRE073
     C                   EVAL      DBASE = 80                                                 CRE073
     C                   OUT       LDA                                                        CRE073
     C                   EXSR      *PSSR                                                      CRE073
     C                   ENDIF                                                                CRE073
     C/COPY WNCPYSRC,GLH00577
      *                                                                                       CRE073
      ** Check if enhancement CRE072 is ON                                                    CRE072
      *                                                                                       CRE072
     C                   CALLB     'AOSARDR0'                                                 CRE072
     C                   PARM      *BLANKS       PRTCD                                        CRE072
     C                   PARM      '*VERIFY'     POPTN                                        CRE072
     C                   PARM      'CRE072'      PSARD                                        CRE072
     C     SCSARD        PARM      SCSARD        DSFDY                                        CRE072
                                                                                              CRE072
     C                   IF        PRTCD = *BLANKS                                            CRE072
     C                   EVAL      CRE072 = 'Y'                                               CRE072
     C                   ELSE                                                                 CRE072
     C                   EVAL      CRE072 = 'N'                                               CRE072
     C                   ENDIF                                                                CRE072
                                                                                              CRE072
     C                   IF        PRTCD <> *BLANKS  AND  PRTCD <> '*NRF   '                  CRE072
     C     *LOCK         IN        LDA                                                        CRE072
     C                   EVAL      DBFILE = 'SCSARDPD'                                        CRE072
     C                   EVAL      DBKEY = 'CRE072'                                           CRE072
     C                   EVAL      DBASE = 81                                                 CRE072
     C                   OUT       LDA                                                        CRE072
     C                   EXSR      *PSSR                                                      CRE072
     C                   ENDIF                                                                CRE072
      *                                                                                       CRE072
      ** Check if enhancement CGL165 is ON                                                    CGL165
      *                                                                                       CGL165
     C                   CALLB     'AOSARDR0'                                                 CGL165
     C                   PARM      *BLANKS       PRTCD                                        CGL165
     C                   PARM      '*VERIFY'     POPTN                                        CGL165
     C                   PARM      'CGL165'      PSARD                                        CGL165
     C     SCSARD        PARM      SCSARD        DSFDY                                        CGL165
                                                                                              CGL165
     C                   IF        PRTCD = *BLANKS                                            CGL165
     C                   EVAL      CGL165 = 'Y'                                               CGL165
     C                   ELSE                                                                 CGL165
     C                   EVAL      CGL165 = 'N'                                               CGL165
     C                   ENDIF                                                                CGL165
      *                                                                                     MD034725
      ** Check if enhancement CTI006 is ON                                                  MD034725
      *                                                                                     MD034725
     C                   CALLB     'AOSARDR0'                                               MD034725
     C                   PARM      *BLANKS       PRTCD                                      MD034725
     C                   PARM      '*VERIFY'     POPTN                                      MD034725
     C                   PARM      'CTI006'      PSARD                                      MD034725
     C     SCSARD        PARM      SCSARD        DSFDY                                      MD034725
                                                                                            MD034725
     C                   IF        PRTCD = *BLANKS                                          MD034725
     C                   EVAL      CTI006 = 'Y'                                             MD034725
     C                   ELSE                                                               MD034725
     C                   EVAL      CTI006 = 'N'                                             MD034725
     C                   ENDIF                                                              MD034725
                                                                                            MD034725
     C                   IF        PRTCD <> *BLANKS  AND  PRTCD <> '*NRF   '                MD034725
     C     *LOCK         IN        LDA                                                      MD034725
     C                   EVAL      DBFILE = 'SCSARDPD'                                      MD034725
     C                   EVAL      DBKEY = 'CTI006'                                         MD034725
     C                   EVAL      DBASE = 82                                               MD034725
     C                   OUT       LDA                                                      MD034725
     C                   EXSR      *PSSR                                                    MD034725
     C                   ENDIF                                                              MD034725
      *                                                                                     MD034725
      ** Check if enhancement CER050 is ON                                                    CER050
      *                                                                                       CER050
     C                   CallB     'AOSARDR0'                                                 CER050
     C                   Parm      *BLANKS       PRTCD                                        CER050
     C                   Parm      '*VERIFY'     POPTN                                        CER050
     C                   Parm      'CER050'      PSARD                                        CER050
     C     SCSARD        Parm      SCSARD        DSFDY                                        CER050
                                                                                              CER050
     C                   If        PRTCD = *BLANKS                                            CER050
     C                   Eval      CER050 = 'Y'                                               CER050
     C                   Else                                                                 CER050
     C                   Eval      CER050 = 'N'                                               CER050
     C                   Endif                                                                CER050
                                                                                              CER050
     C                   ENDSR
     C****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * INITIAL - Program Initialisation routine                      *
      *                                                               *
      * Called by: Main processing                                    *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
     C     INITIAL       BEGSR
      *
      ** CLEAR DATA STRUCTURES
     C                   CLEAR                   B_ACCNT
     C                   CLEAR                   B_ACCNTX
     C                   CLEAR                   B_REIAD
      *
      ** Access Midas Base Rate details DEBIT
      *
     C                   EVAL      W#DBRT=*ZERO                                               216905
     C     AMDRIB        IFNE      *ZEROS
      *
     C                   MOVEL(P)  AMDRIB        @BSRC
     C                   CALLB     'AOBSRTR0'
     C                   PARM      '*MSG    '    @RTCD
     C                   PARM      '*KEY    '    @OPTN
     C                   PARM      AMCCY         @CYCD             3
     C                   PARM                    @BSRC             2
     C     SDBSRT        PARM      SDBSRT        DSSDY
      *
      * DATABASE ERROR
      *
     C     @RTCD         IFNE      *BLANK
     C                   MOVEL     AMDRIB        DBKEY
     C                   MOVEL     'SDBSRTPD'    DBFILE                         *************
     C                   MOVEL     '903'         DBASE                          * DBERR 903 *
     C                   EXSR      SRERR                                        *************
     C                   END
     C************       EVAL      WWDBRT = BANBRT                                            216905
     C                   EVAL      W#DBRT = BANBRT                                            216905
     C                   ENDIF
      *
      ** Access Midas Base Rate details CREDIT
      *
     C                   EVAL      W#CBRT=*ZERO                                               216905
     C     AMCRIB        IFNE      *ZEROS
      *
     C                   MOVEL(P)  AMCRIB        @BSRC
     C                   CALLB     'AOBSRTR0'
     C                   PARM      '*MSG    '    @RTCD
     C                   PARM      '*KEY    '    @OPTN
     C                   PARM      AMCCY         @CYCD
     C                   PARM                    @BSRC
     C     SDBSRT        PARM      SDBSRT        DSSDY
      *
      * DATABASE ERROR
      *
     C     @RTCD         IFNE      *BLANK
     C                   MOVEL     AMCRIB        DBKEY
     C                   MOVEL     'SDBSRTPD'    DBFILE                         *************
     C                   MOVEL     '904'         DBASE                          * DBERR 904 *
     C                   EXSR      SRERR                                        *************
     C                   END
     C************       EVAL      WWCBRT = BANBRT                                            216905
     C                   EVAL      W#CBRT = BANBRT                                            216905
     C                   ENDIF
                                                                                              CRE015
      ** Access account code extension details                                                CRE015
                                                                                              CRE015
     C                   IF        CRE015 = 'Y'                                               CRE015
     C                   MOVE      AMACOD        K#ACOD                                       CRE015
     C     K#ACOD        CHAIN     SDACD1L0                                                   CRE015
     C                   IF        NOT %FOUND(SDACD1L0)                                       CRE015
     C                   CLEAR                   SDACD1D0                                     CRE015
     C                   ENDIF                                                                CRE015
                                                                                              CRE015
      ** Initialise array                                                                     CRE015
                                                                                              CRE015
     C                   CLEAR                   REPRPN                                       CRE015
     C                   DO        26            X                                            CRE015
     C                   EVAL      ArrFilBuf(X) = REPRPN                                      CRE015
     C                   ENDDO                                                                CRE015
     C                   ENDIF                                                                CRE015
     C*
     C** Define key list for file REIAC
     C*
     C     RetKey        KLIST
     C                   KFLD                    CustNum1
     C                   KFLD                    Currency1
     C                   KFLD                    AccCode1
     C                   KFLD                    AccSeq1
     C                   KFLD                    Branch1
     C*                                                                                       237346
     C** Define key list for file REHISBL & RECOM & ACCBR for Alternate                       237346
     C*                                                                                       237346
     C     RehisAlt      KLIST                                                                237346
     C                   KFLD                    Branch1                                      237346
     C                   KFLD                    CustNum1                                     237346
     C                   KFLD                    Currency1                                    237346
     C                   KFLD                    AccCode1                                     237346
     C                   KFLD                    AccSeq1                                      237346
     C*
     C** Define key list for file REHISBL & RECOM & ACCBR
     C*
     C     RehisKey      KLIST
     C                   KFLD                    Branch
     C                   KFLD                    CustNum
     C                   KFLD                    Currency
     C                   KFLD                    AccCode
     C                   KFLD                    AccSeq
     C*
     C** Define key list for file REODHSL0 and REHISLS
     C*
     C     REODHKey      KLIST
     C                   KFLD                    Branch
     C                   KFLD                    CustNum
     C                   KFLD                    Currency
     C                   KFLD                    AccCode
     C                   KFLD                    AccSeq
     C                   KFLD                    Date
     C*
     C** Define key list for file ACCNTL0 & REIAC & REACR & ACCNTBXC
     C*
     C     AccntKey      KLIST
     C                   KFLD                    CustNum
     C                   KFLD                    Currency
     C                   KFLD                    AccCode
     C                   KFLD                    AccSeq
     C                   KFLD                    Branch
     C                   EVAL      CustNum =AMCNUM
     C                   EVAL      Currency=AMCCY
     C                   EVAL      AccCode =AMACOD
     C                   EVAL      AccSeq  =AMACSQ
     C                   EVAL      Branch  =AMBRCA
     C                   EVAL      Date    =BXOLVD
     C*
     C                   Z-ADD     *ZERO         NATN              5 0
     C/COPY WNCPYSRC,GLAMADDC09
     C*
     C*
                                                                                              CSD083
      ** Check if Watch List Element (CSD083) is on                                           CSD083
                                                                                              CSD083
     C                   CALL      'AOSARDR0'                                                 CSD083
     C                   PARM      *BLANKS       @RTCD                                        CSD083
     C                   PARM      '*VERIFY'     @OPTN                                        CSD083
     C                   PARM      'CSD083'      @SARD                                        CSD083
     C     SCSARD        PARM      SCSARD        DSFDY                                        CSD083
                                                                                              CSD083
     C                   IF        @RTCD <> *BLANKS AND                                       CSD083
     C                             @RTCD <> '*NRF'                                            CSD083
     C     *LOCK         IN        LDA                                                        CSD083
     C                   EVAL      DBKEY = 'CSD083'                                           CSD083
     C                   EVAL      DBFILE ='SCSARDPD'                                         CSD083
     C                   EVAL      DBASE  = 911                                               CSD083
     C                   OUT       LDA                                                        CSD083
     C                   EXSR      *PSSR                                                      CSD083
     C                   ENDIF                                                                CSD083
                                                                                              CSD083
     C                   IF        @RTCD = *BLANKS                                            CSD083
     C                   EVAL      CSD015 = 'N'                                               CSD083
     C                   ENDIF                                                                CSD083
                                                                                              CSD083
     C                   ENDSR
     C****************************************************************
      /EJECT
     C/COPY WNCPYSRC,GLAMADDC10
     C****************************************************************
     C*                                                              *
     C* SRERR - EXCEPTION ERRORS                                     *
     C*                                                              *
     C****************************************************************

     C     SRERR         BEGSR
     C*
     C                   MOVEL     '*ERROR '     @@RTCD
     C                   MOVEL     'GLAMADUPD'   DBPGM            10
     C                   MOVE      '1'           *INU7
     C                   MOVE      '1'           *INU8
     C                   MOVE      '1'           *INLR
     C                   DUMP
     C*
     C**  TERMINATE THE PROGRAM
     C*
     C                   RETURN
     C*
     C                   ENDSR

      *****************************************************************
      /EJECT
      *****************************************************************
      **--------------------------------------------------------------------------------------------
      ** The following /COPY contains the standard program status
      ** subroutine, including a bound call to the DBERRCTL module.
     C/COPY ZACPYSRC,PSSR_ILE
      **--------------------------------------------------------------------------------------------
     C****************************************************************
      /EJECT
      *********************************************************************
      *                                                               *                       CSD015
      * SRWTCH - Set-up parameter and send transaction details to     *                       CSD015
      *          Compliance Watch by calling the Engine program       *                       CSD015
      *                                                               *                       CSD015
      *****************************************************************                       CSD015
     C     SRWTCH        BEGSR                                                                CSD015
                                                                                              CSD015
      ** Set-up first parameter for Compliance Engine                                         CSD015
                                                                                              CSD015
     C                   EVAL      PDSWLTD = *BLANKS                                          CSD015
     C                   EVAL      W4ITEM = 'GLACCT'                                          CSD015
     C                   MOVE      AC_CNUM       WCust                                        CSD015
     C                   MOVE      AC_ACOD       WAcod                                        CSD015
     C                   MOVE      AC_ACSQ       WAcsq                                        CSD015
     C                   EVAL      W4IDEN = AC_BRCA + Wcust +                                 CSD015
     C                             AC_CCY + WAcod + WAcsq                                     CSD015
     C                   EVAL      W4BRCH = AC_BRCA                                           CSD015
     C                   EVAL      W4FUNT = 'ACCNTAB'                                         CSD015
                                                                                              CSD015
      ** Get Main System Prefix from data area SC24X7 if enhancement                          CSD015
      ** CSC011 is installed, else get it from SDSTAT                                         CSD015
                                                                                              CSD015
     C                   IF        CSC011 = 'Y'                                               CSD015
     C                   EVAL      W4SYSM = S1MAIN                                            CSD015
     C                   ELSE                                                                 CSD015
     C                   EVAL      W4SYSM = LIBR                                              CSD015
     C                   ENDIF                                                                CSD015
                                                                                              CSD015
      ** Access customer details file for Counter Party (Midas Report                         CSD015
      ** Name + Customer Report Town)                                                         CSD015
                                                                                              CSD015
     C                   MOVE      AC_CNUM       PCUST                                        CSD015
     C                   CALLB     'AOCUSTR0'                                                 CSD015
     C                   PARM      *BLANKS       PRtCd                                        CSD015
     C                   PARM      '*KEY'        POPTN                                        CSD015
     C                   PARM                    PCUST                                        CSD015
     C                   PARM      *BLANKS       PSTKEY                                       CSD015
     C     SDCUST        PARM      SDCUST        DSSDY                                        CSD015
                                                                                              CSD015
      ** If Concord Interface Development is installed (CCF001)                               CSD015
                                                                                              CSD015
     C                   IF        CCF001 = 'Y'                                               CSD015
                                                                                              CSD015
     C                   IF        BBCRPC = 'Y'                                               CSD015
     C                   EVAL      W4CTYP = 'C'                                               CSD015
     C                   ELSE                                                                 CSD015
     C                   EVAL      W4CTYP = 'I'                                               CSD015
     C                   ENDIF                                                                CSD015
                                                                                              CSD015
     C                   ELSE                                                                 CSD015
                                                                                              CSD015
     C                   IF        BBLICD <> *BLANKS                                          CSD015
     C                             AND BBLICD <> W1IND1                                       CSD015
     C                             AND BBLICD <> W1IND2                                       CSD015
     C                             AND BBLICD <> W1IND3                                       CSD015
     C                             AND BBLICD <> W1IND4                                       CSD015
     C                             AND BBLICD <> W1IND5                                       CSD015
     C                   EVAL      W4CTYP = 'C'                                               CSD015
     C                   ELSE                                                                 CSD015
     C                   EVAL      W4CTYP = 'I'                                               CSD015
     C                   ENDIF                                                                CSD015
                                                                                              CSD015
     C                   ENDIF                                                                CSD015
                                                                                              CSD015
     C     BBCRNM        CAT       BBCRTN        W4CUST                                       CSD015
     C                   MOVE      BBCUST        W4CNUM                                       CSD015
                                                                                              CSD015
      ** Deal Date                                                                            CSD015
     C                   MOVE      *BLANKS       PZADayNo                                     CSD015
     C                   EXSR      SRDateToDDT                                                CSD015
     C                   EVAL      W4DDAT = WDDT                                              CSD015
                                                                                              CSD015
      ** Value Date                                                                           CSD015
     C                   MOVE      AC_DACO       PZADayNo                                     CSD015
     C                   EXSR      SRDateToDDT                                                CSD015
     C                   EVAL      W4VDAT = WDDT                                              CSD015
                                                                                              CSD015
      ** Maturity Date                                                                        CSD015
     C                   MOVE      AC_DACC       PZADayNo                                     CSD015
     C                   EXSR      SRDateToDDT                                                CSD015
     C                   EVAL      W4MDAT = WDDT                                              CSD015
                                                                                              CSD015
      ** Denomination 1 and 2                                                                 CSD015
     C                   EVAL      W4DEN1 = AC_CCY                                            CSD015
     C                   EVAL      W4DEN2 = *BLANKS                                           CSD015
                                                                                              CSD015
      ** Amount side 1 and 2                                                                  CSD015
     C                   EVAL      PCcy = AC_CCY                                              CSD015
     C                   MOVE      AC_LDBL       PAmnt                                        CSD015
     C                   EXSR      SRConvAmt                                                  CSD015
     C                   EVAL      W4AMT1 = PConvertdAmt                                      CSD015
                                                                                              CSD015
     C                   EVAL      W4AMT2 = *ZERO                                             CSD015
                                                                                              CSD015
      ** Set-up second parameter for Compliance Engine                                        CSD015
                                                                                              CSD015
     C                   EVAL      PDSXML = *BLANKS                                           CSD015
                                                                                              CSD015
      ** Set-up Account Name                                                                  CSD015
                                                                                              CSD015
     C                   CAT       ARRTAG(1):0   PDSXML                                       CSD015
     C                   CAT       AC_ANAM:0     PDSXML                                       CSD015
     C                   CAT       ARRTAG(2):0   PDSXML                                       CSD015
                                                                                              CSD015
      ** Send transaction details to Compliance Watch                                         CSD015
                                                                                              CSD015
     C                   CALL      'SDCWLCHK'                                                 CSD015
     C                   PARM                    PDSWLTD                                      CSD015
     C                   PARM                    PDSXML                                       CSD015
                                                                                              CSD015
     C                   ENDSR                                                                CSD015
      *****************************************************************                       CSD015
      /EJECT                                                                                  CSD015
      *****************************************************************                       CSD015
      *                                                               *                       CSD015
      * SRXWTCH - Set-up parameter and send transaction details to    *                       CSD015
      *           Compliance Watch by calling the Engine program      *                       CSD015
      *           for Standing Data Authorisation                     *                       CSD015
      *                                                               *                       CSD015
      *****************************************************************                       CSD015
     C     SRXWTCH       BEGSR                                                                CSD015
                                                                                              CSD015
      ** Set-up first parameter for Compliance Engine                                         CSD015
                                                                                              CSD015
     C                   EVAL      PDSWLTD = *BLANKS                                          CSD015
     C                   EVAL      W4ITEM = 'GLACCT'                                          CSD015
     C                   MOVE      TAC_CNUM      WCust                                        CSD015
     C                   MOVE      TAC_ACOD      WAcod                                        CSD015
     C                   MOVE      TAC_ACSQ      WAcsq                                        CSD015
     C                   EVAL      W4IDEN = TAC_BRCA + Wcust +                                CSD015
     C                             TAC_CCY + WAcod + WAcsq                                    CSD015
     C                   EVAL      W4BRCH = TAC_BRCA                                          CSD015
     C                   EVAL      W4FUNT = 'ACCNTAB'                                         CSD015
                                                                                              CSD015
      ** Get Main System Prefix from data area SC24X7 if enhancement                          CSD015
      ** CSC011 is installed, else get it from SDSTAT                                         CSD015
                                                                                              CSD015
     C                   IF        CSC011 = 'Y'                                               CSD015
     C                   EVAL      W4SYSM = S1MAIN                                            CSD015
     C                   ELSE                                                                 CSD015
     C                   EVAL      W4SYSM = LIBR                                              CSD015
     C                   ENDIF                                                                CSD015
                                                                                              CSD015
      ** Access customer details file for Counter Party (Midas Report                         CSD015
      ** Name + Customer Report Town)                                                         CSD015
                                                                                              CSD015
     C                   MOVE      TAC_CNUM      PCUST                                        CSD015
     C                   CALLB     'AOCUSTR0'                                                 CSD015
     C                   PARM      *BLANKS       PRtCd                                        CSD015
     C                   PARM      '*KEY'        POPTN                                        CSD015
     C                   PARM                    PCUST                                        CSD015
     C                   PARM      *BLANKS       PSTKEY                                       CSD015
     C     SDCUST        PARM      SDCUST        DSSDY                                        CSD015
                                                                                              CSD015
      ** If Concord Interface Development is installed (CCF001)                               CSD015
                                                                                              CSD015
     C                   IF        CCF001 = 'Y'                                               CSD015
                                                                                              CSD015
     C                   IF        BBCRPC = 'Y'                                               CSD015
     C                   EVAL      W4CTYP = 'C'                                               CSD015
     C                   ELSE                                                                 CSD015
     C                   EVAL      W4CTYP = 'I'                                               CSD015
     C                   ENDIF                                                                CSD015
                                                                                              CSD015
     C                   ELSE                                                                 CSD015
                                                                                              CSD015
     C                   IF        BBLICD <> *BLANKS                                          CSD015
     C                             AND BBLICD <> W1IND1                                       CSD015
     C                             AND BBLICD <> W1IND2                                       CSD015
     C                             AND BBLICD <> W1IND3                                       CSD015
     C                             AND BBLICD <> W1IND4                                       CSD015
     C                             AND BBLICD <> W1IND5                                       CSD015
     C                   EVAL      W4CTYP = 'C'                                               CSD015
     C                   ELSE                                                                 CSD015
     C                   EVAL      W4CTYP = 'I'                                               CSD015
     C                   ENDIF                                                                CSD015
                                                                                              CSD015
     C                   ENDIF                                                                CSD015
                                                                                              CSD015
     C     BBCRNM        CAT       BBCRTN        W4CUST                                       CSD015
     C                   MOVE      BBCUST        W4CNUM                                       CSD015
                                                                                              CSD015
      ** Deal Date                                                                            CSD015
     C                   MOVE      *BLANKS       PZADayNo                                     CSD015
     C                   EXSR      SRDateToDDT                                                CSD015
     C                   EVAL      W4DDAT = WDDT                                              CSD015
                                                                                              CSD015
      ** Value Date                                                                           CSD015
     C                   MOVE      TAC_DACO      PZADayNo                                     CSD015
     C                   EXSR      SRDateToDDT                                                CSD015
     C                   EVAL      W4VDAT = WDDT                                              CSD015
                                                                                              CSD015
      ** Maturity Date                                                                        CSD015
     C                   MOVE      TAC_DACC      PZADayNo                                     CSD015
     C                   EXSR      SRDateToDDT                                                CSD015
     C                   EVAL      W4MDAT = WDDT                                              CSD015
                                                                                              CSD015
      ** Denomination 1 and 2                                                                 CSD015
     C                   EVAL      W4DEN1 = TAC_CCY                                           CSD015
     C                   EVAL      W4DEN2 = *BLANKS                                           CSD015
                                                                                              CSD015
      ** Amount side 1 and 2                                                                  CSD015
     C                   EVAL      PCcy = TAC_CCY                                             CSD015
     C                   MOVE      TAC_LDBL      PAmnt                                        CSD015
     C                   EXSR      SRConvAmt                                                  CSD015
     C                   EVAL      W4AMT1 = PConvertdAmt                                      CSD015
                                                                                              CSD015
     C                   EVAL      W4AMT2 = *ZERO                                             CSD015
                                                                                              CSD015
      ** Set-up second parameter for Compliance Engine                                        CSD015
                                                                                              CSD015
     C                   EVAL      PDSXML = *BLANKS                                           CSD015
                                                                                              CSD015
      ** Set-up Account Name                                                                  CSD015
                                                                                              CSD015
     C                   CAT       ARRTAG(1):0   PDSXML                                       CSD015
     C                   CAT       TAC_ANAM:0    PDSXML                                       CSD015
     C                   CAT       ARRTAG(2):0   PDSXML                                       CSD015
                                                                                              CSD015
      ** Send transaction details to Compliance Watch                                         CSD015
                                                                                              CSD015
     C                   CALL      'SDCWLCHK'                                                 CSD015
     C                   PARM                    PDSWLTD                                      CSD015
     C                   PARM                    PDSXML                                       CSD015
                                                                                              CSD015
     C                   ENDSR                                                                CSD015
      *****************************************************************                       CSD015
      /EJECT                                                                                  CSD015
      *****************************************************************                       CSD015
      *                                                               *                       CSD015
      * SRDateToDDT - Converts a date into Date Data Type format.     *                       CSD015
      *                                                               *                       CSD015
      *****************************************************************                       CSD015
     C     SRDateToDDT   BEGSR                                                                CSD015
                                                                                              CSD015
      ** Convert the derived Midas Day Number into Date Data Type.                            CSD015
                                                                                              CSD015
     C                   CALL      'ZACVTDATE'                                                CSD015
     C                   PARM      *BLANKS       PZARtCd                                      CSD015
     C                   PARM                    PZADayNo                                     CSD015
     C                   PARM                    PZADDT                                       CSD015
     C                   PARM                    PZACvtDt                                     CSD015
                                                                                              CSD015
     C                   EVAL      WDDT = PZADDT                                              CSD015
                                                                                              CSD015
     C                   ENDSR                                                                CSD015
      *****************************************************************                       CSD015
      /EJECT                                                                                  CSD015
      *****************************************************************                       CSD015
      *                                                               *                       CSD015
      * SRConvAmt - Converts amount to 18,3 format.                   *                       CSD015
      *                                                               *                       CSD015
      *****************************************************************                       CSD015
     C     SRConvAmt     BEGSR                                                                CSD015
                                                                                              CSD015
     C                   CALL      'ZACVTAMT'                                                 CSD015
     C                   PARM                    PRtCd                                        CSD015
     C                   PARM                    PCcy                                         CSD015
     C                   PARM                    PAmnt                                        CSD015
     C                   PARM                    PConvertdAmt                                 CSD015
     C                   PARM                    PDummy16                                     CSD015
                                                                                              CSD015
     C                   ENDSR                                                                CSD015
      *****************************************************************                       CSD015
      /EJECT                                                                                  CSD015
      *****************************************************************                       CSD015
      * Removed ** CMD5 OVRDBF FILE(REPWSHL0) TOFILE(REPWSHL0) SHARE(*NO)                     CSD101
**  CPY@
(c) Finastra International Limited 2001
** CMD1
OVRDBF FILE(GLACSHL0) TOFILE(GLACSHL0) SHARE(*NO)
** CMD2
OVRDBF FILE(GLBXSHL0) TOFILE(GLBXSHL0) SHARE(*NO)
** CMD3
OVRDBF FILE(REIASHL0) TOFILE(REIASHL0) SHARE(*NO)
** CMD4
OVRDBF FILE(RECMSHL0) TOFILE(RECMSHL0) SHARE(*NO)
**  ARRTAG                                                                                    CSD015
<Account Name>                                                                                CSD015
</Account Name>                                                                               CSD015
** ARREVNT                                                                                    CRE015
ABCDEFGHIJKLMNOPQRSTUVWXYZ                                                                    CRE015
