/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas SD ICD enquiry control program')                */
/*********************************************************************/
/*                                                                   */
/*       Midas - Standing Data Module                                */
/*                                                                   */
/*       SDC9001 - ICD display control program.                      */
/*                                                                   */
/*       (c) Finastra International Limited 2001                     */
/*                                                                   */
/*       Last Amend No. MD046248           Date 27Oct17              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/*       Prev Amend No. CDL013             Date 10Jul06              */
/*                      CLE025             Date 20Oct03              */
/*                      CRE008             Date 19Feb02              */
/* Midas Release 4.01 -----------------------------------------------*/
/*                      CAS002             Date 14Jan02              */
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.02 ---------------------------------------------------*/
/*                      CPB001             Date 03Jun99              */
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*                      CAP006             Date 12FEB97              */
/*                      CTI001             Date 13AUG97              */
/*                      CGL004             DATE 04NOV97              */
/*                      CRT003             Date 22JUL96              */
/*                      CAC001             Date 07MAR96              */
/*                      S01408             DATE 05FEB96              */
/*                      S01408             DATE 08SEP95              */
/*                      CRT001             DATE 06MAR95              */
/*                      S01505             DATE 20JUL94              */
/*                      S01486             DATE 19JUL94              */
/*                      S01493             DATE 23MAY94              */
/*                      S01413             DATE 31AUG93              */
/*                      S01421             DATE  6AUG93              */
/*                      S01393             DATE  9NOV92              */
/*                      S01379             DATE 16SEP92              */
/*                      S01382             DATE 22JUL92              */
/*                      S01339             DATE 27MAY92              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       MD046248 - Finastra Rebranding                              */
/*       CDL013 - Tiered Withholding Tax                             */
/*       CLE025 - Credit Lines                                       */
/*       CRE008 - Cash Management                                    */
/*       CAS002 - Hedge Strategy/Linkage                             */
/*       CPB001 - Private Banking Module                             */
/*       CAP006 - Application Program Interface                      */
/*       CTI001 - Midas/Trade Innovation Interface Phase 1           */
/*       CGL004 - Midas-Fontis Interface:                            */
/*                Call SD9421E - Electronic Banking.                 */
/*       CRT003 - Cashier Interface.                                 */
/*       CAC001 - Profit Centre Accounting :                         */
/*                Call SD9401E - Profit Centre Accounting.           */
/*                Remove Call SD9411E - Management Accounting.       */
/*       S01408 - Addition of core hook SDC9001INT                   */
/*              - Addition of core hook SDC9001MPS                   */
/*              - Addition of core hook SDC9001002                   */
/*              - Addition of core hook SDC9001003                   */
/*       S01408 - Addition of core hook SDC9001001                   */
/*       CRT001 - Retail Teller System Development:                  */
/*                Call SD9591E - Default Charges Transaction Type    */
/*       S01505 - Profit Centre Accounting Development:              */
/*                Call SD9401E - Analytical Accounting.              */
/*                Call SD9411E - Management Accounting.              */
/*       S01486 - Private Banking:                                   */
/*                Call SD9381E - Portfolio Management.               */
/*                Call SD9391E - Portfolio Lending.                  */
/*       S01493 - Add the call to SD9361E (Midas-Eureka interface)   */
/*       S01413 - Retail 3 Incorporation.                            */
/*       S01421 - Add the call to SD9351E (Customer Service Fees ICD)*/
/*       S01393 - Add the call to SD9321E (SRM module).              */
/*       S01379 - Add the call to SD9311E (History & Audit Facility).*/
/*              - Add ABNOR processing.                              */
/*       S01382 - Add the call to SD9271E (Optical Disk Enquiry).    */
/*       S01339 - Created to allow the ICD display functions to      */
/*                be selected directly from an MITEM menu option.    */
/*                                                                   */
/*********************************************************************/
             PGM        PARM(&MODULE)
 
             DCL        VAR(&MODULE) TYPE(*CHAR) LEN(2)
             DCL        VAR(&RTNCODE) TYPE(*CHAR) LEN(7)
             DCL        VAR(&WRTNCODE) TYPE(*CHAR) LEN(5)
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2001')
             DCL        VAR(&CDL013) TYPE(*CHAR) LEN(7)                                   /*CDL013*/
             DCL        VAR(&SFMT) TYPE(*CHAR) LEN(200)                                   /*CDL013*/
