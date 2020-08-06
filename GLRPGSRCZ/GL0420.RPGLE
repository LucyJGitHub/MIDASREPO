     H DEBUG                                                                                  S01194
      *****************************************************************
/*XBI *  OVRDBF FILE(GLAPSGL0) TOFILE(GLAPSGAL0)                      *                       216937
/*S*D ***RPGBASE*******************************************************                      CGL061A
/*STD *  RPGBASEMOD                                                   *                      CGL061A
/*EXI *  TEXT('Midas GL Balance statements')                          *
0001 H***********
0002 F*****************************************************************
0003 F*                                                               *
     F*  Midas GENERAL LEDGER MODULE                                  *
0004 F*                                                               *
0005 F*  GL0420 - BALANCE STATEMENTS (A/C FORMATS)                    *
0006 F*                                                               *
      *  (c) Finastra International Limited 2001                      *
      *                                                               *
      *                                                               *
      *  Last Amend No. 220877             Date 22Mar19               *
      *  Prev Amend No. CGL188             Date 19Feb18               *
      *                 MD046248           Date 27Oct17               *
      *                 CGL184             Date 07Dec16               *
      *                 MD037536           Date 26Apr16               *
      *                 MD033999           Date 29Jun15               *
      *                 AR1014455          Date 23Jan14               *
      *                 MD020563           Date 21May13               *
      *                 AR1097176          Date 22Mar13               *
      *                 AR1096328          Date 15Mar13               *
      *                 CFC006             Date 06Aug12               *
      *                 CGL061A            Date 06Aug12               *
      *                 AR1004822          Date 30Jul12               *
      *                 CRE073             Date 06Dec10               *
      *                 CRE075             Date 06Dec10               *
      *                 CLE064             Date 06Dec10               *
      *                 AR676213           Date 19Nov10               *
      *                 CER059             Date 19Jul10               *
      *                 BUG22979A          Date 12Mar09               *
      *                 CER047             Date 19May08               *
      *                 BUG27725           Date 07Jun10               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      *                 BUG27359           Date 05Apr10               *
      *                 BUG26704           Date 10Nov09               *
      *                 CGL061             Date 29Jun06               *
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      *                 246285             Date 03May07               *
      *                 248797             Date 10Jul07               *
      *                 243837             Date 16Jan07               *
      *                 245223             Date 27Feb07               *
      *                 CRE026             Date 24May06               *
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 BG12511A           Date 26Nov06               *
      *                 BG12511            Date 06Nov06               *
      *                 239208             Date 01Jun06               *
      *                 239641             Date 31May06               *
      *                 CGL046             Date 15Feb06               *
      *                 CSD031             Date 10Apr06               *
      *                 236789             Date 06Jan06               *
      *                 CSD027             Date 09Dec05               *
      *                 CSW037A            Date 02May05               *
      *                 CSD023             Date 18Nov04               *
      *                 CSD025             Date 11Jan05               *
      *                 CSW037             Date 15Dec04               *
      *                 CSW036             Date 15Dec04               *
      *                 CLE025             Date 20Oct03               *
      *                 CGL029             Date 01Sep03               *
      *                 216937             Date 28Apr03               *
      *                 216006             Date 28Apr03               *
      * Midas Release 4.01 -------------------------------------------*
      *                 173551             Date 30Oct01               *
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.05 -----------------------------------------------*
      *                 177915             Date 24Jan01               *
      * Midas DBA 3.04 -----------------------------------------------*
      * Midas DBA 3.03 -----------------------------------------------*
      *                 176080             Date 11Feb00               *
      *                 144366             Date 11Feb00               *
      * Midas DBA 3.02 -----------------------------------------------*
      *  Prev Amend No. CAP035             Date 11Nov99               *
      *                 CFT004             Date 22Jul99               *
      *                 169210             Date 19Oct99               *
      * Midas DBA 3.01 -----------------------------------------------*
      *                 CGL007             Date 26Mar99               *
      * Midas DBA 3.00 ---------------- Base -------------------------*
      *                 156327             Date 11May99               *
      *                 CSD005             Date 01Mar99               *
      *                 154040             DATE 26APR99               *
     F*                 143155             DATE 21Sep98               *
     F*                 CEU013             DATE 08Apr98               *
     F*                 S01408             DATE 31Mar98               *
     F*                 S01408             DATE 09Feb98               *
     F*                 S01408             DATE 04NOV96               *
     F*                 S01408             DATE 07OCT96               *
     F*                 S01408             DATE 30AUG96               *
     F*                 S01408             DATE 12AUG96               *
     F*                 S01408             DATE 29APR96               *
     F*                 S01408             DATE 24APR96               *
     F*                 S01408             DATE 06FEB96               *
     F*                 S01408             DATE 25JAN96               *
     F*                 S01408             DATE 24JAN96               *
     F*                 096031             DATE 22JAN96               *
     F*                 S01408             DATE 10JAN96               *
     F*                 S01408             DATE 30NOV95               *
     F*                 S01408             DATE 11MAY95               *
     F*                 S01408             DATE 15MAR95               *
     F*                 S01408             DATE 12JAN95               *
     F*                 S01520             DATE 02NOV94               *
     F*                 S01408             DATE 06OCT94               *
     F*                 S01408             DATE 22AUG94               *
     F*                 063631             DATE 29JUN94               *
     F*                 S01408             DATE 17MAY94               *
     F*                 S01413             DATE 13APR93               *
     F*                 066562             DATE 17FEB94               *
     F*                 S01408             DATE 20JAN94               *
     F*                 055721             DATE 03FEB94               *
     F*                 056524             DATE 17JAN94               *
     F*                 054770             DATE 17JAN94               *
     F*                 059213             DATE 17JAN94               *
     F*                 046303             DATE 17JAN94               *
     F*                 057487             DATE 27OCT93               *
     F*                 044472             DATE 26AUG93               *
     F*                 E32012             DATE 16FEB93               *
     F*                 E38323             DATE 31JUL92               *
     F*                 E32657             DATE 03JUL92               *
     F*                 S01377             DATE 04APR92               *
     F*                 E26793             DATE 12MAR92               *
     F*                 E30556             DATE 30OCT91               *
     F*                 E24147             DATE 03OCT91               *
     F*                 E24683             DATE 20SEP91               *
     F*                 E26667             DATE 30JUL91               *
     F*                 E24003             DATE 23NOV90               *
     F*                 E23370             DATE 21AUG90               *
     F*                 E22281             DATE 08AUG90               *
     F*                 E22296             DATE 19JUL90               *
     F*                 LN0877             DATE 18OCT90               *
     F*                 S01281             DATE 04JUL90               *
     F*                 BHF093             DATE 24MAY90               *
     F*                 BHF092             DATE 24MAY90               *
     F*                 LN0194             DATE 22MAY90               *
     F*                 LN0012             DATE 27/04/90              *
     F*                 E16612             DATE 06SEP89               *
     F*                 E18339             DATE 06/06/89              *
     F*                 E18546             DATE 06/06/89              *
     F*                 E16681             DATE 05/06/89              *
     F*                 E18547             DATE 05/06/89              *
     F*                 E16854             DATE 15/02/89              *
     F*                 S01161             DATE 18/08/88              *
     F*                 E12038             DATE 06/05/88              *
     F*                 S01117             DATE 17/03/89              *
     F*                 S01195             DATE 17/03/89              *
     F*                 S01194             DATE 17/03/89              *
     F*                 S01146             DATE 19/11/87              *
     F*                 E10433             DATE 18/05/87              *
0008 F*                 E10600             DATE 10/04/87              *
0008 F*                 E10604             DATE 10/04/87              *
0008 F*                 E10603             DATE 10/04/87              *
     F*                 E10262             DATE 16/01/87              *
0008 F*                 S01125             DATE 30/10/86              *
0008 F*                 E43356             DATE 08/05/86              *
0008 F*                 S01110             DATE 10/06/86              *
0008 F*                 S01091             DATE 23/05/86              *
0008 F*                                                               *
0013 F*---------------------------------------------------------------*
      *                                                               *
      *  220877 - GL0420 Statements produced do not include the       *
      *           IBAN even if CFT004 is switched on.                 *
      *         - Applied for MD052224.                               *
      *  CGL188 - COB Optimisation of GL0420                          *
      *           Used /Copys:  GL0420FFP2, GL0420FFP3, GL0420I017,   *
      *                         GL0420IIP4, GL0420IIP5, GL0420CP21,   *
      *                         GL0420CP26, GL0420CP49, GL0420C005,   *
      *                         GL0420C006, GL0420C081                *
      *           Added /Copys: GLH00874, GLH00875, GLH00893,         *
      *                         GLH00894                              *
      *  MD046248 - Finastra Rebranding                               *
      *  CGL184 - New Frequencies for Account Statements              *
      *  MD037536 - GLC43 components failed with ï¿½Record in file      *
      *             GL0420P4 truncated at end of lineï¿½.               *
      *             Review GL0420P4 definition and make it            *
      *             consistent with PRTF page size.                   *
      *  MD033999 - GLC43 decimal data error. Patterned fix after     *
      *             MD-19902 which added validation for starting date *
      *             to consider if previous month has 29 or 30.       *
      *  AR1014455 - Retail accounts not included on statement        *
      *              GL0420P2. Amended program to include retail      *
      *              accounts on GL0420P2 when CGL046 is Off and      *
      *              write them on separate file GL0420PR when CGL046 *
      *              is On. (Child: AR1014456)                        *
      *            - Applied for MD-24519                             *
      *  MD020563 - CFC006 issues                                     *
      *  AR1097176 - Accessing AOCOMR0 multiple times slows down      *
      *              the system                                       *
      *  AR1096328 - GLC43 encountered DBase error in Day 1 SG COB    *
      *  CFC006 - COB Restructure - Remove reports from COB           *
      *  CGL061A - Statements Task Split Processing                   *
      *  AR1004822 - Program GL0420 CBTASKSP dataarea now 10 long     *
      *  CRE073 - Interest Rate Rounding (Recompile)                  *
      *  CRE075 - Effective Date for Retail Accounts (Recompile)      *
      *  CLE064 - Enhancement of Lending Frequencies (Recompile)      *
      *  AR676213 - Incorrect definition of CLGLAI field (Recompile)  *
      *             (Child: AR676229)                                 *
      *  CER059 - German Feature Upgrade to Delhi                     *
      *  BUG22979A - Wrong extended narratives output in MT940        *
      *  CER047 - German Features LF037-00 Reporting §24c KWG         *
      *  BUG27725 - Statement of account requested but not generated  *
      *  BUG27359 - Reset flags after closing printer files           *
      *  BUG26704 - Remove FIN spool files                            *
      *  CGL061 - Multi-streaming GL Statements                       *
      *  246285 - Prevent array index error. Apply fix 207355.        *
      *  248797 - Validation of customer status introduced by CSD023  *
      *           should also consider CSD007.                        *
      *  243837 - Update YTDB correctly. Apply fix 220528.            *
      *  245223 - Ensure the hyphen is shown as a separator in the    *
      *           account details.                                    *
      *  CRE026 - Consumer Banking (Recompile)                        *
      *  BG12511A - Fix BG12511.                                      *
      *            CGL046 sets *IN20 in 1st cycle if output will be   *
      *            sent to GL0420PRE.                                 *
      *            *IN20 is reset on each read of APOST if RIND=0     *
      *            i.e. this is NOT a retail account                  *
      *            Hence file can be closed and then a read on APOST  *
      *            causes *IN20 to come on and pgm does an i/o oper'n *
      *            to a closed file trying to write a non retail a/c  *
      *            to the retail printer file.                        *
      *  BG12511 - I/O operation was applied to closed file           *
      *  239208 - Applied core fix 236789.                            *
      *  236789 - Fix CGL029 feature. The process to check if         *
      *           movement to report was incorrect.                   *
      *  239641 - As requested by the client, remove the '03' skip to *
      *           save 1 page of stationary every time 'END OF REPORT'*
      *           is printed.                                         *
      *  CGL046 - Separate printer File for Retail Accounts           *
      *  CSD031 - Enhanced Centralised Static Data (Recompile)        *
      *  236789 - Fix CGL029 feature. The process to check if         *
      *           movement to report was incorrect.                   *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CSW037A- Additional Field extended to 40 chars (recompile)   *
      *  CSD023 - Automatic Customer Account Closure                  *
      *  CSD025 - Customer De-Activation                              *
      *  CSW037 - Additional Field Data on MT300/MT320                *
      *  CSW036 - Dual SWIFT BIC held on Client Details               *
      *  CLE025 - Credit Lines (Recompile)                            *
      *  CGL029 - Increase Account Code to 10 digits                  *
      *  216937 - For group account replicated postings, include      *
      *           source account                                      *
      *  216006 - Include group account text in the statement     t   *
      *  173551 - Equivalent in EURO should not be shown if account   *
      *           is in EUR.                                          *
      *  177915 - Mgt/demand statements should be produced, if        *
      *           requested, whether or not the account has postings. *
     F*  176080 - Frequency E should use last day in month (128753).  *
      *  144366 - Program reads all rate postings for each statement  *
      *           if there are no movement postings. This causes the  *
      *           program to run a long time.                         *
      *  CAP035 - Account maintenance API.                            *
      *  CFT004 - Straight Through Processing Phase 2                 *
      *           International Bank Account Numbers (IBAN)           *
      *  169210 - Duplicate hooks renamed from GL0420C060, GL0420C061,*
      *           GL0420I017 to GL0420CABB, GL0420CABM, GL0420IABN    *
      *  CGL007 - Account Postings Enquiry                            *
      *  156327 - GL0420P4 is size limited to 100, fields should be   *
      *           written accordingly . EURO consolidated ccy code is *
      *           printed when euro equ amount balance is printed.    *
      *  CSD005 - Standing Data Account Narrative.  Add new field     *
      *           to SDACODPD.  Recompilation of programs.            *
     F*  154040 - Also check to see if the Account Posting Retention  *
     F*           Period field is zero (BKAPRP in SGELRPD) before     *
     F*           bypassing update of CPOSTDD. Pass BKAPRP as a       *
     F*           parameter when calling GL0421.Apply 131884 .        *
     F*  143155 - Problem with B/F balance in Euros being incorrect   *
     F*           on statements longer than one page in length.       *
     F*  CEU013 - EMU Account Posting Narrative, addition of balances *
     F*           in Euros and Original Currency and amount.          *
     F*  S01408 - Further balancing of Hooks between DBAR2 and R10.6  *
     F*           New/Repositioned Hooks include:                     *
     F*           GL0420F003                                          *
     F*           GL0420E001                                          *
     F*           GL0420I003 to GL0420I009                            *
     F*           GL0420C024 to GL0420C036                            *
     F*           GL0420CX25, GL0420CX29 to GL0420CX36                *
     F*           GL0420CY32 to GL0420CY34                            *
     F*           GL0420O015, GL0420O016                              *
     F*           GL0420O019, GL0420O020                              *
     F*           GL0420O023 to GL0420O063                            *
     F*           GL0420OX61, GL0420OY13, GL0420OY25, GL0420OY26      *
     F*           GL0420OY36, GL0420OY54, GL0420OY57, GL0420OY63      *
     F*  S01408 - Addition of Hooks to balance DBAR2 and R10.6 (Xnn)  *
     F*  S01408 - Addition of Core Hook Gl0420CP59                    *
     F*           Addition of Core Hook Gl0420CP58                    *
     F*           Addition of Core Hook Gl0420EEP2                    *
     F*  S01408 - Core hook GL0420CP57 added                          *
     F*           Core hook GL0420CP56 added                          *
     F*           Core hook GL0420CP55 added                          *
     F*           Core hook GL0420CP54 added                          *
     F*           Core hook GL0420CP53 added                          *
     F*           Core hook GL0420CP52 added                          *
     F*           Core hook GL0420CP51 added                          *
     F*           Core hook GL0420CP50 added                          *
     F*           Core hook GL0420CP49 added                          *
     F*           Core hook GL0420CP48 added                          *
     F*           Core hook GL0420CP47 added                          *
     F*           Core hook GL0420CP46 added                          *
     F*           Core hook GL0420CP45 added                          *
     F*           Core hook GL0420CP44 added                          *
     F*           Core hook GL0420IP13 added                          *
     F*           Core hook GL0420IP12 added                          *
     F*           Core hook GL0420IP11 added                          *
     F*           Core hook GL0420IP10 added                          *
     F*           Core hook GL0420OP27 added                          *
     F*           Core hook GL0420OP26 added                          *
     F*           Core hook GL0420FFP4 added                          *
     F*           Core hook GL0420EEP1 added                          *
     F*  S01408 - Core hook GL0420CP43 added                          *
     F*           Core hook GL0420CP42 added                          *
     F*           Core hook GL0420CP41 added                          *
     F*           Core hook GL0420CP40 added                          *
     F*           Core hook GL0420CP39 added                          *
     F*           Core hook GL0420CP38 added                          *
     F*           Core hook GL0420OP25 added                          *
     F*  S01408 - Core hook GL0420CP37 added                          *
     F*           Core hook GL0420CP36 added                          *
     F*           Core hook GL0420CP35 added                          *
     F*  S01408 - Core hook GL0420IIP9 added                          *
     F*  S01408 - Core hook GL0420CP34 added                          *
     F*  S01408 - Core hook GL0420IIP8 added                          *
     F*           Core hook GL0420CP33 added                          *
     F*  S01408 - Core hook GL0420IIP7 added                          *
     F*           Core hook GL0420CP32 added                          *
     F*           Core hook GL0420OP19 added                          *
     F*           Core hook GL0420OP20 added                          *
     F*           Core hook GL0420OP21 added                          *
     F*           Core hook GL0420OP22 added                          *
     F*           Core hook GL0420OP23 added                          *
     F*           Core hook GL0420OP24 added                          *
     F*  S01408 - Core hook GL0420CP30 added                          *
     F*           Core hook GL0420CP31 added                          *
     F*           Core hook GL0420FFP2 added                          *
     F*           Core hook GL0420FFP3 added                          *
     F*           Core hook GL0420IIP4 added                          *
     F*           Core hook GL0420IIP5 added                          *
     F*           Core hook GL0420IIP6 added                          *
     F*  096031 - Only check rate change records for postings today.  *
     F*  S01408 - Core hook GL0420CP29 added                          *
     F*           Core hook GL0420OP10 added                          *
     F*           Core hook GL0420OP11 added                          *
     F*           Core hook GL0420OP12 added                          *
     F*           Core hook GL0420OP13 added                          *
     F*           Core hook GL0420OP14 added                          *
     F*           Core hook GL0420OP15 added                          *
     F*           Core hook GL0420OP16 added                          *
     F*           Core hook GL0420OP17 added                          *
     F*           Core hook GL0420OP18 added                          *
     F*  S01408 - Core hook GL0420FFP1 added                          *
     F*           Core hook GL0420IIP2 added                          *
     F*           Core hook GL0420IIP3 added                          *
     F*           Core hook GL0420CP19 added                          *
     F*           Core hook GL0420CP20 added                          *
     F*           Core hook GL0420CP21 added                          *
     F*           Core hook GL0420CP22 added                          *
     F*           Core hook GL0420CP23 added                          *
     F*           Core hook GL0420CP24 added                          *
     F*           Core hook GL0420CP25 added                          *
     F*           Core hook GL0420CP26 added                          *
     F*           Core hook GL0420CP27 added                          *
     F*           Core hook GL0420CP28 added                          *
     F*           Core hook GL0420OO13 added                          *
     F*           Core hook GL0420OO14 added                          *
     F*  S01408 - Core hook GL0420OO12 added                          *
     F*  S01408 - Core hook GL0420CP18 added                          *
     F*  S01408 - Core hook GL0420CCP8 added                          *
     F*           Core hook GL0420CCP9 added                          *
     F*           Core hook GL0420CP10 added                          *
     F*           Core hook GL0420CP11 added                          *
     F*           Core hook GL0420CP12 added                          *
     F*           Core hook GL0420CP13 added                          *
     F*           Core hook GL0420CP14 added                          *
     F*           Core hook GL0420CP15 added                          *
     F*           Core hook GL0420CP16 added                          *
     F*           Core hook GL0420CP17 added                          *
     F*  S01520 - BLI Account Statements Changes.                     *
     F*  S01408 - Core hook GL0420CCP7 added                          *
     F*           Core hook GL0420OOP6 added                          *
     F*           Core hook GL0420OOP7 added                          *
     F*           Core hook GL0420OOP8 added                          *
     F*           Core hook GL0420OOP9 added                          *
     F*           Core hook GL0420OO10 added                          *
     F*           Core hook GL0420OO11 added                          *
     F*  S01408 - Core hook GL0420OOP2 added                          *
     F*           Core hook GL0420OOP3 added                          *
     F*           Core hook GL0420OOP4 added                          *
     F*           Core hook GL0420OOP5 added                          *
     F*  063631 - Brought Forward balance being printed several times *
     F*           on statement as if highlighted.                     *
     F*  S01408 - Core hook GL0420FFPG added                          *
     F*           Core hook GL0420IIPG added                          *
     F*           Core hook GL0420IIP1 added                          *
     F*           Core hook GL0420OOP1 added                          *
     F*           Core hook GL0420CCP1 added                          *
     F*           Core hook GL0420CCP2 added                          *
     F*           Core hook GL0420CCP3 added                          *
     F*           Core hook GL0420CCP4 added                          *
     F*           Core hook GL0420CCP5 added                          *
     F*           Core hook GL0420CCP6 added                          *
0008 F*  S01413 - Retail 3 Incorporation                              *
     F*  066562 - Field BLRSS renamed to BLRSST on SDTRADPD.          *
     F*           Amend and recompile program.                        *
     F*  S01408 - Core hook GL0420CADL added                          *
     F*           Core hook GL0420OP3 added                           *
     F*  055721 - Statements are not producing correctly.             *
     F*           S01377 corrupts statement carried forward           *
     F*           balances on PF/ACCNT and causes incorrect           *
     F*           printing of format 5 statements.                    *
     F*  056524 - C/Fwd Cleared Statement Balance YTDB, as amended by *
     F*           026793 makes this program unrestartable.            *
     F*           YTDB should only be updated here for Retail Accounts*
     F*           YTDB is updated for IN/EX Accounts by GL0800. Retail*
     F*           IN/EX accounts will never get a correct Statement   *
     F*  054770 - Array index error in Form 5 type processing.        *
     F*           Caused by lack of value date check on postings.     *
     F*  059213 - Ensure that items reaching valaue date appear in    *
     F*           carried forward cleared balance.                    *
     F*  046303 - /COPY source subr. ZFWDT amended to prevent array   *
     F*           error if no holiday record found - fixed by S01434. *
     F*           Program recompiled.                                 *
0008 F*  057487 - Error in S01377, accnt updated when no statement    *
0008 F*           produced.                                           *
     F*  044472 - Do not print last stmt date on C/F page             *
0008 F*  E32012 - Multiple statement address code 'C' doesn't have    *
0008 F*           daily balance. Indicator 52 needs to be set-off     *
     F*           again.                                              *
0008 F*  E38323 - Recompiled due to a change in copy source ZFWDT     *
     F*           subr.                                               *
0008 F*  E32657 - Next Statement Date is a Holiday for an Account     *
0008 F*           with frequency equal to 'B'. Field ZCCY is          *
0008 F*           Blank when it calls Subr. ZFREQB. To fix, move      *
0008 F*           Local CCY Code to ZCCY.                             *
     F*  S01377 - Switchable SAR. To prevent a statement being        *
     F*           printed for any accounts (both retail and           *
     F*           non-retail) which have no movements since the       *
     F*           last statement date regardless of wether            *
     F*           the brought forward balance is zero or not and      *
     F*           regardless of GL CoB parameter re Statements for    *
     F*           a/c's with zero balances and no movements.          *
     F*           (This is MOF21 plus a bit more).                    *
     F*           Prior to this SAR system checked for nil B/F        *
     F*           balance and non-retail account, CoB reporting       *
     F*           parm. These are not checked if this SAR is          *
     F*           installed.                                          *
     F*  E26793 - Use the 'Year to date balance' from ACCNTAB         *
     F*           not STMTAH as it does not get set up properly       *
     F*           in STMTAH.                                          *
     F*  E30556 - OVERPRINTING ON PAGE NUMBER IN GL0420P4             *
     F*  E24147 - Reset Statement page number to 1 for Accounts       *
     F*           where it was set to 999 in GL0810.                  *
     F*  E24683 - E18547 is incorrect for Management Statements       *
     F*  E26667 - Data structure SAVKEY had not had branch code       *
     F*           added to it for account numbers; also database      *
     F*           error processing failed to set U7 and U8 on.        *
     F*  E24003 - REINSTATE MATCH KEY FIELDS IF OVERWRITTEN           *
     F*  E23370 - FIX TO PREVENT STATEMENT BEING PRODUCED WITH        *
     F*           A HEADER & B/F BALANCE ONLY FOR A NON-RETAIL        *
     F*           A/C WITH ZERO BALANCE & POSTINGS WHERE THE          *
     F*           POSTINGS HAVE APPEARED ON A PREVIOUS STATEMENT.     *
     F*  E22281 - FIX TO PREVENT STATEMENT BEING PRODUCED WITH        *
     F*           A HEADER & B/F BALANCE ONLY FOR A NON-RETAIL        *
     F*           A/C WITH ZERO BALANCE & ZERO MOVEMENTS.             *
     F*  E22296 - FIX TO TURN OFF THE POSTING DATE MOVEMENT           *
     F*           INDICATOR (*IN49) FOR EACH NEW STATEMENT,           *
     F*           PREVENTING OVERWRITING OF B/F BALANCE.              *
0013 F*  LN0877 - CODE WAS SUCH THAT AOALTNR0 WAS ALWAYS USED TO      *
0013 F*           OBTAIN ALTERNATIVE NAMES AND ADDRESSES  -           *
0013 F*           WRONG VARIABLE USED.                                *
0013 F*  S01281 - ACCESS GLSTAT FOR STATEMENT CONTROL - DON'T         *
     F*           PRODUCE STATEMENT IF ZERO BALANCE/NO MOVEMENT       *
     F*           INDICATOR IS 'N'                                    *
     F*  BHF093 - SHOULD USE FIELD @WCNA1 AND NOT FIELD BCCNA1        *
     F*  BHF092 - USING KEY WITH BRCD IN FIRST POSITION INSTEAD OF    *
     F*           IN THE LAST POSITION.                               *
     F*  LN0194 - INCORRECT HANDLING OF DBASE ERROR 013 & DBPGM       *
     F*  LN0012 - INCORRECT HANDLING OF ALTERNATE NAME & ADDRESS      *
     F*  E16612 - IGNORE THE RATE CHANGE RECORDS WHEN THE             *
     F*           CORRESPONDING RETAIL ACCOUNT USES INTEREST          *
     F*           TYPE NOT EQUAL TO ZERO.                             *
     F*  E18339 - ERROR PROCESSING ERRORS                             *
     F*  E18546 - NON-RETAIL STATEMENTS ARE BEING PRINTED FOR         *
     F*           ACCOUNTS WITH ZERO BALANCE & NO MOVEMENTS.          *
     F*  E16681 - STATEMENT AUDIT HEADING WAS MISSING                 *
     F*  E18547 - ACCNT NOT UPDATED ON ACCOUNTS WITH STFQ ='A'        *
     F*           WHEN NSTD IS (ERRONEOUSLY) IN FUTURE.               *
0013 F*  E16854 - STATEMENTS DID NOT SHOW POSTINGS FOR ACCOUNTS       *
0013 F*           OPENED ON STATEMENT DATE. ALSO, FORWARD VALUE       *
0013 F*           DATE POSTINGS APPEAR TWICE. ALSO, ACCNT NOT         *
0013 F*           BEING UPDATED WITH  LSTP & C/F BALANCE.             *
0013 F*  S01161 - COB IMPROVEMENTS                                    *
     F*  E12038 - A COPY STATEMENT FOR A DELETED ALTERNATE            *
0013 F*           NAME & ADDRESS WAS BEING PRODUCED                   *
     F*  S01117 - MULTIBRANCHING                                      *
     F*  S01195 - HOLIDAY AMENDMENT                                   *
     F*  S01194 - NEW STANDING DATA                                   *
     F*  S01146 - MICROFICHE MODULE                                   *
     F*  E10433 - FILE CONTROL REPORT GOES TO OUTPUT QUEUE MPRINTSS   *
     F*           CAUSING THE STATIONERY ALIGNMENT TO GO WRONG.       *
     F*  E10600 - OVERFLOW WAS NOT WORKING, AND "CONTD" WAS NOT       *
0013 F*           BEING PRINTED                                       *
     F*  E10604 - STATEMENTS WERE NOT BEING PRINTED IF LEDGES = 0     *
0013 F*           AND NO MOVEMENTS.                                   *
     F*  E10603 - THE CARRIED FORWARD STATEMENT BALENCE WAS NOT       *
0013 F*           BEING UPDATED WHEN A STATEMENT WAS PRINTED          *
     F*  E10262 - CHANGE LAST ADDRESS INDICATOR AND REMOVE ZMDAY      *
     F*           FROM THE OUTPUT SPECS                               *
     F*  S01125 - CHANGE THE PRINTER FILE NAMES AND CHANGE THE        *
     F*           SKIP-TO ENTRIES ON THE OUTPUT SPECS.                *
0013 F*  E43356 - LOOP IN ENDPRT SR. IF STDY = '00' AND STFQ =        *
0013 F*           M T Q X OR Y.                                       *
     F*  E01110 - RATE CHANGE PRINT INDICATOR                         *
     F*  E01091 - ACCESS POSTINGS BY SETTL & READ INSTEAD OF          *
     F*           AS SECONDARY FILE & PRINT STATEMENTS                *
     F*           FOR MORE THAN ONE ADDRESS                           *
0013 F*                                                               *
0013 F*****************************************************************
     FTABTG30   IT   F   40        DISK                                         S01091
0017 F*TMTS***IP*AF      32 20AI     1 DISK                               S01161
      *                                                                   S01408
     F/COPY WNCPYSRC,GL0420FFP2                                           S01408
      *                                                                   S01408
0017 F***STMTS** IP AF      57 20AI     1 DISK                                         S01161 CGL029
     F***********STMTS   IP AF      67 20AI     1 DISK                                 CGL029 CGL061
     F**********STMTS     IP  AF   67    20AIDISK    KEYLOC(1)                        CGL061A CGL188
     F***GLSTAMPDIP AF      67 20AI     1 DISK                                        CGL061 CGL061A
      **********                       Driver file                                    CGL061 CGL061A
     F***GLSTAMPAUF  E                    DISK                      A    UC           CGL061 CGL061A
      **********                       Driver Audit file                              CGL061 CGL061A
     FGLSTPRL0  IP  AF   68    20AIDISK    KEYLOC(1)                                          CGL188
      *                                                                                       CGL188
     FGLSTBAL0  UF A E           K DISK    COMMIT                                             CGL188
     F                                     PREFIX(BA)                                         CGL188
     F/COPY WNCPYSRC,GL0420FFP3                                           S01408
      *                                                                   S01408
0018 F*STPO   IS AF     160  1AI   124 DISK                               S01091
0019 F*CCNT   UF  F     400 15AI     2 DISK                               S01117
     F*CCNT***UF**F*    400 18AI     2 DISK                         S01117CEU013
     F***ACCNT***UF  F     448 18AI     2 DISK                     CEU013 CFT004
     F***ACCNT***UF  F     485 18AI     2 DISK                     CFT004 CAP035
     F***ACCNT** UF  F     552 18AI     2 DISK                                         CAP035 CGL029
     FACCNT     UF   F  573    24AIDISK    KEYLOC(2)                                          CGL029
     F                                     COMMIT                                             CGL061
0020 F*LINT***IF* F     256  7AI     2 DISK                               S01194
0021 F*ABLE***IF* F      96 12AI     2 DISK                               S01194
0021 F*ABTB55*IF* F      96 12AI     2 DISK                   S01110  U1  S01194
     F*REIAC**IF**F*    128 15AI     2 DISK                         S01117E16612
     F***REIAC** IF  F     128 18AI     2 DISK                                         S01117 CGL029
     FREIAC     IF   F  218    24AIDISK    KEYLOC(2)                                          CGL029
     F/COPY WNCPYSRC,GL0420F005
0022 F*OSTOHH O   F     160            DISK                               S01091
     F*OSTOPD O   F     160            DISK                               S01091
     F*OSTORA O   F     160            DISK                               S01091
     F*OSTOZZ O   F     160            DISK                               S01091
     F*POSTZZ*UF* F     160            DISK                     S01091    S01161
     F*ODPOZZ*IF* F     160            DISK                     S01091    S01161
0023 F*PRINT  O   F     132     OF     PRINTER                            S01125
0024 F*PRINTS1O   F     132     OA     PRINTER                            S01125
0025 F*PRINTS2O   F     132     OB     PRINTER                            S01125
0026 F*PRINTS3O   F     132     OC     PRINTER                            S01125
0027 F*PRINTS4O   F     132     OD     PRINTER                            S01125
0028 F*PRINTS5O   F     132     OE     PRINTER                            S01125
0023 F*L0420P6O** F     132     OF     PRINTER                  S01125    S01117
0024 F*L0420P5O** F     132     OA     PRINTER                  S01125    S01117
0025 F*L0420P4O** F     132     OB     PRINTER                  S01125    S01117
0026 F*L0420P3O** F     132     OC     PRINTER                  S01125    S01117
0027 F*L0420P2O** F     132     OD     PRINTER                  S01125    S01117
0028 F*L0420P1O** F     132     OE     PRINTER                  S01125    S01117
     FGL0420AU  O    F  132        PRINTER INFDS(SPOOLU)                        S01117
     F                                     OFLIND(*INOV)
0023 FGL0420P6  O    F  132        PRINTER INFDS(SPOOL6)                        S01117
     F                                     OFLIND(*INOF)
     F                                     USROPN
     F/COPY WNCPYSRC,GL0420F006
0024 FGL0420P5  O    F  132        PRINTER INFDS(SPOOL5)                        S01117
     F                                     OFLIND(*INOA)
     F                                     USROPN
     F/COPY WNCPYSRC,GL0420F003
0025 F***GL0420P4  O    F  132        PRINTER INFDS(SPOOL4)                          S01117 MD037536
0025 FGL0420P4  O    F  100        PRINTER INFDS(SPOOL4)                                    MD037536
     F                                     OFLIND(*INOB)
     F                                     USROPN
     F/COPY WNCPYSRC,GL0420F001
0026 FGL0420P3  O    F  132        PRINTER INFDS(SPOOL3)                        S01117
     F                                     OFLIND(*INOC)
     F                                     USROPN
     F/COPY WNCPYSRC,GL0420F002
0027 FGL0420P2  O    F  132        PRINTER INFDS(SPOOL2)                        S01117
     F                                     OFLIND(*INOD)
     F                                     USROPN
     FGL0420PR  O    F  132        PRINTER INFDS(SPOOL7)                        CGL046
     F                                     OFLIND(*INOG)
     F                                     USROPN
      *                                                                   S01408
     F/COPY WNCPYSRC,GL0420FFP4                                           S01408
      *                                                                   S01408
0028 FGL0420P1  O    F  132        PRINTER INFDS(SPOOL1)                        S01117
     F                                     OFLIND(*INOE)
     F                                     USROPN
0018 F*POST***UF* F     160 15AI     2 DISK                     S01091    S01161
0018 F*POST***IF* F     160 15AI     2 DISK                     S01161    S01117
     F*                                                                   S01408
     F/COPY WNCPYSRC,GL0420FFP1                                           S01408
     F*                                                                   S01408
0018 F*POST   IF  F     160 18AI     2 DISK                         S01117CEU013
0018 F***APOST***IF  F     329 18AI     2 DISK                     CEU013 CGL007
0018 F***APOST** IF  F     331 18AI     2 DISK                                         CGL007 CGL029
     FAPOST     IF   F  620    24AIDISK    KEYLOC(2)                                          CGL029
     F/COPY WNCPYSRC,GL0420F004
     F*                                                                   S01408
0018 FGLAPSTPD  IF   E           K DISK                                         CEU013
     FGLAPSGL0  IF   E           K DISK                                         216937
     FSDCMANL0  IF   E           K DISK                                         216006
     FREGAHLJ2  IF   E           K DISK                                         216006
     F** Core hook for externalisation.                                   S01408
     F/COPY WNCPYSRC,GL0420FFPG                                           S01408
     F*                                                                   S01408
     F***********                                   KINFDS INFDSS01091    S01161
0033 F*
0034 F* 01            STMTS - STATEMENTS EXTRACT RECORD
0034 F* 02            AT LEAST ONE POSTING FOR STATEMENT                  S01091
0036 F* 03            ACCNT - ACCOUNT MASTER DETAIL RECORD
0037 F**04************SSTPO - RATE CHANGE POSTINGS                        S01091
0037 F* 04            APOST - RATE CHANGE POSTINGS                        S01091
     F**05************TABTB55 DTL RECORD                           S01110 S01194
0037 F**06************SSTPO - POSTINGS RECORD
0037 F**08************SSTPO - TRAILER
0037 F* 06            APOST - POSTINGS RECORD                             S01091
     F*       07      LAST ADDRESS                                        E10262
0037 F**08************APOST - TRAILER                           S01091    S01161
0037 F* 08            WORK INDICATOR                                      E16612
     F* 09            CHAIN FAILED TO REIAC FILE                          E16612
     F********10******PROCESSED END PERIOD & APPEARED IN STMNT CLRD BAL BIS01161
     F*       10      PRINT BALANCES IN EUROS                             CEU013
     F*       11      CATCHALL
     F*       12      PRINT RATE CHANGE INDICATOR IS 'N'                  S01110
0038 F*       13      STATEMENTS TRAILER
0039 F***     14      POSTING TRAILER                                     S01091
     F*       15      NO MORE POSTINGS FOR ACCOUNT
0040 F*       16      DATABASE ERROR-NO TRAILER ON STMTS FILE
0042 F*    17         CARRIED FORWARD CLEARED BALANCE IS DEBIT.
0043 F*    18         PRINT HEADINGS IN TOTAL TIME FOR FORMAT 5.
0044 F*    19         PRINT LINE FOR CLEARINGS AFTER LAST POST.
0045 F*    20         RETAIL INDICATOR - '0'
0046 F*    21                          - '1'
0047 F*    22         A POSTING AMOUNT IS POSITIVE
0048 F*    23         A POSTING AMOUNT IS NEGATIVE
0049 F*****24*********THE CARRIED FORWARD BALANCE IS POSITIVE             S01161
0050 F*    24         CHAIN GLAPSTPD                                      CEU013
0050 F*    25         CHEQUE NO. ZERO
0051 F*       26      LEDGER BALANCE ZERO
0052 F*       27       BLANK RETAIL NO.
0053 F*       28      CLEARED BALANCE BROUGHT FORWARD IS DEBIT.
     F*       29      WORK INDICATOR                                      E16612
0054 F*       30      FIRST CYCLE INDICATOR
0055 F*       31      LOKUP FOR EQUAL ENTRY
0056 F*       32      CLEARED BALANCE AFTER CLEARING ENTRY IS DEBIT.
0057 F********33*     NO STATEMENT RECORD                                 S01161
0057 F*       33      NO STATEMENT RECORD                                 E18546
0058 F*       34      MANAGEMENT STATEMENT                     DATE
0059 F*       35      DEMAND STATEMENT
0060 F*       36      PRINT ADDRESS
0061 F*       37      CLEARED BALANCE IS DEBIT.
0062 F********38******PROCESSED*END*OF*PERIOD*************************    056524
0062 F*       38      RETAIL ACCOUNT                                      056524
0063 F*       39      ALREADY APPEARED ON STATEMENT
0064 F*
0065 F*       40      PRINT FORMAT - '5'
0066 F*       41      PRINT FORMAT - '1'
0067 F*       42                   - '2'
0068 F*       43                   - '3'
0069 F*       44                   - '4'
0070 F*       45      LAST  LINE OF NEW PAGE OF STATEMENT
0071 F*       46      FIRST PAGE OF STATEMENT
0072 F*       47      THE PRESENT POSTING BALANCE IS POSITIVE
0073 F*       48      FIRST PAGE INDICATOR
0074 F*       49      INDICATES MOVEMENT ON THIS POSTING DATE
0075 F*
0076 F*       50      PRINT INITIAL DETAILS
0077 F*       51      PRINT DETAIL RECORDS
0078 F*       52      PRINT FINAL DETAILS
0079 F*       53      WRITE POSTING TO POSTO FILE
0080 F*       54      EXCEPTION TO UPDATE ACCOUNT
0081 F*       55      STATEMENT FREQUENCY IS 'A'
0082 F*       56      POSTING DATE GREATER THAN NEXT STATEMENT DATE
0083 F*       57      POSTING DATE GREATER THAN RUN DATE
0084 F********58      ACCOUNT HAS ANOTHER POSTING                         S01091
0086 F*       59      NEXT STATMT DATE LESS THAN NEXT WORKING DAY
0087 F*               OR ELSE THIS IS A DEMAND STATMT
0087 F*               OR STFQ = 'A' AND NOT A MANAGEMENT STATEMENT  E18547E24683
0088 F*
0089 F*       60      INITIAL PRINTING FORMAT - 1
0090 F*       61      DETAIL PRINTING FORMAT - 1
0091 F*       62      INITIAL PRINTING FORMAT - 2
0092 F*       63      DETAIL PRINTING FORMAT - 2
0093 F*       64      INITIAL PRINTING FORMAT - 3
0094 F*       65      DETAIL PRINTING FORMAT - 3
0095 F*       66      INITIAL PRINTING FORMAT - 4
0096 F*       67      DETAIL PRINTING FORMAT - 4
0097 F*       68      UPDATE THE NEXT STATMNT DATE
0098 F*       69      POSTING DATE NE VALUE DATE
0099 F*
0100 F*       70      CURRENCY DECIMAL - 0
0101 F*       71                       - 1
0102 F*       72                       - 2
0103 F*       73                       - 3
0104 F*       73                       - 3
0105 F*       74      ITEMS HAVE BEEN CLEARED SINCE LAST STATEMENT.
0106 F*       75      PRINT ITEMS HAVE BEEN CLEARED SINCE LAST STATEMENT.
0107 F********76******CHAIN FAILED TO - TABLE FILE                        S01194
0108 F********77******                - ACCOUNT FILE                      S01194
     F*       76      ERROR IN OBTAINING STANDING DATA DETAILS            S01194
     F*       77      CHAIN FAILED TO - ACCOUNT FILE                      S01194
0109 F********78******                - CLINT FILE                        LN0012
0109 F********79******A/C IS CLOSED                                       S01161
     F*       78      PRINT ORIGINAL CURRENCY AND AMOUNT                  CEU013
0111 F*
0112 F*
0113 F*       80      MANAGEMENT STATEMENT  - INITIAL 1
0114 F*       81                            - DETAIL 1
     F********82******DATABASE ERROR-NO TRAILER ON SSTPO FILE             S01091
     F*       82      DATABASE ERROR-NO TRAILER ON APOST FILE             S01091
     F*       84      PRTF GL0420Pn OPEN FOR OUTPUT                       S01117
0115 F********84-86***OUT OF BALANCE                                      S01161
0116 F*       87      INITIAL PRINTING FORMAT - 5.
0117 F*       88      WORK INDICATOR FOR FORMAT 5 PROCESSING.
0118 F*       89      DETAIL PRINTING FORMAT - 5.
0118 F*       U7      DATABASE ERROR
0118 F*       U8      FILES OUT OF BALANCE
0119 F*
0120 F*****   M3      MATCHING RECORD ON ACCOUNT TYPE                     S01091
0121 F*****   M2      MATCHING RECORD ON BRANCH CODE                      S01091
0122 F*****   M1      MATCHING RECORD ACCOUNT FIELDS                      S01091
0123 F*       L1      LEVEL BREAK ON ACCOUNT TYPE
0123 F*       L4      LEVEL BREAK ON BRANCH CODE                          S01117
     F*       KA      EURO CURRENCY DECIMAL - 0                           CEU013
     F*       KB                            - 1                           CEU013
     F*       KC                            - 2                           CEU013
     F*       KD                            - 3                           CEU013
     F*       KE      ORIGINAL CURRENCY DECIMAL - 0                       CEU013
     F*       KF                                - 1                       CEU013
     F*       KG                                - 2                       CEU013
     F*       KH                                - 3                       CEU013
     F*       KL      Print ERPT2                                                            BG12511
0124 F*
      *                                                                   S01408
     D/COPY WNCPYSRC,GL0420EEP1                                           S01408
      *                                                                   S01408
0125 D TYPE            S              1    DIM(5) CTDATA PERRCD(5)              STATEMENT TYPES
0126 D***********         FORM        5  1 0             STATEMENT FORMATSS01194
0126 D FORM            S              1    DIM(5)                               STATEMENT FORMATSS01
0127 D***********         HCCY       25  3               HOLIDAY CCYS     S01195
0128 D***********         ZHC        50  3               ZFREQ SR.ARRAY   S01195
0129 D ZFMD            S              2    DIM(12) CTDATA PERRCD(12)            ZFREQ SR.ARRAY
0130 D ZYDY            S              4  0 DIM(4) CTDATA PERRCD(4)              ZDATE1/2 SR.ARRAY
0131 D ZMDY            S              3  0 DIM(13) CTDATA PERRCD(13)            ZDATE1/2 SR.ARRAY
0132 D ZMNM            S              3    DIM(12) CTDATA PERRCD(12)            ZDATE2 SR. ARRAY
     D/COPY WNCPYSRC,GL0420E002
0133 D VCAR            S             15  0 DIM(60)                              CLBAL CR. ARRAY
0134 D VDAR            S             15  0 DIM(60)                              CLBAL DR. ARRAY
0134 D***********         B           5  1               BINARY CONV ARRAYS01161
     D ARAD            S              1    DIM(10)                              ADDRESS REFERENCES01
     D CY              S              3    DIM(200) FROMFILE(TABTG30) PERRCD(1) CCY/CCY DETAILS
     D CYD             S             37    DIM(200) ALT(CY)
     D @PAGEN          S              5  0 INZ(0)                                             CGL188
     D*  DATA STRUCTURE FOR COMPILATION  - COPYRIGHT INSERTION            S03220
     D CPYR@#          DS                                                       S03220
     D  CPY@                   1     80                                         S03220
     D                                     DIM(1) CTDATA PERRCD(1)
0356 D**
     D***LOCAL DATA AREA
     D LDA           EUDS           256    EXTNAME(LDA)                                       CGL061
      *                                                                                       CGL061
     D**********LDA        UDS                 256                                            CGL061
     D***********                           134 138 DBFILE                S01194
     D***********                           139 167 DBKEY                 S01194
     D***********                           168 175 DBPGM                 S01194
     D***********                           176 1770DBASE                 S01194
     D***********                           134 141 DBFILE                             S01194 CGL061
     D***********                           142 170 DBKEY                              S01194 CGL061
     D***********                           171 180 DBPGM                              S01194 CGL061
     D***********                           181 1830DBASE                              S01194 CGL061
     D**   MICROFICHE FREQ & SORT FIELD                                   S01146
     D                 DS                                                       S01146
     D  FICHE                  1     16                                         S01146
     D  MFFQ                   1      1                                         S01146
     D  FICHEK                 2     16                                         S01146
     D**   GLAPSTGA fields                                                216937
     D                 DS                                                       216937
     D**********                              1  18 SRCGL                              216937 CGL029
     D  SRCGL                  1     24                                                       CGL029
     D  AGSBRC                 1      3                                         216937
     D**********                              4   90AGSCUS                             216937 CSD027
     D  AGSCUS                 4      9                                                       CSD027
     D  AGSCCY                10     12                                         216937
     D**********                             13  160AGSACD                             216937 CGL029
     D**********                             17  180AGSASN                             216937 CGL029
     D**********                             19  280AGSRNO                             216937 CGL029
     D**********                             19  28 SRCRET                             216937 CGL029
     D  AGSACD                13     22  0                                                    CGL029
     D  AGSASN                23     24  0                                                    CGL029
     D  AGSRNO                25     34  0                                                    CGL029
     D  SRCRET                25     34                                                       CGL029
     D                 DS                                                       216006
     D  CMTXTG                 1    200                                         216006
     D  WCMTX1                 1     65                                         216006
     D  WCMTX2                66    130                                         216006
     D  WCMTX3               131    195                                         216006
     D  WCMTX4               196    260                                         216006
     D**
     D*NFDS****** DS                                            S01091    S01161
     D***********                         B 156 1590BIN         S01091    S01161
     D***********                           156 156 BY4         S01091    S01161
     D***********                           157 157 BY3         S01091    S01161
     D***********                           158 158 BY2         S01091    S01161
     D***********                           159 159 BY1         S01091    S01161
     D*****CURRENCY*DETAILS*FROM*TABTG10**                          S01091S01194
     D*YDDS****** DS                                                S01091S01194
     D***********                             1   10CDP             S01091S01194
     D***********                         P   2   88SPOT            S01091S01194
     D***********                             9   90MDIN            S01091S01194
     D***********                         P  10  168ERLC            S01091S01194
     D***********                            17  170TNOT            S01091S01194
     D***********                            18  31 CCNM            S01091S01194
     D***********                            32  35 TEAC            S01091S01194
     D***********                            36  370SSNO            S01091S01194
     D CYDDS           DS            37                                         S01194
     D  CDP                    1      1  0                                      S01194
     D  CCNM                  18     31                                         S01194
     D SAVKEY          DS                                                       E24003
     D***********                             1   60CNUM            E24003E26667
     D***********                             7   9 CCY             E24003E26667
     D***********                            10  130ACOD            E24003E26667
     D***********                            14  150ACSQ            E24003E26667
     D  BRCA                   1      3                                         E26667
     D**********                              4   90CNUM                               E26667 CSD027
     D  CNUM                   4      9                                                       CSD027
     D  CCY                   10     12                                         E26667
     D**********                             13  160ACOD                               E26667 CGL029
     D**********                             17  180ACSQ                               E26667 CGL029
     D  ACOD                  13     22  0                                                    CGL029
     D  ACSQ                  23     24  0                                                    CGL029
     D/COPY WNCPYSRC,GL0420I017
     D**                                                                  S01117
     D**   FILE INFORMATION DATA STRUCTURE                                S01117
     D**                                                                  S01117
     D SPOOL1          DS                                                       S01117
     D  SFILE1                83     90                                         S01117
     D  SFNUM1               123    124B 0                                      S01117
     D  SWRIT1               243    246B 0                                      S01117
     D**                                                                  S01117
     D SPOOL2          DS                                                       S01117
     D  SFILE2                83     90                                         S01117
     D  SFNUM2               123    124B 0                                      S01117
     D  SWRIT2               243    246B 0                                      S01117
     D**                                                                  S01117
     D SPOOL7          DS                                                       CGL046
     D  SFILE7                83     90                                         CGL046
     D  SFNUM7               123    124B 0                                      CGL046
     D  SWRIT7               243    246B 0                                      CGL046
     D SPOOL3          DS                                                       S01117
     D  SFILE3                83     90                                         S01117
     D  SFNUM3               123    124B 0                                      S01117
     D  SWRIT3               243    246B 0                                      S01117
     D**                                                                  S01117
     D SPOOL4          DS                                                       S01117
     D  SFILE4                83     90                                         S01117
     D  SFNUM4               123    124B 0                                      S01117
     D  SWRIT4               243    246B 0                                      S01117
     D**                                                                  S01117
     D SPOOL5          DS                                                       S01117
     D  SFILE5                83     90                                         S01117
     D  SFNUM5               123    124B 0                                      S01117
     D  SWRIT5               243    246B 0                                      S01117
     D**                                                                  S01117
     D SPOOL6          DS                                                       S01117
     D  SFILE6                83     90                                         S01117
     D  SFNUM6               123    124B 0                                      S01117
     D  SWRIT6               243    246B 0                                      S01117
     D*
     D** Core hook for externalisation.                                   S01408
     D/COPY WNCPYSRC,GL0420IIPG                                           S01408
     D*
     D**                                                                  S01117
     D SPOOLU          DS                                                       S01117
     D  SFILEU                83     90                                         S01117
     D  SFNUMU               123    124B 0                                      S01117
     D**                                                                  S01520
     D WKEYDS          DS                                                       S01520
     D  WBRCA                  1      3                                         S01520
     D  WCNUM                  4      9                                         S01520
     D  WCCY                  10     12                                         S01520
     D**********                             13  16 WACOD                              S01520 CGL029
     D**********                             17  18 WACSQ                              S01520 CGL029
     D**********                             19  23 WRUND                              S01520 CGL029
     D  WACOD                 13     22                                                       CGL029
     D  WACSQ                 23     24                                                       CGL029
     D  WRUND                 25     29                                                       CGL029
     D*                                                                   S01117
     D** DEFINE BLANK FIELDS FOR USE WITH SWRIT1 - SWRIT5                 S01117
     D*                                                                   S01117
     D @BIN1           DS                                                       S01117
     D  @BBIN1                 1      4B 0                                      S01117
     D*                                                                   S01117
     D @BIN2           DS                                                       S01117
     D  @BBIN2                 1      4B 0                                      S01117
     D*                                                                   S01117
     D @BIN3           DS                                                       S01117
     D  @BBIN3                 1      4B 0                                      S01117
     D*                                                                   S01117
     D @BIN4           DS                                                       S01117
     D  @BBIN4                 1      4B 0                                      S01117
     D*                                                                   S01117
     D @BIN5           DS                                                       S01117
     D  @BBIN5                 1      4B 0                                      S01117
     D*                                                                   S01117
     D @BIN6           DS                                                       S01117
     D  @BBIN6                 1      4B 0                                      S01117
     D*                                                                   S01117
     D W#ORAC          C                   CONST('ORIGINATING ACCOUNT:')        216937
     D*
     D** Core hook for externalisation.                                   S01408
     D/COPY WNCPYSRC,GL0420IIP1                                           S01408
     D*
     D DSFDY         E DS                  EXTNAME(DSFDY)                       S01194
     D**  ACCESS PGM PARAMETER DS                                         S01194
     D*                                                                   S01194
     D DSSDY         E DS                  EXTNAME(DSSDY)                                    CGL061A
     D**  ACCESS PGM PARAMETER DS                                                            CGL061A
     D*                                                                                      CGL061A
     D DSLDY         E DS                  EXTNAME(DSLDY)                       CSD023
      ** Third DS for access programs, very long data structure           CSD023
      *                                                                   S01408
      ** Commitment control size                                                              CGL061
     D***CBTASK    E DSCBTASKSP                                                       CGL061 CGL061A
     D/COPY WNCPYSRC,GL0420IP12                                           S01408
      *                                                                   S01408
     D*COPY*ZSRSRC,ZHOLDS*********************************************                S01195 CGL061A
     D/COPY ZSRSRC,ZHOLILE                                                                   CGL061A
      *                                                                   S01408
     D/COPY WNCPYSRC,GL0420IP13                                           S01408
      *                                                                   S01408
     D SDALTN        E DS                  EXTNAME(SDALTNPD)                    S01194
     D*                                                                   S01194
     D**   ALTERNATIVE NAMES AND ADDRESSES                                S01194
     D*                                                                   S01194
     D SDBANK        E DS                  EXTNAME(SDBANKPD)                    S01194
     D**   BANK DETAILS                                                   S01194
     D  BJE2TX       E                     EXTFLD(BJSLCD)                       S01117
     D*                                                                   S01194
     D SDBRCH        E DS                  EXTNAME(SDBRCHPD)                    S01194
     D*                                                                   S01194
     D**   BRANCH CODE                                                    S01194
     D*                                                                   S01194
     D SDGELR        E DS                  EXTNAME(SDGELRPD)                    S01194
     D*                                                                   S01194
     D**   GENERAL LEDGER                                                 S01194
     D*                                                                   S01194
     D SDRETL        E DS                  EXTNAME(SDRETLPD)                    S01194
     D  QQACD1       E                     EXTFLD(QQACCD)                                     CGL029
     D*                                                                   S01377
     D**   SARS INSTALLED FILE                                            S01377
     D*                                                                   S01377
     D SCSARD        E DS                  EXTNAME(SCSARDPD)                    S01377
     D*                                                                   S01194
     D**   RETAIL DETAILS                                                 S01194
     D*                                                                   S01194
     D SDTRAD        E DS                  EXTNAME(SDTRADPD)                    S01194
     D  QQACD2       E                     EXTFLD(QQACCD)                                     CGL029
     D*                                                                   S01194
     D**   TRADING DATA                                                   S01194
     D*                                                                   S01194
     D SDCUST        E DS                  EXTNAME(SDCUSTPD)                    LN0012
     D**   CUSTOMER DETAILS                                               LN0012
     D  DFACQQ       E                     EXTFLD(QQDFAC)                                     CGL029
     D*                                                                   LN0012
     D SDCURR        E DS                  EXTNAME(SDCURRPD)                    CEU013
     D**   CUSTOMER DETAILS                                               CEU013
     D*                                                                   CEU013
     D GLSTAT          DS           256                                         S01281
     D*                                                                   S01281
     D* External DTAARA for Zero Balance/No Movement Indicator            S01281
     D*                                                                   S01281
     D  MOVI                  69     69                                         S01281
     D RUNDT           DS                                                       S01194
     D*                                                                   S01194
     D* External DTAARA for run-date                                      S01194
     D*                                                                   S01194
     D  RUNA                   1      7                                         S01194
     D/COPY WNCPYSRC,GL0420I018
     D  RUND                   8     10P 0                                      S01194
     D  SSF                   11     11                                         S01194
     D  DATF                  12     12                                         S01194
     D  MBIN                  13     13                                         S01194
      *                                                                                       CFC006
     D*CFC006***       S              1A                                          AR1097176 MD020563
     D SUPFL3          S              1A                                                      CFC006
     D SUPFL5          S              1A                                                      CFC006
     D PNAME           S             10A                                                      CFC006
     D PCSEQ           S              5A                                                      CFC006
     D PSCTN           S             50A                                                      CFC006
     D SECTN1          C                   CONST('GL0420001')                                 CFC006
     D SECTN2          C                   CONST('GL0420002')                                 CFC006
      *                                                                                       CGL188
      ** Parameters for AOSVALR0                                                              CGL188
     D PRtCd           S              7A   INZ                                                CGL188
     D POPT            S             20A   INZ DIM( 10 )                                      CGL188
     D PVAL            S            200A   INZ DIM( 10 )                                      CGL188
      *                                                                                       CGL188
     I/COPY WNCPYSRC,GL0420E001                                           S01408
     I*COPY*ZSRSRC,ZHOLE***********************************************               S01195 CGL061A
     I/COPY ZSRSRC,ZHOLELE                                                                   CGL061A
      *                                                                   S01408
     I/COPY WNCPYSRC,GL0420EEP2                                           S01408
      *                                                                   S01408
0141 I*
0142 I**
0143 I*    ACCOUNT I.D.S EXTRACT DETAIL RECORD
0144 I**
     I*                                                                   S01408
     I/COPY WNCPYSRC,GL0420IIP5                                           S01408
     I*                                                                   S01408
0145 I**************STMTS   NS  01   1 CD                                                     CGL061
0145 I**********STMTS     NS  01    1 CD                                              CGL061A CGL188
     I***GLSTAMPDNS  01   1 CD                                                        CGL061 CGL061A
     I*                                                                   S01408
     I/COPY WNCPYSRC,GL0420IIP6                                           S01408
     I*                                                                   S01408
0146 I**********                        1    1  RECI                                          CGL188
0152 I**********                        2    2  ATYP                                          CGL188
0153 I****                                    3   50BRCD  L4              S01117
0153 I**********                        3    5  BRCA          L4                S01117        CGL188
0147 I**********                              6  110CNUM  L3                                  CSD027
0147 I**********                        6   11  CNUM          L3                       CSD027 CGL188
0148 I**********                       12   14  CCY           L2                              CGL188
0149 I**********                             15  180ACOD                                      CGL029
     I**********                       15   18 0ACODQQ                                 CGL029 CGL188
0150 I**********                       19   20 0ACSQ                                          CGL188
0151 I*****************                       6  20 MATCH                 S01117
0151 I**********                              3  20 MATCH                              S01117 CGL029
0151 I**********                              6  20 MATCHS                             S01117 CGL029
     I**********                        3   14  MTCH                                   CGL029 CGL188
     I**********                        6   14  MTCHS                                  CGL029 CGL188
     I/COPY WNCPYSRC,GL0420I020
0154 I************************************P  30  320DUMMY L1              S01117
0154 I**********                       30   32  DUMMY         L1                       S01117 CGL188
     I**********                   P   33   35 0LSTD                                   S01161 CGL188
     I**********                   P   36   38 0NSTD                                   S01161 CGL188
     I**********                   P   39   40 0LSTP                                   S01161 CGL188
     I**                                  P  41  480CFSB                  S01161
     I**********                   P   41   48 0CFSB                    26             E18546 CGL188
     I**********                   P   49   56 0YTDB                                   S01161 CGL188
     I**********                       57   57  GLBT                                   S01161 CGL188
     I**********                       58   67 0ACOD                                   CGL029 CGL188
     I*                                                                   S01408
     I/COPY WNCPYSRC,GL0420IIP4                                           S01408
     IGLSTPRL0  NS  01    2 CD                                                                CGL188
     I                                  1    1  RPTY                                          CGL188
     I                                  2    2  RECI                                          CGL188
     I                                  3    3  ATYP                                          CGL188
     I                                  4    6  BRCA          L4                              CGL188
     I                                  7   12  CNUM          L3                              CGL188
     I                                 13   15  CCY           L2                              CGL188
     I                                 16   19 0ACODQQ                                        CGL188
     I                                 20   21 0ACSQ                                          CGL188
     I                                  4   15  MTCH                                          CGL188
     I                                  7   15  MTCHS                                         CGL188
     I                                 31   33  DUMMY         L1                              CGL188
     I                             P   34   36 0LSTD                                          CGL188
     I                             P   37   39 0NSTD                                          CGL188
     I                             P   40   41 0LSTP                                          CGL188
     I                             P   42   49 0CFSB                    26                    CGL188
     I                             P   50   57 0YTDB                                          CGL188
     I                                 58   58  GLBT                                          CGL188
     I                                 59   68 0ACOD                                          CGL188
     I*                                                                   S01408
0155 I********NS  13   1 CT                                                                   CGL061
0156 I************                            2   60STMSIZ                                    CGL061
0157 I*
0158 I**
0159 I*    CATCHALL FOR DELETED RECORDS
0160 I**
0161 I          NS  11
0162 I******
0163 I**
     IREIAC     NS                                                              E16612
     I                                 17   18  DICT                            E16612
     I                                 41   42  CICT                            E16612
     I**                                                                  E16612
0164 I*    ACCOUNT POSTING
0165 I**
0166 I*STPO***NS**06***1*CP                                               S01091
     I*                                       2  16 MATCH   M1            S01091
     I*                                   P  33  350PSTD  L1              S01091
     I*                                     103 1050BRCD    M2            S01091
     I*                                     124 124 ATYP    M3            S01091
      *                                                                   S01408
     I/COPY WNCPYSRC,GL0420IP10                                           S01408
      *                                                                   S01408
0166 IAPOST     NS  06    1 CP                                                  S01091
      *                                                                   S01408
     I/COPY WNCPYSRC,GL0420IP11                                           S01408
      *                                                                   S01408
0167 I                                  1    1  RECI
     I/COPY WNCPYSRC,GL0420I005                                           S01408
     I                                  2   16  APKEY                           E23370
0168 I**********                              2   70CNUM                                      CSD027
0168 I                                  2    7  CNUM                                          CSD027
0169 I                                  8   10  CCY
0170 I**********                             11  140ACOD                                      CGL029
     I                                 11   14 0ACODQQ                                        CGL029
0171 I                                 15   16 0ACSQ
0173 I                             P   33   35 0PSTD
0174 I                             P   36   38 0VALD
     I/COPY WNCPYSRC,GL0420I010
0175 I                                 39   43  TRAT
     I/COPY WNCPYSRC,GL0420I011
0176 I                                 44   73  PNAR
0177 I                             P   74   80 0PSTA
0178 I                                 81   81 0DRCR                222223
0179 I**********                             82  870ASOC                                      CSD027
0179 I                                 82   87  ASOC                                          CSD027
     I/COPY WNCPYSRC,GL0420I014
0180 I                                 88   95 0CHQN                    25
     I/COPY WNCPYSRC,GL0420I016
0181 I                                 96  102  SPOS
     I/COPY WNCPYSRC,GL0420I015
0182 I****                                  103 1050BRCD                  S01117
0182 I                                103  105  BRCA                            S01117
     I/COPY WNCPYSRC,GL0420I001
0183 I                                106  106 0RIND                212120
     I/COPY WNCPYSRC,GL0420I002
0184 I**                                    124 124 ATYP                  E18546
0184 I                                124  124  ATYPA                           E18546
0185 I                                128  128  CUOR
     I/COPY WNCPYSRC,GL0420I003
0186 I**********                              1 160 LOTP                                      CGL029
     I                                  1  170  LOTP                                          CGL029
     I*                                                                   S01408
     I/COPY WNCPYSRC,GL0420IIP2                                           S01408
     I                                317  319  XRFI                            CEU013
     I                                320  329 0XRFN                            CEU013
     I                                590  599 0ACOD                                          CGL029
     I*                                                                   S01408
0187 I**
0188 I*    RATE CHANGE POSTING
0189 I**
0190 I          NS  04    1 CR
     I/COPY WNCPYSRC,GL0420I006                                           S01408
0191 I                                  1    1  RECI
     I/COPY WNCPYSRC,GL0420I007                                           S01408
     I                                  2   16  APKEY                           E23370
0192 I**********                              2   70CNUM                                      CSD027
0192 I                                  2    7  CNUM                                          CSD027
0193 I                                  8   10  CCY
0194 I**********                             11  140ACOD                                      CGL029
     I                                 11   14 0ACODQQ                                        CGL029
0195 I                                 15   16 0ACSQ
     I/COPY WNCPYSRC,GL0420I008                                           S01408
0199 I                             P   33   35 0PSTD
0200 I                             P   36   38 0VALD
     I/COPY WNCPYSRC,GL0420I012
0201 I                                 39   43  TRAT
     I/COPY WNCPYSRC,GL0420I013
0202 I                                 44   73  PNAR
0203 I                                 81   81 0DRCR                222223
0204 I                                 96  102  SPOS
0205 I****                                  103 1050BRCD                  S01117
0205 I                                103  105  BRCA                            S01117
     I*COP**WN*PYSRC*GL0420I017****************************************** 169210
     I/COPY WNCPYSRC,GL0420IABN                                           169210
0206 I**                                    124 124 ATYP                  E18546
0184 I                                124  124  ATYPA                           E18546
0207 I                                128  128  CUOR
0208 I                             P  147  152 7INTR
0209 I                                153  154 0BRT
0210 I                             P  155  160 7RTSP
     I                                161  170 0ACOD                                          CGL029
     I/COPY WNCPYSRC,GL0420I004
0211 I**********                              1 160 LOTP                                      CGL029
     I                                  1  170  LOTP                                          CGL029
     I*                                                                   S01408
     I/COPY WNCPYSRC,GL0420IIP9                                           S01408
     I*                                                                   S01408
0212 I*
0213 I********NS  08   1 CT                                               S01091
0214 I****                                    2   60POSSIZ                S01091
0215 I****                                P   7  140HNWN
0216 I****                                P  15  160HNDC
0217 I***     NS  **                                                      S01091
0218 I***                                     2  16 MATCHL                S01091
0219 I***                                 P  33  350PSTDL                 S01091
0220 I**
0221 I*    CATCHALL FOR DELETED RECORDS
0222 I**
0223 I          NS  11
     I                                  2   16  APKEY                           E23370
0224 I*
0225 I**
     I**APOST*-**TRAILER FILE                                   S01091    S01161
     I*                                                                   S01091
0213 I*POSTZZ*NS*                                               S01091    S01161
0214 I***********                             2   60POSSIZ      S01091    S01161
     I**EODPO*-**TRAILER FILE                                   S01091    S01161
     I*                                                                   S01091
0213 I*ODPOZZ*NS*                                               S01091    S01161
0214 I***********                             2   60NORE        S01091    S01161
     I*
0226 I*    ACCOUNT MASTER DETAIL RECORD
0227 I**
0228 IACCNT     NS  03    1 CD
0229 I         OR   03    1 CC
0230 I                                  1    1  RECI
0231 I                                  2   16  ACMDKY
     I                                  2   16  FICHEK                          S01146
0232 I**********                              2   70CNUM                                      CSD027
0232 I                                  2    7  CNUM                                          CSD027
0233 I                                  8   10  CCY
0234 I**********                             11  140ACOD                                      CGL029
     I                                 11   14 0ACODQQ                                        CGL029
0235 I                                 15   16 0ACSQ
0236 I***                                    23  250BRCDAM                S01117
0236 I                                 23   25  BRCDAM                          S01117
0237 I                                 26   26  ATYP
     I                                 28   28  MFFQ                            S01146
0238 I                                 29   29  ACST
0239 I                             P   30   32 0DACO
0240 I                             P   33   35 0DACC
0241 I                                 36   55  ANAM
0242 I**                                  P  56  630LDBL            26    E18546
0242 I                             P   56   63 0LDBL                            E18546
0243 I                             P   64   71 0CLBL
0244 I                                 72   72  STFQ
0245 I                                 73   74 0STDY
0246 I***********                         P  75  770LSTD                  S01161
0247 I***********                         P  78  800NSTD                  S01161
0248 I***********                         P  81  820LSTP                  S01161
0249 I***********                         P  83  900CFSB        24        S01161
0246 I                             P   75   77 0LSTDP                           S01161
0247 I                             P   78   80 0NSTDP                           S01161
0248 I                             P   81   82 0LSTPP                           S01161
0249 I                             P   83   90 0CFSBP                           S01161
0250 I                             P   91   93 0LMVD
0251 I                             P   94  101 0EPLB
0252 I                             P  102  109 0EPCB
0253 I                             P  110  117 0CFCB
0254 I***********                           118 118 GLBT                  S01161
0254 I                                118  118  GLBTB                           S01161
     I                                119  126  ADF1                            S01091
     I                                174  175  ADF2                            S01091
0255 I                                190  199 0ACNO                    27
     I*                                                                   S01408
     I/COPY WNCPYSRC,GL0420IIP7                                           S01408
     I*                                                                   S01408
0256 I                                397  397  CHTP
0257 I                             P  398  400 0TNLU
     I*                                                                   S01408
     I/COPY WNCPYSRC,GL0420IIP3                                           S01408
     I*                                                                   S01408
0257 I                                448  448  EUSB                            CEU013
     I                                449  482  IBAN                            CFT004
     I                                554  563 0ACOD                                          CGL029
     I/COPY WNCPYSRC,GL0420I019
0258 I**
0259 I*    CATCHALL FOR DELETED RECORDS
0260 I**
0261 I          NS  11
0262 I***********                                                         S01194
0263 I*****CLIENT*FILE*-*CUSTOMER NAME AND ADDRESS RECORD.                S01194
0264 I***********                                                         S01194
0265 I*LINT   NS  11   8 CB                                               S01091
0265 I*LINT***NS* 11                                               S01091 S01194
0266 I***********                             1   1 RECI                  S01194
0267 I***********                             2   70CNUM                  S01194
0268 I***********                             8   8 RCDT                  S01194
0269 I***********                             9  43 CNA1                  S01194
0270 I***********                            44  78 CNA2                  S01194
0271 I***********                            79 113 CNA3                  S01194
0272 I***********                           114 148 CNA4                  S01194
0273 I***********                         P 250 2520LCD                   S01194
0274 I***********                           253 253 CHTP                  S01194
0275 I***********                         P 254 2560TNLU                  S01194
0276 I***********                                                         S01194
0277 I*****CATCHALL*FOR*DELETED RECORDS.                                  S01194
0278 I********NS* 11                                                      S01194
0279 I*****TABLE*FILE*-*INSTALLATION CONTROL DATA RECORD 1.               S01194
0280 I***********                                                         S01194
0281 I*ABLE***NS* 11   2 C0   3 C1  12 C1                                 S01194
0282 I*******AND*     13 C0                                               S01194
0283 I***********                             1   1 RECI                  S01194
0284 I***********                             2   30RECT                  S01194
0285 I***********                            12  130RCDE                  S01194
0286 I***********                            14  66 TITL                  S01194
0287 I***********                            67  67 DATF                  S01194
0288 I***********                         P  77  790RUND                  S01194
0289 I***********                            80  86 RUNA                  S01194
0290 I***********                                                         S01194
0291 I***********                                                         S01194
0292 I*****TABLE*FILE - INSTALLATION CONTROL DATA RECORD 3.               S01194
0293 I***********                                                         S01194
0294 I********NS* 11   2 C0   3 C1                                        S01194
0295 I*******AND*     12 C2  13 C0                                        S01194
0296 I***********                             1   1 RECI                  S01194
0297 I***********                             2   30RECT                  S01194
0298 I***********                            12  130RCDE                  S01194
0299 I***********                            70  700GLSI                  S01194
0300 I***********                            71  710RTSI                  S01194
0301 I***********                            72  720DLSI                  S01194
0302 I***********                            73  730NOSI                  S01194
0303 I***********                            74  740CTSI                  S01194
0304 I***********                                                         S01194
0305 I*****TABLE*FILE*-*BRANCH CODES RECORD.                              S01194
0306 I***********                                                         S01194
0307 I********NS* 11   1 CD   2 C1   3 C0                                 S01194
0308 I***********                             1   1 RECI                  S01194
0309 I***********                             2   30RECT                  S01194
0310 I***********                            11  130BRCD                  S01194
0311 I***********                            14  43 BRNM                  S01194
0312 I***********                                                         S01194
0313 I*****TABLE*FILE*-*HOLIDAY RECORD.                                   S01194
0314 I********E-EXCLUDE,*I-INCLUDE.                                       S01194
0315 I***********                                                         S01194
0316 I********NS* 11   2 C2   3 C2  14 CE                                 S01194
0317 I***********                             1   1 RECI                  S01194
0318 I***********                             2   30RECT                  S01194
0319 I***********                             8  120HOL                   S01194
0320 I***********                            13  130SREC                  S01194
0321 I***********                            14  14 INEX                  S01194
0322 I***********                            15  89 HCCY                  S01194
0323 I********NS* 11   2 C2   3 C2  14 CI                                 S01194
0324 I***********                             1   1 RECI                  S01194
0325 I***********                             2   30RECT                  S01194
0326 I***********                             8  120HOL                   S01194
0327 I***********                            13  130SREC                  S01194
0328 I***********                            14  14 INEX                  S01194
0329 I***********                            15  89 HCCY                  S01194
0330 I***********                                                         S01194
0331 I*****TABLE*FILE*-*CURRENCIES*RECORD*1.********                      S01091
0332 I*****                                                               S01091
0333 I*****   NS  11   2 C2   3 C0  13 C1                                 S01091
0334 I*****                                   1   1 RECI                  S01091
0335 I*****                                   2   30RECT                  S01091
0336 I*****                                  10  12 CCY                   S01091
0337 I*****                                  13  130SREC                  S01091
0338 I*****                                  14  27 CCNM                  S01091
0339 I*****                                  38  380CDP                   S01091
0340 I*****TABLE*FILE*-*INSTALLATION CONTROL DATA RECORD 2.               S01194
0341 I***********                                                         S01194
0342 I********NS* 11   2 C0   3 C1  12 C1                                 S01194
0343 I*******AND*     13 C1                                               S01194
0344 I***********                             1   1 RECI                  S01194
0345 I***********                             2   30RECT                  S01194
0346 I***********                            12  130RCDE                  S01194
0347 I***********                         P  29  310APDA                  S01194
0348 I***********                            35  35 APFQ                  S01194
0349 I***********                         P  41  430DNWD                  S01194
0350 I***********                            47  49 LOCY                  S01194
0351 I***********                            50  510FDAY                  S01194
0352 I***********                                                         S01194
0353 I*****CATCHALL*FOR*DELETED RECORDS.                                  S01194
0354 I********NS* 11                                                      S01194
0355 I***********                             1   1 RECI                  S01194
     I*****ICD*RECORD*55                                           S01110 S01194
     I*ABTB55*NS* 05   2 C0   3 C1  12 C5                          S01110 S01194
0343 I*******AND*     13 C5                                        S01110 S01194
0345 I***********                             1   1 RECI           S01110 S01194
0346 I***********                             2   30RECT           S01110 S01194
0347 I***********                            12  130RCDE           S01110 S01194
0348 I***********                            14  14 LDAC           S01110 S01194
0349 I***********                            15  15 CBAC           S01110 S01194
0350 I***********                            16  180NDFV           S01110 S01194
0351 I***********                            19  210NDBI           S01110 S01194
     I***********                            22  22 RCPT           S01110 S01194
0352 I***********                         P  90  920LCD            S01110 S01194
0353 I***********                            93  93 CHTP           S01110 S01194
0354 I***********                         P  94  960TNLU           S01110 S01194
0269 I***********                                                  S01110 S01194
     I********NS*                                                  S01110 S01194
0355 I***********                             1   1 RECI           S01110 S01194
     I/COPY WNCPYSRC,GL0420I009                                           S01408
     I**                                                                  S01117
     I*COPY*ZSRSRC,ZHOLI***********************************************               S01195 CGL061A
     I**                                                                  S01117
     I**                                                                  S01117
     I/COPY WNCPYSRC,GL0420IIP8                                           S01195
     I**                                                                  S01117
0357 C/EJECT
     C                   MOVEA     CPY@          BIS@             80
     C     *DTAARA       DEFINE    RUNDAT        RUNDT                                        S01194
     C     *DTAARA       DEFINE                  LDA                                          S01194
     C     *DTAARA       DEFINE                  GLSTAT                                       S01281
     C     *LIKE         DEFINE    PSTBAL        EUPBAL                                       CEU013
     C     *LIKE         DEFINE    PSTBF         EUPBF                                        CEU013
     C**                                                                  S01117
0358 C*    FIRST CYCLE CALCULATIONS
     C/COPY WNCPYSRC,GL0420C005
0359 C   30              GOTO      CYCLE1
     C/COPY WNCPYSRC,GL0420C017
      *                                                                                       CGL061
     C     *ENTRY        PLIST                                                                CGL061
     C                   PARM                    RSTART            1            Restart if Y
     C                   PARM                    ENDKEY           25                         CGL061A
      *                                                                                       CGL061
      ** Initialise LDA variables                                                             CGL061
     C                   MOVEL(P)  'GL0420'      DBPGM                                        CGL061
     C                   MOVE      *BLANKS       DBFILE                                       CGL061
     C                   MOVE      *BLANKS       DBKEY                                        CGL061
0360 C                   SETON                                        30L1
     C/COPY WNCPYSRC,GL0420C006
      *                                                                                       CGL188
     C     KSTBA         KLIST                                                                CGL188
     C                   KFLD                    BRCA                                         CGL188
     C                   KFLD                    CNUM                                         CGL188
     C                   KFLD                    CCY                                          CGL188
     C                   KFLD                    ACOD                                         CGL188
     C                   KFLD                    ACSQ                                         CGL188
      *                                                                                       CGL188
     C*                                                                   S01281
     C**  RETRIEVE GLSTAT DATA AREA TO EXTRACT ZERO BALANCE/NO            S01281
     C**  MOVEMENT IN
     C*                                                                   S01281
     C                   IN        GLSTAT                                                     S01281
     C*                                                                   CEU013
     C*** KEYLIST FOR GLAPSTPD                                            CEU013
     C*                                                                   CEU013
     C     EXTKEY        KLIST                                                                CEU013
     C                   KFLD                    XRFI                                         CEU013
     C                   KFLD                    XRFN                                         CEU013
     C     KREGAH        KLIST                                                                216006
     C                   KFLD                    CNUM                                         216006
     C                   KFLD                    CCY                                          216006
     C                   KFLD                    ACOD                                         216006
     C                   KFLD                    ACSQ                                         216006
     C                   KFLD                    BRCA                                         216006
0361 C**
0362 C**   SETUP NARRATIVE FIELDS.
0363 C**
     C                   MOVE      *BLANKS       DBPGM                                        LN0194
     C                   MOVE      'GL0420'      DBPGM
0364 C                   MOVEL     'ADDRESS '    TEMP16           16
0365 C                   MOVE      'NOT FOUN'    TEMP16
0366 C                   MOVE      'D'           NFOUND           17
0367 C                   MOVEL     TEMP16        NFOUND
0368 C                   MOVE      ' '           BLANK            35
0369 C                   MOVEL     'NOT FOUN'    NFOUNZ            9
0370 C                   MOVE      'D'           NFOUNZ
     C/COPY WNCPYSRC,GL0420CX32                                           S01408
0371 C**
0372 C**
0373 C*
0374 C*    ZEROISE RECORD COUNTS
0375 C                   Z-ADD     0             TNPR              5 0
0376 C                   Z-ADD     0             TNAR              5 0
0377 C                   Z-ADD     0             TNPO              5 0
0378 C                   Z-ADD     0             HPTI             15 0
0379 C                   Z-ADD     0             HPTD              3 0
0380 C                   Z-ADD     0             HPOI             15 0
0381 C                   Z-ADD     0             HPOD              3 0
0382 C                   Z-ADD     0             ZZTOTI           15 0
0383 C                   Z-ADD     0             ZZTOTD            3 0
0384 C                   Z-ADD     0             ZZAMT            15 3
0385 C                   Z-ADD     0             ZERO5             5 0
     C                   Z-ADD     0             TTPR              5 0
     C                   Z-ADD     0             HTTI             15 0
     C                   Z-ADD     0             HTTD              5 0
     C                   Z-ADD     0             NODEL             9 0
     C/COPY WNCPYSRC,GL0420CX29                                           S01408
0386 C*
0387 C*
0388 C*****CHAIN*TO*INSTALLATION*CONTROL DATA 1.                          S01194
     C*    IN DATA AREA RUNDAT                                            S01194
0389 C*    FOR DATE FORMAT AND RUN DATE.
     C                   IN        RUNDT                                                      S01194
     C/COPY WNCPYSRC,GL0420C054
1035 C**                                                                  S01194
1036 C**   CHECK SYSTEM DATE FORMAT, DDMMYY OR MMDDYY.                    S01194
1037 C     DATF          COMP      'M'                                    98    MMDDYY, 98 ON  S0119
0390 C***********          EXSR ZSYSTM                                    S01194
     C*                                                                   S01408
     C/COPY WNCPYSRC,GL0420CP48                                           S01408
     C*                                                                   S01408
     C*                                                                   S01117
     C**  CHECK IF THE MULTIBRANCHING INDICATOR IS ON OR NOT              S01117
     C*                                                                   S01117
     C     MBIN          IFEQ      'Y'                                                        S01117
     C                   SETON                                        58                      S01117
     C                   END                                                                  S01117
     C*                                                                   S01194
     C**  OBTAIN THE BANK DETAILS                                         S01194
     C*                                                                   S01194
     C                   CALL      'AOBANKR0'                                                 S01194
     C                   PARM      '*MSG   '     @RTCD             7                          S01194
     C                   PARM      '*FIRST '     @OPTN             7                          S01194
     C     SDBANK        PARM      SDBANK        DSFDY                                        S01194
     C     @RTCD         IFNE      *BLANKS                                                    S01194
     C                   SETON                                        99                      S01194
     C                   Z-ADD     21            DBASE                          *************  S0119
     C                   MOVEL     *BLANKS       DBKEY                          DATABASE ERROR S0119
     C                   MOVEL     @OPTN         DBKEY                             21         S01194
     C                   MOVE      'SDBANKPD'    DBFILE                         *************  S0119
     C                   MOVEL     @OPTN         DBOPTN            7                          S01194
     C                   EXSR      *PSSR                                                      S01194
     C                   END                                                                  S01194
     C   99              GOTO      ERROR
     C/COPY WNCPYSRC,GL0420C057
0391 C*
0392 C*****CHAIN*TO*INSTALLATION*CONTROL DATA 2.                          S01194
     C**   CALL ACCESS OBJECT 'SDGELRR0'                                  S01194
0393 C*    FOR ACCRUALS PROFIT DATE
0394 C**
0395 C***********          MOVEL'01'      TABKEY 12                       S01194
0396 C***********          MOVE '11'      TABKEY                          S01194
0397 C***********          EXSR TABCHN                                    S01194
0398 C**N76******RECI      COMP 'D'                  7676                 S01194
     C**********           CALL 'AOGELRR0'                                             S01194 CGL029
     C                   CALL      'AOGELRR1'                                                 CGL029
     C                   PARM      '*MSG   '     @RTCD             7                          S01194
     C                   PARM      '*FIRST '     @OPTN             7                          S01194
     C********** SDGELR    PARM SDGELR    DSFDY                                        S01194 CGL029
     C     SDGELR        PARM      SDGELR        DSSDY                                        CGL029
     C     @RTCD         IFNE      *BLANKS                                                    S01194
     C                   SETON                                        76                      S01194
     C                   Z-ADD     22            DBASE                          *************  S0119
     C                   MOVEL     *BLANKS       DBKEY                          DATABASE ERROR S0119
     C                   MOVEL     @OPTN         DBKEY                             22         S01194
     C                   MOVE      'SDGELRPD'    DBFILE                         *************  S0119
     C                   MOVEL     @OPTN         DBOPTN            7                          S01194
     C                   EXSR      *PSSR                                                      S01194
     C                   END                                                                  S01194
0399 C   76              GOTO      ERROR
      *                                                                                       CGL188
     C                   EVAL      POPT( 1 ) = 'GLNumPagesLargeStmts'                         CGL188
     C                   CALL      'AOSVALR0'                                                 CGL188
     C                   PARM      *BLANKS       PRtCd                                        CGL188
     C                   PARM                    POPT( 1 )                                    CGL188
     C                   PARM                    PVAL( 1 )                                    CGL188
     C                   PARM                    POPT( 2 )                                    CGL188
     C                   PARM                    PVAL( 2 )                                    CGL188
     C                   PARM                    POPT( 3 )                                    CGL188
     C                   PARM                    PVAL( 3 )                                    CGL188
     C                   PARM                    POPT( 4 )                                    CGL188
     C                   PARM                    PVAL( 4 )                                    CGL188
     C                   PARM                    POPT( 5 )                                    CGL188
     C                   PARM                    PVAL( 5 )                                    CGL188
     C                   PARM                    POPT( 6 )                                    CGL188
     C                   PARM                    PVAL( 6 )                                    CGL188
     C                   PARM                    POPT( 7 )                                    CGL188
     C                   PARM                    PVAL( 7 )                                    CGL188
     C                   PARM                    POPT( 8 )                                    CGL188
     C                   PARM                    PVAL( 8 )                                    CGL188
     C                   PARM                    POPT( 9 )                                    CGL188
     C                   PARM                    PVAL( 9 )                                    CGL188
     C                   PARM                    POPT( 10 )                                   CGL188
     C                   PARM                    PVAL( 10 )                                   CGL188
      *                                                                                       CGL188
     C                   IF        PRtCd <> *BLANKS                                           CGL188
      *                                                                                       CGL188
     C     *LOCK         IN        LDA                                                        CGL188
     C                   MOVEL     'SDSVALPD'    DBFILE                                       CGL188
     C                   EVAL      DBKEY = 'POPT'                                             CGL188
     C                   Z-ADD     12            DBASE                                        CGL188
     C                   MOVEL     'GL0420'      DBPGM                                        CGL188
     C                   OUT       LDA                                                        CGL188
     C                   EXSR      *PSSR                                                      CGL188
      *                                                                                       CGL188
     C                   ELSE                                                                 CGL188
     C                   EVAL      @PAGEN = %DEC( PVAL( 1 ) : 5 : 0 )                         CGL188
     C                   ENDIF                                                                CGL188
      *                                                                                       CGL188
     C/COPY WNCPYSRC,GL0420C111
     C*                                                                   S01377
     C**  Switchable SAR: Ignore check for zero account balance and       S01377
     C**  type of account (S01377).                                       S01377
     C**  Check to see if SAR is installed.                               S01377
     C                   CALL      'AOSARDR0'                                                 S01377
     C                   PARM      '       '     @RTCD                                        S01377
     C                   PARM      '*VERIFY'     @OPTN                                        S01377
     C                   PARM      'S01377'      @SARD             6                          S01377
     C     SCSARD        PARM      SCSARD        DSFDY                                        S01377
     C*                                                                   S01377
     C**  If SAR S01377 is installed set up the indicating field          S01377
     C     @RTCD         IFEQ      *BLANKS                                                    S01377
     C                   MOVE      'S01377'      @SAR              6                          S01377
     C                   END                                                                  S01377
     C*                                                                   S01408
     C***/COPY*WNCPYSRC,GL0420CP35***                                                  S01408 CFC006
     C/COPY WNCPYSRC,GL0420CP35                                                             MD020563
     C*                                                                   S01408
      ***Check*if*CFC006*is*installed**********************************           AR1097176 MD020563
      *****************************************************************           AR1097176 MD020563
     C**********         EVAL      CFC006 = 'N'                                   AR1097176 MD020563
     C**********         CALL      'AOSARDR0'                                     AR1097176 MD020563
     C**********         PARM      *BLANKS       @RTCD                            AR1097176 MD020563
     C**********         PARM      '*VERIFY'     @OPTN                            AR1097176 MD020563
     C**********         PARM      'CFC006'      @SARD                            AR1097176 MD020563
     C*****SCSARD        PARM      SCSARD        DSFDY                            AR1097176 MD020563
      *****************************************************************           AR1097176 MD020563
     C**********         IF        @RTCD = *BLANKS                                AR1097176 MD020563
     C**********         EVAL      CFC006 = 'Y'                                   AR1097176 MD020563
     C**********         ELSE                                                     AR1097176 MD020563
      *****************************************************************           AR1097176 MD020563
     C**********         IF        @RTCD <> '*NRF'                                AR1097176 MD020563
     C**********         EVAL      DBFILE = 'SCSARDPD'                            AR1097176 MD020563
     C**********         EVAL      DBKEY = 'CFC006'                               AR1097176 MD020563
     C**********         EXSR      *PSSR                                          AR1097176 MD020563
     C**********         ENDIF                                                    AR1097176 MD020563
     C**********         ENDIF                                                    AR1097176 MD020563
      *                                                                                       CFC006
      ** Enable output indicator for GL0420P3 and GL0420P5                                    CFC006
      *                                                                                       CFC006
     C                   EVAL      SUPFL3 = 'N'                                               CFC006
     C                   EVAL      SUPFL5 = 'N'                                               CFC006
      *                                                                                    AR1097176
     C**********         IF        CFC006 = 'Y'                                   AR1097176 MD020563
     C                   CALL      'AOCOMR0'                                                  CFC006
     C                   PARM      'GLC43  '     PNAME                                        CFC006
     C                   PARM      '*ALL '       PCSEQ                                        CFC006
     C                   PARM      SECTN1        PSCTN                                        CFC006
     C                   PARM      *BLANKS       PRTCD                                        CFC006
      *                                                                                       CFC006
     C                   IF        PRTCD = 'Y'                                                CFC006
     C                   EVAL      SUPFL3 = 'Y'                                               CFC006
     C                   ENDIF                                                                CFC006
      *                                                                                       CFC006
     C                   CALL      'AOCOMR0'                                                  CFC006
     C                   PARM      'GLC43  '     PNAME                                        CFC006
     C                   PARM      '*ALL '       PCSEQ                                        CFC006
     C                   PARM      SECTN2        PSCTN                                        CFC006
     C                   PARM      *BLANKS       PRTCD                                        CFC006
      *                                                                                       CFC006
     C                   IF        PRTCD = 'Y'                                                CFC006
     C                   EVAL      SUPFL5 = 'Y'                                               CFC006
     C                   ENDIF                                                                CFC006
     C**********         ENDIF                                                    AR1097176 MD020563
     C*                                                                   S01520
     C** Check if Account Statements Changes switchable feature is        S01520
     C** switched ON                                                      S01520
     C*                                                                   S01520
     C                   CALL      'AOSARDR0'                                                 S01520
     C                   PARM      *BLANKS       @RTCD                                        S01520
     C                   PARM      '*VERIFY'     @OPTN                                        S01520
     C                   PARM      'S01520'      @SARD                                        S01520
     C     SCSARD        PARM      SCSARD        DSFDY                                        S01520
     C*                                                                   S01520
     C                   MOVE      'N'           S01520            1                          S01520
     C     @RTCD         IFEQ      *BLANKS                                                    S01520
     C                   MOVE      'Y'           S01520                                       S01520
     C                   ELSE                                                                 S01520
     C     @RTCD         IFNE      '*NRF   '                                                  S01520
     C                   SETON                                        76                      S01520
     C                   MOVEL     'SCSARDPD'    DBFILE                         ************   S0152
     C                   MOVEL     '*VERIFY'     DBKEY                          * DBERR 05 *   S0152
     C                   Z-ADD     05            DBASE                          ************   S0152
     C                   EXSR      *PSSR                                                      S01520
     C                   END                                                                  S01520
     C                   END                                                                  S01520
     C*                                                                   CEU013
     C** Check if EMU Account Postings Narrative switchable feature is    CEU013
     C** switched ON                                                      CEU013
     C*                                                                   CEU013
     C                   CALL      'AOSARDR0'                                                 CEU013
     C                   PARM      *BLANKS       @RTCD                                        CEU013
     C                   PARM      '*VERIFY'     @OPTN                                        CEU013
     C                   PARM      'CEU013'      @SARD                                        CEU013
     C     SCSARD        PARM      SCSARD        DSFDY                                        CEU013
     C*                                                                   CEU013
     C                   MOVE      'N'           CEU013            1                          CEU013
     C     @RTCD         IFEQ      *BLANKS                                                    CEU013
     C                   MOVE      'Y'           CEU013                                       CEU013
     C                   ELSE                                                                 CEU013
     C     @RTCD         IFNE      '*NRF   '                                                  CEU013
     C                   SETON                                        76                      CEU013
     C                   MOVEL     'SCSARDPD'    DBFILE                         ************   CEU01
     C                   MOVEL     '*VERIFY'     DBKEY                          * DBERR 07 *   CEU01
     C                   Z-ADD     07            DBASE                          ************   CEU01
     C                   EXSR      *PSSR                                                      CEU013
     C                   END                                                                  CEU013
     C                   END                                                                  CEU013
     C*                                                                   CGL046
      *  Check if CGL046 - Print Statement for Retail Account to a        CGL046
      *  different printer file if CGL046 is ON                           CGL046
     C*                                                                   CGL046
     C                   MOVE      'N'           CGL046            1                          CGL046
     C**********           MOVE *OFF      *IN20                           CGL046            BG12511A
     C                   MOVE      *OFF          *INKL                          CGL046            BG
     C                   CALL      'AOSARDR0'                                                 CGL046
     C                   PARM      *BLANKS       @RTCD                                        CGL046
     C                   PARM      '*VERIFY'     @OPTN                                        CGL046
     C                   PARM      'CGL046'      @SARD                                        CGL046
     C     SCSARD        PARM      SCSARD        DSFDY                                        CGL046
      *                                                                   CGL046
     C     @RTCD         IFEQ      *BLANKS                                                    CGL046
     C                   MOVE      'Y'           CGL046                                       CGL046
     C**********           MOVE *ON       *IN20                                       CGL046 BG12511
     C                   MOVE      *ON           *INKL                                       BG12511
     C                   ENDIF                                                                CGL046
      *                                                                   CFT004
      **  Access SAR details file to see if CFT004 is installed.          CFT004
      *                                                                   CFT004
     C                   CALL      'AOSARDR0'                                                 CFT004
     C                   PARM      *BLANKS       PRTCD             7                          CFT004
     C                   PARM      '*VERIFY'     POPTN             7                          CFT004
     C                   PARM      'CFT004'      PSARD             6                          CFT004
     C     SCSARD        PARM      SCSARD        DSSDY                                        CFT004
      *                                                                   CFT004
     C                   MOVE      'N'           CFT004                                       CFT004
     C     PRTCD         IFEQ      *BLANKS                                                    CFT004
     C                   MOVE      'Y'           CFT004            1                          CFT004
     C                   ELSE                                                                 CFT004
     C     PRTCD         IFNE      '*NRF   '                                                  CFT004
     C                   SETON                                        76                      CFT004
     C                   MOVEL     'SCSARDPD'    DBFILE                         ************   CFT00
     C                   MOVEL     '*VERIFY'     DBKEY                          * DBERR 15 *   CFT00
     C                   Z-ADD     15            DBASE                          ************   CFT00
     C                   EXSR      *PSSR                                                      CFT004
     C                   ENDIF                                                                CFT004
     C                   ENDIF                                                                CFT004
      *                                                                   216006
      **  Access SAR details file to see if CRE008 is installed.          216006
      *                                                                   716006
     C                   CALL      'AOSARDR0'                                                 216006
     C                   PARM      *BLANKS       PRTCD             7                          216006
     C                   PARM      '*VERIFY'     POPTN             7                          216006
     C                   PARM      'CRE008'      PSARD             6                          216006
     C     SCSARD        PARM      SCSARD        DSSDY                                        216006
      *                                                                   216006
     C                   MOVE      'N'           CRE008                                       216006
     C     PRTCD         IFEQ      *BLANKS                                                    216006
     C                   MOVE      'Y'           CRE008            1                          216006
     C     *LOVAL        SETLL     SDCMANL0                                                   216006
     C                   READ      SDCMANL0                               53                  216006
     C     *IN53         IFEQ      *ON                                                        216006
     C                   SETON                                        76                      216006
     C                   MOVEL     'SDCMANPD'    DBFILE                         ************   21600
     C                   MOVEL     '*VERIFY'     DBKEY                          * DBERR 30 *   21600
     C                   Z-ADD     30            DBASE                          ************   21600
     C                   EXSR      *PSSR                                                      216006
     C                   ENDIF                                                                216006
     C                   ELSE                                                                 216006
     C     PRTCD         IFNE      '*NRF   '                                                  216006
     C                   SETON                                        76                      216006
     C                   MOVEL     'SCSARDPD'    DBFILE                         ************   21600
     C                   MOVEL     '*VERIFY'     DBKEY                          * DBERR 31 *   21600
     C                   Z-ADD     31            DBASE                          ************   21600
     C                   EXSR      *PSSR                                                      216006
     C                   ENDIF                                                                216006
     C                   ENDIF                                                                216006
      *                                                                   216006
      *                                                                   CFT004
     C   76              GOTO      ERROR                                                      S01520
      *                                                                                       CGL061
      ** Access data area CBTASKSP for commit block size                                      CGL061
     C********** *NAMVAR   DEFN CBTASKSP  CBTASK                                      CGL061 CGL061A
     C**********           IN   CBTASK                                                CGL061 CGL061A
     C**********           MOVE CMTBLK    #OPTIM  60                                CGL061 AR1004822
     C**********           MOVE CMTBLK    #OPTIM 100                               AR1004822 CGL061A
      *                                                                                       CGL061
     C*                                                                   S01520
     C*                                                                   S01377
0400 C***********          MOVE LOCY      ZCCY    3                       S01117
0401 C*
0402 C*****CHAIN*TO*INSTALLATION*CONTROL DATA 3.                          S01194
     C**   CALL ACCESS OBJECT 'SDTRADR0'                                  S01194
0403 C*    FOR FORMS TYPE.
0404 C***********          MOVE '20'      TABKEY                          S01194
0405 C***********          EXSR TABCHN                                    S01194
0406 C**N76******RECI      COMP 'D'                  7676                 S01194
     C                   CALL      'AOTRADR0'                                                 S01194
     C                   PARM      '*MSG   '     @RTCD             7                          S01194
     C                   PARM      '*FIRST '     @OPTN                                        S01194
     C     SDTRAD        PARM      SDTRAD        DSFDY                                        S01194
     C     @RTCD         IFNE      *BLANKS                                                    S01194
     C                   SETON                                        76                      S01194
     C                   Z-ADD     23            DBASE                          *************  S0119
     C                   MOVEL     *BLANKS       DBKEY                          DATABASE ERROR S0119
     C                   MOVEL     @OPTN         DBKEY                             23         S01194
     C                   MOVE      'SDTRADPD'    DBFILE                         *************  S0119
     C                   MOVEL     @OPTN         DBOPTN            7                          S01194
     C                   EXSR      *PSSR                                                      S01194
     C                   END                                                                  S01194
     C/COPY WNCPYSRC,GL0420C007
0408 C  N76              GOTO      OKAY
     C     ERROR         TAG                                                    **ERROR TAG**
     C***********          Z-ADD01        DBASE            *************  S01194
     C***********          MOVELBLANK     DBKEY            DATABASE ERROR S01194
     C***76******          MOVELTABKEY    DBKEY                01         S01194
     C***99******          MOVELZTABKY    DBKEY            ************   S01194
     C***********          MOVE 'TABLE'   DBFILE                          S01194
     C   76
     COR 99              SETON                                        U7U8
     C                   GOTO      FINISH
     C     OKAY          TAG                                                    ***OKAY TAG***
      *                                                                   S01408
     C/COPY WNCPYSRC,GL0420CP38                                           S01408
      *                                                                   S01408
0410 C*     BUILD FORMAT ARRAY FROM TABLES DATA.
0411 C**
0412 C***********          Z-ADDGLSI      FORM,1           * G/L *        S01194
0412 C                   MOVE      BLGLSI        FORM(1)                        * G/L *        S0119
0413 C**
0414 C***********          Z-ADDRTSI      FORM,2           * RETAIL *     S01194
0414 C***********          MOVE BLRSS     FORM,2           * RETAIL S01194066562
0414 C                   MOVE      BLRSST        FORM(2)                        * RETAIL *     06656
0415 C**
0416 C***********          Z-ADDDLSI      FORM,3           * DEALING *    S01194
0416 C                   MOVE      BLDLSS        FORM(3)                        * DEALING *    S0119
0417 C**
0418 C***********          Z-ADDNOSI      FORM,4           * NOSTRO *     S01194
0418 C                   MOVE      BLNSS         FORM(4)                        * NOSTRO *     S0119
0419 C**
0420 C***********          Z-ADDCTSI      FORM,5           * CONTINGENT * S01194
0420 C                   MOVE      BLCSS         FORM(5)                        * CONTINGENT * S0119
     C**
     C  NU1              GOTO      CYCLE1                                                     S01110
0404 C***********          MOVE '55'      TABKEY                   S01110 S01194
0405 C***********          READ TABTB55                  76        S01110 S01194
0406 C**N76******RECI      COMP 'D'                  7676          S01110 S01194
     C                   CALL      'AORETLR0'                                                 S01194
     C                   PARM      '*MSG   '     @RTCD             7                          S01194
     C                   PARM      '*FIRST '     @OPTN             7                          S01194
     C     SDRETL        PARM      SDRETL        DSFDY                                        S01194
     C     @RTCD         IFNE      *BLANKS                                                    S01194
     C                   SETON                                        76                      S01194
     C                   Z-ADD     24            DBASE                          *************  S0119
     C                   MOVEL     *BLANKS       DBKEY                          DATABASE ERROR S0119
     C                   MOVEL     @OPTN         DBKEY                             24         S01194
     C                   MOVE      'SDRETLPD'    DBFILE                         *************  S0119
     C                   MOVEL     @OPTN         DBOPTN            7                          S01194
     C                   EXSR      *PSSR                                                      S01194
     C                   END                                                                  S01194
0408 C     *IN76         IFEQ      '1'                                                        S01110
     C***********          Z-ADD02        DBASE   S01110   *************  S01194
     C***********          MOVELBLANK     DBKEY   S01110   DATABASE ERROR S01194
     C***76******          MOVELTABKEY    DBKEY   S01110       02         S01194
     C***99******          MOVELZTABKY    DBKEY   S01110   ************   S01194
     C***********          MOVE 'TABLE'   DBFILE  S01110                  S01194
     C   76                                                                                   S01110
     COR 99              SETON                                        U7U8                    S01110
     C                   GOTO      FINISH                                                     S01110
     C                   END                                                                  S01110
     C***********RCPT      IFEQ 'N'                                S01110 S01194
     C     BMRCPI        IFEQ      'N'                                                        S01194
     C                   SETON                                        12                      S01110
     C                   END                                                                  S01110
     C*                                                                   S01408
      ** Access Switchable Features file and check if CSD023              CSD023
      ** is switched on or not.                                           CSD023
      *                                                                   CSD023
     C                   CALL      'AOSARDR0'                                                 CSD023
     C                   PARM      *BLANKS       PRTCD             7                          CSD023
     C                   PARM      '*VERIFY'     POPTN             7                          CSD023
     C                   PARM      'CSD023'      PSARD             6                          CSD023
     C     SCSARD        PARM      SCSARD        DSFDY                                        CSD023
      *                                                                   CSD023
     C     PRTCD         IFEQ      *BLANKS                                                    CSD023
     C                   MOVE      'Y'           CSD023            1                          CSD023
     C                   ELSE                                                                 CSD023
     C                   MOVE      'N'           CSD023                                       CSD023
      *                                                                   CSD023
      ** Database Error, if Return Code is not blanks or *NRF             CSD023
      *                                                                   CSD023
     C     PRTCD         IFNE      '*NRF   '                                                  CSD023
     C                   MOVEL     'SCSARDPD'    DBFILE                                       CSD023
     C                   Z-ADD     1             DBASE                                        CSD023
     C                   MOVEL     'CSD023  '    DBKEY                                        CSD023
     C                   EXSR      *PSSR                                                      CSD023
     C                   ENDIF                                                                CSD023
     C                   ENDIF                                                                CSD023
      *                                                                                       248797
      ** Access Switchable Features file and check if CSD007                                  248797
      ** is switched on or not.                                                               248797
      *                                                                                       248797
     C                   CALL      'AOSARDR0'                                                 248797
     C                   PARM      *BLANKS       PRTCD                                        248797
     C                   PARM      '*VERIFY'     POPTN                                        248797
     C                   PARM      'CSD007'      PSARD                                        248797
     C     SCSARD        PARM      SCSARD        DSFDY                                        248797
      *                                                                                       248797
     C     PRTCD         IFEQ      *BLANKS                                                    248797
     C                   MOVE      'Y'           CSD007            1                          248797
     C                   ELSE                                                                 248797
     C                   MOVE      'N'           CSD007                                       248797
     C                   ENDIF                                                                248797
      *                                                                                       CGL184
      ** Check if CGL184 is switched ON                                                       CGL184
      *                                                                                       CGL184
     C                   CALL      'AOSARDR0'                                                 CGL184
     C                   PARM      *BLANKS       PRTCD                                        CGL184
     C                   PARM      '*VERIFY'     POPTN                                        CGL184
     C                   PARM      'CGL184'      PSARD                                        CGL184
     C     SCSARD        PARM      SCSARD        DSFDY                                        CGL184
      *                                                                                       CGL184
     C     PRTCD         IFEQ      *BLANKS                                                    CGL184
     C                   MOVE      'Y'           CGL184            1                          CGL184
     C                   ELSE                                                                 CGL184
     C                   MOVE      'N'           CGL184                                       CGL184
     C                   ENDIF                                                                CGL184
      *                                                                                       CGL184
     C/COPY WNCPYSRC,GL0420CP18                                           S01408
     C*                                                                   S01408
0428 C/EJECT
      ** Set commit counter to 1                                                              CGL061
     C                   Z-ADD     1             #COMIT            6 0                        CGL061
      *                                                                                       CGL061
     C                   MOVE      'N'           OPENP1                                     BUG26704
     C                   MOVE      'N'           OPENP2                                     BUG26704
     C                   MOVE      'N'           OPENP3                                     BUG26704
     C                   MOVE      'N'           OPENP4                                     BUG26704
     C                   MOVE      'N'           OPENP5                                     BUG26704
     C                   MOVE      'N'           OPENP6                                     BUG26704
     C                   MOVE      'N'           OPENPR                                     BUG26704
     C                   MOVE      'N'           CLOSEP                                     BUG26704
0429 C     CYCLE1        TAG                                                    ** CYCLE1 TAG *
     C/COPY WNCPYSRC,GL0420C080
      *                                                                                       CGL029
      ** Set up MATCH fields                                                                  CGL029
      *                                                                                       CGL029
     C                   MOVEL     ACOD          WASQN                                        CGL029
     C                   MOVE      ACSQ          WASQN            12                          CGL029
     C                   MOVEL     MTCH          MATCH            24                          CGL029
     C                   MOVE      WASQN         MATCH                                        CGL029
     C**********         MOVEL     MATCH         CMPKEY           25                  CGL061A CGL188
     C**********         MOVE      ATYP          CMPKEY                               CGL061A CGL188
     C                   MOVEL     RPTY          CMPKEY           25                          CGL188
     C                   MOVE      MATCH         CMPKEY                                       CGL188
      *                                                                                      CGL061A
      ** If record read from STMTS GT end key, seton LR.                                     CGL061A
      *                                                                                      CGL061A
     C     CMPKEY        IFGT      ENDKEY                                                    CGL061A
     C                   SETON                                        LR                     CGL061A
     C                   GOTO      FINISH                                                    CGL061A
     C                   ENDIF                                                               CGL061A
      *                                                                                       CGL029
      ** Set up MATCHS field                                                                  CGL029
      *                                                                                       CGL029
     C                   MOVEL     MTCHS         MATCHS           21                          CGL029
     C                   MOVE      WASQN         MATCHS                                       CGL029
      *                                                                                       CGL029
     C     *INL4         IFEQ      '1'                                                        S01117
     C     MBIN          IFEQ      'Y'                                                        S01117
     C*******************  EXSR ENDRPT                                                 S01117 CGL061
     C                   CLOSE     GL0420P1                                                   S01117
     C/COPY WNCPYSRC,GL0420C008
     C                   CLOSE     GL0420P2                                                   S01117
     C     CGL046        IFEQ      'Y'                                                        CGL046
     C                   CLOSE     GL0420PR                                                   CGL046
     C                   MOVE      'N'           OPENPR                                     BUG27359
     C                   END                                                                  CGL046
     C*
     C** Core hook for externalisation.                                   S01408
     C/COPY WNCPYSRC,GL0420CCP1                                           S01408
     C*
     C                   CLOSE     GL0420P3                                                   S01117
     C*
     C** Core hook for externalisation.                                   S01408
     C/COPY WNCPYSRC,GL0420CCP2                                           S01408
     C*
     C                   CLOSE     GL0420P4                                                   S01117
     C                   CLOSE     GL0420P5                                                   S01117
     C                   CLOSE     GL0420P6                                                   S01117
     C                   MOVE      '0'           *IN84                                        S01117
     C                   MOVE      'N'           OPENP1                                     BUG27359
     C                   MOVE      'N'           OPENP2                                     BUG27359
     C                   MOVE      'N'           OPENP3                                     BUG27359
     C                   MOVE      'N'           OPENP4                                     BUG27359
     C                   MOVE      'N'           OPENP5                                     BUG27359
     C                   MOVE      'N'           OPENP6                                     BUG27359
     C                   END                                                                  S01117
      *                                                                   S01117
     C                   MOVE      BRCA          BRCASV            3                          S01117
     C     MBIN          IFEQ      'Y'                                                        S01117
     C     *IN84         OREQ      '0'                                                        S01117
     C                   SETON                                        84                      S01117
      *                                                                   S01117
     C**********           OPEN GL0420P1                                             S01117 BUG26704
      *                                                                   S01117
      **  ENSURE REPORT SPOOL FILE RECORDED BY RCF                        S01117
     C**********           Z-ADDSFNUM1    SFNO1   60                                 S01117 BUG26704
     C************         OUT  LDA                                                    S01117 CGL061
     C*COP**WN*PYSRC*GL0420C060****************************************** 169210
     C/COPY WNCPYSRC,GL0420CABB                                           169210
     C**********           CALL 'ZSFILE'                                             S01117 BUG26704
     C**********           PARM           SEQ     5                                  S01117 BUG26704
     C**********           PARM BRCA      SENTY   3                                  S01117 BUG26704
     C**********           PARM           SFILE1                                     S01117 BUG26704
     C**********           PARM           SFNO1                                      S01117 BUG26704
     C**********           PARM           ZSERR   1                                  S01117 BUG26704
     C*COP**WN*PYSRC*GL0420C061****************************************** 169210
     C/COPY WNCPYSRC,GL0420CABM                                           169210
      *                                                                   S01117
     C********** *LOCK     IN   LDA                                                  S01117 BUG26704
     C********** ZSERR     IFEQ 'Y'                                                  S01117 BUG26704
      *                                                                   S01117
      * ERROR DURING ZSFILE PROCESSING, RETURN TO CALLING PROGRAMME       S01117
      *                                                                   S01117
     C**********           SETON                     U7U8LR                          S01117 BUG26704
     C**********           RETRN                                                     S01117 BUG26704
     C**********           END                                                       S01117 BUG26704
      *                                                                   S01117
     C/COPY WNCPYSRC,GL0420C009
     C**********           OPEN GL0420P2                                             S01117 BUG26704
     C*                                                                   S01117
     C**  ENSURE REPORT SPOOL FILE RECORDED BY RCF                        S01117
     C**********           Z-ADDSFNUM2    SFNO2   60                                 S01117 BUG26704
     C**********           OUT  LDA                                                  S01117 BUG26704
     C/COPY WNCPYSRC,GL0420C062
     C**********           CALL 'ZSFILE'                                             S01117 BUG26704
     C**********           PARM           SEQ                                        S01117 BUG26704
     C**********           PARM BRCA      SENTY   3                                  S01117 BUG26704
     C**********           PARM           SFILE2                                     S01117 BUG26704
     C**********           PARM           SFNO2                                      S01117 BUG26704
     C**********           PARM           ZSERR   1                                  S01117 BUG26704
     C/COPY WNCPYSRC,GL0420C063
     C*                                                                   S01117
     C********** *LOCK     IN   LDA                                                  S01117 BUG26704
     C********** ZSERR     IFEQ 'Y'                                                  S01117 BUG26704
     C*                                                                   S01117
     C* ERROR DURING ZSFILE PROCESSING, RETURN TO CALLING PROGRAMME       S01117
     C*                                                                   S01117
     C**********           SETON                     U7U8LR                          S01117 BUG26704
     C**********           RETRN                                                     S01117 BUG26704
     C**********           END                                                       S01117 BUG26704
     C*                                                                   S01117
     C*
     C********** CGL046    IFEQ 'Y'                                                  CGL046 BUG26704
     C**********           OPEN GL0420PR                                             CGL046 BUG26704
      *                                                                   CGL046
      *   ENSURE REPORT SPOOL FILE RECORDED BY RCF                        CGL046
     C**********           Z-ADDSFNUM7    SFNO7   60                                 CGL046 BUG26704
     C**********           OUT  LDA                                                  CGL046 BUG26704
     C**********           CALL 'ZSFILE'                                             CGL046 BUG26704
     C**********           PARM           SEQ                                        CGL046 BUG26704
     C**********           PARM BRCA      SENTY   3                                  CGL046 BUG26704
     C**********           PARM           SFILE7                                     CGL046 BUG26704
     C**********           PARM           SFNO7                                      CGL046 BUG26704
     C**********           PARM           ZSERR   1                                  CGL046 BUG26704
      *                                                                   CGL046
     C********** *LOCK     IN   LDA                                                  CGL046 BUG26704
     C********** ZSERR     IFEQ 'Y'                                                  CGL046 BUG26704
      *                                                                   CGL046
      * ERROR DURING ZSFILE PROCESSING, RETURN TO CALLING PROGRAMME       CGL046
      *                                                                   CGL046
     C**********           SETON                     U7U8LR                          CGL046 BUG26704
     C**********           RETRN                                                     CGL046 BUG26704
     C**********           END                                                       CGL046 BUG26704
     C**********           END                                                       CGL046 BUG26704
      *                                                                   CGL046
     C** Core hook for externalisation.                                   S01408
     C/COPY WNCPYSRC,GL0420CCP3                                           S01408
     C*
     C**********           OPEN GL0420P3                                             S01117 BUG26704
     C*                                                                   S01117
     C**  ENSURE REPORT SPOOL FILE RECORDED BY RCF                        S01117
     C**********           Z-ADDSFNUM3    SFNO3   60                                 S01117 BUG26704
     C**********           OUT  LDA                                                  S01117 BUG26704
     C/COPY WNCPYSRC,GL0420C064
     C**********           CALL 'ZSFILE'                                             S01117 BUG26704
     C**********           PARM           SEQ                                        S01117 BUG26704
     C**********           PARM BRCA      SENTY   3                                  S01117 BUG26704
     C**********           PARM           SFILE3                                     S01117 BUG26704
     C**********           PARM           SFNO3                                      S01117 BUG26704
     C**********           PARM           ZSERR   1                                  S01117 BUG26704
     C/COPY WNCPYSRC,GL0420C065
     C*                                                                   S01117
     C********** *LOCK     IN   LDA                                                  S01117 BUG26704
     C********** ZSERR     IFEQ 'Y'                                                  S01117 BUG26704
     C*                                                                   S01117
     C* ERROR DURING ZSFILE PROCESSING, RETURN TO CALLING PROGRAMME       S01117
     C*                                                                   S01117
     C**********           SETON                     U7U8LR                          S01117 BUG26704
     C**********           RETRN                                                     S01117 BUG26704
     C**********           END                                                       S01117 BUG26704
     C*
     C** Core hook for externalisation.                                   S01408
     C/COPY WNCPYSRC,GL0420CCP4                                           S01408
     C*
     C*                                                                   S01117
     C**********           OPEN GL0420P4                                             S01117 BUG26704
     C*                                                                   S01117
     C**  ENSURE REPORT SPOOL FILE RECORDED BY RCF                        S01117
     C**********           Z-ADDSFNUM4    SFNO4   60                                 S01117 BUG26704
     C**********           OUT  LDA                                                  S01117 BUG26704
     C/COPY WNCPYSRC,GL0420C066
     C**********           CALL 'ZSFILE'                                             S01117 BUG26704
     C**********           PARM           SEQ                                        S01117 BUG26704
     C**********           PARM BRCA      SENTY   3                                  S01117 BUG26704
     C**********           PARM           SFILE4                                     S01117 BUG26704
     C**********           PARM           SFNO4                                      S01117 BUG26704
     C**********           PARM           ZSERR   1                                  S01117 BUG26704
     C/COPY WNCPYSRC,GL0420C067
     C*                                                                   S01117
     C********** *LOCK     IN   LDA                                                  S01117 BUG26704
     C********** ZSERR     IFEQ 'Y'                                                  S01117 BUG26704
     C*                                                                   S01117
     C* ERROR DURING ZSFILE PROCESSING, RETURN TO CALLING PROGRAMME       S01117
     C*                                                                   S01117
     C**********           SETON                     U7U8LR                          S01117 BUG26704
     C**********           RETRN                                                     S01117 BUG26704
     C**********           END                                                       S01117 BUG26704
     C*                                                                   S01117
     C**********           OPEN GL0420P5                                             S01117 BUG26704
     C*                                                                   S01117
     C**  ENSURE REPORT SPOOL FILE RECORDED BY RCF                        S01117
     C**********           Z-ADDSFNUM5    SFNO5   60                                 S01117 BUG26704
     C**********           OUT  LDA                                                  S01117 BUG26704
     C/COPY WNCPYSRC,GL0420C068
     C**********           CALL 'ZSFILE'                                             S01117 BUG26704
     C**********           PARM           SEQ                                        S01117 BUG26704
     C**********           PARM BRCA      SENTY   3                                  S01117 BUG26704
     C**********           PARM           SFILE5                                     S01117 BUG26704
     C**********           PARM           SFNO5                                      S01117 BUG26704
     C**********           PARM           ZSERR   1                                  S01117 BUG26704
     C/COPY WNCPYSRC,GL0420C069
     C*                                                                   S01117
     C********** *LOCK     IN   LDA                                                  S01117 BUG26704
     C********** ZSERR     IFEQ 'Y'                                                  S01117 BUG26704
     C*                                                                   S01117
     C* ERROR DURING ZSFILE PROCESSING, RETURN TO CALLING PROGRAMME       S01117
     C*                                                                   S01117
     C**********           SETON                     U7U8LR                          S01117 BUG26704
     C**********           RETRN                                                     S01117 BUG26704
     C**********           END                                                       S01117 BUG26704
     C*                                                                   S01117
     C**********           OPEN GL0420P6                                             S01117 BUG26704
     C*                                                                   S01117
     C**  ENSURE REPORT SPOOL FILE RECORDED BY RCF                        S01117
     C**********           Z-ADDSFNUM6    SFNO6   60                                 S01117 BUG26704
     C**********           OUT  LDA                                                  S01117 BUG26704
     C**********           CALL 'ZSFILE'                                             S01117 BUG26704
     C**********           PARM           SEQ                                        S01117 BUG26704
     C**********           PARM BRCA      SENTY   3                                  S01117 BUG26704
     C**********           PARM           SFILE6                                     S01117 BUG26704
     C**********           PARM           SFNO6                                      S01117 BUG26704
     C**********           PARM           ZSERR   1                                  S01117 BUG26704
     C*                                                                   S01117
     C********** *LOCK     IN   LDA                                                  S01117 BUG26704
     C********** ZSERR     IFEQ 'Y'                                                  S01117 BUG26704
     C*                                                                   S01117
     C* ERROR DURING ZSFILE PROCESSING, RETURN TO CALLING PROGRAMME       S01117
     C*                                                                   S01117
     C**********           SETON                     U7U8LR                          S01117 BUG26704
     C**********           RETRN                                                     S01117 BUG26704
     C**********           END                                                       S01117 BUG26704
      *                                                                   S01117
     C**********           OUT  LDA                                                  CGL061 BUG26704
     C**********           Z-ADD0         PAGE                                       S01117 BUG26704
     C**********           Z-ADD0         PAGE2                                      S01117 BUG26704
     C**********           Z-ADD0         PAGE3                                      S01117 BUG26704
     C**********           Z-ADD0         PAGE4                                      S01117 BUG26704
     C**********           Z-ADD0         PAGE5                                      S01117 BUG26704
     C**********           Z-ADD0         PAGE6                                      S01117 BUG26704
      * OPEN FILES - END                                                  S01117
     C                   END                                                                  S01117
      * BRANCH CHG - END                                                  S01117
     C                   END                                                                  S01117
      *                                                                   S01117
0430 C*    SETOF CONDITIONAL INDICATORS.
0431 C***L1******          SETOF                     49                   E22296
0431 C                   SETOFF                                       49                      E22296
0432 C                   SETOFF                                       181987
0433 C                   SETOFF                                       89
0434 C                   SETOFF                                       465051
     C/COPY WNCPYSRC,GL0420C027
0435 C                   SETOFF                                       525354
     C/COPY WNCPYSRC,GL0420C028
0436 C                   SETOFF                                       606162
0437 C                   SETOFF                                       636465
0438 C                   SETOFF                                       666768
0439 C**********           SETOF                     788081               LN0012
0439 C                   SETOFF                                       8081                    LN0012
     C**TO ALLOW DR INDICATOR TO OPERATE ON BFWD BALANCES
     C***********          SETOF                     33                   S01161
     C                   SETOFF                                       33                      E18546
0441 C   01              SETOFF                                       29
0442 C                   SETOFF                                       45
     C*                                                                   S01408
     C/COPY WNCPYSRC,GL0420CP28                                           S01408
     C*                                                                   S01408
0443 C***14                SETOF                     404142               S01091
0444 C***14                SETOF                     4344                 S01091
     C***TO PRODUCE DATABASE ERROR IF NO STMTS TRAILER PRESENT            S01091
     C***01************    SETON                     16                                       CGL061
     C/COPY WNCPYSRC,GL0420C018
0445 C*
0446 C*
0447 C*
0448 C*
0449 C*
0450 C*    IF A NEW STATEMENT HAS NOT BEEN READ GO TO POSTING PROCESSING
0451 C***02                                                               S01091
0452 C*R*04                GOTO STMTAG                                    S01091
0453 C***13*********       GOTO STRAIL                                                        CGL061
0454 C***14                GOTO PTRAIL                                    S01091
0455 C  N01              GOTO      FINISH
0456 C*
0457 C**
0458 C*****IF ADDRESS REQUIRED OBTAIN FROM CLINT FILE                     S01091
0459 C*****                                                               S01091
0460 C***L3                MOVE 'B'       CLIKEY  7                       S01091
0461 C***L3                MOVELCNUM      CLIKEY                          S01091
0462 C***L3      CLIKEY    CHAINCLINT                78                   S01091
0463 C***L3 78             MOVE BLANK     CNA1                            S01091
0464 C***L3 78             MOVE BLANK     CNA2                            S01091
0465 C***L3 78             MOVE BLANK     CNA3                            S01091
0466 C***L3 78             MOVE BLANK     CNA4                            S01091
0467 C***L3 78             MOVELNFOUND    CNA1                            S01091
     C***L3 78             Z-ADD11        DBASE            ************** S01091
     C***L3 78             MOVE BLANK     DBKEY            DATABASE ERROR S01091
     C***L3 78             MOVELCLIKEY    DBKEY                  11       S01091
     C***L3 78             MOVEL'CLINT'   DBFILE           ************** S01091
     C***L3 78             SETON                     U7U8LR               S01091
0468 C**
0469 C*****OBTAIN*BRANCH*NAME*FROM TABLE FILE                             S01194
0470 C***L4******          MOVE BLANK     TABKEY                          S01194
0471 C***L4******          MOVEL'10'      TABKEY                          S01194
0472 C***L4******          MOVE BRCD      TABKEY                          S01194
0473 C***L4******          EXSR TABCHN                                    S01194
0474 C***L4N76***RECI      COMP 'D'                  7676                 S01194
0475 C***L4*76***          MOVE BLANK     BRNM                            S01194
0476 C***L4*76***          MOVE NFOUNZ    BRNM                            S01194
     C***L4*76***          Z-ADD12        DBASE            ************** S01194
     C***L4*76***          MOVE BLANK     DBKEY            DATABASE ERROR S01194
     C***L4*76***          MOVELTABKEY    DBKEY                   12      S01194
     C***L4*76***          MOVEL'TABLE'   DBFILE           ************** S01194
     C*                                                                   S01194
     C**  OBTAIN BRANCH NAME BY USING THE ACCESS OBJECT 'AOBRCHR0'        S01194
     C*                                                                   S01194
      ** Increase number of records processed                                                 CGL061
     C                   ADD       1             #COMIT            6 0                        CGL061
      *                                                                                       CGL061
     C     *INL4         IFEQ      '1'                                                        S01194
     C**********           CALL 'AOBRCHR0'                                             S01194 CGL029
     C**********         CALL      'AOBRCHR1'                                         CGL029 CGL061A
     C                   CALLB     'AOBRCHR1'                                                CGL061A
     C                   PARM      '*MSG   '     @RTCD             7                          S01194
     C                   PARM      '*KEY   '     @OPTN             7                          S01194
     C                   PARM      BRCA          @DSNB             3                          S01194
     C********** SDBRCH    PARM SDBRCH    DSFDY                                        S01194 CGL029
     C     SDBRCH        PARM      SDBRCH        DSSDY                                        CGL029
     C     @RTCD         IFNE      *BLANKS                                                    S01194
     C                   SETON                                        76                      S01194
     C                   SETON                                        U7U8LR                  S01194
     C                   Z-ADD     25            DBASE                          *************  S0119
     C                   MOVEL     *BLANKS       DBKEY                          DATABASE ERROR S0119
     C                   MOVEL     @DSNB         DBKEY                             25         S01194
     C                   MOVE      'SDBRCHPD'    DBFILE                         *************  S0119
     C                   MOVEL     @OPTN         DBOPTN            7                          S01194
     C                   EXSR      *PSSR                                                      S01194
     C                   GOTO      FINISH                                                     S01194
     C                   END                                                                  S01194
     C/COPY WNCPYSRC,GL0420C038
     C                   END                                                                  S01194
     C/COPY WNCPYSRC,GL0420C039
     C***L4*76***********  SETON                     U7U8LR
     C***L4*76**********   GOTO FINISH                                    E18339
     C**  CURRENCY DETAILS FOR SDCURRPD                                   S01194
0477 C*
0478 C*****OBTAIN*CURRENCY*NAME*FROM*TABLE*FILE************               S01091
0479 C***L2                MOVE BLANK     TABKEY                          S01091
0480 C***L2                MOVEL'20'      TABKEY                          S01091
0481 C***L2                MOVELCCY       WRK4    4                       S01091
0482 C***L2                MOVE '1'       WRK4                            S01091
0483 C***L2                MOVE WRK4      TABKEY                          S01091
0484 C***L2                EXSR TABCHN                                    S01091
0485 C***L2N76   RECI      COMP 'D'                  7676                 S01091
0486 C***L2 76             MOVE BLANK     CCNM                            S01091
0487 C***L2 76             MOVE NFOUNZ    CCNM                            S01091
     C***L2 76             Z-ADD13        DBASE            ************** S01091
     C***L2 76             MOVE BLANK     DBKEY            DATABASE ERROR S01091
     C***L2 76             MOVELTABKEY    DBKEY                   13      S01091
     C***L2 76             MOVEL'TABLE'   DBFILE           ************** S01091
     C***L2 76             SETON                     U7U8LR               S01091
0488 C***                                                                 S01091
0489 C*****DETERMINE*NUMBER*OF*DECIMAL*PLACES*************                S01091
0490 C***L2      CDP       COMP 1                      7071               S01091
0491 C***L2      CDP       COMP 2                    73  72               S01091
     C**   GET CCY DETAILS                                                S01091
     C     *INL2         IFEQ      '1'                                          ** IF  001
     C                   Z-ADD     1             K                 3 0                        S01091
     C     CCY           LOOKUP    CY(K)                                  14                  S01091
     C     *IN14         IFEQ      '1'                                          ** IF  002     S0109
     C                   MOVE      CYD(K)        CYDDS                                        S01091
     C/COPY WNCPYSRC,GL0420C023
     C     CDP           COMP      1                                    7071                  S01091
     C     CDP           COMP      2                                  73  72                  S01091
     C                   ELSE                                                   ** ELS 002     S0109
     C**    ERROR IF NOT FOUND                                            S01091
     C                   MOVE      '1'           *INU7                                        S01091
     C                   MOVE      '1'           *INU8                                        S01091
     C                   MOVE      '1'           *INLR                                        S01091
0486 C                   MOVE      BLANK         CCNM                                         S01091
0487 C                   MOVE      NFOUNZ        CCNM                                         S01091
     C                   Z-ADD     13            DBASE                          ************** S0109
     C                   MOVE      BLANK         DBKEY                          DATABASE ERROR S0109
     C                   MOVEL     CCY           DBKEY                                13      S01091
     C**                                                   ************** LN0194
     C*******************  MOVEL'SDCURRPD'DBFILE           ******** S01194LN0194
     C                   MOVEL     'TABTG30'     DBFILE                                       LN0194
     C***********          MOVEL'TABTG'   DBFILE   S01091  ************** S01194
     C                   SETON                                        U7U8LR                  S01194
     C                   EXSR      *PSSR                                                      S01194
     C                   GOTO      FINISH                                                     S01091
     C                   END                                                    ** END 002     S0109
     C                   END                                                    ** END 001     S0109
     C/COPY WNCPYSRC,GL0420C040
     C**
     C**   CHAIN TO ACCOUNTS FILE TO TEST STATUS
     C**
     C                   SETOFF                                       03
     C*****                MOVE MATCH     ACKEY  15                       S01117
     C**************       MOVELMATCH     ACKEY  18                       S01117
     C**********           MOVELMATCHS    ACKEY  18                                    S01117 CGL029
     C                   MOVEL     MATCHS        ACKEY            24                          CGL029
     C****                 MOVE BRCD      ACKEY                           S01117
     C                   MOVE      BRCA          ACKEY                                        S01117
     C     ACKEY         CHAIN     ACCNT                              77
     C**N03***             Z-ADD02        DBASE            ***************E18339
     C**N03***             Z-ADD14        DBASE            *********E18339S01194
     C**N03***             MOVE BLANK     DBKEY            DATABASE ERROR S01194
     C**N03***             MOVELACKEY     DBKEY                14         S01194
     C**N03***             MOVEL'ACCNT'   DBFILE           ***************S01194
     C**N03******          SETON                     U7    DATABASE ERROR S01194
     C**N03***             SETON                     U7U8LRDATABASE ERROR S01194
     C**N03***             GOTO FINISH                              E18339S01194
      *
     C     *IN03         IFNE      '1'                                                        S01194
     C                   Z-ADD     14            DBASE                          ***************S0119
     C                   MOVE      BLANK         DBKEY                          DATABASE ERROR S0119
     C                   MOVEL     ACKEY         DBKEY                             14         S01194
     C                   MOVEL     'ACCNT'       DBFILE                         ***************S0119
     C                   SETON                                        U7U8LR    DATABASE ERROR S0119
     C                   EXSR      *PSSR                                                      S01194
     C                   GOTO      FINISH                                                     S01194
     C                   END                                                                  S01194
      *
     C/COPY WNCPYSRC,GL0420C029
     C   03RECI          COMP      'C'                                    79
     C***03                EXCPT                                          S01091
     C***                  SETOF                     03                   S01091
     C***03                EXCPT                                   S01161 E16854
     C***                  SETOF                     03            S01161 E16854
     C**
     C*  Check if part of group account hierarchy                         216006
     C                   SETOFF                                         82                    216006
     C     CRE008        IFEQ      'Y'                                                        216006
     C     KREGAH        CHAIN     REGAHLJ2                           77                      216006
     C     *IN77         IFEQ      '0'                                                        216006
     C                   MOVE      '1'           *IN82                                        216006
     C                   ENDIF                                                                216006
     C                   ENDIF                                                                216006
     C*                                                                   216006
     C*                                                                   S01408
     C/COPY WNCPYSRC,GL0420CP32                                           S01408
     C*                                                                   S01408
     C**   INCREASE COUNT OF A/C READ
     C     TNAR          ADD       1             TNAR
     C**   SETUP MICROFICHE FREQ/SORT FIELD                               S01146
     C     MFFQ          IFEQ      *BLANK                                                     S01146
     C                   MOVEL     *BLANKS       FICHE                                        S01146
     C                   END                                                                  S01146
     C**
     C**   DETERMINE IF NEXT STMT DATE IS BEFORE NEXT WORKING DAY
     C***********NSTD      COMP DNWD                   59                 S01194
     C     NSTD          COMP      BJDNWD                               59                    S01194
     C***********STFQ******IFEQ 'A'                                 E18547E24683
     C*********************MOVE '1'       *IN59                     E18547E24683
     C*********************END                                      E18547E24683
     C                   SETOFF                                       3435
      *                                                                   177915
      ** Check if Demand or Management is requested whether or not        177915
      ** the statement is due today                                       177915
      *                                                                   177915
     C/COPY WNCPYSRC,GL0420C112
     C**N59*****           TESTB'1'       GLBT           35 DEMAND        177915
     C**N35N59**           TESTB'0'       GLBT           34 MANAGEMENT    177915
     C                   TESTB     '1'           GLBT                     35    DEMAND        177915
     C  N35              TESTB     '0'           GLBT                     34    MANAGEMENT    177915
     C/COPY WNCPYSRC,GL0420C113
     C                   TESTB     '2'           GLBT                     36           PRINT ADDRESS
      *
     C     STFQ          IFEQ      'A'                                                        E24683
     C     *IN34         ANDEQ     '0'                                                        E24683
     C                   MOVE      '1'           *IN59                                        E24683
     C                   END                                                                  E24683
     C**   SET INDEX FOR FORMAT TYPE
     C                   Z-ADD     1             X                 1 0
     C**   MANAGEMENT STATEMENT FORMAT
     C   34              SETON                                        41
     C   34              SETOFF                                       40
     C   34              SETOFF                                       424344
     C/COPY WNCPYSRC,GL0420C030
     C**   NON-MANAGEMENT STATEMENT FORMATS
     C  N34ATYP          LOOKUP    TYPE(X)                                31
     C**N34******FORM,X    COMP 2                      4142               S01194
     C**N34******FORM,X    COMP 3                        43               S01194
     C**N34******FORM,X    COMP 4                    40  44               S01194
     C  N34FORM(X)       COMP      '2'                                  4142                  S01194
     C  N34FORM(X)       COMP      '3'                                    43                  S01194
     C  N34FORM(X)       COMP      '4'                                40  44                  S01194
     C/COPY WNCPYSRC,GL0420C010
     C**
     C**   IF NO POSTINGS,A/C BALANCE ZERO,NOT
     C**   MANAGEMENT OR DEMAND STATEMENT,& NOT RETAIL A/C,
     C**   AND ZERO BALANCE/NO MOVEMENT IND.IS 'N'                        S01281
     C**   THEN STATEMENT NOT REQUIRED
0492 C*
0535.C**NMR 26N35                                                         S01091
0535.C***26N35N34          SETON                     33            S01091 E10604
0536 C*NN34                SETON                     33            S01091 E10604
0537 C***33      ATYP      COMP 'R'                  3333                 E10604
0538 C***33                GOTO ENDPRT                                    E10604
     C*
     C*   REINSTATE THE ABOVE CODE IN NEW FORM                            E18546
     C                   SETOFF                                       15                      E18546
     C*                                                                   E23370
     C*   CHECK FOR POSTINGS THAT HAVE APPEARED SINCE LAST STATEMENT.     E23370
     C********** MATCH *** SETLLAPOST                              E23370 E18546
     C********** MATCH *** READEAPOST                  1515        E23370 E18546
     C*                                                                   S01408
     C/COPY WNCPYSRC,GL0420CP36                                           S01408
     C*                                                                   S01408
     C*                                                                   E23370
     C*                                                                   E23370
     C***        READ LAST RECORD, OF ACCOUNT, ON APOST.                  E23370
     C*                                                                   E23370
     C*                                                                   S01408
     C/COPY WNCPYSRC,GL0420CP57                                           S01408
     C*                                                                   S01408
     C     MATCH         SETGT     APOST                                                      E23370
     C                   SETOFF                                         11                    236789
     C                   READP     APOST                                1515                  E23370
     C*                                                                   S01408
     C/COPY WNCPYSRC,GL0420CP56                                           S01408
     C*                                                                   S01408
     C*                                                                   096031
     C     RECI          DOWEQ     'R'                                                        096031
     C/COPY WNCPYSRC,GL0420CY33                                           S01408
     C     *IN15         ANDEQ     '0'                                                        096031
     C********** MATCHS    ANDEQAPKEY                                                  144366 236789
     C     MATCH         ANDEQ     SAVKEY                                                     236789
     C     *IN11         ANDEQ     '0'                                                        236789
     C/COPY WNCPYSRC,GLH00438
     C                   READP     APOST                                1515                  096031
     C/COPY WNCPYSRC,GL0420C089
     C                   END                                                                  096031
     C*                                                                   E23370
     C/COPY WNCPYSRC,GL0420C026
     C*                                                                   E23370
     C***        IF RECORD IS NOT FOUND. EI. NO POSTINS FOR ACCOUNT.      E23370
     C*                                                                   E23370
     C     *IN15         IFEQ      '1'                                          UNSUCCESSFUL  E23370
     C                   z-add     1             @PAGECTR          7 0                        CGL188
     C                   GOTO      NOSLCT                                       READ.         E23370
     C                   END                                                                  E23370
     C*                                                                   E23370
     C*                                                                   E23370
     C***        READ ACCESSES RECORD OUTSIDE IF KEY.                     E23370
     C*                                                                   E23370
     C***********MATCH     IFNE APKEY                 RECORD READ   E23370E26667
     C********** MATCHS    IFNE APKEY                       RECORD                     E26667 236789
     C     MATCH         IFNE      SAVKEY                                                     236789
     C     *IN11         OREQ      '1'                                                        236789
     C                   SETON                                        15        IS NO EQUAL   E23370
     C                   z-add     1             @PAGECTR                                     CGL188
     C                   GOTO      NOSLCT                                       TO KEY.       E23370
     C                   END                                                                  E23370
     C*                                                                   E23370
     C*                                                                   E23370
     C***        SELECT ON POSTING AND LAST STATEMENT DATE TO PROCESS.    E23370
     C*                                                                   E23370
     C     PSTD          IFLE      LSTD                                         IF POST DATE  E23370
     C/COPY WNCPYSRC,GL0420C044
     C                   SETON                                        15        <= LAST       E23370
     C                   END                                                    STATEMENT DAT.E23370
     C*                                                                   E23370
     C*                                                                   E23370
     C***        HOWEVER, ALLOW ACCOUNTS OPENED ON STATEMENT DATE.        E23370
     C*                                                                   E23370
     C     DACO          IFEQ      LSTD                                         DAT A/C OPEN. E23370
     C     LSTP          ANDEQ     0                                            LST STMNT PAG.E23370
     C     PSTD          ANDGE     LSTD                                         LAST < PST DT.E23370
     C                   SETOFF                                       15                      E23370
     C                   END                                                                  E23370
     C*                                                                   E23370
     C*                                                                   E23370
     C     NOSLCT        TAG                                                                  E23370
     C*                                                                   E23370
     C*                                                                   E23370
     C***15*26N34                                                   E18546S01281
     C*NN35******          SETON                     33             E18546S01281
     C*                                                                   S01377
     C**  Switchable SAR S01377: Ignore check for zero B/F balance        S01377
     C**  and type of account. @SAR set up in first cycle.                S01377
     C*                                                                   S01281
     C** If no more postings for this a/c (*IN15), ledger balance zero    S01377
     C** (*IN26), not a mgt or demand stmt (*IN34,35) and zero balance/   S01377
     C** no movement ind (GLSTAT - CoB parm) set to 'N', and SAR not      S01377
     C** installed then suppress statement (*IN33).                       S01377
     C/COPY WNCPYSRC,GL0420C051
     C     *IN15         IFEQ      '1'                                                        S01281
     C     *IN26         ANDEQ     '1'                                                        S01281
     C     *IN34         ANDEQ     '0'                                                        S01281
     C     *IN35         ANDEQ     '0'                                                        S01281
     C     MOVI          ANDEQ     'N'                                                        S01281
     C     @SAR          ANDEQ     *BLANKS                                                    S01377
     C                   SETON                                        33                      S01281
     C*                                                                   S01377
     C** Ensure that retail accounts are not suppressed                   S01377
     C   33ATYP          COMP      'R'                                3333                    E18546
     C     *IN33         IFEQ      '1'                                                        E22281
     C                   MOVE      '1'           *IN07                                        E22281
     C                   END                                                                  E22281
     C/COPY WNCPYSRC,GL0420C056
     C   33              GOTO      ENDPRT                                                     E18546
     C                   END                                                                  S01281
     C/COPY WNCPYSRC,GL0420C052
     C*
     C*                                                                   S01281
     C** If no more postings for this a/c (*IN15),                        S01377
     C** not a mgt or demand stmt (*IN34,35) and SAR                      S01377
     C** installed then suppress statement (*IN33).                       S01377
     C     *IN15         IFEQ      '1'                                                        S01377
     C     *IN34         ANDEQ     '0'                                                        S01377
     C     *IN35         ANDEQ     '0'                                                        S01377
     C     @SAR          ANDEQ     'S01377'                                                   S01377
     C/COPY WNCPYSRC,GL0420C002
     C                   SETON                                        33                      S01377
      *                                                                   S01377
     C     *IN33         IFEQ      '1'                                                        S01377
     C                   MOVE      '1'           *IN07                                        S01377
     C                   END                                                                  S01377
     C   33              GOTO      ENDPRT                                                     S01377
     C                   END                                                                  S01377
      *                                                                   177915
      ** If statement is due today and a management statement is          177915
      ** requested: if the a/c has postings, produce normal statement     177915
      ** (set off *IN33 and *IN34); otherwise, produce management         177915
      ** statement and select only necessary fields to update             177915
      ** in ACCNTAB (set on *IN33)                                        177915
      *                                                                   177915
     C     *IN34         IFEQ      '1'                                                        177915
     C     *IN59         ANDEQ     '1'                                                        177915
     C     *IN15         IFEQ      '1'                                                        177915
     C                   MOVE      '1'           *IN33                                        177915
     C                   ELSE                                                                 177915
     C                   MOVE      '0'           *IN33                                        177915
     C                   MOVE      '0'           *IN34                                        177915
     C                   END                                                                  177915
     C                   END                                                                  177915
     C*                                                                   S01408
      *                                                                   177915
      ** If statement is due today and demand statement is requested,     177915
      ** set off *IN33 to update fields in ACCNTAB. If the account        177915
      ** has postings, produce normal statement. Otherwise, produce       177915
      ** demand statement.                                                177915
      *                                                                   177915
     C     *IN35         IFEQ      '1'                                                        177915
     C     *IN59         ANDEQ     '1'                                                        177915
     C                   MOVE      '0'           *IN33                                        177915
     C     *IN15         IFEQ      '0'                                                        177915
     C                   MOVE      '0'           *IN35                                        177915
     C                   END                                                                  177915
     C                   END                                                                  177915
      *                                                                   177915
     C/COPY WNCPYSRC,GL0420CP37                                           S01408
     C*                                                                   S01408
     C*                                                                   E23370
     C***        READ APOST. FURTHER PROCESSING IS ON 1ST REC. FOR A/C.   E23370
     C*                                                                   E23370
     C*                                                                   S01408
     C/COPY WNCPYSRC,GL0420CP55                                           S01408
     C*                                                                   S01408
     C     MATCH         SETLL     APOST                                        READ REC 1    E23370
     C     MATCH         READE     APOST                                1515    FOR ACCOUNT.  E23370
     C*                                                                   S01408
     C/COPY WNCPYSRC,GL0420CP54                                           S01408
     C*                                                                   S01408
     C*                                                                   E23370
     C*                                                                   E24003
     C*   IF READ FAILS, FIELDS ARE CORRUPTED BY SETGT/READP.             E24003
     C*   CNUM, CCY, ACOD, ACSQ NEED RESTORING.                           E24003
     C*                                                                   E24003
     C                   MOVEL     MATCH         SAVKEY                                       E24003
     C*
     C**   IF DEMAND OR MANAGEMENT STMT PRINT ADDRESS
0539 C**
0540 C   34
0541 COR 35              SETON                                        36        PRINT ADDRESS
0542 C*
0543 C   35              SETON                                        59
0544 C*
0545 C*    CONVERT LAST STATMNT DATE
     C/COPY WNCPYSRC,GL0420C060
0546 C                   Z-ADD     LSTD          ZDAYNO            5 0
0547 C                   EXSR      ZDATE2
0548 C                   MOVE      ZADATE        LSTDA             7
     C/COPY WNCPYSRC,GL0420C032
0549 C*
0550 C*    NEXT STATMNT DATE DEFAULT
0551 C                   Z-ADD     NSTD          NSTDA             5 0
0552 C**
0553 C*
     C*                                                                   S01408
     C** Core hook for externalisation.                                   S01408
     C/COPY WNCPYSRC,GL0420CCP7                                           S01408
     C*                                                                   S01408
0554 C*                                                                   S01091
     C*    SET ADDRESS REF IN ARRAY                                       S01091
     C                   MOVEL     ADF1          ADREF            10                          S01091
     C                   MOVE      ADF2          ADREF                                        S01091
     C*    IF NO ADDRESS REFS USE DEFAULT OF ONE 'B' ADDRESS              S01091
     C     ADREF         IFEQ      *BLANKS                                                    S01091
     C                   MOVEL     'B'           ADREF                                        S01091
     C                   END                                                                  S01091
     C*                                                                   S01091
     C*    IF MANAGEMENT STATEMENT PRINT 1 STMT FOR 'B' ADDRESS           S01091
     C     *IN34         IFEQ      '1'                                                        S01091
     C                   MOVE      *BLANKS       ADREF                                        S01091
     C                   MOVEL     'B'           ADREF                                        S01091
     C                   END                                                                  S01091
     C*                                                                   S01091
     C                   Z-ADD     1             C                 2 0                        S01091
     C                   MOVEA     ADREF         ARAD                                         S01091
     C                   MOVE      ARAD(1)       ADTYP             1                          S01091
     C*    PRINT STATEMENTS FOR ALL ADDRESSES                             S01091
     C******     *IN84     DOUEQ'1'                                       E10262
     C     *IN07         DOUEQ     '1'                                                        E10262
     C/COPY WNCPYSRC,GL0420C106
     C                   MOVE      '0'           *IN49                                        063631
     C/COPY WNCPYSRC,GL0420C107
     C***********          MOVE ADTYP     CLIKEY  7                S01091 S01194
     C                   MOVE      ADTYP         W@ADRC            1                          S01194
     C     1             ADD       C             C                                            S01091
     C     C             IFLE      10                                                         S01091
     C                   MOVE      ARAD(C)       ADTYP                                        S01091
     C                   END                                                                  S01091
     C******               SETOF                     84                   E10262
     C                   SETOFF                                       07                      E10262
     C*    ALLOW UPDATE OF FILES IF NEXT ADDRESS REF IS BLANK OR          S01091
     C*    IF LAST ONE                                                    S01091
     C     ADTYP         IFEQ      ' '                                                        S01091
     C     C             OREQ      11                                                         S01091
     C/COPY WNCPYSRC,GL0420C104
     C******               SETON                     84                   E10262
     C                   SETON                                        07                      E10262
     C                   END                                                                  S01091
     C***********CHAIN*TO*CLINT*TO GET ADDRESS                     S01091 S01194
0461 C***********          MOVELCNUM      CLIKEY                   S01091 S01194
0462 C***********CLIKEY    CHAINCLINT                78            S01091 S01194
     C***ENSURE*THAT A COPY STATEMENT IS NOT PRODUCED FOR          E12038 S01194
     C***A*DELETED ALTERNATE NAME AND ADDRESS                      E12038 S01194
     C********** *IN78     IFEQ '0'                                E12038 S01194
     C***********RECI      IFEQ '*'                                E12038 S01194
     C***********RECI      OREQ 'C'                                E12038 S01194
     C***********          GOTO ENDPS                              E12038 S01194
     C***********          END                                     E12038 S01194
     C***********          END                                     E12038 S01194
     C/COPY WNCPYSRC,GL0420C061
     C*                                                            E12038 S01194
     C* DETERMINE ADDRESS OF STATEMENT :-                                 LN0012
     C*   IF THE ADDRESS CODE IS 'B' USE THE ADDRESS ON THE CUSTOMER      LN0012
     C*   DETAILS FILE ELSE USE THE ALTERNATIVE ADDRESS DEFINED FOR       LN0012
     C*   THE CUSTOMER AND ADDRESS CODE ON THE ALTERNATIVE ADDRESS        LN0012
     C*   FILE.                                                           LN0012
     C*                                                            E12038 LN0012
     C********** ADTYP     IFEQ 'B'                                LN0012 LN0877
     C     W@ADRC        IFEQ      'B'                                                        LN0877
     C*                                                            E12038 LN0012
     C                   MOVE      *BLANKS       @KEY1                                        LN0012
     C                   MOVEL     CNUM          @KEY1                                        LN0012
     C******               CALL 'AOCUSTR0'                          LN0012CSD023
     C**********         CALL      'AOCUSTR2'                                         CSD023 CGL061A
     C                   CALLB     'AOCUSTR2'                                                CGL061A
     C                   PARM      '*MSG   '     @RTCD             7                          LN0012
     C                   PARM      '*KEY   '     @OPTN             7                          LN0012
     C                   PARM                    @KEY1            10                          LN0012
     C                   PARM                    @KYST             7                          LN0012
     C     SDCUST        PARM      SDCUST        DSLDY                                        CSD023
     C*****      SDCUST    PARM SDCUST    DSSDY                     LN0012CSD023
     C*                                                            E12038 LN0012
      ** If CSD023 is on, allow processing of a closed record (return     CSD023
      ** code '*NRF' and date deleted equal to zero).                     CSD023
      *                                                                   CSD023
     C     @RTCD         IFNE      *BLANKS                                                    LN0012
     C     @RTCD         ANDNE     '*NRF   '                                                  CSD023
     C     CSD023        ANDEQ     'Y'                                                        CSD023
      *                                                                                       248797
     C     @RTCD         ORNE      *BLANKS                                                    248797
     C     @RTCD         ANDNE     '*NRF   '                                                  248797
     C     CSD007        ANDEQ     'Y'                                                        248797
      *                                                                                       248797
     C     @RTCD         ORNE      *BLANKS                                                    CSD023
     C     @RTCD         ANDEQ     '*NRF   '                                                  CSD023
     C     BBDTDL        ANDNE     *ZEROS                                                     CSD023
     C     CSD023        ANDEQ     'Y'                                                        CSD023
      *                                                                                       248797
     C     @RTCD         ORNE      *BLANKS                                                    248797
     C     @RTCD         ANDEQ     '*NRF   '                                                  248797
     C     BBDTDL        ANDNE     *ZEROS                                                     248797
     C     CSD007        ANDEQ     'Y'                                                        248797
      *                                                                                       248797
     C     @RTCD         ORNE      *BLANKS                                                    CSD023
     C     CSD023        ANDNE     'Y'                                                        CSD023
     C     CSD007        ANDNE     'Y'                                                        248797
     C*                                                            E12038 LN0012
     C                   Z-ADD     26            DBASE                          *************  LN001
     C                   MOVEL     *BLANKS       DBKEY                          DATABASE ERROR LN001
     C                   MOVEL     CNUM          DBKEY                             26         LN0012
     C                   MOVE      'SDCUSTPD'    DBFILE                         *************  LN001
     C                   EXSR      *PSSR                                                      LN0012
     C                   GOTO      FINISH                                                     LN0012
     C                   END                                                                  LN0012
     C*                                                                   LN0012
     C     *LIKE         DEFINE    BBCNA1        @WCNA1                                       LN0012
     C     *LIKE         DEFINE    BBCNA2        @WCNA2                                       LN0012
     C     *LIKE         DEFINE    BBCNA3        @WCNA3                                       LN0012
     C     *LIKE         DEFINE    BBCNA4        @WCNA4                                       LN0012
     C                   MOVE      BBCNA1        @WCNA1                                       LN0012
     C                   MOVE      BBCNA2        @WCNA2                                       LN0012
     C                   MOVE      BBCNA3        @WCNA3                                       LN0012
     C                   MOVE      BBCNA4        @WCNA4                                       LN0012
     C*                                                                   LN0012
     C                   ELSE                                                                 LN0012
     C*                                                                   LN0012
     C**  OBTAIN THE CUSTOMER ADDRESS VIA THE ACCESS OBJECT 'AOALTNR0'    LN0012
     C*                                                                   LN0012
     C                   MOVE      CNUM          W@CNMA            6                          LN0012
     C**********         CALL      'AOALTNR0'                                         LN0012 CGL061A
     C                   CALLB     'AOALTNR0'                                                CGL061A
     C                   PARM      '*MSG   '     @RTCD             7                          LN0012
     C                   PARM      '*KEY   '     @OPTN             7                          LN0012
     C                   PARM      W@CNMA        @AENB             6                          LN0012
     C                   PARM      W@ADRC        @AZCD             1                          LN0012
     C     SDALTN        PARM      SDALTN        DSFDY                                        LN0012
     C     @RTCD         IFNE      *BLANKS                                                    LN0012
     C*  ENSURE THAT A COPY STATEMENT IS NOT PRODUCED FOR                 E12038
     C*  A DELETED ALTERNATE NAME AND ADDRESS                             E12038
     C                   GOTO      ENDPS                                                      E12038
     C                   END                                                                  S01194
     C*                                                                   LN0012
     C                   MOVE      BCCNA1        @WCNA1                                       LN0012
     C                   MOVE      BCCNA2        @WCNA2                                       LN0012
     C                   MOVE      BCCNA3        @WCNA3                                       LN0012
     C                   MOVE      BCCNA4        @WCNA4                                       LN0012
     C*                                                                   LN0012
     C                   END                                                                  LN0012
     C*                                                                   E12038
     C************IN78     IFEQ '1'                                S01091 S01194
0463 C***********          MOVE BLANK     CNA1                     S01091 S01194
0464 C***********          MOVE BLANK     CNA2                     S01091 S01194
0465 C***********          MOVE BLANK     CNA3                     S01091 S01194
0466 C***********          MOVE BLANK     CNA4                     S01091 S01194
0467 C***********          MOVELNFOUND    CNA1                     S01091 S01194
     C***********          MOVE CLIKEY    CNA1                     S01091 S01194
     C***********          END                                     S01091 S01194
0555 C*
0556 C*
     C*                                                                   S01408
     C/COPY WNCPYSRC,GL0420CP34                                           S01408
     C*                                                                   S01408
0557 C*
     C     CONT          TAG                                                                  LN0012
0558 C*
0559 C*    SETON INDICATORS FOR INITIAL PRINT
0560 C                   SETON                                        5046
     C/COPY WNCPYSRC,GL0420C041
0561 C*
0562 C*    SET INDICATORS FOR PRINT
0563 C                   EXSR      SETONS
     C/COPY WNCPYSRC,GL0420C042
0564 C*    SETUP FIELDS FOR TYPE 5
0565 C*
0566 C     CFSB          COMP      0                                  17
     C/COPY WNCPYSRC,GL0420C082
     C***87N45***          Z-ADDCFCB      CFBF   150                      S01161
0567 C***********          Z-ADDCFCB      CLBAL  150                      S01161
0568 C***********          Z-ADDCFCB      VDCBBF 150                      S01161
0569 C***********          Z-ADDCFCB      CLBF   150 28                   S01161
     C***87N45***          Z-ADDYTDB      CFBF   150                S01161E26793
0567 C***********          Z-ADDYTDB      CLBAL  150                S01161E26793
0568 C***********          Z-ADDYTDB      VDCBBF 150                S01161E26793
0569 C***********          Z-ADDYTDB      CLBF   150 28             S01161E26793
     C***87N45***          Z-ADDCFCB      CFBF   150               E26793 056524
0567 C***********          Z-ADDCFCB      CLBAL  150               E26793 056524
0568 C***********          Z-ADDCFCB      VDCBBF 150               E26793 056524
0569 C***********          Z-ADDCFCB      CLBF   150 28            E26793 056524
     C/COPY WNCPYSRC,GL0420C083
     C   87
     CANN45              Z-ADD     YTDB          CFBF             15 0                        056524
0567 C                   Z-ADD     YTDB          CLBAL            15 0                        056524
0568 C                   Z-ADD     YTDB          VDCBBF           15 0                        056524
0569 C                   Z-ADD     YTDB          CLBF             15 028                      056524
     C/COPY WNCPYSRC,GL0420C084
0570 C                   Z-ADD     0             VDCR             13 0
0571 C                   Z-ADD     0             VDDR             13 0
0572 C                   Z-ADD     0             PSCR             13 0
0573 C                   Z-ADD     0             PSDR             13 0
0574 C                   Z-ADD     0             NCR               3 0
0575 C                   Z-ADD     0             NDR               3 0
0576 C                   Z-ADD     LSTD          VDCD              5 0
0577 C                   Z-ADD     0             I                 2 0
0578 C                   Z-ADD     0             VDAR
0579 C                   Z-ADD     0             VCAR
0580 C                   Z-ADD     0             VDOF             13 0
0581 C                   Z-ADD     0             VCOF             13 0
     C*                                                                   S01408
     C/COPY WNCPYSRC,GL0420CP49                                           S01408
     C                   Z-add     1             @PAGECTR                                     CGL188
     C*                                                                   S01408
0582 C*
0583 C*    SET PAGE COUNTER AND ADD CARRIED FORWARD BALANCE.
0584 C******     LSTP      ADD  1         LSTP                            S01091
0585 C******               Z-ADDLSTP      STPA    30                      S01091
0586 C     LSTP          IFEQ      999                                                        E24147
0586 C                   Z-ADD     1             LSTPX                                        E24147
     C/COPY WNCPYSRC,GL0420CX30                                           S01408
0586 C                   ELSE                                                                 E24147
0584 C     LSTP          ADD       1             LSTPX             3 0                        S01091
     C/COPY WNCPYSRC,GL0420CX31                                           S01408
0586 C                   END                                                                  E24147
     C/COPY WNCPYSRC,GL0420CY32                                           S01408
0586 C*                                                                   E24147
0585 C                   Z-ADD     LSTPX         STPA              3 0                        S01091
     C/COPY WNCPYSRC,GL0420CY34                                           S01408
0586 C*
0587 C                   Z-ADD     CFSB          PSTBAL           15 047
0588 C                   Z-ADD     CFSB          PSTBF            15 083
     C/COPY WNCPYSRC,GL0420C078
0589 C*
0590 C*    ZEROISE LINE COUNTER.
0591 C                   Z-ADD     0             LINCNT            2 0
0592 C*
     C*    FORMAT OPENING BALANCE                                         CEU013
     C     CEU013        IFEQ      'Y'                                                        CEU013
     C     EUSB          IFEQ      'Y'                                                        CEU013
     C     CCY           ANDNE     BKEURO                                                     173551
     C                   SETON                                        10                      CEU013
     C                   CALL      'EU0200'                                                   CEU013
     C                   PARM      *BLANK        P@RTCD            7                          CEU013
     C/COPY WNCPYSRC,GL0420C090
     C                   PARM      PSTBF         P@FRAM           18 3                        CEU013
     C/COPY WNCPYSRC,GL0420C091
     C                   PARM      CCY           P@FRCY            3                          CEU013
     C                   PARM      BKEURO        P@TOCY            3                          CEU013
     C     EUPBF         PARM                    P@OUTA           15 0                        CEU013
     C                   PARM                    P@INTA           18 3                        CEU013
     C                   PARM                    P@EXRT           15 9                        CEU013
     C                   PARM                    P@MDIN            1                          CEU013
     C*                                                                   CEU013
     C*    DETERMINE NO. OF DECIMAL PLACES                                CEU013
     C**********         CALL      'AOCURRR0'                                         CEU013 CGL061A
     C                   CALLB     'AOCURRR0'                                                CGL061A
     C                   PARM      *BLANKS       UUAPRC            7                          CEU013
     C                   PARM      '*KEY'        UUAPOP            7                          CEU013
     C                   PARM      BKEURO        UUCYCD            3                          CEU013
     C     SDCURR        PARM      SDCURR        DSSDY                                        CEU013
     C*                                                                   CEU013
     C     UUAPRC        IFNE      *BLANKS                                                    CEU013
     C                   MOVEL     'SDCURRPD'    DBFILE                         ************   CEU01
     C                   MOVEL     BKEURO        DBKEY                          * DBERR 10 *   CEU01
     C                   Z-ADD     10            DBASE                          ************   CEU01
     C                   EXSR      *PSSR                                                      CEU013
     C                   ELSE                                                                 CEU013
     C     A6NBDP        IFEQ      0                                                          CEU013
     C                   MOVE      '1'           *INKA                                        CEU013
     C                   ENDIF                                                                CEU013
     C     A6NBDP        IFEQ      1                                                          CEU013
     C                   MOVE      '1'           *INKB                                        CEU013
     C                   ENDIF                                                                CEU013
     C     A6NBDP        IFEQ      2                                                          CEU013
     C                   MOVE      '1'           *INKC                                        CEU013
     C                   ENDIF                                                                CEU013
     C     A6NBDP        IFEQ      3                                                          CEU013
     C                   MOVE      '1'           *INKD                                        CEU013
     C                   ENDIF                                                                CEU013
     C                   ENDIF                                                                CEU013
     C*                                                                   CEU013
     C                   ELSE                                                                 CEU013
     C                   SETOFF                                       10                      CEU013
     C                   ENDIF                                                                CEU013
     C                   ENDIF                                                                CEU013
     C*                                                                   CFT004
     C** Format International Bank Account Numbers                        CFT004
     C*                                                                   CFT004
     C                   MOVE      '0'           *IN05                                        CFT004
     C                   MOVEL     *BLANKS       RIBAN                                        CFT004
     C     CFT004        IFEQ      'Y'                                                        CFT004
     C     IBAN          ANDNE     *BLANKS                                                    CFT004
     C**********         CALL      'AOIBANR3'                                         CFT004 CGL061A
     C                   CALLB     'AOIBANR3'                                                CGL061A
     C                   PARM      *BLANKS       PRTCD             7                          CFT004
     C                   PARM      IBAN          PIBAN            47                          CFT004
     C                   PARM      *BLANKS       PIWITH           47                          CFT004
     C                   PARM      *BLANKS       PINOBL           34                          CFT004
      *                                                                   CFT004
     C     PRTCD         IFEQ      *BLANKS                                                    CFT004
     C                   MOVE      '1'           *IN05                                        CFT004
     C                   MOVEL     PIWITH        RIBAN            47                          CFT004
     C                   ENDIF                                                                CFT004
      *                                                                   CFT004
     C                   ENDIF                                                                CFT004
      *                                                                   CFT004
     C*    OUTPUT REPORT HEADERS
     C*                                                                   S01408
     C/COPY WNCPYSRC,GL0420CCP8                                           S01408
     C*                                                                   S01408
     C                   EXCEPT
     C*                                                                   S01408
     C/COPY WNCPYSRC,GL0420CCP9                                           S01408
     C*                                                                   S01408
     C                   SETOFF                                       506061
     C                   SETOFF                                       626364
     C                   SETOFF                                       656667
     C                   SETOFF                                       808187
     C                   SETOFF                                       89
0593 C*
0594 C**** DETERMINE IF ACCOUNT HAS A POSTING                             S01091
0595 C***MR                GOTO FINISH                                    S01091
0596 C****                 GOTO ENDPRT                                    S01091
     C/SPACE 3
     C********************************************************************S01091
0597 C*                                                                   S01091
0598 C*****A POSTING HAS BEEN READ IS A STATEMENT DUE.                    S01091
0599 C*****      STMTAG    TAG                             ** STMTAG TAG *S01091
0600 C****                                                                S01091
     C***TO PRODUCE DATABASE ERROR IF NO SSTPO TRAILER PRESENT            S01091
     C*****                SETON                     82                   S01091
0601 C*****INCREASE COUNT OF POSTINGS AND HASH TOTAL POSTING AMOUNTS      S01091
0602 C*****      TNPR      ADD  1         TNPR                            S01091
0603 C*****                                                               S01091
0604 C*****HASH TOTAL                                                     S01091
0605 C*****- BYPASS IF RATE CHANGE POSTING                                S01091
0606 C***04                GOTO RCPOST                                    S01091
0607 C*****      PSTA      DIV  1000      PSTA03 133                      S01091
0608 C*****                Z-ADDPSTA03    ZZAMT                           S01091
0609 C*****                                                               S01091
0610 C*****                Z-ADDHPTI      ZZTOTI                          S01091
0611 C*****                Z-ADDHPTD      ZZTOTD                          S01091
0612 C*****                                                               S01091
0613 C*****                EXSR GLZADD                                    S01091
0614 C*****                                                               S01091
0615 C*****                Z-ADDZZTOTI    HPTI                            S01091
0616 C*****                Z-ADDZZTOTD    HPTD                            S01091
0617 C*****                                                               S01091
0619 C*****      RCPOST    TAG                             ** RCPOST TAG  S01091
0620 C*****                TESTB'6'       CUOR           38               S01091
0621 C*****                TESTB'7'       CUOR           39               S01091
0622 C*****                                                               S01091
0623 C*****IF NO STATEMENT DUE AND NOT YET PRINTED OR RETAIL              S01091
0624 C*****AND NOT END OF PERIOD WRITE TO FILE POSTO                      S01091
0625 C*****OTHERWISE IF NOT DUE GOTO FINISH                               S01091
0626 C***MR                GOTO STM2                                      S01091
0627 C*****      STM1      TAG                             ** STM1 TAG  **S01091
0628 C**N39                                                               S01091
0629 C*R*21N38             SETON                     53                   S01091
0634 C*****                                                               S01091
0635 C*****HASH TOTAL POSTO FILE, NOT FOR RATE CHANGE POSTING             S01091
0636 C***53 04   1         ADD  TNPO      TNPO                            S01091
0637 C***53N04             EXSR POSH                                      S01091
0638 C**NMR                GOTO FINISH                                    S01091
0639 C*****                GOTO ENDPRT                                    S01091
0640 C*****                                                               S01091
0641 C*****TEST STATEMENT FREQUENCY AND POSTING DATE                      S01091
0642 C*****      STM2      TAG                             ** STM2 TAG  **S01091
0643 C*****      STFQ      COMP 'A'                      55               S01091
0644 C***35      PSTD      COMP RUND                 56                   S01091
0645 C**N35      PSTD      COMP APDA                 56                   S01091
0646 C*****      PSTD      COMP RUND                 57                   S01091
0647 C*****ADDITIONAL PROCESSING FOR FORMAT 5.                            S01091
0648 C***39 40             TESTB'5'       CUOR           88               S01091
0649 C***39 40N88                                                         S01091
     C*NN04                EXSR FORM5                                     S01091
0650 C***39 40N88                                                         S01091
     C*NN04                SETON                     74                   S01091
0651 C*****                                                               S01091
0652 C*****STATEMENT FREQ 'A' AND POSTING DATE GOTO STM1 TAG              S01091
0653 C***55 56             GOTO STM1                                      S01091
0654 C*****                                                               S01091
0655 C*****                                                               S01091
0656 C*****                                                               S01091
0657 C*****STATEMENT FREQ NOT 'A' AND POSTING DATE GREATER THAN RUND      S01091
0658 C**N55 57             GOTO STM1                                      S01091
0659 C*****                                                               S01091
0660 C*****IF POSTING ALREADY APPEARED STATEMENT BYPASS PRINT             S01091
0661 C***39                GOTO STM3                                      S01091
0662 C*****                SETON                     5149                 S01091
0663 C*****AFTER FIRST POST, STOP INITIAL CLEARING PRINT.                 S01091
0664 C***75                SETOF                     75                   S01091
0665 C*****      VDS       TAG                             * VDS TAG *    S01091
0666 C***74      I         ADD  1         I                               S01091
0667 C***74      VDCD      ADD  1         VDCD                            S01091
0668 C***74      I         COMP 60                   88                   S01091
0669 C***74 88   I         SUB  60        I                               S01091
0670 C***74      VDCD      COMP PSTD                     88               S01091
0671 C***74 88             GOTO VDO                                       S01091
0672 C***74      VDDR      ADD  VDAR,I    VDDR                            S01091
0673 C***74      VDCR      ADD  VCAR,I    VDCR                            S01091
0674 C***74      VDCBBF    ADD  VDAR,I    VDCBBF                          S01091
0675 C***74      VDCBBF    SUB  VCAR,I    VDCBBF                          S01091
0676 C***74                Z-ADD0         VDAR,I                          S01091
0677 C***74                Z-ADD0         VCAR,I                          S01091
0678 C***74                GOTO VDS                                       S01091
0679 C*****      VDO       TAG                             * VDO TAG *    S01091
0680 C***74      VDDR      COMP 0                    75                   S01091
0681 C***74N75   VDCR      COMP 0                    75                   S01091
0682 C***74 75             Z-ADDVDCBBF    CLBAL                           S01091
0683 C***74 75   VDCBBF    COMP 0                    32                   S01091
0684 C***74 75   LINCNT    ADD  1         LINCNT                          S01091
0685 C***74                SETOF                     74                   S01091
0686 C*****IF NO CLEARINGS FROM LAST STMT.                                S01091
0687 C*****SET VDCD EQ. PSTD, & I EQ. TO 1.                               S01091
0688 C*****      I         COMP 0                        88               S01091
0689 C***88                Z-ADD1         I                               S01091
0690 C***88                Z-ADDPSTD      VDCD                            S01091
0691 C*****                                                               S01091
0692 C*****UPDATE POSTING BIT IF APPLICABLE                               S01091
0693 C***59                BITON'7'       CUOR                            S01091
0694 C*****                                                               S01091
0695 C*****ADD POSTING ENTRY TO BALANCE                                   S01091
0696 C***22N04   PSTBAL    SUB  PSTA      PSTBAL     47                   S01091
0697 C***23N04   PSTA      ADD  PSTBAL    PSTBAL     47                   S01091
0698 C****                 SETON                     29                   S01091
0699 C***40N04             EXSR FORM5                                     S01091
0700 C***40 22N04NCR       ADD  1         NCR                             S01091
0701 C***40 22N04PSCR      ADD  PSTA      PSCR                            S01091
0702 C***40 23N04NDR       ADD  1         NDR                             S01091
0703 C***40 23N04PSDR      ADD  PSTA      PSDR                            S01091
0704 C****                                                                S01091
0705 C****                                                                S01091
0706 C**** CONVERT VALUE DATE AND POSTING DATE.                           S01091
0707 C****                 Z-ADDVALD      ZDAYNO  50                      S01091
0708 C****                 EXSR ZDATE2                                    S01091
0709 C****                 MOVE ZADATE    VALDA   7                       S01091
0710 C****                                                                S01091
0711 C****                 Z-ADDPSTD      ZDAYNO                          S01091
0712 C****                 EXSR ZDATE2                                    S01091
0713 C****                 MOVE ZADATE    PSTDA   7                       S01091
0714 C****       PSTDA     COMP VALDA                6969                 S01091
0715 C****                                                                S01091
0716 C**** DETERMINE IF NEW PAGE NEEDED FOR STATEMENT                     S01091
0717 C****       STPA      COMP LSTP                     48               S01091
0718 C****       LINCNT    ADD  1         LINCNT                          S01091
0719 C**N48      LINCNT    COMP 1                        50               S01091
0720 C****                                                                S01091
0721 C**** SET INDICATORS FOR PRINT                                       S01091
0722 C****                 EXSR SETONS                                    S01091
0727 C****                                                                S01091
0728 C**** IF END OF PAGE INCREMENT LSTP AND ZEROISE LINE COUNTER         S01091
0729 C**SAVE BALANCE FOR NEW PAGE                                         S01091
0730 C****       STM3      TAG                             ** STM3 TAG  **S01091
0731 C**IF STATEMENT NOT DUE                                              S01091
0732 C**** OR RETAIL AND NOT END OF PERIOD WRITE TO POSTO FILE            S01091
0733 C**N59                                                               S01091
0734 C*R*21N38N79          SETON                     53                   S01091
0735 C**** SET ON 'APPEARED IN CLEARED BALANCE INDICATOR' FOR ALL         S01091
0736 C**** RETAIL ACCOUNT POSTINGS TO BE WRITTEN TO APOST IF FORMAT 5     S01091
0737 C**** IS NOT USED, AND NOT A MANAGEMENT STATEMENT                    S01091
0738 C***53 21N40                                                         S01091
0738 C*NN34                BITON'5'       CUOR                            S01091
0739 C****                                                                S01091
0740 C**** HASH TOTAL POSTO                                               S01091
0741 C***53                EXSR POSH                                      S01091
     C*    DETERMINE USING LOOK-AHEAD FIELDS IF MORE POSTINGS             S01091
     C*    FOR ACCOUNT                                                    S01091
     C*          MATCH     COMP MATCHL                   58               S01091
     C*    IF MORE POSTINGS FOR THIS ACCOUNT , CHECK FOR FULL PAGE        S01091
     C* N58                GOTO SAR                                       S01091
0597 C*                                                                   S01091
0598 C*    A STATEMENT HAS BEEN READ,READ POSTINGS                        S01091
     C/COPY WNCPYSRC,GL0420C025                                           S01408
0599 C     STMTAG        TAG                                                    ** STMTAG TAG *S0109
     C                   SETOFF                                       1502                    S01091
     C/COPY WNCPYSRC,GL0420CX34                                           S01408
     C                   MOVE      '0'           *IN52                                        E32012
     C*                                                                   S01408
     C/COPY WNCPYSRC,GL0420CP53                                           S01408
     C*                                                                   S01408
     C     MATCH         SETLL     APOST                                                      S01091
     C*                                                                   S01408
     C/COPY WNCPYSRC,GL0420CP52                                           S01408
     C*                                                                   S01408
     C     *IN15         DOUEQ     '1'                                                        S01091
     C/COPY WNCPYSRC,GL0420C001
     C                   SETOFF                                       0406                    S01091
     C*                                                                   S01408
     C/COPY WNCPYSRC,GL0420CP51                                           S01408
     C*                                                                   S01408
     C     MATCH         READE     APOST                                1515                  S01091
     C*                                                                   S01408
     C/COPY WNCPYSRC,GL0420CP50                                           S01408
     C*                                                                   S01408
     C   15
     CAN 02              GOTO      SAR                                                        S01091
     C                   SETON                                        02                      S01091
     C*                                                                   S01408
     C/COPY WNCPYSRC,GL0420CP59                                           S01408
     C*                                                                   S01408
     C** CHAIN TO REIAC - CHECK THE INTEREST TYPE OF THE RATE             E16612
     C** CHANGE POSTING IS ZERO.                                          E16612
     C*                                                                   E16612
     C     *IN04         IFEQ      '1'                                                        E16612
     C*********  MATCH     CHAINREIAC                09             E16612BHF092
     C     ACKEY         CHAIN     REIAC                              09                      BHF092
     C     *IN09         IFEQ      '1'                                                        E16612
     C                   Z-ADD     17            DBASE                          ***************E1661
     C                   MOVE      BLANK         DBKEY                          DATABASE ERROR E1661
     C                   MOVEL     MATCH         DBKEY                             17         E16612
     C                   MOVEL     'REIAC'       DBFILE                         ***************E1661
     C                   SETON                                        U7U8LR                  E16612
     C                   GOTO      END                                                        E16612
     C                   END                                                                  E16612
     C                   END                                                                  E16612
     C*    BYPASS IF RATE CHANGE POSTING AND RATE CHANGE PRINTING         S01110
     C*    NOT REQUIRED                                                   S01110
     C   04
     CAN 12              GOTO      STM3                                                       S01110
     C/COPY WNCPYSRC,GL0420CX35                                           S01408
     C**                                                                  E16612
     C*    BYPASS IF RATE CHANGE POSTING AND INTEREST TYPE IS NOT         E16612
     C*    ZERO.                                                          E16612
     C*                                                                   E16612
     C     *IN04         IFEQ      '1'                                                        E16612
     C     *IN22         IFEQ      '1'                                                        E16612
     C     CICT          COMP      '00'                               0808                    E16612
     C   08              GOTO      STM3                                                       E16612
     C                   ELSE                                                                 E16612
     C     *IN23         IFEQ      '1'                                                        E16612
     C     DICT          COMP      '00'                               0808                    E16612
     C   08              GOTO      STM3                                                       E16612
     C                   END                                                                  E16612
     C                   END                                                                  E16612
     C                   END                                                                  E16612
0747 C*    CHECK FOR FULL PAGE                                            S01091
     C*                                                                   S01408
     C/COPY WNCPYSRC,GL0420CP19                                           S01408
     C*                                                                   S01408
0749 C   41                                                                                   S01091
0750 C*R*43******LINCNT    COMP 43                       45        S01091 216937
0750 COR 43LINCNT        COMP      43                                 45  45                  216937
     C/COPY WNCPYSRC,GL0420C024
0751 C***40******LINCNT    COMP 31                       45        S01091 216937
0751 C   40LINCNT        COMP      31                                 45  45                  216937
     C/COPY WNCPYSRC,GL0420C021
0752 C***42******LINCNT    COMP 33                       45        S01091 216937
0752 C   42LINCNT        COMP      33                                 45  45                  216937
     C*
     C** Core hook for externalisation.                                   S01408
     C/COPY WNCPYSRC,GL0420CADL                                           S01408
     C*
0753 C***44******LINCNT    COMP 30                       45        S01091 216937
0753 C   44LINCNT        COMP      30                                 45  45                  216937
0754 C*                                                                   S01091
0755 C*                                                                   S01091
0756 C*    IF END OF PAGE INCREMENT LSTP AND ZEROISE LINE COUNTER         S01091
     C*                                                                   S01408
     C/COPY WNCPYSRC,GL0420CP20                                           S01408
     C*                                                                   S01408
0757 C   45STPA          ADD       1             STPA                                         S01091
     C*                                                                   S01408
     C/COPY WNCPYSRC,GL0420CP21                                           S01408
     C   45@PAGECTR      ADD       1             @PAGECTR                                     CGL188
     C*                                                                   S01408
0758 C   40              Z-ADD     LINCNT        FFLCNT            2 0                        S01091
0759 C   45              Z-ADD     0             LINCNT                                       S01091
0760 C***45******          MOVE PSTDA     LSTDA                    S01091 044472
     C   45              MOVEL     'CONTD. '     LSTDA                                        044472
     C/COPY WNCPYSRC,GL0420C055
0761 C* SAVE BALANCE FOR NEW PAGE                                         S01091
     C* TO ENSURE DR INDICATOR INCLUDED ON BFWD FIGURES                   S01091
     C   45              Z-ADD     PSTBAL        PSTBF                83                      S01091
     C/COPY WNCPYSRC,GL0420C092
     C   40
0763 CAN 45              Z-ADD     CLBAL         CFBF             15 028                      S01091
     C/COPY WNCPYSRC,GL0420C093
0765 C                   SETOFF                                       88L1                    S01091
0766 C     PSTD          COMP      PSTDP                              L1L188                  S01091
     C*                                                                   CEU013
     C*    CONVERT CLOSING BALANCE INTO EUROS IF EMU SWITCHABLE FEATURE   CEU013
     C*    PRESENT.                                                       CEU013
     C     CEU013        IFEQ      'Y'                                                        CEU013
     C     EUSB          IFEQ      'Y'                                                        CEU013
     C     CCY           ANDNE     BKEURO                                                     173551
     C                   SETON                                        10                      CEU013
     C*                                                                   CEU013
     C                   CALL      'EU0200'                                                   CEU013
     C                   PARM      *BLANK        P@RTCD            7                          CEU013
     C/COPY WNCPYSRC,GL0420C094
     C                   PARM      PSTBAL        P@FRAM           18 3                        CEU013
     C/COPY WNCPYSRC,GL0420C095
     C                   PARM      CCY           P@FRCY            3                          CEU013
     C                   PARM      BKEURO        P@TOCY            3                          CEU013
     C     EUPBAL        PARM                    P@OUTA           15 0                        CEU013
     C                   PARM                    P@INTA           18 3                        CEU013
     C                   PARM                    P@EXRT           15 9                        CEU013
     C                   PARM                    P@MDIN            1                          CEU013
     C*                                                                   CEU013
     C* If end of page, move C/F Euro bal. to B/F Euro bal. of next page  143155
     C     *IN45         IFEQ      *ON                                                        143155
     C                   Z-ADD     EUPBAL        EUPBF                                        143155
     C                   ENDIF                                                                143155
     C*                                                                   143155
     C**********         CALL      'AOCURRR0'                                         CEU013 CGL061A
     C                   CALLB     'AOCURRR0'                                                CGL061A
     C                   PARM      *BLANKS       UUAPRC            7                          CEU013
     C                   PARM      '*KEY'        UUAPOP            7                          CEU013
     C                   PARM      BKEURO        UUCYCD            3                          CEU013
     C     SDCURR        PARM      SDCURR        DSSDY                                        CEU013
     C*                                                                   CEU013
     C     UUAPRC        IFNE      *BLANKS                                                    CEU013
     C                   MOVEL     'SDCURRPD'    DBFILE                         ************   CEU01
     C                   MOVEL     BKEURO        DBKEY                          * DBERR 08 *   CEU01
     C                   Z-ADD     08            DBASE                          ************   CEU01
     C                   EXSR      *PSSR                                                      CEU013
     C                   ELSE                                                                 CEU013
     C     A6NBDP        IFEQ      0                                                          CEU013
     C                   MOVE      '1'           *INKA                                        CEU013
     C                   ENDIF                                                                CEU013
     C     A6NBDP        IFEQ      1                                                          CEU013
     C                   MOVE      '1'           *INKB                                        CEU013
     C                   ENDIF                                                                CEU013
     C     A6NBDP        IFEQ      2                                                          CEU013
     C                   MOVE      '1'           *INKC                                        CEU013
     C                   ENDIF                                                                CEU013
     C     A6NBDP        IFEQ      3                                                          CEU013
     C                   MOVE      '1'           *INKD                                        CEU013
     C                   ENDIF                                                                CEU013
     C                   ENDIF                                                                CEU013
     C*                                                                   CEU013
     C                   ELSE                                                                 CEU013
     C                   SETOFF                                       10                      CEU013
     C                   ENDIF                                                                CEU013
     C                   ENDIF                                                                CEU013
     C*                                                                   S01408
     C/COPY WNCPYSRC,GL0420CP10                                           S01408
     C*                                                                   S01408
     C   45              EXCEPT    ENDPG                                                      S01091
     C*                                                                   S01408
     C/COPY WNCPYSRC,GL0420CP11                                           S01408
     C*                                                                   S01408
0764 C     SAR           TAG                                                                  S01091
     C/COPY WNCPYSRC,GL0420C037
     C   88
0767 CANN15                                                                                   S01091
0768 CORN40                                                                                   S01091
     COR 74
0769 CANN15              GOTO      CLBP                                                       S01091
0770 C**                                                                  S01091
0771 C**   FOR FORM,X EQ. 5 :-                                            S01091
0772 C**   ON LAST POSTING BEFORE POSTING DATE CHANGE,                    S01091
0773 C**   UPDATE CLEARED BALANCE AND CLEAR OUT ARRAY ELEMENTS            S01091
0774 C**   WHICH HAVE BEEN USED TO DO THIS.                               S01091
0775 C**   ACCUMULATE ALL CLEARING ON PSTD.                               S01091
0776 C**                                                                  S01091
     C** IF I EQ 0 NOW IT IS POSSIBLE THAT POSTINGS WHOSE V DATES FALL IN S01091
     C** WITHIN THIS STATEMENT PERIOD BUT HAVE BEEN PRINTED IN PREVIOUS   S01091
     C**STATEMENTS HAVE ADDED AMTS INTO VDAR/VCAR-ROLL THRU I JUST IN CASES01091
     C     I             COMP      0                                      88                  S01091
     C   88              Z-ADD     1             I                                            S01091
     C   88LSTD          ADD       1             VDCD                                         S01091
0780 C     CLBAL         ADD       VDAR(I)       CLBAL                                        S01091
0781 C     CLBAL         SUB       VCAR(I)       CLBAL                                        S01091
     C/COPY WNCPYSRC,GL0420C096
0782 C**   CLEAR OUT THESE ELEMENTS.                                      S01091
0783 C                   Z-ADD     0             VDAR(I)                                      S01091
0784 C                   Z-ADD     0             VCAR(I)                                      S01091
0785 C**   INCREMENT INDEX AND CONTROL DATE.                              S01091
0786 C     I             ADD       1             I                                            S01091
0787 C     VDCD          ADD       1             VDCD                                         S01091
0788 C**   WRAP AROUND INDEX.                                             S01091
0789 C     I             COMP      60                                 88                      S01091
0790 C   88I             SUB       60            I                                            S01091
0791 C     CLBAL         COMP      0                                  37                      S01091
0792 C     CLBP          TAG                                                    * CLBP TAG *   S0109
     C/COPY WNCPYSRC,GL0420C053
     C   15              GOTO      NEX                                                        S01091
     C/COPY WNCPYSRC,GL0420C011
     C*                                                                   CEU013
     C*    CONVERT CLOSING BALANCE INTO EUROS IF EMU SWITCHABLE FEATURE   CEU013
     C*    PRESENT.                                                       CEU013
     C     CEU013        IFEQ      'Y'                                                        CEU013
     C     EUSB          IFEQ      'Y'                                                        CEU013
     C     CCY           ANDNE     BKEURO                                                     173551
     C                   SETON                                        10                      CEU013
     C*                                                                   CEU013
     C                   CALL      'EU0200'                                                   CEU013
     C                   PARM      *BLANK        P@RTCD            7                          CEU013
     C/COPY WNCPYSRC,GL0420C097
     C                   PARM      PSTBAL        P@FRAM           18 3                        CEU013
     C/COPY WNCPYSRC,GL0420C098
     C                   PARM      CCY           P@FRCY            3                          CEU013
     C                   PARM      BKEURO        P@TOCY            3                          CEU013
     C     EUPBAL        PARM                    P@OUTA           15 0                        CEU013
     C                   PARM                    P@INTA           18 3                        CEU013
     C                   PARM                    P@EXRT           15 9                        CEU013
     C                   PARM                    P@MDIN            1                          CEU013
     C*                                                                   CEU013
     C**********         CALL      'AOCURRR0'                                         CEU013 CGL061A
     C                   CALLB     'AOCURRR0'                                                CGL061A
     C                   PARM      *BLANKS       UUAPRC            7                          CEU013
     C                   PARM      '*KEY'        UUAPOP            7                          CEU013
     C                   PARM      BKEURO        UUCYCD            3                          CEU013
     C     SDCURR        PARM      SDCURR        DSSDY                                        CEU013
     C*                                                                   CEU013
     C     UUAPRC        IFNE      *BLANKS                                                    CEU013
     C                   MOVEL     'SDCURRPD'    DBFILE                         ************   CEU01
     C                   MOVEL     BKEURO        DBKEY                          * DBERR 08 *   CEU01
     C                   Z-ADD     08            DBASE                          ************   CEU01
     C                   EXSR      *PSSR                                                      CEU013
     C                   ELSE                                                                 CEU013
     C     A6NBDP        IFEQ      0                                                          CEU013
     C                   MOVE      '1'           *INKA                                        CEU013
     C                   ENDIF                                                                CEU013
     C     A6NBDP        IFEQ      1                                                          CEU013
     C                   MOVE      '1'           *INKB                                        CEU013
     C                   ENDIF                                                                CEU013
     C     A6NBDP        IFEQ      2                                                          CEU013
     C                   MOVE      '1'           *INKC                                        CEU013
     C                   ENDIF                                                                CEU013
     C     A6NBDP        IFEQ      3                                                          CEU013
     C                   MOVE      '1'           *INKD                                        CEU013
     C                   ENDIF                                                                CEU013
     C                   ENDIF                                                                CEU013
     C*                                                                   CEU013
     C                   ELSE                                                                 CEU013
     C                   SETOFF                                       10                      CEU013
     C                   ENDIF                                                                CEU013
     C                   ENDIF                                                                CEU013
     C*                                                                   CEU013
     C/COPY WNCPYSRC,GL0420CBOY
     C   L1              EXCEPT    BAL                                                        S01091
     C/COPY WNCPYSRC,GL0420C012
0600 C*                                                                   S01091
     C*  TO PRODUCE DATABASE ERROR IF NO APOST TRAILER PRESENT            S01091
     C* REUSE 82 FOR CASH MGT GA                                          216006
     C***********          SETON                     82                   S01091
     C/COPY WNCPYSRC,GL0420C059
0620 C***********          TESTB'6'       CUOR           38        S01091 056524
0621 C***********          TESTB'7'       CUOR           39     S01091    S01161
     C     PSTD          IFLE      LSTD                                                       S01161
     C****       VALD      ANDLELSTD                               S01161 E16854
     C/COPY WNCPYSRC,GL0420C045
     C                   SETON                                        39                      S01161
     C                   ELSE                                                                 S01161
     C                   SETOFF                                       39                      S01161
     C                   END                                                                  S01161
     C*                                                                   E16854
     C*   Extra lines test for a newly opened account (DACO=LSTD), it     E16854
     C*  forces the posting on to the first statement (LSTP=0). Final     E16854
     C*  check ensures that if an account is reopened, previous post-     E16854
     C*  ings will not appear on statement.                               E16854
     C*                                                                   E16854
     C     DACO          IFEQ      LSTD                                                       E16854
     C     LSTP          ANDEQ     0                                                          E16854
     C     PSTD          ANDGE     LSTD                                                       E16854
     C                   SETOFF                                       39                      E16854
     C                   END                                                                  E16854
0622 C*                                                                   S01091
0641 C*    TEST STATEMENT FREQUENCY AND POSTING DATE                      S01091
0643 C     STFQ          COMP      'A'                                    55                  S01091
0644 C   35PSTD          COMP      RUND                               56                      S01091
0645 C**N35******PSTD      COMP APDA                 56            S01091 S01194
0645 C  N35PSTD          COMP      BKAPDT                             56                      S01194
0646 C     PSTD          COMP      RUND                               57                      S01091
     C/COPY WNCPYSRC,GL0420C105
0647 C*    ADDITIONAL PROCESSING FOR FORMAT 5.                            S01091
     C** Do not test CUOR since it is no longer updated to APOST          054770
     C** If VALD and PSTD are both less than or equaled to LSTD           054770
     C** do not include posting.                                          054770
     C*                                                                   054770
0648 C***39*40***          TESTB'5'       CUOR           88        S01091 054770
     C************IN39     IFLE '1'                                054770 055721
     C     *IN39         IFEQ      '1'                                                        055721
     C     *IN40         ANDEQ     '1'                                                        054770
     C     VALD          ANDLE     LSTD                                                       054770
     C/COPY WNCPYSRC,GL0420C046
     C                   SETON                                        88                      054770
     C                   ELSE                                                                 054770
     C                   SETOFF                                       88                      054770
     C                   END                                                                  054770
     C   39
     CAN 40
0649 CANN88                                                                                   S01091
     CANN04              EXSR      FORM5                                                      S01091
     C   39
     CAN 40
0650 CANN88                                                                                   S01091
     CANN04              SETON                                        74                      S01091
0651 C*                                                                   S01091
0659 C*                                                                   S01091
0660 C*    IF POSTING ALREADY APPEARED STATEMENT BYPASS PRINT             S01091
0661 C   39              GOTO      STM3                                                       S01091
     C/COPY WNCPYSRC,GL0420C109
0662 C                   SETON                                        5149                    S01091
0663 C*    AFTER FIRST POST, STOP INITIAL CLEARING PRINT.                 S01091
0664 C   75              SETOFF                                       75                      S01091
     C   74              Z-ADD     0             I                                            059213
     C   74              Z-ADD     LSTD          VDCD                                         059213
0665 C     VDS           TAG                                                    * VDS TAG *    S0109
0666 C   74I             ADD       1             I                                            S01091
0667 C   74VDCD          ADD       1             VDCD                                         S01091
0668 C   74I             COMP      60                                 88                      S01091
     C   74
0669 CAN 88I             SUB       60            I                                            S01091
0670 C   74VDCD          COMP      PSTD                                   88                  S01091
     C   74
0671 CAN 88              GOTO      VDO                                                        S01091
0672 C   74VDDR          ADD       VDAR(I)       VDDR                                         S01091
0673 C   74VDCR          ADD       VCAR(I)       VDCR                                         S01091
0674 C   74VDCBBF        ADD       VDAR(I)       VDCBBF                                       S01091
0675 C   74VDCBBF        SUB       VCAR(I)       VDCBBF                                       S01091
     C/COPY WNCPYSRC,GL0420C099
0676 C   74              Z-ADD     0             VDAR(I)                                      S01091
0677 C   74              Z-ADD     0             VCAR(I)                                      S01091
0678 C   74              GOTO      VDS                                                        S01091
0679 C     VDO           TAG                                                    * VDO TAG *    S0109
0680 C   74VDDR          COMP      0                                  75                      S01091
     C   74
0681 CANN75VDCR          COMP      0                                  75                      S01091
     C   74
0682 CAN 75              Z-ADD     VDCBBF        CLBAL                                        S01091
     C/COPY WNCPYSRC,GL0420C100
     C   74
0683 CAN 75VDCBBF        COMP      0                                  32                      S01091
     C*                                                                   S01408
     C/COPY WNCPYSRC,GL0420CP22                                           S01408
     C*                                                                   S01408
     C   74
0684 CAN 75LINCNT        ADD       1             LINCNT                                       S01091
     C*                                                                   S01408
     C/COPY WNCPYSRC,GL0420CP23                                           S01408
     C*                                                                   S01408
0685 C   74              SETOFF                                       74                      S01091
0686 C*    IF NO CLEARINGS FROM LAST STMT.                                S01091
0687 C*    SET VDCD EQ. PSTD, & I EQ. TO 1.                               S01091
0688 C     I             COMP      0                                      88                  S01091
0689 C   88              Z-ADD     1             I                                            S01091
0690 C   88              Z-ADD     PSTD          VDCD                                         S01091
     C/COPY WNCPYSRC,GL0420C085
0691 C*                                                                   S01091
0695 C*    ADD POSTING ENTRY TO BALANCE                                   S01091
     C   22
0696 CANN04PSTBAL        SUB       PSTA          PSTBAL               47                      S01091
     C   23
0697 CANN04PSTA          ADD       PSTBAL        PSTBAL               47                      S01091
     C/COPY WNCPYSRC,GL0420C086
0698 C                   SETON                                        29                      S01091
     C   40
0699 CANN04              EXSR      FORM5                                                      S01091
     C   40
     CAN 22
0700 CANN04NCR           ADD       1             NCR                                          S01091
     C*                                                                   S01408
     C/COPY WNCPYSRC,GL0420CP44                                           S01408
     C*                                                                   S01408
     C   40
     CAN 22
0701 CANN04PSCR          ADD       PSTA          PSCR                                         S01091
     C*                                                                   S01408
     C/COPY WNCPYSRC,GL04204C45                                           S01408
     C*                                                                   S01408
     C   40
     CAN 23
0702 CANN04NDR           ADD       1             NDR                                          S01091
     C*                                                                   S01408
     C/COPY WNCPYSRC,GL0420CP46                                           S01408
     C*                                                                   S01408
     C   40
     CAN 23
0703 CANN04PSDR          ADD       PSTA          PSDR                                         S01091
     C*                                                                   S01408
     C/COPY WNCPYSRC,GL0420CP47                                           S01408
     C*                                                                   S01408
0704 C*                                                                   S01091
     C*
     C** Core hook for externalisation.                                   S01408
     C/COPY WNCPYSRC,GL0420CCP5                                           S01408
     C*
0705 C*                                                                   S01091
0706 C*    CONVERT VALUE DATE AND POSTING DATE.                           S01091
0707 C                   Z-ADD     VALD          ZDAYNO            5 0                        S01091
0708 C                   EXSR      ZDATE2                                                     S01091
0709 C                   MOVE      ZADATE        VALDA             7                          S01091
     C/COPY WNCPYSRC,GL0420CX25                                           S01408
0710 C*                                                                   S01091
0711 C                   Z-ADD     PSTD          ZDAYNO                                       S01091
0712 C                   EXSR      ZDATE2                                                     S01091
0713 C                   MOVE      ZADATE        PSTDA             7                          S01091
     C/COPY WNCPYSRC,GL0420C033
0714 C     PSTDA         COMP      VALDA                              6969                    S01091
     C*                                                                   S01408
     C/COPY WNCPYSRC,GL0420CP24                                           S01408
     C*                                                                   S01408
     C*  Determine if group account                                       216937
     C                   MOVE      '0'           *IN53                                        216937
     C     CRE008        IFEQ      'Y'                                                        216937
     C     XRFI          IFNE      *BLANKS                                                    216937
     C     XRFN          ANDNE     *ZERO                                                      216937
     C     EXTKEY        CHAIN     GLAPSGL0                           24                      216937
     C     *IN24         IFEQ      '0'                                                        216937
     C     AGSRNO        IFGT      0                                                          216937
     C     W#ORAC        CAT       SRCRET:1      W#ORIG           40                          216937
     C                   ELSE                                                                 216937
     C     W#ORAC        CAT       SRCGL:1       W#ORIG                                       216937
     C                   ENDIF                                                                216937
     C                   MOVE      '1'           *IN53                                        216937
0718 C     LINCNT        ADD       1             LINCNT                                       216937
     C                   ENDIF                                                                216937
     C                   ENDIF                                                                216937
     C                   ENDIF                                                                216937
     C*                                                                   216937
     C*                                                                   CEU013
     C*    DETERMINE IF ORIGINAL AMOUNT AND CCY REQUIRED.                 CEU013
     C*                                                                   CEU013
     C     CEU013        IFEQ      'Y'                                                        CEU013
     C     XRFI          IFNE      *BLANKS                                                    CEU013
     C     XRFN          ANDNE     *ZERO                                                      CEU013
     C/COPY WNCPYSRC,GL0420C073
     C     EXTKEY        CHAIN     GLAPSTPF                           24                      CEU013
     C/COPY WNCPYSRC,GL0420C070
     C     *IN24         IFEQ      '0'                                                        CEU013
     C     OCCY          ANDNE     *BLANKS                                                 BUG22979A
     C     OAMT          ANDNE     *ZEROS                                                  BUG22979A
     C/COPY WNCPYSRC,GL0420C071
     C                   MOVEL     OCCY          ROCCY             3                          CEU013
     C*                                                                   CEU013
     C**********         CALL      'AOCURRR0'                                         CEU013 CGL061A
     C                   CALLB     'AOCURRR0'                                                CGL061A
     C                   PARM      *BLANKS       UUAPRC            7                          CEU013
     C                   PARM      '*KEY'        UUAPOP            7                          CEU013
     C                   PARM      OCCY          UUCYCD            3                          CEU013
     C     SDCURR        PARM      SDCURR        DSSDY                                        CEU013
     C*                                                                   CEU013
     C     UUAPRC        IFNE      *BLANKS                                                    CEU013
     C                   MOVEL     'SDCURRPD'    DBFILE                         ************   CEU01
     C                   MOVEL     BKEURO        DBKEY                          * DBERR 09 *   CEU01
     C                   Z-ADD     09            DBASE                          ************   CEU01
     C                   EXSR      *PSSR                                                      CEU013
     C                   ELSE                                                                 CEU013
     C     A6NBDP        IFEQ      0                                                          CEU013
     C                   MOVE      '1'           *INKE                                        CEU013
     C                   ENDIF                                                                CEU013
     C     A6NBDP        IFEQ      1                                                          CEU013
     C                   MOVE      '1'           *INKF                                        CEU013
     C                   ENDIF                                                                CEU013
     C     A6NBDP        IFEQ      2                                                          CEU013
     C                   MOVE      '1'           *INKG                                        CEU013
     C                   ENDIF                                                                CEU013
     C     A6NBDP        IFEQ      3                                                          CEU013
     C                   MOVE      '1'           *INKH                                        CEU013
     C                   ENDIF                                                                CEU013
     C                   ENDIF                                                                CEU013
      *                                                                   CEU013
     C                   Z-ADD     OAMT          ROAMT            15 0                        CEU013
     C                   SETON                                        78                      CEU013
     C/COPY WNCPYSRC,GL0420C072
     C                   ELSE                                                                 CEU013
     C                   SETOFF                                       78                      CEU013
     C                   ENDIF                                                                CEU013
     C                   ELSE                                                                 CEU013
     C                   SETOFF                                           78                  CEU013
     C                   ENDIF                                                                CEU013
     C*                                                                   CEU013
     C                   ENDIF                                                                CEU013
     C/COPY WNCPYSRC,GL0420C079
0715 C*                                                                   S01091
0716 C*    DETERMINE IF NEW PAGE NEEDED FOR STATEMENT                     S01091
0717 C     STPA          COMP      LSTPX                                  48                  S01091
     C/COPY WNCPYSRC,GL0420C074
0718 C     LINCNT        ADD       1             LINCNT                                       S01091
0719 C  N48LINCNT        COMP      1                                      50                  S01091
     C  N48
     CANN50
0719 CAN 53LINCNT        COMP      2                                      50                  216937
0720 C*                                                                   S01091
0721 C*    SET INDICATORS FOR PRINT                                       S01091
      *                                                                   S01408
     C/COPY WNCPYSRC,GL0420CP39                                           S01408
      *                                                                   S01408
0722 C                   EXSR      SETONS                                                     S01091
     C****************     EXCPTDET                                S01091 E10600
     C*                                                                   S01408
     C/COPY WNCPYSRC,GL0420CP12                                           S01408
     C*                                                                   S01408
     C   50              EXCEPT                                                               E10600
     C*                                                                   S01408
     C/COPY WNCPYSRC,GL0420CP13                                           S01408
     C*                                                                   S01408
     C                   SETOFF                                       506061                  S01091
     C                   SETOFF                                       626364                  S01091
     C                   SETOFF                                       656667                  S01091
     C                   SETOFF                                       808187                  S01091
     C                   SETOFF                                       89                      S01091
     C*                                                                   S01408
     C/COPY WNCPYSRC,GL0420CP14                                           S01408
     C*                                                                   S01408
     C                   EXCEPT    DET                                                        E10600
     C*                                                                   S01408
     C/COPY WNCPYSRC,GL0420CP15                                           S01408
     C*                                                                   S01408
0727 C*                                                                   S01091
0728 C*****IF*END*OF PAGE INCREMENT LSTP AND ZEROISE LINE COUNTER S01091  S01161
0729 C**SAVE*BALANCE FOR NEW PAGE                               S01091    S01161
0730 C     STM3          TAG                                                    ** STM3 TAG  **S0109
     C***UPDATE*FILES FOR LAST ADDRESS                          S01091    S01161
     C******     *IN84     IFEQ '1'                                       E10262
     C************IN07     IFEQ '1'                             E10262    S01161
     C*****IF*NOT*A MANAGEMENT STATEMENT                        S01091    S01161
     C************IN34     IFEQ '0'                             S01091    S01161
     C**AND*IF*RETAIL ACCOUNTS                                  S01091    S01161
     C***********ATYP      IFEQ 'R'                             S01091    S01161
     C***UPDATE*TODAYS BALANCE POSTINGS                         S01091    S01161
     C************IN06     IFEQ '1'                             S01091    S01161
     C***********PSTD      IFEQ RUND                            S01091    S01161
     C***********          BITON'7'       CUOR                  S01091    S01161
     C**N40******          BITON'5'       CUOR                  S01091    S01161
     C***********          EXCPTUPD                             S01091    S01161
     C***********          ELSE                                 S01091    S01161
     C***DELETE*PROCESSED NOT TODAYS POSTINGS                   S01091    S01161
     C***********          TESTB'6'       CUOR           10     S01091    S01161
     C***10******          TESTB'5'       CUOR           10     S01091    S01161
     C***10******          DELETAPOST                           S01091    S01161
     C***10******NODEL     ADD  1         NODEL                 S01091    S01161
     C***UPDATE*APPEARED ON STATEMENT BIT                       S01091    S01161
     C**N10******          BITON'7'       CUOR                  S01091    S01161
     C**N10******          EXCPTUPD                             S01091    S01161
     C***********          END                                  S01091    S01161
     C***DELETE*RATE CHANGE POSTINGS                            S01091    S01161
     C***********          ELSE                                 S01091    S01161
     C***********          DELETAPOST                           S01091    S01161
     C***********NODEL     ADD  1         NODEL                 S01091    S01161
     C***********          END                                  S01091    S01161
     C**NOT*RETAIL ACCOUNTS                                     S01091    S01161
     C***********          ELSE                                 S01091    S01161
     C***DELETE*NOT TODAYS POSTINGS                             S01091    S01161
     C***********          DELETAPOST                           S01091    S01161
     C***********NODEL     ADD  1         NODEL                 S01091    S01161
     C***********          END                                  S01091    S01161
     C***********          END                                  S01091    S01161
     C     NEX           TAG                                                                  S01091
     C***********          END                                  S01091    S01161
     C                   MOVE      PSTD          PSTDP             5 0                        S01091
     C                   END                                                                  S01091
     C/SPACE 3
     C********************************************************************
0742 C*
0743 C     ENDPRT        TAG                                                    ** ENDPRT TAG *
0744 C*
0745 C**** DETERMINE USING LOOK AHEAD FIELDS IF MORE POSTINGS FOR ACCOUNT S01091
0746 C****       MATCH     COMP MATCHL                   58               S01091
0747 C**** IF MORE POSTINGS FOR THIS ACCOUNT,CHECK FOR FULL PAGE          S01091
0748 C**N58                GOTO SAR                                       S01091
0749 C***41                                                               S01091
0750 C*R*43      LINCNT    COMP 43                       45               S01091
0751 C***40      LINCNT    COMP 31                       45               S01091
     C/COPY WNCPYSRC,GL0420C019
0752 C***42      LINCNT    COMP 33                       45               S01091
     C/COPY WNCPYSRC,GL0420C020
0753 C***44      LINCNT    COMP 30                       45               S01091
0754 C****                                                                S01091
0755 C****                                                                S01091
0756 C**** IF END OF PAGE INCREMENT LSTP AND ZEROISE LINE COUNTER         S01091
0757 C***45      STPA      ADD  1         STPA                            S01091
0758 C***40                Z-ADDLINCNT    FFLCNT  20                      S01091
0759 C***45                Z-ADD0         LINCNT                          S01091
0760 C***45                MOVE PSTDA     LSTDA                           S01091
0761 C**SAVE BALANCE FOR NEW PAGE                                         S01091
     C**TO ENSURE DR INDICATOR INCLUDED ON BFWD FIGURES                   S01091
     C***45                Z-ADDPSTBAL    PSTBF      83                   S01091
0763 C***40 45             Z-ADDCLBAL     CFBF   150 28                   S01091
0764 C****       SAR       TAG                                            S01091
0765 C****                 SETOF                     88                   S01091
0766 C***40 58N74PSTD      COMP PSTDL                    88               S01091
0767 C***58 88                                                            S01091
0768 C*RN40                                                               S01091
0769 C*R*58 74             GOTO CLBP                                      S01091
0770 C****                                                                S01091
0771 C**** FOR FORM,X EQ. 5 :-                                            S01091
0772 C**** ON LAST POSTING BEFORE POSTING DATE CHANGE,                    S01091
0773 C**** UPDATE CLEARED BALANCE AND CLEAR OUT ARRAY ELEMENTS            S01091
0774 C**** WHICH HAVE BEEN USED TO DO THIS.                               S01091
0775 C**** ACCUMULATE ALL CLEARING ON PSTD.                               S01091
0776 C****                                                                S01091
     C***IF I EQ 0 NOW IT IS POSSIBLE THAT POSTINGS WHOSE V DATES FALL IN S01091
     C***WITHIN THIS STATEMENT PERIOD BUT HAVE BEEN PRINTED IN PREVIOUS   S01091
     C**STATEMENTS HAVE ADDED AMTS INTO VDAR/VCAR-ROLL THRU I JUST IN CASES01091
     C****       I         COMP 0                        88               S01091
     C***88                Z-ADD1         I                               S01091
     C***88      LSTD      ADD  1         VDCD                            S01091
0780 C****       CLBAL     ADD  VDAR,I    CLBAL                           S01091
0781 C****       CLBAL     SUB  VCAR,I    CLBAL                           S01091
0782 C**** CLEAR OUT THESE ELEMENTS.                                      S01091
0783 C****                 Z-ADD0         VDAR,I                          S01091
0784 C****                 Z-ADD0         VCAR,I                          S01091
0785 C**** INCREMENT INDEX AND CONTROL DATE.                              S01091
0786 C****       I         ADD  1         I                               S01091
0787 C****       VDCD      ADD  1         VDCD                            S01091
0788 C**** WRAP AROUND INDEX.                                             S01091
0789 C****       I         COMP 60                   88                   S01091
0790 C***88      I         SUB  60        I                               S01091
0791 C****       CLBAL     COMP 0                    37                   S01091
0792 C****       CLBP      TAG                             * CLBP TAG *   S01091
0793 C***58                GOTO FINISH                                    S01091
     C  N02                                                                                   S01091
0794 CORN40              GOTO      OFBP                                                       S01091
0795 C**
0796 C**   FOR FORM,X EQ. 5 :-
0797 C**   CHECK FOR ANY AMOUNTS CLEARING AFTER
0798 C**   THE LAST POSTING HAS BEEN PRINTED ON
0799 C**   THIS STATEMENT BUT BEFORE END OF
0800 C**   PERIOD COVERED BY IT, INCLUDING ANY
0801 C**   OVERFLOW AMOUNTS.
0802 C**
0803 C                   Z-ADD     CLBAL         CLBF                 28
     C                   Z-ADD     1             I                                            059213
     C     LSTD          ADD       1             VDCD                                         059213
0804 C**   ADD OVERFLOW VALUES.
0805 C                   Z-ADD     VCOF          VDCR
0806 C                   Z-ADD     VDOF          VDDR
0807 C     CLBF          ADD       VDOF          CLBF
0808 C     CLBF          SUB       VCOF          CLBF
0809 C     CLBEG         TAG                                                    *  CLBEG TAG *
0810 C**   UPDATE TOTALS.
     C/COPY WNCPYSRC,GL0420C047
0811 C     CLBF          ADD       VDAR(I)       CLBF
0812 C     CLBF          SUB       VCAR(I)       CLBF
0813 C     VDDR          ADD       VDAR(I)       VDDR
0814 C     VDCR          ADD       VCAR(I)       VDCR
     C/COPY WNCPYSRC,GL0420C048
0815 C**   INCREMENT INDEX & DATE.
0816 C     I             ADD       1             I
0817 C     VDCD          ADD       1             VDCD
0818 C**   WRAP  AROUND
0819 C     I             COMP      60                                 88
0820 C   88I             SUB       60            I
0821 C**   CHECK NEW DATE IS WITHIN PERIOD.
     C   55
0822 CAN 35
0823 CORN55VDCD          COMP      RUND                               88
0824 C** 55N35   VDCD      COMP APDA                 88
     C** IF ACCRUAL FREQ/NOT DEMAND INCLUDE UP TO CURRENT STATEMENT DATE
     C** NOT UP TO NEXT ACCRUAL DATE  (WILL HAVE BEEN UPDATED IN SD0640)
     C   55
     CANN35VDCD          COMP      NSTD                               88
0825 C  N88              GOTO      CLBEG
0826 C**   CHECK WHETHER ITEMS ARE CLEARED AFTER LAST POST.
0827 C     VDDR          COMP      0                                  1919
0828 C  N19VDCR          COMP      0                                  1919
     C/COPY WNCPYSRC,GL0420C075
0829 C   19FFLCNT        COMP      31                                     18
     C/COPY WNCPYSRC,GL0420C076
0830 C**   CONDITION DR/CR ON PAGE/STMT. TOTAL.
0831 C   18CLBAL         COMP      0                                  37
0832 C   18              Z-ADD     STPA          STPFF             4 0
     C*                                                                   S01408
     C/COPY WNCPYSRC,GL0420CP25                                           S01408
     C*                                                                   S01408
0833 C   18STPA          ADD       1             STPA
     C*                                                                   S01408
     C/COPY WNCPYSRC,GL0420CP26                                           S01408
     C   18@PAGECTR      ADD       1             @PAGECTR                                     CGL188
     C*                                                                   S01408
0834 C   19CLBF          COMP      0                                  28
0835 C     OFBP          TAG                                                    * OFBP TAG *
0836 C*
0837 C*    UPDATE NEXT STMT DATE IF NEEDED
      *                                                                   177915
      ** If demand statement is requested and next statement date is      177915
      ** equal to rundate, and the account has postings, set off *IN35    177915
      ** and set on *IN52 to update ACCNTAB.                              177915
      *                                                                   177915
     C     *IN35         IFEQ      '1'                                                        177915
     C     *IN15         ANDEQ     '1'                                                        177915
     C     NSTD          ANDEQ     RUND                                                       177915
     C                   MOVE      '0'           *IN35                                        177915
     C                   MOVE      '1'           *IN52                                        177915
     C                   END                                                                  177915
      *                                                                   177915
     C   59
     CANN35              SETON                                        68
     C  N68              GOTO      FREND
     C**   UPDATE NEXT STATEMENT DATE
     C                   Z-ADD     NSTD          NSTDA
     C/COPY WNCPYSRC,GL0420C036
     C                   Z-ADD     STDY          ZMDAY                                        E43356
     C**
     C**   CHECK FOR STFQ 'A'.IF APDA NEEDS RECALCULATING
     C**   APDA MAY HAVE ALREADY BEEN UPDATED IN E.O.D.PHASE FIVE-SDP0640
     C     STFQ          COMP      'A'                                    68
     C***68******          Z-ADDAPDA      NSTDA                           S01194
     C   68              Z-ADD     BKAPDT        NSTDA                                        S01194
     C   68              GOTO      FRCHK
     C**   *********************
     C**   RECALCULATION ROUTINE
     C     FRTOP         TAG                                                    ** FRTOP TAG **
     C**
     C* IF STMT FREQ 'Z' ZEROIZE  NEXT STMT DATE
     C     STFQ          COMP      'Z'                                    68
     C   68              Z-ADD     0             NSTDA
     C   68              GOTO      FRCHK
     C     STFQ          COMP      'D'                                    68
     C/COPY WNCPYSRC,GL0420CX33
     C     CGL184        IFEQ      'Y'                                                        CGL184
     C  N68STFQ          COMP      'K'                                    68                  CGL184
     C                   ENDIF                                                                CGL184
     C***68******          Z-ADDDNWD      NSTDA                           S01194
     C   68              Z-ADD     BJDNWD        NSTDA                                        S01194
     C   68              GOTO      FRCHK
      *                                                                   S01408
     C/COPY WNCPYSRC,GL0420CP43                                           S01408
      *                                                                   S01408
     C     STFQ          COMP      'A'                                    68
     C***68******          MOVE APFQ      ZFREQ                           S01194
     C   68              MOVE      BKAPFQ        ZFREQ                                        S01194
     C***68******          Z-ADDFDAY      ZMDAY                           S01194
     C   68              Z-ADD     BKAPFD        ZMDAY                                        S01194
     C  N68              MOVE      STFQ          ZFREQ
     C  N68              Z-ADD     STDY          ZMDAY
     C**
     C**                                                                  E43356
     C*****IF*THE*STATEMENT*FREQUENCY*IS*M,T,Q,X OR Y,*SUBR*ZFREQ** E43356S01413
     C**   IF THE STATEMENT FREQUENCY IS M,E,T,Q,X OR Y, SUBR ZFREQ       S01413
     C**   RELIES ON ZMDAY (STDY) BEING DEFINED - ENSURE THAT             E43356
     C**   THIS IS THE CASE.                                              E43356
     C**                                                                  E43356
     C**N68****************Z-ADDSTDY      ZMDAY                           E43356
     C  N68STFQ          COMP      'M'                                    85                  E43356
     C**N68N85***STFQ******COMP 'E'                      85         S01413176080
     C  N68
     CANN85STFQ          COMP      'T'                                    85                  E43356
     C  N68
     CANN85STFQ          COMP      'Q'                                    85                  E43356
     C  N68
     CANN85STFQ          COMP      'X'                                    85                  E43356
     C  N68
     CANN85STFQ          COMP      'Y'                                    85                  E43356
     C     CGL184        IFEQ      'Y'                                                        CGL184
     C  N68                                                                                   CGL184
     CANN85STFQ          COMP      'G'                                    85                  CGL184
     C  N68                                                                                   CGL184
     CANN85STFQ          COMP      'H'                                    85                  CGL184
     C  N68                                                                                   CGL184
     CANN85STFQ          COMP      'O'                                    85                  CGL184
     C                   ENDIF                                                                CGL184
     C  N68
     C/COPY WNCPYSRC,GLH00808
     CAN 85              Z-ADD     STDY          ZMDAY                    85                  E43356
     C  N68
     CAN 85              MOVEL     NSTDA         ZDAYNO                                       E43356
     C  N68
     CAN 85              EXSR      ZDATE2                                                     E43356
     C  N68
     CAN 85              Z-ADD     ZDAY          ZMDAY                                        E43356
     C                   Z-ADD     NSTDA         ZDAYNO
     C                   MOVE      BJE2TX        ZLOC                                         S01195
     C                   MOVE      BJLCCY        ZCCY                                         E32657
     C**********           EXSR ZFREQS                                    S01195
     C*                                                                   S01413
     C  N68STFQ          IFEQ      'E'                                                        S01413
     C/COPY WNCPYSRC,GLH00809
     C**********           MOVE 'M'       ZFREQ                     S01413176080
     C                   MOVE      'L'           ZFREQ                                        176080
     C/COPY WNCPYSRC,GL0420C003
     C                   ELSE                                                                 S01413
     C                   MOVE      STFQ          ZFREQ                                        S01413
     C                   END                                                                  S01413
     C*                                                                   S01413
     C** Subtract 1 from month if month of NSTD = month of next           176080
     C** business date so that after ZFREQS, month of NSTD will be the    176080
     C** same                                                             176080
     C*                                                                   176080
     C     ZFREQ         IFEQ      'L'                                                        176080
     C     ZFREQ         OREQ      'B'                                                        176080
     C     ZFREQ         OREQ      'E'                                                        176080
     C/COPY WNCPYSRC,GLH00810
     C                   Z-ADD     BJDNWD        ZDAYNO                                       176080
     C                   EXSR      ZDATE2                                                     176080
     C                   Z-ADD     ZMTH          NWDMTH            2 0          TEMP STORAGE   17608
     C                   Z-ADD     NSTDA         ZDAYNO                                       176080
     C                   EXSR      ZDATE2                                                     176080
     C*                                                                   176080
     C     ZMTH          IFEQ      NWDMTH                                                     176080
     C*                                                                   176080
     C     ZMTH          IFEQ      1                                                          176080
     C                   Z-ADD     12            ZMTH                                         176080
     C     ZYEAR         IFEQ      0                                                          176080
     C                   Z-ADD     99            ZYEAR                                        176080
     C                   ELSE                                                                 176080
     C     ZYEAR         SUB       1             ZYEAR                                        176080
     C                   END                                                                  176080
     C                   ELSE                                                                 176080
     C     ZMTH          SUB       1             ZMTH                                         176080
      *                                                                                     MD033999
      ** If month is Feb and day is 30 or 29 then adjust the day correctly.                 MD033999
      *                                                                                     MD033999
     C     ZMTH          IFEQ      2                                                        MD033999
     C     ZDAY          ANDEQ     30                                                       MD033999
     C     ZMTH          OREQ      2                                                        MD033999
     C     ZDAY          ANDEQ     29                                                       MD033999
     C     *IN91         IFEQ      *ON                                                      MD033999
     C                   Z-ADD     29            ZDAY                                       MD033999
     C                   ELSE                                                               MD033999
     C                   Z-ADD     28            ZDAY                                       MD033999
     C                   ENDIF                                                              MD033999
     C                   ENDIF                                                              MD033999
      *                                                                                     MD033999
     C                   END                                                                  176080
     C*                                                                   176080
     C     *IN98         IFEQ      '1'                                                        176080
     C                   MOVE      ZDAY          @ZWRK             4 0                        176080
     C                   MOVEL     ZMTH          @ZWRK                                        176080
     C                   ELSE                                                                 176080
     C                   MOVEL     ZDAY          @ZWRK                                        176080
     C                   MOVE      ZMTH          @ZWRK                                        176080
     C                   END                                                                  176080
     C*                                                                   176080
     C                   MOVEL     @ZWRK         ZDATE                                        176080
     C                   MOVE      ZYEAR         ZDATE                                        176080
     C                   EXSR      ZDATE1                                                     176080
     C                   END                                                                  176080
     C*                                                                   176080
     C                   END                                                                  176080
     C*                                                                   176080
     C**********         EXSR      ZFREQB                                             S01195 CGL061A
     C                   CallB     'ZFREQB'                                                  CGL061A
     C                   Parm      *blanks       @RTCD                                       CGL061A
     C                   Parm                    ZFREQ             1                         CGL061A
     C                   Parm                    ZDAYNO                                      CGL061A
     C                   Parm                    ZCCY                                        CGL061A
     C                   Parm                    ZLOC                                      AR1096328
     C                   Parm                    ZMDAY             2 0                       CGL061A
     C                   Parm                    BJDFIN                                      CGL061A
     C     SDGELR        Parm      SDGELR        DSFDY                                       CGL061A
      *                                                                                      CGL061A
     C     *INU8         IFEQ      '1'                                                        S01194
     C                   GOTO      END                                                        S01194
     C                   END                                                                  S01194
     C/COPY WNCPYSRC,GL0420C077
     C                   Z-ADD     ZDAYNO        NSTDA
     C**
     C**   CHECK IF CALCULATED DATE IS IN FUTURE.IF NOT RECALCULATE
     C     FRCHK         TAG                                                    ** FRCHK TAG **
     C**
     C***********NSTDA     COMP DNWD                 68  68               S01194
     C     NSTDA         COMP      BJDNWD                             68  68                  S01194
     C  N68STFQ          COMP      'Z'                                    68
     C  N68              GOTO      FRTOP
     C**
     C     FREND         TAG                                                    ** FREND TAG **
     C*                                                                   S01377
     C**  Switchable SAR S01377: Ignore check for zero B/F balance        S01377
     C**  and type of account. @SAR set up in first cycle.                S01377
     C     @SAR          IFEQ      *BLANKS                                                    S01377
0856 C*
0857 C*    SET INDICATOR FOR LAST POSTING PRINT
0858 C     ATYP          COMP      'R'                                    52
     C     *IN26         IFEQ      '0'                                                        057487
     C                   SETON                                        52                      057487
     C                   END                                                                  057487
     C                   END                                                                  S01377
0859 C   29
0860 COR 52
0861 COR 34
0862 C***OR*35***                                                         057487
0862 COR 35              SETON                                        52                      057487
0863 C***ORN26***             SETON                     52                057487
     C*                                                                   CEU013
     C*    CONVERT CLOSING BALANCE INTO EUROS IF EMU SWITCHABLE FEATURE   CEU013
     C*    PRESENT.                                                       CEU013
     C     CEU013        IFEQ      'Y'                                                        CEU013
     C     EUSB          IFEQ      'Y'                                                        CEU013
     C     CCY           ANDNE     BKEURO                                                     173551
     C                   SETON                                        10                      CEU013
     C*                                                                   CEU013
     C                   CALL      'EU0200'                                                   CEU013
     C                   PARM      *BLANK        P@RTCD            7                          CEU013
     C/COPY WNCPYSRC,GL0420C101
     C                   PARM      PSTBAL        P@FRAM           18 3                        CEU013
     C/COPY WNCPYSRC,GL0420C102
     C                   PARM      CCY           P@FRCY            3                          CEU013
     C                   PARM      BKEURO        P@TOCY            3                          CEU013
     C     EUPBAL        PARM                    P@OUTA           15 0                        CEU013
     C                   PARM                    P@INTA           18 3                        CEU013
     C                   PARM                    P@EXRT           15 9                        CEU013
     C                   PARM                    P@MDIN            1                          CEU013
     C*                                                                   CEU013
     C*********          CALL      'AOCURRR0'                                         CEU013 CGL061A
     C                   CALLB     'AOCURRR0'                                                CGL061A
     C                   PARM      *BLANKS       UUAPRC            7                          CEU013
     C                   PARM      '*KEY'        UUAPOP            7                          CEU013
     C                   PARM      BKEURO        UUCYCD            3                          CEU013
     C     SDCURR        PARM      SDCURR        DSSDY                                        CEU013
     C*                                                                   CEU013
     C     UUAPRC        IFNE      *BLANKS                                                    CEU013
     C                   MOVEL     'SDCURRPD'    DBFILE                         ************   CEU01
     C                   MOVEL     BKEURO        DBKEY                          * DBERR 08 *   CEU01
     C                   Z-ADD     08            DBASE                          ************   CEU01
     C                   EXSR      *PSSR                                                      CEU013
     C                   ELSE                                                                 CEU013
     C     A6NBDP        IFEQ      0                                                          CEU013
     C                   MOVE      '1'           *INKA                                        CEU013
     C                   ENDIF                                                                CEU013
     C     A6NBDP        IFEQ      1                                                          CEU013
     C                   MOVE      '1'           *INKB                                        CEU013
     C                   ENDIF                                                                CEU013
     C     A6NBDP        IFEQ      2                                                          CEU013
     C                   MOVE      '1'           *INKC                                        CEU013
     C                   ENDIF                                                                CEU013
     C     A6NBDP        IFEQ      3                                                          CEU013
     C                   MOVE      '1'           *INKD                                        CEU013
     C                   ENDIF                                                                CEU013
     C                   ENDIF                                                                CEU013
     C*                                                                   CEU013
     C                   ELSE                                                                 CEU013
     C                   SETOFF                                       10                      CEU013
     C                   ENDIF                                                                CEU013
     C                   ENDIF                                                                CEU013
     C*                                                                   CEU013
0864 C*
0865 C*    ZEROISE LINE COUNT FOR NEW STATEMENT
0866 C                   Z-ADD     0             LINCNT
0867 C*
     C*    OUTPUT TOTAL OUTPUT                                            S01091
     C*                                                                   S01408
     C/COPY WNCPYSRC,GL0420CP16                                           S01408
     C*                                                                   S01408
     C                   EXCEPT    TOT                                                        S01091
     C*                                                                   S01408
     C/COPY WNCPYSRC,GL0420CP17                                           S01408
     C*                                                                   S01408
     C******************   SETOF                     52            S01091 E10603
     C     ENDPS         TAG                                                                  E12038
     C/COPY WNCPYSRC,GL0420C108
     C                   END                                                                  S01091
     C/COPY WNCPYSRC,GL0420C043
0868 C*
0869 C*****CHAIN TO ACCOUNT FILE TO UPDATE************                    S01091
     C*****                SETOF                     03                   S01091
0870 C*****      ACKEY     CHAINACCNT                77                   S01091
     C**N03                Z-ADD03        DBASE            ***************S01091
     C**N03                MOVELBLANK     DBKEY            DATABASE ERROR S01091
     C**N03                MOVELACKEY     DBKEY                03         S01091
     C**N03                MOVEL'ACCNT'   DBFILE           ***************S01091
     C**   CHAIN TO ACCOUNT FILE TO UPDATE                                S01117
     C*                                                                   S01117
     C                   SETOFF                                       03                      S01117
     C     ACKEY         CHAIN     ACCNT                              77                      S01117
     C     *IN03         IFNE      '1'                                                        S01117
     C                   SETON                                        U7U8LR                  S01117
     C                   Z-ADD     03            DBASE                          ***************S0111
     C                   MOVEL     *BLANKS       DBKEY                          DATABSE ERROR  S0111
     C                   MOVEL     ACKEY         DBKEY                               03       S01117
     C                   MOVEL     'ACCNT'       DBFILE                         ***************S0111
     C                   END                                                                  S01117
0871 C*
0872 C*    CHANGE BIT SETTING FOR OUTPUT
0873 C                   BITOFF    '01'          GLBT
     C/COPY WNCPYSRC,GL0420C022
0874 C**N03                SETON                     U7U8LR
0875 C                   SETON                                        54
     C                   MOVE      '0'           *IN38                                        056524
     C     ATYP          IFEQ      'R'                                                        056524
     C     *IN33         ANDEQ     '0'                                                        056524
     C                   MOVE      '1'           *IN38                                        056524
     C                   END                                                                  056524
0876 C***03                EXCPT                                          S01091
     C/COPY WNCPYSRC,GL0420C031
0876 C   03              EXCEPT    ACUPD                                                      S01091
     C/COPY WNCPYSRC,GL0420C081
      *                                                                                       CGL188
     C     @PAGECTR      IFGT      @PAGEN                                                     CGL188
      *                                                                                       CGL188
     C                   move      *IN80         SAV80             1                          CGL188
     C     KSTBA         CHAIN     GLSTBAL0                           80                      CGL188
     C     *IN80         Ifeq      *ON                                                        CGL188
     C                   move      BRCA          BABRCA                                       CGL188
     C                   move      CNUM          BACNUM                                       CGL188
     C                   move      CCY           BACCY                                        CGL188
     C                   move      ACOD          BAACOD                                       CGL188
     C                   move      ACSQ          BAACSQ                                       CGL188
     C                   write     GLSTBAP0                                                   CGL188
     C                   Endif                                                                CGL188
     C                   move      SAV80         *IN80                                        CGL188
      *                                                                                       CGL188
     C                   Endif                                                                CGL188
      *                                                                                       CGL061
      ** Comit if restart status = 'Y' or number of records processed                         CGL061
      ** has reached optimum defined in CBTASKSP                                              CGL061
     C*****RSTART        IFEQ      'Y'                                                CGL061 CGL061A
     C********** #COMIT    OREQ #OPTIM                                              CGL061 AR1004822
     C********** #COMIT    ORGE #OPTIM                                             AR1004822 CGL061A
     C**********         COMMIT                                                       CGL061 CGL061A
     C**********         Z-ADD     0             #COMIT                               CGL061 CGL061A
     C**********         ENDIF                                                        CGL061 CGL061A
     C*                                                                   S01520
     C** If Account Statements Changes switchable feature is switched     S01520
     C** ON, call GL0421                                                  S01520
     C*                                                                   S01520
     C     S01520        IFEQ      'Y'                                                        S01520
     C*                                                                   S01520
     C** Move fields                                                      S01520
     C*                                                                   S01520
     C                   MOVEL     CNUM          WCNUM             6                          S01520
     C**********           MOVELACOD      WACOD   4                                    S01520 CGL029
     C                   MOVEL     ACOD          WACOD            10                          CGL029
     C                   MOVEL     ACSQ          WACSQ             2                          S01520
     C*                                                                   S01520
     C                   CALL      'GL0421'                                                   S01520
     C                   PARM                    BRCA                                         S01520
     C                   PARM                    WCNUM                                        S01520
     C                   PARM                    CCY                                          S01520
     C                   PARM                    WACOD                                        S01520
     C                   PARM                    WACSQ                                        S01520
     C                   PARM                    RUND                                         S01520
     C                   PARM                    PSTBAL                                       S01520
     C                   PARM                    BKAPRP                                       154040
     C                   PARM      *BLANKS       @ERROR            1                          S01520
     C*                                                                   S01520
     C** If an error occured in the called program, do database error     S01520
     C** processing                                                       S01520
     C*                                                                   S01520
     C     @ERROR        IFEQ      'S'                                                        S01520
     C                   MOVE      *BLANKS       DBPGM                                        S01520
     C                   MOVE      *BLANKS       DBKEY                                        S01520
     C                   MOVEL     'SDACODPD'    DBFILE                         ************   S0152
     C                   MOVEL     'GL0421'      DBPGM                          * DBERR 06 *   S0152
     C                   MOVEL     WACOD         DBKEY                          ************   S0152
     C                   Z-ADD     06            DBASE                                        S01520
     C                   EXSR      *PSSR                                                      S01520
     C                   ELSE                                                                 S01520
     C     @ERROR        IFEQ      'C'                                                        S01520
     C                   MOVE      *BLANKS       DBPGM                                        S01520
     C                   MOVE      *BLANKS       DBKEY                                        S01520
     C                   MOVEL     BRCA          WBRCA                                        S01520
     C                   MOVEL     CCY           WCCY                                         S01520
     C                   MOVEL     RUND          WRUND                                        S01520
     C                   MOVEL     'CPOSTDD '    DBFILE                         ************   S0152
     C                   MOVEL     'GL0421'      DBPGM                          * DBERR 06 *   S0152
     C                   MOVEL     WKEYDS        DBKEY                          ************   S0152
     C                   Z-ADD     06            DBASE                                        S01520
     C                   EXSR      *PSSR                                                      S01520
     C                   END                                                                  S01520
     C                   END                                                                  S01520
     C*                                                                   S01520
     C                   END                                                                  S01520
     C*                                                                   S01520
      *                                                                   S01408
     C/COPY WNCPYSRC,GL0420CP40                                           S01408
      *                                                                   S01408
0877 C                   GOTO      FINISH
     C/SPACE 3
     C********************************************************************
0878 C*
0879 C*    FILE CONTROL CHECK
0880 C     STRAIL        TAG                                                    ** STRAIL TAG *
0881 C*****SUBTRACT 2 FOR HEADER AND TRAILER.                                                 CGL061
0882 C***********STMSIZ    SUB  2         STMSIZ                                              CGL061
0883 C***********TNAR      COMP STMSIZ               8686                                     CGL061
0884 C***86******          SETON                     U8                                       CGL061
     C*IF PROCESSING REACHES THIS POINT DATABASE ERROR 04 HAS NOT OCCURED
     C*******************  SETOF                     16                                       CGL061
0885 C*********************GOTO FINISH                                    S01194
     C/SPACE 3
     C********************************************************************
0886 C*
     C****ACCUMULATE POSTINGS FILE CONTROLS FOR MORE THAN ONE TRAILER     S01091
     C***********PTRAIL    TAG                             ** PTRAIL TAG *S01194
     C*                                                                   S01091
     C****       *IN05     IFEQ '0'                                       S01091
     C****                 SETON                     05                   S01091
     C****                 Z-ADDHNWN      HNWNT  130                      S01091
     C****                 Z-ADDHNDC      HNDCT   30                      S01091
     C****       POSSIZ    SUB  2         POSSI   50                      S01091
     C****                                                                S01091
     C****                 ELSE                                           S01091
     C****                                                                S01091
     C****       POSSIZ    ADD  POSSI     POSSI                           S01091
     C****                 Z-ADDHNWN      ZZAMTI                          S01091
     C****                 Z-ADDHNDC      ZZAMTD                          S01091
     C****                 Z-ADDHNWNT     ZZTOTI                          S01091
     C****                 Z-ADDHNDCT     ZZTOTD                          S01091
     C****                 EXSR GLZSUM                                    S01091
     C****                 Z-ADDZZTOTI    HNWNT                           S01091
     C****                 Z-ADDZZTOTD    HNDCT                           S01091
     C****       POSSI     SUB  2         POSSI                           S01091
     C****                 END                                            S01091
     C*
     C*IF*PROCESSING*REACHES THIS POINT DATABASE ERROR 05 HAS NOT OCCURED S01091
     C*******************  SETOF                     82
0885 C*********************GOTO FINISH                                    S01194
      /EJECT
     C*
0887 C*    DATABASE ERROR SETON EXTERNAL INDICATOR AND END JOB
0891 C*
0892 C*    NORMAL END OF CYCLE WILL GO TO FINISH
      *
0893 C     FINISH        TAG                                                    ** FINISH TAG *
     C   U7              SETON                                        LR
     C**                                                                  S01117
     C/COPY WNCPYSRC,GL0420CP33                                           S01195
     C**                                                                  S01117
0894 C*
     C****UPDATE*TRAILER                                        S01091    S01161
     C*R*********          READ APOSTZZ                5858     S01091    S01161
     C*R**********IN58     IFEQ '1'                        ** IFS01091    S01161
     C*R*********          SETON                     U7U8  *****S01091    S01161
     C*R*********          Z-ADD06        DBASE            DATABS01091    S01161
     C*R*********          MOVE 'TRAILER' DBKEY                0S01091    S01161
     C*R*********          MOVE 'APOSTZZ' DBFILE           *****S01091    S01161
     C*R*********          GOTO END                             S01091    S01161
     C*R*********          ELSE                            ** ELS01091    S01161
     C*****CONVERT ACTUAL NUMBER OF RECORDS ON FILE FROM        S01091    S01161
     C*****BINARY TO DECIMAL                                    S01091    S01161
     C*R*********          EXSR BINCON                          S01091    S01161
     C*R*********SUM       SUB  NODEL     POSSO   50            S01091    S01161
     C*R*********          ADD  2         POSSO                 S01091    S01161
     C*****GET*EODPO TRAILER RECORD                             S01091    S01161
     C*R*********          READ EODPOZZ                5858     S01091    S01161
     C*****ERROR*IF NOT FOUND                                   S01091    S01161
     C*R**********IN58     IFEQ '1'                        ** IFS01091    S01161
     C*R*********          SETON                     U7U8  *****S01091    S01161
     C*R*********          Z-ADD16        DBASE            DATABS01091    S01161
     C*R*********          MOVE 'TRAILER' DBKEY                1S01091    S01161
     C*R*********          MOVE 'EODPO'   DBFILE           *****S01091    S01161
     C*R*********          GOTO END                             S01091    S01161
     C*R*********          ELSE                            ** ELS01091    S01161
     C*****CALCULATE EXPECTED NUMBER OF RECORDS FROM TRAILERS   S01091    S01161
     C*R*********          ADD  NORE      POSSIZ                S01091    S01161
     C*R*********          SUB  4         POSSIZ                S01091    S01161
     C*****COMPARE WITH ACTUAL NUMBER OF RECORDS                S01091    S01161
     C*R*********SUM       IFEQ POSSIZ                     ** IFS01091    S01161
     C*****UPDATE FILE IF O.K. ........                         S01091    S01161
     C*R*********          EXCPTTRAIL                           S01091    S01161
     C*********** ELSE SET FILE CONTROL ERROR INDICATOR         S01091    S01161
     C*R*********          ELSE                            ** ENS01091    S01161
     C*R*********          MOVE '1'       *INU8                 S01091    S01161
     C*R*********          MOVE '1'       *IN84                 S01091    S01161
     C*R*********          END                             ** ENS01091    S01161
     C*R*********          END                             ** ENS01091    S01161
     C*R*********          END                             ** ENS01091    S01161
     C***********LRNU7        EXSR ENDRPT                                              S01117 CGL061
0895 C*****FILE CONTROLS POSTINGS                                         S01091
0891 C*R**       TNPR      COMP POSSI                8484                 S01091
0892 C***                                                                 S01091
0893 C***  HASH COMPARISON                                                S01091
0896 C*R*                  Z-ADDHPTI      ZZINT                           S01091
0897 C*R*                  Z-ADDHPTD      ZZDEC                           S01091
     C*R*                  Z-ADDHNWNT     ZZTOTI                          S01091
     C*R*                  Z-ADDHNDCT     ZZTOTD                          S01091
0898 C***                                                                 S01091
0899 C*R*                  EXSR GLZCMP                                    S01091
0900 C***                                                                 S01091
0901 C*R*        ZZDIFI    COMP 0                    8585                 S01091
0902 C*RN85      ZZDIFD    COMP 0                    8585                 S01091
0903 C*R*84                SETON                     U8                   S01091
0904 C*R*85N84             SETON                     U8                   S01091
0905 C***                                                                 S01091
0906 C*R*        HNDCT     MULT 10        HND4    40                      S01091
0907 C*R*        HPTD      MULT 10        HPT4    40                      S01091
0908 C***                                                                 S01091
0909 C**ADD 2 FOR 'H' AND 'T'                                             S01091
0910 C*R*        TNPO      ADD  2         TNPO                            S01091
     C*                                                                   S01377
     C**  Close down switchable SAR's file                                S01377
     C*                                                                   S01377
     CLR                 CALL      'AOSARDR0'                                                 S01377
     CLR                 PARM      '       '     @RTCD                                        S01377
     CLR                 PARM      '*FREE'       @OPTN                                        S01377
     CLR                 PARM      *BLANK        @SARD                                        S01377
     CLR   SCSARD        PARM      SCSARD        DSFDY                                        S01377
     C*                                                                   S01377
     C**  If an error has occurred                                        S01377
     C*                                                                   S01377
     CLR   @RTCD         IFNE      *BLANKS                                                    S01377
     CLR                 Z-ADD     27            DBASE                          *************  S0137
     CLR                 MOVEL     *BLANKS       DBKEY                          DATABASE ERROR S0137
     CLR                 MOVEL     @OPTN         DBKEY                             27         S01377
     CLR                 MOVE      'SCSARDPD'    DBFILE                         *************  S0137
     CLR                 MOVEL     @OPTN         DBOPTN            7                          S01377
     CLR                 EXSR      *PSSR                                                      S01377
     CLR                 END                                                                  S01377
     C*                                                                   S01377
      ** ENSURE TOTALS SPOOL FILE RECORDED BY RCF                         S01117
     CLR                 Z-ADD     SFNUMU        SFNM              6 0                        S01117
     C**********LR             OUT  LDA                                                S01117 CGL061
     CLR                 CALL      'ZSFILE'                                                   S01117
     CLR                 PARM                    SEQ                                          S01117
     CLR                 PARM      *BLANKS       SENTY             3                          S01117
     CLR                 PARM                    SFILEU                                       S01117
     CLR                 PARM                    SFNM                                         S01117
     CLR                 PARM                    ZSERR             1                          S01117
     C*                                                                   S01117
     CLR   *LOCK         IN        LDA                                                        S01117
     CLR   ZSERR         IFEQ      'Y'                                                        S01117
     C*                                                                   S01117
     C* ERROR DURING ZSFILE PROCESSING, RETURN TO CALLING PROGRAMME       S01117
     C*                                                                   S01117
     CLR                 SETON                                        U7U8                    S01117
     CLR                 RETURN                                                               S01117
     CLR                 END                                                                  S01117
     CLR                 OUT       LDA                                                        CGL061
      *                                                                                       CGL061
      ** Update the driver audit file                                                         CGL061
     C****LR                   EXSR UPDAUD                                            CGL061 CGL061A
     CLR                 COMMIT                                                              CGL061A
      *                                                                                       CGL061
     C*IF*16*IS*STILL ON AT LAST RECORD DATABASE ERROR HAS OCCURED                            CGL061
     C*LR*16NU7***          Z-ADD04        DBASE            **************                    CGL061
     C*LR*16NU7***          MOVEL'MISSING' DBMSG  15        DATABASE ERROR                    CGL061
     C*LR*16NU7***          MOVE 'TRAILER' DBMSG                04                            CGL061
     C*LR*16NU7***          MOVE BLANK     DBKEY            **************                    CGL061
     C*LR*16NU7***          MOVELDBMSG     DBKEY                                              CGL061
     C*                                                                   S01408
     C/COPY WNCPYSRC,GL0420CP30                                           S01408
     C*                                                                   S01408
     C************LR 16NU7       MOVE 'STMTS'   DBFILE                                        CGL061
     C*                                                                   S01408
     C/COPY WNCPYSRC,GL0420CP31                                           S01408
     C*                                                                   S01408
     C***LR*16NU7***          SETON                     U7U8                                  CGL061
     C***LR*16*U7***          EXSR *PSSR                                     S01194           CGL061
     C*IF*82 IS STILL ON AT LAST RECORD DATABASE ERROR HAS OCCURED        S01091
     C*R*82NU7             Z-ADD05        DBASE            ************** S01091
     C*R*82NU7             MOVEL'MISSING' DBMSG            DATABASE ERROR S01091
     C*R*82NU7             MOVE 'TRAILER' DBMSG                05         S01091
     C*R*82NU7             MOVE BLANK     DBKEY            ************** S01091
     C*R*82NU7             MOVELDBMSG     DBKEY                           S01091
     C*R*82NU7             MOVE 'SSTPO'   DBFILE                          S01091
     C*R*82NU7             SETON                     U7U8                 S01091
     CLR   END           TAG
0920 C/EJECT
0921 C*   SUBROUTINES.
     C*****************************************************************   S01117
     C/EJECT                                                              S01117
     C*****************************************************************   S01117
     C*                                                                   S01117
     C*  ENDRPT  -  SUBROUTINE TO OUTPUT THE NARRATIVE 'END OF            S01117
     C*             REPORT FOR BRANCH XXX' AT THE END OF THE              S01117
     C*             SPOOL FILES WHICH ALREADY HVE STATEMENTS OUTPUT       S01117
     C*                                                                   S01117
     C*  CALLED BY - MAIN PROGRAM AND LAST CYCLE                          S01117
     C*                                                                   S01117
     C*  CALLS - NOTHING                                                  S01117
     C*                                                                   S01117
     ******************************************************************   S01117
     C*                                                                   S01117
     C     ENDRPT        BEGSR                                                                S01117
     C*                                                                   S01117
     C     SWRIT1        IFNE      0                                                          S01117
     C     SWRIT1        ANDNE     @BBIN1                                                     S01117
     C                   EXCEPT    ERPT1                                                      S01117
     C                   Z-ADD     0             SWRIT1                                       S01117
     C                   END                                                                  S01117
     C*                                                                   S01117
     C/COPY WNCPYSRC,GL0420C013
     C     SWRIT2        IFNE      0                                                          S01117
     C     SWRIT2        ANDNE     @BBIN2                                                     S01117
     C                   EXCEPT    ERPT2                                                      S01117
     C                   Z-ADD     0             SWRIT2                                       S01117
     C                   END                                                                  S01117
     C*                                                                   S01117
     C/COPY WNCPYSRC,GL0420C058
     C     SWRIT3        IFNE      0                                                          S01117
     C     SWRIT3        ANDNE     @BBIN3                                                     S01117
     C                   EXCEPT    ERPT3                                                      S01117
     C                   Z-ADD     0             SWRIT3                                       S01117
     C                   END                                                                  S01117
     C/COPY WNCPYSRC,GL0420C014
     C*                                                                   S01117
     C     SWRIT4        IFNE      0                                                          S01117
     C     SWRIT4        ANDNE     @BBIN4                                                     S01117
     C                   EXCEPT    ERPT4                                                      S01117
     C                   Z-ADD     0             SWRIT4                                       S01117
     C                   END                                                                  S01117
     C*                                                                   S01117
     C     SWRIT5        IFNE      0                                                          S01117
     C     SWRIT5        ANDNE     @BBIN5                                                     S01117
     C                   EXCEPT    ERPT5                                                      S01117
     C                   Z-ADD     0             SWRIT5                                       S01117
     C                   END                                                                  S01117
     C*                                                                   S01117
     C     SWRIT6        IFNE      0                                                          S01117
     C     SWRIT6        ANDNE     @BBIN6                                                     S01117
     C                   EXCEPT    ERPT6                                                      S01117
     C                   Z-ADD     0             SWRIT6                                       S01117
     C                   END                                                                  S01117
     C*                                                                   S01117
     C*
     C** Core hook for externalisation.                                   S01408
     C/COPY WNCPYSRC,GL0420CCP6                                           S01408
     C*
     C                   ENDSR                                                                S01117
     C*****************************************************************   S01117
     C/EJECT                                                              S01117
      *****************************************************************                       CGL061
      *                                                                                       CGL061
      *  UPDAUD  -  SUBROUTINE to Update the audit driver file                                CGL061
      *                                                                                       CGL061
      *****************************************************************                       CGL061
     C********** UPDAUD    BEGSR                                                      CGL061 CGL061A
      **********                                                                      CGL061 CGL061A
      ***Access*record on GLSTAMPA                                                    CGL061 CGL061A
     C**********           OPEN GLSTAMPA                                              CGL061 CGL061A
      **********                                                                      CGL061 CGL061A
     C**********           READ GLSTAMPA                 80                           CGL061 CGL061A
      **********                                                                      CGL061 CGL061A
      ***Accumulate number of records and hash total amount                           CGL061 CGL061A
      ***processed by this sub-task if trailer not empty                              CGL061 CGL061A
     C********** *IN80     IFEQ '0'                                                   CGL061 CGL061A
     C**********           ADD  NORE1     TNAR                                        CGL061 CGL061A
     C**********           ENDIF                                                      CGL061 CGL061A
      **********                                                                      CGL061 CGL061A
     C**********           MOVE 'T'       RECI                                        CGL061 CGL061A
     C**********           Z-ADDTNAR      NORE1                                       CGL061 CGL061A
     C**********           Z-ADD0         HRWN                                        CGL061 CGL061A
     C**********           Z-ADD0         HRDC                                        CGL061 CGL061A
      **********                                                                      CGL061 CGL061A
      ***If*Trailer is empty, write a record; otherwise, update it                    CGL061 CGL061A
     C********** *IN80     IFEQ '0'                                                   CGL061 CGL061A
     C**********           UPDATAPOSTZZF                                              CGL061 CGL061A
     C**********           ELSE                                                       CGL061 CGL061A
     C**********           WRITEAPOSTZZF                                              CGL061 CGL061A
     C**********           ENDIF                                                      CGL061 CGL061A
      **Final*commit                                                                  CGL061 CGL061A
     C**********           COMIT                                                      CGL061 CGL061A
      **********                                                                      CGL061 CGL061A
     C**********           ENDSR                                                      CGL061 CGL061A
      *****************************************************************                       CGL061
      /EJECT                                                                                  CGL061
     C*****************************************************************   S01117
     C*****************************************************************
     C***********                                               S01091    S01161
     C*****BINCON  SR. TO CONVERT A 4 LONG BINARY NUMBER TO A   S01091    S01161
     C***********      DECIMAL NUMBER                           S01091    S01161
     C***********                                               S01091    S01161
     C***********BINCON    BEGSR                                S01091    S01161
     C***********          MOVE BY1       B,1                   S01091    S01161
     C***********          MOVE BY2       B,2                   S01091    S01161
     C***********          MOVE BY3       B,3                   S01091    S01161
     C***********          MOVE BY4       B,4                   S01091    S01161
     C***********          Z-ADD1         POWER   50            S01091    S01161
     C***********          Z-ADD0         SUM     50            S01091    S01161
     C***********          Z-ADD7         N       10            S01091    S01161
     C***********          Z-ADD1         L       10            S01091    S01161
     C***********L         DOUEQ5                               S01091    S01161
     C***********          MOVE B,L       BYT     1             S01091    S01161
     C***********          TESTB'7'       BYT            90     S01091    S01161
     C***90******SUM       ADD  POWER     SUM                   S01091    S01161
     C***********POWER     MULT 2         POWER                 S01091    S01161
     C***********          TESTB'6'       BYT            90     S01091    S01161
     C***90******SUM       ADD  POWER     SUM                   S01091    S01161
     C***********POWER     MULT 2         POWER                 S01091    S01161
     C***********          TESTB'5'       BYT            90     S01091    S01161
     C***90******SUM       ADD  POWER     SUM                   S01091    S01161
     C***********POWER     MULT 2         POWER                 S01091    S01161
     C***********          TESTB'4'       BYT            90     S01091    S01161
     C***90******SUM       ADD  POWER     SUM                   S01091    S01161
     C***********POWER     MULT 2         POWER                 S01091    S01161
     C***********          TESTB'3'       BYT            90     S01091    S01161
     C***90******SUM       ADD  POWER     SUM                   S01091    S01161
     C***********POWER     MULT 2         POWER                 S01091    S01161
     C***********          TESTB'2'       BYT            90     S01091    S01161
     C***90******SUM       ADD  POWER     SUM                   S01091    S01161
     C***********POWER     MULT 2         POWER                 S01091    S01161
     C***********          TESTB'1'       BYT            90     S01091    S01161
     C***90******SUM       ADD  POWER     SUM                   S01091    S01161
     C***********POWER     MULT 2         POWER                 S01091    S01161
     C***********          TESTB'0'       BYT            90     S01091    S01161
     C***90******SUM       ADD  POWER     SUM                   S01091    S01161
     C***********POWER     MULT 2         POWER                 S01091    S01161
     C***********L         ADD  1         L                     S01091    S01161
     C***********          END                                  S01091    S01161
     C***********                                               S01091    S01161
     C***********          ENDSR                                S01091    S01161
     C***********                                               S01091    S01161
     C*                                                                   S01408
     C/COPY WNCPYSRC,GL0420CP27                                           S01408
     C*                                                                   S01408
0922 C**********************************************************S01091    S01161
0923 C**
0924 C**   FORM5 SUBR.
0925 C**
0926 C**   THIS SUBROUTINE UPDATES THE CLEARED BALANCE FOR STATEMENT
0927 C**   FORMAT 5.
0928 C**
0929 C     FORM5         BEGSR                                                  ** FORM5 **
0930 C**
0931 C**   ON CHANGE OF PSTD, UPDATE CLBAL BETWEEN VDCD & PSTD
0932 C**   EXCLUDING PSTD,
0933 C  NL1
0934 COR 39
0935 COR 75              GOTO      FORMB
      *                                                                                       243837
      ** For first posting which will appear on statement,                                    243837
      ** I should be 1 and VDCD should be LSTD + 1.                                           243837
      *                                                                                       243837
     C     NCR           IFEQ      0                                                          243837
     C     NDR           ANDEQ     0                                                          243837
     C     VDCD          ANDGT     PSTD                                                       243837
     C                   Z-ADD     1             I                                            243837
     C     LSTD          ADD       1             VDCD                                         243837
     C                   END                                                                  243837
0936 C     FORMA         TAG                                                    * FORMA TAG *
0937 C**
0938 C**   PROCEED TO PROCESSING OF CURRENT POSTING IF VDCD EQ. PSTD.
0939 C     VDCD          COMP      PSTD                                   88
0940 C   88              GOTO      FORMB
0941 C**
0942 C**   UPDATE CLEARED BALANCE.
0943 C     CLBAL         ADD       VDAR(I)       CLBAL
0944 C     CLBAL         SUB       VCAR(I)       CLBAL
     C/COPY WNCPYSRC,GL0420C103
0945 C**   CLEAR OUT THESE ELEMENTS.
0946 C                   Z-ADD     0             VDAR(I)
0947 C                   Z-ADD     0             VCAR(I)
0948 C**   INCREMENT INDEX AND CONTROL DATE.
0949 C     I             ADD       1             I
0950 C     VDCD          ADD       1             VDCD
0951 C**   WRAP AROUND INDEX.
0952 C     I             COMP      60                                 88
0953 C   88I             SUB       60            I
0954 C                   GOTO      FORMA
0955 C     FORMB         TAG                                                    * FORMB TAG *
0956 C**
0957 C**   UPDATE ARRAY WITH CURRENT CLEARING,
0958 C**   OR IF BEYOND 60 DAYS UPDATE OVERFLOW.
0959 C**   CHECK VALUE DATE IS WITHIN PERIOD.
     C   55
0960 CAN 35
0961 CORN55VALD          COMP      RUND                               88
     C** DO UP TO NSTD NOT TO ALREADY UPDATED ATDA (IN SD0640)
     C   55
     CANN35VALD          COMP      NSTD                               88
0963 C   88              GOTO      FORMD
0964 C**   IF VALD L. T. PSTD, SET VDIN EQ. TO PSTD - VDCD.
0965 C**   DO NOT TEST IF CLEARING FROM LAST STATEMENT.
0966 C  N39VALD          COMP      PSTD                                 88
0967 C   88PSTD          SUB       VDCD          VDIN              2 0
0968 C**   ELSE SET VDIN EQ. TO VALD - VDCD.
0969 C  N88VALD          SUB       VDCD          VDIN
      *                                                                                       246285
     C     VDIN          IFLT      0                                                          246285
     C                   Z-ADD     0             VDIN                                         246285
     C                   END                                                                  246285
      *                                                                                       246285
0970 C**   CHECK FOR OVERFLOW.
0971 C     VDIN          COMP      60                                 88  88
0972 C**   IF OVERFLOW, UPDATE OVERFLOW TOTAL.
     C/COPY WNCPYSRC,GL0420C087
     C   88
0973 CAN 22VCOF          ADD       PSTA          VCOF
     C   88
0974 CAN 23VDOF          ADD       PSTA          VDOF
     C/COPY WNCPYSRC,GL0420C088
0975 C   88              GOTO      FORMC
0976 C**   ELSE UPDATE ARRAYS.
0977 C     I             ADD       VDIN          J                 2 0
0978 C     J             COMP      60                                 88
0979 C   88J             SUB       60            J
     C/COPY WNCPYSRC,GL0420C049
0980 C   22VCAR(J)       ADD       PSTA          VCAR(J)
0981 C   23VDAR(J)       ADD       PSTA          VDAR(J)
     C/COPY WNCPYSRC,GL0420C050
0982 C**   SET 'APPEARED IN CLEARED BALANCE IND.'
0983 C     FORMC         TAG                                                    * FORMC TAG *
0984 C                   BITON     '5'           CUOR
0985 C     FORMD         ENDSR
0986 C********************************************************************
0987 C********************************************************************
0988 C************                                                       *S01194
0989 C*****SR.TABCHN*-*TO*CHAIN TO THE TABLE FILE USING TABKEY.          *S01194
0990 C***********                                                        *S01194
0991 C***********TABCHN    BEGSR                           **** TABCHN ***S01194
0992 C***********                                                        *S01194
0993 C***********                                                        *S01194
0994 C***********                                                        *S01194
0995 C***********TABKEY    CHAINTABLE                76                  *S01194
0996 C***********                                                        *S01194
0997 C***********                                                        *S01194
0998 C***********          ENDSR                                         *S01194
0999 C***********                                                        *S01194
1000 C********************************************************************
1001 C****                                                                S01091
1002 C**** SR POSH - HASH TOTALING FOR POSTO                              S01091
1003 C****                                                                S01091
1004 C****       POSH      BEGSR                           *** POSH ***   S01091
1005 C****                                                                S01091
1006 C****       TNPO      ADD  1         TNPO                            S01091
1007 C****                                                                S01091
1008 C**N02                GOTO ENPOSH                                    S01091
1009 C****                 MOVE PSTA      PSTA03                          S01091
1010 C****                 Z-ADDPSTA03    ZZAMT                           S01091
1011 C****                 Z-ADDHPOI      ZZTOTI                          S01091
1012 C****                 Z-ADDHPOD      ZZTOTD                          S01091
1013 C****                                                                S01091
1014 C****                 EXSR GLZADD                                    S01091
1015 C****                                                                S01091
1016 C****                 Z-ADDZZTOTI    HPOI                            S01091
1017 C****                 Z-ADDZZTOTD    HPOD                            S01091
1018 C****                                                                S01091
1019 C****       ENPOSH    ENDSR                           *** ENDSR ***  S01091
1020 C****                                                                S01091
1021 C****                                                                S01091
1022 C****                                                                S01091
1023 C********************************************************************S01091
1024 C***********                                                         S01194
1025 C*****ZSYSTM*SR.*TO*CHAIN*TO*THE*INSTALLATION CONTROL DATA RECORD.   S01194
1026 C***********                                                         S01194
1027 C***********ZSYSTM    BEGSR                           *** ZSYSTEM ***S01194
     C***********                                                         S01194
1028 C***********                                                         S01194
1029 C*****SET*UP*KEY*FOR*INSTALLATION CONTROL RECORD.                    S01194
1030 C***********          MOVEL'01      'ZTABKY 12                       S01194
1031 C***********          MOVE '  10'    ZTABKY                          S01194
1032 C***********                                                         S01194
1033 C***********ZTABKY    CHAINTABLE                99    ON NOT THERE   S01194
1034 C**N99******RECI      COMP 'D'                  9999  ON, IS DELETED S01194
1035 C***********                                                         S01194
1036 C*****CHECK*SYSTEM*DATE*FORMAT, DDMMYY OR MMDDYY.                    S01194
1037 C***********DATF      COMP 'M'                      98MMDDYY, 98 ON  S01194
1038 C***********                                                         S01194
1039 C***********          ENDSR                                          S01194
1040 C***********                                                         S01194
1041 C***********                                                         S01194
1042 C***********                                                        *S01194
1043 C********************************************************************
1044 C*
1045 C*    SETONS SR. SETS ON THE REQUIRED INDICATORS FOR PRINTING
1046 C*
1047 C     SETONS        BEGSR                                                  **** SETONS ***
1048 C*
1049 C*
1050 C  N50              GOTO      SEND
1051 C*
     C****/COPY*WNCPYSRC,GL0420C110***                                                        CFC006
     C/COPY WNCPYSRC,GL0420C110                                                             MD020563
      *                                                                                       CFC006
      ** Disable indicator(s) used in printing the report                                     CFC006
      *                                                                                       CFC006
     C                   IF        SUPFL3 = 'Y'                                               CFC006
     C                   EVAL      *IN42 = *OFF                                               CFC006
     C                   EVAL      *IN62 = *OFF                                               CFC006
     C                   EVAL      *IN63 = *OFF                                               CFC006
     C                   ENDIF                                                                CFC006
      *                                                                                       CFC006
     C                   IF        SUPFL5 = 'Y'                                               CFC006
     C                   EVAL      *IN44 = *OFF                                               CFC006
     C                   EVAL      *IN66 = *OFF                                               CFC006
     C                   EVAL      *IN67 = *OFF                                               CFC006
     C                   ENDIF                                                                CFC006
      *                                                                                       CFC006
1052 C   40              SETON                                        87
     C   41
1053 CANN34              SETON                                        60
     C/COPY WNCPYSRC,GL0420C034
1054 C   42              SETON                                        62
1055 C   43              SETON                                        64
1056 C   44              SETON                                        66
     C/COPY WNCPYSRC,GL0420C035
     C   41
1057 CAN 34              SETON                                        80
      *                                                                                     BUG26704
     C     MBIN          IFEQ      'Y'                                                      BUG26704
     C     CLOSEP        IFEQ      'N'                                                      BUG26704
     C                   CLOSE     GL0420P1                                                 BUG26704
     C                   CLOSE     GL0420P2                                                 BUG26704
     C                   CLOSE     GL0420P3                                                 BUG26704
     C                   CLOSE     GL0420P4                                                 BUG26704
     C                   CLOSE     GL0420P5                                                 BUG26704
     C                   CLOSE     GL0420P6                                                 BUG26704
     C**********           MOVE '0'       *IN84                                    BUG27359 BUG27725
     C                   MOVE      'N'           OPENP1                                     BUG27359
     C                   MOVE      'N'           OPENP2                                     BUG27359
     C                   MOVE      'N'           OPENP3                                     BUG27359
     C                   MOVE      'N'           OPENP4                                     BUG27359
     C                   MOVE      'N'           OPENP5                                     BUG27359
     C                   MOVE      'N'           OPENP6                                     BUG27359
     C     CGL046        IFEQ      'Y'                                                      BUG26704
     C                   CLOSE     GL0420PR                                                 BUG26704
     C                   MOVE      'N'           OPENPR                                     BUG27359
     C                   ENDIF                                                              BUG26704
     C                   MOVE      'Y'           CLOSEP            1                        BUG26704
     C                   ENDIF                                                              BUG26704
     C                   EXSR      SROPFL                                                   BUG26704
     C                   ENDIF                                                              BUG26704
1058 C*
1059 C  N36              GOTO      SEND
1060 C*
1061 C   87              SETON                                        89
1062 C   60              SETON                                        61
1063 C   62              SETON                                        63
1064 C   64              SETON                                        65
1065 C   66              SETON                                        67
1066 C   80              SETON                                        81
1067 C*
     C/COPY WNCPYSRC,GL0420C015
1068 C     SEND          ENDSR
     C/COPY WNCPYSRC,GL0420C016
1069 C*
1070 C********************************************************************
1071 C**********                                                          S01195
1072 C*****ZFREQS SR. TO INCREMENT A DAY NUMBER DATE BY A                 S01195
1073 C**********     PERIOD VALUE DETERMINED BY A CODE.                   S01195
1074 C**********                                                          S01195
1075 C*********  ZFREQS    BEGSR                           *** ZFREQ ***  S01195
     C*********                                                           S01195
     C*********            MOVE CCY       ZCCY                            S01195
     C**********           MOVE BJE2TX    ZLOC    3                       S01195
1076 C**********                                                          S01195
1077 C*****CALCULATIONS TO DEFINE/CLEAR FIELDS.                           S01195
1078 C**********           MOVE ZFREQ     ZFREQ   1                       S01195
1079 C**********           Z-ADDZDAYNO    ZDAYNO  50                      S01195
1080 C**********           Z-ADDZMDAY     ZMDAY   20                      S01195
1081 C**********           MOVE ZCCY      ZCCY    3                       S01195
1082 C**********                                                          S01195
1083 C***********          MOVE '   '     ZHC                             S01195
1084 C***********          MOVE ' '       ZTABKY 12                       S01195
1085 C**********                                                          S01195
1086 C*****CONVERT DAY NUMBER TO DATE.                                    S01195
1087 C**********           EXSR ZDATE2                                    S01195
1088 C**********                                                          S01195
1089 C*****CHECK FOR AND INCREMENT FOR CODE D-DAILY-WORKING DAY.          S01195
1090 C********** ZFREQ     COMP 'D'                      91               S01195
1091 C***91******ZDAYNO    ADD  1         ZDAYNO                          S01195
1092 C***91******          GOTO ZFHCHK                                    S01195
     C********** *IN91     IFEQ '1'                                       S01195
     C**********           Z-ADD1         ZNRDYS                          S01195
     C**********           EXSR ZFWDT                                     S01195
     C**********           Z-ADDZDYNBR    ZDAYNO                          S01195
     C**********           GOTO ZFEND                                     S01195
     C**********           END                                            S01195
1093 C**********                                                          S01195
1094 C*****CHECK FOR AND INCREMENT FOR CODE W-WEEKLY.                     S01195
1095 C********** ZFREQ     COMP 'W'                      91               S01195
1096 C***91***** ZDAYNO    ADD  7         ZDAYNO                          S01195
1097 C***91*****           GOTO ZFEND                                     S01195
1098 C**********                                                          S01195
1099 C*****CHECK FOR AND INCREMENT FOR CODE F-FORTNIGHTLY.                S01195
1100 C********** ZFREQ     COMP 'F'                      91               S01195
1101 C***91***** ZDAYNO    ADD  14        ZDAYNO                          S01195
1102 C***91*****           GOTO ZFEND                                     S01195
1103 C**********                                                          S01195
1104 C*****CHECK FOR AND INCREMENT FOR CODE S-SEMI-MONTHLY.               S01195
1105 C********** ZFREQ     COMP 'S'                      91               S01195
1106 C***91***** ZDAY      COMP 15                   939292               S01195
1107 C***01*92**           Z-ADD31        ZDAY                            S01195
1108 C***91*93**           Z-ADD15        ZDAY                            S01195
1109 C***91*93** ZMTH      ADD  1         ZMTH                            S01195
1110 C***91*****           GOTO ZFDATE                                    S01195
1111 C**********                                                          S01195
1112 C*****CHECK FOR AND INCREMENT FOR CODE M-MONTHLY.                    S01195
1113 C********** ZFREQ     COMP 'M'                      91               S01195
1114 C***91*****           Z-ADDZMDAY     ZDAY                            S01195
1115 C***91***** ZMTH      ADD  1         ZMTH                            S01195
1116 C***91*****           GOTO ZFDATE                                    S01195
1117 C**********                                                          S01195
1118 C*****CHECK FOR AND INCREMENT FOR CODE R-SIX DAYS BEFORE END OF MONTHS01195
1119 C********** ZFREQ     COMP 'R'                      91               S01195
1120 C***91*****           Z-ADD31        ZDAY                            S01195
1121 C***91***** ZMTH      ADD  1         ZMTH                            S01195
1122 C***91*****           GOTO ZFDATE                                    S01195
1123 C**********                                                          S01195
1124 C*****CHECK FOR AND INCREMENT FOR CODE T-BIMONTHLY.                  S01195
1125 C********** ZFREQ     COMP 'T'                      91               S01195
1126 C***91*****           Z-ADDZMDAY     ZDAY                            S01195
1127 C***91***** ZMTH      ADD  2         ZMTH                            S01195
1128 C***91*****           GOTO ZFDATE                                    S01195
1129 C**********                                                          S01195
1130 C*****CHECK FOR AND INCREMENT FOR CODE Q-QUARTERLY.                  S01195
1131 C********** ZFREQ     COMP 'Q'                      91               S01195
1132 C***91*****           Z-ADDZMDAY     ZDAY                            S01195
1133 C***91***** ZMTH      ADD  3         ZMTH                            S01195
1134 C***91*****           GOTO ZFDATE                                    S01195
1135 C**********                                                          S01195
1136 C*****CHECK FOR AND INCREMENT FOR CODE X-SIX MONTHLY.                S01195
1137 C********** ZFREQ     COMP 'X'                      91               S01195
1138 C***91*****           Z-ADDZMDAY     ZDAY                            S01195
1139 C***91***** ZMTH      ADD  6         ZMTH                            S01195
1140 C***91*****           GOTO ZFDATE                                    S01195
1141 C**********                                                          S01195
1142 C*****CHECK FOR AND INCREMENT FOR CODE Y-YEARLY.                     S01195
1143 C********** ZFREQ     COMP 'Y'                      91               S01195
1138 C***91*****           Z-ADDZMDAY     ZDAY                            S01195
1144 C***91***** ZYEAR     ADD  1         ZYEAR                           S01195
1145 C***91*****           GOTO ZFDATE                                    S01195
1146 C**********                                                          S01195
1147 C*****CHECK FOR AND INCREMENT FOR CODE L-LAST CALENDAR DAY OF MONTH. S01195
1148 C********** ZFREQ     COMP 'L'                      91               S01195
1149 C***91*****           Z-ADD31        ZDAY                            S01195
1150 C***91***** ZMTH      ADD  1         ZMTH                            S01195
1151 C***91*****           GOTO ZFDATE                                    S01195
1152 C**********                                                          S01195
1153 C*****CHECK FOR AND INCREMENT FOR CODE B-LAST WORKING DAY OF MONTH.  S01195
1154 C********** ZFREQ     COMP 'B'                      91               S01195
1155 C***91*****           Z-ADD31        ZDAY                            S01195
1156 C***91***** ZMTH      ADD  1         ZMTH                            S01195
1157 C***91*****           GOTO ZFDATE                                    S01195
1158 C**********                                                          S01195
1159 C*****CHECK FOR AND INCREMENT FOR CODE A-MONTHLY ACCRUAL/PROFIT DATE.S01195
1160 C********** ZFREQ     COMP 'A'                      91               S01195
1161 C***********          MOVEL'01    '  ZTABKY                          S01194
1162 C***91******          MOVE '    11'  ZTABKY                          S01194
1163 C***91******ZTABKY    CHAINTABLE                99    ON NOT THERE   S01194
1164 C**N99******RECI      COMP '*'                      99               S01194
1165 C***91N99***          Z-ADDAPDA      ZDAYNO                          S01194
     C**********                                                          S01194
     C*****ACCESS GENERAL LEDGER DETAILS                                  S01194
     C**********                                                          S01194
     C********** *IN91     IFEQ '1'                                       S01194
     C**********           CALL 'AOGELRR0'                                S01194
     C**********           PARM '*MSG   ' @RTCD   7                       S01194
     C**********           PARM '*FIRST ' @OPTN   7                       S01194
     C********** SDGELR    PARM SDGELR    DSFDY                           S01194
     C**********           END                                            S01194
     C**********                                                          S01194
     C********** @RTCD     IFNE *BLANK                                    S01194
     C**********           SETON                     99                   S01194
     C**********           ELSE                                           S01194
     C**********           Z-ADDBKAPDT    ZDAYNO                          S01194
     C**********           END                                            S01194
1166 C**********                                                          S01195
1167 C*****BYPASS IF ZFREQ IS 'A' OR ANY OTHER VALUE                      S01195
1168 C**********           GOTO ZFEND                                     S01195
1169 C**********                                                          S01195
1170 C**********                                                          S01195
1171 C*****REFORMAT DATE AND ENSURE VALID.                                S01195
1172 C********** ZFDATE    TAG                             ** ZFDATE TAG* S01195
1173 C**********                                                          S01195
1174 C*****VALIDATE MONTH.                                                S01195
1175 C********** ZMTH      COMP 12                   91                   S01195
1176 C***91***** ZMTH      SUB  12        ZMTH                            S01195
1177 C***91***** ZYEAR     ADD  1         ZYEAR                           S01195
1178 C**********                                                          S01195
1179 C*****CHECK FOR LEAP YEAR.                                           S01195
1180 C********** ZYEAR     DIV  4         ZLYR    20                      S01195
1181 C**********           MVR            ZLY     10     92LEAP YEAR-92 ONS01195
1182 C**********                                                          S01195
1183 C*****VALIDATE DAY NUMBER.                                           S01195
1184 C**********           MOVE ZFMD,ZMTH ZWRK2   20                      S01195
1185 C********** ZMTH      COMP 2                        93               S01195
1186 C***92*93             Z-ADD29        ZWRK2                           S01195
1187 C**********                                                          S01195
1188 C********** ZDAY      COMP ZWRK2                94                   S01195
1189 C***94*****           Z-ADDZWRK2     ZDAY                            S01195
1190 C**********                                                          S01195
1191 C*****CHECK IF CODE R, TO SUBTRACT 6 DAYS.                           S01195
1192 C********** ZFREQ     COMP 'R'                      91               S01195
1193 C***91***** ZDAY      SUB  6         ZDAY                            S01195
1194 C**********                                                          S01195
1195 C*****REFORMAT DATE, DDMMYY OR MMDDYY, AND CONVERT TO DAY NUMBER.    S01195
1196 C**********           MOVELZDAY      ZWRK4   40                      S01195
1197 C**********           MOVE ZMTH      ZWRK4                           S01195
1198 C***98*****           MOVELZMTH      ZWRK4                           S01195
1199 C***98*****           MOVE ZDAY      ZWRK4                           S01195
1200 C**********           MOVELZWRK4     ZDATE                           S01195
1201 C**********           MOVE ZYEAR     ZDATE                           S01195
1202 C**********           EXSR ZDATE1                                    S01195
1203 C**********                                                          S01195
1204 C*****CHECK IF CODE B,TO BE CHECKED FOR HOLIDAY.                     S01195
1205 C********** ZFREQ     COMP 'B'                      91               S01195
1206 C***91N99***          GOTO ZFHCHK                                    S01195
     C********** *IN91     IFEQ '1'                                       S01195
     C********** *IN99     ANDNE'1'                                       S01195
     C**********           Z-ADD0         ZNRDYS                          S01195
     C**********           EXSR ZBKDT                                     S01195
     C**********           Z-ADDZDYNBR    ZDAYNO                          S01195
1207 C**********                                                          S01195
1208 C**********           GOTO ZFEND                                     S01195
     C**********           END                                            S01195
1207 C**********                                                          S01195
1208 C***********          GOTO ZFEND                                     S01195
1209 C***********                                                         S01195
1210 C***********                                                         S01195
1211 C*****CHECK*IF*DAY*NUMBER*IS*A*HOLIDAY.                              S01195
1212 C***********ZFHCHK    TAG                             ** ZFHCHK TAG *S01195
1213 C***********          SETOF                     94                   S01195
1214 C***********                                                         S01195
1215 C*****DETERMINE*CODE.**                                              S01195
1216 C***********ZFREQ     COMP 'D'                      91               S01195
1217 C***********ZFREQ     COMP 'B'                      92               S01195
1218 C***********                                                         S01195
1219 C*****SET*KEY*FOR*FIRST*HOLIDAY*RECORD.**                            S01195
1220 C***********          MOVEL'22    '  ZTABKY                          S01195
1221 C***********          MOVELZDAYNO    ZWRK6   6                       S01195
1222 C***********          MOVE 1         ZWRK6                           S01195
1223 C***********          MOVE ZWRK6     ZTABKY                          S01195
1224 C***********                                                         S01195
1225 C*****GET*HOLIDAY*RECORD.**                                          S01195
1226 C***********ZFHCHN    TAG                             ** ZFHCHN TAG* S01195
1227 C***********ZTABKY    CHAINTABLE                93    ON NOT THERE   S01195
1228 C**N93******RECI      COMP '*'                      93               S01195
1229 C**N94******          MOVE '   '     ZHC                             S01195
1230 C***********                                                         S01195
1231 C*****STORE*CURRENCIES*IF*RECORD*FOUND.**                            S01195
1232 C**N94N93***          MOVEAHCCY      ZHC,1                           S01195
1233 C***94N93***          MOVEAHCCY      ZHC,26                          S01195
1234 C***********                                                         S01195
1235 C*****GET*SECORD*RECORD,*IF*NOT*ALREADY*DONE.**                      S01195
1236 C***********          MOVE ZTABKY    ZWRK1   10                      S01195
1237 C***********ZWRK1     COMP 1                        94               S01195
1238 C***********          MOVE '2'       ZTABKY                          S01195
1239 C***94N93***          GOTO ZFHCHN                                    S01195
1240 C***********                                                         S01195
1241 C*****BYPASS*TO*END*IF*NO*FIRST*RECORD*FOUND.**                      S01195
1242 C***93*94***          GOTO ZFEND                                     S01195
1243 C***********                                                         S01195
1244 C*****DETERMINE*HOLIDAY*RECORD*TYPE.**                               S01195
1245 C***********INEX      COMP 'E'                  969695               S01195
1246 C***********                                                         S01195
1247 C*****CHECK*IF*LOCAL*CURRENCY*HOLIDAY.**                             S01195
1248 C***********ZCCY      LOKUPZHC                      97               S01195
1249 C***********                                                         S01195
1250 C*****BYPASS*IF*NOT*HOLIDAY*FOR*CURRENCY.**                          S01195
1251 C***95*97***                                          EXCLUDE FOUND  S01195
1252 C*R*96N97***          GOTO ZFEND                      INCL. NOT FOUNDS01195
1253 C***********                                                         S01195
1254 C*****INCREMENT*OR*DECREMENT*DAY*NUMBER*AS REQUIRED.                 S01195
1255 C***91*95N97                                          EXCL. NOT FOUNDS01195
1256 C*R*91*96*97ZDAYNO    ADD  1         ZDAYNO           INCLUDE FOUND  S01195
1257 C***********                                                         S01195
1258 C***92*95N97                                          EXCL. NOT FOUNDS01195
1259 C*R*92*96*97ZDAYNO    SUB  1         ZDAYNO           INCLUDE FOUND  S01195
1260 C***********          GOTO ZFHCHK                                    S01195
1261 C**********                                                          S01195
1262 C**********                                                          S01195
1263 C********** ZFEND     ENDSR                           * ZFEND ENDSR *S01195
1264 C**
1265 C********************************************************************
1266 C*
1267 C*    ZDATE1 SR. TO VALIDATE DATES  AND
1268 C*          CONVERT TO A NUMBER OF DAYS.
1269 C*
1270 C     ZDATE1        BEGSR                                                  *** ZDATE1 ***
1271 C*
1272 C**   CLEAR DAY NUMBER.
1273 C                   Z-ADD     0             ZDAYNO            5 0
1274 C**
1275 C**   CALCULATION TO DEFINE INPUT DATE FIELD.
1276 C                   Z-ADD     ZDATE         ZDATE             6 0
1277 C**
1278 C**   GET INDIVIDUAL DAY, MONTH AND YEAR FIELDS.
1279 C                   MOVE      ZDATE         ZYEAR             2 0
1280 C  N98              MOVEL     ZDATE         ZDAY              2 0
1281 C   98              MOVEL     ZDATE         ZMTH              2 0
1282 C                   MOVE      ZDATE         ZWRK4             4 0
1283 C  N98              MOVEL     ZWRK4         ZMTH
1284 C   98              MOVEL     ZWRK4         ZDAY
1285 C**
1286 C**   ENSURE MONTH IS VALID.
1287 C     ZMTH          COMP      0                                    9999
1288 C  N99ZMTH          COMP      12                                 99
1289 C   99              GOTO      ZDEND1                                       BYPASS IF ERROR
1290 C**
1291 C**   CHECK FOR 30 DAY MONTHS.
1292 C     ZMTH          COMP      4                                      90    IF 90 ON, 30
1293 C  N90ZMTH          COMP      6                                      90    DAY MONTH.
1294 C  N90ZMTH          COMP      9                                      90
1295 C  N90ZMTH          COMP      11                                     90
1296 C**
1297 C**   ENSURE DAY IS VALID.
1298 C     ZDAY          COMP      0                                    9999
     C   90
1299 CANN99ZDAY          COMP      30                                 99
     C  N90
1300 CANN99ZDAY          COMP      31                                 99
1301 C   99              GOTO      ZDEND1                                       BYPASS IF ERROR
1302 C**
1303 C**   CHECK FOR LEAP YEAR AND FEBRUARY.
1304 C     ZYEAR         ADD       28            ZYEAR
1305 C     ZYEAR         DIV       4             ZLYR              2 0
1306 C                   MVR                     ZLY               1 0    91    LEAP YR, 91 ON
1307 C     ZMTH          COMP      2                                  93  92    FEB., 92 ON
1308 C**                                                   PAST FEB, 93 ON
1309 C**   IF FEBUARY FURTHER VALIDATE DAY.
     C  N91
1310 CAN 92ZDAY          COMP      28                                 99
     C   91
1311 CAN 92ZDAY          COMP      29                                 99
1312 C   99              GOTO      ZDEND1                                       BYPASS IF ERROR
1313 C**
1314 C**   DETERMINE NUMBER OF DAYS FROM 31/12/1971.     NO.OF 4 YR. SPANS
1315 C     ZLYR          MULT      1461          ZDAYNO                         X DAYS IN SPAN.
1316 C  N91ZDAYNO        ADD       ZYDY(ZLY)     ZDAYNO                         SINCE LAST L.YR
     C   91
1317 CAN 93ZDAYNO        ADD       1             ZDAYNO                         L.YR.,PAST FEB.
1318 C     ZDAYNO        ADD       ZMDY(ZMTH)    ZDAYNO                         DAYS THIS YEAR
1319 C     ZDAYNO        ADD       ZDAY          ZDAYNO                         DAYS THIS MONTH
1320 C**
1321 C     ZDEND1        ENDSR                                                  * ZDEND1 ENDSR*
1322 C**
1323 C**
1324 C********************************************************************
1325 C*
1326 C*
1327 C**   ZDATE2 SR. TO CONVERT A DAY NUMBER TO DATE FORMATS.
1328 C**
1329 C     ZDATE2        BEGSR                                                  *** ZDATE2 ***
1330 C**
1331 C**   CLEAR DATE FIELDS.
1332 C                   Z-ADD     0             ZDATE             6 0
1333 C                   MOVEL     '       '     ZADATE            7
1334 C**
1335 C**   CALCULATION TO DEFINE INPUT DAY NUMBER.
1336 C                   Z-ADD     ZDAYNO        ZDAYNO            5 0
1337 C**
1338 C**   DETERMINE YEAR NUMBER.
1339 C**
1340 C**   ADJUST DAY NUMBER IN CASE LAST DAY OF YEAR.
1341 C     ZDAYNO        SUB       1             ZDAYN1            5 0  99
1342 C   99              GOTO      ZDEND2
1343 C**
1344 C**   CALCULATE NUMBER OF 4 YEAR SPANS SINCE 31/12/1971.
1345 C     ZDAYN1        DIV       1461          ZLYR              2 0
1346 C                   MVR                     ZDAYN1                         SAVE REMAINING
1347 C**                                                   DAYS
1348 C**   CALCULATE NUMBER OF REMAINING YEARS.
1349 C                   Z-ADD     1             ZWRK2             2 0
1350 C     ZDTAG1        TAG                                                    ** ZDTAG1 TAG *
1351 C     ZDAYN1        COMP      ZYDY(ZWRK2)                          90
1352 C  N90ZWRK2         ADD       1             ZWRK2
1353 C  N90              GOTO      ZDTAG1
1354 C     ZWRK2         SUB       1             ZWRK2                    91    LEAP YR, 91 ON
1355 C**
1356 C**   DECREMENT DAY NO. BY DAYS IN REMAINING YEARS.
1357 C  N91ZDAYN1        SUB       ZYDY(ZWRK2)   ZDAYN1
1358 C**
1359 C**   CALCULATE ACTUAL YEAR NUMBER.
1360 C     ZLYR          MULT      4             ZWRK3             3 0
1361 C     ZWRK3         ADD       72            ZWRK3                          BASE IS 1972
1362 C                   Z-ADD     ZWRK3         ZYEAR             2 0
1363 C     ZYEAR         ADD       ZWRK2         ZYEAR                          YEAR
1364 C**
1365 C**   DETERMINE MONTH NUMBER.
1366 C**
1367 C**   ADJUST DAY NO. IN CASE LAST DAY OF LEAP YEAR FEBRUARY.
1368 C                   SETOFF                                       9293
1369 C   91ZDAYN1        COMP      59                                   9293
     C   91
1370 CANN92ZDAYN1        SUB       1             ZDAYN1
1371 C**
1372 C**   CALCULATE MONTH NUMBER.
1373 C                   Z-ADD     2             ZWRK2
1374 C     ZDTAG2        TAG                                                    ** ZDTAG2 TAG *
1375 C     ZDAYN1        COMP      ZMDY(ZWRK2)                          94
1376 C  N94ZWRK2         ADD       1             ZWRK2
1377 C  N94              GOTO      ZDTAG2
1378 C     ZWRK2         SUB       1             ZWRK2
1379 C**
1380 C                   Z-ADD     ZWRK2         ZMTH              2 0          MONTH
1381 C**
1382 C**   DETERMINE DAY OF MONTH.
1383 C**
1384 C**   ADD BACK LAST DAY OF YEAR ADJUSTMENT.
1385 C     ZDAYN1        ADD       1             ZDAYN1
1386 C**
1387 C**   CALCULATE DAY OF MONTH.
1388 C     ZDAYN1        SUB       ZMDY(ZWRK2)   ZDAY              2 0          DAY
1389 C**
1390 C**   ADD BACK LEAP YEAR 29TH FEBUARY ADJUSTMENT, IF REQUIRED.
1391 C   93ZDAY          ADD       1             ZDAY
1392 C**
1393 C**   FORMAT DATE, DDMMYY OR MMDDYY.
1394 C  N98              MOVEL     ZDAY          ZWRK4             4 0
1395 C   98              MOVE      ZDAY          ZWRK4
1396 C  N98              MOVE      ZMTH          ZWRK4
1397 C   98              MOVEL     ZMTH          ZWRK4
1398 C                   MOVEL     ZWRK4         ZDATE
1399 C                   MOVE      ZYEAR         ZDATE
1400 C**
1401 C**   FORMAT ALPHA DATE, DDMMMYY.
1402 C     ZDAY          COMP      10                                   95
1403 C                   MOVEL     ZDAY          ZWRK5             5
1404 C   95              MOVEL     ' '           ZWRK5
1405 C                   MOVE      ZMNM(ZMTH)    ZWRK5
1406 C                   MOVEL     ZWRK5         ZADATE
1407 C                   MOVE      ZYEAR         ZADATE
1408 C**
1409 C     ZDEND2        ENDSR                                                  * ZDEND2 ENDSR*
1410 C**
1411 C********************************************************************
1412 C* SUBROUTINE TO ADD AN AMOUNT (ZZAMT) TO THE TOTAL (ZZTOTI,ZZTOTD)
1413 C*   IND '99' IS SET BY AN OVERFLOW ERROR
1414 C*
1415 C     GLZADD        BEGSR                                                  *** GLZADD ***
1416 C*
1417 C                   Z-ADD     ZZAMT         ZZAMT            15 3    91    -DEFINE ZZAMT
1418 C   91              GOTO      ZZAEND                                       AMT = 0.BYPASS
1419 C*
1420 C* SPLIT ZZAMT INTO INTEGER AND DECIMAL FIELDS
1421 C                   Z-ADD     ZZAMT         ZZAMTI           15 0          INTEGER FIELD
1422 C                   MOVE      ZZAMT         ZZAMTD            3 0          DECIMAL FIELD
1423 C* BOTH ZZAMTI AND ZZAMTD CONTAIN A 'SIGN' ZONE NOW
1424 C*
1425 C                   EXSR      GLZSUM
1426 C     ZZAEND        ENDSR                                                  ** ZZAEND TAG *
1427 C*
1428 C********************************************************************
1429 C* SUBROUTINE TO COMPARE AN AMOUNT TO THE TOTAL.
1430 C*      PARAMETERS. I/P - ZZINT - THE INTEGER PORTION OF THE NUMBER.
1431 C*                  I/P - ZZDEC - THE DECIMAL PORTION OF THE NUMBER.
1432 C*                  O/P - ZZDIFI - IS THE INTEGER DIFFERENCE.
1433 C*                  O/P - ZZDIFD - IS THE DECIMAL DIFFERENCE.
1434 C*                  O/P - ZZNEGD - FOR IMMEDIATE PRINTING ONLY.
1435 C*                  O/P - 96 IS SET IF DIFFERENCE IS NEGATIVE.
1436 C*
1437 C*    IF AN ERROR HAS OCCURED ZZDIFI AND ZZDIFD WILL BE ZERO.
1438 C*        '99' - OVERFLOW ERROR
1439 C*        '97' - THE 'SIGN' ZONES OF ZZINT AND ZZDEC ARE DIFFERENT
1440 C*
1441 C     GLZCMP        BEGSR                                                  *** GLZCMP ****
1442 C                   SETOFF                                       9799
1443 C                   Z-ADD     ZZDEC         ZZDEC             3 0919293    DEFINE ZZDEC
1444 C                   Z-ADD     ZZINT         ZZINT            15 0949596    DEFINE ZZINT
1445 C* IF SIGN ZONES DIFFER, SET 97, & RETURN ZERO.
     C   91
1446 CAN 95
     COR 92
1447 CAN 94              SETON                                        97        ERROR -MIXED
1448 C*                                                           STATUS
1449 C   97              GOTO      ZZQUIT                                       BRANCH TO ADMIT
1450 C*
1451 C*  SPECIAL CASES DEALT WITH FIRST
1452 C*      EITHER AMOUNTS EQ '0' OR BOTH AMOUNTS 'EQ'
1453 C                   SETOFF                                       9192
1454 C                   SETOFF                                       9495
     C   93
1455 CAN 96              SETON                                        91        * IF I/P FIELD
1456 C   91              Z-ADD     ZZTOTI        ZZDIFI           15 0          *    ZERO
1457 C   91              Z-ADD     ZZTOTD        ZZDIFD            3 0          *
1458 C   91              GOTO      ZZSIGN
1459 C*
1460 C     ZZTOTI        COMP      ZZINT                                  91    * IF FIELDS EQ
1461 C   91ZZTOTD        COMP      ZZDEC                                  91    *
1462 C   91              Z-ADD     0             ZZDIFI                         *
1463 C   91              Z-ADD     0             ZZDIFD                         *
1464 C   91              GOTO      ZZCEND
1465 C*
1466 C     ZZTOTI        COMP      0                                      91    * IF TOTAL
1467 C   91ZZTOTD        COMP      0                                      91    *    ZERO
1468 C   91              Z-SUB     ZZINT         ZZDIFI                         *
1469 C   91              Z-SUB     ZZDEC         ZZDIFD                         *
1470 C**
1471 C     ZZSIGN        TAG                                                    *** ZZSIGN ****
1472 C*
1473 C**   IF ZZDIFD IS ZERO, AND ZZDIFI IS NEG. SET UP ZZNEGD.
1474 C                   SETOFF                                       96
1475 C   91ZZDIFD        COMP      0                                      94
1476 C   94ZZDIFI        COMP      0                                    96
1477 C   96              MOVE      '.000-'       ZZNEGD            5
1478 C   91              GOTO      ZZCEND
1479 C*      END OF SPECIAL CASES
1480 C*
1481 C* IF ZZTOTALS EQ 'B' AND ZZINT,ZZDEC EQ 'A'   THEN -
1482 C*  TO COMPARE 'A' WITH 'B'
1483 C*     1. STORE ORIGINAL VALUE OF 'B'.
1484 C*     2. NEGATE 'A'.
1485 C*     3. ADD 'A' TO 'B'.
1486 C*     4. 'B' IS NOW THE DIFFERENCE. STORE 'B' IN FIELD 'C'.
1487 C*     5. RESTORE 'B'.
1488 C*            N.B. 'A' EQ ZZINT AND ZZDEC
1489 C*                 'B' EQ ZZTOTI AND ZZTOTD
1490 C*                 'C' EQ ZZDIFI AND ZZDIFD
1491 C*
1492 C*    STEP #1
1493 C                   Z-ADD     ZZTOTI        ZZSTRI           15 0
1494 C                   Z-ADD     ZZTOTD        ZZSTRD            3 0
1495 C*    STEP #2
1496 C                   Z-SUB     ZZINT         ZZAMTI           15 0
1497 C                   Z-SUB     ZZDEC         ZZAMTD            3 0
1498 C*    STEP #3
1499 C                   EXSR      GLZSUM
1500 C**
1501 C   99              GOTO      ZZQUIT
1502 C*    STEP #4
1503 C                   Z-ADD     ZZTOTI        ZZDIFI
1504 C                   MOVE      ZZTOTD        ZZDIFD
1505 C*    STEP #5
1506 C                   Z-ADD     ZZSTRI        ZZTOTI           15 0
1507 C                   Z-ADD     ZZSTRD        ZZTOTD            3 0
1508 C                   GOTO      ZZCEND                                       BYPASS ADMIT
1509 C     ZZQUIT        TAG                                                    ** ZZQUIT TAG**
1510 C                   Z-ADD     0             ZZDIFI
1511 C                   Z-ADD     0             ZZDIFD
1512 C     ZZCEND        ENDSR                                                  ** ZZCEND TAG**
1513 C*
1514 C********************************************************************
1515 C* SUBROUTINE TO CARRY OUT THE ADDITION FOR SUBROUTINES -
1516 C*                        GLZADD, GLZSUB, GLZCMP.
1517 C*          PARAMETERS PASSED -
1518 C*                     I/P ZZAMTI ZZAMTD
1519 C*                     O/P ZZTOTI ZZTOTD ZZNEGD IND 96 IND 99.
1520 C*
1521 C     GLZSUM        BEGSR                                                  *** GLZSUM ****
1522 C*
1523 C                   Z-ADD     ZZTOTI        ZZTOTI           15 0          DEFINE ZZTOTI
1524 C                   Z-ADD     ZZTOTD        ZZTOTD            3 0          DEFINE ZZTOTD
1525 C                   SETOFF                                       919293
1526 C                   SETOFF                                       949599
1527 C*
1528 C*    DETERMINE SIGN OF ZZAMTI & D,   92 IF NEG
1529 C     ZZAMTI        COMP      0                                    9293
1530 C   93ZZAMTD        COMP      0                                    9293
1531 C   93              GOTO      ZZSEND                                       ZERO BYPASS
1532 C*
1533 C*    DETERMINE SIGN OF ZZTOTI & D, 91 IF NEG.
1534 C     ZZTOTI        COMP      0                                    9193
1535 C   93ZZTOTD        COMP      0                                    9193
1536 C*
1537 C*    IF ZZTOTAL IS ZERO, RETURN ZZAMOUNT.
1538 C   93              Z-ADD     ZZAMTI        ZZTOTI
1539 C   93              Z-ADD     ZZAMTD        ZZTOTD
1540 C   93              GOTO      ZZSEND                                       ZERO BYPASS
1541 C*    IF SIGNS DIFFER BYPASS OVERFLOW CHECKS.
     C   91
1542 CANN92
     CORN91
1543 CAN 92              GOTO      ZZOFPS
1544 C*
1545 C     ZZAMTD        ADD       ZZTOTD        ZZWK2             4 0
1546 C     ZZWK2         COMP      999                                93        '93' = CARRY
1547 C  N93ZZWK2         COMP      -999                                 93             INTO INTEGER.
1548 C*
     C   93
1549 CANN92ZZAMTI        ADD       1             ZZWK3            15 0          ADD 'CARRY' +VE
     C   93
1550 CAN 92ZZAMTI        SUB       1             ZZWK3                          SUB 'CARRY' -VE
1551 C   93ZZTOTI        ADD       ZZWK3         ZZWK3
1552 C  N93ZZTOTI        ADD       ZZAMTI        ZZWK3
1553 C*
1554 C* IF THE MODULUS OF ZZWK3 IS LT MOD. ZZTOTI THEN O/F HAS OCCURED
1555 C  N92ZZWK3         COMP      ZZTOTI                               99      -92 MEANS NOS.
1556 C   92ZZWK3         COMP      ZZTOTI                             99                    NEGATIVE
1557 C  N99              Z-ADD     ZZWK2         ZZTOTD
1558 C  N99              Z-ADD     ZZWK3         ZZTOTI
1559 C*
1560 C* IF O/F ZEROIZE ZZAMT , IND '99' SET AND ZZTOT FIELDS LEFT INTACT.
1561 C   99              Z-ADD     0             ZZAMT            15 3
1562 C                   GOTO      ZZSEND
1563 C*
1564 C* THE 'SIGNS' ARE DIFFERENT
1565 C     ZZOFPS        TAG                                                    ** ZZOFPS TAG**
1566 C* IF ZZAMT WAS NEGATIVE, MAKE IT POS. TO COMP WITH ZZTOT
1567 C*
1568 C   92              Z-SUB     ZZAMTI        ZZAMTI           15 0
1569 C   92              Z-SUB     ZZAMTD        ZZAMTD            3 0
1570 C*
1571 C* IF ZZTOT WAS NEGATIVE, MAKE IT POS. TO COMP WITH ZZAMT.
1572 C*
1573 C   91              Z-SUB     ZZTOTI        ZZTOTI
1574 C   91              Z-SUB     ZZTOTD        ZZTOTD
1575 C* BOTH ZZAMT AND ZZTOT ARE NOW POSITIVE.
1576 C*
1577 C     ZZTOTI        COMP      ZZAMTI                             93  95
1578 C   95ZZTOTD        COMP      ZZAMTD                             93  95
1579 C*
1580 C* IF ZZTOT EQ. ZZAMT RETURN ZERO.
1581 C   95              Z-ADD     0             ZZTOTI
1582 C   95              Z-ADD     0             ZZTOTD
1583 C   95              GOTO      ZZSEND
1584 C*
1585 C* IF ZZTOT GT. ZZAMT.
1586 C   93ZZAMTD        COMP      ZZTOTD                             94
     C   93
1587 CAN 94ZZTOTI        SUB       1             ZZTOTI
     C   93
1588 CAN 94ZZTOTD        ADD       1000          ZZWK2
1589 C   93ZZTOTI        SUB       ZZAMTI        ZZTOTI
     C   93
1590 CAN 94ZZWK2         SUB       ZZAMTD        ZZTOTD
     C   93
1591 CANN94ZZTOTD        SUB       ZZAMTD        ZZTOTD
1592 C*
1593 C*
1594 C* IF ZZAMT GT. ZZTOT.
1595 C  N93ZZTOTD        COMP      ZZAMTD                             94
     C  N93
1596 CAN 94ZZAMTI        SUB       1             ZZWK3            15 0
     C  N93
1597 CAN 94ZZAMTD        ADD       1000          ZZWK2
     C  N93
1598 CAN 94ZZWK3         SUB       ZZTOTI        ZZTOTI
     C  N93
1599 CANN94ZZAMTI        SUB       ZZTOTI        ZZTOTI
1600 C********************************************************************
     C  N93
1601 CAN 94ZZWK2         SUB       ZZTOTD        ZZTOTD
     C  N93
1602 CANN94ZZAMTD        SUB       ZZTOTD        ZZTOTD
1603 C*
1604 C* REVERSE SIGN OF ZZTOT IF LARGER I/P FIELDS WERE NEGATIVE
1605 C                   SETOFF                                       94
     C   93
1606 CAN 91
     CORN93
1607 CAN 92              SETON                                        94
1608 C   94              Z-SUB     ZZTOTI        ZZTOTI
1609 C   94              Z-SUB     ZZTOTD        ZZTOTD
1610 C**
1611 C**   RESTORE SIGN OF ZZAMTI & ZZAMTD IF IT WAS REVERSED.
1612 C   92              Z-SUB     ZZAMTI        ZZAMTI
1613 C   92              Z-SUB     ZZAMTD        ZZAMTD
1614 C     ZZSEND        TAG                                                    ** ZZSEND TAG *
1615 C**
1616 C**   IF ZZTOTD IS ZERO, AND ZZTOTI IS NEG. SET UP ZZNEGD.
1617 C                   SETOFF                                       96
1618 C     ZZTOTD        COMP      0                                      91
1619 C   91ZZTOTI        COMP      0                                    96
1620 C   96              MOVE      '.000-'       ZZNEGD            5
1621 C                   ENDSR                                                    ** ENDSR **
      *                                                                                     BUG26704
      ****************************************************************                      BUG26704
      *                                                              *                      BUG26704
      *  SROPFL - Open printerfiles                                  *                      BUG26704
      *                                                              *                      BUG26704
      ****************************************************************                      BUG26704
     C     SROPFL        BEGSR                                                              BUG26704
      *                                                                                     BUG26704
      ** Open GL0420P1                                                                      BUG26704
      *                                                                                     BUG26704
     C     *IN87         IFEQ      *ON                                                      BUG26704
     C     OPENP1        ANDEQ     'N'                                                      BUG26704
     C                   MOVE      'Y'           OPENP1            1                        BUG26704
     C                   OPEN      GL0420P1                                                 BUG26704
      *                                                                                     BUG26704
      **  Ensure report spool file recorded by RCF                                          BUG26704
      *                                                                                     BUG26704
     C                   Z-ADD     SFNUM1        SFNO1             6 0                      BUG26704
     C                   CALL      'ZSFILE'                                                 BUG26704
     C                   PARM                    SEQ               5                        BUG26704
     C                   PARM      BRCA          SENTY             3                        BUG26704
     C                   PARM                    SFILE1                                     BUG26704
     C                   PARM                    SFNO1                                      BUG26704
     C                   PARM                    ZSERR             1                        BUG26704
      *                                                                                     BUG26704
     C     *LOCK         IN        LDA                                                      BUG26704
     C     ZSERR         IFEQ      'Y'                                                      BUG26704
      *                                                                                     BUG26704
      ** Error during ZSFILE processing, return to calling program                          BUG26704
      *                                                                                     BUG26704
     C                   SETON                                        U7U8LR                BUG26704
     C                   RETURN                                                             BUG26704
     C                   ENDIF                                                              BUG26704
     C                   OUT       LDA                                                      BUG26704
     C                   Z-ADD     0             PAGE                                       BUG26704
      *                                                                                     BUG26704
     C                   ENDIF                                                              BUG26704
      *                                                                                     BUG26704
      ** Open GL0420P2                                                                      BUG26704
      *                                                                                     BUG26704
     C     *IN60         IFEQ      *ON                                                      BUG26704
     C     OPENP2        ANDEQ     'N'                                                      BUG26704
     C                   MOVE      'Y'           OPENP2            1                        BUG26704
     C                   OPEN      GL0420P2                                                 BUG26704
      *                                                                                     BUG26704
      **  Ensure report spool file recorded by RCF                                          BUG26704
      *                                                                                     BUG26704
     C                   Z-ADD     SFNUM2        SFNO2             6 0                      BUG26704
     C                   CALL      'ZSFILE'                                                 BUG26704
     C                   PARM                    SEQ                                        BUG26704
     C                   PARM      BRCA          SENTY                                      BUG26704
     C                   PARM                    SFILE2                                     BUG26704
     C                   PARM                    SFNO2                                      BUG26704
     C                   PARM                    ZSERR                                      BUG26704
      *                                                                                     BUG26704
     C     *LOCK         IN        LDA                                                      BUG26704
     C     ZSERR         IFEQ      'Y'                                                      BUG26704
      *                                                                                     BUG26704
      ** Error during ZSFILE processing, return to calling program                          BUG26704
      *                                                                                     BUG26704
     C                   SETON                                        U7U8LR                BUG26704
     C                   RETURN                                                             BUG26704
     C                   ENDIF                                                              BUG26704
      *                                                                                     BUG26704
     C                   OUT       LDA                                                      BUG26704
     C                   Z-ADD     0             PAGE2                                      BUG26704
     C                   ENDIF                                                              BUG26704
      *                                                                                     BUG26704
      ** Open GL0420PR                                                                      BUG26704
      *                                                                                     BUG26704
     C     CGL046        IFEQ      'Y'                                                      BUG26704
     C     *IN60         IFEQ      *ON                                                      BUG26704
     C     OPENPR        ANDEQ     'N'                                                      BUG26704
     C                   MOVE      'Y'           OPENPR            1                        BUG26704
     C                   OPEN      GL0420PR                                                 BUG26704
      *                                                                                     BUG26704
      **  Ensure report spool file recorded by RCF                                          BUG26704
      *                                                                                     BUG26704
     C                   Z-ADD     SFNUM7        SFNO7             6 0                      BUG26704
     C                   CALL      'ZSFILE'                                                 BUG26704
     C                   PARM                    SEQ                                        BUG26704
     C                   PARM      BRCA          SENTY                                      BUG26704
     C                   PARM                    SFILE7                                     BUG26704
     C                   PARM                    SFNO7                                      BUG26704
     C                   PARM                    ZSERR                                      BUG26704
      *                                                                                     BUG26704
     C     *LOCK         IN        LDA                                                      BUG26704
     C     ZSERR         IFEQ      'Y'                                                      BUG26704
      *                                                                                     BUG26704
      ** Error during ZSFILE processing, return to calling program                          BUG26704
      *                                                                                     BUG26704
     C                   SETON                                        U7U8LR                BUG26704
     C                   RETURN                                                             BUG26704
     C                   ENDIF                                                              BUG26704
      *                                                                                     BUG26704
     C                   OUT       LDA                                                      BUG26704
     C                   ENDIF                                                              BUG26704
     C                   ENDIF                                                              BUG26704
      *                                                                                     BUG26704
      ** Open GL0420P3                                                                      BUG26704
      *                                                                                     BUG26704
     C     *IN62         IFEQ      *ON                                                      BUG26704
     C     OPENP3        ANDEQ     'N'                                                      BUG26704
     C                   MOVE      'Y'           OPENP3            1                        BUG26704
     C                   OPEN      GL0420P3                                                 BUG26704
      *                                                                                     BUG26704
      **  Ensure report spool file recorded by RCF                                          BUG26704
      *                                                                                     BUG26704
     C                   Z-ADD     SFNUM3        SFNO3             6 0                      BUG26704
     C                   CALL      'ZSFILE'                                                 BUG26704
     C                   PARM                    SEQ                                        BUG26704
     C                   PARM      BRCA          SENTY                                      BUG26704
     C                   PARM                    SFILE3                                     BUG26704
     C                   PARM                    SFNO3                                      BUG26704
     C                   PARM                    ZSERR                                      BUG26704
      *                                                                                     BUG26704
     C     *LOCK         IN        LDA                                                      BUG26704
     C     ZSERR         IFEQ      'Y'                                                      BUG26704
      *                                                                                     BUG26704
      ** Error during ZSFILE processing, return to calling program                          BUG26704
      *                                                                                     BUG26704
     C                   SETON                                        U7U8LR                BUG26704
     C                   RETURN                                                             BUG26704
     C                   ENDIF                                                              BUG26704
      *                                                                                     BUG26704
     C                   OUT       LDA                                                      BUG26704
     C                   Z-ADD     0             PAGE3                                      BUG26704
     C                   ENDIF                                                              BUG26704
      *                                                                                     BUG26704
      ** Open GL0420P4                                                                      BUG26704
      *                                                                                     BUG26704
     C     *IN64         IFEQ      *ON                                                      BUG26704
     C     OPENP4        ANDEQ     'N'                                                      BUG26704
     C                   MOVE      'Y'           OPENP4            1                        BUG26704
     C                   OPEN      GL0420P4                                                 BUG26704
      *                                                                                     BUG26704
      **  Ensure report spool file recorded by RCF                                          BUG26704
      *                                                                                     BUG26704
     C                   Z-ADD     SFNUM4        SFNO4             6 0                      BUG26704
     C                   CALL      'ZSFILE'                                                 BUG26704
     C                   PARM                    SEQ                                        BUG26704
     C                   PARM      BRCA          SENTY                                      BUG26704
     C                   PARM                    SFILE4                                     BUG26704
     C                   PARM                    SFNO4                                      BUG26704
     C                   PARM                    ZSERR                                      BUG26704
      *                                                                                     BUG26704
     C     *LOCK         IN        LDA                                                      BUG26704
     C     ZSERR         IFEQ      'Y'                                                      BUG26704
      *                                                                                     BUG26704
      ** Error during ZSFILE processing, return to calling program                          BUG26704
      *                                                                                     BUG26704
     C                   SETON                                        U7U8LR                BUG26704
     C                   RETURN                                                             BUG26704
     C                   ENDIF                                                              BUG26704
      *                                                                                     BUG26704
     C                   OUT       LDA                                                      BUG26704
     C                   Z-ADD     0             PAGE4                                      BUG26704
     C                   ENDIF                                                              BUG26704
      *                                                                                     BUG26704
      ** Open GL0420P5                                                                      BUG26704
      *                                                                                     BUG26704
     C     *IN66         IFEQ      *ON                                                      BUG26704
     C     OPENP5        ANDEQ     'N'                                                      BUG26704
     C                   MOVE      'Y'           OPENP5            1                        BUG26704
     C                   OPEN      GL0420P5                                                 BUG26704
      *                                                                                     BUG26704
      **  Ensure report spool file recorded by RCF                                          BUG26704
      *                                                                                     BUG26704
     C                   Z-ADD     SFNUM5        SFNO5             6 0                      BUG26704
     C                   CALL      'ZSFILE'                                                 BUG26704
     C                   PARM                    SEQ                                        BUG26704
     C                   PARM      BRCA          SENTY                                      BUG26704
     C                   PARM                    SFILE5                                     BUG26704
     C                   PARM                    SFNO5                                      BUG26704
     C                   PARM                    ZSERR                                      BUG26704
      *                                                                                     BUG26704
     C     *LOCK         IN        LDA                                                      BUG26704
     C     ZSERR         IFEQ      'Y'                                                      BUG26704
      *                                                                                     BUG26704
      ** Error during ZSFILE processing, return to calling program                          BUG26704
      *                                                                                     BUG26704
     C                   SETON                                        U7U8LR                BUG26704
     C                   RETURN                                                             BUG26704
     C                   ENDIF                                                              BUG26704
      *                                                                                     BUG26704
     C                   OUT       LDA                                                      BUG26704
     C                   Z-ADD     0             PAGE5                                      BUG26704
     C                   ENDIF                                                              BUG26704
      *                                                                                     BUG26704
      ** Open GL0420P6                                                                      BUG26704
      *                                                                                     BUG26704
     C     *IN80         IFEQ      *ON                                                      BUG26704
     C     OPENP6        ANDEQ     'N'                                                      BUG26704
     C                   MOVE      'Y'           OPENP6            1                        BUG26704
     C                   OPEN      GL0420P6                                                 BUG26704
      *                                                                                     BUG26704
      **  Ensure report spool file recorded by RCF                                          BUG26704
      *                                                                                     BUG26704
     C                   Z-ADD     SFNUM6        SFNO6             6 0                      BUG26704
     C                   CALL      'ZSFILE'                                                 BUG26704
     C                   PARM                    SEQ                                        BUG26704
     C                   PARM      BRCA          SENTY                                      BUG26704
     C                   PARM                    SFILE6                                     BUG26704
     C                   PARM                    SFNO6                                      BUG26704
     C                   PARM                    ZSERR                                      BUG26704
      *                                                                                     BUG26704
     C     *LOCK         IN        LDA                                                      BUG26704
     C     ZSERR         IFEQ      'Y'                                                      BUG26704
      *                                                                                     BUG26704
      ** Error during ZSFILE processing, return to calling program                          BUG26704
      *                                                                                     BUG26704
     C                   SETON                                        U7U8LR                BUG26704
     C                   RETURN                                                             BUG26704
     C                   ENDIF                                                              BUG26704
      *                                                                                     BUG26704
     C                   OUT       LDA                                                      BUG26704
     C                   Z-ADD     0             PAGE6                                      BUG26704
     C                   ENDIF                                                              BUG26704
      *                                                                                     BUG26704
     C                   ENDSR                                                              BUG26704
      *                                                                                     BUG26704
     C********************************************************************S01195
     C********************************************************************S01195
     C**                                                                  S01195
     C**   ZFREQB-SR. TO INCREMENT A DAY NUMBER DATE BY A                 S01195
     C**             PERIOD VALUE DETERMINED BY A CODE.                   S01195
     C**                                                                  S01195
     C********************************************************************S01195
      *                                                                   S01408
     C/COPY WNCPYSRC,GL0420CP41                                           S01408
      *                                                                   S01408
     C*COPY*ZSRSRC,ZFREQBZ2********************************************               S01195 CGL061A
      *                                                                   S01408
     C/COPY WNCPYSRC,GL0420CP42                                           S01408
      *                                                                   S01408
     C/EJECT                                                              S01195
     C********************************************************************S01195
     C*COPY*ZSRSRC,ZCHKH***********************************************               S01195 CGL061A
     C/COPY ZSRSRC,ZCHKHLE                                                                   CGL061A
     C/EJECT                                                              S01195
1622 C********************************************************************
1622 C********************************************************************
     C/EJECT                                                              S01195
     C********************************************************************S01194
     C*                                                                   S01195
     C* ZACCH  --- SUBROUTINE TO ACCESS A HOLIDAY RECORD FOR A            S01195
     C*            PARTICULAR CURRENCY AND (OPTIONAL) LOCATION.           S01195
     C*                                                                   S01195
     C* CALLED FROM: ZFWDT, ZBKDT                                         S01195
     C*                                                                   S01195
     C* CALLS: NOTHING                                                    S01195
     C*                                                                   S01195
     C********************************************************************S01195
     C*COPY*ZSRSRC,ZACCH***********************************************               S01195 CGL061A
     C/COPY ZSRSRC,ZACCHLE                                                                   CGL061A
     C/EJECT                                                              S01195
     C********************************************************************S01195
     C*                                                                   S01195
     C* ZFWDT  --- SUBROUTINE TO CALCULATE THE NTH WORKING DAY            S01195
     C*            FORWARD FROM A GIVEN START DATE FOR ANY                S01195
     C*            PARTICULAR CURRENCY AND (OPTIONAL) LOCATION.           S01195
     C*                                                                   S01195
     C* CALLED FROM: ZFREQS                                               S01195
     C*                                                                   S01195
     C* CALLS: ZACCH                                                      S01195
     C*                                                                   S01195
     C********************************************************************S01195
     C*COPY*ZSRSRC,ZFWDT***********************************************               S01195 CGL061A
     C/COPY ZSRSRC,ZFWDT_ILE                                                                 CGL061A
     C/EJECT                                                              S01195
     C********************************************************************S01195
     C*                                                                   S01195
     C* ZBKDT  --- SUBROUTINE TO CALCULATE THE NTH WORKING DAY            S01195
     C*            BACKWARD FROM A GIVEN START DATE FOR ANY               S01195
     C*            PARTICULAR CURRENCY AND (OPTIONAL) LOCATION.           S01195
     C*                                                                   S01195
     C* CALLED FROM: ZFREQS                                               S01195
     C*                                                                   S01195
     C* CALLS: ZACCH                                                      S01195
     C*                                                                   S01195
     C********************************************************************S01195
     C*COPY*ZSRSRC,ZBKDT***********************************************               S01195 CGL061A
     C/COPY ZSRSRC,ZBKDT_ILE                                                                 CGL061A
     C*                                                                   S01408
     C/COPY WNCPYSRC,GL0420CP58                                           S01408
     C*                                                                   S01408
     C/EJECT                                                              S01194
     C********************************************************************S01194
     C*                                                                   S01194
     C* *PSSR  --- SUBROUTINE TO HANDLE ABNORMAL ERROR CONDITIONS         S01194
     C*                                                                   S01194
     C* CALLED FROM: AFTER ABNORNAL OPERATION OCCURS                      S01194
     C*                                                                   S01194
     C* CALLS: NOTHING                                                    S01194
     C*                                                                   S01194
     C********************************************************************S01194
     C*                                                                   S01194
     C     *PSSR         BEGSR                                                  ** *PSSR **    S0119
     C*                                                                   S01194
     C     @RUN          IFEQ      *BLANKS                                                    S01194
     C                   MOVE      'Y'           @RUN              1                          S01194
     C                   SETON                                        U7U8                    E26667
     C                   DUMP                                                                 S01194
     C                   END                                                                  S01194
     C                   ENDSR                                                                S01194
     C********************************************************************S01194
     C*                                                                   S01408
     C/COPY WNCPYSRC,GL0420CP29                                           S01408
     C*                                                                   S01408
1623 C/EJECT
     C/COPY WNCPYSRC,GL0420C004
1624 O*PRINTS1H   03   60                                                 S01091
1624 O*PRINTS1E   03   60                                                 S01125
1624 O*L0420P2E   03   60                                                 S01146
1624 O*L0420P2E** 01   60                                          S01146 S01117
1624 OGL0420P2  E    60 84                    01                                S01117
     O         AND   27                                                         CGL046
     O         OR    60 84                    01                                           AR1014455
     O         AND  N27NKL                                                                 AR1014455
     O/COPY WNCPYSRC,GL0420O001
     O                       FICHE               16                             S01146
     O********E** 03   60                                          S01146 S01117
     O*                                                                   S01408
     O/COPY WNCPYSRC,GL0420OP10                                           S01408
     O*                                                                   S01408
1624 OGL0420P2  E    60 84                    03                                S01117
     O         AND   27                                                         CGL046
     O         OR    60 84                    03                                           AR1014455
     O         AND  N27NKL                                                                 AR1014455
     O/COPY WNCPYSRC,GL0420O037
1625 O***********         36   CNA1      35                               S01194
1625 O***********         36   BCCNA1    35                        S01194 LN0012
1625 O                  36   @WCNA1              35                             LN0012
1626 O                  35                       71 'DEMAND STATEMENT'
1627 O*       H   04   61                                                 S01091
1627 O********E** 04   61                                       S01091    S01117
1627 O          E    61 84                    04                                S01117
     O         AND   27                                                         CGL046
     O         OR    61 84                    04                                           AR1014455
     O         AND  N27NKL                                                                 AR1014455
     O/COPY WNCPYSRC,GL0420O038
1628 O***********            36CNA2      35                               S01194
1628 O***********            36BCCNA2    35                        S01194 LN0012
1628 O                     36@WCNA2              35                             LN0012
1629 O*       H   05   61                                                 S01091
1629 O********E** 05   61                                       S01091    S01117
1629 O          E    61 84                    05                                S01117
     O         AND   27                                                         CGL046
     O         OR    61 84                    05                                           AR1014455
     O         AND  N27NKL                                                                 AR1014455
     O/COPY WNCPYSRC,GL0420O039
1630 O***********            36CNA3      35                               S01194
1630 O***********            36BCCNA3    35                        S01194 LN0012
1630 O                     36@WCNA3              35                             LN0012
1631 O*       H   06   61                                                 S01091
1631 O********E** 06   61                                       S01091    S01117
1631 O          E    61 84                    06                                S01117
     O         AND   27                                                         CGL046
     O         OR    61 84                    06                                           AR1014455
     O         AND  N27NKL                                                                 AR1014455
     O/COPY WNCPYSRC,GL0420O040
1632 O***********            36CNA4      35                               S01194
1632 O***********            36BCCNA4    35                        S01194 LN0012
1632 O                     36@WCNA4              35                             LN0012
1633 O*
     O*                                                                   S01408
     O/COPY WNCPYSRC,GL0420OP11                                           S01408
     O*                                                                   S01408
1634 O*
1635 O*       H   07   60                                                 S01091
1635 O********E** 07   60                                       S01091    S01117
1635 O          E    60 84                    07                                S01117
     O         AND   27                                                         CGL046
     O         OR    60 84                    07                                           AR1014455
     O         AND  N27NKL                                                                 AR1014455
     O/COPY WNCPYSRC,GL0420O041
1636 O* ETC.
1637 O*****                              49 'OUR REF'                     S01117
     O                                           45 'OUR REF'                   S01117
     O               58      BRCA                50                             S01117
     O               58                          51 '-'                         S01117
1638 O**********                         67 '-   -    -'                                      CGL029
     O**********                         73 '-   -    -'                               CGL029 245223
     O                                           58 '-'                                       245223
     O                                           62 '-'                                       245223
     O                                           73 '-'                                       245223
1639 O                       CNUM                57
1640 O                       CCY                 61
1641 O**********               ACOD      66                                                   CGL029
1642 O**********               ACSQ      69                                                   CGL029
1643 O**********      N27      ACNO      80                                                   CGL029
     O                       ACOD                72                                           CGL029
     O                       ACSQ                75                                           CGL029
     O              N27      ACNO                86                                           CGL029
1644 O**********                         97 'BRANCH -'                    S01194
1644 O                  58                       97 'BRANCH -'                  S01194
1645 O***********              BRNM     128                               S01194
     O                  58   A8BRNM             128                             S01194
1646 O*       H   08   60                                                 S01091
1646 O********E** 08   60                                       S01091    S01117
1646 O          E    60 84                    08                                S01117
     O         AND   27                                                         CGL046
     O         OR    60 84                    08                                           AR1014455
     O         AND  N27NKL                                                                 AR1014455
     O/COPY WNCPYSRC,GL0420O042
1647 O***********              PAGE  3  128                               S01117
1647 O                       PAGE2         3    128                             S01117
     O*                                                                   S01408
     O/COPY WNCPYSRC,GL0420OP12                                           S01408
     O*                                                                   S01408
1648 O*       H   10   60                                                 S01091
1648 O********E** 10   60                                       S01091    S01117
1648 O          E    60 84                    10                                S01117
     O         AND   27                                                         CGL046
     O         OR    60 84                    10                                           AR1014455
     O         AND  N27NKL                                                                 AR1014455
     O/COPY WNCPYSRC,GL0420O043
1649 O                                           10 'ACCOUNT'
1650 O                       ANAM                33
     O/COPY WNCPYSRC,GLH00369
1651 O                                           48 'CURRENCY'
1652 O                       CCNM                65
     O/COPY WNCPYSRC,GL0420O128
1653 O                                           77 'DATE'
1654 O                       RUNA                87
     O/COPY WNCPYSRC,GL0420O129
1655 O                                          102 'PAGE'
     O/COPY WNCPYSRC,GL0420OY63                                           S01408
1656 O                       STPA          3    108
     O/COPY WNCPYSRC,GLH00439
     O          E    60 84 05                 11                                CFT004
     O                       RIBAN               50                             CFT004
1657 O*       H   13   60                                                 S01091
1657 O********E** 13   60                                       S01091    S01117
     O*                                                                   S01408
     O** Core hook for externalisation.                                   S01408
     O/COPY WNCPYSRC,GL0420OOP6                                           S01408
     O*                                                                   S01408
1657 O          E    60 84                    13                                S01117
     O         AND   27                                                         CGL046
     O         OR    60 84                    13                                           AR1014455
     O         AND  N27NKL                                                                 AR1014455
     O/COPY WNCPYSRC,GL0420O044
1658 O                                            7 'POSTING'
1659 O                                           16 'VALUE'
1660 O                                           27 'CHEQUE'
1661 O                                           50 'NARRATIVE'
     O/COPY WNCPYSRC,GL0420O107
1662 O                                           76 'DEBITS'
1663 O                                           99 'CREDITS'
1664 O                                          121 'BALANCE'
1665 O*       H   14   60                                                 S01091
1665 O*       E   14   60                                                 S01091
1666 O*                                   6 'DATE'
1667 O*                                  16 'DATE'
1668 O*                                  25 'NO'
1665 O********E** 14   60                                       E10600    S01117
     O/COPY WNCPYSRC,GL0420O070
1665 O          E    60 84                    14                                S01117
     O         AND   27                                                         CGL046
     O         OR    60 84                    14                                           AR1014455
     O         AND  N27NKL                                                                 AR1014455
     O/COPY WNCPYSRC,GL0420O045
1666 O                                            6 'DATE'                      E10600
1667 O                                           16 'DATE'                      E10600
1668 O                                           25 'NO'                        E10600
1669 O*       H   16   60                                                 S01091
1669 O********E** 16   60                                       S01091    S01117
     O/COPY WNCPYSRC,GL0420O071
1669 O          E    60 84                    16                                S01117
     O         AND   27                                                         CGL046
     O         OR    60 84                    16                                           AR1014455
     O         AND  N27NKL                                                                 AR1014455
     O/COPY WNCPYSRC,GL0420O046
1670 O                                           60 'B/F'
     O*                                                                   S01408
     O/COPY WNCPYSRC,GL0420OP19                                           S01408
     O*                                                                   S01408
1671 O                       LSTDA                8
     O/COPY WNCPYSRC,GL0420O155
1672 O                     70PSTBF              127 '   ,   ,   ,   , 0 CR'
1673 O                     71PSTBF              127 '  ,   ,   ,   , 0 . CR'
1674 O                     72PSTBF              127 ' ,   ,   ,   , 0 .  CR'
1675 O                     73PSTBF              127 '   ,   ,   , 0 .   CR'
1676 O               83                         127 'DR'
     O/COPY WNCPYSRC,GL0420O075
     O**                                                                  CEU013
     O          E    60 84 10            1                                      CEU013
     O         AND   27                                                         CGL046
     O         OR    60 84 10            1                                                 AR1014455
     O         AND  N27NKL                                                                 AR1014455
     O                       BKEURO              65                             156327
     O                                          105 '('                         CEU013
     O                     KAEUPBF              128 '   ,   ,   ,   , 0 CR)'    CEU013
     O                     KBEUPBF              128 '  ,   ,   ,   , 0 . CR)'   CEU013
     O                     KCEUPBF              128 ' ,   ,   ,   , 0 .  CR)'   CEU013
     O                     KDEUPBF              128 '   ,   ,   , 0 .   CR)'    CEU013
     O               83                         128 'DR)'                       CEU013
     O**                                                                  CEU013
1677 O***     D 1      41 51N34                                           S01091
     O/COPY WNCPYSRC,GL0420O130
1677 O          E    41 51N34DET         1                                      S01091
     O/COPY WNCPYSRC,GL0420O047
1678 O**     AND       04                                            S1091S01110
1678 O*******AND*      04N12                                    S01110    S01117
1678 O         AND   04N12 84                                                   S01117
     O         AND   27                                                         CGL046
     O         OR    41 51N34            1                                                 AR1014455
     O         AND   04N12 84                                                              AR1014455
     O         AND  N27NKL                                                                 AR1014455
1679 O                       PSTDA                8
1680 O                     69VALDA               18
1681 O                                           32 'DR'
1682 O                     22                    32 'CR'
1683 O                                           47 'RATE CHANGE TO'
1684 O                       INTR                61 '  0 .       -'
1685 O                                           62 '%'
     O/COPY WNCPYSRC,GL0420O078
1686 O***     D 1      41 51N34                                           S01091
1686 O          E    41 51N34DET         1                                      S01091
1687 O*******AND*     N04                                                 S01117
1687 O         AND  N04 84                                                      S01117
     O         AND   27                                                         CGL046
     O         OR    41 51N34            1                                                 AR1014455
     O         AND  N04 84                                                                 AR1014455
     O         AND  N27NKL                                                                 AR1014455
     O/COPY WNCPYSRC,GL0420O048
1688 O                       PSTDA                8
1689 O                     69VALDA               18
     O*                                                                   S01408
     O** Core hook for externalisation.                                   S01408
     O/COPY WNCPYSRC,GL0420OOP2                                           S01408
     O*                                                                   S01408
1690 O              N25      CHQN                28
1691 O                       PNAR                60
     O/COPY WNCPYSRC,GL0420O146
1692 O                  23 70PSTA                81 ' ,   ,   ,   , 0 '
1693 O                  23 71PSTA                81 '   ,   ,   , 0 . '
1694 O                  23 72PSTA                81 '  ,   ,   , 0 .  '
1695 O                  23 73PSTA                81 ' ,   ,   , 0 .   '
1696 O                  22 70PSTA               103 ' ,   ,   ,   , 0 '
1697 O                  22 71PSTA               103 '   ,   ,   , 0 . '
1698 O                  22 72PSTA               103 '  ,   ,   , 0 .  '
1699 O                  22 73PSTA               103 ' ,   ,   , 0 .   '
     O/COPY WNCPYSRC,GL0420O079
1687 O*                                                                   CEU013
     O          E    41 51N34DET         1                                      CEU013
     O         AND  N04 84 78                                                   CEU013
     O         AND   27                                                         CGL046
     O         OR    41 51N34            1                                                 AR1014455
     O         AND  N04 84 78                                                              AR1014455
     O         AND  N27NKL                                                                 AR1014455
     O                       ROCCY               33                             CEU013
     O                     KEROAMT               54 '   ,   ,   ,   , 0 '       CEU013
     O                     KFROAMT               54 '  ,   ,   ,   , 0 . '      CEU013
     O                     KGROAMT               54 ' ,   ,   ,   , 0 .  '      CEU013
     O                     KHROAMT               54 '   ,   ,   , 0 .   '       CEU013
     O          E    41 51N34DET         1                                      216937
     O         AND  N04 84 53                                                   216937
     O         AND   27                                                         CGL046
     O         OR    41 51N34            1                                                 AR1014455
     O         AND  N04 84 53                                                              AR1014455
     O         AND  N27NKL                                                                 AR1014455
     O                       W#ORIG              70                             216937
     O*                                                                   S01408
     O/COPY WNCPYSRC,GL0420OP13                                           S01408
     O*                                                                   S01408
1700 O**   END OF POSTING DATE ONLY
1701 O**
1702 O*       T 00     L1 41 49                                           S01091
1702 O          E    L1 41 49BAL         0  0                                   S01091
1703 O*******AND*     N52N34                                              S01117
1703 O         AND  N52N34 84                                                   S01117
     O         AND   27                                                         CGL046
     O         OR    L1 41 49            0  0                                              AR1014455
     O         AND  N52N34 84                                                              AR1014455
     O         AND  N27NKL                                                                 AR1014455
     O/COPY WNCPYSRC,GL0420O049
1704 O                     70PSTBAL             127 '   ,   ,   ,   , 0 CR'
1705 O                     71PSTBAL             127 '  ,   ,   ,   , 0 . CR'
1706 O                     72PSTBAL             127 ' ,   ,   ,   , 0 .  CR'
1707 O                     73PSTBAL             127 '   ,   ,   , 0 .   CR'
     O/COPY WNCPYSRC,GL0420O156
1708 O                     47                   127 'DR'
1709 O**   END OF PAGE IND 45
1710 O**
1711 O*       T 1         41 45                                           S01091
1711 O          E       41 45ENDPG       1                                      S01091
1712 O*******AND*     N34                                                 S01117
1712 O         AND  N34 84                                                      S01117
     O         AND  N33                                                         S01377
     O/COPY WNCPYSRC,GL0420O050
1713 O*      OR           41 52
1714 O*      AND      N34
     O         AND   27                                                         CGL046
     O         OR    41 45               1                                                 AR1014455
     O         AND  N34N33 84                                                              AR1014455
     O         AND  N27NKL                                                                 AR1014455
1715 O                                           60 'C/F'
     O/COPY WNCPYSRC,GL0420O157
1716 O                     70PSTBAL             127 '   ,   ,   ,   , 0 CR'
1717 O                     71PSTBAL             127 '  ,   ,   ,   , 0 . CR'
1718 O                     72PSTBAL             127 ' ,   ,   ,   , 0 .  CR'
1719 O                     73PSTBAL             127 '   ,   ,   , 0 .   CR'
     O/COPY WNCPYSRC,GL0420O158
1720 O                     47                   127 'DR'
     O**                                                                  CEU013
     O          E       41 45ENDPG       1                                      CEU013
     O         AND  N34 84                                                      CEU013
     O         AND  N33 10                                                      CEU013
     O         AND   27                                                         CGL046
     O         OR    41 45 84            1                                                 AR1014455
     O         AND  N34N33 10                                                              AR1014455
     O         AND  N27NKL                                                                 AR1014455
     O                       BKEURO              65                             156327
     O                                          105 '('                         CEU013
     O                     KAEUPBAL             128 '   ,   ,   ,   , 0 CR)'    CEU013
     O                     KBEUPBAL             128 '  ,   ,   ,   , 0 . CR)'   CEU013
     O                     KCEUPBAL             128 ' ,   ,   ,   , 0 .  CR)'   CEU013
     O                     KDEUPBAL             128 '   ,   ,   , 0 .   CR)'    CEU013
     O                     47                   128 'DR)'                       CEU013
     O**                                                                  CEU013
1713 O*       T 1         41 52                                      S1091S01091
1713 O          E       41 52TOT         1                                      S01091
1714 O*******AND*     N34                                       S01091    S01117
1714 O         AND  N34 84                                                      S01117
     O         AND  N33                                                         S01377
     O         AND   27                                                         CGL046
     O         OR       41 52            1                                                 AR1014455
     O         AND  N34N33 84                                                              AR1014455
     O         AND  N27NKL                                                                 AR1014455
     O/COPY WNCPYSRC,GL0420O051
1715 O                                           60 'C/F'                       S01091
1716 O                     70PSTBAL             127 '   ,   ,   ,   , 0 CR'     S01091
1717 O                     71PSTBAL             127 '  ,   ,   ,   , 0 . CR'    S01091
1718 O                     72PSTBAL             127 ' ,   ,   ,   , 0 .  CR'    S01091
1719 O                     73PSTBAL             127 '   ,   ,   , 0 .   CR'     S01091
     O/COPY WNCPYSRC,GL0420O159
1720 O                     47                   127 'DR'                        S01091
     O**                                                                  CEU013
     O          E       41 52TOT         1                                      CEU013
     O         AND  N34 84                                                      CEU013
     O         AND  N33 10                                                      CEU013
     O                       BKEURO              65                             156327
     O                                          105 '('                         CEU013
     O                     KAEUPBAL             128 '   ,   ,   ,   , 0 CR)'    CEU013
     O                     KBEUPBAL             128 '  ,   ,   ,   , 0 . CR)'   CEU013
     O                     KCEUPBAL             128 ' ,   ,   ,   , 0 .  CR)'   CEU013
     O                     KDEUPBAL             128 '   ,   ,   , 0 .   CR)'    CEU013
     O                     47                   128 'DR)'                       CEU013
     O**                                                                  CEU013
     O          E       41 52TOT         1                                      216006
     O         AND  N34 84                                                      216006
     O         AND  N33 82                                                      216006
     O                       WCMTX1              97                             216006
     O          E       41 52TOT         1                                      216006
     O         AND  N34 84                                                      216006
     O         AND  N33 82                                                      216006
     O                       WCMTX2              97                             216006
     O          E       41 52TOT         1                                      216006
     O         AND  N34 84                                                      216006
     O         AND  N33 82                                                      216006
     O                       WCMTX3              97                             216006
     O          E       41 52TOT         1                                      216006
     O         AND  N34 84                                                      216006
     O         AND  N33 82                                                      216006
     O                       WCMTX4              97                             216006
     O**                                                                  216006
     O/COPY WNCPYSRC,GL0420O036
1721 O**   END OF PAGE ONLY
1722 O**
1723 O*       T 1         41 45                                           S01091
1723 O********E 1         41 45ENDPG                               S01091 E10600
1723 O          E       41 45ENDPG       1  1                                   E10600
1724 O*******AND*     N34                                                 S01117
1724 O         AND  N34 84                                                      S01117
     O         AND   27                                                         CGL046
     O         OR    41 45               1  1                                              AR1014455
     O         AND  N34 84                                                                 AR1014455
     O         AND  N27NKL                                                                 AR1014455
     O/COPY WNCPYSRC,GL0420O052
1725 O                                          116 '- CONTD'
     O/COPY WNCPYSRC,GL0420OO12                                           S01408
     O********E*1 03           ERPT2                                                   S01117 239641
     O          E            ERPT2       1                                                    239641
     O         AND  N33                                                         S01377
     O         AND   27                                                         CGL046
     O         OR   N33                  1                                                 AR1014455
     O         AND  N27NKL                                                                 AR1014455
     O/COPY WNCPYSRC,GL0420O053
     O                                           66 '*** END OF REPORT '        S01117
     O               58                          77 'FOR BRANCH '               S01117
     O               58      BRCASV              80                             S01117
     O               58                          84 ' ***'                      S01117
     O              N58                          69 '***'                       S01117
1726 O/EJECT
     OGL0420PR  E    60 84                    01                                CGL046
     O*******AND      N27 20                                              CGL046            BG12511A
     O         AND  N27 KL                                                      CGL046            BG
     O                       FICHE               16                             CGL046
      *                                                                   CGL046
     OGL0420PR  E    60 84                    03                                CGL046
     O*******AND      N27 20                                              CGL046            BG12511A
     O         AND  N27 KL                                                      CGL046            BG
     O                  36   @WCNA1              35                             CGL046
     O                  35                       71 'DEMAND STATEMENT'          CGL046
      *       H   04   61                                                 CGL046
     O          E    61 84                    04                                CGL046
     O*******AND      N27 20                                              CGL046            BG12511A
     O         AND  N27 KL                                                      CGL046            BG
     O                     36@WCNA2              35                             CGL046
      *       H   05   61                                                 CGL046
     O          E    61 84                    05                                CGL046
     O*******AND      N27 20                                              CGL046            BG12511A
     O         AND  N27 KL                                                      CGL046            BG
     O                     36@WCNA3              35                             CGL046
      *       H   06   61                                                 CGL046
     O          E    61 84                    06                                CGL046
     O*******AND      N27 20                                              CGL046            BG12511A
     O         AND  N27 KL                                                      CGL046            BG
     O                     36@WCNA4              35                             CGL046
      *                                                                   CGL046
     O          E    60 84                    07                                CGL046
     O*******AND      N27 20                                              CGL046            BG12511A
     O         AND  N27 KL                                                      CGL046            BG
      * ETC.                                                              CGL046
     O                                           45 'OUR REF'                   CGL046
     O               58      BRCA                50                             CGL046
     O               58                          51 '-'                         CGL046
     O                                           73 '-   -    -'                CGL046
     O                       CNUM                57                             CGL046
     O                       CCY                 61                             CGL046
     O                       ACOD                72                             CGL046
     O                       ACSQ                75                             CGL046
     O*********       N27 20   ACNO      86                               CGL046            BG12511A
     O              N27      ACNO                86                             CGL046            BG
     O                  58                       97 'BRANCH -'                  CGL046
     O                  58   A8BRNM             128                             CGL046
      *       H   08   60                                                 CGL046
     O          E    60 84                    08                                CGL046
     O*******AND      N27 20                                              CGL046            BG12511A
     O         AND  N27 KL                                                      CGL046            BG
     O                       PAGE2         3    128                             CGL046
      *                                                                   CGL046
     O          E    60 84                    10                                CGL046
     O*******AND      N27 20                                              CGL046            BG12511A
     O         AND  N27 KL                                                      CGL046            BG
     O                                           10 'ACCOUNT'                   CGL046
     O                       ANAM                33                             CGL046
     O                                           48 'CURRENCY'                  CGL046
     O                       CCNM                65                             CGL046
     O                                           77 'DATE'                      CGL046
     O                       RUNA                87                             CGL046
     O                                          102 'PAGE'                      CGL046
     O                       STPA          3    108                             CGL046
      *                                                                   CGL046
     O          E    60 84                    13                                CGL046
     O*******AND      N27 20                                              CGL046            BG12511A
     O         AND  N27 KL                                                      CGL046            BG
     O                                            7 'POSTING'                   CGL046
     O                                           16 'VALUE'                     CGL046
     O                                           27 'CHEQUE'                    CGL046
     O                                           50 'NARRATIVE'                 CGL046
     O                                           76 'DEBITS'                    CGL046
     O                                           99 'CREDITS'                   CGL046
     O                                          121 'BALANCE'                   CGL046
     O          E    60 84                    14                                CGL046
     O*******AND      N27 20                                              CGL046            BG12511A
     O         AND  N27 KL                                                      CGL046            BG
     O                                            6 'DATE'                      CGL046
     O                                           16 'DATE'                      CGL046
     O                                           25 'NO'                        CGL046
     O          E    60 84                    16                                CGL046
     O*******AND      N27 20                                              CGL046            BG12511A
     O         AND  N27 KL                                                      CGL046            BG
     O                                           60 'B/F'                       CGL046
      *                                                                   CGL046
     O                       LSTDA                8                             CGL046
     O                     70PSTBF              127 '   ,   ,   ,   , 0 CR'     CGL046
     O                     71PSTBF              127 '  ,   ,   ,   , 0 . CR'    CGL046
     O                     72PSTBF              127 ' ,   ,   ,   , 0 .  CR'    CGL046
     O                     73PSTBF              127 '   ,   ,   , 0 .   CR'     CGL046
     O               83                         127 'DR'                        CGL046
      *                                                                   CGL046
     O          E    60 84 10            1                                      CGL046
     O*******AND      N27 20                                              CGL046            BG12511A
     O         AND  N27 KL                                                      CGL046            BG
     O                                          105 '('                         CGL046
     O                     KAEUPBF              128 '   ,   ,   ,   , 0 CR)'    CGL046
     O                     KBEUPBF              128 '  ,   ,   ,   , 0 . CR)'   CGL046
     O                     KCEUPBF              128 ' ,   ,   ,   , 0 .  CR)'   CGL046
     O                     KDEUPBF              128 '   ,   ,   , 0 .   CR)'    CGL046
     O               83                         128 'DR)'                       CGL046
      **                                                                  CGL046
     O          E    41 51N34DET         1                                      CGL046
     O         AND   04N12 84                                                   CGL046
     O*******AND      N27 20                                              CGL046            BG12511A
     O         AND  N27 KL                                                      CGL046            BG
     O                       PSTDA                8                             CGL046
     O                     69VALDA               18                             CGL046
     O                                           32 'DR'                        CGL046
     O                     22                    32 'CR'                        CGL046
     O                                           47 'RATE CHANGE TO'            CGL046
     O                       INTR                61 '  0 .       -'             CGL046
     O                                           62 '%'                         CGL046
     O          E    41 51N34DET         1                                      CGL046
     O         AND  N04 84                                                      CGL046
     O*******AND      N27 20                                              CGL046            BG12511A
     O         AND  N27 KL                                                      CGL046            BG
     O                       PSTDA                8                             CGL046
     O                     69VALDA               18                             CGL046
      *                                                                   CGL046
     O              N25      CHQN                28                             CGL046
     O                       PNAR                60                             CGL046
     O                  23 70PSTA                81 ' ,   ,   ,   , 0 '         CGL046
     O                  23 71PSTA                81 '   ,   ,   , 0 . '         CGL046
     O                  23 72PSTA                81 '  ,   ,   , 0 .  '         CGL046
     O                  23 73PSTA                81 ' ,   ,   , 0 .   '         CGL046
     O                  22 70PSTA               103 ' ,   ,   ,   , 0 '         CGL046
     O                  22 71PSTA               103 '   ,   ,   , 0 . '         CGL046
     O                  22 72PSTA               103 '  ,   ,   , 0 .  '         CGL046
     O                  22 73PSTA               103 ' ,   ,   , 0 .   '         CGL046
      *                                                                   CGL046
     O          E    41 51N34DET         1                                      CGL046
     O         AND  N04 84 78                                                   CGL046
     O*******AND      N27 20                                              CGL046            BG12511A
     O         AND  N27 KL                                                      CGL046            BG
     O                       ROCCY               33                             CGL046
     O                     KEROAMT               54 '   ,   ,   ,   , 0 '       CGL046
     O                     KFROAMT               54 '  ,   ,   ,   , 0 . '      CGL046
     O                     KGROAMT               54 ' ,   ,   ,   , 0 .  '      CGL046
     O                     KHROAMT               54 '   ,   ,   , 0 .   '       CGL046
     O          E    41 51N34DET         1                                      CGL046
     O         AND  N04 84 53                                                   CGL046
     O*******AND      N27 20                                              CGL046            BG12511A
     O         AND  N27 KL                                                      CGL046            BG
     O                       W#ORIG              70                             CGL046
      *                                                                   CGL046
      **   END OF POSTING DATE ONLY                                       CGL046
     O          E    L1 41 49BAL         0  0                                   CGL046
     O         AND  N52N34 84                                                   CGL046
     O*******AND      N27 20                                              CGL046            BG12511A
     O         AND  N27 KL                                                      CGL046            BG
     O                     70PSTBAL             127 '   ,   ,   ,   , 0 CR'     CGL046
     O                     71PSTBAL             127 '  ,   ,   ,   , 0 . CR'    CGL046
     O                     72PSTBAL             127 ' ,   ,   ,   , 0 .  CR'    CGL046
     O                     73PSTBAL             127 '   ,   ,   , 0 .   CR'     CGL046
     O                     47                   127 'DR'                        CGL046
      *    END OF PAGE IND 45                                             CGL046
      *                                                                   CGL046
      *       T 1         41 45                                           CGL046
     O          E       41 45ENDPG       1                                      CGL046
     O         AND  N34 84                                                      CGL046
     O         AND  N33                                                         CGL046
     O*******AND      N27 20                                              CGL046            BG12511A
     O         AND  N27 KL                                                      CGL046            BG
     O                                           60 'C/F'                       CGL046
     O                     70PSTBAL             127 '   ,   ,   ,   , 0 CR'     CGL046
     O                     71PSTBAL             127 '  ,   ,   ,   , 0 . CR'    CGL046
     O                     72PSTBAL             127 ' ,   ,   ,   , 0 .  CR'    CGL046
     O                     73PSTBAL             127 '   ,   ,   , 0 .   CR'     CGL046
     O                     47                   127 'DR'                        CGL046
      *                                                                   CGL046
     O          E       41 45ENDPG       1                                      CGL046
     O         AND  N34 84                                                      CGL046
     O         AND  N33 10                                                      CGL046
     O         AND   27                                                         CGL046
      * Can only write if file is OPEN                                                      BG12511A
     O         AND   KL                                                                     BG12511A
     O                                          105 '('                         CGL046
     O                     KAEUPBAL             128 '   ,   ,   ,   , 0 CR)'    CGL046
     O                     KBEUPBAL             128 '  ,   ,   ,   , 0 . CR)'   CGL046
     O                     KCEUPBAL             128 ' ,   ,   ,   , 0 .  CR)'   CGL046
     O                     KDEUPBAL             128 '   ,   ,   , 0 .   CR)'    CGL046
     O                     47                   128 'DR)'                       CGL046
      *                                                                   CGL046
     O          E       41 52TOT         1                                      CGL046
     O         AND  N34 84                                                      CGL046
     O         AND  N33                                                         CGL046
     O*******AND      N27 20                                              CGL046            BG12511A
     O         AND  N27 KL                                                      CGL046            BG
     O                                           60 'C/F'                       CGL046
     O                     70PSTBAL             127 '   ,   ,   ,   , 0 CR'     CGL046
     O                     71PSTBAL             127 '  ,   ,   ,   , 0 . CR'    CGL046
     O                     72PSTBAL             127 ' ,   ,   ,   , 0 .  CR'    CGL046
     O                     73PSTBAL             127 '   ,   ,   , 0 .   CR'     CGL046
     O                     47                   127 'DR'                        CGL046
      *                                                                   CGL046
     O          E       41 52TOT         1                                      CGL046
     O         AND  N34 84                                                      CGL046
     O         AND  N33 10                                                      CGL046
     O*******AND      N27 20                                              CGL046            BG12511A
     O         AND  N27 KL                                                      CGL046            BG
     O                                          105 '('                         CGL046
     O                     KAEUPBAL             128 '   ,   ,   ,   , 0 CR)'    CGL046
     O                     KBEUPBAL             128 '  ,   ,   ,   , 0 . CR)'   CGL046
     O                     KCEUPBAL             128 ' ,   ,   ,   , 0 .  CR)'   CGL046
     O                     KDEUPBAL             128 '   ,   ,   , 0 .   CR)'    CGL046
     O                     47                   128 'DR)'                       CGL046
      *                                                                   CGL046
     O          E       41 52TOT         1                                      CGL046
     O         AND  N34 84                                                      CGL046
     O         AND  N33 82                                                      CGL046
     O*******AND      N27 20                                              CGL046            BG12511A
     O         AND  N27 KL                                                      CGL046            BG
     O                       WCMTX1              97                             CGL046
     O          E       41 52TOT         1                                      CGL046
     O         AND  N34 84                                                      CGL046
     O         AND  N33 82                                                      CGL046
     O*******AND      N27 20                                              CGL046            BG12511A
     O         AND  N27 KL                                                      CGL046            BG
     O                       WCMTX2              97                             CGL046
     O          E       41 52TOT         1                                      CGL046
     O         AND  N34 84                                                      CGL046
     O         AND  N33 82                                                      CGL046
     O*******AND      N27 20                                              CGL046            BG12511A
     O         AND  N27 KL                                                      CGL046            BG
     O                       WCMTX3              97                             CGL046
     O          E       41 52TOT         1                                      CGL046
     O         AND  N34 84                                                      CGL046
     O         AND  N33 82                                                      CGL046
     O*******AND      N27 20                                              CGL046            BG12511A
     O         AND  N27 KL                                                      CGL046            BG
     O                       WCMTX4              97                             CGL046
      *                                                                   CGL046
      *    END OF PAGE ONLY                                               CGL046
      *                                                                   CGL046
     O          E       41 45ENDPG       1  1                                   CGL046
     O         AND  N34 84                                                      CGL046
     O*******AND      N27 20                                              CGL046            BG12511A
     O         AND  N27 KL                                                      CGL046            BG
     O                                          116 '- CONTD'                   CGL046
     O          E            ERPT2       1    03                                CGL046
     O         AND  N33                                                         CGL046
     O*******AND      N27 20                                                          CGL046 BG12511
     O         AND  N27 KL                                                                   BG12511
     O                                           66 '*** END OF REPORT '        CGL046
     O               58                          77 'FOR BRANCH '               CGL046
     O               58      BRCASV              80                             CGL046
     O               58                          84 ' ***'                      CGL046
     O              N58                          69 '***'                       CGL046
     O/EJECT                                                              CGL046
     O*                                                                   S01408
     O/COPY WNCPYSRC,GL0420OO13                                           S01408
     O*                                                                   S01408
1727 O*****MPRINTS2**BEGINS**H*E*R*E***                                   S01125
1727 O*    GL0420P3  BEGINS  H E R E                                      S01125
1728 O*                      -------
1729 O*PRINTS2H   03   62                                                 S01091
1729 O*PRINTS2E   03   62                                                 S01125
1624 O*L0420P3E   03   62                                                 S01146
1624 O*L0420P3E** 01   62                                          S01146 S01117
1624 OGL0420P3  E    62 84                    01                                S01117
     O                       FICHE               16                             S01146
     O********E** 03   62                                          S01146 S01117
     O          E    62 84                    03                                S01117
     O/COPY WNCPYSRC,GL0420O003
1730 O***********         36   CNA1      35                               S01194
     O/COPY WNCPYSRC,GL0420O004
1730 O***********         36   BCCNA1    35                         S01194BHF093
1730 O                  36   @WCNA1              35                             BHF093
1731 O                  35                       71 'DEMAND STATEMENT'
1732 O*       H   04   63                                                 S01091
1732 O********E** 04   63                                       S01091    S01117
1732 O          E    63 84                    04                                S01117
     O/COPY WNCPYSRC,GL0420O005
1733 O***********            36CNA2      35                               S01194
     O/COPY WNCPYSRC,GL0420O006
1733 O***********            36BCCNA2    35                         S01194BHF093
1733 O                     36@WCNA2              35                             BHF093
     O/COPY WNCPYSRC,GL0420O097
1734 O*       H   05   63                                                 S01091
1734 O********E** 05   63                                       S01091    S01117
1734 O          E    63 84                    05                                S01117
     O/COPY WNCPYSRC,GL0420O007
1735 O***********            36CNA3      35                               S01194
     O/COPY WNCPYSRC,GL0420O008
1735 O***********            36BCCNA3    35                         S01194BHF093
1735 O                     36@WCNA3              35                             BHF093
1736 O*       H   06   63                                                 S01091
1736 O********E** 06   63                                       S01091    S01117
1736 O          E    63 84                    06                                S01117
     O/COPY WNCPYSRC,GL0420O009
1737 O***********            36CNA4      35                               S01194
     O/COPY WNCPYSRC,GL0420O010
1737 O***********            36BCCNA4    35                         S01194BHF093
1737 O                     36@WCNA4              35                             BHF093
1738 O*       H   07   62                                                 S01091
1738 O********E** 07   62                                       S01091    S01117
1738 O          E    62 84                    07                                S01117
     O/COPY WNCPYSRC,GL0420O011
     O               58      BRCA                50                             S01117
     O               58                          51 '-'                         S01117
1739 O**********                         67 '-   -    -'                                      CGL029
     O**********                         73 '-   -    -'                               CGL029 245223
     O                                           58 '-'                                       245223
     O                                           62 '-'                                       245223
     O                                           73 '-'                                       245223
     O/COPY WNCPYSRC,GL0420O012                                           S01408
1740 O                       CNUM                57
1741 O                       CCY                 61
1742 O**********               ACOD      66                                                   CGL029
1743 O**********               ACSQ      69                                                   CGL029
1744 O**********      N27      ACNO      80                                                   CGL029
     O                       ACOD                72                                           CGL029
     O                       ACSQ                75                                           CGL029
     O              N27      ACNO                86                                           CGL029
     O*CO*Y*WN*PY*RC*GL0420O012                                           S01408
     O/COPY WNCPYSRC,GL0420O013                                           S01408
1745 O***********                        97 'BRANCH -'                    S01194
     O/COPY WNCPYSRC,GL0420O014
1745 O                  58                       97 'BRANCH -'                  S01194
     **C*PY*WN*PY**C*GL0420O013                                           S01408
     O/COPY WNCPYSRC,GL0420OY13                                           S01408
1746 O***********              BRNM     128                               S01194
     O                  58   A8BRNM             128                             S01194
     O/COPY WNCPYSRC,GL0420Y054                                           S01408
1747 O*       H   08   62                                                 S01091
1747 O********E** 08   62                                       S01091    S01117
1747 O          E    62 84                    08                                S01117
     O*CO*Y*WN*PY*RC*GL0420O014                                           S01408
     O/COPY WNCPYSRC,GL0420O015                                           S01408
1748 O***********              PAGE  3  128                               S01117
     **C*PY*WN*PY*RC*GL0420O015                                           S01408
     O/COPY WNCPYSRC,GL0420O016                                           S01408
1748 O                       PAGE3         3    128                             S01117
     O/COPY WNCPYSRC,GL0420O054
1749 O*       H   10   62                                                 S01091
1749 O********E** 10   62                                       S01091    S01117
     **C*PY*WN*PY*RC*GL0420O016                                           S01408
1749 O          E    62 84                    10                                S01117
     O/COPY WNCPYSRC,GL0420O017
1750 O                       ANAM                33
     O/COPY WNCPYSRC,GLH00370
1751 O                       CCNM                65
     O/COPY WNCPYSRC,GL0420O131
1752 O                       RUNA                87
     O/COPY WNCPYSRC,GL0420O055
1753 O                       STPA          3    108
     O          E    62 84 05                 11                                              220877
     O                       RIBAN               60                                           220877
     O*                                                                   S01408
     O** Core hook for externalisation.                                   S01408
     O/COPY WNCPYSRC,GL0420OOP7                                           S01408
     O*                                                                   S01408
1754 O*       H   16   62                                                 S01091
1754 O********E** 16   62                                       S01091    S01117
1754 O          E    62 84                    16                                S01117
     O/COPY WNCPYSRC,GL0420O018
1755 O                                           60 'B/F'
     O/COPY WNCPYSRC,GL0420O019
1756 O                       LSTDA                8
     O/COPY WNCPYSRC,GL0420O056
1757 O                     70PSTBF              127 '   ,   ,   ,   , 0 CR'
     **C*PY*WN*PY*RC*GL0420O057                                           S01408
     O/COPY WNCPYSRC,GL0420OY57                                           S01408
1758 O                     71PSTBF              127 '  ,   ,   ,   , 0 . CR'
1759 O                     72PSTBF              127 ' ,   ,   ,   , 0 .  CR'
1760 O                     73PSTBF              127 '   ,   ,   , 0 .   CR'
1761 O               83                         127 'DR'
     O/COPY WNCPYSRC,GL0420O080
     O**                                                                  CEU013
     O          E    62 84 10                 17                                CEU013
     O                       BKEURO              65                             156327
     O                                          105 '('                         CEU013
     O                     KAEUPBF              128 '   ,   ,   ,   , 0 CR)'    CEU013
     O                     KBEUPBF              128 '  ,   ,   ,   , 0 . CR)'   CEU013
     O                     KCEUPBF              128 ' ,   ,   ,   , 0 .  CR)'   CEU013
     O                     KDEUPBF              128 '   ,   ,   , 0 .   CR)'    CEU013
     O               83                         128 'DR)'                       CEU013
     O**                                                                  CEU013
     **C*PY*WN*PY*RC*GL0420O019                                           S01408
     O/COPY WNCPYSRC,GL0420O020                                           S01408
1762 O***     D 1      51 42 04                                           S01091
     **C*PY*WN*PY*RC*GL0420O020                                           S01408
1762 O          E    51 42 04DET         1                                      S01091
     O/COPY WNCPYSRC,GL0420O021
     O*******AND*     N12                                       S01110    S01117
     O/COPY WNCPYSRC,GL0420O022
     O         AND  N12 84                                                      S01117
     O/COPY WNCPYSRC,GL0420O023
1763 O                       PSTDA                8
     O/COPY WNCPYSRC,GL0420O024
1764 O                     69VALDA               18
1765 O                                           32 'DR'
1766 O                     22                    32 'CR'
1767 O                                           47 'RATE CHANGE TO'
1768 O                       INTR                61 '  0 .       -'
1769 O                                           62 '%'
     O/COPY WNCPYSRC,GL0420O081
     O*C*PY*WN*PY*RC*GL0420O023                                           S01408
1770 O***     D 1      51 42N04                                           S01091
     O*C*PY*WN*PY*RC*GL0420O024                                           S01408
1770 O          E    51 42N04DET         1                                      S01091
     O/COPY WNCPYSRC,GL0420O025
     O         AND   84                                                         S01117
     O/COPY WNCPYSRC,GL0420O118
1771 O                       PSTDA                8
     O/COPY WNCPYSRC,GL0420O026
1772 O                     69VALDA               18
     O*                                                                   S01408
     O** Core hook for externalisation.                                   S01408
     O/COPY WNCPYSRC,GL0420OOP3                                           S01408
     O*                                                                   S01408
1773 O              N25      CHQN                28
     **C*PY*WN*PY*RC*GL0420O058                                           S01408
     O/COPY WNCPYSRC,GL0420O057
1774 O                       PNAR                60
     **C*PY*WN*PY*RC*GL0420O059                                           S01408
     O/COPY WNCPYSRC,GL0420O058
1775 O                  23 70PSTA                81 ' ,   ,   ,   , 0 '
1776 O                  23 71PSTA                81 '   ,   ,   , 0 . '
1777 O                  23 72PSTA                81 '  ,   ,   , 0 .  '
1778 O                  23 73PSTA                81 ' ,   ,   , 0 .   '
     **C*PY*WN*PY*RC*GL0420O060                                           S01408
     O/COPY WNCPYSRC,GL0420O059                                           S01408
1779 O                  22 70PSTA               103 ' ,   ,   ,   , 0 '
1780 O                  22 71PSTA               103 '   ,   ,   , 0 . '
1781 O                  22 72PSTA               103 '  ,   ,   , 0 .  '
1782 O                  22 73PSTA               103 ' ,   ,   , 0 .   '
     O/COPY WNCPYSRC,GL0420O082
     O*                                                                   CEU013
     O          E    51 42N04DET         1                                      CEU013
     O         AND   84 78                                                      CEU013
     O                       ROCCY               33                             CEU013
     O                     KEROAMT               54 '   ,   ,   ,   , 0 '       CEU013
     O                     KFROAMT               54 '  ,   ,   ,   , 0 . '      CEU013
     O                     KGROAMT               54 ' ,   ,   ,   , 0 .  '      CEU013
     O                     KHROAMT               54 '   ,   ,   , 0 .   '       CEU013
     O*                                                                   216937
     O          E    51 42N04DET         1                                      216937
     O         AND   84 53                                                      216937
     O                       W#ORIG              70                             216937
     O*                                                                   216937
     O** Core hook for externalisation.                                   S01408
     O/COPY WNCPYSRC,GL0420OP14                                           S01408
     O*                                                                   S01408
1783 O**   END OF POSTING DATE ONLY
1784 O**
1785 O*       T 00     L1 42 49                                           S01091
1785 O          E    L1 42 49BAL         0  0                                   S01091
     **C*PY*WN*PY*RC*GL0420O025                                           S01408
     O/COPY WNCPYSRC,GL0420OY25                                           S01408
1786 O*******AND*     N52                                                 S01117
     **C*PY*WN*PY*RC*GL0420O026                                           S01408
     O/COPY WNCPYSRC,GL0420OY26                                           S01408
1786 O         AND  N52 84                                                      S01117
     **C*PY*WN*PY*RC*GL0420O027                                           S01408
     O/COPY WNCPYSRC,GL0420O060                                           S01408
1787 O                     70PSTBAL             127 '   ,   ,   ,   , 0 CR'
1788 O                     71PSTBAL             127 '  ,   ,   ,   , 0 . CR'
1789 O                     72PSTBAL             127 ' ,   ,   ,   , 0 .  CR'
1790 O                     73PSTBAL             127 '   ,   ,   , 0 .   CR'
1791 O                     47                   127 'DR'
     **C*PY*WN*PY*RC*GL0420O028                                           S01408
     O/COPY WNCPYSRC,GL0420O027                                           S01408
1792 O**   END OF PAGE IND 45
1793 O**
1794 O********E*1         42 45ENDPG                            S01091    S01117
     **C*PY*WN*PY*RC*GL0420O029                                           S01408
1794 O          E    84 42 45ENDPG       1                                      S01117
     **C*PY*WN*PY*RC*GL0420O030                                           S01408
     O/COPY WNCPYSRC,GL0420O028                                           S01408
     O         AND  N33                                                         S01377
1794 O*       T 1         42 45                                           S01091
1795 O*      OR           42 52                                           S01091
     O/COPY WNCPYSRC,GL0420OX61                                           S01408
1796 O                                           60 'C/F'
     O/COPY WNCPYSRC,GL0420O061
1797 O                     70PSTBAL             127 '   ,   ,   ,   , 0 CR'
1798 O                     71PSTBAL             127 '  ,   ,   ,   , 0 . CR'
1799 O                     72PSTBAL             127 ' ,   ,   ,   , 0 .  CR'
1800 O                     73PSTBAL             127 '   ,   ,   , 0 .   CR'
1801 O                     47                   127 'DR'
     O/COPY WNCPYSRC,GL0420O119
     O**                                                                  CEU013
     O          E    84 42 45ENDPG       1                                      CEU013
     O         AND  N33 10                                                      CEU013
     O                       BKEURO              65                             156327
     O                                          105 '('                         CEU013
     O                     KAEUPBAL             128 '   ,   ,   ,   , 0 CR)'    CEU013
     O                     KBEUPBAL             128 '  ,   ,   ,   , 0 . CR)'   CEU013
     O                     KCEUPBAL             128 ' ,   ,   ,   , 0 .  CR)'   CEU013
     O                     KDEUPBAL             128 '   ,   ,   , 0 .   CR)'    CEU013
     O                     47                   128 'DR)'                       CEU013
     O**                                                                  CEU013
     **C*PY*WN*PY*RC*GL0420O031                                           S01408
     O/COPY WNCPYSRC,GL0420O029                                           S01408
1795 O*       T 1         42 52                                      S1091S01091
1795 O********E*1         42 52TOT                              S01091    S01117
1795 O          E    84 42 52TOT         1                                      S01117
     **C*PY*WN*PY*RC*GL0420O032                                           S01408
     O/COPY WNCPYSRC,GL0420O030                                           S01408
     O         AND  N33                                                         S01377
     O*C*PY*WN*PY*RC*GL0420O033                                           S01408
     O/COPY WNCPYSRC,GL0420O120
1796 O                                           60 'C/F'                       S01091
     O/COPY WNCPYSRC,GL0420O062
1797 O                     70PSTBAL             127 '   ,   ,   ,   , 0 CR'     S01091
1798 O                     71PSTBAL             127 '  ,   ,   ,   , 0 . CR'    S01091
1799 O                     72PSTBAL             127 ' ,   ,   ,   , 0 .  CR'    S01091
1800 O                     73PSTBAL             127 '   ,   ,   , 0 .   CR'     S01091
1801 O                     47                   127 'DR'                        S01091
     O/COPY WNCPYSRC,GL0420O121
     O**                                                                  CEU013
     O          E    84 42 52TOT         1                                      CEU013
     O         AND  N33 10                                                      CEU013
     O                       BKEURO              65                             156327
     O                                          105 '('                         CEU013
     O                     KAEUPBAL             128 '   ,   ,   ,   , 0 CR)'    CEU013
     O                     KBEUPBAL             128 '  ,   ,   ,   , 0 . CR)'   CEU013
     O                     KCEUPBAL             128 ' ,   ,   ,   , 0 .  CR)'   CEU013
     O                     KDEUPBAL             128 '   ,   ,   , 0 .   CR)'    CEU013
     O                     47                   128 'DR)'                       CEU013
     O*                                                                   216006
     O          E    84 42 52TOT         1                                      216006
     O         AND  N33 82                                                      216006
     O                       WCMTX1              97                             216006
     O          E    84 42 52TOT         1                                      216006
     O         AND  N33 82                                                      216006
     O                       WCMTX2              97                             216006
     O          E    84 42 52TOT         1                                      216006
     O         AND  N33 82                                                      216006
     O                       WCMTX3              97                             216006
     O          E    84 42 52TOT         1                                      216006
     O         AND  N33 82                                                      216006
     O                       WCMTX4              97                             216006
     O**                                                                  CEU013
     O*C*PY*WN*PY*RC*GL0420O034                                           S01408
     O/COPY WNCPYSRC,GL0420O031                                           S01408
1802 O**   END OF PAGE ONLY
1803 O**
1804 O*       T 1         42 45ENDPG                                      S01091
1804 O******  E 1         42 45                                    S01091 E10600
1804 O********E*1         42 45ENDPG                            E10600    S01117
1804 O          E    84 42 45ENDPG       1                                      S01117
     O/COPY WNCPYSRC,GL0420O032
1805 O                                          116 '- CONTD'
     O*                                                                   S01408
     O/COPY WNCPYSRC,GL0420OP20                                           S01408
     O*                                                                   S01408
     O********E*1 03           ERPT3                                                   S01117 239641
     O          E            ERPT3       1                                                    239641
     O         AND  N33                                                         S01377
     O                                           66 '*** END OF REPORT '        S01117
     O               58                          77 'FOR BRANCH '               S01117
     O               58      BRCASV              80                             S01117
     O               58                          84 ' ***'                      S01117
     O              N58                          69 '***'                       S01117
     O*                                                                   S01408
     O** Core hook for externalisation.                                   S01408
     O/COPY WNCPYSRC,GL0420OP3                                            S01408
     O*                                                                   S01408
1806 O/EJECT
     O/COPY WNCPYSRC,GL0420O063
1807 O*****MPRINTS3BEGINS****H*E*R*E***                                   S01125
1807 O*    GL0420P4BEGINS    H E R E                                      S01125
1808 O*                      -------
1809 O*
1810 O*PRINTS3H   02   64                                                 S01091
1810 O*PRINTS3E   02   64                                                 S01125
1624 O*L0420P4E   03   64                                                 S01146
1624 O*L0420P4E** 01   64                                          S01146 S01117
     O/COPY WNCPYSRC,GL0420O035
1810 OGL0420P4  E    64 84                    01                                S01117
     O                       FICHE               16                             S01146
     O/COPY WNCPYSRC,GL0420O076
     O********E** 03   64                                          S01146 S01117
     O          E    64 84                    03                                S01117
1811 O*****                              31 '-   -    -'                  S01117
1812 O*****                    CNUM      21                               S01117
1813 O*****                    CCY       25                               S01117
1814 O*****                    ACOD      30                               S01117
1815 O*****                    ACSQ      33                               S01117
1816 O*****           N27      ACNO      45                               S01117
     O               58      BRCA                18                             S01117
     O               58                          19 '-'                         S01117
     O**********                         35 '-   -    -'                               S01117 CGL029
     O**********                         41 '-   -    -'                               CGL029 245223
     O                                           26 '-'                                       245223
     O                                           30 '-'                                       245223
     O                                           41 '-'                                       245223
     O                       CNUM                25                             S01117
     O                       CCY                 29                             S01117
     O**********               ACOD      34                                            S01117 CGL029
     O**********               ACSQ      37                                            S01117 CGL029
     O**********      N27      ACNO      49                                            S01117 CGL029
     O                       ACOD                40                                           CGL029
     O                       ACSQ                43                                           CGL029
     O              N27      ACNO                55                                           CGL029
1817 O                  35                       74 'DEMAND STATEMENT'
1818 O*       H   04   65                                                 S01091
1818 O********E** 04   65                                       S01091    S01117
1818 O          E    65 84                    04                                S01117
1819 O***********            36CNA1      50                               S01194
1819 O***********            36BCCNA1    50                         S01194BHF093
1819 O                     36@WCNA1              50                             BHF093
1820 O*       H   05   65                                                 S01091
1820 O********E** 05   65                                       S01091    S01117
1820 O          E    65 84                    05                                S01117
1821 O***********            36CNA2      50                               S01194
1821 O***********            36BCCNA2    50                         S01194BHF093
1821 O                     36@WCNA2              50                             BHF093
     O/COPY WNCPYSRC,GL0420O098
1822 O*       H   06   65                                                 S01091
1822 O********E** 06   65                                       S01091    S01117
1822 O          E    65 84                    06                                S01117
1823 O***********            36CNA3      50                               S01194
1823 O***********            36BCCNA3    50                         S01194BHF093
1823 O                     36@WCNA3              50                             BHF093
1824 O*       H   07   65                                                 S01091
1824 O********E** 07   65                                       S01091    S01117
1824 O          E    65 84                    07                                S01117
1825 O***********            36CNA4      50                               S01194
1825 O***********            36BCCNA4    50                         S01194BHF093
1825 O                     36@WCNA4              50                             BHF093
1826 O*       H        64 36                                              S01091
1826 O*       E        64 36                                              S01091
1827 O*      OR   07   64N36                                              S01125
1826 O********E** 07   64 36                                    S01125    S01117
1827 O*******OR**      64N36                                    S01125    S01117
1826 O          E    64 36 84                 08                                S01117
1827 O         OR    64N36 84                                                   S01117
1828 O***********                        68 'BRANCH -'                    S01194
1828 O                  58                       68 'BRANCH -'                  S01194
1829 O***********              BRNM      99                               S01194
     O                  58   A8BRNM              99                             S01194
1830 O*       H   08   64                                                 S01091
1830 O********E** 08   64                                       S01091    S01117
1830 O********E***08   64 84                                    S01117    E30556
1830 O          E    64 84                    09                                E30556
1831 O***********              PAGE  3   99                               S01117
1831 O                       PAGE4         3     99                             S01117
1832 O*       H   10   64                                                 S01091
1832 O********E** 10   64                                       S01091    S01117
1832 O          E    64 84                    10                                S01117
     O/COPY WNCPYSRC,GLH00371
1833 O                                           20 'ACCOUNT'
1834 O                       ANAM                43
     O/COPY WNCPYSRC,GL0420O132
1835 O                                           52 'CCY'
1836 O                       CCNM                68
1837 O                                           75 'DATE'
1838 O                       RUNA                85
     O/COPY WNCPYSRC,GL0420O133
1839 O                                           93 'PAGE'
     O/COPY WNCPYSRC,GL0420O064
1840 O                       STPA          3     98
     O          E    64 84 05                 11                                              220877
     O                       RIBAN               70                                           220877
     O** Core hook for externalisation.                                   S01408
     O/COPY WNCPYSRC,GL0420OOP8                                           S01408
     O*                                                                   S01408
1841 O*       H   13   64                                                 S01091
1841 O********E** 13   64                                       S01091    S01117
1841 O          E    64 84                    13                                S01117
1842 O                                           21 'DATE'
1843 O                                           44 'NARRATIVE'
     O/COPY WNCPYSRC,GL0420O108
1844 O                                           71 'AMOUNT'
1845 O                                           93 'BALANCE'
     O/COPY WNCPYSRC,GL0420O123
1846 O*       H   16   64                                                 S01091
1846 O********E** 16   64                                       S01091    S01117
1846 O          E    64 84                    16                                S01117
     O/COPY WNCPYSRC,GL0420O077
1847 O                                           55 'B/F'
1848 O                       LSTDA               23
     O/COPY WNCPYSRC,GL0420O160
1849 O                     70PSTBF              100 '   ,   ,   ,   , 0 CR'
1850 O                     71PSTBF              100 '  ,   ,   ,   , 0 . CR'
1851 O                     72PSTBF              100 ' ,   ,   ,   , 0 .  CR'
1852 O                     73PSTBF              100 '   ,   ,   , 0 .   CR'
1853 O               83                         100 'DR'
     O/COPY WNCPYSRC,GL0420O083
     O*                                                                   CEU013
     O          E    64 84 10                 17                                CEU013
     O                       BKEURO              60                             156327
     O                                           77 '('                         156327
     O                     KAEUPBF              100 '   ,   ,   ,   , 0 CR)'    156327
     O                     KBEUPBF              100 '  ,   ,   ,   , 0 . CR)'   156327
     O                     KCEUPBF              100 ' ,   ,   ,   , 0 .  CR)'   156327
     O                     KDEUPBF              100 '   ,   ,   , 0 .   CR)'    156327
     O               83                         100 'DR)'                       156327
     O**********                         78 '('                    CEU013*156327
     O**********             KAEUPBF  101 '   ,   ,   ,   , 0 CR)' CEU013*156327
     O**********             KBEUPBF  101 '  ,   ,   ,   , 0 . CR)'CEU013*156327
     O**********             KCEUPBF  101 ' ,   ,   ,   , 0 .  CR)'CEU013*156327
     O**********             KDEUPBF  101 '   ,   ,   , 0 .   CR)' CEU013*156327
     O**********       83               101 'DR)'                  CEU013*156327
     O*                                                                   CEU013
1854 O*
1855 O***     D 1      43 51 04                                           S01091
     O/COPY WNCPYSRC,GL0420O134
1855 O          E    43 51 04DET         1                                      S01091
     O*******AND*     N12                                       S01110    S01117
     O         AND  N12 84                                                      S01117
1856 O                       PSTDA               23
1857 O                                           27 'DR'
1858 O                     22                    27 'CR'
1859 O                                           42 'RATE CHANGE TO'
1860 O                       INTR                56 '  0 .       -'
1861 O                                           57 '%'
     O/COPY WNCPYSRC,GL0420O084
1862 O***     D 1      43 51N04                                           S01091
1862 O          E    43 51N04DET         1                                      S01091
     O         AND   84                                                         S01117
1863 O                       PSTDA               23
1864 O                       PNAR                55
     O/COPY WNCPYSRC,GL0420O147
1865 O                     70PSTA                74 ' ,   ,   ,   , 0 '
1866 O                     71PSTA                74 '   ,   ,   , 0 . '
1867 O                     72PSTA                74 '  ,   ,   , 0 .  '
1868 O                     73PSTA                74 ' ,   ,   , 0 .   '
     O/COPY WNCPYSRC,GL0420O148
1869 O                                           76 'DR'
1870 O                     22                    76 'CR'
     O/COPY WNCPYSRC,GL0420O085
     O*                                                                   CEU013
     O          E    43 51N04DET         1                                      CEU013
     O         AND   84 78                                                      CEU013
     O                       ROCCY               28                             CEU013
     O                     KEROAMT               49 '   ,   ,   ,   , 0 '       CEU013
     O                     KFROAMT               49 '  ,   ,   ,   , 0 . '      CEU013
     O                     KGROAMT               49 ' ,   ,   ,   , 0 .  '      CEU013
     O                     KHROAMT               49 '   ,   ,   , 0 .   '       CEU013
     O*                                                                   216937
     O          E    43 51N04DET         1                                      216937
     O         AND   84 53                                                      216937
     O                       W#ORIG              65                             216937
     O*                                                                   216937
     O** Core hook for externalisation.                                   S01408
     O/COPY WNCPYSRC,GL0420OP15                                           S01408
     O*                                                                   S01408
1871 O**   END OF POSTING DATE ONLY
1872 O**
1873 O*       T 00     L1 43 49                                           S01091
1873 O          E    L1 43 49BAL         0  0                                   S01091
1874 O*******AND*     N52                                                 S01117
1874 O         AND  N52 84                                                      S01117
     O/COPY WNCPYSRC,GL0420O161
1875 O                     70PSTBAL             100 '   ,   ,   ,   , 0 CR'
1876 O                     71PSTBAL             100 '  ,   ,   ,   , 0 . CR'
1877 O                     72PSTBAL             100 ' ,   ,   ,   , 0 .  CR'
1878 O                     73PSTBAL             100 '   ,   ,   , 0 .   CR'
     O/COPY WNCPYSRC,GL0420O162
1879 O                     47                   100 'DR'
     O/COPY WNCPYSRC,GL0420O144
1880 O**   END OF PAGE IND 45
1881 O**
1882 O          E       43 45ENDPG       1                                      S01091
1874 O         AND   84                                                         S01117
     O         AND  N33                                                         S01377
1882 O*       T 1         43 45                                           S01091
1883 O*      OR           43 52
1884 O                                           55 'C/F'
     O/COPY WNCPYSRC,GL0420O163
1885 O                     70PSTBAL             100 '   ,   ,   ,   , 0 CR'
1886 O                     71PSTBAL             100 '  ,   ,   ,   , 0 . CR'
1887 O                     72PSTBAL             100 ' ,   ,   ,   , 0 .  CR'
1888 O                     73PSTBAL             100 '   ,   ,   , 0 .   CR'
     O/COPY WNCPYSRC,GL0420O164
1889 O                     47                   100 'DR'
     O*                                                                   CEU013
     O          E       43 45ENDPG       1                                      CEU013
     O         AND   84                                                         CEU013
     O         AND  N33 10                                                      CEU013
     O                       BKEURO              60                             156327
     O                                           77 '('                         156327
     O                     KAEUPBAL             100 '   ,   ,   ,   , 0 CR)'    156327
     O                     KBEUPBAL             100 '  ,   ,   ,   , 0 . CR)'   156327
     O                     KCEUPBAL             100 ' ,   ,   ,   , 0 .  CR)'   156327
     O                     KDEUPBAL             100 '   ,   ,   , 0 .   CR)'    156327
     O               47                         100 'DR)'                       156327
     O**********                         78 '('                    CEU013*156327
     O**********             KAEUPBAL 101 '   ,   ,   ,   , 0 CR)' CEU013*156327
     O**********             KBEUPBAL 101 '  ,   ,   ,   , 0 . CR)'CEU013*156327
     O**********             KCEUPBAL 101 ' ,   ,   ,   , 0 .  CR)'CEU013*156327
     O**********             KDEUPBAL 101 '   ,   ,   , 0 .   CR)' CEU013*156327
     O**********       47               101 'DR)'                  CEU013*156327
     O*                                                                   CEU013
1883 O*       T 1         43 52                                      S1091S01091
1883 O********E*1         43 52TOT                              S01091    S01117
1883 O          E    84 43 52TOT         1                                      S01117
     O         AND  N33                                                         S01377
1884 O                                           55 'C/F'                       S01091
     O/COPY WNCPYSRC,GL0420O165
1885 O                     70PSTBAL             100 '   ,   ,   ,   , 0 CR'     S01091
1886 O                     71PSTBAL             100 '  ,   ,   ,   , 0 . CR'    S01091
1887 O                     72PSTBAL             100 ' ,   ,   ,   , 0 .  CR'    S01091
1888 O                     73PSTBAL             100 '   ,   ,   , 0 .   CR'     S01091
     O/COPY WNCPYSRC,GL0420O166
1889 O                     47                   100 'DR'                        S01091
     O*                                                                   CEU013
     O          E    84 43 52TOT         1                                      CEU013
     O         AND  N33 10                                                      CEU013
     O                       BKEURO              60                             156327
     O                                           77 '('                         156327
     O                     KAEUPBAL             100 '   ,   ,   ,   , 0 CR)'    156327
     O                     KBEUPBAL             100 '  ,   ,   ,   , 0 . CR)'   156327
     O                     KCEUPBAL             100 ' ,   ,   ,   , 0 .  CR)'   156327
     O                     KDEUPBAL             100 '   ,   ,   , 0 .   CR)'    156327
     O               47                         100 'DR)'                       156327
     O*                                                                   216006
     O          E    84 43 52TOT         1                                      216006
     O         AND  N33 82                                                      216006
     O                       WCMTX1              97                             216006
     O          E    84 43 52TOT         1                                      216006
     O         AND  N33 82                                                      216006
     O                       WCMTX2              97                             216006
     O          E    84 43 52TOT         1                                      216006
     O         AND  N33 82                                                      216006
     O                       WCMTX3              97                             216006
     O          E    84 43 52TOT         1                                      216006
     O         AND  N33 82                                                      216006
     O                       WCMTX4              97                             216006
     O/COPY WNCPYSRC,GL0420O103
     O**********                         78 '('                    CEU013*156327
     O**********             KAEUPBAL 101 '   ,   ,   ,   , 0 CR)' CEU013*156327
     O**********             KBEUPBAL 101 '  ,   ,   ,   , 0 . CR)'CEU013*156327
     O**********             KCEUPBAL 101 ' ,   ,   ,   , 0 .  CR)'CEU013*156327
     O**********             KDEUPBAL 101 '   ,   ,   , 0 .   CR)' CEU013*156327
     O**********       47               101 'DR)'                  CEU013*156327
     O*                                                                   CEU013
1897 O**   END OF PAGE ONLY
1898 O**
1899 O*       T 1         43 45                                           S01091
1899 O********E*1         43 45ENDPG                            S01091    S01117
1899 O          E    84 43 45ENDPG       1                                      S01117
1900 O                                           85 '- CONTD'
     O*                                                                   S01408
     O/COPY WNCPYSRC,GL0420OP21                                           S01408
     O*                                                                   S01408
     O********E*1 03           ERPT4                                                   S01117 239641
     O          E            ERPT4       1                                                    239641
     O         AND  N33                                                         S01377
     O                                           66 '*** END OF REPORT '        S01117
     O               58                          77 'FOR BRANCH '               S01117
     O               58      BRCASV              80                             S01117
     O               58                          84 ' ***'                      S01117
     O              N58                          69 '***'                       S01117
     O/COPY WNCPYSRC,GL0420O002
1901 O/EJECT
1902 O*****MPRINTS4BEGINS****H*E*R*E****                                  S01125
1902 O*    GL0420P5BEGINS    H E R E                                      S01125
1903 O*                      -------
1904 O*
1905 O*PRINTS4H   02   66                                                 S01091
1905 O*PRINTS4E   02   66                                                 S01125
1624 O*L0420P5E   02   66                                                 S01146
1624 O*L0420P5E** 01   66                                          S01146 S01117
     O/COPY WNCPYSRC,GL0420O145
1905 OGL0420P5  E    66 84                    01                                S01117
     O                       FICHE               16                             S01146
     O********E** 02   66                                          S01146 S01117
     O          E    66 84                    02                                S01117
1906 O*****                              31 '-   -    -'                  S01117
1907 O*****                    CNUM      21                               S01117
1908 O*****                    CCY       25                               S01117
1909 O*****                    ACOD      30                               S01117
1910 O*****                    ACSQ      33                               S01117
1911 O*****           N27      ACNO      45                               S01117
     O               58      BRCA                18                             S01117
     O               58                          19 '-'                         S01117
     O**********                         35 '-   -    -'                               S01117 CGL029
     O**********                         41 '-   -    -'                               CGL029 245223
     O                                           26 '-'                                       245223
     O                                           30 '-'                                       245223
     O                                           41 '-'                                       245223
     O                       CNUM                25                             S01117
     O                       CCY                 29                             S01117
     O**********               ACOD      34                                            S01117 CGL029
     O**********               ACSQ      37                                            S01117 CGL029
     O**********      N27      ACNO      49                                            S01117 CGL029
     O                       ACOD                40                                           CGL029
     O                       ACSQ                43                                           CGL029
     O              N27      ACNO                55                                           CGL029
1912 O                  35                       74 'DEMAND STATEMENT'
1913 O*       H   04   67                                                 S01091
1913 O********E** 04   67                                       S01091    S01117
1913 O          E    67 84                    04                                S01117
1914 O***********            36CNA1      50                               S01194
1914 O***********            36BCCNA1    50                         S01194BHF093
1914 O                     36@WCNA1              50                             BHF093
1915 O*       H   05   67                                                 S01091
1915 O********E** 05   67                                       S01091    S01117
1915 O          E    67 84                    05                                S01117
1916 O***********            36CNA2      50                               S01194
1916 O***********            36BCCNA2    50                         S01194BHF093
1916 O                     36@WCNA2              50                             BHF093
     O/COPY WNCPYSRC,GL0420O099
1917 O*       H   06   67                                                 S01091
1917 O********E** 06   67                                       S01091    S01117
1917 O          E    67 84                    06                                S01117
1918 O***********            36CNA3      50                               S01194
1918 O***********            36BCCNA3    50                         S01194BHF093
1918 O                     36@WCNA3              50                             BHF093
1919 O*       H   07   67                                                 S01091
1919 O********E** 07   67                                       S01091    S01117
1919 O          E    67 84                    07                                S01117
1920 O***********            36CNA4      50                               S01194
1920 O***********            36BCCNA4    50                         S01194BHF093
1920 O                     36@WCNA4              50                             BHF093
1921 O*       H        66 36                                              S01091
1921 O*       E        66 36                                              S01091
1922 O*      OR   07   66N36                                              S01125
1921 O********E** 07   66 36                                    S01125    S01117
1922 O*******OR**      66N36                                    S01125    S01117
1921 O          E    66 36 84                 07                                S01117
1922 O         OR    66N36 84                                                   S01117
1923 O***********                        68 'BRANCH -'                    S01194
1923 O                  58                       68 'BRANCH -'                  S01194
1924 O***********              BRNM      99                               S01194
     O                  58   A8BRNM              99                             S01194
1925 O*       H   08   66                                                 S01091
1925 O********E** 08   66                                       S01091    S01117
1925 O          E    66 84                    08                                S01117
1926 O***********              PAGE  3   99                               S01117
1926 O                       PAGE5         3     99                             S01117
1927 O*       H   10   66                                                 S01091
1927 O********E** 10   66                                       S01091    S01117
1927 O          E    66 84                    10                                S01117
     O/COPY WNCPYSRC,GLH00372
1928 O                       ANAM                43
     O/COPY WNCPYSRC,GL0420O135
1929 O                       CCNM                68
1930 O                       RUNA                85
     O/COPY WNCPYSRC,GL0420O065
1931 O                       STPA          3     98
     O          E    66 84 05                 11                                              220877
     O                       RIBAN               70                                           220877
     O** Core hook for externalisation.                                   S01408
     O/COPY WNCPYSRC,GL0420OOP9                                           S01408
     O*                                                                   S01408
1932 O*       H   16   66                                                 S01091
1932 O********E** 16   66                                       S01091    S01117
1932 O          E    66 84                    16                                S01117
     O/COPY WNCPYSRC,GL0420O124
1933 O                                           55 'B/F'
1934 O                       LSTDA               23
     O/COPY WNCPYSRC,GL0420O167
1935 O                     70PSTBF              100 '   ,   ,   ,   , 0 CR'
1936 O                     71PSTBF              100 '  ,   ,   ,   , 0 . CR'
1937 O                     72PSTBF              100 ' ,   ,   ,   , 0 .  CR'
1938 O                     73PSTBF              100 '   ,   ,   , 0 .   CR'
1939 O               83                         100 'DR'
     O/COPY WNCPYSRC,GL0420O086
     O*                                                                   CEU013
     O          E    66 84 10                 17                                CEU013
     O                       BKEURO              60                             156327
     O                                           78 '('                         CEU013
     O                     KAEUPBF              101 '   ,   ,   ,   , 0 CR)'    CEU013
     O                     KBEUPBF              101 '  ,   ,   ,   , 0 . CR)'   CEU013
     O                     KCEUPBF              101 ' ,   ,   ,   , 0 .  CR)'   CEU013
     O                     KDEUPBF              101 '   ,   ,   , 0 .   CR)'    CEU013
     O               83                         101 'DR)'                       CEU013
     O*                                                                   CEU013
1940 O*
1941 O***     D 1      44 51 04                                           S01091
     O/COPY WNCPYSRC,GL0420O136
1941 O          E    44 51 04DET         1                                      S01091
     O*******AND*     N12                                       S01110    S01117
     O         AND  N12 84                                                      S01117
1942 O                       PSTDA               23
1943 O                                           27 'DR'
1944 O                     22                    27 'CR'
1945 O                                           42 'RATE CHANGE TO'
1946 O                       INTR                56 '  0 .       -'
1947 O                                           57 '%'
     O/COPY WNCPYSRC,GL0420O087
1948 O***     D 1      44 51N04                                           S01091
1948 O          E    44 51N04DET         1                                      S01091
1960 O         AND   84                                                         S01117
1949 O                       PSTDA               23
1950 O                       PNAR                55
     O/COPY WNCPYSRC,GL0420O149
1951 O                     70PSTA                74 ' ,   ,   ,   , 0 '
1952 O                     71PSTA                74 '   ,   ,   , 0 . '
1953 O                     72PSTA                74 '  ,   ,   , 0 .  '
1954 O                     73PSTA                74 ' ,   ,   , 0 .   '
     O/COPY WNCPYSRC,GL0420O150
1955 O                                           76 'DR'
1956 O                     22                    76 'CR'
     O/COPY WNCPYSRC,GL0420O088
     O*                                                                   CEU013
     O          E    44 51N04DET         1                                      CEU013
     O         AND   84 78                                                      CEU013
     O                       ROCCY               28                             CEU013
     O                     KEROAMT               49 '   ,   ,   ,   , 0 '       CEU013
     O                     KFROAMT               49 '  ,   ,   ,   , 0 . '      CEU013
     O                     KGROAMT               49 ' ,   ,   ,   , 0 .  '      CEU013
     O                     KHROAMT               49 '   ,   ,   , 0 .   '       CEU013
     O*                                                                   216937
     O          E    44 51N04DET         1                                      216937
     O         AND   84 53                                                      216937
     O                       W#ORIG              65                             216937
     O*                                                                   216937
     O** Core hook for externalisation.                                   S01408
     O/COPY WNCPYSRC,GL0420OP16                                           S01408
     O*                                                                   S01408
1957 O**   END OF POSTING DATE ONLY
1958 O**
1959 O*       T 00     L1 44 49                                           S01091
1959 O          E    L1 44 49BAL         0  0                                   S01091
1960 O*******AND*     N52                                                 S01117
1960 O         AND  N52 84                                                      S01117
     O/COPY WNCPYSRC,GL0420O168
1961 O                     70PSTBAL             100 '   ,   ,   ,   , 0 CR'
1962 O                     71PSTBAL             100 '  ,   ,   ,   , 0 . CR'
1963 O                     72PSTBAL             100 ' ,   ,   ,   , 0 .  CR'
1964 O                     73PSTBAL             100 '   ,   ,   , 0 .   CR'
     O/COPY WNCPYSRC,GL0420O169
1965 O                     47                   100 'DR'
1966 O**   END OF PAGE IND 45
1967 O**
1968 O********E*1         44 45ENDPG                            S01091    S01117
1968 O          E    84 44 45ENDPG       1                                      S01117
     O         AND  N33                                                         S01377
1968 O*       T 1         44 45                                           S01091
1969 O*      OR           44 52
1970 O                                           55 'C/F'
     O/COPY WNCPYSRC,GL0420O170
1971 O                     70PSTBAL             100 '   ,   ,   ,   , 0 CR'
1972 O                     71PSTBAL             100 '  ,   ,   ,   , 0 . CR'
1973 O                     72PSTBAL             100 ' ,   ,   ,   , 0 .  CR'
1974 O                     73PSTBAL             100 '   ,   ,   , 0 .   CR'
     O/COPY WNCPYSRC,GL0420O171
1975 O                     47                   100 'DR'
     O*                                                                   CEU013
     O          E    84 44 45ENDPG       1                                      CEU013
     O         AND  N33 10                                                      CEU013
     O                       BKEURO              60                             156327
     O                                           78 '('                         CEU013
     O                     KAEUPBAL             101 '   ,   ,   ,   , 0 CR)'    CEU013
     O                     KBEUPBAL             101 '  ,   ,   ,   , 0 . CR)'   CEU013
     O                     KCEUPBAL             101 ' ,   ,   ,   , 0 .  CR)'   CEU013
     O                     KDEUPBAL             101 '   ,   ,   , 0 .   CR)'    CEU013
     O                     47                   101 'DR)'                       CEU013
     O*                                                                   CEU013
1969 O*       T 1         44 52                                      S1091S01091
1969 O********E*1         44 52TOT                              S01091    S01117
1969 O          E    84 44 52TOT         1                                      S01117
     O         AND  N33                                                         S01377
1970 O                                           55 'C/F'                       S01091
     O/COPY WNCPYSRC,GL0420O172
1971 O                     70PSTBAL             100 '   ,   ,   ,   , 0 CR'     S01091
1972 O                     71PSTBAL             100 '  ,   ,   ,   , 0 . CR'    S01091
1973 O                     72PSTBAL             100 ' ,   ,   ,   , 0 .  CR'    S01091
1974 O                     73PSTBAL             100 '   ,   ,   , 0 .   CR'     S01091
     O/COPY WNCPYSRC,GL0420O173
1975 O                     47                   100 'DR'                        S01091
     O*                                                                   CEU013
     O          E    84 44 52TOT         1                                      CEU013
     O         AND  N33 10                                                      CEU013
     O                       BKEURO              60                             156327
     O                                           78 '('                         CEU013
     O                     KAEUPBAL             101 '   ,   ,   ,   , 0 CR)'    CEU013
     O                     KBEUPBAL             101 '  ,   ,   ,   , 0 . CR)'   CEU013
     O                     KCEUPBAL             101 ' ,   ,   ,   , 0 .  CR)'   CEU013
     O                     KDEUPBAL             101 '   ,   ,   , 0 .   CR)'    CEU013
     O                     47                   101 'DR)'                       CEU013
     O*                                                                   216006
     O          E    84 44 52TOT         1                                      216006
     O         AND  N33 82                                                      216006
     O                       WCMTX1              97                             216006
     O          E    84 44 52TOT         1                                      216006
     O         AND  N33 82                                                      216006
     O                       WCMTX2              97                             216006
     O          E    84 44 52TOT         1                                      216006
     O         AND  N33 82                                                      216006
     O                       WCMTX3              97                             216006
     O          E    84 44 52TOT         1                                      216006
     O         AND  N33 82                                                      216006
     O                       WCMTX4              97                             216006
     O/COPY WNCPYSRC,GL0420O104
     O*                                                                   CEU013
1976 O**   END OF PAGE ONLY
1977 O**
1978 O*       T 1         44 45                                           S01091
1978 O********E*1         44 45ENDPG                            S01091    S01117
1978 O          E    84 44 45ENDPG       1                                      S01117
1979 O                                           85 '- CONTD'
     O*                                                                   S01408
     O/COPY WNCPYSRC,GL0420OP22                                           S01408
     O*                                                                   S01408
     O********E*2 03           ERPT5                                                   S01117 239641
     O          E            ERPT5       2                                                    239641
     O         AND  N33                                                         S01377
     O                                           66 '*** END OF REPORT '        S01117
     O               58                          77 'FOR BRANCH '               S01117
     O               58      BRCASV              80                             S01117
     O               58                          84 ' ***'                      S01117
     O              N58                          69 '***'                       S01117
1980 O/EJECT
1981 O*****MPRINTS5BEGINS****H*E*R*E***                                   S01125
      *                                                                   S01408
     O/COPY WNCPYSRC,GL0420OP25                                           S01408
      *                                                                   S01408
1981 O*    GL0420P6BEGINS    H E R E                                      S01125
1982 O*                      -------
1983 O*
1984 O*PRINTS5H   03   80                                                 S01091
1984 O*PRINTS5E   03   80                                                 S01125
1624 O*L0420P6E   03   80                                                 S01146
1624 O*L0420P6E** 01   80                                          S01146 S01117
1984 OGL0420P6  E    80 84                    01                                S01117
     O                       FICHE               16                             S01146
     O********E** 03   80                                          S01146 S01117
     O          E    80 84                    03                                S01117
1985 O*               N14      CNA1      35
1985 O***********              CNA1      35                               S01194
1985 O***********              BCCNA1    35                         S01194BHF093
1985 O                       @WCNA1              35                             BHF093
1986 O                                           76 '*MANAGEMENT STATEMENT*'
1987 O*       H   04   81                                                 S01091
1987 O********E** 04   81                                       S01091    S01117
1987 O          E    81 84                    04                                S01117
1988 O*               N14      CNA2      35
1988 O***********              CNA2      35                               S01194
1988 O***********              BCCNA2    35                         S01194BHF093
1988 O                       @WCNA2              35                             BHF093
     O/COPY WNCPYSRC,GL0420O100
1989 O*       H   05   81                                                 S01091
1989 O********E** 05   81                                       S01091    S01117
1989 O          E    81 84                    05                                S01117
1990 O*               N14      CNA3      35
1990 O***********              CNA3      35                               S01194
1990 O***********              BCCNA3    35                         S01194BHF093
1990 O                       @WCNA3              35                             BHF093
1991 O*       H   06   81                                                 S01091
1991 O********E** 06   81                                       S01091    S01117
1991 O          E    81 84                    06                                S01117
1992 O*               N14      CNA4      35
1992 O***********              CNA4      35                               S01194
1992 O***********              BCCNA4    35                         S01194BHF093
1992 O                       @WCNA4              35                             BHF093
     O/COPY WNCPYSRC,GL0420O072
1993 O*
1994 O*
1995 O*       H   07   80N14                                              S01091
1995 O********E** 07   80                                       S01091    S01117
1995 O          E    80 84                    07                                S01117
1996 O* ETC.
1997 O*****                              49 'OUR REF'                     S01117
     O                                           45 'OUR REF'                   S01117
     O/COPY WNCPYSRC,GL0420O073
     O               58      BRCA                50                             S01117
     O               58                          51 '-'                         S01117
1998 O**********                         67 '-   -    -'                                      CGL029
     O**********                         73 '-   -    -'                               CGL029 245223
     O                                           58 '-'                                       245223
     O                                           62 '-'                                       245223
     O                                           73 '-'                                       245223
1999 O                       CNUM                57
2000 O                       CCY                 61
     O**********               ACOD      66                                                   CGL029
     O**********               ACSQ      69                                                   CGL029
     O**********      N27      ACNO      80                                                   CGL029
     O                       ACOD                72                                           CGL029
     O                       ACSQ                75                                           CGL029
     O              N27      ACNO                86                                           CGL029
2004 O*************                      97 'BRANCH -'                    S01194
2004 O                  58                       97 'BRANCH -'                  S01194
2005 O***********              BRNM     128                               S01194
     O                  58   A8BRNM             128                             S01194
2006 O*       H   08   80N14                                              S01091
2006 O********E** 08   80                                       S01091    S01117
2006 O          E    80 84                    08                                S01117
2007 O***********              PAGE  3  128                               S01117
     O/COPY WNCPYSRC,GL0420O074
2007 O                       PAGE6         3    128                             S01117
2008 O*       H   10   80N14                                              S01091
2008 O********E** 10   80                                       S01091    S01117
2008 O          E    80 84                    10                                S01117
     O/COPY WNCPYSRC,GLH00373
2009 O                                           10 'ACCOUNT'
2010 O                       ANAM                33
     O/COPY WNCPYSRC,GLH00374
2011 O                                           48 'CURRENCY'
2012 O                       CCNM                65
     O/COPY WNCPYSRC,GL0420O137
2013 O                                           77 'DATE'
2014 O                       RUNA                87
     O/COPY WNCPYSRC,GL0420O138
2015 O                                          102 'PAGE'
     O/COPY WNCPYSRC,GL0420O066
2016 O                       STPA          3    108
     O          E    80 84 05                 11                                              220877
     O                       RIBAN               60                                           220877
     O** Core hook for externalisation.                                   S01408
     O/COPY WNCPYSRC,GL0420OO10                                           S01408
     O*                                                                   S01408
2017 O*       H   13   80N14                                              S01091
2017 O********E** 13   80                                       S01091    S01117
2017 O          E    80 84                    13                                S01117
2018 O                                            7 'POSTING'
2019 O                                           16 'VALUE'
2020 O                                           27 'CHEQUE'
2021 O                                           50 'NARRATIVE'
     O/COPY WNCPYSRC,GL0420O109
2022 O                                           76 'DEBITS'
2023 O                                           99 'CREDITS'
2024 O                                          121 'BALANCE'
2025 O*       H   14   80N14                                              S01091
2025 O********E** 14   80                                       S01091    S01117
2025 O          E    80 84                    14                                S01117
2026 O                                            6 'DATE'
2027 O                                           16 'DATE'
2028 O                                           25 'NO'
     O/COPY WNCPYSRC,GL0420O125
2029 O*       H   16   80N14                                              S01091
2029 O********E** 16   80                                       S01091    S01117
2029 O          E    80 84                    16                                S01117
     O/COPY WNCPYSRC,GL0420O126
2030 O                                           60 'B/F'
2031 O                       LSTDA                8
     O/COPY WNCPYSRC,GL0420O174
2032 O                     70PSTBF              127 '   ,   ,   ,   , 0 CR'
2033 O                     71PSTBF              127 '  ,   ,   ,   , 0 . CR'
2034 O                     72PSTBF              127 ' ,   ,   ,   , 0 .  CR'
2035 O                     73PSTBF              127 '   ,   ,   , 0 .   CR'
2036 O                  83                      127 'DR'
     O/COPY WNCPYSRC,GL0420O089
     O*                                                                   CEU013
     O          E    80 84 10                 17                                CEU013
     O                       BKEURO              65                             156327
     O                                          105 '('                         CEU013
     O                     KAEUPBF              128 '   ,   ,   ,   , 0 CR)'    CEU013
     O                     KBEUPBF              128 '  ,   ,   ,   , 0 . CR)'   CEU013
     O                     KCEUPBF              128 ' ,   ,   ,   , 0 .  CR)'   CEU013
     O                     KDEUPBF              128 '   ,   ,   , 0 .   CR)'    CEU013
     O                  83                      128 'DR)'                       CEU013
     O*                                                                   CEU013
2037 O***     D 1      41 51 34                                           S01091
     O/COPY WNCPYSRC,GL0420O139
2037 O          E    41 51 34DET         1                                      S01091
2038 O***    AND       04                                                 S01110
     O*******AND*     N12 04                                      S01110  S01117
     O         AND  N12 04 84                                                   S01117
2039 O                       PSTDA                8
2040 O                     69VALDA               18
2041 O                                           32 'DR'
2042 O                     22                    32 'CR'
2043 O                                           47 'RATE CHANGE TO'
2044 O                       INTR                61 '  0 .       -'
2045 O                                           62 '%'
     O/COPY WNCPYSRC,GL0420O090
2046 O***     D 1      41 51 34                                           S01091
2046 O          E    41 51 34DET         1                                      S01091
2047 O*******AND*     N04                                                 S01117
2047 O         AND  N04 84                                                      S01117
2048 O                       PSTDA                8
2049 O                     69VALDA               18
     O*                                                                   S01408
     O** Core hook for externalisation.                                   S01408
     O/COPY WNCPYSRC,GL0420OOP4                                           S01408
     O*                                                                   S01408
2050 O              N25      CHQN                28
2051 O                       PNAR                60
     O/COPY WNCPYSRC,GL0420O151
2052 O                  23 70PSTA                81 ' ,   ,   ,   , 0 '
2053 O                  23 71PSTA                81 '   ,   ,   , 0 . '
2054 O                  23 72PSTA                81 '  ,   ,   , 0 .  '
2055 O                  23 73PSTA                81 ' ,   ,   , 0 .   '
2056 O                  22 70PSTA               103 ' ,   ,   ,   , 0 '
2057 O                  22 71PSTA               103 '   ,   ,   , 0 . '
2058 O                  22 72PSTA               103 '  ,   ,   , 0 .  '
2059 O                  22 73PSTA               103 ' ,   ,   , 0 .   '
     O/COPY WNCPYSRC,GL0420O091
     O*                                                                   CEU013
     O          E    41 51 34DET         1                                      CEU013
     O         AND  N04 84 78                                                   CEU013
     O                       ROCCY               33                             CEU013
     O                     KEROAMT               54 '   ,   ,   ,   , 0 '       CEU013
     O                     KFROAMT               54 '  ,   ,   ,   , 0 . '      CEU013
     O                     KGROAMT               54 ' ,   ,   ,   , 0 .  '      CEU013
     O                     KHROAMT               54 '   ,   ,   , 0 .   '       CEU013
     O*                                                                   216937
     O          E    41 51 34DET         1                                      216937
     O         AND  N04 84 53                                                   216937
     O                       W#ORIG              70                             216937
     O*                                                                   216937
     O** Core hook for externalisation.                                   S01408
     O/COPY WNCPYSRC,GL0420OP17                                           S01408
     O*                                                                   S01408
2060 O**   END OF POSTING DATE ONLY
2061 O**
2062 O*       T 00     L1 41 49                                           S01091
2062 O          E    L1 41 49BAL         0  0                                   S01091
2063 O*******AND*     N52 34                                              S01117
2063 O         AND  N52 34 84                                                   S01117
     O/COPY WNCPYSRC,GL0420O175
2064 O                     70PSTBAL             127 '   ,   ,   ,   , 0 CR'
2065 O                     71PSTBAL             127 '  ,   ,   ,   , 0 . CR'
2066 O                     72PSTBAL             127 ' ,   ,   ,   , 0 .  CR'
2067 O                     73PSTBAL             127 '   ,   ,   , 0 .   CR'
     O/COPY WNCPYSRC,GL0420O176
2068 O                     47                   127 'DR'
2072 O**   END OF PAGE IND 45
2073 O**
2074 O*       T 1         41 45                                           S01091
2074 O          E       41 45ENDPG       1                                      S01091
2075 O*******AND*      34                                                 S01117
2075 O         AND   34 84                                                      S01117
     O         AND  N33                                                         S01377
2076 O*      OR           41 52
2077 O*      AND       34
2078 O                                           60 'C/F'
     O/COPY WNCPYSRC,GL0420O177
2079 O                     70PSTBAL             127 '   ,   ,   ,   , 0 CR'
2080 O                     71PSTBAL             127 '  ,   ,   ,   , 0 . CR'
2081 O                     72PSTBAL             127 ' ,   ,   ,   , 0 .  CR'
2082 O                     73PSTBAL             127 '   ,   ,   , 0 .   CR'
     O/COPY WNCPYSRC,GL0420O178
2083 O                     47                   127 'DR'
     O*                                                                   CEU013
     O          E       41 45ENDPG       1                                      CEU013
     O         AND   34 84                                                      CEU013
     O         AND  N33 10                                                      CEU013
     O                       BKEURO              65                             156327
     O                                          105 '('                         CEU013
     O                     KAEUPBAL             128 '   ,   ,   ,   , 0 CR)'    CEU013
     O                     KBEUPBAL             128 '  ,   ,   ,   , 0 . CR)'   CEU013
     O                     KCEUPBAL             128 ' ,   ,   ,   , 0 .  CR)'   CEU013
     O                     KDEUPBAL             128 '   ,   ,   , 0 .   CR)'    CEU013
     O                     47                   128 'DR)'                       CEU013
2083 O*                                                                   CEU013
2076 O*       T 1         41 52                                      S1091S01091
2076 O          E       41 52TOT         1                                      S01091
2077 O*******AND*      34                                       S01091    S01117
2077 O         AND   34 84                                                      S01117
     O         AND  N33                                                         S01377
2078 O                                           60 'C/F'                       S01091
     O/COPY WNCPYSRC,GL0420O179
2079 O                     70PSTBAL             127 '   ,   ,   ,   , 0 CR'     S01091
2080 O                     71PSTBAL             127 '  ,   ,   ,   , 0 . CR'    S01091
2081 O                     72PSTBAL             127 ' ,   ,   ,   , 0 .  CR'    S01091
2082 O                     73PSTBAL             127 '   ,   ,   , 0 .   CR'     S01091
     O/COPY WNCPYSRC,GL0420O180
2083 O                     47                   127 'DR'                        S01091
     O*                                                                   CEU013
     O          E       41 52TOT         1                                      CEU013
     O         AND   34 84                                                      CEU013
     O         AND  N33 10                                                      CEU013
     O                       BKEURO              65                             156327
     O                                          105 '('                         CEU013
     O                     KAEUPBAL             128 '   ,   ,   ,   , 0 CR)'    CEU013
     O                     KBEUPBAL             128 '  ,   ,   ,   , 0 . CR)'   CEU013
     O                     KCEUPBAL             128 ' ,   ,   ,   , 0 .  CR)'   CEU013
     O                     KDEUPBAL             128 '   ,   ,   , 0 .   CR)'    CEU013
     O                     47                   128 'DR)'                       CEU013
     O*                                                                   216006
     O          E       41 52TOT         1                                      216006
     O         AND   34 84                                                      216006
     O         AND  N33 82                                                      216006
     O                       WCMTX1              97                             216006
     O          E       41 52TOT         1                                      216006
     O         AND   34 84                                                      216006
     O         AND  N33 82                                                      216006
     O                       WCMTX2              97                             216006
     O          E       41 52TOT         1                                      216006
     O         AND   34 84                                                      216006
     O         AND  N33 82                                                      216006
     O                       WCMTX3              97                             216006
     O          E       41 52TOT         1                                      216006
     O         AND   34 84                                                      216006
     O         AND  N33 82                                                      216006
     O                       WCMTX4              97                             216006
     O/COPY WNCPYSRC,GL0420O105
     O*                                                                   CEU013
2084 O**   END OF PAGE ONLY
2085 O**
2086 O*       T 1         41 45                                           S01091
2086 O          E       41 45ENDPG       1                                      S01091
2087 O*******AND*      34                                                 S01117
2087 O         AND   34 84                                                      S01117
2088 O                                          116 '- CONTD'
     O*                                                                   S01408
     O/COPY WNCPYSRC,GL0420OP23                                           S01408
     O*                                                                   S01408
     O********E*1 03           ERPT6                                                   S01117 239641
     O          E            ERPT6       1                                                    239641
     O         AND  N33                                                         S01377
     O                                           66 '*** END OF REPORT '        S01117
     O               58                          77 'FOR BRANCH '               S01117
     O               58      BRCASV              80                             S01117
     O               58                          84 ' ***'                      S01117
     O              N58                          69 '***'                       S01117
     O/COPY WNCPYSRC,GL0420O122
2310 O********T**202   LR                                       E10433    S01117
     OGL0420AU  T    LR                     2 02                                S01117
     O***********                        22 'REFERENCE GL0420'            S01117
     O                                           24 'REFERENCE GL0420AU'        S01117
2312 O*                        TITL      92                     E10433    S01161
2312 O********                 TITL      92                     E16681    S01194
     O                       BJURPT              92                             S01194
2313 O                                          104 'DATE'                      E10433
2314 O                       RUNA               113                             E10433
0523 O                                          122 'PAGE'                      S01117
0524 O                       PAGE1              127                             S01117
     O/COPY WNCPYSRC,GL0420O092
2315 O*                                                                   E10433
2316 O          T    LR                     1                                   E10433
2317 O                                           70 'BALANCE STATEMENTS'        E10433
     O                                           85 'RUN CONTROLS'              S01117
2318 O          T    LR                     1                                   E10433
2319 O                                           70 '------------------'        E10433
2320 O          T    LR                       15                                E10433
2321 O                                           30 'FILE CONTROLS'             E10433
2322 O***********                        58 'INPUT'                                    E10433 CGL061
2323 O                                           81 'CALCULATED'                E10433
2324 O********T** 17   LR                                       E10433    S01161
2325 O***********                        29 'NO. POSTING '      E10433    S01161
     O***********                        38 'RECORDS :'         E10433    S01161
2326 O***********              POSSIZ3   58                     E10433    S01161
2327 O***********              SUM   3   84                     E10433    S01161
2328 O***********            84         111 '*** OUT OF BALANCE E10433    S01161
2324 O********T** 19   LR                                       E10433    S01161
2325 O***********                        29 'NO. POSTINGS'      E10433    S01161
     O***********                        39 'DELETED :'         E10433    S01161
2326 O***********              NODEL 3   58                     E10433    S01161
2324 O********T** 21   LRN84                                    E10433    S01161
2325 O***********                        29 'NO. POSTINGS'      E10433    S01161
     O***********                        41 'REMAINING :'       E10433    S01161
2326 O***********              POSSO 3   58                     E10433    S01161
2338 O********T** 24   LR                                       E10433    S01161
2338 O          T    LRNU7                    17                                S01161
2339 O                                           31 'NO. STATEMENTS'            E10433
     O                                           45 'RECORDS READ:'             E10433
2340 O***********              STMSIZ3   58                                            E10433 CGL061
2341 O                       TNAR          3     84                             E10433
2342 O******************  86            111 '*** OUT OF BALANCE ***'                   E10433 CGL061
     O          T    U7 U8 LR            3                                      E10433
     O                                           42 '***REFERENCE'              E10433
     O***********              DBPGM     51                     E10433    S01194
     O                       DBPGM               53                             S01194
     O                                           71 'DATABASE ERROR AT'         E10433
     O***********              DBASE     74                     E10433    S01194
     O                       DBASE               75                             S01194
     O          T    U7 U8 LR            2  2                                   E10433
     O                                           37 'FILE NAME'                 E10433
     O***********              DBFILE    43                     E10433    S01194
     O***********                        48 'KEY'               E10433    S01194
     O***********              DBKEY     78                     E10433    S01194
     O                       DBFILE              46                             S01194
     O                                           51 'KEY'                       S01194
     O                       DBKEY               81                             S01194
2343 O********T*3      LR                                       E10433    S01161
2344 O***********                        76 '*** END OF REPORT *E10433    S01161
2089 O*
2090 O**************
2091 O/EJECT
     O*                                                                   S01408
     O/COPY WNCPYSRC,GL0420OO14                                           S01408
     O*                                                                   S01408
2092 O*PRINT  H   03   87                                                 S01091
2092 O*PRINT  E   03   87                                                 S01125
1624 O*L0420P1E   03   87                                                 S01146
1624 O*L0420P1E** 01   87                                          S01146 S01117
1624 OGL0420P1  E    87 84                    01                                S01117
     O                       FICHE               16                             S01146
     O********E** 03   87                                          S01146 S01117
     O          E    87 84                    03                                S01117
2093 O***********         36   CNA1      35                               S01194
2093 O***********         36   BCCNA1    35                         S01194BHF093
2093 O                  36   @WCNA1              35                             BHF093
2094 O                  35                       71 'DEMAND STATEMENT'
2095 O*       H   04   89                                                 S01091
2095 O********E*  04   89                                       S01091    S01117
2095 O          E    89 84                    04                                S01117
2096 O***********            36CNA2      35                               S01194
2096 O***********            36BCCNA2    35                         S01194BHF093
2096 O                     36@WCNA2              35                             BHF093
     O/COPY WNCPYSRC,GL0420O101
2097 O*       H   05   89                                                 S01091
2097 O********E*  05   89                                       S01091    S01117
2097 O          E    89 84                    05                                S01117
2098 O***********            36CNA3      35                               S01194
2098 O***********            36BCCNA3    35                         S01194BHF093
2098 O                     36@WCNA3              35                             BHF093
2099 O*       H   06   89                                                 S01091
2099 O********E*  06   89                                       S01091    S01117
2099 O          E    89 84                    06                                S01117
2100 O***********            36CNA4      35                               S01194
     O***********            36BCCNA4    35                         S01194BHF093
     O                     36@WCNA4              35                             BHF093
2101 O*
2102 O*
2103 O*       H   07   87                                                 S01091
2103 O********E*  07   87                                       S01091    S01117
2103 O          E    87 84                    07                                S01117
2104 O* ETC.
2105 O*****                              49 'OUR REF'                     S01117
     O/COPY WNCPYSRC,GL0420O110
     O                                           45 'OUR REF'                   S01117
     O/COPY WNCPYSRC,GL0420O111
     O               58      BRCA                50                             S01117
     O               58                          51 '-'                         S01117
2106 O**********                         67 '-   -    -'                                      CGL029
     O**********                         73 '-   -    -'                               CGL029 245223
     O                                           58 '-'                                       245223
     O                                           62 '-'                                       245223
     O                                           73 '-'                                       245223
2107 O                       CNUM                57
2108 O                       CCY                 61
2109 O**********               ACOD      66                                                   CGL029
2110 O**********               ACSQ      69                                                   CGL029
2111 O**********      N27      ACNO      80                                                   CGL029
     O                       ACOD                72                                           CGL029
     O                       ACSQ                75                                           CGL029
     O              N27      ACNO                86                                           CGL029
2112 O*************                      97 'BRANCH -'                    S01194
     O/COPY WNCPYSRC,GL0420O112
2112 O                  58                       97 'BRANCH -'                  S01194
2113 O***********              BRNM     128                               S01194
     O                  58   A8BRNM             128                             S01194
2114 O*       H   08   87                                                 S01091
2114 O********E*  08   87                                       S01091    S01117
2114 O          E    87 84                    08                                S01117
2115 O                       PAGE          3    128
     O/COPY WNCPYSRC,GL0420O113
2116 O*       H   10   87                                                 S01091
2116 O********E** 10   87                                       S01091    S01117
2116 O          E    87 84                    10                                S01117
     O/COPY WNCPYSRC,GL0420O114
2117 O                       ANAM                33
     O/COPY WNCPYSRC,GLH00375
2118 O                       CCNM                65
     O/COPY WNCPYSRC,GL0420O140
2119 O                       RUNA                87
     O/COPY WNCPYSRC,GL0420O067
2120 O                       STPA          3    107
     O          E    87 84 05                 11                                              220877
     O                       RIBAN               60                                           220877
     O** Core hook for externalisation.                                   S01408
     O/COPY WNCPYSRC,GL0420OO11                                           S01408
     O*                                                                   S01408
2121 O*       H   16   87                                                 S01091
2121 O********E*  16   87                                       S01091    S01117
2121 O          E    87 84                    16                                S01117
     O/COPY WNCPYSRC,GL0420O127
2122 O**
2123 O**   NARRATIVES OVERLAP WITH THE DEBITS BY ONE COLUMN.
2124 O**
2125 O                       LSTDA                7
2126 O                                           55 'B/F'
     O/COPY WNCPYSRC,GL0420O181
2127 O                     70PSTBF              110 '   ,   ,   ,   , 0 CR'
2128 O                     71PSTBF              110 '  ,   ,   ,   , 0 . CR'
2129 O                     72PSTBF              110 ' ,   ,   ,   , 0 .  CR'
2130 O                     73PSTBF              110 '   ,   ,   , 0 .   CR'
2131 O                     47                   110 'DR'
     O*TO ENSURE ACCURATE CLEARED BALANCE BFWD IS SHOWN ON FIRST &
     O*  SUBSEQUENT PAGES OF STATMENTS
2132 O                     70CFBF               132 '   ,   ,   ,   , 0 CR'
2133 O                     71CFBF               132 '  ,   ,   ,   , 0 . CR'
2134 O                     72CFBF               132 ' ,   ,   ,   , 0 .  CR'
2135 O                     73CFBF               132 '   ,   ,   , 0 .   CR'
2136 O                     28                   132 'DR'
     O/COPY WNCPYSRC,GL0420O093
     O*                                                                   CEU013
     O          E    87 84 10                 17                                CEU013
     O                       BKEURO              60                             156327
     O                                           88 '('                         CEU013
     O                     KAEUPBF              111 '   ,   ,   ,   , 0 CR)'    CEU013
     O                     KBEUPBF              111 '  ,   ,   ,   , 0 . CR)'   CEU013
     O                     KCEUPBF              111 ' ,   ,   ,   , 0 .  CR)'   CEU013
     O                     KDEUPBF              111 '   ,   ,   , 0 .   CR)'    CEU013
     O                     47                   111 'DR)'                       CEU013
     O*                                                                   CEU013
2137 O***     D 1      40 75 51                                           S01091
2137 O********E*1******40*75*51**********                          S01091 059213
     O/COPY WNCPYSRC,GL0420O141
2137 O          E    40 75 51DET         1                                      059213
     O         AND   84                                                         S01117
     O/COPY WNCPYSRC,GL0420O182
2138 O                     70VDDR                71 ' ,   ,   ,   , 0 '
2139 O                     71VDDR                71 '   ,   ,   , 0 . '
2140 O                     72VDDR                71 '  ,   ,   , 0 .  '
2141 O                     73VDDR                71 ' ,   ,   , 0 .   '
2142 O                                           40 '**AMOUNT CLEARED SINCE L'
2143 O                                           55 'AST STATEMENT**'
2144 O                     70VDCR                88 ' ,   ,   ,   , 0 '
2145 O                     71VDCR                88 '   ,   ,   , 0 . '
2146 O                     72VDCR                88 '  ,   ,   , 0 .  '
2147 O                     73VDCR                88 ' ,   ,   , 0 .   '
2148 O                     70VDCBBF             132 '   ,   ,   ,   , 0 CR'
2149 O                     71VDCBBF             132 '  ,   ,   ,   , 0 . CR'
2150 O                     72VDCBBF             132 ' ,   ,   ,   , 0 .  CR'
2151 O                     73VDCBBF             132 '   ,   ,   , 0 .   CR'
     O/COPY WNCPYSRC,GL0420O183
2152 O                     32                   132 'DR'
2153 O***     D 1      40 51 04                                           S01091
2153 O          E    40 51 04DET         1                                      S01091
     O*******AND*     N12                                       S01110    S01117
     O         AND  N12 84                                                      S01117
2154 O                       PSTDA                7
2155 O                     69VALDA               15
2156 O                                           27 'DR'
2157 O                     22                    27 'CR'
2158 O                                           42 'RATE CHANGE TO'
2159 O                       INTR                56 '  0 .       -'
2160 O                                           57 '%'
     O/COPY WNCPYSRC,GL0420O094
2161 O***     D 1      40 51N04                                           S01091
2161 O          E    40 51N04DET         1                                      S01091
     O         AND   84                                                         S01117
2162 O                       PSTDA                7
2163 O                     69VALDA               15
     O*                                                                   S01408
     O** Core hook for externalisation.                                   S01408
     O/COPY WNCPYSRC,GL0420OOP5                                           S01408
     O*                                                                   S01408
2164 O              N25      CHQN                24
     O/COPY WNCPYSRC,GL0420O152
2165 O                  23 70PSTA                71 ' ,   ,   ,   , 0 '
2166 O                  23 71PSTA                71 '   ,   ,   , 0 . '
2167 O                  23 72PSTA                71 '  ,   ,   , 0 .  '
2168 O                  23 73PSTA                71 ' ,   ,   , 0 .   '
     O/COPY WNCPYSRC,GL0420O153
2169 O                       PNAR                55
     O/COPY WNCPYSRC,GL0420O154
2170 O                  22 70PSTA                88 ' ,   ,   ,   , 0 '
2171 O                  22 71PSTA                88 '   ,   ,   , 0 . '
2172 O                  22 72PSTA                88 '  ,   ,   , 0 .  '
2173 O                  22 73PSTA                88 ' ,   ,   , 0 .   '
     O/COPY WNCPYSRC,GL0420O095
     O          E    40 51N04DET         1                                      CEU013
     O         AND   84 78                                                      CEU013
     O                       ROCCY               28                             CEU013
     O                     KEROAMT               49 '   ,   ,   ,   , 0 '       CEU013
     O                     KFROAMT               49 '  ,   ,   ,   , 0 . '      CEU013
     O                     KGROAMT               49 ' ,   ,   ,   , 0 .  '      CEU013
     O                     KHROAMT               49 '   ,   ,   , 0 .   '       CEU013
     O*                                                                   216937
     O          E    40 51N04DET         1                                      216937
     O         AND   84 53                                                      216937
     O                       W#ORIG              65                             216937
     O*                                                                   216937
     O** Core hook for externalisation.                                   S01408
     O/COPY WNCPYSRC,GL0420OP18                                           S01408
     O*                                                                   S01408
2174 O**   END OF POSTING DATE ONLY
2175 O**
2176 O*       T 00     L1 40 49                                           S01091
2176 O          E    L1 40 49BAL         0  0                                   S01091
     O*******AND*     N52 51                                              S01117
     O         AND  N52 51 84                                                   S01117
2178 O*      OR           40 19                                           S01091
2179 O*      AND      N18 52                                              S01091
     O/COPY WNCPYSRC,GL0420O184
2180 O                     70PSTBAL             110 '   ,   ,   ,   , 0 CR'
2181 O                     71PSTBAL             110 '  ,   ,   ,   , 0 . CR'
2182 O                     72PSTBAL             110 ' ,   ,   ,   , 0 .  CR'
2183 O                     73PSTBAL             110 '   ,   ,   , 0 .   CR'
2184 O                     47                   110 'DR'
2185 O                     70CLBAL              132 '   ,   ,   ,   , 0 CR'
2186 O                     71CLBAL              132 '  ,   ,   ,   , 0 . CR'
2187 O                     72CLBAL              132 ' ,   ,   ,   , 0 .  CR'
2188 O                     73CLBAL              132 '   ,   ,   , 0 .   CR'
     O/COPY WNCPYSRC,GL0420O185
2189 O                     37                   132 'DR'
2178 O**      T 00        40 19                                      S1091S01091
2178 O********E*00********40*19TOT*******                          S01091 059213
2179 O*******AND*     N18 52                                    S01091    S01117
2179 O*******AND******N18*52*84**********                          S01117 059213
2180 O***********************70PSTBAL***110 '   ,   ,   ,   , 0 CR'S01091 059213
2181 O**********************71PSTBAL***110 '  ,   ,   ,   , 0 . CR'S01091 059213
2182 O**********************72PSTBAL***110 ' ,   ,   ,   , 0 .  CR'S01091 059213
2183 O***********************73PSTBAL***110 '   ,   ,   , 0 .   CR'S01091 059213
2184 O***********************47*********110 'DR'                   S01091 059213
2185 O***********************70CLBAL****132 '   ,   ,   ,   , 0 CR'S01091 059213
2186 O**********************71CLBAL****132 '  ,   ,   ,   , 0 . CR'S01091 059213
2187 O**********************72CLBAL****132 ' ,   ,   ,   , 0 .  CR'S01091 059213
2188 O***********************73CLBAL****132 '   ,   ,   , 0 .   CR'S01091 059213
2189 O***********************37*********132 'DR'                   S01091 059213
2190 O**   C/F BALANCE PRINTED WHEN ITEMS CLEARING AFTER LAST POST
2191 O**
2192 O*       T 1         40 18                                           S01091
2192 O********E*1         40 18TOT                              S01091    S01117
2192 O          E    84 40 18TOT         1                                      S01117
     O         AND  N33                                                         055721
2193 O                                           55 'C/F'                       S01091
     O/COPY WNCPYSRC,GL0420O186
2194 O                     70PSTBAL             110 '   ,   ,   ,   , 0 CR'
2195 O                     71PSTBAL             110 '  ,   ,   ,   , 0 . CR'
2196 O                     72PSTBAL             110 ' ,   ,   ,   , 0 .  CR'
2197 O                     73PSTBAL             110 '   ,   ,   , 0 .   CR'
2198 O                     47                   110 'DR'
2199 O                     70CLBAL              132 '   ,   ,   ,   , 0 CR'
2200 O                     71CLBAL              132 '  ,   ,   ,   , 0 . CR'
2201 O                     72CLBAL              132 ' ,   ,   ,   , 0 .  CR'
2202 O                     73CLBAL              132 '   ,   ,   , 0 .   CR'
     O/COPY WNCPYSRC,GL0420O187
2203 O                     28                   132 'DR'
     O*                                                                   CEU013
     O          E    84 40 18TOT         1                                      CEU013
     O         AND  N33 10                                                      CEU013
     O                       BKEURO              60                             156327
     O                                           88 '('                         CEU013
     O                     KAEUPBAL             111 '   ,   ,   ,   , 0 CR)'    CEU013
     O                     KBEUPBAL             111 '  ,   ,   ,   , 0 . CR)'   CEU013
     O                     KCEUPBAL             111 ' ,   ,   ,   , 0 .  CR)'   CEU013
     O                     KDEUPBAL             111 '   ,   ,   , 0 .   CR)'    CEU013
     O                     47                   111 'DR)'                       CEU013
     O/COPY WNCPYSRC,GL0420O106
     O*                                                                   CEU013
2204 O**   END OF PAGE WHEN ITEMS TO BE CLEARED AFTER LAST POST
2205 O**
2206 O*       T   50      40 18                                           S01091
2206 O********E*  50      40 18TOT                              S01091    S01117
2206 O          E    84 40 18TOT              50                                S01117
     O         AND  N33                                                         055721
2207 O                                          125 '- CONTD'
     O*                                                                   S01408
     O/COPY WNCPYSRC,GL0420OP24                                           S01408
     O*                                                                   S01408
2208 O**   TOTAL TIME HEADINGS OUTPUT ONLY WHEN ITEMS CLEARED AFTER
2209 O**
2210 O*       T   03      40 18                                           S01091
2210 O********E*  03      40 18TOT                              S01091    S01117
2210 O          E    84 40 18TOT              03                                S01117
     O         AND  N33                                                         055721
2211 O***********         36   CNA1      35                               S01194
2211 O***********         36   BCCNA1    35                         S01194BHF093
2211 O                  36   @WCNA1              35                             BHF093
2212 O                  35                       71 'DEMAND STATEMENT'
     O                  58                       85 'BRANCH    -'               S01117
     O                  58   BRCA                84                             S01117
     O                  58   A8BRNM             115                             S01117
2213 O*       T   04      40 18                                           S01091
2213 O********E*  04      40 18TOT                              S01091    S01117
2213 O          E    84 40 18TOT              04                                S01117
     O         AND  N33                                                         055721
2214 O***********            36CNA2      35                               S01194
2214 O***********            36BCCNA2    35                         S01194BHF093
2214 O                     36@WCNA2              35                             BHF093
     O/COPY WNCPYSRC,GL0420O102
2215 O*       T   05      40 18                                           S01091
2215 O********E*  05      40 18TOT                              S01091    S01117
2215 O          E    84 40 18TOT              05                                S01117
     O         AND  N33                                                         055721
2216 O***********            36CNA3      35                               S01194
2216 O***********            36BCCNA3    35                         S01194BHF093
2216 O                     36@WCNA3              35                             BHF093
2217 O*       T   06      40 18                                           S01091
2217 O********E** 06      40 18TOT                              S01091    S01117
2217 O          E    84 40 18TOT              06                                S01117
     O         AND  N33                                                         055721
2218 O***********            36CNA4      35                               S01194
2218 O***********            36BCCNA4    35                         S01194BHF093
2218 O                     36@WCNA4              35                             BHF093
2219 O*
2220 O*
2221 O*       T   07      40 18                                           S01091
2221 O********E** 07      40 18TOT                              S01091    S01117
2221 O          E    84 40 18TOT              07                                S01117
     O         AND  N33                                                         055721
2222 O* ETC.
2223 O                                           49 'OUR REF'
2224 O**********                         67 '-   -    -'                                      CGL029
     O**********                         73 '-   -    -'                               CGL029 245223
     O                                           58 '-'                                       245223
     O                                           62 '-'                                       245223
     O                                           73 '-'                                       245223
2225 O                       CNUM                57
2226 O                       CCY                 61
2227 O**********               ACOD      66                                                   CGL029
2228 O**********               ACSQ      69                                                   CGL029
2229 O**********      N27      ACNO      80                                                   CGL029
     O                       ACOD                72                                           CGL029
     O                       ACSQ                75                                           CGL029
     O              N27      ACNO                86                                           CGL029
2230 O***********                        97 'BRANCH -'                    S01117
2231 O***********              BRNM     128                               S01117
2221 O          E    84 40 18TOT              08                                S01117
     O         AND  N33                                                         055721
     O               58                          12 'BRANCH'                    S01117
     O               58      BRCA                16                             S01117
     O               58      A8BRNM              48                             S01194
2232 O*       T   10      40 18                                           S01091
2232 O********E** 10      40 18TOT                              S01091    S01117
2232 O          E    84 40 18TOT              10                                S01117
     O         AND  N33                                                         055721
     O/COPY WNCPYSRC,GL0420O115
2233 O                       ANAM                33
     O/COPY WNCPYSRC,GLH00376
2234 O                       CCNM                65
     O/COPY WNCPYSRC,GL0420O142
2235 O                       RUNA                87
     O/COPY WNCPYSRC,GL0420O068
2236 O                       STPFF         3    107
     O/COPY WNCPYSRC,GL0420O069
2237 O*       T   16      40 18                                           S01091
2237 O********E** 16      40 18TOT                              S01091    S01117
2237 O          E    84 40 18TOT              16                                S01117
     O         AND  N33                                                         055721
2238 O                       LSTDA                7
     O/COPY WNCPYSRC,GL0420O143
2239 O                                           55 'B/F'
     O/COPY WNCPYSRC,GL0420O188
2240 O                     70PSTBF              110 '   ,   ,   ,   , 0 CR'
2241 O                     71PSTBF              110 '  ,   ,   ,   , 0 . CR'
2242 O                     72PSTBF              110 ' ,   ,   ,   , 0 .  CR'
2243 O                     73PSTBF              110 '   ,   ,   , 0 .   CR'
2244 O                     47                   110 'DR'
2245 O                     70CLBAL              132 '   ,   ,   ,   , 0 CR'
2246 O                     71CLBAL              132 '  ,   ,   ,   , 0 . CR'
2247 O                     72CLBAL              132 ' ,   ,   ,   , 0 .  CR'
2248 O                     73CLBAL              132 '   ,   ,   , 0 .   CR'
2249 O                     37                   132 'DR'
     O/COPY WNCPYSRC,GL0420O096
     O*                                                                   CEU013
     O          E    84 40 18TOT              17                                CEU013
     O         AND  N33 10                                                      CEU013
     O                       BKEURO              60                             156327
     O                                           88 '('                         CEU013
     O                     KAEUPBF              111 '   ,   ,   ,   , 0 CR)'    CEU013
     O                     KBEUPBF              111 '  ,   ,   ,   , 0 . CR)'   CEU013
     O                     KCEUPBF              111 ' ,   ,   ,   , 0 .  CR)'   CEU013
     O                     KDEUPBF              111 '   ,   ,   , 0 .   CR)'    CEU013
     O                     47                   111 'DR)'                       CEU013
     O*                                                                   CEU013
2250 O**   ITEMS CLEARED AFTER LAST POST.
2251 O**
2252 O*       T 1         40 19                                           S01091
2252 O********E*1         40 19TOT                              S01091    S01117
2252 O          E    84 40 19TOT         1                                      S01117
     O         AND  N33                                                         055721
     O/COPY WNCPYSRC,GL0420O189
2253 O                     70VDDR                71 ' ,   ,   ,   , 0 '
2254 O                     71VDDR                71 '   ,   ,   , 0 . '
2255 O                     72VDDR                71 '  ,   ,   , 0 .  '
2256 O                     73VDDR                71 ' ,   ,   , 0 .   '
2257 O                                           40 '** AMOUNT CLEARED AFTER '
2258 O                                           55 'LAST POSTING **'
2259 O                     70VDCR                88 ' ,   ,   ,   , 0 '
2260 O                     71VDCR                88 '   ,   ,   , 0 . '
2261 O                     72VDCR                88 '  ,   ,   , 0 .  '
2262 O                     73VDCR                88 ' ,   ,   , 0 .   '
     O*TO ENSURE ACCURATE CLEARED BALANCE CFWD IS SHOWN ON FIRST &
     O* SUBSEQUENT PAGES OF STATMENTS
2263 O                  52 70CLBF               132 '   ,   ,   ,   , 0 CR'
2264 O                  52 71CLBF               132 '  ,   ,   ,   , 0 . CR'
2265 O                  52 72CLBF               132 ' ,   ,   ,   , 0 .  CR'
2266 O                  52 73CLBF               132 '   ,   ,   , 0 .   CR'
2263 O                  45 70CLBAL              132 '   ,   ,   ,   , 0 CR'
2264 O                  45 71CLBAL              132 '  ,   ,   ,   , 0 . CR'
2265 O                  45 72CLBAL              132 ' ,   ,   ,   , 0 .  CR'
2266 O                  45 73CLBAL              132 '   ,   ,   , 0 .   CR'
     O/COPY WNCPYSRC,GL0420O190
2267 O                     28                   132 'DR'
2268 O**   END OF PAGE IND 45
2269 O**
2270 O*       T 1         40 45                                           S01091
2270 O********E*1         40 45ENDPG                            S01091    S01117
2270 O          E    84 40 45ENDPG       1                                      S01117
     O         AND  N33                                                         055721
2272 O                                           55 'C/F'
     O/COPY WNCPYSRC,GL0420O191
2273 O                     70PSTBAL             110 '   ,   ,   ,   , 0 CR'
2274 O                     71PSTBAL             110 '  ,   ,   ,   , 0 . CR'
2275 O                     72PSTBAL             110 ' ,   ,   ,   , 0 .  CR'
2276 O                     73PSTBAL             110 '   ,   ,   , 0 .   CR'
2277 O                     47                   110 'DR'
2278 O***********************70CLBF*****132 '   ,   ,   ,   , 0 CR'       059213
2279 O***********************71CLBF*****132 '  ,   ,   ,   , 0 . CR'      059213
2280 O***********************72CLBF*****132 ' ,   ,   ,   , 0 .  CR'      059213
2281 O***********************73CLBF*****132 '   ,   ,   , 0 .   CR'       059213
2278 O                     70CLBAL              132 '   ,   ,   ,   , 0 CR'     059213
2279 O                     71CLBAL              132 '  ,   ,   ,   , 0 . CR'    059213
2280 O                     72CLBAL              132 ' ,   ,   ,   , 0 .  CR'    059213
2281 O                     73CLBAL              132 '   ,   ,   , 0 .   CR'     059213
     O/COPY WNCPYSRC,GL0420O192
2282 O                     28                   132 'DR'
     O**                                                                  CEU013
     O          E    84 40 45ENDPG       1                                      CEU013
     O         AND  N33 10                                                      CEU013
     O                       BKEURO              60                             156327
     O                                           88 '('                         CEU013
     O                     KAEUPBAL             111 '   ,   ,   ,   , 0 CR)'    CEU013
     O                     KBEUPBAL             111 '  ,   ,   ,   , 0 . CR)'   CEU013
     O                     KCEUPBAL             111 ' ,   ,   ,   , 0 .  CR)'   CEU013
     O                     KDEUPBAL             111 '   ,   ,   , 0 .   CR)'    CEU013
     O                     47                   111 'DR)'                       CEU013
     O**                                                                  CEU013
2271 O**      T 1         40 52                                      S1091S01091
2271 O********E*1         40 52TOT                              S01091    S01117
2271 O          E    84 40 52TOT         1                                      S01117
     O         AND  N33                                                         055721
2272 O                                           55 'C/F'                       S01091
     O/COPY WNCPYSRC,GL0420O193
2273 O                     70PSTBAL             110 '   ,   ,   ,   , 0 CR'     S01091
2274 O                     71PSTBAL             110 '  ,   ,   ,   , 0 . CR'    S01091
2275 O                     72PSTBAL             110 ' ,   ,   ,   , 0 .  CR'    S01091
2276 O                     73PSTBAL             110 '   ,   ,   , 0 .   CR'     S01091
2277 O                     47                   110 'DR'                        S01091
2278 O                     70CLBF               132 '   ,   ,   ,   , 0 CR'     S01091
2279 O                     71CLBF               132 '  ,   ,   ,   , 0 . CR'    S01091
2280 O                     72CLBF               132 ' ,   ,   ,   , 0 .  CR'    S01091
2281 O                     73CLBF               132 '   ,   ,   , 0 .   CR'     S01091
     O/COPY WNCPYSRC,GL0420O194
2282 O                     28                   132 'DR'                        S01091
     O*                                                                   CEU013
     O          E    84 40 52TOT         1                                      CEU013
     O         AND  N33 10                                                      CEU013
     O                       BKEURO              60                             156327
     O                                           88 '('                         CEU013
     O                     KAEUPBAL             111 '   ,   ,   ,   , 0 CR)'    CEU013
     O                     KBEUPBAL             111 '  ,   ,   ,   , 0 . CR)'   CEU013
     O                     KCEUPBAL             111 ' ,   ,   ,   , 0 .  CR)'   CEU013
     O                     KDEUPBAL             111 '   ,   ,   , 0 .   CR)'    CEU013
     O                     47                   111 'DR)'                       CEU013
     O*                                                                   CEU013
2283 O**   SUMMARY OF THIS STATEMENT AT BOTTOM OF LAST PAGE.
2284 O**
2285 O*       T   50      40 52                                           S01091
2285 O********E** 50      40 52TOT                              S01091    S01117
     O/COPY WNCPYSRC,GL0420O116
2285 O          E    84 40 52TOT              50                                S01117
     O         AND  N33                                                         055721
     O/COPY WNCPYSRC,GL0420O195
2286 O                     70CFSB                26 '   ,   ,   ,   , 0 CR'
2287 O                     71CFSB                26 '  ,   ,   ,   , 0 . CR'
2288 O                     72CFSB                26 ' ,   ,   ,   , 0 .  CR'
2289 O                     73CFSB                26 '   ,   ,   , 0 .   CR'
2290 O                     17                    26 'DR'
      *                                                                   S01408
     O/COPY WNCPYSRC,GL0420OP26                                           S01408
      *                                                                   S01408
2291 O                       NDR           3     33
     O/COPY WNCPYSRC,GL0420O196
2292 O                     70PSDR                51 ' ,   ,   ,   , 0 '
2293 O                     71PSDR                51 '   ,   ,   , 0 . '
2294 O                     72PSDR                51 '  ,   ,   , 0 .  '
2295 O                     73PSDR                51 ' ,   ,   , 0 .   '
2296 O                       NCR           3     59
2297 O                     70PSCR                78 ' ,   ,   ,   , 0 '
2298 O                     71PSCR                78 '   ,   ,   , 0 . '
2299 O                     72PSCR                78 '  ,   ,   , 0 .  '
2300 O                     73PSCR                78 ' ,   ,   , 0 .   '
2301 O                     70PSTBAL             109 '   ,   ,   ,   , 0 CR'
2302 O                     71PSTBAL             109 '  ,   ,   ,   , 0 . CR'
2303 O                     72PSTBAL             109 ' ,   ,   ,   , 0 .  CR'
2304 O                     73PSTBAL             109 '   ,   ,   , 0 .   CR'
     O/COPY WNCPYSRC,GL0420O197
2305 O                     47                   109 'DR'
     O*                                                                   CEU013
     O          E    84 40 52TOT         1                                      CEU013
     O         AND  N33 10                                                      CEU013
     O                       BKEURO              60                             156327
     O                                           87 '('                         CEU013
     O                     KAEUPBAL             110 '   ,   ,   ,   , 0 CR)'    CEU013
     O                     KBEUPBAL             110 '  ,   ,   ,   , 0 . CR)'   CEU013
     O                     KCEUPBAL             110 ' ,   ,   ,   , 0 .  CR)'   CEU013
     O                     KDEUPBAL             110 '   ,   ,   , 0 .   CR)'    CEU013
     O                     47                   110 'DR)'                       CEU013
     O*                                                                   216006
     O          E    84 40 52TOT         1                                      216006
     O         AND  N33 82                                                      216006
     O                       WCMTX1              97                             216006
     O          E    84 40 52TOT         1                                      216006
     O         AND  N33 82                                                      216006
     O                       WCMTX2              97                             216006
     O          E    84 40 52TOT         1                                      216006
     O         AND  N33 82                                                      216006
     O                       WCMTX3              97                             216006
     O          E    84 40 52TOT         1                                      216006
     O         AND  N33 82                                                      216006
     O                       WCMTX4              97                             216006
     O/COPY WNCPYSRC,GL0420O117
     O*                                                                   CEU013
2306 O********E** 50      40 45ENDPG                            S01091    S01117
2306 O          E    84 40 45ENDPG            50                                S01117
     O         AND  N33                                                         055721
2306 O*       T   50      40 45                                           S01091
2307 O*******AND      N52                                                 E10604
2308 O                                          125 '- CONTD'
2192 O********E*1 03           ERPT1                                                   S01117 239641
     O          E            ERPT1       1    03                                              239641
     O                                           66 '*** END OF REPORT '        S01117
     O               58                          77 'FOR BRANCH '               S01117
     O               58      BRCASV              80                             S01117
     O               58                          84 ' ***'                      S01117
     O              N58                          69 '***'                       S01117
2309 O*
2310 O********T  202   LR                                                 E10433
     O********                           22 'REFERENCE GL0420'            E10433
2312 O********                 TITL      92                               E10433
2313 O********                          104 'DATE'                        E10433
2314 O********                 RUNA     113                               E10433
2315 O********                                                            E10433
2316 O********T  1     LR                                                 E10433
2317 O********                           70 'BALANCE STATEMENTS'          E10433
2318 O********T  1     LR                                                 E10433
2319 O********                           70 '------------------'          E10433
2320 O********T   15   LR                                                 E10433
2321 O********                           30 'FILE CONTROLS'               E10433
2322 O********                           58 'INPUT'                       E10433
2323 O********                           81 'CALCULATED'                  E10433
2324 O****    T   17   LR                                                 S01091
2325 O****                               29 'NO. POSTINGS'                S01091
     O****                               43 'RECORDS READ:'               S01091
2326 O****                     POSSI 3   58                               S01091
2327 O****                     TNPR  3   84                               S01091
2328 O****                   84         111 '*** OUT OF BALANCE ***'      S01091
2324 O********T   17   LR                                           S01091E10433
2325 O********                           29 'NO. POSTING '          S01091E10433
     O********                           38 'RECORDS :'             S01091E10433
2326 O********                 POSSIZ3   58                         S01091E10433
2327 O********                 SUM   3   84                         S01091E10433
2328 O********               84         111 '*** OUT OF BALANCE ***'S01091E10433
2324 O********T   19   LR                                           S01091E10433
2325 O********                           29 'NO. POSTINGS'          S01091E10433
     O********                           39 'DELETED :'             S01091E10433
2326 O********                 NODEL 3   58                         S01091E10433
2324 O********T   21   LRN84                                        S01091E10433
2325 O********                           29 'NO. POSTINGS'          S01091E10433
     O********                           41 'REMAINING :'           S01091E10433
2326 O********                 POSSO 3   58                         S01091E10433
2329 O****    T   19   LR                                                 S01091
2330 O****                               34 'VALUE OF POSTINGS'           S01091
2331 O****                     ZZTOTIZ   55                               S01091
2332 O****                     HND4      59                               S01091
2333 O****                               59 ' '                           S01091
2334 O****                     HPTI  Z   81                               S01091
2335 O****                     HPT4      85                               S01091
2336 O****                               85 ' '                           S01091
2337 O****                              111 '*** OUT OF BALANCE ***'      S01091
2338 O****    T   20   LR                                                 S01091
2338 O********T   24   LR                                                 E10433
2339 O********                           31 'NO. STATEMENTS'              E10433
     O********                           45 'RECORDS READ:'               E10433
2340 O********                 STMSIZ3   58                               E10433
2341 O********                 TNAR  3   84                               E10433
2342 O********            86            111 '*** OUT OF BALANCE ***'      E10433
     O********T 3      U7 U8 LR                                           E10433
     O********                           42 '***REFERENCE'                E10433
     O********                 DBPGM     51                               E10433
     O********                           71 'DATABASE ERROR AT'           E10433
     O********                 DBASE     74                               E10433
     O********T 22     U7 U8 LR                                           E10433
     O********                           37 'FILE NAME'                   E10433
     O********                 DBFILE    43                               E10433
     O********                           48 'KEY'                         E10433
     O********                 DBKEY     78                               E10433
2343 O********T 3      LR                                                 E10433
2344 O********                           76 '*** END OF REPORT ***'       E10433
     O*
     O** Core hook for externalisation.                                   S01408
     O/COPY WNCPYSRC,GL0420OOP1                                           S01408
     O*
2345 O/EJECT
2346 O*
2347 O*    ACCNT FILE - EXCEPTION
2348 O*
2349 O*CCNT   E        03N54                                              S01091
2350 O*                                                                   S01091
2351 O*               - UPDATE WITH NEW DETAILS                           S01091
2352 O*                                                                   S01091
2353 O*       E        54 59                                              S01091
2354 O*                        ZMDAY     74                               E10262
2354 O*                        RUND      77P                              S01091
     O*                33      LSTD      77P                              S01091
2355 O*                     N35NSTDA     80P                              S01091
2356 O*                      52STPA      82P                              S01091
2357 O*                      52PSTBAL    90P                              S01091
2358 O*                      52CLBF     117P                              S01091
2359 O*                        GLBT     118                               S01091
2360 O*       E        54N59                                              S01091
2361 O*                        GLBT     118                               S01091
2353 OACCNT     E            ACUPD                                              S01091
2354 O***********      59      RUND      77P                       S01091 055721
     O               59N33   RUND                77P                            055721
     O***********      33 59   LSTD      77P                    S01091    S01161
     O***********      33 59   LSTD      77P                       E18546 055721
2355 O               59   N35NSTDA               80P                            S01091
2356 O***********      59    52STPA      82P                       S01091 055721
2357 O***********      59    52PSTBAL    90P                       S01091 055721
2358 O*****************59****52CLBF*****117P                       S01091 055721
     O/COPY WNCPYSRC,GL0420OY36
2356 O               59N33 52STPA                82P                            055721
     O/COPY WNCPYSRC,GL0420O033
2357 O               59N33 52PSTBAL              90P                            055721
     O/COPY WNCPYSRC,GL0420O034
2358 O*****************59N33*52CLBF*****117P                S01091 055721 056524
2358 O               59 38 52CLBF               117P                            056524
2359 O                       GLBT               118                             S01091
2362 O*                                                                   S01091
2363 O**** POSTO FILE - OUTPUT OF NON-STATEMENT POSTING.                  S01091
2364 O****                                                                S01091
2365 O*OSTOHH H        1P                                                 S01091
2366 O****                                1 'H'                           S01091
2367 O****                     ZERO5      4P                              S01091
2368 O*OSTOPD D        53 02                                              S01091
2369 O****                     LOTP     160                               S01091
2370 O****                     CUOR     128                               S01091
     O*OSTORA D        53 04                                              S01091
     O****                     LOTP     160                               S01091
     O****                     CUOR     128                               S01091
2371 O*OSTOZZ T        LR                                                 S01091
2372 O****                                1 'T'                           S01091
2373 O****                     TNPO       6                               S01091
2374 O****                     HPOI      14P                              S01091
2375 O****                     HPOD      16P                              S01091
     O*POSTZZ*E**              TRAIL                            S01091    S01161
     O***********              POSSO      6                     S01091    S01161
     O*POST***E**              UPD                              S01091    S01161
     O***********              CUOR     128                     S01091    S01161
      *                                                                   S01408
     O/COPY WNCPYSRC,GL0420OP27                                           S01408
**CTDATA CPY@
(c) Finastra International Limited 2001
**CTDATA TYPE
GRDNC
**CTDATA ZFMD
312831303130313130313031
**CTDATA ZYDY
0366073110961461
**CTDATA ZMDY
000031059090120151181212243273304334365
**CTDATA ZMNM
JANFEBMARAPRMAYJUNJULAUGSEPOCTNOVDEC
