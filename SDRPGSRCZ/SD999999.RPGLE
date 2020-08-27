000100200827      *****************************************************************
000101200827/*STD *  PGMBASE                                                      *
000102200827/*EXI *  MODULE(AS000010) ACTGRP(*CALLER)                             *                       CPK016
000103200827/*EXI *  TEXT('Midas AS Hedge DL a/c key generation program')         *
000104200827/*E*I ***MODULE(AS000010)**********************************************                       CPK016
000105200827/*E*I ***BNDSRVPGM(*NONE)*BNDDIR(MIDAS)*ACTGRP(*CALLER)****************                       CPK016
000106200827      *****************************************************************
000107200827      *                                                               *
000108200827      *  Midas  - Accounting Standards Module                         *
000109200827      *                                                               *
000110200827      *  AS000010 - Hedge DL Account Key Generation Program           *
000111200827      *                                                               *
000112200827      *  (c) Finastra International Limited 2002                      *
000113200827      *                                                               *
000114200827      *  Last Amend No. CSD103             Date 10Aug20               *
000115200827      *  Prev Amend No. MD046248           Date 27Oct17               *
000116200827      *                 CDL099             Date 06Oct17               *
000117200827      *                 CGL165             Date 17Feb15               *
000118200827      *                 CDL096             Date 22Sep14               *
000119200827      *                 CDL094             Date 11Jun14               *
000120200827      *                 CLE148             Date 23Jul12               *
000121200827      *                 CSW212             Date 03May12               *
000122200827      *                 AR821740           Date 29Aug11               *
000123200827      *                 CRE073             Date 06Dec10               *
000124200827      *                 CER059             Date 19Jul10               *
000125200827      *                 CER054             Date 07Apr09               *
000126200827      *                 CER048             Date 19May08               *
000127200827      *                 CER020             Date 19May08               *
000128200827      *                 CER043             Date 19May08               *
000129200827      * Bank Fusion Midas 1.4 Base -----------------------------------*
000130200827      * Midas Plus 1.4 Base 04 ---------------------------------------*
000131200827      * Midas Plus 1.4 Base ------------------------------------------*
000132200827      * Midas Plus 1.3 ----------- Base ------------------------------*
000133200827      *                 229304             Date 18Sep06               *
000134200827      *                 CDL049             Date 04Jul06               *
000135200827      *                 CSD031             Date 10Apr06               *
000136200827      *                 CSD027             Date 09Dec05               *
000137200827      *                 BUG9559            Date 10Dec05               *
000138200827      *                 CDL038             Date 10May05               *
000139200827      *                 CAS009             Date 16May05               *
000140200827      *                 228259             Date 07Jul04               *
000141200827      *                 225301             Date 27Feb04               *
000142200827      *                 CDL028             Date 07Feb05               *
000143200827      *                 CGL029             Date 01Sep03               *
000144200827      *                 221416             Date 17Sep03               *
000145200827      *                 CPK016             Date 29Jul03               *
000146200827      *                 CAS006             Date 21Jan03               *
000147200827      *                 CAS005             Date 16Dec02               *
000148200827      *                 CAS004  *CREATE    Date 26Jun02               *
000149200827      *                                                               *
000150200827      *---------------------------------------------------------------*
000151200827      *                                                               *
000152200827      *  CSD103 - LIBOR Deregulation - Common Layer/Standing Data     *
000153200827      *  MD046248 - Finastra Rebranding                               *
000154200827      *  CDL099 - Split Value Date (Recompile)                        *
000155200827      *  CGL165 - Dual Withholding Tax (Recompile)                    *
000156200827      *  CDL096 - Business Day Conventions on MM Deals                *
000157200827      *           (Recompile)                                         *
000158200827      *  CDL094 - Enhance Receive Settlement Instructions             *
000159200827      *           (Recompiled)                                        *
000160200827      *  CLE148 - Alpha Loan Reference (Recompile)                    *
000161200827      *  CSW212 - SWIFT 2012 Changes (Recompile)                      *
000162200827      *  AR821740 - COB - No stamp tax account keys generated         *
000163200827      *             (Recompile)                                       *
000164200827      *  CRE073 - Interest Rate Rounding (Recompile)                  *
000165200827      *  CER059 - German Feature Upgrade to Delhi                     *
000166200827      *  CER054 - German Features - Church Tax (Recompile)            *
000167200827      *  CER048 - German Features - Taxes (Recompile)                 *
000168200827      *  CER020 - Enhanced Rollover Window: Upgrade FGE089 to         *
000169200827      *           Midas Plus (Recompile)                              *
000170200827      *  CER043 - German Features LF041-00 New Fields and Defaulting  *
000171200827      *           (Recompile)                                         *
000172200827      *  229304 - Incorrect details for branch.                       *
000173200827      *  CDL049 - Addition of a Reference Rate field (recompile)      *
000174200827      *  CSD031 - Enhanced Centralised Static Data (Recompile)        *
000175200827      *  CSD027 - Conversion Of Customer Number to Alpha              *
000176200827      *  BUG9559 - Recompile over changes in module.                  *
000177200827      *  CDL038 - Extended Deal Sub Type (Recompile)                  *
000178200827      *  CAS009 - EIR/AC Accounting (Recompile)                       *
000179200827      *  228259 - DB Error due to non-existent forecast               *
000180200827      *  225301 - Wrong reversal amounts posted.                      *
000181200827      *  CDL028 - Automatic Rate Interpolations (Recompile)           *
000182200827      *  CGL029 - Increase Account Code to 10 digits                  *
000183200827      *  221416 - Extra reversals posted due to ineffective hedge     *
000184200827      *           reactivated.                                        *
000185200827      *  CPK016 - Release 5 packaging.  Standardise parameters.       *
000186200827      *  CAS006 - Hedge Accounting Phase B                            *
000187200827      *  CAS005 - Enhancements for CAS001, CAS002 and CAS004          *
000188200827      *  CAS004 - Hedge Accounting Phase A                            *
000189200827      *                                                               *
000190200827      *****************************************************************
000191200827