/*  SD0017 variables.                                                */                   /*CDL013*/
             DCL        VAR(&RTNCD) TYPE(*CHAR) LEN(5)                                    /*CDL013*/
                                                                      /*S01408*/
/*/COPY WNCPYSRC,SDC9001INT                                          */
                                                                      /*S01408*/
             MONMSG     MSGID(CPF0000 MCH0000 RPG0000) +
                          EXEC(GOTO CMDLBL(ABNOR))                    /*S01379*/
                                                                      /*S01408*/
             CALL       PGM(AOSARDR0) PARM(&CDL013 '*VERIFY' 'CDL013' +
                          &SFMT)                                                          /*CDL013*/
/*/COPY WNCPYSRC,SDC9001MPS                                          */
                                                                      /*S01408*/
/* If module code is SD (Standing Data) */
 
             IF         COND(&MODULE *EQ 'SD') THEN(DO)
                CALL       PGM(SD9101E) PARM(&RTNCODE 'BANK' &WRTNCODE)
             ENDDO
 
/* If module code is GL (General Ledger) */
 
             IF         COND(&MODULE *EQ 'GL') THEN(DO)
/*/COPY WNCPYSRC,SDC9001004                                          */
                CALL       PGM(SD9171E) PARM(&RTNCODE 'GELR' &WRTNCODE)
/*/COPY WNCPYSRC,SDC9001005                                          */
             ENDDO
 
/* If module code is TR (Trading Data) */
 
             IF         COND(&MODULE *EQ 'TR') THEN(DO)
                CALL       PGM(SD9231E) PARM(&RTNCODE 'TRAD' &WRTNCODE)
             ENDDO
 
/* If module code is FC (Report Control Facility) */
 
             IF         COND(&MODULE *EQ 'FC') THEN(DO)
                CALL       PGM(SD9241E) PARM(&RTNCODE 'RCF' &WRTNCODE)
             ENDDO
 
/* If module code is CB (Close of Business) */
 
             IF         COND(&MODULE *EQ 'CB') THEN(DO)
                CALL       PGM(SD9261E) PARM(&RTNCODE 'COBP' &WRTNCODE)
             ENDDO
 
/* If module code is DL (Dealing) */
 
             IF         COND(&MODULE *EQ 'DL') THEN(DO)
                CALL       PGM(SD9121E) PARM(&RTNCODE 'DEAL' &WRTNCODE)
             ENDDO
 
/* If module code is TM (Treasury Management) */
 
             IF         COND(&MODULE *EQ 'TM') THEN(DO)
                CALL       PGM(SD9291E) PARM(&RTNCODE 'TRMA' &WRTNCODE)
             ENDDO
 
/* If module code is RK (Risk Management) */                          /*S01393*/
                                                                      /*S01393*/
             IF         COND(&MODULE *EQ 'RK') THEN(DO)               /*S01393*/
                CALL       PGM(SD9321E) PARM(&RTNCODE 'RISK' +
                              &WRTNCODE)                              /*S01393*/
             ENDDO                                                    /*S01393*/
                                                                      /*S01393*/
/* If module code is IR (FRA/IRS) */
 
             IF         COND(&MODULE *EQ 'IR') THEN(DO)
                CALL       PGM(SD9161E) PARM(&RTNCODE 'FAIS' &WRTNCODE)
             ENDDO
 
/* If module code is SE (Securities Trading) */
 
             IF         COND(&MODULE *EQ 'SE') THEN(DO)
                CALL       PGM(SD9211E) PARM(&RTNCODE 'STRD' &WRTNCODE)
             ENDDO
 
/* If module code is FF (Futures and Options) */
 
             IF         COND(&MODULE *EQ 'FF') THEN(DO)
                CALL       PGM(SD9151E) PARM(&RTNCODE 'FODA' &WRTNCODE)
             ENDDO
 
/* If module code is LE (Customer Lending) */
 
             IF         COND(&MODULE *EQ 'LE') THEN(DO)
                CALL       PGM(SD9111E) PARM(&RTNCODE 'CLND' &WRTNCODE)
             ENDDO
 
/* If module code is RE (Retail) */
 
             IF         COND(&MODULE *EQ 'RE') THEN(DO)
                CALL       PGM(SD9201E) PARM(&RTNCODE 'RETL' &WRTNCODE)
             ENDDO
 
/* If module code is WT (Withholding Tax) */                          /*S01413*/
 
             IF         COND(&MODULE *EQ 'WT') THEN(DO)
                                                                      /*S01408*/
/*/COPY WNCPYSRC,SDC9001002                                          */
/*                                                                   */                   /*CDL013*/
/*  CDL013 - Call SD0017 if CDL013 is switched on, else call         */                   /*CDL013*/
/*           SD9331E.                                                */                   /*CDL013*/
/*                                                                   */                   /*CDL013*/
             IF         COND(&CDL013 *EQ ' ') THEN(DO)                                    /*CDL013*/
             CALL       PGM(SD0017) PARM('RETAIL    ' 'E' &RTNCD)                         /*CDL013*/
                   ENDDO                                                                  /*CDL013*/
                   ELSE       CMD(DO)                                                     /*CDL013*/
                                                                      /*S01408*/
                CALL       PGM(SD9331E) PARM(&RTNCODE 'RETAIL' &WRTNCODE)
                                                                      /*S01408*/
/*/COPY WNCPYSRC,SDC9001003                                          */
                                                                                          /*CDL013*/
             ENDDO                                                                        /*CDL013*/
                                                                      /*S01408*/
             ENDDO
                                                                      /*S01413*/
/* If module code is ME (Message Management) */
 
             IF         COND(&MODULE *EQ 'ME') THEN(DO)
                CALL       PGM(SD9281E) PARM(&RTNCODE 'MGME' &WRTNCODE)
             ENDDO
 
/* If module code is CF (Confirmation Matching) */
 
             IF         COND(&MODULE *EQ 'CF') THEN(DO)
                CALL       PGM(SD9300E) PARM(&RTNCODE 'CONF' &WRTNCODE)
             ENDDO
 
/* If module code is FT (Funds Transfer) */
 
             IF         COND(&MODULE *EQ 'FT') THEN(DO)
                CALL       PGM(SD9141E) PARM(&RTNCODE 'FTFR' &WRTNCODE)
             ENDDO
 
/* If module code is EM (Exposure Management) */
 
             IF         COND(&MODULE *EQ 'EM') THEN(DO)
                CALL       PGM(SD9131E) PARM(&RTNCODE 'EXPM' &WRTNCODE)
             ENDDO
 
/* If module code is MF (Microfiche Archiving) */
 
             IF         COND(&MODULE *EQ 'MF') THEN(DO)
                CALL       PGM(SD9251E) PARM(&RTNCODE 'MCFC' &WRTNCODE)
             ENDDO
                                                                      /*S01408*/
/*/COPY WNCPYSRC,SDC9001001                                          */
 
/* If module code is OD (Optical Disk) */
 
             IF         COND(&MODULE *EQ 'OD') THEN(DO)
                CALL       PGM(SD9271E) PARM(&RTNCODE 'OPTC' &WRTNCODE)
             ENDDO
                                                                      /*S01379*/
/* If module code is HF (History and Audit Facility) */               /*S01379*/
                                                                      /*S01379*/
             IF         COND(&MODULE *EQ 'HF') THEN(DO)               /*S01379*/
               CALL      PGM(SD9311E) PARM(&RTNCODE 'HAFD' &WRTNCODE) /*S01379*/
             ENDDO                                                    /*S01379*/
/**/                                                                  /*S01421*/
/* Customer Service Fees ICD enquiry to be accessed */                /*S01421*/
/* from Input Cycle menu */                                           /*S01421*/
/**/                                                                  /*S01421*/
             IF         COND(&MODULE *EQ 'CS') THEN(DO)               /*S01421*/
               CALL      PGM(SD9351E) PARM(&RTNCODE 'CSFD' &WRTNCODE) /*S01421*/
             ENDDO                                                    /*S01421*/
/**/                                                                  /*S01421*/
/**/                                                                  /*S01421*/
/* Midas-Eureka Interface ICD Enquiry to be accessed  */              /*S01493*/
/* from Input Cycle menu */                                           /*S01493*/
/**/                                                                  /*S01493*/
             IF         COND(&MODULE *EQ 'ED') THEN(DO)               /*S01493*/
               CALL      PGM(SD9361E) PARM(&RTNCODE 'MEXP' &WRTNCODE) /*S01493*/
             ENDDO                                                    /*S01493*/
/**/                                                                  /*S01493*/
/**/                                                                  /*S01486*/
/**/                                                                  /*S01486*/
/* Portfolio management ICD Enquiry to be accessed  */                /*S01486*/
/* from Input Cycle menu */                                           /*S01486*/
/**/                                                                  /*S01486*/
             IF         COND(&MODULE *EQ 'PM') THEN(DO)               /*S01486*/
               CALL      PGM(SD9381E) PARM(&RTNCODE 'PORT' &WRTNCODE) /*S01486*/
             ENDDO                                                    /*S01486*/
/**/                                                                  /*S01486*/
/**/                                                                  /*S01486*/
/* Portfolio Lending ICD Enquiry to be accessed  */                   /*S01486*/
/* from Input Cycle menu */                                           /*S01486*/
/**/                                                                  /*S01486*/
             IF         COND(&MODULE *EQ 'LB') THEN(DO)               /*S01486*/
               CALL      PGM(SD9391E) PARM(&RTNCODE 'LOMB' &WRTNCODE) /*S01486*/
             ENDDO                                                    /*S01486*/
/**/                                                                  /*S01505*/
/**/                                                                  /*S01505*/
/**Analytical*Accounting*ICD*Enquiry*to*be*accessed**********/ /*S01505 CAC001*/
/**/                                                                  /*CAC001*/
/* Profit Centre Accounting ICD Enquiry to be accessed */             /*CAC001*/
/* from Input Cycle menu */                                           /*S01505*/
/**/                                                                  /*S01505*/
             IF         COND(&MODULE *EQ 'AA') THEN(DO)               /*S01505*/
/****CALL******PGM(SD9401E) PARM(&RTNCODE 'ANAC' &WRTNCODE)*/  /*S01505 CAC001*/
               CALL      PGM(SD9401E) PARM(&RTNCODE 'PCAC' &WRTNCODE) /*CAC001*/
             ENDDO                                                    /*S01505*/
/**/                                                                  /*S01505*/
/**/                                                                  /*S01505*/
/**Management*Accounting*ICD*Enquiry*to*be*accessed**/         /*S01505 CAC001*/
/**from*Input*Cycle*menu**/                                    /*S01505 CAC001*/
/**/                                                           /*S01505 CAC001*/
/*********** IF         COND(&MODULE *EQ 'MC') THEN(DO)        /*S01505 CAC001*/
/****CALL***   PGM(SD9411E) PARM(&RTNCODE 'MGAC' &WRTNCODE)    /*S01505 CAC001*/
/*********** ENDDO                                             /*S01505 CAC001*/
/**/                                                                  /*S01505*/
/* RTS Default Charges Transaction Type 'R1'  */                      /*CRT001*/
                                                                      /*CRT001*/
             IF         COND(&MODULE *EQ 'R1') THEN(DO)               /*CRT001*/
                CALL     PGM(SD9591E) PARM(&RTNCODE 'TCHG' &WRTNCODE) /*CRT001*/
             ENDDO                                                    /*CRT001*/
                                                                      /*CRT001*/
/* Cashier System Interface 'CI'              */                      /*CRT003*/
                                                                      /*CRT003*/
             IF         COND(&MODULE *EQ 'CI') THEN(DO)               /*CRT003*/
                CALL     PGM(SD9411E) PARM(&RTNCODE 'BAII' &WRTNCODE) /*CRT003*/
             ENDDO                                                    /*CRT003*/
                                                                      /*CRT003*/
/* Midas-Fontis Interface ICD enquiry to be accessed*/                /*CGL004*/
/* from Input cycle menu  */                                          /*CGL004*/
                                                                      /*CGl004*/
             IF         COND(&MODULE *EQ 'EB') THEN(DO)               /*CGL004*/
                CALL     PGM(SD9421E) PARM(&RTNCODE 'FONT' &WRTNCODE) /*CGL004*/
             ENDDO                                                    /*CGL004*/
                                                                      /*CTI001*/
/* Midas/Trade Innovation Interface 'TI'      */                      /*CTI001*/
                                                                      /*CTI001*/
             IF         COND(&MODULE *EQ 'TI') THEN(DO)               /*CTI001*/
                CALL     PGM(SD9441E) PARM(&RTNCODE 'TIIN' &WRTNCODE) /*CTI001*/
             ENDDO                                                    /*CTI001*/
 
/* APIs 'AP'                                  */                      /*CAP006*/
                                                                      /*CAP006*/
             IF         COND(&MODULE *EQ 'AP') THEN(DO)               /*CAP006*/
                CALL     PGM(SD9451E) PARM(&RTNCODE 'API' &WRTNCODE)  /*CAP006*/
             ENDDO                                                    /*CAP006*/
                                                                      /*CPB001*/
/* Private Banking ICD Enquiry to be accessed  */                     /*CPB001*/
/* from Input Cycle menu */                                           /*CPB001*/
                                                                      /*CPB001*/
             IF         COND(&MODULE *EQ 'PB') THEN(DO)               /*CPB001*/
                CALL     PGM(SD9461E) PARM(&RTNCODE 'TOF ' &WRTNCODE) /*CPB001*/
             ENDDO                                                    /*CPB001*/
/**/                                                                  /*S01505*/
/**/                                                                  /*S01505*/
                                                                                          /*CRE008*/
/** Cash Management ICD Enquiry  */                                                       /*CRE008*/
                                                                                          /*CRE008*/
             IF         COND(&MODULE *EQ 'CM') THEN(DO)                                   /*CRE008*/
                CALL       PGM(SD9452) PARM(&RTNCODE 'SDCMANPD' 'E')                      /*CRE008*/
             ENDDO                                                                        /*CRE008*/
                                                                                          /*CAS002*/
/** Hedging ICD Enquiry  */                                                               /*CAS002*/
                                                                                          /*CAS002*/
             IF         COND(&MODULE *EQ 'AS') THEN(DO)                                   /*CAS002*/
                CALL       PGM(SD000744) PARM(&RTNCODE 'HEDG' 'E')                        /*CAS002*/
             ENDDO                                                                        /*CAS002*/
                                                                                          /*CLE025*/
/** Collateral and Credit Control Enquiry */                                              /*CLE025*/
                                                                                          /*CLE025*/
             IF         COND(&MODULE *EQ 'CO') THEN(DO)                                   /*CLE025*/
                CALL       PGM(SD009113) PARM(&RTNCODE 'COCC' 'E')                        /*CLE025*/
             ENDDO                                                                        /*CLE025*/
                                                                      /*S01379*/
             GOTO CMDLBL(END)                                         /*S01379*/
                                                                      /*S01379*/
/* Abnormal Processing */                                             /*S01379*/
                                                                      /*S01379*/
 ABNOR:      SNDPGMMSG  TOMSGQ(MOPERQ) MSG('Program SDC9001 +
                          ended abnormally')                          /*S01379*/
END:         CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
             ENDPGM
